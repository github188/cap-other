/******************************************************************************
 * Copyright (C) 2016 ShenZhen ComTop Information Technology Co.,Ltd
 * All Rights Reserved.
 * 本软件为深圳康拓普开发研制。未经本公司正式书面同意，其他任何个人、团体不得使用、
 * 复制、修改或发布本软件.
 *****************************************************************************/

package com.comtop.cap.test.design.practice.function.form;

import java.util.HashMap;
import java.util.Map;

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
public class FormQueryTestcaseGenerater extends AbstractFunctionTestcaseGenerater {
    
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
        // 获取当前list页面上面有没有tab页面
        PageVO objTabPageVO = getTabPageVO(objPageVO);
        if (objTabPageVO != null) {
            objRetMap.put("tab-id", this.getLayoutIdByType(objTabPageVO, "Tab"));
            objRetMap.put("tab-index", this.getTabIndex(objTabPageVO, objPageVO));
        } else {
            objTabPageVO = objPageVO;
        }
        CapPackageVO objCapPackageVO = this.getAppCodeByPackageId(objTabPageVO.getModelPackageId());
        objRetMap.put("appName", objCapPackageVO.getModuleName());
        objRetMap.put("locator-home", objCapPackageVO.getModuleName() + "-" + getChineseSystemName());
        FuncDTO objFuncDTO = getFuncDTOById(objTabPageVO.getPageId());
        if (objFuncDTO == null) {
            logger.error("页面名称为：" + objTabPageVO.getModelName() + "菜单ID为：" + objTabPageVO.getPageId() + "没有对应的菜单配置");
            return null;
        }
        objRetMap.put("locator-link", "link=" + objFuncDTO.getFuncName());
        objRetMap.put("appCode", objCapPackageVO.getModuleCode());
        objRetMap.put("locator", "应用");
        objRetMap.put("listPage", objPageVO.getModelId());
        objRetMap.put("listPage-strategy", "dynamic");
        objRetMap.put("locator-queryBtn", "id=" + getActionIdByActionType(objPageVO, "query"));
        objRetMap.put("locator-cleanQueryBtn", "id=" + getActionIdByActionType(objPageVO, "clearQuery"));
        return objRetMap;
    }
    
    @Override
    public DynamicStep getDynamicStep(String strType, Map<String, Object> args) {
        InvokeData objInvokeData = new InvokeData();
        objInvokeData.setModelId(strType);
        Map<String, String> objArgs = new HashMap<String, String>();
        objArgs.put("listPage", (String) args.get("listPage"));
        objArgs.put("strategy", (String) args.get("strategy"));
        objInvokeData.setDatas(objArgs);
        return invokeFacade.invoke(objInvokeData);
    }
    
}
