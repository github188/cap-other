/******************************************************************************
 * Copyright (C) 2016 ShenZhen ComTop Information Technology Co.,Ltd
 * All Rights Reserved.
 * 本软件为深圳康拓普开发研制。未经本公司正式书面同意，其他任何个人、团体不得使用、
 * 复制、修改或发布本软件.
 *****************************************************************************/

package com.comtop.cap.bm.metadata.page.actionlibrary.model;

import java.util.ArrayList;
import java.util.List;

import com.comtop.cap.bm.metadata.base.model.BaseModel;

import comtop.org.directwebremoting.annotations.DataTransferObject;

/**
 * 引用JS函数json对象
 *
 * @author xiaowei
 * @since jdk1.6
 * @version 2016年11月7日 xiaowei
 */
@DataTransferObject
public class JSFunctionsVO extends BaseModel {
    
    /**
     * JS文件中包含函数集合
     */
    private List<JSFunctionVO> jsFunctions = new ArrayList<JSFunctionVO>();
    
    /**
     * 构造函数
     */
    public JSFunctionsVO() {
        this.setModelId("preference.config.customAction.SelectJSFunction");
        this.setModelPackage("preference.config");
        this.setModelName("SelectJSFunction");
        this.setModelType("customAction");
    }
    
    /**
     * 获取自定义modelId
     * @return 字符
     */
    public static String getCustomModelId(){
        return "preference.config.customAction.SelectJSFunction";
    }
    
    /**
     * @return 获取 jsFunctions属性值
     */
    public List<JSFunctionVO> getJsFunctions() {
        return jsFunctions;
    }
    
    /**
     * @param jsFunctions 设置 jsFunctions 属性值为参数值 jsFunctions
     */
    public void setJsFunctions(List<JSFunctionVO> jsFunctions) {
        this.jsFunctions = jsFunctions;
    }
    
}
