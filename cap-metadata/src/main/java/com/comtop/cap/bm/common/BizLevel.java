/******************************************************************************
 * Copyright (C) 2016 ShenZhen ComTop Information Technology Co.,Ltd
 * All Rights Reserved.
 * 本软件为深圳康拓普开发研制。未经本公司正式书面同意，其他任何个人、团体不得使用、
 * 复制、修改或发布本软件.
 *****************************************************************************/

package com.comtop.cap.bm.common;

import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

/**
 * 业务层级
 *
 * @author lizhiyong
 * @since jdk1.6
 * @version 2016年1月4日 lizhiyong
 */
public enum BizLevel {
    
    /** 公司总部 */
    BIZ_LEVEL_HQ("HQ", "公司总部"),
    /** 分子公司 */
    BIZ_LEVEL_CC("CC", "分子公司"),
    /** 地市单位 */
    BIZ_LEVEL_BU("BU", "地市单位"),
    /** 基层单位 */
    BIZ_LEVEL_LU("LU", "基层单位"),
    /** 网公司 */
    BIZ_LEVEL_CSG("CSG", "网公司"),
    /** 省公司 */
    BIZ_LEVEL_PROVINCE("PROVINCE", "省公司"),
    /** 省公司系统部 */
    BIZ_LEVEL_PROVINCE_SD("PROVINCE_SD", "省公司系统部"),
    /** 地市局 */
    BIZ_LEVEL_BUREAU("BUREAU", "地市局"),
    /** 地市供电局 */
    BIZ_LEVEL_BUREAU_PS("BUREAU", "地市供电局"),
    /** 超高压 */
    BIZ_LEVEL_UHV("UHV", "超高压"),
    /** 能源公司 */
    BIZ_LEVEL_EC("EC", "能源公司"),
    /** 未定义的层级 */
    BIZ_LEVEL_UNKNOWN("UNKNOWN", "未知层级");
    
    /** 字典数据项集 */
    private static List<BizLevel> DIC_1 = new ArrayList<BizLevel>();
    
    /** 字典数据项集 */
    private static List<BizLevel> DIC_2 = new ArrayList<BizLevel>();
    
    /** 字典数据项集 */
    private static List<BizLevel> DIC_3 = new ArrayList<BizLevel>();
    
    /** 字典集 */
    private static Map<String, List<BizLevel>> DICS = new HashMap<String, List<BizLevel>>();
    static {
        DIC_1.add(BIZ_LEVEL_HQ);
        DIC_1.add(BIZ_LEVEL_CC);
        DIC_1.add(BIZ_LEVEL_BU);
        DIC_1.add(BIZ_LEVEL_LU);
        
        DIC_2.add(BIZ_LEVEL_CSG);
        DIC_2.add(BIZ_LEVEL_CC);
        DIC_2.add(BIZ_LEVEL_PROVINCE);
        DIC_2.add(BIZ_LEVEL_BUREAU);
        DIC_2.add(BIZ_LEVEL_LU);
        
        //
        // {ID:'分子公司',TEXT:'分子公司'},
        // {ID:'地市单位',TEXT:'地市单位'},
        // {ID:'基层单位',TEXT:'基层单位'}
        //
        // 网公司 分子公司 省公司 地市局 基层单位
        //
        // 公司总部 超高压 能源公司 省公司 地市单位 基层单位
        DIC_3.add(BIZ_LEVEL_HQ);
        DIC_3.add(BIZ_LEVEL_UHV);
        DIC_3.add(BIZ_LEVEL_EC);
        DIC_3.add(BIZ_LEVEL_PROVINCE);
        DIC_3.add(BIZ_LEVEL_BU);
        DIC_3.add(BIZ_LEVEL_LU);
        
        DICS.put("DIC_1", DIC_1);
        DICS.put("DIC_2", DIC_2);
        DICS.put("DIC_3", DIC_3);
    }
    
    /** 代码 */
    private String code;
    
    /** 中文名称 */
    private String cnName;
    
    /**
     * 构造函数
     * 
     * @param code 代码
     * 
     * @param cnName 中文名称
     */
    private BizLevel(String code, String cnName) {
        this.code = code;
        this.cnName = cnName;
    }
    
    /**
     * @return 获取 cnName属性值
     */
    public String getCnName() {
        return cnName;
    }
    
    /**
     * @return 获取 code属性值
     */
    public String getCode() {
        return code;
    }
    
    /**
     * 根据中文名获得业务层级
     *
     * @param cnName 中文名称
     * @return 业务层级
     */
    public static BizLevel getBizLevelByCnName(String cnName) {
        BizLevel[] bizLevels = BizLevel.values();
        for (BizLevel bizLevel : bizLevels) {
            if (bizLevel.getCnName().equals(cnName)) {
                return bizLevel;
            }
        }
        return BIZ_LEVEL_UNKNOWN;
    }
    
    /**
     * 根据中文名获得业务层级
     *
     * @param code 中文名称
     * @return 业务层级
     */
    public static BizLevel getBizLevelByCode(String code) {
        BizLevel[] bizLevels = BizLevel.values();
        for (BizLevel bizLevel : bizLevels) {
            if (bizLevel.getCode().equals(code)) {
                return bizLevel;
            }
        }
        return BIZ_LEVEL_UNKNOWN;
    }
    
    /**
     * 根据英文名获得业务层级
     *
     * @param name 名称
     * @return 业务层级
     */
    public static BizLevel getBizLevel(String name) {
        BizLevel bizLevel = BizLevel.valueOf(name);
        if (bizLevel == null) {
            return BIZ_LEVEL_UNKNOWN;
        }
        return bizLevel;
    }
    
    /**
     * 获得字典项
     *
     * @param dicKey 字典Key
     * @return JSON 字符串
     */
    public static String getBizLevelDicByDicKey(String dicKey) {
        List<BizLevel> levels = DICS.get(dicKey);
        if (levels == null) {
            return null;
        }
        StringBuffer sb = new StringBuffer();
        sb.append('[');
        for (BizLevel bizLevel : levels) {
            sb.append("{'id':'").append(bizLevel.getCode()).append("',text:'").append(bizLevel.getCnName())
                .append("'},");
        }
        sb.deleteCharAt(sb.length() - 1);
        sb.append(']');
        return sb.toString();
    }
    
}
