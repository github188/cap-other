/******************************************************************************
 * Copyright (C) 2016 
 * ShenZhen ComTop Information Technology Co.,Ltd
 * All Rights Reserved.
 * 本软件为深圳康拓普开发研制。
 * 未经本公司正式书面同意，其他任何个人、团体不得使用、
 * 复制、修改或发布本软件.
 *****************************************************************************/
package com.comtop.tech.facade;

import org.springframework.stereotype.Service;
import com.comtop.tech.facade.abs.AbstractContractFacade;
import com.comtop.tech.model.ContractVO;


/**
 * 合同信息扩展实现
 * 
 * @author CAP超级管理员
 * @since 1.0
 * @version 2016-11-23 CAP超级管理员
 */
@Service(value="contractFacade")
public class ContractFacade extends AbstractContractFacade<ContractVO> {
	//TODO 请在此编写自己的业务代码
	
}
