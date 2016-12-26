/******************************************************************************
 * Copyright (C) 2015 ShenZhen ComTop Information Technology Co.,Ltd
 * All Rights Reserved.
 * 本软件为深圳康拓普开发研制。未经本公司正式书面同意，其他任何个人、团体不得使用、
 * 复制、修改或发布本软件.
 *****************************************************************************/

package com.comtop.cip.graph.xmi.bean;

import java.util.ArrayList;
import java.util.Iterator;
import java.util.LinkedHashMap;
import java.util.List;
import java.util.Map;

import org.dom4j.Element;

import com.comtop.cip.graph.xmi.utils.DateUtil;
import com.comtop.cip.graph.xmi.utils.DiagramHelper;
import com.comtop.cip.graph.xmi.utils.XMIUtil;

/**
 * UMLDiagram 图表元素
 *
 *
 * @author duqi
 * @since jdk1.6
 * @version 2015年10月8日 duqi
 */
public class UMLDiagram extends BaseXMIBean {
    
    /** UMLDiagram 类型 */
    private String diagramType = "ClassDiagram";
    
    /** 拥有者 */
    private String owner;
    
    /** toolName */
    private String toolName = "Enterprise Architect 2.5";
    
    /** UMLDiagramElement */
    private List<UMLDiagramElement> diagramElements = new ArrayList<UMLDiagramElement>();
    
    /** taggedValuesMap */
    private Map<String, String> taggedValuesMap = new LinkedHashMap<String, String>();
    
    /** XMI ID前缀 */
    private static final String ID_PREFIX = "EAID_";
    
    /** UMLPackage */
    private UMLPackage pckage;
    
    /** localID */
    private int localID = XMIUtil.getLocalID();
    
    /** 添加包元素及类元素时递增 */
    private int seqno = 1;
    
    /**
     * 构造函数
     * 
     * @param pckage UMLPackage
     */
    public UMLDiagram(UMLPackage pckage) {
        this.pckage = pckage;
        this.id = XMIUtil.getUUID();
        this.name = pckage.getName() + " Diagram";
        this.owner = pckage.getXMIID();
        initTaggedValue();
        initDiagramElement();
    }
    
    /**
     * 初始化taggedValuesMap
     * 
     */
    private void initTaggedValue() {
        String currentTime = DateUtil.getCurrentTime();
        taggedValuesMap.put("version", "1.0");
        taggedValuesMap.put("author", "system");
        taggedValuesMap.put("created_date", currentTime);
        taggedValuesMap.put("modified_date", currentTime);
        taggedValuesMap.put("package", this.owner);
        taggedValuesMap.put("type", "Logical");
        taggedValuesMap.put("swimlanes",
            "locked=false;orientation=0;width=0;inbar=false;names=false;color=0;bold=false;fcol=0;;cls=0;");
        taggedValuesMap.put("matrixitems", "locked=false;matrixactive=false;swimlanesactive=true;width=1;");
        taggedValuesMap.put("ea_localid", localID + "");
        taggedValuesMap
            .put(
                "EAStyle",
                "ShowPrivate=1;ShowProtected=1;ShowPublic=1;HideRelationships=0;Locked=0;Border=1;"
                    + "HighlightForeign=1;PackageContents=1;SequenceNotes=0;ScalePrintImage=0;PPgs.cx=1;PPgs.cy=1;DocSize.cx=791;"
                    + "DocSize.cy=1134;ShowDetails=0;Orientation=P;Zoom=100;ShowTags=0;OpParams=1;VisibleAttributeDetail=0;"
                    + "ShowOpRetType=1;ShowIcons=1;CollabNums=0;HideProps=0;ShowReqs=0;ShowCons=0;PaperSize=9;HideParents=0;"
                    + "UseAlias=0;HideAtts=0;HideOps=0;HideStereo=0;HideElemStereo=0;ShowTests=0;ShowMaint=0;"
                    + "ConnectorNotation=UML 2.1;ExplicitNavigability=0;AdvancedElementProps=1;AdvancedFeatureProps=1;"
                    + "AdvancedConnectorProps=1;ShowNotes=0;SuppressBrackets=0;SuppConnectorLabels=0;PrintPageHeadFoot=0;ShowAsList=0;");
        taggedValuesMap
            .put(
                "styleex",
                "ExcludeRTF=0;DocAll=0;HideQuals=0;AttPkg=1;ShowTests=0;ShowMaint=0;SuppressFOC=1;"
                    + "MatrixActive=0;SwimlanesActive=1;MatrixLineWidth=1;MatrixLocked=0;TConnectorNotation=UML 2.1;"
                    + "TExplicitNavigability=0;AdvancedElementProps=1;AdvancedFeatureProps=1;AdvancedConnectorProps=1;ProfileData=;"
                    + "MDGDgm=;STBLDgm=;ShowNotes=0;VisibleAttributeDetail=0;ShowOpRetType=1;SuppressBrackets=0;SuppConnectorLabels=0;"
                    + "PrintPageHeadFoot=0;ShowAsList=0;");
    }
    
    /**
     * 初始化UMLDiagramElement
     *
     */
    private void initDiagramElement() {
        List<UMLDiagramElement> dElements = new DiagramHelper(this).getDiagramElements();
        this.setDiagramElements(dElements);
    }
    
    /**
     * 
     * 转换为XML的DOM结构
     *
     * @param parent 父DOM元素
     */
    public void toDom(Element parent) {
        Element diagram = parent.addElement("UML:Diagram");
        XMIUtil.addElementAttribute(diagram, "name", this.name);
        XMIUtil.addElementAttribute(diagram, "xmi.id", this.getXMIID());
        XMIUtil.addElementAttribute(diagram, "diagramType", this.diagramType);
        XMIUtil.addElementAttribute(diagram, "owner", this.owner);
        XMIUtil.addElementAttribute(diagram, "toolName", this.toolName);
        XMIUtil.addTaggedValueElement(diagram, taggedValuesMap);
        
        Element diagramElement = diagram.addElement("UML:Diagram.element");
        for (Iterator<UMLDiagramElement> iterator = diagramElements.iterator(); iterator.hasNext();) {
            UMLDiagramElement next = iterator.next();
            next.toDom(diagramElement);
        }
    }
    
    /**
     * 获取序列号 并+1
     *
     * @return 序列号
     */
    public int getAndIncreaseSeqno() {
        return this.seqno++;
    }
    
    /**
     * 
     * 获取XMI ID
     * 
     * @return xmi id
     *
     */
    public String getXMIID() {
        if (this.id == null) {
            return null;
        }
        return ID_PREFIX + this.id;
    }
    
    /**
     * 添加UMLDiagramElement
     *
     * @param diagramElement 图标元素
     */
    public void addDiagramElement(UMLDiagramElement diagramElement) {
        diagramElements.add(diagramElement);
    }
    
    /**
     * @return 获取 diagramType属性值
     */
    public String getDiagramType() {
        return diagramType;
    }
    
    /**
     * @param diagramType 设置 diagramType 属性值为参数值 diagramType
     */
    public void setDiagramType(String diagramType) {
        this.diagramType = diagramType;
    }
    
    /**
     * @return 获取 owner属性值
     */
    public String getOwner() {
        return owner;
    }
    
    /**
     * @param owner 设置 owner 属性值为参数值 owner
     */
    public void setOwner(String owner) {
        this.owner = owner;
    }
    
    /**
     * @return 获取 toolName属性值
     */
    public String getToolName() {
        return toolName;
    }
    
    /**
     * @param toolName 设置 toolName 属性值为参数值 toolName
     */
    public void setToolName(String toolName) {
        this.toolName = toolName;
    }
    
    /**
     * @return 获取 diagramElements属性值
     */
    public List<UMLDiagramElement> getDiagramElements() {
        return diagramElements;
    }
    
    /**
     * @param diagramElements 设置 diagramElements 属性值为参数值 diagramElements
     */
    public void setDiagramElements(List<UMLDiagramElement> diagramElements) {
        this.diagramElements = diagramElements;
    }
    
    /**
     * @return 获取 taggedValuesMap属性值
     */
    public Map<String, String> getTaggedValuesMap() {
        return taggedValuesMap;
    }
    
    /**
     * @param taggedValuesMap 设置 taggedValuesMap 属性值为参数值 taggedValuesMap
     */
    public void setTaggedValuesMap(Map<String, String> taggedValuesMap) {
        this.taggedValuesMap = taggedValuesMap;
    }
    
    /**
     * @return 获取 pckage属性值
     */
    public UMLPackage getPckage() {
        return pckage;
    }
    
    /**
     * @param pckage 设置 pckage 属性值为参数值 pckage
     */
    public void setPckage(UMLPackage pckage) {
        this.pckage = pckage;
    }
    
    /**
     * @return 获取 localID属性值
     */
    public int getLocalID() {
        return localID;
    }
    
    /**
     * @param localID 设置 localID 属性值为参数值 localID
     */
    public void setLocalID(int localID) {
        this.localID = localID;
    }
    
    /**
     * @return 获取 seqno属性值
     */
    public int getSeqno() {
        return seqno;
    }
    
    /**
     * @param seqno 设置 seqno 属性值为参数值 seqno
     */
    public void setSeqno(int seqno) {
        this.seqno = seqno;
    }
    
}
