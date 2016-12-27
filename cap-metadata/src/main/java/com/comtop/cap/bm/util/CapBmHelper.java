/******************************************************************************
 * Copyright (C) 2015 ShenZhen ComTop Information Technology Co.,Ltd
 * All Rights Reserved.
 * 本软件为深圳康拓普开发研制。未经本公司正式书面同意，其他任何个人、团体不得使用、
 * 复制、修改或发布本软件.
 *****************************************************************************/

package com.comtop.cap.bm.util;

import com.comtop.cap.doc.util.DocDataUtil;
import com.comtop.cap.runtime.component.facade.AutoGenNumberFacade;
import com.comtop.cap.runtime.core.AppBeanUtil;

/**
 * 帮助类
 *
 * @author lizhiyong
 * @since jdk1.6
 * @version 2015年12月1日 lizhiyong
 */
public class CapBmHelper {
    
    /**
     * 生成排序号
     *
     * @param key 识别码
     * @return 排序号 以Key唯一
     */
    public static Integer generateSortNo(String key) {
        String sortNoExpr = DocDataUtil.getSortNoExpr(key, null);
        AutoGenNumberFacade autoGenNumberService = AppBeanUtil.getBean(AutoGenNumberFacade.class);
        return Integer.valueOf(autoGenNumberService.genNumber(sortNoExpr, null));
    }
    
}
