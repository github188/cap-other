/******************************************************************************
 * Copyright (C) 2016 
 * ShenZhen ComTop Information Technology Co.,Ltd
 * All Rights Reserved.
 * 本软件为深圳康拓普开发研制。
 * 未经本公司正式书面同意，其他任何个人、团体不得使用、
 * 复制、修改或发布本软件.
 *****************************************************************************/
package com.comtop.cap.demo.treeModule.appservice;

import com.comtop.cip.jodd.petite.meta.PetiteBean;
import com.comtop.cap.demo.treeModule.model.JerryProjectTaskVO;
import com.comtop.cap.demo.treeModule.appservice.abs.AbstractJerryProjectTaskAppService;


/**
 * JerryProjectTask服务扩展类
 * 
 * @author CAP超级管理员
 * @since 1.0
 * @version 2016-6-14 CAP超级管理员
 * @param <T> 类泛型
 */
@PetiteBean(value="jerryProjectTaskAppService")
public class JerryProjectTaskAppService<T extends JerryProjectTaskVO> extends AbstractJerryProjectTaskAppService<JerryProjectTaskVO> {

   	 //TODO 请在此编写自己的业务代码
}
