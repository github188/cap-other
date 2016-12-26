/******************************************************************************
 * Copyright (C) 2016 ShenZhen ComTop Information Technology Co.,Ltd
 * All Rights Reserved.
 * 本软件为深圳康拓普开发研制。未经本公司正式书面同意，其他任何个人、团体不得使用、
 * 复制、修改或发布本软件.
 *****************************************************************************/

package com.comtop.cap.test.definition.model;

import javax.xml.bind.annotation.XmlEnum;

/**
 * 最佳实践类型
 *
 * @author lizhongwen
 * @since jdk1.6
 * @version 2016年7月11日 lizhongwen
 */
@XmlEnum
public enum PracticeType {
    
    /** 后台API */
    API,
    /** 业务服务 */
    SERVICE,
    /** 业务功能 */
    FUNCTION;
    
}
