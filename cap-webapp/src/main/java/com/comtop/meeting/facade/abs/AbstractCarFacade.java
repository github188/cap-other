/******************************************************************************
 * Copyright (C) 2016 
 * ShenZhen ComTop Information Technology Co.,Ltd
 * All Rights Reserved.
 * 本软件为深圳康拓普开发研制。
 * 未经本公司正式书面同意，其他任何个人、团体不得使用、
 * 复制、修改或发布本软件.
 *****************************************************************************/
package com.comtop.meeting.facade.abs;


import com.comtop.meeting.appservice.CarAppService;
import com.comtop.meeting.model.CarVO;
import com.comtop.cap.runtime.base.util.BeanContextUtil;
import com.comtop.ipb.cap.runtime.base.facade.WorkflowForIpbFacade;

import java.util.ArrayList;
import java.util.List;
import com.comtop.soa.annotation.SoaMethod;

/**
 * 汽车人业务逻辑处理类门面
 * 
 * @author CAP超级管理员
 * @since 1.0
 * @version 2016-12-16 CAP超级管理员
 * @param <T> 类泛型参数
 */
public abstract class AbstractCarFacade<T extends CarVO> extends WorkflowForIpbFacade {

	
	/** 注入AppService **/
    protected CarAppService carAppService = (CarAppService)BeanContextUtil.getBean("carAppService");
	
     /**
     * @see com.comtop.cap.runtime.base.facade.CapBaseFacade#getAppService()
     */
    @Override
    public CarAppService getAppService() {
    	return carAppService;
    }
    
    
   
    /**
     * queryModel
     * 
     * @param queryVO 查询VO
     * @param lst lst
     * @return  List<CarVO>
     * 
     */
    @SoaMethod(alias="queryModel")   
     public List<CarVO> queryModel(CarVO queryVO,List<CarVO> lst){
    	return getAppService().queryModel(queryVO,lst);
     }
    
   
    /**
     * 查询测试
     * 
     * @param queryVO 查询VO
     * @return  List<CarVO>
     * 
     */
    @SoaMethod(alias="queryTest")   
     public List<CarVO> queryTest(CarVO queryVO){
    	return getAppService().queryTest(queryVO);
     }
    
   
    /**
     * 级联操作
     * 
     * @param entityId 查询的实体Id
     * @return  CarVO
     * 
     */
    @SoaMethod(alias="cascade")   
     public CarVO cascade(String entityId){
        List<String> lstCascade = new ArrayList<String>();
		return (CarVO) super.loadCascadeById(loadById(entityId), getCascadeVOList(lstCascade));
     }

}