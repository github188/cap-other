/******************************************************************************
 * Copyright (C) 2015 ShenZhen ComTop Information Technology Co.,Ltd
 * All Rights Reserved.
 * 本软件为深圳康拓普开发研制。未经本公司正式书面同意，其他任何个人、团体不得使用、
 * 复制、修改或发布本软件.
 *****************************************************************************/

package com.comtop.cap.bm.biz.flow.model;

import javax.persistence.Column;
import javax.persistence.Id;
import javax.persistence.Table;

import com.comtop.top.core.base.model.CoreVO;
import comtop.org.directwebremoting.annotations.DataTransferObject;

/**
 * 业务关联数据项
 * 
 * @author CAP
 * @since 1.0
 * @version 2015-11-17 CAP
 */
@DataTransferObject
@Table(name = "CAP_BIZ_REL_DATA")
public class BizRelDataVO extends CoreVO {
    
    /** 序列化ID */
    private static final long serialVersionUID = 1L;
    
    /** 主键 */
    @Id
    @Column(name = "ID", length = 40)
    private String id;
    
    /** 业务关联ID */
    @Column(name = "REL_INFO_ID", length = 40)
    private String relInfoId;
    
    /** 业务对象ID */
    @Column(name = "OBJ_ID", length = 40)
    private String objId;
    
    /** 数据项ID */
    @Column(name = "ITEM_ID", length = 40)
    private String itemId;
    
    /** 备注 */
    @Column(name = "REMARK", length = 2000)
    private String remark;
    
    /** 业务对象名称 */
    private String bizObjName;
    
    /** 数据项名称 */
    private String itemName;
    
    /** 业务引用说明 */
    private String itemCodeNote;
    
    /** 序号 */
    @Column(name = "SORT_NO", precision = 10)
    private Integer sortNo;
    
    /**
     * @return 获取 sortNo属性值
     */
    public Integer getSortNo() {
        return sortNo;
    }
    
    /**
     * @param sortNo 设置 sortNo 属性值为参数值 sortNo
     */
    public void setSortNo(Integer sortNo) {
        this.sortNo = sortNo;
    }
    
    /**
     * @return 获取 主键属性值
     */
    
    public String getId() {
        return id;
    }
    
    /**
     * @param id 设置 主键属性值为参数值 id
     */
    
    public void setId(String id) {
        this.id = id;
    }
    
    /**
     * @return 获取 业务关联ID属性值
     */
    
    public String getRelInfoId() {
        return relInfoId;
    }
    
    /**
     * @param relInfoId 设置 业务关联ID属性值为参数值 relInfoId
     */
    
    public void setRelInfoId(String relInfoId) {
        this.relInfoId = relInfoId;
    }
    
    /**
     * @return 获取 业务对象ID属性值
     */
    
    public String getObjId() {
        return objId;
    }
    
    /**
     * @param objId 设置 业务对象ID属性值为参数值 objId
     */
    
    public void setObjId(String objId) {
        this.objId = objId;
    }
    
    /**
     * @return 获取 数据项ID属性值
     */
    
    public String getItemId() {
        return itemId;
    }
    
    /**
     * @param itemId 设置 数据项ID属性值为参数值 itemId
     */
    
    public void setItemId(String itemId) {
        this.itemId = itemId;
    }
    
    /**
     * @return 获取 备注属性值
     */
    
    public String getRemark() {
        return remark;
    }
    
    /**
     * @param remark 设置 备注属性值为参数值 remark
     */
    
    public void setRemark(String remark) {
        this.remark = remark;
    }
    
    /**
     * 
     * 获取业务对象名称
     * 
     * @return 业务对象名称
     */
    public String getBizObjName() {
        return bizObjName;
    }
    
    /**
     * 设置业务对象名称
     * 
     * @param bizObjName 业务对象名称
     */
    public void setBizObjName(String bizObjName) {
        this.bizObjName = bizObjName;
    }
    
    /**
     * 获取数据项名称
     * 
     * @return 数据项名称
     */
    public String getItemName() {
        return itemName;
    }
    
    /**
     * 设置数据项名称
     * 
     * @param itemName 数据项名称
     */
    public void setItemName(String itemName) {
        this.itemName = itemName;
    }
    
    /**
     * 获取业务引用说明
     * 
     * @return 业务引用说明
     */
    public String getItemCodeNote() {
        return itemCodeNote;
    }
    
    /**
     * 设置业务引用说明
     * 
     * @param itemCodeNote 业务引用说明
     */
    public void setItemCodeNote(String itemCodeNote) {
        this.itemCodeNote = itemCodeNote;
    }
    
}
