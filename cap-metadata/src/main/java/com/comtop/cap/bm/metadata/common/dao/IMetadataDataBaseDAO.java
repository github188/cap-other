/******************************************************************************
 * Copyright (C) 2014 ShenZhen ComTop Information Technology Co.,Ltd
 * All Rights Reserved.
 * 本软件为深圳康拓普开发研制。未经本公司正式书面同意，其他任何个人、团体不得使用、
 * 复制、修改或发布本软件.
 *****************************************************************************/

package com.comtop.cap.bm.metadata.common.dao;

import java.sql.Connection;
import java.util.List;

import com.comtop.cap.bm.metadata.common.model.MetadataVersionVO;

/**
 * 元数据连接中心数据库DAO接口
 * 
 * @author 沈康
 * @since 1.0
 * @version 2014-6-10 沈康
 */
public interface IMetadataDataBaseDAO {
    
    /**
     * 获取数据库连接
     * 
     * @return 数据库连接
     */
    Connection getConnection();
    
    /**
     * 根据节点ID获取元数据版本VO
     * 
     * @param nodeId 节点ID
     * @return 元数据版本VO
     */
    MetadataVersionVO getMetadataVersionVOByNodeId(final String nodeId);
    
    /**
     * 判断元数据是否锁定
     * 
     * @param nodeId 节点ID
     * @param operator 当前操作者
     * @return 元数据版本VO
     */
    boolean metadataIsLocked(final String nodeId, final String operator);
    
    /**
     * 更新元数据锁定VO对象集合
     * 
     * @param metadataVersionVOs 更新对象集合
     */
    void updateMetadataVersionVO(final List<MetadataVersionVO> metadataVersionVOs);
    
    /**
     * 新增元数据锁定VO对象集合
     * 
     * @param metadataVersionVOs 新增对象集合
     */
    void insertMetadataVersionVO(final List<MetadataVersionVO> metadataVersionVOs);
}
