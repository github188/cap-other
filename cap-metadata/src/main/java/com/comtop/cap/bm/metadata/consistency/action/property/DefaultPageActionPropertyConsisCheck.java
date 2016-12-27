/******************************************************************************
 * Copyright (C) 2016 ShenZhen ComTop Information Technology Co.,Ltd
 * All Rights Reserved.
 * 本软件为深圳康拓普开发研制。未经本公司正式书面同意，其他任何个人、团体不得使用、
 * 复制、修改或发布本软件.
 *****************************************************************************/

package com.comtop.cap.bm.metadata.consistency.action.property;

import java.util.HashMap;
import java.util.List;
import java.util.Map;

import com.comtop.cap.bm.metadata.base.consistency.ConsistencyException;
import com.comtop.cap.bm.metadata.base.consistency.model.ConsistencyCheckResult;
import com.comtop.cap.bm.metadata.base.model.BaseMetadata;
import com.comtop.cap.bm.metadata.common.storage.exception.OperateException;
import com.comtop.cap.bm.metadata.consistency.ConsistencyCheckResultType;
import com.comtop.cap.bm.metadata.consistency.ConsistencyResultAttrName;
import com.comtop.cap.bm.metadata.consistency.action.IActionProperyConsisCheck;
import com.comtop.cap.bm.metadata.entity.model.EntityAttributeVO;
import com.comtop.cap.bm.metadata.entity.model.MethodVO;
import com.comtop.cap.bm.metadata.page.actionlibrary.model.ActionDefineVO;
import com.comtop.cap.bm.metadata.page.desinger.model.PageActionVO;
import com.comtop.cap.bm.metadata.page.desinger.model.PageVO;
import com.comtop.cap.bm.metadata.page.uilibrary.model.PropertyVO;

/**
 * 行为模版的属性数据一致性校验
 *
 * @author 诸焕辉
 * @since jdk1.6
 * @version 2016年6月30日 诸焕辉
 */
public class DefaultPageActionPropertyConsisCheck implements IActionProperyConsisCheck {
    
    @Override
    public ConsistencyCheckResult checkPropertyValueConsis(ActionDefineVO comp, PropertyVO propertyVO,
        PageActionVO data, PageVO root) {
        return null;
    }
    
    /**
     * 校验器
     * 
     * @param propertyVO 控件属性
     * @param data 控件对应的布局对象
     * @param root page对象
     * @param expression 表达式
     * @param errorMsgTemp 错误信息模版
     * @return 校验结果
     */
    protected ConsistencyCheckResult checkConsisHandler(PropertyVO propertyVO, PageActionVO data, PageVO root,
        String expression, String errorMsgTemp) {
        ConsistencyCheckResult objRes = null;
        try {
            BaseMetadata objBaseMetadata = (BaseMetadata) root.query(expression);
            if (objBaseMetadata == null) {
                objRes = new ConsistencyCheckResult();
                objRes.setType(ConsistencyCheckResultType.CONSISTENCY_TYPE_PAGE_ACTION.getValue());
                objRes.setMessage(errorMsgTemp);
                Map<String, String> objAtrrMap = new HashMap<String, String>();
                objAtrrMap.put(ConsistencyResultAttrName.PAGE_ATTRNAME_PK.getValue(), root.getModelId());
                objAtrrMap.put(ConsistencyResultAttrName.PAGE_ACTION_ATTRNAME_PK.getValue(), data.getPageActionId());
                objAtrrMap.put(ConsistencyResultAttrName.PAGE_ACTION_ATTRNAME_ACTION_PRO.getValue(),
                    propertyVO.getEname());
                objRes.setAttrMap(objAtrrMap);
            }
        } catch (OperateException e) {
            throw new ConsistencyException("校验行为属性依赖的数据一致性校验出错，校验的" + propertyVO.getEname() + "属性出错", e);
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
        // TODO 自动生成方法存根注释，方法实现时请删除此注释
        return null;
    }
}
