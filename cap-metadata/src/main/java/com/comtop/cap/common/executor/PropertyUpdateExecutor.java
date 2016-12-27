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
import java.util.Map;

import com.comtop.cap.common.reflect.FieldDescription;
import com.comtop.cap.common.reflect.ReflectUtil;
import com.comtop.cap.common.reflect.TypeDescription;
import com.comtop.top.core.base.model.CoreVO;
import com.comtop.top.core.jodd.executor.IBizExecutor;

/**
 * 属性更新执行器
 *
 * @author lizhiyong
 * @since jdk1.6
 * @version 2015年12月4日 lizhiyong
 */
public class PropertyUpdateExecutor implements IBizExecutor {
    
    /** 主键参数 */
    private final String pid;
    
    /** VO的类型 */
    private final Class<? extends CoreVO> voType;
    
    /** 属性值集 */
    private final Map<String, Object> propertiesMap;
    
    /**
     * 构造函数
     * 
     * @param propertiesMap 属性集值
     * @param voType SQL
     * @param pid 主键参数
     */
    public PropertyUpdateExecutor(String pid, Map<String, Object> propertiesMap, Class<? extends CoreVO> voType) {
        super();
        this.voType = voType;
        this.pid = pid;
        this.propertiesMap = propertiesMap;
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
        String sql = SqlBuilder.buildSQLUpdatePropertybyId(typeDescription, propertiesMap);
        Map<String, FieldDescription> propertyDesMap = typeDescription.getColumnFieldDescriptionMap();
        try {
            pstmt = paramConnection.prepareStatement(sql);
            int paramIndex = 1;
            FieldDescription description = null;
            for (String property : propertiesMap.keySet()) {
                description = propertyDesMap.get(property);
                if (description != null) {
                    pstmt.setObject(paramIndex++, propertiesMap.get(property));
                }
            }
            pstmt.setObject(paramIndex, pid);
            return pstmt.execute();
        } catch (SQLException e) {
            throw new RuntimeException("根据id查询对象属性值时发生异常", e);
        } finally {
            ConnectionUtil.closeConnection(rs, pstmt);
        }
    }
    
}
