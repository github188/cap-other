
package com.comtop.cap.test.design.practice.function.workflow;

import java.util.HashMap;
import java.util.Map;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;

import com.comtop.cap.bm.metadata.common.storage.exception.OperateException;
import com.comtop.cap.bm.metadata.page.desinger.model.PageVO;
import com.comtop.cap.bm.metadata.page.external.PageMetadataProvider;
import com.comtop.cap.test.definition.facade.PracticeFacade;
import com.comtop.cap.test.definition.model.Practice;
import com.comtop.cap.test.design.facade.TestCaseFacade;
import com.comtop.cap.test.design.model.TestCase;
import com.comtop.cap.test.design.model.TestCaseType;
import com.comtop.cap.test.design.practice.PracticeImpl;
import com.comtop.cap.test.design.practice.function.FunctionTestcaseGenerater;
import com.comtop.cip.jodd.petite.meta.PetiteBean;
import com.comtop.cip.jodd.petite.meta.PetiteInject;

/**
 * 工作流最佳实践实现
 * 
 * @author zhangzunzhi
 * @since jdk1.6
 * @version 2016年7月19日 zhangzunzhi
 */
@PetiteBean
public class WorkflowPracticeImpl implements PracticeImpl {
    
    /** 日志 */
    private final static Logger logger = LoggerFactory.getLogger(WorkflowPracticeImpl.class);
    
    /** 最佳实践Facade */
    @PetiteInject
    protected PracticeFacade practiceFacade;
    
    /** 页面元数据提供的相关接口Facade */
    @PetiteInject
    protected PageMetadataProvider pageMetadataProvider;
    
    /** TestCaseFacade */
    @PetiteInject
    protected TestCaseFacade testCaseFacade;
    
    /** Facade */
    @PetiteInject
    protected WorkflowEditReportTestcaseGenerater workflowEditReportTestcaseGenerater;
    
    /** Facade */
    @PetiteInject
    protected WorkflowEditSendTestcaseGenerater workflowEditSendTestcaseGenerater;
    
    /** Facade */
    @PetiteInject
    protected WorkflowEditSaveAndReportTestcaseGenerater workflowEditSaveAndReportTestcaseGenerater;
    
    /** Facade */
    @PetiteInject
    protected WorkflowEditSaveAndSendTestcaseGenerater workflowEditSaveAndSendTestcaseGenerater;
    
    /** Facade */
    @PetiteInject
    protected WorkflowReportTestcaseGenerater workflowReportTestcaseGenerater;
    
    /** Facade */
    @PetiteInject
    protected WorkflowSendTestcaseGenerater workflowSendTestcaseGenerater;
    
    /** Facade */
    @PetiteInject
    protected WorkflowBackTestcaseGenerater workflowBackTestcaseGenerater;
    
    /** Facade */
    @PetiteInject
    protected WorkflowUndoTestcaseGenerater workflowUndoTestcaseGenerater;
    
    /** 行为类型 */
    private static final Map<String, String> actionTypedMap = new HashMap<String, String>();
    
    static {
        actionTypedMap.put("editReport", "上报");
        actionTypedMap.put("editSend", "发送");
        actionTypedMap.put("editSaveAndReport", "保存并上报");
        actionTypedMap.put("editSaveAndSend", "保存并发送");
        actionTypedMap.put("report", "上报");
        actionTypedMap.put("send", "发送");
        actionTypedMap.put("back", "回退");
        actionTypedMap.put("undo", "撤回");
    }
    
    @Override
    public TestCase impl(String practiceId, TestCase testcase, Map<String, String> args) {
        Practice practice = practiceFacade.loadPracticeById(practiceId);
        if (practice == null) {
            return null;
        }
        String strMapping = practice.getMapping();// 确定是工作流的操作类型
        // 行为选择时候，传递三个参数，一个modelId页面元数据ID，一个页面actionId，一个为行为类型,结构为modelId:actionId:actionType
        String strActionId = args.get("pageActionId");
        String[] strActionIds = strActionId.split(":");
        if (!strMapping.equals(strActionIds[2])) {
            return null;
        }
        // 编辑页面元数据定义操作有上报，发送，保存上报，保存发送
        // 列表页面元数据定义操作有上报
        // 待办页面元数据定义操作有发送，回退
        // 已办页面元数据定义操作有撤回
        // 列表页面元数据对象,新增，更新，删除的行为类型都定义在此页面
        PageVO objPageVO = null;
        try {
            objPageVO = pageMetadataProvider.getPageByModelId(strActionIds[0]);
        } catch (OperateException exception) {
            logger.error("根据页面元数据ID获取页面元数据出错", exception);
        }
        if (objPageVO == null) {
            return null;
        }
        TestCase objTestCase = testcase;
        if (objTestCase == null) {
            objTestCase = new TestCase();
            objTestCase.setName(actionTypedMap.get(strMapping) + "_" + objPageVO.getCname());
            objTestCase.setModelPackage(objPageVO.getModelPackage());
            objTestCase.setModelName(strMapping.substring(0, 1).toUpperCase() + strMapping.substring(1) + "_"
                + objPageVO.getModelName());
            objTestCase.setMetadata(strActionId);
            objTestCase.setPractice(practiceId);
            objTestCase.setType(TestCaseType.FUNCTION);// 根据实践类型填充
        }
        String strModelId = objTestCase.getModelId();
        TestCase objExitTestCase = testCaseFacade.loadTestCaseById(strModelId);
        if (objExitTestCase != null) {
            return null;
        }
        FunctionTestcaseGenerater generater = this.getGenerater(strMapping);
        if (generater != null) {
            generater.genTestcase(practice, objTestCase, objPageVO, "");
        }
        
        return objTestCase;
    }
    
    /**
     * 获取用例生成器
     *
     * @param strActionType 行为类型
     * @return 用例生成器
     */
    private FunctionTestcaseGenerater getGenerater(String strActionType) {
        if ("editReport".equals(strActionType)) {
            return workflowEditReportTestcaseGenerater;
        } else if ("editSend".equals(strActionType)) {
            return workflowEditSendTestcaseGenerater;
        } else if ("editSaveAndReport".equals(strActionType)) {
            return workflowEditSaveAndReportTestcaseGenerater;
        } else if ("editSaveAndSend".equals(strActionType)) {
            return workflowEditSaveAndSendTestcaseGenerater;
        } else if ("report".equals(strActionType)) {
            return workflowReportTestcaseGenerater;
        } else if ("send".equals(strActionType)) {
            return workflowSendTestcaseGenerater;
        } else if ("back".equals(strActionType)) {
            return workflowBackTestcaseGenerater;
        } else if ("undo".equals(strActionType)) {
            return workflowUndoTestcaseGenerater;
        }
        return null;
    }
    
}
