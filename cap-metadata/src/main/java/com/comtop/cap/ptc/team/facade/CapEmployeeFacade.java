/******************************************************************************
 * Copyright (C) 2015 ShenZhen ComTop Information Technology Co.,Ltd
 * All Rights Reserved.
 * 本软件为深圳康拓普开发研制。未经本公司正式书面同意，其他任何个人、团体不得使用�?
 * 复制、修改或发布本软�?
 *****************************************************************************/

package com.comtop.cap.ptc.team.facade;

import java.util.List;

import com.comtop.cap.bm.metadata.base.facade.CapBmBaseFacade;
import com.comtop.cap.ptc.team.appservice.CapEmployeeAppService;
import com.comtop.cap.ptc.team.model.CapEmployeeVO;
import com.comtop.cap.runtime.base.facade.CapTopExtendFacade;
import com.comtop.cip.common.util.CAPStringUtils;
import com.comtop.cip.jodd.petite.meta.PetiteBean;
import com.comtop.cip.jodd.petite.meta.PetiteInject;

/**
 * 人员基本信息扩展实现
 * 
 * @author 姜子豪
 * @since 1.0
 * @version 2015-9-18 姜子豪
 */
@PetiteBean
public class CapEmployeeFacade extends CapBmBaseFacade {
    
    /** 注入AppService **/
    @PetiteInject
    protected CapEmployeeAppService employeeAppService;
    
    /** 注入运行时的cap与top集成的facade **/
    @PetiteInject
    protected CapTopExtendFacade capTopExtendFacade;
    
    /**
     * 查询用户列表
     * 
     * @param capEmployee 人员基本信息
     * @return 人员基本信息
     */
    public List<CapEmployeeVO> queryEmployeeList(CapEmployeeVO capEmployee) {
        return employeeAppService.queryEmployeeList(capEmployee);
    }
    
    /**
     * 查询用户数据条数
     * 
     * @param capEmployee 人员基本信息
     * @return 数据条数
     */
    public int queryEmployeeCount(CapEmployeeVO capEmployee) {
        return employeeAppService.queryEmployeeCount(capEmployee);
    }
    
    /**
     * 新增 人员基本信息
     * 
     * @param capEmployee 人员基本信息对象
     * @return 人员基本信息
     */
    public String insertEmployee(CapEmployeeVO capEmployee) {
        updateRelatedAccount(capEmployee);
        return employeeAppService.insertEmployee(capEmployee);
    }
    
    /**
     * 更新人员基本信息对象中的关联帐号，规则：根据关联的用户ID读取运行时的用户帐号
     * 
     * @param capEmployee 人员基本信息对象
     */
    private void updateRelatedAccount(CapEmployeeVO capEmployee) {
        if (CAPStringUtils.isNotBlank(capEmployee.getRelatedUserId())) {
            String relatedAccount = capTopExtendFacade.queryUserByUserId(capEmployee.getRelatedUserId());
            capEmployee.setRelatedAccount(relatedAccount);
        } else {
            capEmployee.setRelatedAccount("");
        }
    }
    
    /**
     * 更新 人员基本信息
     * 
     * @param capEmployee 人员基本信息对象
     */
    public void updateEmployee(CapEmployeeVO capEmployee) {
        updateRelatedAccount(capEmployee);
        employeeAppService.updateEmployee(capEmployee);
    }
    
    /**
     * 通过人员基本信息ID查询人员基本信息
     * 
     * @param capEmployeeId 人员基本信息ID
     * @return 人员基本信息对象
     */
    public CapEmployeeVO queryCapEmployeeById(String capEmployeeId) {
        return employeeAppService.queryCapEmployeeById(capEmployeeId);
    }
    
    /**
     * 删除人员对象
     * 
     * @param capEmployeeList 人员对象
     */
    public void deleteEmployeeList(List<CapEmployeeVO> capEmployeeList) {
        employeeAppService.deleteEmployeeList(capEmployeeList);
    }
    
    /**
     * 查询用户列表(不分页)
     * 
     * @param capEmployee 人员基本信息
     * @return 人员基本信息
     */
    public List<CapEmployeeVO> queryEmployeeListNoPage(CapEmployeeVO capEmployee) {
        return employeeAppService.queryEmployeeListNoPage(capEmployee);
    }
    
    /**
     * 查询测试用户列表(不分页)
     * 
     * @param capEmployee 测试人员基本信息
     * @return 人员基本信息
     */
    public List<CapEmployeeVO> queryTestEmployeeListNoPage(CapEmployeeVO capEmployee) {
        return employeeAppService.queryTestEmployeeListNoPage(capEmployee);
    }
    
}
