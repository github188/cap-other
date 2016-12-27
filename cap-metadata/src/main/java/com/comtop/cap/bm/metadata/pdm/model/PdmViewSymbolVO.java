/******************************************************************************
 * Copyright (C) 2015 ShenZhen ComTop Information Technology Co.,Ltd
 * All Rights Reserved.
 * 本软件为深圳康拓普开发研制。未经本公司正式书面同意，其他任何个人、团体不得使用、
 * 复制、修改或发布本软件.
 *****************************************************************************/
package com.comtop.cap.bm.metadata.pdm.model;

/**
 * Created by duqi on 2016/2/23.
 */
public class PdmViewSymbolVO extends PdmSymbolVO{
    /** 引用表ID */
    private String refViewId;

    /**
     * @return 获取 refViewId属性值
     */
    public String getRefViewId() {
        return refViewId;
    }

    /**
     * @param refViewId 设置 refViewId 属性值为参数值 refViewId
     */
    public void setRefViewId(String refViewId) {
        this.refViewId = refViewId;
    }
}
