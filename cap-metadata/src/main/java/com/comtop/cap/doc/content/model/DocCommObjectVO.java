/******************************************************************************
 * Copyright (C) 2015 ShenZhen ComTop Information Technology Co.,Ltd
 * All Rights Reserved.
 * 本软件为深圳康拓普开发研制。未经本公司正式书面同意，其他任何个人、团体不得使用、
 * 复制、修改或发布本软件.
 *****************************************************************************/

package com.comtop.cap.doc.content.model;

import java.util.List;
import java.util.Map;

import javax.persistence.Column;
import javax.persistence.Id;
import javax.persistence.Table;

import com.comtop.top.core.base.model.CoreVO;
import comtop.org.directwebremoting.annotations.DataTransferObject;

/**
 * 模型对象实例。如果扩展的模型对象没有独立的存储结构，则对象本身存储在此表中，对象属性存储在CAP_DOC_COMM_ATTRIBUTE表中
 * 
 * @author 李小芬
 * @since 1.0
 * @version 2015-11-12 李小芬
 */
@DataTransferObject
@Table(name = "CAP_DOC_COMM_OBJECT")
public class DocCommObjectVO extends CoreVO {
    
    /** 序列化ID */
    private static final long serialVersionUID = 1L;
    
    /** 根据关系ReAttri生成模型对象属性实例。如果扩展的模型对象没有集合,由CIP自动创建。 */
    private List<DocCommAttributeVO> docCommAttributeByReattris;
    
    /** 流水号 */
    @Id
    @Column(name = "ID", length = 40)
    private String id;
    
    /** 资源标识，对象唯一标识，用于数据交换、查找等场合。唯一标识可能由几个属性值组合而成 */
    @Column(name = "URI", length = 128)
    private String uri;
    
    /** 对象定义URI */
    @Column(name = "CLASS_URI", length = 40)
    private String classUri;
    
    /** 顺序号 */
    @Column(name = "SORT_NO", precision = 10)
    private Integer sortNo;
    
    /** 属性值 */
    private Map<String, String> propertiesMap;
    
    /**
     * @return 获取 根据关系ReAttri生成模型对象属性实例。如果扩展的模型对象没有集合,由CIP自动创建。属性值
     */
    
    public List<DocCommAttributeVO> getDocCommAttributeByReattris() {
        return docCommAttributeByReattris;
    }
    
    /**
     * @param docCommAttributeByReattris 设置 根据关系ReAttri生成模型对象属性实例。如果扩展的模型对象没有集合,由CIP自动创建。属性值为参数值
     *            docCommAttributeByReattris
     */
    
    public void setDocCommAttributeByReattris(List<DocCommAttributeVO> docCommAttributeByReattris) {
        this.docCommAttributeByReattris = docCommAttributeByReattris;
    }
    
    /**
     * @return 获取 流水号属性值
     */
    
    public String getId() {
        return id;
    }
    
    /**
     * @param id 设置 流水号属性值为参数值 id
     */
    
    public void setId(String id) {
        this.id = id;
    }
    
    /**
     * @return 获取 资源标识，对象唯一标识，用于数据交换、查找等场合。唯一标识可能由几个属性值组合而成属性值
     */
    
    public String getUri() {
        return uri;
    }
    
    /**
     * @param uri 设置 资源标识，对象唯一标识，用于数据交换、查找等场合。唯一标识可能由几个属性值组合而成属性值为参数值 uri
     */
    
    public void setUri(String uri) {
        this.uri = uri;
    }
    
    /**
     * @return 获取 对象定义URI属性值
     */
    
    public String getClassUri() {
        return classUri;
    }
    
    /**
     * @param classUri 设置 对象定义URI属性值为参数值 classUri
     */
    
    public void setClassUri(String classUri) {
        this.classUri = classUri;
    }
    
    /**
     * @return 获取 顺序号属性值
     */
    
    public Integer getSortNo() {
        return sortNo;
    }
    
    /**
     * @param sortNo 设置 顺序号属性值为参数值 sortNo
     */
    
    public void setSortNo(Integer sortNo) {
        this.sortNo = sortNo;
    }
    
    /**
     * @return 获取 propertiesMap属性值
     */
    public Map<String, String> getPropertiesMap() {
        return propertiesMap;
    }
    
    /**
     * @param propertiesMap 设置 propertiesMap 属性值为参数值 propertiesMap
     */
    public void setPropertiesMap(Map<String, String> propertiesMap) {
        this.propertiesMap = propertiesMap;
    }
    
}
