/******************************************************************************
* Copyright (C) 2016 ShenZhen ComTop Information Technology Co.,Ltd
* All Rights Reserved.
* 本软件为深圳康拓普开发研制。未经本公司正式书面同意，其他任何个人、团体不得使用、
* 复制、修改或发布本软件.
*****************************************************************************/

package com.comtop.cap.bm.metadata.page.desinger.model;

/**
 * 界面分类枚举类
 *
 *
 * @author  肖威
 * @since   jdk1.6
 * @version 2016年8月4日 肖威
 */
public enum PageUITypeEnum {
    /**框架界面 **/
    FRAME_PAGE("framePage"),
    /**列表查询界面 **/
    LIST_PAGE("listPage"),
     /**编辑界面 **/
    EIDT_PAGE ("eidtPage"),
    /**待上报列表查询界面：**/
    TO_ENTRY_LIST_PAGE("toEntryListPage"),
    /**已上报列表查询界面**/
    ENTRYED_LIST_PAGE("entryEdListPage"),
    /**待办列表查询界面**/
    TODO_LIST_PAGE("todoListPage"),
    /**已办列表查询界面**/
    DONE_LIST_PAGE("doneListPage"),
     /**展现界面 **/
    VIEW_PAGE("viewPage");
    
    /** 配置文件的名称 */
    private String pageUIType;
    
    /**
     * 构造函数
     * 
     * @param pageUIType 配置文件的名称
     */
    private PageUITypeEnum(String pageUIType) {
        this.pageUIType = pageUIType;
    }
    
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
    
}
