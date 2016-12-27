/******************************************************************************
 * Copyright (C) 2014 ShenZhen ComTop Information Technology Co.,Ltd
 * All Rights Reserved.
 * 本软件为深圳康拓普开发研制。未经本公司正式书面同意，其他任何个人、团体不得使用、
 * 复制、修改或发布本软件.
 *****************************************************************************/

package com.comtop.cap.bm.metadata.inject.injecter.page;

import com.comtop.cap.bm.metadata.inject.injecter.IMetaDataInjecter;
import com.comtop.cap.bm.metadata.page.desinger.model.PageVO;

/**
 * 页面中的界面原型相关字段处理的注入器
 * 
 *
 * @author 凌晨
 * @since jdk1.6
 * @version 2016年1月13日 凌晨
 */
public class CrudeUIInjecter implements IMetaDataInjecter {
    
    @Override
    public void inject(Object obj, Object source) {
        PageVO page = (PageVO) source;
        page.setCrudeUIIds(null);
        page.setCrudeUINames(null);
    }
}
