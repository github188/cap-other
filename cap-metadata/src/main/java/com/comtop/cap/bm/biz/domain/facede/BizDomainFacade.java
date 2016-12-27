/******************************************************************************
 * Copyright (C) 2015 ShenZhen ComTop Information Technology Co.,Ltd
 * All Rights Reserved.
 * 本软件为深圳康拓普开发研制。未经本公司正式书面同意，其他任何个人、团体不得使用、
 * 复制、修改或发布本软件.
 *****************************************************************************/

package com.comtop.cap.bm.biz.domain.facede;

import java.util.ArrayList;
import java.util.List;

import com.comtop.cap.bm.biz.domain.appservice.BizDomainAppService;
import com.comtop.cap.bm.biz.domain.model.BizDomainVO;
import com.comtop.cap.bm.biz.flow.appservice.BizRelInfoAppService;
import com.comtop.cap.bm.biz.flow.model.BizRelInfoVO;
import com.comtop.cap.bm.metadata.base.facade.CapBmBaseFacade;
import com.comtop.cap.bm.metadata.sysmodel.facade.SysmodelFacade;
import com.comtop.cap.bm.metadata.sysmodel.model.CapPackageVO;
import com.comtop.cap.bm.metadata.sysmodel.model.FunctionItemVO;
import com.comtop.cap.runtime.component.facade.AutoGenNumberFacade;
import com.comtop.cip.jodd.petite.meta.PetiteBean;
import com.comtop.cip.jodd.petite.meta.PetiteInject;
import com.comtop.cap.runtime.core.AppBeanUtil;
import com.comtop.top.core.jodd.AppContext;

/**
 * 业务域 业务逻辑处理类 门面
 * 
 * @author 姜子豪
 * @since 1.0
 * @version 2015-11-3 姜子豪
 */
@PetiteBean
public class BizDomainFacade extends CapBmBaseFacade {
    
    /** 注入AppService **/
    @PetiteInject
    protected BizDomainAppService damainAppService;
    
    /** 注入AppService **/
    @PetiteInject
    protected BizRelInfoAppService bizRelInfoAppService;
    
    /**
     * 应用模块服务
     */
    protected SysmodelFacade sysmodelFacade = AppContext.getBean(SysmodelFacade.class);
    
    /**
     * 读取 业务域 列表
     * 
     * @param condition 查询条件
     * @return 业务域列表
     */
    public List<BizDomainVO> queryDomainList(BizDomainVO condition) {
        return damainAppService.queryDomainList(condition);
    }
    
    /**
     * 读取 业务域 数据条数
     * 
     * @param condition 查询条件
     * @return 业务域数据条数
     */
    public int queryDomainCount(BizDomainVO condition) {
        return damainAppService.queryDomainCount(condition);
    }
    
    /**
     * 根据业务域ID查询业务域对象
     * 
     * @param domainId 业务域ID
     * @return 业务域对象
     */
    public BizDomainVO queryDomainById(String domainId) {
        return damainAppService.queryDomainById(domainId);
    }
    
    /**
     * 根据功能子项ID查询对应的最近业务域对象
     * 
     * @param funcSubId 功能子项ID
     * @return 业务域对象
     */
    public BizDomainVO queryDomainByfuncSubId(String funcSubId) {
        return damainAppService.queryDomainByfuncSubId(funcSubId);
    }
    
    /**
     * 根据应用编码查询关联的功能项或功能子项，通过其功能项或功能子项查询业务域列表
     * 
     * @param funcCode 应用编码
     * @return 业务域列表
     */
    public List<BizDomainVO> queryDomainListByfuncCode(String funcCode) {
        CapPackageVO objCapPackageVO = sysmodelFacade.readModuleVOByCode(funcCode);
		if (objCapPackageVO == null) {
			return new ArrayList<BizDomainVO>();
		}
        
        // 获取所有的功能项和功能子项
        List<FunctionItemVO> lstFunctionItem = objCapPackageVO.getLstFunctionItem();
        // 获取业务域
        List<BizDomainVO> allBizDomainRet = damainAppService.querybizDomainByReqFuncId(lstFunctionItem);
        return allBizDomainRet;
    }
    
    /**
     * 新增业务域基本信息
     * 
     * @param domain 业务域基本信息
     * @return 业务域ID
     */
    public String insertDomain(BizDomainVO domain) {
        AutoGenNumberFacade autoGenNumberService = AppBeanUtil.getBean(AutoGenNumberFacade.class);
        String code = autoGenNumberService.genNumber(BizDomainVO.getCodeExpr(), null);
        domain.setCode(code);
        return damainAppService.insertDomain(domain);
    }
    
    /**
     * 修改业务域基本信息
     * 
     * @param domain 业务域基本信息
     */
    public void updateDomain(BizDomainVO domain) {
        BizRelInfoVO condition = new BizRelInfoVO();
        condition.setRoleaDomainId(domain.getId());
        condition.setRoleaDomainName(domain.getName());
        condition.setRolebDomainId(domain.getId());
        condition.setRolebDomainName(domain.getName());
        bizRelInfoAppService.synBizNodeConstraint(condition);
        damainAppService.updateDomain(domain);
    }
    
    /**
     * 删除业务域对象
     * 
     * @param domainId 业务域ID
     */
    public void deleteDomain(String domainId) {
        damainAppService.deleteDomain(domainId);
    }
    
    /**
     * 业务域编码查重
     * 
     * @param domain 业务域
     * @return 结果
     */
    public int checkDomainCode(BizDomainVO domain) {
        return damainAppService.checkDomainCode(domain);
    }
    
    /**
     * 业务是否存在引用
     * 
     * @param domainId 业务域ID
     * @return 结果
     */
    public int checkDomainIsUse(String domainId) {
        return damainAppService.checkDomainIsUse(domainId);
    }
    
    /**
     * 更新 排序号
     * 
     * @param bizDomainVO 业务域
     * 
     */
    public void updateSortNoById(BizDomainVO bizDomainVO) {
        damainAppService.updateSortNoById(bizDomainVO);
    }
    
    /**
     * 检查同级业务域是否名称重复
     * 
     * @param domainVO 业务域
     * @return 结果
     */
    public boolean checkDomainName(BizDomainVO domainVO) {
        return damainAppService.checkDomainName(domainVO);
    }
    
}
