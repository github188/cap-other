/******************************************************************************
 * Copyright (C) 2016 ShenZhen ComTop Information Technology Co.,Ltd
 * All Rights Reserved.
 * 本软件为深圳康拓普开发研制。未经本公司正式书面同意，其他任何个人、团体不得使用、
 * 复制、修改或发布本软件.
 *****************************************************************************/

package com.comtop.cap.test.design.practice.function.workflow;

import java.util.HashMap;
import java.util.List;
import java.util.Map;

import com.comtop.cap.bm.metadata.page.desinger.model.LayoutVO;
import com.comtop.cap.bm.metadata.page.desinger.model.PageUITypeEnum;
import com.comtop.cap.bm.metadata.page.desinger.model.PageVO;
import com.comtop.cap.bm.metadata.sysmodel.model.CapPackageVO;
import com.comtop.cap.test.definition.model.DynamicStep;
import com.comtop.cap.test.design.model.InvokeData;
import com.comtop.cap.test.design.practice.function.AbstractFunctionTestcaseGenerater;
import com.comtop.cip.jodd.petite.meta.PetiteBean;
import com.comtop.top.sys.accesscontrol.func.model.FuncDTO;

/**
 * 保存方法测试用例生成
 * 
 * @author zhangzunzhi
 * @since jdk1.6
 * @version 2016年8月2日 zhangzunzhi
 */
@PetiteBean
public class WorkflowEditSaveAndSendTestcaseGenerater extends AbstractFunctionTestcaseGenerater {
    
    /**
     * 封装参数
     *
     * @param objPageVO 页面元数据
     * @param strLayoutId 控件ID
     * @return 参数
     */
    @Override
    public Map<String, Object> wrapperArgs(PageVO objPageVO, String strLayoutId) {
        Map<String, Object> objRetMap = new HashMap<String, Object>();
        // 获取页面路径
        Map<String, Object> objMap = getEditPagePath(objPageVO.getModelPackageId());
        String strKey = PageUITypeEnum.TODO_LIST_PAGE.getPageUIType() + objPageVO.getModelName();
        List<PageVO> lstPageVOPath = (List<PageVO>) objMap.get(strKey);
        PageVO objLstPageVO = null;
        PageVO objLinkPageVO = null;
        if (lstPageVOPath == null) {
            objLinkPageVO = objPageVO;
        } else {
            if (lstPageVOPath.size() > 2) {
                objLstPageVO = lstPageVOPath.get(1);
                objRetMap.put("tab-id", this.getLayoutIdByType(lstPageVOPath.get(0), "Tab"));
                objRetMap.put("tab-index", this.getTabIndex(lstPageVOPath.get(0), lstPageVOPath.get(1)));
            } else {
                objLstPageVO = lstPageVOPath.get(0);
            }
            objLinkPageVO = lstPageVOPath.get(0);
        }
        CapPackageVO objCapPackageVO = this.getAppCodeByPackageId(objLinkPageVO.getModelPackageId());
        objRetMap.put("appName", objCapPackageVO.getModuleName());
        objRetMap.put("locator-home", objCapPackageVO.getModuleName() + "-" + getChineseSystemName());
        objRetMap.put("appCode", objCapPackageVO.getModuleCode());
        FuncDTO objFuncDTO = getFuncDTOById(objLinkPageVO.getPageId());
        if (objFuncDTO == null) {
            logger.error("页面名称为：" + objLinkPageVO.getModelName() + "菜单ID为：" + objLinkPageVO.getPageId() + "没有对应的菜单配置");
            return null;
        }
        objRetMap.put("locator-link", "link=" + objFuncDTO.getFuncName());
        objRetMap.put("locator", "应用");
        objRetMap.put("tableId", this.getLayoutIdByType(objLstPageVO, "Grid"));// list页面元数据的gridId
        objRetMap.put("row", "1");
        objRetMap.put("col", getUpdateColByActionType(objLstPageVO, "editLink"));
        objRetMap.put("locator-editPage", objPageVO.getCname());
        objRetMap.put("editPage", objPageVO.getModelId());
        objRetMap.put("inputOption", "all");
        objRetMap.put("strategy", "dynamic");
        objRetMap.put("locator-saveAndSendBtn", "id=" + this.getActionIdByActionType(objPageVO, "editSaveAndSend"));// 编辑页面元数据的发送按钮ID
        objRetMap.put("send-text", "操作成功！");// TODO
        // EGrid组件数据录入处理
        List<LayoutVO> lstLayoutVO = this.getLayoutVOByType(objPageVO, "EditableGrid");
        objRetMap.put("EGridSize", lstLayoutVO.size());
        for (int i = 0, len = lstLayoutVO.size(); i < len; i++) {
            Map<String, Object> objEdit = new HashMap<String, Object>();
            String strEgridId = lstLayoutVO.get(i).getId();
            String strEgridDelId = this.getEGridActionId(objPageVO, "deleteGrid", strEgridId);
            String strEgridInsertId = this.getEGridActionId(objPageVO, "insertGrid", strEgridId);
            String strEditPageGrid = objPageVO.getModelId().concat(";").concat(strEgridId);
            objEdit.put("egrid-tableId", strEgridId);
            objEdit.put("rIndexes", "0");
            objEdit.put("locator-btnDeleteOnEGrid", "id=" + strEgridDelId);
            objEdit.put("locator-btnAddOnEGird", "id=" + strEgridInsertId);
            objEdit.put("editPageGrid", strEditPageGrid);
            objEdit.put("editPageStrategy", "dynamic");
            objRetMap.put("EGrid" + i, objEdit);
        }
        return objRetMap;
    }
    
    @Override
    public DynamicStep getDynamicStep(String strType, Map<String, Object> args) {
        if (strType.contains("grid")) {
            InvokeData objInvokeData = new InvokeData();
            objInvokeData.setModelId(strType);
            Map<String, String> objArgs = new HashMap<String, String>();
            objArgs.put("editPageGrid", (String) args.get("editPageGrid"));
            objArgs.put("strategy", (String) args.get("editPageStrategy"));
            objInvokeData.setDatas(objArgs);
            return invokeFacade.invoke(objInvokeData);
        }
        InvokeData objInvokeData = new InvokeData();
        objInvokeData.setModelId(strType);
        Map<String, String> objArgs = new HashMap<String, String>();
        objArgs.put("editPage", (String) args.get("editPage"));
        objArgs.put("inputOption", (String) args.get("inputOption"));
        objArgs.put("strategy", (String) args.get("strategy"));
        objInvokeData.setDatas(objArgs);
        return invokeFacade.invoke(objInvokeData);
    }
    
}
