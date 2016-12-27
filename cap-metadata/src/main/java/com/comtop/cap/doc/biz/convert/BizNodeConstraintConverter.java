/******************************************************************************
 * Copyright (C) 2016 ShenZhen ComTop Information Technology Co.,Ltd
 * All Rights Reserved.
 * 本软件为深圳康拓普开发研制。未经本公司正式书面同意，其他任何个人、团体不得使用、
 * 复制、修改或发布本软件.
 *****************************************************************************/

package com.comtop.cap.doc.biz.convert;

import com.comtop.cap.doc.biz.model.BizNodeConstraintDTO;
import com.comtop.cap.doc.biz.model.BizObjectDTO;
import com.comtop.cap.doc.biz.model.BizObjectDataItemDTO;
import com.comtop.cap.doc.biz.model.BizProcessNodeDTO;
import com.comtop.cap.document.word.docmodel.data.WordDocument;

/**
 * 数据转换器工具类
 *
 * @author lizhiyong
 * @since jdk1.6
 * @version 2016年1月25日 lizhiyong
 */
public class BizNodeConstraintConverter {
    
    /**
     * 构造函数
     */
    private BizNodeConstraintConverter() {
        //
    }
    
    /**
     * 从节点约束时抽取信息转换为节点对象
     *
     * @param constraintDTO 约束
     * @param document 文档对象
     * @return 节点DTO
     */
    public static BizProcessNodeDTO convert2ProcessNode(BizNodeConstraintDTO constraintDTO, WordDocument document) {
        BizProcessNodeDTO nodeDTO = new BizProcessNodeDTO();
        nodeDTO.setProcessName(constraintDTO.getProcessName());
        nodeDTO.setName(constraintDTO.getNodeName());
        nodeDTO.setSerialNo(constraintDTO.getNodeSerialNo());
        nodeDTO.setDataFrom(constraintDTO.getDataFrom());
        nodeDTO.setDomainId(constraintDTO.getDomainId());
        nodeDTO.setDocumentId(constraintDTO.getDocumentId());
        nodeDTO.setContainer(constraintDTO.getContainer());
        nodeDTO.setProcessId(constraintDTO.getProcessId());
        nodeDTO.setBizItemId(constraintDTO.getBizItemId());
        nodeDTO.setBizItemName(constraintDTO.getBizItemName());
        nodeDTO.setId(constraintDTO.getNodeId());
        return nodeDTO;
    }
    
    /**
     * 从节点约束时抽取信息转换为节点对象
     *
     * @param constraintDTO 约束
     * @param document 文档对象
     * @return 节点DTO
     */
    public static BizObjectDTO convert2BizObject(BizNodeConstraintDTO constraintDTO, WordDocument document) {
        BizObjectDTO bizObjectDTO = new BizObjectDTO();
        bizObjectDTO.setName(constraintDTO.getObjectName());
        bizObjectDTO.setDomainId(constraintDTO.getDomainId());
        bizObjectDTO.setDocumentId(constraintDTO.getDocumentId());
        bizObjectDTO.setDataFrom(constraintDTO.getDataFrom());
        bizObjectDTO.setCode(constraintDTO.getObjectCode());
        bizObjectDTO.setPackageName(constraintDTO.getObjectPackageName());
        bizObjectDTO.setPackageId(constraintDTO.getObjectPackageId());
        return bizObjectDTO;
    }
    
    /**
     * 从节点约束时抽取信息转换为节点对象
     *
     * @param constraintDTO 约束
     * @param document 文档对象
     * @return 节点DTO
     */
    public static BizObjectDataItemDTO convert2BizObjectDataItem(BizNodeConstraintDTO constraintDTO,
        WordDocument document) {
        BizObjectDataItemDTO bizObjectDataItem = new BizObjectDataItemDTO();
        bizObjectDataItem.setObjectId(constraintDTO.getObjectId());
        bizObjectDataItem.setName(constraintDTO.getDataItemName());
        bizObjectDataItem.setDomainId(constraintDTO.getDomainId());
        bizObjectDataItem.setDocumentId(constraintDTO.getDocumentId());
        bizObjectDataItem.setDataFrom(constraintDTO.getDataFrom());
        bizObjectDataItem.setObjectName(constraintDTO.getObjectName());
        bizObjectDataItem.setObjectCode(constraintDTO.getObjectCode());
        bizObjectDataItem.setObjectPackageId(constraintDTO.getObjectPackageId());
        bizObjectDataItem.setObjectPackageName(constraintDTO.getObjectPackageName());
        return bizObjectDataItem;
    }
}
