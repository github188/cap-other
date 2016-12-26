/******************************************************************************
 * Copyright (C) 2014 ShenZhen ComTop Information Technology Co.,Ltd
 * All Rights Reserved.
 * 本软件为深圳康拓普开发研制。未经本公司正式书面同意，其他任何个人、团体不得使用、
 * 复制、修改或发布本软件.
 *****************************************************************************/

package com.comtop.cip.graph.entity.appservice;

import java.util.HashMap;
import java.util.List;
import java.util.Map;

import org.apache.commons.lang.StringUtils;

import com.comtop.cap.runtime.base.appservice.BaseAppService;
import com.comtop.cip.graph.entity.dao.GraphModuleDAO;
import com.comtop.cip.graph.entity.model.GraphModuleVO;
import com.comtop.cip.jodd.petite.meta.PetiteBean;
import com.comtop.cip.jodd.petite.meta.PetiteInject;
import com.comtop.top.core.base.dao.CoreDAO;
import com.comtop.top.sys.module.appservice.ModuleAppService;

/**
 * 模块依赖图应用服务(新增)
 * 
 * @author 杜祺
 * @since 1.0
 * @version 2015-07-01
 */
@PetiteBean
public class GraphModuleAppService extends BaseAppService {
    
    /** 实体属性DAO */
    @PetiteInject
    protected GraphModuleDAO graphModuleDAO;
    
    /** 实体属性DAO */
    @PetiteInject
    protected ModuleAppService moduleAppService;
    
    /** coreDAO */
    @PetiteInject
    protected CoreDAO coreDAO;
    
    /**
     * 通过模块ID获取模块图形关系名称
     * 
     * @param packageId 包ID
     * @return 模块图形关系数据
     */
    public GraphModuleVO queryGraphModuleNameByModuleId(final String packageId) {
        String strModuleId = StringUtils.isBlank(packageId) ? moduleAppService.getRootModule().getModuleId()
            : packageId;
        // 根据moduleId读取GraphModuleVO
        GraphModuleVO objGraphModuleVO = graphModuleDAO.readGraphModuleVO(strModuleId);
        return objGraphModuleVO;
    }
    
    /**
     * 
     * 读取图形模块实体
     *
     * @param moduleId 模块ID
     * @return 图形模块实体
     */
    public GraphModuleVO readGraphModuleVO(String moduleId) {
        return graphModuleDAO.readGraphModuleVO(moduleId);
    }
    
    /**
     * 
     * 查询子模块列表
     *
     * @param moduleId 模块ID
     * @return 图形模块实体
     */
    public List<GraphModuleVO> queryChildrenModuleVOList(String moduleId) {
        return graphModuleDAO.queryChildrenModuleVOList(moduleId);
    }
    
    /**
     * 
     * 读取图形模块实体
     *
     * @param strFullPath 模块ID
     * @return 图形模块实体
     */
    public GraphModuleVO readGraphModuleVOByFullPath(String strFullPath) {
        return graphModuleDAO.readGraphModuleVOByFullPath(strFullPath);
    }
    
    /**
     * 
     * 读取根模块
     *
     * @return 图形模块实体
     */
    public GraphModuleVO readRootGraphModuleVO() {
        return graphModuleDAO.readRootGraphModuleVO();
    }
    
    /**
     * 
     * 查询所有子模块列表
     *
     * @param moduleId 图形模块实体id
     * @return 图形模块实体
     */
    public List<GraphModuleVO> queryAllChildrenModuleVOList(final String moduleId) {
        Map<String, String> params = new HashMap<String, String>();
        params.put("moduleId", moduleId);
        List<GraphModuleVO> lstGraphModuleVO = coreDAO.queryList(
            "com.comtop.cip.graph.entity.model.queryAllChildrenModuleVOList", params);
        return lstGraphModuleVO;
    }
}
