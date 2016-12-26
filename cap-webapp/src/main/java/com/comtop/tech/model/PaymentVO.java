/******************************************************************************
 * Copyright (C) 2016 
 * ShenZhen ComTop Information Technology Co.,Ltd
 * All Rights Reserved.
 * 本软件为深圳康拓普开发研制。
 * 未经本公司正式书面同意，其他任何个人、团体不得使用、
 * 复制、修改或发布本软件.
 *****************************************************************************/
package com.comtop.tech.model;

import com.comtop.cap.runtime.base.model.CapBaseVO;
import comtop.org.directwebremoting.annotations.DataTransferObject;
import javax.persistence.Table;
import javax.persistence.Column;
import javax.persistence.Id;


/**
 * 付款单信息
 * 
 * @author CAP超级管理员
 * @since 1.0
 * @version 2016-12-12 CAP超级管理员
 */
@Table(name = "T_CT_PAYMENT")
@DataTransferObject
public class PaymentVO extends CapBaseVO {

    /** 序列化ID */
    private static final long serialVersionUID = 1L;
    
    /** 主键 */
    @Id
    @Column(name = "ID",length=36,precision=0)
    private String id;
    
    /** 付款单号 */
    @Column(name = "OD_0000004190",length=100,precision=0)
    private String od0000004190;
    
    /** 本次申请支付金额 */
    @Column(name = "OD_0000004191",length=100,precision=0)
    private String od0000004191;
    
    /** 收款单位 */
    @Column(name = "OD_0000004192",length=100,precision=0)
    private String od0000004192;
    
    /** 收款单位银行 */
    @Column(name = "OD_0000004193",length=100,precision=0)
    private String od0000004193;
    
    /** 收款单位银行账号 */
    @Column(name = "OD_0000004194",length=100,precision=0)
    private String od0000004194;
    
    /** 付款方式 */
    @Column(name = "OD_0000004195",length=100,precision=0)
    private String od0000004195;
    
    /** 资金来源 */
    @Column(name = "OD_0000004196",length=100,precision=0)
    private String od0000004196;
    
    /** 申请日期 */
    @Column(name = "OD_0000004197",length=100,precision=0)
    private String od0000004197;
    
    /** 付款类型 */
    @Column(name = "OD_0000004198",length=100,precision=0)
    private String od0000004198;
    
    /** 甲方支付银行 */
    @Column(name = "OD_0000004199",length=100,precision=0)
    private String od0000004199;
    
    /** 甲方支付账号 */
    @Column(name = "OD_0000004200",precision=10)
    private Double od0000004200;
    
	
    /**
     * @return 获取 主键 属性值
     */
    public String getId() {
        return id;
    }
    	
    /**
     * @param id 设置 主键 属性值为参数值 id
     */
    public void setId(String id) {
        this.id = id;
    }
    
    /**
     * @return 获取 付款单号 属性值
     */
    public String getOd0000004190() {
        return od0000004190;
    }
    	
    /**
     * @param od0000004190 设置 付款单号 属性值为参数值 od0000004190
     */
    public void setOd0000004190(String od0000004190) {
        this.od0000004190 = od0000004190;
    }
    
    /**
     * @return 获取 本次申请支付金额 属性值
     */
    public String getOd0000004191() {
        return od0000004191;
    }
    	
    /**
     * @param od0000004191 设置 本次申请支付金额 属性值为参数值 od0000004191
     */
    public void setOd0000004191(String od0000004191) {
        this.od0000004191 = od0000004191;
    }
    
    /**
     * @return 获取 收款单位 属性值
     */
    public String getOd0000004192() {
        return od0000004192;
    }
    	
    /**
     * @param od0000004192 设置 收款单位 属性值为参数值 od0000004192
     */
    public void setOd0000004192(String od0000004192) {
        this.od0000004192 = od0000004192;
    }
    
    /**
     * @return 获取 收款单位银行 属性值
     */
    public String getOd0000004193() {
        return od0000004193;
    }
    	
    /**
     * @param od0000004193 设置 收款单位银行 属性值为参数值 od0000004193
     */
    public void setOd0000004193(String od0000004193) {
        this.od0000004193 = od0000004193;
    }
    
    /**
     * @return 获取 收款单位银行账号 属性值
     */
    public String getOd0000004194() {
        return od0000004194;
    }
    	
    /**
     * @param od0000004194 设置 收款单位银行账号 属性值为参数值 od0000004194
     */
    public void setOd0000004194(String od0000004194) {
        this.od0000004194 = od0000004194;
    }
    
    /**
     * @return 获取 付款方式 属性值
     */
    public String getOd0000004195() {
        return od0000004195;
    }
    	
    /**
     * @param od0000004195 设置 付款方式 属性值为参数值 od0000004195
     */
    public void setOd0000004195(String od0000004195) {
        this.od0000004195 = od0000004195;
    }
    
    /**
     * @return 获取 资金来源 属性值
     */
    public String getOd0000004196() {
        return od0000004196;
    }
    	
    /**
     * @param od0000004196 设置 资金来源 属性值为参数值 od0000004196
     */
    public void setOd0000004196(String od0000004196) {
        this.od0000004196 = od0000004196;
    }
    
    /**
     * @return 获取 申请日期 属性值
     */
    public String getOd0000004197() {
        return od0000004197;
    }
    	
    /**
     * @param od0000004197 设置 申请日期 属性值为参数值 od0000004197
     */
    public void setOd0000004197(String od0000004197) {
        this.od0000004197 = od0000004197;
    }
    
    /**
     * @return 获取 付款类型 属性值
     */
    public String getOd0000004198() {
        return od0000004198;
    }
    	
    /**
     * @param od0000004198 设置 付款类型 属性值为参数值 od0000004198
     */
    public void setOd0000004198(String od0000004198) {
        this.od0000004198 = od0000004198;
    }
    
    /**
     * @return 获取 甲方支付银行 属性值
     */
    public String getOd0000004199() {
        return od0000004199;
    }
    	
    /**
     * @param od0000004199 设置 甲方支付银行 属性值为参数值 od0000004199
     */
    public void setOd0000004199(String od0000004199) {
        this.od0000004199 = od0000004199;
    }
    
    /**
     * @return 获取 甲方支付账号 属性值
     */
    public Double getOd0000004200() {
        return od0000004200;
    }
    	
    /**
     * @param od0000004200 设置 甲方支付账号 属性值为参数值 od0000004200
     */
    public void setOd0000004200(Double od0000004200) {
        this.od0000004200 = od0000004200;
    }
    
	 
    /**
     * 获取主键值
     * @return 主键值
     */
    @Override
    public String getPrimaryValue(){
    		return  this.id;
    }
}