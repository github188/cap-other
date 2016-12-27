/******************************************************************************
 * Copyright (C) 2014 ShenZhen ComTop Information Technology Co.,Ltd
 * All Rights Reserved.
 * 本软件为深圳康拓普开发研制。未经本公司正式书面同意，其他任何个人、团体不得使用、
 * 复制、修改或发布本软件.
 *****************************************************************************/

package com.comtop.cap.bm.metadata.serve.model;

import java.util.ArrayList;
import java.util.List;

import com.comtop.cap.bm.metadata.base.inter.SoaRegisterBaseData;
import com.comtop.cap.bm.metadata.base.model.BaseModel;
import com.comtop.cap.bm.metadata.base.model.SoaBaseType;
import com.comtop.cap.bm.metadata.entity.model.MethodVO;
import com.comtop.cap.bm.metadata.sysmodel.model.CapPackageVO;
import comtop.org.directwebremoting.annotations.DataTransferObject;

/**
 * 服务对象VO
 * 
 * @author 林玉千
 * @since 1.0
 * @version 2016-5-27 林玉千 新建
 */
@DataTransferObject
public class ServiceObjectVO extends BaseModel implements SoaRegisterBaseData {
    
    /** 标识 */
    private static final long serialVersionUID = 1L;
    
    /** 服务ID */
    private String serviceObjectId;
    
    /** 所在包 */
    private CapPackageVO packageVO;
    
    /** 所在包Id */
    private String packageId;
    
    /** 服务类中文名 */
    private String chineseName;
    
    /** 服务类名 */
    private String englishName;
    
    /** 服务类别名 */
    private String serviceAlias;
    
    /** 类实体构造器 */
    private String buildClass;
    
    /** 描述 */
    private String description;
    
    /** 实体方法 */
    private List<MethodVO> methods;
    
    /**
     * @return 获取 packageId属性值
     */
    public String getPackageId() {
        return packageId;
    }
    
    /**
     * @param packageId 设置 packageId 属性值为参数值 packageId
     */
    public void setPackageId(String packageId) {
        this.packageId = packageId;
    }
    
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
     * @return 获取 serviceAlias属性值
     */
    public String getServiceAlias() {
        return serviceAlias;
    }
    
    /**
     * @param serviceAlias 设置 serviceAlias 属性值为参数值 serviceAlias
     */
    public void setServiceAlias(String serviceAlias) {
        this.serviceAlias = serviceAlias;
    }
    
    /**
     * @return 获取 buildClass属性值
     */
    public String getBuildClass() {
        return buildClass;
    }
    
    /**
     * @param buildClass 设置 buildClass 属性值为参数值 buildClass
     */
    public void setBuildClass(String buildClass) {
        this.buildClass = buildClass;
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
    
    /**
     * @return 获取 methods属性值
     */
    public List<MethodVO> getMethods() {
        return methods;
    }
    
    /**
     * @param methods 设置 methods 属性值为参数值 methods
     */
    public void setMethods(List<MethodVO> methods) {
        this.methods = methods;
    }
    
    /**
     * 向实体中添加方法
     * 
     * @param method 方法
     */
    public void addMethod(MethodVO method) {
        if (this.methods == null) {
            this.methods = new ArrayList<MethodVO>();
        }
        this.methods.add(method);
    }
    
    /**
     * @return 获取 serviceObjectId属性值
     */
    public String getServiceObjectId() {
        return serviceObjectId;
    }
    
    /**
     * @param serviceObjectId 设置 serviceObjectId 属性值为参数值 serviceObjectId
     */
    public void setServiceObjectId(String serviceObjectId) {
        this.serviceObjectId = serviceObjectId;
    }
    
    /**
     * @return 获取 packageVO属性值
     */
    public CapPackageVO getPackageVO() {
        return packageVO;
    }
    
    /**
     * @param packageVO 设置 packageVO 属性值为参数值 packageVO
     */
    public void setPackageVO(CapPackageVO packageVO) {
        this.packageVO = packageVO;
    }
    
    /**
     * 
     * @see com.comtop.cap.bm.metadata.base.inter.SoaRegisterBaseData#gainObjectType()
     */
    @Override
    public String gainObjectType() {
        return SoaBaseType.SERVICEOBJECT_TYPE.getValue();
    }
    
}
