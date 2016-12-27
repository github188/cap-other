/******************************************************************************
 * Copyright (C) 2014 ShenZhen ComTop Information Technology Co.,Ltd
 * All Rights Reserved.
 * 本软件为深圳康拓普开发研制。未经本公司正式书面同意，其他任何个人、团体不得使用、
 * 复制、修改或发布本软件.
 *****************************************************************************/

package com.comtop.cap.bm.metadata.page.template.facade;

import java.io.File;
import java.io.FileNotFoundException;
import java.io.FileOutputStream;
import java.io.IOException;
import java.io.OutputStream;
import java.io.OutputStreamWriter;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.Iterator;
import java.util.List;
import java.util.Map;
import java.util.Map.Entry;
import java.util.UUID;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;

import com.comtop.cap.bm.metadata.common.dwr.CapMap;
import com.comtop.cap.bm.metadata.common.storage.exception.OperateException;
import com.comtop.cap.bm.metadata.page.PageUtil;
import com.comtop.cap.bm.metadata.page.desinger.facade.PageFacade;
import com.comtop.cap.bm.metadata.page.desinger.model.PageVO;
import com.comtop.cap.bm.metadata.page.template.model.InputAreaComponentVO;
import com.comtop.cap.bm.metadata.page.template.model.MetadataGenerateVO;
import com.comtop.cap.bm.metadata.page.template.model.RowFromEntityAreaVO;
import com.comtop.cap.bm.metadata.page.template.model.WrapperFtlPageCommon;
import com.comtop.cip.common.validator.ValidateResult;
import com.comtop.cip.jodd.io.FileUtil;
import com.comtop.cip.json.JSONArray;
import com.comtop.cip.json.JSONObject;
import com.comtop.cip.json.util.IOUtils;
import com.comtop.top.component.common.systeminit.WebGlobalInfo;
import com.comtop.top.core.util.StringUtil;
import com.comtop.top.core.util.constant.NumberConstant;

import freemarker.template.Configuration;
import freemarker.template.Template;
import freemarker.template.TemplateException;

/**
 * @author luozhenming
 *
 */
public class PageGenerate4DefaultFtlTemp {
    /** 日志 */
    private final static Logger LOG = LoggerFactory.getLogger(PageGenerate4DefaultFtlTemp.class);
    
    /**
     * 
     * @param metadataGenerateVO 模板表单元数据
     * @return 生成成功的页面元数据modelid
     * @throws OperateException 操作异常
     * @throws IOException 流异常
     */
    public Map<String, Object> generatePageJson(MetadataGenerateVO metadataGenerateVO) throws OperateException, IOException {
        Map<String, Object> objResult = new HashMap<String, Object>();
        List<String> lstSuccessModelId = new ArrayList<String>();
        List<String> lstErrorTemplateName = new ArrayList<String>();
        objResult.put("success", lstSuccessModelId);
        objResult.put("error", lstErrorTemplateName);
        // 拷贝
        String strJson = JSONObject.toJSONString(metadataGenerateVO);
        MetadataGenerateVO objCopyMetaGenVO = JSONObject.parseObject(strJson, MetadataGenerateVO.class);
        boolean bResult = false;
        List<CapMap> lstPageTempInfo = objCopyMetaGenVO.getMetadataPageConfigVO().getPageTempList();
        boolean isWrapperConstantURL = isWrapperConstantURL(lstPageTempInfo);
        InputAreaComponentVO objInputAreaComponentVO = (InputAreaComponentVO) objCopyMetaGenVO
            .query("metadataValue/inputComponentList[id='modelName']");
        String strModelName = objInputAreaComponentVO.getValue();
        aliaConverterEntityEname(objCopyMetaGenVO);
        // 模块包路劲
        String strModelPackage = objCopyMetaGenVO.getModelPackage();
        // 当前模块名称
        String strCurrModel = strModelPackage.replace("com.comtop.", "").replace(".", "_") + "_";
        // url的路径
        String strUrlPath = PageUtil.getPageFilePath(strModelPackage);
        // url的后缀
        String strPageUrlSuffix = PageUtil.getPageUrlSuffix();
        
        int iTemplateNum = lstPageTempInfo.size();
        // 循环当前元数据对应模板并生成Json文件
        JSONObject objJSONObject = WrapperFtlPageCommon.wrapperDataToFtlTmp(objCopyMetaGenVO,
            isWrapperConstantURL);
        // 特殊处理 备份一次
        JSONObject objTmpJSONObject = JSONObject.parseObject(JSONObject.toJSONString(objJSONObject));
        for (int i = 0; i < iTemplateNum; i++) {
            String strTemplateName = (String) lstPageTempInfo.get(i).get("ename");
            
            boolean replaceFlag = false;
            
            // 特殊处理 判断模板名称是否为这俩个模板
            if (strTemplateName.equals("ReportedListPage.ftl") || strTemplateName.equals("CompreListPage.ftl")) {
                JSONArray objSubRenders = (JSONArray) objJSONObject.get("gridRender");
                for (int j = 0, len = objSubRenders.size(); j < len; j++) {
                    JSONObject objRender = (JSONObject) objSubRenders.get(j);
                    if ("gridEditLinkRender".equals(objRender.getString("actionModelName"))) {
                    	String strBindName = objRender.getString("bindName");
                    	String strUpdateAcionName = "gridViewLinkRenderBy"+(strBindName.substring(NumberConstant.ZERO, NumberConstant.ONE).toUpperCase()
                                + strBindName.substring(NumberConstant.ONE));
                    	
                    	String strActionName = (String) objRender.get("gridEditLinkRender");
                    	// 修改extras 以及 columns 中的 gridEditLinkRenderByXX
                    	String strGridExtras = objJSONObject.getString("gridExtras");
                    	if (strGridExtras != null && strGridExtras.indexOf(strActionName) != -1) {// gridViewLinkRender
                    		strGridExtras = strGridExtras.replace(strActionName, strUpdateAcionName);
                    		objJSONObject.put("gridExtras", strGridExtras);
                    	}
                    	
                    	String strGridColumns = objJSONObject.getString("gridColumns");
                    	if (strGridColumns != null && strGridColumns.indexOf(strActionName) != -1) {// gridViewLinkRender
                    		strGridColumns = strGridColumns
                    				.replace(strActionName, strUpdateAcionName);
                    		objJSONObject.put("gridColumns", strGridColumns);
                    	}
                        // 修改objRender
                        objRender.put("actionModelName", "gridViewLinkRender");
                        objRender.put("gridViewLinkRender", strUpdateAcionName);
                        objRender.remove("gridEditLinkRender");
                        
                        replaceFlag = true;
                    }
                }
               
                
            }
            // 数据封装
            String strFileSuffix = strTemplateName.substring(0, strTemplateName.indexOf("."));
            // 首字母转大写
            String strPageModelName = strModelName.substring(0, 1).toUpperCase() + strModelName.substring(1)
                + strFileSuffix;
            String strModelId = strModelPackage + ".page." + strPageModelName;
            // 包名(.转为_)+页面名称(首字母小写)
            objJSONObject.put("code", strCurrModel + strModelName + strFileSuffix);
            objJSONObject.put("modelId", strModelId);
            objJSONObject.put("modelName", strPageModelName);
            // url中首字母小写
            objJSONObject.put("url", strUrlPath + strModelName + strFileSuffix + strPageUrlSuffix);
            objJSONObject.put("pageId", UUID.randomUUID().toString().replaceAll("-", StringUtil.EMPTY));
            objJSONObject.put("pageUrlSuffix", strPageUrlSuffix);
            // 生成Json文件
            File fileJson = this.getFile(strModelId);
            if (fileJson.exists()) {
                PageFacade objPageFacade = new PageFacade();
                String strPage = FileUtil.readString(fileJson, "UTF-8");
                PageVO objPageVO = null;
                try {
                    objPageVO = JSONObject.toJavaObject(JSONObject.parseObject(strPage), PageVO.class);
                } catch (Exception e) {
                    LOG.error("已存在的界面元数据文件【" + strModelId + "】中的JSON内容格式有错！", e);
                }
                if(objPageVO != null){
                    objPageFacade.deleteModel(objPageVO);
                }
            }
            // 根据模板写入数据
            bResult = this.generateJson(objJSONObject, strTemplateName, fileJson);
            // 根据模板处理后Json对象转换为PageVO进行处理
            if (bResult) {
                PageFacade objPageFacade = new PageFacade();
                String strPage = FileUtil.readString(fileJson, "UTF-8");
                PageVO objPageVO = null;
                try {
                    objPageVO = JSONObject.toJavaObject(JSONObject.parseObject(strPage), PageVO.class);
                } catch (Exception e) {
                    lstErrorTemplateName.add(strTemplateName);
                    FileUtil.delete(fileJson);
                    LOG.error("【" + strTemplateName + "】模版生成的JSON对象有误，无法生成【" + strModelId + "】界面元数据文件！" + strPage, e);
                }
                if(objPageVO != null){
                    ValidateResult<PageVO> bValidate = objPageFacade.validate(objPageVO);
                    if (bValidate.isOK()) {
                        objPageFacade.saveTopPage(objPageVO);
                        lstSuccessModelId.add(objPageVO.getModelId());
                    }
                }
            } else {
                lstErrorTemplateName.add(strTemplateName);
            }
            // 特殊处理
            if (replaceFlag) {
                objJSONObject = objTmpJSONObject;
            }
        }
        return objResult;
    }
    
    /**
     * 根据模型ID获取模型文件
     *
     * @param id 模型对象唯一标识
     * @return 文件
     */
    public File getFile(String id) {
        File objFile = null;
        // com.comtop.fwms.defect.entity.defect
        if (StringUtil.isNotBlank(id)) {
            String[] strPaths = id.split("\\.");
            int iLong = strPaths.length;
            String strType = strPaths[iLong - 2];
            String strName = strPaths[iLong - 1] + "." + strType;
            String strPackage = "";
            for (int i = 0; i < iLong - 2; i++) {
                strPackage += File.separator + strPaths[i];
            }
            String strFilePath = WebGlobalInfo.getWebInfoPath() + File.separator + "metadata" + strPackage
                + File.separator + "page" + File.separator + strName + ".json";
            objFile = new File(strFilePath);
        }
        return objFile;
    }
    
    /**
     * 判断是否需要封装URL常量（编辑，查看，返回）
     *
     * @param lstPageTempInfo 页面模板集合
     * @return 是否需要封装
     */
    private boolean isWrapperConstantURL(List<CapMap> lstPageTempInfo) {
        int iFTLType = 0;
        for (CapMap objPageTempInfo : lstPageTempInfo) {
            String strFtlName = (String) objPageTempInfo.get("ename");
            if (StringUtil.equals(strFtlName, "EditPage.ftl")) {
                iFTLType += 1;
            }
            if (StringUtil.equals(strFtlName, "EditPageForWorkFlow.ftl")) {
                iFTLType += 1;
            }
            if (StringUtil.equals(strFtlName, "ListPage.ftl")) {
                iFTLType += 1;
            }
            if (StringUtil.equals(strFtlName, "ListPageForWorkFlow.ftl")) {
                iFTLType += 1;
            }
        }
        return iFTLType == 2;
    }
    
    /**
     * 生成Json文件
     * 
     * @param param 数据
     * @param ftlName 模板文件名称
     * @param srcFile Json文件名称
     * @return boolean 返回模板文件处理操作是否成功标识
     */
    private boolean generateJson(Object param, String ftlName, File srcFile) {
        OutputStream objOS = null;
        OutputStreamWriter objOSW = null;
        Template objCodeTemplate = null;
        try {
            FileUtil.mkdirs(srcFile.getParent());
            // 获取模版
            objCodeTemplate = this.getTemplateConfig().getTemplate(ftlName);
            objOS = new FileOutputStream(srcFile);
            objOSW = new OutputStreamWriter(objOS, "UTF-8");
            objCodeTemplate.process(param, objOSW);
            return true;
        } catch (FileNotFoundException e) {
            e.printStackTrace();
        } catch (IOException e) {
            e.printStackTrace();
        } catch (TemplateException e) {
            e.printStackTrace();
        } catch (Exception e) {
            e.printStackTrace();
        } finally {
            IOUtils.close(objOS);
            IOUtils.close(objOSW);
        }
        return false;
    }
    
    /**
     * 获取模板配置
     * 
     * @return 模板配置
     */
    private Configuration getTemplateConfig() {
        Configuration objTemplateConfig = new Configuration();
        // 获取ftl模板存放路径
        String ftlPath = WebGlobalInfo.getWebInfoPath() + File.separator + "metadata" + File.separator + "pageTemplate"
            + File.separator + "oldPageConfigTmp" + File.separator + "ftl";
        try {
            FileUtil.mkdirs(ftlPath);
            objTemplateConfig.setDirectoryForTemplateLoading(new File(ftlPath));
            objTemplateConfig.setDefaultEncoding("UTF-8"); // 这个一定要设置，不然在生成的页面中 会乱码
        } catch (IOException e) {
            e.printStackTrace();
        }
        return objTemplateConfig;
    }
    
    /**
     * 控件属性绑定的实体别名更改为实体英文名称
     *
     * @param vo 模板表单元数据
     * @throws OperateException 异常
     */
    @SuppressWarnings({ "unchecked", "rawtypes" })
    private void aliaConverterEntityEname(MetadataGenerateVO vo) throws OperateException {
        List<RowFromEntityAreaVO> lstEntity = vo.getMetadataValue().getEntityComponentList().get(0).getRowList();
        CapMap objMap = new CapMap();
        for (RowFromEntityAreaVO objEntity : lstEntity) {
            objMap.put(objEntity.getSuffix(), objEntity.getEngName());
        }
        List<CapMap> lstOption = vo.queryList("metadataValue//options");
        for (CapMap objOption : lstOption) {
            Iterator iterator = objOption.entrySet().iterator();
            while (iterator.hasNext()) {
                Map.Entry<String, String> entry = (Entry<String, String>) iterator.next();
                if (null != entry.getValue() && !"".equals(entry.getValue())) {
                    String strVal = String.valueOf(entry.getValue());
                    String[] str = strVal.split("\\.");
                    if (objMap.containsKey(str[0])) {
                        String strDataStoreEname = objMap.get(str[0]).toString();
                        strDataStoreEname = strDataStoreEname.substring(0, 1).toLowerCase()
                            + strDataStoreEname.substring(1, strDataStoreEname.length());
                        entry.setValue(strVal.replace(str[0], strDataStoreEname));
                    }
                }
            }
        }
    }
}
