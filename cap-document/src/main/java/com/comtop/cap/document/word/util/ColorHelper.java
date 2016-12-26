/******************************************************************************
 * Copyright (C) 2015 ShenZhen ComTop Information Technology Co.,Ltd
 * All Rights Reserved.
 * 本软件为深圳康拓普开发研制。未经本公司正式书面同意，其他任何个人、团体不得使用、
 * 复制、修改或发布本软件.
 *****************************************************************************/

package com.comtop.cap.document.word.util;

import java.util.HashMap;
import java.util.Map;

import org.openxmlformats.schemas.wordprocessingml.x2006.main.CTBorder;
import org.openxmlformats.schemas.wordprocessingml.x2006.main.CTColor;
import org.openxmlformats.schemas.wordprocessingml.x2006.main.CTParaRPr;
import org.openxmlformats.schemas.wordprocessingml.x2006.main.CTRPr;
import org.openxmlformats.schemas.wordprocessingml.x2006.main.CTShd;
import org.openxmlformats.schemas.wordprocessingml.x2006.main.STHexColor;
import org.openxmlformats.schemas.wordprocessingml.x2006.main.STShd;
import org.w3c.dom.Attr;
import org.w3c.dom.Node;

import com.comtop.cap.document.word.docmodel.style.Color;

/**
 * 颜色处理帮助 类
 *
 * @author lizhiyong
 * @since jdk1.6
 * @version 2015年11月3日 lizhiyong
 */
public class ColorHelper {
    
    /** 常量 自动 */
    private static final String AUTO = "auto";
    
    /** 常量 pct */
    private static final String PCT = "pct";
    
    /** 颜色集 */
    private static final Map<String, Color> colors = new HashMap<String, Color>();
    
    /**
     * 根据颜色字符串，获得颜色对象，没有创建
     *
     * @param style 十六进行颜色值
     * @return 颜色对象
     */
    public static Color getColor(String style) {
        Color color = colors.get(style);
        return color != null ? color : createColor(style);
    }
    
    /**
     * 创建新的颜色对象
     *
     * @param hexColor 十六进行颜色值
     * @return 颜色对象
     */
    private static Color createColor(String hexColor) {
        if (hexColor != null && !"0xauto".equals(hexColor) && !"0xtransparent".equals(hexColor)) {
            Color color = Color.decode(hexColor);
            colors.put(hexColor, color);
            return color;
        }
        return null;
    }
    
    /**
     * 根据 CTShd 获得填充的颜色
     *
     * @param shd CTShd
     * @return 颜色对象
     */
    public static Color getFillColor(CTShd shd) {
        if (shd == null) {
            return null;
        }
        STHexColor hexColor = shd.xgetFill();
        Object val = shd.xgetVal();
        return getColor(hexColor, val, true);
    }
    
    /**
     * 根据CTRPr获得颜色
     *
     * @param rPr r属性
     * @return 颜色对象
     */
    public static Color getColor(CTRPr rPr) {
        if (rPr != null) {
            CTColor ctColor = rPr.getColor();
            if (ctColor != null) {
                STHexColor color = ctColor.xgetVal();
                Object val = ctColor.getVal();
                return ColorHelper.getColor(color, val, false);
            }
            // else
            // {
            // return ColorHelper.getColor( rPr.getShd() );
            // }
        }
        return null;
    }
    
    /**
     * 根据 CTParaRPr 获得颜色
     *
     * @param rPr CTParaRPr
     * @return 颜色对象
     */
    public static Color getColor(CTParaRPr rPr) {
        if (rPr != null) {
            CTColor ctColor = rPr.getColor();
            if (ctColor != null) {
                STHexColor color = ctColor.xgetVal();
                Object val = ctColor.getVal();
                return ColorHelper.getColor(color, val, false);
            }
        }
        return null;
    }
    
    /**
     * 根据CTShd获得颜色
     *
     * @param shd CTShd
     * @return 颜色对象
     */
    public static Color getColor(CTShd shd) {
        if (shd == null) {
            return null;
        }
        STHexColor hexColor = shd.xgetColor();
        Object val = shd.xgetVal();
        return getColor(hexColor, val, false);
    }
    
    /**
     * 获得颜色
     *
     * @param hexColor 十六进制颜色值
     * @param val 变量
     * @param background 背景
     * @return 颜色值
     */
    public static Color getColor(STHexColor hexColor, Object val, boolean background) {
        if (hexColor == null) {
            return null;
        }
        return getColor(hexColor.getStringValue(), val, background);
    }
    
    /**
     * 获得颜色
     *
     * @param hexColor 十六进制颜色值
     * @param val 变量
     * @param background 背景
     * @return 颜色值
     */
    public static Color getColor(String hexColor, Object val, boolean background) {
        if (hexColor != null) {
            if (AUTO.equals(hexColor)) {
                Color autoColor = background ? Color.WHITE : Color.BLACK;
                if (val != null) {
                    String s = getStringVal(val);
                    if (s.startsWith(PCT)) {
                        s = s.substring(PCT.length(), s.length());
                        try {
                            float percent = Float.parseFloat(s) / 100;
                            if (background) {
                                return darken(autoColor.getRed(), autoColor.getGreen(), autoColor.getBlue(), percent);
                            }
                            return lighten(autoColor.getRed(), autoColor.getGreen(), autoColor.getBlue(), percent);
                        } catch (Throwable e) {
                            e.printStackTrace();
                        }
                    }
                }
                return autoColor;
            }
            return getColor("0x" + hexColor);
        }
        return null;
    }
    
    /**
     * 变暗
     *
     * @param r 红
     * @param g 绿
     * @param b 蓝
     * @param percent %
     * @return 颜色对象
     * @throws IllegalArgumentException x
     */
    public static Color darken(int r, int g, int b, double percent) throws IllegalArgumentException {
        return new Color(Math.max((int) (r * (1 - percent)), 0), Math.max((int) (g * (1 - percent)), 0), Math.max(
            (int) (b * (1 - percent)), 0));
    }
    
    /**
     * 变亮
     *
     * @param r 红
     * @param g 绿
     * @param b 蓝
     * @param percent %
     * @return 颜色对象
     * @throws IllegalArgumentException x
     */
    public static Color lighten(int r, int g, int b, double percent) throws IllegalArgumentException {
        int r2, g2, b2;
        r2 = r + (int) ((255 - r) * percent);
        g2 = g + (int) ((255 - g) * percent);
        b2 = b + (int) ((255 - b) * percent);
        return new Color(r2, g2, b2);
    }
    
    /**
     * 获得边框颜色
     *
     * @param border 边框
     * @return 颜色对象
     */
    public static Color getBorderColor(CTBorder border) {
        if (border == null) {
            return null;
        }
        // border.getColor returns object???, use attribute w:color to get
        // the color.
        Node colorAttr = border.getDomNode().getAttributes()
            .getNamedItemNS("http://schemas.openxmlformats.org/wordprocessingml/2006/main", "color");
        if (colorAttr != null) {
            Object val = border.getVal();
            return ColorHelper.getColor(((Attr) colorAttr).getValue(), val, false);
        }
        return null;
    }
    
    /**
     * Color to hex representation
     * 
     * @param color x
     * @return x
     */
    public static String toHexString(Color color) {
        if (color == null) {
            return "";
        }
        String hexColour = Integer.toHexString(color.getRGB() & 0xffffff);
        if (hexColour.length() < 6) {
            hexColour = "000000".substring(0, 6 - hexColour.length()) + hexColour;
        }
        return "#" + hexColour;
    }
    
    /**
     * 获得字符串形式的变量
     *
     * @param val x
     * @return x
     */
    private static String getStringVal(Object val) {
        if (val instanceof STShd) {
            STShd shd = (STShd) val;
            return shd.getStringValue();
        }
        return val.toString();
    }
    
    /**
     * rgb颜色值转换为16进制字符串
     *
     * @param red 红色值
     * @param green 绿色值
     * @param blue 蓝色值
     * @return 16进制字符串
     */
    public static String rgbTripleToHex(float red, float green, float blue) {
        return getHex(red) + getHex(green) + getHex(blue);
    }
    
    /**
     * 浮点数转换为16进制
     * 
     * @param f 浮点数
     * @return 16进制
     */
    private static String getHex(float f) {
        
        int i = Math.round(f);
        
        if (i <= 16) {
            // Pad so we have 2 digits
            return "0" + Integer.toHexString(i);
        }
        return Integer.toHexString(i);
    }
    
    /**
     * 颜色值转换为16进制
     *
     * @param color 颜色值
     * @return 16进制字符串
     */
    public static String toHexColor(int color) {
        String ret = Integer.toHexString(color).toUpperCase();
        return (ret.length() < 6 ? "000000".substring(0, 6 - ret.length()) + ret : ret);
    }
    
    /**
     * 混色
     *
     * @param fgColor 前景色
     * @param bgColor 背景色
     * @param pctFg 偏光
     * @return 混色值
     */
    public static int combineColors(int fgColor, int bgColor, int pctFg) {
        int resColor = 0;
        if (pctFg < 1) {
            resColor = bgColor;
        } else if (pctFg == 100) {
            resColor = fgColor;
        } else {
            int pctBg = 100 - pctFg;
            resColor =
            // Red
            (((((((fgColor >> 16) & 0xff) * pctFg) + (((bgColor >> 16) & 0xff) * pctBg))) / 100) << 16) |
            // Green
                (((((((fgColor >> 8) & 0xff) * pctFg) + (((bgColor >> 8) & 0xff) * pctBg))) / 100) << 8) |
                // Blue
                (((((fgColor & 0xff) * pctFg) + ((bgColor & 0xff) * pctBg))) / 100);
        }
        
        return resColor;
    }
    
    /**
     * 将十六进制字符串转换成字节数组
     *
     * @param data 十六进制字符串
     * @return 字节数组
     */
    public static byte[] decodeHex(final String data) {
        final char[] chars = data.toCharArray();
        final int len = chars.length;
        
        final byte[] out = new byte[len >> 1];
        
        // two characters form the hex value.
        for (int i = 0, j = 0; j < len; i++) {
            int f = Character.digit(chars[j], 16) << 4;
            j++;
            f = f | Character.digit(chars[j], 16);
            j++;
            out[i] = (byte) (f & 0xFF);
        }
        return out;
    }
    
}
