/******************************************************************************
 * Copyright (C) 2014 ShenZhen ComTop Information Technology Co.,Ltd
 * All Rights Reserved.
 * 本软件为深圳康拓普开发研制。未经本公司正式书面同意，其他任何个人、团体不得使用、
 * 复制、修改或发布本软件.
 *****************************************************************************/

package com.comtop.cip.graph.entity.facade;

import com.comtop.cip.graph.entity.model.GraphModuleVO;

/**
 * 模块依赖图门面类
 *
 * @author 刘城
 * @since jdk1.6
 * @version 2016年11月1日 刘城
 */
public interface IGraphModuleFacade {
    
    /**
     * 通过模块ID获取模块图形关系数据
     * 
     * @param packageId 模块ID
     * @return 模块图形关系数据
     */
    public GraphModuleVO queryGraphModuleByModuleId(final String packageId);
    
    /**
     * 通过模块ID获取模块图形名称
     * 
     * @param packageId 模块ID
     * @return 模块图形关系数据
     */
    public GraphModuleVO queryGraphModuleNameByModuleId(final String packageId);
    
    /**
     * 存储模块关系
     * 将当前系统的所有关联关系保存起来
     */
    public void saveGraphModuleVORelations();
    
}
