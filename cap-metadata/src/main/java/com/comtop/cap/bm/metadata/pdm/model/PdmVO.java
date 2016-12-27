/******************************************************************************
 * Copyright (C) 2015 ShenZhen ComTop Information Technology Co.,Ltd
 * All Rights Reserved.
 * 本软件为深圳康拓普开发研制。未经本公司正式书面同意，其他任何个人、团体不得使用、
 * 复制、修改或发布本软件.
 *****************************************************************************/

package com.comtop.cap.bm.metadata.pdm.model;

import java.util.ArrayList;
import java.util.List;

import com.comtop.cap.bm.metadata.database.dbobject.model.ReferenceVO;
import com.comtop.cap.bm.metadata.database.dbobject.model.TableVO;
import com.comtop.cap.bm.metadata.database.dbobject.model.ViewVO;
import comtop.org.directwebremoting.annotations.DataTransferObject;

/**
 * PDM字段关联关系VO
 * 
 * @author 陈志伟
 * @since 1.0
 * @version 2015-10-08 陈志伟
 */
@DataTransferObject
public class PdmVO extends PdmBaseVO {
    
    /** 数据库编码 */
    private String dBMSCode;
    
    /** 数据库名称 */
    private String dBMSName;
    
    /** 包含包集合 */
    private List<PdmPackageVO> packages;
    
    /** 包含用户 */
    private List<PdmUserVO> users = new ArrayList<PdmUserVO>();
    
    /** 包含视图 */
    private List<PdmPhysicalDiagramVO> physicalDiagrams = new ArrayList<PdmPhysicalDiagramVO>();
    
    /** 包含实体集合 */
    private List<TableVO> tables = new ArrayList<TableVO>();
    
    /** 包含视图集合 */
    private List<ViewVO> views = new ArrayList<ViewVO>();
    
    /** 包含关联关系集合 */
    private List<ReferenceVO> references = new ArrayList<ReferenceVO>();
    
    /**
     * @return 获取 dBMSCode属性值
     */
    public String getdBMSCode() {
        return dBMSCode;
    }
    
    /**
     * @param dBMSCode 设置 dBMSCode 属性值为参数值 dBMSCode
     */
    public void setdBMSCode(String dBMSCode) {
        this.dBMSCode = dBMSCode;
    }
    
    /**
     * @return 获取 dBMSName属性值
     */
    public String getdBMSName() {
        return dBMSName;
    }
    
    /**
     * @param dBMSName 设置 dBMSName 属性值为参数值 dBMSName
     */
    public void setdBMSName(String dBMSName) {
        this.dBMSName = dBMSName;
    }
    
    /**
     * @return 获取 packages属性值
     */
    public List<PdmPackageVO> getPackages() {
        return packages;
    }
    
    /**
     * @param packages 设置 packages 属性值为参数值 packages
     */
    public void setPackages(List<PdmPackageVO> packages) {
        this.packages = packages;
    }
    
    /**
     * @return 获取 users属性值
     */
    public List<PdmUserVO> getUsers() {
        return users;
    }
    
    /**
     * @param users 设置 users 属性值为参数值 users
     */
    public void setUsers(List<PdmUserVO> users) {
        this.users = users;
    }
    
    /**
     * @return 获取 physicalDiagrams属性值
     */
    public List<PdmPhysicalDiagramVO> getPhysicalDiagrams() {
        return physicalDiagrams;
    }
    
    /**
     * @param physicalDiagrams 设置 physicalDiagrams 属性值为参数值 physicalDiagrams
     */
    public void setPhysicalDiagrams(List<PdmPhysicalDiagramVO> physicalDiagrams) {
        this.physicalDiagrams = physicalDiagrams;
    }
    
    /**
     * @return 获取 tables属性值
     */
    public List<TableVO> getTables() {
        return tables;
    }
    
    /**
     * @param tables 设置 tables 属性值为参数值 tables
     */
    public void setTables(List<TableVO> tables) {
        this.tables = tables;
    }
    
    /**
     * @return 获取 views属性值
     */
    public List<ViewVO> getViews() {
        return views;
    }
    
    /**
     * @param views 设置 views 属性值为参数值 views
     */
    public void setViews(List<ViewVO> views) {
        this.views = views;
    }
    
    /**
     * @return 获取 references属性值
     */
    public List<ReferenceVO> getReferences() {
        return references;
    }
    
    /**
     * @param references 设置 references 属性值为参数值 references
     */
    public void setReferences(List<ReferenceVO> references) {
        this.references = references;
    }
    
    /**
     * @param id id
     * @return 获取 table属性值
     */
    public TableVO getPdmTableVO(String id) {
        for (TableVO table : tables) {
            if (id.equals(table.getId())) {
                return table;
            }
        }
        return null;
    }
    
    /**
     * @param id id
     * @return 获取 table属性值
     */
    public PdmUserVO getPdmUserVO(String id) {
        for (PdmUserVO user : users) {
            if (id.equals(user.getId())) {
                return user;
            }
        }
        return null;
    }
}
