/******************************************************************************
 * Copyright (C) 2014 ShenZhen ComTop Information Technology Co.,Ltd
 * All Rights Reserved.
 * 本软件为深圳康拓普开发研制。未经本公司正式书面同意，其他任何个人、团体不得使用、
 * 复制、修改或发布本软件.
 *****************************************************************************/

package com.comtop.cap.bm.metadata.entity.facade;

import java.util.List;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;

import com.comtop.cap.bm.metadata.base.facade.CapBmBaseFacade;
import com.comtop.cap.bm.metadata.common.storage.CacheOperator;
import com.comtop.cap.bm.metadata.common.storage.exception.OperateException;
import com.comtop.cap.bm.metadata.common.storage.exception.ValidateException;
import com.comtop.cap.bm.metadata.entity.model.ExceptionVO;
import com.comtop.cap.bm.metadata.entity.model.ModelTypeConstant;
import com.comtop.cap.bm.metadata.sysmodel.facade.SysmodelFacade;
import com.comtop.cap.bm.metadata.sysmodel.model.CapPackageVO;
import com.comtop.cip.jodd.petite.meta.PetiteBean;
import com.comtop.top.core.jodd.AppContext;
import com.comtop.top.core.util.StringUtil;
import comtop.org.directwebremoting.annotations.DwrProxy;
import comtop.org.directwebremoting.annotations.RemoteMethod;

/**
 * 异常模型facade类
 *
 * @author 凌晨
 * @since jdk1.6
 * @version 2015年10月14日 凌晨
 */
@DwrProxy
@PetiteBean
public class ExceptionFacade extends CapBmBaseFacade {
    
    /** 日志 */
    private final static Logger LOG = LoggerFactory.getLogger(ExceptionFacade.class);
    
    /** 包Facade */
    private final SysmodelFacade packageFacade = AppContext.getBean(SysmodelFacade.class);
    
    /**
     * 查询异常列表
     * 
     * @param packageId 当前模块包ID
     * 
     * @return 异常列表
     * @throws OperateException 异常
     */
    @RemoteMethod
    public List<ExceptionVO> queryExceptionList(String packageId) throws OperateException {
        CapPackageVO objPackageVO = packageFacade.queryPackageById(packageId);
        String strPackageName = objPackageVO.getFullPath();
        List<ExceptionVO> lstExceptionVOs = CacheOperator.queryList(
            strPackageName + "/" + ModelTypeConstant.EXCEPTION.getValue(), ExceptionVO.class);
        return lstExceptionVOs;
        
    }
    
    /**
     * 通过异常modelId查询异常对象。如果modelId为空，则表示异常新增。
     * 
     * @param modelId 异常模型ID
     * @param packageId 包ID
     * @return 异常对象
     */
    @RemoteMethod
    public ExceptionVO loadException(String modelId, String packageId) {
        ExceptionVO objExceptionVO = new ExceptionVO();
        // 编辑
        if (StringUtil.isNotBlank(modelId)) {
            objExceptionVO = (ExceptionVO) CacheOperator.readById(modelId);
        } else { // 新增
            CapPackageVO objPackageVO = packageFacade.queryPackageById(packageId);
            objExceptionVO.setModelPackage(objPackageVO.getFullPath());
            objExceptionVO.setModelType(ModelTypeConstant.EXCEPTION.getValue());
            objExceptionVO.setPkg(objPackageVO);
        }
        return objExceptionVO;
    }
    
    /**
     * 异常保存
     *
     * @param exceptionVO 被保存的异常对象
     * @return 异常对象
     * @throws ValidateException 校验失败异常
     */
    @RemoteMethod
    public ExceptionVO saveException(ExceptionVO exceptionVO) throws ValidateException {
        boolean bResult = exceptionVO.saveModel();
        return bResult ? exceptionVO : null;
    }
    
    /**
     * 查询该包路径下是否存在相同异常英文名称（除当前异常之外，异常编译时不与自己比较）。
     * 
     * @param modelPackage 包全路径
     * @param engName 异常英文名称
     * @param modelId 异常模型Id
     * @return 是否存在（false： 不存在、true：存在）
     * @throws OperateException 操作异常
     */
    @RemoteMethod
    public boolean isExistSameNameException(String modelPackage, String engName, String modelId)
        throws OperateException {
        boolean bResult = false;
        List<ExceptionVO> lstExceptionVO = CacheOperator.queryList(
            modelPackage + "/" + ModelTypeConstant.EXCEPTION.getValue(), ExceptionVO.class);
        for (ExceptionVO objExceptionVO : lstExceptionVO) {
            String strEngName = objExceptionVO.getEngName();
            if (strEngName.equals(engName) && !objExceptionVO.getModelId().equals(modelId)) {
                bResult = true;
                break;
            }
        }
        return bResult;
    }
    
    /**
     * 查询该包路径下是否存在相同的异常中文名称
     * 
     * @param modelPackage 包全路径
     * @param chName 异常中文名称
     * @param modelId 异常模块ID
     * @return 是否存在（false： 不存在、true：存在）
     * @throws OperateException 操作异常
     */
    @RemoteMethod
    public boolean isExistSameChNameException(String modelPackage, String chName, String modelId)
        throws OperateException {
        boolean bResult = false;
        List<ExceptionVO> lstExceptionVO = CacheOperator.queryList(
            modelPackage + "/" + ModelTypeConstant.EXCEPTION.getValue(), ExceptionVO.class);
        for (ExceptionVO objExceptionVO : lstExceptionVO) {
            String strChName = objExceptionVO.getChName();
            String strModelId = objExceptionVO.getModelId();
            if (strChName.equals(chName) && !strModelId.equals(modelId)) {
                bResult = true;
                break;
            }
        }
        return bResult;
    }
    
    /**
     * 删除异常模型
     *
     * @param models 异常的modelId集合
     * @return 是否成功
     */
    @RemoteMethod
    public boolean delExceptions(String[] models) {
        boolean bResult = true;
        try {
            for (int i = 0; i < models.length; i++) {
                ExceptionVO.deleteModel(models[i]);
            }
        } catch (Exception e) {
            bResult = false;
            LOG.error("删除异常模型失败", e);
        }
        return bResult;
    }
    
    /**
     * 快速查询异常模型
     * 
     * @param keyword
     *            关键字
     * @return 系统模块集合
     * @throws OperateException 操作异常
     */
    @RemoteMethod
    public List<ExceptionVO> fastQueryException(String keyword) throws OperateException {
        @SuppressWarnings("unchecked")
        List<ExceptionVO> lstExceptionVOs = CacheOperator.queryList(ModelTypeConstant.EXCEPTION.getValue()
            + "[contains(engName,'" + keyword + "') or contains(chName,'" + keyword + "')]");
        return lstExceptionVOs;
    }
    
}
