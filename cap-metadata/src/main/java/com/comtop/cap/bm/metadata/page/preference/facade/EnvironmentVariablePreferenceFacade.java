/******************************************************************************
 * Copyright (C) 2015 ShenZhen ComTop Information Technology Co.,Ltd
 * All Rights Reserved.
 * 本软件为深圳康拓普开发研制。未经本公司正式书面同意，其他任何个人、团体不得使用、
 * 复制、修改或发布本软件.
 *****************************************************************************/

package com.comtop.cap.bm.metadata.page.preference.facade;

import java.util.ArrayList;
import java.util.Iterator;
import java.util.List;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;

import com.comtop.cap.bm.metadata.base.facade.CapBmBaseFacade;
import com.comtop.cap.bm.metadata.common.storage.CacheOperator;
import com.comtop.cap.bm.metadata.common.storage.exception.OperateException;
import com.comtop.cap.bm.metadata.common.storage.exception.ValidateException;
import com.comtop.cap.bm.metadata.page.desinger.facade.PageFacade;
import com.comtop.cap.bm.metadata.page.preference.model.EnvironmentVariablePreferenceVO;
import com.comtop.cap.bm.metadata.page.preference.model.EnvironmentVariableVO;
import com.comtop.cip.common.validator.ValidateResult;
import com.comtop.cip.common.validator.ValidatorUtil;
import com.comtop.cip.jodd.petite.meta.PetiteBean;
import com.comtop.top.core.util.StringUtil;
import com.comtop.top.core.util.constant.NumberConstant;
import comtop.org.directwebremoting.annotations.DwrProxy;
import comtop.org.directwebremoting.annotations.RemoteMethod;

/**
 * 引入文件首选项facade类
 *
 * @author 诸焕辉
 * @version jdk1.6
 * @version 2015-5-28 诸焕辉
 */
@DwrProxy
@PetiteBean
public class EnvironmentVariablePreferenceFacade extends CapBmBaseFacade {
    
    /** 日志 */
    private final static Logger LOG = LoggerFactory.getLogger(PageFacade.class);
    
    /**
     * 根据"关联全局引入文件名称"获取环境变量
     *
     * @param filePaths 关联全局引入文件名称数组
     * @return 操作结果
     * @throws OperateException json操作异常
     */
    @SuppressWarnings("unchecked")
    @RemoteMethod
    public List<EnvironmentVariableVO> queryListByFileName(String[] filePaths) throws OperateException {
        List<EnvironmentVariableVO> objEnvironmentVariableVO = null;
        if (filePaths != null && filePaths.length > NumberConstant.ZERO) {
            EnvironmentVariablePreferenceVO obj = this.queryDefaultEnvironmentVariable();
            StringBuffer sbExpression = new StringBuffer();
            sbExpression.append("environmentVariableList[");
            for (int i = 0, len = filePaths.length; i < len; i++) {
                sbExpression.append("fileName='").append(filePaths[i]).append("'");
                if (i < len - 1) {
                    sbExpression.append(" or ");
                }
            }
            sbExpression.append("]");
            objEnvironmentVariableVO = obj.queryList(sbExpression.toString());
        }
        return objEnvironmentVariableVO;
    }
    
    /**
     * 加载模型文件
     *
     * @param id 控件模型ID
     * @return 操作结果
     */
    @RemoteMethod
    public EnvironmentVariablePreferenceVO loadModel(String id) {
        return this.queryDefaultEnvironmentVariable();
    }
    
    /**
     * 验证VO对象
     *
     * @param model 被校验对象
     * @return 结果集
     */
    @SuppressWarnings("rawtypes")
    @RemoteMethod
    public ValidateResult validate(EnvironmentVariablePreferenceVO model) {
        return ValidatorUtil.validate(model);
    }
    
    /**
     * 保存
     *
     * @param model 被保存的对象
     * @return 是否成功
     * @throws ValidateException 异常
     */
    @RemoteMethod
    public boolean saveModel(EnvironmentVariablePreferenceVO model) throws ValidateException {
        return model.saveModel();
    }
    
    /**
     * 删除模型
     *
     * @param model 被删除的对象
     * @return 是否成功
     * @throws OperateException 异常
     */
    @RemoteMethod
    public boolean deleteModel(EnvironmentVariablePreferenceVO model) throws OperateException {
        return model.deleteModel();
    }
    
    /**
     * 获取默认全局参数
     * 默认参数存放文件路径metadata\preference\page\environmentVariable\environmentVariables.environmentVariable.json
     * 
     * @return 操作结果
     */
    @RemoteMethod
    public EnvironmentVariablePreferenceVO queryDefaultEnvironmentVariable() {
        String strModelId = EnvironmentVariablePreferenceVO.getCustomModelId();
        EnvironmentVariablePreferenceVO objEnvironmentVariablePreferenceVO = (EnvironmentVariablePreferenceVO) CacheOperator
            .readById(strModelId);
        if (objEnvironmentVariablePreferenceVO == null) {
            objEnvironmentVariablePreferenceVO = EnvironmentVariablePreferenceVO.createCustomVariablePreference();
            try {
                if (saveModel(objEnvironmentVariablePreferenceVO)) {
                    objEnvironmentVariablePreferenceVO = (EnvironmentVariablePreferenceVO) CacheOperator
                        .readById(strModelId);
                }
            } catch (ValidateException e) {
                LOG.error("生成用户自定义配置文件失败", e);
            }
        }
        return objEnvironmentVariablePreferenceVO;
    }
    
    /**
     * 获取当前系统配置的默认全局参数
     *
     * @return List<EnvironmentVariableVO> List集合对象，集合中存放EnvironmentVariableVO
     */
    @RemoteMethod
    public List<EnvironmentVariableVO> queryEnvironmentVariableist() {
        List<EnvironmentVariableVO> lstEnvironmentVariableVO = new ArrayList<EnvironmentVariableVO>();
        EnvironmentVariablePreferenceVO objEnvironmentVariablePreferenceVO = this.queryDefaultEnvironmentVariable();
        lstEnvironmentVariableVO = objEnvironmentVariablePreferenceVO.getEnvironmentVariableList();
        return lstEnvironmentVariableVO;
    }
    
    /**
     * 根据文件对象向集合中新增引入文件对象
     *
     * @param objEnvironmentVariableVO 待新增引入文件路径
     * @param oldAttributeName 原变量名称
     * @return 操作结果
     * @throws ValidateException 对象验证异常
     */
    @RemoteMethod
    public boolean addEnvironmentVariable(EnvironmentVariableVO objEnvironmentVariableVO, String oldAttributeName)
        throws ValidateException {
        EnvironmentVariablePreferenceVO objEnvironmentVariablePreferenceVO = this.queryDefaultEnvironmentVariable();
        List<EnvironmentVariableVO> lstEnvironmentVariableVO = objEnvironmentVariablePreferenceVO
            .getEnvironmentVariableList();
        List<EnvironmentVariableVO> lstUpdatedEnvironmentVariables = this.updateEnvironmentVariableList(
            lstEnvironmentVariableVO, objEnvironmentVariableVO, oldAttributeName);
        objEnvironmentVariablePreferenceVO.setEnvironmentVariableList(lstUpdatedEnvironmentVariables);
        boolean rs = false;
        if (validate(objEnvironmentVariablePreferenceVO).isOK()) {
            rs = objEnvironmentVariablePreferenceVO.saveModel();
        }
        return rs;
    }
    
    /**
     * 默认引入文件删除方法
     *
     * @param lstVariableName 待删除引入文件路径集合，集合中存放String类型
     * @return 操作结果
     * @throws ValidateException 对象验证异常
     */
    @RemoteMethod
    public boolean deleteEnvironmentVariable(List<String> lstVariableName) throws ValidateException {
        EnvironmentVariablePreferenceVO objEnvironmentVariablePreferenceVO = this.queryDefaultEnvironmentVariable();
        List<EnvironmentVariableVO> lstEnvironmentVariableVO = objEnvironmentVariablePreferenceVO
            .getEnvironmentVariableList();
        List<EnvironmentVariableVO> lstDeletedVariableName = new ArrayList<EnvironmentVariableVO>();
        lstDeletedVariableName.addAll(lstEnvironmentVariableVO);
        for (Iterator<String> iterator = lstVariableName.iterator(); iterator.hasNext();) {
            String strVariableName = iterator.next();
            for (Iterator<EnvironmentVariableVO> iterator2 = lstEnvironmentVariableVO.iterator(); iterator2.hasNext();) {
                EnvironmentVariableVO environmentVariableVO = iterator2.next();
                if (StringUtil.equals(strVariableName, environmentVariableVO.getAttributeName())) {
                    lstDeletedVariableName.remove(environmentVariableVO);
                }
            }
        }
        objEnvironmentVariablePreferenceVO.setEnvironmentVariableList(lstDeletedVariableName);
        boolean rs = false;
        if (validate(objEnvironmentVariablePreferenceVO).isOK()) {
            rs = objEnvironmentVariablePreferenceVO.saveModel();
        }
        return rs;
    }
    
    /**
     * 根据EnvironmentVariableVO来更新集合中EnvironmentVariableVO对象信息
     *
     * @param lstEnvironmentVariable 待更新的集合
     * @param objEnvironmentVariableVO 需要更新的EnvironmentVariableVO
     * @param oldAttributeName 原变量名称
     * @return 更新后的集合
     */
    
    private List<EnvironmentVariableVO> updateEnvironmentVariableList(
        List<EnvironmentVariableVO> lstEnvironmentVariable, EnvironmentVariableVO objEnvironmentVariableVO,
        String oldAttributeName) {
        List<EnvironmentVariableVO> lstUpdatedEnvironmentVariables = new ArrayList<EnvironmentVariableVO>();
        lstUpdatedEnvironmentVariables.addAll(lstEnvironmentVariable);
        for (Iterator<EnvironmentVariableVO> iterator = lstEnvironmentVariable.iterator(); iterator.hasNext();) {
            EnvironmentVariableVO environmentVariableVO = iterator.next();
            if (StringUtil.equals(oldAttributeName, environmentVariableVO.getAttributeName())) {
                lstUpdatedEnvironmentVariables.remove(environmentVariableVO);
            }
            if (StringUtil
                .equals(environmentVariableVO.getAttributeName(), objEnvironmentVariableVO.getAttributeName())) {
                lstUpdatedEnvironmentVariables.remove(environmentVariableVO);
            }
        }
        lstUpdatedEnvironmentVariables.add(objEnvironmentVariableVO);
        return lstUpdatedEnvironmentVariables;
    }
    
    /**
     * 根据参数名称获取参数对象
     *
     * @param strEnvironmentVariableName 参数名称
     * @return 参数对象 EnvironmentVariableVO
     */
    @RemoteMethod
    public EnvironmentVariableVO loadByEnvironmentVariableName(String strEnvironmentVariableName) {
        EnvironmentVariablePreferenceVO objEnvironmentVariablePreferenceVO = this.queryDefaultEnvironmentVariable();
        List<EnvironmentVariableVO> lstEnvironmentVariables = objEnvironmentVariablePreferenceVO
            .getEnvironmentVariableList();
        for (Iterator<EnvironmentVariableVO> iterator = lstEnvironmentVariables.iterator(); iterator.hasNext();) {
            EnvironmentVariableVO environmentVariableVO = iterator.next();
            if (StringUtil.equals(strEnvironmentVariableName, environmentVariableVO.getAttributeName())) {
                return environmentVariableVO;
            }
        }
        return null;
    }
    
    /**
     * 根据"关联全局引入文件名称"获取环境变量
     *
     * @param filePaths 关联全局引入文件名称数组
     * @param EnviromentVariableClass 全局环境变量类型
     * @return 操作结果
     * @throws OperateException json操作异常
     */
    @SuppressWarnings("unchecked")
    @RemoteMethod
    public List<EnvironmentVariableVO> queryListByFileName(String[] filePaths, String EnviromentVariableClass)
        throws OperateException {
        List<EnvironmentVariableVO> objEnvironmentVariableVO = null;
        if (filePaths != null && filePaths.length > NumberConstant.ZERO) {
            EnvironmentVariablePreferenceVO obj = this.queryDefaultEnvironmentVariable();
            StringBuffer sbExpression = new StringBuffer();
            sbExpression.append("environmentVariableList[");
            for (int i = 0, len = filePaths.length; i < len; i++) {
                sbExpression.append("fileName='").append(filePaths[i]).append("'");
                if (i < len - 1) {
                    sbExpression.append(" or ");
                }
            }
            sbExpression.append("]");
            List<EnvironmentVariableVO> lstEnvironmentVariable = obj.queryList(sbExpression.toString());
            List<EnvironmentVariableVO> lstTemp = new ArrayList<EnvironmentVariableVO>();
            for (Iterator<EnvironmentVariableVO> iterator = lstEnvironmentVariable.iterator(); iterator.hasNext();) {
                EnvironmentVariableVO objVariableVO = iterator.next();
                String strAttirbuteClass = objVariableVO.getAttributeClass();
                if (StringUtil.equals(strAttirbuteClass, EnviromentVariableClass)) {
                    lstTemp.add(objVariableVO);
                }
            }
            if (lstTemp.size() > 0) {
                objEnvironmentVariableVO = lstTemp;
            }
        }
        return objEnvironmentVariableVO;
    }
}
