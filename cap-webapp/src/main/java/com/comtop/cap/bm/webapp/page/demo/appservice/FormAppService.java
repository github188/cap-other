/******************************************************************************
 * Copyright (C) 2015 ShenZhen ComTop Information Technology Co.,Ltd
 * All Rights Reserved.
 * 本软件为深圳康拓普开发研制。未经本公司正式书面同意，其他任何个人、团体不得使用、
 * 复制、修改或发布本软件.
 *****************************************************************************/

package com.comtop.cap.bm.webapp.page.demo.appservice;

import java.util.ArrayList;
import java.util.Date;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import com.comtop.cap.bm.webapp.page.demo.model.FormGrid1VO;
import com.comtop.cap.bm.webapp.page.demo.model.FormGrid2VO;
import com.comtop.cap.bm.webapp.page.demo.model.FormVO;
import com.comtop.cap.runtime.base.appservice.CapWorkflowAppService;
import com.comtop.cap.runtime.base.model.CapWorkflowParam;
import com.comtop.cip.jodd.petite.meta.PetiteBean;

/**
 * FIXME 类注释信息(此标记由Eclipse自动生成,请填写注释信息删除此标记)
 * 
 * 
 * @author 作者
 * @since 1.0
 * @version 2015-6-10 作者
 */
@PetiteBean
public class FormAppService extends CapWorkflowAppService<FormVO> {
    
    @Override
    public String getProcessId() {
        // TODO 自动生成方法存根注释，方法实现时请删除此注释
        return "lzm_test_0701";
    }
    
    @Override
    public String getDataName() {
        // TODO 自动生成方法存根注释，方法实现时请删除此注释
        return "form";
    }
    
    /**
     * @param id xx
     * @return xx
     */
    protected FormVO queryById(String id) {
        FormVO objFormVO = new FormVO();
        /*
         * data={
         * code:'aaa',
         * workPlanId:'111',
         * applyDate:'2015-05-28',
         * outageReasonType:1,
         * overhaulType:1,
         * isNeedInside:2,
         * longTimeOutageReason:2,
         * notTurnpowerReason:[1,2],
         * notInMonplanReason:'fsdfsdfsdfs',
         * planPeopleId:'00092CAA1982408DB62F01F4A6C98A27',
         * planPeopleName:'薛武',
         * planDepartmentId:"F50FF5BBD7E145D99C8FD9E06B33067B",
         * planDepartmentName:"行政部",
         * outageDeviceTableList:editGridData,
         * requeryTableList:editGridData2
         * };
         */
        objFormVO.setCode("aaa111");
        objFormVO.setWorkPlanId("111");
        objFormVO.setApplyDate(new Date());
        objFormVO.setOutageReasonType(1);
        objFormVO.setOverhaulType(1);
        objFormVO.setIsNeedInside(2);
        objFormVO.setLongTimeOutageReason(2);
        objFormVO.setNotTurnpowerReason(new Integer[] { 1, 2 });
        objFormVO.setNotInMonplanReason("fsdfsdfsdfs");
        objFormVO.setPlanPeopleId("00092CAA1982408DB62F01F4A6C98A27");
        objFormVO.setPlanPeopleName("薛武");
        objFormVO.setPlanDepartmentId("F50FF5BBD7E145D99C8FD9E06B33067B");
        objFormVO.setPlanDepartmentName("行政部");
        
        /*
         * var editGridData =[{
         * "id": "0",
         * "depertment" : "技术研究中心",
         * "substation": "景田站",
         * "line": "甲线",
         * "device": "变电站"
         * },{
         * "id": "1",
         * "depertment" : "技术研究中心",
         * "substation": "景田站",
         * "line": "甲线",
         * "device": "变电站"
         * }];
         */
        
        List lstEditGridVO1 = new ArrayList();
        
        FormGrid1VO obEditGridVO1 = new FormGrid1VO();
        obEditGridVO1.setId("0");
        obEditGridVO1.setDepertment("技术研究中心");
        obEditGridVO1.setSubstation("景田站");
        obEditGridVO1.setLine("甲线");
        obEditGridVO1.setDevice("变电站");
        lstEditGridVO1.add(obEditGridVO1);
        
        FormGrid1VO obEditGridVO2 = new FormGrid1VO();
        obEditGridVO2.setId("1");
        obEditGridVO2.setDepertment("技术研究中心");
        obEditGridVO2.setSubstation("景田站");
        obEditGridVO2.setLine("甲线");
        obEditGridVO2.setDevice("变电站");
        lstEditGridVO1.add(obEditGridVO2);
        
        /*
         * var editGridData2 =[{
         * "id": "0",
         * "requery" : "技术研究中心",
         * },{
         * "id": "1",
         * "requery" : "技术研究中心",
         * }];
         */
        List lstEditGridVO2 = new ArrayList();
        FormGrid2VO obEditGridVO3 = new FormGrid2VO();
        obEditGridVO3.setId("0");
        obEditGridVO3.setRequery("技术研究中心");
        lstEditGridVO2.add(obEditGridVO3);
        
        FormGrid2VO obEditGridVO4 = new FormGrid2VO();
        obEditGridVO4.setId("1");
        obEditGridVO4.setRequery("技术研究中心");
        lstEditGridVO2.add(obEditGridVO4);
        
        objFormVO.setOutageDeviceTableList(lstEditGridVO1);
        objFormVO.setRequeryTableList(lstEditGridVO2);
        return objFormVO;
    }
    
    /**
     * 获取工作流所需的参数集合,用于条件判断
     * 
     * @param workflowVO 工单对象
     * @return 工作流所需的参数集合
     */
    @Override
    public Map<String, Object> getParamMap(FormVO workflowVO) {
        Map<String, Object> objMap = new HashMap<String, Object>();
        objMap.put("code", workflowVO.getCode());
        return objMap;
    }
    
    /**
     * @param workflowVO xx
     * @param workflowParam xx
     */
    public void entryCallback(FormVO workflowVO, CapWorkflowParam workflowParam) {
        // TODO 自动生成方法存根注释，方法实现时请删除此注释
        System.out.println("FormAppService.entryCallback");
        // super.entryCallback(workflowVO, workflowParam);
    }
}
