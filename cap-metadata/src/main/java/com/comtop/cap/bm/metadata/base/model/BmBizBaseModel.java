/******************************************************************************
 * Copyright (C) 2016 ShenZhen ComTop Information Technology Co.,Ltd
 * All Rights Reserved.
 * 本软件为深圳康拓普开发研制。未经本公司正式书面同意，其他任何个人、团体不得使用、
 * 复制、修改或发布本软件.
 *****************************************************************************/
package com.comtop.cap.bm.metadata.base.model;

import com.comtop.cap.bm.metadata.common.storage.GraphMainObservable;
import com.comtop.cap.bm.metadata.common.storage.exception.OperateException;
import com.comtop.cap.bm.metadata.common.storage.exception.ValidateException;

/**
 * 建模业务基础模型
 * <p>
 * 用于扩展模型操作时更新图形关系,没有首页图形关系的不需要继承该类,目前继承该类的只需EntityVO,PageVO
 * </p>
 * 
 * @author 许畅
 * @since JDK1.7
 * @version 2016年12月15日 许畅 新建
 */
public abstract class BmBizBaseModel extends BaseModel {

	/**
	 *  Graph观察者
	 */
	private static GraphMainObservable observable = GraphMainObservable
			.getInstance();

	/**
	 * 模型保存
	 *
	 * @return boolean success
	 * @throws ValidateException
	 *             校验异常
	 *
	 * @see com.comtop.cap.bm.metadata.base.model.BaseModel#saveModel()
	 */
	@Override
	public boolean saveModel() throws ValidateException {
		boolean issuccess = super.saveModel();
		observable.doBusiness("update");
		return issuccess;
	}

	/**
	 * 模型删除
	 * 
	 * @param expression
	 *            表达式
	 * @return boolean success
	 * @throws OperateException
	 *             OperateException
	 * @throws ValidateException
	 *             ValidateException
	 *
	 * @see com.comtop.cap.bm.metadata.base.model.BaseModel#delete(java.lang.String)
	 */
	@Override
	public boolean delete(String expression) throws OperateException,
			ValidateException {
		boolean issuccess = super.delete(expression);
		observable.doBusiness("update");
		return issuccess;
	}

	/**
	 * 模型删除
	 * 
	 * @return boolean success
	 * @throws OperateException
	 *             OperateException
	 *
	 * @see com.comtop.cap.bm.metadata.base.model.BaseModel#deleteModel()
	 */
	@Override
	public boolean deleteModel() throws OperateException {
		boolean issuccess = super.deleteModel();
		observable.doBusiness("update");
		return issuccess;
	}

}
