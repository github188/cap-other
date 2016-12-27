/******************************************************************************
 * Copyright (C) 2016 ShenZhen ComTop Information Technology Co.,Ltd
 * All Rights Reserved.
 * 本软件为深圳康拓普开发研制。未经本公司正式书面同意，其他任何个人、团体不得使用、
 * 复制、修改或发布本软件.
 *****************************************************************************/
package com.comtop.cap.bm.metadata.consistency.entity;

import java.util.List;

import com.comtop.cap.bm.metadata.base.consistency.model.ConsistencyCheckResult;
import com.comtop.cap.bm.metadata.base.model.BaseModel;

/**
 * 对象被依赖校验接口
 * 
 * @author 许畅
 * @since JDK1.6
 * @version 2016年7月1日 许畅 新建
 * @param <T>
 *            BaseModel
 * @param <R> Object
 */
public interface IBeingDependOnValidate<T extends BaseModel,R> {

	/**
	 * 校验当前对象被其他同类型对象所依赖
	 * 
	 * @param sourceData
	 *            实体对象
	 * @return 校验结果集
	 */
	public List<ConsistencyCheckResult> beingDependOnRoot(T sourceData);

	/**
	 * 校验当前对象属性被其他对象所依赖
	 * 
	 * @param attributes
	 *            属性集合
	 * 
	 * @param sourceData
	 *            来源实体
	 * @return 校验结果集
	 */
	public List<ConsistencyCheckResult> beingDependOnAttribute(R attributes,T sourceData);

	/**
	 * 校验当前对象方法被其他对象所依赖
	 * @param methods 方法集合
	 * 
	 * @param sourceData
	 *            来源实体
	 * @return 校验结果集
	 */
	public List<ConsistencyCheckResult> beingDependOnMethod(R methods,T sourceData);
	
	/**
	 * 是否校验元数据一致性
	 * 
	 * @return 是否校验一致性
	 */
	public boolean isCheckConsistency();

}
