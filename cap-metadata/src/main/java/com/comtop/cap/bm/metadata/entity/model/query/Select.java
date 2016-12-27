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
 * 查询建模SELECT对象模型
 *
 * @author 许畅
 * @since jdk1.6
 * @version 2016年07月25日 许畅 新建
 */
@DataTransferObject
public class Select extends BaseMetadata {

	/** 序列化版本号 */
	private static final long serialVersionUID = 1L;

	/** select选择的属性集合 */
	private List<QueryAttribute> selectAttributes;

	/**
	 * @return the selectAttributes select选择的属性集合
	 */
	public List<QueryAttribute> getSelectAttributes() {
		return selectAttributes;
	}

	/**
	 * @param selectAttributes
	 *            the selectAttributes to set select选择的属性集合
	 */
	public void setSelectAttributes(List<QueryAttribute> selectAttributes) {
		this.selectAttributes = selectAttributes;
	}

}
