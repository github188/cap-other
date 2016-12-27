/******************************************************************************
 * Copyright (C) 2014 ShenZhen ComTop Information Technology Co.,Ltd
 * All Rights Reserved.
 * 本软件为深圳康拓普开发研制。未经本公司正式书面同意，其他任何个人、团体不得使用、
 * 复制、修改或发布本软件.
 *****************************************************************************/

package com.comtop.cap.bm.biz.info.common;

import java.util.ArrayList;
import java.util.List;

import com.comtop.cap.bm.biz.common.model.BizCommonVO;
import com.comtop.cap.bm.biz.common.model.BizDataCommonVO;
import com.comtop.cap.bm.metadata.database.dbobject.model.ColumnVO;
import com.comtop.cap.bm.metadata.database.dbobject.model.TableVO;
import com.comtop.cap.bm.metadata.database.dbobject.util.DBType;
import com.comtop.cap.bm.metadata.database.dbobject.util.DBTypeAdapter;
import com.comtop.cap.bm.metadata.database.dbobject.util.TableSysncEntityUtil;
import com.comtop.cap.bm.metadata.sysmodel.facade.SysmodelFacade;
import com.comtop.cap.bm.metadata.sysmodel.model.CapPackageVO;
import com.comtop.corm.resource.util.CollectionUtils;
import com.comtop.top.component.app.session.HttpSessionUtil;
import com.comtop.top.core.jodd.AppContext;

/**
 * 业务对象导入
 * 
 * @author 林玉千
 * @since jdk1.6
 * @version 2016-11-3 林玉千
 */

public class BizObjImportOperator {
    
    /** 包Facade */
    private final SysmodelFacade packageFacade = AppContext.getBean(SysmodelFacade.class);
    
	/** 列数据类型 */
	private static final String COLUMN_DATATYPE_ORACLE = "VARCHAR2";

	/** 列数据类型 */
	private static final String COLUMN_DATATYPE_MYSQL = "VARCHAR";
    
    /**
     * 业务对象转表元数据
     * 
     * @param lstBizCommon 业务对象
     * @return 表元数据
     */
    public TableVO parserBizToTable(List<BizCommonVO> lstBizCommon) {
        if (CollectionUtils.isEmpty(lstBizCommon)) {
            return null;
        }
        TableVO objTableVO = new TableVO();
        // 获取列表中第一个对象，用于设置表信息
        BizCommonVO bizCommonVO = lstBizCommon.get(0);
        // 获取列表中所有对象的数据项，用于设置列信息
        List<BizDataCommonVO> lstBizDataCommon = new ArrayList<BizDataCommonVO>();
        for (int i = 0; i < lstBizCommon.size(); i++) {
            lstBizDataCommon.addAll(lstBizCommon.get(i).getDataItems());
        }
        // 设置表的基本信息
        setBasicMessageToTableVO(objTableVO);
        
        // 将业务对象转换为表对象
        tranferBizObjToTableVO(objTableVO, bizCommonVO);
        
        // 将数据项信息转换为列
        tranferDataItemsToColumns(objTableVO, lstBizDataCommon, bizCommonVO.getCode());
        
        // 设置包信息
        setPackageMessageToTableVO(objTableVO, bizCommonVO.getPackageId());
        // 获取字段集合
        return objTableVO;
    }
    
    /**
     * 将数据项信息转换为列
     * 
     * @param objTableVO 表对象
     * @param lstBizDataCommon 数据项列表
     * @param tableName 表名
     */
    private void tranferDataItemsToColumns(TableVO objTableVO, List<BizDataCommonVO> lstBizDataCommon, String tableName) {
		DBType dbType = DBTypeAdapter.getDBType();
		if (DBType.ORACLE.getValue().equals(dbType.getValue())) {
			tranferColumnOracle(objTableVO, lstBizDataCommon, tableName);
			return;
		} else if (DBType.MYSQL.getValue().equals(dbType.getValue())) {
			tranferColumnMySQL(objTableVO, lstBizDataCommon, tableName);
			return;
		}
		
		tranferColumnOracle(objTableVO, lstBizDataCommon, tableName);
    }
    
    /**
     * 将数据项信息转换为列 oracle
     * 
     * @param objTableVO 表对象
     * @param lstBizDataCommon 数据项列表
     * @param tableName 表名
     */
	private void tranferColumnOracle(TableVO objTableVO,
			List<BizDataCommonVO> lstBizDataCommon, String tableName) {
		List<ColumnVO> columnVOs = new ArrayList<ColumnVO>();
		// 由于业务对象选择出来的数据项信息无法体现主键信息,所以自定义创建一个信息添加主键列
		columnVOs.add(TableSysncEntityUtil.autoCreatePrimarykeyColumn(standardizeName(tableName)));
		// 添加普通列
		for (int i = 0; i < lstBizDataCommon.size(); i++) {
			ColumnVO objColumnVO = new ColumnVO();
			BizDataCommonVO objBizDataCommonVO = lstBizDataCommon.get(i);
			objColumnVO.setId(objBizDataCommonVO.getId());
			objColumnVO.setEngName(standardizeName(objBizDataCommonVO.getCode()));
			objColumnVO.setCode(standardizeName(objBizDataCommonVO.getCode()));
			objColumnVO.setChName(objBizDataCommonVO.getName());
			objColumnVO.setTableCode(standardizeName(tableName));
			objColumnVO.setDescription(objBizDataCommonVO.getName());
			objColumnVO.setDataType(COLUMN_DATATYPE_ORACLE);
			objColumnVO.setDefaultValue("");
			objColumnVO.setIsForeignKey(false);
			objColumnVO.setIsPrimaryKEY(false);
			objColumnVO.setIsUnique(false);
			objColumnVO.setCanBeNull(true);
			objColumnVO.setLength(100);
			objColumnVO.setPrecision(0);
			columnVOs.add(objColumnVO);
		}
		objTableVO.setColumns(columnVOs);
	}
	
	 /**
     * 将数据项信息转换为列 mysql
     * 
     * @param objTableVO 表对象
     * @param lstBizDataCommon 数据项列表
     * @param tableName 表名
     */
	private void tranferColumnMySQL(TableVO objTableVO,
			List<BizDataCommonVO> lstBizDataCommon, String tableName) {
		List<ColumnVO> columnVOs = new ArrayList<ColumnVO>();
		// 由于业务对象选择出来的数据项信息无法体现主键信息,所以自定义创建一个信息添加主键列
		columnVOs.add(TableSysncEntityUtil.autoCreatePrimarykeyColumnMySQL(standardizeName(tableName)));
		// 添加普通列
		for (int i = 0; i < lstBizDataCommon.size(); i++) {
			ColumnVO objColumnVO = new ColumnVO();
			BizDataCommonVO objBizDataCommonVO = lstBizDataCommon.get(i);
			objColumnVO.setId(objBizDataCommonVO.getId());
			objColumnVO.setEngName(standardizeName(objBizDataCommonVO.getCode()));
			objColumnVO.setCode(standardizeName(objBizDataCommonVO.getCode()));
			objColumnVO.setChName(objBizDataCommonVO.getName());
			objColumnVO.setTableCode(standardizeName(tableName));
			objColumnVO.setDescription(objBizDataCommonVO.getName());
			objColumnVO.setDataType(COLUMN_DATATYPE_MYSQL);
			objColumnVO.setDefaultValue("");
			objColumnVO.setIsForeignKey(false);
			objColumnVO.setIsPrimaryKEY(false);
			objColumnVO.setIsUnique(false);
			objColumnVO.setCanBeNull(true);
			objColumnVO.setLength(100);
			objColumnVO.setPrecision(0);
			columnVOs.add(objColumnVO);
		}
		objTableVO.setColumns(columnVOs);
	}
    
    /**
     * 将业务对象转换为表对象
     * 
     * @param objTableVO 表对象
     * @param ObjBizCommonVO 业务对象
     */
    private void tranferBizObjToTableVO(TableVO objTableVO, BizCommonVO ObjBizCommonVO) {
        // 设置Id
        objTableVO.setId(ObjBizCommonVO.getId());
        // 中文名称
        objTableVO.setChName(ObjBizCommonVO.getName());
        // 英文名称
        objTableVO.setEngName(standardizeName(ObjBizCommonVO.getCode()));
        // 编码
        objTableVO.setCode(standardizeName(ObjBizCommonVO.getCode()));
        // 注释
        objTableVO.setDescription(ObjBizCommonVO.getDescription());
    }
    
    /**
     * 设置表的基本信息
     * 
     * @param objTableVO 表对象
     */
    private void setBasicMessageToTableVO(TableVO objTableVO) {
        // 设置创建者
        objTableVO.setCreaterId(HttpSessionUtil.getCurUserId());
        objTableVO.setCreaterName((String) HttpSessionUtil.getCurUserProperty("employeeName"));
        objTableVO.setCreateTime(System.currentTimeMillis());
    }
    
    /**
     * 设置表的包信息
     * 
     * @param objTableVO 表对象
     * @param packageId 包ID
     */
    private void setPackageMessageToTableVO(TableVO objTableVO, String packageId) {
        // 查询指定的包
        CapPackageVO objPackageVO = packageFacade.queryPackageById(packageId);
        objTableVO.setModelPackage(objPackageVO.getFullPath());
        objTableVO.setModelType("table");
        objTableVO.setModelName(objTableVO.getEngName());
        //objTableVO.setModelId(objTableVO.getModelPackage() + "." + objTableVO.getModelType() + "." + objTableVO.getModelName());
    }
    
    /**
     * 规范化名称方法 ,将业务对象中有关-号变为_下划线
     * 
     * @param name 名称
     * @return 标准化后的方法
     */
    private String standardizeName(String name) {
        if (null == name) {
            return "";
        }
        return name.replaceAll("-", "_").toUpperCase();
    }
}
