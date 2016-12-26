/******************************************************************************
 * Copyright (C) 2016 
 * ShenZhen ComTop Information Technology Co.,Ltd
 * All Rights Reserved.
 * 本软件为深圳康拓普开发研制。
 * 未经本公司正式书面同意，其他任何个人、团体不得使用、
 * 复制、修改或发布本软件.
 *****************************************************************************/
package com.comtop.hr.appservice;

import com.comtop.cip.jodd.petite.meta.PetiteBean;
import com.comtop.hr.model.PersonVO;
import com.comtop.hr.appservice.abs.AbstractPersonAppService;


/**
 * 部门员工服务扩展类
 * 
 * @author CAP超级管理员
 * @since 1.0
 * @version 2016-12-16 CAP超级管理员
 * @param <T> 类泛型
 */
@PetiteBean(value="personAppService")
public class PersonAppService<T extends PersonVO> extends AbstractPersonAppService<PersonVO> {

   	 //TODO 请在此编写自己的业务代码
}
