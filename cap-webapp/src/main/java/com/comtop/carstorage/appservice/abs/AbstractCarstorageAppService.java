/******************************************************************************
 * Copyright (C) 2016 
 * ShenZhen ComTop Information Technology Co.,Ltd
 * All Rights Reserved.
 * 本软件为深圳康拓普开发研制。
 * 未经本公司正式书面同意，其他任何个人、团体不得使用、
 * 复制、修改或发布本软件.
 *****************************************************************************/
package com.comtop.carstorage.appservice.abs;

import com.comtop.carstorage.model.CarstorageVO;
import com.comtop.cap.runtime.base.appservice.CapBaseAppService;

import java.util.Map;
import java.util.List;
import java.util.HashMap;

/**
 * 车库管理 业务逻辑处理类
 * 
 * @author CAP超级管理员
 * @since 1.0
 * @version 2016-12-15 CAP超级管理员
 * @param <T> 类泛型参数
 */
public abstract class AbstractCarstorageAppService<T extends CarstorageVO> extends CapBaseAppService<CarstorageVO> {
	
		//todo
	
    /**
     * 获取树所有数据
     * 
     * @param car car
     * @return  List<CarstorageVO>
     * 
     */
    public List<CarstorageVO> getTreeAllData(CarstorageVO car){
     	CarstorageVO params = car;
         return  capBaseCommonDAO.queryList("com.comtop.carstorage.model.carstorage_getTreeAllData", params);
     }
      
    /**
     * 获取子节点数据
     * 
     * @param car car
     * @return  List<CarstorageVO>
     * 
     */
    public List<CarstorageVO> getChildData(CarstorageVO car){
     	CarstorageVO params = car;
         return  capBaseCommonDAO.queryList("com.comtop.carstorage.model.carstorage_getChildData", params);
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
    public List<CarstorageVO> manyParam(List<CarstorageVO> lst,String str,CarstorageVO vo,Map<String,CarstorageVO> map,Object obj){
     	Map<String,Object> params = new HashMap<String,Object>();
    	params.put("lst", lst);
    	params.put("str", str);
    	params.put("vo", vo);
    	params.put("map", map);
    	params.put("obj", obj);
         return  capBaseCommonDAO.queryList("com.comtop.carstorage.model.carstorage_manyParam", params);
     }
      
    /**
     * xxx
     * 
     * @param ss sss
     * @return  List<CarstorageVO>
     * 
     */
    public List<CarstorageVO> queryA(Map<String,CarstorageVO> ss){
     	Map<String,CarstorageVO> params = ss;
         return  capBaseCommonDAO.queryList("com.comtop.carstorage.model.carstorage_queryA", params);
     }
      
    /**
     * listA
     * 
     * @param list list
     * @return  CarstorageVO
     * 
     */
    public CarstorageVO listA(List<CarstorageVO> list){
     	List<CarstorageVO> params = list;
        return (CarstorageVO)capBaseCommonDAO.selectOne("com.comtop.carstorage.model.carstorage_listA", params);
     }
      
}