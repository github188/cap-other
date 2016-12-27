/******************************************************************************
 * Copyright (C) 2015 ShenZhen ComTop Information Technology Co.,Ltd
 * All Rights Reserved.
 * 本软件为深圳康拓普开发研制。未经本公司正式书面同意，其他任何个人、团体不得使用、
 * 复制、修改或发布本软件.
 *****************************************************************************/

package com.comtop.cap.bm.metadata.page.desinger.model;

import java.util.ArrayList;
import java.util.List;

import javax.xml.bind.annotation.XmlRootElement;

import com.comtop.cap.bm.metadata.base.consistency.annotation.BaseModelConsistency;
import com.comtop.cap.bm.metadata.base.consistency.annotation.ConsistencyDependOnField;
import com.comtop.cap.bm.metadata.base.model.BmBizBaseModel;
import com.comtop.cap.bm.metadata.page.PageUtil;
import com.comtop.cap.bm.metadata.page.preference.model.IncludeFileVO;
import comtop.org.directwebremoting.annotations.DataTransferObject;

/**
 * 页面模型
 * 
 * @author 诸焕辉
 * @version jdk1.6
 * @version 2015-4-28 诸焕辉
 */
@XmlRootElement(name = "page")
@DataTransferObject
@BaseModelConsistency
public class PageVO extends BmBizBaseModel {
    
    /** 标识 */
    private static final long serialVersionUID = 6567820238692410499L;
    
    /** 页面资源编号 */
    private String code;
    
    /** 页面中文名/页面标题 */
    private String cname;
    
    /** 字符集编码 */
    private String charEncode = "UTF-8";
    
    /** 是否是菜单 */
    private boolean hasMenu = false;
    
    /** 是否需要授权 */
    private boolean hasPermission = false;
    
    /** 访问URL */
    private String url;
    
    /** 上级目录ID */
    private String parentId;
    
    /** 上级目录名称 */
    private String parentName;
    
    /** 菜单分类 */
    private String menuType;
    
    /** 菜单名称 */
    private String menuName;
    
    /** 录入页面类型，1为录入的模板，2为录入的自定义页面，默认为1 */
    private int pageType = 1;
    
    /**
     * TOP页面ID
     */
    private String pageId;
    
    /** 描述 */
    private String description;
    
    /** 页面设计最小分辨率 */
    private String minWidth = "1024px";
    
    /** 页面设计最小宽度 */
    private String pageMinWidth = "600px";
    
    /** 引入JSP、CSS、JS文件 */
    private List<IncludeFileVO> includeFileList = new ArrayList<IncludeFileVO>();
    
    /** 布局 */
    @ConsistencyDependOnField
    private LayoutVO layoutVO = new LayoutVO();
    
    /** 页面数据集 */
    @ConsistencyDependOnField
    private List<DataStoreVO> dataStoreVOList = new ArrayList<DataStoreVO>();
    
    /** 页面控件状态表达式集合 */
    @ConsistencyDependOnField
    private List<PageComponentExpressionVO> pageComponentExpressionVOList = new ArrayList<PageComponentExpressionVO>();
    
    /** 页面行为集合 */
    @ConsistencyDependOnField
    private List<PageActionVO> pageActionVOList = new ArrayList<PageActionVO>();
    
    /** 页面数据模型集合 */
    private List<PageAttributeVO> pageAttributeVOList = new ArrayList<PageAttributeVO>();
    
    /**
     * 模型包对应的数据Id 系统模块现在存储在数据库中，模块的dbId暂时冗余在pageVO中，
     */
    private String modelPackageId;
    
    /** 界面原型名称 */
    private String crudeUINames;
    
    /** 界面原型Id */
    private String crudeUIIds;
    
    /** 文件存储状态 false：表示暂存，不能用于生成代码 true：表示可以用于生成代码 */
    private boolean state = Boolean.TRUE;

    /** 界面分类-pageUIType **/ 
    private String pageUIType;
    
    /**
     * @return 获取 pageUIType属性值
     */
    public String getPageUIType() {
        return pageUIType;
    }

    
    /**
     * @param pageUIType 设置 pageUIType 属性值为参数值 pageUIType
     */
    public void setPageUIType(String pageUIType) {
        this.pageUIType = pageUIType;
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
     * @return the modelPackageId
     */
    public String getModelPackageId() {
        return modelPackageId;
    }
    
    /**
     * @param modelPackageId the modelPackageId to set
     */
    public void setModelPackageId(String modelPackageId) {
        this.modelPackageId = modelPackageId;
    }
    
    /**
     * 构造函数
     */
    public PageVO() {
        this.setModelType("page");
    }
    
    /**
     * @return 获取 code属性值
     */
    public String getCode() {
        return code;
    }
    
    /**
     * @param code 设置 code 属性值为参数值 code
     */
    public void setCode(String code) {
        this.code = code;
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
     * @return the hasMenu
     */
    public boolean isHasMenu() {
        return hasMenu;
    }
    
    /**
     * @param hasMenu the hasMenu to set
     */
    public void setHasMenu(boolean hasMenu) {
        this.hasMenu = hasMenu;
    }
    
    /**
     * @return the hasPermission
     */
    public boolean isHasPermission() {
        return hasPermission;
    }
    
    /**
     * @param hasPermission the hasPermission to set
     */
    public void setHasPermission(boolean hasPermission) {
        this.hasPermission = hasPermission;
    }
    
    /*
    *//**
     * @return 获取 url属性值
     */
    public String getUrl() {
    	if(pageType == 2){
    		return this.url;
    	}
    	String strPack = this.getModelPackage();
    	String strName = this.getModelName();
    	strPack = strPack == null?"":strPack;
    	strName = strName == null?"":strName;
        return PageUtil.getPageURL(strPack, strName);
    }
    
    /**
     * @param url 设置 url 属性值为参数值 url
     */
    public void setUrl(String url) {
    	this.url = url;
    }
    
    /**
     * @return 获取 parentId属性值
     */
    public String getParentId() {
        return parentId;
    }
    
    /**
     * @param parentId 设置 parentId 属性值为参数值 parentId
     */
    public void setParentId(String parentId) {
        this.parentId = parentId;
    }
    
    /**
     * @return 获取 parentName属性值
     */
    public String getParentName() {
        return parentName;
    }
    
    /**
     * @param parentName 设置 parentName 属性值为参数值 parentName
     */
    public void setParentName(String parentName) {
        this.parentName = parentName;
    }
    
    /**
     * @return 获取 menuType属性值
     */
    public String getMenuType() {
        return menuType;
    }
    
    /**
     * @param menuType 设置 menuType 属性值为参数值 menuType
     */
    public void setMenuType(String menuType) {
        this.menuType = menuType;
    }
    
    /**
     * @return 获取 menuName属性值
     */
    public String getMenuName() {
        return menuName;
    }
    
    /**
     * @param menuName 设置 menuName 属性值为参数值 menuName
     */
    public void setMenuName(String menuName) {
        this.menuName = menuName;
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
    
    /**
     * @return 获取 serialversionuid属性值
     */
    public static long getSerialversionuid() {
        return serialVersionUID;
    }
    
    /**
     * @return the pageAttributeVOList
     */
    public List<PageAttributeVO> getPageAttributeVOList() {
        return pageAttributeVOList;
    }
    
    /**
     * @param pageAttributeVOList the pageAttributeVOList to set
     */
    public void setPageAttributeVOList(List<PageAttributeVO> pageAttributeVOList) {
        this.pageAttributeVOList = pageAttributeVOList;
    }
    
    /**
     * @return the pageId
     */
    public String getPageId() {
        return pageId;
    }
    
    /**
     * @param pageId the pageId to set
     */
    public void setPageId(String pageId) {
        this.pageId = pageId;
    }
    
    /**
     * @return the minWidth
     */
    public String getMinWidth() {
        return minWidth;
    }
    
    /**
     * @param minWidth the minWidth to set
     */
    public void setMinWidth(String minWidth) {
        this.minWidth = minWidth;
    }
    
    /**
     * @return 获取 pageType属性值
     */
    public int getPageType() {
        return pageType;
    }
    
    /**
     * @param pageType 设置 pageType 属性值为参数值 pageType
     */
    public void setPageType(int pageType) {
        this.pageType = pageType;
    }
    
    /**
     * @return 获取 crudeUIIds属性值
     */
    public String getCrudeUIIds() {
        return crudeUIIds;
    }
    
    /**
     * @param crudeUIIds 设置 crudeUIIds 属性值为参数值 crudeUIIds
     */
    public void setCrudeUIIds(String crudeUIIds) {
        this.crudeUIIds = crudeUIIds;
    }
    
    /**
     * @return 获取 crudeUINames属性值
     */
    public String getCrudeUINames() {
        return crudeUINames;
    }
    
    /**
     * @param crudeUINames 设置 crudeUINames 属性值为参数值 crudeUINames
     */
    public void setCrudeUINames(String crudeUINames) {
        this.crudeUINames = crudeUINames;
    }
    
    /**
     * @return 获取 state属性值
     */
    public boolean isState() {
        return state;
    }
    
    /**
     * @param state 设置 state 属性值为参数值 state
     */
    public void setState(boolean state) {
        this.state = state;
    }
}
