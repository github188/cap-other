/******************************************************************************
 * Copyright (C) 2016 ShenZhen ComTop Information Technology Co.,Ltd
 * All Rights Reserved.
 * 本软件为深圳康拓普开发研制。未经本公司正式书面同意，其他任何个人、团体不得使用、
 * 复制、修改或发布本软件.
 *****************************************************************************/

package com.comtop.cap.test.definition.facade;

import java.util.LinkedList;
import java.util.List;

import com.comtop.cap.bm.metadata.base.facade.CapBmBaseFacade;
import com.comtop.cap.test.definition.model.StepGroup;
import com.comtop.cap.test.definition.model.StepGroups;
import com.comtop.cip.jodd.petite.meta.PetiteBean;
import com.comtop.cip.jodd.petite.meta.PetiteInject;
import comtop.org.directwebremoting.annotations.DwrProxy;
import comtop.org.directwebremoting.annotations.RemoteMethod;

/**
 * 步骤分组Facade
 *
 * @author lizhongwen
 * @since jdk1.6
 * @version 2016年6月24日 lizhongwen
 */
@DwrProxy
@PetiteBean
public class StepGroupsFacade extends CapBmBaseFacade {
    
    /** 步骤定义Facade */
    @PetiteInject
    protected StepFacade stepFacade;
    
    /**
     * @return 获取步骤分组
     */
    @RemoteMethod
    public StepGroups loadStepGroups() {
        return StepCache.getInstance().getStepGroups();
    }
    
    /**
     * @param code 分组编码
     * @param name 分组名称
     * @return 保存步骤分组
     */
    @RemoteMethod
    public boolean nameUniqueValidate(String code, String name) {
        StepGroups groups = StepCache.getInstance().getStepGroups();
        if (groups == null || groups.getGroups() == null || groups.getGroups().isEmpty()) {
            return true;
        }
        List<StepGroup> stepGroups = groups.getGroups();
        for (StepGroup stepGroup : stepGroups) {
            if (!code.equals(stepGroup.getCode()) && name.equals(stepGroup.getName())) {
                return false;
            }
        }
        return true;
    }
    
    /**
     * 根据编码获取步骤分组
     *
     * @param code 编码
     * @return 步骤分组
     */
    @RemoteMethod
    public StepGroup loadStepGroupByCode(String code) {
        StepGroups groups = StepCache.getInstance().getStepGroups();
        if (groups == null) {
            return null;
        }
        return groups.findGroupByCode(code);
    }
    
    /**
     * @param group 步骤分组
     * @return 保存步骤分组
     */
    @RemoteMethod
    public boolean saveStepGroup(StepGroup group) {
        return StepCache.getInstance().updateGroupCache(group);
    }
    
    /**
     *
     * @param code 分组编码
     * @return 是否含有步骤
     */
    public boolean hasStep(String code) {
        return StepCache.getInstance().isGroupHasStep(code);
    }
    
    /**
     *
     * @param codes 分组编码
     * @return 是否含有步骤
     */
    @RemoteMethod
    public String[] deleteAble(List<String> codes) {
        List<String> unables = new LinkedList<String>();
        for (String code : codes) {
            if (hasStep(code)) {
                unables.add(code);
            }
        }
        return unables.toArray(new String[0]);
    }
    
    /**
     *
     * @param codes 步骤编码
     * @return 是否含有步骤
     */
    @RemoteMethod
    public boolean deleteStepGroups(List<String> codes) {
        return StepCache.getInstance().removeGroupCache(codes.toArray(new String[0]));
    }
}
