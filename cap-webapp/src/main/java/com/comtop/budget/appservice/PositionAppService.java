/******************************************************************************
 * Copyright (C) 2016 
 * ShenZhen ComTop Information Technology Co.,Ltd
 * All Rights Reserved.
 * 本软件为深圳康拓普开发研制。
 * 未经本公司正式书面同意，其他任何个人、团体不得使用、
 * 复制、修改或发布本软件.
 *****************************************************************************/
package com.comtop.budget.appservice;

import com.comtop.cip.jodd.petite.meta.PetiteBean;
import com.comtop.budget.model.PositionVO;
import com.comtop.budget.appservice.abs.AbstractPositionAppService;


/**
 * 职位服务扩展类
 * 
 * @author CAP超级管理员
 * @since 1.0
 * @version 2016-9-13 CAP超级管理员
 * @param <T> 类泛型
 */
@PetiteBean(value="positionAppService")
public class PositionAppService<T extends PositionVO> extends AbstractPositionAppService<PositionVO> {

   	 //TODO 请在此编写自己的业务代码
}
