/******************************************************************************
 * Copyright (C) 2015 ShenZhen ComTop Information Technology Co.,Ltd
 * All Rights Reserved.
 * 本软件为深圳康拓普开发研制。未经本公司正式书面同意，其他任何个人、团体不得使用、
 * 复制、修改或发布本软件.
 *****************************************************************************/

package com.comtop.cip.graph.entity.facade;

import com.comtop.cip.graph.entity.model.GraphModuleVO;

/**
 * 模型实体接口
 * 
 * @author 陈志伟
 * @since 1.0
 * @version 2015-7-17 陈志伟
 */
public interface IGraphFacade {

	/**
	 * 通过包ID查询该包中所有实体
	 * 
	 * @param packageId
	 *            包ID
	 * @return 实体对象集合
	 */
	public GraphModuleVO queryGraphEntityByPackageId(final String packageId);
	
	 /**
     * 
     * 查询第三层子模块列表
     *
     * @param moduleId 图形模块实体id
     * @return 图形模块实体
     */
    public GraphModuleVO queryThreeChildrenModuleVOList(final String moduleId);

}
