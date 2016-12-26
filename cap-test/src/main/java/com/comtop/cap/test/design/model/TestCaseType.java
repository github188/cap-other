/******************************************************************************
 * Copyright (C) 2016 ShenZhen ComTop Information Technology Co.,Ltd
 * All Rights Reserved.
 * 本软件为深圳康拓普开发研制。未经本公司正式书面同意，其他任何个人、团体不得使用、
 * 复制、修改或发布本软件.
 *****************************************************************************/

package com.comtop.cap.test.design.model;

import javax.xml.bind.annotation.XmlEnum;

/**
 * 用例类型
 *
 * @author lizhongwen
 * @since jdk1.6
 * @version 2016年6月23日 lizhongwen
 */
@XmlEnum
public enum TestCaseType {
    
    /** 后台API */
    API,
    /** 业务服务 */
    SERVICE,
    /** 业务功能 */
    FUNCTION;
    
    @Override
    public String toString() {
        return this.name();
    }
    
}
