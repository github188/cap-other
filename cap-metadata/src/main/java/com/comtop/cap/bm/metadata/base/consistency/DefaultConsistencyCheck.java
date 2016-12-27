/******************************************************************************
 * Copyright (C) 2015 ShenZhen ComTop Information Technology Co.,Ltd
 * All Rights Reserved.
 * 本软件为深圳康拓普开发研制。未经本公司正式书面同意，其他任何个人、团体不得使用、
 * 复制、修改或发布本软件.
 *****************************************************************************/

package com.comtop.cap.bm.metadata.base.consistency;

import java.util.ArrayList;
import java.util.List;

import com.comtop.cap.bm.metadata.base.consistency.model.ConsistencyCheckResult;
import com.comtop.cap.bm.metadata.base.consistency.model.FieldConsistencyCheckVO;
import com.comtop.cap.bm.metadata.base.model.BaseModel;
import com.comtop.cap.bm.metadata.common.storage.CacheOperator;


/**
 * 一致性校验
 * 
 * @author 罗珍明
 * @param <R> 泛型
 *
 */
public abstract class DefaultConsistencyCheck<R extends BaseModel> implements IConsistencyCheck<R>{
	
	@Override
	public List<ConsistencyCheckResult> checkBeingDependOn(R root) {
		List<FieldConsistencyCheckVO> lstCheckField = getFieldBeingDependOn(root);
		return ConsistencyCheckUtil.checkFieldBeingDependOn(lstCheckField, root);
	}
	
	@Override
	public List<ConsistencyCheckResult> checkBeingDependOnWhenChange(R root) {
		R sourceBean = getSourceBean(root);
		return ConsistencyCheckUtil.checkFieldBeingDependOnWithChange(root, sourceBean);
	}

	/**
	 * 
	 * @param root 当前对象
	 * @return 原始对象
	 */
	protected R getSourceBean(R root) {
		return (R) CacheOperator.readById(root.getModelId());
	}

	/**
	 * 
	 * @param root 当前对象
	 * @return 变化的属性
	 */
	public List<FieldConsistencyCheckVO> getFieldBeingDependOn(R root) {
		return ConsistencyCheckUtil.getFieldBeingDependOnWithAnnotion(root);
	}

	@Override
	public <T> List<ConsistencyCheckResult> checkBeingDependOn(String fieldName,
			T field, R root) {
		FieldConsistencyCheckVO objFieldCheck = ConsistencyCheckUtil.getFieldBeingDependOnWithAnnotion(fieldName,root);
		if(objFieldCheck == null){
			return new ArrayList<ConsistencyCheckResult>(0);
		}
		return ConsistencyCheckUtil.checkFieldBeingDependOnWithClass(objFieldCheck, root);
	}
	
	@Override
	public List<ConsistencyCheckResult> checkCurrentDependOn(R root) {
		List<FieldConsistencyCheckVO> lstCheckField = getFieldDependOnOtherObject(root);
		return ConsistencyCheckUtil.checkFieldDependOn(lstCheckField, root);
	}


	@Override
	public <T> List<ConsistencyCheckResult> checkFieldDependOn(String fieldName,T data, R root) {
		FieldConsistencyCheckVO objFieldCheck = ConsistencyCheckUtil.getFieldDependOnOtherObjectWithAnnotion(fieldName,root);
		if(objFieldCheck == null){
			return new ArrayList<ConsistencyCheckResult>(0);
		}
		return ConsistencyCheckUtil.checkFieldDependOnConsistency(objFieldCheck, root);
	}
	
	/**
	 * 
	 * @param root 根对象
	 * @return 根对象中需要校验的字段信息
	 */
	public List<FieldConsistencyCheckVO> getFieldDependOnOtherObject(R root) {
		return ConsistencyCheckUtil.getFieldDependOnOtherObjectWithAnnotion(root);
	}
}
