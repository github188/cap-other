/******************************************************************************
 * Copyright (C) 2015 ShenZhen ComTop Information Technology Co.,Ltd
 * All Rights Reserved.
 * 本软件为深圳康拓普开发研制。未经本公司正式书面同意，其他任何个人、团体不得使用、
 * 复制、修改或发布本软件.
 *****************************************************************************/

package com.comtop.cap.bm.metadata.page.template.facade;

import java.util.ArrayList;
import java.util.HashMap;
import java.util.Iterator;
import java.util.List;
import java.util.Map;

import com.comtop.cap.bm.metadata.common.dwr.CapMap;
import com.comtop.cap.bm.metadata.common.storage.exception.OperateException;
import com.comtop.cap.bm.metadata.common.storage.exception.ValidateException;
import com.comtop.cap.bm.metadata.page.desinger.facade.PageFacade;
import com.comtop.cap.bm.metadata.page.desinger.model.PageVO;
import com.comtop.cap.bm.metadata.page.template.TemplateProvider;
import com.comtop.cap.bm.metadata.page.template.model.MetadataGenerateVO;
import com.comtop.cap.bm.metadata.page.template.model.MetadataPageConfigVO;
import com.comtop.top.core.jodd.AppContext;

/**
 * @author luozhenming
 *
 */
public class PageGenerate4CustomTmp {
    
    /** 页面facade */
    private PageFacade pageFacade = AppContext.getBean(PageFacade.class);
    
    /**
     * 
     * @param metadataGenerateVO 模板表单元数据
     * @return 成功的数量
     * @throws OperateException 操作异常
     * @throws ValidateException 验证异常
     */
    @SuppressWarnings({ "rawtypes", "unchecked" })
    public Map<String, Object> generatePageJson(MetadataGenerateVO metadataGenerateVO) throws ValidateException,
        OperateException {
        Map<String, Object> objResult = new HashMap<String, Object>();
        List<String> lstSuccessModelId = new ArrayList<String>();
        List<String> lstErrorTemplateName = new ArrayList<String>();
        objResult.put("success", lstSuccessModelId);
        objResult.put("error", lstErrorTemplateName);
        // 根据modelId获取对应模板PageVO
        List<String> lstModelIds = new ArrayList<String>();
        MetadataPageConfigVO objMetadataPageConfigVO = metadataGenerateVO.getMetadataPageConfigVO();
        if (objMetadataPageConfigVO == null) {
            return objResult;
        }
        List<CapMap> lstPageTempInfo = objMetadataPageConfigVO.getPageTempList();
        for (CapMap objPageTempInfo : lstPageTempInfo) {
            lstModelIds.add((String) objPageTempInfo.get("modelId"));
        }
        TemplateProvider objTemplateProvider = new TemplateProvider();
        List lstTemplatePage = objTemplateProvider.getTemplatePagesByModelId(lstModelIds);
        if (lstTemplatePage != null) {
            objTemplateProvider.metaDataInject(metadataGenerateVO, lstTemplatePage);
            for (Iterator iterator = lstTemplatePage.iterator(); iterator.hasNext();) {
                PageVO page = (PageVO) iterator.next();
                if (pageFacade.saveModel(page) != null) {
                    lstSuccessModelId.add(page.getModelId());
                } else {
                    lstErrorTemplateName.add(page.getModelName());
                }
            }
        }
        return objResult;
    }
}
