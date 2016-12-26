/******************************************************************************
 * Copyright (C) 2016 
 * ShenZhen ComTop Information Technology Co.,Ltd
 * All Rights Reserved.
 * 本软件为深圳康拓普开发研制。
 * 未经本公司正式书面同意，其他任何个人、团体不得使用、
 * 复制、修改或发布本软件.
 *****************************************************************************/
package com.comtop.carstorage.facade;

import org.springframework.stereotype.Service;
import com.comtop.carstorage.facade.abs.AbstractOpinionFacade;
import com.comtop.carstorage.model.OpinionVO;

import com.comtop.carstorage.model.BizaccountVO;
import java.util.List;
import com.comtop.soa.annotation.SoaMethod;

/**
 * cap流程常用意见扩展实现
 * 
 * @author CAP超级管理员
 * @since 1.0
 * @version 2016-9-12 CAP超级管理员
 */
@Service(value="opinion2Facade")
public class OpinionFacade extends AbstractOpinionFacade<OpinionVO> {
	//TODO 请在此编写自己的业务代码
	
    /**
     * relationBizAccount
     * 
     * @param bizAccount bizAccount
     * @return  List<BizaccountVO>
     * 
     */
    @Override
    @SoaMethod(alias="relationBizAccount")     
    public List<BizaccountVO> relationBizAccount(BizaccountVO bizAccount){
      return null;
    }
}
