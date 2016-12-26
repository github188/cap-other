/******************************************************************************
 * Copyright (C) 2016 ShenZhen ComTop Information Technology Co.,Ltd
 * All Rights Reserved.
 * 本软件为深圳康拓普开发研制。未经本公司正式书面同意，其他任何个人、团体不得使用、
 * 复制、修改或发布本软件.
 *****************************************************************************/

package com.comtop.cap.domain;

/**
 * 执行状态
 *
 * @author lizhongwen
 * @since jdk1.6
 * @version 2016年8月22日 lizhongwen
 */
public enum ExecStatus {
    /** 等待执行 */
    WAIT,
    /** 执行失败 */
    FAILD,
    /** 执行中 */
    EXECING,
    /** 执行结束 */
    EXECED;
}
