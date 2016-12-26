/******************************************************************************
 * Copyright (C) 2016 ShenZhen ComTop Information Technology Co.,Ltd
 * All Rights Reserved.
 * 本软件为深圳康拓普开发研制。未经本公司正式书面同意，其他任何个人、团体不得使用、
 * 复制、修改或发布本软件.
 *****************************************************************************/

package com.comtop.cap.document.word.docconfig.datatype;

import javax.xml.bind.annotation.XmlEnum;

/**
 * 数据存储策略。配置此策略，主要用于告诉解析程序是否将相关的数据填充到对应的DTO中。
 *
 * @author lizhiyong
 * @since jdk1.6
 * @version 2016年1月18日 lizhiyong
 */
@XmlEnum
public enum DataStoreStrategy {
    
    /**
     * 此值为默认值。全存 不管数据什么样子，都映射到DTO的属性中。
     * 
     * <pre>
     * &lt;td width="10" mappingTo="bizRole.name"&gt; 名称 &lt;/td&gt;
     * </pre>
     */
    STORE,
    
    /**
     * 全不存。不管数据什么样子，都不映射到DTO的属性中 如：
     * 
     * <pre>
     * &lt; td width="1.5" mappingTo="bizRole.sortIndex"   storeStrategy="NO_STORE" &gt;序号&lt;/td &gt;
     * </pre>
     */
    NO_STORE,
    
    /**
     * 空值不存。数据为空时，不映射到DTO的属性中。非空时映射到DTO的属性中 比如
     * 
     * <pre>
     * &lt;td mappingTo="bizProcessInfo.code" storeStrategy="NULL_VALUE_NO_STORE"&gt;
     * 流程编码&lt;/td &gt;
     * </pre>
     */
    NULL_VALUE_NO_STORE;
}
