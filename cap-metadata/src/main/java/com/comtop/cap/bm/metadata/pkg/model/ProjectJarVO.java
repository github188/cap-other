/******************************************************************************
 * Copyright (C) 2014 ShenZhen ComTop Information Technology Co.,Ltd
 * All Rights Reserved.
 * 本软件为深圳康拓普开发研制。未经本公司正式书面同意，其他任何个人、团体不得使用、
 * 复制、修改或发布本软件.
 *****************************************************************************/

package com.comtop.cap.bm.metadata.pkg.model;

import javax.persistence.Column;
import javax.persistence.Id;
import javax.persistence.Table;

import com.comtop.cap.runtime.base.model.BaseVO;
import com.comtop.cip.validator.org.hibernate.validator.constraints.Length;
import comtop.org.directwebremoting.annotations.DataTransferObject;

/**
 * 项目依赖包
 * 
 * @author 李忠文
 * @since 1.0
 * @version 2014-5-22 李忠文
 */
@DataTransferObject
@Table(name = "CIP_PROJECT_JAR")
public class ProjectJarVO extends BaseVO {
    
    /** 序列化ID */
    private static final long serialVersionUID = 1L;
    
    /** 项目JAR主键 */
    @Id
    @Column(name = "JAR_ID")
    private String id;
    
    /** 项目 */
    private ProjectVO project;
    
    /** 项目ID */
    @Length(max = 32)
    @Column(name = "PROJECT_ID", length = 32)
    private String projectId;
    
    /** 第三方jar包依赖 */
    @Length(max = 1000)
    @Column(name = "JAR_CONTENT", length = 1000)
    private String content;
    
    /**
     * @return 获取 id属性值
     * @see com.comtop.cap.runtime.base.model.BaseVO#getId()
     */
    @Override
    public String getId() {
        return this.id;
    }
    
    /**
     * @param id 设置 id 属性值为参数值 id
     * @see com.comtop.cap.runtime.base.model.BaseVO#setId(java.lang.String)
     */
    @Override
    public void setId(String id) {
        this.id = id;
    }
    
    /**
     * @return 获取 project属性值
     */
    public ProjectVO getProject() {
        return project;
    }
    
    /**
     * @param project 设置 project 属性值为参数值 project
     */
    public void setProject(ProjectVO project) {
        this.project = project;
    }
    
    /**
     * @return 获取 projectId属性值
     */
    public String getProjectId() {
        return projectId;
    }
    
    /**
     * @param projectId 设置 projectId 属性值为参数值 projectId
     */
    public void setProjectId(String projectId) {
        this.projectId = projectId;
    }
    
    /**
     * @return 获取 content属性值
     */
    public String getContent() {
        return content;
    }
    
    /**
     * @param content 设置 content 属性值为参数值 content
     */
    public void setContent(String content) {
        this.content = content;
    }
    
}
