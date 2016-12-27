/******************************************************************************
 * Copyright (C) 2015 ShenZhen ComTop Information Technology Co.,Ltd
 * All Rights Reserved.
 * 本软件为深圳康拓普开发研制。未经本公司正式书面同意，其他任何个人、团体不得使用、
 * 复制、修改或发布本软件.
 *****************************************************************************/

package com.comtop.cap.bm.biz.domain.model;

import javax.persistence.Column;
import javax.persistence.Id;
import javax.persistence.Table;

import com.comtop.top.core.base.model.CoreVO;
import comtop.org.directwebremoting.annotations.DataTransferObject;

/**
 * 业务域
 * 
 * @author 姜子豪
 * @since 1.0
 * @version 2015-11-3 姜子豪
 */
@DataTransferObject
@Table(name = "CAP_BIZ_DOMAIN")
public class BizDomainVO extends CoreVO {
    
    /** 序列化ID */
    private static final long serialVersionUID = 1L;
    
    /** 主键 */
    @Id
    @Column(name = "ID", length = 40)
    private String id;
    
    /** 编码表达式 */
    private static final String codeExpr = "DM-${seq('BizDomain',10,1,1)}";
    
    /** 父ID */
    @Column(name = "PARENT_ID", length = 40)
    private String paterId;
    
    /** 名称 */
    @Column(name = "NAME", length = 200)
    private String name;
    
    /** 序号 */
    @Column(name = "SORT_NO", length = 10)
    private int sortNo;
    
    /** 编码(业务域英文编码，譬如：资产系统：LCAM) */
    @Column(name = "CODE", length = 250)
    private String code;
    
    /** 简称 */
    @Column(name = "SHORT_NAME", length = 36)
    private String shortName;
    
    /** 备注 */
    @Column(name = "REMARK", length = 2000)
    private String remark;
    
    /**
     * @return 获取 主键属性值
     */
    
    public String getId() {
        return id;
    }
    
    /**
     * @param id 设置 主键属性值为参数值 id
     */
    
    public void setId(String id) {
        this.id = id;
    }
    
    /**
     * 获取 编码表达式
     * 
     * @return codeExpr
     */
    public static String getCodeExpr() {
        return codeExpr;
    }
    
    /**
     * @return 获取 父ID属性值
     */
    
    public String getPaterId() {
        return paterId;
    }
    
    /**
     * @param paterId 设置 父ID属性值为参数值 paterId
     */
    
    public void setPaterId(String paterId) {
        this.paterId = paterId;
    }
    
    /**
     * @return 获取 名称属性值
     */
    
    public String getName() {
        return name;
    }
    
    /**
     * @param name 设置 名称属性值为参数值 name
     */
    
    public void setName(String name) {
        this.name = name;
    }
    
    /**
     * @return 获取 编码(业务域英文编码，譬如：资产系统：LCAM)属性值
     */
    
    public String getCode() {
        return code;
    }
    
    /**
     * @param code 设置 编码(业务域英文编码，譬如：资产系统：LCAM)属性值为参数值 code
     */
    
    public void setCode(String code) {
        this.code = code;
    }
    
    /**
     * @return 获取 简称属性值
     */
    
    public String getShortName() {
        return shortName;
    }
    
    /**
     * @param shortName 设置 简称属性值为参数值 shortName
     */
    
    public void setShortName(String shortName) {
        this.shortName = shortName;
    }
    
    /**
     * @return 获取 备注属性值
     */
    
    public String getRemark() {
        return remark;
    }
    
    /**
     * @param remark 设置 备注属性值为参数值 remark
     */
    
    public void setRemark(String remark) {
        this.remark = remark;
    }
    
    /**
     * @return 获取 sortNo属性值
     */
    public int getSortNo() {
        return sortNo;
    }
    
    /**
     * @param sortNo 设置 sortNo 属性值为参数值 sortNo
     */
    public void setSortNo(int sortNo) {
        this.sortNo = sortNo;
    }
    
}
