/******************************************************************************
 * Copyright (C) 2016 ShenZhen ComTop Information Technology Co.,Ltd
 * All Rights Reserved.
 * 本软件为深圳康拓普开发研制。未经本公司正式书面同意，其他任何个人、团体不得使用、
 * 复制、修改或发布本软件.
 *****************************************************************************/

package com.comtop.cap.test.design.generate;

import java.util.HashMap;
import java.util.LinkedHashSet;
import java.util.LinkedList;
import java.util.List;
import java.util.Map;
import java.util.Set;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;

import com.comtop.cap.bm.metadata.entity.facade.EntityFacade;
import com.comtop.cap.bm.metadata.entity.model.EntityVO;
import com.comtop.cap.bm.metadata.entity.model.MethodVO;
import com.comtop.cap.test.definition.facade.PracticeFacade;
import com.comtop.cap.test.definition.model.Practice;
import com.comtop.cap.test.definition.model.PracticeType;
import com.comtop.cap.test.design.facade.InvokeFacade;
import com.comtop.cap.test.design.facade.VersionFacade;
import com.comtop.cap.test.design.model.InvokeData;
import com.comtop.cap.test.design.model.TestCase;
import com.comtop.cip.jodd.petite.meta.PetiteBean;
import com.comtop.cip.jodd.petite.meta.PetiteInject;

/**
 * 实体方法测试用例生成器
 *
 * @author lizhongwen
 * @since jdk1.6
 * @version 2016年7月13日 lizhongwen
 */
@PetiteBean
public class EntityMethodTestcaseGenerator implements TestcaseGenerator<EntityVO> {
    
    /** 日志 */
    private final static Logger logger = LoggerFactory.getLogger(EntityMethodTestcaseGenerator.class);
    
    /** 执行器 */
    @PetiteInject
    protected InvokeFacade invokeFacade;
    
    /** 版本管理接口 */
    @PetiteInject
    protected VersionFacade versionFacade;
    
    /** 版本管理接口 */
    @PetiteInject
    protected PracticeFacade practiceFacade;
    
    /** 实体接口 */
    @PetiteInject
    protected EntityFacade entityFacade;
    
    /**
     * 
     * @see com.comtop.cap.test.design.generate.TestcaseGenerator#gen(com.comtop.cap.bm.metadata.base.model.BaseMetadata)
     */
    @Override
    public List<TestCase> gen(EntityVO metadata) {
        String modelId = metadata.getModelId();
        Map<String, List<Practice>> practiceMap = practiceFacade.loadPracticeByType(PracticeType.API);
        if (practiceMap == null || practiceMap.values() == null) {
            return null;
        }
        Set<String> methods = this.handleEntityMethods(modelId);
        List<TestCase> result = new LinkedList<TestCase>();
        TestCase testcase = null;
        for (List<Practice> practices : practiceMap.values()) {
            for (Practice practice : practices) {
                String practiceId = practice.getModelId();
                if (!methods.contains(practice.getMapping())) {
                    continue;
                }
                String metadataId = modelId.concat(":").concat(practice.getMapping());
                String clazz = practice.getImpl();
                testcase = genTestcase(practiceId, metadataId, clazz);
                if (testcase != null) {
                    result.add(testcase);
                }
            }
        }
        return result;
    }
    
    /**
     * 处理实体方法
     *
     * @param modelId 实体ModelId
     * @return 实体方法
     */
    private Set<String> handleEntityMethods(String modelId) {
        Set<String> methodNames = new LinkedHashSet<String>();
        List<MethodVO> methods = this.entityFacade.getSelfAndParentMethods(modelId);
        if (methods == null) {
            return methodNames;
        }
        for (MethodVO method : methods) {
            methodNames.add(method.getEngName());
        }
        return methodNames;
    }
    
    /**
     * 生成测试用例
     *
     * @param practiceId 最佳实践Id
     * @param metadataId 元数据id
     * @param clazz 实现类
     * @return 测试用例
     */
    private TestCase genTestcase(String practiceId, String metadataId, String clazz) {
        InvokeData data = new InvokeData();
        data.setModelId(practiceId);
        Map<String, String> datas = new HashMap<String, String>();
        datas.put("metadata", metadataId);
        data.setDatas(datas);
        TestCase testcase = null;
        try {
            testcase = invokeFacade.practiceImpl(data);
            if (testcase != null) {
               // testcase.saveModel();
                // 更新版本信息
                versionFacade.updateVersion(testcase.getModelId(), testcase.getScriptName());
            }
        } catch (Exception e) {
            logger.error("根据最佳实践【{}】生成用例出错。", practiceId, e);
        }
        return testcase;
    }
}
