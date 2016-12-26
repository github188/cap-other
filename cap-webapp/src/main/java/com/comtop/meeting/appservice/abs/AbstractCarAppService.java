/******************************************************************************
 * Copyright (C) 2016 
 * ShenZhen ComTop Information Technology Co.,Ltd
 * All Rights Reserved.
 * 本软件为深圳康拓普开发研制。
 * 未经本公司正式书面同意，其他任何个人、团体不得使用、
 * 复制、修改或发布本软件.
 *****************************************************************************/
package com.comtop.meeting.appservice.abs;

import com.comtop.meeting.model.CarVO;
import com.comtop.ipb.cap.runtime.base.appservice.WorkflowForIpbAppService;

import java.util.Map;
import java.util.List;
import java.util.HashMap;

/**
 * 汽车人 业务逻辑处理类
 * 
 * @author CAP超级管理员
 * @since 1.0
 * @version 2016-12-16 CAP超级管理员
 * @param <T> 类泛型参数
 */
public abstract class AbstractCarAppService<T extends CarVO> extends WorkflowForIpbAppService<CarVO> {
	
		//todo
 	/** 汽车人工作流ID */
   	public static final String CAR_PROCESS_ID ="Pro4339322410106";
	   	
    /**
     * 返回流程编码
     * 
     * @return 汽车人工作流ID
     */
    @Override
    public String getProcessId() {
        return CAR_PROCESS_ID;
    }
    
    /**
     * 短信发送时获取业务数据名称，例如：检修单；缺陷单等
     * 
     * @return 工作流名称
     */
    @Override
    public String getDataName() {
        return "汽车人";
    }
	
    /**
     * queryModel
     * 
     * @param queryVO 查询VO
     * @param lst lst
     * @return  List<CarVO>
     * 
     */
    public List<CarVO> queryModel(CarVO queryVO,List<CarVO> lst){
     	Map<String,Object> params = new HashMap<String,Object>();
    	params.put("queryVO", queryVO);
    	params.put("lst", lst);
         return  capBaseCommonDAO.queryList("com.comtop.meeting.model.car_queryModel", params);
     }
      
    /**
     * 查询测试
     * 
     * @param queryVO 查询VO
     * @return  List<CarVO>
     * 
     */
    public List<CarVO> queryTest(CarVO queryVO){
     	CarVO params = queryVO;
         return  capBaseCommonDAO.queryList("com.comtop.meeting.model.car_queryTest", params);
     }
      
}