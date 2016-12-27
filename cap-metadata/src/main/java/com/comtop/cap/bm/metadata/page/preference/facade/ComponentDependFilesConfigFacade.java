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
import com.comtop.cap.bm.metadata.common.dwr.CapMap;
import com.comtop.cap.bm.metadata.common.storage.CacheOperator;
import com.comtop.cap.bm.metadata.common.storage.exception.OperateException;
import com.comtop.cap.bm.metadata.common.storage.exception.ValidateException;
import com.comtop.cap.bm.metadata.page.preference.model.ComponentDependFilesConfigVO;
import com.comtop.cap.bm.metadata.page.uilibrary.facade.ComponentFacade;
import com.comtop.cip.jodd.petite.meta.PetiteBean;
import com.comtop.top.core.jodd.AppContext;
import comtop.org.directwebremoting.annotations.DwrProxy;
import comtop.org.directwebremoting.annotations.RemoteMethod;

/**
 * 控件依赖文件配置
 *
 * @author 诸焕辉
 * @version jdk1.6
 * @version 2016-3-30 诸焕辉
 */
@DwrProxy
@PetiteBean
public class ComponentDependFilesConfigFacade extends CapBmBaseFacade {
    
    /**
     * 页面/菜单 facade
     */
    protected ComponentFacade componentFacade = AppContext.getBean(ComponentFacade.class);
    
    /**
     * 加载模型文件
     *
     * @param modelId 模型ID
     * @return 操作结果
     * @throws OperateException 操作异常
     */
    @RemoteMethod
    public ComponentDependFilesConfigVO loadModel(String modelId) throws OperateException {
        ComponentDependFilesConfigVO objCompDependFilesConfig = (ComponentDependFilesConfigVO) CacheOperator
            .readById(modelId);
        if (objCompDependFilesConfig == null) {
            objCompDependFilesConfig = new ComponentDependFilesConfigVO();
        }
        List<CapMap> lstDependFilesChangeInfo = objCompDependFilesConfig.getDependFilesChangeInfoList();
        // 已存在的映射配置
        List<String> lstExistDependFilePath = new ArrayList<String>();
        // 获取控件所有默认依赖文件路径信息
        List<String> lstDefaultDependFiles = componentFacade.queryAllComponentDependFiles();
        // 清除引用文件已经被删除的配置项
        for (int i = 0, len = lstDependFilesChangeInfo.size(); i < len; i++) {
            String strDefaultFilePath = (String) lstDependFilesChangeInfo.get(i).get("defaultFilePath");
            if (!lstDefaultDependFiles.contains(strDefaultFilePath)) {
                lstDependFilesChangeInfo.remove(i);
                len--;
                i--;
            }
            lstExistDependFilePath.add(strDefaultFilePath);
        }
        // 重新扫描所有控件依赖文件，检查是否有最新的引用文件未载【 控件依赖文件配置】文件中，如果没加入，则添加
        for (String strFilePath : lstDefaultDependFiles) {
            if (!lstExistDependFilePath.contains(strFilePath)) {
                CapMap objNewConfig = new CapMap();
                objNewConfig.put("defaultFilePath", strFilePath);
                lstDependFilesChangeInfo.add(objNewConfig);
            }
        }
        return objCompDependFilesConfig;
    }
    
    /**
     * 保存
     *
     * @param model 被保存的对象
     * @return 是否成功
     * @throws ValidateException 异常
     */
    @RemoteMethod
    public boolean saveModel(ComponentDependFilesConfigVO model) throws ValidateException {
        return model.saveModel();
    }
    
    /**
     * 删除模型
     *
     * @param model 被删除的对象
     * @return 是否成功
     * @throws OperateException 异常
     */
    @RemoteMethod
    public boolean deleteModel(ComponentDependFilesConfigVO model) throws OperateException {
        return model.deleteModel();
    }
    
}
