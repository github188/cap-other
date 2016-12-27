/******************************************************************************
 * Copyright (C) 2016 ShenZhen ComTop Information Technology Co.,Ltd
 * All Rights Reserved.
 * 本软件为深圳康拓普开发研制。未经本公司正式书面同意，其他任何个人、团体不得使用、
 * 复制、修改或发布本软件.
 *****************************************************************************/
package com.comtop.cap.bm.metadata.database.model;

import java.util.List;

import com.comtop.cap.bm.metadata.base.model.BaseMetadata;
import com.comtop.cap.bm.metadata.database.dbobject.model.TableVO;
import com.comtop.cap.bm.metadata.entity.model.EntityVO;
import comtop.org.directwebremoting.annotations.DataTransferObject;

/**
 * 比较信息
 * 
 * @author 许畅
 * @since JDK1.7
 * @version 2016年11月22日 许畅 新建
 */
@DataTransferObject
public class CompareVO extends BaseMetadata {

	/** 来源数据 */
	private TableVO src;

	/** 目标数据 */
	private EntityVO target;

	/** 分析结果集 */
	private List<AnalyzeResult> analyzeResults;

	/** 是否创建 */
	private boolean isNew;

	/**
	 * @return the src
	 */
	public TableVO getSrc() {
		return src;
	}

	/**
	 * @param src
	 *            the src to set
	 */
	public void setSrc(TableVO src) {
		this.src = src;
	}

	/**
	 * @return the target
	 */
	public EntityVO getTarget() {
		return target;
	}

	/**
	 * @param target
	 *            the target to set
	 */
	public void setTarget(EntityVO target) {
		this.target = target;
	}

	/**
	 * @return the analyzeResults
	 */
	public List<AnalyzeResult> getAnalyzeResults() {
		return analyzeResults;
	}

	/**
	 * @param analyzeResults
	 *            the analyzeResults to set
	 */
	public void setAnalyzeResults(List<AnalyzeResult> analyzeResults) {
		this.analyzeResults = analyzeResults;
	}

	/**
	 * @return the isNew
	 */
	public boolean isNew() {
		return isNew;
	}

	/**
	 * @param isNew
	 *            the isNew to set
	 */
	public void setNew(boolean isNew) {
		this.isNew = isNew;
	}

}
