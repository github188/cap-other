/******************************************************************************
 * Copyright (C) 2015 ShenZhen ComTop Information Technology Co.,Ltd
 * All Rights Reserved.
 * 本软件为深圳康拓普开发研制。未经本公司正式书面同意，其他任何个人、团体不得使用、
 * 复制、修改或发布本软件.
 *****************************************************************************/

package com.comtop.cap.bm.biz.items.model;

import java.util.List;
import java.util.Map;

import javax.persistence.Column;
import javax.persistence.Id;
import javax.persistence.Table;

import com.comtop.cap.bm.biz.common.model.BizBaseVO;
import com.comtop.cap.bm.biz.flow.model.BizProcessInfoVO;
import comtop.org.directwebremoting.annotations.DataTransferObject;

/**
 * 业务事项
 * 
 * @author 姜子豪
 * @since 1.0
 * @version 2015-11-11 姜子豪
 */
@DataTransferObject
@Table(name = "CAP_BIZ_ITEMS")
public class BizItemsVO extends BizBaseVO {
    
    /** 序列化ID */
    private static final long serialVersionUID = 1L;
    
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
    
    /** 业务说明 */
    @Column(name = "BIZ_DESC", length = 4000)
    private String bizDesc;
    
    /** 引用文件 */
    @Column(name = "REFERENCE_FILE", length = 4000)
    private String referenceFile;
    
    /** 管理要点 */
    @Column(name = "MANAGE_POINTS", length = 4000)
    private String managePoints;
    
    /** 备注 */
    @Column(name = "REMARK", length = 2000)
    private String remark;
    
    /** 所属业务域 */
    private String belongDomain;
    
    /** 关键字 */
    private String keywords;
    
    /** 业务流程清单 */
    private List<BizProcessInfoVO> bizProcessList;
    
    /** 业务事项角色关联 */
    private List<BizItemsRoleVO> bizItemsRoleList;
    
    /** 业务事项角色关联名称 */
    private String roleNames;
    
    /** 业务事项和角色的关系适用范围 */
    private Map<String, String> rolesMap;
    
    /**查询关键字*/
    private String keyWords;
    
    /** 编码表达式 */
    private static final String codeExpr = "BI-${seq('BizItems',10,1,1)}";
    
    /**
     * @return 获取 codeExpr属性值
     */
    public static String getCodeExpr() {
        return codeExpr;
    }
    
    /**
     * @return 获取 bizProcessList属性值
     */
    public List<BizProcessInfoVO> getBizProcessList() {
        return bizProcessList;
    }
    
    /**
     * @param bizProcessList 设置 bizProcessList 属性值为参数值 bizProcessList
     */
    public void setBizProcessList(List<BizProcessInfoVO> bizProcessList) {
        this.bizProcessList = bizProcessList;
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
     * @return 获取 业务说明属性值
     */
    
    public String getBizDesc() {
        return bizDesc;
    }
    
    /**
     * @param bizDesc 设置 业务说明属性值为参数值 bizDesc
     */
    
    public void setBizDesc(String bizDesc) {
        this.bizDesc = bizDesc;
    }
    
    /**
     * @return 获取 引用文件属性值
     */
    
    public String getReferenceFile() {
        return referenceFile;
    }
    
    /**
     * @param referenceFile 设置 引用文件属性值为参数值 referenceFile
     */
    
    public void setReferenceFile(String referenceFile) {
        this.referenceFile = referenceFile;
    }
    
    /**
     * @return 获取 管理要点属性值
     */
    
    public String getManagePoints() {
        return managePoints;
    }
    
    /**
     * @param managePoints 设置 管理要点属性值为参数值 managePoints
     */
    
    public void setManagePoints(String managePoints) {
        this.managePoints = managePoints;
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
     * @return 获取 belongDomain属性值
     */
    public String getBelongDomain() {
        return belongDomain;
    }
    
    /**
     * @param belongDomain 设置 belongDomain 属性值为参数值 belongDomain
     */
    public void setBelongDomain(String belongDomain) {
        this.belongDomain = belongDomain;
    }
    
    /**
     * @return 获取 keywords属性值
     */
    public String getKeywords() {
        return keywords;
    }
    
    /**
     * @param keywords 设置 keywords 属性值为参数值 keywords
     */
    public void setKeywords(String keywords) {
        this.keywords = keywords;
    }
    
    /**
     * @return 获取 rolesMap属性值
     */
    public Map<String, String> getRolesMap() {
        return rolesMap;
    }
    
    /**
     * @param rolesMap 设置 rolesMap 属性值为参数值 rolesMap
     */
    public void setRolesMap(Map<String, String> rolesMap) {
        this.rolesMap = rolesMap;
    }
    
    /**
     * @return 获取 roleNames属性值
     */
    public String getRoleNames() {
        return roleNames;
    }
    
    /**
     * @param roleNames 设置 roleNames 属性值为参数值 roleNames
     */
    public void setRoleNames(String roleNames) {
        this.roleNames = roleNames;
    }
    
    /**
     * @return 获取 bizItemsRoleList属性值
     */
    public List<BizItemsRoleVO> getBizItemsRoleList() {
        return bizItemsRoleList;
    }
    
    /**
     * @param bizItemsRoleList 设置 bizItemsRoleList 属性值为参数值 bizItemsRoleList
     */
    public void setBizItemsRoleList(List<BizItemsRoleVO> bizItemsRoleList) {
        this.bizItemsRoleList = bizItemsRoleList;
    }

    /**
     *  获取查询关键字
     * @return 查询关键字
     */
	public String getKeyWords() {
		return keyWords;
	}

	/**
	 * 设置查询关键字
	 * @param keyWords 查询关键字
	 */
	public void setKeyWords(String keyWords) {
		this.keyWords = keyWords;
	}
    
}
