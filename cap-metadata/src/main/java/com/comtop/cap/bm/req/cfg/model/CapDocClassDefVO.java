/******************************************************************************
 * Copyright (C) 2015 ShenZhen ComTop Information Technology Co.,Ltd
 * All Rights Reserved.
 * 本软件为深圳康拓普开发研制。未经本公司正式书面同意，其他任何个人、团体不得使用、
 * 复制、修改或发布本软件.
 *****************************************************************************/

package com.comtop.cap.bm.req.cfg.model;

import javax.persistence.Column;
import javax.persistence.Id;
import javax.persistence.Table;

import com.comtop.top.core.base.model.CoreVO;
import comtop.org.directwebremoting.annotations.DataTransferObject;

/**
 * 需求对象信息表(系统初始数据，不允许修改)
 * 
 * @author 姜子豪
 * @since 1.0
 * @version 2015-9-11 姜子豪
 */
@DataTransferObject
@Table(name = "Cap_Doc_Class_Def")
public class CapDocClassDefVO extends CoreVO {
    
    /** 序列化ID */
    private static final long serialVersionUID = 1L;
    
    /** 流水号 */
    @Id
    @Column(name = "ID", length = 40)
    private String id;
    
    /** 需求对象类型的类型编号（SYS.项目;SUBSYS.子项目,DIR.目录,MODEL.模块,PAGE.界面,SERVICE.服务,PROCESS 流程,ENTITY.实体,） */
    @Column(name = "NAME", length = 10)
    private String name;
    
    /** 中文名称 */
    @Column(name = "CN_NAME", length = 100)
    private String CnName;
    
    /** 描述 */
    @Column(name = "REMARK", length = 4000)
    private String remark;
    
    /** 存储表名 */
    @Column(name = "TABLE_NAME", length = 30)
    private String TableName;
       
    /**
     * @return 获取 id属性值
     */
    public String getId() {
        return id;
    }
    
    /**
     * @param id 设置 id 属性值为参数值 id
     */
    public void setId(String id) {
        this.id = id;
    }
    
    /**
     * @return 获取 name属性值
     */
    public String getName() {
        return name;
    }
    
    /**
     * @param name 设置 name 属性值为参数值 name
     */
    public void setName(String name) {
        this.name = name;
    }
    
    /**
     * @return 获取 cnName属性值
     */
    public String getCnName() {
        return CnName;
    }
    
    /**
     * @param cnName 设置 cnName 属性值为参数值 cnName
     */
    public void setCnName(String cnName) {
        CnName = cnName;
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
    
    /**
     * @return 获取 tableName属性值
     */
    public String getTableName() {
        return TableName;
    }
    
    /**
     * @param tableName 设置 tableName 属性值为参数值 tableName
     */
    public void setTableName(String tableName) {
        TableName = tableName;
    }

	@Override
	public String toString() {
		return "CapDocClassDefVO [id=" + id + ", name=" + name + ", CnName="
				+ CnName + ", remark=" + remark + ", TableName=" + TableName
				+ "]";
	}
 
}
