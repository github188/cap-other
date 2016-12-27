/******************************************************************************
 * Copyright (C) 2014 ShenZhen ComTop Information Technology Co.,Ltd
 * All Rights Reserved.
 * 本软件为深圳康拓普开发研制。未经本公司正式书面同意，其他任何个人、团体不得使用、
 * 复制、修改或发布本软件.
 *****************************************************************************/

package com.comtop.cap.bm.metadata.common.model;

/**
 * 节点状态
 * 
 * 
 * @author 李忠文
 * @since 1.0
 * @version 2014-4-29 李忠文
 */
public final class NodeStatus {
    
    /**
     * 构造函数
     */
    private NodeStatus() {
        super();
    }
    
    /** 修改 */
    public static final int MODIFY = 0;
    
    /** 稳定 */
    public static final int STABLE = 1;
    
    /** 已提交 */
    public static final int COMMITED = 2;
    
}
