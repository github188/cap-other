/******************************************************************************
 * Copyright (C) 2016 
 * ShenZhen ComTop Information Technology Co.,Ltd
 * All Rights Reserved.
 * 本软件为深圳康拓普开发研制。
 * 未经本公司正式书面同意，其他任何个人、团体不得使用、
 * 复制、修改或发布本软件.
 *****************************************************************************/

package com.comtop.cap.demo.treeModule.action;

import com.comtop.cap.demo.treeModule.action.abs.AbstractTreeTestAction;
import com.comtop.cip.jodd.madvoc.meta.MadvocAction;
import com.comtop.top.core.jodd.AppContext;
import com.comtop.top.sys.usermanagement.organization.facade.OrganizationFacade;
import com.comtop.top.sys.usermanagement.organization.model.OrganizationDTO;
import comtop.org.directwebremoting.annotations.DwrProxy;
import comtop.org.directwebremoting.annotations.RemoteMethod;

/**
 * 左侧树导航页面Action
 * 
 * @author CAP超级管理员
 * @since 1.0
 * @version 2016-6-14 CAP超级管理员
 */
@DwrProxy
@MadvocAction
public class TreeTestAction extends AbstractTreeTestAction {
    
    /**
     * 组织facade
     */
    protected OrganizationFacade clientOrganizationFacade = (OrganizationFacade) AppContext
        .getBean("organizationFacade");
    
    /**
     * 初始化页面参数
     */
    @Override
    public void initBussinessAttr() {
        // 添加页面初始化时候输出参数值
    }
    
    /**
     * 获取树节点数据源
     * 
     * @param organizationId 组织ID
     * @return String
     * 
     */
    @RemoteMethod
    public String getTreeDatasource(String organizationId) {
        if (organizationId == null) {
            organizationId = "-1";
        }
        OrganizationDTO objOrganizationDTO = new OrganizationDTO();
        objOrganizationDTO.setOrgId(organizationId);
        objOrganizationDTO.setOrgStructureId("A");
        String str = clientOrganizationFacade.getOrgTreeNode(objOrganizationDTO);
        return str;
    }
    
}
