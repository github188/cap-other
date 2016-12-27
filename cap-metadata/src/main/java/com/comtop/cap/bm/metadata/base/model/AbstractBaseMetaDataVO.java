/******************************************************************************
 * Copyright (C) 2014 ShenZhen ComTop Information Technology Co.,Ltd
 * All Rights Reserved.
 * 本软件为深圳康拓普开发研制。未经本公司正式书面同意，其他任何个人、团体不得使用、
 * 复制、修改或发布本软件.
 *****************************************************************************/

package com.comtop.cap.bm.metadata.base.model;

import javax.persistence.Column;

import com.comtop.cap.runtime.base.model.BaseVO;
import com.comtop.cip.validator.javax.validation.constraints.Pattern;
import com.comtop.cip.validator.org.hibernate.validator.constraints.Length;
import comtop.org.directwebremoting.annotations.DataTransferObject;

/**
 * 元数据基础VO
 * 
 * @author 李忠文
 * @since 1.0
 * @version 2014-2-26 李忠文
 */
@DataTransferObject
public abstract class AbstractBaseMetaDataVO extends BaseVO {
    
    /** 序列化ID */
    private static final long serialVersionUID = 1L;
    
    /** 中文名称 */
    @Length(max = 100, message = "中文名称长度超过100。")
    @Column(name = "CH_NAME", length = 100)
    private String chineseName;
    
    /** 英文名称 */
    @Pattern(regexp = "^[a-zA-Z][a-zA-Z0-9_]*$", message = "必须为英文字符、数字和下划线，且必须以英文字符开头。")
    @Length(max = 50, message = "英文名称长度超过50。")
    @Column(name = "ENG_NAME", length = 50)
    private String englishName;
    
    /** 描述 */
    @Length(max = 300, message = "描述信息长度超过300。")
    @Column(name = "DESCRIPTION", length = 300)
    private String description;
    
    /**
     * @return 获取 chineseName属性值
     */
    public String getChineseName() {
        return chineseName;
    }
    
    /**
     * @param chineseName 设置 chineseName 属性值为参数值 chineseName
     */
    public void setChineseName(String chineseName) {
        this.chineseName = chineseName;
    }
    
    /**
     * @return 获取 englishName属性值
     */
    public String getEnglishName() {
        return englishName;
    }
    
    /**
     * @param englishName 设置 englishName 属性值为参数值 englishName
     */
    public void setEnglishName(String englishName) {
        this.englishName = englishName;
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
