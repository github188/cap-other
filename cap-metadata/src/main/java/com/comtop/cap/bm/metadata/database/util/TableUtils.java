/******************************************************************************
 * Copyright (C) 2014 ShenZhen ComTop Information Technology Co.,Ltd
 * All Rights Reserved.
 * 本软件为深圳康拓普开发研制。未经本公司正式书面同意，其他任何个人、团体不得使用、
 * 复制、修改或发布本软件.
 *****************************************************************************/

package com.comtop.cap.bm.metadata.database.util;

import java.lang.reflect.Field;
import java.util.ArrayList;
import java.util.Arrays;
import java.util.HashMap;
import java.util.HashSet;
import java.util.List;
import java.util.Map;
import java.util.Set;

import org.springframework.beans.BeanUtils;

import com.comtop.cap.bm.metadata.database.dbobject.model.ColumnCompareResult;
import com.comtop.cap.bm.metadata.database.dbobject.model.ColumnVO;
import com.comtop.cap.bm.metadata.database.dbobject.model.IndexColumnVO;
import com.comtop.cap.bm.metadata.database.dbobject.model.IndexCompareResult;
import com.comtop.cap.bm.metadata.database.dbobject.model.TableCompareResult;
import com.comtop.cap.bm.metadata.database.dbobject.model.TableIndexVO;
import com.comtop.cap.bm.metadata.database.dbobject.model.TableVO;
import com.comtop.cap.bm.metadata.entity.model.CompareIgnore;
import com.comtop.cip.common.util.builder.EqualsBuilder;

/**
 * 表工具类
 * 
 * @author 林玉千
 * @since jdk1.6
 * @version 2016-9-26 林玉千 新建
 */
public final class TableUtils {
    
    /**
     * 构造函数
     */
    private TableUtils() {
        super();
    }
    
    /**
     * 比较表
     * 
     * @param srcTableVO 源表VO 本地表源数据
     * @param targetTableVO 目标表VO 数据库中最新表元数据
     * @param tableName 表名
     * @return 表比较结果
     */
    public static TableCompareResult compareTable(TableVO srcTableVO, TableVO targetTableVO, String tableName) {
        TableCompareResult objResult = new TableCompareResult();
        objResult.setSrcTable(srcTableVO);
        objResult.setTargetTable(targetTableVO);
        // 目标表不存在
        if (null == targetTableVO) {
            objResult.setResult(TableCompareResult.TABLE_NOT_EXISTS);
            return objResult;
        }
        
        // 比较表描述
        if (isChangeDescription(srcTableVO, targetTableVO)) {
            objResult.setResult(TableCompareResult.TABLE_DIFF);
        }
        
        // 比较表索引
        if (isChangeIndex(srcTableVO, targetTableVO)) {
            objResult.setResult(TableCompareResult.TABLE_DIFF);
            // 封装索引比较结果对象
            setIndexCompareResultList(objResult, srcTableVO, targetTableVO);
        }
        
        // 比较表字段
        // 封装字段比较结果对象
        setColumnCompareResultList(objResult, srcTableVO, targetTableVO, tableName);
        
        return objResult;
    }
    
    /**
     * 封装表结果中的列
     * 
     * @param objResult 表的比较结果
     * @param srcTableVO 元数据表
     * @param targetTableVO 数据库最新表
     * @param tableName 表名
     */
    private static void setColumnCompareResultList(TableCompareResult objResult, TableVO srcTableVO,
        TableVO targetTableVO, String tableName) {
        // 比较表字段
        // 获取目标表的列，并进行整理
        List<ColumnVO> lstTargetColumn = targetTableVO.getColumns();
        Map<String, ColumnVO> objMapTargetColumn = new HashMap<String, ColumnVO>();
        for (ColumnVO objColumn : lstTargetColumn) {
            objMapTargetColumn.put(objColumn.getCode(), objColumn);
        }
        
        // 获取源表的列，并进行比较
        List<ColumnVO> lstSrcColumn = srcTableVO.getColumns();
        for (ColumnVO objSrcColumn : lstSrcColumn) {
            if (null != objSrcColumn.getCode()) {
                // 1、 如果源数据列存在于目标数据列时，比较列里面的属性
                // 2、如果源数据列有而目标数据没有，说明字段已经被删除
                if (objMapTargetColumn.containsKey(objSrcColumn.getCode())) {
                    // 修改列属性
                    ColumnCompareResult objRet = compareColumn(objSrcColumn,
                        objMapTargetColumn.get(objSrcColumn.getCode()), tableName);
                    objResult.addColumnResult(objRet);
                    // 递归将比较过的列删除
                    objMapTargetColumn.remove(objSrcColumn.getCode());
                    
                } else if (!objMapTargetColumn.containsKey(objSrcColumn.getCode())) {
                    // 删除列
                    ColumnCompareResult objRet = deleteColumn(objSrcColumn, tableName);
                    objResult.addColumnResult(objRet);
                }
            }
        }
        // 3、如果目标数据列的Map中仍存在数据，说明剩下来的数据为目标数据列中有而源数据列中没有的列，此时为数据表新增的字段
        if (objMapTargetColumn.size() > 0) {
            // 新增列
            for (String key : objMapTargetColumn.keySet()) {
                ColumnCompareResult objRet = addColumn(objMapTargetColumn.get(key), tableName);
                objResult.addColumnResult(objRet);
            }
        }
        
    }
    
    /**
     * 获取索引比较结果列表
     * 
     * @param objResult 表比较结果对象
     * @param srcTableVO 元数据表
     * @param targetTableVO 数据库最新表
     */
    private static void setIndexCompareResultList(TableCompareResult objResult, TableVO srcTableVO,
        TableVO targetTableVO) {
        List<TableIndexVO> srcIndexs = srcTableVO.getIndexs();
        List<TableIndexVO> targetIndexs = targetTableVO.getIndexs();
        Map<String, TableIndexVO> indexMap = new HashMap<String, TableIndexVO>();
        // 将源索引的名称和列列表封装到indexMap
        for (TableIndexVO index : targetIndexs) {
            if (index.isUnique()
                && targetTableVO.getColumnVOByColumnEngName(index.getColumns().get(0).getColumn().getEngName())
                    .getIsPrimaryKEY()) {
                index.setPrimary(true);
            }
            indexMap.put(index.getEngName(), index);
        }
        // 遍历目标索引跟indexMap进行过滤返回结果
        for (TableIndexVO idx : srcIndexs) {
            if (idx.isUnique()
                && srcTableVO.getColumnVOByColumnEngName(idx.getColumns().get(0).getColumn().getEngName())
                    .getIsPrimaryKEY()) {
                idx.setPrimary(true);
            }
            // 1、 如果源数据索引存在于目标数据列时，比较索引里面的属性
            // 2、如果源数据索引有而目标数据没有，说明索引已经被删除
            if (indexMap.containsKey(idx.getEngName())) {
                TableIndexVO targetTemp = indexMap.get(idx.getEngName());
                IndexCompareResult objIndexResult = compareIndex(idx, targetTemp);
                objResult.addIndexResult(objIndexResult);
                indexMap.remove(idx.getEngName());
            } else {
                IndexCompareResult objIndexResult = deleteIndex(idx);
                objResult.addIndexResult(objIndexResult);
            }
        }
        
        // 3、如果目标数据索引的Map中仍存在数据，说明剩下来的数据为目标数据索引中有而源数据列中没有的索引，此时为数据表新增的索引
        if (indexMap.size() > 0) {
            for (String key : indexMap.keySet()) {
                IndexCompareResult objIndexResult = addIndex(indexMap.get(key));
                objResult.addIndexResult(objIndexResult);
            }
        }
    }
    
    /**
     * 表字段比较
     * 
     * 
     * @param srcColumn 源属性
     * @param targetColumn 目标属性
     * @param tableName 表名
     * @return 比较结果 {@link com.comtop.cap.bm.metadata.database.dbobject.model.ColumnCompareResult}
     */
    private static ColumnCompareResult compareColumn(final ColumnVO srcColumn, final ColumnVO targetColumn,
        final String tableName) {
        ColumnCompareResult objResult = new ColumnCompareResult(srcColumn.getCode());
        objResult.setSrcColumn(srcColumn);
        objResult.setTargetColumn(targetColumn);
        objResult.setTableName(tableName);
        
        // 1、先比较存在@CompareIgnore注解的属性
        // 比较时忽略的属性列表
        List<String> lstExcludeField = getExcludeFields();
        boolean bEquals = EqualsBuilder.reflectionEquals(srcColumn, targetColumn, lstExcludeField);
        if (bEquals) {
            objResult.setResult(ColumnCompareResult.COLUMN_EQUAL);
            return objResult;
        }
        // 2、然后递归忽略没有@CompareIgnore注解的属性
        // 获取需要比较的属性列表
        List<String> lstIncludeField = getIncludeFields();
        // 剩下比较的字段列表
        List<String> lstIncludeFieldTemp = getIncludeFields();
        Set<Integer> lstType = new HashSet<Integer>();
        for (String includeField : lstIncludeField) {
            // 比较前一个一个比
            lstIncludeFieldTemp.remove(includeField);
            lstExcludeField.addAll(lstIncludeFieldTemp);
            bEquals = EqualsBuilder.reflectionEquals(srcColumn, targetColumn, lstExcludeField);
            if (!bEquals) {
                // 如果字段比较结果不同，则计入比较结果列表，用于生成代码
                lstType.add(ColumnCompareResult.getDiffType(includeField));
            }
            // 比较后将刚比较的字段加入忽略字段
            lstExcludeField.add(includeField);
            lstExcludeField.removeAll(lstIncludeFieldTemp);
        }
        
		objResult.setLstResult(new ArrayList<Integer>(lstType));
        objResult.setResult(ColumnCompareResult.COLUMN_DIFF);
        
        return objResult;
    }
    
    /**
     * 新增列
     * 
     * @param columnVO 列对象
     * @param tableName 表名
     * @return 列比较的结果对象
     */
    private static ColumnCompareResult addColumn(ColumnVO columnVO, String tableName) {
        ColumnCompareResult objResult = new ColumnCompareResult();
        objResult.setResult(ColumnCompareResult.COLUMN_ADD);
        objResult.setTargetColumn(columnVO);
        objResult.setTableName(tableName);
        return objResult;
    }
    
    /**
     * 删除列
     * 
     * @param columnVO 列对象
     * @param tableName 表名
     * @return 列比较结果对象
     */
    private static ColumnCompareResult deleteColumn(ColumnVO columnVO, String tableName) {
        ColumnCompareResult objResult = new ColumnCompareResult();
        objResult.setResult(ColumnCompareResult.COLUMN_DEL);
        objResult.setSrcColumn(columnVO);
        objResult.setTableName(tableName);
        return objResult;
    }
    
    /**
     * 
     * 比较索引
     * 
     * @param srcIndex 源索引
     * @param targetIndex 数据库最新索引
     * @return 索引比较结果
     */
    private static IndexCompareResult compareIndex(final TableIndexVO srcIndex, final TableIndexVO targetIndex) {
        IndexCompareResult objIndexResult = new IndexCompareResult();
        objIndexResult.setSrcIndex(srcIndex);
        objIndexResult.setTargetIndex(targetIndex);
        objIndexResult.setStrTargetIndexColumn(targetIndex);
        List<String> lstSrcColumn = new ArrayList<String>();
        List<IndexColumnVO> columns = srcIndex.getColumns();
        for (IndexColumnVO col : columns) {
            lstSrcColumn.add(col.getColumn().getCode());
        }
        List<String> lstTargetColumn = new ArrayList<String>();
        List<IndexColumnVO> lstColumns = targetIndex.getColumns();
        for (IndexColumnVO objcol : lstColumns) {
            lstTargetColumn.add(objcol.getColumn().getCode());
        }
        if (isChangeIndexColumn(lstSrcColumn, lstTargetColumn)) {
            objIndexResult.setResult(IndexCompareResult.INDEX_DIFF);
        } else {
            objIndexResult.setResult(IndexCompareResult.INDEX_EQUAL);
        }
        return objIndexResult;
    }
    
    /**
     * 删除索引
     * 
     * @param index 索引对象
     * @return 索引比较结果对象
     */
    private static IndexCompareResult deleteIndex(TableIndexVO index) {
        IndexCompareResult objResult = new IndexCompareResult();
        objResult.setResult(IndexCompareResult.INDEX_DEL);
        objResult.setSrcIndex(index);
        return objResult;
    }
    
    /**
     * 新增索引
     * 
     * @param index 索引对象
     * @return 索引比较结果对象
     */
    private static IndexCompareResult addIndex(TableIndexVO index) {
        IndexCompareResult objResult = new IndexCompareResult();
        objResult.setResult(IndexCompareResult.INDEX_ADD);
        objResult.setTargetIndex(index);
        objResult.setStrTargetIndexColumn(index);
        return objResult;
    }
    
    /**
     * 取得列属性VO中忽略比较的字段名称集合
     * 
     * @return 忽略比较的字段名称集合
     */
    private static List<String> getExcludeFields() {
        List<String> lstExcludeFields = new ArrayList<String>();
        Field[] fields = ColumnVO.class.getDeclaredFields();
        for (Field field : fields) {
            if (null != field.getAnnotation(CompareIgnore.class)) {
                lstExcludeFields.add(field.getName());
            }
        }
        return lstExcludeFields;
    }
    
    /**
     * 取得列属性VO中不忽略比较的字段名称集合
     * 
     * @return 获取比较的字段名称集合
     */
    private static List<String> getIncludeFields() {
        List<String> lstIncludeFields = new ArrayList<String>();
        Field[] fields = ColumnVO.class.getDeclaredFields();
        for (Field field : fields) {
            if (null == field.getAnnotation(CompareIgnore.class)) {
                lstIncludeFields.add(field.getName());
            }
        }
        return lstIncludeFields;
    }
    
    /**
     * 
     * 判断源表索引是否发生改变
     * 
     * @param srcTable 源表
     * @param targetTable 数据库最新的表
     * @return true: 发生改变， false：没有改变
     */
    public static boolean isChangeIndex(TableVO srcTable, TableVO targetTable) {
        List<TableIndexVO> srcIndexs = srcTable.getIndexs();
        List<TableIndexVO> targetIndexs = targetTable.getIndexs();
        Map<String, List<String>> indexMap = new HashMap<String, List<String>>();
        if (srcIndexs.size() != targetIndexs.size()) {
            return true;
        }
        // 将源索引的名称和列列表封装到indexMap
        for (TableIndexVO index : targetIndexs) {
            // 去除主键默认索引
            // if (index.isUnique()) {
            // continue;
            // }
            List<String> lstColumn = new ArrayList<String>();
            List<IndexColumnVO> columns = index.getColumns();
            for (IndexColumnVO col : columns) {
                lstColumn.add(col.getColumn().getCode());
            }
            indexMap.put(index.getEngName(), lstColumn);
        }
        // 遍历目标索引跟indexMap进行过滤返回结果
        for (TableIndexVO idx : srcIndexs) {
            if (indexMap.containsKey(idx.getEngName())) {
                List<String> srcTemp = indexMap.get(idx.getEngName());
                List<String> targetTemp = new ArrayList<String>();
                List<IndexColumnVO> columnsTemp = idx.getColumns();
                for (IndexColumnVO col : columnsTemp) {
                    targetTemp.add(col.getColumn().getCode());
                }
                if (isChangeIndexColumn(srcTemp, targetTemp)) {
                    return true;
                }
                continue;
            }
            
            return true;
        }
        
        return false;
    }
    
    /**
     * 
     * 判断索引列是否改变
     * 
     * @param srcList 源索引的列
     * @param targetList 目标索引的列
     * @return true 表示改变； false 表示没变
     */
    private static boolean isChangeIndexColumn(List<String> srcList, List<String> targetList) {
        Map<String, String> codeMap = new HashMap<String, String>();
        if (srcList.size() != targetList.size()) {
            return true;
        }
        for (String srcTemp : srcList) {
            codeMap.put(srcTemp, srcTemp);
        }
        
        for (String targetTemp : targetList) {
            if (codeMap.containsKey(targetTemp)) {
                codeMap.remove(targetTemp);
            }
        }
        if (codeMap.size() > 0) {
            return true;
        }
        return false;
    }
    
    /**
     * 判断表的描述是否更改
     * 
     * @param srcTable 源表
     * @param targetTable 数据库最新表
     * @return 表的描述是否改变的boolean值 true: 代表描述已改变 false:代表描述没有变化
     */
    public static boolean isChangeDescription(TableVO srcTable, TableVO targetTable) {
        if (null != srcTable.getDescription() && !srcTable.getDescription().equals(targetTable.getDescription())) {
            return true;
        }
        return false;
    }
    
	/**
	 * 复制比较结果集
	 * 
	 * @param srcResult
	 *            table比较结果集
	 * @param index
	 *            索引比较结果集
	 * @return TableCompareResult
	 */
	public static TableCompareResult copyCompareResult(
			TableCompareResult srcResult, IndexCompareResult index) {
		TableCompareResult targetResult = new TableCompareResult();
		BeanUtils.copyProperties(srcResult, targetResult);
		// 重置列比较结果集
		targetResult.setColumnResults(new ArrayList<ColumnCompareResult>());
		targetResult.setIndexResults(Arrays.asList(index));
		return targetResult;
	}
	
	/**
	 * 合并列比较结果集
	 * 
	 * @param compareResults
	 *            合并比较结果集
	 * @return TableCompareResults
	 */
	public static List<TableCompareResult> mergeColumn(
			List<TableCompareResult> compareResults) {
		List<TableCompareResult> merge = new ArrayList<TableCompareResult>();
		Map<String, List<ColumnCompareResult>> map = new HashMap<String, List<ColumnCompareResult>>();
		for (TableCompareResult objResult : compareResults) {
			String tableName = objResult.getSrcTable().getCode();
			if (map.containsKey(tableName)) {
				List<ColumnCompareResult> columns = map.get(tableName);
				columns.addAll(objResult.getColumnResults());
				map.put(tableName, columns);
			} else {
				map.put(tableName, objResult.getColumnResults());
			}
		}
		Set<String> tables = map.keySet();
		for (String table : tables) {
			TableCompareResult tableResult = getTableCompareResult(table,
					compareResults);
			if (tableResult != null) {
				tableResult.setColumnResults(map.get(table));
				merge.add(tableResult);
			}
		}
		return merge;
	}
	
	/**
	 * 合并索引
	 * 
	 * @param compareResults
	 *            比较结果集
	 * @return TableCompareResults
	 */
	public static List<TableCompareResult> mergeIndex(
			List<TableCompareResult> compareResults) {
		List<TableCompareResult> merge = new ArrayList<TableCompareResult>();
		Map<String, List<IndexCompareResult>> map = new HashMap<String, List<IndexCompareResult>>();
		for (TableCompareResult objResult : compareResults) {
			String tableName = objResult.getSrcTable().getCode();
			if (map.containsKey(tableName)) {
				List<IndexCompareResult> indexs = map.get(tableName);
				indexs.addAll(objResult.getIndexResults());
				map.put(tableName, indexs);
			} else {
				map.put(tableName, objResult.getIndexResults());
			}
		}
		Set<String> tables = map.keySet();
		for (String table : tables) {
			TableCompareResult tableResult = getTableCompareResult(table,
					compareResults);
			if (tableResult != null) {
				tableResult.setIndexResults(map.get(table));
				merge.add(tableResult);
			}
		}

		return merge;
	}
	
	/**
	 * 获取表比较结果集
	 * 
	 * @param table
	 *            表名
	 * @param compareResults
	 *            比较结果集
	 * @return TableCompareResult
	 */
	private static TableCompareResult getTableCompareResult(String table,
			List<TableCompareResult> compareResults) {
		for (TableCompareResult objResult : compareResults) {
			if (objResult.getSrcTable().getCode().equalsIgnoreCase(table)) {
				return objResult;
			}
		}
		return null;
	}
    
}
