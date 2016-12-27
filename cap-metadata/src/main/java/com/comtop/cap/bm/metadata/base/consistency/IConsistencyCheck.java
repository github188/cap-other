/******************************************************************************
 * Copyright (C) 2015 ShenZhen ComTop Information Technology Co.,Ltd
 * All Rights Reserved.
 * 本软件为深圳康拓普开发研制。未经本公司正式书面同意，其他任何个人、团体不得使用、
 * 复制、修改或发布本软件.
 *****************************************************************************/

package com.comtop.cap.bm.metadata.base.consistency;

import java.util.List;

import com.comtop.cap.bm.metadata.base.consistency.model.ConsistencyCheckResult;

/**
 * 一致性校验接口
 * 
 * @author luozhenming
 *
 * @param <R> 泛型
 */
public interface IConsistencyCheck<R> {

	/**
	 * 校验当前对象所有依赖外部数据的属性的一致性
	 * 
	 * @param root basemode对象
	 * @return 校验结果
	 * 
	 */
	List<ConsistencyCheckResult> checkCurrentDependOn(R root);
	
	/**
	 * 
	 * @param <T> 泛型
	 * @param fieldName 属性名称
	 * @param field 属性值
	 * @param data 属性所属的根对象
	 * @return 校验结果
	 */
	<T> List<ConsistencyCheckResult> checkFieldDependOn(String fieldName,T field,R data);
	
	/**
	 * 校验对象被外部依赖的集合
	 * 
	 * @param root 对象
	 * @return 校验结果
	 */
	List<ConsistencyCheckResult> checkBeingDependOn(R root);
	
	/**
	 * 校验对象被外部依赖的集合
	 * 
	 * @param root 对象
	 * @return 校验结果
	 */
	List<ConsistencyCheckResult> checkBeingDependOnWhenChange(R root);
	
	/**
	 * 
	 * @param <T> 泛型
	 * @param fieldName 属性名称
	 * @param field 属性值
	 * @param root 属性所属根对象
	 * @return 校验结果
	 */
	<T> List<ConsistencyCheckResult> checkBeingDependOn(String fieldName,T field,R root);
}
