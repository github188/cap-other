/******************************************************************************
 * Copyright (C) 2015 ShenZhen ComTop Information Technology Co.,Ltd
 * All Rights Reserved.
 * 本软件为深圳康拓普开发研制。未经本公司正式书面同意，其他任何个人、团体不得使用、
 * 复制、修改或发布本软件.
 *****************************************************************************/

package com.comtop.cip.graph.uml.dao;

import java.util.HashMap;
import java.util.List;
import java.util.Map;

import com.comtop.cap.bm.metadata.entity.model.EntityVO;
import com.comtop.cip.graph.uml.model.GraphEntityExtendVO;
import com.comtop.cip.jodd.petite.meta.PetiteBean;
import com.comtop.cip.runtime.base.dao.BaseDAO;

/**
 * 模型实体DAO
 * 
 * @author 陈志伟
 * @since 1.0
 * @version 2015-7-7 陈志伟
 */
@PetiteBean
public class GraphUmlDAO extends BaseDAO<EntityVO> {
    
    /**
     * 通过包ID查询所有实体继承关系
     * 
     * @param packageId
     *            包ID
     * @return 实体继承关系集合
     */
    public List<GraphEntityExtendVO> queryEntityExtendsByPackageId(final String packageId) {
        Map<String, Object> objParam = new HashMap<String, Object>();
        objParam.put("packageId", packageId);
        
        List<GraphEntityExtendVO> lstExtends = this.queryList(
            "com.comtop.cip.graph.uml.model.queryEntityExtendsByPackageId", objParam);
        return lstExtends;
    }
    
}
