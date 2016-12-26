/******************************************************************************
 * Copyright (C) 2016 
 * ShenZhen ComTop Information Technology Co.,Ltd
 * All Rights Reserved.
 * 本软件为深圳康拓普开发研制。
 * 未经本公司正式书面同意，其他任何个人、团体不得使用、
 * 复制、修改或发布本软件.
 *****************************************************************************/
package com.comtop.carstorage.facade;

import java.util.List;
import java.util.Map;

import org.springframework.stereotype.Service;

import com.comtop.cap.runtime.base.model.CapBaseVO;
import com.comtop.carstorage.facade.abs.AbstractCarstorageFacade;
import com.comtop.carstorage.model.CarstorageVO;


/**
 * 车库管理扩展实现
 * 
 * @author CAP超级管理员
 * @since 1.0
 * @version 2016-5-4 CAP超级管理员
 */
@Service
public class CarstorageFacade extends AbstractCarstorageFacade<CarstorageVO> {
	//TODO 请在此编写自己的业务代码
	
	@Override
	public String save(CapBaseVO vo) {
		return super.save(vo);
	}
	
	/** 
	 *
	 * @return xx
	 *		
	 * @see com.comtop.carstorage.facade.abs.AbstractCarstorageFacade#queryA(java.util.Map)
	 */
	@Override
	public List<CarstorageVO> queryA(Map<String, CarstorageVO> ss) {
		
		ss.put("snames", null);
		return super.queryA(ss);
	}

}
