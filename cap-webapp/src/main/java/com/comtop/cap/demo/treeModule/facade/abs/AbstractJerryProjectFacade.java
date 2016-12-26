/******************************************************************************
 * Copyright (C) 2016 
 * ShenZhen ComTop Information Technology Co.,Ltd
 * All Rights Reserved.
 * 本软件为深圳康拓普开发研制。
 * 未经本公司正式书面同意，其他任何个人、团体不得使用、
 * 复制、修改或发布本软件.
 *****************************************************************************/
package com.comtop.cap.demo.treeModule.facade.abs;


import com.comtop.cap.demo.treeModule.appservice.JerryProjectAppService;
import com.comtop.cap.demo.treeModule.model.JerryProjectVO;
import com.comtop.cap.runtime.base.util.BeanContextUtil;
import com.comtop.cap.runtime.base.facade.CapWorkflowFacade;

import java.util.ArrayList;
import java.util.List;
import com.comtop.soa.annotation.SoaMethod;

/**
 * 项目业务逻辑处理类门面
 * 
 * @author CAP超级管理员
 * @since 1.0
 * @version 2016-6-14 CAP超级管理员
 * @param <T> 类泛型参数
 */
public abstract class AbstractJerryProjectFacade<T extends JerryProjectVO> extends CapWorkflowFacade {

	
	/** 注入AppService **/
    protected JerryProjectAppService jerryProjectAppService = (JerryProjectAppService)BeanContextUtil.getBean("jerryProjectAppService");
     /**
     * @see com.comtop.cap.runtime.base.facade.CapBaseFacade#getAppService()
     */
    @Override
    public JerryProjectAppService getAppService() {
    	return jerryProjectAppService;
    }
    
    
   
    /**
     * 查询（并且查找级联数据）
     * 
     * @param entityId 查询的实体Id
     * @return  JerryProjectVO
     * 
     */
    @SoaMethod(alias="querySelfAndSubById")   
     public JerryProjectVO querySelfAndSubById(String entityId){
        List<String> lstCascade = new ArrayList<String>();
		lstCascade.add("{\"entityName\":\"JerryProjectTask\", \"entityAttName\":\"relationTasks\"}" );
		return (JerryProjectVO) super.loadCascadeById(loadById(entityId), getCascadeVOList(lstCascade));
     }
    
   
    /**
     * 保存（级联保存）
     * 
     * @param saveVO 保存的实体VO
     * @return  String
     * 
     */
    @SoaMethod(alias="saveSeftAndSub")   
     public String saveSeftAndSub(JerryProjectVO saveVO){
        List<String> lstCascade = new ArrayList<String>();
		lstCascade.add("{\"entityName\":\"JerryProjectTask\", \"entityAttName\":\"relationTasks\"}" );
		return super.saveCascadeVO(saveVO, getCascadeVOList(lstCascade));
     }

}