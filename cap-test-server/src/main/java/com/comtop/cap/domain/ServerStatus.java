/******************************************************************************
 * Copyright (C) 2016 ShenZhen ComTop Information Technology Co.,Ltd
 * All Rights Reserved.
 * 本软件为深圳康拓普开发研制。未经本公司正式书面同意，其他任何个人、团体不得使用、
 * 复制、修改或发布本软件.
 *****************************************************************************/

package com.comtop.cap.domain;

/**
 * 服务器状态
 *
 * @author lizhongwen
 * @since jdk1.6
 * @version 2016年8月19日 lizhongwen
 */
public enum ServerStatus {
    /** 已启动 */
    STARTED,
    /** 已停止 */
    STOPPED,
    /** 已暂停 */
    SUSPENDED,
    /** 未知 */
    UNKOWN;
}
