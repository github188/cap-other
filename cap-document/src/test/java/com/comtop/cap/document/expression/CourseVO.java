/******************************************************************************
 * Copyright (C) 2016 ShenZhen ComTop Information Technology Co.,Ltd
 * All Rights Reserved.
 * 本软件为深圳康拓普开发研制。未经本公司正式书面同意，其他任何个人、团体不得使用、
 * 复制、修改或发布本软件.
 *****************************************************************************/

package com.comtop.cap.document.expression;


/**
 * 科目
 *
 * @author lizhongwen
 * @since jdk1.6
 * @version 2016年1月8日 lizhongwen
 */
public class CourseVO {
    
    /** 名称 */
    private String name;
    
    /** 编码 */
    private String code;
    
    /** 分科 */
    private String branch;
    
    /**
     * 构造函数
     */
    public CourseVO() {
        super();
    }
    
    /**
     * 构造函数
     * 
     * @param name name
     * @param code code
     */
    public CourseVO(String name, String code) {
        this(name, code, null);
    }
    
    /**
     * 构造函数
     * 
     * @param name name
     * @param code code
     * @param branch branch
     */
    public CourseVO(String name, String code, String branch) {
        super();
        this.name = name;
        this.code = code;
        this.branch = branch;
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
    
    /**
     * @return 获取 branch属性值
     */
    public String getBranch() {
        return branch;
    }
    
    /**
     * @param branch 设置 branch 属性值为参数值 branch
     */
    public void setBranch(String branch) {
        this.branch = branch;
    }
}
