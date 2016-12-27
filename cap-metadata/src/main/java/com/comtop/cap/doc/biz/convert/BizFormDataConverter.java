/******************************************************************************
 * Copyright (C) 2016 ShenZhen ComTop Information Technology Co.,Ltd
 * All Rights Reserved.
 * 本软件为深圳康拓普开发研制。未经本公司正式书面同意，其他任何个人、团体不得使用、
 * 复制、修改或发布本软件.
 *****************************************************************************/

package com.comtop.cap.doc.biz.convert;

import com.comtop.cap.doc.biz.model.BizFormDTO;
import com.comtop.cap.doc.biz.model.BizFormDataItemDTO;
import com.comtop.cap.document.word.docmodel.data.WordDocument;

/**
 * 数据转换器工具类
 *
 * @author lizhiyong
 * @since jdk1.6
 * @version 2016年1月25日 lizhiyong
 */
public class BizFormDataConverter {
    
    /**
     * 构造函数
     */
    private BizFormDataConverter() {
        //
    }
    
    /**
     * 从节点约束时抽取信息转换为节点对象
     *
     * @param bizFormDataDTO 约束
     * @param document 文档对象
     * @return 节点DTO
     */
    public static BizFormDTO convert2BizForm(BizFormDataItemDTO bizFormDataDTO, WordDocument document) {
        BizFormDTO bizFormDTO = new BizFormDTO();
        bizFormDTO.setName(bizFormDataDTO.getObjectName());
        bizFormDTO.setId(bizFormDataDTO.getObjectId());
        bizFormDTO.setCode(bizFormDataDTO.getObjectCode());
        bizFormDTO.setPackageId(bizFormDataDTO.getObjectPackageId());
        bizFormDTO.setDomainId(bizFormDataDTO.getDomainId());
        bizFormDTO.setDocumentId(bizFormDataDTO.getDocumentId());
        bizFormDTO.setDataFrom(bizFormDataDTO.getDataFrom());
        bizFormDTO.setPackageName(bizFormDataDTO.getObjectPackageName());
        return bizFormDTO;
    }
}
