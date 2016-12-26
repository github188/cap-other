/******************************************************************************
 * Copyright (C) 2016 
 * ShenZhen ComTop Information Technology Co.,Ltd
 * All Rights Reserved.
 * 本软件为深圳康拓普开发研制。
 * 未经本公司正式书面同意，其他任何个人、团体不得使用、
 * 复制、修改或发布本软件.
 *****************************************************************************/
package com.comtop.tech.appservice.abs;

import com.comtop.tech.model.TechVO;
import com.comtop.cap.runtime.base.appservice.CapBaseAppService;


/**
 * 科技信息 业务逻辑处理类
 * 
 * @author CAP超级管理员
 * @since 1.0
 * @version 2016-12-2 CAP超级管理员
 * @param <T> 类泛型参数
 */
public abstract class AbstractTechAppService<T extends TechVO> extends CapBaseAppService<TechVO> {
	
		//todo
	
    /**
     * 自定义SQL查询
     * 
     * @return  String
     * 
     */
    public String customSQL(){
    	Object params = null;
        return (String)capBaseCommonDAO.selectOne("com.comtop.tech.model.tech_customSQL", params);
     }
      
}