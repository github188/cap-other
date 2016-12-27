/******************************************************************************
 * Copyright (C) 2015 ShenZhen ComTop Information Technology Co.,Ltd
 * All Rights Reserved.
 * 本软件为深圳康拓普开发研制。未经本公司正式书面同意，其他任何个人、团体不得使用、
 * 复制、修改或发布本软件.
 *****************************************************************************/

package com.comtop.cap.doc.tmpl.appservice;

import java.util.List;

import com.comtop.cap.doc.tmpl.dao.CapDocTemplateDAO;
import com.comtop.cap.doc.tmpl.model.CapDocTemplateVO;
import com.comtop.cip.jodd.petite.meta.PetiteBean;
import com.comtop.cip.jodd.petite.meta.PetiteInject;
import com.comtop.cap.runtime.base.appservice.BaseAppService;

/**
 * 文档模板 业务逻辑处理类
 * 
 * @author CIP
 * @since 1.0
 * @version 2015-11-9 CIP
 */
@PetiteBean
public class CapDocTemplateAppService extends BaseAppService {
    
    /** 注入DAO **/
    @PetiteInject
    protected CapDocTemplateDAO capDocTemplateDAO;
    
    /**
     * 新增 文档模板
     * 
     * @param capDocTemplate 文档模板对象
     * @return 文档模板Id
     */
    public Object insertCapDocTemplate(CapDocTemplateVO capDocTemplate) {
        return capDocTemplateDAO.insertCapDocTemplate(capDocTemplate);
    }
    
    /**
     * 更新 文档模板
     * 
     * @param capDocTemplate 文档模板对象
     * @return 更新成功与否
     */
    public boolean updateCapDocTemplate(CapDocTemplateVO capDocTemplate) {
        return capDocTemplateDAO.updateCapDocTemplate(capDocTemplate);
    }
    
    /**
     * 删除 文档模板
     * 
     * @param capDocTemplate 文档模板对象
     * @return 删除成功与否
     */
    public boolean deleteCapDocTemplate(CapDocTemplateVO capDocTemplate) {
        return capDocTemplateDAO.deleteCapDocTemplate(capDocTemplate);
    }
    
    /**
     * 删除 文档模板集合
     * 
     * @param capDocTemplateList 文档模板对象
     * @return 删除成功与否
     */
    public boolean deleteCapDocTemplateList(List<CapDocTemplateVO> capDocTemplateList) {
        if (capDocTemplateList == null) {
            return true;
        }
        for (CapDocTemplateVO capDocTemplate : capDocTemplateList) {
            this.deleteCapDocTemplate(capDocTemplate);
        }
        return true;
    }
    
    /**
     * 读取 文档模板
     * 
     * @param capDocTemplate 文档模板对象
     * @return 文档模板
     */
    public CapDocTemplateVO loadCapDocTemplate(CapDocTemplateVO capDocTemplate) {
        return capDocTemplateDAO.loadCapDocTemplate(capDocTemplate);
    }
    
    /**
     * 根据文档模板主键读取 文档模板
     * 
     * @param id 文档模板主键
     * @return 文档模板
     */
    public CapDocTemplateVO loadCapDocTemplateById(String id) {
        return capDocTemplateDAO.loadCapDocTemplateById(id);
    }
    
    /**
     * 读取 文档模板 列表
     * 
     * @param condition 查询条件
     * @return 文档模板列表
     */
    public List<CapDocTemplateVO> queryCapDocTemplateList(CapDocTemplateVO condition) {
        return capDocTemplateDAO.queryCapDocTemplateList(condition);
    }
    
    /**
     * 读取 文档模板 数据条数
     * 
     * @param condition 查询条件
     * @return 文档模板数据条数
     */
    public int queryCapDocTemplateCount(CapDocTemplateVO condition) {
        return capDocTemplateDAO.queryCapDocTemplateCount(condition);
    }
    
}
