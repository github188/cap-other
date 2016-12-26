/******************************************************************************
 * Copyright (C) 2014 ShenZhen ComTop Information Technology Co.,Ltd
 * All Rights Reserved.
 * 本软件为深圳康拓普开发研制。未经本公司正式书面同意，其他任何个人、团体不得使用、
 * 复制、修改或发布本软件.
 *****************************************************************************/

package com.comtop.cap.document.word.docmodel.data;

import static com.comtop.cap.document.word.util.MeasurementUnits.cmToEMU;
import static com.comtop.cap.document.word.util.MeasurementUnits.cmToMM;
import static com.comtop.cap.document.word.util.MeasurementUnits.cmToPT;
import static com.comtop.cap.document.word.util.MeasurementUnits.emuToCm;
import static com.comtop.cap.document.word.util.MeasurementUnits.mmToTwip;
import static com.comtop.cap.document.word.util.MeasurementUnits.pt2cm;

import java.io.FileInputStream;
import java.io.FileNotFoundException;
import java.io.InputStream;

import org.apache.commons.lang.StringUtils;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;

import com.comtop.cap.document.word.docmodel.datatype.GraphicType;
import com.comtop.cap.document.word.docmodel.style.Rectify;
import com.comtop.cip.json.annotation.JSONField;

/**
 * 图片
 *
 * @author lizhongwen
 * @since jdk1.6
 * @version 2015年10月15日 lizhongwen
 */
public class Graphic extends SimplexSeg {
	
	/**
	 * log
	 */
	protected static final Logger LOGGER = LoggerFactory.getLogger(Graphic.class);
    
    /** 类序列号 */
    private static final long serialVersionUID = 1L;
    
    /** 预览图宽度（单位为:PT） */
    @JSONField(serialize = false)
    private float widthPt;
    
    /** 预览图宽度（单位为:Twip） */
    @JSONField(serialize = false)
    private long widthTwip;
    
    /** 预览图高度（单位为:PT） */
    @JSONField(serialize = false)
    private float heightPt;
    
    /** 预览图高度（单位为:Twip） */
    @JSONField(serialize = false)
    private long heightTwip;
    
    /** 图片文件路径 */
    private String path;
    
    /** 文件Web路径 */
    private String webPath;
    
    /** 宽度,单位（厘米） */
    private float width;
    
    /** 高度,单位（厘米） */
    private float height;
    
    /** 宽度,单位（EMU） */
    @JSONField(serialize = false)
    private long widthAsEMU;
    
    /** 高度,单位（EMU） */
    @JSONField(serialize = false)
    private long heightAsEMU;
    
    /** 图片描述 */
    private String description;
    
    /** 后缀 */
    private String subfix;
    
    /** 文件类型 */
    private GraphicType graphicType;
    
    /** 文档中获取的文件类型 */
    private String type;
    
    /** 图片裁剪 */
    @JSONField(serialize = false)
    public Rectify rectify;
    
    /** 文档输入流 */
    private InputStream input;
    
    /**
     * 构造函数
     */
    public Graphic() {
        super();
    }
    
    /**
     * 构造函数
     * 
     * @param path 文件路径
     */
    public Graphic(String path) {
        this.path = path;
    }
    
    /**
     * 构造函数
     * 
     * @param input 输入流
     */
    public Graphic(InputStream input) {
        this.input = input;
    }
    
    /**
     * 构造函数
     * 
     * @param path 文件路径
     * @param width 宽度
     * @param height 高度
     */
    public Graphic(String path, Float width, Float height) {
        this(path, null, width, height);
    }
    
    /**
     * 构造函数
     * 
     * @param input 文件路径
     * @param width 宽度
     * @param height 高度
     */
    public Graphic(InputStream input, Float width, Float height) {
        this(input, null, width, height);
    }
    
    /**
     * 构造函数
     * 
     * @param path 文件路径
     * @param name 名称
     * @param width 宽度
     * @param height 高度
     */
    public Graphic(String path, String name, Float width, Float height) {
        this(path);
        this.setName(name);
        this.setWidth(width);
        this.setHeight(height);
    }
    
    /**
     * 构造函数
     * 
     * @param input 文件路径
     * @param name 名称
     * @param width 宽度
     * @param height 高度
     */
    public Graphic(InputStream input, String name, Float width, Float height) {
        this.input = input;
        this.setName(name);
        this.setWidth(width);
        this.setHeight(height);
    }
    
    /**
     * @return 获取 path属性值
     */
    public String getPath() {
        return path;
    }
    
    /**
     * @param path 设置 path 属性值为参数值 path
     */
    public void setPath(String path) {
        this.path = path;
    }
    
    /**
     * @return 获取 webPath属性值
     */
    public String getWebPath() {
        return webPath;
    }
    
    /**
     * @param webPath 设置 webPath 属性值为参数值 webPath
     */
    public void setWebPath(String webPath) {
        this.webPath = webPath;
    }
    
    /**
     * @return 获取 subfix属性值
     */
    public String getSubfix() {
        return subfix;
    }
    
    /**
     * @param subfix 设置 subfix 属性值为参数值 subfix
     */
    public void setSubfix(String subfix) {
        this.subfix = subfix;
    }
    
    /**
     * @return 获取 name属性值
     */
    @Override
    public String getName() {
        String name = super.getName();
        if (StringUtils.isBlank(name)) {
            name = this.getNameByPath();
            setName(name);
        }
        return name;
    }
    
    /**
     * @return 获取 width属性值
     */
    public Float getWidth() {
        return width;
    }
    
    /**
     * @param width 设置 width 属性值为参数值 width
     */
    public void setWidth(Float width) {
        if (width == null) {
            this.width = 15.5f;
        } else {
            this.width = width;
        }
        this.widthAsEMU = cmToEMU(this.width);
        this.widthPt = cmToPT(this.width);
        this.widthTwip = mmToTwip(cmToMM(this.width));
    }
    
    /**
     * @return 获取 宽度在Word中的数值
     */
    public long getWidthAsEMU() {
        return widthAsEMU;
    }
    
    /**
     * @param widthAsEMU 设置 widthAsEMU 属性值为参数值 widthAsEMU
     */
    public void setWidthAsEMU(long widthAsEMU) {
        this.widthAsEMU = widthAsEMU;
        this.width = emuToCm(widthAsEMU);
        this.widthPt = cmToPT(width);
        this.widthTwip = mmToTwip(cmToMM(width));
    }
    
    /**
     * @param heightAsEMU 设置 heightAsEMU 属性值为参数值 heightAsEMU
     */
    public void setHeightAsEMU(long heightAsEMU) {
        this.heightAsEMU = heightAsEMU;
        this.height = emuToCm(heightAsEMU);
        this.heightPt = cmToPT(height);
        this.heightTwip = mmToTwip(cmToMM(height));
    }
    
    /**
     * @return 获取 height属性值
     */
    public Float getHeight() {
        return height;
    }
    
    /**
     * @param height 设置 height 属性值为参数值 height
     */
    public void setHeight(Float height) {
        if (height == null) {
            this.height = 10f;
        } else {
            this.height = height;
        }
        this.heightAsEMU = cmToEMU(this.height);
        this.heightPt = cmToPT(this.height);
        this.heightTwip = mmToTwip(cmToMM(this.height));
    }
    
    /**
     * @return 获取 宽度在Word中的数值
     */
    public long getHeightAsEMU() {
        return heightAsEMU;
    }
    
    /**
     * @return 获取 width属性值,单位转换为PT
     */
    public Float getWidthAsPt() {
        return this.widthPt;
    }
    
    /**
     * @param widthPt 设置 widthPt 属性值为参数值 widthPt
     */
    public void setWidthPt(float widthPt) {
        this.widthPt = widthPt;
        this.width = pt2cm(widthPt);
        this.widthAsEMU = cmToEMU(width);
        this.widthTwip = mmToTwip(cmToMM(width));
    }
    
    /**
     * @param heightPt 设置 heightPt 属性值为参数值 heightPt
     */
    public void setHeightPt(float heightPt) {
        this.heightPt = heightPt;
        this.height = pt2cm(heightPt);
        this.heightAsEMU = cmToEMU(height);
        this.heightTwip = mmToTwip(cmToMM(height));
    }
    
    /**
     * @return 获取 width属性值,单位转换为Twip
     */
    public long getWidthAsTwip() {
        return this.widthTwip;
    }
    
    /**
     * @return 获取 height属性值,单位转换为PT
     */
    public Float getHeightAsPt() {
        return heightPt;
    }
    
    /**
     * @return 获取 height属性值,单位转换为Twip
     */
    public long getHeightAsTwip() {
        return heightTwip;
    }
    
    /**
     * @return 获取 description属性值
     */
    public String getDescription() {
        return description;
    }
    
    /**
     * @param description 设置 description 属性值为参数值 description
     */
    public void setDescription(String description) {
        this.description = description;
    }
    
    /**
     * @return 获取 format属性值
     */
    public GraphicType getGraphicType() {
        if (graphicType == null) {
            graphicType = this.getFormatByPath();
        }
        return graphicType;
    }
    
    /**
     * @param graphicType 设置 graphicType 属性值为参数值 graphicType
     */
    public void setGraphicType(GraphicType graphicType) {
        this.graphicType = graphicType;
    }
    
    /**
     * 根据文件路径获取文件名称
     * 
     * @return 文件名称
     */
    private String getNameByPath() {
        String cleanPath = this.path.replace('\\', '/');
        int lastFolderIndex = cleanPath.lastIndexOf('/') + 1;
        int subfixIndex = cleanPath.lastIndexOf('.');
        return cleanPath.substring(lastFolderIndex, subfixIndex);
    }
    
    /**
     * 根据文件路径获取文件名称
     * 
     * @return 文件名称
     */
    private GraphicType getFormatByPath() {
        if (StringUtils.isBlank(subfix)) {
            String cleanPath = this.path.replace('\\', '/');
            int subfixIndex = cleanPath.lastIndexOf('.') + 1;
            subfix = cleanPath.substring(subfixIndex);
        }
        return GraphicType.formatBySubfix(subfix);
    }
    
    /**
     * @return 获取 rectify属性值
     */
    public Rectify getRectify() {
        return rectify;
    }
    
    /**
     * @param rectify 设置 rectify 属性值为参数值 rectify
     */
    public void setRectify(Rectify rectify) {
        this.rectify = rectify;
    }
    
    /**
     * 获取裁剪字符串
     *
     * @return 裁剪字符串
     */
    public String getRectifyString() {
        String str = "";
        if (this.rectify != null) {
            str = this.rectify.toString();
        }
        return str;
    }
    
    /**
     * @return 获取 type属性值
     */
    public String getType() {
        return type;
    }
    
    /**
     * @param type 设置 type 属性值为参数值 type
     */
    public void setType(String type) {
        this.type = type;
    }
    
    // /**
    // * @return 获取 relativePath属性值
    // */
    // public String getRelativePath() {
    // return relativePath;
    // }
    //
    // /**
    // * @param relativePath 设置 relativePath 属性值为参数值 relativePath
    // */
    // public void setRelativePath(String relativePath) {
    // this.relativePath = relativePath;
    // }
    
    @Override
    public String getContent() {
        StringBuffer sbBuffer = new StringBuffer();
        sbBuffer.append("<img ");
        sbBuffer.append(" src='").append(this.getWebPath()).append("'");
        sbBuffer.append(" height='").append(this.getHeightAsPt()).append("'");
        sbBuffer.append(" width='").append(this.getWidthAsPt()).append("'");
        // sbBuffer.append(" path='").append(this.getPath()).append("'");
        sbBuffer.append("/>");
        content = sbBuffer.toString();
        return content;
    }
    
    /**
     * @return 获取 input属性值
     */
    public InputStream getInput() {
        return input;
    }
    
    /**
     * @return 获取 input属性值
     */
    public InputStream toInputStream() {
        if (this.input == null && StringUtils.isNotBlank(path)) {
            try {
                this.input = new FileInputStream(path);
            } catch (FileNotFoundException e) {
            	LOGGER.debug("to inputStram error, fileNotFound:{}. ", path, e);
                this.input = null;
            }
        }
        return input;
    }
}
