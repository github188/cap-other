/******************************************************************************
 * Copyright (C) 2015 ShenZhen ComTop Information Technology Co.,Ltd
 * All Rights Reserved.
 * 本软件为深圳康拓普开发研制。未经本公司正式书面同意，其他任何个人、团体不得使用、
 * 复制、修改或发布本软件.
 *****************************************************************************/

package com.comtop.cap.doc.hld.facade;

import java.util.ArrayList;
import java.util.List;

import com.comtop.cap.bm.biz.domain.appservice.BizDomainAppService;
import com.comtop.cap.bm.biz.domain.model.BizDomainVO;
import com.comtop.cap.bm.metadata.sysmodel.model.FunctionItemVO;
import com.comtop.cap.doc.biz.appservice.BizRoleDocAppservice;
import com.comtop.cap.doc.hld.model.PackageDTO;
import com.comtop.cap.doc.hld.model.RoleDataConstraintDTO;
import com.comtop.cap.doc.service.AbstractExportFacade;
import com.comtop.cap.document.expression.annotation.DocumentService;
import com.comtop.cip.common.util.CAPCollectionUtils;
import com.comtop.cip.jodd.petite.meta.PetiteInject;

/**
 * FIXME 类注释信息
 *
 * @author lizhiyong
 * @since jdk1.6
 * @version 2015年12月30日 lizhiyong
 */
@DocumentService(name = "RoleDataConstraint", dataType = RoleDataConstraintDTO.class)
public class RoleDataConstraintFacede extends AbstractExportFacade<RoleDataConstraintDTO> {
    
    /** 注入AppService **/
    @PetiteInject
    protected BizRoleDocAppservice bizRoleDocAppservice;
    
    /** 注入AppService **/
    @PetiteInject
    protected BizDomainAppService bizDomainAppService;
    
    @Override
    public List<RoleDataConstraintDTO> loadData(RoleDataConstraintDTO condition) {
        // 选择导出文档的节点ID
        String strPackageId = condition.getPackageId();
        List<PackageDTO> lstNodes = getPackages(strPackageId);
        // 获取所有的功能项和功能子项
        List<FunctionItemVO> lstFunctionItem = new ArrayList<FunctionItemVO>();
        for (PackageDTO packageDTO : lstNodes) {
            if (CAPCollectionUtils.isNotEmpty(packageDTO.getLstFunctionItem())) {
                lstFunctionItem.addAll(packageDTO.getLstFunctionItem());
            }
        }
        // 获取业务域
        List<BizDomainVO> alBizDomainRet = bizDomainAppService.querybizDomainByReqFuncId(lstFunctionItem);
        // 查询选中节点下关联的功能子项对应的角色及职责信息
        return bizRoleDocAppservice.queryRoleDataConstraintDTO(alBizDomainRet);
    }
}
