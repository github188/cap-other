/******************************************************************************
 * Copyright (C) 2015 ShenZhen ComTop Information Technology Co.,Ltd
 * All Rights Reserved.
 * 本软件为深圳康拓普开发研制。未经本公司正式书面同意，其他任何个人、团体不得使用、
 * 复制、修改或发布本软件.
 *****************************************************************************/

package com.comtop.cap.bm.metadata.page.template.facade;

import java.io.File;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.Iterator;
import java.util.List;
import java.util.Map;

import org.apache.commons.lang.StringUtils;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;

import com.comtop.cap.bm.metadata.base.facade.CapBmBaseFacade;
import com.comtop.cap.bm.metadata.common.dwr.CapMap;
import com.comtop.cap.bm.metadata.common.storage.CacheOperator;
import com.comtop.cap.bm.metadata.common.storage.exception.OperateException;
import com.comtop.cap.bm.metadata.common.storage.exception.ValidateException;
import com.comtop.cap.bm.metadata.page.template.model.MetadataGenerateVO;
import com.comtop.cap.bm.metadata.page.template.model.MetadataPageConfigVO;
import com.comtop.cap.bm.metadata.page.template.model.MetadataTmpTypeDefineVO;
import com.comtop.cap.bm.metadata.page.template.model.MetadataTmpTypeVO;
import com.comtop.cap.bm.metadata.page.template.model.MetadataTmpTypeViewVO;
import com.comtop.cap.bm.metadata.page.template.model.PageTempVO;
import com.comtop.cip.jodd.petite.meta.PetiteBean;
import com.comtop.cip.jodd.petite.meta.PetiteInject;
import com.comtop.corm.resource.util.CollectionUtils;
import com.comtop.top.core.util.StringUtil;
import comtop.org.directwebremoting.annotations.DwrProxy;
import comtop.org.directwebremoting.annotations.RemoteMethod;
import comtop.soa.org.apache.commons.io.FileUtils;

/**
 * 元数据模板分类facade类
 *
 * @author 诸焕辉
 * @since jdk1.6
 * @version 2015-9-24 诸焕辉
 */
@DwrProxy
@PetiteBean
public class MetadataTmpTypeFacade extends CapBmBaseFacade {
    
    /** 日志 */
    private final static Logger LOG = LoggerFactory.getLogger(MetadataTmpTypeFacade.class);
    
    /**
     * 元数据页面配置facade
     */
    @PetiteInject
    private MetadataPageConfigFacade metadataPageConfigFacade;
    
    /**
     * 元数据页面配置生成的数据facade
     */
    @PetiteInject
    private MetadataGenerateFacade metadataGenerateFacade;
    
    /**
     * 加载模型文件
     *
     * @return 操作结果
     * @throws ValidateException 对象检验异常
     */
    @RemoteMethod
    public MetadataTmpTypeVO getCustomMetaTmpType() throws ValidateException {
        String strModelId = MetadataTmpTypeVO.getCustomMetaTmpTypeModelId();
        MetadataTmpTypeVO objMetadataTmpTypeVO = (MetadataTmpTypeVO) CacheOperator.readById(strModelId);
        if (objMetadataTmpTypeVO == null) {
            objMetadataTmpTypeVO = MetadataTmpTypeVO.createCustomMetadataTmpTypeVO();
            boolean isSuccess = objMetadataTmpTypeVO.saveModel();
            if (isSuccess) {
                objMetadataTmpTypeVO = (MetadataTmpTypeVO) MetadataTmpTypeVO.loadModel(strModelId);
            }
        }
        return objMetadataTmpTypeVO;
    }
    
    /**
     * 加载模型文件
     *
     * @param id 控件模型ID
     * @return 操作结果
     */
    @RemoteMethod
    public MetadataTmpTypeVO loadModel(String id) {
        MetadataTmpTypeVO objMetadataTmpTypeVO = null;
        if (StringUtils.isNotBlank(id)) {
            objMetadataTmpTypeVO = (MetadataTmpTypeVO) CacheOperator.readById(id);
        }
        return objMetadataTmpTypeVO;
    }
    
    /**
     * 根据元数据模版分类，把元数据模版封装成一颗树
     * 
     * @return lstMetadataTmpTypeViewVO
     * @throws OperateException 异常
     * @throws ValidateException 检验异常
     */
    @RemoteMethod
    public List<MetadataTmpTypeViewVO> queryMetadataTmpTypeView() throws OperateException, ValidateException {
        List<MetadataTmpTypeViewVO> lstMetadataTmpTypeViewVO = new ArrayList<MetadataTmpTypeViewVO>();
        String strModelId = MetadataTmpTypeVO.getCustomMetaTmpTypeModelId();
        MetadataTmpTypeVO objMetadataTmpTypeVO = (MetadataTmpTypeVO) CacheOperator.readById(strModelId);
        if (objMetadataTmpTypeVO == null) {// 创建自定义文件
            objMetadataTmpTypeVO = MetadataTmpTypeVO.createCustomMetadataTmpTypeVO();
            boolean isSuccess = objMetadataTmpTypeVO.saveModel();
            if (isSuccess) {
                objMetadataTmpTypeVO = (MetadataTmpTypeVO) CacheOperator.readById(strModelId);
            }
        }
        if (objMetadataTmpTypeVO != null) {
            lstMetadataTmpTypeViewVO = this.convertMetadataTmpTypeViewVO(objMetadataTmpTypeVO.getType());
        }
        return lstMetadataTmpTypeViewVO;
    }
    
    /**
     * 转换单个行为节点VO对象成视图中的数节点VO
     * 
     * @param lstMetadataTmpTypeVO 树干节点
     * @return MetadataTmpTypeViewVO 行为类型视图VO
     * @throws OperateException xml操作异常
     */
    private List<MetadataTmpTypeViewVO> convertMetadataTmpTypeViewVO(List<MetadataTmpTypeDefineVO> lstMetadataTmpTypeVO)
        throws OperateException {
        List<MetadataTmpTypeViewVO> lstMetadataTmpTypeViewVO = new ArrayList<MetadataTmpTypeViewVO>();
        for (MetadataTmpTypeDefineVO objType : lstMetadataTmpTypeVO) {
            MetadataTmpTypeViewVO objMetadataTmpTypeViewVO = new MetadataTmpTypeViewVO();
            String strTypeCode = objType.getTypeCode();
            objMetadataTmpTypeViewVO.setTitle(objType.getTypeName());
            objMetadataTmpTypeViewVO.setKey(strTypeCode);
            objMetadataTmpTypeViewVO.setFolder(true);
            objMetadataTmpTypeViewVO.setExpand(true);
            List<MetadataTmpTypeDefineVO> lstSubMetadataTmpTypeVO = objType.getType();
            if (lstSubMetadataTmpTypeVO != null && lstSubMetadataTmpTypeVO.size() > 0) {
                List<MetadataTmpTypeViewVO> lstSubMetadataTmpTypeViewVO = this
                    .convertMetadataTmpTypeViewVO(lstSubMetadataTmpTypeVO);
                objMetadataTmpTypeViewVO.setChildren(lstSubMetadataTmpTypeViewVO);
                if ("pageMetadataTmp".equals(strTypeCode)) { // 页面元数据模版
                    this.setPageMetadataTmpNode(lstSubMetadataTmpTypeViewVO);
                } else if ("entityMetadataTmp".equals(strTypeCode)) { // 实体元数据模版
                    this.setEntityMetadataTmpNode(lstSubMetadataTmpTypeViewVO);
                }
            }
            
            lstMetadataTmpTypeViewVO.add(objMetadataTmpTypeViewVO);
        }
        
        return lstMetadataTmpTypeViewVO;
    }
    
    /**
     * 界面元数据模版
     *
     * @param lstMetadataTmpTypeViewVO 元数据模版分类tree对象
     * @throws OperateException 操作异常
     */
    private void setPageMetadataTmpNode(List<MetadataTmpTypeViewVO> lstMetadataTmpTypeViewVO) throws OperateException {
        for (MetadataTmpTypeViewVO objMetadataTmpTypeViewVO : lstMetadataTmpTypeViewVO) {
            MetadataPageConfigVO objMetadataPageConfigVO = metadataPageConfigFacade
                .queryByTypeCode(objMetadataTmpTypeViewVO.getKey());
            if (objMetadataPageConfigVO != null) {
                objMetadataTmpTypeViewVO.setMetadataPageConfigModelId(objMetadataPageConfigVO.getModelId());
                objMetadataTmpTypeViewVO.setDefaultTemplate(objMetadataPageConfigVO.isDefaultTemplate());
            }
            objMetadataTmpTypeViewVO.setFolder(false);
        }
    }
    
    /**
     * 实体元数据模版
     *
     * @param lstMetadataTmpTypeViewVO 元数据模版分类tree对象
     */
    private void setEntityMetadataTmpNode(List<MetadataTmpTypeViewVO> lstMetadataTmpTypeViewVO) {
        for (MetadataTmpTypeViewVO objMetadataTmpTypeViewVO : lstMetadataTmpTypeViewVO) {
            // 待扩展
            objMetadataTmpTypeViewVO.setFolder(false);
        }
    }
    
    /**
     * 根据界面配置模版modelId，获取生成元数据模版相关数据
     *
     * @param id 界面配置模版modelId
     * @return 生成元数据模版集合
     */
    @SuppressWarnings("unchecked")
    @RemoteMethod
    public List<Map<String, Object>> queryPageTmpList(String id) {
        List<Map<String, Object>> lstPageTmp = new ArrayList<Map<String, Object>>();
        MetadataPageConfigVO objMetadataPageConfigVO = (MetadataPageConfigVO) CacheOperator.readById(id);
        if (objMetadataPageConfigVO != null) {
            List<CapMap> lstPageTemp = objMetadataPageConfigVO.getPageTempList();
            if (objMetadataPageConfigVO.isDefaultTemplate()) {// 旧版本（flt）
                for (CapMap objPageTemp : lstPageTemp) {
                    lstPageTmp.add(objPageTemp);
                }
            } else {
                for (CapMap objPage : lstPageTemp) {
                    String strModelId = (String) objPage.get("modelId");
                    PageTempVO objPageTempVO = (PageTempVO) CacheOperator.readById(strModelId);
                    Map<String, Object> objPageTemp = new HashMap<String, Object>();
                    objPageTemp.put("id", objPageTempVO.getModelId());
                    objPageTemp.put("cname", objPageTempVO.getCname());
                    objPageTemp.put("ename", objPageTempVO.getModelName());
                    objPageTemp.put("description", objPageTempVO.getDescription());
                    lstPageTmp.add(objPageTemp);
                }
            }
        }
        return lstPageTmp;
    }
    
    /**
     * 新增模版分类，并添加在typeCode所在节点下
     *
     * @param metadataTmpTypeDefineVO 类型编码
     * @param typeCode 类型编码
     * @return 是否成功
     * @throws OperateException 操作异常
     * @throws ValidateException 检验异常
     */
    @RemoteMethod
    public boolean addMetadataTmpTypeNode(MetadataTmpTypeDefineVO metadataTmpTypeDefineVO, String typeCode)
        throws OperateException, ValidateException {
        boolean isSuccess = false;
        MetadataTmpTypeVO objMetadataTmpTypeVO = (MetadataTmpTypeVO) CacheOperator.readById(MetadataTmpTypeVO
            .getCustomMetaTmpTypeModelId());
        MetadataTmpTypeDefineVO objParentNode = (MetadataTmpTypeDefineVO) objMetadataTmpTypeVO
            .query("//type[typeCode='" + typeCode + "']");
        if (objParentNode != null) {
            objParentNode.getType().add(metadataTmpTypeDefineVO);
            isSuccess = objMetadataTmpTypeVO.saveModel();
        }
        return isSuccess;
    }
    
    /**
     * 更新模版分类
     *
     * @param metadataTmpTypeDefineVO 类型编码
     * @return 是否成功
     * @throws OperateException 操作异常
     * @throws ValidateException 检验异常
     */
    @RemoteMethod
    public boolean updateMetadataTmpTypeNode(MetadataTmpTypeDefineVO metadataTmpTypeDefineVO) throws OperateException,
        ValidateException {
        boolean isSuccess = false;
        MetadataTmpTypeVO objMetadataTmpTypeVO = (MetadataTmpTypeVO) CacheOperator.readById(MetadataTmpTypeVO
            .getCustomMetaTmpTypeModelId());
        MetadataTmpTypeDefineVO objMetadataTmpTypeNode = (MetadataTmpTypeDefineVO) objMetadataTmpTypeVO
            .query("//type[typeCode='" + metadataTmpTypeDefineVO.getTypeCode() + "']");
        if (objMetadataTmpTypeNode != null) {
            objMetadataTmpTypeNode.setTypeName(metadataTmpTypeDefineVO.getTypeName());
            isSuccess = objMetadataTmpTypeVO.saveModel();
        }
        return isSuccess;
    }
    
    /**
     * 根据类型编码，删除该节点的分类
     *
     * @param typeCode 类型编码
     * @return 是否成功
     * @throws ValidateException 检验异常
     * @throws OperateException 操作异常
     */
    @RemoteMethod
    public boolean deleteMetadataTmpType(String typeCode) throws ValidateException, OperateException {
        boolean isSuccess = false;
        MetadataTmpTypeVO objMetadataTmpTypeVO = (MetadataTmpTypeVO) CacheOperator.readById(MetadataTmpTypeVO
            .getCustomMetaTmpTypeModelId());
        MetadataPageConfigVO objMetadataPageConfigVO = metadataPageConfigFacade.queryByTypeCode(typeCode);
        if (objMetadataPageConfigVO != null) {
            String[] strPaths = objMetadataPageConfigVO.getModelPackage().split("\\.");
            try {
                // 1、删除pageTemp页面模版
                List<CapMap> lstPageTempInfo = objMetadataPageConfigVO.getPageTempList();
                for (CapMap objPageTempInfo : lstPageTempInfo) {
                    PageTempVO.deleteModel((String) objPageTempInfo.get("modelId"));
                }
                // 2、删除界面配置模版（pageConfig）
                objMetadataTmpTypeVO.delete("//type[typeCode='" + typeCode + "']");
            } catch (Exception e) {
                LOG.error(typeCode + "类型的相关页面模版已不存在，原因：手动在工程删除了文件。", e);
            }
            String strMetaTmpTypeFolderPath = CacheOperator.getMetaDataRootPath();
            for (String objPath : strPaths) {
                strMetaTmpTypeFolderPath += objPath + File.separator;
            }
            File objFile = new File(strMetaTmpTypeFolderPath);
            // 3、删除分类模版目录(前两步是为了删除缓存数据)
            isSuccess = FileUtils.deleteQuietly(objFile);
        } else { // 如果线下直接删除了界面配置文件（xxx.pageConfig.json）执行以下操作即可
            isSuccess = objMetadataTmpTypeVO.delete("//type[typeCode='" + typeCode + "']");
        }
        return isSuccess;
    }
    
    /**
     * 
     * 根据模版分类，判断该分类是否已被使用（即：已有界面配置元数据产生的数据文件MetadataGenerateVO）
     * 
     * @param typeCode 元数据模版分类编码
     * @return 检验结果
     * @throws OperateException 对象操作异常
     */
    @RemoteMethod
    public Map<String, String> isGenerateMetadata(String typeCode) throws OperateException {
        Map<String, String> objResult = new HashMap<String, String>();
        MetadataPageConfigVO objMetadataPageConfigVO = metadataPageConfigFacade.queryByTypeCode(typeCode);
        if (objMetadataPageConfigVO != null) {
            List<MetadataGenerateVO> lstMetadataGenerateVO = metadataGenerateFacade
                .queryListByExpression("metadataGenerate[metadataPageConfigModelId='"
                    + objMetadataPageConfigVO.getModelId() + "']");
            if (!CollectionUtils.isEmpty(lstMetadataGenerateVO)) {
                List<String> lstFileName = new ArrayList<String>();
                for (MetadataGenerateVO objMetadataGenerateVO : lstMetadataGenerateVO) {
                    lstFileName.add(objMetadataGenerateVO.getModelName());
                }
                objResult.put("result", "0");
                objResult.put("message", lstFileName.toString());
            } else {
                objResult.put("result", "1");
            }
        } else {
            objResult.put("result", "1");
        }
        return objResult;
    }
    
    /**
     * 检查模块分类编码是否已存在
     *
     * @param typeCode 类型编码
     * @return 是否存在
     * @throws OperateException 操作异常
     */
    @RemoteMethod
    public boolean isExistMetadataTmpTypeByTypeCode(String typeCode) throws OperateException {
        return CacheOperator.queryCount("metadataTmpType//type[typeCode='" + typeCode + "']") > 0 ? true : false;
    }
    
    /**
     * 检查模块分类名称是否已存在
     *
     * @param typeName 类型名称
     * @param typeCode 类型code（）
     * @return 是否存在
     * @throws OperateException 操作异常
     * @throws ValidateException 验证错误
     */
    @RemoteMethod
    public boolean isExistMetadataTmpTypeByTypeName(String typeName, String typeCode) throws OperateException, ValidateException {
        List<MetadataTmpTypeViewVO> lstMetadataTmps= new ArrayList<MetadataTmpTypeViewVO>();
        List<MetadataTmpTypeViewVO> lstMetadatas= this.queryMetadataTmpTypeView();
        lstMetadataTmps = this.getMetadataTempTypeList(lstMetadatas);
        for (Iterator<MetadataTmpTypeViewVO> iterator = lstMetadataTmps.iterator(); iterator.hasNext();) {
            MetadataTmpTypeViewVO metadataTmpTypeViewVO = iterator.next();
            if( !StringUtil.equals(typeCode, metadataTmpTypeViewVO.getKey()) && StringUtil.equals(typeName, metadataTmpTypeViewVO.getTitle()) ){
                return true;
            }
        }
        return false;
    }
    
    /**
     * 获取所有分类信息
     * 
     * @param lstMetadatas 树形节点
     * @return lstMetadataTmps 分类信息集合
     */
    public List<MetadataTmpTypeViewVO> getMetadataTempTypeList(List<MetadataTmpTypeViewVO> lstMetadatas){
        List<MetadataTmpTypeViewVO> lstMetadataTmps= new ArrayList<MetadataTmpTypeViewVO>();
        for (Iterator iterator = lstMetadatas.iterator(); iterator.hasNext();) {
            MetadataTmpTypeViewVO metadataTmpTypeViewVO = (MetadataTmpTypeViewVO) iterator.next();
            List lstChildren = metadataTmpTypeViewVO.getChildren();
            if(lstChildren!=null && lstChildren.size()>0){
                lstMetadataTmps.addAll(this.getMetadataTempTypeList(lstChildren));
            }
            lstMetadataTmps.add(metadataTmpTypeViewVO);
        }
        return lstMetadataTmps;
    }
}
