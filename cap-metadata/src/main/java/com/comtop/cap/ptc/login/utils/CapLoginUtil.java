/******************************************************************************
 * Copyright (C) 2015 ShenZhen ComTop Information Technology Co.,Ltd
 * All Rights Reserved.
 * 本软件为深圳康拓普开发研制。未经本公司正式书面同意，其他任何个人、团体不得使用、
 * 复制、修改或发布本软件.
 *****************************************************************************/

package com.comtop.cap.ptc.login.utils;

import java.util.Arrays;
import java.util.HashSet;
import java.util.Set;

import javax.servlet.http.HttpSession;

import com.comtop.cap.ptc.login.model.CapLoginVO;
import com.comtop.top.component.app.session.HttpSessionUtil;

/**
 * 
 * 登陆工具类
 * 
 * @author 丁庞
 * @since jdk1.6
 * @version 2015年9月25日 丁庞
 */
public final class CapLoginUtil {
    
    /**
     * 构造函数
     */
    private CapLoginUtil() {
        
    }
    
    /** cap当前登陆用户session key */
    public static String CAP_CURRENT_USER = "current_capuser";
    
    /** top 平台超级管理员账号 */
    public final static String TOP_SUPER_ADMIN_ACCOUNT = "SuperAdmin";
    
    /**
     * 读取session中的当前cap用户信息
     * 
     * @return cap用户信息
     */
    public static CapLoginVO getCapCurrentUserSession() {
        CapLoginVO objCAPLoginVO = new CapLoginVO();
        HttpSession objSession = HttpSessionUtil.getSession();
        objCAPLoginVO = (CapLoginVO) objSession.getAttribute(CapLoginUtil.CAP_CURRENT_USER);
        return objCAPLoginVO;
    }
    
    /**
     * 当前cap用户信息放到session中
     * 
     * @param bmLoginVO BMLoginVO
     */
    public static void setCapCurrentUserSession(CapLoginVO bmLoginVO) {
        CapLoginVO attributeMap = new CapLoginVO();
        attributeMap.setAccount(bmLoginVO.getAccount());
        attributeMap.setBmEmployeeId(bmLoginVO.getBmEmployeeId());
        attributeMap.setBmEmployeeName(bmLoginVO.getBmEmployeeName());
        attributeMap.setBmTeamId(bmLoginVO.getBmTeamId());
        attributeMap.setRoleIds(bmLoginVO.getRoleIds());
        // attributeMap.setBmTeamName(bmLoginVO.getBmTeamName());
        HttpSession objSession = HttpSessionUtil.getSession();
        objSession.setAttribute(CapLoginUtil.CAP_CURRENT_USER, attributeMap);
    }
    
    /**
     * 清除session中的当前cap用户信息
     *
     * @param objSession HttpSession
     */
    public static void removeCapCurrentUserSession(HttpSession objSession) {
        objSession.removeAttribute(CAP_CURRENT_USER);
    }
    
    /**
     * 
     * 数组转字符串
     * 
     * @param arrStr 字符串数组
     * @param flag 标示
     * @return 字符串
     */
    public static String arrayUnique(String[] arrStr, String flag) {
        String str = "";
        Set<String> set = new HashSet<String>();
        for (int i = 0; i < arrStr.length; i++) {
            set.addAll(Arrays.asList(arrStr[i].split(";")));
        }
        String[] temp = set.toArray(new String[0]);
        for (int i = 0; i < temp.length; i++) {
            str += temp[i];
            if (i < temp.length - 1) {
                str += flag;
            }
        }
        return str;
    }
}
