/******************************************************************************
 * Copyright (C) 2015 ShenZhen ComTop Information Technology Co.,Ltd
 * All Rights Reserved.
 * 本软件为深圳康拓普开发研制。未经本公司正式书面同意，其他任何个人、团体不得使用、
 * 复制、修改或发布本软件.
 *****************************************************************************/

package com.comtop.cap.document.word.parse.util;

/**
 * 业务数据比较器,用于判断业务对象能否匹配指定的条件，用于解析word文档时进行前端过滤。目前未用
 *
 * @author lizhiyong
 * @since jdk1.6
 * @version 2015年11月25日 lizhiyong
 */
public interface IBizDataComparator {
    
    /**
     * 比较业务对象是否符合条件
     *
     * @param obj 业务对象
     * @param condition 条件 每个条件的形式如"name:value"
     * @return 0 相等 <0 obj小于条件 >0 obj大于条件
     */
    int compare(Object obj, String... condition);
}
