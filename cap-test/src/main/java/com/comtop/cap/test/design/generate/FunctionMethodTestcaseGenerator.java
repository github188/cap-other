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

import com.comtop.cap.bm.metadata.page.desinger.model.LayoutVO;
import com.comtop.cap.bm.metadata.page.desinger.model.PageActionVO;
import com.comtop.cap.bm.metadata.page.desinger.model.PageUITypeEnum;
import com.comtop.cap.bm.metadata.page.desinger.model.PageVO;
import com.comtop.cap.bm.metadata.page.external.PageMetadataProvider;
import com.comtop.cap.test.definition.facade.PracticeFacade;
import com.comtop.cap.test.definition.model.Practice;
import com.comtop.cap.test.definition.model.PracticeType;
import com.comtop.cap.test.design.facade.InvokeFacade;
import com.comtop.cap.test.design.facade.VersionFacade;
import com.comtop.cap.test.design.model.InvokeData;
import com.comtop.cap.test.design.model.TestCase;
import com.comtop.cip.jodd.petite.meta.PetiteBean;
import com.comtop.cip.jodd.petite.meta.PetiteInject;
import com.comtop.cip.jodd.util.StringUtil;
import comtop.soa.org.apache.cxf.common.util.StringUtils;

/**
 * 界面行为测试用例生成器
 *
 * @author zhangzunzhi
 * @since jdk1.6
 * @version 2016年7月18日 zhangzunzhi
 */
@PetiteBean
public class FunctionMethodTestcaseGenerator implements TestcaseGenerator<PageVO> {
    
    /** 日志 */
    private final static Logger logger = LoggerFactory.getLogger(FunctionMethodTestcaseGenerator.class);
    
    /** 执行器 */
    @PetiteInject
    protected InvokeFacade invokeFacade;
    
    /** 版本管理接口 */
    @PetiteInject
    protected VersionFacade versionFacade;
    
    /** 版本管理接口 */
    @PetiteInject
    protected PracticeFacade practiceFacade;
    
    /** 页面元数据提供的相关接口Facade */
    @PetiteInject
    protected PageMetadataProvider pageMetadataProvider;
    
    /**
     * 
     * @see com.comtop.cap.test.design.generate.TestcaseGenerator#gen(com.comtop.cap.bm.metadata.base.model.BaseMetadata)
     */
    @Override
    public List<TestCase> gen(PageVO metadata) {
        Map<String, List<Practice>> practiceMap = practiceFacade.loadPracticeByType(PracticeType.FUNCTION);
        if (practiceMap == null || practiceMap.values() == null) {
            return null;
        }
        List<TestCase> result = new LinkedList<TestCase>();
        TestCase testcase = null;
        // 根据界面元数据确定的行为类型和最佳实践来生成测试用例
        for (List<Practice> practices : practiceMap.values()) {
            for (Practice practice : practices) {
                List<InvokeData> lstInvokeData = getInvokeDataByMetadata(metadata, practice);
                if (lstInvokeData == null || lstInvokeData.size() == 0) {
                    continue;
                }
                for (InvokeData objInvokeData : lstInvokeData) {
                    testcase = genTestcase(objInvokeData);
                    if (testcase != null) {
                        result.add(testcase);
                    }
                }
                
            }
        }
        return result;
    }
    
    /**
     * 
     * @param metadata 页面元数据
     * @param practice 最佳实践
     * @return 测试用例的执行数据对象
     */
    private List<InvokeData> getInvokeDataByMetadata(PageVO metadata, Practice practice) {
        List<InvokeData> lstRet = new ArrayList<InvokeData>();
        String strModelId = metadata.getModelId();
        String strPracticeId = practice.getModelId();
        String strPracticeType = practice.getMapping();
        List<PageActionVO> lstPageActionVO = metadata.getPageActionVOList();
        // 循环页面元数据所有行为
        for (PageActionVO objPageActionVO : lstPageActionVO) {
            String strActionType = (String) objPageActionVO.getMethodOption().get("actionType");
            // 正常情况，配置有行为类型，并且和最佳实践的类型相同的情况
            if (StringUtil.isNotBlank(strActionType) && strPracticeType.equals(strActionType)) {
                String strPageActionId = strModelId.concat(":").concat(objPageActionVO.getPageActionId()).concat(":")
                    .concat(strActionType);
                InvokeData objInvokeData = new InvokeData();
                objInvokeData.setModelId(strPracticeId);
                Map<String, String> objInvokeDataArg = new HashMap<String, String>();
                objInvokeDataArg.put("pageActionId", strPageActionId);
                objInvokeData.setDatas(objInvokeDataArg);
                lstRet.add(objInvokeData);
            } else if (StringUtil.isEmpty(strActionType)) {// 行为没有配置行为类型，但是被页面按钮绑定的情况，也生成按钮最佳实践
                String strActionId = objPageActionVO.getPageActionId();
                List<LayoutVO> lstButtonLayoutVO = getPageButtonByActionId(metadata, strActionId);
                if (lstButtonLayoutVO == null || lstButtonLayoutVO.size() == 0) {
                    continue;
                }
                for (LayoutVO objLayoutVO : lstButtonLayoutVO) {
                    String strButtonEname = (String) objLayoutVO.getOptions().get("on_click");
                    String strButtonCname = (String) objLayoutVO.getOptions().get("label");
                    String strLoyoutId = (String) objLayoutVO.getOptions().get("id");
                    if (StringUtils.isEmpty(strLoyoutId)) {
                        strLoyoutId = objLayoutVO.getId();
                    }
                    String strPraticeId = this.getPracticeModelId(metadata, practice);
                    if (StringUtil.isEmpty(strPraticeId)) {
                        continue;
                    }
                    InvokeData data = new InvokeData();
                    // 根据列表还是编辑页面设置最佳实践的ID
                    data.setModelId(strPraticeId);
                    Map<String, String> datas = new HashMap<String, String>();
                    String pageActionId = strModelId.concat(":").concat(strActionId).concat(":").concat(strButtonEname);
                    datas.put("pageActionId", pageActionId);
                    datas.put("buttonEname", strButtonEname);
                    datas.put("buttonCname", strButtonCname);
                    datas.put("layoutId", strLoyoutId);
                    data.setDatas(datas);
                    lstRet.add(data);
                }
            }
        }
        return lstRet;
    }
    
    /**
     * 根据页面元数据和行为ID获取绑定该行为的页面按钮集合
     * 
     * @param metadata 页面元数据
     * @param strActionId 行为ID
     * @return 按钮控件集合
     */
    private List<LayoutVO> getPageButtonByActionId(PageVO metadata, String strActionId) {
        List<String> lstUiType = new ArrayList<String>();
        lstUiType.add("Button");
        Map<String, Object> objPageLayoutVO = pageMetadataProvider.queryCmpsByUItypes(metadata.getModelId(), lstUiType);// 根据控件类型获取控件对象
        List<LayoutVO> lstLayoutVO = (List<LayoutVO>) objPageLayoutVO.get("dataList");
        if (lstLayoutVO == null) {
            return null;
        }
        List<LayoutVO> lstButtonLayout = new ArrayList<LayoutVO>();
        for (LayoutVO objLayoutVO : lstLayoutVO) {
            String strLayoutActionId = (String) objLayoutVO.getOptions().get("on_click_id");
            if (StringUtil.isNotBlank(strActionId) && strLayoutActionId.equals(strActionId)) {
                lstButtonLayout.add(objLayoutVO);
            }
        }
        return lstButtonLayout;
    }
    
    /**
     * 根据页面类型获取最佳实践modelId
     * 
     * @param metadata 页面元数据
     * @param practice 最佳实践
     * @return 最佳实践ID
     */
    private String getPracticeModelId(PageVO metadata, Practice practice) {
        String strPracticeType = practice.getMapping();
        if (isEditPage(metadata) && strPracticeType.equals("editPageButton")) {
            return practice.getModelId();
        } else if (isListPage(metadata) && strPracticeType.equals("listPageButton")) {
            return practice.getModelId();
        }
        return null;
    }
    
    /**
     * 是否是列表页面
     * 
     * @param objPageVO 页面元数据
     * @return true
     */
    private boolean isListPage(PageVO objPageVO) {
        if (PageUITypeEnum.LIST_PAGE.getPageUIType().equals(objPageVO.getPageUIType())
            || PageUITypeEnum.TO_ENTRY_LIST_PAGE.getPageUIType().equals(objPageVO.getPageUIType())
            || PageUITypeEnum.ENTRYED_LIST_PAGE.getPageUIType().equals(objPageVO.getPageUIType())
            || PageUITypeEnum.TODO_LIST_PAGE.getPageUIType().equals(objPageVO.getPageUIType())
            || PageUITypeEnum.DONE_LIST_PAGE.getPageUIType().equals(objPageVO.getPageUIType())) {
            return true;
        }
        return false;
    }
    
    /**
     * 是否是编辑页面
     * 
     * @param objPageVO 页面元数据
     * @return true
     */
    private boolean isEditPage(PageVO objPageVO) {
        if (PageUITypeEnum.EIDT_PAGE.getPageUIType().equals(objPageVO.getPageUIType())
            || PageUITypeEnum.VIEW_PAGE.getPageUIType().equals(objPageVO.getPageUIType())) {
            return true;
        }
        return false;
    }
    
    /**
     * 生成测试用例
     *
     * @param data 最佳实践Id
     * @return 测试用例
     */
    private TestCase genTestcase(InvokeData data) {
        
        TestCase testcase = null;
        try {
            testcase = invokeFacade.practiceImpl(data);
            if (testcase != null) {
               // testcase.saveModel();
                // 更新版本信息
                versionFacade.updateVersion(testcase.getModelId(), testcase.getScriptName());
            }
        } catch (Exception e) {
            logger.error("根据最佳实践【{}】生成用例出错。", data.getModelId(), e);
        }
        return testcase;
    }
    
}
