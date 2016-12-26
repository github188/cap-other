/******************************************************************************
 * Copyright (C) 2016 ShenZhen ComTop Information Technology Co.,Ltd
 * All Rights Reserved.
 * 本软件为深圳康拓普开发研制。未经本公司正式书面同意，其他任何个人、团体不得使用、
 * 复制、修改或发布本软件.
 *****************************************************************************/

package com.comtop.cap.test.design.generate;

import java.util.ArrayList;
import java.util.HashMap;
import java.util.LinkedList;
import java.util.List;
import java.util.Map;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;

import com.comtop.cap.bm.metadata.base.model.BaseModel;
import com.comtop.cap.bm.metadata.common.storage.CacheOperator;
import com.comtop.cap.bm.metadata.common.storage.exception.OperateException;
import com.comtop.cap.bm.metadata.common.storage.exception.ValidateException;
import com.comtop.cap.bm.metadata.entity.facade.EntityFacade;
import com.comtop.cap.bm.metadata.entity.model.CascadeAttributeVO;
import com.comtop.cap.bm.metadata.entity.model.EntityVO;
import com.comtop.cap.bm.metadata.page.desinger.model.PageVO;
import com.comtop.cap.runtime.base.util.BeanContextUtil;
import com.comtop.cap.test.design.facade.VersionFacade;
import com.comtop.cap.test.design.model.TestCase;
import com.comtop.cip.jodd.petite.meta.PetiteBean;
import com.comtop.top.core.jodd.AppContext;

/**
 * 用例生成器上下文
 *
 * @author lizhongwen
 * @since jdk1.6
 * @version 2016年7月13日 lizhongwen
 */
@PetiteBean
public class TestcaseGeneratorContext {
    
    /** 日志 */
    private final static Logger logger = LoggerFactory.getLogger(TestcaseGeneratorContext.class);
    
    /** 实体方法测试用例生成器 */
    protected EntityMethodTestcaseGenerator entityMethodTestcaseGenerator = BeanContextUtil
        .getBean(EntityMethodTestcaseGenerator.class);
    
    /** 页面功能测试用例生成器 */
    protected FunctionMethodTestcaseGenerator functionMethodTestcaseGenerator = BeanContextUtil
        .getBean(FunctionMethodTestcaseGenerator.class);
    
    /** 版本 */
    protected VersionFacade versionFacade = BeanContextUtil.getBean(VersionFacade.class);
    
    /** 实体Facade */
    private final EntityFacade entityFacade = AppContext.getBean(EntityFacade.class);
    
    /**
     * 元数据集合
     *
     * @param metadatas 元数据
     * @return 用例集合
     */
    @SuppressWarnings("unchecked")
    public List<TestCase> generate(List<? extends BaseModel> metadatas) {
        if (metadatas == null || metadatas.isEmpty()) {
            return null;
        }
        List<TestCase> ret = new LinkedList<TestCase>();
        List<TestCase> temp;
        List<String> ignores = analyseIgnores(metadatas);
        for (BaseModel metadata : metadatas) {
            if (ignores.contains(metadata.getModelId())) {
                continue;
            }
            temp = this.getGenerator(metadata.getClass()).gen(metadata);
            if (temp != null) {
                ret.addAll(temp);
            }
        }
        // 设置测试用例的序号
        setTestCaseSortNo(ret);
        return ret;
    }
    
    /**
     * 把通过一键生成的测试用例设置序号
     *
     * @param lstTestCase 一键生成的测试用例
     */
    private void setTestCaseSortNo(List<TestCase> lstTestCase) {
        Map<String, List<TestCase>> objMap = new HashMap<String, List<TestCase>>();
        // 按最佳实践类型分类
        for (TestCase objTmpTestCase : lstTestCase) {
            String strPractice = objTmpTestCase.getPractice();
            if (objMap.containsKey(strPractice)) {
                List<TestCase> lstTemp = objMap.get(strPractice);
                lstTemp.add(objTmpTestCase);
            } else {
                List<TestCase> lstTmp = new ArrayList<TestCase>();
                lstTmp.add(objTmpTestCase);
                objMap.put(strPractice, lstTmp);
            }
        }
        // 根据最佳实践类型排序
        List<TestCase> lstSort = new LinkedList<TestCase>();
        if (objMap.get("testStepDefinitions.practices.practice.form_insert") != null) {
            lstSort.addAll(objMap.get("testStepDefinitions.practices.practice.form_insert"));
        }
        if (objMap.get("testStepDefinitions.practices.practice.save_method") != null) {
            lstSort.addAll(objMap.get("testStepDefinitions.practices.practice.save_method"));
        }
        if (objMap.get("testStepDefinitions.practices.practice.form_update") != null) {
            lstSort.addAll(objMap.get("testStepDefinitions.practices.practice.form_update"));
        }
        if (objMap.get("testStepDefinitions.practices.practice.update_method") != null) {
            lstSort.addAll(objMap.get("testStepDefinitions.practices.practice.update_method"));
        }
        if (objMap.get("testStepDefinitions.practices.practice.edit_workflow_report") != null) {
            lstSort.addAll(objMap.get("testStepDefinitions.practices.practice.edit_workflow_report"));
        }
        if (objMap.get("testStepDefinitions.practices.practice.edit_workflow_saveAndreport") != null) {
            lstSort.addAll(objMap.get("testStepDefinitions.practices.practice.edit_workflow_saveAndreport"));
        }
        if (objMap.get("testStepDefinitions.practices.practice.list_workflow_report") != null) {
            lstSort.addAll(objMap.get("testStepDefinitions.practices.practice.list_workflow_report"));
        }
        if (objMap.get("testStepDefinitions.practices.practice.fore_method") != null) {
            lstSort.addAll(objMap.get("testStepDefinitions.practices.practice.fore_method"));
        }
        if (objMap.get("testStepDefinitions.practices.practice.edit_workflow_send") != null) {
            lstSort.addAll(objMap.get("testStepDefinitions.practices.practice.edit_workflow_send"));
        }
        if (objMap.get("testStepDefinitions.practices.practice.edit_workflow_saveAndsend") != null) {
            lstSort.addAll(objMap.get("testStepDefinitions.practices.practice.edit_workflow_saveAndsend"));
        }
        if (objMap.get("testStepDefinitions.practices.practice.list_workflow_send") != null) {
            lstSort.addAll(objMap.get("testStepDefinitions.practices.practice.list_workflow_send"));
        }
        if (objMap.get("testStepDefinitions.practices.practice.list_workflow_undo") != null) {
            lstSort.addAll(objMap.get("testStepDefinitions.practices.practice.list_workflow_undo"));
        }
        if (objMap.get("testStepDefinitions.practices.practice.undo_method") != null) {
            lstSort.addAll(objMap.get("testStepDefinitions.practices.practice.undo_method"));
        }
        if (objMap.get("testStepDefinitions.practices.practice.list_workflow_back") != null) {
            lstSort.addAll(objMap.get("testStepDefinitions.practices.practice.list_workflow_back"));
        }
        if (objMap.get("testStepDefinitions.practices.practice.back_method") != null) {
            lstSort.addAll(objMap.get("testStepDefinitions.practices.practice.back_method"));
        }
        if (objMap.get("testStepDefinitions.practices.practice.load_method") != null) {
            lstSort.addAll(objMap.get("testStepDefinitions.practices.practice.load_method"));
        }
        if (objMap.get("testStepDefinitions.practices.practice.delete_method") != null) {
            lstSort.addAll(objMap.get("testStepDefinitions.practices.practice.delete_method"));
        }
        if (objMap.get("testStepDefinitions.practices.practice.form_delete") != null) {
            lstSort.addAll(objMap.get("testStepDefinitions.practices.practice.form_delete"));
        }
        if (objMap.get("testStepDefinitions.practices.practice.form_query") != null) {
            lstSort.addAll(objMap.get("testStepDefinitions.practices.practice.form_query"));
        }
        if (objMap.get("testStepDefinitions.practices.practice.edit_page_button") != null) {
            lstSort.addAll(objMap.get("testStepDefinitions.practices.practice.edit_page_button"));
        }
        if (objMap.get("testStepDefinitions.practices.practice.list_page_button") != null) {
            lstSort.addAll(objMap.get("testStepDefinitions.practices.practice.list_page_button"));
        }
        
        // 如果之前有生成用例，则获取最大的测试用例编号
        int iCount = getTestCaseCount(lstSort);
        
        for (int i = 0; i < lstSort.size(); i++) {
            TestCase objTestCase = lstSort.get(i);
            int iSort = i + 1;
            String strPattern = "000";
            java.text.DecimalFormat objDFormat = new java.text.DecimalFormat(strPattern);
            if (iCount == 0) {
                objTestCase.setSortNo(objDFormat.format(iSort));
            } else {
                iCount++;
                objTestCase.setSortNo(objDFormat.format(iCount));
            }
            try {
                objTestCase.saveModel();
                versionFacade.updateVersion(objTestCase.getModelId(), objTestCase.getScriptName());
            } catch (ValidateException e) {
                logger.error("测试用例序号设置失败，用例id为:" + objTestCase.getModelId(), e);
            }
        }
    }
    
    /**
     * 获取测试用例数量
     * 
     * @param lstSort 生成的测试用例
     * @return 测试用例数量
     */
    private int getTestCaseCount(List<TestCase> lstSort) {
        int iCount = 0;
        if (lstSort != null && lstSort.size() > 0) {
            try {
                List<TestCase> lstTestCases = CacheOperator.queryList(lstSort.get(0).getModelPackage() + "/testcase",
                    TestCase.class);
                
                if (lstTestCases != null && lstTestCases.size() > 0) {
                    for (TestCase objTestCase : lstTestCases) {
                        int iSortNo = Integer.parseInt(objTestCase.getSortNo());
                        if (iSortNo > iCount) {
                            iCount = iSortNo;
                        }
                    }
                }
            } catch (OperateException e) {
                logger.error("获取模块下的测试用例失败", e);
            }
        }
        return iCount;
    }
    
    /**
     * 分析可忽略的元数据
     *
     * @param metadatas 元数据集合
     * @return 可以忽略元数据模型Id
     */
    private List<String> analyseIgnores(List<? extends BaseModel> metadatas) {
        List<String> ignores = new LinkedList<String>();
        for (BaseModel model : metadatas) {
            if (model instanceof EntityVO) {
                EntityVO entity = (EntityVO) model;
                List<CascadeAttributeVO> cascades = entityFacade.getCascadeAttribute(entity, null, null, 0, null);
                if (cascades == null) {
                    continue;
                }
                for (CascadeAttributeVO cascade : cascades) {
                    ignores.add(cascade.getGenerateCodeType());
                }
            }
        }
        return ignores;
    }
    
    /**
     * 获取用例生成器
     *
     * @param clazz 元数据类型
     * @return 用例生成器
     */
    @SuppressWarnings("rawtypes")
    private TestcaseGenerator getGenerator(Class<?> clazz) {
        if (EntityVO.class.equals(clazz) || EntityVO.class.isAssignableFrom(clazz)) {
            return entityMethodTestcaseGenerator;
        } else if (PageVO.class.equals(clazz) || PageVO.class.isAssignableFrom(clazz)) {
            return functionMethodTestcaseGenerator;
        }
        return null;
    }
}
