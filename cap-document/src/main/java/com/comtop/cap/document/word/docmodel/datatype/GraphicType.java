/******************************************************************************
 * Copyright (C) 2015 ShenZhen ComTop Information Technology Co.,Ltd
 * All Rights Reserved.
 * 本软件为深圳康拓普开发研制。未经本公司正式书面同意，其他任何个人、团体不得使用、
 * 复制、修改或发布本软件.
 *****************************************************************************/

package com.comtop.cap.document.word.docmodel.datatype;

/**
 * 图片类型
 *
 *
 * @author lizhongwen
 * @since jdk1.6
 * @version 2015年10月15日 lizhongwen
 */
public enum GraphicType {
    /** Extended windows meta file */
    PICTURE_TYPE_EMF(2),
    
    /** Windows Meta File */
    PICTURE_TYPE_WMF(3),
    
    /** Mac PICT format */
    PICTURE_TYPE_PICT(4),
    
    /** JPEG format */
    PICTURE_TYPE_JPEG(5),
    
    /** PNG format */
    PICTURE_TYPE_PNG(6),
    
    /** Device independent bitmap */
    PICTURE_TYPE_DIB(7),
    
    /** GIF image format */
    PICTURE_TYPE_GIF(8),
    
    /** Tag Image File (.tiff) */
    PICTURE_TYPE_TIFF(9),
    
    /** Encapsulated Postscript (.eps) */
    PICTURE_TYPE_EPS(10),
    
    /** Windows Bitmap (.bmp) */
    PICTURE_TYPE_BMP(11),
    
    /** WordPerfect graphics (.wpg) */
    PICTURE_TYPE_WPG(12);
    
    /** 文件类型 */
    private int type;
    
    /**
     * 
     * 构造函数
     * 
     * @param type 文件类型
     */
    private GraphicType(int type) {
        this.type = type;
    }
    
    /**
     * @return 获取 type属性值
     */
    public int getType() {
        return type;
    }
    
    /**
     * 根据后缀名获取图片格式
     *
     * @param subfix 后缀名
     * @return 图片格式
     */
    public static GraphicType formatBySubfix(String subfix) {
        GraphicType format;
        if ("emf".equalsIgnoreCase(subfix)) {
            format = GraphicType.PICTURE_TYPE_EMF;
        } else if ("wmf".equalsIgnoreCase(subfix)) {
            format = GraphicType.PICTURE_TYPE_WMF;
        } else if ("pict".equalsIgnoreCase(subfix)) {
            format = GraphicType.PICTURE_TYPE_PICT;
        } else if ("jpeg".equalsIgnoreCase(subfix) || "jpg".equalsIgnoreCase(subfix)) {
            format = GraphicType.PICTURE_TYPE_PICT;
        } else if ("png".equalsIgnoreCase(subfix)) {
            format = GraphicType.PICTURE_TYPE_PNG;
        } else if ("dib".equalsIgnoreCase(subfix)) {
            format = GraphicType.PICTURE_TYPE_DIB;
        } else if ("gif".equalsIgnoreCase(subfix)) {
            format = GraphicType.PICTURE_TYPE_GIF;
        } else if ("tiff".equalsIgnoreCase(subfix)) {
            format = GraphicType.PICTURE_TYPE_TIFF;
        } else if ("bmp".equalsIgnoreCase(subfix)) {
            format = GraphicType.PICTURE_TYPE_BMP;
        } else if ("eps".equalsIgnoreCase(subfix)) {
            format = GraphicType.PICTURE_TYPE_EPS;
        } else if ("wpg".equalsIgnoreCase(subfix)) {
            format = GraphicType.PICTURE_TYPE_WPG;
        } else {
            format = GraphicType.PICTURE_TYPE_PNG;
        }
        return format;
    }
}
