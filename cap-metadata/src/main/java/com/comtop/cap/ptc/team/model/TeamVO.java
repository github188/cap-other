/******************************************************************************
 * Copyright (C) 2015 ShenZhen ComTop Information Technology Co.,Ltd
 * All Rights Reserved.
 * 本软件为深圳康拓普开发研制。未经本公司正式书面同意，其他任何个人、团体不得使用、
 * 复制、修改或发布本软件.
 *****************************************************************************/

package com.comtop.cap.ptc.team.model;

import javax.persistence.Column;
import javax.persistence.Id;
import javax.persistence.Table;

import com.comtop.top.core.base.model.CoreVO;
import comtop.org.directwebremoting.annotations.DataTransferObject;

/**
 * 项目团队基本信息
 * 
 * @author 姜子豪
 * @since 1.0
 * @version 2015-10-15 姜子豪
 */
@DataTransferObject
@Table(name = "CAP_PTC_TEAM")
public class TeamVO extends CoreVO {
    
    /** 序列化ID */
    private static final long serialVersionUID = 1L;
    
    /** 团队编号 */
    @Id
    @Column(name = "TEAM_ID", length = 32)
    private String id;
    
    /** 团队名称 */
    @Column(name = "TEAM_NAME", length = 200)
    private String teamName;
    
    /** 父团队ID */
    @Column(name = "PATER_TEAM_ID", length = 32)
    private String paterTeamId;
    
    /**
     * @return 获取 团队编号属性值
     */
    
    public String getId() {
        return id;
    }
    
    /**
     * @param id 设置 团队编号属性值为参数值 id
     */
    
    public void setId(String id) {
        this.id = id;
    }
    
    /**
     * @return 获取 团队名称属性值
     */
    
    public String getTeamName() {
        return teamName;
    }
    
    /**
     * @param teamName 设置 团队名称属性值为参数值 teamName
     */
    
    public void setTeamName(String teamName) {
        this.teamName = teamName;
    }
    
    /**
     * @return 获取 父团队ID属性值
     */
    
    public String getPaterTeamId() {
        return paterTeamId;
    }
    
    /**
     * @param paterTeamId 设置 父团队ID属性值为参数值 paterTeamId
     */
    
    public void setPaterTeamId(String paterTeamId) {
        this.paterTeamId = paterTeamId;
    }
    
}
