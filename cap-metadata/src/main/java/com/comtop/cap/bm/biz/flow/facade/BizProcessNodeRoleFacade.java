/******************************************************************************
 * Copyright (C) 2015 ShenZhen ComTop Information Technology Co.,Ltd
 * All Rights Reserved.
 * 本软件为深圳康拓普开发研制。未经本公司正式书面同意，其他任何个人、团体不得使用、
 * 复制、修改或发布本软件.
 *****************************************************************************/
package com.comtop.cap.bm.biz.flow.facade;

import java.util.List;

import com.comtop.cap.bm.biz.flow.appservice.BizProcessNodeRoleAppService;
import com.comtop.cap.bm.biz.flow.model.BizProcessNodeRoleVO;
import com.comtop.cip.jodd.petite.meta.PetiteBean;
import com.comtop.cip.jodd.petite.meta.PetiteInject;
import com.comtop.cap.runtime.base.facade.BaseFacade;

/**
 * 业务模型-流程角色关联表 业务逻辑处理类 门面
 * 
 * @author CAP
 * @since 1.0
 * @version 2015-12-29 CAP
 */
@PetiteBean
public class BizProcessNodeRoleFacade extends BaseFacade {
   /** 注入AppService **/
    @PetiteInject
    protected BizProcessNodeRoleAppService bizProcessNodeRoleAppService ;
    
    /**
     * 通过节点id查询查询节点和角色关联对象
     * @param bizProcessNodeId 节点id
     * @return 查询节点和角色关联对象
     */
	public BizProcessNodeRoleVO queryBizProcessNodeRoleByNodeId(String bizProcessNodeId) {
		return bizProcessNodeRoleAppService.queryBizProcessNodeRoleByNodeId(bizProcessNodeId);
	}
	
	/**
	 * 通过节点id删除数据
	 * @param bizProcessNodeId 节点id
	 */
	public void deleteProcessNodeRoleFacadeByNodeId(String bizProcessNodeId) {
		 bizProcessNodeRoleAppService.deleteProcessNodeRoleFacadeByNodeId(bizProcessNodeId);
	}
	/**
	 *  批量新增节点和角色关联对象数据
	 * @param bizProcessNodeRoleVOs 节点和角色关联对象集合
	 */
	public void saveBizProcessNodeRoleVOs(List<BizProcessNodeRoleVO> bizProcessNodeRoleVOs) {
		for(BizProcessNodeRoleVO nodeRoleVO : bizProcessNodeRoleVOs){
			bizProcessNodeRoleAppService.insert(nodeRoleVO);
		}
	}
    
}