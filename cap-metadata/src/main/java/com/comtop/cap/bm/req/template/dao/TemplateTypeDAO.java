/******************************************************************************
 * Copyright (C) 2015 ShenZhen ComTop Information Technology Co.,Ltd
 * All Rights Reserved.
 * 本软件为深圳康拓普开发研制。未经本公司正式书面同意，其他任何个人、团体不得使用、
 * 复制、修改或发布本软件.
 *****************************************************************************/

package com.comtop.cap.bm.req.template.dao;

import java.util.List;

import com.comtop.cap.bm.req.cfg.util.ReqConstants;
import com.comtop.cap.bm.req.template.model.TemplateTypeVO;
import com.comtop.cip.jodd.jtx.JtxPropagationBehavior;
import com.comtop.cip.jodd.jtx.meta.Transaction;
import com.comtop.cip.jodd.petite.meta.PetiteBean;
import com.comtop.top.core.base.dao.CoreDAO;

/**
 * 需求模板类型扩展DAO
 * 
 * @author 姜子豪
 * @since 1.0
 * @version 2015-9-22 姜子豪
 */
@PetiteBean
public class TemplateTypeDAO extends CoreDAO<TemplateTypeVO> {
    
    /**
     * 获取需求模板类型ID
     * 
     * @return 需求模板类型ID数组
     */
    public List<TemplateTypeVO> reqTemplateTypeIDLst() {
        List<TemplateTypeVO> t = super.queryList(ReqConstants.REQ_TEMPLATE_MODEL + ".reqTemplateTypeIDLst",
            new TemplateTypeVO());
        return t;
    }
    
    /**
     * 
     * 新增需求模板类型对象
     *
     * @param templateTypeVO 需求模板类型对象
     * @return 需求模板类型ID
     */
    @Transaction(propagation = JtxPropagationBehavior.PROPAGATION_REQUIRED, readOnly = false)
    public String insetTemplateType(TemplateTypeVO templateTypeVO) {
        String templateTypeId = (String) insert(templateTypeVO);
        return templateTypeId;
    }
    
    /**
     * 
     * 删除需求模板类型对象
     * 
     * @param templateTypeVO 需求模板类型对象
     * @return 删除结果
     */
    @Transaction(propagation = JtxPropagationBehavior.PROPAGATION_REQUIRED, readOnly = false)
    public boolean deleteTemplateType(TemplateTypeVO templateTypeVO) {
        return super.delete(templateTypeVO);
    }
    
    /**
     * 
     * 修改需求模板类型对象
     *
     * @param templateTypeVO 需求模板类型对象
     * @return 需求模板类型ID
     */
    public boolean updateTemplateType(TemplateTypeVO templateTypeVO) {
        return update(templateTypeVO);
    }
}
