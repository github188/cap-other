/******************************************************************************
 * Copyright (C) 2014 ShenZhen ComTop Information Technology Co.,Ltd
 * All Rights Reserved.
 * 本软件为深圳康拓普开发研制。未经本公司正式书面同意，其他任何个人、团体不得使用、
 * 复制、修改或发布本软件.
 *****************************************************************************/

package com.comtop.cap.bm.metadata.base.model;

/**
 * 元数据常量类
 * 
 * 
 * @author 李忠文
 * @since 1.0
 * @version 2014-3-26 李忠文
 */
public final class MetaDataConstant {
    
    /**
     * 构造函数
     */
    private MetaDataConstant() {
        super();
    }
    
    /**
     * 默认ID长度
     */
    public final static int DEFAULT_ID_LENGHT = 32;
    
    /**
     * 默认精度长度
     */
    public final static int DEFAULT_PRECISION = 0;
    
    /**
     * 最大精度长度
     */
    public final static int MAX_PRECISION = 36;
    
    /**
     * 关联关系处理方式:-1 表示忽略此端，不做处理
     */
    public final static int RELATION_PROCESS_MODE_IGNORE = -1;
    
    /**
     * 关联关系处理方式:0 表示当前实体所对应的表应该包含目标实体的Id
     */
    public final static int RELATION_PROCESS_MODE_TAEGETID = 0;
    
    /**
     * 关联关系处理方式:1 表示为多对多关系，需要生成中间表
     */
    public final static int RELATION_PROCESS_MODE_MIDTABLE = 1;
    
    /**
     * 关联关系处理方式:2 表示当前实体所对应的表应该包含源实体的Id
     */
    public final static int RELATION_PROCESS_MODE_SOURCEID = 2;
    
}
