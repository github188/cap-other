/******************************************************************************
 * Copyright (C) 2016 
 * ShenZhen ComTop Information Technology Co.,Ltd
 * All Rights Reserved.
 * 本软件为深圳康拓普开发研制。
 * 未经本公司正式书面同意，其他任何个人、团体不得使用、
 * 复制、修改或发布本软件.
 *****************************************************************************/
package com.comtop.carstorage.facade.abs;


import com.comtop.carstorage.appservice.CarstorageAppService;
import com.comtop.carstorage.model.CarstorageVO;
import com.comtop.cap.runtime.base.util.BeanContextUtil;
import com.comtop.cap.runtime.base.facade.CapBaseFacade;

import java.util.Map;
import java.util.List;
import com.comtop.soa.annotation.SoaMethod;

/**
 * 车库管理业务逻辑处理类门面
 * 
 * @author CAP超级管理员
 * @since 1.0
 * @version 2016-12-15 CAP超级管理员
 * @param <T> 类泛型参数
 */
public abstract class AbstractCarstorageFacade<T extends CarstorageVO> extends CapBaseFacade {

	
	/** 注入AppService **/
    protected CarstorageAppService carstorageAppService = (CarstorageAppService)BeanContextUtil.getBean("carstorageAppService");
	
     /**
     * @see com.comtop.cap.runtime.base.facade.CapBaseFacade#getAppService()
     */
    @Override
    public CarstorageAppService getAppService() {
    	return carstorageAppService;
    }
    
    
   
    /**
     * 获取树所有数据
     * 
     * @param car car
     * @return  List<CarstorageVO>
     * 
     */
    @SoaMethod(alias="getTreeAllData")   
     public List<CarstorageVO> getTreeAllData(CarstorageVO car){
    	return getAppService().getTreeAllData(car);
     }
    
   
    /**
     * 获取子节点数据
     * 
     * @param car car
     * @return  List<CarstorageVO>
     * 
     */
    @SoaMethod(alias="getChildData")   
     public List<CarstorageVO> getChildData(CarstorageVO car){
    	return getAppService().getChildData(car);
     }
    
   
    /**
     * manyParam
     * 
     * @param lst lst
     * @param str str
     * @param vo vo
     * @param map map
     * @param obj obj
     * @return  List<CarstorageVO>
     * 
     */
    @SoaMethod(alias="manyParam")   
     public List<CarstorageVO> manyParam(List<CarstorageVO> lst,String str,CarstorageVO vo,Map<String,CarstorageVO> map,Object obj){
    	return getAppService().manyParam(lst,str,vo,map,obj);
     }
    
   
    /**
     * xxx
     * 
     * @param ss sss
     * @return  List<CarstorageVO>
     * 
     */
    @SoaMethod(alias="queryA")   
     public List<CarstorageVO> queryA(Map<String,CarstorageVO> ss){
    	return getAppService().queryA(ss);
     }
    
   
    /**
     * listA
     * 
     * @param list list
     * @return  CarstorageVO
     * 
     */
    @SoaMethod(alias="listA")   
     public CarstorageVO listA(List<CarstorageVO> list){
    	return getAppService().listA(list);
     }

}