/******************************************************************************
 * Copyright (C) 2016 ShenZhen ComTop Information Technology Co.,Ltd
 * All Rights Reserved.
 * 本软件为深圳康拓普开发研制。未经本公司正式书面同意，其他任何个人、团体不得使用、
 * 复制、修改或发布本软件.
 *****************************************************************************/

package com.comtop.cap.report.domain;

import javax.xml.bind.annotation.XmlEnum;

/**
 * 消息级别
 *
 * @author lizhongwen
 * @since jdk1.6
 * @version 2016年9月6日 lizhongwen
 */
@XmlEnum
public enum Level {
    /** 调试 */
    DEBUG,
    /** 跟踪 */
    TRACE,
    /** INFO */
    INFO,
    /** 警告 */
    WARN,
    /** 错误 */
    ERROR;
}
