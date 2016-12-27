/******************************************************************************
 * Copyright (C) 2015 ShenZhen ComTop Information Technology Co.,Ltd
 * All Rights Reserved.
 * 本软件为深圳康拓普开发研制。未经本公司正式书面同意，其他任何个人、团体不得使用、
 * 复制、修改或发布本软件.
 *****************************************************************************/

package com.comtop.cap.bm.metadata.base.consistency;

import java.lang.reflect.Field;
import java.util.ArrayList;
import java.util.List;

import javax.persistence.Id;

import com.comtop.cap.bm.metadata.base.consistency.model.ConsistencyCheckResult;
import com.comtop.cap.bm.metadata.base.consistency.model.FieldConsistencyCheckVO;
import com.comtop.cap.bm.metadata.base.model.BaseModel;
import com.comtop.cip.jodd.bean.BeanUtil;
import com.comtop.cip.jodd.util.StringUtil;

/**
 * 一致性校验
 * 
 * @author 罗珍明
 * @param <F> 属性类型方向
 * @param <R> 根对象类
 *
 */
public class DefaultFieldConsistencyCheck< F, R extends BaseModel> implements IFieldConsistencyCheck<F , R>{

	@Override
	public List<ConsistencyCheckResult> checkFieldDependOn(F data,R root) {
		if(isNeedCheck(data, root)){
			List<FieldConsistencyCheckVO> lstField =  ConsistencyCheckUtil.getFieldDependOnOtherObjectWithAnnotion(data);
			lstField = filterCheckField(data,lstField);
			List<ConsistencyCheckResult> lst = ConsistencyCheckUtil.checkFieldDependOn(lstField, root);
			setConsistencyCheckResultType(lst);
			return lst;
		}
		return new ArrayList<ConsistencyCheckResult>(0);
	}

	/**
	 * 设置Type属性
	 * @param lst 校验结果
	 */
	protected void setConsistencyCheckResultType(List<ConsistencyCheckResult> lst) {
		if(lst == null){
			return;
		}
		if(StringUtil.isBlank(getCheckResultPageType())){
			return;
		}
		for (ConsistencyCheckResult consistencyCheckResult : lst) {
			consistencyCheckResult.setType(getCheckResultPageType());
		}
	}
	
	/**
	 * 
	 * @return 校验结果跳转到的页面类型
	 */
	protected String getCheckResultPageType(){
		return null;
	}

	/**
	 * 
	 * @param data 子对象
	 * @param lstField 添加了注解的字段
	 * @return 需要校验的字段集合
	 */
	protected List<FieldConsistencyCheckVO> filterCheckField(F data,List<FieldConsistencyCheckVO> lstField) {
		return lstField;
	}

	@Override
	public List<ConsistencyCheckResult> checkBeingDependOn(F data,R root) {
		// TODO Auto-generated method stub
		return null;
	}
	
	
	/**
	 * @param data 属性值
	 * @param root 根对象
	 * @return 是否需要一致性校验
	 */
	protected boolean isNeedCheck(F data,R root){
		return true;
	}
	
	/**
	 * @param data 属性值
	 * @param root 根对象
	 * @return 是否需要一致性校验
	 */
	protected boolean isNeedCheckBeingDependOn(F data,R root){
		return true;
	}

	@Override
	public List<ConsistencyCheckResult> checkBeingDependOnWhenChange(F newField, R newRoot, F field, R root) {
		if(isNeedCheckBeingDependOn(field, root)){
//			List<FieldConsistencyCheckVO> lstOldConfig = ConsistencyCheckUtil.getFieldBeingDependOnWithAnnotion(field);
//			for (FieldConsistencyCheckVO fieldConsistencyCheckVO : lstOldConfig) {
//				//
//			}
//			List<FieldConsistencyCheckVO> lstNewConfig = ConsistencyCheckUtil.getFieldBeingDependOnWithAnnotion(newField);
//			for (FieldConsistencyCheckVO fieldConsistencyCheckVO : lstNewConfig) {
//				//
//			}
			if(isValueChange(newField,field)){
				return ConsistencyCheckUtil.checkFieldBeingDependOnWithChange(newField, field);
			}
		}
		return new ArrayList<ConsistencyCheckResult>(0);
	}

	/**
	 * 值是否发生变化
	 * @param newField 新值
	 * @param field 原始值
	 * @return true 是  false 否
	 */
	protected boolean isValueChange(F newField, F field) {
		if(field == null){
			return false;
		}
		return !field.equals(newField);
	}

	@Override
	public String getObjectPk(F sourceV) {
		Field[] fields = sourceV.getClass().getDeclaredFields();
		String strPKField = null;
		for (Field field : fields) {
			if (field.getAnnotation(Id.class) != null) {
				strPKField = field.getName();
			}
		}
		if (strPKField != null) {
			Object objDescPKValue = BeanUtil.getDeclaredProperty(sourceV, strPKField);
			return (String)objDescPKValue;
		}
		return null;
	}

	@Override
	public F getObjectFromArr(String pk, List<F> lstNew) {
		if(lstNew == null || pk == null){
			return null;
		}
		for (F f : lstNew) {
			if(pk.equals(getObjectPk(f))){
				return f;
			}
		}
		return null;
	}
}
