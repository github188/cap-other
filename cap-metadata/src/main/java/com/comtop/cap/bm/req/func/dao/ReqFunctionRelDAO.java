/******************************************************************************
 * Copyright (C) 2015 ShenZhen ComTop Information Technology Co.,Ltd
 * All Rights Reserved.
 * 本软件为深圳康拓普开发研制。未经本公司正式书面同意，其他任何个人、团体不得使用、
 * 复制、修改或发布本软件.
 *****************************************************************************/

package com.comtop.cap.bm.req.func.dao;

import java.util.ArrayList;
import java.util.Collections;
import java.util.List;

import com.comtop.cap.bm.biz.items.dao.BizItemsDAO;
import com.comtop.cap.bm.biz.items.model.BizItemsVO;
import com.comtop.cap.bm.req.func.model.ReqFunctionRelVO;
import com.comtop.cip.jodd.jtx.JtxPropagationBehavior;
import com.comtop.cip.jodd.jtx.meta.Transaction;
import com.comtop.cip.jodd.petite.meta.PetiteBean;
import com.comtop.cip.jodd.petite.meta.PetiteInject;
import com.comtop.cip.jodd.util.StringUtil;
import com.comtop.top.core.base.dao.CoreDAO;

/**
 * 功能项关系 扩展DAO
 * 
 * @author CAP
 * @since 1.0
 * @version 2015-11-25 CAP
 */
@PetiteBean
public class ReqFunctionRelDAO extends CoreDAO<ReqFunctionRelVO> {
    
    /** 注入DAO **/
    @PetiteInject
    protected BizItemsDAO bizItemsDAO;
    
    /**
     * 
     * 功能项关系
     *
     * @param reqFunctionRel 功能项关系
     * @return 功能项关系
     */
    public List<ReqFunctionRelVO> queryFunctionRel(ReqFunctionRelVO reqFunctionRel) {
        List<ReqFunctionRelVO> funcItemRelList = queryList(
            "com.comtop.cap.bm.req.func.model.queryFunctionRelByFunItemId", reqFunctionRel);
        for (ReqFunctionRelVO relVO : funcItemRelList) {
            if (StringUtil.isNotBlank(relVO.getBizItemIds())) {
                String itemIds = relVO.getBizItemIds();
                String[] itemIdList = itemIds.split(";");
                List<String> myItemidList = new ArrayList<String>();
                Collections.addAll(myItemidList, itemIdList);
                List<BizItemsVO> itemList = bizItemsDAO.queryItemByidlist(myItemidList);
                String bizItemNames = "";
                for (BizItemsVO itemVO : itemList) {
                    bizItemNames += itemVO.getName() + ";";
                }
                relVO.setBizItemNames(bizItemNames);
            }
        }
        return funcItemRelList;
    }
    
    /**
     * 
     * 修改功能项关系
     *
     * @param reqFunctionRel 功能项关系
     */
    @Transaction(propagation = JtxPropagationBehavior.PROPAGATION_REQUIRED, readOnly = false)
    public void updateFunctionRel(ReqFunctionRelVO reqFunctionRel) {
        super.update(reqFunctionRel);
    }
    
    /**
     * 
     * 新增功能项关系
     *
     * @param reqFunctionRel 功能项关系
     * @return Id
     */
    @Transaction(propagation = JtxPropagationBehavior.PROPAGATION_REQUIRED, readOnly = false)
    public String insertFunctionRel(ReqFunctionRelVO reqFunctionRel) {
        return (String) insert(reqFunctionRel);
    }
    
    /**
     * 
     * 删除功能项关系
     * 
     * @param reqFunctionRelList 功能项关系
     */
    @Transaction(propagation = JtxPropagationBehavior.PROPAGATION_REQUIRED, readOnly = false)
    public void deleteFunctionRel(List<ReqFunctionRelVO> reqFunctionRelList) {
        super.delete(reqFunctionRelList);
    }
    
    /**
     * 
     * 检查是否重复关联
     * 
     * @param reqFunctionRelVO 功能项
     * @return 结果
     */
    public boolean checkRelFunctionItemId(ReqFunctionRelVO reqFunctionRelVO) {
        int strResult = (Integer) selectOne("com.comtop.cap.bm.req.func.model.checkRelFunctionItemId", reqFunctionRelVO);
        return strResult > 0 ? false : true;
    }
    
    /**
     * 
     * 功能项关系
     *
     * @param funcitemRelId 功能项关系Id
     * @return 功能项关系
     */
    public ReqFunctionRelVO queryFunctionRelById(String funcitemRelId) {
        ReqFunctionRelVO reqFunctionRelVO = (ReqFunctionRelVO) selectOne(
            "com.comtop.cap.bm.req.func.model.queryFunctionRelById", funcitemRelId);
        if (StringUtil.isNotBlank(reqFunctionRelVO.getBizItemIds())) {
            String itemIds = reqFunctionRelVO.getBizItemIds();
            String[] itemIdList = itemIds.split(";");
            List<String> myItemidList = new ArrayList<String>();
            Collections.addAll(myItemidList, itemIdList);
            List<BizItemsVO> itemList = bizItemsDAO.queryItemByidlist(myItemidList);
            String bizItemNames = "";
            for (BizItemsVO itemVO : itemList) {
                bizItemNames += itemVO.getName() + ";";
            }
            reqFunctionRelVO.setBizItemNames(bizItemNames);
        }
        return reqFunctionRelVO;
    }
}
