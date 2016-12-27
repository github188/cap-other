/******************************************************************************
 * Copyright (C) 2014 ShenZhen ComTop Information Technology Co.,Ltd
 * All Rights Reserved.
 * 本软件为深圳康拓普开发研制。未经本公司正式书面同意，其他任何个人、团体不得使用、
 * 复制、修改或发布本软件.
 *****************************************************************************/

package com.comtop.cap.bm.metadata.common.facade;

import java.util.List;

import com.comtop.cip.json.JSONObject;
import com.comtop.cap.bm.metadata.common.model.MetadataNodeVO;
import com.comtop.cap.bm.metadata.common.model.MetadataVersionVO;

/**
 * 元数据版本化 业务逻辑处理类接口
 * 
 * @author 沈康
 * @since 1.0
 * @version 2014-6-6 沈康
 */
public interface IMetadataVersionFacade {
    
    /**
     * 根据节点ID获取元数据
     * 
     * @param nodeId 节点ID
     * @return 返回封装好元数据的JSONObject
     */
    JSONObject getMetadataByNodeId(final String nodeId);
    
    /**
     * 根据节点ID拼装JSON文件名称
     * 
     * @param nodeId 节点ID
     * @return JSON文件名称
     */
    String getJSONFileName(final String nodeId);
    
    /**
     * 节点对应元数据VO
     * 
     * @param nodeId 节点ID
     * @return 节点对应元数据信息
     */
    MetadataNodeVO getMetadataNodeVOByNodeId(final String nodeId);
    
    /**
     * 根据节点ID将元数据信息同步到中心数据库
     * 
     * @param nodeId 节点
     * @return 是否同步成功
     */
    boolean syncMetadataToCenterDB(final String nodeId);
    
    /**
     * 根据节点集合从中心数据库更新元数据到本地
     * 
     * @param nodeIds 节点集合
     * @return 是否更新成功
     */
    boolean updateMetadataFromCenterDB(final List<String> nodeIds);
    
    /**
     * 元数据锁定方法
     * 
     * @param nodeId 节点ID
     */
    void metadataLock(final String nodeId);
    
    /**
     * 元数据解锁方法
     * 
     * @param nodeId 节点ID
     */
    void metadataUnLock(final String nodeId);
    
    /**
     * 根据节点ID获取元数据版本VO
     * 
     * @param nodeId 节点ID
     * @return 元数据版本信息
     */
    MetadataVersionVO getMetadataVersionVOByNodeId(final String nodeId);
    
    /**
     * 根据节点ID查询节点是否被本人锁定
     * 
     * @param nodeId 节点ID
     * @return true锁定 false未锁定
     */
    boolean metadataIsLocked(final String nodeId);
    
    /**
     * 根据项目查询关联所有元数据信息
     * 
     * @param projectId 项目ID
     * @return 是否更新成功
     */
    boolean updateMetadataFromCenterDBByProjectId(final String projectId);
}
