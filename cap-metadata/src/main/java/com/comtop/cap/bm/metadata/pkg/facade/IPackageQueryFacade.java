/******************************************************************************
 * Copyright (C) 2014 ShenZhen ComTop Information Technology Co.,Ltd
 * All Rights Reserved.
 * 本软件为深圳康拓普开发研制。未经本公司正式书面同意，其他任何个人、团体不得使用、
 * 复制、修改或发布本软件.
 *****************************************************************************/

package com.comtop.cap.bm.metadata.pkg.facade;

import com.comtop.cap.bm.metadata.pkg.model.PackageVO;

/**
 * 包元数据查询类接口
 * <P>
 * 包元数据提供元数据的Namespace管理，同时也提供了另一种分类和查看的方式。包是类似于目录结构的一个树状模型。也可以认为包的元数据与java中包的概念等价。
 * 
 * @author 李忠文
 * @since 1.0
 * @version 2014-6-27 李忠文
 */
public interface IPackageQueryFacade {
    
    /**
     * 通过包ID查询包对象
     * 
     * @param packageId 包对象Id
     * @return 包
     */
    PackageVO queryPackageById(final String packageId);
    
    /**
     * 通过包路径查询包对象
     * 
     * @param packagePath 包路径
     * @return 包
     */
    PackageVO queryPackageByFullPath(final String packagePath);
    
}
