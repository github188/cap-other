/******************************************************************************
 * Copyright (C) 2015 ShenZhen ComTop Information Technology Co.,Ltd
 * All Rights Reserved.
 * 本软件为深圳康拓普开发研制。未经本公司正式书面同意，其他任何个人、团体不得使用、
 * 复制、修改或发布本软件.
 *****************************************************************************/

package com.comtop.cap.bm.metadata.page.preference.facade;

import java.util.List;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;

import com.comtop.cap.bm.metadata.base.facade.CapBmBaseFacade;
import com.comtop.cap.bm.metadata.common.storage.CacheOperator;
import com.comtop.cap.bm.metadata.common.storage.exception.ValidateException;
import com.comtop.cap.bm.metadata.page.desinger.facade.PageFacade;
import com.comtop.cap.bm.metadata.page.preference.model.PageTemplateActionPreferenceVO;
import com.comtop.cap.bm.metadata.page.preference.model.PageTemplateActionVO;
import com.comtop.cip.common.validator.ValidateResult;
import com.comtop.cip.common.validator.ValidatorUtil;
import com.comtop.cip.jodd.petite.meta.PetiteBean;
import comtop.org.directwebremoting.annotations.DwrProxy;
import comtop.org.directwebremoting.annotations.RemoteMethod;

/**
 * 页面模板渲染行为
 *
 * @author 肖威
 * @version jdk1.6
 * @version 2015-12-29
 */
@DwrProxy
@PetiteBean
public class PageTemplateActionPreferenceFacade extends CapBmBaseFacade {
    
    /** 日志 */
    private final static Logger LOG = LoggerFactory.getLogger(PageFacade.class);
    
    /**
     * 获取默认页面模板渲染行为对象
     *
     * @return PageTemplateActionPreferenceVO默认对象
     */
    @RemoteMethod
    public PageTemplateActionPreferenceVO getDefaultPageTemplateActionPreference() {
        String strModelId = PageTemplateActionPreferenceVO.getCustomModelId();
        PageTemplateActionPreferenceVO objVO = (PageTemplateActionPreferenceVO) CacheOperator.readById(strModelId);
        
        if (objVO == null) {
            objVO = PageTemplateActionPreferenceVO.createCustomActionPreference();
            if (save(objVO)) {
                objVO = (PageTemplateActionPreferenceVO) PageTemplateActionPreferenceVO.loadModel(strModelId);
            }
        }
        
        return objVO;
    }
    
    /**
     * 验证VO对象
     *
     * @param model 被校验对象
     * @return 结果集
     */
    @RemoteMethod
    public ValidateResult<PageTemplateActionPreferenceVO> validate(PageTemplateActionPreferenceVO model) {
        return ValidatorUtil.validate(model);
    }
    
    /**
     * 验证VO对象
     *
     * @param model 被校验对象
     * @return 结果集
     */
    @RemoteMethod
    public boolean save(PageTemplateActionPreferenceVO model) {
        try {
            return model.saveModel();
        } catch (ValidateException e) {
            LOG.error("保存页面渲染行为首选项配置失败", e);
        }
        return false;
    }
    
    /**
     * 获取默认页面模板渲染行为对象
     *
     * @return List<PageTemplateActionVO> 页面行为集合
     */
    @RemoteMethod
    public List<PageTemplateActionVO> getPageTemplateActionList() {
        PageTemplateActionPreferenceVO objTemplateAction = this.getDefaultPageTemplateActionPreference();
        List<PageTemplateActionVO> lst = objTemplateAction.getLstActions();
        return lst;
    }
}
