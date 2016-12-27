/******************************************************************************
 * Copyright (C) 2016 ShenZhen ComTop Information Technology Co.,Ltd
 * All Rights Reserved.
 * 本软件为深圳康拓普开发研制。未经本公司正式书面同意，其他任何个人、团体不得使用、
 * 复制、修改或发布本软件.
 *****************************************************************************/

package com.comtop.cap.doc.biz.convert;

import com.comtop.cap.doc.biz.model.BizFormDTO;
import com.comtop.cap.doc.biz.model.BizFormNodeDTO;
import com.comtop.cap.doc.biz.model.BizProcessNodeDTO;
import com.comtop.cap.document.word.docmodel.data.WordDocument;

/**
 * 数据转换器工具类
 *
 * @author lizhiyong
 * @since jdk1.6
 * @version 2016年1月25日 lizhiyong
 */
public class BizFormNodeRelConverter {
    
    /**
     * 构造函数
     */
    private BizFormNodeRelConverter() {
        //
    }
    
    /**
     * 从节点约束时抽取信息转换为节点对象
     *
     * @param bizFormNodeDTO 约束
     * @param document 文档对象
     * @return 节点DTO
     */
    public static BizFormDTO convert2BizForm(BizFormNodeDTO bizFormNodeDTO, WordDocument document) {
        BizFormDTO bizFormDTO = new BizFormDTO();
        bizFormDTO.setName(bizFormNodeDTO.getFormName());
        bizFormDTO.setId(bizFormNodeDTO.getFormId());
        bizFormDTO.setCode(bizFormNodeDTO.getFormCode());
        bizFormDTO.setDomainId(bizFormNodeDTO.getDomainId());
        bizFormDTO.setDocumentId(bizFormNodeDTO.getDocumentId());
        bizFormDTO.setDataFrom(bizFormNodeDTO.getDataFrom());
        return bizFormDTO;
    }
    
    /**
     * 从节点约束时抽取信息转换为节点对象
     *
     * @param bizFormNodeDTO 约束
     * @param document 文档对象
     * @return 节点DTO
     */
    public static BizProcessNodeDTO convert2ProcessNode(BizFormNodeDTO bizFormNodeDTO, WordDocument document) {
        BizProcessNodeDTO nodeDTO = new BizProcessNodeDTO();
        nodeDTO.setBizItemName(bizFormNodeDTO.getBizItemName());
        nodeDTO.setProcessName(bizFormNodeDTO.getProcessName());
        nodeDTO.setBizItemId(bizFormNodeDTO.getBizItemId());
        nodeDTO.setProcessId(bizFormNodeDTO.getProcessId());
        nodeDTO.setName(bizFormNodeDTO.getNodeName());
        nodeDTO.setSerialNo(bizFormNodeDTO.getNodeSerialNo());
        nodeDTO.setDataFrom(bizFormNodeDTO.getDataFrom());
        nodeDTO.setDomainId(bizFormNodeDTO.getDomainId());
        nodeDTO.setDocumentId(bizFormNodeDTO.getDocumentId());
        nodeDTO.setContainer(bizFormNodeDTO.getContainer());
        nodeDTO.setId(bizFormNodeDTO.getNodeId());
        return nodeDTO;
    }
}
