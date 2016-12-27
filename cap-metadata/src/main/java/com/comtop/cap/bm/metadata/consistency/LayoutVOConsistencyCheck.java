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
import com.comtop.cap.bm.metadata.entity.model.EntityAttributeVO;
import com.comtop.cap.bm.metadata.entity.model.EntityVO;
import com.comtop.cap.bm.metadata.page.desinger.model.DataStoreVO;
import com.comtop.cap.bm.metadata.page.desinger.model.LayoutVO;
import com.comtop.cap.bm.metadata.page.desinger.model.PageVO;
import com.comtop.cap.bm.metadata.page.uilibrary.facade.ComponentFacade;
import com.comtop.cap.bm.metadata.page.uilibrary.model.ComponentVO;
import com.comtop.cip.jodd.util.StringUtil;
import com.comtop.top.core.jodd.AppContext;

/**
 * 一致性校验
 * 
 * @author 罗珍明
 *
 */
public class LayoutVOConsistencyCheck extends DefaultFieldConsistencyCheck<LayoutVO, PageVO> {
    
    /** 默认的控件校验类处理类名称 */
    private static String DEFAULT_COMPONENT_CONSISCHECK_CLASS = "com.comtop.cap.bm.metadata.consistency.component.DefaultComponentConsisCheck";
    
    /** 控件模型facade类 */
    private final ComponentFacade componentFacade = AppContext.getBean(ComponentFacade.class);
    
    /**
     * 
     * @param data layout布局
     * @param root 根对象（page）
     * @return 校验结果
     */
    private List<ConsistencyCheckResult> checkChildren(LayoutVO data, PageVO root) {
        if (data.getChildren() == null || data.getChildren().size() == 0) {
            return new ArrayList<ConsistencyCheckResult>(0);
        }
        List<ConsistencyCheckResult> lstRes = new ArrayList<ConsistencyCheckResult>();
        for (LayoutVO child : data.getChildren()) {
            lstRes.addAll(checkFieldDependOn(child, root));
        }
        return lstRes;
    }
    
    @Override
    public List<ConsistencyCheckResult> checkFieldDependOn(LayoutVO data, PageVO root) {
        String strComponentId = data.getComponentModelId();
        if (StringUtil.isBlank(strComponentId)) {
            return checkChildren(data, root);
        }
        if (data.getOptions() == null || data.getOptions().isEmpty()) {
            return checkChildren(data, root);
        }
        ComponentVO objComponentVO = componentFacade.loadModel(strComponentId);
        if (objComponentVO == null) {
            return checkChildren(data, root);
        }
        FieldConsistencyConfigVO objConsistencyConfig = objComponentVO.getConsistencyConfig();
        if (objConsistencyConfig == null) {
            return checkChildren(data, root);
        }
        List<ConsistencyCheckResult> lstRes = new ArrayList<ConsistencyCheckResult>();
        if (objConsistencyConfig.getCheckConsistency().booleanValue()) {
            String strCheckClass = StringUtil.isNotBlank(objConsistencyConfig.getCheckClass()) ? objConsistencyConfig
                .getCheckClass() : DEFAULT_COMPONENT_CONSISCHECK_CLASS;
            IComponentConsisCheck objCheck = ConsistencyCheckUtil.getConsistencyCheck(strCheckClass,
                IComponentConsisCheck.class);
            if (objCheck == null) {
                String strMessage = "控件：" + objComponentVO.getModelId() + "定义的一致性校验类：" + strCheckClass + "不存在。";
                throw new ConsistencyException(strMessage);
            }
            List<ConsistencyCheckResult> objRes = objCheck.checkEventValueConsis(objComponentVO,
                objComponentVO.getEvents(), data, root);
            if (objRes != null) {
                lstRes.addAll(objRes);
            }
            objRes = objCheck.checkPropertyValueConsis(objComponentVO, objComponentVO.getProperties(), data, root);
            if (objRes != null) {
                lstRes.addAll(objRes);
            }
        }
        lstRes.addAll(checkChildren(data, root));
        setConsistencyCheckResultType(lstRes);
        return lstRes;
    }
    
    @Override
    protected String getCheckResultPageType() {
        return ConsistencyCheckResultType.CONSISTENCY_TYPE_PAGE_LAYOUT.getValue();
    }
    
    /**
     * 校验实体属性被页面布局控件所依赖的数据
     *
     * @param data 实体属性集合
     * @param entity 实体对象
     * @param page 页面对象
     * @param relationEntitys 页面对象
     * @return 校验结果
     */
    @SuppressWarnings("unchecked")
    public List<ConsistencyCheckResult> checkBeingDependOnEntityAttr(List<EntityAttributeVO> data, EntityVO entity,
        PageVO page, List<EntityVO> relationEntitys) {
        List<ConsistencyCheckResult> lstRes = new ArrayList<ConsistencyCheckResult>();
        List<DataStoreVO> lstDataStoreVO = null;
        try {
            StringBuffer strRelaEntitys = new StringBuffer();
            strRelaEntitys.append("./dataStoreVOList[entityId='%s'");
            if (relationEntitys != null && relationEntitys.size() > 0) {
                for (EntityVO objEntityVO : relationEntitys) {
                    strRelaEntitys.append(" or entityId='").append(objEntityVO.getModelId()).append("' ");
                }
            }
            strRelaEntitys.append("]");
            lstDataStoreVO = page.queryList(String.format(strRelaEntitys.toString(), entity.getModelId()));
            List<LayoutVO> lstLayout = page.queryList("./layoutVO//children[type='ui']", LayoutVO.class);
            if (lstDataStoreVO == null || lstDataStoreVO.size() == 0 || lstLayout == null || lstLayout.size() == 0) {
                return lstRes;
            }
            for (LayoutVO objLayoutVO : lstLayout) {
                ComponentVO objComponentVO = componentFacade.loadModel(objLayoutVO.getComponentModelId());
                if (objComponentVO != null) {
                    FieldConsistencyConfigVO objConsistencyConfig = objComponentVO.getConsistencyConfig();
                    if (objConsistencyConfig != null && objConsistencyConfig.getCheckConsistency().booleanValue()) {
                        IComponentConsisCheck objCheck = ConsistencyCheckUtil.getConsistencyCheck(
                            objConsistencyConfig.getCheckClass(), IComponentConsisCheck.class);
                        if (objCheck == null) {
                            continue;
                        }
                        List<ConsistencyCheckResult> lstRes4Layout = objCheck.checkProValDependOnEntityAttr(
                            objComponentVO, data, lstDataStoreVO, objLayoutVO, page);
                        if (lstRes4Layout != null && lstRes4Layout.size() > 0) {
                            lstRes.addAll(lstRes4Layout);
                        }
                    }
                }
            }
        } catch (OperateException e) {
            throw new ConsistencyException("校验当前实体属性" + entity.getModelId() + "是否被页面" + page.getModelId()
                + "中的控件所依赖时报错。", e);
        }
        return lstRes;
    }
}
