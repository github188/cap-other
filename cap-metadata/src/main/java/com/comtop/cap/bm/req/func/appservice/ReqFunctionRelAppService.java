/******************************************************************************
 * Copyright (C) 2015 ShenZhen ComTop Information Technology Co.,Ltd
 * All Rights Reserved.
 * 本软件为深圳康拓普开发研制。未经本公司正式书面同意，其他任何个人、团体不得使用、
 * 复制、修改或发布本软件.
 *****************************************************************************/

package com.comtop.cap.bm.req.func.appservice;

import java.util.List;

import com.comtop.cap.bm.req.func.dao.ReqFunctionRelDAO;
import com.comtop.cap.bm.req.func.model.ReqFunctionRelVO;
import com.comtop.cip.jodd.petite.meta.PetiteBean;
import com.comtop.cip.jodd.petite.meta.PetiteInject;
import com.comtop.top.core.base.appservice.BaseAppService;

/**
 * 功能项关系 服务扩展类
 * 
 * @author CAP
 * @since 1.0
 * @version 2015-11-25 CAP
 */
@PetiteBean
public class ReqFunctionRelAppService extends BaseAppService {
    
    /** 注入DAO **/
    @PetiteInject
    protected ReqFunctionRelDAO reqFunctionRelDAO;
    
    /**
     * 
     * 功能项关系
     *
     * @param reqFunctionRel 功能项关系
     * @return 功能项关系
     */
    public List<ReqFunctionRelVO> queryFunctionRel(ReqFunctionRelVO reqFunctionRel) {
        return reqFunctionRelDAO.queryFunctionRel(reqFunctionRel);
    }
    
    /**
     * 
     * 修改功能项关系
     *
     * @param reqFunctionRel 功能项关系
     */
    public void updateFunctionRel(ReqFunctionRelVO reqFunctionRel) {
        reqFunctionRelDAO.updateFunctionRel(reqFunctionRel);
    }
    
    /**
     * 
     * 新增功能项关系
     *
     * @param reqFunctionRel 功能项关系
     * @return Id
     */
    public String insertFunctionRel(ReqFunctionRelVO reqFunctionRel) {
        return reqFunctionRelDAO.insertFunctionRel(reqFunctionRel);
    }
    
    /**
     * 
     * 删除功能项关系
     * 
     * @param reqFunctionRelList 功能项关系
     */
    public void deleteFunctionRel(List<ReqFunctionRelVO> reqFunctionRelList) {
        reqFunctionRelDAO.deleteFunctionRel(reqFunctionRelList);
    }
    
    /**
     * 
     * 检查是否重复关联
     * 
     * @param reqFunctionRelVO 功能项
     * @return 结果
     */
    public boolean checkRelFunctionItemId(ReqFunctionRelVO reqFunctionRelVO) {
        return reqFunctionRelDAO.checkRelFunctionItemId(reqFunctionRelVO);
    }
    
    /**
     * 
     * 功能项关系
     *
     * @param funcitemRelId 功能项关系Id
     * @return 功能项关系
     */
    public ReqFunctionRelVO queryFunctionRelById(String funcitemRelId) {
        return reqFunctionRelDAO.queryFunctionRelById(funcitemRelId);
    }
    
}
