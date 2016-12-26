/******************************************************************************
 * Copyright (C) 2016 
 * ShenZhen ComTop Information Technology Co.,Ltd
 * All Rights Reserved.
 * 本软件为深圳康拓普开发研制。
 * 未经本公司正式书面同意，其他任何个人、团体不得使用、
 * 复制、修改或发布本软件.
 *****************************************************************************/
package com.comtop.carstorage.appservice;

import com.comtop.carstorage.appservice.abs.AbstractCarstorageAppService;
import com.comtop.carstorage.model.CarstorageVO;
import com.comtop.cip.jodd.petite.meta.PetiteBean;

/**
 * 车库管理服务扩展类
 * 
 * @author CAP超级管理员
 * @since 1.0
 * @version 2016-5-4 CAP超级管理员
 * @param <T>
 *            类泛型
 */
@PetiteBean
public class CarstorageAppService<T extends CarstorageVO> extends
		AbstractCarstorageAppService<CarstorageVO> {

	// TODO 请在此编写自己的业务代码
}
