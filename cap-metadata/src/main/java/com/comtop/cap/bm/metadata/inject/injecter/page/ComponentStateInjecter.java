/******************************************************************************
 * Copyright (C) 2014 ShenZhen ComTop Information Technology Co.,Ltd
 * All Rights Reserved.
 * 本软件为深圳康拓普开发研制。未经本公司正式书面同意，其他任何个人、团体不得使用、
 * 复制、修改或发布本软件.
 *****************************************************************************/

package com.comtop.cap.bm.metadata.inject.injecter.page;

import java.util.List;

import com.comtop.cap.bm.metadata.inject.injecter.IMetaDataInjecter;
import com.comtop.cap.bm.metadata.page.desinger.model.PageComponentExpressionVO;
import com.comtop.cap.bm.metadata.page.desinger.model.PageVO;
import com.comtop.corm.resource.util.CollectionUtils;

/**
 * “控件状态”注入器
 *
 *
 * @author 凌晨
 * @since jdk1.6
 * @version 2016年1月11日 凌晨
 */
public class ComponentStateInjecter implements IMetaDataInjecter {
    
    /**
     * 清空页面的所有控件状态
     * 
     * @see com.comtop.cap.bm.metadata.inject.injecter.IMetaDataInjecter#inject(java.lang.Object, java.lang.Object)
     */
    @Override
    public void inject(Object obj, Object source) {
            PageVO page = (PageVO) source;
            List<PageComponentExpressionVO> lstState = page.getPageComponentExpressionVOList();
            if (CollectionUtils.isEmpty(lstState)) {
                return;
            }
            lstState.clear();
    }
    
}
