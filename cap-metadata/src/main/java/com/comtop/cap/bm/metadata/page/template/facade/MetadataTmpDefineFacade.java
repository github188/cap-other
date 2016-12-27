/******************************************************************************
 * Copyright (C) 2015 ShenZhen ComTop Information Technology Co.,Ltd
 * All Rights Reserved.
 * 本软件为深圳康拓普开发研制。未经本公司正式书面同意，其他任何个人、团体不得使用、
 * 复制、修改或发布本软件.
 *****************************************************************************/

package com.comtop.cap.bm.metadata.page.template.facade;

import java.util.List;

import org.apache.commons.lang.StringUtils;

import com.comtop.cap.bm.metadata.base.facade.CapBmBaseFacade;
import com.comtop.cap.bm.metadata.common.storage.CacheOperator;
import com.comtop.cap.bm.metadata.common.storage.exception.OperateException;
import com.comtop.cap.bm.metadata.common.storage.exception.ValidateException;
import com.comtop.cap.bm.metadata.page.template.model.MetadataPageConfigVO;
import com.comtop.cap.bm.metadata.page.template.model.MetadataTmpDefineVO;
import com.comtop.cip.jodd.petite.meta.PetiteBean;
import com.comtop.cip.jodd.petite.meta.PetiteInject;
import comtop.org.directwebremoting.annotations.DwrProxy;
import comtop.org.directwebremoting.annotations.RemoteMethod;

/**
 * 元数据模板定义facade类
 *
 * @author 诸焕辉
 * @since jdk1.6
 * @version 2015-9-24 诸焕辉
 */
@DwrProxy
@PetiteBean
public class MetadataTmpDefineFacade extends CapBmBaseFacade {
    
    /**
     * 元数据页面配置facade
     */
    @PetiteInject
    private MetadataPageConfigFacade metadataPageConfigFacade;
    
    /**
     * 加载模型文件
     *
     * @param id 控件模型ID
     * @return 操作结果
     */
    @RemoteMethod
    public MetadataTmpDefineVO loadModel(String id) {
        MetadataTmpDefineVO objMetadataTmpDefineVO = null;
        if (StringUtils.isNotBlank(id)) {
            objMetadataTmpDefineVO = (MetadataTmpDefineVO) CacheOperator.readById(id);
            MetadataPageConfigVO objMetadataPageConfigVO = (MetadataPageConfigVO) CacheOperator
                .readById(objMetadataTmpDefineVO.getMetadataPageConfigModelId());
            objMetadataTmpDefineVO.setMetadataPageConfigVO(objMetadataPageConfigVO);
        }
        return objMetadataTmpDefineVO;
    }
    
    /**
     * 加载模型文件
     *
     * @param expression 表达式
     * @return 操作结果
     * @throws OperateException xml操作异常
     */
    @SuppressWarnings("unchecked")
    @RemoteMethod
    public List<MetadataTmpDefineVO> queryList(String expression) throws OperateException {
        List<MetadataTmpDefineVO> lstMetadataTmpDefineVO = CacheOperator.queryList(expression);
        return lstMetadataTmpDefineVO;
    }
    
    /**
     * 保存
     *
     * @param metadataTmpDefineVO 被保存的对象
     * @return 是否成功
     * @throws ValidateException 异常
     */
    @RemoteMethod
    public boolean saveModel(MetadataTmpDefineVO metadataTmpDefineVO) throws ValidateException {
        return metadataTmpDefineVO.saveModel();
    }
}
