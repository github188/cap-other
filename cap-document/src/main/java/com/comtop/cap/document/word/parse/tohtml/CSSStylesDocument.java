/******************************************************************************
 * Copyright (C) 2015 ShenZhen ComTop Information Technology Co.,Ltd
 * All Rights Reserved.
 * 本软件为深圳康拓普开发研制。未经本公司正式书面同意，其他任何个人、团体不得使用、
 * 复制、修改或发布本软件.
 *****************************************************************************/

package com.comtop.cap.document.word.parse.tohtml;

import java.math.BigInteger;
import java.util.ArrayList;
import java.util.List;

import org.apache.commons.lang.StringUtils;
import org.apache.poi.xwpf.usermodel.XWPFStyles;
import org.openxmlformats.schemas.wordprocessingml.x2006.main.CTHeight;
import org.openxmlformats.schemas.wordprocessingml.x2006.main.CTString;
import org.openxmlformats.schemas.wordprocessingml.x2006.main.CTStyle;
import org.openxmlformats.schemas.wordprocessingml.x2006.main.CTTblPrBase;
import org.openxmlformats.schemas.wordprocessingml.x2006.main.CTTblWidth;
import org.openxmlformats.schemas.wordprocessingml.x2006.main.CTTcPr;
import org.openxmlformats.schemas.wordprocessingml.x2006.main.CTTextDirection;
import org.openxmlformats.schemas.wordprocessingml.x2006.main.CTTrPr;
import org.openxmlformats.schemas.wordprocessingml.x2006.main.STHeightRule;
import org.openxmlformats.schemas.wordprocessingml.x2006.main.STTblWidth;
import org.openxmlformats.schemas.wordprocessingml.x2006.main.STTextDirection;
import org.xml.sax.helpers.AttributesImpl;

import com.comtop.cap.document.word.docmodel.style.CSSStyle;
import com.comtop.cap.document.word.docmodel.style.Color;
import com.comtop.cap.document.word.docmodel.style.TableHeight;
import com.comtop.cap.document.word.docmodel.style.TableWidth;
import com.comtop.cap.document.word.parse.util.XWPFTableUtil;
import com.comtop.cap.document.word.util.ColorHelper;
import com.comtop.cap.document.word.util.MeasurementUnits;
import com.comtop.cap.document.word.util.SAXHelper;

/**
 * CSS样式文档
 *
 * @author lizhiyong
 * @since jdk1.6
 * @version 2015年11月3日 lizhiyong
 */
public class CSSStylesDocument {
    
    /** PT单位常量 */
    private static final String PT_UNIT = "pt";
    
    /** %单位常量 */
    private static final Object PERCENT_UNIT = "%";
    
    /** 样式集 */
    private List<CSSStyle> cssStyles = new ArrayList<CSSStyle>(10);
    
    /** 忽略未使用的样式 */
    private final boolean ignoreStylesIfUnused;
    
    /** 样式文档 */
    private XWPFStyles stylesDocument;
    
    /**
     * 构造函数
     * 
     * @param stylesDocument x
     * @param ignoreStylesIfUnused x
     * @param indent x
     */
    public CSSStylesDocument(XWPFStyles stylesDocument, boolean ignoreStylesIfUnused, Integer indent) {
        this.ignoreStylesIfUnused = ignoreStylesIfUnused;
        this.stylesDocument = stylesDocument;
        this.initialize();
    }
    
    /**
     * 初始化
     *
     */
    private void initialize() {
        // default paragraph
        CSSStyle defaultPStyle = new CSSStyle(HTMLConstants.P_ELEMENT, null);
        defaultPStyle.addProperty(CSSStylesConstants.MARGIN_TOP, "0pt");
        defaultPStyle.addProperty(CSSStylesConstants.MARGIN_BOTTOM, "1pt");
        cssStyles.add(defaultPStyle);
    }
    
    /**
     * 根据表格属性创建样式
     *
     * @param tblPr 表格属性
     * @return 样式对象
     */
    public CSSStyle createCSSStyle(CTTblPrBase tblPr) {
        return createCSSStyle(tblPr, null);
    }
    
    /**
     * 根据表格属性创建样式
     *
     * @param tblPr 表格属性
     * @param className css 类名
     * @return 样式对象
     */
    public CSSStyle createCSSStyle(CTTblPrBase tblPr, String className) {
        if (tblPr != null) {
            String tagName = HTMLConstants.TABLE_ELEMENT;
            CSSStyle style = ignoreStylesIfUnused ? null : getOrCreateStyle(null, tagName, className);
            CTTblWidth tblWidth = tblPr.getTblW();
            TableWidth tableWidth = XWPFTableUtil.getTableWidth(tblWidth);
            if (tableWidth == null) {
                tblWidth = tblPr.getTblW();
                tableWidth = XWPFTableUtil.getTableWidth(tblWidth);
                
            }
            if (tableWidth != null && tableWidth.width > 0) {
                style = getOrCreateStyle(style, tagName, className);
                style.addProperty(CSSStylesConstants.WIDTH, getStyleWidth(tableWidth));
            }
            
            return style;
        }
        return null;
    }
    
    /**
     * 根据表格行属性创建样式
     *
     * @param trPr 表格行属性
     * @return 样式对象
     */
    public CSSStyle createCSSStyle(CTTrPr trPr) {
        return createCSSStyle(trPr, null);
    }
    
    /**
     * /**
     * 根据表格行属性创建样式
     *
     * @param trPr 表格行属性
     * @param className css类名
     * @return 样式对象
     */
    public CSSStyle createCSSStyle(CTTrPr trPr, String className) {
        if (trPr != null) {
            String tagName = HTMLConstants.TR_ELEMENT;
            CSSStyle style = ignoreStylesIfUnused ? null : getOrCreateStyle(null, tagName, className);
            
            // min-height / height
            TableHeight tableHeight = getTableRowHeight(trPr);
            if (tableHeight != null) {
                style = getOrCreateStyle(style, tagName, className);
                if (tableHeight.minimum) {
                    style.addProperty(CSSStylesConstants.MIN_HEIGHT, getValueAsPoint(tableHeight.height));
                }
                style.addProperty(CSSStylesConstants.HEIGHT, getValueAsPoint(tableHeight.height));
            }
            return style;
        }
        return null;
    }
    
    /**
     * 根据单元格属性创建样式
     *
     * @param tcPr 单元格属性
     * @return 样式对象
     */
    public CSSStyle createCSSStyle(CTTcPr tcPr) {
        return createCSSStyle(tcPr, null);
    }
    
    /**
     * 根据单元格属性创建样式
     *
     * @param tcPr 单元格属性
     * @param className css类名
     * @return 样式对象
     */
    public CSSStyle createCSSStyle(CTTcPr tcPr, String className) {
        if (tcPr != null) {
            String tagName = HTMLConstants.TD_ELEMENT;
            CSSStyle style = ignoreStylesIfUnused ? null : getOrCreateStyle(null, tagName, className);
            
            // cell width
            TableWidth cellWidth = getTableCellWith(tcPr);
            if (cellWidth != null) {
                style = getOrCreateStyle(style, tagName, className);
                style.addProperty(CSSStylesConstants.WIDTH, getStyleWidth(cellWidth));
            }
            // background color
            Color backgroundColor = getTableCellBackgroundColor(tcPr);
            if (backgroundColor != null) {
                style = getOrCreateStyle(style, tagName, className);
                style.addProperty(CSSStylesConstants.BACKGROUND_COLOR, ColorHelper.toHexString(backgroundColor));
            }
            CTTextDirection direction = getTextDirection(tcPr);
            if (direction != null) {
                // see http://www.css3maker.com/text-rotation.html
                int dir = direction.getVal().intValue();
                switch (dir) {
                    case STTextDirection.INT_BT_LR:
                        style = getOrCreateStyle(style, tagName, className);
                        style.addProperty("-webkit-transform", "rotate(270deg)");
                        style.addProperty("-moz-transform", "rotate(270deg)");
                        style.addProperty("-o-transform", "rotate(270deg)");
                        style.addProperty("writing-mode", "bt-lr"); // For IE
                        break;
                    case STTextDirection.INT_TB_RL:
                        style = getOrCreateStyle(style, tagName, className);
                        style.addProperty("-webkit-transform", "rotate(90deg)");
                        style.addProperty("-moz-transform", "rotate(90deg)");
                        style.addProperty("-o-transform", "rotate(90deg)");
                        style.addProperty("writing-mode", "tb-rl"); // For IE
                        break;
                    default:
                        break;
                }
            }
            return style;
        }
        return null;
    }
    
    /**
     * 创建Css类属性
     *
     * @param styleID x
     * @return x
     */
    public AttributesImpl createClassAttribute(String styleID) {
        String classNames = getClassNames(styleID);
        if (StringUtils.isNotEmpty(classNames)) {
            return SAXHelper.addAttrValue(null, HTMLConstants.CLASS_ATTR, classNames);
        }
        return null;
    }
    
    /**
     * 创建样式属性
     *
     * @param cssStyle CSS样式
     * @param attributes 属性集
     * @return 属性集
     */
    public AttributesImpl createStyleAttribute(CSSStyle cssStyle, AttributesImpl attributes) {
        if (cssStyle != null) {
            String inlineStyles = cssStyle.getInlineStyles();
            if (StringUtils.isNotEmpty(inlineStyles)) {
                return SAXHelper.addAttrValue(attributes, HTMLConstants.STYLE_ATTR, inlineStyles);
            }
        }
        return null;
    }
    
    /**
     * 获得文本方向
     *
     * @param tcPr 单元格属性
     * @return 文本 方向
     */
    public CTTextDirection getTextDirection(CTTcPr tcPr) {
        if (tcPr != null) {
            return tcPr.getTextDirection();
        }
        return null;
    }
    
    /**
     * 获得单元格背景色
     *
     * @param tcPr 背景色
     * @return 颜色
     */
    public Color getTableCellBackgroundColor(CTTcPr tcPr) {
        if (tcPr != null) {
            return ColorHelper.getFillColor(tcPr.getShd());
        }
        return null;
    }
    
    /**
     * 获得行高
     *
     * @param trPr 行属性
     * @return 行高
     */
    public TableHeight getTableRowHeight(CTTrPr trPr) {
        if (trPr == null) {
            return null;
        }
        if (trPr.sizeOfTrHeightArray() == 0) {
            return null;
        }
        // see http://officeopenxml.com/WPtableRowProperties.php
        CTHeight trHeight = trPr.getTrHeightArray(0);
        org.openxmlformats.schemas.wordprocessingml.x2006.main.STHeightRule.Enum hRule = trHeight.getHRule();
        boolean minimum = true;
        // hRule -- Specifies the meaning of the height. Possible values :
        if (hRule != null) {
            switch (hRule.intValue()) {
                case STHeightRule.INT_AT_LEAST:
                    // are atLeast (height should be at leasat the
                    // value specified)
                    minimum = true;
                    break;
                case STHeightRule.INT_EXACT:
                    // exact (height should be exactly the value specified)
                    minimum = false;
                    break;
                case STHeightRule.INT_AUTO:
                    // auto (default value--height is determined based on the height of the contents, so the value is
                    // ignored)
                    return null;
                default:
                    break;
            }
        }
        // val -- Specifies the row's height, in twentieths of a point.
        BigInteger value = trHeight.getVal();
        float height = MeasurementUnits.dxa2points(value);
        return new TableHeight(height, minimum);
    }
    
    /**
     * 获得单元格宽度
     *
     * @param tcPr 单元格属性
     * @return 单元格宽度
     */
    public TableWidth getTableCellWith(CTTcPr tcPr) {
        if (tcPr == null) {
            return null;
        }
        CTTblWidth tblWidth = tcPr.getTcW();
        return getTableWidth(tblWidth);
    }
    
    /**
     * 获得表格的宽度
     *
     * @param tblWidth 表格宽度定义
     * @return 表格宽度
     */
    public TableWidth getTableWidth(CTTblWidth tblWidth) {
        if (tblWidth == null) {
            return null;
        }
        float width = XWPFTableUtil.getTblWidthW(tblWidth);
        boolean percentUnit = (STTblWidth.INT_PCT == tblWidth.getType().intValue());
        if (percentUnit) {
            width = width / 100f;
        } else {
            width = MeasurementUnits.dxa2points(width);
        }
        return new TableWidth(width, percentUnit);
    }
    
    /**
     * 根据样式 id获得Css class名称
     *
     * @param styleID 样式id
     * @return Css class名称
     */
    public String getClassNames(String styleID) {
        if (StringUtils.isEmpty(styleID)) {
            return null;
        }
        StringBuilder classNames = new StringBuilder(getClassName(styleID));
        CTStyle style = getStyle(styleID);
        while (style != null) {
            style = getStyle(style.getBasedOn());
            if (style != null) {
                classNames.insert(0, getClassName(style.getStyleId(), true));
            }
        }
        
        return classNames.toString();
    }
    
    /**
     * 浮点值转为pt字符串
     *
     * @param value 浮点值
     * @return pt字符串
     */
    private String getValueAsPoint(float value) {
        return new StringBuilder(String.valueOf(value)).append(PT_UNIT).toString();
    }
    
    /**
     * 浮点值转为%字符串
     *
     * @param value 浮点值
     * @return %字符串
     */
    private String getValueAsPercent(float value) {
        return new StringBuilder(String.valueOf(value)).append(PERCENT_UNIT).toString();
    }
    
    /**
     * 根据样式id获得样式
     *
     * @param styleId 样式id
     * @return 样式对象
     */
    private CTStyle getStyle(String styleId) {
        return stylesDocument.getStyle(styleId).getCTStyle();
    }
    
    /**
     * 获得样式
     *
     * @param basedOn CTString
     * @return 样式对象
     */
    private CTStyle getStyle(CTString basedOn) {
        if (basedOn == null) {
            return null;
        }
        return getStyle(basedOn.getVal());
    }
    
    /**
     * 获得样式的宽度
     *
     * @param tableWidth 表格宽度
     * @return 样式宽度
     */
    private String getStyleWidth(TableWidth tableWidth) {
        return tableWidth.percentUnit ? getValueAsPercent(tableWidth.width) : getValueAsPoint(tableWidth.width);
    }
    
    /**
     * 获得css 类名
     *
     * @param styleId 样式id
     * @return 类名
     */
    private String getClassName(String styleId) {
        return getClassName(styleId, false);
    }
    
    /**
     * 根据doc 样式 获得 css类名
     *
     * @param styleId 样式id
     * @param spaceAfter 是否空格之后
     * @return css 类名
     */
    private String getClassName(String styleId, boolean spaceAfter) {
        StringBuilder className = new StringBuilder();
        char firstChar = styleId.charAt(0);
        if (Character.isDigit(firstChar)) {
            // class name must not started with a number (Chrome doesn't works with that).
            className.append('X').toString();
        }
        if (spaceAfter) {
            return className.append(styleId).append(' ').toString();
        }
        return className.append(styleId).toString();
    }
    
    /**
     * 获得或者创建样式
     *
     * @param style 样式对象
     * @param tagName 标签名
     * @param className css 类名
     * @return Css样式对象
     */
    private CSSStyle getOrCreateStyle(CSSStyle style, String tagName, String className) {
        if (style != null) {
            return style;
        }
        return new CSSStyle(tagName, className);
    }
}
