/******************************************************************************
 * Copyright (C) 2015 ShenZhen ComTop Information Technology Co.,Ltd
 * All Rights Reserved.
 * 本软件为深圳康拓普开发研制。未经本公司正式书面同意，其他任何个人、团体不得使用、
 * 复制、修改或发布本软件.
 *****************************************************************************/

package com.comtop.cap.bm.metadata.page.preference.facade;

import java.util.ArrayList;
import java.util.List;

import com.comtop.cap.bm.metadata.base.facade.CapBmBaseFacade;
import com.comtop.cap.bm.metadata.common.storage.CacheOperator;
import com.comtop.cap.bm.metadata.common.storage.exception.OperateException;
import com.comtop.cap.bm.metadata.page.desinger.model.PageAttributeVO;
import com.comtop.cip.jodd.petite.meta.PetiteBean;
import com.comtop.top.core.util.constant.NumberConstant;
import comtop.org.directwebremoting.annotations.DwrProxy;
import comtop.org.directwebremoting.annotations.RemoteMethod;

/**
 * 页面参数首选项
 *
 * @author 凌晨
 * @version jdk1.6
 * @version 2015-8-5 凌晨
 */
@DwrProxy
@PetiteBean
public class PageAttributePreferenceFacade extends CapBmBaseFacade {
    
    /**
     * 获取默认页面参数首选项
     *
     * @return 操作结果
     * @throws OperateException json操作异常
     */
    public List<PageAttributeVO> queryDefaultReferenceParameters() throws OperateException {
        return queryByDefaultReference(true);
    }
    
    /**
     * 获取可选页面参数首选项
     *
     * @return 操作结果
     * @throws OperateException json操作异常
     */
    @RemoteMethod
    public List<PageAttributeVO> queryOptionalParameters() throws OperateException {
        return queryByDefaultReference(false);
    }
    
    /**
     * 根据是否默认页面参数，获取页面参数首选项
     * 
     * @param defaultReference 是否是默认页面参数
     * 
     * @return 操作结果
     * @throws OperateException json操作异常
     */
    @SuppressWarnings("unchecked")
    private List<PageAttributeVO> queryByDefaultReference(boolean defaultReference) throws OperateException {
        List<PageAttributeVO> lstPageAttributeVO = new ArrayList<PageAttributeVO>();
        StringBuffer sbExpression = new StringBuffer();
        int iBool = defaultReference == true ? NumberConstant.ONE : NumberConstant.ZERO;
        sbExpression.append("preference.page/pageParameter/parameterList[defaultReference=").append(iBool).append("]");
        lstPageAttributeVO = CacheOperator.queryList(sbExpression.toString());
        return lstPageAttributeVO;
    }
}
