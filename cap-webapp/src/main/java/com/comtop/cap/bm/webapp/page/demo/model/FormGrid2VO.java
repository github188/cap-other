/******************************************************************************
 * Copyright (C) 2015 ShenZhen ComTop Information Technology Co.,Ltd
 * All Rights Reserved.
 * 本软件为深圳康拓普开发研制。未经本公司正式书面同意，其他任何个人、团体不得使用、
 * 复制、修改或发布本软件.
 *****************************************************************************/

package com.comtop.cap.bm.webapp.page.demo.model;

import com.comtop.top.core.base.model.CoreVO;
import comtop.org.directwebremoting.annotations.DataTransferObject;

/**
 * FIXME 类注释信息(此标记由Eclipse自动生成,请填写注释信息删除此标记)
 *
 *
 * @author 作者
 * @since 1.0
 * @version 2015-6-5 作者
 */
@DataTransferObject
public class FormGrid2VO extends CoreVO {

	/** FIXME */
    private static final long serialVersionUID = 3020727163163347428L;

    /**
	 * 
	 */
	private String id;

	/**
	 * 
	 */
	private String requery;

	/**
	 * @return 获取 id属性值
	 */
	public String getId() {
		return id;
	}

	/**
	 * @param id 设置 id 属性值为参数值 id
	 */
	public void setId(String id) {
		this.id = id;
	}

	/**
	 * @return 获取 requery属性值
	 */
	public String getRequery() {
		return requery;
	}

	/**
	 * @param requery 设置 requery 属性值为参数值 requery
	 */
	public void setRequery(String requery) {
		this.requery = requery;
	}

}
