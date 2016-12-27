/******************************************************************************
 * Copyright (C) 2015 ShenZhen ComTop Information Technology Co.,Ltd
 * All Rights Reserved.
 * 本软件为深圳康拓普开发研制。未经本公司正式书面同意，其他任何个人、团体不得使用、
 * 复制、修改或发布本软件.
 *****************************************************************************/

package com.comtop.cap.ptc.notice.model;

import java.sql.Timestamp;

import javax.persistence.Column;
import javax.persistence.Id;
import javax.persistence.Table;

import com.comtop.top.core.base.model.CoreVO;
import comtop.org.directwebremoting.annotations.DataTransferObject;

/**
 * 公告基本信息
 * 
 * @author CAP
 * @since 1.0
 * @version 2015-9-25 CAP
 */
@DataTransferObject
@Table(name = "CAP_PTC_NOTICE")
public class CapPtcNoticeVO extends CoreVO {
    
    /** 序列化ID */
    private static final long serialVersionUID = 1L;
    
    /** 主键 */
    @Id
    @Column(name = "ID", length = 32)
    private String id;
    
    /** 公告标题 */
    @Column(name = "TITLE", length = 200)
    private String title;
    
    /** 公告类型 */
    @Column(name = "TYPE", length = 20)
    private String type;
    
    /** 公告内容 */
    @Column(name = "CONTENT", length = 4000)
    private String content;
    
    /** 公告创建人ID */
    @Column(name = "CREATOR_ID", length = 32)
    private String creatorId;
    
    /** 公告创建人姓名 */
    @Column(name = "CREATOR_NAME", length = 50)
    private String creatorName;
    
    /** 创建时间 */
    @Column(name = "CDT", precision = 11)
    private Timestamp cdt;
    
    /** 创建时间查询开始值 */
    private Timestamp cdtStart;
    
    /** 创建时间查询结束值 */
    private Timestamp cdtEnd;
    
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
     * @return 获取 公告标题属性值
     */
    
    public String getTitle() {
        return title;
    }
    
    /**
     * @param title 设置 公告标题属性值为参数值 title
     */
    
    public void setTitle(String title) {
        this.title = title;
    }
    
    /**
     * @return 获取 公告类型属性值
     */
    
    public String getType() {
        return type;
    }
    
    /**
     * @param type 设置 公告类型属性值为参数值 type
     */
    
    public void setType(String type) {
        this.type = type;
    }
    
    /**
     * @return 获取 公告内容属性值
     */
    
    public String getContent() {
        return content;
    }
    
    /**
     * @param content 设置 公告内容属性值为参数值 content
     */
    
    public void setContent(String content) {
        this.content = content;
    }
    
    /**
     * @return 获取 公告创建人ID属性值
     */
    
    public String getCreatorId() {
        return creatorId;
    }
    
    /**
     * @param creatorId 设置 公告创建人ID属性值为参数值 creatorId
     */
    
    public void setCreatorId(String creatorId) {
        this.creatorId = creatorId;
    }
    
    /**
     * @return 获取 公告创建人姓名属性值
     */
    
    public String getCreatorName() {
        return creatorName;
    }
    
    /**
     * @param creatorName 设置 公告创建人姓名属性值为参数值 creatorName
     */
    
    public void setCreatorName(String creatorName) {
        this.creatorName = creatorName;
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
    
    /**
     * @return 获取 创建时间查询开始值属性值
     */
    
    public Timestamp getCdtStart() {
        return cdtStart;
    }
    
    /**
     * @param cdtStart 设置 创建时间查询开始值属性值为参数值 cdtStart
     */
    
    public void setCdtStart(Timestamp cdtStart) {
        this.cdtStart = cdtStart;
    }
    
    /**
     * @return 获取 创建时间查询结束值属性值
     */
    
    public Timestamp getCdtEnd() {
        return cdtEnd;
    }
    
    /**
     * @param cdtEnd 设置 创建时间查询结束值属性值为参数值 cdtEnd
     */
    
    public void setCdtEnd(Timestamp cdtEnd) {
        this.cdtEnd = cdtEnd;
    }
    
}
