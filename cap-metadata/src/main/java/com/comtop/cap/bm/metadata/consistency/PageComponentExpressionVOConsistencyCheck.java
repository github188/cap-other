/******************************************************************************
 * Copyright (C) 2015 ShenZhen ComTop Information Technology Co.,Ltd
 * All Rights Reserved.
 * 本软件为深圳康拓普开发研制。未经本公司正式书面同意，其他任何个人、团体不得使用、
 * 复制、修改或发布本软件.
 *****************************************************************************/

package com.comtop.cap.bm.metadata.consistency;

import com.comtop.cap.bm.metadata.base.consistency.DefaultFieldConsistencyCheck;
import com.comtop.cap.bm.metadata.page.desinger.model.PageComponentExpressionVO;
import com.comtop.cap.bm.metadata.page.desinger.model.PageVO;

/**
 * 一致性校验
 * 
 * @author 罗珍明
 *
 */
public class PageComponentExpressionVOConsistencyCheck extends DefaultFieldConsistencyCheck<PageComponentExpressionVO, PageVO> {

	@Override
	protected String getCheckResultPageType() {
		return ConsistencyCheckResultType.CONSISTENCY_TYPE_PAGE_RIGHT.getValue();
	}

}
