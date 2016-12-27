/******************************************************************************
 * Copyright (C) 2014 ShenZhen ComTop Information Technology Co.,Ltd
 * All Rights Reserved.
 * 本软件为深圳康拓普开发研制。未经本公司正式书面同意，其他任何个人、团体不得使用、
 * 复制、修改或发布本软件.
 *****************************************************************************/

package com.comtop.cap.bm.metadata.base.model;

/**
 * 树节点接口
 * 
 * 
 * @author 李忠文
 * @since 1.0
 * @version 2014-4-3 李忠文
 */
public interface IMetaNode {
    
    /**
     * 获取节点Id
     * 
     * @return 节点Id
     */
    String getNodeId();
    
    /**
     * 获取 中文名称
     * 
     * @return 中文名称
     */
    String getChineseName();
    
    /**
     * 获取 英文名称
     * 
     * @return 英文名称
     */
    String getEnglishName();
    
    /**
     * 描述
     * 
     * @return 描述
     */
    String getDescription();
    
    /**
     * 获取 节点类型
     * 
     * @return 节点类型
     */
    String getNodeType();
    
    /**
     * 获取表名称
     * 
     * @return 表名称
     */
    String getTableName();
}
