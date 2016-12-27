/******************************************************************************
 * Copyright (C) 2016 ShenZhen ComTop Information Technology Co.,Ltd
 * All Rights Reserved.
 * 本软件为深圳康拓普开发研制。未经本公司正式书面同意，其他任何个人、团体不得使用、
 * 复制、修改或发布本软件.
 *****************************************************************************/

package com.comtop.cap.doc.srs.convert;

import com.comtop.cap.bm.biz.info.model.BizObjInfoVO;
import com.comtop.cap.doc.biz.model.BizObjectDTO;
import com.comtop.cap.doc.biz.model.BizObjectDataItemDTO;
import com.comtop.cap.doc.srs.model.BizObjectDataItemWithSubitemDTO;
import com.comtop.cap.doc.util.DocDataUtil;
import com.comtop.cap.document.word.docmodel.data.WordDocument;

/**
 * 数据转换器工具类
 *
 * @author lizhiyong
 * @since jdk1.6
 * @version 2016年1月25日 lizhiyong
 */
public final class SubitemConverter {
    
    /**
     * 构造函数
     */
    private SubitemConverter() {
    }
    
    /**
     * 从节点约束时抽取信息转换为节点对象
     *
     * @param subitemData 业务子项数据项
     * @param document 文档对象
     * @return 节点DTO
     */
    public static BizObjectDataItemDTO convert2BizObjectDataItem(BizObjectDataItemWithSubitemDTO subitemData,
        WordDocument document) {
        BizObjectDataItemDTO objDTO = new BizObjectDataItemDTO();
        DocDataUtil.copyProperties(objDTO, subitemData);
        return objDTO;
    }
    
    /**
     * 从节点约束时抽取信息转换为节点对象
     *
     * @param subitemData 业务子项数据项
     * @param document 文档对象
     * @return 节点DTO
     */
    public static BizObjectDTO convert2BizObject(BizObjectDataItemWithSubitemDTO subitemData, WordDocument document) {
        BizObjectDTO objBizObjectDTO = new BizObjectDTO();
        objBizObjectDTO.setName(subitemData.getObjectName());
        objBizObjectDTO.setId(subitemData.getObjectId());
        objBizObjectDTO.setCode(subitemData.getObjectCode());
        objBizObjectDTO.setDescription(subitemData.getObjectDesc());
        objBizObjectDTO.setRemark(subitemData.getObjectDesc());
        objBizObjectDTO.setDomainId(subitemData.getDomainId());
        objBizObjectDTO.setDocumentId(subitemData.getDocumentId());
        objBizObjectDTO.setDataFrom(subitemData.getDataFrom());
        return objBizObjectDTO;
    }
    
    /**
     * 从节点约束时抽取信息转换为节点对象
     *
     * @param subitemData 业务子项数据项
     * @param document 文档对象
     * @return 节点DTO
     */
    public static BizObjInfoVO convert2BizObjInfo(BizObjectDataItemWithSubitemDTO subitemData, WordDocument document) {
        BizObjInfoVO objBizObjInfoVO = new BizObjInfoVO();
        objBizObjInfoVO.setName(subitemData.getObjectName());
        objBizObjInfoVO.setId(subitemData.getObjectId());
        objBizObjInfoVO.setCode(subitemData.getObjectCode());
        objBizObjInfoVO.setDescription(subitemData.getObjectDesc());
        objBizObjInfoVO.setDomainId(subitemData.getDomainId());
        objBizObjInfoVO.setDocumentId(subitemData.getDocumentId());
        objBizObjInfoVO.setDataFrom(subitemData.getDataFrom());
        return objBizObjInfoVO;
    }
    
}
