/******************************************************************************
 * Copyright (C) 2016 ShenZhen ComTop Information Technology Co.,Ltd
 * All Rights Reserved.
 * 本软件为深圳康拓普开发研制。未经本公司正式书面同意，其他任何个人、团体不得使用、
 * 复制、修改或发布本软件.
 *****************************************************************************/

package com.comtop.cap.bm.metadata.inject.injecter.page;

import com.comtop.cap.bm.metadata.common.storage.exception.OperateException;
import com.comtop.cap.bm.metadata.inject.injecter.IMetaDataInjecter;
import com.comtop.cap.bm.metadata.page.desinger.model.PageVO;
import com.comtop.cap.bm.metadata.page.template.model.HiddenComponentVO;
import com.comtop.cap.bm.metadata.page.template.model.MenuAreaComponentVO;
import com.comtop.cap.bm.metadata.page.template.model.MetadataGenerateVO;

/**
 * 与top平台集成的信息封装
 *
 * @author 肖威
 * @since jdk1.6
 * @version 2016年1月7日 肖威
 */
public class ParentDirInjecter implements IMetaDataInjecter {
    
    /**
     * 页面基础信息封装
     */
    @Override
    public void inject(Object obj, Object source) {
        MetadataGenerateVO objMetadataGenerate = (MetadataGenerateVO) obj;
        
        try {
            
            HiddenComponentVO objParentId = objMetadataGenerate.query(
                "metadataValue/hiddenComponentList[id='parentId']", HiddenComponentVO.class);
            String strParentId = objParentId == null ? null : objParentId.getValue();
            
            MenuAreaComponentVO objParentName = objMetadataGenerate.query(
                "metadataValue/menuComponentList[id='parentName']", MenuAreaComponentVO.class);
            String strParentName = objParentName == null ? null : objParentName.getValue();
            
            PageVO objPageVO = (PageVO) source;
            objPageVO.setParentId(strParentId);
            objPageVO.setParentName(strParentName);
        } catch (OperateException e) {
            e.printStackTrace();
        }
    }
    
}
