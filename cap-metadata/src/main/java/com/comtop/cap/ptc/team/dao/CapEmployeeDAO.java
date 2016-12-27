/******************************************************************************
 * Copyright (C) 2015 ShenZhen ComTop Information Technology Co.,Ltd
 * All Rights Reserved.
 * 本软件为深圳康拓普开发研制。未经本公司正式书面同意，其他任何个人、团体不得使用
 * 复制、修改或发布本软
 *****************************************************************************/

package com.comtop.cap.ptc.team.dao;

import java.util.List;

import com.comtop.cap.ptc.team.model.CapEmployeeVO;
import com.comtop.cip.jodd.jtx.JtxPropagationBehavior;
import com.comtop.cip.jodd.jtx.meta.Transaction;
import com.comtop.cip.jodd.petite.meta.PetiteBean;
import com.comtop.top.core.base.dao.CoreDAO;

/**
 * 人员基本信息扩展DAO
 * 
 * @author 姜子豪
 * @since 1.0
 * @version 2015-9-18 姜子豪
 */
@PetiteBean
public class CapEmployeeDAO extends CoreDAO<CapEmployeeVO> {
    
    /**
     * 查询用户列表
     * 
     * @param capEmployee 人员基本信息
     * @return 人员基本信息
     */
    public List<CapEmployeeVO> queryEmployeeList(CapEmployeeVO capEmployee) {
        return super.queryList("com.comtop.cap.ptc.team.model.queryEmployeeList", capEmployee, capEmployee.getPageNo(),
            capEmployee.getPageSize());
    }
    
    /**
     * 查询用户列表（不分页）
     * 
     * @param capEmployee 人员基本信息
     * @return 人员基本信息
     */
    public List<CapEmployeeVO> queryEmployeeListNoPage(CapEmployeeVO capEmployee) {
        return super.queryList("com.comtop.cap.ptc.team.model.queryEmployeeList", capEmployee);
    }
    
    /**
     * 查询测试用户列表(不分页)
     * 
     * @param capEmployee 测试人员基本信息
     * @return 人员基本信息
     */
    public List<CapEmployeeVO> queryTestEmployeeListNoPage(CapEmployeeVO capEmployee) {
        return super.queryList("com.comtop.cap.ptc.team.model.queryTestEmployeeList", capEmployee);
    }
    
    /**
     * 新增 人员基本信息
     * 
     * @param capEmployee 人员基本信息对象
     * @return 新增结果
     */
    @Transaction(propagation = JtxPropagationBehavior.PROPAGATION_REQUIRED, readOnly = false)
    public String insertEmployee(CapEmployeeVO capEmployee) {
        String result = (String) insert(capEmployee);
        return result;
    }
    
    /**
     * 更新 人员基本信息
     * 
     * @param capEmployee 人员基本信息对象
     */
    @Transaction(propagation = JtxPropagationBehavior.PROPAGATION_REQUIRED, readOnly = false)
    public void updateEmployee(CapEmployeeVO capEmployee) {
        update(capEmployee);
    }
    
    /**
     * 通过人员基本信息ID查询人员基本信息
     * 
     * @param capEmployeeId 人员基本信息ID
     * @return 人员基本信息对象
     */
    public CapEmployeeVO queryCapEmployeeById(String capEmployeeId) {
        CapEmployeeVO objEmployee = new CapEmployeeVO();
        objEmployee.setId(capEmployeeId);
        return loadEmployee(objEmployee);
    }
    
    /**
     * 读取 人员基本信息
     * 
     * @param employee 人员基本信息对象
     * @return 人员基本信息
     */
    public CapEmployeeVO loadEmployee(CapEmployeeVO employee) {
        CapEmployeeVO objEmployee = load(employee);
        return objEmployee;
    }
    
    /**
     * 删除人员对象
     * 
     * @param capEmployeeList 人员对象
     */
    public void deleteEmployeeList(List<CapEmployeeVO> capEmployeeList) {
        super.delete(capEmployeeList);
    }
    
    /**
     * 查询用户数据条数
     * 
     * @param capEmployee 人员基本信息
     * @return 数据条数
     */
    public int queryEmployeeCount(CapEmployeeVO capEmployee) {
        return ((Integer) selectOne("com.comtop.cap.ptc.team.model.queryEmployeeCount", capEmployee)).intValue();
    }
    
}
