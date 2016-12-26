/******************************************************************************
 * Copyright (C) 2014 ShenZhen ComTop Information Technology Co.,Ltd
 * All Rights Reserved.
 * 本软件为深圳康拓普开发研制。未经本公司正式书面同意，其他任何个人、团体不得使用、
 * 复制、修改或发布本软件.
 *****************************************************************************/

package com.comtop.cip.graph.entity.dao;

import java.util.HashMap;
import java.util.List;
import java.util.Map;

import com.comtop.cap.bm.metadata.entity.model.EntityVO;
import com.comtop.cip.graph.entity.model.GraphModuleVO;
import com.comtop.cip.jodd.petite.meta.PetiteBean;
import com.comtop.cip.runtime.base.dao.BaseDAO;

/**
 * 模块依赖DAO
 *
 * @author 刘城
 * @since jdk1.6
 * @version 2016年11月1日 刘城
 */
@PetiteBean
public class GraphModuleDAO extends BaseDAO<EntityVO> {
    
    /**
     * 
     * 读取图形模块实体
     *
     * @param moduleId 模块ID
     * @return 图形模块实体
     */
    public GraphModuleVO readGraphModuleVO(final String moduleId) {
        return (GraphModuleVO) this.selectOne("com.comtop.cip.graph.entity.model.readGraphModuleVONew2", moduleId);
    }
    
    /**
     * 
     * 读取图形模块实体
     *
     * @param strFullPath 模块ID
     * @return 图形模块实体
     */
    public GraphModuleVO readGraphModuleVOByFullPath(final String strFullPath) {
        return (GraphModuleVO) this.selectOne("com.comtop.cip.graph.entity.model.readGraphModuleVOByFullPath",
            strFullPath);
    }
    
    /**
     * 
     * 查询子模块列表
     *
     * @param moduleId 模块ID
     * @return 图形模块实体
     */
    public List<GraphModuleVO> queryChildrenModuleVOList(final String moduleId) {
        Map<String, String> params = new HashMap<String, String>();
        params.put("moduleId", moduleId);
        List<GraphModuleVO> lstGraphModuleVO = this.queryList(
            "com.comtop.cip.graph.entity.model.queryChildrenModuleVOListByModuleId", params);
        return lstGraphModuleVO;
    }
    
    /**
     * 
     * 读取根模块
     *
     * @return 图形模块实体
     */
    public GraphModuleVO readRootGraphModuleVO() {
        return (GraphModuleVO) this.selectOne("com.comtop.cip.graph.entity.model.readRootGraphModuleVO", null);
    }
    
}
