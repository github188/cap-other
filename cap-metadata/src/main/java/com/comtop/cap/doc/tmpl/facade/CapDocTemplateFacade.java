/******************************************************************************
 * Copyright (C) 2015 ShenZhen ComTop Information Technology Co.,Ltd
 * All Rights Reserved.
 * 本软件为深圳康拓普开发研制。未经本公司正式书面同意，其他任何个人、团体不得使用、
 * 复制、修改或发布本软件.
 *****************************************************************************/

package com.comtop.cap.doc.tmpl.facade;

import java.util.HashMap;
import java.util.List;
import java.util.Map;

import com.comtop.cap.doc.tmpl.appservice.CapDocTemplateAppService;
import com.comtop.cap.doc.tmpl.model.CapDocTemplateVO;
import com.comtop.cip.jodd.petite.meta.PetiteBean;
import com.comtop.cip.jodd.petite.meta.PetiteInject;
import com.comtop.cap.runtime.base.facade.BaseFacade;

/**
 * 文档模板 业务逻辑处理类 门面
 * 
 * @author CAP
 * @since 1.0
 * @version 2015-11-9 CAP
 */
@PetiteBean
public class CapDocTemplateFacade extends BaseFacade {
    
    /** 注入AppService **/
    @PetiteInject
    protected CapDocTemplateAppService capDocTemplateAppService;
    
    /**
     * 新增 文档模板
     * 
     * @param capDocTemplateVO 文档模板对象
     * @return 文档模板
     */
    public Object insertCapDocTemplate(CapDocTemplateVO capDocTemplateVO) {
        return capDocTemplateAppService.insertCapDocTemplate(capDocTemplateVO);
    }
    
    /**
     * 更新 文档模板
     * 
     * @param capDocTemplateVO 文档模板对象
     * @return 更新结果
     */
    public boolean updateCapDocTemplate(CapDocTemplateVO capDocTemplateVO) {
        return capDocTemplateAppService.updateCapDocTemplate(capDocTemplateVO);
    }
    
    /**
     * 保存或更新文档模板，根据ID是否为空
     * 
     * @param capDocTemplateVO 文档模板ID
     * @return 文档模板保存后的主键ID
     */
    public String saveCapDocTemplate(CapDocTemplateVO capDocTemplateVO) {
        if (capDocTemplateVO.getId() == null) {
            String strId = (String) this.insertCapDocTemplate(capDocTemplateVO);
            capDocTemplateVO.setId(strId);
        } else {
            this.updateCapDocTemplate(capDocTemplateVO);
        }
        return capDocTemplateVO.getId();
    }
    
    /**
     * 读取 文档模板 列表，分页查询--新版设计器使用
     * 
     * @param condition 查询条件
     * @return 文档模板列表
     */
    public Map<String, Object> queryCapDocTemplateListByPage(CapDocTemplateVO condition) {
        final Map<String, Object> ret = new HashMap<String, Object>(2);
        int count = capDocTemplateAppService.queryCapDocTemplateCount(condition);
        List<CapDocTemplateVO> capDocTemplateVOList = null;
        if (count > 0) {
            capDocTemplateVOList = capDocTemplateAppService.queryCapDocTemplateList(condition);
        }
        ret.put("list", capDocTemplateVOList);
        ret.put("count", count);
        return ret;
    }
    
    /**
     * 删除 文档模板
     * 
     * @param capDocTemplateVO 文档模板对象
     * @return 删除结果
     */
    public boolean deleteCapDocTemplate(CapDocTemplateVO capDocTemplateVO) {
        return capDocTemplateAppService.deleteCapDocTemplate(capDocTemplateVO);
    }
    
    /**
     * 删除 文档模板集合
     * 
     * @param capDocTemplateVOList 文档模板对象
     * @return 删除结果
     */
    public boolean deleteCapDocTemplateList(List<CapDocTemplateVO> capDocTemplateVOList) {
        return capDocTemplateAppService.deleteCapDocTemplateList(capDocTemplateVOList);
    }
    
    /**
     * 读取 文档模板
     * 
     * @param capDocTemplateVO 文档模板对象
     * @return 文档模板
     */
    public CapDocTemplateVO loadCapDocTemplate(CapDocTemplateVO capDocTemplateVO) {
        return capDocTemplateAppService.loadCapDocTemplate(capDocTemplateVO);
    }
    
    /**
     * 根据文档模板主键 读取 文档模板
     * 
     * @param id 文档模板主键
     * @return 文档模板
     */
    public CapDocTemplateVO loadCapDocTemplateById(String id) {
        return capDocTemplateAppService.loadCapDocTemplateById(id);
    }
    
    /**
     * 读取 文档模板 列表
     * 
     * @param condition 查询条件
     * @return 文档模板列表
     */
    public List<CapDocTemplateVO> queryCapDocTemplateList(CapDocTemplateVO condition) {
        return capDocTemplateAppService.queryCapDocTemplateList(condition);
    }
    
    /**
     * 读取 文档模板 数据条数
     * 
     * @param condition 查询条件
     * @return 文档模板数据条数
     */
    public int queryCapDocTemplateCount(CapDocTemplateVO condition) {
        return capDocTemplateAppService.queryCapDocTemplateCount(condition);
    }
    
}
