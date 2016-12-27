/******************************************************************************
 * Copyright (C) 2016 ShenZhen ComTop Information Technology Co.,Ltd
 * All Rights Reserved.
 * 本软件为深圳康拓普开发研制。未经本公司正式书面同意，其他任何个人、团体不得使用、
 * 复制、修改或发布本软件.
 *****************************************************************************/
package com.comtop.cap.bm.metadata.consistency.entity.util;

/**
 * 实体一致性校验类型枚举类
 * 
 * @author 许畅
 * @since JDK1.6
 * @version 2016年6月27日 许畅 新建
 */
public final class EntityConsistencyCheckType {

	/**
	 * 私有化构造方法
	 */
	private EntityConsistencyCheckType() {

	}

	/** 实体方法的返回值类型 */
	public static final int ENTITY_METHOD_RETURN_TYPE = 0;

	/** 实体方法的参数类型 */
	public static final int ENTITY_METHOD_PARAMETER_TYPE = 1;

	/** 实体方法的级联操作类型 */
	public static final int ENTITY_METHOD_CASCADE_TYPE = 2;

	/** 实体关系类型 */
	public static final int ENTITY_RELATIONSHIP_TYPE = 3;

	/** 实体属性类型 */
	public static final int ENTITY_ATTRIBUTE_RELATION_TYPE = 4;

	/** 实体属性枚举类型 */
	public static final int ENTITY_ATTRIBUTE_ENUM_TYPE = 5;

	/** 实体对应父实体属性 */
	public static final int ENTITY_PARENT_ENTITY_TYPE = 6;

	/** 实体对应流程类型 */
	public static final int ENTITY_PROCESS_TYPE = 7;

	/** 实体对应表类型 */
	public static final int ENTITY_TABLE_TYPE = 8;

	/** 实体方法关联实体类型参数类型 */
	public static final int ENTITY_METHOD_PARAMETER_ENTITY_TYPE = 9;

	/** 实体方法关联实体泛型参数类型 */
	public static final int ENTITY_METHOD_PARAMETER_GENERIC_TYPE = 10;

	/** 实体方法的返回值关联实体类型 */
	public static final int ENTITY_METHOD_RETURN_ENTITY_TYPE = 11;

	/** 实体方法的返回值关联泛型实体类型 */
	public static final int ENTITY_METHOD_RETURN_GENERIC_TYPE = 12;

	/** 实体关系类型1 */
	public static final int ENTITY_RELATIONSHIP_ASSOSIATE_TYPE = 13;

	/** 实体关系类型2 */
	public static final int ENTITY_RELATIONSHIP_SOURCE_TYPE = 14;

	/** 实体关系类型3 */
	public static final int ENTITY_RELATIONSHIP_TARGET_TYPE = 15;

	/** 实体属性关联实体类型 */
	public static final int ENTITY_ATTRIBUTE_ENTITY_TYPE = 16;

	/** 实体属性关联实体泛型类型 */
	public static final int ENTITY_ATTRIBUTE_GENERIC_TYPE = 17;
	
	/** 实体关系目标实体属性 */
	public static final int ENTITY_RELATIONSHIP_TARGET_FIELD = 18;
	
	/** 实体关系中间实体属性 */
	public static final int ENTITY_RELATIONSHIP_ASSOCIATION_FIELD = 19;
	
	/** 实体被页面所依赖 */
	public static final int PAGE_DATA_STORE_TYPE = 20;

}
