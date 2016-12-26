/******************************************************************************
 * Copyright (C) 2015 ShenZhen ComTop Information Technology Co.,Ltd
 * All Rights Reserved.
 * 本软件为深圳康拓普开发研制。未经本公司正式书面同意，其他任何个人、团体不得使用、
 * 复制、修改或发布本软件.
 *****************************************************************************/

package com.comtop.cip.graph.image;

import java.io.File;

import com.comtop.cip.graph.image.utils.GraphToImageUtil;

/**
 * 常量类
 * 
 * @author duqi
 * 
 */
public class GraphToImageConstants {
    
    /** 执行jar包的名称 */
    public static String EXECUTE_JAR_NAME = "comtop-cap-graph-to-image.jar";
    
    /** 图形目录 */
    public static String GRAPH_DIR = GraphToImageUtil.getWebinfPath() + File.separator + "cap" + File.separator + "bm"
        + File.separator + "graph";
    
    /** 图片工具记录日志位置 */
    public static String LOG_DIR = GRAPH_DIR;
    
    /** 临时图片存储位置 */
    public static String TMP_IMAGE_DIR = GRAPH_DIR + File.separator + "tmp";
    
    /** 模块关系图基本URL */
    public static String MODULE_RELA_GRAPH_BASEURL = "/cap/bm/graph/ModuleRelationGraph.jsp";
    
    /** 资源关系图基本URL */
    public static String RESOURCE_RELA_GRAPH_BASEURL = "/cap/bm/graph/ClassRelationGraph.jsp";
    
    /** 逻辑部署图基本URL */
    public static String LOGIC_DEPLOYMENT_BASEURL = "/cap/bm/graph/editor/Editor.jsp?diagramType=logic";
    
    /** 物理部署图基本URL */
    public static String PHYSIC_DEPLOYMENT_BASEURL = "/cap/bm/graph/editor/Editor.jsp?diagramType=physic";
    
    /** ER图基本URL */
    public static String ER_GRAPH_BASEURL = "/cap/bm/graph/ERGraph.jsp";
    
    /** ER图基本URL */
    public static String MODULE_STRUCTURE_GRAPH_BASEURL = "/cap/bm/graph/ModuleStructGraph.jsp";
    
}
