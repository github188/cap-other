/******************************************************************************
 * Copyright (C) 2016 ShenZhen ComTop Information Technology Co.,Ltd
 * All Rights Reserved.
 * 本软件为深圳康拓普开发研制。未经本公司正式书面同意，其他任何个人、团体不得使用、
 * 复制、修改或发布本软件.
 *****************************************************************************/

package com.comtop.cap.test.definition.model;

import javax.xml.bind.annotation.XmlElement;
import javax.xml.bind.annotation.XmlRootElement;
import javax.xml.bind.annotation.XmlTransient;

import comtop.org.directwebremoting.annotations.DataTransferObject;

/**
 * 动态组合节点
 *
 * @author lizhongwen
 * @since jdk1.6
 * @version 2016年6月23日 lizhongwen
 */
@XmlRootElement(name = "dynamic")
@DataTransferObject
public class DynamicStep extends CombineStep {
    
    /** 序列化ID */
    private static final long serialVersionUID = 1L;
    
    /** 扫描器 */
    private String scan;
    
    /**
     * @return 获取 scan属性值
     */
    @XmlElement(name = "scan")
    public String getScan() {
        return scan;
    }
    
    /**
     * @param scan 设置 scan 属性值为参数值 scan
     */
    public void setScan(String scan) {
        this.scan = scan;
    }
    
    /**
     * @see com.comtop.cap.test.definition.model.StepDefinition#getStepType()
     */
    @Override
    @XmlTransient
    public StepType getStepType() {
        return StepType.DYNAMIC;
    }
}
