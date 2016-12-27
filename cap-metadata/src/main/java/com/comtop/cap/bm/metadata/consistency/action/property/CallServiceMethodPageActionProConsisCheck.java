/******************************************************************************
 * Copyright (C) 2015 ShenZhen ComTop Information Technology Co.,Ltd
 * All Rights Reserved.
 * 本软件为深圳康拓普开发研制。未经本公司正式书面同意，其他任何个人、团体不得使用、
 * 复制、修改或发布本软件.
 *****************************************************************************/

package com.comtop.cap.bm.metadata.consistency.action.property;

import java.util.HashMap;
import java.util.List;
import java.util.Map;

import org.apache.commons.lang.StringUtils;

import com.comtop.cap.bm.metadata.base.consistency.model.ConsistencyCheckResult;
import com.comtop.cap.bm.metadata.common.dwr.CapMap;
import com.comtop.cap.bm.metadata.consistency.ConsistencyCheckResultType;
import com.comtop.cap.bm.metadata.consistency.ConsistencyResultAttrName;
import com.comtop.cap.bm.metadata.consistency.action.IActionProperyConsisCheck;
import com.comtop.cap.bm.metadata.entity.facade.EntityFacade;
import com.comtop.cap.bm.metadata.entity.model.EntityAttributeVO;
import com.comtop.cap.bm.metadata.entity.model.MethodVO;
import com.comtop.cap.bm.metadata.page.actionlibrary.model.ActionDefineVO;
import com.comtop.cap.bm.metadata.page.desinger.model.PageActionVO;
import com.comtop.cap.bm.metadata.page.desinger.model.PageVO;
import com.comtop.cap.bm.metadata.page.uilibrary.model.PropertyVO;
import com.comtop.top.core.jodd.AppContext;

/**
 * 行为模版调用后台方法的数据一致性校验
 *
 * @author 诸焕辉
 * @since jdk1.6
 * @version 2016年6月30日 诸焕辉
 */
public class CallServiceMethodPageActionProConsisCheck implements IActionProperyConsisCheck {
    
    /**
     * 页面实体facade类
     */
    private final EntityFacade entityFacade = AppContext.getBean(EntityFacade.class);
    
    @Override
    public ConsistencyCheckResult checkPropertyValueConsis(ActionDefineVO comp, PropertyVO propertyVO,
        PageActionVO data, PageVO root) {
        ConsistencyCheckResult objRes = null;
        String strName = propertyVO.getEname();
        String strValue = (String) data.getMethodOption().get(strName);
        if (StringUtils.isNotBlank(strValue)) {
            boolean bExist = false;
            List<MethodVO> lstMethod = entityFacade.getSelfAndParentMethods((String) data.getMethodOption().get(
                "entityId"));
            if (lstMethod == null || lstMethod.size() == 0) {
                return null;
            }
            for (MethodVO objMethodVO : lstMethod) {
                String strMethodName = StringUtils.isNotBlank(objMethodVO.getAliasName()) ? objMethodVO.getAliasName()
                    : objMethodVO.getEngName();
                if (strValue.equals(strMethodName)) {
                    bExist = true;
                    break;
                }
            }
            if (!bExist) {
                objRes = new ConsistencyCheckResult();
                objRes.setType(ConsistencyCheckResultType.CONSISTENCY_TYPE_PAGE_ACTION.getValue());
                objRes.setMessage(String.format("页面行为%s中的%s属性关联的后台方法：%s不存在", data.getEname(), strName, strValue));
                Map<String, String> objAtrrMap = new HashMap<String, String>();
                objAtrrMap.put(ConsistencyResultAttrName.PAGE_ATTRNAME_PK.getValue(), root.getModelId());
                objAtrrMap.put(ConsistencyResultAttrName.PAGE_ACTION_ATTRNAME_PK.getValue(), data.getPageActionId());
                objAtrrMap.put(ConsistencyResultAttrName.PAGE_ACTION_ATTRNAME_ACTION_PRO.getValue(),
                    propertyVO.getEname());
                objRes.setAttrMap(objAtrrMap);
            }
        }
        return objRes;
    }

    @Override
    public ConsistencyCheckResult checkPageActionDependOnEntityAttr(ActionDefineVO comp,
        List<EntityAttributeVO> entityAttrs, PropertyVO propertyVO, PageActionVO data, PageVO root) {
        // TODO 自动生成方法存根注释，方法实现时请删除此注释
        return null;
    }
    
    @Override
    public ConsistencyCheckResult checkPageActionDependOnEntityMethod(List<MethodVO> entityMethodVOs,
        PropertyVO propertyVO, PageActionVO data, PageVO root) {
        ConsistencyCheckResult objRes = null;
        CapMap objOption = data.getMethodOption();
        String strEname = propertyVO.getEname();
        String strValue = (String) objOption.get(strEname);
        if (StringUtils.isNotBlank(strValue)) {
            for (MethodVO ojbMethodVO : entityMethodVOs) {
                String strMethod = StringUtils.isNotBlank(ojbMethodVO.getAliasName()) ? ojbMethodVO.getAliasName()
                    : ojbMethodVO.getEngName();
                if (strValue.equals(strMethod)) {
                    objRes = new ConsistencyCheckResult();
                    objRes.setType(ConsistencyCheckResultType.CONSISTENCY_TYPE_PAGE_ACTION.getValue());
                    objRes.setMessage(String.format("页面【%s】中的行为【%s】属性%s值依赖了实体方法：%s", root.getCname(), data.getEname(),
                        strEname, strValue));
                    Map<String, String> objAtrrMap = new HashMap<String, String>();
                    objAtrrMap.put(ConsistencyResultAttrName.PAGE_ATTRNAME_PK.getValue(), root.getModelId());
                    objAtrrMap
                        .put(ConsistencyResultAttrName.PAGE_ACTION_ATTRNAME_PK.getValue(), data.getPageActionId());
                    objAtrrMap.put(ConsistencyResultAttrName.PAGE_ACTION_ATTRNAME_ACTION_PRO.getValue(),
                        propertyVO.getEname());
                    objRes.setAttrMap(objAtrrMap);
                    break;
                }
            }
        }
        return objRes;
    }
}
