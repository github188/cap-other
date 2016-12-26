/******************************************************************************
 * Copyright (C) 2014 ShenZhen ComTop Information Technology Co.,Ltd
 * All Rights Reserved.
 * 本软件为深圳康拓普开发研制。未经本公司正式书面同意,其他任何个人、团体不得使用、
 * 复制、修改或发布本软件.
 *****************************************************************************/

package com.comtop.cap.document.word.docmodel.style;

import org.openxmlformats.schemas.wordprocessingml.x2006.main.STJc;
import org.openxmlformats.schemas.wordprocessingml.x2006.main.STVerticalAlignRun;
import org.openxmlformats.schemas.wordprocessingml.x2006.main.STVerticalJc;

/**
 * 样式
 *
 * @author lizhongwen
 * @since jdk1.6
 * @version 2015年10月19日 lizhongwen
 */
public class Style {
    
    /**
     * 项目编号/符号
     *
     *
     * @author lizhongwen
     * @since jdk1.6
     * @version 2015年10月20日 lizhongwen
     */
    public static class ItemCode {
        
        /** 文本内容 */
        private String content;
        
        /** 符号类型（数字或者符号） */
        private ItemType type;
        
        /** 级别 */
        private int level;
        
        /** 级别,参考 BulletStyle 和 NumberStyle */
        private int style;
        
        /**
         * 构造函数
         * 
         * @param content 文本内容
         */
        public ItemCode(String content) {
            super();
            this.content = content;
        }
        
        /**
         * 构造函数
         * 
         * @param content 文本内容
         * @param type 符号类型（数字或者符号）
         * @param level 级别
         * @param style 级别
         */
        public ItemCode(String content, ItemType type, int level, int style) {
            this(content);
            this.type = type;
            this.level = level;
            this.style = style;
        }
        
        /**
         * @return 获取 content属性值
         */
        public String getContent() {
            return content;
        }
        
        /**
         * @param content 设置 content 属性值为参数值 content
         */
        public void setContent(String content) {
            this.content = content;
        }
        
        /**
         * @return 获取 type属性值
         */
        public ItemType getType() {
            return type;
        }
        
        /**
         * @param type 设置 type 属性值为参数值 type
         */
        public void setType(ItemType type) {
            this.type = type;
        }
        
        /**
         * @return 获取 level属性值
         */
        public int getLevel() {
            return level;
        }
        
        /**
         * @param level 设置 level 属性值为参数值 level
         */
        public void setLevel(int level) {
            this.level = level;
        }
        
        /**
         * @return 获取 style属性值
         */
        public int getStyle() {
            return style;
        }
        
        /**
         * @param style 设置 style 属性值为参数值 style
         */
        public void setStyle(int style) {
            this.style = style;
        }
    }
    
    /**
     * 符号类型
     *
     *
     * @author lizhongwen
     * @since jdk1.6
     * @version 2015年10月20日 lizhongwen
     */
    public enum ItemType {
        /** 符号 */
        NUMBERING,
        /** 编号 */
        BULLET;
    }
    
    /**
     * 内置的项目符号类型
     *
     *
     * @author lizhongwen
     * @since jdk1.6
     * @version 2015年10月21日 lizhongwen
     */
    public static interface BulletStyle {
        
        /** 黑圆点 */
        public static final int BLACK_CIRCLE_DOT = 2;
        
        /** 黑方点 */
        public static final int BLACK_SQUARE_DOT = 3;
        
        /** 黑菱形点 */
        public static final int BLACK_DIAMOND_DOT = 4;
        
        /** √ */
        public static final int HOOK = 5;
        
        /** 向右的箭头 */
        public static final int ARROW = 6;
        
        /** 空心菱形 */
        public static final int HOLLOW_DIAMOND = 7;
        
        /** 黑五角星 */
        public static final int BLACK_STAR = 8;
    }
    
    /**
     * 内置的项目编号类型
     *
     *
     * @author lizhongwen
     * @since jdk1.6
     * @version 2015年10月21日 lizhongwen
     */
    public static interface NumberStyle {
        
        /** 阿拉伯数字 如:1.,2.,3.... */
        public static final int DECIMAL = 9;
        
        /** 带括号的数字 如:1),2),3)... */
        public static final int DECIMAL_BRACKET = 10;
        
        /** 简体中文数字 如:一,二,三... */
        public static final int CHINESE_COUNTING = 11;
        
        /** 大写字母 如:A,B,C... */
        public static final int UPPER_LETTER = 12;
        
        /** 带括号的 简体中文数字 如:(一),(二),(三) ... */
        public static final int CHINESE_COUNTING_BRACKETS = 13;
        
        /** 小写字母 如:a,b,c... */
        public static final int LOWER_LETTER = 14;
        
        /** 小写罗马数字 如:i,ii,iii... */
        public static final int LOWER_ROMAN = 15;
        
        /** 大写罗马数字 如:I,II,III... */
        public static final int UPPER_ROMAN = 16;
        
        /** 大写简体数字 如:壹,贰,叁... */
        public static final int CHINESE_LEGAL = 17;
        
        /** 天干 如:甲,乙,丙... */
        public static final int IDEOGRAPH_TRADITIONAL = 18;
        
        /** 地支 如:子,丑,寅... */
        public static final int IDEOGRAPH_ZODIAC = 19;
        
        /** 序数 如:1st, 2nd,3rd... */
        public static final int ORDINAL = 20;
        
        /** 基数文本 如:one,two,three... */
        public static final int CARDINAL_TEXT = 21;
        
        /** 序数文本 如:first, second,thirdv */
        public static final int ORDINAL_TEXT = 22;
        
        /** 以0开头的数字 如:01,02,03... */
        public static final int DECIMAL_ZERO = 23;
    }
    
    /**
     * 字体
     *
     *
     * @author lizhongwen
     * @since jdk1.6
     * @version 2015年10月20日 lizhongwen
     */
    public static class Font {
        
        /** 字体名称 */
        private String name;
        
        /** 字号大小（单位:磅） */
        private int fontSize;
        
        /** 空间对齐方式 */
        private VertAlign vert;
        
        /** 文本样式 */
        private TextStyle[] textStyles;
        
        /** 初号 */
        public static final float NO_0 = 42;
        
        /** 小初 */
        public static final float SMALL_NO_0 = 36;
        
        /** 一号 */
        public static final float NO_1 = 26;
        
        /** 小一 */
        public static final float SMALL_NO_1 = 24;
        
        /** 二号 */
        public static final float NO_2 = 22;
        
        /** 小二 */
        public static final float SMALL_NO_2 = 20;
        
        /** 三号 */
        public static final float NO_3 = 18;
        
        /** 小三 */
        public static final float SMALL_NO_3 = 16;
        
        /** 四号 */
        public static final float NO_4 = 14;
        
        /** 小四 */
        public static final float SMALL_NO_4 = 12;
        
        /** 五号 */
        public static final float NO_5 = 10.5f;
        
        /** 小五 */
        public static final float SMALL_NO_5 = 14;
        
        /** 六号 */
        public static final float NO_6 = 7.5f;
        
        /** 小六 */
        public static final float SMALL_NO_6 = 6.5f;
        
        /** 七号 */
        public static final float NO_7 = 5.5f;
        
        /** 八号 */
        public static final float NO_8 = 5;
        
        /**
         * 构造函数
         */
        public Font() {
            super();
        }
        
        /**
         * 构造函数
         * 
         * @param name 字体名称
         */
        public Font(String name) {
            super();
            this.name = name;
        }
        
        /**
         * 构造函数
         * 
         * @param name 字体名称
         * @param size 字号大小（磅,必须为0.5的倍数,与Word中的字号数值一致,如果是汉字字号,请使用本类中的常量）
         */
        public Font(String name, float size) {
            super();
            this.name = name;
            this.fontSize = (int) size * 2;
        }
        
        /**
         * @return 获取 name属性值
         */
        public String getName() {
            return name;
        }
        
        /**
         * @param name 设置 name 属性值为参数值 name
         */
        public void setName(String name) {
            this.name = name;
        }
        
        /**
         * @return 获取 fontSize属性值
         */
        public int getFontSize() {
            return fontSize;
        }
        
        /**
         * 设置字体大小（单位：磅,注意,必须为0.5的倍数）
         * 
         * @param size 设置 fontSize 属性值为参数值 fontSize
         */
        public void setFontSize(float size) {
            this.fontSize = (int) size * 2;
        }
        
        /**
         * @return 获取 vert属性值
         */
        public VertAlign getVert() {
            return vert;
        }
        
        /**
         * @param vert 设置 vert 属性值为参数值 vert
         */
        public void setVert(VertAlign vert) {
            this.vert = vert;
        }
        
        /**
         * @return 获取 textStyles属性值
         */
        public TextStyle[] getTextStyle() {
            return textStyles;
        }
        
        /**
         * @param textStyles 设置 textStyles 属性值为参数值 textStyles
         */
        public void setTextStyle(TextStyle... textStyles) {
            this.textStyles = textStyles;
        }
    }
    
    /**
     * 垂直对齐方式
     *
     * @author lizhongwen
     * @since jdk1.6
     * @version 2015年10月19日 lizhongwen
     */
    public enum VAlign {
        /** 顶部 */
        TOP(STVerticalJc.TOP),
        /** 居中 */
        CENTER(STVerticalJc.CENTER),
        /** 底部 */
        BOTTOM(STVerticalJc.BOTTOM);
        
        /** 垂直对齐Word值 */
        private STVerticalJc.Enum value;
        
        /**
         * 构造函数
         * 
         * @param value 垂直对齐Word值
         */
        private VAlign(STVerticalJc.Enum value) {
            this.value = value;
        }
        
        /**
         * @return 获取 value属性值
         */
        public STVerticalJc.Enum getValue() {
            return value;
        }
    }
    
    /**
     * 水平对齐方式
     *
     * @author lizhongwen
     * @since jdk1.6
     * @version 2015年10月19日 lizhongwen
     */
    public enum HAlign {
        /** 左对齐 */
        LEFT(STJc.LEFT),
        /** 右对齐 */
        RIGHT(STJc.RIGHT),
        /** 居中对齐 */
        CENTER(STJc.CENTER),
        /** 分散对齐 */
        DISTRIBUTE(STJc.DISTRIBUTE);
        
        /** 水平对齐Word值 */
        private STJc.Enum value;
        
        /**
         * 构造函数
         * 
         * @param value 水平对齐Word值
         */
        private HAlign(STJc.Enum value) {
            this.value = value;
        }
        
        /**
         * @return 获取 value属性值
         */
        public STJc.Enum getValue() {
            return value;
        }
    }
    
    /**
     * 空间对齐方式
     *
     * @author lizhongwen
     * @since jdk1.6
     * @version 2015年10月20日 lizhongwen
     */
    public enum VertAlign {
        /** 下标 */
        SUB_SCRIPT(STVerticalAlignRun.SUBSCRIPT),
        /** 上标 */
        SUPER_SCRIPT(STVerticalAlignRun.SUBSCRIPT);
        
        /** Word中空间对齐方式枚举值 */
        private STVerticalAlignRun.Enum value;
        
        /**
         * 构造函数
         * 
         * @param value Word中空间对齐方式枚举值
         */
        private VertAlign(STVerticalAlignRun.Enum value) {
            this.value = value;
        }
        
        /**
         * @return 获取 value属性值
         */
        public STVerticalAlignRun.Enum getValue() {
            return value;
        }
    }
    
    /**
     * 文本样式
     *
     * @author lizhongwen
     * @since jdk1.6
     * @version 2015年10月20日 lizhongwen
     */
    public enum TextStyle {
        /** 粗体 */
        BOLD,
        /** 倾斜 */
        INC_LINE,
        /** 下划线 */
        UNDER_LINE,
        /** 删除线 */
        STRIKE,
        /** 双删除线 */
        DSTRIKE,
        /** 隐藏 */
        VANISH,
        /** 小型 大写字母 */
        SMALL_CAPS,
        /** 全部 大写字母 */
        CAPS;
    }
}
