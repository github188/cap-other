/******************************************************************************
 * Copyright (C) 2015 ShenZhen ComTop Information Technology Co.,Ltd
 * All Rights Reserved.
 * 本软件为深圳康拓普开发研制。未经本公司正式书面同意，其他任何个人、团体不得使用、
 * 复制、修改或发布本软件.
 *****************************************************************************/

package com.comtop.cap.ptc.login.facade;

import java.util.ArrayList;
import java.util.List;

import com.comtop.cap.ptc.login.model.CapLoginVO;
import com.comtop.cap.ptc.login.utils.CapLoginUtil;
import com.comtop.cap.ptc.team.appservice.CapEmployeeAppService;
import com.comtop.cap.ptc.team.appservice.TeamAndEmployeeRelAppService;
import com.comtop.cap.ptc.team.model.CapEmployeeVO;
import com.comtop.cap.ptc.team.model.TeamAndEmployeeRelVO;
import com.comtop.cip.jodd.petite.meta.PetiteBean;
import com.comtop.cip.jodd.petite.meta.PetiteInject;
import com.comtop.cip.jodd.util.StringUtil;

/**
 * 
 * CAP登陆扩展实现
 * 
 * @author 丁庞
 * @since jdk1.6
 * @version 2015年9月21日 丁庞
 */
@PetiteBean
public class CapLoginFacade {
    
    /** 注入人员AppService **/
    @PetiteInject
    protected CapEmployeeAppService capEmployeeAppService;
    
    /** 注入团队AppService **/
    @PetiteInject
    protected TeamAndEmployeeRelAppService teamAndEmployeeRelAppService;
    
    /**
     * 验证密码是否正确
     * 
     * @param account 账号
     * @param password 密码
     * @return 人员结果集
     */
    public CapLoginVO queryPersonnelList(String account, String password) {
        CapLoginVO bmLoginVO = new CapLoginVO();
        List<CapEmployeeVO> capEmployeeVOs = new ArrayList<CapEmployeeVO>();
        CapEmployeeVO capEmployeeVO = new CapEmployeeVO();
        capEmployeeVO.setEmployeeAccount(account);
        capEmployeeVO.setEmployeePassword(password);
        capEmployeeVOs = capEmployeeAppService.queryEmployeeList(capEmployeeVO);
        if (capEmployeeVOs != null && capEmployeeVOs.size() > 0) {
            CapEmployeeVO personnelVO = capEmployeeVOs.get(0);
            bmLoginVO.setAccount(personnelVO.getEmployeeAccount());
            bmLoginVO.setBmEmployeeId(personnelVO.getId());
            bmLoginVO.setBmEmployeeName(personnelVO.getEmployeeName());
            bmLoginVO.setPassword(personnelVO.getEmployeePassword());
            bmLoginVO.setRelatedAccount(personnelVO.getRelatedAccount());
            if (StringUtil.isBlank(bmLoginVO.getRelatedAccount())) { // 关联账号为null默认关联为top超级管理员账号
                bmLoginVO.setRelatedAccount(CapLoginUtil.TOP_SUPER_ADMIN_ACCOUNT);
            }
            TeamAndEmployeeRelVO teamAndEmployeeRelVO = new TeamAndEmployeeRelVO();
            teamAndEmployeeRelVO.setEmployeeId(personnelVO.getId());
            List<TeamAndEmployeeRelVO> teamAndEmployeeRes = new ArrayList<TeamAndEmployeeRelVO>();
            teamAndEmployeeRes = teamAndEmployeeRelAppService.queryTeamAndEmployeeRel(teamAndEmployeeRelVO);
            if (capEmployeeVOs != null && capEmployeeVOs.size() > 0) {
                String teamIds = "";
                String roleIds = "";
                for (int i = 0; i < teamAndEmployeeRes.size(); i++) {
                    teamIds += teamAndEmployeeRes.get(i).getTeamId();
                    roleIds += teamAndEmployeeRes.get(i).getRoleId();
                    if (i < (teamAndEmployeeRes.size() - 1)) {
                        teamIds += ",";
                        roleIds += ",";
                    }
                }
                bmLoginVO.setRoleIds(CapLoginUtil.arrayUnique(roleIds.split(","), ";"));
                bmLoginVO.setBmTeamId(teamIds);
            }
            bmLoginVO.setValidateCode(true);
        }
        return bmLoginVO;
    }
}
