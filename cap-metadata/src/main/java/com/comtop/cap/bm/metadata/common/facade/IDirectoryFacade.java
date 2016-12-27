/******************************************************************************
 * Copyright (C) 2014 ShenZhen ComTop Information Technology Co.,Ltd
 * All Rights Reserved.
 * 本软件为深圳康拓普开发研制。未经本公司正式书面同意，其他任何个人、团体不得使用、
 * 复制、修改或发布本软件.
 *****************************************************************************/

package com.comtop.cap.bm.metadata.common.facade;

import java.util.List;

import com.comtop.cap.bm.metadata.base.model.IMetaNode;

/**
 * 目录树导航 业务逻辑处理类接口
 * 
 * @author 李忠文
 * @since 1.0
 * @version 2014-3-17 李忠文
 */
public interface IDirectoryFacade extends IDirectoryQueryFacade {
    
    /**
     * 更新 目录树导航节点
     * 
     * @param nodes 目录树导航节点集合
     * @return 更新结果
     * 
     */
    boolean updateNodeList(final List<? extends IMetaNode> nodes);
    
    /**
     * 删除 目录树导航节点
     * 
     * @param nodes 目录树导航节点集合
     * 
     */
    void deleteNodeList(final List<? extends IMetaNode> nodes);
    
    /**
     * 根据节点ID、节点类型判断节点是否能够被删除
     * 
     * @param nodeId 树节点ID
     * @param nodeType 树节点类型
     * @return boolean true or false 是否能被删除
     */
    boolean isAbleDeleteNode(final String nodeId, final String nodeType);
    
}
