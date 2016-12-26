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
import com.comtop.cap.runtime.base.model.CapWorkflowParam;
import com.comtop.cip.jodd.petite.meta.PetiteBean;

/**
 * 默认发送方法测试用例生成
 * 
 * @author lizhongwen
 * @since jdk1.6
 * @version 2016年7月12日 lizhongwen
 */
@PetiteBean
public class UndoMethodTestcaseGenerater extends AbstractMethodTestcaseGenerater {
    
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
        String paramName = CapWorkflowParam.class.getName();
        String idName = findIdAttrName(entity.getAttributes());
        
        // 封装查询参数
        Map<String, Object> queryData = new HashMap<String, Object>();
        String saveRequestJson = this.requestDataJson(facadeName, voName, "queryDoneVOList", queryData);
        args.put("query-list-data", saveRequestJson);
        
        // 根据业务单据进行撤回
        Map<String, Object> undoData = new HashMap<String, Object>();
        undoData.put("workId", "${data['" + idName + "']}");
        undoData.put("taskId", "${data['taskId']}");
        undoData.put("paramMap", new HashMap<String, Object>());
        String undoRequestJson = this.requestDataJson(facadeName, paramName, "undo", undoData);
        args.put("undo-data", undoRequestJson);
        return args;
    }
}
