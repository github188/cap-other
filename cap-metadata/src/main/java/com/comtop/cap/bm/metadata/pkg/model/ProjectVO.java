/******************************************************************************
 * Copyright (C) 2014 ShenZhen ComTop Information Technology Co.,Ltd
 * All Rights Reserved.
 * 本软件为深圳康拓普开发研制。未经本公司正式书面同意，其他任何个人、团体不得使用、
 * 复制、修改或发布本软件.
 *****************************************************************************/

package com.comtop.cap.bm.metadata.pkg.model;

import java.util.ArrayList;
import java.util.List;

import javax.persistence.Column;
import javax.persistence.Id;
import javax.persistence.Table;

import com.comtop.cap.runtime.base.model.BaseVO;
import com.comtop.cip.validator.javax.validation.constraints.NotNull;
import com.comtop.cip.validator.javax.validation.constraints.Pattern;
import com.comtop.cip.validator.org.hibernate.validator.constraints.Length;
import comtop.org.directwebremoting.annotations.DataTransferObject;

/**
 * 项目VO
 * 
 * 
 * @author 李忠文
 * @since 1.0
 * @version 2014-4-3 李忠文
 */
@DataTransferObject
@Table(name = "CIP_PROJECT_INFO")
public class ProjectVO extends BaseVO {
    
    /** 标识 */
    private static final long serialVersionUID = 1L;
    
    /** 项目Id */
    @Id
    @Column(name = "PROJECT_ID")
    private String id;
    
    /** 项目名称 */
    @NotNull
    @Pattern(regexp = "^(?!_)(?!.*?_$)[a-zA-Z0-9_]+$", message = "必须为英文字符、数字和下划线，且必须以英文字符开头。")
    @Length(max = 30)
    @Column(name = "PROJECT_NAME", length = 30)
    private String name;
    
    /** 包路径 */
    @NotNull
    @Pattern(regexp = "[a-z]+([.][a-z]+)+", message = "必须为小写英文字符，并用点进行分割。")
    @Length(max = 50)
    @Column(name = "PACKAGE_PATH", length = 50)
    private String packagePath;
    
    /** 项目简称 */
    @Pattern(regexp = "^(?!_)(?!.*?_$)[a-zA-Z0-9_]+$", message = "必须为英文字符、数字和下划线，且必须以英文字符开头。")
    private String shortName;
    
    /** 中文名称 */
    private String chineseName;
    
    /**
     * 项目类型
     */
    @Column(name = "PROJECT_TYPE")
    private int projectType;
    
    /** 父项目ID */
    @Length(max = 32)
    @Column(name = "PARENT_PROJECT_ID", length = 32)
    private String parentProjectId;
    
    /** 父项目 */
    private ProjectVO parentProject;
    
    /** 源目录 */
    @Length(max = 80)
    @Column(name = "SOURCE_DIRECTORY", length = 80)
    private String srcDir = "src/main/java";
    
    /** 源目录配置 */
    @Length(max = 80)
    @Column(name = "SOURCE_DIRECTORY_RESOURCE", length = 80)
    private String srcResourceDir = "src/main/resources";
    
    /** 测试目录 */
    @Length(max = 80)
    @Column(name = "TEST_DIRECTORY", length = 80)
    private String testDir = "src/test/java";
    
    /** 测试目录配置 */
    @Length(max = 80)
    @Column(name = "TEST_DIRECTORY_RESOURCE", length = 80)
    private String testResouceDir = "src/test/resources";
    
    /** WEB目录 */
    @Length(max = 80)
    @Column(name = "WEB_DIRECTORY", length = 80)
    private String webDir = "src/main/webapp";
    
    /** 项目依赖包 */
    private List<ProjectJarVO> jars;
    
    /**
     * @return 获取 id属性值
     */
    @Override
    public String getId() {
        return id;
    }
    
    /**
     * @param id 设置 id 属性值为参数值 id
     */
    @Override
    public void setId(String id) {
        this.id = id;
    }
    
    /**
     * @return 获取 name属性值
     */
    public String getName() {
        return name;
    }
    
    /**
     * @param name 设置 name 属性值为参数值 name
     */
    public void setName(String name) {
        this.name = name;
    }
    
    /**
     * @return 获取 packagePath属性值
     */
    public String getPackagePath() {
        return packagePath;
    }
    
    /**
     * @param packagePath 设置 packagePath 属性值为参数值 packagePath
     */
    public void setPackagePath(String packagePath) {
        this.packagePath = packagePath;
    }
    
    /**
     * @return 获取 shortName属性值
     */
    public String getShortName() {
        return shortName;
    }
    
    /**
     * @param shortName 设置 shortName 属性值为参数值 shortName
     */
    public void setShortName(String shortName) {
        this.shortName = shortName;
    }
    
    /**
     * @return 获取 chineseName属性值
     */
    public String getChineseName() {
        return chineseName;
    }
    
    /**
     * @param chineseName 设置 chineseName 属性值为参数值 chineseName
     */
    public void setChineseName(String chineseName) {
        this.chineseName = chineseName;
    }
    
    /**
     * @return 获取 projectType属性值
     */
    public int getProjectType() {
        return projectType;
    }
    
    /**
     * @param projectType 设置 projectType 属性值为参数值 projectType
     */
    public void setProjectType(int projectType) {
        this.projectType = projectType;
    }
    
    /**
     * @return 获取 parentProjectId属性值
     */
    public String getParentProjectId() {
        return parentProjectId;
    }
    
    /**
     * @param parentProjectId 设置 parentProjectId 属性值为参数值 parentProjectId
     */
    public void setParentProjectId(String parentProjectId) {
        this.parentProjectId = parentProjectId;
    }
    
    /**
     * @return 获取 parentProject属性值
     */
    public ProjectVO getParentProject() {
        return parentProject;
    }
    
    /**
     * @param parentProject 设置 parentProject 属性值为参数值 parentProject
     */
    public void setParentProject(ProjectVO parentProject) {
        this.parentProject = parentProject;
    }
    
    /**
     * @return 获取 srcDir属性值
     */
    public String getSrcDir() {
        return srcDir;
    }
    
    /**
     * @param srcDir 设置 srcDir 属性值为参数值 srcDir
     */
    public void setSrcDir(String srcDir) {
        this.srcDir = srcDir;
    }
    
    /**
     * @return 获取 srcResourceDir属性值
     */
    public String getSrcResourceDir() {
        return srcResourceDir;
    }
    
    /**
     * @param srcResourceDir 设置 srcResourceDir 属性值为参数值 srcResourceDir
     */
    public void setSrcResourceDir(String srcResourceDir) {
        this.srcResourceDir = srcResourceDir;
    }
    
    /**
     * @return 获取 testDir属性值
     */
    public String getTestDir() {
        return testDir;
    }
    
    /**
     * @param testDir 设置 testDir 属性值为参数值 testDir
     */
    public void setTestDir(String testDir) {
        this.testDir = testDir;
    }
    
    /**
     * @return 获取 testResouceDir属性值
     */
    public String getTestResouceDir() {
        return testResouceDir;
    }
    
    /**
     * @param testResouceDir 设置 testResouceDir 属性值为参数值 testResouceDir
     */
    public void setTestResouceDir(String testResouceDir) {
        this.testResouceDir = testResouceDir;
    }
    
    /**
     * @return 获取 webDir属性值
     */
    public String getWebDir() {
        return webDir;
    }
    
    /**
     * @param webDir 设置 webDir 属性值为参数值 webDir
     */
    public void setWebDir(String webDir) {
        this.webDir = webDir;
    }
    
    /**
     * @return 获取 jars属性值
     */
    public List<ProjectJarVO> getJars() {
        return jars;
    }
    
    /**
     * @param jars 设置 jars 属性值为参数值 jars
     */
    public void setJars(List<ProjectJarVO> jars) {
        this.jars = jars;
    }
    
    /**
     * 向项目中添加Jar
     * 
     * @param jar jarVO
     */
    public void addJar(ProjectJarVO jar) {
        if (null == this.jars) {
            this.jars = new ArrayList<ProjectJarVO>();
        }
        if (null != jar) {
            jar.setProjectId(this.id);
            this.jars.add(jar);
        }
    }
    
}
