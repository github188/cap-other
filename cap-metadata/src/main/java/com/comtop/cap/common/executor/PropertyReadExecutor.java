/******************************************************************************
 * Copyright (C) 2015 ShenZhen ComTop Information Technology Co.,Ltd
 * All Rights Reserved.
 * 本软件为深圳康拓普开发研制。未经本公司正式书面同意，其他任何个人、团体不得使用、
 * 复制、修改或发布本软件.
 *****************************************************************************/

package com.comtop.cap.common.executor;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.List;
import java.util.Map;

import com.comtop.cap.common.reflect.FieldDescription;
import com.comtop.cap.common.reflect.ReflectUtil;
import com.comtop.cap.common.reflect.TypeDescription;
import com.comtop.top.core.base.model.CoreVO;
import com.comtop.top.core.jodd.executor.IBizExecutor;

/**
 * 按属性读取执行器
 *
 * @author lizhiyong
 * @since jdk1.6
 * @version 2015年12月4日 lizhiyong
 */
public class PropertyReadExecutor implements IBizExecutor {
    
    /** 主键参数 */
    private final String pid;
    
    /** VO的类型 */
    private final Class<? extends CoreVO> voType;
    
    /** 返回结果集 */
    private final Map<String, Object> retMap;
    
    /** 属性集 */
    private final List<String> properties;
    
    /**
     * 构造函数
     * 
     * @param properties 属性列名映射
     * @param voType SQL
     * @param pid 主键参数
     * @param retMap 结果集
     */
    public PropertyReadExecutor(String pid, List<String> properties, Class<? extends CoreVO> voType,
        Map<String, Object> retMap) {
        super();
        this.voType = voType;
        this.pid = pid;
        this.retMap = retMap;
        this.properties = properties;
    }
    
    /**
     * 
     * @see com.comtop.top.core.jodd.executor.IBizExecutor#execute(java.sql.Connection)
     */
    @Override
    public Object execute(Connection paramConnection) {
        PreparedStatement pstmt = null;
        ResultSet rs = null;
        TypeDescription typeDescription = ReflectUtil.getTypeDescription(voType);
        String sql = SqlBuilder.buildSQLReadPropertybyId(typeDescription, properties);
        Map<String, FieldDescription> propertyDesMap = typeDescription.getColumnFieldDescriptionMap();
        try {
            pstmt = paramConnection.prepareStatement(sql);
            pstmt.setObject(1, pid);
            rs = pstmt.executeQuery();
            if (rs.next()) {
                FieldDescription description = null;
                for (String property : properties) {
                    description = propertyDesMap.get(property);
                    if (description != null) {
                        retMap.put(property, rs.getObject(description.getColumnName()));
                    }
                }
            }
            return retMap;
        } catch (SQLException e) {
            throw new RuntimeException("根据id查询对象属性值时发生异常", e);
        } finally {
            ConnectionUtil.closeConnection(rs, pstmt);
        }
    }
}
