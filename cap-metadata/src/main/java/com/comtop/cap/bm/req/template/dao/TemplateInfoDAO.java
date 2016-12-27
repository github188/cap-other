/******************************************************************************
 * Copyright (C) 2015 ShenZhen ComTop Information Technology Co.,Ltd
 * All Rights Reserved.
 * 本软件为深圳康拓普开发研制。未经本公司正式书面同意，其他任何个人、团体不得使用、
 * 复制、修改或发布本软件.
 *****************************************************************************/

package com.comtop.cap.bm.req.template.dao;

import java.util.List;

import com.comtop.cap.bm.req.cfg.util.ReqConstants;
import com.comtop.cap.bm.req.template.model.TemplateInfoVO;
import com.comtop.cip.jodd.jtx.JtxPropagationBehavior;
import com.comtop.cip.jodd.jtx.meta.Transaction;
import com.comtop.cip.jodd.petite.meta.PetiteBean;
import com.comtop.top.core.base.dao.CoreDAO;

/**
 * 需求模板明细扩展DAO
 * 
 * @author 姜子豪
 * @since 1.0
 * @version 2015-9-22 姜子豪
 */
@PetiteBean
public class TemplateInfoDAO extends CoreDAO<TemplateInfoVO> {
    
    /**
     * 新增 需求模板明细
     * 
     * @param templateInfo 需求模板明细对象
     * @return 需求模板明细Id
     */
    @Transaction(propagation = JtxPropagationBehavior.PROPAGATION_REQUIRED, readOnly = false)
    public Object insertTemplateInfo(TemplateInfoVO templateInfo) {
        Object result = insert(templateInfo);
        return result;
    }
    
    /**
     * 更新 需求模板明细
     * 
     * @param templateInfo 需求模板明细对象
     * @return 更新成功与否
     */
    @Transaction(propagation = JtxPropagationBehavior.PROPAGATION_REQUIRED, readOnly = false)
    public boolean updateTemplateInfo(TemplateInfoVO templateInfo) {
        return update(templateInfo);
    }
    
    /**
     * 删除 需求模板明细
     * 
     * @param templateInfo 需求模板明细对象
     * @return 删除成功与否
     */
    @Transaction(propagation = JtxPropagationBehavior.PROPAGATION_REQUIRED, readOnly = false)
    public boolean deleteTemplateInfo(TemplateInfoVO templateInfo) {
        return delete(templateInfo);
    }
    
    /**
     * 读取 需求模板明细
     * 
     * @param templateInfo 需求模板明细对象
     * @return 需求模板明细
     */
    public TemplateInfoVO loadTemplateInfo(TemplateInfoVO templateInfo) {
        TemplateInfoVO objTemplateInfo = load(templateInfo);
        return objTemplateInfo;
    }
    
    /**
     * 根据需求模板明细主键读取 需求模板明细
     * 
     * @param id 需求模板明细主键
     * @return 需求模板明细
     */
    public TemplateInfoVO loadTemplateInfoById(String id) {
        TemplateInfoVO objTemplateInfo = new TemplateInfoVO();
        objTemplateInfo.setId(id);
        return loadTemplateInfo(objTemplateInfo);
    }
    
    /**
     * 读取 需求模板明细 列表
     * 
     * @param templateInfo 查询条件
     * @param templateTypeId 需求模板类型ID
     * @return 需求模板明细列表
     */
    public List<TemplateInfoVO> queryTemplateInfoList(TemplateInfoVO templateInfo, String templateTypeId) {
        return queryList(ReqConstants.REQ_TEMPLATE_MODEL + ".queryTemplateInfoList", templateTypeId,
            templateInfo.getPageNo(), templateInfo.getPageSize());
    }
    
    /**
     * 读取 需求模板明细 数据条数
     * 
     * @param templateInfo 查询条件
     * @param templateTypeId 需求模板类型ID
     * @return 需求模板明细数据条数
     */
    public int queryTemplateInfoCount(TemplateInfoVO templateInfo, String templateTypeId) {
        return ((Integer) selectOne(ReqConstants.REQ_TEMPLATE_MODEL + ".queryTemplateInfoCount", templateTypeId))
            .intValue();
    }
    
    /**
     * 
     * 根据需求模板ID删除需求明细
     *
     * @param templateTypeId 需求模板类型ID
     */
    public void deleteTemplateInfoByTypeId(String templateTypeId) {
        super.delete(ReqConstants.REQ_TEMPLATE_MODEL + ".deleteTemplateInfoByTypeId", templateTypeId);
    }
    
    /**
     * 
     * 删除需求模板类型下对应模板
     * 
     * @param templateTypeId 需求模板类型对象
     */
    public void deleteTemplateByType(String templateTypeId) {
        // TODO 自动生成方法存根注释，方法实现时请删除此注释
        
    }
    
}
