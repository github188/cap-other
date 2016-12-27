/******************************************************************************
 * Copyright (C) 2015 ShenZhen ComTop Information Technology Co.,Ltd
 * All Rights Reserved.
 * 本软件为深圳康拓普开发研制。未经本公司正式书面同意，其他任何个人、团体不得使用、
 * 复制、修改或发布本软件.
 *****************************************************************************/

package com.comtop.cap.doc.hld.model;

import java.util.ArrayList;
import java.util.List;

import com.comtop.cap.bm.metadata.sysmodel.model.FunctionItemVO;
import com.comtop.cap.document.word.docmodel.data.BaseDTO;

/**
 * 应用 模块 数据主题
 *
 * @author lizhiyong
 * @since jdk1.6
 * @version 2015年12月30日 lizhiyong
 */
public class PackageDTO extends BaseDTO {
    
    /** 序列号 */
    private static final long serialVersionUID = 1L;
    
    /** 下级对象集合 */
    private List<PackageDTO> childs;
    
    /** 上级 */
    private PackageDTO parent;
    
    /** 类型 */
    private int type;
    
    /** 上级id */
    private String parentId;
    
    /** 统一层次 */
    private int level;
    
    /** 类型层次 */
    private int typeLevel;
    
    /** 级联查询标志 */
    private int cascadeQuery;
    
    /** 功能项 功能子项 */
    private List<FunctionItemVO> lstFunctionItem;
    
    /**
     * @return 获取 lstFunctionItem属性值
     */
    public List<FunctionItemVO> getLstFunctionItem() {
        return lstFunctionItem;
    }
    
    /**
     * @param lstFunctionItem 设置 lstFunctionItem 属性值为参数值 lstFunctionItem
     */
    public void setLstFunctionItem(List<FunctionItemVO> lstFunctionItem) {
        this.lstFunctionItem = lstFunctionItem;
    }
    
    /**
     * @param level 设置 level 属性值为参数值 level
     */
    public void setLevel(int level) {
        this.level = level;
    }
    
    /**
     * @param typeLevel 设置 typeLevel 属性值为参数值 typeLevel
     */
    public void setTypeLevel(int typeLevel) {
        this.typeLevel = typeLevel;
    }
    
    /**
     * @return 获取 type属性值
     */
    public int getType() {
        return type;
    }
    
    /**
     * @param type 设置 type 属性值为参数值 type
     */
    public void setType(int type) {
        this.type = type;
    }
    
    /**
     * @return 获取 childs属性值
     */
    public List<PackageDTO> getChilds() {
        return childs;
    }
    
    /**
     * @param childs 设置 childs 属性值为参数值 childs
     */
    public void setChilds(List<PackageDTO> childs) {
        this.childs = childs;
    }
    
    /**
     * 添加下级
     *
     * @param child 下级
     */
    public void addChild(PackageDTO child) {
        if (this.childs == null) {
            this.childs = new ArrayList<PackageDTO>();
        }
        child.setParent(this);
        childs.add(child);
    }
    
    /**
     * @param parent 设置 parent 属性值为参数值 parent
     */
    public void setParent(PackageDTO parent) {
        this.parent = parent;
    }
    
    /**
     * @return 获取 parent属性值
     */
    public PackageDTO getParent() {
        return parent;
    }
    
    /**
     * @return 获取 parentId属性值
     */
    public String getParentId() {
        return parentId;
    }
    
    /**
     * @param parentId 设置 parentId 属性值为参数值 parentId
     */
    public void setParentId(String parentId) {
        this.parentId = parentId;
    }
    
    /**
     * 获得当前节点的类型层级
     *
     * @return 当前节点的类型层级
     */
    public int getTypeLevel() {
        if (typeLevel != 0) {
            return typeLevel;
        }
        if (this.getParent() == null) {
            return 0;
        }
        if (this.getParent().getType() != this.type) {
            return 1;
        }
        return getParent().getTypeLevel() + 1;
    }
    
    /**
     * 获得当前节点的层级
     *
     * @return 当前节点的层级
     */
    public int getLevel() {
        if (level != 0) {
            return level;
        }
        if (this.getParent() == null) {
            return 0;
        }
        return getParent().getLevel() + 1;
    }
    
    /**
     * @return 获取 cascadeQuery属性值
     */
    public int getCascadeQuery() {
        return cascadeQuery;
    }
    
    /**
     * @param cascadeQuery 设置 cascadeQuery 属性值为参数值 cascadeQuery
     */
    public void setCascadeQuery(int cascadeQuery) {
        this.cascadeQuery = cascadeQuery;
    }
    
}
