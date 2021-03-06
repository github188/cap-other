/******************************************************************************
 * Copyright (C) 2014 ShenZhen ComTop Information Technology Co.,Ltd
 * All Rights Reserved.
 * 本软件为深圳康拓普开发研制。未经本公司正式书面同意，其他任何个人、团体不得使用、
 * 复制、修改或发布本软件.
 *****************************************************************************/

package com.comtop.cap.bm.metadata.common.facade;

import java.util.List;

import com.comtop.cip.jodd.petite.meta.PetiteBean;
import com.comtop.cip.jodd.petite.meta.PetiteInject;
import com.comtop.cap.bm.metadata.base.model.IMetaNode;
import com.comtop.cap.bm.metadata.base.model.IMetaTree;
import com.comtop.cap.bm.metadata.common.appservice.DirectoryAppService;
import com.comtop.cap.bm.metadata.common.model.DirectoryVO;
import com.comtop.cap.runtime.base.facade.BaseFacade;

/**
 * 目录树导航表 业务逻辑处理类 门面
 * 
 * @author 李忠文
 * @since 1.0
 * @version 2014-3-17 李忠文
 */
@PetiteBean
public class DirectoryFacadeImpl extends BaseFacade implements IDirectoryFacade {
    
    /** 注入AppService **/
    @PetiteInject
    protected DirectoryAppService directoryAppService;
    
    /**
     * 更新 目录树导航节点
     * 
     * @param nodes 目录树导航节点集合
     * @return 更新结果
     * @see com.comtop.cap.bm.metadata.common.facade.IDirectoryFacade#updateNodeList(java.util.List)
     */
    @Override
    public boolean updateNodeList(final List<? extends IMetaNode> nodes) {
        return directoryAppService.updateNodeList(nodes);
    }
    
    /**
     * 删除 目录树导航节点
     * 
     * @param nodes 目录树导航节点集合
     * @see com.comtop.cap.bm.metadata.common.facade.IDirectoryFacade#deleteNodeList(java.util.List)
     */
    @Override
    public void deleteNodeList(final List<? extends IMetaNode> nodes) {
        directoryAppService.deleteNodeList(nodes);
    }
    
    /**
     * 通过 目录导航树节点ID查询节点
     * 
     * @param nodeId 节点ID
     * @return 目录导航树节点
     * @see com.comtop.cap.bm.metadata.common.facade.IDirectoryFacade#queryNodeById(java.lang.String)
     */
    @Override
    public IMetaNode queryNodeById(final String nodeId) {
        return directoryAppService.queryNodeById(nodeId);
    }
    
    /**
     * 查询当前节点的子节点
     * 
     * @param parentNodeId 父节点Id
     * @param nodeType 节点类型
     * @return 指定Id的所有子节点集合
     * @see com.comtop.cap.bm.metadata.common.facade.IDirectoryFacade#queryChildrenNodeByParentId(java.lang.String,
     *      java.lang.String[])
     */
    @Override
    public List<? extends IMetaNode> queryChildrenNodeByParentId(final String parentNodeId,
        final String... nodeType) {
        return directoryAppService.queryChildrenNodeByParentId(parentNodeId, nodeType);
    }
    
    /**
     * 查询指定关键字关键字的子节点，可以包含多种类型
     * 
     * @param parentNodeId 父节点Id
     * @param keyword 关键字
     * @param nodeType 节点类型
     * @return 指定Id的所有子节点集合
     * @see com.comtop.cap.bm.metadata.common.facade.IDirectoryFacade#queryChildrenNodeByKeyword(java.lang.String,
     *      java.lang.String, java.lang.String[])
     */
    @Override
    public List<? extends IMetaNode> queryChildrenNodeByKeyword(final String parentNodeId,
        final String keyword, final String... nodeType) {
        return directoryAppService.queryChildrenNodeByKeyword(parentNodeId, keyword, nodeType);
    }
    
    /**
     * 查询指定类型的的树，从指定的根节点ID开始
     * 
     * @param rootId 根节点ID
     * @param nodeType 树节点类型
     * @return 目录导航树，当树节点类型为空时，查询从根节点开始的整棵树
     * @see com.comtop.cap.bm.metadata.common.facade.IDirectoryFacade#queryTreeByNodeType(java.lang.String,
     *      java.lang.String[])
     */
    @Override
    public IMetaTree queryTreeByNodeType(final String rootId, final String... nodeType) {
        return directoryAppService.queryTreeByNodeType(rootId, nodeType);
    }
    
    /**
     * 查询关键字的树，可以包含多种类型，从指定的根节点ID开始
     * 
     * @param rootId 根节点ID
     * @param keyword 关键字
     * @param nodeType 树节点类型
     * @return 目录导航树,当树节点类型为空时包含所有类型
     * @see com.comtop.cap.bm.metadata.common.facade.IDirectoryFacade#queryTreeByKeyword(java.lang.String,
     *      java.lang.String, java.lang.String[])
     */
    @Override
    public IMetaTree queryTreeByKeyword(final String rootId, final String keyword,
        final String... nodeType) {
        return directoryAppService.queryTreeByKeyword(rootId, keyword, false, nodeType);
    }
    
    /**
     * 根据节点ID、节点类型判断节点是否能够被删除
     * 
     * @param nodeId 树节点ID
     * @param nodeType 树节点类型
     * @return boolean true or false 是否能被删除
     */
    @Override
    public boolean isAbleDeleteNode(final String nodeId, final String nodeType) {
        return directoryAppService.isAbleDeleteNode(nodeId, nodeType);
    }
    
    /**
     * 根据节点ID查询子节点
     * 
     * @param parentNodeId 父节点ID
     * @return 节点集合
     */
    @Override
    public List<DirectoryVO> queryChildrenNodeById(final String parentNodeId) {
        return directoryAppService.queryChildrenNodeById(parentNodeId);
    }
    
    /**
     * 查询数据表树，从指定的根节点ID开始
     * 
     * @param rootId 根节点ID
     * @param keyword 关键字
     * @return 数据表目录导航树
     * @see com.comtop.cap.bm.metadata.common.facade.IDirectoryQueryFacade#queryTableTreeByKeyword(java.lang.String,
     *      java.lang.String)
     */
    @Override
    public IMetaTree queryTableTreeByKeyword(final String rootId, final String keyword) {
        return directoryAppService.queryTableTreeByKeyword(rootId, keyword);
    }
    
    /**
     * 根据节点ID查询数据表树子节点
     * 
     * @param parentNodeId 父节点ID
     * @return 节点集合
     * @see com.comtop.cap.bm.metadata.common.facade.IDirectoryQueryFacade#queryTableChildrenNodeById(java.lang.String)
     */
    @Override
    public List<? extends IMetaNode> queryTableChildrenNodeById(final String parentNodeId) {
        return directoryAppService.queryTableChildrenNodeById(parentNodeId);
    }
    
    /**
     * 查询某个项目中指定类型的节点
     * 
     * @param projectId 项目ID
     * @param keyword 查询关键字
     * @param nodeType 节点类型
     * @return 目录导航树节点
     */
    @Override
    public List<? extends IMetaNode> queryNodeByProjectId(final String projectId, final String keyword,
        final String... nodeType) {
        return directoryAppService.queryNodeByProjectId(projectId, keyword , nodeType);
    }
    
    /**
     * 根据项目ID和关键字递归查询所有树节点
     *
     * @param projectId 项目ID
     * @param keyword 关键字
     * @param nodeType 节点类型
     * @return 返回递归查询的所有树节点
     */
    @Override
    public List<IMetaNode> queryAllIMetaNodes(final String projectId, final String keyword, final String... nodeType) {
        return directoryAppService.queryAllIMetaNodes(projectId, keyword, nodeType);
    }
    
    /**
     * 根据项目ID和关键字递归查询所有树节点
     *
     * @param metaTree 关键树
     * @return 返回递归查询的所有树节点
     */
    @Override
    public List<IMetaNode> queryAllIMetaNodes(final IMetaTree metaTree) {
        return directoryAppService.queryAllIMetaNodes(metaTree);
    }
}
