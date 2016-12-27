/******************************************************************************
 * Copyright (C) 2014 ShenZhen ComTop Information Technology Co.,Ltd
 * All Rights Reserved.
 * 本软件为深圳康拓普开发研制。未经本公司正式书面同意，其他任何个人、团体不得使用、
 * 复制、修改或发布本软件.
 *****************************************************************************/

package com.comtop.cap.bm.metadata.entity.util;

import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import javax.servlet.http.HttpSession;

import com.comtop.cap.bm.metadata.database.util.MetaConnection;
import com.comtop.cap.bm.metadata.entity.model.AttributeCompareResult;
import com.comtop.cap.bm.metadata.entity.model.EntityAttributeVO;
import com.comtop.cap.bm.metadata.entity.model.EntityCompareResult;
import com.comtop.top.component.app.session.HttpSessionUtil;

/**
 * 实体导入工具类
 * 
 * 
 * @author 徐庆庆
 * @since 1.0
 * @version 2014-12-2 徐庆庆
 */
public class EntityImportUtils {
    
    /** 存储实体与数据表比较结果集session标记 */
    private final static String SESSION_ENTITY_COMPARE_RESULT = "sessionEntityCompareResult";
    
    /**
     * 构造函数
     */
    private EntityImportUtils() {
        throw new RuntimeException("please do not try new EntityImportUtils instace,because all methods are static.");
    }
    
    /**
     * 获取系统配置的数据库连接信息
     * 
     * @return 数据库连接信息
     * 
     */
    public static MetaConnection getMetaConnection() {
        return ConnectionProvider.getMetaConnection();
    }
    
    /**
     * 存储实体与数据表比较结果集到session
     * 
     * @param lisEntityCompareResult 实体与数据表比较结果集
     */
    public static void saveCompareEntityToSession(List<EntityCompareResult> lisEntityCompareResult) {
        HttpSession objHttpSession = HttpSessionUtil.getSession();
        if (objHttpSession != null) {
            objHttpSession.setAttribute(SESSION_ENTITY_COMPARE_RESULT, lisEntityCompareResult);
        }
    }
    
    /**
     * 从session获取体与数据表比较结果集
     * 
     * @return List<EntityCompareResult> 实体与数据表比较结果集
     */
    @SuppressWarnings("unchecked")
    public static List<EntityCompareResult> getCompareEntityBySession() {
        HttpSession objHttpSession = HttpSessionUtil.getSession();
        List<EntityCompareResult> objLisEntityCompareResult = null;
        if (objHttpSession != null) {
            objLisEntityCompareResult = (List<EntityCompareResult>) objHttpSession
                .getAttribute(SESSION_ENTITY_COMPARE_RESULT);
        }
        return objLisEntityCompareResult;
    }
    
    /**
     * 删除session中的实体与数据表比较结果集
     */
    public static void removeCompareEntityBySession() {
        HttpSession objHttpSession = HttpSessionUtil.getSession();
        if (objHttpSession != null) {
            objHttpSession.removeAttribute(SESSION_ENTITY_COMPARE_RESULT);
        }
    }
    
    /**
     * 获取变化属性信息
     * 
     * @param objLstAttributeCompareResult 实体与数据表比较结果集
     * @return 变化属性信息
     */
    public static List<Map<String, String>> getChangedAttributes(
        List<AttributeCompareResult> objLstAttributeCompareResult) {
        
        List<Map<String, String>> lstChangedAttributes = new ArrayList<Map<String, String>>();
        for (AttributeCompareResult objAttResult : objLstAttributeCompareResult) {
            switch (objAttResult.getResult()) {
                case AttributeCompareResult.ATTR_NOT_EXISTS: // 更新
                    Map<String, String> addMap = attributeWrapper(objAttResult.getSrcAttribute());
                    addMap.put("state", "新增");
                    addMap.put("stateCode", AttributeCompareResult.ATTR_NOT_EXISTS + "");
                    lstChangedAttributes.add(addMap);
                    break;
                case AttributeCompareResult.ATTR_DEL: // 更新
                    Map<String, String> delMap = attributeWrapper(objAttResult.getTargetAttribute());
                    delMap.put("state", "删除");
                    delMap.put("stateCode", AttributeCompareResult.ATTR_DEL + "");
                    lstChangedAttributes.add(delMap);
                    break;
                case AttributeCompareResult.ATTR_DIFF: // 修改
                    Map<String, String> updateTarMap = attributeWrapper(objAttResult.getTargetAttribute());
                    updateTarMap.put("state", "修改");
                    updateTarMap.put("stateCode", AttributeCompareResult.ATTR_DIFF + "");
                    lstChangedAttributes.add(updateTarMap);
                    break;
                case AttributeCompareResult.ATTR_DESC_DIFF: // 修改
                    Map<String, String> updateSrcMap = attributeWrapper(objAttResult.getSrcAttribute());
                    updateSrcMap.put("state", "修改");
                    updateSrcMap.put("stateCode", AttributeCompareResult.ATTR_DESC_DIFF + "");
                    lstChangedAttributes.add(updateSrcMap);
                    break;
                default:
                    break;
            }
        }
        return lstChangedAttributes;
    }
    
    /**
     * 组装属性提示信息
     * 
     * @param objEntityAttributeVO 实体属性VO
     * @return 封装的变化的属性的map
     */
    private static Map<String, String> attributeWrapper(final EntityAttributeVO objEntityAttributeVO) {
        return new HashMap<String, String>() {
            
            {
                put("cname", objEntityAttributeVO.getChName());
                put("ename", objEntityAttributeVO.getEngName());
            }
        };
        
    }
}
