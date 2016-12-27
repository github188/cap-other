/******************************************************************************
 * Copyright (C) 2015 ShenZhen ComTop Information Technology Co.,Ltd
 * All Rights Reserved.
 * 本软件为深圳康拓普开发研制。未经本公司正式书面同意，其他任何个人、团体不得使用、
 * 复制、修改或发布本软件.
 *****************************************************************************/

package com.comtop.cap.doc.service;

import java.text.MessageFormat;

import com.comtop.cap.doc.biz.model.BizFormDTO;
import com.comtop.cap.doc.biz.model.BizFormDataItemDTO;
import com.comtop.cap.doc.biz.model.BizItemDTO;
import com.comtop.cap.doc.biz.model.BizNodeConstraintDTO;
import com.comtop.cap.doc.biz.model.BizObjectDTO;
import com.comtop.cap.doc.biz.model.BizObjectDataItemDTO;
import com.comtop.cap.doc.biz.model.BizProcessDTO;
import com.comtop.cap.doc.biz.model.BizProcessNodeDTO;
import com.comtop.cap.doc.biz.model.BizRelationDTO;
import com.comtop.cap.doc.biz.model.BizRelationDataItemDTO;
import com.comtop.cap.document.word.docmodel.data.BaseDTO;
import com.comtop.cap.document.word.parse.check.AbstractCheckLogger;
import com.comtop.cap.document.word.parse.check.ILogRecorder;

/**
 * 数据检查日志
 *
 * @author lizhiyong
 * @since jdk1.6
 * @version 2015年12月21日 lizhiyong
 */
public class DataCheckLogger extends AbstractCheckLogger {
    
    /** 消息样式常量 */
    public static final String MESSAGES_TYLE = "{0}{1}【当前{2}】:{3}.位置:{4}";
    
    /** 业务事项 */
    public static final String NAME_BIZ_ITEM = "业务事项";
    
    /** 业务流程 */
    public static final String NAME_BIZ_PROCESS = "业务流程";
    
    /** 流程节点 */
    public static final String NAME_BIZ_PROCESS_NODE = "流程节点";
    
    /** 业务角色 */
    public static final String NAME_BIZ_ROLE = "业务角色";
    
    /** 业务关联 */
    public static final String NAME_BIZ_RELATION = "业务关联";
    
    /** 业务对象 */
    public static final String NAME_BIZ_OBJECT = "业务对象";
    
    /** 业务表单 */
    public static final String NAME_BIZ_FORM = "业务表单";
    
    /** 业务对象数据项 */
    public static final String NAME_BIZ_OBJECT_DATA = "业务对象数据项";
    
    /** 业务表单数据项 */
    public static final String NAME_BIZ_FORM_DATA = "业务表单数据项";
    
    /** 业务关联数据项 */
    public static final String NAME_BIZ_RELATION_DATA = "业务关联数据项";
    
    /** 业务节点约束 */
    public static final String NAME_BIZ_NODE_CONSTRAINT = "业务节点约束";
    
    /**
     * 构造函数
     * 
     * @param logRecorder 日志记录器
     */
    public DataCheckLogger(ILogRecorder logRecorder) {
        super(logRecorder);
    }
    
    /**
     * 业务事项错误
     *
     * @param data 业务事项DTO
     * @param message 消息
     */
    public void errorBizItemDTO(BizItemDTO data, String message) {
        outputErrorMessage(message, NAME_BIZ_ITEM, data.getName(), data);
    }
    
    /**
     * 业务事项错误
     *
     * @param data 业务事项DTO
     * @param message 消息
     */
    public void warnBizItemDTO(BizItemDTO data, String message) {
        outputWarnMessage(message, NAME_BIZ_ITEM, data.getName(), data);
    }
    
    /**
     * 业务事项错误
     *
     * @param data 业务事项DTO
     * @param message 消息
     */
    public void errorBizProcessDTO(BizProcessDTO data, String message) {
        outputErrorMessage(message, NAME_BIZ_PROCESS, data.getProcessName(), data);
    }
    
    /**
     * 业务事项错误
     *
     * @param data 业务事项DTO
     * @param message 消息
     */
    public void warnBizProcessDTO(BizProcessDTO data, String message) {
        outputWarnMessage(message, NAME_BIZ_PROCESS, data.getProcessName(), data);
    }
    
    /**
     * 业务事项错误
     *
     * @param data 业务事项DTO
     * @param message 消息
     */
    public void errorBizProcessNodeDTO(BizProcessNodeDTO data, String message) {
        outputErrorMessage(message, NAME_BIZ_PROCESS_NODE, data.getName(), data);
    }
    
    /**
     * 业务事项错误
     *
     * @param data 业务事项DTO
     * @param message 消息
     */
    public void warnBizProcessNodeDTO(BizProcessNodeDTO data, String message) {
        outputWarnMessage(message, NAME_BIZ_PROCESS_NODE, data.getName(), data);
    }
    
    /**
     * 业务事项错误
     *
     * @param data 业务事项DTO
     * @param message 消息
     */
    public void errorBizObjectDTO(BizObjectDTO data, String message) {
        outputErrorMessage(message, NAME_BIZ_OBJECT, data.getName(), data);
    }
    
    /**
     * 业务事项错误
     *
     * @param data 业务事项DTO
     * @param message 消息
     */
    public void warnBizObjectDTO(BizObjectDTO data, String message) {
        outputWarnMessage(message, NAME_BIZ_OBJECT, data.getName(), data);
    }
    
    /**
     * 业务事项错误
     *
     * @param data 业务事项DTO
     * @param message 消息
     */
    public void errorBizFormDTO(BizFormDTO data, String message) {
        outputErrorMessage(message, NAME_BIZ_FORM, data.getName(), data);
    }
    
    /**
     * 业务事项错误
     *
     * @param data 业务事项DTO
     * @param message 消息
     */
    public void warnBizFormDTO(BizFormDTO data, String message) {
        
        outputWarnMessage(message, NAME_BIZ_FORM, data.getName(), data);
    }
    
    /**
     * 业务事项错误
     *
     * @param data 业务事项DTO
     * @param message 消息
     */
    public void errorBizFormDataItemDTO(BizFormDataItemDTO data, String message) {
        outputErrorMessage(message, NAME_BIZ_FORM_DATA, data.getName(), data);
    }
    
    /**
     * 业务事项错误
     *
     * @param data 业务事项DTO
     * @param message 消息
     */
    public void warnBizFormDataItemDTO(BizFormDataItemDTO data, String message) {
        outputWarnMessage(message, NAME_BIZ_FORM_DATA, data.getName(), data);
    }
    
    /**
     * 业务事项错误
     *
     * @param data 业务事项DTO
     * @param message 消息
     */
    public void errorBizObjectDataItemDTO(BizObjectDataItemDTO data, String message) {
        outputErrorMessage(message, NAME_BIZ_OBJECT_DATA, data.getName(), data);
    }
    
    /**
     * 业务事项错误
     *
     * @param data 业务事项DTO
     * @param message 消息
     */
    public void warnBizObjectDataItemDTO(BizObjectDataItemDTO data, String message) {
        
        outputWarnMessage(message, NAME_BIZ_OBJECT_DATA, data.getName(), data);
        
    }
    
    /**
     * 业务事项错误
     *
     * @param data 业务事项DTO
     * @param message 消息
     */
    public void errorBizRelationDataItemDTO(BizRelationDataItemDTO data, String message) {
        outputErrorMessage(message, NAME_BIZ_RELATION_DATA, data.getName(), data);
    }
    
    /**
     * 业务事项错误
     *
     * @param data 业务事项DTO
     * @param message 消息
     */
    public void warnBizRelationDataItemDTO(BizRelationDataItemDTO data, String message) {
        
        outputWarnMessage(message, NAME_BIZ_RELATION_DATA, data.getName(), data);
    }
    
    /**
     * 业务事项错误
     *
     * @param data 业务事项DTO
     * @param message 消息
     */
    public void errorBizRelationDTO(BizRelationDTO data, String message) {
        outputErrorMessage(message, NAME_BIZ_RELATION, data.getName(), data);
    }
    
    /**
     * 业务事项错误
     *
     * @param data 业务事项DTO
     * @param message 消息
     */
    public void warnBizRelationDTO(BizRelationDTO data, String message) {
        outputWarnMessage(message, NAME_BIZ_RELATION, data.getName(), data);
    }
    
    /**
     * 业务事项错误
     *
     * @param data 业务事项DTO
     * @param message 消息
     */
    public void errorBizNodeConstraintDTO(BizNodeConstraintDTO data, String message) {
        outputErrorMessage(message, NAME_BIZ_NODE_CONSTRAINT, data.getName(), data);
    }
    
    /**
     * 业务事项错误
     *
     * @param data 业务事项DTO
     * @param message 消息
     */
    public void warnBizNodeConstraintDTO(BizNodeConstraintDTO data, String message) {
        outputWarnMessage(message, NAME_BIZ_NODE_CONSTRAINT, data.getName(), data);
    }
    
    /**
     * 输出警告消息
     *
     * @param message 消息
     * @param itemName 项名
     * @param objName 对象名
     * @param data 数据
     */
    private void outputWarnMessage(String message, String itemName, String objName, BaseDTO data) {
        String uriName = "";
        if (data.getContainer() != null) {
            uriName = data.getContainer().getUriChain();
        }
        String outMessage = MessageFormat.format(MESSAGES_TYLE, FSTR_WARN, message, itemName, objName, uriName);
        getLogRecorder().output(outMessage);
    }
    
    /**
     * 输出错误消息
     *
     * @param message 消息
     * @param itemName 项名
     * @param objName 对象名
     * @param data 数据
     */
    private void outputErrorMessage(String message, String itemName, String objName, BaseDTO data) {
        String uriName = "";
        if (data.getContainer() != null) {
            uriName = data.getContainer().getUriChain();
        }
        String outMessage = MessageFormat.format(MESSAGES_TYLE, FSTR_ERR, message, itemName, objName, uriName);
        getLogRecorder().output(outMessage);
    }
}
