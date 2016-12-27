/******************************************************************************
 * Copyright (C) 2015 ShenZhen ComTop Information Technology Co.,Ltd
 * All Rights Reserved.
 * 本软件为深圳康拓普开发研制。未经本公司正式书面同意，其他任何个人、团体不得使用、
 * 复制、修改或发布本软件.
 *****************************************************************************/

package com.comtop.cap.bm.metadata.consistency;

import java.util.ArrayList;
import java.util.List;

import com.comtop.cap.bm.metadata.base.consistency.ConsistencyCheckUtil;
import com.comtop.cap.bm.metadata.base.consistency.ConsistencyException;
import com.comtop.cap.bm.metadata.base.consistency.DefaultFieldConsistencyCheck;
import com.comtop.cap.bm.metadata.base.consistency.model.ConsistencyCheckResult;
import com.comtop.cap.bm.metadata.base.consistency.model.FieldConsistencyConfigVO;
import com.comtop.cap.bm.metadata.common.storage.exception.OperateException;
import com.comtop.cap.bm.metadata.consistency.action.IPageActionConsisCheck;
import com.comtop.cap.bm.metadata.entity.model.EntityAttributeVO;
import com.comtop.cap.bm.metadata.entity.model.EntityVO;
import com.comtop.cap.bm.metadata.entity.model.MethodVO;
import com.comtop.cap.bm.metadata.page.actionlibrary.facade.ActionDefineFacade;
import com.comtop.cap.bm.metadata.page.actionlibrary.model.ActionDefineVO;
import com.comtop.cap.bm.metadata.page.desinger.model.DataStoreVO;
import com.comtop.cap.bm.metadata.page.desinger.model.PageActionVO;
import com.comtop.cap.bm.metadata.page.desinger.model.PageVO;
import com.comtop.cip.jodd.util.StringUtil;
import com.comtop.top.core.jodd.AppContext;

/**
 * 一致性校验
 * 
 * @author 罗珍明
 *
 */
public class PageActionVOConsistencyCheck extends DefaultFieldConsistencyCheck<PageActionVO, PageVO> {
    
    /** 行为模板facade */
    private ActionDefineFacade actionDefineFacade = AppContext.getBean(ActionDefineFacade.class);
    
    @Override
    public List<ConsistencyCheckResult> checkFieldDependOn(PageActionVO data, PageVO root) {
        
        if (data.getMethodOption() == null || data.getMethodOption().isEmpty()) {
            return new ArrayList<ConsistencyCheckResult>(0);
        }
        
        String strTempId = data.getMethodTemplate();
        
        if (StringUtil.isBlank(strTempId)) {
            return new ArrayList<ConsistencyCheckResult>(0);
        }
        
        ActionDefineVO objActionDefineVO = actionDefineFacade.loadModel(strTempId);
        
        if (objActionDefineVO == null) {
            return new ArrayList<ConsistencyCheckResult>(0);
        }
        
        if (objActionDefineVO.getConsistencyConfig() == null) {
            return new ArrayList<ConsistencyCheckResult>(0);
        }
        List<ConsistencyCheckResult> lstRes = new ArrayList<ConsistencyCheckResult>();
        if (objActionDefineVO.getConsistencyConfig().getCheckConsistency() != null
            && objActionDefineVO.getConsistencyConfig().getCheckConsistency().booleanValue()) {
            String strCheckClass = objActionDefineVO.getConsistencyConfig().getCheckClass();
            if (StringUtil.isBlank(strCheckClass)) {
                String strClassPre = StringUtil.capitalize(objActionDefineVO.getModelName());
                strCheckClass = "com.comtop.cap.bm.metadata.consistency.action." + strClassPre + "ActionConsisCheck";
            }
            
            IPageActionConsisCheck actionCheck = ConsistencyCheckUtil.getConsistencyCheck(strCheckClass,
                IPageActionConsisCheck.class);
            List<ConsistencyCheckResult> lst = actionCheck.checkPageActionConsis(objActionDefineVO, data, root);
            if (lst != null) {
                lstRes.addAll(lst);
            }
        }
        
        return lstRes;
    }
    
    @Override
    public List<ConsistencyCheckResult> checkBeingDependOn(PageActionVO field, PageVO root) {
        // TODO Auto-generated method stub
        return null;
    }
    
    @Override
    protected String getCheckResultPageType() {
        return ConsistencyCheckResultType.CONSISTENCY_TYPE_PAGE_ACTION.getValue();
    }
    
    /**
     * 校验当前实体方法被页面元数据行为所依赖
     *
     * @param entityMethods 实体方法集
     * @param entity 实体对象
     * @param page 页面对象
     * @return 校验结果
     */
    public List<ConsistencyCheckResult> checkBeingDependOnMethod(List<MethodVO> entityMethods, EntityVO entity,
        PageVO page) {
        List<ConsistencyCheckResult> lstRes = new ArrayList<ConsistencyCheckResult>();
        List<PageActionVO> lstPageAction = page.getPageActionVOList();
        if (lstPageAction == null || lstPageAction.size() == 0) {
            return lstRes;
        }
        for (PageActionVO objPageActionVO : lstPageAction) {
            if (objPageActionVO.getMethodOption() == null || objPageActionVO.getMethodOption().isEmpty()
                || StringUtil.isBlank(objPageActionVO.getMethodTemplate())) {
                continue;
            }
            ActionDefineVO objActionDefineVO = actionDefineFacade.loadModel(objPageActionVO.getMethodTemplate());
            if (objActionDefineVO == null || objActionDefineVO.getConsistencyConfig() == null) {
                continue;
            }
            FieldConsistencyConfigVO objFieldConsisConfigVO = objActionDefineVO.getConsistencyConfig();
            if (objFieldConsisConfigVO != null && objFieldConsisConfigVO.getCheckConsistency() != null
                && objFieldConsisConfigVO.getCheckConsistency().booleanValue()) {
                String strCheckClass = objActionDefineVO.getConsistencyConfig().getCheckClass();
                IPageActionConsisCheck objCheck = ConsistencyCheckUtil.getConsistencyCheck(strCheckClass,
                    IPageActionConsisCheck.class);
                List<ConsistencyCheckResult> lstRes4Action = objCheck.checkPageActionDependOnEntityMethod(
                    objActionDefineVO, entityMethods, objPageActionVO, page);
                if (lstRes4Action != null && lstRes4Action.size() > 0) {
                    lstRes.addAll(lstRes4Action);
                }
            }
        }
        return lstRes;
    }
    
    /**
     * 校验实体属性被页面行为所依赖的数据
     *
     * @param data 实体属性集合
     * @param entity 实体对象
     * @param page 页面对象
     * @return 校验结果
     */
    @SuppressWarnings("unchecked")
    public List<ConsistencyCheckResult> checkBeingDependOnEntityAttr(List<EntityAttributeVO> data, EntityVO entity,
        PageVO page) {
        List<ConsistencyCheckResult> lstRes = new ArrayList<ConsistencyCheckResult>();
        List<DataStoreVO> lstDataStoreVO = null;
        try {
            lstDataStoreVO = page.queryList(String.format("./dataStoreVOList[entityId='%s']", entity.getModelId()));
            List<PageActionVO> lstPageAction = page.getPageActionVOList();
            if (lstDataStoreVO == null || lstDataStoreVO.size() == 0 ||lstPageAction == null || lstPageAction.size() == 0) {
                return lstRes;
            }
            for (PageActionVO objPageActionVO : lstPageAction) {
                if (objPageActionVO.getMethodOption() == null || objPageActionVO.getMethodOption().isEmpty()
                    || StringUtil.isBlank(objPageActionVO.getMethodTemplate())) {
                    continue;
                }
                ActionDefineVO objActionDefineVO = actionDefineFacade.loadModel(objPageActionVO.getMethodTemplate());
                if (objActionDefineVO == null || objActionDefineVO.getConsistencyConfig() == null) {
                    continue;
                }
                if (objActionDefineVO.getConsistencyConfig().getCheckConsistency() != null
                    && objActionDefineVO.getConsistencyConfig().getCheckConsistency().booleanValue()) {
                    String strCheckClass = objActionDefineVO.getConsistencyConfig().getCheckClass();
                    IPageActionConsisCheck objCheck = ConsistencyCheckUtil.getConsistencyCheck(strCheckClass,
                        IPageActionConsisCheck.class);
                    List<ConsistencyCheckResult> lstRes4Action = objCheck.checkPageActionDependOnEntityAttr(
                        objActionDefineVO, data, objPageActionVO, page);
                    if (lstRes4Action != null && lstRes4Action.size() > 0) {
                        lstRes.addAll(lstRes4Action);
                    }
                }
            }
        } catch (OperateException e) {
            throw new ConsistencyException("校验当前实体属性" + entity.getModelId() + "是否被页面" + page.getModelId() + "中的行为所依赖时报错。", e);
        }
        return lstRes;
    }
}
