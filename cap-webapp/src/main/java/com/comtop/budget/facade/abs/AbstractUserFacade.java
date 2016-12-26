/******************************************************************************
 * Copyright (C) 2016 
 * ShenZhen ComTop Information Technology Co.,Ltd
 * All Rights Reserved.
 * 本软件为深圳康拓普开发研制。
 * 未经本公司正式书面同意，其他任何个人、团体不得使用、
 * 复制、修改或发布本软件.
 *****************************************************************************/
package com.comtop.budget.facade.abs;


import com.comtop.budget.appservice.UserAppService;
import com.comtop.budget.model.UserVO;
import com.comtop.cap.runtime.base.util.BeanContextUtil;
import com.comtop.cap.runtime.base.facade.CapWorkflowFacade;

import java.util.ArrayList;
import java.util.List;
import com.comtop.soa.annotation.SoaMethod;

/**
 * 用户表业务逻辑处理类门面
 * 
 * @author CAP超级管理员
 * @since 1.0
 * @version 2016-10-8 CAP超级管理员
 * @param <T> 类泛型参数
 */
public abstract class AbstractUserFacade<T extends UserVO> extends CapWorkflowFacade {

	
	/** 注入AppService **/
    protected UserAppService userAppService = (UserAppService)BeanContextUtil.getBean("user2AppService");
     /**
     * @see com.comtop.cap.runtime.base.facade.CapBaseFacade#getAppService()
     */
    @Override
    public UserAppService getAppService() {
    	return userAppService;
    }
    
    
   
    /**
     * 级联保存
     * 
     * @param saveVO 保存的实体VO
     * @return  String
     * 
     */
    @SoaMethod(alias="cascadeSave")   
     public String cascadeSave(UserVO saveVO){
        List<String> lstCascade = new ArrayList<String>();
		lstCascade.add("{\"entityName\":\"Position\", \"sourceEntityAliasName\":\"user2\", \"targetEntityAliasName\":\"position\", \"entityAttName\":\"relationOneToMany\"}" );
		return super.saveCascadeVO(saveVO, getCascadeVOList(lstCascade));
     }
    
   
    /**
     * 级联读取
     * 
     * @param entityId 查询的实体Id
     * @return  UserVO
     * 
     */
    @SoaMethod(alias="cascadeRead")   
     public UserVO cascadeRead(String entityId){
        List<String> lstCascade = new ArrayList<String>();
		lstCascade.add("{\"entityName\":\"Position\", \"sourceEntityAliasName\":\"user2\", \"targetEntityAliasName\":\"position\", \"entityAttName\":\"relationOneToMany\"}" );
		return (UserVO) super.loadCascadeById(loadById(entityId), getCascadeVOList(lstCascade));
     }
    
   
    /**
     * 级联删除
     * 
     * @param lstDelVO 删除的实体VO集合
     * @return  Boolean
     * 
     */
    @SoaMethod(alias="casecadeDelete")   
     public Boolean casecadeDelete(List<UserVO> lstDelVO){
        List<String> lstCascade = new ArrayList<String>();
		lstCascade.add("{\"entityName\":\"Position\", \"sourceEntityAliasName\":\"user2\", \"targetEntityAliasName\":\"position\", \"entityAttName\":\"relationOneToMany\"}" );
		return super.deleteCascadeList(lstDelVO, getCascadeVOList(lstCascade));
     }
    
    
   
    /**
     * 级联新增
     * 
     * @param insertVO 新增的实体VO
     * @return  String
     * 
     */
    @SoaMethod(alias="cascadeInsert")   
     public String cascadeInsert(UserVO insertVO){
        List<String> lstCascade = new ArrayList<String>();
		lstCascade.add("{\"entityName\":\"Position\", \"sourceEntityAliasName\":\"user2\", \"targetEntityAliasName\":\"position\", \"entityAttName\":\"relationOneToMany\"}" );
		return super.insertCascadeVO(insertVO, getCascadeVOList(lstCascade));
     }
    
   
    /**
     * 级联更新
     * 
     * @param updateVO 更新的实体VO
     * @return  Boolean
     * 
     */
    @SoaMethod(alias="cascadeUpdate")   
     public Boolean cascadeUpdate(UserVO updateVO){
        List<String> lstCascade = new ArrayList<String>();
		return super.updateCascadeVO(updateVO, getCascadeVOList(lstCascade));
     }
    
   
    /**
     * 级联更新2
     * 
     * @param entityId 查询的实体Id
     * @return  UserVO
     * 
     */
    @SoaMethod(alias="casecadeUp2")   
     public UserVO casecadeUp2(String entityId){
        List<String> lstCascade = new ArrayList<String>();
		lstCascade.add("{\"entityName\":\"Position\", \"sourceEntityAliasName\":\"user2\", \"targetEntityAliasName\":\"position\", \"entityAttName\":\"relationOneToMany\"}" );
		return (UserVO) super.loadCascadeById(loadById(entityId), getCascadeVOList(lstCascade));
     }

}