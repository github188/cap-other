/******************************************************************************
 * Copyright (C) 2016 ShenZhen ComTop Information Technology Co.,Ltd
 * All Rights Reserved.
 * 本软件为深圳康拓普开发研制。未经本公司正式书面同意，其他任何个人、团体不得使用、
 * 复制、修改或发布本软件.
 *****************************************************************************/

package com.comtop.cap.test.design.practice.api;

import java.util.HashMap;
import java.util.Map;

import org.apache.commons.lang.StringUtils;

import com.comtop.cap.bm.metadata.entity.facade.EntityFacade;
import com.comtop.cap.bm.metadata.entity.model.EntityType;
import com.comtop.cap.bm.metadata.entity.model.EntityVO;
import com.comtop.cap.test.definition.facade.PracticeFacade;
import com.comtop.cap.test.definition.model.Practice;
import com.comtop.cap.test.design.model.TestCase;
import com.comtop.cap.test.design.model.TestCaseType;
import com.comtop.cap.test.design.practice.PracticeImpl;
import com.comtop.cip.jodd.petite.meta.PetiteBean;
import com.comtop.cip.jodd.petite.meta.PetiteInject;

/**
 * 实体方法测试最佳实践
 *
 * @author lizhongwen
 * @since jdk1.6
 * @version 2016年7月12日 lizhongwen
 */
@PetiteBean
public class EntityFacadeMethodTestPracticeImpl implements PracticeImpl {
    
    /** 最佳实践接口 */
    @PetiteInject
    protected PracticeFacade practiceFacade;
    
    /** 实体接口 */
    @PetiteInject
    protected EntityFacade entityFacade;
    
    /** 实体保存方法测试用例生成器 */
    @PetiteInject
    protected SaveMethodTestcaseGenerater saveGenerater;
    
    /** 实体更新方法测试用例生成器 */
    @PetiteInject
    protected UpdateMethodTestcaseGenerater updateGenerater;
    
    /** 实体删除方法测试用例生成器 */
    @PetiteInject
    protected DeleteMethodTestcaseGenerater deleteGenerater;
    
    /** 实体查询方法测试用例生成器 */
    @PetiteInject
    protected LoadMethodTestcaseGenerater loadGenerater;
    
    /** 实体发送方法测试用例生成器 */
    @PetiteInject
    protected ForeMethodTestcaseGenerater foreGenerater;
    
    /** 实体回退方法测试用例生成器 */
    @PetiteInject
    protected BackMethodTestcaseGenerater backGenerater;
    
    /** 实体撤回方法测试用例生成器 */
    @PetiteInject
    protected UndoMethodTestcaseGenerater undoGenerater;
    
    /** 方法 */
    private static final Map<String, String> methodMap = new HashMap<String, String>();
    
    static {
        methodMap.put("save", "保存");
        methodMap.put("update", "更新");
        methodMap.put("delete", "删除");
        methodMap.put("load", "查询");
        methodMap.put("fore", "发送(上报或下发)");
        methodMap.put("back", "回退");
        methodMap.put("undo", "撤回");
    }
    
    /**
     * 
     * @see com.comtop.cap.test.design.practice.PracticeImpl#impl(java.lang.String,
     *      com.comtop.cap.test.design.model.TestCase, java.util.Map)
     */
    @Override
    public TestCase impl(String practiceId, TestCase testcase, Map<String, String> args) {
        Practice practice = practiceFacade.loadPracticeById(practiceId);
        if (practice == null) {
            return null;
        }
        // 注意： metadata的结构为：entityId+"."+ methodName
        String metadataId = args.get("metadata");
        if (StringUtils.isBlank(metadataId)) {
            return null;
        }
        int index = metadataId.lastIndexOf(':');
        String entityId = metadataId.substring(0, index);
        String methodName = metadataId.substring(index + 1);
        if (!methodName.equals(practice.getMapping())) { // 方法名称不匹配
            return null;
        }
        EntityVO entity = entityFacade.loadEntity(entityId, null);
        if (entity == null || !EntityType.BIZ_ENTITY.getValue().equals(entity.getEntityType())) { // 暂不处理非业务实体
            return null;
        }
        TestCase tc = testcase;
        if (tc == null) {
            tc = new TestCase();
            tc.setModelPackage(entity.getModelPackage());
            tc.setName(methodMap.get(methodName) + "_" + entity.getChName());
        }
        tc.setModelName(methodName + "_" + entity.getEngName());
        tc.setType(TestCaseType.API);
        tc.setMetadata(metadataId);
        tc.setPractice(practiceId);
        String tcModelId = tc.getModelId();
        TestCase existed = (TestCase) TestCase.loadModel(tcModelId);
        if (existed != null) { // 如果用例已经生成，将不会重复生成。
            return null;
        }
        APITestcaseGenerater generater = this.getGenerater(methodName);
        if (generater != null) {
            generater.genTestcase(practice, tc, entity);
        }
        return tc;
    }
    
    /**
     * 获取用例生成器
     *
     * @param methodName 方法名称
     * @return 用例生成器
     */
    private APITestcaseGenerater getGenerater(String methodName) {
        if ("save".equals(methodName)) {
            return saveGenerater;
        } else if ("update".equals(methodName)) {
            return updateGenerater;
        } else if ("delete".equals(methodName)) {
            return deleteGenerater;
        } else if ("load".equals(methodName)) {
            return loadGenerater;
        } else if ("fore".equals(methodName)) {
            return foreGenerater;
        } else if ("back".equals(methodName)) {
            return backGenerater;
        } else if ("undo".equals(methodName)) {
            return undoGenerater;
        }
        return null;
    }
}
