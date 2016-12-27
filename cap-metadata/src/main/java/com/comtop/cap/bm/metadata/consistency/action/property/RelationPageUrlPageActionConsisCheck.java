/******************************************************************************
 * Copyright (C) 2016 ShenZhen ComTop Information Technology Co.,Ltd
 * All Rights Reserved.
 * 本软件为深圳康拓普开发研制。未经本公司正式书面同意，其他任何个人、团体不得使用、
 * 复制、修改或发布本软件.
 *****************************************************************************/

package com.comtop.cap.bm.metadata.consistency.action.property;

import org.apache.commons.lang.StringUtils;

import com.comtop.cap.bm.metadata.base.consistency.model.ConsistencyCheckResult;
import com.comtop.cap.bm.metadata.page.actionlibrary.model.ActionDefineVO;
import com.comtop.cap.bm.metadata.page.desinger.model.PageActionVO;
import com.comtop.cap.bm.metadata.page.desinger.model.PageVO;
import com.comtop.cap.bm.metadata.page.uilibrary.model.PropertyVO;

/**
 * 行为模版的属性类型为url值的数据一致性校验
 *
 * @author 诸焕辉
 * @since jdk1.6
 * @version 2016年6月30日 诸焕辉
 */
public class RelationPageUrlPageActionConsisCheck extends DefaultPageActionPropertyConsisCheck {
    
    @Override
    public ConsistencyCheckResult checkPropertyValueConsis(ActionDefineVO comp, PropertyVO propertyVO,
        PageActionVO data, PageVO root) {
        ConsistencyCheckResult objRes = null;
        String strName = propertyVO.getEname();
        String strValue = (String) data.getMethodOption().get(strName);
        if (StringUtils.isNotBlank(strValue)) {
            objRes = this.checkConsisHandler(propertyVO, data, root,
                String.format("./dataStoreVOList[ename='pageConstantList']/pageConstantList[constantType='url' and constantName='%s']", strValue),
                String.format("页面行为%s中的%s属性关联的页面URL常量：%s不存在", data.getEname(), strName, strValue));
        }
        return objRes;
    }
}
