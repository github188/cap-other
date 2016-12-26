/******************************************************************************
 * Copyright (C) 2016 ShenZhen ComTop Information Technology Co.,Ltd
 * All Rights Reserved.
 * 本软件为深圳康拓普开发研制。未经本公司正式书面同意，其他任何个人、团体不得使用、
 * 复制、修改或发布本软件.
 *****************************************************************************/

package com.comtop.cap.document.expression;

/**
 * 成绩
 *
 * @author lizhongwen
 * @since jdk1.6
 * @version 2016年1月8日 lizhongwen
 */
public class ScoreVO {
    
    /** 编码 */
    private String code;
    
    /** 名称 */
    private String name;
    
    /** 分科编码 */
    private String branchCode;
    
    /** 分科名称 */
    private String branchName;
    
    /** 成绩 */
    private Integer score;
    
    /**
     * 构造函数
     */
    public ScoreVO() {
        super();
    }
    
    /**
     * 构造函数
     * 
     * @param code code
     * @param name name
     * @param branchCode branchCode
     * @param branchName branchName
     * @param score score
     */
    public ScoreVO(String code, String name, String branchCode, String branchName, Integer score) {
        super();
        this.code = code;
        this.name = name;
        this.branchCode = branchCode;
        this.branchName = branchName;
        this.score = score;
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
     * @return 获取 score属性值
     */
    public Integer getScore() {
        return score;
    }
    
    /**
     * @param score 设置 score 属性值为参数值 score
     */
    public void setScore(Integer score) {
        this.score = score;
    }
    
    /**
     * @return 获取 branchCode属性值
     */
    public String getBranchCode() {
        return branchCode;
    }
    
    /**
     * @param branchCode 设置 branchCode 属性值为参数值 branchCode
     */
    public void setBranchCode(String branchCode) {
        this.branchCode = branchCode;
    }
    
    /**
     * @return 获取 branchName属性值
     */
    public String getBranchName() {
        return branchName;
    }
    
    /**
     * @param branchName 设置 branchName 属性值为参数值 branchName
     */
    public void setBranchName(String branchName) {
        this.branchName = branchName;
    }
}
