/******************************************************************************
 * Copyright (C) 2015 ShenZhen ComTop Information Technology Co.,Ltd
 * All Rights Reserved.
 * 本软件为深圳康拓普开发研制。未经本公司正式书面同意，其他任何个人、团体不得使用、
 * 复制、修改或发布本软件.
 *****************************************************************************/

package com.comtop.cap.bm.metadata.page.actionlibrary.model;

import com.comtop.cap.bm.metadata.base.model.BaseMetadata;

import comtop.org.directwebremoting.annotations.DataTransferObject;

/**
 * 控件属性
 * 
 * 
 * @author 诸焕辉
 * @since 1.0
 * @version 2015-5-13 诸焕辉
 */
@DataTransferObject
public class ParameterVO extends BaseMetadata {
    
    /** serialVersionUID */
    private static final long serialVersionUID = 2295802380032503526L;
    
    /** 英文名称 */
    private String ename;
    
    /** 显示文本 */
    private String remark;

    
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
    
  
}
