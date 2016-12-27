/******************************************************************************
 * Copyright (C) 2015 ShenZhen ComTop Information Technology Co.,Ltd
 * All Rights Reserved.
 * 本软件为深圳康拓普开发研制。未经本公司正式书面同意，其他任何个人、团体不得使用、
 * 复制、修改或发布本软件.
 *****************************************************************************/

package com.comtop.cap.doc.content.util;

/**
 * 文档编辑常量类
 *
 * @author 李小芬
 * @since 1.0
 * @version 2015年12月9日 李小芬
 */
public final class CapDocContentConstant {
    
    /**
     * 构造函数
     */
    private CapDocContentConstant() {
        // 构造函数
    }
    
    /** 树根节点父ID */
    public final static String TREE_ROOT_PARENT_ID = "-1";
    
    /** 树根节点URI */
    public final static String TREE_ROOT_URI = "TreeUri";
    
    /** 容器类型-章节 */
    public final static String DOC_CONTAINER_TYPE_CHAPTER = "Chapter";
    
    /** URI连接符 */
    public final static String URI_CONNECTOR = "/";
    
    /** 章节编号连接符 */
    public final static String WORD_NUMBER_CONNECTOR = ".";
    
    /** xml变量标识 */
    public final static String VARIABLE_FLAG = "[]";
    
    /** xml的ID表达式 */
    public final static String ID_EXP_CONNECTOR = ".id";
    
    /** 代理类 */
    public final static String PROXETTA_FLAG = "$$Proxetta";
    
    /** 系统自动增加的mappingTo字符串识别码 */
    public final static String MAPPINGTO_CONTENTSEG = "ContentSeg";
    
}
