/******************************************************************************
 * Copyright (C) 2015 ShenZhen ComTop Information Technology Co.,Ltd
 * All Rights Reserved.
 * 本软件为深圳康拓普开发研制。未经本公司正式书面同意，其他任何个人、团体不得使用、
 * 复制、修改或发布本软件.
 *****************************************************************************/

package com.comtop.cap.bm.req.template.facade;

import java.util.List;

import com.comtop.cap.bm.req.template.appservice.TemplateInfoAppService;
import com.comtop.cap.bm.req.template.model.TemplateInfoVO;
import com.comtop.cip.jodd.petite.meta.PetiteBean;
import com.comtop.cip.jodd.petite.meta.PetiteInject;
import com.comtop.cap.runtime.base.facade.BaseFacade;

/**
 * 需求模板明细扩展实现
 * 
 * @author 姜子豪
 * @since 1.0
 * @version 2015-9-22 姜子豪
 */
@PetiteBean
public class TemplateInfoFacade extends BaseFacade {
    
    /** 注入AppService **/
    @PetiteInject
    protected TemplateInfoAppService templateInfoAppService;
    
    /**
     * 新增 需求模板明细
     * 
     * @param templateInfoVO 需求模板明细对象
     * @return 需求模板明细
     */
    public Object insertTemplateInfo(TemplateInfoVO templateInfoVO) {
        return templateInfoAppService.insertTemplateInfo(templateInfoVO);
    }
    
    /**
     * 更新 需求模板明细
     * 
     * @param templateInfoVO 需求模板明细对象
     * @return 更新结果
     */
    public boolean updateTemplateInfo(TemplateInfoVO templateInfoVO) {
        return templateInfoAppService.updateTemplateInfo(templateInfoVO);
    }
    
    /**
     * 保存或更新需求模板明细，根据ID是否为空
     * 
     * @param templateInfoVO 需求模板明细ID
     * @return 需求模板明细保存后的主键ID
     */
    public String saveTemplateInfo(TemplateInfoVO templateInfoVO) {
        if (templateInfoVO.getId() == null) {
            String strId = (String) this.insertTemplateInfo(templateInfoVO);
            templateInfoVO.setId(strId);
        } else {
            this.updateTemplateInfo(templateInfoVO);
        }
        return templateInfoVO.getId();
    }
    
    /**
     * 删除 需求模板明细
     * 
     * @param templateInfoVO 需求模板明细对象
     * @return 删除结果
     */
    public boolean deleteTemplateInfo(TemplateInfoVO templateInfoVO) {
        return templateInfoAppService.deleteTemplateInfo(templateInfoVO);
    }
    
    /**
     * 删除 需求模板明细集合
     * 
     * @param templateInfoVOList 需求模板明细对象
     * @return 删除结果
     */
    public boolean deleteTemplateInfoList(List<TemplateInfoVO> templateInfoVOList) {
        return templateInfoAppService.deleteTemplateInfoList(templateInfoVOList);
    }
    
    /**
     * 读取 需求模板明细
     * 
     * @param templateInfoVO 需求模板明细对象
     * @return 需求模板明细
     */
    public TemplateInfoVO loadTemplateInfo(TemplateInfoVO templateInfoVO) {
        return templateInfoAppService.loadTemplateInfo(templateInfoVO);
    }
    
    /**
     * 根据需求模板明细主键 读取 需求模板明细
     * 
     * @param id 需求模板明细主键
     * @return 需求模板明细
     */
    public TemplateInfoVO loadTemplateInfoById(String id) {
        return templateInfoAppService.loadTemplateInfoById(id);
    }
    
    /**
     * 读取 需求模板明细 列表
     * 
     * @param templateInfo 查询条件
     * @param templateTypeId 需求模板类型ID
     * @return 需求模板明细列表
     */
    public List<TemplateInfoVO> queryTemplateInfoList(TemplateInfoVO templateInfo, String templateTypeId) {
        return templateInfoAppService.queryTemplateInfoList(templateInfo, templateTypeId);
    }
    
    /**
     * 读取 需求模板明细 数据条数
     * 
     * @param templateInfo 查询条件
     * @param templateTypeId 需求模板类型ID
     * @return 需求模板明细数据条数
     */
    public int queryTemplateInfoCount(TemplateInfoVO templateInfo, String templateTypeId) {
        return templateInfoAppService.queryTemplateInfoCount(templateInfo, templateTypeId);
    }
    
}
