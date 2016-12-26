/******************************************************************************
 * Copyright (C) 2015 ShenZhen ComTop Information Technology Co.,Ltd
 * All Rights Reserved.
 * 本软件为深圳康拓普开发研制。未经本公司正式书面同意，其他任何个人、团体不得使用、
 * 复制、修改或发布本软件.
 *****************************************************************************/

package com.comtop.cap.document.expression;

import java.io.Serializable;
import java.util.List;
import java.util.Map;

/**
 * 业务对象
 *
 * @author lizhongwen
 * @since jdk1.6
 * @version 2015年11月18日 lizhongwen
 */
public class BizObjectVO implements Serializable {
    
    /** 序列化ID */
    private static final long serialVersionUID = 1L;
    
    /** 根据关系RelData生成业务对象数据项集合,由CIP自动创建。 */
    private List<BizDataItemVO> dataItems;
    
    /** 主键 */
    private String id;
    
    /** 业务域ID */
    private String domainId;
    
    /** 序号 */
    private Integer sortNo;
    
    /** 编码 */
    private String code;
    
    /** 名称 */
    private String name;
    
    /** map */
    private Map<String, String> map;
    
    /**
     * @return 获取 dataItems属性值
     */
    public List<BizDataItemVO> getDataItems() {
        return dataItems;
    }
    
    /**
     * @param dataItems 设置 dataItems 属性值为参数值 dataItems
     */
    public void setDataItems(List<BizDataItemVO> dataItems) {
        this.dataItems = dataItems;
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
     * @return 获取 业务域ID属性值
     */
    
    public String getDomainId() {
        return domainId;
    }
    
    /**
     * @param domainId 设置 业务域ID属性值为参数值 domainId
     */
    
    public void setDomainId(String domainId) {
        this.domainId = domainId;
    }
    
    /**
     * @return 获取 序号属性值
     */
    
    public Integer getSortNo() {
        return sortNo;
    }
    
    /**
     * @param sortNo 设置 序号属性值为参数值 sortNo
     */
    
    public void setSortNo(Integer sortNo) {
        this.sortNo = sortNo;
    }
    
    /**
     * @return 获取 编码属性值
     */
    
    public String getCode() {
        return code;
    }
    
    /**
     * @param code 设置 编码属性值为参数值 code
     */
    
    public void setCode(String code) {
        this.code = code;
    }
    
    /**
     * @return 获取 名称属性值
     */
    
    public String getName() {
        return name;
    }
    
    /**
     * @param name 设置 名称属性值为参数值 name
     */
    
    public void setName(String name) {
        this.name = name;
    }
    
    /**
     * @return 获取 map属性值
     */
    public Map<String, String> getMap() {
        return map;
    }
    
    /**
     * @param map 设置 map 属性值为参数值 map
     */
    public void setMap(Map<String, String> map) {
        this.map = map;
    }
    
    /**
     * @see java.lang.Object#toString()
     */
    @Override
    public String toString() {
        return "BizObjectVO [id=" + id + ", domainId=" + domainId + ", sortNo=" + sortNo + ", code=" + code + ", name="
            + name + ", map=" + map + "] \n";
    }
    
}
