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
 * @param <F> 字段类型泛型
 * @param <R> 泛型
 */
public interface IFieldConsistencyCheck<F,R> {
	
	/**
	 * 校验当前对象所依赖的属性
	 * 
	 * @param field 属性值
	 * @param data 属性所属的根对象
	 * @return 校验结果
	 */
	List<ConsistencyCheckResult> checkFieldDependOn(F field,R data);
	
	/**
	 * 校验当前对象被依赖的属性
	 * 
	 * @param field 属性值
	 * @param root 属性所属根对象
	 * @return 校验结果
	 */
	List<ConsistencyCheckResult> checkBeingDependOn(F field,R root);
	
	/**
	 * 
	 * @param newField 新的属性值
	 * @param newRoot 新属性值所属根对象
	 * @param field 属性值
	 * @param root 属性所属根对象
	 * @return 校验结果
	 */
	List<ConsistencyCheckResult> checkBeingDependOnWhenChange(F newField,R newRoot, F field, R root);

	/**
	 * 
	 * @param sourceV 属性对象
	 * @return 属性对象的主键
	 */
	String getObjectPk(F sourceV);

	/**
	 * 
	 * @param pk 主键
	 * @param lstNew 集合
	 * @return 从集合中获取指定主键值的对象
	 */
	F getObjectFromArr(String pk, List<F> lstNew);
}
