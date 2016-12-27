/******************************************************************************
 * Copyright (C) 2015 ShenZhen ComTop Information Technology Co.,Ltd
 * All Rights Reserved.
 * 本软件为深圳康拓普开发研制。未经本公司正式书面同意，其他任何个人、团体不得使用、
 * 复制、修改或发布本软件.
 *****************************************************************************/

package com.comtop.cap.bm.biz.domain.dao;

import java.util.List;

import com.comtop.cap.bm.biz.domain.model.BizDomainVO;
import com.comtop.cip.jodd.petite.meta.PetiteBean;
import com.comtop.top.core.base.dao.CoreDAO;

/**
 * 业务域DAO
 * 
 * @author 姜子豪
 * @since 1.0
 * @version 2015-11-3 姜子豪
 */
@PetiteBean
public class BizDomainDAO extends CoreDAO<BizDomainVO> {
    
    /**
     * 读取 业务域 列表
     * 
     * @param condition 查询条件
     * @return 业务域列表
     */
    public List<BizDomainVO> queryDomainList(BizDomainVO condition) {
        return queryList("com.comtop.cap.bm.biz.domain.model.queryDomainList", condition);
    }
    
    /**
     * 读取 业务域 数据条数
     * 
     * @param condition 查询条件
     * @return 业务域数据条数
     */
    public int queryDomainCount(BizDomainVO condition) {
        return ((Integer) selectOne("com.comtop.cap.bm.biz.domain.model.queryDomainCount", condition)).intValue();
    }
    
    /**
     * 根据业务域ID查询业务域对象
     * 
     * @param domainId 业务域ID
     * @return 业务域对象
     */
    public BizDomainVO queryDomainById(String domainId) {
        return (BizDomainVO) selectOne("com.comtop.cap.bm.biz.domain.model.queryDomainById", domainId);
    }
    
    /**
     * 根据功能子项ID查询对应的最近业务域对象
     * 
     * @param funcSubId 功能子项ID
     * @return 业务域对象
     */
    public BizDomainVO queryDomainByfuncSubId(String funcSubId) {
        return (BizDomainVO) selectOne("com.comtop.cap.bm.biz.domain.model.queryDomainByfuncSubId", funcSubId);
    }
    
    /**
     * 新增业务域基本信息
     * 
     * @param domain 业务域基本信息
     * @return 业务域ID
     */
    public String insertDomain(BizDomainVO domain) {
        int Count = getDomainMaxSort(domain) + 1;
        domain.setSortNo(Count);
        return (String) super.insert(domain);
    }
    
    /**
     * 修改业务域基本信息
     * 
     * @param domain 业务域基本信息
     */
    public void updateDomain(BizDomainVO domain) {
        super.update(domain);
    }
    
    /**
     * 删除业务域对象
     * 
     * @param domainId 业务域ID
     */
    public void deleteDomain(String domainId) {
        super.delete("com.comtop.cap.bm.biz.domain.model.deleteDomain", domainId);
    }
    
    /**
     * 业务域编码查重
     * 
     * @param domain 业务域
     * @return 结果
     */
    public int checkDomainCode(BizDomainVO domain) {
        return ((Integer) selectOne("com.comtop.cap.bm.biz.domain.model.checkDomainCode", domain)).intValue();
    }
    
    /**
     * 业务是否存在引用
     * 
     * @param domainId 业务域ID
     * @return 结果
     */
    public int checkDomainIsUse(String domainId) {
        return ((Integer) selectOne("com.comtop.cap.bm.biz.domain.model.checkDomainIsUse", domainId)).intValue();
    }
    
    /**
     * 获取业务域排序号最大值
     * 
     * @param domain 业务域
     * @return 结果
     */
    public int getDomainMaxSort(BizDomainVO domain) {
        int count = ((Integer) selectOne("com.comtop.cap.bm.biz.domain.model.getDomainMaxSort", domain)).intValue();
        return count;
    }
    
    /**
     * 更新 排序号
     * 
     * @param bizDomainVO 业务域
     *
     */
    public void updateSortNoById(BizDomainVO bizDomainVO) {
        super.selectOne("com.comtop.cap.bm.biz.domain.model.updateSortNoById", bizDomainVO);
    }
    
    /**
     * 检查同级业务域是否名称重复
     * 
     * @param domainVO 业务域
     * @return 结果
     */
    public boolean checkDomainName(BizDomainVO domainVO) {
        int result = (Integer) selectOne("com.comtop.cap.bm.biz.domain.model.checkDomainName", domainVO);
        return result > 0 ? false : true;
    }
}
