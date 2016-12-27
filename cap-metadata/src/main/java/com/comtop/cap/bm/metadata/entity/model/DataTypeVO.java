/******************************************************************************
 * Copyright (C) 2014 ShenZhen ComTop Information Technology Co.,Ltd
 * All Rights Reserved.
 * 本软件为深圳康拓普开发研制。未经本公司正式书面同意，其他任何个人、团体不得使用、
 * 复制、修改或发布本软件.
 *****************************************************************************/

package com.comtop.cap.bm.metadata.entity.model;

import java.util.ArrayList;
import java.util.List;

import com.comtop.cap.bm.metadata.base.model.BaseMetadata;
import comtop.org.directwebremoting.annotations.DataTransferObject;

/**
 * 属性类型、参数类型、方法返回值类型VO
 * 
 * @author 章尊志
 * @since 1.0
 * @version 2014-9-17 章尊志
 */
@DataTransferObject
public class DataTypeVO extends BaseMetadata {
    
    /** 序列化ID */
    private static final long serialVersionUID = 1L;
    
    /** 泛型 **/
    private List<DataTypeVO> generic;
    
    /** 类型 如果来源是基础类型、第三方类型、集合、数据字典，则这里就取值4类8种以及其他常用的类型，如java.sql.Date等等。 **/
    private String type;
    
    /**
     * 关联具体来源的值 来源为基本类型、第三方类型、集合这里均为空；当来源为数据字典，这里就是数据字典的key
     * 实体、实体属性、其他实体时,value存储主键Id
     **/
    private String value;
    
    /** 来源 基本类型、第三方类型、实体、实体属性 {@link com.comtop.cap.bm.metadata.entity.model.AttributeSourceType} */
    private String source;
    
    /**
     * @return 获取 generic属性值
     */
    public List<DataTypeVO> getGeneric() {
        return generic;
    }
    
    /**
     * @param generic 设置 generic 属性值为参数值 generic
     */
    public void setGeneric(List<DataTypeVO> generic) {
        this.generic = generic;
    }
    
    /**
     * @return 获取 type属性值
     */
    public String getType() {
        return type;
    }
    
    /**
     * @param type 设置 type 属性值为参数值 type
     */
    public void setType(String type) {
        this.type = type;
    }
    
    /**
     * @return 获取 value属性值
     */
    public String getValue() {
        return value;
    }
    
    /**
     * @param value 设置 value 属性值为参数值 value
     */
    public void setValue(String value) {
        this.value = value;
    }
    
    /**
     * @return 获取 source属性值
     */
    public String getSource() {
        return source;
    }
    
    /**
     * @param source 设置 source 属性值为参数值 source
     */
    public void setSource(String source) {
        this.source = source;
    }
    
    /**
     *
     * 返回类型名称字符串如："List" "UserVO"
     *
     * @return 类型名称
     */
    public String readDataTypeName() {
        if (AttributeSourceType.PRIMITIVE.getValue().equals(this.source)
            || AttributeSourceType.DATA_DICTIONARY.getValue().equals(this.source)
            || AttributeSourceType.ENUM_TYPE.getValue().equals(this.source)
            || AttributeSourceType.JAVA_OBJECT.getValue().equals(this.source)
            || AttributeSourceType.OTHER_ENTITY_ATTRIBUTE.getValue().equals(this.source)) {
            return AttributeType.getAttributeType(this.type).getShortName();
        }
        if (AttributeSourceType.THIRD_PARTY_TYPE.getValue().equals(this.source)) {
            return getLastString();
        }
        if (AttributeSourceType.ENTITY.getValue().equals(this.source)) {
            return getEntityTypeString();
        }
        if (AttributeSourceType.COLLECTION.getValue().equals(this.source)) {
            return getCollectionTypeString();
        }
        return "";
    }
    
    /**
     *
     * 返回类型名称字符串如："java.util.List" "com.comtop.top.xxx.UserVO"
     *
     * @return 类型名称
     */
    public String readDataTypeFullName() {
        if (AttributeSourceType.PRIMITIVE.getValue().equals(this.source)
            || AttributeSourceType.DATA_DICTIONARY.getValue().equals(this.source)
            || AttributeSourceType.ENUM_TYPE.getValue().equals(this.source)
            || AttributeSourceType.JAVA_OBJECT.getValue().equals(this.source)
            || AttributeSourceType.OTHER_ENTITY_ATTRIBUTE.getValue().equals(this.source)) {
            String strFullName = AttributeType.getAttributeType(this.type).getFullName();
            return strFullName == null ? AttributeType.getAttributeType(this.type).getShortName() : strFullName;
        }
        if (AttributeSourceType.THIRD_PARTY_TYPE.getValue().equals(this.source)) {
            return this.value == null ? "" : this.value;
        }
        if (AttributeSourceType.ENTITY.getValue().equals(this.source)) {
            return getEntityTypeFullName();
        }
        if (AttributeSourceType.COLLECTION.getValue().equals(this.source)) {
            return AttributeType.getAttributeType(this.type).getFullName();
        }
        return "";
    }
    
    /**
     * 获取方法返回值实体ID集合（供文档导入导出使用）
     * 
     * <pre>
     * 
     * </pre>
     * 
     * @return 实体IID集合
     */
    public List<String> readRelationEntityIds() {
        List<String> lstEntityId = new ArrayList<String>();
        if (AttributeSourceType.ENTITY.getValue().equals(this.source)) {
            lstEntityId.add(this.value);
        } else if (AttributeSourceType.COLLECTION.getValue().equals(this.source)) {
            if (this.generic == null || this.generic.size() == 0) {
                return lstEntityId;
            }
            for (DataTypeVO objDataTypeVO : generic) {
                lstEntityId.addAll(objDataTypeVO.readRelationEntityIds());
            }
        }
        return lstEntityId;
    }
    
    /**
     * 返回实体类型
     * 
     * @return 字符串 如:com.cotmop.xxx.UserVO
     */
    private String getEntityTypeFullName() {
        return this.value.replace(".entity.", ".model.") + "VO";
    }
    
    /**
     * 
     * @return xx
     */
    private String getCollectionTypeString() {
        String strSelfType = AttributeType.getAttributeType(this.type).getShortName();
        String strGenericType = getGenericType();
        return strSelfType + strGenericType;
    }
    
    /**
     * 获取泛型类型
     * 
     * @return 泛型类型
     */
    private String getGenericType() {
        if (generic == null || generic.isEmpty()) {
            return "";
        }
        String str = "";
        
        for (DataTypeVO dataTypeVO : generic) {
            str += dataTypeVO.readDataTypeName() + ",";
        }
        str = str.substring(0, str.length() - 1);
        return "<" + str + ">";
    }
    
    /**
     * 截取最后一个“.”后面的字符串
     * 
     * @return 字符串
     */
    private String getLastString() {
        if (this.value == null) {
            return "";
        }
        String[] strTme = this.value.split("\\.");
        return strTme[strTme.length - 1];
    }
    
    /**
     * 截取最后一个“.”后面的字符串
     * 
     * @return 字符串
     */
	private String getEntityTypeString() {
		if (this.value == null) {
			return "";
		}

		String[] strTme = this.value.split("\\.");
		String strEntityName = strTme[strTme.length - 1];
		return strEntityName + "VO";
	}
    
    /**
     *
     * 返回类型的全路径的<a>List<String></a>,如：<a>com.comtop.UserVo</a>、<a>java.sql.Date</a> 此元数据用于生成代码<a>import</a>。
     *
     * @return 导入类集合
     */
    public List<String> readImportDateType() {
        if (AttributeSourceType.PRIMITIVE.getValue().equals(this.source)
            || AttributeSourceType.DATA_DICTIONARY.getValue().equals(this.source)
            || AttributeSourceType.ENUM_TYPE.getValue().equals(this.source)
            || AttributeSourceType.JAVA_OBJECT.getValue().equals(this.source)
            || AttributeSourceType.OTHER_ENTITY_ATTRIBUTE.getValue().equals(this.source)) {
            String fullName = AttributeType.getAttributeType(this.type).getFullName();
            if (fullName == null) {
                return new ArrayList<String>(0);
            }
            List<String> lstImport = new ArrayList<String>(1);
            lstImport.add(fullName);
            return lstImport;
        }
        
        if (AttributeSourceType.THIRD_PARTY_TYPE.getValue().equals(this.source)) {
            if (this.value == null) {
                return new ArrayList<String>(0);
            }
            List<String> lstImport = new ArrayList<String>(1);
            lstImport.add(this.value);
            return lstImport;
        }
        if (AttributeSourceType.ENTITY.getValue().equals(this.source)) {
            return getEntityTypeImport();
        }
        if (AttributeSourceType.COLLECTION.getValue().equals(this.source)) {
            return getCollectionTypeImport();
        }
        return new ArrayList<String>(0);
    }
    
    /**
     * 返回集合类型的引入类
     * 
     * @return 集合
     */
    private List<String> getCollectionTypeImport() {
        List<String> lstImport = new ArrayList<String>();
        String strSelfType = AttributeType.getAttributeType(this.type).getFullName();
        lstImport.add(strSelfType);
        lstImport.addAll(getGenericTypeImport());
        return lstImport;
    }
    
    /**
     * 获取泛型类型
     * 
     * @return 泛型类型
     */
    private List<String> getGenericTypeImport() {
        List<String> lstImport = new ArrayList<String>();
        if (generic == null || generic.isEmpty()) {
            return lstImport;
        }
        for (DataTypeVO dataTypeVO : generic) {
            lstImport.addAll(dataTypeVO.readImportDateType());
        }
        return lstImport;
    }
    
    /**
     * 实体类型全路径
     * 
     * @return list<string>
     */
    private List<String> getEntityTypeImport() {
        List<String> lstImport = new ArrayList<String>(1);
        if (this.value == null) {
            return lstImport;
        }
        String[] strTme = this.value.split("\\.");
        if (strTme.length < 2) {
            return lstImport;
        }
        
        String strImport = "";
        for (int i = 0; i < strTme.length - 2; i++) {
            strImport += strTme[i] + ".";
        }
        strImport = strImport + "model." + strTme[strTme.length - 1] + "VO";
        lstImport.add(strImport);
        return lstImport;
    }
}
