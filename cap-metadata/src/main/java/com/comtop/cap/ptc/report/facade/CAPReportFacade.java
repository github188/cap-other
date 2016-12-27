/******************************************************************************
 * Copyright (C) 2015 ShenZhen ComTop Information Technology Co.,Ltd
 * All Rights Reserved.
 * 本软件为深圳康拓普开发研制。未经本公司正式书面同意，其他任何个人、团体不得使用、
 * 复制、修改或发布本软件.
 *****************************************************************************/

package com.comtop.cap.ptc.report.facade;

import java.util.ArrayList;
import java.util.Calendar;
import java.util.Collections;
import java.util.Comparator;
import java.util.Date;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import com.comtop.cap.bm.metadata.CapMetaDataConstant;
import com.comtop.cap.bm.metadata.CapMetaDataUtil;
import com.comtop.cap.ptc.report.model.CAPReportVO;
import com.comtop.cap.ptc.report.model.ReportCondition;
import com.comtop.cap.ptc.report.utils.CAPReportConstant;
import com.comtop.cap.ptc.report.utils.ReportDateUtil;
import com.comtop.cap.ptc.report.utils.ReportDateUtil.RangeDate;
import com.comtop.cap.runtime.base.appservice.CapWorkflowCoreService;
import com.comtop.cip.jodd.petite.meta.PetiteBean;
import com.comtop.cip.jodd.petite.meta.PetiteInject;
import com.comtop.top.core.jodd.AppContext;
import com.comtop.top.sys.module.facade.IModuleFacade;
import com.comtop.top.sys.module.facade.ModuleFacade;
import com.comtop.top.sys.module.model.ModuleDTO;

/**
 * 
 * CAP统计报表Facade实现类
 * 
 * @author 杨赛
 * @since jdk1.6
 * @version 2015年9月21日
 */
@PetiteBean("CAPReportFacade")
public class CAPReportFacade implements ICAPReportFacade {
    
    
    /** 注入BpmsService */
    @PetiteInject
    protected CapWorkflowCoreService workflowCoreService;
    
    /** TOP系统模块 Facade */
    private final IModuleFacade moduleFacade = AppContext.getBean(ModuleFacade.class);
    
    /** 统计工作流时 不同版本流程是否计算版本，true：需要计算，false：不计算 */
    private final boolean COUNT_DIFVER = false;
    
    @Override
    public CAPReportVO querySystemIntegralityReportVO() {
        CAPReportVO objReportVO = new CAPReportVO();
        objReportVO.setEntityCount(CapMetaDataUtil.queryAllMetaDataCount(CapMetaDataConstant.META_DATA_TYPE_ENTITY));
        objReportVO.setFlowCount(workflowCoreService.queryDeployeProcessCount());
        objReportVO.setPageCount(CapMetaDataUtil.queryAllMetaDataCount(CapMetaDataConstant.META_DATA_TYPE_PAGE));
//        objReportVO.setServiceCount(CapMetaDataUtil.queryAllMetaDataCount(CapMetaDataConstant.META_DATA_TYPE_SERIVE));
        //TODO
        objReportVO.setServiceCount(0);
        objReportVO.setModuleCount(queryAllActiveModuleByType().size());
        return objReportVO;
    }
    
    @Override
    public List<CAPReportVO> queryPhasedReportVO(ReportCondition reportCondition) {
        if (reportCondition == null || reportCondition.getStartTime() == null || reportCondition.getEndTime() == null) {
            return new ArrayList<CAPReportVO>(0);
        }
        List<RangeDate> lstRangeDate = null;
        if (CAPReportConstant.QUERY_TYPE_WEEK.equals(reportCondition.getQueryType())) {
            lstRangeDate = ReportDateUtil
                .getWeekRangeDate(reportCondition.getStartTime(), reportCondition.getEndTime());
        } else if (CAPReportConstant.QUERY_TYPE_MONTH.equals(reportCondition.getQueryType())) {
            lstRangeDate = ReportDateUtil.getMonthRangeDate(reportCondition.getStartTime(),
                reportCondition.getEndTime());
        } else if (CAPReportConstant.QUERY_TYPE_QUARTER.equals(reportCondition.getQueryType())) {
            lstRangeDate = ReportDateUtil.getQuarterRangeDate(reportCondition.getStartTime(),
                reportCondition.getEndTime());
        }
        if (lstRangeDate == null || lstRangeDate.isEmpty()) {
            return new ArrayList<CAPReportVO>(0);
        }
        Map<String, CAPReportVO> objReportVOMap = new HashMap<String, CAPReportVO>(lstRangeDate.size());
        List<CAPReportVO> lstReportVO = new ArrayList<CAPReportVO>(lstRangeDate.size());
        Date startTime = reportCondition.getStartTime();
        for (RangeDate objRangeDate : lstRangeDate) {
        	
            // 查询flow
            int flowCount = workflowCoreService.queryDeployeProcessCount(reportCondition.getCreaterId(), startTime, objRangeDate.getEndTime().getTime(), COUNT_DIFVER, reportCondition
                .getCreaterId());
            // 需要查询当天的 所以需要加上1天时间
            objRangeDate.getEndTime().add(Calendar.DATE, 1);
            // 查询页面
            int pageCount = CapMetaDataUtil.queryMetaDataCountByCreate(startTime.getTime(),
                objRangeDate.getEndTime().getTimeInMillis(), reportCondition.getCreaterId(),
                CapMetaDataConstant.META_DATA_TYPE_PAGE);
            // 查询entity
            int entityCount = CapMetaDataUtil.queryMetaDataCountByCreate(startTime.getTime(),
                objRangeDate.getEndTime().getTimeInMillis(), reportCondition.getCreaterId(),
                CapMetaDataConstant.META_DATA_TYPE_ENTITY);
            // 查询service
            int servierCount = CapMetaDataUtil.queryMetaDataCountByCreate(
            		startTime.getTime(), objRangeDate.getEndTime().getTimeInMillis(),
                reportCondition.getCreaterId(), CapMetaDataConstant.META_DATA_TYPE_SERIVE);
            
            CAPReportVO objReportVO = createReportVO(pageCount, flowCount, objRangeDate.getRangeName());
            objReportVO.setEntityCount(entityCount);
            objReportVO.setServiceCount(servierCount);
            objReportVOMap.put(objRangeDate.getRangeName(), objReportVO);
            lstReportVO.add(objReportVO);
            
        }
        return lstReportVO;
    }
    
    @Override
    public List<CAPReportVO> queryModuleReportVO(ReportCondition reportCondition) {
        // 查询所有的模块
        List<ModuleDTO> lstModule = queryAllActiveModuleByType();
        Map<String, CAPReportVO> objReportVOMap = new HashMap<String, CAPReportVO>(lstModule.size());
        List<CAPReportVO> lstReportVO = new ArrayList<CAPReportVO>(lstModule.size());
        for (ModuleDTO moduleDto : lstModule) {
            // 查询页面
            int pageCount = CapMetaDataUtil.queryMetaDataCountByPackageId(moduleDto.getModuleId(),
                CapMetaDataConstant.META_DATA_TYPE_PAGE);
            // 查询entity
            int entityCount = CapMetaDataUtil.queryMetaDataCountByPackageId(moduleDto.getModuleId(),
                CapMetaDataConstant.META_DATA_TYPE_ENTITY);
            // 查询service
//            int servierCount = CapMetaDataUtil.queryMetaDataCountByPackageId(moduleDto.getModuleId(),
//                CapMetaDataConstant.META_DATA_TYPE_SERIVE);
            // int flowCount = workflowCoreService.queryDeployeProcessCount(moduleDto.getModuleCode(), null, null,
            // COUNT_DIFVER);
            CAPReportVO objReportVO = createReportVO(pageCount, 0, moduleDto.getModuleName());
            objReportVO.setEntityCount(entityCount);
//            objReportVO.setServiceCount(servierCount);
            objReportVOMap.put(moduleDto.getModuleCode(), objReportVO);
            lstReportVO.add(objReportVO);
        }
        // 查询enity
        // Map<String, Integer> mapEntityCount = entityFacade.queryEntityModuleNumForReport();
        // for(Map.Entry<String, Integer> entry: mapEntityCount.entrySet()) {
        // if(objReportVOMap.containsKey(entry.getKey())) {
        // objReportVOMap.get(entry.getKey()).setEntityCount(entry.getValue());
        // }
        // }
        
//         查询service
		// TODO 查询服务个数采用新版查询
		// Map<String, Integer> mapServiceCount =
		// serviceObjectFacade.queryServiceObjectModuleNumForReport();
		// for(Map.Entry<String, Integer> entry: mapServiceCount.entrySet()) {
		// if(objReportVOMap.containsKey(entry.getKey())) {
		// objReportVOMap.get(entry.getKey()).setServiceCount(entry.getValue());
		// }
		// }
        
        // 查询flow
        Map<String, Integer> mapObject = workflowCoreService.queryDeployeProcessMap();
        for (Map.Entry<String, Integer> entry : mapObject.entrySet()) {
            if (objReportVOMap.containsKey(entry.getKey())) {
                objReportVOMap.get(entry.getKey()).setFlowCount(entry.getValue());
            } else {
                // System.out.println("flow: can not find module code " + entry.getKey() + " in objReportVOHashMap");
            }
        }
        
        Collections.sort(lstReportVO, new Comparator<CAPReportVO>() {
            
            @Override
            public int compare(CAPReportVO o1, CAPReportVO o2) {
                return (o2.getEntityCount() + o2.getPageCount() + o2.getFlowCount() + o2.getServiceCount())
                    - (o1.getEntityCount() + o1.getPageCount() + o1.getFlowCount() + o1.getServiceCount());
            }
        });
        // 返回前10个
        return lstReportVO.size() > 10 ? lstReportVO.subList(0, 10) : lstReportVO;
    }
    
    /***
     * 查询当前系统中所有有效的模块数据(根据模块类型进行查询)，李小强新增 2015-09-29
     * 
     * @return 有效的模块数据
     */
    private List<ModuleDTO> queryAllActiveModuleByType() {
        return moduleFacade.queryAllActiveModuleByType("2");
    }
    
    /**
     * 根据给定的参数创建新的reportVO
     * 
     * @param pageCount 页面数
     * @param flowCount 流程数
     * @param axisName 报表轴名称
     * @return new reportVO
     */
    private CAPReportVO createReportVO(int pageCount, int flowCount, String axisName) {
        CAPReportVO objReportVO = new CAPReportVO();
        objReportVO.setFlowCount(flowCount);
        objReportVO.setPageCount(pageCount);
        objReportVO.setAxisName(axisName);
        return objReportVO;
    }
}
