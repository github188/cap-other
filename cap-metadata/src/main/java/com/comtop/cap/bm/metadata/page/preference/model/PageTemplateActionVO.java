/******************************************************************************
 * Copyright (C) 2015 ShenZhen ComTop Information Technology Co.,Ltd
 * All Rights Reserved.
 * 本软件为深圳康拓普开发研制。未经本公司正式书面同意，其他任何个人、团体不得使用、
 * 复制、修改或发布本软件.
 *****************************************************************************/

package com.comtop.cap.bm.metadata.page.preference.model;

import javax.persistence.Id;

import com.comtop.cap.bm.metadata.base.model.BaseMetadata;
import com.comtop.cap.bm.metadata.common.storage.annotation.AggregationField;
import com.comtop.cap.bm.metadata.common.storage.annotation.IgnoreField;
import com.comtop.cap.bm.metadata.page.actionlibrary.model.ActionDefineVO;
import comtop.org.directwebremoting.annotations.DataTransferObject;

/**
 * 引入文件首选项
 *
 * @author 肖威
 * @version jdk1.6
 * @version 2015-12-21
 */
@DataTransferObject
public class PageTemplateActionVO extends BaseMetadata {
    
    /** 标识 */
    private static final long serialVersionUID = 5966461224961964523L;
    
    /** 行为模板的modelId */
    @Id
    private String actionId;
    
    /***/
    @IgnoreField
    @AggregationField(value = "actionId")
    private ActionDefineVO actionDefineVO;
    
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
     * @return 获取 actionId属性值
     */
    public String getActionId() {
        return actionId;
    }
    
    /**
     * @param actionId 设置 actionId 属性值为参数值 actionId
     */
    public void setActionId(String actionId) {
        this.actionId = actionId;
    }
}
