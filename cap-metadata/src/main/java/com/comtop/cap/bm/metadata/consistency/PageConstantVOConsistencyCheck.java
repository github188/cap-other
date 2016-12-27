/******************************************************************************
 * Copyright (C) 2015 ShenZhen ComTop Information Technology Co.,Ltd
 * All Rights Reserved.
 * 本软件为深圳康拓普开发研制。未经本公司正式书面同意，其他任何个人、团体不得使用、
 * 复制、修改或发布本软件.
 *****************************************************************************/

package com.comtop.cap.bm.metadata.consistency;

import java.util.ArrayList;
import java.util.List;

import com.comtop.cap.bm.metadata.base.consistency.DefaultFieldConsistencyCheck;
import com.comtop.cap.bm.metadata.base.consistency.model.ConsistencyCheckResult;
import com.comtop.cap.bm.metadata.common.storage.CacheOperator;
import com.comtop.cap.bm.metadata.page.desinger.model.PageConstantVO;
import com.comtop.cap.bm.metadata.page.desinger.model.PageVO;

/**
 * 一致性校验
 * 
 * @author 罗珍明
 *
 */
public class PageConstantVOConsistencyCheck extends DefaultFieldConsistencyCheck<PageConstantVO,PageVO> {

	/**
	 * 
	 * @param data 属性值
	 * @param root 根对象
	 * @return 是否需要校验
	 */
	@Override
	protected boolean isNeedCheck(PageConstantVO data, PageVO root) {
		if("url".equals(data.getConstantType())){
			return true;
		}
		return false;
	}
	
	@Override
	public List<ConsistencyCheckResult> checkFieldDependOn(PageConstantVO data, PageVO root) {
		List<ConsistencyCheckResult> lstRes = new ArrayList<ConsistencyCheckResult>(0);
		if(isNeedCheck(data, root)){
			String strPageModelId = (String) data.getConstantOption().get("pageModelId");
            PageVO objPageVO = (PageVO) CacheOperator.readById(strPageModelId);
            if(objPageVO == null){
            	ConsistencyCheckResult objConsistencyCheckResult = new ConsistencyCheckResult();
            	objConsistencyCheckResult.setMessage("页面中定义的url常量："+data.getConstantName()+"的值:"+data.getConstantValue()+"不存在");
            	objConsistencyCheckResult.addAttr(ConsistencyResultAttrName.PAGE_DATASTORE_ATTRNAME_ENAME.getValue()
            			,ConsistencyResultAttrName.PAGE_DATASTORE_ATTRNAME_ENAME_VALUE_CONSTANTS.getValue());
            	objConsistencyCheckResult.addAttr(ConsistencyResultAttrName.PAGE_DATASTORE_ATTRNAME_PAGECONSTANT_CONSTANTNAME
            			.getValue(),data.getConstantName());
            	lstRes.add(objConsistencyCheckResult);
            }
		}
		return lstRes;
	}
}
