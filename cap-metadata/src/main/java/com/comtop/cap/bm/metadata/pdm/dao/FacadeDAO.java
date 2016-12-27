/******************************************************************************
 * Copyright (C) 2015 ShenZhen ComTop Information Technology Co.,Ltd
 * All Rights Reserved.
 * 本软件为深圳康拓普开发研制。未经本公司正式书面同意，其他任何个人、团体不得使用、
 * 复制、修改或发布本软件.
 *****************************************************************************/

package com.comtop.cap.bm.metadata.pdm.dao;

import java.util.HashMap;
import java.util.List;
import java.util.Map;

import com.comtop.cap.bm.metadata.entity.model.EntityVO;
import com.comtop.cip.jodd.petite.meta.PetiteBean;
import com.comtop.cip.runtime.base.dao.BaseDAO;
import com.comtop.top.sys.module.model.ModuleVO;

/**
 * PDM模型实体DAO
 * 
 * @author 陈志伟
 * @since 1.0
 * @version 2015-7-7 陈志伟
 */
@PetiteBean
public class FacadeDAO extends BaseDAO<EntityVO> {
    
    /**
     * 
     * 查询子模块列表
     *
     * @param moduleId 模块ID
     * @return 子模块列表
     */
    public List<ModuleVO> queryChildrenModuleVOList(final String moduleId) {
        Map<String, String> params = new HashMap<String, String>();
        params.put("moduleId", moduleId);
        List<ModuleVO> lstModuleVO = this.queryList("com.comtop.cap.bm.metadata.pdm.queryChildrenModuleVOList", params);
        return lstModuleVO;
    }
}
