/******************************************************************************
 * Copyright (C) 2015 ShenZhen ComTop Information Technology Co.,Ltd
 * All Rights Reserved.
 * 本软件为深圳康拓普开发研制。未经本公司正式书面同意，其他任何个人、团体不得使用、
 * 复制、修改或发布本软件.
 *****************************************************************************/

package com.comtop.cap.doc.tmpl.dao;

import java.util.List;

import com.comtop.cap.doc.tmpl.model.CapDocTemplateVO;
import com.comtop.cip.jodd.jtx.JtxPropagationBehavior;
import com.comtop.cip.jodd.jtx.meta.Transaction;
import com.comtop.cip.jodd.petite.meta.PetiteBean;
import com.comtop.top.core.base.dao.CoreDAO;

/**
 * 文档模板DAO
 * 
 * @author CAP
 * @since 1.0
 * @version 2015-11-9 CAP
 */
@PetiteBean
public class CapDocTemplateDAO extends CoreDAO<CapDocTemplateVO> {
    
    /**
     * 新增 文档模板
     * 
     * @param capDocTemplate 文档模板对象
     * @return 文档模板Id
     */
    @Transaction(propagation = JtxPropagationBehavior.PROPAGATION_REQUIRED, readOnly = false)
    public Object insertCapDocTemplate(CapDocTemplateVO capDocTemplate) {
        Object result = insert(capDocTemplate);
        return result;
    }
    
    /**
     * 更新 文档模板
     * 
     * @param capDocTemplate 文档模板对象
     * @return 更新成功与否
     */
    @Transaction(propagation = JtxPropagationBehavior.PROPAGATION_REQUIRED, readOnly = false)
    public boolean updateCapDocTemplate(CapDocTemplateVO capDocTemplate) {
        return update(capDocTemplate);
    }
    
    /**
     * 删除 文档模板
     * 
     * @param capDocTemplate 文档模板对象
     * @return 删除成功与否
     */
    @Transaction(propagation = JtxPropagationBehavior.PROPAGATION_REQUIRED, readOnly = false)
    public boolean deleteCapDocTemplate(CapDocTemplateVO capDocTemplate) {
        return delete(capDocTemplate);
    }
    
    /**
     * 读取 文档模板
     * 
     * @param capDocTemplate 文档模板对象
     * @return 文档模板
     */
    public CapDocTemplateVO loadCapDocTemplate(CapDocTemplateVO capDocTemplate) {
        CapDocTemplateVO objCapDocTemplate = load(capDocTemplate);
        return objCapDocTemplate;
    }
    
    /**
     * 根据文档模板主键读取 文档模板
     * 
     * @param id 文档模板主键
     * @return 文档模板
     */
    public CapDocTemplateVO loadCapDocTemplateById(String id) {
        CapDocTemplateVO objCapDocTemplate = new CapDocTemplateVO();
        objCapDocTemplate.setId(id);
        return loadCapDocTemplate(objCapDocTemplate);
    }
    
    /**
     * 读取 文档模板 列表
     * 
     * @param condition 查询条件
     * @return 文档模板列表
     */
    public List<CapDocTemplateVO> queryCapDocTemplateList(CapDocTemplateVO condition) {
        return queryList("com.comtop.cap.doc.tmpl.model.queryCapDocTemplateList", condition, condition.getPageNo(),
            condition.getPageSize());
    }
    
    /**
     * 读取 文档模板 数据条数
     * 
     * @param condition 查询条件
     * @return 文档模板数据条数
     */
    public int queryCapDocTemplateCount(CapDocTemplateVO condition) {
        return ((Integer) selectOne("com.comtop.cap.doc.tmpl.model.queryCapDocTemplateCount", condition)).intValue();
    }
    
}
