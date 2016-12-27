/******************************************************************************
 * Copyright (C) 2015 ShenZhen ComTop Information Technology Co.,Ltd
 * All Rights Reserved.
 * 本软件为深圳康拓普开发研制。未经本公司正式书面同意，其他任何个人、团体不得使用、
 * 复制、修改或发布本软件.
 *****************************************************************************/

package com.comtop.cap.bm.metadata.entity.model;

/**
 * 查询规则
 * 
 * @author 李忠文
 * @since 1.0
 * @version 2015-6-3 李忠文
 */
public class QueryRule {
    
    /**
     * 构造函数
     */
    private QueryRule() {
        
    }
    
    /** = */
    public static final int EQ = 1;
    
    /** %F% */
    public static final int F_LIKE = 2;
    
    /** F% */
    public static final int R_LIKE = 3;
    
    /** %F */
    public static final int L_LIKE = 4;
    
    /** in */
    public static final int IN = 5;
    
    /** != */
    public static final int NEQ = 6;
    
    /** > */
    public static final int GT = 7;
    
    /** >= */
    public static final int GE = 8;
    
    /** < */
    public static final int LT = 9;
    
    /** <= */
    public static final int LE = 10;
    
    /** range */
    public static final int RANGE = 11;
    
    /**
     * 获取规则表达式模板
     * 
     * 
     * @param rule 规则
     * @return 表达式模板
     */
    public static String getRuleTemplate(int rule) {
        String strTemplate;
        switch (rule) {
            case EQ:
                strTemplate = "T1.${coll} = ${'#'}{${attr}}";
                break;
            case F_LIKE:
                strTemplate = "T1.${coll} LIKE '%${'$'}{${attr}}%'";
                break;
            case L_LIKE:
                strTemplate = "T1.${coll} LIKE '%${'$'}{${attr}}'";
                break;
            case R_LIKE:
                strTemplate = "T1.${coll} LIKE '${'$'}{${attr}}%'";
                break;
            case IN:
                strTemplate = "T1.${coll} IN ${'#'}{${attr}List}";
                break;
            case NEQ:
                strTemplate = "T1.${coll} != ${'#'}{${attr}}";
                break;
            case GT:
                strTemplate = "T1.${coll} > ${'#'}{${attr}}";
                break;
            case GE:
                strTemplate = "T1.${coll} >= ${'#'}{${attr}}";
                break;
            case LT:
                strTemplate = "T1.${coll} < ${'#'}{${attr}}";
                break;
            case LE:
                strTemplate = "T1.${coll} <= ${'#'}{${attr}}";
                break;
            case RANGE:
                strTemplate = "T1.${coll} >= ${'#'}{start${attr?cap_first}} AND T1.${coll} <= ${'#'}{end${attr?cap_first}}";
                break;
            default:
                strTemplate = null;
                break;
        }
        return strTemplate;
    }
}
