/******************************************************************************
 * Copyright (C) 2014 ShenZhen ComTop Information Technology Co.,Ltd
 * All Rights Reserved.
 * 本软件为深圳康拓普开发研制。未经本公司正式书面同意，其他任何个人、团体不得使用、
 * 复制、修改或发布本软件.
 *****************************************************************************/

package com.comtop.cap.bm.metadata.common.appservice;

import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import com.comtop.cap.bm.metadata.base.model.IMetaNode;
import com.comtop.cap.bm.metadata.base.model.IMetaTree;
import com.comtop.cap.bm.metadata.common.dao.DirectoryDAO;
import com.comtop.cap.bm.metadata.common.model.DirectoryVO;
import com.comtop.cap.bm.metadata.common.model.MetaTreeVO;
import com.comtop.cap.bm.metadata.common.model.NodeType;
import com.comtop.cap.runtime.base.appservice.BaseAppService;
import com.comtop.cip.common.util.ArrayUtils;
import com.comtop.cip.jodd.jtx.JtxPropagationBehavior;
import com.comtop.cip.jodd.jtx.meta.Transaction;
import com.comtop.cip.jodd.petite.meta.PetiteBean;
import com.comtop.cip.jodd.petite.meta.PetiteInject;
import com.comtop.cip.jodd.util.StringUtil;
import com.comtop.corm.resource.util.CollectionUtils;

/**
 * 目录导航树业务逻辑处理类
 * 
 * @author 李忠文
 * @since 1.0
 * @version 2014-3-17 李忠文
 */
@PetiteBean
public class DirectoryAppService extends BaseAppService {
    
    /** 注入DAO **/
    @PetiteInject
    protected DirectoryDAO directoryDAO;
    
    /**
     * 新增 目录树导航节点
     * 
     * @param node 导航节点
     * @param parentNodeId 导航节点Id
     * @return 目录树导航表
     * 
     */
    @Transaction(propagation = JtxPropagationBehavior.PROPAGATION_REQUIRED, readOnly = false)
    public String insertNode(final IMetaNode node, final String parentNodeId) {
        DirectoryVO objParentDir = null;
        if (StringUtil.isNotBlank(parentNodeId)) {
            objParentDir = (DirectoryVO) this.queryNodeById(parentNodeId);
        }
        DirectoryVO objDirVO;
        if (node instanceof DirectoryVO) {
            objDirVO = (DirectoryVO) node;
        } else {
            objDirVO = new DirectoryVO();
            if (StringUtil.isNotBlank(node.getNodeId())) {
                objDirVO.setId(node.getNodeId());
            }
            objDirVO.setChineseName(node.getChineseName());
            objDirVO.setDescription(node.getDescription());
            objDirVO.setEnglishName(node.getEnglishName());
            objDirVO.setTableName(node.getTableName());
            objDirVO.setNodeType(node.getNodeType());
        }
        objDirVO.setParentNodeId(parentNodeId);
        if (!NodeType.PROJECT_NODE.equals(objDirVO.getNodeType()) && objParentDir != null) {
            // 如果当前不为项目根节点，那么它的项目ID必须与父节点的一致
            objDirVO.setProjectId(objParentDir.getProjectId());
        }
        String strDirId = (String) directoryDAO.insert(objDirVO);
        if (NodeType.PROJECT_NODE.equals(objDirVO.getNodeType())) { // 当前节点为项目根节点，其项目ID就是自己的ID
            objDirVO.setProjectId(strDirId);
            directoryDAO.update(objDirVO);
        }
        return strDirId;
    }
    
    /**
     * 更新 目录导航树集合
     * 
     * @param nodes 目录树导航节点集合
     * @return 更新成功与否
     * 
     */
    @Transaction(propagation = JtxPropagationBehavior.PROPAGATION_REQUIRED, readOnly = false)
    public boolean updateNodeList(final List<? extends IMetaNode> nodes) {
        if (nodes == null) {
            return true;
        }
        List<DirectoryVO> lstDir = new ArrayList<DirectoryVO>();
        DirectoryVO objDir;
        for (IMetaNode objNode : nodes) {
            if (objNode instanceof DirectoryVO) {
                lstDir.add((DirectoryVO) objNode);
                continue;
            }
            objDir = (DirectoryVO) this.queryNodeById(objNode.getNodeId());
            if (objDir == null) {
                continue;
            }
            objDir.setChineseName(objNode.getChineseName());
            objDir.setDescription(objNode.getDescription());
            objDir.setEnglishName(objNode.getEnglishName());
            objDir.setTableName(objNode.getTableName());
            lstDir.add(objDir);
        }
        return directoryDAO.update(lstDir) == nodes.size();
    }
    
    /**
     * 删除 目录树节点
     * 
     * @param nodes 目录树节点集合
     */
    @Transaction(propagation = JtxPropagationBehavior.PROPAGATION_REQUIRED, readOnly = false)
    public void deleteNodeList(final List<? extends IMetaNode> nodes) {
        if (nodes == null) {
            return;
        }
        List<DirectoryVO> lstDir = new ArrayList<DirectoryVO>();
        DirectoryVO objDir;
        for (IMetaNode objNode : nodes) {
            if (objNode == null) {
                continue;
            }
            if (objNode instanceof DirectoryVO) {
                objDir = (DirectoryVO) objNode;
            } else {
                objDir = new DirectoryVO();
                objDir.setId(objNode.getNodeId());
            }
            lstDir.add(objDir);
        }
        directoryDAO.delete(lstDir);
    }
    
    /**
     * 通过 目录导航树节点ID查询节点
     * 
     * @param nodeId 节点ID
     * @return 目录导航树节点
     */
    public IMetaNode queryNodeById(final String nodeId) {
        DirectoryVO objParam = new DirectoryVO();
        objParam.setId(nodeId);
        return directoryDAO.load(objParam);
    }
    
    /**
     * 查询某个项目中指定类型的节点
     * 
     * @param projectId 项目ID
     * @param keyword 查询关键字
     * @param nodeType 节点类型
     * @return 目录导航树节点
     */
    public List<? extends IMetaNode> queryNodeByProjectId(final String projectId, final String keyword,
        final String... nodeType) {
        return directoryDAO.queryNodeByProjectId(projectId, keyword, nodeType);
    }
    
    /**
     * 查询当前节点的兄弟节点，可以指定兄弟节点的类型
     * 
     * @param nodeId 节点Id
     * @param nodeType 节点类型集合
     * @return 当前节点的兄弟节点集合
     */
    public List<? extends IMetaNode> queryBrotherNodesByNodeId(final String nodeId, final String... nodeType) {
        return directoryDAO.queryBrotherNodesByNodeId(nodeId, nodeType);
    }
    
    /**
     * 查询当前节点的叔父节点，可以指定叔父节点的类型
     * 
     * @param nodeId 节点Id
     * @param nodeType 节点类型集合
     * @return 当前节点的叔父节点集合
     */
    public List<? extends IMetaNode> queryUncleNodesByNodeId(final String nodeId, final String... nodeType) {
        return directoryDAO.queryUncleNodesByNodeId(nodeId, nodeType);
    }
    
    /**
     * 查询当前节点的子节点
     * 
     * @param parentNodeId 父节点Id
     * @param nodeType 节点类型集合
     * @return 指定Id的所有子节点集合
     */
    public List<? extends IMetaNode> queryChildrenNodeByParentId(final String parentNodeId, final String... nodeType) {
        return directoryDAO.queryChildrenNodeByKeyword(parentNodeId, null, false, nodeType);
    }
    
    /**
     * 查询指定关键字关键字的子节点，可以包含多种类型
     * 
     * @param parentNodeId 父节点Id
     * @param keyword 关键字
     * @param nodeType 节点类型
     * @return 指定Id的所有子节点集合
     */
    public List<? extends IMetaNode> queryChildrenNodeByKeyword(final String parentNodeId, final String keyword,
        final String... nodeType) {
        return directoryDAO.queryChildrenNodeByKeyword(parentNodeId, keyword, false, nodeType);
    }
    
    /**
     * 查询指定类型的的树，从指定的根节点ID开始
     * 
     * @param rootId 根节点ID
     * @param nodeType 树节点类型
     * @return 目录导航树，当树节点类型为空时，查询从根节点开始的整棵树
     */
    public IMetaTree queryTreeByNodeType(final String rootId, final String... nodeType) {
        return this.queryTreeByKeyword(rootId, null, false, nodeType);
    }
    
    /**
     * 查询关键字的树，可以包含多种类型，从指定的根节点ID开始
     * 
     * @param rootId 根节点ID
     * @param keyword 关键字
     * @param isForTable 是否查询表的元数据
     * @param nodeType 树节点类型
     * @return 目录导航树,当树节点类型为空时包含所有类型
     */
    public IMetaTree queryTreeByKeyword(final String rootId, final String keyword, final boolean isForTable,
        final String... nodeType) {
        // 先查询根节点，如果根节点不存在，则直接返回空
        DirectoryVO objRoot = (DirectoryVO) this.queryNodeById(rootId);
        if (objRoot == null) {
            return null;
        }
        
        IMetaTree objTree = new MetaTreeVO();
        objTree.setTreeNode(objRoot);
        // appendChildWithParams(objTree, keyword, nodeType); //由于该方法只能用于Oracle，暂时换另一种方式。
        if (StringUtil.isBlank(keyword) && ArrayUtils.isEmpty(nodeType)) {
            this.queryTreeByRootId(rootId, isForTable, objTree);
        } else {
            Map<String, IMetaTree> objMapTree = new HashMap<String, IMetaTree>();
            objMapTree.put(rootId, objTree);
            this.queryTreeWithParams(objMapTree, rootId, keyword, isForTable, nodeType);
        }
        return objTree;
    }
    
    /**
     * 根据查询参数构造整棵树
     * 
     * 
     * @param mateTreeMap 树映射集合,以当前树节点的Id为key,IMetaTree为值
     * @param rootId 根节点Id
     * @param keyword 关键字
     * @param isForTable 是否查询表的元数据
     * @param nodeType 节点类型
     */
    public void queryTreeWithParams(final Map<String, IMetaTree> mateTreeMap, final String rootId,
        final String keyword, final boolean isForTable, final String... nodeType) {
        List<DirectoryVO> lstDir = directoryDAO.queryChildrenNodeByKeyword(null, keyword, isForTable, nodeType);
        findParentTree(mateTreeMap, rootId, lstDir);
    }
    
    /**
     * 根据根节点构造整棵树
     * 
     * @param parentNodeId 根节点ID
     * @param isForTable 是否查询表的元数据
     * @param tree 目录导航树
     */
    public void queryTreeByRootId(final String parentNodeId, final boolean isForTable, final IMetaTree tree) {
        List<DirectoryVO> lstDir = directoryDAO.queryChildrenNodeByKeyword(parentNodeId, null, false);
        if (CollectionUtils.isEmpty(lstDir)) {
            return;
        }
        IMetaTree objSubTree;
        String strSubNodeId;
        for (DirectoryVO objDir : lstDir) {
            String strNodeType = objDir.getNodeType();
            strSubNodeId = objDir.getNodeId();
            if (isForTable && NodeType.ENTITY_NODE.equals(strNodeType) && StringUtil.isBlank(objDir.getTableName())) {
                continue;
            }
            objSubTree = tree.addChildNode(objDir);
            queryTreeByRootId(strSubNodeId, isForTable, objSubTree);
        }
    }
    
    /**
     * 查找指定节点集合的父节点
     * 
     * 
     * @param mateTreeMap 树映射集合,以当前树节点的Id为key,IMetaTree为值
     * @param rootId 根节点Id
     * @param dirs 需要查询父节点的目录
     */
    public void findParentTree(final Map<String, IMetaTree> mateTreeMap, final String rootId,
        final List<DirectoryVO> dirs) {
        if (CollectionUtils.isEmpty(dirs)) { // 当前集合为空，则直接返回
            return;
        }
        String strParentId;
        String strId;
        DirectoryVO objParentDir;
        IMetaTree objPrarentTree;
        IMetaTree objCurrentTree;
        List<DirectoryVO> lstParentDir = new ArrayList<DirectoryVO>();
        for (DirectoryVO objDir : dirs) { // 遍历所有节点进行处理
            strId = objDir.getNodeId();
            if (rootId.equals(strId)) { // 该节点就是根，则忽略
                continue;
            }
            strParentId = objDir.getParentNodeId();
            if (StringUtil.isBlank(strParentId)) { // 除了根节点，其他接都应该有父节点
                continue;
            }
            objCurrentTree = mateTreeMap.get(strId); // 该已经存在，并且已经有的父节点
            if (objCurrentTree != null && objCurrentTree.getParentTree() != null) {
                continue;
            }
            // 获取父节点树
            objPrarentTree = mateTreeMap.get(strParentId);
            if (objPrarentTree == null) { // 当父节点树不能存在则需要重新查询，并构造，新查询出来的树节点需要继续查找祖父节点
                objParentDir = (DirectoryVO) this.queryNodeById(strParentId);
                if (objParentDir == null) {
                    continue;
                }
                lstParentDir.add(objParentDir);
                objPrarentTree = new MetaTreeVO();
                objPrarentTree.setTreeNode(objParentDir);
                mateTreeMap.put(strParentId, objPrarentTree);
            }
            
            if (objCurrentTree == null) {
                IMetaTree objSubTree = objPrarentTree.addChildNode(objDir);
                mateTreeMap.put(strId, objSubTree);
            } else {
                objPrarentTree.addChildTree(objCurrentTree);
            }
        }
        findParentTree(mateTreeMap, rootId, lstParentDir);
    }
    
    /**
     * 根据节点ID、节点类型判断节点是否能够被删除
     * 
     * @param nodeId 树节点ID
     * @param nodeType 树节点类型
     * @return boolean true or false 是否能被删除
     */
    public boolean isAbleDeleteNode(final String nodeId, final String nodeType) {
        boolean objFlag = true;
        // 首先判断节点类型是包类型还是实体类型
        // 如果是包类型，则判断节点下是否有子节点
        if (NodeType.PKG_NODE.equals(nodeType)) {
            List<DirectoryVO> lstChildNodes = this.queryChildrenNodeById(nodeId);
            if (lstChildNodes.size() > 0) {
                objFlag = false;
            }
        }
        
        // 如果是实体类型，则判断数据库相关表中是否存在和实体关联的数据
        // 关联表：CIP_ENTITY、CIP_ENTITY_ATTRIBUTE、CIP_METHOD_CASCADE、
        // CIP_ENTITY_RELATIONSHIP、CIP_ENTITY_METHOD、CIP_METHOD_PARAMETER
        if (NodeType.ENTITY_NODE.equals(nodeType)) {
            // 查询记录总数
            int iTotalCount = 0;
            // 1、查询当前节点ID实体是否存在除自己之外的子实体
            iTotalCount = queryChildEntityCount(nodeId);
            if (iTotalCount > 0) {
                objFlag = false;
                return objFlag;
            }
            // 2、查询当前节点实体是否为除自己之外其他实体的目标/源实体，即被建立了关联关系的实体
            iTotalCount = queryRelationshipEntityCount(nodeId);
            if (iTotalCount > 0) {
                objFlag = false;
                return objFlag;
            }
            // 3、查询当前实体是否为除自己之外的其他实体方法的参数或者返回值
            iTotalCount = queryRelMethodParamCount(nodeId);
            if (iTotalCount > 0) {
                objFlag = false;
                return objFlag;
            }
            // 4、查询当前实体是否为除自己之外的其他实体方法的返回值
            iTotalCount = queryRelMethodReturnValCount(nodeId);
            if (iTotalCount > 0) {
                objFlag = false;
                return objFlag;
            }
            // 5、查询当前实体是否为除自己之外其他实体的关系级联属性
            iTotalCount = queryEntityAssArrtCount(nodeId);
            if (iTotalCount > 0) {
                objFlag = false;
                return objFlag;
            }
        }
        return objFlag;
    }
    
    /**
     * 查询当前节点ID实体是否存在除自己之外的子实体
     * 
     * @param nodeId 节点ID
     * @return 子节点个数
     */
    public int queryChildEntityCount(final String nodeId) {
        return (Integer) directoryDAO.selectOne("queryChildEntityCount", nodeId);
    }
    
    /**
     * 查询当前节点实体是否为除自己之外其他实体的目标/源实体，即被建立了关联关系的实体
     * 
     * @param nodeId 节点ID
     * @return 源实体记录数
     */
    public int queryRelationshipEntityCount(final String nodeId) {
        return (Integer) directoryDAO.selectOne("queryRelationshipEntityCount", nodeId);
    }
    
    /**
     * 查询当前实体是否为除自己之外的其他实体方法的参数或者返回值
     * 
     * @param nodeId 节点ID
     * @return 记录数
     */
    public int queryRelMethodParamCount(final String nodeId) {
        return (Integer) directoryDAO.selectOne("queryRelMethodParamCount", nodeId);
    }
    
    /**
     * 查询当前实体是否为除自己之外的其他实体方法的返回值
     * 
     * @param nodeId 节点ID
     * @return 记录数
     */
    public int queryRelMethodReturnValCount(final String nodeId) {
        return (Integer) directoryDAO.selectOne("queryRelMethodReturnValCount", nodeId);
    }
    
    /**
     * 查询当前实体是否为除自己之外其他实体的关系级联属性
     * 
     * @param nodeId 节点ID
     * @return 记录数
     */
    public int queryEntityAssArrtCount(final String nodeId) {
        return (Integer) directoryDAO.selectOne("queryEntityAssArrtCount", nodeId);
    }
    
    /**
     * 根据节点ID查询子节点
     * 
     * @param parentNodeId 父节点ID
     * @return 节点集合
     */
    public List<DirectoryVO> queryChildrenNodeById(final String parentNodeId) {
        return directoryDAO.queryChildrenNodeById(parentNodeId);
    }
    
    /**
     * 查询数据表树，从指定的根节点ID开始
     * 
     * @param rootId 根节点ID
     * @param keyword 关键字
     * @return 数据表目录导航树
     */
    public IMetaTree queryTableTreeByKeyword(final String rootId, final String keyword) {
        return this.queryTreeByKeyword(rootId, keyword, true);
    }
    
    /**
     * 根据节点ID查询数据表树子节点
     * 
     * @param parentNodeId 父节点ID
     * @return 节点集合
     */
    public List<? extends IMetaNode> queryTableChildrenNodeById(String parentNodeId) {
        return directoryDAO.queryChildrenNodeByKeyword(parentNodeId, null, true);
    }
    
    /**
     * 根据项目ID和关键字递归查询所有树节点
     *
     * @param projectId 项目ID
     * @param keyword 关键字
     * @param nodeType 节点类型
     * @return 返回递归查询的所有树节点
     */
    public List<IMetaNode> queryAllIMetaNodes(final String projectId, final String keyword, final String... nodeType) {
        IMetaTree objIMetaTree = this.queryTreeByKeyword(projectId, keyword, false, nodeType);
        List<IMetaNode> lstIMetaNodes = new ArrayList<IMetaNode>();
        if (objIMetaTree != null) {
            lstIMetaNodes.add(objIMetaTree.getTreeNode());
            lstIMetaNodes = this.getAllImetaNodes(objIMetaTree.getChildrenTree(), lstIMetaNodes);
        }
        return lstIMetaNodes;
    }
    
    /**
     * 递归方法查询所有树节点
     * 
     * @param metaTrees 节点树
     * @param metaNodes 树节点
     * @return 树节点
     */
    private List<IMetaNode> getAllImetaNodes(List<IMetaTree> metaTrees, List<IMetaNode> metaNodes) {
        if (CollectionUtils.isEmpty(metaTrees)) {
            return metaNodes;
        }
        for (IMetaTree objMetaTree : metaTrees) {
            IMetaNode objIMetaNode = objMetaTree.getTreeNode();
            metaNodes.add(objIMetaNode);
            List<IMetaTree> lstChlIMetaTree = objMetaTree.getChildrenTree();
            this.getAllImetaNodes(lstChlIMetaTree, metaNodes);
        }
        return metaNodes;
    }
    
    /**
     * 根据项目ID和关键字递归查询所有树节点
     *
     * @param metaTree 关键树
     * @return 返回递归查询的所有树节点
     */
    public List<IMetaNode> queryAllIMetaNodes(final IMetaTree metaTree) {
        List<IMetaNode> lstIMetaNodes = new ArrayList<IMetaNode>();
        if (metaTree != null) {
            lstIMetaNodes.add(metaTree.getTreeNode());
            lstIMetaNodes = this.getAllImetaNodes(metaTree.getChildrenTree(), lstIMetaNodes);
        }
        return lstIMetaNodes;
    }
}
