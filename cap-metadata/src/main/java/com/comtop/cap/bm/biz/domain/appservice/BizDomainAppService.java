/******************************************************************************
 * Copyright (C) 2015 ShenZhen ComTop Information Technology Co.,Ltd
 * All Rights Reserved.
 * 本软件为深圳康拓普开发研制。未经本公司正式书面同意，其他任何个人、团体不得使用、
 * 复制、修改或发布本软件.
 *****************************************************************************/

package com.comtop.cap.bm.biz.domain.appservice;

import java.util.List;

import com.comtop.cap.bm.biz.domain.dao.BizDomainDAO;
import com.comtop.cap.bm.biz.domain.model.BizDomainVO;
import com.comtop.cap.bm.metadata.sysmodel.model.FunctionItemVO;
import com.comtop.cip.common.util.CAPCollectionUtils;
import com.comtop.cip.jodd.petite.meta.PetiteBean;
import com.comtop.cip.jodd.petite.meta.PetiteInject;
import com.comtop.cap.runtime.base.appservice.BaseAppService;

/**
 * 业务域 业务逻辑处理类
 * 
 * @author 姜子豪
 * @since 1.0
 * @version 2015-11-3 姜子豪
 */
@PetiteBean
public class BizDomainAppService extends BaseAppService {
    
    /** 注入DAO **/
    @PetiteInject
    protected BizDomainDAO damainDAO;
    
    /**
     * 读取 业务域 列表
     * 
     * @param condition 查询条件
     * @return 业务域列表
     */
    public List<BizDomainVO> queryDomainList(BizDomainVO condition) {
        return damainDAO.queryDomainList(condition);
    }
    
    /**
     * 读取 业务域 数据条数
     * 
     * @param condition 查询条件
     * @return 业务域数据条数
     */
    public int queryDomainCount(BizDomainVO condition) {
        return damainDAO.queryDomainCount(condition);
    }
    
    /**
     * 根据业务域ID查询业务域对象
     * 
     * @param domainId 业务域ID
     * @return 业务域对象
     */
    public BizDomainVO queryDomainById(String domainId) {
        return damainDAO.queryDomainById(domainId);
    }
    
    /**
     * 新增业务域基本信息
     * 
     * @param domain 业务域基本信息
     * @return 业务域ID
     */
    public String insertDomain(BizDomainVO domain) {
        return damainDAO.insertDomain(domain);
    }
    
    /**
     * 修改业务域基本信息
     * 
     * @param domain 业务域基本信息
     */
    public void updateDomain(BizDomainVO domain) {
        damainDAO.updateDomain(domain);
    }
    
    /**
     * 删除业务域对象
     * 
     * @param domainId 业务域ID
     */
    public void deleteDomain(String domainId) {
        damainDAO.deleteDomain(domainId);
    }
    
    /**
     * 业务域编码查重
     * 
     * @param domain 业务域
     * @return 结果
     */
    public int checkDomainCode(BizDomainVO domain) {
        return damainDAO.checkDomainCode(domain);
    }
    
    /**
     * 业务是否存在引用
     * 
     * @param domainId 业务域ID
     * @return 结果
     */
    public int checkDomainIsUse(String domainId) {
        return damainDAO.checkDomainIsUse(domainId);
    }
    /**
     * 根据功能子项ID查询对应的最近业务域对象
     * 
     * @param funcSubId 功能子项ID
     * @return 业务域对象
     */
    public BizDomainVO queryDomainByfuncSubId(String funcSubId) {
        return damainDAO.queryDomainByfuncSubId(funcSubId);
    }
    /**
     * 更新 排序号
     * 
     * @param bizDomainVO 业务域
     *
     */
    public void updateSortNoById(BizDomainVO bizDomainVO) {
        damainDAO.updateSortNoById(bizDomainVO);
    }
    
    /**
     * 根据功能项和功能子项ID集合，查询业务域集合
     *
     * @param lstFunctionItem 功能项和功能子项ID集合
     * @return 业务域集合
     */
    public List<BizDomainVO> querybizDomainByReqFuncId(List<FunctionItemVO> lstFunctionItem) {
        if (CAPCollectionUtils.isNotEmpty(lstFunctionItem)) {
            return damainDAO.queryList("com.comtop.cap.bm.biz.domain.model.querybizDomainByReqFuncId", lstFunctionItem);
        }
        return null;
    }
    
    /**
     * 检查同级业务域是否名称重复
     * 
     * @param domainVO 业务域
     * @return 结果
     */
    public boolean checkDomainName(BizDomainVO domainVO) {
        return damainDAO.checkDomainName(domainVO);
    }
}
