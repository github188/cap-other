/******************************************************************************
 * Copyright (C) 2014 ShenZhen ComTop Information Technology Co.,Ltd
 * All Rights Reserved.
 * 本软件为深圳康拓普开发研制。未经本公司正式书面同意，其他任何个人、团体不得使用、
 * 复制、修改或发布本软件.
 *****************************************************************************/

package com.comtop.cap.bm.metadata.common.facade;

import java.util.List;

import com.comtop.cap.bm.metadata.base.model.IMetaNode;
import com.comtop.cap.bm.metadata.base.model.IMetaTree;
import com.comtop.cap.bm.metadata.common.model.DirectoryVO;

/**
 * 目录树导航查询接口
 * <P>
 * 目录导航树元数据是将CIP中的项目、包、实体等元数据按照树型结构进行描述，方便界面进行展示的元数据。该元数据描述项目、包、实体等元数据之间的层次关系。
 * 
 * @author 李忠文
 * @since 1.0
 * @version 2014-6-27 李忠文
 */
public interface IDirectoryQueryFacade {
    
    /**
     * 通过 目录导航树节点ID查询节点
     * 
     * @param nodeId 节点ID
     * @return 目录导航树节点
     */
    IMetaNode queryNodeById(final String nodeId);
    
    /**
     * 查询当前节点的子节点
     * 
     * @param parentNodeId 父节点Id
     * @param nodeType 节点类型
     * @return 指定Id的所有子节点集合
     */
    List<? extends IMetaNode> queryChildrenNodeByParentId(final String parentNodeId,
        final String... nodeType);
    
    /**
     * 查询指定关键字关键字的子节点，可以包含多种类型
     * 
     * @param parentNodeId 父节点Id
     * @param keyword 关键字
     * @param nodeType 节点类型
     * @return 指定Id的所有子节点集合
     */
    List<? extends IMetaNode> queryChildrenNodeByKeyword(final String parentNodeId,
        final String keyword, final String... nodeType);
    
    /**
     * 查询指定类型的的树，从指定的根节点ID开始
     * 
     * @param rootId 根节点ID
     * @param nodeType 树节点类型
     * @return 目录导航树，当树节点类型为空时，查询从根节点开始的整棵树
     */
    IMetaTree queryTreeByNodeType(final String rootId, final String... nodeType);
    
    /**
     * 查询关键字的树，可以包含多种类型，从指定的根节点ID开始
     * 
     * @param rootId 根节点ID
     * @param keyword 关键字
     * @param nodeType 树节点类型
     * @return 目录导航树,当树节点类型为空时包含所有类型
     */
    IMetaTree queryTreeByKeyword(final String rootId, final String keyword,
        final String... nodeType);
    
    /**
     * 根据节点ID查询子节点
     * 
     * @param parentNodeId 父节点ID
     * @return 节点集合
     */
    List<DirectoryVO> queryChildrenNodeById(final String parentNodeId);
    
    /**
     * 查询数据表树，从指定的根节点ID开始
     * 
     * @param rootId 根节点ID
     * @param keyword 关键字
     * @return 数据表目录导航树
     */
    IMetaTree queryTableTreeByKeyword(final String rootId, final String keyword);
    
    /**
     * 根据节点ID查询数据表树子节点
     * 
     * @param parentNodeId 父节点ID
     * @return 节点集合
     */
    List<? extends IMetaNode> queryTableChildrenNodeById(final String parentNodeId);
    
    /**
     * 查询某个项目中指定类型的节点
     * 
     * @param projectId 项目ID
     * @param keyword 查询关键字
     * @param nodeType 节点类型
     * @return 目录导航树节点
     */
    List<? extends IMetaNode> queryNodeByProjectId(final String projectId, final String keyword,
        final String... nodeType);
    
    /**
     * 根据项目ID和关键字递归查询所有树节点
     *
     * @param projectId 项目ID
     * @param keyword 关键字
     * @param nodeType 节点类型
     * @return 返回递归查询的所有树节点
     */
    List<IMetaNode> queryAllIMetaNodes(final String projectId,final String keyword, final String... nodeType);
    
    /**
     * 根据项目ID和关键字递归查询所有树节点
     *
     * @param metaTree 关键树
     * @return 返回递归查询的所有树节点
     */
    List<IMetaNode> queryAllIMetaNodes(final IMetaTree metaTree);
    
}
