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
import com.comtop.cap.bm.metadata.base.consistency.model.FieldConsistencyCheckVO;
import com.comtop.cap.bm.metadata.page.desinger.model.DataStoreVO;
import com.comtop.cap.bm.metadata.page.desinger.model.PageVO;

/**
 * 一致性校验
 * 
 * @author 罗珍明
 *
 */
public class DataStoreVOConsistencyCheck extends DefaultFieldConsistencyCheck<DataStoreVO, PageVO>{

	@Override
	protected boolean isNeedCheck(DataStoreVO data, PageVO root) {
		if("list".equals(data.getModelType()) || "object".equals(data.getModelType())){
			return true;
		}
		if("pageConstant".equals(data.getModelType())){
			return true;
		}
		return false;
	}
	
	@Override
	protected List<FieldConsistencyCheckVO> filterCheckField(DataStoreVO data,List<FieldConsistencyCheckVO> lstField) {
		List<FieldConsistencyCheckVO> lstFilter = new ArrayList<FieldConsistencyCheckVO>();
		for (FieldConsistencyCheckVO fieldCheckVO : lstField) {
			if("entityId".equals(fieldCheckVO.getConsistencyConfigVO().getFieldName())
					&& ("list".equals(data.getModelType()) || "object".equals(data.getModelType()))){
				lstFilter.add(fieldCheckVO);
			}else if("pageConstantList".equals(fieldCheckVO.getConsistencyConfigVO().getFieldName())
					&&"pageConstant".equals(data.getModelType())){
				lstFilter.add(fieldCheckVO);
			}
		}
		return lstFilter;
	}
	
	@Override
	protected String getCheckResultPageType() {
		return ConsistencyCheckResultType.CONSISTENCY_TYPE_PAGE_DATASTORE.getValue();
	}
}
