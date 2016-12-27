/******************************************************************************
 * Copyright (C) 2014 ShenZhen ComTop Information Technology Co.,Ltd
 * All Rights Reserved.
 * 本软件为深圳康拓普开发研制。未经本公司正式书面同意，其他任何个人、团体不得使用、
 * 复制、修改或发布本软件.
 *****************************************************************************/

package com.comtop.cap.bm.metadata.pkg.model;

/**
 * 项目类型
 * 
 * @author 李忠文
 * @since 1.0
 * @version 2014-5-22 李忠文
 */
public final class ProjectType {
    
    /**
     * 构造函数
     */
    private ProjectType() {
        super();
    }
    
    /** Web工程 */
    public static final int WEB_PROJECT = 0;
    
    /** 引用工程 */
    public static final int APP_PROJECT = 1;
    
    /** POM工程 */
    public static final int POM_PROJECT = 2;
}
