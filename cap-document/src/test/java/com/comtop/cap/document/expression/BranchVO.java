/******************************************************************************
 * Copyright (C) 2016 ShenZhen ComTop Information Technology Co.,Ltd
 * All Rights Reserved.
 * 本软件为深圳康拓普开发研制。未经本公司正式书面同意，其他任何个人、团体不得使用、
 * 复制、修改或发布本软件.
 *****************************************************************************/

package com.comtop.cap.document.expression;

/**
 * 分科
 *
 * @author lizhongwen
 * @since jdk1.6
 * @version 2016年1月8日 lizhongwen
 */
public class BranchVO {
    
    /** 名称 */
    private String name;
    
    /** 编码 */
    private String code;
    
    /**
     * 构造函数
     */
    public BranchVO() {
        super();
    }
    
    /**
     * 构造函数
     * 
     * @param name name
     * @param code code
     */
    public BranchVO(String name, String code) {
        super();
        this.name = name;
        this.code = code;
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
}
