/******************************************************************************
 * Copyright (C) 2014 ShenZhen ComTop Information Technology Co.,Ltd
 * All Rights Reserved.
 * 本软件为深圳康拓普开发研制。未经本公司正式书面同意，其他任何个人、团体不得使用、
 * 复制、修改或发布本软件.
 *****************************************************************************/

package com.comtop.cap.bm.metadata.entity.model;

import java.util.List;

import com.comtop.cap.bm.metadata.base.model.BaseMetadata;
import com.comtop.cap.bm.metadata.common.storage.annotation.IgnoreField;
import comtop.org.directwebremoting.annotations.DataTransferObject;

/**
 * 级联属性VO
 *
 * @author 凌晨
 * @since jdk1.6
 * @version 2015年10月22日 凌晨
 */
@DataTransferObject
public class CascadeAttributeVO extends BaseMetadata {
    
    /** 序列化版本ID */
    private static final long serialVersionUID = 1L;
    
    /** 级联属性id，用于构造树型结构数据 */
    private String id;
    
    /** 级联属性父Id，用于构造树型结构数据 */
    private String parentId;
    
    /** 级联属性名称 */
    private String name;
    
    /** 级联属性界面显示类型 */
    @IgnoreField
    private String displayType;
    
    /** 级联属性生成代码使用的类型 */
    private String generateCodeType;
    
    /** 级联属性 */
    private List<CascadeAttributeVO> lstCascadeAttribute;
    
    /** 级联属性名称在页面表格中的缩进单位数（每个单位缩进4em） */
    @IgnoreField
    private Integer indent;
    
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
     * @return 获取 parentId属性值
     */
    public String getParentId() {
        return parentId;
    }
    
    /**
     * @param parentId 设置 parentId 属性值为参数值 parentId
     */
    public void setParentId(String parentId) {
        this.parentId = parentId;
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
     * @return 获取 displayType属性值
     */
    public String getDisplayType() {
        return displayType;
    }
    
    /**
     * @param displayType 设置 displayType 属性值为参数值 displayType
     */
    public void setDisplayType(String displayType) {
        this.displayType = displayType;
    }
    
    /**
     * @return 获取 generateCodeType属性值
     */
    public String getGenerateCodeType() {
        return generateCodeType;
    }
    
    /**
     * @param generateCodeType 设置 generateCodeType 属性值为参数值 generateCodeType
     */
    public void setGenerateCodeType(String generateCodeType) {
        this.generateCodeType = generateCodeType;
    }
    
    /**
     * @return 获取 lstCascadeAttribute属性值
     */
    public List<CascadeAttributeVO> getLstCascadeAttribute() {
        return lstCascadeAttribute;
    }
    
    /**
     * @param lstCascadeAttribute 设置 lstCascadeAttribute 属性值为参数值 lstCascadeAttribute
     */
    public void setLstCascadeAttribute(List<CascadeAttributeVO> lstCascadeAttribute) {
        this.lstCascadeAttribute = lstCascadeAttribute;
    }
    
    /**
     * @return 获取 indent属性值
     */
    public Integer getIndent() {
        return indent;
    }
    
    /**
     * @param indent 设置 indent 属性值为参数值 indent
     */
    public void setIndent(Integer indent) {
        this.indent = indent;
    }
    
}
