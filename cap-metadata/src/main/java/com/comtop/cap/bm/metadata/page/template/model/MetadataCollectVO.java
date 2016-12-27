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
import com.comtop.cap.bm.metadata.page.desinger.model.DataStoreVO;
import com.comtop.cap.bm.metadata.page.desinger.model.LayoutVO;
import com.comtop.cap.bm.metadata.page.desinger.model.PageActionVO;
import com.comtop.cap.bm.metadata.page.desinger.model.PageComponentExpressionVO;
import comtop.org.directwebremoting.annotations.DataTransferObject;

/**
 * 元数据收藏
 * 
 * @author 诸焕辉
 * @version jdk1.6
 * @version 2015-9-22 诸焕辉
 */
@DataTransferObject
public class MetadataCollectVO extends BaseModel {
    
    /** 标识 */
    private static final long serialVersionUID = 4196814408528808427L;
    
    /**
     * 描述
     */
    private String description;
    
    /**
     * 布局
     */
    private LayoutVO layoutVO;
    
    /**
     * 页面数据集
     */
    private List<DataStoreVO> dataStoreVOList = new ArrayList<DataStoreVO>();
    
    /**
     * 页面控件状态表达式集合
     */
    private List<PageComponentExpressionVO> pageComponentExpressionVOList = new ArrayList<PageComponentExpressionVO>();
    
    /**
     * 页面行为集合
     */
    private List<PageActionVO> pageActionVOList = new ArrayList<PageActionVO>();
    
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
     * @return 获取 layoutVO属性值
     */
    public LayoutVO getLayoutVO() {
        return layoutVO;
    }
    
    /**
     * @param layoutVO 设置 layoutVO 属性值为参数值 layoutVO
     */
    public void setLayoutVO(LayoutVO layoutVO) {
        this.layoutVO = layoutVO;
    }
    
    /**
     * @return 获取 dataStoreVOList属性值
     */
    public List<DataStoreVO> getDataStoreVOList() {
        return dataStoreVOList;
    }
    
    /**
     * @param dataStoreVOList 设置 dataStoreVOList 属性值为参数值 dataStoreVOList
     */
    public void setDataStoreVOList(List<DataStoreVO> dataStoreVOList) {
        this.dataStoreVOList = dataStoreVOList;
    }
    
    /**
     * @return 获取 pageComponentExpressionVOList属性值
     */
    public List<PageComponentExpressionVO> getPageComponentExpressionVOList() {
        return pageComponentExpressionVOList;
    }
    
    /**
     * @param pageComponentExpressionVOList 设置 pageComponentExpressionVOList 属性值为参数值 pageComponentExpressionVOList
     */
    public void setPageComponentExpressionVOList(List<PageComponentExpressionVO> pageComponentExpressionVOList) {
        this.pageComponentExpressionVOList = pageComponentExpressionVOList;
    }
    
    /**
     * @return 获取 pageActionVOList属性值
     */
    public List<PageActionVO> getPageActionVOList() {
        return pageActionVOList;
    }
    
    /**
     * @param pageActionVOList 设置 pageActionVOList 属性值为参数值 pageActionVOList
     */
    public void setPageActionVOList(List<PageActionVO> pageActionVOList) {
        this.pageActionVOList = pageActionVOList;
    }
    
}
