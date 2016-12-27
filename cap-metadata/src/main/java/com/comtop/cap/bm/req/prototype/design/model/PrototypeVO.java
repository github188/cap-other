/******************************************************************************
 * Copyright (C) 2015 ShenZhen ComTop Information Technology Co.,Ltd
 * All Rights Reserved.
 * 本软件为深圳康拓普开发研制。未经本公司正式书面同意，其他任何个人、团体不得使用、
 * 复制、修改或发布本软件.
 *****************************************************************************/

package com.comtop.cap.bm.req.prototype.design.model;

import java.util.ArrayList;
import java.util.List;

import javax.xml.bind.annotation.XmlRootElement;

import com.comtop.cap.bm.metadata.base.model.BaseModel;
import com.comtop.cap.bm.metadata.page.desinger.model.LayoutVO;
import com.comtop.cap.bm.metadata.page.desinger.model.PageActionVO;
import com.comtop.cap.bm.metadata.page.desinger.model.PageAttributeVO;
import com.comtop.cap.bm.metadata.page.preference.model.IncludeFileVO;
import comtop.org.directwebremoting.annotations.DataTransferObject;

/**
 * 界面原型模型
 * 
 * @author 诸焕辉
 * @version jdk1.6
 * @version 2016-12-25 诸焕辉
 */
@XmlRootElement(name = "prototype")
@DataTransferObject
public class PrototypeVO extends BaseModel {
    
    /** 标识 */
    private static final long serialVersionUID = 6567820238692410459L;
    
    /** 页面中文名/页面标题 */
    private String cname;
    
    /** 字符集编码 */
    private String charEncode = "UTF-8";
    
    /** 描述 */
    private String description;
    
    /** 页面设计最小分辨率 */
    private String minWidth = "1024px";
    
    /** 页面设计最小宽度 */
    private String pageMinWidth = "600px";
    
    /** 布局 */
    private LayoutVO layoutVO = new LayoutVO();
    
    /** 引入CSS、JS文件 */
    private List<IncludeFileVO> includeFileList = new ArrayList<IncludeFileVO>();
    
    /** 页面行为集合 */
    private List<PageActionVO> pageActionVOList = new ArrayList<PageActionVO>();
    
    /** 页面数据模型集合 */
    private List<PageAttributeVO> pageAttributeVOList = new ArrayList<PageAttributeVO>();
    
    /** 访问URL */
    private String url;
    
    /** 界面原型在列表中的序号 */
    private int sortNo;
    
    /** 界面原型图片的请求路径 **/
    private String imageURL;
    
    /** 界面原型类型：0-设计器的设计的原型、1-手动上传图片的原型 */
    private int type;
    
    /** 功能子项Id */
    private String functionSubitemId;
    
    /**
     * @return 获取 imageURL属性值
     */
    public String getImageURL() {
        return imageURL;
    }
    
    /**
     * @param imageURL 设置 imageURL 属性值为参数值 imageURL
     */
    public void setImageURL(String imageURL) {
        this.imageURL = imageURL;
    }
    
    /**
     * @return 获取 type属性值
     */
    public int getType() {
        return type;
    }
    
    /**
     * @param type 设置 type 属性值为参数值 type
     */
    public void setType(int type) {
        this.type = type;
    }
    
    /**
     * @return 获取 sortNo属性值
     */
    public int getSortNo() {
        return sortNo;
    }
    
    /**
     * @param sortNo 设置 sortNo 属性值为参数值 sortNo
     */
    public void setSortNo(int sortNo) {
        this.sortNo = sortNo;
    }
    
    /**
     * @return 获取 url属性值
     */
    public String getUrl() {
        return url;
    }
    
    /**
     * @param url 设置 url 属性值为参数值 url
     */
    public void setUrl(String url) {
        this.url = url;
    }
    
    /**
     * 构造函数
     */
    public PrototypeVO() {
        this.setModelType("prototype");
    }
    
    /**
     * @return 获取 pageMinWidth属性值
     */
    public String getPageMinWidth() {
        return pageMinWidth;
    }
    
    /**
     * @param pageMinWidth 设置 pageMinWidth 属性值为参数值 pageMinWidth
     */
    public void setPageMinWidth(String pageMinWidth) {
        this.pageMinWidth = pageMinWidth;
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
     * @return 获取 charEncode属性值
     */
    public String getCharEncode() {
        return charEncode;
    }
    
    /**
     * @param charEncode 设置 charEncode 属性值为参数值 charEncode
     */
    public void setCharEncode(String charEncode) {
        this.charEncode = charEncode;
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
     * @return 获取 includeFileList属性值
     */
    public List<IncludeFileVO> getIncludeFileList() {
        return includeFileList;
    }
    
    /**
     * @param includeFileList 设置 includeFileList 属性值为参数值 includeFileList
     */
    public void setIncludeFileList(List<IncludeFileVO> includeFileList) {
        this.includeFileList = includeFileList;
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
    
    /**
     * @return 获取 pageAttributeVOList属性值
     */
    public List<PageAttributeVO> getPageAttributeVOList() {
        return pageAttributeVOList;
    }
    
    /**
     * @param pageAttributeVOList 设置 pageAttributeVOList 属性值为参数值 pageAttributeVOList
     */
    public void setPageAttributeVOList(List<PageAttributeVO> pageAttributeVOList) {
        this.pageAttributeVOList = pageAttributeVOList;
    }
    
    /**
     * @return 获取 minWidth属性值
     */
    public String getMinWidth() {
        return minWidth;
    }
    
    /**
     * @param minWidth 设置 minWidth 属性值为参数值 minWidth
     */
    public void setMinWidth(String minWidth) {
        this.minWidth = minWidth;
    }

    /**
     * @return 获取 functionSubitemId属性值
     */
    public String getFunctionSubitemId() {
        return functionSubitemId;
    }

    /**
     * @param functionSubitemId 设置 functionSubitemId 属性值为参数值 functionSubitemId
     */
    public void setFunctionSubitemId(String functionSubitemId) {
        this.functionSubitemId = functionSubitemId;
    }
}
