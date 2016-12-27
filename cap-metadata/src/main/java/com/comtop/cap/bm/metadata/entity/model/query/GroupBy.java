/******************************************************************************
 * Copyright (C) 2016 ShenZhen ComTop Information Technology Co.,Ltd
 * All Rights Reserved.
 * 本软件为深圳康拓普开发研制。未经本公司正式书面同意，其他任何个人、团体不得使用、
 * 复制、修改或发布本软件.
 *****************************************************************************/
package com.comtop.cap.bm.metadata.entity.model.query;

import java.util.List;

import com.comtop.cap.bm.metadata.base.model.BaseMetadata;

import comtop.org.directwebremoting.annotations.DataTransferObject;

/**
 * 查询建模group by
 * 
 * @author 许畅
 * @since JDK1.6
 * @version 2016年7月25日 许畅 新建
 */
@DataTransferObject
public class GroupBy extends BaseMetadata {

	/** 序列化版本号 */
	private static final long serialVersionUID = 1L;

	/** 分组属性集合 */
	private List<QueryAttribute> groupByAttributes;

	/**
	 * @return the groupByAttributes 分组属性集合
	 */
	public List<QueryAttribute> getGroupByAttributes() {
		return groupByAttributes;
	}

	/**
	 * @param groupByAttributes
	 *            the groupByAttributes to set 分组属性集合
	 */
	public void setGroupByAttributes(List<QueryAttribute> groupByAttributes) {
		this.groupByAttributes = groupByAttributes;
	}

}
