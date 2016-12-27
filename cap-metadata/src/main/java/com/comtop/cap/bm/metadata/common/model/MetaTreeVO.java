/******************************************************************************
 * Copyright (C) 2014 ShenZhen ComTop Information Technology Co.,Ltd
 * All Rights Reserved.
 * 本软件为深圳康拓普开发研制。未经本公司正式书面同意，其他任何个人、团体不得使用、
 * 复制、修改或发布本软件.
 *****************************************************************************/

package com.comtop.cap.bm.metadata.common.model;

import java.util.ArrayList;
import java.util.List;

import com.comtop.cap.bm.metadata.base.model.IMetaNode;
import com.comtop.cap.bm.metadata.base.model.IMetaTree;

/**
 * 元数据导航树
 * 
 * @author 李忠文
 * @since 1.0
 * @version 2014-4-3 李忠文
 */
public class MetaTreeVO implements IMetaTree, IMetaNode {
    
    /** 当前树节点 */
    private IMetaNode treeNode;
    
    /** 上级树 */
    private IMetaTree parentTree;
    
    /** 子树集合 */
    private List<IMetaTree> childrenTree;
    
    /**
     * 设置当前树节点
     * 
     * @param treeNode 当前树节点
     * @see com.comtop.cap.bm.metadata.base.model.IMetaTree#setTreeNode(com.comtop.cap.bm.metadata.base.model.IMetaNode)
     */
    @Override
    public void setTreeNode(final IMetaNode treeNode) {
        this.treeNode = treeNode;
    }
    
    /**
     * 获取当前树节点
     * 
     * @return 当前树节点
     * @see com.comtop.cap.bm.metadata.base.model.IMetaTree#getTreeNode()
     */
    @Override
    public IMetaNode getTreeNode() {
        return this.treeNode;
    }
    
    /**
     * 设置当前树的父树
     * 
     * @param parentTree 父树
     * @see com.comtop.cap.bm.metadata.base.model.IMetaTree#setParentTree(com.comtop.cap.bm.metadata.base.model.IMetaTree)
     */
    @Override
    public void setParentTree(final IMetaTree parentTree) {
        this.parentTree = parentTree;
    }
    
    /**
     * @param childrenTree 设置 childrenTree 属性值为参数值 childrenTree
     */
    public void setChildrenTree(final List<IMetaTree> childrenTree) {
        this.childrenTree = childrenTree;
    }
    
    /**
     * 添加子树
     * 
     * @param childTree 子树
     * @see com.comtop.cap.bm.metadata.base.model.IMetaTree#addChildTree(com.comtop.cap.bm.metadata.base.model.IMetaTree)
     */
    @Override
    public void addChildTree(final IMetaTree childTree) {
        if (this.childrenTree == null) {
            this.childrenTree = new ArrayList<IMetaTree>();
        }
        childTree.setParentTree(this);
        this.childrenTree.add(childTree);
    }
    
    /**
     * 添加子节点
     * 
     * @param childNode 子节点
     * @return 新增节点所在的子树
     * @see com.comtop.cap.bm.metadata.base.model.IMetaTree#addChildNode(com.comtop.cap.bm.metadata.base.model.IMetaNode)
     */
    @Override
    public IMetaTree addChildNode(final IMetaNode childNode) {
        MetaTreeVO objSubTree = new MetaTreeVO();
        objSubTree.setTreeNode(childNode);
        this.addChildTree(objSubTree);
        return objSubTree;
    }
    
    /**
     * 添加子节点集合
     * 
     * @param childrenNode 子节点集合
     * @see com.comtop.cap.bm.metadata.base.model.IMetaTree#addChildrenNode(java.util.List)
     */
    @Override
    public void addChildrenNode(final List<IMetaNode> childrenNode) {
        for (IMetaNode objSubNode : childrenNode) {
            this.addChildNode(objSubNode);
        }
    }
    
    /**
     * 获取上级树点
     * 
     * @return 上级树点
     * @see com.comtop.cap.bm.metadata.base.model.IMetaTree#getParentTree()
     */
    @Override
    public IMetaTree getParentTree() {
        return this.parentTree;
    }
    
    /**
     * 获取下级子树集合
     * 
     * @return 下级子树下级子树集合
     * @see com.comtop.cap.bm.metadata.base.model.IMetaTree#getChildrenTree()
     */
    @Override
    public List<IMetaTree> getChildrenTree() {
        return this.childrenTree;
    }
    
    /**
     * 获取当前节点Id
     * 
     * @return 当前节点节点Id
     * @see com.comtop.cap.bm.metadata.base.model.IMetaNode#getNodeId()
     */
    @Override
    public String getNodeId() {
        
        return this.treeNode == null ? null : this.treeNode.getNodeId();
    }
    
    /**
     * 获取当前节点 中文名称
     * 
     * @return 当前节点中文名称
     * @see com.comtop.cap.bm.metadata.base.model.IMetaNode#getChineseName()
     */
    @Override
    public String getChineseName() {
        
        return this.treeNode == null ? null : this.treeNode.getChineseName();
    }
    
    /**
     * 获取当前节点 英文名称
     * 
     * @return 当前节点英文名称
     * @see com.comtop.cap.bm.metadata.base.model.IMetaNode#getEnglishName()
     */
    @Override
    public String getEnglishName() {
        return this.treeNode == null ? null : this.treeNode.getEnglishName();
    }
    
    /**
     * 获取当前节点描述
     * 
     * @return 当前节点描述
     * @see com.comtop.cap.bm.metadata.base.model.IMetaNode#getDescription()
     */
    @Override
    public String getDescription() {
        return this.treeNode == null ? null : this.treeNode.getDescription();
    }
    
    /**
     * 获取当前节点类型
     * 
     * @return 当前节点类型
     * @see com.comtop.cap.bm.metadata.base.model.IMetaNode#getNodeType()
     */
    @Override
    public String getNodeType() {
        return this.treeNode == null ? null : this.treeNode.getNodeType();
    }
    
    /**
     * 
     * @see com.comtop.cap.bm.metadata.base.model.IMetaNode#getTableName()
     * @return tableName or null
     */
    @Override
    public String getTableName() {
        return this.treeNode == null ? null : this.treeNode.getTableName();
    }
    
}
