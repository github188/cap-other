/******************************************************************************
 * Copyright (C) 2014 ShenZhen ComTop Information Technology Co.,Ltd
 * All Rights Reserved.
 * 本软件为深圳康拓普开发研制。未经本公司正式书面同意，其他任何个人、团体不得使用、
 * 复制、修改或发布本软件.
 *****************************************************************************/

package com.comtop.cap.bm.metadata.pdm.util;

import java.io.File;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.Iterator;
import java.util.List;
import java.util.Map;

import org.dom4j.Document;
import org.dom4j.Element;
import org.dom4j.Node;
import org.dom4j.io.SAXReader;

import com.comtop.cap.bm.metadata.database.dbobject.model.ColumnVO;
import com.comtop.cap.bm.metadata.database.dbobject.model.IndexColumnVO;
import com.comtop.cap.bm.metadata.database.dbobject.model.ReferenceJoinVO;
import com.comtop.cap.bm.metadata.database.dbobject.model.ReferenceVO;
import com.comtop.cap.bm.metadata.database.dbobject.model.TableIndexVO;
import com.comtop.cap.bm.metadata.database.dbobject.model.TableVO;
import com.comtop.cap.bm.metadata.database.dbobject.model.ViewColumnVO;
import com.comtop.cap.bm.metadata.database.dbobject.model.ViewVO;
import com.comtop.cap.bm.metadata.database.dbobject.util.TableSysncEntityUtil;
import com.comtop.cap.bm.metadata.pdm.convert.DataTypeFactory;
import com.comtop.cap.bm.metadata.pdm.convert.IDataTypeConverter;
import com.comtop.cap.bm.metadata.pdm.model.PdmKeyVO;
import com.comtop.cap.bm.metadata.pdm.model.PdmPackageVO;
import com.comtop.cap.bm.metadata.pdm.model.PdmUserVO;
import com.comtop.cap.bm.metadata.pdm.model.PdmVO;
import com.comtop.top.component.app.session.HttpSessionUtil;

/**
 * PDM导入器
 * 
 * 
 * @author 陈志伟
 * @since 1.0
 * @version 2015-10-12 陈志伟
 */
public class PdmImport {
    
    /** Pdm实体 */
    private PdmVO pdm = new PdmVO();
    
    /** 包集合 */
    private List<PdmPackageVO> lstPackages = new ArrayList<PdmPackageVO>();
    
    /** 表集合 */
    private Map<String, TableVO> mapTableVO = new HashMap<String, TableVO>();
    
    /** 字段集合 */
    private Map<String, ColumnVO> mapPdmColumnVO = new HashMap<String, ColumnVO>();
    
    /** 视图集合 */
    private List<ViewVO> lstViewVO = new ArrayList<ViewVO>();
    
    /** 关联关系集合 */
    private List<ReferenceVO> lstReferenceVO = new ArrayList<ReferenceVO>();
    
    /**
     * 解析PDM文件
     * 
     * @param file file
     * 
     * @return 包集合
     * @throws Exception Exception
     */
    public PdmVO pdmParser(File file) throws Exception {
        // 读取pdm文件
        SAXReader objReader = new SAXReader();
        Document objDocument = objReader.read(file);
        // 获取根节点
        Element objRoot = objDocument.getRootElement();
        objRoot.addNamespace("a", "attribute");
        objRoot.addNamespace("c", "collection");
        objRoot.addNamespace("o", "object");
        // 获取model节点
        Element objModel = (Element) objRoot.selectSingleNode("//c:Children/o:Model");
        // 获取pdm基本信息
        pdm.setId(objModel.attributeValue("Id"));
        pdm.setEngName(objModel.selectSingleNode("a:Name").getText());
        pdm.setCode(objModel.selectSingleNode("a:Code").getText());
        Node dbms = objModel.selectSingleNode("//o:Shortcut");
        pdm.setdBMSCode(dbms.selectSingleNode("a:Code").getText());
        pdm.setdBMSName(dbms.selectSingleNode("a:Name").getText());
        
        // 设置用户
        pdm.setUsers(pdmUserParser(objModel));
        // 解析包结构
        pdm.setPackages(pdmPackageParser(objModel));
        // 解析所有的表
        pdm.setTables(new ArrayList<TableVO>(pdmTableParser(objModel).values()));
        // 解析视图
        pdm.setViews(pdmViewParser(objModel));
        // 解析表的依赖关系
        pdm.setReferences(pdmReferenceParser(objModel));
        return pdm;
    }
    
    /**
     * 获取包集合
     * 
     * @param node Element
     * @return 包集合
     * @throws Exception Exception
     */
    public List<PdmPackageVO> pdmPackageParser(Element node) throws Exception {
        // 循环遍历包
        for (Object o : node.selectNodes("c:Packages/o:Package")) {
            Node objPackageNode = (Node) o;
            PdmPackageVO objPdmPackageVO = new PdmPackageVO();
            objPdmPackageVO.setId(((Element) objPackageNode).attributeValue("Id"));
            objPdmPackageVO.setChName(selectSingleNodeStringText(objPackageNode, "a:Name"));
            objPdmPackageVO.setEngName(selectSingleNodeStringText(objPackageNode, "a:Code"));
            objPdmPackageVO.setCode(selectSingleNodeStringText(objPackageNode, "a:Code"));
            objPdmPackageVO.setParentId(node.attributeValue("Id"));
            pdmViewParser((Element) o);
            pdmTableParser((Element) o);
            pdmReferenceParser((Element) o);
            
            lstPackages.add(objPdmPackageVO);
        }
        // 当前节点下面子节点迭代器
        @SuppressWarnings("unchecked")
        Iterator<Element> objIterator = node.elementIterator();
        // 遍历
        while (objIterator.hasNext()) {
            // 获取某个子节点对象
            Element objElement = objIterator.next();
            // 对子节点进行遍历
            pdmPackageParser(objElement);
        }
        return lstPackages;
    }
    
    /**
     * 获取表集合
     * 
     * @param node Element
     * @return 表集合
     */
    public Map<String, TableVO> pdmTableParser(Element node) {
        for (Object o : node.selectNodes("c:Tables/o:Table")) {
            Node objTableNode = (Node) o;
            TableVO objTableVO = new TableVO();
            objTableVO.setId(((Element) objTableNode).attributeValue("Id"));
            // 中文名称
            objTableVO.setChName(selectSingleNodeStringText(objTableNode, "a:Comment"));
            // 英文名称
            objTableVO.setEngName(selectSingleNodeStringText(objTableNode, "a:Code"));
            // 编码
            objTableVO.setCode(selectSingleNodeStringText(objTableNode, "a:Code"));
            // 注释
            objTableVO.setDescription(selectSingleNodeStringText(objTableNode, "a:Comment" ,false));
            // 获取字段集合
            List<ColumnVO> columnVOs = pdmColumnParser(objTableNode, objTableVO.getCode());

            // 键集合
            Map<String, PdmKeyVO> mapPdmKey = new HashMap<String, PdmKeyVO>();
            // 获取键集合
            for (Object key : objTableNode.selectNodes("c:Keys/o:Key")) {
                Node objKeyNode = (Node) key;
                PdmKeyVO objPdmKey = new PdmKeyVO();
                objPdmKey.setId(((Element) objKeyNode).attributeValue("Id"));
                objPdmKey.setChName(selectSingleNodeStringText(objKeyNode, "a:Name"));
                objPdmKey.setEngName(selectSingleNodeStringText(objKeyNode, "a:Code"));
                objPdmKey.setCode(selectSingleNodeStringText(objKeyNode, "a:Code"));
                for (Object column : objKeyNode.selectNodes("c:Key.Columns/o:Column")) {
                    String id = ((Element) column).attributeValue("Ref");
                    // 设置唯一约束
                    ColumnVO objColumnVO = mapPdmColumnVO.get(id);
                    objColumnVO.setIsUnique(true);
                    objPdmKey.addColumn(objColumnVO);
                }
                mapPdmKey.put(objPdmKey.getId(), objPdmKey);
            }
            // 设置主键
            if (objTableNode.selectSingleNode("c:PrimaryKey/o:Key") != null) {
                String keyId = ((Element) objTableNode.selectSingleNode("c:PrimaryKey/o:Key")).attributeValue("Ref");
                List<ColumnVO> lstColumnVO = mapPdmKey.get(keyId).getColumns();
                
				for (ColumnVO columnVO : lstColumnVO) {
					ColumnVO objColumnVO = mapPdmColumnVO.get(columnVO.getId());
					objColumnVO.setIsPrimaryKEY(true);
					objColumnVO.setCanBeNull(false);
					// 将主键转为索引
					TableSysncEntityUtil.addPrimaryKeyIndex(objTableVO, objColumnVO);
				}
            }
            
            // 设置字段集合
            objTableVO.setColumns(columnVOs);
            // 设置索引
            for (Object index : objTableNode.selectNodes("c:Indexes/o:Index")) {
                Node objNode = (Node) index;
                TableIndexVO objTableIndexVO = new TableIndexVO();
                // 中文名称
                objTableIndexVO.setChName(selectSingleNodeStringText(objNode, "a:Name"));
                // 英文名称
                objTableIndexVO.setEngName(selectSingleNodeStringText(objNode, "a:Code"));
                // 类型
                objTableIndexVO.setType(selectSingleNodeStringText(objNode, "a:BaseIndex.Type"));
                // 是否唯一
                objTableIndexVO.setUnique(selectSingleNodeIntText(objNode, "a:Unique") == 1);
                // 注释
                objTableIndexVO.setDescription(selectSingleNodeStringText(objNode, "a:Comment" ,false));
                for (Object column : objNode.selectNodes("c:IndexColumns/o:IndexColumn")) {
                    IndexColumnVO objIndexColumnVO = new IndexColumnVO();
                    Node objIndexColumnNode = (Node) column;
                    objIndexColumnVO.setAscending(selectSingleNodeStringText(objIndexColumnNode, "a:Ascending"));
                    objIndexColumnVO.setExpression(selectSingleNodeStringText(objIndexColumnNode,
                        "a:IndexColumn.Expression"));
                    //设置关联的字段
                    Node objColumnNode = objIndexColumnNode.selectSingleNode("c:Column/o:Column");
                    if(objColumnNode != null) {
                    	String objColumnId = ((Element)objColumnNode).attributeValue("Ref");
                    	ColumnVO objColumnVO = mapPdmColumnVO.get(objColumnId);
                    	objIndexColumnVO.setColumn(objColumnVO);
                    }
                    objTableIndexVO.addColumn(objIndexColumnVO);
                }
                objTableVO.addIndex(objTableIndexVO);
            }
            
            // 设置创建者
            objTableVO.setCreaterId(HttpSessionUtil.getCurUserId());
            objTableVO.setCreaterName((String) HttpSessionUtil.getCurUserProperty("employeeName"));
            mapTableVO.put(objTableVO.getId(), objTableVO);
        }
        return mapTableVO;
    }
    
    /**
     * 获取表集合
     * 
     * @param node Element
     * @return 表集合
     */
    public List<ViewVO> pdmViewParser(Element node) {
        for (Object o : node.selectNodes("c:Views/o:View")) {
            Node objViewNode = (Node) o;
            ViewVO objViewVO = new ViewVO();
            objViewVO.setId(((Element) objViewNode).attributeValue("Id"));
            // 中文名称
            objViewVO.setChName(selectSingleNodeStringText(objViewNode, "a:Name"));
            // 英文名称
            objViewVO.setEngName(selectSingleNodeStringText(objViewNode, "a:Code"));
            // 编码
            objViewVO.setCode(selectSingleNodeStringText(objViewNode, "a:Code"));
            // 注释
            objViewVO.setDescription(selectSingleNodeStringText(objViewNode, "a:Comment",false));
            // 设置sql
            objViewVO.setSqlQuery(selectSingleNodeStringText(objViewNode, "a:View.SQLQuery"));
            // 设置字段
            objViewVO.setColumns(pdmViewColumnParser(objViewNode));
            // 设置字段
            objViewVO.setTables(pdmViewTableParser(objViewNode));
            // 设置创建者
            objViewVO.setCreaterId(HttpSessionUtil.getCurUserId());
            objViewVO.setCreaterName((String) HttpSessionUtil.getCurUserProperty("employeeName"));
            lstViewVO.add(objViewVO);
        }
        return lstViewVO;
    }
    
    /**
     * 获取表集合
     * 
     * @param node Element
     * @return 表集合
     */
    private List<String> pdmViewTableParser(Node node) {
        List<String> lstTable = new ArrayList<String>();
        for (Object o : node.selectNodes("c:View.Tables/o:Table")) {
            Node objNode = (Node) o;
            String strTableId = ((Element) objNode).attributeValue("Ref");
            TableVO objTableVO = mapTableVO.get(strTableId);
            lstTable.add(objTableVO.getCode());
        }
        return lstTable;
    }
    
    /**
     * 获取表集合
     * 
     * @param node Element
     * @return 表集合
     */
    private List<ViewColumnVO> pdmViewColumnParser(Node node) {
        List<ViewColumnVO> lstViewColumnVO = new ArrayList<ViewColumnVO>();
        for (Object o : node.selectNodes("c:Columns/o:ViewColumn")) {
            Node objNode = (Node) o;
            ViewColumnVO objViewColumnVO = new ViewColumnVO();
            objViewColumnVO.setId(((Element) objNode).attributeValue("Id"));
            objViewColumnVO.setChName(selectSingleNodeStringText(objNode, "a:Name"));
            objViewColumnVO.setEngName(selectSingleNodeStringText(objNode, "a:Code"));
            objViewColumnVO.setCode(selectSingleNodeStringText(objNode, "a:Code"));
            objViewColumnVO.setDescription(selectSingleNodeStringText(objNode, "a:Comment" ,false));
            objViewColumnVO.setDataType(selectSingleNodeStringText(objNode, "a:DataType"));
            objViewColumnVO.setLength(selectSingleNodeIntText(objNode, "a:Length"));
            objViewColumnVO.setPrecision(selectSingleNodeIntText(objNode, "a:Precision"));
            objViewColumnVO.setDefaultValue(selectSingleNodeStringText(objNode, "a:DefaultValue"));
			List refTableColumns = objNode.selectNodes("c:ViewColumn.Columns/o:Column");
			if(refTableColumns != null && refTableColumns.size() > 0){
				List<String> tableColumns = new ArrayList<String>(refTableColumns.size());
				for (Iterator iterator = refTableColumns.iterator(); iterator
						.hasNext();) {
					Element elem = (Element) iterator.next();
					tableColumns.add(elem.attributeValue("Ref"));
				}
				objViewColumnVO.setTableColumns(tableColumns);
			}
            lstViewColumnVO.add(objViewColumnVO);
        }
        return lstViewColumnVO;
    }
    
    /**
     * 获取表集合
     * 
     * @param node Element
     * @param tableCode 表编码
     * @return 表集合
     */
    public List<ColumnVO> pdmColumnParser(Node node, String tableCode) {
        List<ColumnVO> columnVOs = new ArrayList<ColumnVO>();
        for (Object o : node.selectNodes("c:Columns/o:Column")) {
            Node objNode = (Node) o;
            ColumnVO objColumnVO = new ColumnVO();
            objColumnVO.setId(((Element) objNode).attributeValue("Id"));
            String comment =selectSingleNodeStringText(objNode, "a:Comment" ,false);
            objColumnVO.setCode(selectSingleNodeStringText(objNode, "a:Code"));
            objColumnVO.setEngName(selectSingleNodeStringText(objNode, "a:Code"));
			objColumnVO.setChName(comment == null ? objColumnVO.getEngName() : comment);
            objColumnVO.setDescription(objColumnVO.getChName());
            String dataType = selectSingleNodeStringText(objNode, "a:DataType");
			
			IDataTypeConverter iDataTypeConverter=DataTypeFactory.getDataTypeConverter();
			Integer length = iDataTypeConverter.convertToMetaLength(dataType);//字段长度
			Integer precision = iDataTypeConverter.convertToMetaPrecision(dataType);//字段精度
			objColumnVO.setLength(length == null ? selectSingleNodeIntText(objNode, "a:Length") : length);
			objColumnVO.setPrecision(precision == null ? selectSingleNodeIntText(objNode, "a:Precision") : precision);
			
			objColumnVO.setDataType(iDataTypeConverter.convertToMetaDataType(dataType));
            objColumnVO.setDefaultValue(selectSingleNodeStringText(objNode, "a:DefaultValue"));
            objColumnVO.setCanBeNull(selectSingleNodeIntText(objNode, "a:Mandatory") == 0);
            objColumnVO.setTableCode(tableCode);
            columnVOs.add(objColumnVO);
            mapPdmColumnVO.put(objColumnVO.getId(), objColumnVO);
        }
        return columnVOs;
    }
    
    /**
     * 获取表集合
     * 
     * @param node Element
     * @return 表集合
     */
    public List<PdmUserVO> pdmUserParser(Node node) {
        List<PdmUserVO> userList = new ArrayList<PdmUserVO>();
        for (Object o : node.selectNodes("c:Users/o:User")) {
            Node objUserNode = (Node) o;
            PdmUserVO objPdmUserVO = new PdmUserVO();
            objPdmUserVO.setId(((Element) objUserNode).attributeValue("Id"));
            objPdmUserVO.setChName(selectSingleNodeStringText(objUserNode, "a:Name"));
            objPdmUserVO.setEngName(selectSingleNodeStringText(objUserNode, "a:Code"));
            objPdmUserVO.setCode(selectSingleNodeStringText(objUserNode, "a:Code"));
            
            userList.add(objPdmUserVO);
        }
        return userList;
    }
    
    /**
     * 获取关联关系集合
     * 
     * @param node Element
     * @return 关联关系集合
     * @throws Exception Exception
     */
    public List<ReferenceVO> pdmReferenceParser(Element node) throws Exception {
        for (Object reference : node.selectNodes("c:References/o:Reference")) {
            Node objNode = (Node) reference;
            ReferenceVO objReferenceVO = new ReferenceVO();
            //设置关联关系
            String strCardinality = selectSingleNodeStringText(objNode, "a:Cardinality");
            objReferenceVO.setCardinality(strCardinality);
            if(objNode == null){
            	continue;
            }
            // 获取关联表Id
            Element objE = (Element) objNode.selectSingleNode("c:ChildTable/o:Table");
            if(objE == null){
            	continue;
            }
            String strChildTableId = objE.attributeValue("Ref");
            // 设置关联表Id
            objReferenceVO.setChildTableId(strChildTableId);            
            // 设置关联表
            TableVO objChildTableVO = mapTableVO.get(strChildTableId);
            objReferenceVO.setChildTable(objChildTableVO);
            // 获取关联表的字段
            List<ColumnVO> lstColumnVO = objChildTableVO.getColumns();
            Map<String, ColumnVO> mapColumnVO = new HashMap<String, ColumnVO>();
            for (ColumnVO columnVO : lstColumnVO) {
                mapColumnVO.put(columnVO.getId(), columnVO);
            }
            // 获取父实体Id
            String objParentTableId = ((Element) objNode.selectSingleNode("c:ParentTable/o:Table"))
                .attributeValue("Ref");
            TableVO objParentTableVO = mapTableVO.get(objParentTableId);
            List referenceJoinList = objNode.selectNodes("c:Joins/o:ReferenceJoin");
            if(referenceJoinList == null || referenceJoinList.size() <= 0){//关联关系未建立关联字段 忽略这个关联关系
                continue;
            }
            int ingore = 0;
            // 设置Joins
            for (Object join : objNode.selectNodes("c:Joins/o:ReferenceJoin")) {
                Node objReferenceJoinNode = (Node) join;
                ReferenceJoinVO objReferenceJoin = new ReferenceJoinVO();
                // 获取父实体字段id
                Element parentElement = (Element) objReferenceJoinNode.selectSingleNode("c:Object1/o:Column");
                Element childElement = (Element) objReferenceJoinNode.selectSingleNode("c:Object2/o:Column");
                if(parentElement == null || childElement == null){//为指定关联字段 忽略
                    ingore++;
                    continue;
                }
                String strParentElementId = parentElement.attributeValue("Ref");
                // 获取父实体字段编码
                objReferenceJoin.setParentTableColumnCode(mapTableVO.get(objParentTableId).getColumnVO(strParentElementId)
                        .getCode());
                // 设置父实体字段
                objReferenceJoin.setParentTableColumn(mapTableVO.get(objParentTableId).getColumnVO(strParentElementId));

                // 获取关联字段id
                String strChildElementId = childElement .attributeValue("Ref");
                // 设置关联字段编码
                objReferenceJoin.setChildTableColumnCode(objReferenceVO.getChildTable().getColumnVO(strChildElementId)
                        .getCode());
                // 设置关联字段
                objReferenceJoin.setChildTableColumn(objReferenceVO.getChildTable().getColumnVO(strChildElementId));
                // 设置外键
                ColumnVO objColumnVO = mapColumnVO.get(strChildElementId);
                objColumnVO.setIsForeignKey(true);

                // 设置字段关联关系
                objReferenceVO.addReferenceJoin(objReferenceJoin);
            }
            if (referenceJoinList.size() <= ingore){
                continue;//没有一个关联字段配置正确 所以忽略这个关联关系
            }

            //objChildTableVO.setColumns(new ArrayList<ColumnVO>(mapColumnVO.values()));
            // 更新主表关联关系
            List<ReferenceVO> lstParentTableReferenceVO = objParentTableVO.getReferences();
            lstParentTableReferenceVO.add(objReferenceVO);
            objParentTableVO.setReferences(lstParentTableReferenceVO);
            // 更新表集合
            mapTableVO.put(objChildTableVO.getId(), objChildTableVO);
            mapTableVO.put(objParentTableVO.getId(), objParentTableVO);
            objReferenceVO.setParentTable(objParentTableVO);
            objReferenceVO.setParentTableId(objParentTableId);
            lstReferenceVO.add(objReferenceVO);
        }
        
        return lstReferenceVO;
    }
    
	/**
	 * 获取节点信息
	 * 
	 * @param parentNode
	 *            Node
	 * @param childNodeName
	 *            String
	 * @return 节点信息
	 */
	private String selectSingleNodeStringText(Node parentNode,
			String childNodeName) {
		return selectSingleNodeStringText(parentNode, childNodeName, true);
	}
	
	/**
	 * 区分大小写
	 * 
	 * @param parentNode xx
	 * @param childNodeName xx
	 * @param toUpperCase xx
	 * @return xx
	 */
	private String selectSingleNodeStringText(Node parentNode,
			String childNodeName, boolean toUpperCase) {
		Node objChildNode = parentNode.selectSingleNode(childNodeName);
		if (objChildNode != null) {
			return toUpperCase ? objChildNode.getText().toUpperCase() : objChildNode.getText();
		}
		return null;
	}
    
    /**
     * 获取节点数据
     * 
     * @param parentNode Node
     * @param childNodeName String
     * @return 节点数据
     */
    private int selectSingleNodeIntText(Node parentNode, String childNodeName) {
        Node objChildNode = parentNode.selectSingleNode(childNodeName);
        if (objChildNode != null) {
            return Integer.parseInt(objChildNode.getText());
        }
        return 0;
    }
    
}
