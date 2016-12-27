/******************************************************************************
 * Copyright (C) 2015 ShenZhen ComTop Information Technology Co.,Ltd
 * All Rights Reserved.
 * 本软件为深圳康拓普开发研制。未经本公司正式书面同意，其他任何个人、团体不得使用、
 * 复制、修改或发布本软件.
 *****************************************************************************/

package com.comtop.cap.bm.metadata.soareg;

import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;

import com.comtop.cip.jodd.util.StringUtil;
import com.comtop.soa.common.util.SOACollectionUtils;
import com.comtop.soa.store.register.ClassScanner;
import com.comtop.soa.store.register.model.RegisterScanBean;
import com.comtop.soa.store.register.model.RegisterScansBean;
import com.comtop.soa.store.smc.model.ServiceVO;
import com.comtop.soa.store.tools.RegisterSQLHelper;

/**
 * 实体方法soa服务sql脚本注册类
 *
 * @author 龚斌
 * @since 1.0
 * @version 2015年11月3日 龚斌
 */
public final class SoaSqlRegister {
    
    /** 日志记录器 */
    private static final Logger LOGGER = LoggerFactory.getLogger(SoaSqlRegister.class);
    
    /**
     * 构造函数
     */
    private SoaSqlRegister() {
    }
    
    /**
     * 根据正则表达式获取本地服务的SQL脚本
     * 
     * @param regex 生成服务需要的正则表达式
     * @return sql注册脚本
     */
    public static String getEntityRegisterSqlByRegex(String regex) {
        Map<String, ServiceVO> objServiceMap = getEntityRegisterMap(regex);
        if (SOACollectionUtils.isEmpty(objServiceMap)) {
            return null;
        }
        // 第二步：生成注册SQL
        return createRegisterSQL(objServiceMap);
    }
    
    /**
     * 获取实体soa注册的map
     * 
     * @param regex 表达式
     * @return 注册map
     */
    private static Map<String, ServiceVO> getEntityRegisterMap(String regex) {
        RegisterScansBean objScans = new RegisterScansBean();
        objScans.setDir("soa");
        objScans.setExclude("");
        List<RegisterScanBean> scanList = new ArrayList<RegisterScanBean>();
        RegisterScanBean objRegScan = new RegisterScanBean();
        objRegScan.setInclude(regex);
        objRegScan.setExclude("");
        objRegScan.setDir("soa");
        objRegScan.setPublishTypes("1");
        objRegScan.setBuilder("com.comtop.cap.runtime.spring.SoaBeanBuilder4Cap");
        //objRegScan.setBuilder("com.comtop.top.core.soa.JoddBeanBuilderImp");
        scanList.add(objRegScan);
        objScans.setScanList(scanList);
        Map<String, ServiceVO> objServiceMap = registerScan(objScans, regex);
        return objServiceMap;
    }
    
    /**
     * 对每一个文件进行规则匹配与服务注册，用户按指定规则扫描,每次处理一个XML，soa:scans
     * 
     * @param scans 扫描范围集合
     * @param fileName 文件名
     * @return 规则扫描的ServiceVoMap --对应文件<soa:scans />;key:serivceCode,value: ServiceVO
     */
    private static Map<String, ServiceVO> registerScan(RegisterScansBean scans, String fileName) {
        /** 规则扫描的ServiceVoMap --对应文件<soa:scans />;key:serivceCode,value: ServiceVO */
        Map<String, ServiceVO> objScanServiceMap = new HashMap<String, ServiceVO>();
        // 处理扫描--<soa:scans><scan/><scan/></soa:scans>
        List<RegisterScanBean> lstScan = scans.getScanList();
        if (SOACollectionUtils.isEmpty(lstScan)) {
            return objScanServiceMap;
        }
        for (RegisterScanBean objScan : lstScan) {
            // 每次处理一个<scan/>
            List<ServiceVO> lstServiceVo = ClassScanner.parseRegisterScan(objScan, scans.getExclude(), fileName);
            for (ServiceVO objVo : lstServiceVo) {
                objVo.setBuilderClass(StringUtil.isBlank(objVo.getBuilderClass()) ? objScan.getBuilder() : objVo
                    .getBuilderClass());
                if (!objScanServiceMap.containsKey(objVo.getCode())) {
                    objScanServiceMap.put(objVo.getCode(), objVo);
                }
            }
        }
        return objScanServiceMap;
    }
    
    /**
     * 生成需要注册的sql文件 * @description 根据用户指定的服务内容，生成一个持久化服务元素的SQL文件
     * 
     * @dbAffect 无
     * @ramAffect 无
     * @fileAffect 将会在指定的目录下，生成一个以“soa_register.sql”命名的SQL文件。
     * @step 第一步：拼装服务类的注册SQL内容 <br/>
     *       第1.1步：拼装类描述信息SQL内容
     *       第1.2步：拼装服务方法的注册SQL内容 <br/>
     *       第1.3步：拼装方法参数的注册SQL内容 <br/>
     *       第1.4步：拼装参数结构描述的注册SQL内容 <br/>
     *       第二步：生成SQL文件
     * @author lixiaoqiang
     * @param serviceMap 需要注册的服务MAP（serviceMap）的内容。生成一个服务注册的SQL文件
     * @return sql注册脚本
     */
    public static String createRegisterSQL(Map<String, ServiceVO> serviceMap) {
        // 如果MAP不为空，则循环每一个serviceVo生成注册SQL
        if (!SOACollectionUtils.isEmpty(serviceMap)) {
            // 第一步：生成原始sql
            StringBuffer strSQL = appendRegisterSQL(serviceMap);
            // strSQL.append("commit;\n");
            return strSQL.toString();
        }
        return null;
    }
    
    /**
     * 获取 生成需要注册的sql内容,包括：SERVICE、method、Params、PARAM_DETAIL
     * 
     * @author lixiaoqiang
     * @param serviceMap 需要注册的服务MAP（serviceMap）的内容。生成一个服务注册的SQL文件
     * @return SQL内容
     */
    public static StringBuffer appendRegisterSQL(Map<String, ServiceVO> serviceMap) {
        // 如果MAP不为空，则循环每一个serviceVo生成注册SQL
        StringBuffer strSQL = new StringBuffer(32);
        String strKey = "";
        for (Map.Entry<String, ServiceVO> objEntry : serviceMap.entrySet()) {
            strKey = objEntry.getKey();
            // strSQL.append("--------准备注册：");
            // strSQL.append(strKey);
            // strSQL.append("服务-------\n");
            LOGGER.info("服务注册，生成" + strKey + "服务元素注册SQL");
            RegisterSQLHelper.createServiceSQL(objEntry.getValue(), strSQL);
        }
        return strSQL;
    }
    
}
