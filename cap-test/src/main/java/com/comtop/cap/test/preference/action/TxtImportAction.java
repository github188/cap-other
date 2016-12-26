/******************************************************************************
 * Copyright (C) 2016 ShenZhen ComTop Information Technology Co.,Ltd
 * All Rights Reserved.
 * 本软件为深圳康拓普开发研制。未经本公司正式书面同意，其他任何个人、团体不得使用、
 * 复制、修改或发布本软件.
 *****************************************************************************/

package com.comtop.cap.test.preference.action;

import java.io.BufferedReader;
import java.io.IOException;
import java.io.InputStream;
import java.io.InputStreamReader;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.HashSet;
import java.util.List;
import java.util.Map;
import java.util.Set;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;

import com.comtop.cap.bm.metadata.common.storage.exception.ValidateException;
import com.comtop.cap.test.definition.facade.StepCache;
import com.comtop.cap.test.definition.model.Argument;
import com.comtop.cap.test.definition.model.BasicStep;
import com.comtop.cap.test.definition.model.CtrlDefinition;
import com.comtop.cap.test.definition.model.ValueType;
import com.comtop.cip.jodd.madvoc.meta.MadvocAction;
import com.comtop.cip.jodd.util.StringUtil;
import com.comtop.top.core.util.StringConvertUtils;
import comtop.org.directwebremoting.annotations.DwrProxy;
import comtop.org.directwebremoting.annotations.RemoteMethod;
import comtop.org.directwebremoting.io.FileTransfer;

/**
 * 基本步骤导入———Txt
 * 1、按行读取
 * 2、正则表达式按照空格分隔String[] abc = strr.split("[\\p{Space}]+");
 * 3、第一个字符串为*
 * 4、第一列为Library
 * 5、第一列为Resource
 * 6、上一行为空格 紧接着的为中文，则为步骤名称
 * 7、步骤名称后面带#为步骤英文名称（步骤定义）
 * 8、第一列为[Arguments] 后面的为参数集合，参数中=号后面为默认值
 * 9、第一列为[Documentation]
 *
 * @author 李小芬
 * @since jdk1.6
 * @version 2016年6月27日 李小芬
 */
@DwrProxy
@MadvocAction
public class TxtImportAction {
    
    /** 日志对象 */
    private static final Logger LOGGER = LoggerFactory.getLogger(TxtImportAction.class);
    
    /**
     * 导入文档
     * 
     * @param fileTransfer 上传后的文件对象
     * @param fileName 文件名
     * @param stepGroupCode 步骤分组编码
     * @return 导入结果
     */
    @RemoteMethod
    public Map<String, Object> importTxt(FileTransfer fileTransfer, String fileName, String stepGroupCode) {
        final Map<String, Object> ret = new HashMap<String, Object>(2);
        InputStream objInputStream = null;
        InputStreamReader objIsr = null;
        BufferedReader objReader = null;
        String strTempString = null;
        List<Argument> lstArgument = null;
        Set<String> lstLibrary = new HashSet<String>(5);
        Set<String> lstResource = new HashSet<String>(5);
        BasicStep objBasicStep = null;
        String strLastLineText = null;
        String strReturnValue = "";
        try {
            objInputStream = fileTransfer.getInputStream();
            objIsr = new InputStreamReader(objInputStream, "UTF-8");
            objReader = new BufferedReader(objIsr);
            while ((strTempString = objReader.readLine()) != null) {
                String lineText = strTempString.trim();
                // 文档开始或者有空行，是一个新的步骤
                if (StringUtil.isBlank(lineText)) {
                    saveXmlModel(fileName, lstArgument, lstLibrary, lstResource, objBasicStep, stepGroupCode,
                        strReturnValue);
                    objBasicStep = new BasicStep();
                    strReturnValue = "";
                    lstArgument = new ArrayList<Argument>();
                    strLastLineText = lineText;
                    continue;
                }
                // 处理Library
                if (lineText.startsWith("Library")) {
                    dealWithLibrary(lineText, lstLibrary);
                    strLastLineText = lineText;
                    continue;
                }
                // 处理Resource
                if (lineText.startsWith("Resource")) {
                    dealWithResource(lineText, lstResource);
                    strLastLineText = lineText;
                    continue;
                }
                // 处理步骤名称、描述、帮助
                if (isStepName(strLastLineText, lineText)) {
                    dealWithStepName(lineText, objBasicStep);
                    strLastLineText = lineText;
                    continue;
                }
                // 处理步骤定义（步骤英文名称）
                if (isStepEngName(strLastLineText)) {
                    dealWithStepEngName(lineText, objBasicStep);
                    strLastLineText = lineText;
                    continue;
                }
                // 处理参数
                if (lineText.startsWith("[Arguments]")) {
                    dealWithArguments(lineText, lstArgument);
                    strLastLineText = lineText;
                    continue;
                }
                // 处理参数说明
                if (isStepArgument(strLastLineText, lineText)) { // 参数说明
                    dealWithParameterDesc(lineText, lstArgument);
                    strLastLineText = lineText;
                    continue;
                }
                if (lineText.startsWith("[Return]")) { // 返回值
                    strReturnValue = dealWithReturnValue(lineText, lstArgument);
                }
                // 设置上一行内容，供下一行使用
                strLastLineText = lineText;
            }
            // 文档读取完成，设置最后一个步骤信息到List
            saveXmlModel(fileName, lstArgument, lstLibrary, lstResource, objBasicStep, stepGroupCode, strReturnValue);
            objReader.close();
        } catch (IOException e) {
            ret.put("code", "Success");
            LOGGER.error("导入文档时发生异常", e);
            e.printStackTrace();
        } catch (ValidateException e) {
            e.printStackTrace();
        } finally {
            if (objInputStream != null) {
                try {
                    objInputStream.close();
                    ret.put("code", "Success");
                } catch (IOException e) {
                    ret.put("code", "Success");
                    LOGGER.error("关闭文件流失败", e);
                    e.printStackTrace();
                }
            }
        }
        return ret;
    }
    
    /**
     * 生成XML文件
     *
     * @param fileName 文件名称
     * @param lstArgument 参数
     * @param lstLibrary 库
     * @param lstResource 资源
     * @param objBasicStep VO
     * @param stepGroupCode 步骤分组
     * @param returnValue 返回值
     * @throws ValidateException 异常处理
     */
    private void saveXmlModel(String fileName, List<Argument> lstArgument, Set<String> lstLibrary,
        Set<String> lstResource, BasicStep objBasicStep, String stepGroupCode, String returnValue)
        throws ValidateException {
        // 直接生成xml文件
        if (objBasicStep != null && StringUtil.isNotBlank(objBasicStep.getName().trim())) {
            objBasicStep.setLibraries(lstLibrary);
            objBasicStep.setResources(lstResource);
            objBasicStep.setArguments(lstArgument);
            objBasicStep.setIcon("icon-cog-wheel-silhouette");
            objBasicStep.setSrc(fileName);
            objBasicStep.setGroup(stepGroupCode);
            if (StringUtil.isBlank(objBasicStep.getDefinition())) {
                objBasicStep.setDefinition(StringConvertUtils.getFirstSpell(objBasicStep.getName()));
            }
            setBasicStepMacro(lstArgument, objBasicStep, returnValue);
            objBasicStep.setCreateTime(System.currentTimeMillis());
            objBasicStep.saveModel();
            StepCache.getInstance().updateStepDefinition(objBasicStep);
        }
    }
    
    /**
     * 设置步骤的宏
     *
     * @param lstArgument 参数列表
     * @param objBasicStep 步骤VO
     * @param returnValue 返回值
     */
    private void setBasicStepMacro(List<Argument> lstArgument, BasicStep objBasicStep, String returnValue) {
        StringBuffer sbMacro = new StringBuffer(30);
        if (StringUtil.isNotBlank(returnValue)) {
            sbMacro.append("${").append(returnValue).append("}").append("    ");
        }
        sbMacro.append(objBasicStep.getName()).append("    ");
        for (Argument arg : lstArgument) {
            if (!arg.getName().equals(returnValue)) {
                sbMacro.append("${").append(arg.getName()).append("}").append("    ");
            }
        }
        sbMacro.append("#").append("${desc}");
        objBasicStep.setMacro(sbMacro.toString());
    }
    
    /**
     * 是否为参数说明的行
     * 上一行为...本行为...
     *
     * @param strLastLineText 上一行内容
     * @param lineText 本行内容
     * @return true 是 false 不是
     */
    private static boolean isStepArgument(String strLastLineText, String lineText) {
        return strLastLineText != null && strLastLineText.startsWith("...") && lineText.startsWith("...");
    }
    
    /**
     * 判断是否为步骤定义的行
     * 上一行为[Documentation]
     *
     * @param strLastLineText 上一行内容
     * @return true 是 false 不是
     */
    private static boolean isStepEngName(String strLastLineText) {
        return strLastLineText != null && strLastLineText.startsWith("[Documentation]");
    }
    
    /**
     * 判断是否是步骤名称的行
     * 上一行为空或*
     * 本行不为空或*
     *
     * @param strLastLineText 上一行内容
     * @param lineText 本行内容
     * @return true 是 false 不是
     */
    private static boolean isStepName(String strLastLineText, String lineText) {
        return strLastLineText != null && (strLastLineText.startsWith("*") || StringUtil.isBlank(strLastLineText))
            && !lineText.startsWith("*") && StringUtil.isNotBlank(lineText);
    }
    
    /**
     * 处理参数说明
     *
     * @param lineText 行信息
     * @param lstArgument 参数集合
     */
    private static void dealWithParameterDesc(String lineText, List<Argument> lstArgument) {
        String[] lineWord = lineText.split("[\\p{Space}]{2,}");
        String argDesc = lineWord[1];
        argDesc = argDesc.replace("：", ":");
        String[] argsDesc = argDesc.split(":");
        for (Argument argument : lstArgument) {
            if (argument.getName().equals(argsDesc[0].substring(2, argsDesc[0].length() - 1))) {
                argument.setDescription(argsDesc[1]);
                argument.setHelp(argsDesc[1]);
            }
        }
    }
    
    /**
     * 处理返回值类型
     * 
     * @param lineText 当前行
     * @param lstArgument 参数列表
     * @return 返回值
     */
    private String dealWithReturnValue(String lineText, List<Argument> lstArgument) {
        String[] lineWord = lineText.split("[\\p{Space}]{2,}");
        String strReturnValue = lineWord[1].substring(2, lineWord[1].length() - 1);
        for (Argument argument : lstArgument) {
            if (strReturnValue.equals(argument.getName())) {
                return strReturnValue;
            }
        }
        return "";
    }
    
    /**
     * 处理步骤参数
     *
     * @param lineText 行信息
     * @param lstArgument 参数集合
     */
    private static void dealWithArguments(String lineText, List<Argument> lstArgument) {
        String[] lineWord = lineText.split("[\\p{Space}]{2,}");
        Argument objArgument = null;
        for (int i = 1; i < lineWord.length; i++) {
            objArgument = new Argument();
            String[] argValue = lineWord[i].split("=");
            objArgument.setName(argValue[0].substring(2, argValue[0].length() - 1));
            if (argValue.length > 1 && !"\"\"".equals(argValue[1])) {
                objArgument.setDefaultValue(argValue[1]);
                objArgument.setRequired(false);
            } else {
                objArgument.setRequired(true);
            }
            objArgument.setRequired(true);
            objArgument.setValueType(ValueType.STRING);
            setArgCtrl(objArgument);
            lstArgument.add(objArgument);
        }
        
    }
    
    /**
     * 构造参数的控件信息
     *
     * @param objArgument 参数信息
     */
    private static void setArgCtrl(Argument objArgument) {
        StringBuffer sbCtrlOptions = new StringBuffer(50);
        sbCtrlOptions.append("\n            {");
        sbCtrlOptions.append("\n                'id': '").append(objArgument.getName()).append("',");
        sbCtrlOptions.append("\n                'name': '").append(objArgument.getName()).append("'");
        sbCtrlOptions.append("\n            }            \n");
        CtrlDefinition objCtrl = new CtrlDefinition();
        objCtrl.setType("Input");
        objCtrl.setOptions(sbCtrlOptions.toString());
        objArgument.setCtrl(objCtrl);
    }
    
    /**
     * 处理步骤名称
     *
     * @param lineText 行信息
     * @param objBasicStep 步骤VO
     */
    private static void dealWithStepName(String lineText, BasicStep objBasicStep) {
        String[] lineWord = lineText.split("[\\p{Space}]{2,}");
        objBasicStep.setName(lineWord[0]);
        objBasicStep.setDescription(lineText);
        objBasicStep.setHelp(lineText);
    }
    
    /**
     * 处理步骤英文名称
     *
     * @param lineText 行信息
     * @param objBasicStep 步骤VO
     */
    private static void dealWithStepEngName(String lineText, BasicStep objBasicStep) {
        String[] lineWord = lineText.split("[\\p{Space}]{2,}");
        String strDefinition = lineWord[1].replaceAll(" ", "_");
        strDefinition = strDefinition.replaceAll("\\.", "_");
        objBasicStep.setDefinition(strDefinition.toLowerCase());
    }
    
    /**
     * 处理步骤的Resource信息
     *
     * @param lineText 行信息
     * @param lstResource Resource存储器
     */
    private static void dealWithResource(String lineText, Set<String> lstResource) {
        String[] lineWord = lineText.split("[\\p{Space}]{2,}");
        if (StringUtil.isNotBlank(lineWord[1])) {
            lstResource.add(lineWord[1]);
        }
    }
    
    /**
     * 处理步骤的Library信息
     *
     * @param lineText 行信息
     * @param lstLibrary Library存储器
     */
    private static void dealWithLibrary(String lineText, Set<String> lstLibrary) {
        String[] lineWord = lineText.split("[\\p{Space}]{2,}");
        if (StringUtil.isNotBlank(lineWord[1])) {
            lstLibrary.add(lineWord[1]);
        }
    }
    
}
