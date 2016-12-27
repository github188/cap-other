/******************************************************************************
 * Copyright (C) 2015 ShenZhen ComTop Information Technology Co.,Ltd
 * All Rights Reserved.
 * 本软件为深圳康拓普开发研制。未经本公司正式书面同意，其他任何个人、团体不得使用、
 * 复制、修改或发布本软件.
 *****************************************************************************/

package com.comtop.cap.bm.req.template.appservice;

import java.util.List;

import com.comtop.cap.bm.req.template.dao.TemplateInfoDAO;
import com.comtop.cap.bm.req.template.model.TemplateInfoVO;
import com.comtop.cip.jodd.petite.meta.PetiteBean;
import com.comtop.cip.jodd.petite.meta.PetiteInject;
import com.comtop.cap.runtime.base.appservice.BaseAppService;

/**
 * 需求模板明细服务扩展类
 * 
 * @author 姜子豪
 * @since 1.0
 * @version 2015-9-22 姜子豪
 */
@PetiteBean
public class TemplateInfoAppService extends BaseAppService {
    
    /** 注入DAO **/
    @PetiteInject
    protected TemplateInfoDAO templateInfoDAO;
    
    /**
     * 新增 需求模板类型
     * 
     * @param templateType 需求模板类型对象
     * @return 需求模板类型Id
     */
    public Object insertTemplateInfo(TemplateInfoVO templateType) {
        return templateInfoDAO.insertTemplateInfo(templateType);
    }
    
    /**
     * 更新 需求模板类型
     * 
     * @param templateType 需求模板类型对象
     * @return 更新成功与否
     */
    public boolean updateTemplateInfo(TemplateInfoVO templateType) {
        return templateInfoDAO.updateTemplateInfo(templateType);
    }
    
    /**
     * 删除 需求模板类型
     * 
     * @param templateType 需求模板类型对象
     * @return 删除成功与否
     */
    public boolean deleteTemplateInfo(TemplateInfoVO templateType) {
        return templateInfoDAO.deleteTemplateInfo(templateType);
    }
    
    /**
     * 删除 需求模板类型集合
     * 
     * @param templateTypeList 需求模板类型对象
     * @return 删除成功与否
     */
    public boolean deleteTemplateInfoList(List<TemplateInfoVO> templateTypeList) {
        if (templateTypeList == null) {
            return true;
        }
        for (TemplateInfoVO templateType : templateTypeList) {
            this.deleteTemplateInfo(templateType);
        }
        return true;
    }
    
    /**
     * 读取 需求模板类型
     * 
     * @param templateType 需求模板类型对象
     * @return 需求模板类型
     */
    public TemplateInfoVO loadTemplateInfo(TemplateInfoVO templateType) {
        return templateInfoDAO.loadTemplateInfo(templateType);
    }
    
    /**
     * 根据需求模板类型主键读取 需求模板类型
     * 
     * @param id 需求模板类型主键
     * @return 需求模板类型
     */
    public TemplateInfoVO loadTemplateInfoById(String id) {
        return templateInfoDAO.loadTemplateInfoById(id);
    }
    
    /**
     * 读取 需求模板类型 列表
     * 
     * @param templateInfo 查询条件
     * @param templateTypeId 需求模板类型ID
     * @return 需求模板类型列表
     */
    public List<TemplateInfoVO> queryTemplateInfoList(TemplateInfoVO templateInfo, String templateTypeId) {
        return templateInfoDAO.queryTemplateInfoList(templateInfo, templateTypeId);
    }
    
    /**
     * 读取 需求模板类型 数据条数
     * 
     * @param templateInfo 查询条件
     * @param templateTypeId 需求模板类型ID
     * @return 需求模板类型数据条数
     */
    public int queryTemplateInfoCount(TemplateInfoVO templateInfo, String templateTypeId) {
        return templateInfoDAO.queryTemplateInfoCount(templateInfo, templateTypeId);
    }
    
    /**
     * 
     * 根据需求模板ID删除需求明细
     *
     * @param templateTypeId 需求模板类型ID
     */
    public void deleteTemplateInfoByTypeId(String templateTypeId) {
        templateInfoDAO.deleteTemplateInfoByTypeId(templateTypeId);
    }
    
}
