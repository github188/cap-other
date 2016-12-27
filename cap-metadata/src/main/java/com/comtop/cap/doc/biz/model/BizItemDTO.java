/******************************************************************************
 * Copyright (C) 2015 ShenZhen ComTop Information Technology Co.,Ltd
 * All Rights Reserved.
 * 本软件为深圳康拓普开发研制。未经本公司正式书面同意，其他任何个人、团体不得使用、
 * 复制、修改或发布本软件.
 *****************************************************************************/

package com.comtop.cap.doc.biz.model;

import java.util.ArrayList;
import java.util.List;
import java.util.Map;

import com.comtop.cap.document.word.docmodel.data.BaseDTO;
import comtop.org.directwebremoting.annotations.DataTransferObject;

/**
 * 业务事项DTO
 * 
 * @author 李志勇
 * @since 1.0
 * @version 2015-11-11 李志勇
 */
@DataTransferObject
public class BizItemDTO extends BaseDTO {
    
    /** 序列化ID */
    private static final long serialVersionUID = 1L;
    
    /** 业务说明 */
    private String bizDesc;
    
    /** 把控策略(指导型，负责型) */
    private String managePolicy;
    
    /** 统一规范策略(全局统一型，地市统一型) */
    private String normPolicy;
    
    /** 引用文件 */
    private String referenceFile;
    
    /** 管理要点 */
    private String managePoints;
    
    /** 业务事项和角色的关系适用范围 */
    private Map<String, String> rolesMap;
    
    /** 业务流程清单 */
    private List<BizProcessDTO> bizProcessList;
    
    /** 一级业务 */
    private String firstLevelBiz;
    
    /** 二级业务 */
    private String secondLevelBiz;
    
    /** 所属业务域DTO */
    private BizDomainDTO bizDomainDTO;
    
    /** 角色集合 */
    private List<BizRoleDTO> bizRoles;
    
    /**
     * @return 获取 bizProcessList属性值
     */
    public List<BizProcessDTO> getBizProcessList() {
        return bizProcessList;
    }
    
    /**
     * @param bizProcesss 设置 bizProcessList 属性值为参数值 bizProcessList
     */
    public void addBizProcessList(List<BizProcessDTO> bizProcesss) {
        if (bizProcesss != null && bizProcesss.size() > 0) {
            for (BizProcessDTO bizProcessDTO : bizProcesss) {
                addBizProcessDTO(bizProcessDTO);
            }
        }
    }
    
    /**
     * @param bizProcessList 设置 bizProcessList 属性值为参数值 bizProcessList
     */
    public void setBizProcessList(List<BizProcessDTO> bizProcessList) {
        this.bizProcessList = bizProcessList;
    }
    
    /**
     * 添加一个流程
     *
     * @param bizProcessDTO 流程
     */
    public void addBizProcessDTO(BizProcessDTO bizProcessDTO) {
        if (bizProcessList == null) {
            bizProcessList = new ArrayList<BizProcessDTO>();
        }
        bizProcessList.add(bizProcessDTO);
        bizProcessDTO.setBizItem(this);
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
     * @return 获取 指导型，负责型属性值
     */
    
    public String getManagePolicy() {
        return managePolicy;
    }
    
    /**
     * @param managePolicy 设置 指导型，负责型属性值为参数值 managePolicy
     */
    
    public void setManagePolicy(String managePolicy) {
        this.managePolicy = managePolicy;
    }
    
    /**
     * @return 获取 全局统一型，地市统一型属性值
     */
    
    public String getNormPolicy() {
        return normPolicy;
    }
    
    /**
     * @param normPolicy 设置 全局统一型，地市统一型属性值为参数值 normPolicy
     */
    
    public void setNormPolicy(String normPolicy) {
        this.normPolicy = normPolicy;
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
     * @return 获取 firstLevelBiz属性值
     */
    public String getFirstLevelBiz() {
        return firstLevelBiz;
    }
    
    /**
     * @param firstLevelBiz 设置 firstLevelBiz 属性值为参数值 firstLevelBiz
     */
    public void setFirstLevelBiz(String firstLevelBiz) {
        this.firstLevelBiz = firstLevelBiz;
    }
    
    /**
     * @return 获取 secondLevelBiz属性值
     */
    public String getSecondLevelBiz() {
        return secondLevelBiz;
    }
    
    /**
     * @param secondLevelBiz 设置 secondLevelBiz 属性值为参数值 secondLevelBiz
     */
    public void setSecondLevelBiz(String secondLevelBiz) {
        this.secondLevelBiz = secondLevelBiz;
    }
    
    /**
     * @return 获取 bizDomainDTO属性值
     */
    public BizDomainDTO getBizDomainDTO() {
        return bizDomainDTO;
    }
    
    /**
     * @param bizDomainDTO 设置 bizDomainDTO 属性值为参数值 bizDomainDTO
     */
    public void setBizDomainDTO(BizDomainDTO bizDomainDTO) {
        this.bizDomainDTO = bizDomainDTO;
    }
    
    /**
     * @return 获取 bizRoles属性值
     */
    public List<BizRoleDTO> getBizRoles() {
        return bizRoles;
    }
    
    /**
     * @param bizRoles 设置 bizRoles 属性值为参数值 bizRoles
     */
    public void setBizRoles(List<BizRoleDTO> bizRoles) {
        this.bizRoles = bizRoles;
    }
}
