/******************************************************************************
 * Copyright (C) 2016 ShenZhen ComTop Information Technology Co.,Ltd
 * All Rights Reserved.
 * 本软件为深圳康拓普开发研制。未经本公司正式书面同意，其他任何个人、团体不得使用、
 * 复制、修改或发布本软件.
 *****************************************************************************/

package com.comtop.cap.doc.biz.convert;

import java.util.HashMap;
import java.util.Map;
import java.util.Map.Entry;

import org.apache.commons.lang.StringUtils;

import com.comtop.cap.doc.biz.model.BizItemDTO;
import com.comtop.cap.doc.biz.model.BizProcessDTO;
import com.comtop.cap.document.word.docmodel.data.WordDocument;

/**
 * 数据转换器工具类
 *
 * @author lizhiyong
 * @since jdk1.6
 * @version 2016年1月25日 lizhiyong
 */
public class BizProcessConverter {
    
    /**
     * 构造函数
     */
    private BizProcessConverter() {
        //
    }
    
    /**
     * 从业务流程抽取信息转换为业务事项对象
     *
     * @param bizProcessDTO 业务流程
     * @param document 文档对象
     * @return 节点DTO
     */
    public static BizItemDTO convert2BizItem(BizProcessDTO bizProcessDTO, WordDocument document) {
        BizItemDTO bizItemDTO = new BizItemDTO();
        bizItemDTO.setName(bizProcessDTO.getBizItemName());
        bizItemDTO.setId(bizProcessDTO.getBizItemId());
        bizItemDTO.setCode(bizProcessDTO.getBizItemCode());
        bizItemDTO.setDataFrom(bizProcessDTO.getDataFrom());
        bizItemDTO.setDomainId(bizProcessDTO.getDomainId());
        bizItemDTO.setDocumentId(bizProcessDTO.getDocumentId());
        bizItemDTO.setFirstLevelBiz(bizProcessDTO.getFirstLevelBiz());
        bizItemDTO.setSecondLevelBiz(bizProcessDTO.getSecondLevelBiz());
        bizItemDTO.setManagePolicy(bizProcessDTO.getManagePolicy());
        bizItemDTO.setNormPolicy(bizProcessDTO.getNormPolicy());
        bizItemDTO.setContainer(bizProcessDTO.getContainer());
        return bizItemDTO;
    }
    
    /**
     * 流程分布转为字符串。本方法与string2DistributionMap方法互逆
     * <p>
     * 设置流程分布信息 数据库中存储的是模板中配置的属性的key，即mappingTo中的最后一截，如下面的例子所示：HQ，CC等。
     * 这些key源于com.comtop.cap.bm.common.BizLevel中定义的层级的编码。数据库中存编码，即保证统一，又保证阅读性。
     * <p>
     * 本方法将Map转为字符串形式，只要最终的字符串中存在这个key，表明流程在这个Key上有分布。
     * 
     * <pre>
     *  &lt;tr>
     *    &lt;td mappingTo="bizProcessInfo.processName" nullAble="false">流程列表 &lt;/td>
     *    &lt;td mappingTo="bizProcessInfo.distributionMap.HQ" >公司总部 &lt;/td>
     *    &lt;td mappingTo="bizProcessInfo.distributionMap.CC" >分子公司 &lt;/td>
     *    &lt;td mappingTo="bizProcessInfo.distributionMap.BU" >地市单位 &lt;/td>
     *    &lt;td mappingTo="bizProcessInfo.distributionMap.LU" >基层单位 &lt;/td>
     *  &lt;/tr>
     * </pre>
     * 
     * @param distribution 流程分布
     * @return 字符串
     */
    public static String convertToDistributionString(Map<String, String> distribution) {
        if (distribution != null && distribution.size() > 0) {
            StringBuffer sbBuffer = new StringBuffer();
            for (Entry<String, String> entry : distribution.entrySet()) {
                String value = entry.getValue();
                if (StringUtils.isNotBlank(value) && "√".equals(value)) {
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
     * 字符串转流程分布。本方法与distributionMap2String方法互逆.
     * <p>
     * 数据库中存储的是模板中配置的属性的key，即mappingTo中的最后一截，如下面的例子所示：HQ，CC等。
     * 这些key源于com.comtop.cap.bm.common.BizLevel中定义的层级的编码。数据库中存编码，即保证统一，又保证阅读性。
     * <p>
     * 本方法需要将数据库中的值 转为页面或文档中显示的结构，需要组成一个Map结构，map的key为数据库中的值，值为"√" <br/>
     * 
     * <pre>
     *  &lt;tr>
     *    &lt;td mappingTo="bizProcessInfo.processName" nullAble="false">流程列表 &lt;/td>
     *    &lt;td mappingTo="bizProcessInfo.distributionMap.HQ" >公司总部 &lt;/td>
     *    &lt;td mappingTo="bizProcessInfo.distributionMap.CC" >分子公司 &lt;/td>
     *    &lt;td mappingTo="bizProcessInfo.distributionMap.BU" >地市单位 &lt;/td>
     *    &lt;td mappingTo="bizProcessInfo.distributionMap.LU" >基层单位 &lt;/td>
     *  &lt;/tr>
     * </pre>
     * 
     * @param processLevel 流程层级
     * @return 流程分布
     */
    public static Map<String, String> convertToDistributionMap(String processLevel) {
        if (StringUtils.isNotBlank(processLevel)) {
            String[] levels = processLevel.split(";");
            Map<String, String> levelMap = new HashMap<String, String>();
            for (int i = 0; i < levels.length; i++) {
                levelMap.put(levels[i], "√");
            }
            return levelMap;
        }
        
        return null;
    }
    
}
