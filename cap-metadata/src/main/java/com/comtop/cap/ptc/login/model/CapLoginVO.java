/******************************************************************************
 * Copyright (C) 2015 ShenZhen ComTop Information Technology Co.,Ltd
 * All Rights Reserved.
 * 本软件为深圳康拓普开发研制。未经本公司正式书面同意，其他任何个人、团体不得使用、
 * 复制、修改或发布本软件.
 *****************************************************************************/

package com.comtop.cap.ptc.login.model;

import javax.servlet.http.Cookie;

import com.comtop.top.component.common.systeminit.TopServletListener;
import com.comtop.top.core.base.model.CoreVO;

/**
 * 建模登陆模型
 *
 * @author 丁庞
 * @since jdk1.6
 * @version 2015年9月21日 丁庞
 */
public class CapLoginVO extends CoreVO {
    
    /** FIXME */
    private static final long serialVersionUID = 1562310596117223957L;

    /** 登陆账号 */
    private String account;
    
    /** 人员编号 */
    private String bmEmployeeId;
    
    /** 用户名称 */
    private String bmEmployeeName;
    
    /** 团队编号 */
    private String bmTeamId;
    
    /** 团队名称 */
    private String bmTeamName;
    
    /** 登陆密码 */
    private String password;
    
    /** 客户端cookie */
    private Cookie cookie;
    
    /** 验证码 */
    private boolean validateCode;
    
    /** 关联账户 */
    private String relatedAccount;
    
    /** 跳转路径 */
    private String redirectUrl;
    
    /** 角色ID */
    private String roleIds;
    
    /**
     * @return roleIds
     */
    public String getRoleIds() {
        return roleIds;
    }
    
    /**
     * 
     * @param roleIds 角色Ids
     */
    public void setRoleIds(String roleIds) {
        this.roleIds = roleIds;
    }
    
    /**
     * @return 关联账户
     */
    public String getRelatedAccount() {
        return relatedAccount;
    }
    
    /**
     * 
     * @param relatedAccount 关联账户
     */
    public void setRelatedAccount(String relatedAccount) {
        this.relatedAccount = relatedAccount;
    }
    
    /**
     * @return account
     */
    public String getAccount() {
        TopServletListener.getSession().removeAttribute("user");
        
        // .getAttribute("user").
        return account;
    }
    
    /**
     * @param account 登陆账号
     */
    public void setAccount(String account) {
        this.account = account;
    }
    
    /**
     * @return 人员编号
     */
    public String getBmEmployeeId() {
        return bmEmployeeId;
    }
    
    /**
     * @param bmEmployeeId 人员id
     */
    public void setBmEmployeeId(String bmEmployeeId) {
        this.bmEmployeeId = bmEmployeeId;
    }
    
    /**
     * @return bmEmployeeName
     */
    public String getBmEmployeeName() {
        return bmEmployeeName;
    }
    
    /**
     * @param bmEmployeeName 人员名称
     */
    public void setBmEmployeeName(String bmEmployeeName) {
        this.bmEmployeeName = bmEmployeeName;
    }
    
    /**
     * @return bmTeamId
     */
    public String getBmTeamId() {
        return bmTeamId;
    }
    
    /**
     * @param bmTeamId 团队id
     */
    public void setBmTeamId(String bmTeamId) {
        this.bmTeamId = bmTeamId;
    }
    
    /**
     * @return bmTeamName
     */
    public String getBmTeamName() {
        return bmTeamName;
    }
    
    /**
     * @param bmTeamName 团队名称
     */
    public void setBmTeamName(String bmTeamName) {
        this.bmTeamName = bmTeamName;
    }
    
    /**
     * @return password
     */
    public String getPassword() {
        return password;
    }
    
    /**
     * @param password 登陆密码
     */
    public void setPassword(String password) {
        this.password = password;
    }
    
    /**
     * @return cookie
     */
    public Cookie getCookie() {
        return cookie;
    }
    
    /**
     * @param cookie 客户端cookie
     */
    public void setCookie(Cookie cookie) {
        this.cookie = cookie;
    }
    
    /**
     * @return validateCode
     */
    public boolean getValidateCode() {
        return validateCode;
    }
    
    /**
     * 
     * @param validateCode 验证码
     */
    public void setValidateCode(boolean validateCode) {
        this.validateCode = validateCode;
    }
    
    /**
     * @return 跳转路径
     */
    public String getRedirectUrl() {
        return redirectUrl;
    }
    
    /**
     * @param redirectUrl 跳转路径
     */
    public void setRedirectUrl(String redirectUrl) {
        this.redirectUrl = redirectUrl;
    }
    
}
