/******************************************************************************
 * Copyright (C) 2016 ShenZhen ComTop Information Technology Co.,Ltd
 * All Rights Reserved.
 * 本软件为深圳康拓普开发研制。未经本公司正式书面同意，其他任何个人、团体不得使用、
 * 复制、修改或发布本软件.
 *****************************************************************************/
package com.comtop.cap.bm.metadata.database.datasource;

import java.util.ArrayList;
import java.util.Arrays;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import org.springframework.beans.BeanUtils;

import com.comtop.cap.bm.metadata.database.datasource.util.UuidGenerator;
import com.comtop.cap.bm.metadata.database.dbobject.model.ColumnCompareResult;
import com.comtop.cap.bm.metadata.database.dbobject.model.IndexCompareResult;
import com.comtop.cap.bm.metadata.database.dbobject.model.TableCompareResult;
import com.comtop.cap.bm.metadata.database.util.TableUtils;

/**
 * 表结构对比数据源
 * 
 * @author 许畅
 * @since JDK1.7
 * @version 2016年11月2日 许畅 新建
 */
public class CompareDataProvider implements ICompareDataSource {

	/** 表比较结果集 */
	private final List<TableCompareResult> tableCompareResults;

	/**
	 * 构造方法
	 */
	public CompareDataProvider() {
		tableCompareResults = new ArrayList<TableCompareResult>();
	}

	/**
	 * 构造函数
	 * 
	 * @param tableCompareResults
	 *            注入List<TableCompareResult>
	 */
	public CompareDataProvider(List<TableCompareResult> tableCompareResults) {
		this.tableCompareResults = tableCompareResults;
	}

	/**
	 * 初始化列数据源
	 * 
	 * @return list
	 *
	 * @see com.comtop.cap.bm.metadata.database.datasource.ICompareDataSource#initColumn()
	 */
	@Override
	public List<Map<String, Object>> initColumn() {
		List<Map<String, Object>> columns = new ArrayList<Map<String, Object>>();
		for (TableCompareResult result : tableCompareResults) {
			List<ColumnCompareResult> columnResults = result.getColumnResults();
			for (ColumnCompareResult column : columnResults) {
				Map<String, Object> col = new HashMap<String, Object>();
				switch (column.getResult()) {
				case ColumnCompareResult.COLUMN_ADD:
					col.put("state", CompareState.ADD.getValue());
					col.put("engName", column.getTargetColumn().getCode());
					col.put("chName", column.getTargetColumn().getChName());
					col.put("table", result.getSrcTable().getCode());
					col.put("id", UuidGenerator.generateUpperUUID());
					col.put("columnCompareResult", copyCompareResult(result, column));
					break;
				case ColumnCompareResult.COLUMN_DEL:
					col.put("state", CompareState.DELETE.getValue());
					col.put("engName", column.getSrcColumn().getCode());
					col.put("chName", column.getSrcColumn().getChName());
					col.put("table", result.getSrcTable().getCode());
					col.put("id", UuidGenerator.generateUpperUUID());
					col.put("columnCompareResult",copyCompareResult(result, column));
					break;
				case ColumnCompareResult.COLUMN_EQUAL:
					break;
				case ColumnCompareResult.COLUMN_DIFF:
					col.put("state", CompareState.MODIFY.getValue());
					col.put("engName", column.getTargetColumn().getCode());
					col.put("chName", column.getTargetColumn().getChName());
					col.put("table", result.getSrcTable().getCode());
					col.put("id", UuidGenerator.generateUpperUUID());
					col.put("columnCompareResult",copyCompareResult(result, column));
					break;
				default:
					col.put("state", CompareState.MODIFY.getValue());
					col.put("engName", column.getTargetColumn().getCode());
					col.put("chName", column.getTargetColumn().getChName());
					col.put("table", result.getSrcTable().getCode());
					col.put("id", UuidGenerator.generateUpperUUID());
					col.put("columnCompareResult",copyCompareResult(result, column));
					break;
				}
				if (col.size() > 0) {
					columns.add(col);
				}
			}
		}
		return columns;
	}

	/**
	 * 初始化索引数据源
	 * 
	 * @return list
	 *
	 * @see com.comtop.cap.bm.metadata.database.datasource.ICompareDataSource#initIndex()
	 */
	@Override
	public List<Map<String, Object>> initIndex() {
		List<Map<String, Object>> indexs = new ArrayList<Map<String, Object>>();
		
		for (TableCompareResult result : tableCompareResults) {
			List<IndexCompareResult> indexResults = result.getIndexResults();
			for (IndexCompareResult indexResult : indexResults) {
				Map<String,Object> col =new HashMap<String,Object>();
				switch (indexResult.getResult()) {
				case IndexCompareResult.INDEX_ADD:
					col.put("state", CompareState.ADD.getValue());
					col.put("id", UuidGenerator.generateUpperUUID());
					col.put("table", result.getTargetTable().getCode());
					col.put("column", indexResult.getStrTargetIndexColumn());
					col.put("index", indexResult.getTargetIndex().getEngName());
					col.put("indexCompareResult", TableUtils.copyCompareResult(result, indexResult));
					break;
				case IndexCompareResult.INDEX_DEL:
					col.put("state", CompareState.DELETE.getValue());
					col.put("id", UuidGenerator.generateUpperUUID());
					col.put("table", result.getTargetTable().getCode());
					col.put("column", indexResult.getStrTargetIndexColumn());
					col.put("index", indexResult.getSrcIndex().getEngName());
					col.put("indexCompareResult", TableUtils.copyCompareResult(result, indexResult));
					break;
				case IndexCompareResult.INDEX_DIFF:
					col.put("state", CompareState.MODIFY.getValue());
					col.put("id", UuidGenerator.generateUpperUUID());
					col.put("table", result.getTargetTable().getCode());
					col.put("column", indexResult.getStrTargetIndexColumn());
					col.put("index", indexResult.getTargetIndex().getEngName());
					col.put("indexCompareResult", TableUtils.copyCompareResult(result, indexResult));
					break;
				case IndexCompareResult.INDEX_EQUAL:
					break;
				default:
					col.put("state", CompareState.MODIFY.getValue());
					col.put("id", UuidGenerator.generateUpperUUID());
					col.put("table", result.getTargetTable().getCode());
					col.put("column", indexResult.getStrTargetIndexColumn());
					col.put("index", indexResult.getTargetIndex().getEngName());
					col.put("indexCompareResult", TableUtils.copyCompareResult(result, indexResult));
					break;
				}
				if (col.size() > 0) {
					indexs.add(col);
				}
			}
		}

		return indexs;
	}

	/**
	 * 初始化所有数据源
	 * 
	 * @return list
	 *
	 * @see com.comtop.cap.bm.metadata.database.datasource.ICompareDataSource#initAll()
	 */
	@Override
	public List<Map<String, Object>> initAll() {
		return new ArrayList<Map<String, Object>>();
	}

	/**
	 * @return the tableCompareResults
	 */
	public List<TableCompareResult> getTableCompareResults() {
		return tableCompareResults;
	}

	/**
	 * @param srcResult
	 *            表比较结果集
	 * @param column
	 *            列比较结果集
	 * @return TableCompareResult
	 */
	private TableCompareResult copyCompareResult(TableCompareResult srcResult,
			ColumnCompareResult column) {
		TableCompareResult targetResult = new TableCompareResult();
		BeanUtils.copyProperties(srcResult, targetResult);
		// 重置索引
		List<IndexCompareResult> indexResults = new ArrayList<IndexCompareResult>();
		List<IndexCompareResult> indexs = targetResult.getIndexResults();
		for (IndexCompareResult index : indexs) {
			IndexCompareResult newIndex = new IndexCompareResult();
			BeanUtils.copyProperties(index, newIndex);
			if (index.getResult() != IndexCompareResult.INDEX_EQUAL) {
				newIndex.setResult(IndexCompareResult.INDEX_EQUAL);
			}
			indexResults.add(newIndex);
		}
		targetResult.setIndexResults(indexResults);
		targetResult.setColumnResults(Arrays.asList(column));
		return targetResult;
	}

}
