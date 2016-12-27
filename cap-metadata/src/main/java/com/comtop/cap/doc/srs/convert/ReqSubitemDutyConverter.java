/******************************************************************************
 * Copyright (C) 2016 ShenZhen ComTop Information Technology Co.,Ltd
 * All Rights Reserved.
 * 本软件为深圳康拓普开发研制。未经本公司正式书面同意，其他任何个人、团体不得使用、
 * 复制、修改或发布本软件.
 *****************************************************************************/

package com.comtop.cap.doc.srs.convert;

import com.comtop.cap.doc.biz.model.BizRoleDTO;
import com.comtop.cap.doc.srs.model.ReqSubitemDutyDTO;
import com.comtop.cap.document.word.docmodel.data.WordDocument;

/**
 * 数据转换器工具类
 *
 * @author lizhiyong
 * @since jdk1.6
 * @version 2016年1月25日 lizhiyong
 */
public final class ReqSubitemDutyConverter {
    
    /**
     * 构造函数
     */
    private ReqSubitemDutyConverter() {
    }
    
    /**
     * 从节点约束时抽取信息转换为节点对象
     *
     * @param subitemData 业务子项数据项
     * @param document 文档对象
     * @return 节点DTO
     */
    public static BizRoleDTO convert2BizRole(ReqSubitemDutyDTO subitemData, WordDocument document) {
        BizRoleDTO objBizRoleDTO = new BizRoleDTO();
        String strDomainId = subitemData.getDomainId();
        String strBizLevel = subitemData.getBizLevel();
        String strRoleName = subitemData.getRoleName();
        objBizRoleDTO.setName(strRoleName);
        objBizRoleDTO.setDomainId(strDomainId);
        objBizRoleDTO.setDocumentId(subitemData.getDocumentId());
        objBizRoleDTO.setDataFrom(1);
        objBizRoleDTO.setBizLevel(strBizLevel);
        return objBizRoleDTO;
    }
}
