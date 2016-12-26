/******************************************************************************
 * Copyright (C) 2015 ShenZhen ComTop Information Technology Co.,Ltd
 * All Rights Reserved.
 * 本软件为深圳康拓普开发研制。未经本公司正式书面同意，其他任何个人、团体不得使用、
 * 复制、修改或发布本软件.
 *****************************************************************************/

package com.comtop.cap.document.word.docconfig.datatype;

import javax.xml.bind.annotation.XmlEnum;

/**
 * 大纲级别
 *
 * @author lizhiyong
 * @since jdk1.6
 * @version 2015年10月21日 lizhiyong
 */
@XmlEnum
public enum OutlineLevel {
    
    /** 大标题 */
    LEVEL0(0),
    
    /** 一级标题 */
    LEVEL1(1),
    
    /** 二级标题 */
    LEVEL2(2),
    
    /** 三级标题 */
    LEVEL3(3),
    
    /** 四级标题 */
    LEVEL4(4),
    
    /** 五级标题 */
    LEVEL5(5),
    
    /** 六级标题 */
    LEVEL6(6),
    
    /** 七级标题 */
    LEVEL7(7),
    
    /** 入级标题 */
    LEVEL8(8),
    
    /** 九级标题 */
    LEVEL9(9),
    
    /** 正文 */
    LEVEL10(10);
    
    /** 值 */
    private int value;
    
    /**
     * 
     * 构造函数
     * 
     * @param value 值
     */
    OutlineLevel(int value) {
        this.value = value;
    }
    
    /***
     * 
     * 获得值
     *
     * @return 值
     */
    public int getValue() {
        return value;
    }
    
    /**
     * 获得枚举对象
     *
     * @param level 级别
     * @return 枚举对象
     */
    public static OutlineLevel getOutlineLevel(int level) {
        if (level < 0 || level > 10) {
            throw new RuntimeException("不支持的大纲级别枚举值：" + level);
        }
        return OutlineLevel.values()[level];
    }
    
    /**
     * 获得下级大纲级别
     *
     * @return 大纲级别
     */
    public OutlineLevel getChild() {
        return getOutlineLevel(getValue() + 1);
    }
    
    /**
     * 获得上一级（父亲级）大纲
     *
     * @return 大纲级别
     */
    public OutlineLevel getParent() {
        return getOutlineLevel(getValue() - 1);
    }
}
