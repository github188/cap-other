/******************************************************************************
 * Copyright (C) 2016 ShenZhen ComTop Information Technology Co.,Ltd
 * All Rights Reserved.
 * 本软件为深圳康拓普开发研制。未经本公司正式书面同意，其他任何个人、团体不得使用、
 * 复制、修改或发布本软件.
 *****************************************************************************/

package com.comtop.cap.bm.metadata.page.actionlibrary.model;

import java.util.ArrayList;
import java.util.List;

import com.comtop.cap.bm.metadata.base.model.BaseMetadata;

import comtop.org.directwebremoting.annotations.DataTransferObject;

/**
 * 引用JS函数VO
 *
 * @author xiaowei
 * @since jdk1.6
 * @version 2016年11月7日 xiaowei
 */
@DataTransferObject
public class JSFunctionVO extends BaseMetadata {
    
    
    /** 函数名称 */
    private String functionName;
    
    /** 函数方法名称 */
    private String functionFullName;
    
    /** 入参 */
    private List<ParameterVO> inParams = new ArrayList<ParameterVO>();
    
    /** 函数方法名称 */
    private String inParamsDeclare;
    
    /** 出参 */
    private List<ParameterVO> outParams = new ArrayList<ParameterVO>();
    
    /** 函数方法名称 */
    private String outParamsDeclare;
    
    /** 备注 */
    private String remark;
    
    /** 分组  component为组件可用，空为组件行为都可用*/
    private String group;
    
    /**
     * @return 获取 functionName属性值
     */
    public String getFunctionName() {
        return functionName;
    }
    
    /**
     * @param functionName 设置 functionName 属性值为参数值 functionName
     */
    public void setFunctionName(String functionName) {
        this.functionName = functionName;
    }
    
    /**
     * @return 获取 inParams属性值
     */
    public List<ParameterVO> getInParams() {
        return inParams;
    }
    
    /**
     * @param inParams 设置 inParams 属性值为参数值 inParams
     */
    public void setInParams(List<ParameterVO> inParams) {
        this.inParams = inParams;
    }
    
    /**
     * @return 获取 outParams属性值
     */
    public List<ParameterVO> getOutParams() {
        return outParams;
    }
    
    /**
     * @param outParams 设置 outParams 属性值为参数值 outParams
     */
    public void setOutParams(List<ParameterVO> outParams) {
        this.outParams = outParams;
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
     * @return 获取 functionFullName属性值
     */
    public String getFunctionFullName() {
        return functionFullName;
    }
    
    /**
     * @param functionFullName 设置 functionFullName 属性值为参数值 functionFullName
     */
    public void setFunctionFullName(String functionFullName) {
        this.functionFullName = functionFullName;
    }
    
    /**
     * @return 获取 inParamsDeclare属性值
     */
    public String getInParamsDeclare() {
        return inParamsDeclare;
    }
    
    /**
     * @param inParamsDeclare 设置 inParamsDeclare 属性值为参数值 inParamsDeclare
     */
    public void setInParamsDeclare(String inParamsDeclare) {
        this.inParamsDeclare = inParamsDeclare;
    }
    
    /**
     * @return 获取 outParamsDeclare属性值
     */
    public String getOutParamsDeclare() {
        return outParamsDeclare;
    }
    
    /**
     * @param outParamsDeclare 设置 outParamsDeclare 属性值为参数值 outParamsDeclare
     */
    public void setOutParamsDeclare(String outParamsDeclare) {
        this.outParamsDeclare = outParamsDeclare;
    }
    
    /**
     * @return 获取 group属性值
     */
    public String getGroup() {
        return group;
    }

    /**
     * @param group 设置 group 属性值为参数值 group
     */
    public void setGroup(String group) {
        this.group = group;
    }
    
}
