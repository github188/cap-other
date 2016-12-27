/******************************************************************************
 * Copyright (C) 2014 ShenZhen ComTop Information Technology Co.,Ltd
 * All Rights Reserved.
 * 本软件为深圳康拓普开发研制。未经本公司正式书面同意，其他任何个人、团体不得使用、
 * 复制、修改或发布本软件.
 *****************************************************************************/

package com.comtop.cap.bm.metadata.pkg.dao;

import java.util.List;

import com.comtop.cip.jodd.petite.meta.PetiteBean;
import com.comtop.cap.bm.metadata.pkg.model.ProjectJarVO;
import com.comtop.cip.runtime.base.dao.BaseDAO;

/**
 * 项目依赖包 数据访问接口类
 * 
 * @author 李忠文
 * @since 1.0
 * @version 2014-5-22 李忠文
 */
@PetiteBean
public class ProjectJarDAO extends BaseDAO<ProjectJarVO> {
    
    /**
     * 根据项目Id删除项目Jar
     * 
     * 
     * @param projectId 项目Id
     */
    public void deleteProjectJarByProjectId(final String projectId) {
        this.delete("deleteProjectJarByProjectId", projectId);
    }
    
    /**
     * 通过项目ID查询项目对象
     * 
     * @param projectId 项目ID
     * @return 项目
     */
    public List<ProjectJarVO> queryProjectJarByProjectId(final String projectId) {
        return this.queryList("queryProjectJarByProjectId", projectId);
    }
}
