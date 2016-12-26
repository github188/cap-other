/******************************************************************************
 * Copyright (C) 2016 ShenZhen ComTop Information Technology Co.,Ltd
 * All Rights Reserved.
 * 本软件为深圳康拓普开发研制。未经本公司正式书面同意，其他任何个人、团体不得使用、
 * 复制、修改或发布本软件.
 *****************************************************************************/

package com.comtop.cap.test.definition.model;

import java.util.Map;

import javax.xml.bind.annotation.XmlAttribute;
import javax.xml.bind.annotation.XmlElement;
import javax.xml.bind.annotation.XmlTransient;
import javax.xml.bind.annotation.XmlType;
import javax.xml.bind.annotation.adapters.XmlJavaTypeAdapter;

import org.apache.commons.lang.StringUtils;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;

import com.comtop.cap.bm.metadata.base.model.BaseMetadata;
import com.comtop.cap.common.xml.CDataAdaptor;

import com.comtop.top.core.util.JsonUtil;


import comtop.org.directwebremoting.annotations.DataTransferObject;

/**
 * 控件类型
 *
 * @author lizhongwen
 * @since jdk1.6
 * @version 2016年6月22日 lizhongwen
 */
@XmlType(name = "ctrl")
@DataTransferObject
public class CtrlDefinition extends BaseMetadata {
    
    /** 日志 */
    private final static Logger logger = LoggerFactory.getLogger(CtrlDefinition.class);
    
    /** 添加序列化ID */
    private static final long serialVersionUID = 1L;
    
    /** 控件类型 */
    private String type;
    
    /** 选项 */
    private String options;
    
    /** 脚本 */
    private String script;
    
    /**
     * @return 获取 type属性值
     */
    @XmlAttribute(name = "type")
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
     * @return 获取 options属性值
     */
    @XmlElement(name = "options")
    @XmlJavaTypeAdapter(value = CDataAdaptor.class)
    public String getOptions() {
        return options;
    }
    
    /**
     * @param options 设置 options 属性值为参数值 options
     */
    public void setOptions(String options) {
        this.options = options;
    }
    
    /**
     * @return 获取 optionMap属性值，方便前台使用。
     */
    @XmlTransient
    public Map<?, ?> getOptionMap() {
        if (StringUtils.isBlank(options)) {
            return null;
        }
        Map<?, ?> optionMap = null;
        String cleared = options;
        while (cleared.contains("\r")) {
            cleared = cleared.replace("\r", "");
        }
        while (cleared.contains("\n")) {
            cleared = cleared.replace("\n", "");
        }
        while (cleared.contains("\t")) {
            cleared = cleared.replace("\t", " ");
        }
        while (cleared.contains("  ")) {
            cleared = cleared.replace("  ", " ");
        }
        try {
            optionMap = JsonUtil.jsonToObject(cleared, Map.class);
        } catch (Exception e) {
            logger.debug("转换JSON数据出错。", e);
        }
        return optionMap;
    }
    
    /**
     * @return 获取 script属性值
     */
    @XmlElement(name = "script")
    @XmlJavaTypeAdapter(value = CDataAdaptor.class)
    public String getScript() {
        return script;
    }
    
    /**
     * @param script 设置 script 属性值为参数值 script
     */
    public void setScript(String script) {
        this.script = script;
    }
}
