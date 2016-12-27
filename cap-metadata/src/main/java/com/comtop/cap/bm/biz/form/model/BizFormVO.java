/******************************************************************************
 * Copyright (C) 2015 ShenZhen ComTop Information Technology Co.,Ltd
 * All Rights Reserved.
 * 本软件为深圳康拓普开发研制。未经本公司正式书面同意，其他任何个人、团体不得使用、
 * 复制、修改或发布本软件.
 *****************************************************************************/

package com.comtop.cap.bm.biz.form.model;

import java.util.List;

import javax.persistence.Column;
import javax.persistence.Id;
import javax.persistence.Table;

import com.comtop.cap.bm.biz.common.model.BizBaseVO;
import com.comtop.cap.bm.biz.flow.model.BizProcessNodeVO;
import comtop.org.directwebremoting.annotations.DataTransferObject;

/**
 * 业务表单
 * 
 * @author 姜子豪
 * @since 1.0
 * @version 2015-11-17 姜子豪
 */
@DataTransferObject
@Table(name = "CAP_BIZ_FORM")
public class BizFormVO extends BizBaseVO {
    
    /** 序列化ID */
    private static final long serialVersionUID = 1L;
    
    /** 业务表单数据项 */
    private List<BizFormDataVO> dataItems;
    
    /** 业务节点清单 */
    private List<BizProcessNodeVO> bizProcessNodes;
    
    /** 主键 */
    @Id
    @Column(name = "ID", length = 40)
    private String id;
    
    /** 名称 */
    @Column(name = "NAME", length = 200)
    private String name;
    
    /** 编码 */
    @Column(name = "CODE", length = 250)
    private String code;
    
    /** 备注 */
    @Column(name = "REMARK", length = 2000)
    private String remark;
    
    /** 附件ID */
    @Column(name = "ATTACHMENT_ID", length = 40)
    private String attachmentId;
    
    /** keywords */
    private String keyWords;
    
    /** 所属包id */
    @Column(name = "PACKAGE_ID", length = 40)
    private String packageId;
    
    /** 是否是包 1是 0否 */
    @Column(name = "PACKAGE_FLAG", precision = 1)
    private int packageFlag;
    
    /** 域Id列表 */
    private List<String> domainIdList;
    
    /** 编码表达式 */
    private static final String codeExpr = "BF-${seq('BizForm',10,1,1)}";
    
    /**
     * @return 获取 codeExpr属性值
     */
    public static String getCodeExpr() {
        return codeExpr;
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
     * @return 获取 bizProcessNodes属性值
     */
    public List<BizProcessNodeVO> getBizProcessNodes() {
        return bizProcessNodes;
    }
    
    /**
     * @param bizProcessNodes 设置 bizProcessNodes 属性值为参数值 bizProcessNodes
     */
    public void setBizProcessNodes(List<BizProcessNodeVO> bizProcessNodes) {
        this.bizProcessNodes = bizProcessNodes;
    }
    
    /**
     * @return 获取 dataItems属性值
     */
    public List<BizFormDataVO> getDataItems() {
        return dataItems;
    }
    
    /**
     * @param dataItems 设置 dataItems 属性值为参数值 dataItems
     */
    public void setDataItems(List<BizFormDataVO> dataItems) {
        this.dataItems = dataItems;
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
     * @return 获取 attachmentId属性值
     */
    public String getAttachmentId() {
        return attachmentId;
    }
    
    /**
     * @param attachmentId 设置 attachmentId 属性值为参数值 attachmentId
     */
    public void setAttachmentId(String attachmentId) {
        this.attachmentId = attachmentId;
    }
    
    /**
     * @return 获取 keywords属性值
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
