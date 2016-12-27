/******************************************************************************
 * Copyright (C) 2014 ShenZhen ComTop Information Technology Co.,Ltd
 * All Rights Reserved.
 * 本软件为深圳康拓普开发研制。未经本公司正式书面同意，其他任何个人、团体不得使用、
 * 复制、修改或发布本软件.
 *****************************************************************************/

package com.comtop.cap.bm.metadata.base.model;

import java.util.List;

/**
 * 元数据树
 * 
 * 
 * @author 李忠文
 * @since 1.0
 * @version 2014-4-3 李忠文
 */
public interface IMetaTree {
    
    /**
     * 设置当前树节点
     * 
     * @param treeNode 当前树节点
     */
    void setTreeNode(final IMetaNode treeNode);
    
    /**
     * 获取当前树节点
     * 
     * @return 当前树节点
     */
    IMetaNode getTreeNode();
    
    /**
     * 设置当前树的父树
     * 
     * @param parentTree 父树
     */
    void setParentTree(final IMetaTree parentTree);
    
    /**
     * 获取上级树点
     * 
     * @return 上级树点
     */
    IMetaTree getParentTree();
    
    /**
     * 获取下级子树集合
     * 
     * @return 下级子树下级子树集合
     */
    List<IMetaTree> getChildrenTree();
    
    /**
     * 添加子树
     * 
     * @param childTree 子树
     */
    void addChildTree(final IMetaTree childTree);
    
    /**
     * 添加子节点
     * 
     * @param childNode 子节点
     * @return 新增节点所在的子树
     */
    IMetaTree addChildNode(final IMetaNode childNode);
    
    /**
     * 添加子节点集合
     * 
     * @param childrenNode 子节点集合
     */
    void addChildrenNode(final List<IMetaNode> childrenNode);
}
