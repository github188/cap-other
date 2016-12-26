/******************************************************************************
 * Copyright (C) 2016 ShenZhen ComTop Information Technology Co.,Ltd
 * All Rights Reserved.
 * 本软件为深圳康拓普开发研制。未经本公司正式书面同意，其他任何个人、团体不得使用、
 * 复制、修改或发布本软件.
 *****************************************************************************/

package com.comtop.cap.report.domain;

import java.util.List;

import javax.xml.bind.annotation.XmlElement;
import javax.xml.bind.annotation.XmlElementWrapper;
import javax.xml.bind.annotation.XmlType;

/**
 * 统计结果
 *
 * @author lizhongwen
 * @since jdk1.6
 * @version 2016年9月6日 lizhongwen
 */
@XmlType(name = "statistics")
public class Statistics {
    
    /** 总计 */
    private List<Stat> total;
    
    /** 按标签分类 */
    private List<Stat> tag;
    
    /** 按用例统计 */
    private List<Stat> suite;
    
    /**
     * @return 获取 total属性值
     */
    @XmlElementWrapper(name = "total")
    @XmlElement(name = "stat")
    public List<Stat> getTotal() {
        return total;
    }
    
    /**
     * @param total 设置 total 属性值为参数值 total
     */
    public void setTotal(List<Stat> total) {
        this.total = total;
    }
    
    /**
     * @return 获取 tag属性值
     */
    @XmlElementWrapper(name = "tag")
    @XmlElement(name = "stat")
    public List<Stat> getTag() {
        return tag;
    }
    
    /**
     * @param tag 设置 tag 属性值为参数值 tag
     */
    public void setTag(List<Stat> tag) {
        this.tag = tag;
    }
    
    /**
     * @return 获取 suite属性值
     */
    @XmlElementWrapper(name = "suite")
    @XmlElement(name = "stat")
    public List<Stat> getSuite() {
        return suite;
    }
    
    /**
     * @param suite 设置 suite 属性值为参数值 suite
     */
    public void setSuite(List<Stat> suite) {
        this.suite = suite;
    }
}
