/******************************************************************************
 * Copyright (C) 2014 ShenZhen ComTop Information Technology Co.,Ltd
 * All Rights Reserved.
 * 本软件为深圳康拓普开发研制。未经本公司正式书面同意，其他任何个人、团体不得使用、
 * 复制、修改或发布本软件.
 *****************************************************************************/

package com.comtop.cap.bm.metadata.pkg.facade;

import java.util.List;

import com.comtop.cap.bm.metadata.pkg.model.ProjectVO;

/**
 * 项目元数据查询接口
 * <P>
 * 项目元数据是对CIP项目的一种描述，用于根据用户创建的CIP项目在Eclipse中生成相应的工程。项目元数据也是该项目中所有元数据的根节点。
 * 
 * @author 李忠文
 * @since 1.0
 * @version 2014-6-27 李忠文
 */
public interface IProjectQueryFacade {
    
    /**
     * 通过项目ID查询项目对象
     * 
     * @param projectId 项目对象Id
     * @return 项目
     * 
     */
    ProjectVO queryProjectById(final String projectId);
    
    /**
     * 通过用户ID查询该用户所在项目
     *
     * @param userId 用户ID
     * @return 项目集合
     */
    List<ProjectVO> queryProjectsByUserId(final String userId);
    
}
