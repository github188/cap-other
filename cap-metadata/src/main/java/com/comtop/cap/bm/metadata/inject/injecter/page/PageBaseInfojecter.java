/******************************************************************************
 * Copyright (C) 2016 ShenZhen ComTop Information Technology Co.,Ltd
 * All Rights Reserved.
 * 本软件为深圳康拓普开发研制。未经本公司正式书面同意，其他任何个人、团体不得使用、
 * 复制、修改或发布本软件.
 *****************************************************************************/

package com.comtop.cap.bm.metadata.inject.injecter.page;

import java.util.Iterator;
import java.util.List;

import com.comtop.cap.bm.metadata.common.storage.exception.OperateException;
import com.comtop.cap.bm.metadata.inject.injecter.IMetaDataInjecter;
import com.comtop.cap.bm.metadata.inject.injecter.util.MetadataInjectProvider;
import com.comtop.cap.bm.metadata.page.desinger.model.PageVO;
import com.comtop.cap.bm.metadata.page.template.model.InputAreaComponentVO;
import com.comtop.cap.bm.metadata.page.template.model.MetadataGenerateVO;
import com.comtop.cap.ptc.login.model.CapLoginVO;
import com.comtop.cap.ptc.login.utils.CapLoginUtil;
import com.comtop.top.core.util.StringUtil;

/**
 * 输入信息封装
 *
 * @author 肖威
 * @since jdk1.6
 * @version 2016年1月7日 肖威
 */
public class PageBaseInfojecter implements IMetaDataInjecter {
    
    /**
     * 页面基础信息封装
     */
    @Override
    public void inject(Object obj, Object source) {
        MetadataGenerateVO objMetadataGenerate = (MetadataGenerateVO) obj;
        List<InputAreaComponentVO> lstInputAreaComponentVO;
        String strModelPackage = objMetadataGenerate.getModelPackage();
        // 获取当前CAP用户信息
        CapLoginVO currentVO = CapLoginUtil.getCapCurrentUserSession();
        try {
            lstInputAreaComponentVO = MetadataInjectProvider.queryList(objMetadataGenerate,
                "metadataValue/inputComponentList", InputAreaComponentVO.class);
            String strModelName = "";
            String strModelChName = "";
            for (Iterator<InputAreaComponentVO> iterator = lstInputAreaComponentVO.iterator(); iterator.hasNext();) {
                InputAreaComponentVO inputAreaComponentVO = iterator.next();
                String strId = inputAreaComponentVO.getId();
                String strValue = inputAreaComponentVO.getValue();
                if (StringUtil.equals("modelName", strId)) {
                    strModelName = StringUtil.isBlank(strValue) ? "" : strValue;
                } else if (StringUtil.equals("cname", strId)) {
                    strModelChName = StringUtil.isBlank(strValue) ? "" : strValue;
                }
            }
            
            PageVO objpageVO = (PageVO) source;
            
            String strPageModeName = objpageVO.getModelName();
            objpageVO.setModelName(strModelName.substring(0, 1).toUpperCase() + strModelName.substring(1)
                + strPageModeName);
            
            String strPageChName = objpageVO.getCname();
            objpageVO.setCname(strModelChName + strPageChName);
            
            objpageVO.setModelPackage(strModelPackage);
            
            objpageVO.setModelType("page");
            
            objpageVO.setModelId(objpageVO.getModelPackage() + "." + objpageVO.getModelType() + "."
                + objpageVO.getModelName());
            
            String description = objpageVO.getDescription();
            if (description == null) {
                description = "";
            }
            objpageVO.setDescription(strModelChName + description);
            
            setPageUrlAndCode(objpageVO);
            objpageVO.setPageId("");
            objpageVO.setCreaterId(currentVO.getBmEmployeeId());
            objpageVO.setCreaterName(currentVO.getBmEmployeeName());
            objpageVO.setCreateTime(System.currentTimeMillis());
        } catch (OperateException e) {
            e.printStackTrace();
        }
    }
    
    /**
     * 
     * @param page 页面
     */
    private void setPageUrlAndCode(PageVO page) {
        String strPageModeName = page.getModelName();
        strPageModeName = strPageModeName.substring(0, 1).toLowerCase() + strPageModeName.substring(1);
        // 当前模块名称
//        page.setUrl(PageUtil.getPageUrl(page));
        
        String strCurrModel = page.getModelPackage().replace("com.comtop.", "");
        page.setCode(strCurrModel.replace(".", "_") + "_" + strPageModeName);
    }
    
}
