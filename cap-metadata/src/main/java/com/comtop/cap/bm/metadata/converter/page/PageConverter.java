/******************************************************************************
 * Copyright (C) 2015 ShenZhen ComTop Information Technology Co.,Ltd
 * All Rights Reserved.
 * 本软件为深圳康拓普开发研制。未经本公司正式书面同意，其他任何个人、团体不得使用、
 * 复制、修改或发布本软件.
 *****************************************************************************/

package com.comtop.cap.bm.metadata.converter.page;

import com.comtop.cap.bm.metadata.common.storage.exception.OperateException;
import com.comtop.cap.bm.metadata.page.desinger.model.PageVO;
import com.comtop.cap.bm.req.prototype.design.model.PrototypeVO;

/**
 * 原型设计页面转换器，可以将需求建模原型设计页面转换为开发建模的页面元数据
 * @author yangsai
 *
 */
public class PageConverter {
	
	/**
	 * 页面元数据对象
	 */
	private PageVO objPageVO;
	
	/**
	 * 构造函数
	 * @param objPageVO 页面元数据对象
	 */
	public PageConverter(PageVO objPageVO) {
		this.objPageVO = objPageVO;
	}

	/**
     * 将原型设计页面的相关元数据转换成页面元数据
     * @param prototypeVO 需求建模中原型页面对象
     * @throws OperateException xml操作异常
     */
	public void convert(PrototypeVO prototypeVO) throws OperateException {
		if(prototypeVO == null) {
			return;
		}
		objPageVO.setCname(prototypeVO.getCname());
		objPageVO.setDescription(prototypeVO.getDescription());
		objPageVO.setCrudeUIIds(prototypeVO.getModelId() + ";");
		objPageVO.setCrudeUINames(prototypeVO.getCname() + ";");
		
    	new LayoutConverter(objPageVO.getLayoutVO()).convert(prototypeVO.getLayoutVO());
	}

	/**
	 * @return 获取 objPageVO属性值
	 */
	public PageVO getObjPageVO() {
		return objPageVO;
	}

	/**
	 * @param objPageVO 设置 objPageVO 属性值为参数值 objPageVO
	 */
	public void setObjPageVO(PageVO objPageVO) {
		this.objPageVO = objPageVO;
	}
	
}
