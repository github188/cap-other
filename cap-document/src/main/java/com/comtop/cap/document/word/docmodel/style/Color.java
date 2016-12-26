/******************************************************************************
 * Copyright (C) 2016 ShenZhen ComTop Information Technology Co.,Ltd
 * All Rights Reserved.
 * 本软件为深圳康拓普开发研制。未经本公司正式书面同意，其他任何个人、团体不得使用、
 * 复制、修改或发布本软件.
 *****************************************************************************/

package com.comtop.cap.document.word.docmodel.style;

/**
 * 颜色
 *
 * @author lizhiyong
 * @since jdk1.6
 * @version 2015年11月3日 lizhiyong
 */
public class Color {
    
    /** 白 */
    public static final Color WHITE = new Color(255, 255, 255);
    
    /** 黑 */
    public static final Color BLACK = new Color(0, 0, 0);
    
    /** 蓝 */
    public static final Color BLUE = new Color(0, 0, 255);
    
    /** CYAN */
    public static final Color CYAN = new Color(0, 255, 255);
    
    /** 深灰 */
    public static final Color DARK_GRAY = new Color(64, 64, 64);
    
    /** 绿 */
    public static final Color GREEN = new Color(0, 255, 0);
    
    /** 浅灰 */
    public static final Color LIGHT_GRAY = new Color(192, 192, 192);
    
    /** MAGENTA */
    public static final Color MAGENTA = new Color(255, 0, 255);
    
    /** 红 */
    public static final Color RED = new Color(255, 0, 0);
    
    /** 黄 */
    public static final Color YELLOW = new Color(255, 255, 0);
    
    /** rgb三原色 */
    private int argb;
    
    /**
     * 构造函数
     * 
     * @param value xz
     */
    public Color(final int value) {
        this.argb = value;
    }
    
    /**
     * 构造函数
     * 
     * @param r 红值
     * @param g 绿值
     * @param b 蓝值
     */
    public Color(int r, int g, int b) {
        this(r, g, b, 255);
    }
    
    /**
     * 构造函数
     * 
     * @param red 红值
     * @param green 绿值
     * @param blue 蓝值
     * @param alpha alpha值
     */
    public Color(final int red, final int green, final int blue, final int alpha) {
        update(red, green, blue, alpha);
    }
    
    /**
     * 更新
     *
     * @param red 红值
     * @param green 绿值
     * @param blue 蓝值
     * @param alpha alpha值
     */
    private void update(final int red, final int green, final int blue, final int alpha) {
        isValid(red, "red");
        isValid(green, "green");
        isValid(blue, "blue");
        isValid(alpha, "alpha");
        argb = ((alpha & 0xFF) << 24) | ((red & 0xFF) << 16) | ((green & 0xFF) << 8) | ((blue & 0xFF) << 0);
    }
    
    /**
     * 颜色值是否有效
     *
     * @param value 值
     * @param name 颜色名
     */
    private void isValid(int value, String name) {
        if (value < 0 || value > 255)
            throw new IllegalArgumentException(name + " is invalid, must be between 0 and 255");
        
    }
    
    /**
     * 获得 argb
     *
     * @return argb
     */
    public int getRGB() {
        return argb;
    }
    
    /**
     * 获得 红色值
     *
     * @return 红色值
     */
    public int getRed() {
        return (getRGB() >> 16) & 0xFF;
    }
    
    /**
     * 获得 绿色值
     *
     * @return 绿色值
     */
    public int getGreen() {
        return (getRGB() >> 8) & 0xFF;
    }
    
    /**
     * 获得 蓝色值
     *
     * @return 蓝色值
     */
    public int getBlue() {
        return (getRGB() >> 0) & 0xFF;
    }
    
    /**
     * 获得 Alpha值
     *
     * @return Alpha值
     */
    public int getAlpha() {
        return (getRGB() >> 24) & 0xff;
    }
    
    /**
     * 解码16进制颜色值为颜色对象
     *
     * @param hexColor 16进制颜色值
     * @return 颜色对象
     */
    public static Color decode(String hexColor) {
        Integer intval = Integer.decode(hexColor);
        int i = intval.intValue();
        return new Color((i >> 16) & 0xFF, (i >> 8) & 0xFF, i & 0xFF);
    }
}
