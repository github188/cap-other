/******************************************************************************
 * Copyright (C) 2016 ShenZhen ComTop Information Technology Co.,Ltd
 * All Rights Reserved.
 * 本软件为深圳康拓普开发研制。未经本公司正式书面同意，其他任何个人、团体不得使用、
 * 复制、修改或发布本软件.
 *****************************************************************************/

package com.comtop.cap.doc.biz.convert;

import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;
import java.util.Map.Entry;

import org.apache.commons.lang.StringUtils;

import com.comtop.cap.bm.biz.flow.model.BizProcessNodeRoleVO;
import com.comtop.cap.bm.biz.items.model.BizItemsRoleVO;
import com.comtop.cap.bm.common.BizLevel;
import com.comtop.cap.doc.biz.model.BizRoleDTO;
import com.comtop.cap.document.word.docmodel.data.WordDocument;
import com.comtop.cap.document.word.docmodel.datatype.DataFromType;

/**
 * 数据转换器工具类
 *
 * @author lizhiyong
 * @since jdk1.6
 * @version 2016年1月25日 lizhiyong
 */
public class BizRoleConverter {
    
    /**
     * 构造函数
     */
    private BizRoleConverter() {
        //
    }
    
    /**
     * 转换为角色集，以业务层级为Key
     *
     * @param roles 角色集
     * @return 角色集
     */
    public static Map<String, String> convertToRolesMapByBizLevel(List<BizItemsRoleVO> roles) {
        Map<String, StringBuffer> rolesBufferMap = new HashMap<String, StringBuffer>();
        StringBuffer sbRoles = null;
        for (BizItemsRoleVO bizItemsRoleVO : roles) {
            sbRoles = rolesBufferMap.get(bizItemsRoleVO.getBizLevel());
            if (sbRoles == null) {
                sbRoles = new StringBuffer();
                rolesBufferMap.put(bizItemsRoleVO.getBizLevel(), sbRoles);
            }
            sbRoles.append(bizItemsRoleVO.getRoleName()).append(';');
        }
        
        // 删除最后一个多余的';'
        Map<String, String> rolesMap = new HashMap<String, String>();
        String value = null;
        for (Entry<String, StringBuffer> entry : rolesBufferMap.entrySet()) {
            if (entry.getValue().length() > 0) {
                value = entry.getValue().deleteCharAt(entry.getValue().length() - 1).toString();
                rolesMap.put(entry.getKey(), value);
            }
        }
        return rolesMap;
    }
    
    /**
     * 将角色字符串转为角色集
     *
     * @param rolesInput 角色字符串
     * @param bizLevel 业务层级
     * @param document 当前文档对象
     * @return 角色集
     */
    public static List<BizRoleDTO> convertToRoleList(String rolesInput, String bizLevel, WordDocument document) {
        // 组装角色数据
        List<BizRoleDTO> roleCollection = new ArrayList<BizRoleDTO>();
        // 将角色名称按分隔符分解，创建新的角色
        String[] roles = rolesInput.split("[、;；]");
        for (String name : roles) {
            if (StringUtils.isNotBlank(bizLevel)) {
                String[] bizLevels = bizLevel.split("[、；;]");
                for (String level : bizLevels) {
                    BizRoleDTO bizRoleDTO = convertToRoleDTO(document, name, level);
                    roleCollection.add(bizRoleDTO);
                }
            } else {
                BizRoleDTO bizRoleDTO = convertToRoleDTO(document, name, bizLevel);
                roleCollection.add(bizRoleDTO);
            }
        }
        return roleCollection;
    }
    
    /**
     * 转换角色
     *
     * @param document 文档对象
     * @param name 名称
     * @param level 业务层级
     * @return 角色DTO
     */
    public static BizRoleDTO convertToRoleDTO(WordDocument document, String name, String level) {
        BizLevel bizLevel = BizLevel.getBizLevelByCnName(level);
        if (bizLevel == BizLevel.BIZ_LEVEL_UNKNOWN) {
            bizLevel = BizLevel.getBizLevelByCode(level);
        }
        BizRoleDTO bizRoleDTO = new BizRoleDTO();
        // if (bizLevel != BizLevel.BIZ_LEVEL_UNKNOWN) {
        bizRoleDTO.setBizLevel(bizLevel.getCode());
        // }
        bizRoleDTO.setName(name);
        bizRoleDTO.setDataFrom(DataFromType.IMPORT);
        bizRoleDTO.setDocumentId(document.getId());
        bizRoleDTO.setDomainId(document.getDomainId());
        return bizRoleDTO;
    }
    
    /**
     * 角色转为字符串
     *
     * @param roles 角色集
     * @return 角色字符串
     */
    public static String convertToRoles(List<BizProcessNodeRoleVO> roles) {
        StringBuffer sbRoles = new StringBuffer();
        for (BizProcessNodeRoleVO bizProcessNodeRole : roles) {
            sbRoles.append(bizProcessNodeRole.getRoleName()).append(';');
        }
        if (sbRoles.length() > 0) {
            sbRoles.deleteCharAt(sbRoles.length() - 1);
        }
        return sbRoles.toString();
    }
}
