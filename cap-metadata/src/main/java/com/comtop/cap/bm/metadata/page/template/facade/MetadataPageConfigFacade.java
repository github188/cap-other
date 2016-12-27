/******************************************************************************
 * Copyright (C) 2015 ShenZhen ComTop Information Technology Co.,Ltd
 * All Rights Reserved.
 * 本软件为深圳康拓普开发研制。未经本公司正式书面同意，其他任何个人、团体不得使用、
 * 复制、修改或发布本软件.
 *****************************************************************************/

package com.comtop.cap.bm.metadata.page.template.facade;

import java.util.ArrayList;
import java.util.List;

import org.apache.commons.lang.StringUtils;

import com.comtop.cap.bm.metadata.CapMetaDataConstant;
import com.comtop.cap.bm.metadata.base.facade.CapBmBaseFacade;
import com.comtop.cap.bm.metadata.common.dwr.CapMap;
import com.comtop.cap.bm.metadata.common.storage.CacheOperator;
import com.comtop.cap.bm.metadata.common.storage.exception.OperateException;
import com.comtop.cap.bm.metadata.common.storage.exception.ValidateException;
import com.comtop.cap.bm.metadata.page.desinger.model.PageVO;
import com.comtop.cap.bm.metadata.page.template.TemplateProvider;
import com.comtop.cap.bm.metadata.page.template.model.MetaComponentDefineVO;
import com.comtop.cap.bm.metadata.page.template.model.MetadataPageConfigVO;
import com.comtop.cip.jodd.petite.meta.PetiteBean;
import comtop.org.directwebremoting.annotations.DwrProxy;
import comtop.org.directwebremoting.annotations.RemoteMethod;

/**
 * 元数据页面配置facade类
 *
 * @author 诸焕辉
 * @since jdk1.6
 * @version 2015-9-24 诸焕辉
 */
@DwrProxy
@PetiteBean
public class MetadataPageConfigFacade extends CapBmBaseFacade {
    
    /**
     * 加载模型文件
     *
     * @param id 控件模型ID
     * @return 操作结果
     * @throws OperateException 操作异常
     */
    @RemoteMethod
    public MetadataPageConfigVO loadModel(String id) throws OperateException {
        MetadataPageConfigVO objMetadataPageConfigVO = null;
        if (StringUtils.isNotBlank(id)) {
            objMetadataPageConfigVO = (MetadataPageConfigVO) CacheOperator.readById(id);
        }
        
        this.layoutElementNodeOrder(objMetadataPageConfigVO);
        return objMetadataPageConfigVO;
    }
    
    /**
     * 保存
     *
     * @param metadataPageConfigVO 被保存的对象
     * @return 是否成功
     * @throws ValidateException 异常
     * @throws OperateException 操作异常
     */
    @RemoteMethod
    public boolean saveModel(MetadataPageConfigVO metadataPageConfigVO) throws ValidateException, OperateException {
        this.layoutElementNodeOrder(metadataPageConfigVO);
        return metadataPageConfigVO.saveModel();
    }
    
    /**
     * 根据页面模版分类类型，获取界面配置模版
     *
     * @param typeCode 页面模版分类类型
     * @throws OperateException 操作异常
     * @return 界面配置元数据对象
     */
    public MetadataPageConfigVO queryByTypeCode(String typeCode) throws OperateException {
        List<MetadataPageConfigVO> lstMetadataPageConfigVO = CacheOperator.queryList("pageConfig[typeCode='" + typeCode
            + "']", MetadataPageConfigVO.class);
        return lstMetadataPageConfigVO != null && lstMetadataPageConfigVO.size() > 0 ? lstMetadataPageConfigVO.get(0)
            : null;
    }
    
    /**
     * 编排元素节点顺序
     *
     * @param metadataPageConfigVO 被保存的对象
     * @throws OperateException 操作异常
     */
    private void layoutElementNodeOrder(MetadataPageConfigVO metadataPageConfigVO) throws OperateException {
        if (metadataPageConfigVO != null) {
            List<MetaComponentDefineVO> lstMetaCompDefineVO = new ArrayList<MetaComponentDefineVO>();
            lstMetaCompDefineVO.addAll(this.getComponentDefineVOsByUitype(metadataPageConfigVO,
                CapMetaDataConstant.META_COMPONENT_DEFINE_TYPE_INPUT.getMetaDataType()));
            lstMetaCompDefineVO.addAll(this.getComponentDefineVOsByUitype(metadataPageConfigVO,
                CapMetaDataConstant.META_COMPONENT_DEFINE_TYPE_MENU.getMetaDataType()));
            lstMetaCompDefineVO.addAll(this.getComponentDefineVOsByUitype(metadataPageConfigVO,
                CapMetaDataConstant.META_COMPONENT_DEFINE_TYPE_ENTITYSELECTION.getMetaDataType()));
            lstMetaCompDefineVO.addAll(this.getComponentDefineVOsByUitype(metadataPageConfigVO,
                CapMetaDataConstant.META_COMPONENT_DEFINE_TYPE_QUERYCODEAREA.getMetaDataType()));
            lstMetaCompDefineVO.addAll(this.getComponentDefineVOsByUitype(metadataPageConfigVO,
                CapMetaDataConstant.META_COMPONENT_DEFINE_TYPE_LISTCODEAREA.getMetaDataType()));
            lstMetaCompDefineVO.addAll(this.getComponentDefineVOsByUitype(metadataPageConfigVO,
                CapMetaDataConstant.META_COMPONENT_DEFINE_TYPE_EDITCODEAREA.getMetaDataType()));
            lstMetaCompDefineVO.addAll(this.getComponentDefineVOsByUitype(metadataPageConfigVO, StringUtils.EMPTY));
            metadataPageConfigVO.setMetaComponentDefineVOList(lstMetaCompDefineVO);
        }
    }
    
    /**
     * 根据控件类型，获取所有相关控件信息
     *
     * @param metadataPageConfigVO 被保存的对象
     * @param uitype 控件类型
     * @return 控件对象集合
     * @throws OperateException 操作异常
     */
    @SuppressWarnings("unchecked")
    private List<MetaComponentDefineVO> getComponentDefineVOsByUitype(MetadataPageConfigVO metadataPageConfigVO,
        String uitype) throws OperateException {
        return metadataPageConfigVO.queryList("metaComponentDefineVOList[uiType='" + uitype + "']");
    }
    
    /**
     * 验证页面的可变区域设置是否合法（具有相同的区域编码和区域ID的可变区域，如果绑定的实体不同(一个有绑定实体为空，一个没绑定实体也视为不同)则非法）
     *
     * @param lstPageVO 需要校验的页面集合
     * @return
     *         校验结果（
     *         <code>{"result":false,"illegalAreas":[{"areaName":xxx,"areaId":xxx,"entityId":["www","yyy"],"pageName":["personList","personEdit"]}],"message":"xxx"}</code>
     *         ,areaName为区域的中文名称，非区域的code，areaId可能不存在（值为null，序列化成JSON串时，跳过了null属性的序列化），表示为设置区域Id
     *         ,entityId数组中的元素为null表示区域未绑定数据集）
     */
    @RemoteMethod
    public CapMap validatePagesAreas(List<PageVO> lstPageVO) {
        TemplateProvider objTemplateProvider = new TemplateProvider();
        return objTemplateProvider.validatePagesAreas(lstPageVO);
    }
    
    /**
     * 批量clone源页面,并返回生成元数据录入界面配置文件需要的数据
     *
     * @param lstPageVO 源页面集合（不能为null）
     * @param templateTypeCode 模板分类的code
     * @param templateTypeName 模板分类的Name
     * @return 是否成功
     * @throws ValidateException 检验异常
     * @throws OperateException 对象操作异常
     */
    @RemoteMethod
    public boolean generateTemplateFiles(List<PageVO> lstPageVO, String templateTypeCode, String templateTypeName)
        throws ValidateException, OperateException {
        // saveAsTemplates接口要改造，到时直接返回MetaComponentDefineVO对象即可，不需要在此封装MetaComponentDefineVO对象
        MetadataPageConfigVO objMetadataPageConfigVO = new TemplateProvider().saveAsTemplates(lstPageVO,
            templateTypeCode);
        objMetadataPageConfigVO.setModelPackage("pageTemplate." + templateTypeCode);
        objMetadataPageConfigVO.setModelName(templateTypeCode);
        objMetadataPageConfigVO.setCname(templateTypeName);
        // pageTemplate.XXX.pageConfig.XXX
        objMetadataPageConfigVO.setModelId(objMetadataPageConfigVO.getModelPackage() + "."
            + objMetadataPageConfigVO.getModelType() + "." + objMetadataPageConfigVO.getModelName());
        objMetadataPageConfigVO.setTypeCode(templateTypeCode);
        objMetadataPageConfigVO.setExtend("pageTemplate.basePageConfig.pageConfig.base");
        return this.saveModel(objMetadataPageConfigVO);
    }
}
