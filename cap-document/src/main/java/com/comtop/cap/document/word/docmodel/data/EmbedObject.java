/******************************************************************************
 * Copyright (C) 2014 ShenZhen ComTop Information Technology Co.,Ltd
 * All Rights Reserved.
 * 本软件为深圳康拓普开发研制。未经本公司正式书面同意，其他任何个人、团体不得使用、
 * 复制、修改或发布本软件.
 *****************************************************************************/

package com.comtop.cap.document.word.docmodel.data;

import java.io.FileInputStream;
import java.io.FileNotFoundException;
import java.io.InputStream;

import org.apache.commons.lang.StringUtils;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;

import com.comtop.cap.document.word.docmodel.datatype.EmbedType;

/**
 * 嵌入式文件
 *
 * @author lizhongwen
 * @since jdk1.6
 * @version 2015年10月16日 lizhongwen
 */
public class EmbedObject extends SimplexSeg {
    
    /** 类序列号 */
    private static final long serialVersionUID = 1L;
    
    /**
     * logger
     */
    protected static final Logger LOGGER = LoggerFactory.getLogger(EmbedObject.class);
    
    /** 文件路径 */
    private String path;
    
    /** 文件类型 */
    private EmbedType embedType;
    
    /** 文档中获取的类型 */
    private String type;
    
    /** 后缀名 */
    private String subfix;
    
    /** 预览图 */
    private Graphic picture;
    
    /** 预览图 */
    private String progId;
    
    /** 相对上下文的路径 */
    private String webPath;
    
    /** 缺省的图片相对上下文路径 */
    private String defaultIconRelativePath;
    
    /** 文档输入流 */
    private InputStream input;
    
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
     * 构造函数
     * 
     */
    public EmbedObject() {
    }
    
    /**
     * 构造函数
     * 
     * @param path 文件路径
     * @param embedType 文件类型
     * @param picture 预览图
     */
    public EmbedObject(String path, EmbedType embedType, Graphic picture) {
        super();
        this.path = path;
        this.embedType = embedType;
        this.picture = picture;
    }
    
    /**
     * 构造函数
     * 
     * @param input 文档输入流
     * @param embedType 文件类型
     * @param picture 预览图
     */
    public EmbedObject(InputStream input, EmbedType embedType, Graphic picture) {
        super();
        this.input = input;
        this.embedType = embedType;
        this.picture = picture;
    }
    
    /**
     * @return 获取 progId属性值
     */
    public String getProgId() {
        return progId;
    }
    
    /**
     * @param progId 设置 progId 属性值为参数值 progId
     */
    public void setProgId(String progId) {
        this.progId = progId;
    }
    
    /**
     * 构造函数
     * 
     * @param path 文件路径
     */
    public EmbedObject(String path) {
        this.path = path;
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
    
    // /**
    // * @return 获取 dataUri属性值
    // */
    // public URI getDataUri() {
    // return dataUri;
    // }
    //
    // /**
    // * @param dataUri 设置 dataUri 属性值为参数值 dataUri
    // */
    // public void setDataUri(URI dataUri) {
    // this.dataUri = dataUri;
    // }
    
    /**
     * @return 获取 type属性值
     */
    public EmbedType getEmbedType() {
        if (this.embedType == null) {
            this.embedType = getTypeBySubfix();
        }
        return embedType;
    }
    
    /**
     * 根据后缀名获取文件类型
     * 
     * @return 文件类型
     */
    private EmbedType getTypeBySubfix() {
        if (StringUtils.isBlank(subfix)) {
            this.getSubfixByPath();
        }
        if ("xlsx".equalsIgnoreCase(subfix)) {
            return EmbedType.XLSX;
        } else if ("xls".equalsIgnoreCase(subfix)) {
            return EmbedType.XLS;
        } else if ("vsdx".equalsIgnoreCase(subfix)) {
            return EmbedType.VSDX;
        } else if ("vsd".equalsIgnoreCase(subfix)) {
            return EmbedType.VSD;
        }
        return null;
    }
    
    /**
     * @param embedType 设置 embedType 属性值为参数值 embedType
     */
    public void setEmbedType(EmbedType embedType) {
        this.embedType = embedType;
    }
    
    /**
     * @return 获取 picture属性值
     */
    public Graphic getPicture() {
        return picture;
    }
    
    /**
     * @param picture 设置 picture 属性值为参数值 picture
     */
    public void setPicture(Graphic picture) {
        this.picture = picture;
    }
    
    /**
     * 根据文件后缀名
     * 
     * @return 文件名称
     */
    public String getSubfixByPath() {
        if (StringUtils.isBlank(subfix)) {
            String cleanPath = this.path.replace('\\', '/');
            int subfixIndex = cleanPath.lastIndexOf('.') + 1;
            subfix = cleanPath.substring(subfixIndex);
        }
        return subfix;
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
    
    @Override
    public String getContent() {
        StringBuffer sbBuffer = new StringBuffer();
        sbBuffer.append("<a href='").append(this.webPath).append("'> ");
        // sbBuffer.append("path='").append(path).append("'>\r\n");
        sbBuffer.append("<img ");
        if (picture != null) {
            sbBuffer.append(" src='").append(picture.getWebPath()).append("'");
            // sbBuffer.append(" path='").append(picture.getPath()).append("'");
            sbBuffer.append(" height='").append(picture.getHeightAsPt()).append("'");
            sbBuffer.append(" width='").append(picture.getWidthAsPt()).append("'");
            sbBuffer.append("/>");
        } else {
            /** 图片配置 */
            // GraphicConfig graphicConfig = GraphicConfig.getInstance();
            // String iconPath = graphicConfig.getDefaultIconPath(subfix);
            sbBuffer.append(" src='").append(defaultIconRelativePath).append("'");
            // sbBuffer.append(" path='").append(defaultIconPath).append("'");
            // sbBuffer.append(" height='").append(picture.getHeightAsPt()).append("'");
            // sbBuffer.append(" width='").append(picture.getWidthAsPt()).append("'");
            sbBuffer.append("/>");
            sbBuffer.append(this.getName());
        }
        sbBuffer.append("</a>");
        content = sbBuffer.toString();
        return content;
    }
    
    /**
     * @return 获取 defaultIconRelativePath属性值
     */
    public String getDefaultIconRelativePath() {
        return defaultIconRelativePath;
    }
    
    /**
     * @param defaultIconRelativePath 设置 defaultIconRelativePath 属性值为参数值 defaultIconRelativePath
     */
    public void setDefaultIconRelativePath(String defaultIconRelativePath) {
        this.defaultIconRelativePath = defaultIconRelativePath;
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
