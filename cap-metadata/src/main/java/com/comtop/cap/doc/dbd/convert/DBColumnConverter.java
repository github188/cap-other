/******************************************************************************
 * Copyright (C) 2015 ShenZhen ComTop Information Technology Co.,Ltd
 * All Rights Reserved.
 * 本软件为深圳康拓普开发研制。未经本公司正式书面同意，其他任何个人、团体不得使用、
 * 复制、修改或发布本软件.
 *****************************************************************************/

package com.comtop.cap.doc.dbd.convert;

import com.comtop.cap.bm.metadata.database.dbobject.model.ColumnVO;
import com.comtop.cap.bm.metadata.database.dbobject.model.FunctionColumnVO;
import com.comtop.cap.bm.metadata.database.dbobject.model.ProcedureColumnVO;
import com.comtop.cap.bm.metadata.database.dbobject.model.ViewColumnVO;
import com.comtop.cap.doc.dbd.model.DBColumnDTO;
import com.comtop.cap.document.expression.util.DocStringUtils;

/**
 * dto vo转换器
 * 
 * @author 李小强
 * @since 1.0
 * @version 2015-12-30 李小强
 */
public class DBColumnConverter {
    
    /**
     * 构造函数
     */
    private DBColumnConverter() {
        //
    }
    
    /**
     * 存储过程参数类型集合
     */
    static final String[] PRODURE_FIELD_TYPE_DATA = { "procedureColumnUnknown", "procedureColumnIn",
        "procedureColumnInOut", "procedureColumnOut", "procedureColumnReturn", "procedureColumnResult" };
    
    /**
     * 函数参数类型集合
     */
    static final String[] FUNCTION_FIELD_TYPE_DATA = { "FunctionColumnUnknown", "FunctionColumnIn",
        "FunctionColumnInOut", "FunctionColumnOut", "FunctionColumnReturn", "FunctionColumnResult" };
    
    /**
     * columnVO2DBTableColumnDTO
     * 
     * @param vo ColumnVO
     * @param dto DBTableColumnDTO
     */
    public static void columnVO2DBTableColumnDTO(ColumnVO vo, DBColumnDTO dto) {
        dto.setCode(vo.getEngName());
        dto.setComment(vo.getDescription());
        dto.setName(vo.getChName());
        dto.setDataType(vo.getDataType());
        dto.setLength(vo.getLength());
        dto.setEnableNull(vo.getCanBeNull() ? "Y" : "N");
        dto.setPrecision(vo.getPrecision());
        dto.setDefaultValue(vo.getDefaultValue());
        dto.setRemark(vo.getDescription());
        dto.setIsPrimaryKey(vo.getIsPrimaryKEY() ? "Y" : "N");
    }
    
    /**
     * viewColumnVO2DBTableColumnDTO
     * 
     * @param vo ColumnVO
     * @param dto DBTableColumnDTO
     */
    public static void viewColumnVO2DBTableColumnDTO(ViewColumnVO vo, DBColumnDTO dto) {
        dto.setCode(vo.getEngName());
        dto.setComment(vo.getDescription());
        dto.setName(vo.getChName());
        dto.setDataType(vo.getDataType());
        dto.setLength(vo.getLength());
        dto.setPrecision(vo.getPrecision());
    }
    
    /**
     * functionColumnVO2DBTableColumnDTO
     * 
     * @param vo ColumnVO
     * @param dto DBTableColumnDTO
     */
    public static void functionColumnVO2DBTableColumnDTO(FunctionColumnVO vo, DBColumnDTO dto) {
        dto.setCode(vo.getParameterName());
        dto.setComment(vo.getDescription());
        dto.setName(vo.getParameterName());
        dto.setLength(vo.getLength());
        dto.setColumnType(getDBObjectColParamType(vo.getParameterType(), FUNCTION_FIELD_TYPE_DATA));//
        dto.setDataType(vo.getDataType());
    }
    
    /**
     * procedureColumnVO2DBTableColumnDTO
     * 
     * @param vo ColumnVO
     * @param dto DBTableColumnDTO
     */
    public static void procedureColumnVO2DBTableColumnDTO(ProcedureColumnVO vo, DBColumnDTO dto) {
        dto.setCode(vo.getParameterName());
        dto.setName(vo.getParameterName());
        dto.setComment(vo.getDescription());
        dto.setDataType(vo.getDataType());
        dto.setLength(vo.getLength());
        dto.setColumnType(getDBObjectColParamType(vo.getParameterType(), PRODURE_FIELD_TYPE_DATA));//
    }
    
    /**
     * 根据变量原始参数类型 <int> 值获取翻译后的数据库对象参数类型
     * 
     * @param techType 数据库对象原始参数类型
     * @param fieldTypeData 集合数据
     * @return 翻译后的数据库对象参数类型
     */
    public static String getDBObjectColParamType(String techType, String[] fieldTypeData) {
        int indexNo = Integer.parseInt(techType);
        return DocStringUtils.getTextByIndexNo(indexNo, fieldTypeData);
    }
    
}
