/******************************************************************************
 * Copyright (C) 2015 ShenZhen ComTop Information Technology Co.,Ltd
 * All Rights Reserved.
 * 本软件为深圳康拓普开发研制。未经本公司正式书面同意，其他任何个人、团体不得使用、
 * 复制、修改或发布本软件.
 *****************************************************************************/

package com.comtop.cap.bm.metadata.page.template.model;

import java.util.ArrayList;
import java.util.List;

import com.comtop.cap.bm.metadata.base.model.BaseModel;
import comtop.org.directwebremoting.annotations.DataTransferObject;

/**
 * 元数据模板分类配置
 * 
 * @author 诸焕辉
 * @version jdk1.6
 * @version 2015-9-22 诸焕辉
 */
@DataTransferObject
public class MetadataTmpTypeVO extends BaseModel {
    
    /** 标识 */
    private static final long serialVersionUID = 6115425017003955530L;
    
    /**
     * 分类类型定义
     */
    private List<MetadataTmpTypeDefineVO> type = new ArrayList<MetadataTmpTypeDefineVO>();
    
    /**
     * 构造函数
     */
    public MetadataTmpTypeVO() {
        this.setModelId("template.metadataTmpType.baseType");
        this.setModelName("type");
        this.setModelType("metadataTmpType");
        this.setModelPackage("template");
    }
    
    /**
     * 返回可修改的元数据模板分类
     * 
     * @return 字符串
     */
    public static String getCustomMetaTmpTypeModelId() {
        return "template.metadataTmpType.customType";
    }
    
    /**
     * 创建自定义模版分类配置文件
     * 
     * @return 配置对象
     */
    public static MetadataTmpTypeVO createCustomMetadataTmpTypeVO() {
        MetadataTmpTypeVO objMetadataTmpTypeVO = new MetadataTmpTypeVO();
        String strExtend = objMetadataTmpTypeVO.getModelId();
        objMetadataTmpTypeVO.setExtend(strExtend);
        objMetadataTmpTypeVO.setModelId(getCustomMetaTmpTypeModelId());
        objMetadataTmpTypeVO.setModelName("customType");
        return objMetadataTmpTypeVO;
    }
    
    /**
     * @return 获取 type属性值
     */
    public List<MetadataTmpTypeDefineVO> getType() {
        return type;
    }
    
    /**
     * @param type 设置 type 属性值为参数值 type
     */
    public void setType(List<MetadataTmpTypeDefineVO> type) {
        this.type = type;
    }
    
}
