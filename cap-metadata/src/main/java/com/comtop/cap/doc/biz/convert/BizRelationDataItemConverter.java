/******************************************************************************
 * Copyright (C) 2016 ShenZhen ComTop Information Technology Co.,Ltd
 * All Rights Reserved.
 * 本软件为深圳康拓普开发研制。未经本公司正式书面同意，其他任何个人、团体不得使用、
 * 复制、修改或发布本软件.
 *****************************************************************************/

package com.comtop.cap.doc.biz.convert;

import com.comtop.cap.doc.biz.model.BizObjectDTO;
import com.comtop.cap.doc.biz.model.BizObjectDataItemDTO;
import com.comtop.cap.doc.biz.model.BizRelationDataItemDTO;
import com.comtop.cap.document.word.docmodel.data.WordDocument;

/**
 * 数据转换器工具类
 *
 * @author lizhiyong
 * @since jdk1.6
 * @version 2016年1月25日 lizhiyong
 */
public class BizRelationDataItemConverter {
    
    /**
     * 构造函数
     */
    private BizRelationDataItemConverter() {
        //
    }
    
    /**
     * 从节点约束时抽取信息转换为节点对象
     *
     * @param reldataItemDTO 关联数据项
     * @param document 文档对象
     * @return 节点DTO
     */
    public static BizObjectDataItemDTO convert2BizObjectDataItem(BizRelationDataItemDTO reldataItemDTO,
        WordDocument document) {
        BizObjectDataItemDTO dataItemDTO = new BizObjectDataItemDTO();
        dataItemDTO.setName(reldataItemDTO.getDataItemName());
        dataItemDTO.setObjectName(reldataItemDTO.getObjectName());
        dataItemDTO.setObjectCode(reldataItemDTO.getObjectCode());
        dataItemDTO.setObjectPackageId(reldataItemDTO.getObjectPackageId());
        dataItemDTO.setObjectPackageName(reldataItemDTO.getObjectPackageName());
        dataItemDTO.setId(reldataItemDTO.getDataItemId());
        dataItemDTO.setDomainId(reldataItemDTO.getDomainId());
        dataItemDTO.setDocumentId(reldataItemDTO.getDocumentId());
        dataItemDTO.setCodeNote(reldataItemDTO.getCodeNote());
        dataItemDTO.setDataFrom(reldataItemDTO.getDataFrom());
        dataItemDTO.setObjectId(reldataItemDTO.getObjectId());
        dataItemDTO.setRemark(reldataItemDTO.getRemark());
        dataItemDTO.setDescription(reldataItemDTO.getDescription());
        return dataItemDTO;
    }
    
    /**
     * 从节点约束时抽取信息转换为节点对象
     *
     * @param reldataItemDTO 关联数据项
     * @param document 文档对象
     * @return 节点DTO
     */
    public static BizObjectDTO convert2BizObject(BizRelationDataItemDTO reldataItemDTO, WordDocument document) {
        BizObjectDTO bizObject = new BizObjectDTO();
        bizObject.setName(reldataItemDTO.getObjectName());
        bizObject.setId(reldataItemDTO.getObjectId());
        bizObject.setCode(reldataItemDTO.getObjectCode());
        bizObject.setDomainId(reldataItemDTO.getDomainId());
        bizObject.setDocumentId(reldataItemDTO.getDocumentId());
        bizObject.setDataFrom(reldataItemDTO.getDataFrom());
        bizObject.setPackageId(reldataItemDTO.getObjectPackageId());
        bizObject.setPackageName(reldataItemDTO.getObjectPackageName());
        return bizObject;
    }
}
