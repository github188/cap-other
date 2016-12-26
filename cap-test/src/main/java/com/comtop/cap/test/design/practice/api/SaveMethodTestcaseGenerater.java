/******************************************************************************
 * Copyright (C) 2016 ShenZhen ComTop Information Technology Co.,Ltd
 * All Rights Reserved.
 * 本软件为深圳康拓普开发研制。未经本公司正式书面同意，其他任何个人、团体不得使用、
 * 复制、修改或发布本软件.
 *****************************************************************************/

package com.comtop.cap.test.design.practice.api;

import java.util.HashMap;
import java.util.Map;

import com.comtop.cap.bm.metadata.entity.model.EntityVO;
import com.comtop.cap.test.design.practice.api.AbstractMethodTestcaseGenerater;
import com.comtop.cip.jodd.petite.meta.PetiteBean;

/**
 * 保存方法测试用例生成
 * 
 * @author lizhongwen
 * @since jdk1.6
 * @version 2016年7月12日 lizhongwen
 */
@PetiteBean
public class SaveMethodTestcaseGenerater extends AbstractMethodTestcaseGenerater {
    
    /**
     * 封装参数
     *
     * @param entity 实体
     * @return 参数
     */
    @Override
    public Map<String, Object> wrapperArgs(EntityVO entity) {
        Map<String, Object> args = new HashMap<String, Object>();
        String facadeName = entity.getModelPackage() + ".facade." + entity.getEngName() + "Facade";
        String voName = entity.getModelPackage() + ".model." + entity.getEngName() + "VO";
        String idName = findIdAttrName(entity.getAttributes());
        
        // 封装保存参数
        Map<String, Object> saveData = genData(entity);
        saveData.put(idName, null);
        String saveRequestJson = this.requestDataJson(facadeName, voName, "save", saveData);
        args.put("save-data", saveRequestJson);
        
        // 根据ID查询的参数
        Map<String, Object> loadData = new HashMap<String, Object>();
        loadData.put(idName, "${data}");
        String loadRequestJson = this.requestDataJson(facadeName, voName, "load", loadData);
        args.put("load-data", loadRequestJson);
        return args;
    }
}
