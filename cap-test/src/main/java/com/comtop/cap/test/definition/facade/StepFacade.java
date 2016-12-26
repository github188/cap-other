/******************************************************************************
 * Copyright (C) 2016 ShenZhen ComTop Information Technology Co.,Ltd
 * All Rights Reserved.
 * 本软件为深圳康拓普开发研制。未经本公司正式书面同意，其他任何个人、团体不得使用、
 * 复制、修改或发布本软件.
 *****************************************************************************/

package com.comtop.cap.test.definition.facade;

import java.util.HashMap;
import java.util.List;
import java.util.Map;

import org.apache.commons.lang.StringUtils;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;

import com.comtop.cap.bm.metadata.common.storage.CacheOperator;
import com.comtop.cap.bm.metadata.common.storage.exception.OperateException;
import com.comtop.cap.bm.metadata.common.storage.exception.ValidateException;
import com.comtop.cap.test.definition.model.BasicStep;
import com.comtop.cap.test.definition.model.StepDefinition;
import com.comtop.cap.test.definition.model.StepGroup;
import com.comtop.cap.test.definition.model.StepType;
import com.comtop.cip.jodd.petite.meta.PetiteBean;
import com.comtop.cip.jodd.util.StringUtil;
import comtop.org.directwebremoting.annotations.DwrProxy;
import comtop.org.directwebremoting.annotations.RemoteMethod;

/**
 * 步骤facade
 *
 * @author lizhongwen
 * @since jdk1.6
 * @version 2016年6月22日 lizhongwen
 */
@DwrProxy
@PetiteBean
public class StepFacade {
    
    /** 日志 */
    private final static Logger logger = LoggerFactory.getLogger(StepFacade.class);
    
    /** 步骤分组ID */
    private static final String STEP_PACKAGE_NAME = "testStepDefinitions.basics";
    
    /**
     * 根据Id获取基本步骤
     *
     * @param id id
     * @return 基本步骤
     */
    @RemoteMethod
    public BasicStep loadBasicStepById(String id) {
        BasicStep ret = null;
        if (StringUtils.isNotBlank(id)) {
            ret = (BasicStep) CacheOperator.readById(id);
        }
        return ret;
    }
    
    /**
     * 根据Id获取步骤定义
     *
     * @param id id
     * @return 步骤定义
     */
    @RemoteMethod
    public StepDefinition loadStepDefinitionById(String id) {
        StepDefinition ret = null;
        if (StringUtils.isNotBlank(id)) {
            ret = (StepDefinition) CacheOperator.readById(id);
        }
        return ret;
    }
    
    /**
     * 保存基本步骤
     *
     * @param step 基本步骤
     * @return 是否保存成功
     * @throws ValidateException 验证异常
     */
    @RemoteMethod
    public boolean saveBasicStep(BasicStep step) throws ValidateException {
        StepCache.getInstance().updateStepDefinition(step);
        return step.saveModel();
    }
    
    /**
     * 保存基本步骤
     * 
     * @param modelId modelId 上一个基本测试步骤对象ID
     * @param step 基本步骤
     * @return 是否保存成功
     * @throws ValidateException 验证异常
     * @throws OperateException 操作异常
     */
    @RemoteMethod
    public boolean saveBasicStep(String modelId, BasicStep step) throws ValidateException, OperateException {
        boolean bRet = false;
        BasicStep existed = this.loadBasicStepById(modelId);
        if (existed != null) {
            StepCache.getInstance().removeStepDefinition(existed);
        }
        BasicStep.deleteModel(modelId);
        bRet = step.saveModel();
        StepCache.getInstance().updateStepDefinition(step);
        return bRet;
    }
    
    /**
     * 获取所有的基本步骤集合
     *
     * @param pageNo 页码
     * @param pageSize 每页显示数量
     * 
     * @return 基本步骤集合
     * @throws OperateException OperateException
     */
    @RemoteMethod
    public Map<String, Object> queryALLBasicStep(int pageNo, int pageSize) throws OperateException {
        Map<String, Object> objRet = new HashMap<String, Object>();
        List<BasicStep> lstBasicStep = CacheOperator.queryList(STEP_PACKAGE_NAME + "/basic", BasicStep.class, pageNo,
            pageSize);
        List<BasicStep> lstBasicStepSize = CacheOperator.queryList(STEP_PACKAGE_NAME + "/basic", BasicStep.class);
        objRet.put("size", lstBasicStepSize.size());
        objRet.put("list", lstBasicStep);
        return objRet;
    }
    
    /**
     * 获取所有的基本步骤集合
     * 
     * @return 基本步骤集合
     * @throws OperateException OperateException
     */
    @RemoteMethod
    public List<BasicStep> queryALLBasicStep() throws OperateException {
        List<BasicStep> lstBasicStep = CacheOperator.queryList(STEP_PACKAGE_NAME + "/basic", BasicStep.class);
        return lstBasicStep;
    }
    
    /**
     * 带步骤分组的查询，获取所有步骤集合，包含步骤类型以及步骤分组
     * 
     * @return 步骤类型及分组
     */
    @RemoteMethod
    public Map<StepType, List<StepGroup>> queryALLStepsWithGroup() {
        return StepCache.getInstance().loadAllSteps();
    }
    
    /**
     * 删除测试步骤
     * 
     * @param models ID集合
     * @return 是否成功
     */
    @RemoteMethod
    public boolean delTestBasicStep(String[] models) {
        boolean bResult = true;
        try {
            for (int i = 0; i < models.length; i++) {
                BasicStep.deleteModel(models[i]);
            }
        } catch (Exception e) {
            bResult = false;
            logger.error("删除测试步骤文件失败", e);
        }
        return bResult;
    }
    
    /**
     * 根据测试步骤名称查询集合
     * 
     * @param stepName 基本步骤名称
     * @param stepGroup 基本步骤分组
     * @param pageNo 页码
     * @param pageSize 每页显示数量
     * @return 基本步骤集合
     * @throws OperateException OperateException
     */
    @RemoteMethod
    public Map<String, Object> queryBasicStepByName(String stepName, String stepGroup, int pageNo, int pageSize)
        throws OperateException {
        Map<String, Object> objRet = new HashMap<String, Object>();
        String strQueryExpression = "/basic";
        if (StringUtil.isNotBlank(stepGroup) && StringUtil.isNotBlank(stepName)) {
            strQueryExpression = "basic[contains(name,'" + stepName + "') or contains(definition,'" + stepName
                + "') and group='" + stepGroup + "']";
        } else if (StringUtil.isEmpty(stepGroup) && StringUtil.isNotBlank(stepName)) {
            strQueryExpression = "basic[contains(name,'" + stepName + "') or contains(definition,'" + stepName + "')]";
        } else if (StringUtil.isEmpty(stepName) && StringUtil.isNotBlank(stepGroup)) {
            strQueryExpression = "basic[group='" + stepGroup + "']";
        }
        @SuppressWarnings("unchecked")
        List<BasicStep> lstBasicStep = CacheOperator.queryList(strQueryExpression, BasicStep.class, pageNo, pageSize);
        List<BasicStep> lstBasicStepSize = CacheOperator.queryList(strQueryExpression, BasicStep.class);
        objRet.put("size", lstBasicStepSize.size());
        objRet.put("list", lstBasicStep);
        return objRet;
    }
    
    /**
     * 根据modelId,分组编码判断是否存在步骤定义
     *
     * <pre>
     * 
     * </pre>
     * 
     * @param modelId modelId
     * @param groupCode 分组编码
     * @param definition 步骤定义
     * @return boolean
     * @throws OperateException OperateException
     */
    @RemoteMethod
    public boolean isExitDefinition(String modelId, String groupCode, String definition) throws OperateException {
        boolean bResult = false;
        List<BasicStep> lstBasicStep = this.queryALLBasicStep();
        for (BasicStep basicStep : lstBasicStep) {
            if (basicStep.getGroup().equals(groupCode) && basicStep.getDefinition().equals(definition)
                && !basicStep.getModelId().equals(modelId)) {
                bResult = true;
                break;
            }
        }
        return bResult;
        
    }
}
