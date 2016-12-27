/******************************************************************************
 * Copyright (C) 2014 ShenZhen ComTop Information Technology Co.,Ltd
 * All Rights Reserved.
 * 本软件为深圳康拓普开发研制。未经本公司正式书面同意，其他任何个人、团体不得使用、
 * 复制、修改或发布本软件.
 *****************************************************************************/

package com.comtop.cap.bm.metadata.pkg.facade;

import com.comtop.cap.bm.metadata.pkg.model.ProjectJarVO;

/**
 * 项目依赖包元数据查询接口
 * <P>
 * 项目依赖包元数据是描述该项目中需要增加哪些第三方的依赖包。由于CIP项目使用maven进行关系，该项目依赖包需要满足maven依赖定义的形式。
 * 
 * @author 李忠文
 * @since 1.0
 * @version 2014-6-27 李忠文
 */
public interface IProjectJarQueryFacade {
    
    /**
     * 通过项目依赖包ID查询项目依赖包对象
     * 
     * @param projectJarId 项目依赖包对象Id
     * @return 项目依赖包
     * 
     */
    ProjectJarVO queryProjectJarById(final String projectJarId);
}
