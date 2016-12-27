/******************************************************************************
 * Copyright (C) 2015 ShenZhen ComTop Information Technology Co.,Ltd
 * All Rights Reserved.
 * 本软件为深圳康拓普开发研制。未经本公司正式书面同意，其他任何个人、团体不得使用、
 * 复制、修改或发布本软件.
 *****************************************************************************/

package com.comtop.cap.bm.metadata.consistency;

import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import com.comtop.cap.bm.metadata.base.consistency.ConsistencyCheckUtil;
import com.comtop.cap.bm.metadata.base.consistency.ConsistencyException;
import com.comtop.cap.bm.metadata.base.consistency.DefaultConsistencyCheck;
import com.comtop.cap.bm.metadata.base.consistency.model.ConsistencyCheckResult;
import com.comtop.cap.bm.metadata.common.storage.exception.OperateException;
import com.comtop.cap.bm.metadata.entity.model.EntityAttributeVO;
import com.comtop.cap.bm.metadata.entity.model.EntityVO;
import com.comtop.cap.bm.metadata.entity.model.MethodVO;
import com.comtop.cap.bm.metadata.page.desinger.facade.PageFacade;
import com.comtop.cap.bm.metadata.page.desinger.model.PageActionVO;
import com.comtop.cap.bm.metadata.page.desinger.model.PageConstantVO;
import com.comtop.cap.bm.metadata.page.desinger.model.PageVO;
import com.comtop.top.core.jodd.AppContext;

/**
 * 一致性校验
 * 
 * @author 罗珍明
 *
 */
public class PageVOConsistencyCheck extends DefaultConsistencyCheck<PageVO> {
    
    /**
     * 页面元数据facade类
     */
    private final PageFacade pageFacade = AppContext.getBean(PageFacade.class);
    
    @Override
    public List<ConsistencyCheckResult> checkCurrentDependOn(PageVO root) {
        return super.checkCurrentDependOn(root);
    }
    
    @SuppressWarnings("unchecked")
    @Override
    public List<ConsistencyCheckResult> checkBeingDependOn(PageVO root) {
        List<ConsistencyCheckResult> lstRes = new ArrayList<ConsistencyCheckResult>();
        List<PageVO> lstPageVO = null;
        String strCurrPageModelId = root.getModelId();
        try {
            lstPageVO = pageFacade.queryList("page[modelId!='" + strCurrPageModelId + "']", PageVO.class);
            List<PageConstantVO> lstPageConstantVO = null;
            for (PageVO objPageVO : lstPageVO) {
                lstPageConstantVO = objPageVO
                    .queryList("./dataStoreVOList[ename='pageConstantList']/pageConstantList[constantType='url' and constantOption[pageModelId='" + strCurrPageModelId + "']]");
                if (lstPageConstantVO != null && lstPageConstantVO.size() > 0) {
                    ConsistencyCheckResult objRes = new ConsistencyCheckResult();
                    objRes.setType(ConsistencyCheckResultType.CONSISTENCY_TYPE_PAGE_DATASTORE.getValue());
                    Map<String, String> objAttrMap = new HashMap<String, String>();
                    objAttrMap.put(ConsistencyResultAttrName.PAGE_ATTRNAME_PK.getValue(), objPageVO.getModelId());
                    objRes.setAttrMap(objAttrMap);
                    objRes.setMessage("当前页面元数据被其他页面元数据所依赖了，依赖的页面元数据modeId=" + objPageVO.getModelId() + "，在页面常量中使用到当前页面元数据");
                    lstRes.add(objRes);
                }
            }
        } catch (OperateException e) {
            throw new ConsistencyException("一致性校验出错，校验其他数据依赖于当前数据pageModelId=" + strCurrPageModelId + "的信息是否还存在出错", e);
        }
        return lstRes;
    }
    
    @Override
    public List<ConsistencyCheckResult> checkBeingDependOnWhenChange(PageVO root) {
        return new ArrayList<ConsistencyCheckResult>();
    }
    
    /**
     * 校验实体属性被页面所依赖的数据
     *
     * @param data 要删除的实体属性集合
     * @param root 实体对象
     * @param relationEntitys 实体对象
     * @return 返回校验结果
     */
    public List<ConsistencyCheckResult> checkBeingDependOnEntityAttr(List<EntityAttributeVO> data, EntityVO root, List<EntityVO> relationEntitys) {
        List<ConsistencyCheckResult> lstRes = new ArrayList<ConsistencyCheckResult>();
        String strModelId = root.getModelId();
        List<PageVO> lstPageVO = null;
        try {
            StringBuffer strRelaEntitys = new StringBuffer();
            strRelaEntitys.append("page[dataStoreVOList[entityId='%s'");
            if (relationEntitys != null && relationEntitys.size() > 0) {
                for (EntityVO objEntityVO : relationEntitys) {
                    strRelaEntitys.append(" or entityId='").append(objEntityVO.getModelId()).append("' ");
                }
            }
            strRelaEntitys.append("]]");
            lstPageVO = pageFacade.queryList(String.format(strRelaEntitys.toString(), strModelId), PageVO.class);
            if (lstPageVO == null || lstPageVO.size() == 0) {
                return lstRes;
            }
            LayoutVOConsistencyCheck objCheck4Layout = ConsistencyCheckUtil.getConsistencyCheck("com.comtop.cap.bm.metadata.consistency.LayoutVOConsistencyCheck", LayoutVOConsistencyCheck.class);
            PageActionVOConsistencyCheck objCheck4PageAction = ConsistencyCheckUtil.getConsistencyCheck("com.comtop.cap.bm.metadata.consistency.PageActionVOConsistencyCheck",
                PageActionVOConsistencyCheck.class);
            for (PageVO objPageVO : lstPageVO) {
                // 校验页面控件
                List<ConsistencyCheckResult> objRes4PageLayout = objCheck4Layout.checkBeingDependOnEntityAttr(data, root, objPageVO, relationEntitys);
                if (objRes4PageLayout != null && objRes4PageLayout.size() > 0) {
                    lstRes.addAll(objRes4PageLayout);
                }
                // 校验页面行为
                List<ConsistencyCheckResult> objRes4PageAction = objCheck4PageAction.checkBeingDependOnEntityAttr(data, root, objPageVO);
                if (objRes4PageAction != null && objRes4PageAction.size() > 0) {
                    lstRes.addAll(objRes4PageAction);
                }
            }
        } catch (OperateException e) {
            throw new ConsistencyException("校验当前实体" + strModelId + "是否被其他页面所依赖时报错。", e);
        }
        return lstRes;
    }
    
    /**
     * 校验实体被页面所依赖
     * 
     * @param entity 实体对象
     * @return 返回校验结果
     */
    public List<ConsistencyCheckResult> checkBeingDependOnEntity(EntityVO entity) {
        List<ConsistencyCheckResult> lstRes = new ArrayList<ConsistencyCheckResult>();
        String strModelId = entity.getModelId();
        List<PageVO> lstPageVO = null;
        try {
            lstPageVO = pageFacade.queryList(String.format("page[dataStoreVOList[entityId='%s']]", strModelId), PageVO.class);
            for (PageVO objPageVO : lstPageVO) {
                String strPageModelId = objPageVO.getModelId();
                ConsistencyCheckResult objRes = new ConsistencyCheckResult();
                objRes.setId(strPageModelId);
                objRes.setType(ConsistencyCheckResultType.CONSISTENCY_TYPE_PAGE_DATASTORE.getValue());
                objRes.setMessage(String.format("当前实体被页面【%s-%s】所依赖", objPageVO.getCname(), strPageModelId));
                Map<String, String> attrMap = new HashMap<String, String>();
                attrMap.put(ConsistencyResultAttrName.PAGE_ATTRNAME_PK.getValue(), strPageModelId);
                objRes.setAttrMap(attrMap);
                lstRes.add(objRes);
            }
        } catch (OperateException e) {
            throw new ConsistencyException("校验当前实体" + strModelId + "是否被其他页面所依赖时报错。", e);
        }
        return lstRes;
    }
    
    /**
     * 校验实体方法被页面所依赖
     * 
     * @param methods 实体方法集
     * @param entity 实体对象
     * @return 返回校验结果
     */
    public List<ConsistencyCheckResult> checkBeingDependOnMethod(List<MethodVO> methods, EntityVO entity) {
        List<ConsistencyCheckResult> lstRes = new ArrayList<ConsistencyCheckResult>();
        String strModelId = entity.getModelId();
        String strCheckCalzz = "com.comtop.cap.bm.metadata.consistency.PageActionVOConsistencyCheck";
        List<PageVO> lstPageVO = null;
        try {
            lstPageVO = pageFacade.queryList(String.format("page[dataStoreVOList[entityId='%s']]", strModelId), PageVO.class);
            for (PageVO objPageVO : lstPageVO) {
                List<ConsistencyCheckResult> lstRes4Page = new ArrayList<ConsistencyCheckResult>();
                List<PageActionVO> lstPageAction = objPageVO.getPageActionVOList();
                if (lstPageAction == null || lstPageAction.size() == 0) {
                    return lstRes;
                }
                PageActionVOConsistencyCheck objCheck = ConsistencyCheckUtil.getConsistencyCheck(strCheckCalzz, PageActionVOConsistencyCheck.class);
                if (objCheck != null) {
                    lstRes4Page = objCheck.checkBeingDependOnMethod(methods, entity, objPageVO);
                }
                if (lstRes4Page != null && lstRes4Page.size() > 0) {
                    lstRes.addAll(lstRes4Page);
                }
            }
            
        } catch (OperateException e) {
            throw new ConsistencyException("校验当前实体" + strModelId + "是否被其他页面所依赖时报错。", e);
        }
        return lstRes;
    }
    
}
