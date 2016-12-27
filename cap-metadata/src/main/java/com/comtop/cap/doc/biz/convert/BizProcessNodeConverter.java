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
import java.util.regex.Matcher;

import org.apache.commons.lang.StringUtils;

import com.comtop.cap.bm.common.BizLevel;
import com.comtop.cap.doc.biz.model.BizProcessDTO;
import com.comtop.cap.doc.biz.model.BizProcessNodeDTO;
import com.comtop.cap.doc.util.DocDataUtil;
import com.comtop.cap.document.word.docmodel.data.WordDocument;

/**
 * 数据转换器工具类
 *
 * @author lizhiyong
 * @since jdk1.6
 * @version 2016年1月25日 lizhiyong
 */
public class BizProcessNodeConverter {
    
    /**
     * 构造函数
     */
    private BizProcessNodeConverter() {
        //
    }
    
    /**
     * 将节点转为节点集。主要是将节点名称形如 " 审批（20，220，320）"的节点转为节点集
     * 
     * @param matcher 匹配器
     *
     * @param newDTO 节点
     * @return 节点集
     */
    public static List<BizProcessNodeDTO> convertNodeToNodeList(Matcher matcher, BizProcessNodeDTO newDTO) {
        List<BizProcessNodeDTO> alRet = new ArrayList<BizProcessNodeDTO>();
        String nodeName = matcher.group(1);
        String strNodeNos = matcher.group(2);
        String[] nodeNos = strNodeNos.split("[,、，]");
        for (int i = 0; i < nodeNos.length; i++) {
            String nodeNo = nodeNos[i];
            BizProcessNodeDTO newOneNodeDTO = new BizProcessNodeDTO();
            DocDataUtil.copyProperties(newOneNodeDTO, newDTO);
            newOneNodeDTO.setBizForms(null);
            newOneNodeDTO.setBizRelations(null);
            newOneNodeDTO.setBizRoles(null);
            newOneNodeDTO.setBizNodeConstraints(null);
            newOneNodeDTO.setName(nodeName);
            newOneNodeDTO.setSerialNo(nodeNo);
            newOneNodeDTO.setId(null);
            alRet.add(newOneNodeDTO);
        }
        return alRet;
    }
    
    /**
     * 从节点约束时抽取信息转换为节点对象
     *
     * @param bizProcessNodeDTO 流程节点
     * @param document 文档对象
     * @return 流程DTO
     */
    public static BizProcessDTO convert2BizProcess(BizProcessNodeDTO bizProcessNodeDTO, WordDocument document) {
        BizProcessDTO bizProcessDTO = new BizProcessDTO();
        bizProcessDTO.setName(bizProcessNodeDTO.getProcessName());
        bizProcessDTO.setId(bizProcessNodeDTO.getProcessId());
        bizProcessDTO.setProcessName(bizProcessNodeDTO.getProcessName());
        bizProcessDTO.setDataFrom(bizProcessNodeDTO.getDataFrom());
        bizProcessDTO.setDomainId(bizProcessNodeDTO.getDomainId());
        bizProcessDTO.setDocumentId(bizProcessNodeDTO.getDocumentId());
        bizProcessDTO.setContainer(bizProcessNodeDTO.getContainer());
        bizProcessDTO.setBizItemName(bizProcessNodeDTO.getBizItemName());
        bizProcessDTO.setBizItemId(bizProcessNodeDTO.getBizItemId());
        return bizProcessDTO;
    }
    
    /**
     * 转换节点标志为集合 本方法与convertToNodeFlag互逆
     * <p>
     * 在模板中，节点标志部分如下面的例子所示
     * 其中flowNode.nodeFlagMap.critical、flowNode.nodeFlagMap.core、flowNode.nodeFlagMap.generic三个属性为节点标识的属性。其值存储在数据库中，为形如
     * "critical;core;generic"的字符串
     * <p>
     * 在展示数据和导出文档时，需要将数据组装成Map的形式，Map的Key为mappingTo的最后一段，即critical、core、generic，value为"√".
     * <p>
     * 在导入时，则需要将Map形式的数据转为字符串形式的数据存储在数据库中
     * <p>
     * 模板样例
     * 
     * <pre>
     *  &lt;table type="EXT_ROWS" name="流程节点清单"
     *             mappingTo="flowNode[]=#BizProcessNode(processId=bizProcessInfo.id,processName=bizProcessInfo.processName)"
     *             selector="flowNode.name,flowNode.serialNo">
     *             &lt;tr>
     *                 &lt;td mappingTo="flowNode.serialNo" >编码&lt;/td>
     *                 &lt;td mappingTo="flowNode.name" nullAble="false">流程节点|业务活动&lt;/td>
     *                 &lt;td mappingTo="flowNode.roles" >涉及角色&lt;/td>
     *                 &lt;td mappingTo="flowNode.cnManageLevel" >层级关系&lt;/td>
     *                 &lt;td mappingTo="flowNode.nodeFlagMap.critical" >关键业务节点|关键业务活动|关键流程节点&lt;/td>
     *                 &lt;td mappingTo="flowNode.nodeFlagMap.core" >核心管控节点|核心管控活动&lt;/td>
     *                 &lt;td mappingTo="flowNode.nodeFlagMap.generic" >一般管控节点|一般管控活动&lt;/td>
     *                 &lt;td mappingTo="flowNode.sysName" >IT实现&lt;/td>
     *                 &lt;td mappingTo="flowNode.riskArea" >风险点&lt;/td>
     *                 &lt;td mappingTo="flowNode.clause" >制度条款&lt;/td>
     *                 &lt;td mappingTo="flowNode.remark" >备注&lt;/td>
     *             &lt;/tr>
     *         &lt;/table>
     * </pre>
     * 
     * @param nodeFlag 节点标识
     * @return 节点标识集
     */
    public static Map<String, String> convertToNodeFlagMap(String nodeFlag) {
        if (StringUtils.isNotBlank(nodeFlag)) {
            String[] flags = nodeFlag.split(";");
            Map<String, String> flagMap = new HashMap<String, String>();
            for (int i = 0; i < flags.length; i++) {
                flagMap.put(flags[i], "√");
            }
            return flagMap;
        }
        return null;
    }
    
    /**
     * 节点标记集转为字符串。转换节点标志为集合 本方法与convertToNodeFlagMap互逆
     *
     * @param nodeFlagMap 节点标识
     * @return 字符串 形式的NodeFlag
     */
    public static String convertToNodeFlag(Map<String, String> nodeFlagMap) {
        if (nodeFlagMap != null && nodeFlagMap.size() > 0) {
            StringBuffer sbBuffer = new StringBuffer();
            for (Entry<String, String> entry : nodeFlagMap.entrySet()) {
                if (StringUtils.isNotBlank(entry.getValue()) && "√".equals(entry.getValue())) {
                    sbBuffer.append(entry.getKey()).append(';');
                }
            }
            if (sbBuffer.length() > 0) {
                sbBuffer.deleteCharAt(sbBuffer.length() - 1);
            }
            return sbBuffer.toString();
        }
        return null;
    }
    
    /**
     * 中文的业务层级转为编码形式
     *
     * @param cnManageLevel 中文形式的业务层级
     * @return 编码形式的业务层级
     */
    public static String convertToManageLevel(String cnManageLevel) {
        if (StringUtils.isNotBlank(cnManageLevel)) {
            String[] bizLevels = cnManageLevel.split("[、；;]");
            StringBuffer sb = new StringBuffer();
            for (String level : bizLevels) {
                BizLevel level2 = BizLevel.getBizLevelByCnName(level);
                sb.append(level2.getCode()).append(";");
            }
            sb.deleteCharAt(sb.length() - 1);
            return sb.toString();
        }
        return null;
    }
    
    /**
     * 转为中文形式的管理层级
     * 存在数据库中的管理层级是com.comtop.cap.bm.common.BizLevel类的编码，需要将其转换对应的中文描述便于阅读
     * 
     * @param manageLevel code形式有管理层级
     * @return 中文形式的管理层级
     */
    public static String convertToCnManageLevel(String manageLevel) {
        if (StringUtils.isNotBlank(manageLevel)) {
            String[] bizLevels = manageLevel.split("[;]");
            StringBuffer sb = new StringBuffer();
            for (String level : bizLevels) {
                BizLevel level2 = BizLevel.getBizLevelByCode(level);
                sb.append(level2.getCnName()).append(";");
            }
            sb.deleteCharAt(sb.length() - 1);
            return sb.toString();
        }
        return null;
    }
}
