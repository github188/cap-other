/******************************************************************************
 * Copyright (C) 2015 ShenZhen ComTop Information Technology Co.,Ltd
 * All Rights Reserved.
 * 本软件为深圳康拓普开发研制。未经本公司正式书面同意，其他任何个人、团体不得使用、
 * 复制、修改或发布本软件.
 *****************************************************************************/

package com.comtop.cap.document.word.docmodel.data;

import java.io.Serializable;

import com.comtop.cap.document.word.docconfig.model.ConfigElement;
import com.comtop.cip.json.annotation.JSONField;

/**
 * Word元素基类
 *
 * @author lizhiyong
 * @since jdk1.6
 * @version 2015年10月21日 lizhiyong
 */
public abstract class WordElement implements Serializable {
    
    /** 类序列号 */
    private static final long serialVersionUID = 1L;
    
    /** 名称 */
    private String name;
    
    /** id */
    private String id;
    
    /** 序号 */
    private Integer sortNo;
    
    /** 同层次下最多出现次数 */
    @JSONField(serialize = false)
    private Integer maxOccurs;
    
    /** 当前元素的定义信息 */
    @JSONField(serialize = false)
    private ConfigElement definition;
    
    /**
     * @return 获取 maxOccurs属性值
     */
    public int getMaxOccurs() {
        return maxOccurs == null ? Integer.MAX_VALUE : (maxOccurs < 0 ? Integer.MAX_VALUE : maxOccurs);
    }
    
    /**
     * @param maxOccurs 设置 maxOccurs 属性值为参数值 maxOccurs
     */
    public void setMaxOccurs(int maxOccurs) {
        this.maxOccurs = maxOccurs;
    }
    
    /**
     * @return 获取 definition属性值
     */
    public ConfigElement getDefinition() {
        return definition;
    }
    
    /**
     * @param definition 设置 definition 属性值为参数值 definition
     */
    public void setDefinition(ConfigElement definition) {
        this.definition = definition;
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
        return sortNo == null ? 0 : sortNo;
    }
    
    /**
     * @param sortNo 设置 sortNo 属性值为参数值 sortNo
     */
    public void setSortNo(Integer sortNo) {
        this.sortNo = sortNo;
    }
    
}
