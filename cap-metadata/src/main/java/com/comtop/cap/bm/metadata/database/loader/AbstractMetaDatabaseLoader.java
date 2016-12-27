/******************************************************************************
 * Copyright (C) 2014 ShenZhen ComTop Information Technology Co.,Ltd
 * All Rights Reserved.
 * 本软件为深圳康拓普开发研制。未经本公司正式书面同意，其他任何个人、团体不得使用、
 * 复制、修改或发布本软件.
 *****************************************************************************/

package com.comtop.cap.bm.metadata.database.loader;

import java.sql.Connection;
import java.sql.DatabaseMetaData;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.Collections;
import java.util.HashMap;
import java.util.List;
import java.util.Map;
import java.util.regex.Matcher;
import java.util.regex.Pattern;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;

import com.comtop.cap.bm.metadata.database.dbobject.model.ColumnVO;
import com.comtop.cap.bm.metadata.database.dbobject.model.FunctionColumnVO;
import com.comtop.cap.bm.metadata.database.dbobject.model.FunctionVO;
import com.comtop.cap.bm.metadata.database.dbobject.model.IndexColumnVO;
import com.comtop.cap.bm.metadata.database.dbobject.model.ProcedureColumnVO;
import com.comtop.cap.bm.metadata.database.dbobject.model.ProcedureVO;
import com.comtop.cap.bm.metadata.database.dbobject.model.TableIndexVO;
import com.comtop.cap.bm.metadata.database.dbobject.model.TableVO;
import com.comtop.cap.bm.metadata.database.dbobject.model.ViewColumnVO;
import com.comtop.cap.bm.metadata.database.dbobject.model.ViewVO;
import com.comtop.cap.bm.metadata.database.util.DataTypeConverterFactory;
import com.comtop.cap.bm.metadata.database.util.FieldDataType;
import com.comtop.cap.bm.metadata.database.util.IDataTypeConverter;
import com.comtop.cap.bm.metadata.database.util.MetaConnection;
import com.comtop.cap.bm.metadata.preferencesconfig.facade.PreferencesFacade;
import com.comtop.cap.bm.metadata.utils.StringConvertor;
import com.comtop.cap.runtime.base.exception.CapMetaDataException;
import com.comtop.cap.runtime.base.util.BeanContextUtil;
import com.comtop.cip.common.util.DBUtil;
import com.comtop.cip.jodd.util.StringUtil;

/**
 * 抽象的元数据加载类
 * 
 * 
 * @author 李忠文
 * @since 1.0
 * @version 2014-3-27 李忠文
 */
public abstract class AbstractMetaDatabaseLoader implements IDatabaseLoader {
    
    /** 日志 */
    private static final Logger LOGGER = LoggerFactory.getLogger(AbstractMetaDatabaseLoader.class);
    
    /** 移除对象 */
    private static List<String> removelst = new ArrayList<String>();
    
    /** 首选项的facade实例 **/
    private final static PreferencesFacade preferencesFacade = BeanContextUtil.getBean(PreferencesFacade.class);
    
    static {
        removelst.add("ODCIAGGREGATEINITIALIZE");
        removelst.add("Packaged function");
        removelst.add("ODCIAGGREGATEITERATE");
        removelst.add("ODCIAGGREGATEMERGE");
        removelst.add("ODCIAGGREGATETERMINATE");
        removelst.add("GETHZFULLPY");
        removelst.add("GETHZPYCAP");
        removelst.add("GETHZPY_BY_INDEX");
        removelst.add("GET_GREECE_ALPHABET_PY");
        removelst.add("GET_PY_INDEX_01");
        removelst.add("GET_PY_INDEX_02");
        removelst.add("GET_PY_INDEX_03");
        removelst.add("GET_PY_INDEX_04");
        removelst.add("GET_PY_INDEX_05");
        removelst.add("GET_PY_INDEX_06");
        removelst.add("GET_PY_INDEX_07");
        removelst.add("GET_PY_INDEX_08");
        removelst.add("GET_PY_INDEX_09");
        removelst.add("GET_PY_INDEX_10");
        removelst.add("GET_PY_INDEX_11");
        removelst.add("GET_PY_INDEX_12");
        removelst.add("GET_PY_INDEX_13");
        removelst.add("ET_ROMA_NUM_PY");
    }
    
    /**
     * 从数据库中获取表
     * 
     * @param schema 数据库模式
     * @param tablePatten 表名称模式
     * @param prefix 忽略前缀数
     * @param exact 精确的，TRUE表示精确查询，false表示模糊查询
     * @param conn 数据库连接元数据
     * @return 表对象集合，当为精确查询时，返回的集合中应该只有一个表对象
     * @see com.comtop.cap.bm.metadata.database.loader.IDatabaseLoader#loadEntityFromDatabase(java.lang.String,
     *      java.lang.String,java.lang.Integer, boolean, com.comtop.cap.bm.metadata.database.util.MetaConnection)
     */
    @SuppressWarnings("resource")
    @Override
    public List<TableVO> loadEntityFromDatabase(final String schema, final String tablePatten, final Integer prefix,
        final boolean exact, final MetaConnection conn) {
        
        TableVO objTableVO;
        List<TableVO> lstTableVO = null;
        ResultSet objResultSet = null;
        String strUpperCaseTablePatten = StringUtil.isBlank(tablePatten) ? "" : tablePatten.toUpperCase();
        String strTablePatten;
        Integer iPre = prefix;
        if (iPre == null) {
            iPre = Integer.valueOf(preferencesFacade.getConfig("tablePrefixIngore").getConfigValue());
        }
        if (StringUtil.isBlank(tablePatten)) {
            strTablePatten = exact ? "" : "%";
        } else {
            strTablePatten = (exact ? tablePatten.replace("%", "") : "%" + tablePatten + "%").toUpperCase();
        }
        Connection objConn = conn.getConn();
        if (objConn == null) {
            throw new CapMetaDataException("数据库连接失败！");
        }
        try {
            DatabaseMetaData objDBMeta = objConn.getMetaData();
            objResultSet = objDBMeta.getTables(null, schema, strTablePatten, new String[] { "TABLE" });
            lstTableVO = new ArrayList<TableVO>();
            while (objResultSet.next()) {
                String strTableName = objResultSet.getString("TABLE_NAME").toUpperCase();
                // 当名称中含有“_”可能会被JDBC API，当成任一字符，再次过滤，确保正确。
                if (strTableName.startsWith("BIN$") || !strTableName.contains(strUpperCaseTablePatten)) {
                    continue;
                }
                String strTableRemark = objResultSet.getString("REMARKS");
                objTableVO = new TableVO();
                String strEngName = StringConvertor.toCamelCase(strTableName, iPre);
                String strCHName = getChName(strEngName, strTableRemark);
                objTableVO.setChName(strCHName);
                objTableVO.setEngName(strTableName);
                objTableVO.setDescription(strTableRemark);
                objTableVO.setCode(strTableName);// 表名
                lstTableVO.add(objTableVO);
            }
        } catch (SQLException e) {
            LOGGER.debug(e.getMessage(), e);
            throw new CapMetaDataException("获取数据表{0}的失败。", e, tablePatten);
        } finally {
            DBUtil.closeConnection(null, null, objResultSet);
        }
        return lstTableVO;
    }
    
    /**
     * 从数据库中获取视图
     * 
     * @param schema 数据库模式
     * @param tablePatten 表名称模式
     * @param exact 精确的，TRUE表示精确查询，false表示模糊查询
     * @param conn 数据库连接元数据
     * @return 表对象集合，当为精确查询时，返回的集合中应该只有一个表对象
     * @see com.comtop.cap.bm.metadata.database.loader.IDatabaseLoader#loadViewFromDatabase(java.lang.String,
     *      java.lang.String, boolean, com.comtop.cap.bm.metadata.database.util.MetaConnection)
     */
    @Override
    public List<ViewVO> loadViewFromDatabase(final String schema, final String tablePatten, final boolean exact,
        final MetaConnection conn) {
        ViewVO objViewVO;
        List<ViewVO> lstViewVO = null;
        ResultSet objResultSet = null;
        String strUpperCaseTablePatten = StringUtil.isBlank(tablePatten) ? "" : tablePatten.toUpperCase();
        String strTablePatten;
        
        if (StringUtil.isBlank(tablePatten)) {
            strTablePatten = exact ? "" : "%";
        } else {
            strTablePatten = (exact ? tablePatten.replace("%", "") : "%" + tablePatten + "%").toUpperCase();
        }
        Connection objConn = conn.getConn();
        if (objConn == null) {
            throw new CapMetaDataException("数据库连接失败！");
        }
        try {
            DatabaseMetaData objDBMeta = objConn.getMetaData();
            objResultSet = objDBMeta.getTables(null, schema, strTablePatten, new String[] { "VIEW" });
            lstViewVO = new ArrayList<ViewVO>();
            while (objResultSet.next()) {
                String strTableName = objResultSet.getString("TABLE_NAME").toUpperCase();
                // 当名称中含有“_”可能会被JDBC API，当成任一字符，再次过滤，确保正确。
                if (strTableName.startsWith("BIN$") || !strTableName.contains(strUpperCaseTablePatten)) {
                    continue;
                }
                String strTableRemark = objResultSet.getString("REMARKS");
                objViewVO = new ViewVO();
                String strCHName = getChName(strTableName, strTableRemark);
                objViewVO.setChName(strCHName);
                objViewVO.setCode(strTableName);
                objViewVO.setEngName(strTableName);
                objViewVO.setDescription(strTableRemark);
                lstViewVO.add(objViewVO);
            }
        } catch (SQLException e) {
            LOGGER.debug(e.getMessage(), e);
            throw new CapMetaDataException("获取数据表{0}的失败。", e, tablePatten);
        } finally {
            DBUtil.closeConnection(null, null, objResultSet);
        }
        return lstViewVO;
    }
    
    /**
     * 根据表名和表注释获取中文名称
     * 
     * @param strTableName 表名
     * @param strTableRemark 表注释
     * @return 中文名称
     */
    private String getChName(String strTableName, String strTableRemark) {
        String strCHName;
        if (StringUtil.isNotBlank(strTableRemark) && strTableRemark.length() > 20) {
            strCHName = strTableRemark.substring(0, 20);
        } else {
            strCHName = strTableRemark;
        }
        if (StringUtil.isBlank(strCHName)) {
            strCHName = strTableName;
        } else {
            strCHName = strCHName.replace("\n", "");
        }
        return strCHName;
    }
    
    /**
     * 获取数据库中表字段
     * 
     * @param schema 数据库模式
     * @param tableName 表名称
     * @param conn 数据库连接
     * @return 表字段集合
     * @see com.comtop.cap.bm.metadata.database.loader.IDatabaseLoader#loadEntityAttributeFromDataBase(java.lang.String,
     *      java.lang.String, com.comtop.cap.bm.metadata.database.util.MetaConnection)
     */
    @SuppressWarnings("resource")
    @Override
    public List<ColumnVO> loadEntityAttributeFromDataBase(final String schema, final String tableName,
        final MetaConnection conn) {
        ColumnVO objColumnVO;
        List<ColumnVO> lstColumnVO = null;
        ResultSet objResultSet = null;
        Connection objConn = conn.getConn();
        if (objConn == null) {
            throw new CapMetaDataException("数据库连接失败！");
        }
        try {
            DatabaseMetaData objDBMeta = objConn.getMetaData();
            IDataTypeConverter objConverter = DataTypeConverterFactory.getDataTypeConverter(conn);
            objResultSet = objDBMeta.getColumns(null, schema, tableName, "%");
            List<String> lstPK = loadTablePrimitiveKeyFormDataBase(schema, tableName, conn);
            lstColumnVO = new ArrayList<ColumnVO>();
            while (objResultSet.next()) {
                String strColumnName = objResultSet.getString("COLUMN_NAME").toUpperCase();
                // String strTypeName = objResultSet.getString("TYPE_NAME");
                int iType = objResultSet.getInt("DATA_TYPE");
                
                int iLength = objResultSet.getInt("COLUMN_SIZE");
                int iPrecision = objResultSet.getInt("DECIMAL_DIGITS");
                String defaultValue = objResultSet.getString("COLUMN_DEF");// 获取默认值
                
                // 临时处理：由于不同版本的jdbc驱动导致number的解析出的精度不同。数据库number类型不设精度，ojdbc6-12.1.2-0-0.jar驱动会解析出精度为-127，长度为0.
                if (iType == 3 && iPrecision == -127) {
                    iLength = 22;
                    iPrecision = 0;
                }
                
                boolean bAllowNull = "YES".equals(objResultSet.getString("IS_NULLABLE"));
                String strRemark = objResultSet.getString("REMARKS");
                objColumnVO = new ColumnVO();
                String strEngName = StringUtil.uncapitalize(StringConvertor.toCamelCase(strColumnName,
                    Integer.valueOf(preferencesFacade.getConfig("tableColumnPrefixIngore").getConfigValue())));
                String strCHName = getChName(strEngName, strRemark);
                objColumnVO.setChName(strCHName);
                if (lstPK.contains(strColumnName) && 1 == lstPK.size()) {
                    objColumnVO.setEngName(strColumnName);
                    objColumnVO.setIsPrimaryKEY(true);
                } else {
                    objColumnVO.setEngName(strColumnName);
                    objColumnVO.setIsPrimaryKEY(false);
                }
                objColumnVO.setCode(strColumnName);
                int iFieldType = objConverter.getFieldDateType(iType);
                String strFieldType = FieldDataType.getFieldTypeValue(iFieldType);
                objColumnVO.setDataType(strFieldType);
                objColumnVO.setLength(iLength); // 长度
                objColumnVO.setPrecision(iPrecision);// 精度
                objColumnVO.setCanBeNull(bAllowNull);// 是否能为空
                objColumnVO.setDefaultValue(formatDefaultValue(defaultValue));// 默认值
                objColumnVO.setDescription(strRemark); // 描述
                lstColumnVO.add(objColumnVO);
            }
        } catch (SQLException e) {
            LOGGER.error(e.getMessage(), e);
            throw new CapMetaDataException("获取数据表{0}的字段失败。", e, tableName);
        } finally {
            DBUtil.closeConnection(null, null, objResultSet);
        }
		return lstColumnVO;
    }
    
    /**
     * 转换默认值
     * 
     * @param defaultValue
     *            列设置的默认值
     * @return val
     */
    private String formatDefaultValue(String defaultValue) {
        String defValue = defaultValue == null ? null : defaultValue.replace("\n", "").trim();
        
        if ("null".equals(defValue)) {
            return "";
        }
        if (defValue != null) {
            Pattern p = Pattern.compile("^'(.*)'$");
            Matcher matcher = p.matcher(defValue);
            boolean matches = matcher.matches();
            if (matches) {
                return matcher.group(1);
            }
            return defValue;
        }
        return defValue != null ? defValue.trim() : null;
    }
    
    /**
     * 获取数据库中表字段
     * 
     * @param schema 数据库模式
     * @param tableName 表名称
     * @param conn 数据库连接
     * @return 表字段集合
     * @see com.comtop.cap.bm.metadata.database.loader.IDatabaseLoader#loadViewColumnFromDataBase(java.lang.String,
     *      java.lang.String, com.comtop.cap.bm.metadata.database.util.MetaConnection)
     */
    @SuppressWarnings("resource")
    @Override
    public List<ViewColumnVO> loadViewColumnFromDataBase(final String schema, final String tableName,
        final MetaConnection conn) {
        ViewColumnVO objViewColumnVO;
        List<ViewColumnVO> lstViewColumnVO = null;
        ResultSet objResultSet = null;
        Connection objConn = conn.getConn();
        if (objConn == null) {
            throw new CapMetaDataException("数据库连接失败！");
        }
        try {
            DatabaseMetaData objDBMeta = objConn.getMetaData();
            IDataTypeConverter objConverter = DataTypeConverterFactory.getDataTypeConverter(conn);
            objResultSet = objDBMeta.getColumns(null, schema, tableName, "%");
            lstViewColumnVO = new ArrayList<ViewColumnVO>();
            while (objResultSet.next()) {
                String strColumnName = objResultSet.getString("COLUMN_NAME").toUpperCase();
                int iType = objResultSet.getInt("DATA_TYPE");
                int iLength = objResultSet.getInt("COLUMN_SIZE");
                int iPrecision = objResultSet.getInt("DECIMAL_DIGITS");
                String strRemark = objResultSet.getString("REMARKS");
                objViewColumnVO = new ViewColumnVO();
                String strEngName = StringUtil.uncapitalize(StringConvertor.toCamelCase(strColumnName,
                    Integer.valueOf(preferencesFacade.getConfig("tableColumnPrefixIngore").getConfigValue())));
                String strCHName = getChName(strEngName, strRemark);
                objViewColumnVO.setChName(strCHName);
                objViewColumnVO.setEngName(strColumnName);
                objViewColumnVO.setCode(strColumnName);
                int iFieldType = objConverter.getFieldDateType(iType);
                String strFieldType = FieldDataType.getFieldTypeValue(iFieldType);
                objViewColumnVO.setDataType(strFieldType);
                objViewColumnVO.setLength(iLength); // 长度
                objViewColumnVO.setPrecision(iPrecision);// 精度
                objViewColumnVO.setDescription(strRemark); // 描述
                lstViewColumnVO.add(objViewColumnVO);
            }
        } catch (SQLException e) {
            LOGGER.debug(e.getMessage(), e);
            throw new CapMetaDataException("获取数据表{0}的字段失败。", e, tableName);
        } finally {
            DBUtil.closeConnection(null, null, objResultSet);
        }
        return lstViewColumnVO;
    }
    
    /**
     * 获取数据库主键
     * 
     * @param schema 数据库模式
     * @param tableName 表名称
     * @param conn 数据库连接元数据
     * @return 主键集合
     * @see com.comtop.cap.bm.metadata.database.loader.IDatabaseLoader#loadTablePrimitiveKeyFormDataBase(java.lang.String,
     *      java.lang.String, com.comtop.cap.bm.metadata.database.util.MetaConnection)
     */
    @SuppressWarnings("resource")
    @Override
    public List<String> loadTablePrimitiveKeyFormDataBase(final String schema, final String tableName,
        final MetaConnection conn) {
        List<String> lstPK = null;
        ResultSet objResultSet = null;
        Connection objConn = conn.getConn();
        if (objConn == null) {
            throw new CapMetaDataException("数据库连接失败！");
        }
        try {
            DatabaseMetaData objDBMeta = objConn.getMetaData();
            objResultSet = objDBMeta.getPrimaryKeys(null, schema, tableName);
            lstPK = new ArrayList<String>();
            while (objResultSet.next()) {
                String strColumnName = objResultSet.getString("COLUMN_NAME").toUpperCase();
                lstPK.add(strColumnName);
            }
        } catch (SQLException e) {
            LOGGER.debug(e.getMessage(), e);
            throw new CapMetaDataException("获取数据表{0}的主键失败。", e, tableName);
        } finally {
            DBUtil.closeConnection(null, null, objResultSet);
        }
        return lstPK;
    }
    
    /**
     * 从数据库中获取存储过程
     * 
     * @param schema 数据库模式
     * @param procedurePattern 存储过名称模式
     * @param exact 精确的，TRUE表示精确查询，false表示模糊查询
     * @param conn 数据库连接元数据
     * 
     * @return 实体对象集合，当为精确查询时，返回的集合中应该只有一个实体对象
     * @see com.comtop.cap.bm.metadata.database.loader.IDatabaseLoader#loadTablePrimitiveKeyFormDataBase(java.lang.String,
     *      java.lang.String, com.comtop.cap.bm.metadata.database.util.MetaConnection)
     */
    @Override
    public List<ProcedureVO> loadProceduresFromDatabase(final String schema, final String procedurePattern,
        final boolean exact, final MetaConnection conn) {
        ProcedureVO objProcedureVO;
        List<ProcedureVO> lstProcedureVO = null;
        ResultSet objResultSet = null;
        String strUpperCaseTablePatten = StringUtil.isBlank(procedurePattern) ? "" : procedurePattern.toUpperCase();
        String strTablePatten;
        
        if (StringUtil.isBlank(procedurePattern)) {
            strTablePatten = exact ? "" : "%";
        } else {
            strTablePatten = (exact ? procedurePattern.replace("%", "") : "%" + procedurePattern + "%").toUpperCase();
        }
        Connection objConn = conn.getConn();
        if (objConn == null) {
            throw new CapMetaDataException("数据库连接失败！");
        }
        try {
            DatabaseMetaData objDBMeta = objConn.getMetaData();
            objResultSet = objDBMeta.getProcedures(null, schema, strTablePatten);
            
            lstProcedureVO = new ArrayList<ProcedureVO>();
            while (objResultSet.next()) {
                String strTableName = objResultSet.getString("PROCEDURE_NAME").toUpperCase();
                // 当名称中含有“_”可能会被JDBC API，当成任一字符，再次过滤，确保正确。
                if (strTableName.startsWith("BIN$") || !strTableName.contains(strUpperCaseTablePatten)) {
                    continue;
                }
                String strTableRemark = objResultSet.getString("REMARKS");
                int iProType = objResultSet.getInt("PROCEDURE_TYPE");
                
                objProcedureVO = new ProcedureVO();
                String strCHName = getChName(strTableName, strTableRemark);
                objProcedureVO.setChName(strCHName);
                objProcedureVO.setEngName(strTableName);
                objProcedureVO.setDescription(strTableRemark);
                
                boolean bFlag = true;
                if (iProType == 1) {
                    for (String strRemoveName : removelst) {
                        if (strTableName.endsWith(strRemoveName)) {
                            bFlag = false;
                            break;
                        }
                    }
                    if (bFlag) {
                        lstProcedureVO.add(objProcedureVO);
                    }
                }
            }
        } catch (SQLException e) {
            LOGGER.debug(e.getMessage(), e);
            throw new CapMetaDataException("获取数据数据库对象{0}的失败。", e, procedurePattern);
        } finally {
            DBUtil.closeConnection(null, null, objResultSet);
        }
        return lstProcedureVO;
    }
    
    /**
     * 获取数据库中存储过程字段
     * 
     * @param schema 数据库模式
     * @param procedureName 存储过程名称
     * @param conn 数据库连接
     * @return 表字段集合
     * @see com.comtop.cap.bm.metadata.database.loader.IDatabaseLoader#loadTablePrimitiveKeyFormDataBase(java.lang.String,
     *      java.lang.String, com.comtop.cap.bm.metadata.database.util.MetaConnection)
     */
    @Override
    public List<ProcedureColumnVO> loadProcedureColumnFromDataBase(final String schema, final String procedureName,
        final MetaConnection conn) {
        ProcedureColumnVO objProcedureColumnVO;
        List<ProcedureColumnVO> lstProcedureColumnVO = null;
        ResultSet objResultSet = null;
        Connection objConn = conn.getConn();
        if (objConn == null) {
            throw new CapMetaDataException("数据库连接失败！");
        }
        try {
            DatabaseMetaData objDBMeta = objConn.getMetaData();
            objResultSet = objDBMeta.getProcedureColumns(null, schema, procedureName, "%");
            lstProcedureColumnVO = new ArrayList<ProcedureColumnVO>();
            while (objResultSet.next()) {
                String strColumnName = objResultSet.getString("COLUMN_NAME");
                strColumnName = strColumnName != null ? StringUtil.uncapitalize(StringConvertor.toCamelCase(
                    strColumnName,
                    Integer.valueOf(preferencesFacade.getConfig("tableColumnPrefixIngore").getConfigValue()))) : "";
                int iColumnType = objResultSet.getInt("COLUMN_TYPE");
                // int iType = objResultSet.getInt("DATA_TYPE");
                String strTypeName = objResultSet.getString("TYPE_NAME");
                int iPrecision = objResultSet.getInt("PRECISION");
                int iLength = objResultSet.getInt("LENGTH");
                String strRemark = objResultSet.getString("REMARKS");
                objProcedureColumnVO = new ProcedureColumnVO();
                objProcedureColumnVO.setParameterName(strColumnName);
                objProcedureColumnVO.setParameterChName(getChName(strColumnName, strRemark));
                objProcedureColumnVO.setParameterType(iColumnType + "");
                objProcedureColumnVO.setDataType(strTypeName);
                objProcedureColumnVO.setPrecision(iPrecision);
                objProcedureColumnVO.setLength(iLength);
                objProcedureColumnVO.setDescription(strRemark);
                
                lstProcedureColumnVO.add(objProcedureColumnVO);
            }
        } catch (SQLException e) {
            LOGGER.debug(e.getMessage(), e);
            throw new CapMetaDataException("获取存储过程{0}的字段失败。", e, procedureName);
        } finally {
            DBUtil.closeConnection(null, null, objResultSet);
        }
        return lstProcedureColumnVO;
    }
    
    /**
     * 从数据库中获取函数
     * 
     * @param schema 数据库模式
     * @param functionPattern 函数名称模式
     * @param exact 精确的，TRUE表示精确查询，false表示模糊查询
     * @param conn 数据库连接元数据
     * 
     * @return 实体对象集合，当为精确查询时，返回的集合中应该只有一个实体对象
     * @see com.comtop.cap.bm.metadata.database.loader.IDatabaseLoader#loadTablePrimitiveKeyFormDataBase(java.lang.String,
     *      java.lang.String, com.comtop.cap.bm.metadata.database.util.MetaConnection)
     */
    @Override
    public List<FunctionVO> loadFunctionsFromDatabase(final String schema, final String functionPattern,
        final boolean exact, final MetaConnection conn) {
        FunctionVO objFunctionVO;
        List<FunctionVO> lstFunctionVO = null;
        ResultSet objResultSet = null;
        String strUpperCaseTablePatten = StringUtil.isBlank(functionPattern) ? "" : functionPattern.toUpperCase();
        String strTablePatten;
        
        if (StringUtil.isBlank(functionPattern)) {
            strTablePatten = exact ? "" : "%";
        } else {
            strTablePatten = (exact ? functionPattern.replace("%", "") : "%" + functionPattern + "%").toUpperCase();
        }
        Connection objConn = conn.getConn();
        if (objConn == null) {
            throw new CapMetaDataException("数据库连接失败！");
        }
        try {
            DatabaseMetaData objDBMeta = objConn.getMetaData();
            objResultSet = objDBMeta.getProcedures(null, schema, strTablePatten);
            
            lstFunctionVO = new ArrayList<FunctionVO>();
            while (objResultSet.next()) {
                String strTableName = objResultSet.getString("PROCEDURE_NAME").toUpperCase();
                // 当名称中含有“_”可能会被JDBC API，当成任一字符，再次过滤，确保正确。
                if (strTableName.startsWith("BIN$") || !strTableName.contains(strUpperCaseTablePatten)) {
                    continue;
                }
                String strTableRemark = objResultSet.getString("REMARKS");
                int iProType = objResultSet.getInt("PROCEDURE_TYPE");
                
                objFunctionVO = new FunctionVO();
                String strCHName = getChName(strTableName, strTableRemark);
                objFunctionVO.setChName(strCHName);
                objFunctionVO.setEngName(strTableName);
                objFunctionVO.setDescription(strTableRemark);
                
                boolean bFlag = true;
                if (iProType == 2) {
                    for (String strRemoveName : removelst) {
                        if (strTableName.endsWith(strRemoveName)) {
                            bFlag = false;
                            break;
                        }
                    }
                    if (bFlag) {
                        lstFunctionVO.add(objFunctionVO);
                    }
                }
            }
        } catch (SQLException e) {
            LOGGER.debug(e.getMessage(), e);
            throw new CapMetaDataException("获取数据库对象{0}的失败。", e, functionPattern);
        } finally {
            DBUtil.closeConnection(null, null, objResultSet);
        }
        return lstFunctionVO;
    }
    
    /**
     * 获取数据库中函数字段
     * 
     * @param schema 数据库模式
     * @param functionName 函数名称
     * @param conn 数据库连接
     * @return 表字段集合
     * @see com.comtop.cap.bm.metadata.database.loader.IDatabaseLoader#loadTablePrimitiveKeyFormDataBase(java.lang.String,
     *      java.lang.String, com.comtop.cap.bm.metadata.database.util.MetaConnection)
     */
    @Override
    public List<FunctionColumnVO> loadFunctionColumnFromDataBase(final String schema, final String functionName,
        final MetaConnection conn) {
        FunctionColumnVO objFunctionColumnVO;
        List<FunctionColumnVO> lstFunctionColumnVO = null;
        ResultSet objResultSet = null;
        Connection objConn = conn.getConn();
        if (objConn == null) {
            throw new CapMetaDataException("数据库连接失败！");
        }
        try {
            DatabaseMetaData objDBMeta = objConn.getMetaData();
            // objResultSet = objDBMeta.getFunctionColumns(null, schema, functionName, "%");
            objResultSet = objDBMeta.getProcedureColumns(null, schema, functionName, "%");
            lstFunctionColumnVO = new ArrayList<FunctionColumnVO>();
            while (objResultSet.next()) {
                String strColumnName = objResultSet.getString("COLUMN_NAME");
                strColumnName = strColumnName != null ? strColumnName : "";
                int iColumnType = objResultSet.getInt("COLUMN_TYPE");
                String strTypeName = objResultSet.getString("TYPE_NAME");
                // 4:表示属性为return值，也就是out参数，5：表示属性为result值，也为out参数
                if ("TABLE".equals(strTypeName) || "CLOB".equals(strTypeName)) {
                    continue;
                }
                if (5 == iColumnType) {
                    if ("".equals(strColumnName) || strColumnName == null) {
                        strColumnName = "F_RESULT";
                    }
                    iColumnType = 4;
                }
                if (4 == iColumnType && "".equals(strColumnName)) {
                    strColumnName = "F_RETURN";
                }
                // 当类型为1也就是默认输入参数时，如果参数名称为空，重命名为F_PARAM
                if (1 == iColumnType && "".equals(strColumnName)) {
                    strColumnName = "F_PARAM";
                }
                strColumnName = StringUtil.uncapitalize(StringConvertor.toCamelCase(strColumnName,
                    Integer.valueOf(preferencesFacade.getConfig("tableColumnPrefixIngore").getConfigValue())));
                int iPrecision = objResultSet.getInt("PRECISION");
                int iLength = objResultSet.getInt("LENGTH");
                String strRemark = objResultSet.getString("REMARKS");
                objFunctionColumnVO = new FunctionColumnVO();
                objFunctionColumnVO.setParameterName(strColumnName);
                objFunctionColumnVO.setParameterChName(getChName(strColumnName, strRemark));
                objFunctionColumnVO.setParameterType(iColumnType + "");
                objFunctionColumnVO.setDataType(strTypeName);
                objFunctionColumnVO.setPrecision(iPrecision);
                objFunctionColumnVO.setLength(iLength);
                objFunctionColumnVO.setDescription(strRemark);
                lstFunctionColumnVO.add(objFunctionColumnVO);
            }
        } catch (SQLException e) {
            LOGGER.debug(e.getMessage(), e);
            throw new CapMetaDataException("获取函数{0}的字段失败。", e, functionName);
        } finally {
            DBUtil.closeConnection(null, null, objResultSet);
        }
        Collections.reverse(lstFunctionColumnVO);
        return lstFunctionColumnVO;
    }
    
    /**
     * 获取数据库中表索引
     * 
     * @param schema 数据库模式
     * @param tableName 表名称
     * @param conn 数据库连接元数据
     * @return 表字段集合
     * @see com.comtop.cap.bm.metadata.database.loader.IDatabaseLoader#loadTablePrimitiveKeyFormDataBase(java.lang.String,
     *      java.lang.String, com.comtop.cap.bm.metadata.database.util.MetaConnection)
     */
    @Override
    public List<TableIndexVO> loadTableIndexesFromDataBase(final String schema, final String tableName,
        final MetaConnection conn) {
        TableIndexVO objIndex;
        List<IndexColumnVO> lstIndexColumnVO;
        List<TableIndexVO> lstIndex = null;
        ResultSet objResultSet = null;
        Map<String, TableIndexVO> objIndexMap = new HashMap<String, TableIndexVO>();
        Connection objConn = conn.getConn();
        if (objConn == null) {
            throw new CapMetaDataException("数据库连接失败！");
        }
        try {
            DatabaseMetaData objDBMeta = objConn.getMetaData();
            objResultSet = objDBMeta.getIndexInfo(null, schema, tableName, false, false);
            lstIndex = new ArrayList<TableIndexVO>();
            while (objResultSet.next()) {
                String strColumnName = objResultSet.getString("COLUMN_NAME");
                strColumnName = strColumnName != null ? strColumnName.toUpperCase() : "";
                String strIndexName = objResultSet.getString("INDEX_NAME");
                strIndexName = strIndexName != null ? strIndexName.toUpperCase() : "";
                short sType = objResultSet.getShort("TYPE");// 索引类型0,没有索引；1，聚集索引；2，哈希表HASH索引；3，BTREE索引
                String strAscending = objResultSet.getString("ASC_OR_DESC");// 列排序顺序:升序还是降序[A:升序; B:降序]
                boolean bNonUnique = objResultSet.getBoolean("NON_UNIQUE");// 索引值是否可以不唯一
                if (StringUtil.isAllBlank(strColumnName, strIndexName)) {
                    continue;
                }
                IndexColumnVO objIndexColumnVO;
                ColumnVO objColumnVO;
                if (objIndexMap.get(strIndexName) != null) {
                    objIndex = objIndexMap.get(strIndexName);
                    objIndexColumnVO = new IndexColumnVO();
                    objColumnVO = new ColumnVO();
                    objColumnVO.setCode(strColumnName);
                    objColumnVO.setEngName(strColumnName);
                    objIndexColumnVO.setColumn(objColumnVO);
                    lstIndexColumnVO = objIndex.getColumns();
                    lstIndexColumnVO.add(objIndexColumnVO);
                } else {
                    objIndex = new TableIndexVO();
                    objIndex.setChName(strIndexName);
                    objIndex.setEngName(strIndexName);
                    objIndex.setDescription(strIndexName);
                    objIndex.setType(String.valueOf(sType));// 索引类型
                    if (!bNonUnique) {
                        objIndex.setUnique(true);
                    }
                    
                    lstIndexColumnVO = new ArrayList<IndexColumnVO>();
                    objIndexColumnVO = new IndexColumnVO();
                    objColumnVO = new ColumnVO();
                    objColumnVO.setCode(strColumnName);
                    objColumnVO.setEngName(strColumnName);
                    objIndexColumnVO.setColumn(objColumnVO);
                    objIndexColumnVO.setAscending(strAscending);
                    // objIndexColumnVO.setExpression();
                    lstIndexColumnVO.add(objIndexColumnVO);
                    objIndex.setColumns(lstIndexColumnVO);
                    // TODO 待处理
                    objIndexMap.put(strIndexName, objIndex);
                    lstIndex.add(objIndex);
                }
            }
        } catch (SQLException e) {
            LOGGER.error(e.getMessage(), e);
            throw new CapMetaDataException("获取数据表{0}的索引失败。", e, tableName);
        } finally {
            DBUtil.closeConnection(null, null, objResultSet);
        }
        return lstIndex;
    }
    
}
