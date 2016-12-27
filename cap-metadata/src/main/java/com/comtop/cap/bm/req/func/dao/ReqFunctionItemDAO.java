/******************************************************************************
 * Copyright (C) 2015 ShenZhen ComTop Information Technology Co.,Ltd
 * All Rights Reserved.
 * 本软件为深圳康拓普开发研制。未经本公司正式书面同意，其他任何个人、团体不得使用、
 * 复制、修改或发布本软件.
 *****************************************************************************/

package com.comtop.cap.bm.req.func.dao;

import java.util.List;

import com.comtop.cap.base.MDBaseDAO;
import com.comtop.cap.bm.req.func.model.ReqFunctionDistributedVO;
import com.comtop.cap.bm.req.func.model.ReqFunctionItemVO;
import com.comtop.cap.bm.req.func.model.ReqFunctionRelFlowVO;
import com.comtop.cap.bm.req.func.model.ReqFunctionRelItemsVO;
import com.comtop.cip.jodd.jtx.JtxPropagationBehavior;
import com.comtop.cip.jodd.jtx.meta.Transaction;
import com.comtop.cip.jodd.petite.meta.PetiteBean;
import com.comtop.cip.jodd.petite.meta.PetiteInject;

/**
 * 功能项，建立在系统、子系统、目录下面。扩展DAO
 * 
 * @author CAP
 * @since 1.0
 * @version 2015-11-25 CAP
 */
@PetiteBean
public class ReqFunctionItemDAO extends MDBaseDAO<ReqFunctionItemVO> {
    
    /** 注入DAO **/
    @PetiteInject
    protected ReqFunctionRelFlowDAO reqFunctionRelFlowDAO;
    
    /** 注入DAO **/
    @PetiteInject
    protected ReqFunctionDistributedDAO reqFunctionDistributedDAO;
    
    /** 注入DAO **/
    @PetiteInject
    protected ReqFunctionRelItemsDAO reqFunctionRelItemsDAO;
    
    /**
     * 新增 功能项
     * 
     * @param reqFunctionItem 功能项
     * @return Id
     */
    @Transaction(propagation = JtxPropagationBehavior.PROPAGATION_REQUIRED, readOnly = false)
    public String insertReqFunctionItem(ReqFunctionItemVO reqFunctionItem) {
        String result = (String) insert(reqFunctionItem);
        if (reqFunctionItem.getReqFunctionRelFlow() != null && !reqFunctionItem.getReqFunctionRelFlow().isEmpty()) {
            List<ReqFunctionRelFlowVO> reqFunctionRelFlow = reqFunctionItem.getReqFunctionRelFlow();
            for (ReqFunctionRelFlowVO flowVO : reqFunctionRelFlow) {
                flowVO.setFunctionItemId(result);
                reqFunctionRelFlowDAO.insertRelation(flowVO);
            }
        }
        if (reqFunctionItem.getReqFunctionDistributed() != null
            && !reqFunctionItem.getReqFunctionDistributed().isEmpty()) {
            List<ReqFunctionDistributedVO> reqFunctionDistributedVO = reqFunctionItem.getReqFunctionDistributed();
            for (ReqFunctionDistributedVO distributedVO : reqFunctionDistributedVO) {
                distributedVO.setItemId(result);
                if (distributedVO.getDataFrom() == null) {
                    distributedVO.setDataFrom(0);
                }
                reqFunctionDistributedDAO.insertRelationToFunItem(distributedVO);
            }
        }
        if (reqFunctionItem.getReqFunctionRelItems() != null && !reqFunctionItem.getReqFunctionRelItems().isEmpty()) {
            List<ReqFunctionRelItemsVO> reqFunctionRelItemsVO = reqFunctionItem.getReqFunctionRelItems();
            for (ReqFunctionRelItemsVO itemsVO : reqFunctionRelItemsVO) {
                itemsVO.setFunctionId(result);
                reqFunctionRelItemsDAO.insertRelationToFunItem(itemsVO);
            }
        }
        return result;
    }
    
    /**
     * 更新 功能项
     * 
     * @param reqFunctionItem 功能项
     * @return 更新成功与否
     */
    @Transaction(propagation = JtxPropagationBehavior.PROPAGATION_REQUIRED, readOnly = false)
    public boolean updateReqFunctionItem(ReqFunctionItemVO reqFunctionItem) {
        reqFunctionRelItemsDAO.deleteFunctionRelItemByFunItemId(reqFunctionItem.getId());
        reqFunctionRelFlowDAO.deleteFunctionRelFlowByFunItemId(reqFunctionItem.getId());
        reqFunctionDistributedDAO.deleteFunDistributeByFunItemId(reqFunctionItem.getId());
        if (reqFunctionItem.getReqFunctionRelFlow() != null) {
            List<ReqFunctionRelFlowVO> reqFunctionRelFlow = reqFunctionItem.getReqFunctionRelFlow();
            for (ReqFunctionRelFlowVO flowVO : reqFunctionRelFlow) {
                flowVO.setFunctionItemId(reqFunctionItem.getId());
                reqFunctionRelFlowDAO.insertRelation(flowVO);
            }
        }
        if (reqFunctionItem.getReqFunctionDistributed() != null) {
            List<ReqFunctionDistributedVO> reqFunctionDistributedVO = reqFunctionItem.getReqFunctionDistributed();
            for (ReqFunctionDistributedVO distributedVO : reqFunctionDistributedVO) {
                distributedVO.setItemId(reqFunctionItem.getId());
                if (distributedVO.getDataFrom() == null) {
                    distributedVO.setDataFrom(0);
                }
                reqFunctionDistributedDAO.insertRelationToFunItem(distributedVO);
            }
        }
        if (reqFunctionItem.getReqFunctionRelItems() != null) {
            List<ReqFunctionRelItemsVO> reqFunctionRelItemsVO = reqFunctionItem.getReqFunctionRelItems();
            for (ReqFunctionRelItemsVO itemsVO : reqFunctionRelItemsVO) {
                itemsVO.setFunctionId(reqFunctionItem.getId());
                reqFunctionRelItemsDAO.insertRelationToFunItem(itemsVO);
            }
        }
        return update(reqFunctionItem);
    }
    
    /**
     * 删除 功能项
     * 
     * @param reqFunctionItem 功能项
     * @return 删除成功与否
     */
    @Transaction(propagation = JtxPropagationBehavior.PROPAGATION_REQUIRED, readOnly = false)
    public boolean deleteReqFunctionItem(ReqFunctionItemVO reqFunctionItem) {
        return delete(reqFunctionItem);
    }
    
    /**
     * 通过功能项ID查询功能项
     * 
     * @param reqFunctionItemId 功能项ID
     * @return 功能项对象
     */
    public ReqFunctionItemVO queryReqFunctionItemById(String reqFunctionItemId) {
        ReqFunctionItemVO functionItemVO = (ReqFunctionItemVO) selectOne(
            "com.comtop.cap.bm.req.func.model.queryReqFunctionItemById", reqFunctionItemId);
        if (functionItemVO == null) { // 系统模块树关联了功能项，但是cap删除了。查询不到
            return null;
        }
        List<ReqFunctionRelFlowVO> reqFunctionRelFlow = reqFunctionRelFlowDAO
            .getRelFlowListByFunItemId(reqFunctionItemId);
        List<ReqFunctionDistributedVO> reqFunctionDistributedVO = reqFunctionDistributedDAO
            .getFunctionDistributedByFunItemId(reqFunctionItemId);
        List<ReqFunctionRelItemsVO> reqFunctionRelItemsVO = reqFunctionRelItemsDAO
            .getRelItemListByFunItemId(reqFunctionItemId);
        functionItemVO.setReqFunctionRelFlow(reqFunctionRelFlow);
        functionItemVO.setReqFunctionDistributed(reqFunctionDistributedVO);
        functionItemVO.setReqFunctionRelItems(reqFunctionRelItemsVO);
        return functionItemVO;
    }
    
    /**
     * 检查功能项编码是否重复
     * 
     * @param reqFunctionItem 功能项
     * @return 结果
     */
    public int checkReqFunItemCode(ReqFunctionItemVO reqFunctionItem) {
        return ((Integer) selectOne("com.comtop.cap.bm.req.func.model.checkReqFunItemCode", reqFunctionItem))
            .intValue();
    }
    
    /**
     * 获取排序号
     * 
     * @return 结果
     */
    public int getMaxSortNoFromReqTree() {
        return ((Integer) selectOne("com.comtop.cap.bm.req.func.model.getMaxSortNoFromReqTree", null)).intValue();
    }
    
    /**
     * 查询需求功能项以及功能分布
     *
     * @param condition 查询条件
     * @return 需求功能项以及功能分布
     */
    public ReqFunctionItemVO queryReqFunctionItemWithDistributed(ReqFunctionItemVO condition) {
        String itemId = condition.getId();
        ReqFunctionItemVO item = (ReqFunctionItemVO) selectOne(
            "com.comtop.cap.bm.req.func.model.queryReqFunctionItemById", itemId);
        if (item != null) {
            List<ReqFunctionDistributedVO> distributeds = reqFunctionDistributedDAO
                .getFunctionDistributedByFunItemId(itemId);
            item.setReqFunctionDistributed(distributeds);
        }
        return item;
    }
    
    /**
     * 更新 排序号
     * 
     * @param reqFunctionItemVO 功能项
     *
     */
    @Transaction(propagation = JtxPropagationBehavior.PROPAGATION_REQUIRED, readOnly = false)
    public void updateSortNoById(ReqFunctionItemVO reqFunctionItemVO) {
        super.selectOne("com.comtop.cap.bm.req.func.model.updateSortNoById", reqFunctionItemVO);
    }
    
    /**
     * 查询功能项是否有关联子项
     * 
     * @param reqFunctionItem 功能项
     * @return 结果
     */
    public boolean checkSubFunByFunItem(ReqFunctionItemVO reqFunctionItem) {
        int strResult = (Integer) super.selectOne("com.comtop.cap.bm.req.func.model.checkSubFunByFunItem",
            reqFunctionItem);
        return strResult > 0 ? true : false;
    }
    
    /**
     * 
     * 检查功能项是否重名
     * 
     * @param reqFunctionItem 功能项
     * @return 结果
     */
    public boolean checkFuncItemName(ReqFunctionItemVO reqFunctionItem) {
        int result = (Integer) super.selectOne("com.comtop.cap.bm.req.func.model.checkFuncItemName", reqFunctionItem);
        return result > 0 ? false : true;
    }
}
