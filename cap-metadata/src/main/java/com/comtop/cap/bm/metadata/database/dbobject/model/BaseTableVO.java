package com.comtop.cap.bm.metadata.database.dbobject.model;

import com.comtop.cap.bm.metadata.base.model.BaseModel;
import comtop.org.directwebremoting.annotations.DataTransferObject;

/**
 * 表和视图的抽象类
 * 
 * <pre>
 * [调用关系:
 * 实现接口及父类:
 * 子类:
 * 内部类列表:
 * ]
 * </pre>
 * 
 * @author 章尊志
 * @since jdk1.6
 * @version 2016年1月8日 章尊志
 */
@DataTransferObject
public class BaseTableVO extends BaseModel {

	/** 序列化ID */
	private static final long serialVersionUID = 1L;

	/** id */
	private String id;

	/** 编码 */
	private String code;

	/** 中文名称 */
	private String chName;

	/** 英文名称 */
	private String engName;

	/** 描述 */
	private String description;

	/**
	 * 根据数据库英文名称获取数据库对象
	 * 
	 * <pre>
	 * 
	 * </pre>
	 * 
	 * @param strEngName
	 *            英文名
	 * @return 数据库列对象
	 */
	public ColumnVO getColumnVOByColumnEngName(String strEngName) {
		return null;
	}

	/**
	 * @return 获取 id属性值
	 */
	public String getId() {
		return id;
	}

	/**
	 * @param id
	 *            设置 id 属性值为参数值 id
	 */
	public void setId(String id) {
		this.id = id;
	}

	/**
	 * @return 获取 code属性值
	 */
	public String getCode() {
		return code;
	}

	/**
	 * @param code
	 *            设置 code 属性值为参数值 code
	 */
	public void setCode(String code) {
		this.code = code;
	}

	/**
	 * @return 获取 chName属性值
	 */
	public String getChName() {
		return chName;
	}

	/**
	 * @param chName
	 *            设置 chName 属性值为参数值 chName
	 */
	public void setChName(String chName) {
		this.chName = chName;
	}

	/**
	 * @return 获取 engName属性值
	 */
	public String getEngName() {
		return engName;
	}

	/**
	 * @param engName
	 *            设置 engName 属性值为参数值 engName
	 */
	public void setEngName(String engName) {
		this.engName = engName;
	}

	/**
	 * @return 获取 description属性值
	 */
	public String getDescription() {
		return description;
	}

	/**
	 * @param description
	 *            设置 description 属性值为参数值 description
	 */
	public void setDescription(String description) {
		this.description = description;
	}

	/**
	 * 是否存在描述
	 * 
	 * @return true 是 ，false 否
	 */
	public boolean existsDescription() {
		if (null != this.description && this.description.length() > 0) {
			return true;
		}
		return false;
	}

}
