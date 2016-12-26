/******************************************************************************
 * Copyright (C) 2015 ShenZhen ComTop Information Technology Co.,Ltd
 * All Rights Reserved.
 * 本软件为深圳康拓普开发研制。未经本公司正式书面同意，其他任何个人、团体不得使用、
 * 复制、修改或发布本软件.
 *****************************************************************************/

package com.comtop.cap.document.word.write;

import static com.comtop.cap.document.word.util.FolderUtil.projectOutputPath;
import static com.comtop.cap.document.word.util.FolderUtil.urlToPath;
import static com.comtop.cap.document.word.write.DocxConstants.STYLE_COVER_SIMHEI_3;
import static com.comtop.cap.document.word.write.DocxConstants.STYLE_TABLE_CONTENT_LEFT;
import static com.comtop.cap.document.word.write.DocxConstants.STYLE_TABLE_TITLE;

import java.io.InputStream;
import java.net.URL;
import java.util.ArrayList;
import java.util.List;
import java.util.Map;

import org.apache.commons.io.IOUtils;
import org.apache.commons.lang.StringUtils;
import org.apache.poi.xwpf.usermodel.XWPFDocument;
import org.apache.poi.xwpf.usermodel.XWPFTable;
import org.codehaus.jackson.map.ObjectMapper;
import org.codehaus.jackson.type.TypeReference;

import com.comtop.cap.document.word.docmodel.data.EmbedObject;
import com.comtop.cap.document.word.docmodel.data.Graphic;
import com.comtop.cap.document.word.docmodel.datatype.EmbedType;
import com.comtop.cap.document.word.docmodel.style.Style;
import com.comtop.cap.document.word.docmodel.style.Style.ItemCode;
import com.comtop.cap.document.word.docmodel.style.Style.ItemType;
import com.comtop.cap.document.word.docmodel.style.Style.NumberStyle;
import com.comtop.cap.document.word.docmodel.style.Style.VAlign;

/**
 * 文档示例
 *
 * @author lizhongwen
 * @since jdk1.6
 * @version 2015年10月30日 lizhongwen
 */
public class DocxDemo {
    
    /** helper */
    public static DocxHelper helper;
    
    /**
     * 入口
     *
     * @param args 参数
     * @throws Exception 异常
     */
    public static void main(String[] args) throws Exception {
        helper = DocxHelper.getInstance();
        XWPFDocument docx = helper.createDocument();
        helper.createFrontCover(docx, "南方电网公司系统运行业务模型说明书运行方式管理分册").createDefaultHeader(docx, "系统运行业务模型说明书运行方式管理分册")
            .createDefaultFooter(docx).createTextParagraph(docx, "文 档 说 明").getLastParagraph(docx)
            .setStyle(STYLE_COVER_SIMHEI_3);
        // 文档说明，修订记录部分
        createDocumentDescription(docx);
        helper.createEmptyParagraph(docx).createTextParagraph(docx, "修 订 记 录").getLastParagraph(docx)
            .setStyle(STYLE_COVER_SIMHEI_3);
        createModifyRecords(docx);
        helper.removeSectionFooter(docx);
        // 目录部分
        helper.createCataloguePage(docx);
        // TODO 生成目录
        // 正文部分
        // 综述
        createSummarize(docx);
        // 业务总体设计
        helper.createParagraphTitle(docx, "业务总体设计", 1).createTextParagraph(docx, "参见《南方电网公司-系统运行业务模型说明书总册》");
        // 业务事项设计
        createBizMatterDesign(docx);
        helper.saveDocument(docx, projectOutputPath() + "/样例.docx");
    }
    
    /**
     * 创建文档说明表格
     *
     * @param docx 文档对象
     */
    private static void createDocumentDescription(final XWPFDocument docx) {
        XWPFTable table = helper.createTable(docx, 9, 4, 2.73f, 0.7f);
        helper.setTableStyle(table, STYLE_TABLE_CONTENT_LEFT).setColStyle(table, 0, STYLE_TABLE_TITLE)
            .setColStyle(table, 2, STYLE_TABLE_TITLE).setTableCellsAlign(table, VAlign.CENTER, null)
            .setColBackground(table, 0, "F3F3F3").setColBackground(table, 2, "F3F3F3").setColWidth(table, 1, 6.21f)
            .setColWidth(table, 3, 3.53f).setColAlign(table, 0, VAlign.CENTER, null)
            .setColAlign(table, 2, VAlign.CENTER, null).mergeCellsHorizontal(table, 0, 1, 3)
            .mergeCellsHorizontal(table, 3, 1, 3).mergeCellsHorizontal(table, 8, 1, 3);
        helper.setCellText(table, 0, 0, "文档名称").setCellText(table, 1, 0, "文档编号").setCellText(table, 1, 2, "文档版本")
            .setCellText(table, 2, 0, "文档密级").setCellText(table, 2, 2, "内部版本").setCellText(table, 3, 0, "文档类型")
            .setCellText(table, 3, 1, "□原型稿   □初稿   □送审稿   □征求意见稿   ■ 最终稿").setCellText(table, 4, 0, "文档编制")
            .setCellText(table, 4, 2, "编制时间").setCellText(table, 5, 0, "文档审核").setCellText(table, 5, 2, "审核时间")
            .setCellText(table, 6, 0, "文档审核").setCellText(table, 6, 2, "审核时间").setCellText(table, 7, 0, "所属项目")
            .setCellText(table, 7, 2, "项目编号").setCellText(table, 8, 0, "文档备注");
    }
    
    /**
     * 创建修改记录
     *
     * @param docx 文档对象
     */
    private static void createModifyRecords(final XWPFDocument docx) {
        XWPFTable table = helper.createTable(docx, 8, 7, 2.43f, 0.7f);
        helper.setTableStyle(table, STYLE_TABLE_CONTENT_LEFT).setTableHeader(table, 1)
            .setRowAlign(table, 0, VAlign.CENTER, null).setRowBackground(table, 0, "F3F3F3")
            .setColsWidth(table, new float[] { 2.43f, 3.42f, 2.43f, 2.43f, 1.93f, 1.93f, 2.43f });
        String[] titles = { "修订人", "修订内容摘要", "产生版本", "修订日期 ", "审核人", "批准人", "批准时间" };
        String[] contents = { "",
            "1.“5.2”部分的编制说明，增加关于数据安全方面描述的说明\r\n2.“业务活动”统一为“流程节点”\r\n“流程接口”统一为“关联关系”\r\n3.对角色、流程节点和关联关系进行了定义", "",
            "2013年10月15日 ", "", "", "" };
        for (int i = 0; i < 7; i++) {
            helper.setCellText(table, 0, i, titles[i]).setCellText(table, 1, i, contents[i]);
        }
    }
    
    /**
     * 综述
     *
     * @param docx 文档对象
     */
    private static void createSummarize(final XWPFDocument docx) {
        helper
            .createParagraphTitle(docx, "综述", 1)
            .createParagraphTitle(docx, "规范性引用资料", 2)
            .createParagraphTitle(docx, "管理规定", 3)
            .createTextParagraph(docx, "《南方电网安全生产规定》（Q/CSG    ）")
            .createParagraphTitle(docx, "技术标准", 3)
            .createTextParagraph(
                docx,
                "国务院第599号令 《电力安全事故应急处置和调查处理条例》\r\n" + "《电力系统安全稳定导则》（DL 755-2001）\r\n"
                    + "《电力系统安全稳定控制技术导则》（DL/T723-2000）\r\n" + "《发电企业设备检修导则》（DL/T 838-2003）\r\n"
                    + "《南方电网安全稳定计算分析导则》（Q/CSG 11004）\r\n" + "《中国南方电网电力调度管理规程》（Q/CSG 2 1003-2008）")
            .createParagraphTitle(docx, "作业标准", 3)
            .createTextParagraph(
                docx,
                "《南方电网运行方式编制规范》（Q/CSG110021-2012）\r\n" + "《南方电网年度运行方式编制业务指导书》\r\n" + "《南方电网月度运行方式编制业务指导书》\r\n"
                    + "《南方电网日运行方式编制业务指导书》\r\n" + "《南方电网年度系统运行计划编制业务指导书》\r\n" + "《南方电网迎峰度夏方案编制业务指导书》")
            .createParagraphTitle(docx, "术语", 2)
            .createParagraphTitle(docx, "统调机组", 3)
            .createTextParagraph(docx, "南方电网四级调度机构直接调度管理的机组。")
            .createParagraphTitle(docx, "统调负荷", 3)
            .createTextParagraph(docx, "调度机构所管辖电网所有统调机组总发电出力与所辖电网受入（或送出）电力之和（或之差）。")
            .createParagraphTitle(docx, "统调发受电量", 3)
            .createTextParagraph(docx, "调度机构所管辖电网所有统调机组总发电量与所辖电网受入（或送出）电量之和（或之差）。")
            .createParagraphTitle(docx, "减扣容量", 3)
            .createTextParagraph(docx,
                "除计划检修外的其他因素导致的机组不可用或可用能力降低。主要考虑因缺燃料火电停机或发不满，因来水少或水头低、机组或辅机原因、综合利用原因、风电场受风力影响等原因导致机组出力下降以及可能出现的机组临时停运、网络受限等。")
            .createParagraphTitle(docx, "机组平均检修容量", 3)
            .createTextParagraph(docx, "机组平均检修容量为各机组在统计（或预测）时间段内检修天数与机组容量的乘积除以统计期的天数。")
            .createParagraphTitle(docx, "系统运行计划", 3)
            .createTextParagraph(docx, "为实现系统“安全、优质、经济、环保”运行、促进各项系统运行工作有序开展而制定的与系统运行相关的各类指标、计划及方案。包括年度系统运行计划及各类运行方式。")
            .createParagraphTitle(docx, "业务流程清单", 2);
        XWPFTable flowlist = helper.createTable(docx, 8, 9, 1.4f, 1.93f);
        helper.setTableStyle(flowlist, STYLE_TABLE_CONTENT_LEFT).setTableHeader(flowlist, 1)
            .setTableCellsAlign(flowlist, VAlign.CENTER, null).setColWidth(flowlist, 5, 1.0f)
            .setColWidth(flowlist, 7, 6.0f).setColWidth(flowlist, 5, 1.0f);
        String[] flowListTitles = { "一级业务", "二级业务", "业务事项", "管控策略", "统一规范策略", "流程编码", "业务流程", "流程定义", "IT实现" };
        for (int i = 0; i < flowListTitles.length; i++) {
            helper.setCellText(flowlist, 0, i, flowListTitles[i]);
        }
        List<Map<String, String>> flowListData = loadData("flowlist");
        if (flowListData != null) {
            int rowIndex;
            for (int i = 0; i < flowListData.size(); i++) {
                rowIndex = i + 1;
                Map<String, String> data = flowListData.get(i);
                
                helper.setCellText(flowlist, rowIndex, 0, data.get("biz1"))
                    .setCellText(flowlist, rowIndex, 1, data.get("biz2"))
                    .setCellText(flowlist, rowIndex, 2, data.get("matter"))
                    .setCellText(flowlist, rowIndex, 3, data.get("m_strategy"))
                    .setCellText(flowlist, rowIndex, 4, data.get("u_strategy"))
                    .setCellText(flowlist, rowIndex, 5, data.get("flowcode"))
                    .setCellText(flowlist, rowIndex, 6, data.get("flowname"))
                    .setCellText(flowlist, rowIndex, 7, data.get("flowdefined"))
                    .setCellText(flowlist, rowIndex, 8, data.get("it_imp"));
            }
        }
        // 根据内容合并指定的列
        helper.mergeSameContentRowVertically(flowlist, 0, 1).mergeSameContentRowVertically(flowlist, 1, 1)
            .mergeSameContentRowVertically(flowlist, 2, 1);
        helper.createParagraphTitle(docx, "业务流程和流程节点清单", 2);
        List<Map<String, String>> nodeListData = loadData("nodelist");
        int rowNum = nodeListData == null || nodeListData.size() == 0 ? 1 : nodeListData.size() + 1;
        XWPFTable nodelist = helper.createTable(docx, rowNum, 3, 6.63f, 0.8f);
        helper.setTableStyle(nodelist, STYLE_TABLE_CONTENT_LEFT).setTableHeader(nodelist, 1)
            .setTableCellsAlign(nodelist, VAlign.CENTER, null)
            .setColsWidth(nodelist, new float[] { 6.63f, 7.82f, 1.93f });
        String[] nodeListTitles = { "业务流程编码和名称", "流程节点", "序号" };
        for (int i = 0; i < nodeListTitles.length; i++) {
            helper.setCellText(nodelist, 0, i, nodeListTitles[i]);
        }
        if (nodeListData != null) {
            int rowIndex;
            for (int i = 0; i < nodeListData.size(); i++) {
                rowIndex = i + 1;
                Map<String, String> data = nodeListData.get(i);
                
                helper.setCellText(nodelist, rowIndex, 0, data.get("codeOrName"))
                    .setCellText(nodelist, rowIndex, 1, data.get("flowNode"))
                    .setCellText(nodelist, rowIndex, 2, data.get("nodeSeq"));
            }
        }
        helper.mergeSameContentRowVertically(nodelist, 0, 1);
        // helper.createPageBreak(docx);
    }
    
    /**
     * 创建业务事项设计
     *
     * @param docx 文档对象
     */
    private static void createBizMatterDesign(XWPFDocument docx) {
        helper.createParagraphTitle(docx, "业务事项设计", 1);
        int itemSize = 15;
        for (int i = 0; i < itemSize; i++) {
            createBizMatterDesignContent(docx);
        }
    }
    
    /**
     * 创建业务事项设计内容
     *
     * @param docx 文档对象
     */
    private static void createBizMatterDesignContent(XWPFDocument docx) {
        helper
            .createParagraphTitle(docx, "年季月运行方式管理", 2)
            .createParagraphTitle(docx, "业务说明", 3)
            .createTextParagraph(docx,
                "编制电网年度、季度、月度运行方式, 编制电网调度运行方式，统筹安排未来电力供应，安排发输变配电设备检修停电计划、评估安全稳定水平、揭示电网的存在风险、提出停电方式安排、保证电力供应和电网安全的风险管控措施等。")
            .createParagraphTitle(docx, "适用范围", 3);
        List<Map<String, String>> scopeRoleListData = loadData("scope_roles");
        int colNum = scopeRoleListData == null || scopeRoleListData.size() == 0 ? 1 : scopeRoleListData.size() + 1;
        XWPFTable scopeRolelist = helper.createTable(docx, 2, colNum, 3.28f, 1.05f);
        helper.setTableStyle(scopeRolelist, STYLE_TABLE_CONTENT_LEFT).setTableHeader(scopeRolelist, 1)
            .setColStyle(scopeRolelist, 0, STYLE_TABLE_TITLE).setTableCellsAlign(scopeRolelist, VAlign.CENTER, null);
        int colIndex;
        helper.setCellText(scopeRolelist, 0, 0, "适用层级").setCellText(scopeRolelist, 1, 0, "角色（岗位）");
        for (int i = 0; scopeRoleListData != null && i < scopeRoleListData.size(); i++) {
            colIndex = i + 1;
            Map<String, String> data = scopeRoleListData.get(i);
            helper.setCellText(scopeRolelist, 0, colIndex, data.get("level")).setCellText(scopeRolelist, 1, colIndex,
                data.get("roles"));
        }
        List<ItemCode> cruces = loadListData("cruces");
        helper
            .createParagraphTitle(docx, "引用文件", 3)
            .createTextParagraph(
                docx,
                "国务院第599号令 《电力安全事故应急处置和调查处理条例》\r\n《电力系统安全稳定导则》（DL 755-2001）\r\n《电力系统安全稳定控制技术导则》（DL/T723-2000）\r\n《发电企业设备检修导则》（DL/T 838-2003）\r\n《南方电网安全稳定计算分析导则》（Q/CSG 11004）\r\n《中国南方电网电力调度管理规程》（Q/CSG 2 1003-2008）\r\n《南方电网运行方式编制规范》（Q/CSG110021-2012）\r\n《南方电网安全生产规定》（Q/CSG    ）")
            .createParagraphTitle(docx, "管理要点", 3).createParagraphWithItemCodes(docx, cruces, true)
            .createParagraphTitle(docx, "业务流程清单", 3);
        List<Map<String, String>> yqmommListData = loadData("yqmomm");
        int rowNum = yqmommListData == null || yqmommListData.size() == 0 ? 1 : yqmommListData.size() + 1;
        String[] yqmommListTitles = { "业务事项", " 流程编码", "业务流程名称", "流程定义" };
        XWPFTable yqmommList = helper.createTable(docx, rowNum, 4, 2.73f, 0.7f);
        helper.setTableStyle(yqmommList, STYLE_TABLE_CONTENT_LEFT).setTableHeader(yqmommList, 1)
            .setTableCellsAlign(yqmommList, VAlign.CENTER, null)
            .setColsWidth(yqmommList, new float[] { 2.73f, 2.73f, 3.68f, 7.61f });
        for (int i = 0; i < yqmommListTitles.length; i++) {
            helper.setCellText(yqmommList, 0, i, yqmommListTitles[i]);
        }
        if (yqmommListData != null) {
            int rowIndex;
            for (int i = 0; i < yqmommListData.size(); i++) {
                rowIndex = i + 1;
                Map<String, String> data = yqmommListData.get(i);
                helper.setCellText(yqmommList, rowIndex, 0, data.get("item"))
                    .setCellText(yqmommList, rowIndex, 1, data.get("code"))
                    .setCellText(yqmommList, rowIndex, 2, data.get("name"))
                    .setCellText(yqmommList, rowIndex, 3, data.get("defined"));
            }
        }
        List<ItemCode> jobReqList = loadListData("job_reqired");
        List<ItemCode> jobContList = loadListData("job_content");
        helper
            .mergeSameContentRowVertically(yqmommList, 0, 1)
            .createParagraphTitle(docx, "年运行方式制定流程", 3)
            .createParagraphTitle(docx, "流程定义", 4)
            .createTextParagraph(docx,
                "编制电网年度运行方式，统筹安排未来电力供应，安排发输变配电设备检修停电计划、评估安全稳定水平、揭示电网的存在风险、提出停电方式安排、保证电力供应和电网安全的风险管控措施等。")
            .createParagraphTitle(docx, "工作要求", 4).createParagraphWithItemCodes(docx, jobReqList, true)
            .createParagraphTitle(docx, "工作内容", 4)
            .createTextParagraph(docx, "电网年度运行方式应符合《南方电网运行方式编制规范》要求并至少包括以下内容，各省公司可在以下内容基础上根据需要进一步细化本省年度运行方式编制内容")
            .createParagraphWithItemCodes(docx, jobContList, true).createParagraphTitle(docx, "业务流程图", 4);
        List<EmbedObject> ymmdFiles = loadYmmdEmebdedFiles();
        try {
            for (EmbedObject ymmd : ymmdFiles) {
                helper.createFileObject(docx, ymmd);
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        List<Map<String, String>> ymmdNodeListData = loadData("yqmm_nodelist");
        rowNum = ymmdNodeListData == null || ymmdNodeListData.size() == 0 ? 1 : ymmdNodeListData.size() + 1;
        XWPFTable yqmmNodeList = helper.createParagraphTitle(docx, "流程节点清单", 4).createTable(docx, rowNum, 11, 0.86f,
            0.7f);
        helper
            .setTableStyle(yqmmNodeList, STYLE_TABLE_CONTENT_LEFT)
            .setTableHeader(yqmmNodeList, 1)
            .setTableCellsAlign(yqmmNodeList, VAlign.CENTER, null)
            .setColsWidth(yqmmNodeList,
                new float[] { 0.86f, 1.92f, 1.58f, 2.49f, 1.32f, 1.32f, 1.32f, 1.32f, 1.32f, 1.32f, 1.32f });
        String[] yqmmNodeListTitles = { "编码", "流程节点", "涉及角色", "层级关系", "关键业务节点", "核心管控节点", "一般管控节点", "IT实现", "风险点",
            "制度条款", "备注" };
        for (int i = 0; i < yqmmNodeListTitles.length; i++) {
            helper.setCellText(yqmmNodeList, 0, i, yqmmNodeListTitles[i]);
        }
        if (ymmdNodeListData != null) {
            int rowIndex;
            for (int i = 0; i < ymmdNodeListData.size(); i++) {
                rowIndex = i + 1;
                Map<String, String> data = ymmdNodeListData.get(i);
                helper.setCellText(yqmmNodeList, rowIndex, 0, data.get("code"))
                    .setCellText(yqmmNodeList, rowIndex, 1, data.get("node"))
                    .setCellText(yqmmNodeList, rowIndex, 2, data.get("role"))
                    .setCellText(yqmmNodeList, rowIndex, 3, data.get("level"))
                    .setCellText(yqmmNodeList, rowIndex, 4, data.get("keyNode"))
                    .setCellText(yqmmNodeList, rowIndex, 5, data.get("coreNode"))
                    .setCellText(yqmmNodeList, rowIndex, 6, data.get("generalNode"))
                    .setCellText(yqmmNodeList, rowIndex, 7, data.get("it_imp"))
                    .setCellText(yqmmNodeList, rowIndex, 8, data.get("risk"))
                    .setCellText(yqmmNodeList, rowIndex, 9, data.get("term"))
                    .setCellText(yqmmNodeList, rowIndex, 10, data.get("remark"));
            }
        }
    }
    
    /**
     * 加载列表数据
     * 
     * @param name 列表名称
     * @return 列表数据
     */
    private static List<ItemCode> loadListData(final String name) {
        List<ItemCode> items = new ArrayList<Style.ItemCode>();
        ClassLoader loader = Thread.currentThread().getContextClassLoader();
        InputStream input = null;
        String data;
        ItemCode item;
        try {
            input = loader.getResourceAsStream("data/" + name + ".lst");
            data = IOUtils.toString(input);
            if (StringUtils.isNotEmpty(data)) {
                String[] parts = data.split("\r\n");
                for (String part : parts) {
                    if (StringUtils.isNotBlank(part)) {
                        item = new ItemCode(part, ItemType.NUMBERING, 0, NumberStyle.DECIMAL_BRACKET);
                        items.add(item);
                    }
                }
            }
        } catch (Exception e) {
            e.printStackTrace();
        } finally {
            IOUtils.closeQuietly(input);
        }
        return items;
    }
    
    /**
     * 加载运行方式管理插入文件
     * 
     * @return 插入文件
     */
    public static List<EmbedObject> loadYmmdEmebdedFiles() {
        List<EmbedObject> lst = new ArrayList<EmbedObject>();
        ClassLoader loader = Thread.currentThread().getContextClassLoader();
        URL ymmd0PreURL = loader.getResource("workflow/ymmd0.emf");
        URL ymmd0VsdURL = loader.getResource("workflow/ymmd0.vsd");
        EmbedObject ymmd0 = new EmbedObject(urlToPath(ymmd0VsdURL), EmbedType.VSD, new Graphic(urlToPath(ymmd0PreURL),
            16.48f, 11.38f));
        lst.add(ymmd0);
        URL ymmd1PreURL = loader.getResource("workflow/ymmd1.emf");
        URL ymmd1VsdURL = loader.getResource("workflow/ymmd1.vsd");
        EmbedObject ymmd1 = new EmbedObject(urlToPath(ymmd1VsdURL), EmbedType.VSD, new Graphic(urlToPath(ymmd1PreURL),
            15.9f, 11.27f));
        lst.add(ymmd1);
        URL ymmd2PreURL = loader.getResource("workflow/ymmd2.emf");
        URL ymmd2VsdURL = loader.getResource("workflow/ymmd2.vsd");
        EmbedObject ymmd2 = new EmbedObject(urlToPath(ymmd2VsdURL), EmbedType.VSD, new Graphic(urlToPath(ymmd2PreURL),
            16.48f, 9.74f));
        lst.add(ymmd2);
        return lst;
    }
    
    /**
     * 加载数据
     *
     * @param name 名称
     * @return 数据
     */
    public static List<Map<String, String>> loadData(String name) {
        ClassLoader loader = Thread.currentThread().getContextClassLoader();
        List<Map<String, String>> data = null;
        InputStream input = null;
        try {
            input = loader.getResourceAsStream("data/" + name + ".json");
            ObjectMapper mapper = new ObjectMapper();
            data = mapper.readValue(input, new TypeReference<List<Map<String, String>>>() {
                // do nothing;
            });
        } catch (Exception e) {
            e.printStackTrace();
        } finally {
            IOUtils.closeQuietly(input);
        }
        return data;
    }
}
