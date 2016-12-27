/******************************************************************************
 * Copyright (C) 2015 ShenZhen ComTop Information Technology Co.,Ltd
 * All Rights Reserved.
 * 本软件为深圳康拓普开发研制。未经本公司正式书面同意，其他任何个人、团体不得使用、
 * 复制、修改或发布本软件.
 *****************************************************************************/

package com.comtop.cap.bm.biz.info.model;

import java.util.List;

import javax.persistence.Column;
import javax.persistence.Id;
import javax.persistence.Table;

import com.comtop.cap.bm.biz.common.model.BizBaseVO;
import comtop.org.directwebremoting.annotations.DataTransferObject;

/**
 * 业务对象基本信息
 * 
 * @author CAP
 * @since 1.0
 * @version 2015-11-10 CAP
 */
@DataTransferObject
@Table(name = "CAP_BIZ_OBJ_INFO")
public class BizObjInfoVO extends BizBaseVO {
    
    /** 序列化ID */
    private static final long serialVersionUID = 1L;
    
    /** 根据关系RelData生成业务对象数据项集合,由CIP自动创建。 */
    private List<BizObjDataItemVO> dataItems;
    
    /** 主键 */
    @Id
    @Column(name = "ID", length = 40)
    private String id;
    
    /** 编码 */
    @Column(name = "CODE", length = 250)
    private String code;
    
    /** 名称 */
    @Column(name = "NAME", length = 200)
    private String name;
    
    /** 说明 */
    @Column(name = "DESCRIPTION", length = 2000)
    private String description;
    
    /** 所属包id */
    @Column(name = "PACKAGE_ID", length = 40)
    private String packageId;
    
    /** 是否是包 */
    @Column(name = "PACKAGE_FLAG", precision = 1)
    private int packageFlag;
    
    /** 关键字，用于模糊查询 */
    private String keyWords;
    
    /** 域Id列表 */
    private List<String> domainIdList;
    
    /** 编码表达式 */
    public static final String CODE_EXPR = "BO-${seq('BizObject',10,1,1)}";
    
    /** 序号表达式 */
    public static final String SORT_NO_EXPR = "${seq('BizObject-${domainId}',4,1,1)}";
    
    /**
     * @return 获取 codeExpr属性值
     */
    public static String getCodeExpr() {
        return CODE_EXPR;
    }
    
    /**
     * @return 获取 packageId属性值
     */
    public String getPackageId() {
        return packageId;
    }
    
    /**
     * @param packageId 设置 packageId 属性值为参数值 packageId
     */
    public void setPackageId(String packageId) {
        this.packageId = packageId;
    }
    
    /**
     * @return 获取 dataItems属性值
     */
    public List<BizObjDataItemVO> getDataItems() {
        return dataItems;
    }
    
    /**
     * @param dataItems 设置 dataItems 属性值为参数值 dataItems
     */
    public void setDataItems(List<BizObjDataItemVO> dataItems) {
        this.dataItems = dataItems;
    }
    
    /**
     * @return 获取 packageFlag属性值
     */
    public int getPackageFlag() {
        return packageFlag;
    }
    
    /**
     * @param packageFlag 设置 packageFlag 属性值为参数值 packageFlag
     */
    public void setPackageFlag(int packageFlag) {
        this.packageFlag = packageFlag;
    }
    
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
     * @return 获取 编码属性值
     */
    
    public String getCode() {
        return code;
    }
    
    /**
     * @param code 设置 编码属性值为参数值 code
     */
    
    public void setCode(String code) {
        this.code = code;
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
     * @return 获取 说明属性值
     */
    
    public String getDescription() {
        return description;
    }
    
    /**
     * @param description 设置 说明属性值为参数值 description
     */
    
    public void setDescription(String description) {
        this.description = description;
    }
    
    /**
     * @return 获取 keyWords属性值
     */
    public String getKeyWords() {
        return keyWords;
    }
    
    /**
     * @param keyWords 设置 keyWords 属性值为参数值 keyWords
     */
    public void setKeyWords(String keyWords) {
        this.keyWords = keyWords;
    }
    
    /**
     * @return 获取 domainIdList属性值
     */
    public List<String> getDomainIdList() {
        return domainIdList;
    }
    
    /**
     * @param domainIdList 设置 domainIdList 属性值为参数值 domainIdList
     */
    public void setDomainIdList(List<String> domainIdList) {
        this.domainIdList = domainIdList;
    }
    
}
