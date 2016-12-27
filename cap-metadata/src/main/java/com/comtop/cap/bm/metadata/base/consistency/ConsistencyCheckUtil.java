/******************************************************************************
 * Copyright (C) 2015 ShenZhen ComTop Information Technology Co.,Ltd
 * All Rights Reserved.
 * 本软件为深圳康拓普开发研制。未经本公司正式书面同意，其他任何个人、团体不得使用、
 * 复制、修改或发布本软件.
 *****************************************************************************/

package com.comtop.cap.bm.metadata.base.consistency;

import java.text.MessageFormat;
import java.util.ArrayList;
import java.util.Arrays;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;

import com.comtop.cap.bm.metadata.base.consistency.annotation.BaseModelConsistency;
import com.comtop.cap.bm.metadata.base.consistency.annotation.ConsistencyDependOnField;
import com.comtop.cap.bm.metadata.base.consistency.annotation.ConsistencyReferencedField;
import com.comtop.cap.bm.metadata.base.consistency.model.ConsistencyCheckResult;
import com.comtop.cap.bm.metadata.base.consistency.model.FieldConsistencyCheckVO;
import com.comtop.cap.bm.metadata.base.consistency.model.FieldConsistencyConfigVO;
import com.comtop.cap.bm.metadata.base.model.BaseMetadata;
import com.comtop.cap.bm.metadata.base.model.BaseModel;
import com.comtop.cap.bm.metadata.common.storage.CacheOperator;
import com.comtop.cap.bm.metadata.common.storage.annotation.IgnoreField;
import com.comtop.cap.bm.metadata.common.storage.exception.OperateException;
import com.comtop.cip.jodd.bean.BeanUtil;
import com.comtop.cip.jodd.introspector.ClassDescriptor;
import com.comtop.cip.jodd.introspector.ClassIntrospector;
import com.comtop.cip.jodd.introspector.FieldDescriptor;
import com.comtop.cip.jodd.util.StringUtil;

/**
 * 一致性校验工具类
 * 
 * @author 罗珍明
 *
 */
public final class ConsistencyCheckUtil {
	
	 /** 日志 */
    private final static Logger logger = LoggerFactory.getLogger(ConsistencyCheckUtil.class);
    
    /**依赖外部数据的字段集合*/
    private static Map<Class<?>,List<FieldConsistencyConfigVO>> fieldDependOnMap = new HashMap<Class<?>,List<FieldConsistencyConfigVO>>();

    /**被外部依赖对象字段集合*/
    private static Map<Class<?>,List<FieldConsistencyConfigVO>> fieldBeingDependOnMap = new HashMap<Class<?>,List<FieldConsistencyConfigVO>>();
    
    /**basemodel对应的校验对象缓存Map*/
    private static Map<Class<?>,Object> checkerInstMap = new HashMap<Class<?>,Object>();

    /**属性校验对应的对象缓存Map*/
    private static Map<String,Object> consistencyInstMap = new HashMap<String,Object>();
    
	/**
	 * 
	 * @param args xx
	 */
	public static void main(String[] args) {
//		PageVO objPageVO = new PageVO();
//		checkConsistencyCurrentDependOn(objPageVO,objPageVO);
		String str = MessageFormat.format("entity[modelId=\"{0}\"]", "abc");
		System.out.println(str);
	}
	
	/**
	 * 获取被其他对象依赖的属性
	 * @param <T> 泛型
	 * @param fieldName 属性名称
	 * @param data 对象
	 * @return 属性名称集合
	 */
	public static <T> FieldConsistencyCheckVO getFieldBeingDependOnWithAnnotion(String fieldName,T data) {
		List<FieldConsistencyConfigVO> lstConfig = parseFieldBeingDependOn(data.getClass());
		FieldConsistencyCheckVO objCheckVO = null;
		for (FieldConsistencyConfigVO fieldConfigVO : lstConfig) {
			if(fieldConfigVO.getFieldName().equals(fieldName)){
				Object obj = BeanUtil.getDeclaredProperty(data, fieldConfigVO.getFieldName());
				if(obj != null){
					objCheckVO = new FieldConsistencyCheckVO();
					objCheckVO.setValue(obj);
					objCheckVO.setConsistencyConfigVO(fieldConfigVO);
				}
				break;
			}
		}
		return objCheckVO;
	}
	
	/**
	 * 获取被其他对象依赖的属性
	 * @param <T> 泛型
	 * @param data 对象
	 * @return 属性名称集合
	 */
	public static <T> List<FieldConsistencyCheckVO> getFieldBeingDependOnWithAnnotion(T data) {
		List<FieldConsistencyConfigVO> lstConfig = parseFieldBeingDependOn(data.getClass());
		FieldConsistencyCheckVO objCheckVO;
		List<FieldConsistencyCheckVO> lstCheck = new ArrayList<FieldConsistencyCheckVO>();
		for (FieldConsistencyConfigVO fieldConfigVO : lstConfig) {
			Object obj = BeanUtil.getDeclaredProperty(data, fieldConfigVO.getFieldName());
			if(obj == null){
				continue;
			}
			objCheckVO = new FieldConsistencyCheckVO();
			objCheckVO.setValue(obj);
			objCheckVO.setConsistencyConfigVO(fieldConfigVO);
			lstCheck.add(objCheckVO);
		}
		return lstCheck;
	}
	
	/**
	 * 解析类中添加了被外部依赖注解的属性
	 * @param clazz 类型
	 * @return 类型中的校验字段
	 */
	private static List<FieldConsistencyConfigVO> parseFieldBeingDependOn(Class<?> clazz) {
		List<FieldConsistencyConfigVO> lstConfig = fieldBeingDependOnMap.get(clazz);
		if(lstConfig == null){
			lstConfig = new ArrayList<FieldConsistencyConfigVO>();
			fieldBeingDependOnMap.put(clazz, lstConfig);
		}else{
			return lstConfig;
		}
		ClassDescriptor objClassDescriptor = ClassIntrospector.lookup(clazz);
		FieldDescriptor[] objFieldDescriptors = objClassDescriptor.getAllFieldDescriptors();
		FieldConsistencyConfigVO objConsistencyConfigVO;
		for (FieldDescriptor field : objFieldDescriptors) {
			if(field.getField().getAnnotation(IgnoreField.class) != null){
				continue;
			}
			ConsistencyReferencedField obj = field.getField().getAnnotation(ConsistencyReferencedField.class);
			if(obj == null){
				continue;
			}
			objConsistencyConfigVO = new FieldConsistencyConfigVO();
			objConsistencyConfigVO.setCheckClass(obj.checkClass());
			objConsistencyConfigVO.setCheckConsistency(true);
			objConsistencyConfigVO.setFieldName(field.getField().getName());
			objConsistencyConfigVO.setObjectClassName(clazz.getSimpleName());
			lstConfig.add(objConsistencyConfigVO);
		}
		return lstConfig;
	}

	/**
	 * 获取被其他对象依赖的属性
	 * @param <T> 泛型
	 * @param data 对象
	 * @param source 原始对象
	 * @return 属性名称集合
	 */
	public static <T> List<ConsistencyCheckResult> checkFieldBeingDependOnWithChange(T data,T source) {
		List<ConsistencyCheckResult> lstRes = new ArrayList<ConsistencyCheckResult>();
		List<FieldConsistencyConfigVO> lstConfig = parseFieldBeingDependOn(data.getClass());
		FieldConsistencyCheckVO objCheckVO;
		for (FieldConsistencyConfigVO fieldConfigVO : lstConfig) {
			Object objValue = BeanUtil.getDeclaredProperty(source, fieldConfigVO.getFieldName());
			if(objValue == null){
				continue;
			}
			Object objNewValue = BeanUtil.getDeclaredProperty(data, fieldConfigVO.getFieldName());
			if(objNewValue == null){
				objCheckVO = new FieldConsistencyCheckVO();
				objCheckVO.setValue(objValue);
				objCheckVO.setConsistencyConfigVO(fieldConfigVO);
				lstRes.addAll(checkFieldBeingDependOnWithClass(objCheckVO, source));
				continue;
			}
			lstRes.addAll(checkFieldBeingDependOnWithChange(fieldConfigVO,objNewValue,data,objValue,source));
		}
		return lstRes;
	}
	
	/**
	 * 获取被其他对象依赖的属性
	 * @param <T> 泛型
	 * @param fieldConfigVO 字段校验对象
	 * @param newV 新值
	 * @param newR 新增根对象
	 * @param sourceV 原始值
	 * @param sourceRoot 原始值根对象
	 * @return 校验结果
	 */
	public static <T> List<ConsistencyCheckResult> checkFieldBeingDependOnWithChange(FieldConsistencyConfigVO fieldConfigVO,Object newV,T newR,Object sourceV,T sourceRoot){
		if(StringUtil.isNotBlank(fieldConfigVO.getCheckClass())){
			String strCheckClass = fieldConfigVO.getCheckClass();
			return checkFieldBeingDependOnWhenChanged(newV, newR, sourceV,
					sourceRoot, strCheckClass);
		}
		if(sourceV instanceof BaseMetadata){
			String strCheckClass = getConsistencyCheckClassName(sourceV);
			return checkFieldBeingDependOnWhenChanged(newV, newR, sourceV,
					sourceRoot, strCheckClass);
		}
		if(sourceV.getClass().isArray()){
			Object[] arr = (Object[])sourceV;
			Object[] arrNew = (Object[])newV;
			
			List lstSource = Arrays.asList(arr);
			List lstNew = Arrays.asList(arrNew);
			return checkFieldBeingDependOnWithChange(lstNew,newR, lstSource, sourceRoot);
		}
		if(sourceV instanceof List){
			List arr = (List)sourceV;
			List arrNew = (List)newV;
			return checkFieldBeingDependOnWithChange(arrNew, newR, arr,sourceRoot);
		}
		throw new ConsistencyException(sourceRoot.getClass()+"的属性："+
				fieldConfigVO.getFieldName()+"配置的一致性校验信息错误，"
				+ "checkClass,expression都为空");
	}
	
	/**
	 * 
	 * @param <T> 泛型
	 * @param lstNew 新值
	 * @param newR 新值根对象
	 * @param lstSource 原始值
	 * @param sourceRoot 原始值根对象
	 * @return 校验结果
	 */
	private static <T> List<ConsistencyCheckResult> checkFieldBeingDependOnWithChange(List lstNew,
			T newR, List lstSource, T sourceRoot) {
		List<ConsistencyCheckResult> objRes = new ArrayList<ConsistencyCheckResult>();
		for (Object sourceV : lstSource) {
			String strCheckClass = getConsistencyCheckClassName(sourceV);
			IFieldConsistencyCheck objFieldConsistencyCheck = getConsistencyCheck(strCheckClass, IFieldConsistencyCheck.class);
			if(objFieldConsistencyCheck == null){
				continue;
			}
			String objPk = objFieldConsistencyCheck.getObjectPk(sourceV);
			Object newObj = objFieldConsistencyCheck.getObjectFromArr(objPk,lstNew);
			objRes.addAll(checkFieldBeingDependOnWhenChanged(newObj, newR, sourceV, sourceRoot, strCheckClass));
		}
		return objRes;
	}

	/**
	 * @param <T> 泛型
	 * @param newV 新值
	 * @param newR 新值根对象
	 * @param sourceV 原始值
	 * @param sourceRoot 原始值根对象
	 * @param strCheckClass 校验类
	 * @return 校验结果
	 */
	private static <T> List<ConsistencyCheckResult> checkFieldBeingDependOnWhenChanged(
			Object newV, T newR, Object sourceV, T sourceRoot,
			String strCheckClass) {
		IFieldConsistencyCheck objFieldConsistencyCheck = getConsistencyCheck(strCheckClass, IFieldConsistencyCheck.class);
		if(objFieldConsistencyCheck == null){
			return new ArrayList<ConsistencyCheckResult>(0);
		}
		List lst= objFieldConsistencyCheck.checkBeingDependOnWhenChange(newV, newR, sourceV, sourceRoot);
		if(lst == null){
			return new ArrayList<ConsistencyCheckResult>(0);
		}
		return lst;
	}
	
//	/**
//	 * 判断属性值是否相等
//	 * 
//	 * @param objValue 原始值
//	 * @param objNewValue 新值
//	 * @return true 相等 false 不相等
//	 */
//	private static boolean isValueChange(Object objValue, Object objNewValue) {
//		if(objValue == null){
//			return true;
//		}
//		if(objNewValue == null){
//			return false;
//		}
//		if(objValue instanceof List){
//			List lstSource = (List)objValue;
//			List lstNew = (List)objNewValue;
//			//
//			BeanCompare.beans(objValue, objNewValue).compare();
//		}
//		if(objValue instanceof BaseMetadata){
//			List<FieldConsistencyConfigVO> lstConfig = parseFieldBeingDependOn(objValue.getClass());
//			
//		}
//		return objValue.equals(objNewValue);
//	}

	/**
	 * 获取依赖于其他对象的属性
	 * @param <T> 泛型
	 * @param fieldName 属性名称
	 * @param data 对象
	 * @return 属性集合
	 */
	public static  <T> FieldConsistencyCheckVO getFieldDependOnOtherObjectWithAnnotion(String fieldName,T data) {
		List<FieldConsistencyConfigVO> lstConfig =  parseFieldDependOnConsistencyConfig(data.getClass());
		FieldConsistencyCheckVO objCheckVO = null;
		for (FieldConsistencyConfigVO fieldConfigVO : lstConfig) {
			if(fieldConfigVO.getFieldName().equals(fieldName)){
				Object obj = BeanUtil.getDeclaredProperty(data, fieldConfigVO.getFieldName());
				if(obj != null){
					objCheckVO = new FieldConsistencyCheckVO();
					objCheckVO.setValue(obj);
					objCheckVO.setConsistencyConfigVO(fieldConfigVO);
				}
				break;
			}
		}
		return objCheckVO;
	}
	
	/**
	 * 获取依赖于其他对象的属性
	 * @param <T> 泛型
	 * @param data 对象
	 * @return 属性集合
	 */
	public static  <T> List<FieldConsistencyCheckVO> getFieldDependOnOtherObjectWithAnnotion(T data) {
		List<FieldConsistencyConfigVO> lstConfig = parseFieldDependOnConsistencyConfig(data.getClass());
		List<FieldConsistencyCheckVO> lstFieldCheck = new ArrayList<FieldConsistencyCheckVO>(lstConfig.size());
		FieldConsistencyCheckVO fieldCheckVO;
		for (FieldConsistencyConfigVO fieldConfigVO : lstConfig) {
			Object obj = BeanUtil.getDeclaredProperty(data, fieldConfigVO.getFieldName());
			if(obj == null){
				continue;
			}
			fieldCheckVO = new FieldConsistencyCheckVO();
			fieldCheckVO.setValue(obj);
			fieldCheckVO.setConsistencyConfigVO(fieldConfigVO);
			lstFieldCheck.add(fieldCheckVO);
		}
		return lstFieldCheck;
	}
	
	/**
	 * 
	 * @param clazz 校验类
	 * @return 返回校验的属性值
	 */
	private static List<FieldConsistencyConfigVO> parseFieldDependOnConsistencyConfig(Class<?> clazz) {
		List<FieldConsistencyConfigVO> lstConfig =  fieldDependOnMap.get(clazz);
		if(lstConfig == null){
			lstConfig = new ArrayList<FieldConsistencyConfigVO>();
			fieldDependOnMap.put(clazz, lstConfig);
		}else{
			return lstConfig;
		}
		ClassDescriptor objClassDescriptor = ClassIntrospector.lookup(clazz);
		FieldDescriptor[] objFieldDescriptors = objClassDescriptor.getAllFieldDescriptors();
		FieldConsistencyConfigVO objConsistencyConfigVO;
		for (FieldDescriptor field : objFieldDescriptors) {
			if(field.getField().getAnnotation(IgnoreField.class) != null){
				continue;
			}
			ConsistencyDependOnField obj = field.getField().getAnnotation(ConsistencyDependOnField.class);
			if(obj == null){
				continue;
			}
			objConsistencyConfigVO = new FieldConsistencyConfigVO();
			objConsistencyConfigVO.setCheckClass(obj.checkClass());
			objConsistencyConfigVO.setCheckConsistency(true);
			objConsistencyConfigVO.setCheckScope(obj.checkScope());
			objConsistencyConfigVO.setExpression(obj.expression());
			objConsistencyConfigVO.setFieldName(field.getField().getName());
			objConsistencyConfigVO.setObjectClassName(clazz.getSimpleName());
			lstConfig.add(objConsistencyConfigVO);
		}
		return lstConfig;
	}

	/**
	 * 
	 * @param <T> 泛型
	 * @param data baseModel对象
	 * @return 检验类实例
	 */
	public static final <T> Object getBaseModelConsistencyChecker(T data){
		if(data == null){
			return null;
		}
		BaseModelConsistency objBaseModelConsistency = data.getClass().getAnnotation(BaseModelConsistency.class);
		if(objBaseModelConsistency == null){
			return null;
		}
		Object objChecker = checkerInstMap.get(data.getClass());
		if(objChecker != null){
			return objChecker;
		}
		Class<? extends IConsistencyCheck> checkClass;
		if(DefaultConsistencyCheck.class.equals(objBaseModelConsistency.checkClass())){
			String strCheckClass = getConsistencyCheckClassName(data);
			try {
				checkClass =  (Class<? extends IConsistencyCheck>) Class.forName(strCheckClass);
			} catch (ClassNotFoundException e) {
				logger.error("未找到一致性校验类："+strCheckClass,e);
				throw new ConsistencyException("未找到一致性校验类："+strCheckClass,e);
			}
		}else{
			checkClass = objBaseModelConsistency.checkClass();
		}
		try {
			objChecker = checkClass.newInstance();
			checkerInstMap.put(data.getClass(), objChecker);
			return objChecker;
		} catch (InstantiationException e) {
			logger.error("一致性校验类："+checkClass+"实例化失败。",e);
			throw new ConsistencyException("一致性校验类："+checkClass+"实例化失败。",e);
		} catch (IllegalAccessException e) {
			logger.error("一致性校验类："+checkClass+"实例化失败。",e);
			throw new ConsistencyException("一致性校验类："+checkClass+"实例化失败。",e);
		}
	}
	
	/**
	 * 
	 * @param <T> 泛型
	 * @param lstCheckField 一致性校验的指端
	 * @param root 字段所属根对象
	 * @return 校验结果
	 */
	public static <T extends BaseModel> List<ConsistencyCheckResult> checkFieldDependOn(List<FieldConsistencyCheckVO> lstCheckField,T root){
		List<ConsistencyCheckResult> lstRes = new ArrayList<ConsistencyCheckResult>();
		List<ConsistencyCheckResult> objCheckFieldRes;
		for (FieldConsistencyCheckVO fieldConsistencyCheckVO : lstCheckField) {
			objCheckFieldRes = checkFieldDependOnConsistency(fieldConsistencyCheckVO,root);
			if(objCheckFieldRes != null){
				lstRes.addAll(objCheckFieldRes);
			}
		}
		return lstRes;
	}
	
	/**
	 * 
	 * @param <R> 泛型
	 * @param fieldCheckVO 字段校验对象
	 * @param root 根对象
	 * @return 校验结果
	 */
	public static <R extends BaseModel> List<ConsistencyCheckResult> checkFieldDependOnConsistency(FieldConsistencyCheckVO fieldCheckVO, R root) {
		List<ConsistencyCheckResult> lstRes = new ArrayList<ConsistencyCheckResult>();
		FieldConsistencyConfigVO objConfigVO = fieldCheckVO.getConsistencyConfigVO();
		String strCheckClass = objConfigVO.getCheckClass();
		String strExpr = objConfigVO.getExpression();
		if(StringUtil.isNotBlank(strCheckClass)){
			lstRes.addAll(check(objConfigVO.getFieldName(),fieldCheckVO.getValue(), strCheckClass,root));
		}else if(StringUtil.isNotBlank(strExpr)){
			ConsistencyCheckResult objResult = checkFieldDependOnConsistencyWithExpr(fieldCheckVO,root);
			if(objResult != null){
				lstRes.add(objResult);
			}
		}else{
			lstRes.addAll(checkConsistency(fieldCheckVO,root));
		}
		return lstRes;
	}
	

	/**
	 * 
	 * @param <R> 泛型
	 * @param fieldCheckVO 字段校验信息
	 * @param root 根对象
	 * @return 校验结果
	 */
	private static <R extends BaseModel> ConsistencyCheckResult checkFieldDependOnConsistencyWithExpr(FieldConsistencyCheckVO fieldCheckVO, R root) {
		if(executeExpression(root,
				fieldCheckVO.getConsistencyConfigVO().getExpression(), 
				fieldCheckVO.getConsistencyConfigVO().getCheckScope(), fieldCheckVO.getValue())){
			return null;
		}
		ConsistencyCheckResult obj = new ConsistencyCheckResult();
		
		StringBuffer sb = new StringBuffer();
		sb.append(fieldCheckVO.getConsistencyConfigVO().getObjectClassName());
		sb.append("的属性:");
		sb.append(fieldCheckVO.getConsistencyConfigVO().getFieldName());
		sb.append("关联的对象不存在");
		
		obj.setMessage(sb.toString());
		return obj;
	}

	/**
	 * 
	 * @param <R> 泛型
	 * @param lstFiled 被依赖的字段
	 * @param root 字段所属对象
	 * @return 校验结果
	 */
	public static <R> List<ConsistencyCheckResult> checkFieldBeingDependOn(List<FieldConsistencyCheckVO> lstFiled,R root){
		List<ConsistencyCheckResult> lstRes = new ArrayList<ConsistencyCheckResult>();
		List<ConsistencyCheckResult> lstFieldRes;
		for (FieldConsistencyCheckVO fieldCheckVO : lstFiled) {
			lstFieldRes = checkFieldBeingDependOnWithClass(fieldCheckVO,root);
			if(lstFieldRes != null){
				lstRes.addAll(lstFieldRes);
			}
		}
		return lstRes;
	}
	
	/**
	 * 
	 * @param <T> 泛型
	 * @param fieldCheckVO 校验字段
	 * @param data 字段所属对象
	 * @return 校验结果
	 */
	public static <T> List<ConsistencyCheckResult> checkFieldBeingDependOnWithClass(FieldConsistencyCheckVO fieldCheckVO,T data){
		String strCheckClass = fieldCheckVO.getConsistencyConfigVO().getCheckClass();
		if(StringUtil.isBlank(strCheckClass)){
			strCheckClass = getConsistencyCheckClassName(fieldCheckVO.getValue());
		}
		IFieldConsistencyCheck a = getConsistencyCheck(strCheckClass, IFieldConsistencyCheck.class); 
		if(a == null){
			return new ArrayList<ConsistencyCheckResult>(0);
		}
		List<ConsistencyCheckResult> lst = a.checkBeingDependOn(fieldCheckVO.getValue(), data);
		if(lst == null){
			return new ArrayList<ConsistencyCheckResult>(0);
		}
		return lst;
	}

	/**
	 * @param <E> 泛型
	 * @param root 根对象
	 * @param expression xpath查询表达式
	 * @param checkScope 校验范围
	 * @param value 根对象的属性值
	 * @return 校验结果
	 */
	public static <E extends BaseModel> boolean executeExpression(E root,String expression,String checkScope,Object value){
		String strExpression = MessageFormat.format(expression, value);
		try {
			List lst;
			if(ConsistencyDependOnField.CHECK_SCOPE_GLOBAL.equals(checkScope)){
				lst = CacheOperator.queryList(strExpression);
			}else{
				lst = root.queryList(strExpression);
			}
			if(lst == null || lst.size() == 0){
				return false;
			}
			return true;
		} catch (OperateException e) {
			logger.error("一致性校验异常，根据表达式查询关联的数据出错，表达式"+expression+"的值出错",e);
			throw new ConsistencyException("一致性校验异常",e);
		}
	}
	
	/**
	 * 
	 * @param <E> 泛型
	 * @param fieldCheckVO 属性值校验对象
	 * @param root 属性所属根对象
	 * @return 校验结果
	 */
	private static <E extends BaseModel> List<ConsistencyCheckResult> checkConsistency(FieldConsistencyCheckVO fieldCheckVO,E root) {
		Object objValue = fieldCheckVO.getValue();
		if(objValue instanceof BaseMetadata){
			return checkConsis(fieldCheckVO.getConsistencyConfigVO().getFieldName(),objValue,root);
		}
		if(objValue.getClass().isArray()){
			List<ConsistencyCheckResult> objRes = new ArrayList<ConsistencyCheckResult>();
			Object[] arr = (Object[])objValue;
			String strFieldName = fieldCheckVO.getConsistencyConfigVO().getFieldName();
			int i = 0;
			for (Object object : arr) {
				if(object instanceof BaseMetadata){
					objRes.addAll(checkConsis(strFieldName+"["+i+"]",object,root));
				}
				i++;
			}
			return objRes;
		}
		if(objValue instanceof List){
			List<ConsistencyCheckResult> objRes = new ArrayList<ConsistencyCheckResult>();
			List<?> lst = (List)objValue;
			String strFieldName = fieldCheckVO.getConsistencyConfigVO().getFieldName();
			int i = 0;
			for (Object object : lst) {
				if(object instanceof BaseMetadata){
					objRes.addAll(checkConsis(strFieldName+"["+i+"]",object,root));
				}
				i++;
			}
			return objRes;
		}
		throw new ConsistencyException(root.getClass()+"的属性："+
				fieldCheckVO.getConsistencyConfigVO().getFieldName()+"配置的一致性校验信息错误，"
				+ "checkClass,expression都为空");
	}

	/**
	 * @param <E> 泛型
	 * @param fieldName 属性名称
	 * @param objValue 属性值
	 * @param root 属性所属根对象
	 * @return 校验结果
	 */
	private static <E extends BaseModel> List<ConsistencyCheckResult> checkConsis(String fieldName,Object objValue,E root) {
		String strCheckClassName = getConsistencyCheckClassName(objValue);
		return check(fieldName,objValue, strCheckClassName,root);
	}

	/**
	 * @param objValue 值
	 * @return 校验类名
	 */
	private static String getConsistencyCheckClassName(Object objValue) {
		String strCheckClassName = "com.comtop.cap.bm.metadata.consistency."+objValue.getClass().getSimpleName()+"ConsistencyCheck";
		return strCheckClassName;
	}

	/**
	 * @param <E> 泛型
	 * @param fieldName 属性名称
	 * @param objValue 属性值
	 * @param strClassName 属性值校验类名
	 * @param root 属性所属根对象
	 * @return 校验结果
	 */
	private static <E extends BaseModel> List<ConsistencyCheckResult> check(String fieldName,Object objValue, String strClassName,E root) {
		IFieldConsistencyCheck a = getConsistencyCheck(strClassName,IFieldConsistencyCheck.class);
		if(a == null){
			return new ArrayList<ConsistencyCheckResult>(0);
		}
		List<ConsistencyCheckResult> lst= a.checkFieldDependOn(objValue, root);
		if(lst == null){
			return new ArrayList<ConsistencyCheckResult>(0);
		}
		return lst;
	}

	/**
	 * @param <I> 泛型
	 * @param strCheckClassName 类名
	 * @param type 类型
	 * @return IConsistencyCheck
	 */
	public static <I> I getConsistencyCheck(String strCheckClassName,Class<I> type) {
		if(consistencyInstMap.containsKey(strCheckClassName)){
			return (I) consistencyInstMap.get(strCheckClassName);
		}
		Class<?> clazz = null;
		try {
			clazz = Class.forName(strCheckClassName);
			Object objCheck = clazz.newInstance();
			if(type.isInstance(objCheck)){
				consistencyInstMap.put(strCheckClassName, objCheck);
				return (I)objCheck;
			}
			throw new ConsistencyException(clazz+" 未实现接口："+type);
		} catch (ClassNotFoundException e) {
			throw new ConsistencyException("一致性校验类不存在:"+strCheckClassName,e);
		} catch (InstantiationException e) {
			throw new ConsistencyException("实例化一致性校验类失败:"+clazz,e);
		} catch (IllegalAccessException e) {
			throw new ConsistencyException("实例化一致性校验类失败:"+clazz,e);
		}
	}

}
