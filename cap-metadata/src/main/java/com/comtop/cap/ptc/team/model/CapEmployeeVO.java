/******************************************************************************
 * Copyright (C) 2015 ShenZhen ComTop Information Technology Co.,Ltd
 * All Rights Reserved.
 * 本软件为深圳康拓普开发研制。未经本公司正式书面同意，其他任何个人、团体不得使用、
 * 复制、修改或发布本软件.
 *****************************************************************************/

package com.comtop.cap.ptc.team.model;

import java.sql.Timestamp;

import javax.persistence.Column;
import javax.persistence.Id;
import javax.persistence.Table;

import com.comtop.top.core.base.model.CoreVO;
import comtop.org.directwebremoting.annotations.DataTransferObject;

/**
 * 人员基本信息
 * 
 * @author 姜子豪
 * @since 1.0
 * @version 2015-10-15 姜子豪
 */
@DataTransferObject
@Table(name = "CAP_PTC_EMPLOYEE")
public class CapEmployeeVO extends CoreVO {
    
    /** 序列化ID */
    private static final long serialVersionUID = 1L;
    
    /** 人员编号 */
    @Id
    @Column(name = "EMPLOYEE_ID", length = 32)
    private String id;
    
    /** 人员姓名 */
    @Column(name = "EMPLOYEE_NAME", length = 200)
    private String employeeName;
    
    /** 人员账号 */
    @Column(name = "EMPLOYEE_ACCOUNT", length = 100)
    private String employeeAccount;
    
    /** 账号密码 */
    @Column(name = "EMPLOYEE_PASSWORD", length = 50)
    private String employeePassword;
    
    /** 工作性质 */
    @Column(name = "WORKING_PROPERTY", precision = 1)
    private Integer workingProperty;
    
    /** 学历 */
    @Column(name = "EDUCATION", precision = 1)
    private Integer education;
    
    /** 性别 */
    @Column(name = "SEX", precision = 1)
    private Integer sex;
    
    /** 入职时间 */
    @Column(name = "ENTRY_TIME", precision = 7)
    private Timestamp entryTime;
    
    /** 兴趣与专长 */
    @Column(name = "INTEREST_EXPERTISE", length = 2048)
    private String interestExpertise;
    
    /** 关联账户名称 */
    @Column(name = "RELATED_ACCOUNT", length = 32)
    private String relatedAccount;
    
    /** 关联账户ID */
    @Column(name = "RELATED_USER_ID", length = 32)
    private String relatedUserId;
    
    /** 移动电话 */
    @Column(name = "MOBILE_PHONE", length = 36)
    private String mobilePhone;
    
    /** 住宅电话 */
    @Column(name = "HOME_PHONE", length = 36)
    private String homePhone;
    
    /** 电子邮箱 */
    @Column(name = "ELECTRONIC_MAIL", length = 48)
    private String electronicMail;
    
    /** 地址 */
    @Column(name = "ADDRESS", length = 1024)
    private String address;
    
    /** 创建时间 */
    @Column(name = "CDT", precision = 7)
    private Timestamp cdt;
    
    /** 角色ID */
    private String roleSetName;
    
    /** 关系ID */
    private String relId;
    
    /** 人员所属团队 */
    private String teamId;
    
    /** 关键字 */
    private String keywords;
    
    /**
     * @return 获取 关系ID属性值
     */
    public String getRelId() {
        return relId;
    }
    
    /**
     * @param relId 设置 关系ID属性值为参数值 relId
     */
    public void setRelId(String relId) {
        this.relId = relId;
    }
    
    /**
     * @return 获取 角色ID属性值
     */
    public String getRoleSetName() {
        return roleSetName;
    }
    
    /**
     * @param roleSetName 设置 角色ID属性值为参数值 roleSetName
     */
    public void setRoleSetName(String roleSetName) {
        this.roleSetName = roleSetName;
    }
    
    /**
     * @return 获取 人员编号属性值
     */
    
    public String getId() {
        return id;
    }
    
    /**
     * @param employeeId 设置 人员编号属性值为参数值 employeeId
     */
    
    public void setId(String employeeId) {
        this.id = employeeId;
    }
    
    /**
     * @return 获取 人员姓名属性值
     */
    
    public String getEmployeeName() {
        return employeeName;
    }
    
    /**
     * @param employeeName 设置 人员姓名属性值为参数值 employeeName
     */
    
    public void setEmployeeName(String employeeName) {
        this.employeeName = employeeName;
    }
    
    /**
     * @return 获取 人员账号属性值
     */
    
    public String getEmployeeAccount() {
        return employeeAccount;
    }
    
    /**
     * @param employeeAccount 设置 人员账号属性值为参数值 employeeAccount
     */
    
    public void setEmployeeAccount(String employeeAccount) {
        this.employeeAccount = employeeAccount;
    }
    
    /**
     * @return 获取 账号密码属性值
     */
    
    public String getEmployeePassword() {
        return employeePassword;
    }
    
    /**
     * @param employeePassword 设置 账号密码属性值为参数值 employeePassword
     */
    
    public void setEmployeePassword(String employeePassword) {
        this.employeePassword = employeePassword;
    }
    
    /**
     * @return 获取 工作性质属性值
     */
    
    public Integer getWorkingProperty() {
        return workingProperty;
    }
    
    /**
     * @param workingProperty 设置 工作性质属性值为参数值 workingProperty
     */
    
    public void setWorkingProperty(Integer workingProperty) {
        this.workingProperty = workingProperty;
    }
    
    /**
     * @return 获取 学历属性值
     */
    
    public Integer getEducation() {
        return education;
    }
    
    /**
     * @param education 设置 学历属性值为参数值 education
     */
    
    public void setEducation(Integer education) {
        this.education = education;
    }
    
    /**
     * @return 获取 性别属性值
     */
    
    public Integer getSex() {
        return sex;
    }
    
    /**
     * @param sex 设置 性别属性值为参数值 sex
     */
    
    public void setSex(Integer sex) {
        this.sex = sex;
    }
    
    /**
     * @return 获取 入职时间属性值
     */
    
    public Timestamp getEntryTime() {
        return entryTime;
    }
    
    /**
     * @param entryTime 设置 入职时间属性值为参数值 entryTime
     */
    
    public void setEntryTime(Timestamp entryTime) {
        this.entryTime = entryTime;
    }
    
    /**
     * @return 获取 兴趣与专长属性值
     */
    
    public String getInterestExpertise() {
        return interestExpertise;
    }
    
    /**
     * @param interestExpertise 设置 兴趣与专长属性值为参数值 interestExpertise
     */
    
    public void setInterestExpertise(String interestExpertise) {
        this.interestExpertise = interestExpertise;
    }
    
    /**
     * @return 获取 关联账户名称属性值
     */
    
    public String getRelatedAccount() {
        return relatedAccount;
    }
    
    /**
     * @param relatedAccount 设置 关联账户名称属性值为参数值 relatedAccount
     */
    
    public void setRelatedAccount(String relatedAccount) {
        this.relatedAccount = relatedAccount;
    }
    
    /**
     * @return 获取 关联账户ID属性值
     */
    
    public String getRelatedUserId() {
        return relatedUserId;
    }
    
    /**
     * @param relatedUserId 设置 关联账户ID属性值为参数值 relatedUserId
     */
    public void setRelatedUserId(String relatedUserId) {
        this.relatedUserId = relatedUserId;
    }
    
    /**
     * @return 获取 移动电话属性值
     */
    
    public String getMobilePhone() {
        return mobilePhone;
    }
    
    /**
     * @param mobilePhone 设置 移动电话属性值为参数值 mobilePhone
     */
    
    public void setMobilePhone(String mobilePhone) {
        this.mobilePhone = mobilePhone;
    }
    
    /**
     * @return 获取 住宅电话属性值
     */
    
    public String getHomePhone() {
        return homePhone;
    }
    
    /**
     * @param homePhone 设置 住宅电话属性值为参数值 homePhone
     */
    
    public void setHomePhone(String homePhone) {
        this.homePhone = homePhone;
    }
    
    /**
     * @return 获取 电子邮箱属性值
     */
    
    public String getElectronicMail() {
        return electronicMail;
    }
    
    /**
     * @param electronicMail 设置 电子邮箱属性值为参数值 electronicMail
     */
    
    public void setElectronicMail(String electronicMail) {
        this.electronicMail = electronicMail;
    }
    
    /**
     * @return 获取 地址属性值
     */
    
    public String getAddress() {
        return address;
    }
    
    /**
     * @param address 设置 地址属性值为参数值 address
     */
    
    public void setAddress(String address) {
        this.address = address;
    }
    
    /**
     * @return 获取 团队ID属性值
     */
    public String getTeamId() {
        return teamId;
    }
    
    /**
     * @param teamId 设置 团队ID属性值为参数值 teamId
     */
    public void setTeamId(String teamId) {
        this.teamId = teamId;
    }
    
    /**
     * @return 获取 关键字属性值
     */
    public String getKeywords() {
        return keywords;
    }
    
    /**
     * @param keywords 设置 团队ID属性值为参数值 keywords
     */
    public void setKeywords(String keywords) {
        this.keywords = keywords;
    }
    
    /**
     * @return 获取 创建时间属性值
     */
    public Timestamp getCdt() {
        return cdt;
    }
    
    /**
     * @param cdt 设置 创建时间属性值为参数值 cdt
     */
    public void setCdt(Timestamp cdt) {
        this.cdt = cdt;
    }
    
}
