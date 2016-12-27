/******************************************************************************
 * Copyright (C) 2016 ShenZhen ComTop Information Technology Co.,Ltd
 * All Rights Reserved.
 * 本软件为深圳康拓普开发研制。未经本公司正式书面同意，其他任何个人、团体不得使用、
 * 复制、修改或发布本软件.
 *****************************************************************************/

package com.comtop.cap.doc.biz.convert;

import com.comtop.cap.doc.biz.model.BizProcessNodeDTO;
import com.comtop.cap.doc.biz.model.BizRelationDTO;
import com.comtop.cap.document.word.docmodel.data.WordDocument;

/**
 * 数据转换器工具类
 *
 * @author lizhiyong
 * @since jdk1.6
 * @version 2016年1月25日 lizhiyong
 */
public class BizRelationConverter {
    
    /**
     * 构造函数
     */
    private BizRelationConverter() {
        //
    }
    
    /**
     * 从节点约束时抽取信息转换为节点对象
     *
     * @param bizRelation 约束
     * @param document 文档对象
     * @return 节点DTO
     */
    public static BizProcessNodeDTO convert2ProcessNode(BizRelationDTO bizRelation, WordDocument document) {
        BizProcessNodeDTO nodeDTO = new BizProcessNodeDTO();
        nodeDTO.setBizItemId(bizRelation.getRoleaItemId());
        nodeDTO.setBizItemName(bizRelation.getRoleaItemName());
        nodeDTO.setProcessId(bizRelation.getRoleaProcessId());
        nodeDTO.setProcessName(bizRelation.getRoleaProcessName());
        nodeDTO.setName(bizRelation.getRoleaNodeName());
        nodeDTO.setSerialNo(bizRelation.getRoleaNodeSerialNo());
        nodeDTO.setDataFrom(bizRelation.getDataFrom());
        nodeDTO.setDomainId(bizRelation.getDomainId());
        nodeDTO.setDocumentId(bizRelation.getDocumentId());
        nodeDTO.setContainer(bizRelation.getContainer());
        nodeDTO.setId(bizRelation.getRoleaNodeId());
        return nodeDTO;
    }
}
