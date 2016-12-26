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

import com.comtop.cap.bm.metadata.page.desinger.model.PageUITypeEnum;
import com.comtop.cap.bm.metadata.page.desinger.model.PageVO;
import com.comtop.cap.bm.metadata.sysmodel.model.CapPackageVO;
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
public class WorkflowEditSendTestcaseGenerater extends AbstractFunctionTestcaseGenerater {
    
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
        objRetMap.put("locator-sendBtn", "id=" + this.getActionIdByActionType(objPageVO, "editSend"));// 编辑页面元数据的发送按钮ID
        objRetMap.put("send-text", "操作成功！");// TODO
        return objRetMap;
    }
    
}
