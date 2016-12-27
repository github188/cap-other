/******************************************************************************
 * Copyright (C) 2014 ShenZhen ComTop Information Technology Co.,Ltd
 * All Rights Reserved.
 * 本软件为深圳康拓普开发研制。未经本公司正式书面同意，其他任何个人、团体不得使用、
 * 复制、修改或发布本软件.
 *****************************************************************************/
package com.comtop.cap.bm.metadata.pkg.dao;

import java.util.HashMap;
import java.util.List;
import java.util.Map;

import com.comtop.cip.jodd.petite.meta.PetiteBean;
import com.comtop.cap.bm.metadata.pkg.model.ProjectVO;
import com.comtop.cip.runtime.base.dao.BaseDAO;


/**
 * 项目 数据访问接口类
 * 
 * @author 李忠文
 * @since 1.0
 * @version 2014-5-22 李忠文
 */
@PetiteBean
public class ProjectDAO extends BaseDAO<ProjectVO> {
    
    /**
     * 通过用户ID查询该用户所在项目
     *
     * @param userId 用户ID
     * @return 项目集合
     */
    public List<ProjectVO> queryProjectsByUserId(String userId) {
        Map<String, String> objParam = new HashMap<String, String>();
        objParam.put("userId", userId);
        return this.queryList("queryProjectsByUserId", objParam);
    }
}