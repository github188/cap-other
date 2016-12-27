/******************************************************************************
 * Copyright (C) 2015 ShenZhen ComTop Information Technology Co.,Ltd
 * All Rights Reserved.
 * 本软件为深圳康拓普开发研制。未经本公司正式书面同意，其他任何个人、团体不得使用、
 * 复制、修改或发布本软件.
 *****************************************************************************/

package com.comtop.cap.bm.req.func.appservice;

import com.comtop.cap.base.MDBaseAppservice;
import com.comtop.cap.base.MDBaseDAO;
import com.comtop.cap.bm.req.func.dao.ReqFunctionItemDAO;
import com.comtop.cap.bm.req.func.model.ReqFunctionItemVO;
import com.comtop.cip.jodd.petite.meta.PetiteBean;
import com.comtop.cip.jodd.petite.meta.PetiteInject;

/**
 * 功能项，建立在系统、子系统、目录下面。服务扩展类
 * 
 * @author CAP
 * @since 1.0
 * @version 2015-11-25 CAP
 */
@PetiteBean
public class ReqFunctionItemAppService extends MDBaseAppservice<ReqFunctionItemVO> {
    
    /** 注入DAO **/
    @PetiteInject
    protected ReqFunctionItemDAO reqFunctionItemDAO;
    
    /**
     * 新增 功能项
     * 
     * @param reqFunctionItem 功能项
     * @return Id
     */
    public String insertReqFunctionItem(ReqFunctionItemVO reqFunctionItem) {
        return reqFunctionItemDAO.insertReqFunctionItem(reqFunctionItem);
    }
    
    /**
     * 更新 功能项
     * 
     * @param reqFunctionItem 功能项
     * @return 更新成功与否
     */
    public boolean updateReqFunctionItem(ReqFunctionItemVO reqFunctionItem) {
        return reqFunctionItemDAO.updateReqFunctionItem(reqFunctionItem);
    }
    
    /**
     * 删除 功能项
     * 
     * @param reqFunctionItem 功能项
     * @return 删除成功与否
     */
    public boolean deleteReqFunctionItem(ReqFunctionItemVO reqFunctionItem) {
        return reqFunctionItemDAO.deleteReqFunctionItem(reqFunctionItem);
    }
    
    /**
     * 通过功能项ID查询功能项
     * 
     * @param reqFunctionItemId 功能项ID
     * @return 功能项对象
     */
    public ReqFunctionItemVO queryReqFunctionItemById(String reqFunctionItemId) {
        return reqFunctionItemDAO.queryReqFunctionItemById(reqFunctionItemId);
    }
    
    /**
     * 检查功能项编码是否重复
     * 
     * @param reqFunctionItem 功能项
     * @return 结果
     */
    public int checkReqFunItemCode(ReqFunctionItemVO reqFunctionItem) {
        return reqFunctionItemDAO.checkReqFunItemCode(reqFunctionItem);
    }
    
    /**
     * 
     * @see com.comtop.cap.base.MDBaseAppservice#getDAO()
     */
    @Override
    protected MDBaseDAO<ReqFunctionItemVO> getDAO() {
        return reqFunctionItemDAO;
    }
    
    /**
     * 查询需求功能项以及功能分布
     *
     * @param condition 查询条件
     * @return 需求功能项以及功能分布
     */
    public ReqFunctionItemVO queryReqFunctionItemWithDistributed(ReqFunctionItemVO condition) {
        return reqFunctionItemDAO.queryReqFunctionItemWithDistributed(condition);
    }
    
    /**
     * 更新 排序号
     * 
     * @param reqFunctionItemVO 功能项
     *
     */
    public void updateSortNoById(ReqFunctionItemVO reqFunctionItemVO) {
        reqFunctionItemDAO.updateSortNoById(reqFunctionItemVO);
    }
    
    /**
     * 查询功能项是否有关联子项
     * 
     * @param reqFunctionItem 功能项
     * @return 结果
     */
    public boolean checkSubFunByFunItem(ReqFunctionItemVO reqFunctionItem) {
        return reqFunctionItemDAO.checkSubFunByFunItem(reqFunctionItem);
    }
    
    /**
     * 
     * 检查功能项是否重名
     * 
     * @param reqFunctionItem 功能项
     * @return 结果
     */
    public boolean checkFuncItemName(ReqFunctionItemVO reqFunctionItem) {
        return reqFunctionItemDAO.checkFuncItemName(reqFunctionItem);
    }
}
