/******************************************************************************
 * Copyright (C) 2014 ShenZhen ComTop Information Technology Co.,Ltd
 * All Rights Reserved.
 * 本软件为深圳康拓普开发研制。未经本公司正式书面同意，其他任何个人、团体不得使用、
 * 复制、修改或发布本软件.
 *****************************************************************************/

package com.comtop.cap.bm.metadata.base.inter;

/**
 * 用于soa注册接口，通过实现方法区分传入的对象类型
 * 
 * @author 林玉千
 * @since jdk1.6
 * @version 2016-6-28 林玉千
 */
public interface SoaRegisterBaseData {
    
    /**
     * 
     * @return 获取对象类型
     */
    String gainObjectType();
}
