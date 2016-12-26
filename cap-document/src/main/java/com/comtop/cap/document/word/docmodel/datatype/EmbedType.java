/******************************************************************************
 * Copyright (C) 2015 ShenZhen ComTop Information Technology Co.,Ltd
 * All Rights Reserved.
 * 本软件为深圳康拓普开发研制。未经本公司正式书面同意，其他任何个人、团体不得使用、
 * 复制、修改或发布本软件.
 *****************************************************************************/

package com.comtop.cap.document.word.docmodel.datatype;

import org.apache.commons.lang.StringUtils;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;

/**
 * 文件类型
 *
 * @author lizhongwen
 * @since jdk1.6
 * @version 2015年10月23日 lizhongwen
 */
public enum EmbedType {
    /** Excel-2007以上版本 */
    XLSX("application/vnd.openxmlformats-officedocument.spreadsheetml.sheet",
        "http://schemas.openxmlformats.org/officeDocument/2006/relationships/package", ".xlsx", "Excel.sheet.12",
        "Microsoft_Office_Excel____${index}.xlsx"),
    /** Excel 2003-2007 file以上版本 */
    XLS("application/vnd.ms-excel", "http://schemas.openxmlformats.org/officeDocument/2006/relationships/oleObject",
        ".xls", "Excel.Sheet.8", "Microsoft_Office_Excel_97-2003____${index}.xls"),
    /** Visio */
    VSD("application/vnd.visio", "http://schemas.openxmlformats.org/officeDocument/2006/relationships/oleObject",
        ".vsd", "Visio.Drawing.11", "Microsoft_Visio_2003-2010___${index}.vsd"),
    /** Visio */
    VSDX("application/vnd.ms-visio.drawing",
        "http://schemas.openxmlformats.org/officeDocument/2006/relationships/package", ".vsdx", "Visio.Drawing.15",
        "Microsoft_Visio___${index}.vsdx"),
    /** UNKNOWN */
    UNKNOWN("application/vnd.openxmlformats-officedocument.oleObject",
        "http://schemas.openxmlformats.org/officeDocument/2006/relationships/oleObject", ".bin", "UNKNOWN",
        "oleObject${index}.bin");
	
	/**
     * logger
     */
    protected static final Logger LOGGER = LoggerFactory.getLogger(EmbedType.class);
    
    // /** word 2003及之前版本 */
    // DOC,
    //
    // /** word 2007及之后版本 */
    // DOCX,
    //
    // /** PPT 2003及之前版本 */
    // PPT,
    //
    // /** PPT 2007及之后版本 */
    // PPTX;
    /** 内容类型 */
    private String contentType;
    
    /** 包装类型 */
    private String packageType;
    
    /** 后缀 */
    private String subfix;
    
    /** 应用ID */
    private String progId;
    
    /** 文件名称模板 */
    private String nameTemplate;
    
    /**
     * 构造函数
     * 
     * @param contentType 内容类型
     * @param packageType 包装类型
     * @param subfix 后缀
     * @param progId 应用ID
     * @param nameTemplate 文件名称模板
     */
    private EmbedType(String contentType, String packageType, String subfix, String progId, String nameTemplate) {
        this.contentType = contentType;
        this.packageType = packageType;
        this.subfix = subfix;
        this.progId = progId;
        this.nameTemplate = nameTemplate;
    }
    
    /**
     * @return 获取 progId属性值
     */
    public String getProgId() {
        return progId;
    }
    
    /**
     * @return 获取 contentType属性值
     */
    public String getContentType() {
        return contentType;
    }
    
    /**
     * @return 获取 packageType属性值
     */
    public String getPackageType() {
        return packageType;
    }
    
    /**
     * @return 获取 subfix属性值
     */
    public String getSubfix() {
        return subfix;
    }
    
    /**
     * @return 获取 nameTemplate属性值
     */
    public String getNameTemplate() {
        return nameTemplate;
    }
    
    /**
     * xxx
     *
     * @param progID xxx
     * @return xxx
     */
    public static EmbedType byProgId(final String progID) {
        if (StringUtils.isBlank(progID)) {
            return UNKNOWN;
        }
        String[] parts = progID.split("[\\.]");
        if (parts == null || parts.length < 3) {
            return UNKNOWN;
        }
        int version;
        try {
            version = Integer.parseInt(parts[2]);
        } catch (NumberFormatException e) {
        	LOGGER.debug("Number format error:{}", parts[2], e);
            return UNKNOWN;
        }
        if ("Excel".equalsIgnoreCase(parts[0])) {
            if (version >= 12) {
                return XLSX;
            }
            return XLS;
        } else if ("Visio".equals(parts[0])) {
            if (version >= 15) {
                return VSDX;
            }
            return VSD;
        }
        return UNKNOWN;
    }
    
}
