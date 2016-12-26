/******************************************************************************
 * Copyright (C) 2015 ShenZhen ComTop Information Technology Co.,Ltd
 * All Rights Reserved.
 * 本软件为深圳康拓普开发研制。未经本公司正式书面同意，其他任何个人、团体不得使用、
 * 复制、修改或发布本软件.
 *****************************************************************************/

package com.comtop.cap.document.word.docmodel;

import static com.comtop.cap.document.word.util.MeasurementUnits.cmToTwip;

import java.math.BigInteger;

import org.openxmlformats.schemas.wordprocessingml.x2006.main.STPageOrientation;
import org.openxmlformats.schemas.wordprocessingml.x2006.main.STSectionMark;

import com.comtop.cap.document.word.docmodel.style.Border;

/**
 * 章节属性
 *
 * @author lizhongwen
 * @since jdk1.6
 * @version 2015年11月3日 lizhongwen
 */
public class SectionProperties {
    
    /** 页面大小 */
    private PageSize size;
    
    /** 页边距 */
    private Margin margin;
    
    /** 页面方向 */
    private Orientation orient;
    
    /** 章节类型 */
    private Type type;
    
    /** 页面边线 */
    private Border[] borders;
    
    // TODO 还可以设置诸如行号、文字方向、装订线、网格等等
    
    /**
     * @return 获取 size属性值
     */
    public PageSize getSize() {
        return size;
    }
    
    /**
     * @param size 设置 size 属性值为参数值 size
     */
    public void setSize(PageSize size) {
        this.size = size;
    }
    
    /**
     * @return 获取 margin属性值
     */
    public Margin getMargin() {
        return margin;
    }
    
    /**
     * @param margin 设置 margin 属性值为参数值 margin
     */
    public void setMargin(Margin margin) {
        this.margin = margin;
    }
    
    /**
     * @return 获取 orient属性值
     */
    public Orientation getOrient() {
        return orient;
    }
    
    /**
     * @param orient 设置 orient 属性值为参数值 orient
     */
    public void setOrient(Orientation orient) {
        this.orient = orient;
    }
    
    /**
     * @return 获取 type属性值
     */
    public Type getType() {
        return type;
    }
    
    /**
     * @param type 设置 type 属性值为参数值 type
     */
    public void setType(Type type) {
        this.type = type;
    }
    
    /**
     * @return 获取 borders属性值
     */
    public Border[] getBorders() {
        return borders;
    }
    
    /**
     * @param borders 设置 borders 属性值为参数值 borders
     */
    public void setBorders(Border[] borders) {
        this.borders = borders;
    }
    
    /**
     * 页面大小
     *
     * @author lizhongwen
     * @since jdk1.6
     * @version 2015年10月15日 lizhongwen
     */
    public static class PageSize {
        
        /** 宽度 （单位：厘米） */
        private Float width;
        
        /** 高度（单位：厘米） */
        private Float height;
        
        /** 宽度 （单位：Twip） */
        private BigInteger widthTwip;
        
        /** 高度 （单位：Twip） */
        private BigInteger heightTwip;
        
        /**
         * 构造函数
         */
        public PageSize() {
            super();
        }
        
        /**
         * 构造函数
         * 
         * @param width 宽度
         * @param height 高度
         */
        public PageSize(Float width, Float height) {
            super();
            this.setWidth(width);
            this.setHeight(height);
        }
        
        /**
         * @return 获取 width属性值
         */
        public Float getWidth() {
            return width;
        }
        
        /**
         * @return 获取 宽度在Word中的数值
         */
        public BigInteger getWidthAsTwip() {
            return widthTwip;
        }
        
        /**
         * @param width 设置 width 属性值为参数值 width
         */
        public void setWidth(Float width) {
            this.width = width;
            this.widthTwip = BigInteger.valueOf(cmToTwip(width));
        }
        
        /**
         * @return 获取 height属性值
         */
        public Float getHeight() {
            return height;
        }
        
        /**
         * @return 获取 宽度在Word中的数值
         */
        public BigInteger getHeightAsTwip() {
            return heightTwip;
        }
        
        /**
         * @param height 设置 height 属性值为参数值 height
         */
        public void setHeight(Float height) {
            this.height = height;
            this.heightTwip = BigInteger.valueOf(cmToTwip(height));
        }
        
        /** A3页面大小 */
        private static PageSize A3;
        
        /**
         * @return A3页面大小
         */
        public static PageSize getA3() {
            if (A3 == null) {
                synchronized (PageSize.class) {
                    A3 = new PageSize(29.7f, 42f);
                }
            }
            return A3;
        }
        
        /** A4页面大小 */
        private static PageSize A4;
        
        /**
         * @return A4页面大小
         */
        public static PageSize getA4() {
            if (A4 == null) {
                synchronized (PageSize.class) {
                    A4 = new PageSize(21f, 29.7f);
                }
            }
            return A4;
        }
        
        /** A5页面大小 */
        private static PageSize A5;
        
        /**
         * @return A5页面大小
         */
        public static PageSize getA5() {
            if (A5 == null) {
                synchronized (PageSize.class) {
                    A5 = new PageSize(14.8f, 21f);
                }
            }
            return A5;
        }
        
        /** A6页面大小 */
        private static PageSize A6;
        
        /**
         * @return A6页面大小
         */
        public static PageSize getA6() {
            if (A6 == null) {
                synchronized (PageSize.class) {
                    A6 = new PageSize(10.5f, 14.8f);
                }
            }
            return A6;
        }
        
        /** B3页面大小 */
        private static PageSize B3;
        
        /**
         * @return B3页面大小
         */
        public static PageSize getB3() {
            if (B3 == null) {
                synchronized (PageSize.class) {
                    B3 = new PageSize(36.4f, 51.5f);
                }
            }
            return B3;
        }
        
        /** B4页面大小 */
        private static PageSize B4;
        
        /**
         * @return B4页面大小
         */
        public static PageSize getB4() {
            if (B4 == null) {
                synchronized (PageSize.class) {
                    B4 = new PageSize(25.7f, 36.4f);
                }
            }
            return B4;
        }
        
        /** B5页面大小 */
        private static PageSize B5;
        
        /**
         * @return B5页面大小
         */
        public static PageSize getB5() {
            if (B5 == null) {
                synchronized (PageSize.class) {
                    B5 = new PageSize(18.2f, 25.7f);
                }
            }
            return B5;
        }
        
        /** B6页面大小 */
        private static PageSize B6;
        
        /**
         * @return B6页面大小
         */
        public static PageSize getB6() {
            if (B6 == null) {
                synchronized (PageSize.class) {
                    B6 = new PageSize(12.8f, 18.2f);
                }
            }
            return B6;
        }
    }
    
    /**
     * 页边距（单位厘米，(word中1厘米约等于567)）
     *
     *
     * @author lizhongwen
     * @since jdk1.6
     * @version 2015年10月15日 lizhongwen
     */
    public static class Margin {
        
        /** 左边距 （单位：厘米） */
        private Float left;
        
        /** 上边距（单位：厘米） */
        private Float top;
        
        /** 右边距（单位：厘米） */
        private Float right;
        
        /** 下边距 （单位：厘米） */
        private Float bottom;
        
        /** 装订线边距 （单位：厘米） */
        private Float gutter;
        
        /** 页眉边距 （单位：厘米） */
        private Float header;
        
        /** 页脚边距 （单位：厘米） */
        private Float footer;
        
        /** 左边距 （单位：Twip） */
        private BigInteger leftTwip;
        
        /** 上边距 （单位：Twip） */
        private BigInteger topTwip;
        
        /** 右边距 （单位：Twip） */
        private BigInteger rightTwip;
        
        /** 下边距 （单位：Twip） */
        private BigInteger bottomTwip;
        
        /** 装订线边距 （单位：Twip） */
        private BigInteger gutterTwip;
        
        /** 页眉边距 （单位：Twip） */
        private BigInteger headerTwip;
        
        /** 页脚边距 （单位：Twip） */
        private BigInteger footerTwip;
        
        /**
         * 构造函数
         */
        public Margin() {
            
        }
        
        /**
         * 构造函数
         * 
         * @param left 左边距
         * @param top 上边距
         * @param right 右边距
         * @param bottom 下边距
         */
        public Margin(Float left, Float top, Float right, Float bottom) {
            super();
            this.setLeft(left);
            this.setTop(top);
            this.setRight(right);
            this.setBottom(bottom);
        }
        
        /**
         * 构造函数
         * 
         * @param left 左边距
         * @param top 上边距
         * @param right 右边距
         * @param bottom 下边距
         * @param gutter 装订线边距
         * @param header 页眉边距
         * @param footer 页脚边距
         */
        public Margin(Float left, Float top, Float right, Float bottom, Float gutter, Float header, Float footer) {
            this(left, top, right, bottom);
            this.setGutter(gutter);
            this.setHeader(header);
            this.setFooter(footer);
        }
        
        /**
         * @return 获取 left属性值
         */
        public Float getLeft() {
            return left;
        }
        
        /**
         * @return 获取 左边距在Word中的数值
         */
        public BigInteger getLeftAsTwip() {
            return leftTwip;
        }
        
        /**
         * @param left 设置 left 属性值为参数值 left
         */
        public void setLeft(Float left) {
            this.left = left;
            this.leftTwip = BigInteger.valueOf(cmToTwip(left));
        }
        
        /**
         * @return 获取 top属性值
         */
        public Float getTop() {
            return top;
        }
        
        /**
         * @return 获取 上边距在Word中的数值
         */
        public BigInteger getTopAsTwip() {
            return topTwip;
        }
        
        /**
         * @param top 设置 top 属性值为参数值 top
         */
        public void setTop(Float top) {
            this.top = top;
            this.topTwip = BigInteger.valueOf(cmToTwip(top));
        }
        
        /**
         * @return 获取 right属性值
         */
        public Float getRight() {
            return right;
        }
        
        /**
         * @param right 设置 right 属性值为参数值 right
         */
        public void setRight(Float right) {
            this.right = right;
            this.rightTwip = BigInteger.valueOf(cmToTwip(right));
        }
        
        /**
         * @return 获取 右边距在Word中的数值
         */
        public BigInteger getRightAsTwip() {
            return rightTwip;
        }
        
        /**
         * @return 获取 bottom属性值
         */
        public Float getBottom() {
            return bottom;
        }
        
        /**
         * @param bottom 设置 bottom 属性值为参数值 bottom
         */
        public void setBottom(Float bottom) {
            this.bottom = bottom;
            this.bottomTwip = BigInteger.valueOf(cmToTwip(bottom));
        }
        
        /**
         * @return 获取 下边距在Word中的数值
         */
        public BigInteger getBottomAsTwip() {
            return bottomTwip;
        }
        
        /**
         * @return 获取 gutter属性值
         */
        public Float getGutter() {
            return gutter;
        }
        
        /**
         * @param gutter 设置 gutter 属性值为参数值 gutter
         */
        public void setGutter(Float gutter) {
            this.gutter = gutter;
            this.gutterTwip = BigInteger.valueOf(cmToTwip(gutter));
        }
        
        /**
         * @return 获取 装订线边距在Word中的数值
         */
        public BigInteger getGutterAsTwip() {
            return gutterTwip;
        }
        
        /**
         * @return 获取 header属性值
         */
        public Float getHeader() {
            return header;
        }
        
        /**
         * @param header 设置 header 属性值为参数值 header
         */
        public void setHeader(Float header) {
            this.header = header;
            this.headerTwip = BigInteger.valueOf(cmToTwip(header));
        }
        
        /**
         * @return 获取 装订线边距在Word中的数值
         */
        public BigInteger getHeaderAsTwip() {
            return headerTwip;
        }
        
        /**
         * @return 获取 footer属性值
         */
        public Float getFooter() {
            return footer;
        }
        
        /**
         * @return 获取 装订线边距在Word中的数值
         */
        public BigInteger getFooterAsTwip() {
            return footerTwip;
        }
        
        /**
         * @param footer 设置 footer 属性值为参数值 footer
         */
        public void setFooter(Float footer) {
            this.footer = footer;
            this.footerTwip = BigInteger.valueOf(cmToTwip(footer));
        }
        
        /** 默认的页边距 */
        public static Margin DEFAULT_MARGIN;
        
        /**
         * @return 获取默认的页边距
         */
        public static Margin getA4Margin() {
            if (DEFAULT_MARGIN == null) {
                synchronized (Margin.class) {
                    DEFAULT_MARGIN = new Margin(3.17f, 2.54f, 3.17f, 2.54f, 0f, 1.5f, 1.75f);
                }
            }
            return DEFAULT_MARGIN;
        }
        
    }
    
    /**
     * 页面方向
     *
     * @author lizhongwen
     * @since jdk1.6
     * @version 2015年10月15日 lizhongwen
     */
    public static enum Orientation {
        /** 横向 */
        LANDSCAPE(STPageOrientation.LANDSCAPE),
        /** 纵向 */
        PORTRAIT(STPageOrientation.PORTRAIT);
        
        /** word中页面方向枚举 */
        private STPageOrientation.Enum storient;
        
        /**
         * 构造函数
         * 
         * @param storient word中页面方向枚举
         */
        private Orientation(STPageOrientation.Enum storient) {
            this.storient = storient;
        }
        
        /**
         * @return 获取Word中页面方向的值
         */
        public STPageOrientation.Enum getSTOrient() {
            return storient;
        }
    }
    
    /**
     * 章节类型
     *
     * @author lizhongwen
     * @since jdk1.6
     * @version 2015年11月3日 lizhongwen
     */
    public static enum Type {
        /** 下一页 */
        NEXT_PAGE(STSectionMark.NEXT_PAGE),
        /** 下一列 */
        NEXT_COLUMN(STSectionMark.NEXT_COLUMN),
        /** 接上页 */
        CONTINUOUS(STSectionMark.CONTINUOUS),
        /** 偶数页 */
        EVEN_PAGE(STSectionMark.EVEN_PAGE),
        /** 奇数页 */
        ODD_PAGE(STSectionMark.ODD_PAGE);
        
        /** 章节类型标记 */
        private STSectionMark.Enum mark;
        
        /**
         * 构造函数
         * 
         * @param mark 章节类型标记
         */
        private Type(STSectionMark.Enum mark) {
            this.mark = mark;
        }
        
        /**
         * @return 获取 mark属性值
         */
        public STSectionMark.Enum getMark() {
            return mark;
        }
    }
    
}
