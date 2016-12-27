/******************************************************************************
 * Copyright (C) 2015 ShenZhen ComTop Information Technology Co.,Ltd
 * All Rights Reserved.
 * 本软件为深圳康拓普开发研制。未经本公司正式书面同意，其他任何个人、团体不得使用、
 * 复制、修改或发布本软件.
 *****************************************************************************/

package com.comtop.cap.bm.metadata.page.actionlibrary.facade;

import java.util.ArrayList;
import java.util.Iterator;
import java.util.List;

import org.apache.commons.lang.StringUtils;

import com.comtop.cap.bm.metadata.base.facade.CapBmBaseFacade;
import com.comtop.cap.bm.metadata.common.storage.CacheOperator;
import com.comtop.cap.bm.metadata.common.storage.exception.OperateException;
import com.comtop.cap.bm.metadata.page.actionlibrary.model.JSFunctionVO;
import com.comtop.cap.bm.metadata.page.actionlibrary.model.JSFunctionsVO;
import com.comtop.cip.jodd.petite.meta.PetiteBean;

import comtop.org.directwebremoting.annotations.DwrProxy;
import comtop.org.directwebremoting.annotations.RemoteMethod;

/**
 * js函数facade类
 *
 * @author 诸焕辉
 * @version jdk1.6
 * @version 2015-6-03 诸焕辉
 */
@DwrProxy
@PetiteBean
public class JSFunctionFacade extends CapBmBaseFacade {
	/** 日志 */
    
    
    /**
    
    /**
     * 根据控件英文名称加载模型文件
     *
     * @return 操作结果
     * @throws OperateException xml操作异常
     */
    @RemoteMethod
    public JSFunctionsVO loadModelByModelId() throws OperateException {
       String modelId =  JSFunctionsVO.getCustomModelId();
       JSFunctionsVO objJSFunctions = null;
        if (StringUtils.isNotBlank(modelId)) {
            objJSFunctions = (JSFunctionsVO) CacheOperator.readById(modelId);
        }
        return objJSFunctions;
    }
    
    /**
     * 根据控件英文名称加载模型文件
     * @param group  js函数分组
     *
     * @return 操作结果
     * @throws OperateException xml操作异常
     */
    @RemoteMethod
    public JSFunctionsVO loadModelByModelId(String group) throws OperateException {
        JSFunctionsVO objJSFunctions = this.loadModelByModelId();
        List<JSFunctionVO> lstJSFunction = objJSFunctions.getJsFunctions();
        List<JSFunctionVO> lstTempJSFunction = new ArrayList<JSFunctionVO>();
        for (Iterator<JSFunctionVO> iterator = lstJSFunction.iterator(); iterator.hasNext();) {
            JSFunctionVO objJSFunctionVO = iterator.next();
            if(StringUtils.equals(group, objJSFunctionVO.getGroup()) || StringUtils.equals("all", objJSFunctionVO.getGroup())){
                lstTempJSFunction.add(objJSFunctionVO);
            }
        }
        objJSFunctions.setJsFunctions(lstTempJSFunction);
        return objJSFunctions;
    }
}
