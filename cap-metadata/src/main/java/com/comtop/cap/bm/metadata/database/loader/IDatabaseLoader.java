/******************************************************************************
 * Copyright (C) 2014 ShenZhen ComTop Information Technology Co.,Ltd
 * All Rights Reserved.
 * 本软件为深圳康拓普开发研制。未经本公司正式书面同意，其他任何个人、团体不得使用、
 * 复制、修改或发布本软件.
 *****************************************************************************/

package com.comtop.cap.bm.metadata.database.loader;

import java.util.List;

import com.comtop.cap.bm.metadata.database.dbobject.model.ColumnVO;
import com.comtop.cap.bm.metadata.database.dbobject.model.FunctionColumnVO;
import com.comtop.cap.bm.metadata.database.dbobject.model.FunctionVO;
import com.comtop.cap.bm.metadata.database.dbobject.model.ProcedureColumnVO;
import com.comtop.cap.bm.metadata.database.dbobject.model.ProcedureVO;
import com.comtop.cap.bm.metadata.database.dbobject.model.TableIndexVO;
import com.comtop.cap.bm.metadata.database.dbobject.model.TableVO;
import com.comtop.cap.bm.metadata.database.dbobject.model.ViewColumnVO;
import com.comtop.cap.bm.metadata.database.dbobject.model.ViewVO;
import com.comtop.cap.bm.metadata.database.util.MetaConnection;

/**
 * 数据库元数据加载接口
 * 
 * @author 李忠文
 * @since 1.0
 * @version 2014-3-27 李忠文
 */
public interface IDatabaseLoader {
    
    /**
     * 从数据库中获取表
     * 
     * @param schema 数据库模式
     * @param tablePatten 表名称模式
     * @param prefix 忽略前缀数
     * @param exact 精确的，TRUE表示精确查询，false表示模糊查询
     * @param connection 数据库连接元数据
     * 
     * @return 实体对象集合，当为精确查询时，返回的集合中应该只有一个实体对象
     */
    List<TableVO> loadEntityFromDatabase(final String schema, final String tablePatten, final Integer prefix,
        final boolean exact, final MetaConnection connection);
    
    /**
     * 获取数据库中表字段
     * 
     * @param schema 数据库模式
     * @param tableName 表名称
     * @param connection 数据库连接
     * @return 表字段集合
     */
    List<ColumnVO> loadEntityAttributeFromDataBase(final String schema, final String tableName,
        final MetaConnection connection);
    
    /**
     * 从数据库中获取视图
     * 
     * @param schema 数据库模式
     * @param tablePatten 表名称模式
     * @param exact 精确的，TRUE表示精确查询，false表示模糊查询
     * @param connection 数据库连接元数据
     * 
     * @return 实体对象集合，当为精确查询时，返回的集合中应该只有一个实体对象
     */
    List<ViewVO> loadViewFromDatabase(final String schema, final String tablePatten, final boolean exact,
        final MetaConnection connection);
    
    /**
     * 获取数据库中视图字段
     * 
     * @param schema 数据库模式
     * @param tableName 表名称
     * @param connection 数据库连接
     * @return 表字段集合
     */
    List<ViewColumnVO> loadViewColumnFromDataBase(final String schema, final String tableName,
        final MetaConnection connection);
    
    /**
     * 获取数据库主键
     * 
     * @param schema 数据库模式
     * @param tableName 表名称
     * @param connection 数据库连接元数据
     * @return 主键集合
     */
    List<String> loadTablePrimitiveKeyFormDataBase(final String schema, final String tableName,
        final MetaConnection connection);
    
    /**
     * 获取数据库中表索引
     * 
     * @param schema 数据库模式
     * @param tableName 表名称
     * @param connection 数据库连接元数据
     * @return 表字段集合
     */
    List<TableIndexVO> loadTableIndexesFromDataBase(final String schema, final String tableName,
        final MetaConnection connection);
    
    /**
     * 从数据库中获取存储过程
     * 
     * @param schema 数据库模式
     * @param procedurePattern 存储过程名称模式
     * @param exact 精确的，TRUE表示精确查询，false表示模糊查询
     * @param connection 数据库连接元数据
     * 
     * @return 实体对象集合，当为精确查询时，返回的集合中应该只有一个实体对象
     */
    List<ProcedureVO> loadProceduresFromDatabase(final String schema, final String procedurePattern,
        final boolean exact, final MetaConnection connection);
    
    /**
     * 获取存储过程字段
     * 
     * @param schema 数据库模式
     * @param procedureName 存储过程名称模式
     * @param connection 数据库连接
     * @return 表字段集合
     */
    List<ProcedureColumnVO> loadProcedureColumnFromDataBase(final String schema, final String procedureName,
        final MetaConnection connection);
    
    /**
     * 从数据库中获取函数
     * 
     * @param schema 数据库模式
     * @param functionPattern 函数名称模式
     * @param exact 精确的，TRUE表示精确查询，false表示模糊查询
     * @param connection 数据库连接元数据
     * 
     * @return 实体对象集合，当为精确查询时，返回的集合中应该只有一个实体对象
     */
    List<FunctionVO> loadFunctionsFromDatabase(final String schema, final String functionPattern, final boolean exact,
        final MetaConnection connection);
    
    /**
     * 获取函数字段
     * 
     * @param schema 数据库模式
     * @param functionName 函数名称模式
     * @param connection 数据库连接
     * @return 表字段集合
     */
    List<FunctionColumnVO> loadFunctionColumnFromDataBase(final String schema, final String functionName,
        final MetaConnection connection);
}
