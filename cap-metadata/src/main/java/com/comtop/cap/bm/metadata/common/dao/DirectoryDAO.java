/******************************************************************************
 * Copyright (C) 2014 ShenZhen ComTop Information Technology Co.,Ltd
 * All Rights Reserved.
 * 本软件为深圳康拓普开发研制。未经本公司正式书面同意，其他任何个人、团体不得使用、
 * 复制、修改或发布本软件.
 *****************************************************************************/

package com.comtop.cap.bm.metadata.common.dao;

import java.util.HashMap;
import java.util.List;
import java.util.Map;

import com.comtop.cap.bm.metadata.base.model.IMetaNode;
import com.comtop.cap.bm.metadata.common.model.DirectoryVO;
import com.comtop.cip.jodd.petite.meta.PetiteBean;
import com.comtop.cip.jodd.util.StringUtil;
import com.comtop.cip.runtime.base.dao.BaseDAO;

/**
 * 目录树导航表 数据访问接口类
 * 
 * @author 李忠文
 * @since 1.0
 * @version 2014-3-17 李忠文
 */
@PetiteBean
public class DirectoryDAO extends BaseDAO<DirectoryVO> {
    
    /**
     * 删除目录树节点对象
     * 
     * @param dir 待删除目录树节点对象
     * @param mappingTables model所映射的表名
     * @return 成功与否
     * @see com.comtop.cip.runtime.base.dao.BaseDAO#delete(java.lang.Object, java.lang.String[])
     */
    @Override
    public boolean delete(final DirectoryVO dir, final String... mappingTables) {
        String strId = dir.getId();
        List<? extends IMetaNode> lstChildren = this.queryChildrenNodeByKeyword(strId, null, false);
        if (lstChildren != null && lstChildren.size() > 0) {
            // throw new MetaDataException("不能删除仍有子节点的节点{0}。", dir.getEnglishName());
        }
        return super.delete(dir, mappingTables);
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
        Map<String, Object> objParam = new HashMap<String, Object>();
        objParam.put("projectId", projectId);
        objParam.put("nodeTypes", nodeType);
        String strKeyword = null;
        if (StringUtil.isNotBlank(keyword)) {
            strKeyword = "%" + keyword + "%";
        }
        objParam.put("keyword", strKeyword);
        return queryList("queryNodeByProjectId", objParam);
    }
    
    /**
     * 查询当前节点的兄弟节点，可以指定兄弟节点的类型
     * 
     * @param nodeId 节点Id
     * @param nodeType 节点类型集合
     * @return 当前节点的兄弟节点集合
     */
    public List<? extends IMetaNode> queryBrotherNodesByNodeId(final String nodeId, final String... nodeType) {
        DirectoryVO objParam = new DirectoryVO();
        objParam.setId(nodeId);
        DirectoryVO objCurrentNode = this.load(objParam);
        // 找不到当前节点或者当前节点没有父节点
        if (objCurrentNode == null || StringUtil.isEmpty(objCurrentNode.getParentNodeId())) {
            return null;
        }
        String strParentId = objCurrentNode.getParentNodeId();
        return this.queryChildrenNodeByKeyword(strParentId, null, false, nodeType);
    }
    
    /**
     * 查询当前节点的叔父节点，可以指定叔父节点的类型
     * 
     * @param nodeId 节点Id
     * @param nodeType 节点类型集合
     * @return 当前节点的叔父节点集合
     */
    public List<? extends IMetaNode> queryUncleNodesByNodeId(final String nodeId, final String... nodeType) {
        DirectoryVO objParam = new DirectoryVO();
        objParam.setId(nodeId);
        DirectoryVO objCurrentNode = this.load(objParam);
        // 找不到当前节点或者当前节点没有父节点
        if (objCurrentNode == null || StringUtil.isEmpty(objCurrentNode.getParentNodeId())) {
            return null;
        }
        String strParentId = objCurrentNode.getParentNodeId();
        objParam.setId(strParentId);
        DirectoryVO objParentNode = this.load(objParam);
        // 找不到当前节点没有父节点或者祖父节点不存在
        if (objParentNode == null || StringUtil.isEmpty(objParentNode.getParentNodeId())) {
            return null;
        }
        String strGrandparentId = objParentNode.getParentNodeId();
        return this.queryChildrenNodeByKeyword(strGrandparentId, null, false, nodeType);
    }
    
    /**
     * 查询指定关键字关键字的子节点，可以包含多种类型
     * 
     * @param parentNodeId 父节点Id
     * @param keyword 关键字
     * @param isForTable 是否查询数据表元数据
     * @param nodeType 节点类型
     * @return 指定Id的所有子节点集合
     */
    public List<DirectoryVO> queryChildrenNodeByKeyword(final String parentNodeId, final String keyword,
        final boolean isForTable, final String... nodeType) {
        Map<String, Object> objParam = new HashMap<String, Object>();
        objParam.put("parentNodeId", parentNodeId);
        String strKeyword = null;
        if (StringUtil.isNotBlank(keyword)) {
            strKeyword = "%" + keyword + "%";
        }
        objParam.put("keyword", strKeyword);
        objParam.put("isForTable", isForTable);
        objParam.put("nodeTypes", nodeType);
        return queryList("queryChildrenNodeByKeyword", objParam);
    }
    
    /**
     * 查询指定条件的树
     * 
     * @param keyword 关键字
     * @param nodeType 节点类型
     * @return 指定Id的所有子节点集合
     */
    public List<DirectoryVO> queryNodeTreeByParam(final String keyword, final String... nodeType) {
        Map<String, Object> objParam = new HashMap<String, Object>();
        String strKeyword = null;
        if (StringUtil.isNotBlank(keyword)) {
            strKeyword = "%" + keyword + "%";
        }
        objParam.put("keyword", strKeyword);
        objParam.put("nodeTypes", nodeType);
        return queryList("queryNodeTreeByParam_" + this.getDataBaseType().toUpperCase(), objParam);
    }
    
    /**
     * 根据节点ID查询子节点
     * 
     * @param parentNodeId 父节点ID
     * @return 节点集合
     */
    public List<DirectoryVO> queryChildrenNodeById(final String parentNodeId) {
        Map<String, Object> objParam = new HashMap<String, Object>();
        objParam.put("parentNodeId", parentNodeId);
        return this.queryList("queryChildrenNodeById", objParam);
    }
}
