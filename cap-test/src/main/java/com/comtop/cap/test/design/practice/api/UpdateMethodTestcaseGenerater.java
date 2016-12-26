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
 * 更新方法测试用例生成
 * 
 * @author lizhongwen
 * @since jdk1.6
 * @version 2016年7月12日 lizhongwen
 */
@PetiteBean
public class UpdateMethodTestcaseGenerater extends AbstractMethodTestcaseGenerater {
    
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
        // 查询List参数
        String queryRequestJson = this
            .requestDataJson(facadeName, voName, "queryVOList", new HashMap<String, Object>());
        args.put("query-list-data", queryRequestJson);
        args.put("pk", idName);
        
        // 更新参数
        Map<String, Object> updateData = genData(entity);
        updateData.put(idName, "${value}");
        String saveRequestJson = this.requestDataJson(facadeName, voName, "update", updateData);
        args.put("update-data", saveRequestJson);
        
        // 根据ID查询的参数
        Map<String, Object> loadData = new HashMap<String, Object>();
        loadData.put(idName, "${value}");
        String loadRequestJson = this.requestDataJson(facadeName, voName, "load", loadData);
        args.put("load-data", loadRequestJson);
        
        // 数据验证参数
        String updatedAttrName = findCheckAttrName(entity.getAttributes());
        Object updatedValue = updateData.get(updatedAttrName);
        args.put("update-property", updatedAttrName);
        args.put("updated-value", updatedValue);
        return args;
    }
}
