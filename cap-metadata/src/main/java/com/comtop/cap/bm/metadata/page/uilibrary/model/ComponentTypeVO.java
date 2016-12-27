/******************************************************************************
 * Copyright (C) 2015 ShenZhen ComTop Information Technology Co.,Ltd
 * All Rights Reserved.
 * 本软件为深圳康拓普开发研制。未经本公司正式书面同意，其他任何个人、团体不得使用、
 * 复制、修改或发布本软件.
 *****************************************************************************/

package com.comtop.cap.bm.metadata.page.uilibrary.model;

import java.util.ArrayList;
import java.util.List;

import javax.xml.bind.annotation.XmlRootElement;

import com.comtop.cap.bm.metadata.base.model.BaseModel;
import comtop.org.directwebremoting.annotations.DataTransferObject;

/**
 * 控件类型模型
 *
 * @author 诸焕辉
 * @version jdk1.5
 * @version 2015-5-22 诸焕辉
 */
@DataTransferObject
@XmlRootElement(name = "componentType")
public class ComponentTypeVO extends BaseModel {
    
    /** 标识 */
    private static final long serialVersionUID = 2825877855055900495L;
    
    /** 控件分类定义 */
    private List<ComponentSubTypeVO> type = new ArrayList<ComponentSubTypeVO>();
    
    /**
     * 构造函数
     */
    public ComponentTypeVO() {
        this.setModelId(ComponentTypeVO.getDefaultModelId());
        this.setModelName("type");
        this.setModelType("componentType");
        this.setModelPackage("uilibrary");
    }
    
    /**
     * @return 获取 type属性值
     */
    public List<ComponentSubTypeVO> getType() {
        return type;
    }
    
    /**
     * @param type 设置 type 属性值为参数值 type
     */
    public void setType(List<ComponentSubTypeVO> type) {
        this.type = type;
    }
    
    /**
     * 获取modelId
     * @return 字符
     */
    public static String getDefaultModelId(){
        return "uilibrary.componentType.type";
    }
}
