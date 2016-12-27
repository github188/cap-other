/******************************************************************************
 * Copyright (C) 2015 ShenZhen ComTop Information Technology Co.,Ltd
 * All Rights Reserved.
 * 本软件为深圳康拓普开发研制。未经本公司正式书面同意，其他任何个人、团体不得使用、
 * 复制、修改或发布本软件.
 *****************************************************************************/

package com.comtop.cap.bm.metadata.page.desinger.model;

import javax.xml.bind.annotation.XmlRootElement;

import com.comtop.cap.bm.metadata.base.model.BaseMetadata;
import com.comtop.cap.bm.metadata.common.dwr.CapMap;
import com.comtop.cap.bm.metadata.common.storage.annotation.IgnoreField;
import com.comtop.cap.bm.metadata.page.actionlibrary.model.ActionDefineVO;
import comtop.org.directwebremoting.annotations.DataTransferObject;

/**
 * 行为模型
 * 
 * @author 诸焕辉
 * @version jdk1.6
 * @version 2015-4-28 诸焕辉
 */
@XmlRootElement(name = "pageaction")
@DataTransferObject
public class PageActionVO extends BaseMetadata {
    
    /** serialVersionUID */
    private static final long serialVersionUID = -2848876975074577627L;
    
    /**
     * 行为Id
     */
    private String pageActionId;
    
    /** 行为英文名 */
    private String ename;
    
    /** 行为中文名 */
    private String cname;
    
    /** 描述 */
    private String description;
    
    /** 行为模板ID */
    private String methodTemplate;
    
    /** 行为参数选项 */
    private CapMap methodOption = new CapMap();
    
    /** 行为方法体扩展 */
    private CapMap methodBodyExtend = new CapMap();
    
    /** 行为方法体 */
    private String methodBody;
    
    /**
     * 行为定义
     */
    @IgnoreField
    private ActionDefineVO actionDefineVO = new ActionDefineVO();
    
    /** 行为模板初始属性个数 */
    @IgnoreField
    private Integer initPropertiesCount;
    
    /**
     * @return 获取 ename属性值
     */
    public String getEname() {
        return ename;
    }
    
    /**
     * @param ename 设置 ename 属性值为参数值 ename
     */
    public void setEname(String ename) {
        this.ename = ename;
    }
    
    /**
     * @return 获取 cname属性值
     */
    public String getCname() {
        return cname;
    }
    
    /**
     * @param cname 设置 cname 属性值为参数值 cname
     */
    public void setCname(String cname) {
        this.cname = cname;
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
     * @return 获取 methodTemplate属性值
     */
    public String getMethodTemplate() {
        return methodTemplate;
    }
    
    /**
     * @param methodTemplate 设置 methodTemplate 属性值为参数值 methodTemplate
     */
    public void setMethodTemplate(String methodTemplate) {
        this.methodTemplate = methodTemplate;
    }
    
    /**
     * @return 获取 methodOption属性值
     */
    public CapMap getMethodOption() {
        return methodOption;
    }
    
    /**
     * @param methodOption 设置 methodOption 属性值为参数值 methodOption
     */
    public void setMethodOption(CapMap methodOption) {
        this.methodOption = methodOption;
    }
    
    /**
     * @return 获取 methodBodyExtend属性值
     */
    public CapMap getMethodBodyExtend() {
        return methodBodyExtend;
    }
    
    /**
     * @param methodBodyExtend 设置 methodBodyExtend 属性值为参数值 methodBodyExtend
     */
    public void setMethodBodyExtend(CapMap methodBodyExtend) {
        this.methodBodyExtend = methodBodyExtend;
    }
    
    /**
     * @return 获取 methodBody属性值
     */
    public String getMethodBody() {
        return methodBody;
    }
    
    /**
     * @param methodBody 设置 methodBody 属性值为参数值 methodBody
     */
    public void setMethodBody(String methodBody) {
        this.methodBody = methodBody;
    }
    
    /**
     * @return the actionDefineVO
     */
    public ActionDefineVO getActionDefineVO() {
        return actionDefineVO;
    }
    
    /**
     * @param actionDefineVO the actionDefineVO to set
     */
    public void setActionDefineVO(ActionDefineVO actionDefineVO) {
        this.actionDefineVO = actionDefineVO;
    }
    
    /**
     * @return the pageActionId
     */
    public String getPageActionId() {
        return pageActionId;
    }
    
    /**
     * @param pageActionId the pageActionId to set
     */
    public void setPageActionId(String pageActionId) {
        this.pageActionId = pageActionId;
    }
    
    /**
     * @return 获取 initPropertiesCount属性值
     */
    public Integer getInitPropertiesCount() {
        return initPropertiesCount;
    }
    
    /**
     * @param initPropertiesCount 设置 initPropertiesCount 属性值为参数值 initPropertiesCount
     */
    public void setInitPropertiesCount(Integer initPropertiesCount) {
        this.initPropertiesCount = initPropertiesCount;
    }
    
}
