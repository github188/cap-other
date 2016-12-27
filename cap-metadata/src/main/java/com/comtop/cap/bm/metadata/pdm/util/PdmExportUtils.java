/******************************************************************************
 * Copyright (C) 2014 ShenZhen ComTop Information Technology Co.,Ltd
 * All Rights Reserved.
 * 本软件为深圳康拓普开发研制。未经本公司正式书面同意，其他任何个人、团体不得使用、
 * 复制、修改或发布本软件.
 *****************************************************************************/

package com.comtop.cap.bm.metadata.pdm.util;

import java.io.File;
import java.io.FileOutputStream;
import java.io.IOException;
import java.net.URL;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.Iterator;
import java.util.List;
import java.util.Map;
import java.util.UUID;

import org.dom4j.Document;
import org.dom4j.DocumentException;
import org.dom4j.Element;
import org.dom4j.io.OutputFormat;
import org.dom4j.io.SAXReader;
import org.dom4j.io.XMLWriter;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;

import com.comtop.cap.bm.metadata.database.dbobject.model.ColumnVO;
import com.comtop.cap.bm.metadata.database.dbobject.model.IndexColumnVO;
import com.comtop.cap.bm.metadata.database.dbobject.model.ReferenceJoinVO;
import com.comtop.cap.bm.metadata.database.dbobject.model.ReferenceVO;
import com.comtop.cap.bm.metadata.database.dbobject.model.TableIndexVO;
import com.comtop.cap.bm.metadata.database.dbobject.model.TableVO;
import com.comtop.cap.bm.metadata.database.dbobject.model.ViewColumnVO;
import com.comtop.cap.bm.metadata.database.dbobject.model.ViewVO;
import com.comtop.cap.bm.metadata.pdm.model.PdmReferanceSymbolVO;
import com.comtop.cap.bm.metadata.pdm.model.PdmTableSymbolVO;
import com.comtop.cap.bm.metadata.pdm.model.PdmVO;
import com.comtop.cap.bm.metadata.pdm.model.PdmViewSymbolVO;
import com.comtop.top.component.app.session.HttpSessionUtil;
import com.comtop.top.core.util.StringUtil;

/**
 * PDM导入帮助类
 * 
 * 
 * @author 陈志伟
 * @since 1.0
 * @version 2015-10-12 陈志伟
 */
public class PdmExportUtils {
    
    /** 日志 */
    private final static Logger LOG = LoggerFactory.getLogger(PdmExportUtils.class);
    
    /** 表集合 */
    private Map<String, String> objMapTable = new HashMap<String, String>();
    
    /** 表元素集合 */
    private Map<String, String> objMapTableSymbol = new HashMap<String, String>();
    
    /** 主键集合 */
    private Map<String, String> objMapPrimaryKey = new HashMap<String, String>();
    
    /** 主键字段集合 */
    private Map<String, String> objMapPrimaryColumn = new HashMap<String, String>();
    
    /** 外键字段集合 */
    private Map<String, String> objMapForeignColumn = new HashMap<String, String>();
    
    /** 字段集合 */
    private Map<String, String> objMapColumn = new HashMap<String, String>();
    
    /** Pdm实体 */
    private PdmVO pdm = new PdmVO();
    
    /**
     * 构造函数
     * 
     * @param pdmVO pdmVO
     * 
     */
    public PdmExportUtils(PdmVO pdmVO) {
        this.pdm = pdmVO;
    }
    
    /**
     * 导出PDM文件
     * 
     * 
     * @return PDM文件路径
     * @throws Exception Exception
     */
    public String exportPdm() throws Exception {
        // 读取pdm文件
        SAXReader objReader = new SAXReader();
        URL url = getResourcePath("Pdm.xml");
        Document objDocument = objReader.read(url);
        // 获取根节点
        Element objRoot = objDocument.getRootElement();
        objRoot.addNamespace("a", "attribute");
        objRoot.addNamespace("c", "collection");
        objRoot.addNamespace("o", "object");
        // 获取model节点
        Element objModel = (Element) objRoot.selectSingleNode("//c:Children/o:Model");
        
        // 导出表
        exportPDMTable(objModel);
        // 导出关联关系
        exportPDMReference(objModel);
        // 最后导出视图
        exportPDMView(objModel);
        
        // 保存文件
        String strPdmPath = PdmUtils.createTmpFileDir() + File.separator + pdm.getCode() + "-" +  System.currentTimeMillis() + ".pdm";
        File objFile = new File(strPdmPath);
        write(objFile, objDocument);
        return strPdmPath;
    }
    
    /**
     * 将PDM文档写入文件
     * 
     * @param targetFile 目标文件
     * @param document PDM文档
     *
     */
    private void write(File targetFile, Document document) {
        FileOutputStream fileOutputStream = null;
        XMLWriter output = null;
        try {
            OutputFormat format = OutputFormat.createPrettyPrint();// 格式化
            fileOutputStream = new FileOutputStream(targetFile);
            output = new XMLWriter(fileOutputStream, format); //
            output.write(document);
            output.flush();
        } catch (IOException e) {
            LOG.error("写文件时出现IO异常", e);
        } finally {
            if (fileOutputStream != null) {
                try {
                    fileOutputStream.close();
                } catch (IOException e) {
                    LOG.error("写文件时出现IO异常", e);
                }
            }
            if (output != null) {
                try {
                    output.close();
                } catch (IOException e) {
                    LOG.error("写文件时出现IO异常", e);
                }
            }
        }
    }
    
    /**
     * 添加元素
     * 
     * @param parent parent
     * @param name 名称
     * @param value 值
     */
    private void addElement(Element parent, String name, String value) {
        if (StringUtil.isNotBlank(value)) {
            Element objElement = parent.addElement(name);
            objElement.setText(value);
        }
    }
    
    /**
     * 获取UUID
     *
     * @return UUID
     */
    private String getUUID() {
        UUID uuid = UUID.randomUUID();
        return uuid.toString().replace('-', '_').toUpperCase();
    }
    
    /**
     * 获取模板资源路径
     * 
     * @param fileName 文件名称
     *
     * @return 文件路径URL
     */
    private URL getResourcePath(String fileName) {
        return Thread.currentThread().getContextClassLoader().getResource("com/comtop/cap/bm/metadata/pdm/" + fileName);
    }
    
    // ///////////////////////////////////*** 导出表 ***//////////////////////////////////////////////////////////////
    
    /**
     * 导出表
     * 
     * @param node Element
     * @throws DocumentException DocumentException
     */
    private void exportPDMTable(Element node) throws DocumentException {
        Element objTable = (Element) node.selectSingleNode("c:Tables");
        List<TableVO> lstTableVO = pdm.getTables();
        if (lstTableVO != null && lstTableVO.size() > 0) {
            SymbolHelper.revert();
            for (TableVO tableVO : lstTableVO) {
                exportTable(objTable, tableVO);
                exportTableSymbol(node, tableVO);
            }
        }
    }
    
    /**
     * 导出表
     *
     * @param parent parent
     * @param tableVO tableVO 表实体
     * @return 表ID
     */
    private String exportTable(Element parent, TableVO tableVO) {
        Element objTableElement = parent.addElement("o:Table");
        String strTableId = AtomicIntegerUtils.getLocalID();
        tableVO.setId(strTableId);
        objTableElement.addAttribute("Id", strTableId);
        addElement(objTableElement, "a:ObjectID", getUUID());
        addElement(objTableElement, "a:Name", tableVO.getChName());
        addElement(objTableElement, "a:Code", tableVO.getEngName());
        addElement(objTableElement, "a:CreationDate", System.currentTimeMillis() + "");
        addElement(objTableElement, "a:Creator", (String) HttpSessionUtil.getCurUserProperty("employeeName"));
        addElement(objTableElement, "a:ModificationDate", System.currentTimeMillis() + "");
        addElement(objTableElement, "a:Modifier", (String) HttpSessionUtil.getCurUserProperty("employeeName"));
        addElement(objTableElement, "a:Comment", tableVO.getDescription());
        // 导出表字段
        List<ColumnVO> lstTableColumnVO = tableVO.getColumns();
        List<String> lstPrimaryKey = new ArrayList<String>();
        // 导出表字段
        if (lstTableColumnVO != null && lstTableColumnVO.size() > 0) {
            for (ColumnVO columnVO : lstTableColumnVO) {
                String strColumnId = exportTableColumn(objTableElement, columnVO, tableVO);
                if (columnVO.getIsPrimaryKEY()) {
                    lstPrimaryKey.add(strColumnId);
                }
            }
            // 导出键
            String strPrimaryKey = exportKey(objTableElement, lstPrimaryKey);
            // 导出主键
            exportPrimaryKey(objTableElement, strPrimaryKey);
            objMapPrimaryKey.put(tableVO.getCode(), strPrimaryKey);
            lstPrimaryKey = new ArrayList<String>();
        }
        // 导出索引
        List<TableIndexVO> lstTableIndexVO = tableVO.getIndexs();
        if (lstTableIndexVO != null && lstTableIndexVO.size() > 0) {
            for (TableIndexVO tableIndexVO : lstTableIndexVO) {
                exportTableIndex(objTableElement, tableIndexVO);
            }
        }
        objMapTable.put(tableVO.getCode(), strTableId);
        return strTableId;
    }
    
    /**
     * 导出表字段
     *
     * @param parent parent
     * @param columnVO 字段信息
     * @param tableVO 表实体
     * @return 字段ID
     */
    private String exportTableColumn(Element parent, ColumnVO columnVO, TableVO tableVO) {
        Element objColumnsElement = parent.addElement("c:Columns");
        Element objTableColumnElement = objColumnsElement.addElement("o:Column");
        String strColumnId = AtomicIntegerUtils.getLocalID();
        objTableColumnElement.addAttribute("Id", strColumnId);
        addElement(objTableColumnElement, "a:ObjectID", getUUID());
        addElement(objTableColumnElement, "a:Name", columnVO.getChName());
        addElement(objTableColumnElement, "a:Code", columnVO.getEngName());
        addElement(objTableColumnElement, "a:CreationDate", System.currentTimeMillis() + "");
        addElement(objTableColumnElement, "a:Creator", (String) HttpSessionUtil.getCurUserProperty("employeeName"));
        addElement(objTableColumnElement, "a:ModificationDate", System.currentTimeMillis() + "");
        addElement(objTableColumnElement, "a:Modifier", (String) HttpSessionUtil.getCurUserProperty("employeeName"));
        String dataType = columnVO.getDataType();
        int len = columnVO.getLength();
        addElement(objTableColumnElement, "a:DataType", convertDataType(dataType, len));
        addElement(objTableColumnElement, "a:Comment", columnVO.getDescription());
        addElement(objTableColumnElement, "a:Length", columnVO.getLength() + "");
        addElement(objTableColumnElement, "a:Precision", columnVO.getPrecision() + "");
        addElement(objTableColumnElement, "a:DefaultValue", columnVO.getDefaultValue());
        addElement(objTableColumnElement, "a:Mandatory", (columnVO.getCanBeNull() ? 0 : 1) + "");
        // 缓存主键
        if (columnVO.getIsPrimaryKEY()) {
            objMapPrimaryColumn.put(tableVO.getCode() + "_" + columnVO.getCode(), strColumnId);
        }
        // 缓存外键
        if (columnVO.getIsForeignKey()) {
            objMapForeignColumn.put(tableVO.getCode() + "_" + columnVO.getCode(), strColumnId);
        }
        // 缓存字段
        objMapColumn.put(tableVO.getCode() + "_" + columnVO.getCode(), strColumnId);
        return strColumnId;
    }
    
	/**
	 * 转换数据类型
	 * 
	 * @param dataType
	 *            数据类型
	 * @param len
	 *            数据长度
	 * @return pdm正确的数据类型
	 */
	private String convertDataType(String dataType, int len) {
		if (dataType.toUpperCase().startsWith("VARCHAR")
				|| dataType.toUpperCase().startsWith("CHAR")
				|| dataType.toUpperCase().startsWith("NVARCHAR")) {
			if (len > 0) {
				return dataType + "(" + len + ")";
			}
		}

		return dataType;
	}
    
    /**
     * 导出索引
     * 
     * @param parent parent
     * @param tableIndexVO 表索引信息
     */
    private void exportTableIndex(Element parent, TableIndexVO tableIndexVO) {
        Element objTableIndexElement = parent.addElement("c:Indexes");
        Element objIndexElement = objTableIndexElement.addElement("o:Index");
        String strIndexId = AtomicIntegerUtils.getLocalID();
        objIndexElement.addAttribute("Id", strIndexId);
        addElement(objIndexElement, "a:ObjectID", getUUID());
        addElement(objIndexElement, "a:Name", tableIndexVO.getChName());
        addElement(objIndexElement, "a:Code", tableIndexVO.getEngName());
        addElement(objIndexElement, "a:CreationDate", System.currentTimeMillis() + "");
        addElement(objIndexElement, "a:Creator", (String) HttpSessionUtil.getCurUserProperty("employeeName"));
        addElement(objIndexElement, "a:ModificationDate", System.currentTimeMillis() + "");
        addElement(objIndexElement, "a:Modifier", (String) HttpSessionUtil.getCurUserProperty("employeeName"));
        addElement(objIndexElement, "a:Unique", (tableIndexVO.isUnique() ? 1 : "") + "");
        for (IndexColumnVO indexColumnVO : tableIndexVO.getColumns()) {
            exportIndexColumn(objIndexElement, indexColumnVO);
        }
    }
    
    /**
     * 导出索引字段
     * 
     * @param parent parent
     * @param indexColumnVO 索引字段
     */
    private void exportIndexColumn(Element parent, IndexColumnVO indexColumnVO) {
        Element objColumnsElement = parent.addElement("c:IndexColumns");
        Element objIndexColumnElement = objColumnsElement.addElement("o:IndexColumn");
        String strViewId = AtomicIntegerUtils.getLocalID();
        objIndexColumnElement.addAttribute("Id", strViewId);
        addElement(objIndexColumnElement, "a:ObjectID", getUUID());
        addElement(objIndexColumnElement, "a:CreationDate", System.currentTimeMillis() + "");
        addElement(objIndexColumnElement, "a:Creator", (String) HttpSessionUtil.getCurUserProperty("employeeName"));
        addElement(objIndexColumnElement, "a:ModificationDate", System.currentTimeMillis() + "");
        addElement(objIndexColumnElement, "a:Modifier", (String) HttpSessionUtil.getCurUserProperty("employeeName"));
        addElement(objIndexColumnElement, "a:Ascending", indexColumnVO.getAscending());
        addElement(objIndexColumnElement, "a:IndexColumn.Expression", indexColumnVO.getExpression());
        ColumnVO columnVO = indexColumnVO.getColumn();
        if(columnVO != null) {
            Element objElement = objIndexColumnElement.addElement("c:Column");
            Element objOColumnElement = objElement.addElement("o:Column");
            String strColumnId = objMapColumn.get(columnVO.getTableCode() + "_" + columnVO.getCode());
            objOColumnElement.addAttribute("Ref", strColumnId);
        }
    }
    
    /**
     * 导出主键
     * 
     * @param tableElement tableElement
     * @param strPrimaryKey 主键ID
     */
    private void exportPrimaryKey(Element tableElement, String strPrimaryKey) {
        Element objKeysElement = tableElement.addElement("c:PrimaryKey");
        Element objKeyElement = objKeysElement.addElement("o:Key");
        objKeyElement.addAttribute("Ref", strPrimaryKey);
    }
    
    /**
     * 导出键
     * 
     * @param tableElement tableElement
     * @param lstPrimaryKey 主键字段
     * @return 键ID
     */
    private String exportKey(Element tableElement, List<String> lstPrimaryKey) {
        Element objKeysElement = tableElement.addElement("c:Keys");
        Element objKeyElement = objKeysElement.addElement("o:Key");
        String strKeyId = AtomicIntegerUtils.getLocalID();
        objKeyElement.addAttribute("Id", strKeyId);
        addElement(objKeyElement, "a:ObjectID", getUUID());
        addElement(objKeyElement, "a:Name", "Key_1");
        addElement(objKeyElement, "a:Code", "Key_1");
        addElement(objKeyElement, "a:CreationDate", System.currentTimeMillis() + "");
        addElement(objKeyElement, "a:Creator", (String) HttpSessionUtil.getCurUserProperty("employeeName"));
        addElement(objKeyElement, "a:ModificationDate", System.currentTimeMillis() + "");
        addElement(objKeyElement, "a:Modifier", (String) HttpSessionUtil.getCurUserProperty("employeeName"));
        Element objKeyColumnElement = objKeyElement.addElement("c:Key.Columns");
        for (String primaryKey : lstPrimaryKey) {
            Element objElement = objKeyColumnElement.addElement("o:Column");
            objElement.addAttribute("Ref", primaryKey);
        }
        return strKeyId;
    }
    
    /**
     * 导出表的位置信息
     * 
     * @param node node
     * @param tableVO 表信息
     * @throws DocumentException DocumentException
     */
    private void exportTableSymbol(Element node, TableVO tableVO) throws DocumentException {
        Element objTableSymbol = (Element) node.selectSingleNode("c:PhysicalDiagrams/o:PhysicalDiagram/c:Symbols");
        // 读取pdm文件
        SAXReader objReader = new SAXReader();
        Document objDocument = objReader.read(getResourcePath("TableSymbol.xml"));
        Element objRoot = objDocument.getRootElement();
        Element objModel = (Element) objRoot.selectSingleNode("//c:Children/o:Model/o:TableSymbol");
        SymbolHelper objSymbolHelper = SymbolHelper.getInstance();
        PdmTableSymbolVO pdmTableSymbolVO = objSymbolHelper.getTableSymbol(tableVO);
        objModel.addAttribute("Id", pdmTableSymbolVO.getId());
        Element rectElement = (Element)objModel.selectSingleNode("//a:Rect");
        rectElement.setText(pdmTableSymbolVO.toString());

        Element objRefView = (Element) objModel.selectSingleNode("//c:Object/o:Table");
        objRefView.addAttribute("Ref", pdmTableSymbolVO.getRefTableId());
        objTableSymbol.add((Element) objModel.clone());
        objMapTableSymbol.put(tableVO.getCode(), pdmTableSymbolVO.getId());
    }
    
    // ///////////////////////////////////*** 导出表关联关系 ***///////////////////////////////////////////////////////
    
    /**
     * 导出关联关系
     * 
     * @param node Element
     * @throws DocumentException DocumentException
     */
    private void exportPDMReference(Element node) throws DocumentException {
        Element objReference = (Element) node.selectSingleNode("c:References");
        List<TableVO> lstTableVO = pdm.getTables();
        if (lstTableVO != null && lstTableVO.size() > 0) {
            // 导出关联关系
            for (TableVO tableVO : lstTableVO) {
                List<ReferenceVO> lstReferenceVO = tableVO.getReferences();
                if (lstReferenceVO != null && lstReferenceVO.size() > 0) {
                    for (ReferenceVO referenceVO : lstReferenceVO) {
                        String strReferenceId = exportReference(objReference, referenceVO, tableVO);
                        exportReferenceSymbol(node, referenceVO, tableVO, strReferenceId);
                    }
                }
            }
        }
    }
    
    /**
     * 导出关联关系
     * 
     * @param parent Element
     * @param referenceVO referenceVO 关联关系实体
     * @param parentTableVO parentTableVO 父表实体
     * @return 关联关系ID
     */
    private String exportReference(Element parent, ReferenceVO referenceVO, TableVO parentTableVO) {
        Element objReferenceElement = parent.addElement("o:Reference");
        String strReferenceId = AtomicIntegerUtils.getLocalID();
        objReferenceElement.addAttribute("Id", strReferenceId);
        addElement(objReferenceElement, "a:ObjectID", getUUID());
        addElement(objReferenceElement, "a:Name", AtomicIntegerUtils.getReferenceName());
        addElement(objReferenceElement, "a:Code", AtomicIntegerUtils.getReferenceName());
        addElement(objReferenceElement, "a:CreationDate", System.currentTimeMillis() + "");
        addElement(objReferenceElement, "a:Creator", (String) HttpSessionUtil.getCurUserProperty("employeeName"));
        addElement(objReferenceElement, "a:ModificationDate", System.currentTimeMillis() + "");
        addElement(objReferenceElement, "a:Modifier", (String) HttpSessionUtil.getCurUserProperty("employeeName"));
        addElement(objReferenceElement, "a:UpdateConstraint", 1 + "");
        addElement(objReferenceElement, "a:DeleteConstraint", 1 + "");
        addElement(objReferenceElement, "a:Cardinality", referenceVO.getCardinality());//增加基数关联性
        
        Element objParentElement = objReferenceElement.addElement("c:ParentTable");
        Element objElement = objParentElement.addElement("o:Table");
        objElement.addAttribute("Ref", objMapTable.get(parentTableVO.getCode()));
        
        objParentElement = objReferenceElement.addElement("c:ChildTable");
        objElement = objParentElement.addElement("o:Table");
        objElement.addAttribute("Ref", objMapTable.get(referenceVO.getChildTable().getCode()));
        
        objParentElement = objReferenceElement.addElement("c:ParentKey");
        objElement = objParentElement.addElement("o:Key");
        objElement.addAttribute("Ref", objMapPrimaryKey.get(parentTableVO.getCode()));
        
        // 导出字段关联字段
        List<ReferenceJoinVO> lstReferenceJoinVO = referenceVO.getJoins();
        if (lstReferenceJoinVO != null && lstReferenceJoinVO.size() > 0) {
            for (ReferenceJoinVO referenceJoinVO : lstReferenceJoinVO) {
                exportReferenceJoin(objReferenceElement, referenceJoinVO, referenceVO, parentTableVO);
            }
        }
        return strReferenceId;
    }
    
    /**
     * 导出关联字段
     *
     * 
     * @param parent parent
     * @param referenceJoinVO referenceJoinVO 关联字段实体
     * @param referenceVO referenceVO 关联关系实体
     * @param parentTableVO parentTableVO 父表实体
     */
    private void exportReferenceJoin(Element parent, ReferenceJoinVO referenceJoinVO, ReferenceVO referenceVO,
        TableVO parentTableVO) {
        Element objJoinsElement = parent.addElement("c:Joins");
        Element objReferenceJoinElement = objJoinsElement.addElement("o:ReferenceJoin");
        String strKeyId = AtomicIntegerUtils.getLocalID();
        objReferenceJoinElement.addAttribute("Id", strKeyId);
        addElement(objReferenceJoinElement, "a:ObjectID", getUUID());
        addElement(objReferenceJoinElement, "a:CreationDate", System.currentTimeMillis() + "");
        addElement(objReferenceJoinElement, "a:Creator", (String) HttpSessionUtil.getCurUserProperty("employeeName"));
        addElement(objReferenceJoinElement, "a:ModificationDate", System.currentTimeMillis() + "");
        addElement(objReferenceJoinElement, "a:Modifier", (String) HttpSessionUtil.getCurUserProperty("employeeName"));
        Element objKeyColumnElement = objReferenceJoinElement.addElement("c:Object1");
        Element objElement = objKeyColumnElement.addElement("o:Column");
        objElement.addAttribute("Ref",
            objMapPrimaryColumn.get(parentTableVO.getCode() + "_" + referenceJoinVO.getParentTableColumnCode()));
        objKeyColumnElement = objReferenceJoinElement.addElement("c:Object2");
        objElement = objKeyColumnElement.addElement("o:Column");
        objElement.addAttribute(
            "Ref",
            objMapForeignColumn.get(referenceVO.getChildTable().getCode() + "_"
                + referenceJoinVO.getChildTableColumnCode()));
    }
    
    /**
     * 导出关联关系的位置信息
     * 
     * @param node node
     * @param referenceVO 关联关系实体
     * @param tableVO 表实体
     * @param strReferenceId 关联关系ID
     * @throws DocumentException DocumentException
     */
    private void exportReferenceSymbol(Element node, ReferenceVO referenceVO, TableVO tableVO, String strReferenceId)
        throws DocumentException {
        Element objReferenceSymbol = (Element) node.selectSingleNode("c:PhysicalDiagrams/o:PhysicalDiagram/c:Symbols");
        // 读取pdm文件
        SAXReader objReader = new SAXReader();
        Document objDocument = objReader.read(getResourcePath("ReferenceSymbol.xml"));
        Element objRoot = objDocument.getRootElement();
        String sourcId = objMapTableSymbol.get(referenceVO.getChildTable().getCode());
        String destinationId = objMapTableSymbol.get(tableVO.getCode());

        Element objModel = (Element) objRoot.selectSingleNode("//c:Children/o:Model/o:ReferenceSymbol");
        objModel.addAttribute("Id", AtomicIntegerUtils.getLocalID());
        Element objRefView = (Element) objModel.selectSingleNode("//c:SourceSymbol/o:TableSymbol");
        objRefView.addAttribute("Ref", sourcId);
        objRefView = (Element) objModel.selectSingleNode("//c:DestinationSymbol/o:TableSymbol");
        objRefView.addAttribute("Ref", destinationId);
        objRefView = (Element) objModel.selectSingleNode("//c:Object/o:Reference");
        objRefView.addAttribute("Ref", strReferenceId);
        SymbolHelper objSymbolHelper = SymbolHelper.getInstance();
        PdmReferanceSymbolVO objPdmReferanceSymbolVO = objSymbolHelper.getReferenceSymbol(sourcId, destinationId, strReferenceId);
        Element rectElement = (Element)objModel.selectSingleNode("//a:Rect");
        rectElement.setText(objPdmReferanceSymbolVO.toString());

        Element pointsElement = (Element)objModel.selectSingleNode("//a:ListOfPoints");
        pointsElement.setText(objPdmReferanceSymbolVO.pointsToString());

        objReferenceSymbol.add((Element) objModel.clone());
    }
    
    // ///////////////////////////////////*** 导出视图 ***///////////////////////////////////////////////////////
    
    /**
     * 导出视图
     * 
     * @param node Element
     * @throws DocumentException DocumentException
     */
    private void exportPDMView(Element node) throws DocumentException {
        Element objView = (Element) node.selectSingleNode("c:Views");
        List<ViewVO> lstViewVO = pdm.getViews();
        if (lstViewVO != null && lstViewVO.size() > 0) {
            for (ViewVO viewVO : lstViewVO) {
                exportView(objView, viewVO);
                exportViewSymbol(node, viewVO);
            }
        }
    }
    
    /**
     * 导出视图
     *
     * 
     * @param parent parent
     * @param viewVO 视图实体
     * @return 视图ID
     */
    private String exportView(Element parent, ViewVO viewVO) {
        Element objViewElement = parent.addElement("o:View");
        String strViewId = AtomicIntegerUtils.getLocalID();
        viewVO.setId(strViewId);
        objViewElement.addAttribute("Id", strViewId);
        addElement(objViewElement, "a:ObjectID", getUUID());
        addElement(objViewElement, "a:Name", viewVO.getChName());
        addElement(objViewElement, "a:Code", viewVO.getEngName());
        addElement(objViewElement, "a:CreationDate", System.currentTimeMillis() + "");
        addElement(objViewElement, "a:Creator", (String) HttpSessionUtil.getCurUserProperty("employeeName"));
        addElement(objViewElement, "a:ModificationDate", System.currentTimeMillis() + "");
        addElement(objViewElement, "a:Modifier", (String) HttpSessionUtil.getCurUserProperty("employeeName"));
        addElement(objViewElement, "a:Comment", viewVO.getDescription());
        addElement(objViewElement, "a:View.SQLQuery", viewVO.getSqlQuery());
        addElement(objViewElement, "a:TaggedSQLQuery", viewVO.getSqlQuery());
        // 导出视图关联的字段
        Element objColumnsElement = objViewElement.addElement("c:Columns");
        List<ViewColumnVO> lstViewColumnVO = viewVO.getColumns();
        if (lstViewColumnVO != null && lstViewColumnVO.size() > 0) {
            for (ViewColumnVO columnVO : lstViewColumnVO) {
                exportViewColumn(objColumnsElement, columnVO);
            }
        }
        // 导出视图关联的表
        Element objElement = objViewElement.addElement("c:View.Tables");
        List<String> lstTable = viewVO.getTables();
        if (lstViewColumnVO != null && lstTable.size() > 0) {
            for (String tableCode : lstTable) {
                exportViewTable(objElement, tableCode);
            }
        }
        return strViewId;
    }
    
    /**
     * 导出视图关联的表
     * 
     * @param element element
     * @param tableCode 表编码
     */
    private void exportViewTable(Element element, String tableCode) {
        Element objElement = element.addElement("o:Table");
        objElement.addAttribute("Ref", objMapTable.get(tableCode));
    }
    
    /**
     * 导出视图字段
     *
     * 
     * @param parent parent
     * @param viewColumnVO 视图字段实体
     */
    private void exportViewColumn(Element parent, ViewColumnVO viewColumnVO) {
        Element objViewColumnElement = parent.addElement("o:ViewColumn");
        String strViewId = AtomicIntegerUtils.getLocalID();
        objViewColumnElement.addAttribute("Id", strViewId);
        addElement(objViewColumnElement, "a:ObjectID", getUUID());
        addElement(objViewColumnElement, "a:Name", viewColumnVO.getChName());
        addElement(objViewColumnElement, "a:Code", viewColumnVO.getEngName());
        addElement(objViewColumnElement, "a:CreationDate", System.currentTimeMillis() + "");
        addElement(objViewColumnElement, "a:Creator", (String) HttpSessionUtil.getCurUserProperty("employeeName"));
        addElement(objViewColumnElement, "a:ModificationDate", System.currentTimeMillis() + "");
        addElement(objViewColumnElement, "a:Modifier", (String) HttpSessionUtil.getCurUserProperty("employeeName"));
        addElement(objViewColumnElement, "a:Comment", viewColumnVO.getDescription());
        addElement(objViewColumnElement, "a:DataType", viewColumnVO.getDataType());
        Element objColumnElement = objViewColumnElement.addElement("c:ViewColumn.Columns");
        List<String> tableColumns = viewColumnVO.getTableColumns();
        for (Iterator<String> iterator = tableColumns.iterator(); iterator.hasNext();) {
			String tableColumn = iterator.next();
			Element objElement = objColumnElement.addElement("o:Column");
	        objElement.addAttribute("Ref", tableColumn);
		}
    }
    
    /**
     * 导出视图的位置信息
     * 
     * @param node node
     * @param viewVO viewVO
     * @throws DocumentException DocumentException
     */
    private void exportViewSymbol(Element node, ViewVO viewVO) throws DocumentException {
        Element objViewSymbol = (Element) node.selectSingleNode("c:PhysicalDiagrams/o:PhysicalDiagram/c:Symbols");
        // 读取pdm文件
        SAXReader objReader = new SAXReader();
        Document objDocument = objReader.read(getResourcePath("ViewSymbol.xml"));
        Element objRoot = objDocument.getRootElement();
        Element objModel = (Element) objRoot.selectSingleNode("//c:Children/o:Model/o:ViewSymbol");
        SymbolHelper objSymbolHelper = SymbolHelper.getInstance();
        PdmViewSymbolVO pdmViewSymbolVO = objSymbolHelper.getViewSymbol(viewVO);
        objModel.addAttribute("Id", pdmViewSymbolVO.getId());
        Element rectElement = (Element)objModel.selectSingleNode("//a:Rect");
        rectElement.setText(pdmViewSymbolVO.toString());

        objModel.addAttribute("Id", AtomicIntegerUtils.getLocalID());
        Element objRefView = (Element) objModel.selectSingleNode("//c:Object/o:View");
        objRefView.addAttribute("Ref", pdmViewSymbolVO.getRefViewId());
        objViewSymbol.add((Element) objModel.clone());
    }
    
}
