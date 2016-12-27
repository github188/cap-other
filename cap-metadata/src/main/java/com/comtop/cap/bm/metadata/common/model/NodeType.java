/******************************************************************************
 * Copyright (C) 2014 ShenZhen ComTop Information Technology Co.,Ltd
 * All Rights Reserved.
 * 本软件为深圳康拓普开发研制。未经本公司正式书面同意，其他任何个人、团体不得使用、
 * 复制、修改或发布本软件.
 *****************************************************************************/

package com.comtop.cap.bm.metadata.common.model;

/**
 * 节点类型
 * 
 * 
 * @author 李忠文
 * @since 1.0
 * @version 2014-4-2 李忠文
 */
public final class NodeType {
    
    /**
     * 构造函数
     */
    private NodeType() {
        super();
    }
    
    /** 项目 */
    public static final String PROJECT_NODE = "project";
    
    /** 包 */
    public static final String PKG_NODE = "package";
    
    /** 模块 */
    public static final String MODULE_NODE = "module";
    
    /** 模型 */
    public static final String UML_NODE = "uml";
    
    /** 实体 */
    public static final String ENTITY_NODE = "entity";
    
    /** 关系 */
    public static final String REL_NODE = "relation";
    
    /** 值对象 */
    public static final String VO_NODE = "vo";
    
    /** 数据表 */
    public static final String TABLE_NODE = "table";
    
    /** 查询 */
    public static final String QUERY_NODE = "query";
    
    /** 目录 */
    public static final String DIR_NODE = "directory";
}
