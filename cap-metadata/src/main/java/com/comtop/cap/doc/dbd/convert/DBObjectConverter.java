/******************************************************************************
 * Copyright (C) 2015 ShenZhen ComTop Information Technology Co.,Ltd
 * All Rights Reserved.
 * 本软件为深圳康拓普开发研制。未经本公司正式书面同意，其他任何个人、团体不得使用、
 * 复制、修改或发布本软件.
 *****************************************************************************/

package com.comtop.cap.doc.dbd.convert;

import java.util.ArrayList;
import java.util.List;

import com.comtop.cap.bm.metadata.database.dbobject.model.ColumnVO;
import com.comtop.cap.bm.metadata.database.dbobject.model.FunctionColumnVO;
import com.comtop.cap.bm.metadata.database.dbobject.model.FunctionVO;
import com.comtop.cap.bm.metadata.database.dbobject.model.ProcedureColumnVO;
import com.comtop.cap.bm.metadata.database.dbobject.model.ProcedureVO;
import com.comtop.cap.bm.metadata.database.dbobject.model.TableVO;
import com.comtop.cap.bm.metadata.database.dbobject.model.ViewColumnVO;
import com.comtop.cap.bm.metadata.database.dbobject.model.ViewVO;
import com.comtop.cap.doc.dbd.model.DBColumnDTO;
import com.comtop.cap.doc.dbd.model.DBObjectDTO;
import com.comtop.cip.common.util.CAPCollectionUtils;

/**
 * dto vo转换器
 * 
 * @author 李小强
 * @since 1.0
 * @version 2015-12-30 李小强
 */
public class DBObjectConverter {
    
    /**
     * 构造函数
     */
    private DBObjectConverter() {
        //
    }
    
    /**
     * 将tableVO 数据转换到DBObjectDTO
     * 
     * @param vo
     *            TableVO
     * @param dto
     *            DBObjectDTO
     */
    public static void tableVO2DBObjectDTO(TableVO vo, DBObjectDTO dto) {
        dto.setCode(vo.getEngName());
        dto.setName(vo.getChName());
        dto.setComment(vo.getDescription());
        List<ColumnVO> columns = vo.getColumns();
        if (CAPCollectionUtils.isNotEmpty(columns)) {
            List<DBColumnDTO> columnList = new ArrayList<DBColumnDTO>(columns.size());
            for (ColumnVO colVo : columns) {
                DBColumnDTO colDto = new DBColumnDTO();
                DBColumnConverter.columnVO2DBTableColumnDTO(colVo, colDto);
                columnList.add(colDto);
            }
            dto.setColumnList(columnList);
            dto.setType(DBObjectDTO.DBOBJECT_TYPE_TABLE);
            dto.setCnName(vo.getChName());
        }
    }
    
    /**
     * 将ViewVO 数据转换到DBObjectDTO
     * 
     * @param vo
     *            TableVO
     * @param dto
     *            DBObjectDTO
     */
    public static void viewVO2DBObjectDTO(ViewVO vo, DBObjectDTO dto) {
        dto.setCode(vo.getEngName());
        dto.setName(vo.getChName());
        dto.setComment(vo.getDescription());
        List<ViewColumnVO> columns = vo.getColumns();
        if (CAPCollectionUtils.isNotEmpty(columns)) {
            List<DBColumnDTO> columnList = new ArrayList<DBColumnDTO>(columns.size());
            for (ViewColumnVO colVo : columns) {
                DBColumnDTO colDto = new DBColumnDTO();
                DBColumnConverter.viewColumnVO2DBTableColumnDTO(colVo, colDto);
                columnList.add(colDto);
            }
            dto.setType(DBObjectDTO.DBOBJECT_TYPE_VIEW);
            dto.setColumnList(columnList);
        }
    }
    
    /**
     * 将procedureVO 数据转换到DBObjectDTO
     * 
     * @param vo
     *            TableVO
     * @param dto
     *            DBObjectDTO
     */
    public static void procedureVO2DBObjectDTO(ProcedureVO vo, DBObjectDTO dto) {
        dto.setCode(vo.getEngName());
        dto.setName(vo.getChName());
        dto.setComment(vo.getDescription());
        List<ProcedureColumnVO> procedureColumns = vo.getProcedureColumns();
        if (CAPCollectionUtils.isNotEmpty(procedureColumns)) {
            List<DBColumnDTO> columnList = new ArrayList<DBColumnDTO>(procedureColumns.size());
            for (ProcedureColumnVO colVo : procedureColumns) {
                DBColumnDTO colDto = new DBColumnDTO();
                DBColumnConverter.procedureColumnVO2DBTableColumnDTO(colVo, colDto);
                columnList.add(colDto);
            }
            dto.setType(DBObjectDTO.DBOBJECT_TYPE_PROCEDURE);
            dto.setColumnList(columnList);
        }
    }
    
    /**
     * 将FunctionVO 数据转换到DBObjectDTO
     * 
     * @param vo
     *            FunctionVO
     * @param dto
     *            DBObjectDTO
     */
    public static void functionVOVO2DBObjectDTO(FunctionVO vo, DBObjectDTO dto) {
        dto.setCode(vo.getEngName());
        dto.setName(vo.getChName());
        dto.setComment(vo.getDescription());
        List<FunctionColumnVO> functionColumns = vo.getFunctionColumns();
        if (CAPCollectionUtils.isNotEmpty(functionColumns)) {
            List<DBColumnDTO> columnList = new ArrayList<DBColumnDTO>(functionColumns.size());
            for (FunctionColumnVO colVo : functionColumns) {
                DBColumnDTO colDto = new DBColumnDTO();
                DBColumnConverter.functionColumnVO2DBTableColumnDTO(colVo, colDto);
                columnList.add(colDto);
            }
            dto.setType(DBObjectDTO.DBOBJECT_TYPE_FUNCTION);
            dto.setColumnList(columnList);
        }
    }
    
    /**
     * 将tableVO 数据转换到DBObjectDTO
     * 
     * @param lstVo
     *            TableVO
     * @param lstDto
     *            DBObjectDTO
     */
    public static void tableVOs2DBObjectDTOs(List<TableVO> lstVo, List<DBObjectDTO> lstDto) {
        for (TableVO vo : lstVo) {
            DBObjectDTO dto = new DBObjectDTO();
            tableVO2DBObjectDTO(vo, dto);
            lstDto.add(dto);
        }
    }
    
    /**
     * 将tableVO 数据转换到DBObjectDTO
     * 
     * @param lstVo
     *            ViewVO
     * @param lstDto
     *            DBObjectDTO
     */
    public static void viewVOs2DBObjectDTOs(List<ViewVO> lstVo, List<DBObjectDTO> lstDto) {
        for (ViewVO vo : lstVo) {
            DBObjectDTO dto = new DBObjectDTO();
            viewVO2DBObjectDTO(vo, dto);
            lstDto.add(dto);
        }
    }
    
    /**
     * 将tableVO 数据转换到DBObjectDTO
     * 
     * @param lstVo
     *            ViewVO
     * @param lstDto
     *            DBObjectDTO
     */
    public static void procedureVOs2DBObjectDTOs(List<ProcedureVO> lstVo, List<DBObjectDTO> lstDto) {
        for (ProcedureVO vo : lstVo) {
            DBObjectDTO dto = new DBObjectDTO();
            procedureVO2DBObjectDTO(vo, dto);
            lstDto.add(dto);
        }
    }
    
    /**
     * 将FunctionVO 数据转换到DBObjectDTO
     * 
     * @param lstVo
     *            FunctionVO
     * @param lstDto
     *            DBObjectDTO
     */
    public static void functionVOs2DBObjectDTOs(List<FunctionVO> lstVo, List<DBObjectDTO> lstDto) {
        for (FunctionVO vo : lstVo) {
            DBObjectDTO dto = new DBObjectDTO();
            functionVOVO2DBObjectDTO(vo, dto);
            lstDto.add(dto);
        }
    }
    
}
