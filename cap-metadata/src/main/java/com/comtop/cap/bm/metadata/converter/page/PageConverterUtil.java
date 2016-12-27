/******************************************************************************
 * Copyright (C) 2015 ShenZhen ComTop Information Technology Co.,Ltd
 * All Rights Reserved.
 * 本软件为深圳康拓普开发研制。未经本公司正式书面同意，其他任何个人、团体不得使用、
 * 复制、修改或发布本软件.
 *****************************************************************************/

package com.comtop.cap.bm.metadata.converter.page;

import com.comtop.cap.bm.metadata.common.storage.exception.OperateException;
import com.comtop.cap.bm.metadata.converter.page.PageConverter;
import com.comtop.cap.bm.metadata.page.desinger.model.PageVO;
import com.comtop.cap.bm.req.prototype.design.facade.PrototypeFacade;
import com.comtop.cap.bm.req.prototype.design.model.PrototypeVO;
import com.comtop.top.core.jodd.AppContext;

/**
 * 开发页面转换器，可以将需求建模原型设计页面转换为开发建模的页面元数据
 * @author yangsai
 *
 */
public class PageConverterUtil {

	/**
     * 将原型设计页面的相关元数据转换成页面元数据
     * @param objPageVO 页面元数据对象
     * @param prototypeId 需求建模中原型页面元数据
     * @throws OperateException xml操作异常
     */
	public static void convertPrototype(PageVO objPageVO, String prototypeId) throws OperateException {
		final PrototypeFacade prototypeFacade = AppContext.getBean(PrototypeFacade.class);
		PrototypeVO prototypeVO = prototypeFacade.loadModel(prototypeId, null);
		convertPrototype(objPageVO, prototypeVO);
	}
	
	/**
     * 将原型设计页面的相关元数据转换成页面元数据
     * @param objPageVO 页面元数据对象
     * @param prototypeVO 需求建模中原型页面对象
     * @throws OperateException xml操作异常
     */
	public static void convertPrototype(PageVO objPageVO, PrototypeVO prototypeVO) throws OperateException {
    	new PageConverter(objPageVO).convert(prototypeVO);
	}
}
