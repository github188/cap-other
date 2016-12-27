/******************************************************************************
 * Copyright (C) 2015 ShenZhen ComTop Information Technology Co.,Ltd
 * All Rights Reserved.
 * 本软件为深圳康拓普开发研制。未经本公司正式书面同意，其他任何个人、团体不得使用、
 * 复制、修改或发布本软件.
 *****************************************************************************/

package com.comtop.cap.bm.metadata.page.preference.facade;

import java.util.List;

import com.comtop.cap.bm.metadata.base.facade.CapBmBaseFacade;
import com.comtop.cap.bm.metadata.common.storage.CacheOperator;
import com.comtop.cap.bm.metadata.common.storage.exception.OperateException;
import com.comtop.cap.bm.metadata.page.preference.model.BuiltInActionPreferenceVO;
import com.comtop.cap.bm.metadata.page.preference.model.BuiltInActionVO;
import com.comtop.cip.jodd.petite.meta.PetiteBean;
import com.comtop.top.core.util.constant.NumberConstant;
import comtop.org.directwebremoting.annotations.DwrProxy;
import comtop.org.directwebremoting.annotations.RemoteMethod;

/**
 * 内置行为函数facade类
 *
 * @author 诸焕辉
 * @version jdk1.6
 * @version 2015-7-22 诸焕辉
 */
@DwrProxy
@PetiteBean
public class BuiltInActionPreferenceFacade extends CapBmBaseFacade {
    
    /**
     * 根据"关联内置行为引入文件名称"获取内置行为函数
     *
     * @param filePaths 关联内置行为引入文件名称数组
     * @return 操作结果
     * @throws OperateException json操作异常
     */
    @SuppressWarnings("unchecked")
    @RemoteMethod
    public List<BuiltInActionVO> queryListByFileName(String[] filePaths) throws OperateException {
        List<BuiltInActionVO> objBuiltInActionVO = null;
        if (filePaths != null && filePaths.length > NumberConstant.ZERO) {
            StringBuffer sbExpression = new StringBuffer();
            sbExpression.append("preference.page/builtInAction/builtInActionList[");
            for (int i = 0, len = filePaths.length; i < len; i++) {
                sbExpression.append("fileName='").append(filePaths[i]).append("'");
                if (i < len - 1) {
                    sbExpression.append(" or ");
                }
            }
            sbExpression.append("]");
            objBuiltInActionVO = CacheOperator.queryList(sbExpression.toString());
        }
        return objBuiltInActionVO;
    }
    
    /**
     * 加载模型文件
     *
     * @param id 控件模型ID
     * @return 操作结果
     */
    @RemoteMethod
    public BuiltInActionPreferenceVO loadModel(String id) {
        return (BuiltInActionPreferenceVO) CacheOperator.readById(id);
    }
    
    /**
     * 根据行为名称，检查行为是否存在
     *
     * @param actionMethodName 行为名称
     * @return 检查结果
     */
    public boolean existBuiltInActionMethodName(String actionMethodName){
        int iCount = 0;
        try {
            iCount = CacheOperator.queryCount("preference.page/builtInAction/builtInActionList[actionMethodName='" + actionMethodName + "']");
        } catch (OperateException e) {
            e.printStackTrace();
        }
        return iCount > 0 ? true : false;
    }
}
