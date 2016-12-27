/******************************************************************************
 * Copyright (C) 2015 ShenZhen ComTop Information Technology Co.,Ltd
 * All Rights Reserved.
 * 本软件为深圳康拓普开发研制。未经本公司正式书面同意，其他任何个人、团体不得使用、
 * 复制、修改或发布本软件.
 *****************************************************************************/

package com.comtop.cap.doc.service;

import com.comtop.cap.doc.DocServiceException;
import com.comtop.cap.doc.biz.BizModelImportProcessor;

/**
 * 文档类型
 *
 * @author lizhiyong
 * @since jdk1.6
 * @version 2015年12月23日 lizhiyong
 */
public enum DocType {
    
    /** 业务模型说明书 */
    BIZ_MODEL("业务模型说明书", BizModelImportProcessor.class),
    
    /** 概要设计说明书 */
    HLD("概要设计说明书", null),
    
    /** 需求规格说明书 */
    SRS("需求规格说明书", null),
    
    /** 详细设计说明书 */
    LLD("详细设计说明书", null),
    
    /** 数据库设计说明书 */
    DBD("数据库设计说明书", null);
    
    /** 中文名称 */
    private String cnName;
    
    /** 文档处理器 */
    private Class<? extends IDocDataProcessor> docDataProcessor;
    
    /**
     * 构造函数
     * 
     * @param cnName 中文名称
     * @param docDataProcessor 文档处理器
     */
    private DocType(String cnName, Class<? extends IDocDataProcessor> docDataProcessor) {
        this.cnName = cnName;
        this.docDataProcessor = docDataProcessor;
    }
    
    /**
     * @return 获取 cnName属性值
     */
    public String getCnName() {
        return cnName;
    }
    
    /**
     * @return 获取 docDataProcessor属性值
     */
    public Class<? extends IDocDataProcessor> getDocDataProcessor() {
        return docDataProcessor;
    }
    
    /**
     * 获得DocType
     *
     * @param docType 字符串形式的DocType
     * @return DocType
     */
    public static DocType getDocType(String docType) {
        DocType type = DocType.valueOf(docType);
        if (type == null) {
            throw new DocServiceException("不支持的文档类型：docType=" + docType);
        }
        return type;
    }
}
