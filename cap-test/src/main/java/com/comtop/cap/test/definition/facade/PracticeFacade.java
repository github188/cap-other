/******************************************************************************
 * Copyright (C) 2016 ShenZhen ComTop Information Technology Co.,Ltd
 * All Rights Reserved.
 * 本软件为深圳康拓普开发研制。未经本公司正式书面同意，其他任何个人、团体不得使用、
 * 复制、修改或发布本软件.
 *****************************************************************************/

package com.comtop.cap.test.definition.facade;

import java.util.ArrayList;
import java.util.List;
import java.util.Map;
import java.util.Map.Entry;

import com.comtop.cap.test.definition.model.Practice;
import com.comtop.cap.test.definition.model.PracticeType;
import com.comtop.cip.jodd.petite.meta.PetiteBean;
import comtop.org.directwebremoting.annotations.DwrProxy;
import comtop.org.directwebremoting.annotations.RemoteMethod;

/**
 * 最佳实践Facade
 *
 * @author lizhongwen
 * @since jdk1.6
 * @version 2016年7月12日 lizhongwen
 */
@DwrProxy
@PetiteBean
public class PracticeFacade {
    
    /**
     * 根据Id获取最佳实践
     *
     * @param id id
     * @return 最佳实践
     */
    @RemoteMethod
    public Practice loadPracticeById(String id) {
        return StepCache.getInstance().loadPracticeById(id);
    }
    
    /**
     * 获取所有最佳实践
     *
     * @return 最佳实践
     */
    @RemoteMethod
    public Map<PracticeType, Map<String, List<Practice>>> loadAllPractices() {
        return StepCache.getInstance().loadPractices();
    }
    
    /**
     * 根据类型获取所有最佳实践
     * 
     * @param type 最佳实践类型
     * @return 最佳实践
     */
    @RemoteMethod
    public Map<String, List<Practice>> loadPracticeByType(PracticeType type) {
        return StepCache.getInstance().loadPractices().get(type);
    }
    
    /**
     * 返回最佳实践集合
     *
     * @param type 最佳实践类型
     * @return 最佳实践
     */
    @RemoteMethod
    public List<Practice> loadPracticeList(PracticeType type) {
        List<Practice> lstPractice = new ArrayList<Practice>();
        Map<String, List<Practice>> objPracticeMap = this.loadPracticeByType(type);
        for (Entry<String, List<Practice>> entry : objPracticeMap.entrySet()) {
            lstPractice.addAll(entry.getValue());
        }
        return lstPractice;
    }
    
}
