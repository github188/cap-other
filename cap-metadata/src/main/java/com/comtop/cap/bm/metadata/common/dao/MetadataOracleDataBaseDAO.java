/******************************************************************************
 * Copyright (C) 2014 ShenZhen ComTop Information Technology Co.,Ltd
 * All Rights Reserved.
 * 本软件为深圳康拓普开发研制。未经本公司正式书面同意，其他任何个人、团体不得使用、
 * 复制、修改或发布本软件.
 *****************************************************************************/

package com.comtop.cap.bm.metadata.common.dao;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.List;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;

import com.comtop.cap.bm.metadata.common.model.MetadataVersionVO;
import com.comtop.cap.runtime.base.exception.CapMetaDataException;
import com.comtop.cip.common.util.MetadataConnection;
import com.comtop.cip.common.util.MetadataPreferences;

/**
 * ORALCE元数据DAO 基类
 * 
 * @author 沈康
 * @since 1.0
 * @version 2014-6-10 沈康
 */
public final class MetadataOracleDataBaseDAO implements IMetadataDataBaseDAO {
    
    /** 日志 */
    private static final Logger LOGGER = LoggerFactory.getLogger(MetadataOracleDataBaseDAO.class);
    
    /** ORACLE元数据DAO实例 */
    private static MetadataOracleDataBaseDAO instance;
    
    /** 中心数据库连接 */
    protected static MetadataConnection metadataConnection;
    
    /**
     * 构造函数
     */
    public MetadataOracleDataBaseDAO() {
        metadataConnection = MetadataPreferences.getMetadataConnection();
    }
    
    /**
     * 获取ORACLE数据库类型转换器
     * 
     * @return 转换器实例
     */
    public static synchronized MetadataOracleDataBaseDAO getInstance() {
        if (instance == null) {
            instance = new MetadataOracleDataBaseDAO();
        }
        return instance;
    }
    
    /**
     * 根据节点ID获取元数据版本VO
     * 
     * @param nodeId 节点ID
     * @return 元数据版本VO
     */
    @Override
    public MetadataVersionVO getMetadataVersionVOByNodeId(final String nodeId) {
        ResultSet objResultSet = null;
        Connection objConnection = null;
        PreparedStatement objPstmt = null;
        MetadataVersionVO objMetadataVersionVO = null;
        
        try {
            // 查询SQL
            // 获取数据库连接
            objConnection = this.getConnection();
            String strSQL = "SELECT * FROM CIP_ENTITY_OPERATE_LOCK CL WHERE CL.NODE_ID = ?";
            objPstmt = objConnection.prepareStatement(strSQL);
            objPstmt.setString(1, nodeId);
            objResultSet = objPstmt.executeQuery();
            if (objResultSet != null && objResultSet.next()) {
                objMetadataVersionVO = new MetadataVersionVO();
                objMetadataVersionVO.setId(objResultSet.getString("LOCK_ID"));
                objMetadataVersionVO.setLocked(objResultSet.getInt("LOCKED") == 1 ? true : false);
                objMetadataVersionVO.setNodeId(objResultSet.getString("NODE_ID"));
                objMetadataVersionVO.setOperateTime(objResultSet.getTimestamp("OPERATE_TIME"));
                objMetadataVersionVO.setOperator(objResultSet.getString("OPERATOR"));
            }
        } catch (SQLException ex) {
            LOGGER.error("根据节点ID获取元数据版本VO出错！", ex);
            throw new CapMetaDataException(" 根据节点ID获取元数据版本VO出错！", ex);
        } finally {
            this.closeConnection(objResultSet, objPstmt, objConnection);
        }
        return objMetadataVersionVO;
    }
    
    /**
     * 判断元数据是否被本人锁定
     * 
     * @param nodeId 节点ID
     * @param operator 当前操作人员
     * @return 元数据版本VO
     */
    @Override
    public boolean metadataIsLocked(final String nodeId, final String operator) {
        ResultSet objResultSet = null;
        Connection objConnection = null;
        PreparedStatement objPstmt = null;
        try {
            // 获取数据库连接
            objConnection = this.getConnection();
            // 查询SQL
            String strSQL = "SELECT * FROM CIP_ENTITY_OPERATE_LOCK CL WHERE CL.NODE_ID = ? "
                + "AND CL.LOCKED = 1 AND CL.OPERATOR = ?";
            objPstmt = objConnection.prepareStatement(strSQL);
            objPstmt.setString(1, nodeId);
            objPstmt.setString(2, operator);
            objResultSet = objPstmt.executeQuery();
            if (objResultSet != null && objResultSet.next()) {
                return true;
            }
        } catch (SQLException ex) {
            LOGGER.error("判断元数据是否锁定出错！", ex);
            throw new CapMetaDataException("判断元数据是否锁定出错！", ex);
        } finally {
            this.closeConnection(objResultSet, objPstmt, objConnection);
        }
        return false;
    }
    
    /**
     * 新增元数据锁定VO对象集合
     * 
     * @param metadataVersionVOs 新增对象集合
     */
    @Override
    public void insertMetadataVersionVO(final List<MetadataVersionVO> metadataVersionVOs) {
        ResultSet objResultSet = null;
        Connection objConnection = null;
        PreparedStatement objPstmt = null;
        MetadataVersionVO objMetadataVersionVO = null;
        
        StringBuffer sbSQL = new StringBuffer(256);
        sbSQL.append("INSERT INTO CIP_ENTITY_OPERATE_LOCK VALUES(?, ?, ?, ?, ?)");
        
        try {
            objConnection = this.getConnection();
            objConnection.setAutoCommit(false);
            objPstmt = objConnection.prepareStatement(sbSQL.toString(), ResultSet.TYPE_SCROLL_SENSITIVE,
                ResultSet.CONCUR_READ_ONLY);
            for (int i = 0; i < metadataVersionVOs.size(); i++) {
                objMetadataVersionVO = metadataVersionVOs.get(i);
                objPstmt.setString(1, objMetadataVersionVO.getId());
                objPstmt.setString(2, objMetadataVersionVO.getNodeId());
                objPstmt.setInt(3, objMetadataVersionVO.getLocked() ? 1 : 0);
                objPstmt.setString(4, objMetadataVersionVO.getOperator());
                objPstmt.setTimestamp(5, objMetadataVersionVO.getOperateTime());
                objPstmt.addBatch();
            }
            objPstmt.executeBatch();
            objConnection.commit();
        } catch (SQLException ex) {
            LOGGER.error("新增元数据锁定VO对象集合出错！", ex);
            throw new CapMetaDataException("新增元数据锁定VO对象集合出错！", ex);
        } finally {
            this.closeConnection(objResultSet, objPstmt, objConnection);
        }
        
    }
    
    /**
     * 更新元数据锁定VO对象集合
     * 
     * @param metadataVersionVOs 更新对象集合
     */
    @Override
    public void updateMetadataVersionVO(final List<MetadataVersionVO> metadataVersionVOs) {
        ResultSet objResultSet = null;
        Connection objConnection = null;
        PreparedStatement objPstmt = null;
        MetadataVersionVO objMetadataVersionVO = null;
        
        StringBuffer sbSQL = new StringBuffer(256);
        sbSQL.append("UPDATE CIP_ENTITY_OPERATE_LOCK CL SET CL.LOCKED = ?, CL.OPERATOR = ?, CL.OPERATE_TIME = ?");
        sbSQL.append(" WHERE CL.NODE_ID = ?");
        
        try {
            objConnection = this.getConnection();
            objConnection.setAutoCommit(false);
            objPstmt = objConnection.prepareStatement(sbSQL.toString());
            for (int i = 0; i < metadataVersionVOs.size(); i++) {
                objMetadataVersionVO = metadataVersionVOs.get(i);
                objPstmt.setInt(1, objMetadataVersionVO.getLocked() ? 1 : 0);
                objPstmt.setString(2, objMetadataVersionVO.getOperator());
                objPstmt.setTimestamp(3, objMetadataVersionVO.getOperateTime());
                objPstmt.setString(4, objMetadataVersionVO.getNodeId());
                objPstmt.addBatch();
            }
            objPstmt.executeBatch();
            objConnection.commit();
        } catch (SQLException ex) {
            LOGGER.error("更新元数据锁定VO对象集合出错！", ex);
            throw new CapMetaDataException("更新元数据锁定VO对象集合出错！", ex);
        } finally {
            this.closeConnection(objResultSet, objPstmt, objConnection);
        }
    }
    
    /**
     * 获取数据库连接
     * 
     * @return 数据库连接
     * @see com.comtop.cap.bm.metadata.common.dao.IMetadataDataBaseDAO#getConnection()
     */
    @Override
    public Connection getConnection() {
        // 创建数据库连接
        Connection objConnection = null;
        objConnection = metadataConnection.getConnection();
        return objConnection;
    }
    
    /**
     * 关闭数据库操作相关
     * 
     * @param resultSet 结果集
     * @param pstmt PreparedStatement
     * @param conn 数据库连接
     */
    private void closeConnection(ResultSet resultSet, PreparedStatement pstmt, Connection conn) {
        if (resultSet != null) {
            try {
                resultSet.close();
            } catch (SQLException e) {
                LOGGER.error("关闭数据库连接出错！", e);
                throw new CapMetaDataException("关闭数据库连接出错！", e);
            }
        }
        
        if (pstmt != null) {
            try {
                pstmt.close();
            } catch (SQLException e) {
                LOGGER.error("关闭数据库连接出错！", e);
                throw new CapMetaDataException("关闭数据库连接出错！", e);
            }
        }
        
        if (conn != null) {
            try {
                conn.close();
            } catch (SQLException e) {
                LOGGER.error("关闭数据库连接出错！", e);
                throw new CapMetaDataException("关闭数据库连接出错！", e);
            }
        }
    }
}
