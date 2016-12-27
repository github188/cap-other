/* Copyright (C) 2015 ShenZhen ComTop Information Technology Co.,Ltd
 * All Rights Reserved.
 * 本软件为深圳康拓普开发研制。未经本公司正式书面同意，其他任何个人、团体不得使用、
 * 复制、修改或发布本软件.
 *****************************************************************************/

package com.comtop.cap.bm.req.func.facade;

import java.util.ArrayList;
import java.util.List;

import com.comtop.cap.bm.req.func.appservice.ReqTreeAppService;
import com.comtop.cap.bm.req.func.model.ReqTreeVO;
import com.comtop.cip.common.util.CAPCollectionUtils;
import com.comtop.cip.common.util.CAPStringUtils;
import com.comtop.cip.jodd.petite.meta.PetiteBean;
import com.comtop.cip.jodd.petite.meta.PetiteInject;
import com.comtop.top.core.base.facade.BaseFacade;

/**
 * 功能项需求视图扩展实现
 * 
 * @author CAP
 * @since 1.0
 * @version 2015-11-25 CAP
 */
@PetiteBean
public class ReqTreeFacade extends BaseFacade {
    
    /** 注入AppService **/
    @PetiteInject
    protected ReqTreeAppService reqTreeAppService;
    
    /**
     * 读取 功能项需求视图 列表
     * 
     * @param condition 查询条件
     * @return 功能项需求视图列表
     */
    public List<ReqTreeVO> queryViewReqTreeList(ReqTreeVO condition) {
        return reqTreeAppService.queryViewReqTreeList(condition);
    }
    
    /**
     * 读取 功能项需求视图数据条数
     * 
     * @param condition 查询条件
     * @return 功能项需求视图数据条数
     */
    public int queryViewReqTreeCount(ReqTreeVO condition) {
        return reqTreeAppService.queryViewReqTreeCount(condition);
    }
    
    /**
     * 功能项树子节点加载方法
     * 
     * @param parentId 父节点Id
     * @return 子节点
     */
    public List<ReqTreeVO> queryViewReqListById(String parentId) {
        return reqTreeAppService.queryViewReqListById(parentId);
    }
    
    /**
     * 根据ID集合、对象类型查询对应的 功能项需求视图（包含业务领域、功能项、功能子项）
     * 
     * @param type 类型,1:业务域、2：功能项、3：功能子项
     * @param ids id集合
     * @return 符合条件的功能项需求视图VO集合
     */
    public List<ReqTreeVO> queryViewReqTreeListByTypeAndIds(String type, List<String> ids) {
        if (CAPStringUtils.isBlank(type) || CAPCollectionUtils.isEmpty(ids)) {
            return new ArrayList<ReqTreeVO>(0);
        }
        return reqTreeAppService.queryViewReqTreeListByTypeAndIds(type, ids);
    }
    
    /**
     * 根据ID查询父子列表
     * 
     * @param id id
     * @return 符合条件的功能项需求视图VO集合
     */
    public List<ReqTreeVO> queryViewPTreeById(String id) {
        return reqTreeAppService.queryViewPTreeById(id);
    }
}
