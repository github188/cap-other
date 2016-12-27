/******************************************************************************
 * Copyright (C) 2015 ShenZhen ComTop Information Technology Co.,Ltd
 * All Rights Reserved.
 * 本软件为深圳康拓普开发研制。未经本公司正式书面同意，其他任何个人、团体不得使用�?
 * 复制、修改或发布本软�?
 *****************************************************************************/

package com.comtop.cap.ptc.team.appservice;

import java.util.List;

import com.comtop.cap.ptc.team.dao.CapEmployeeDAO;
import com.comtop.cap.ptc.team.model.CapEmployeeVO;
import com.comtop.cip.jodd.petite.meta.PetiteBean;
import com.comtop.cip.jodd.petite.meta.PetiteInject;
import com.comtop.top.core.base.appservice.BaseAppService;

/**
 * 人员基本信息服务扩展
 * 
 * @author 姜子豪
 * @since 1.0
 * @version 2015-9-18 姜子豪
 */
@PetiteBean
public class CapEmployeeAppService extends BaseAppService {
    
    /** 注入DAO **/
    @PetiteInject
    protected CapEmployeeDAO employeeDAO;
    
    /**
     * 查询用户列表
     * 
     * @param capEmployee 人员基本信息
     * @return 人员基本信息
     */
    public List<CapEmployeeVO> queryEmployeeList(CapEmployeeVO capEmployee) {
        return employeeDAO.queryEmployeeList(capEmployee);
    }
    
    /**
     * 新增 人员基本信息
     * 
     * @param capEmployee 人员基本信息对象
     * @return 人员基本信息Id
     */
    public String insertEmployee(CapEmployeeVO capEmployee) {
        return employeeDAO.insertEmployee(capEmployee);
    }
    
    /**
     * 更新 人员基本信息
     * 
     * @param capEmployee 人员基本信息对象
     */
    public void updateEmployee(CapEmployeeVO capEmployee) {
        employeeDAO.updateEmployee(capEmployee);
    }
    
    /**
     * 通过人员基本信息ID查询人员基本信息
     * 
     * @param capEmployeeId 人员基本信息ID
     * @return 人员基本信息对象
     */
    public CapEmployeeVO queryCapEmployeeById(String capEmployeeId) {
        return employeeDAO.queryCapEmployeeById(capEmployeeId);
    }
    
    /**
     * 删除人员对象
     * 
     * @param capEmployeeList 人员对象
     */
    public void deleteEmployeeList(List<CapEmployeeVO> capEmployeeList) {
        employeeDAO.deleteEmployeeList(capEmployeeList);
    }
    
    /**
     * 查询用户数据条数
     * 
     * @param capEmployee 人员基本信息
     * @return 数据条数
     */
    public int queryEmployeeCount(CapEmployeeVO capEmployee) {
        return employeeDAO.queryEmployeeCount(capEmployee);
    }
    
    /**
     * 查询用户列表(不分页)
     * 
     * @param capEmployee 人员基本信息
     * @return 人员基本信息
     */
    public List<CapEmployeeVO> queryEmployeeListNoPage(CapEmployeeVO capEmployee) {
        return employeeDAO.queryEmployeeListNoPage(capEmployee);
    }
    
    /**
     * 查询测试用户列表(不分页)
     * 
     * @param capEmployee 测试人员基本信息
     * @return 人员基本信息
     */
    public List<CapEmployeeVO> queryTestEmployeeListNoPage(CapEmployeeVO capEmployee) {
        return employeeDAO.queryTestEmployeeListNoPage(capEmployee);
    }
    
}
