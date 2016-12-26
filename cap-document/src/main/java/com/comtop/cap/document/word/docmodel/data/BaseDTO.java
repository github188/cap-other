/******************************************************************************
 * Copyright (C) 2015 ShenZhen ComTop Information Technology Co.,Ltd
 * All Rights Reserved.
 * 本软件为深圳康拓普开发研制。未经本公司正式书面同意，其他任何个人、团体不得使用、
 * 复制、修改或发布本软件.
 *****************************************************************************/

package com.comtop.cap.document.word.docmodel.data;

import java.io.Serializable;

import com.comtop.cap.document.word.docmodel.datatype.DataFromType;

/**
 * DTO基类
 *
 * @author lizhiyong
 * @since jdk1.6
 * @version 2015年11月19日 lizhiyong
 */
public class BaseDTO implements Serializable {
    
    /** 序列号 */
    private static final long serialVersionUID = 1L;
    
    /** 主键 一般是UUID表示 */
    private String id;
    
    /** 序号 用于数据库中的数据排序 */
    private Integer sortNo;
    
    /** 序号 用于word、页面展示时使用 加载每个数据时根据数据量动态取值 */
    private Integer sortIndex;
    
    /** 名称 */
    private String name;
    
    /** 编码 */
    private String code;
    
    /**
     * 备注 和描述字段没有本质的区分，爱用哪个可根据喜好，但在某些情况下，备注和描述同时存在。
     * 一般情况下，备注用于额外的说明，而描述用于事物本身的解释，是对名称的细化说明。
     */
    private String remark;
    
    /**
     * 描述 和备注字段没有本质的区分，爱用哪个可根据喜好，但在某些情况下，备注和描述同时存在。
     * 一般情况下 备注用于额外的说明，而描述用于事物本身的解释，是对名称的细化说明。
     */
    private String description;
    
    /** 数据来源，1：导入；0：系统创建；默认值为0 */
    private Integer dataFrom = DataFromType.IMPORT;
    
    /** 文档ID */
    private String documentId;
    
    /** 业务域id */
    private String domainId;
    
    /** 包id 包指的是一个范围，比如一个应用，一个模块、一个子系统，一个业务域，一个业务表单分组，一个业务对象分组等。 */
    private String packageId;
    
    /**
     * 是否是新的数据对象 从数据库查询的数据，都设置为非新数据 数据在导入时会自动创建id，
     * 因此无法区分哪些数据是本次导入新来的，哪些是数据库已经存在的 通过此属性区分
     */
    private boolean newData = true;
    
    /** 该对象所属的文档内容容器，可能是个章节，也可能是个分节 */
    private transient Container container;
    
    /**
     * @return 获取 sortIndex属性值
     */
    public Integer getSortIndex() {
        return sortIndex;
    }
    
    /**
     * @param sortIndex 设置 sortIndex 属性值为参数值 sortIndex
     */
    public void setSortIndex(Integer sortIndex) {
        this.sortIndex = sortIndex;
    }
    
    /**
     * @return 获取 packageId属性值
     */
    public String getPackageId() {
        return packageId;
    }
    
    /**
     * @param packageId 设置 packageId 属性值为参数值 packageId
     */
    public void setPackageId(String packageId) {
        this.packageId = packageId;
    }
    
    /**
     * @return 获取 id属性值
     */
    public String getId() {
        return id;
    }
    
    /**
     * @param id 设置 id 属性值为参数值 id
     */
    public void setId(String id) {
        this.id = id;
    }
    
    /**
     * @return 获取 sortNo属性值
     */
    public Integer getSortNo() {
        return sortNo;
    }
    
    /**
     * @param sortNo 设置 sortNo 属性值为参数值 sortNo
     */
    public void setSortNo(Integer sortNo) {
        this.sortNo = sortNo;
    }
    
    /**
     * @return 获取 name属性值
     */
    public String getName() {
        return name;
    }
    
    /**
     * @param name 设置 name 属性值为参数值 name
     */
    public void setName(String name) {
        this.name = name;
    }
    
    /**
     * @return 获取 remark属性值
     */
    public String getRemark() {
        return remark;
    }
    
    /**
     * @param remark 设置 remark 属性值为参数值 remark
     */
    public void setRemark(String remark) {
        this.remark = remark;
    }
    
    /**
     * @return 获取 dataFrom属性值
     */
    public int getDataFrom() {
        return dataFrom;
    }
    
    /**
     * @param dataFrom 设置 dataFrom 属性值为参数值 dataFrom
     */
    public void setDataFrom(int dataFrom) {
        this.dataFrom = dataFrom;
    }
    
    /**
     * @return 获取 documentId属性值
     */
    public String getDocumentId() {
        return documentId;
    }
    
    /**
     * @param documentId 设置 documentId 属性值为参数值 documentId
     */
    public void setDocumentId(String documentId) {
        this.documentId = documentId;
    }
    
    /**
     * @return 获取 domainId属性值
     */
    public String getDomainId() {
        return domainId;
    }
    
    /**
     * @param domainId 设置 domainId 属性值为参数值 domainId
     */
    public void setDomainId(String domainId) {
        this.domainId = domainId;
    }
    
    /**
     * @return 获取 code属性值
     */
    public String getCode() {
        return code;
    }
    
    /**
     * @param code 设置 code 属性值为参数值 code
     */
    public void setCode(String code) {
        this.code = code;
    }
    
    /**
     * @return 获取 newData属性值
     */
    public boolean isNewData() {
        return newData;
    }
    
    /**
     * @param newData 设置 newData 属性值为参数值 newData
     */
    public void setNewData(boolean newData) {
        this.newData = newData;
    }
    
    /**
     * @return 获取 container属性值
     */
    public Container getContainer() {
        return container;
    }
    
    /**
     * @param container 设置 container 属性值为参数值 container
     */
    public void setContainer(Container container) {
        this.container = container;
    }
    
    /**
     * @return 获取 description属性值
     */
    public String getDescription() {
        return description;
    }
    
    /**
     * @param description 设置 description 属性值为参数值 description
     */
    public void setDescription(String description) {
        this.description = description;
    }
    
}
