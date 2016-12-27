/******************************************************************************
 * Copyright (C) 2014 ShenZhen ComTop Information Technology Co.,Ltd
 * All Rights Reserved.
 * 本软件为深圳康拓普开发研制。未经本公司正式书面同意，其他任何个人、团体不得使用、
 * 复制、修改或发布本软件.
 *****************************************************************************/

package com.comtop.cap.bm.metadata.inject.injecter;



/**
 * 元数据注入器的接口
 *
 *
 * @author 凌晨
 * @since jdk1.6
 * @version 2016年1月4日 凌晨
 */
public interface IMetaDataInjecter {
    
    /**
     * 元数据注入
     *
     * @param fillData 注入的数据
     * @param templateObject 所有的模板对象
     */
    void inject(Object fillData,Object templateObject);
}
