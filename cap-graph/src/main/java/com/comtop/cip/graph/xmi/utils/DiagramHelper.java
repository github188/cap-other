/******************************************************************************
 * Copyright (C) 2015 ShenZhen ComTop Information Technology Co.,Ltd
 * All Rights Reserved.
 * 本软件为深圳康拓普开发研制。未经本公司正式书面同意，其他任何个人、团体不得使用、
 * 复制、修改或发布本软件.
 *****************************************************************************/

package com.comtop.cip.graph.xmi.utils;

import java.util.ArrayList;
import java.util.HashMap;
import java.util.Iterator;
import java.util.List;
import java.util.Map;

import com.comtop.cip.graph.xmi.bean.UMLAssociation;
import com.comtop.cip.graph.xmi.bean.UMLAttribute;
import com.comtop.cip.graph.xmi.bean.UMLClass;
import com.comtop.cip.graph.xmi.bean.UMLDependency;
import com.comtop.cip.graph.xmi.bean.UMLDiagram;
import com.comtop.cip.graph.xmi.bean.UMLDiagramElement;
import com.comtop.cip.graph.xmi.bean.UMLOperation;
import com.comtop.cip.graph.xmi.bean.UMLOperationParameter;
import com.comtop.cip.graph.xmi.bean.UMLPackage;

/**
 * 
 * 生成图表的帮助类
 *
 * @author duqi
 * @since jdk1.6
 * @version 2015年10月20日 duqi
 */
public class DiagramHelper {
    
    /**
     * key为UMLDiagramElement的subject
     * value为UMLDiagramElement
     */
    Map<String, UMLDiagramElement> diagramElementMap = new HashMap<String, UMLDiagramElement>();
    
    /** UMLDiagram */
    private UMLDiagram diagram;
    
    /** UMLDiagram */
    private UMLPackage pckage;
    
    /** 记录每列包的累加高度 */
    private int[] packageCols;
    
    /** 记录每列类的累加高度 */
    private int[] classCols;
    
//    /** 类起始位置 */
//    private int classStartLeft;
    
    /** 类起始位置 */
    private int classStartTop;
    
    /** 类元素宽度 */
    private int classElemWidth;
    /**
     * 构造函数
     * 
     * @param diagram UMLDiagram
     */
    public DiagramHelper(UMLDiagram diagram) {
        this.diagram = diagram;
        this.pckage = diagram.getPckage();
        this.packageCols = new int[DiagramConstants.DEFAULT_PACKAGE_COLS];
        this.classCols = new int[DiagramConstants.DEFAULT_CLASS_COLS];
    }
    
    /**
     * 获取UMLDiagramElement
     *
     * @return UMLDiagramElement集合
     */
    public List<UMLDiagramElement> getDiagramElements() {
        List<UMLDiagramElement> diagramElements = new ArrayList<UMLDiagramElement>();
        diagramElements.addAll(getDiagramElementsBySubPckages(pckage.getPackages()));
        classStartTop = initClassCols();
        diagramElements.addAll(getDiagramElementsByClasses(pckage.getClasses()));
        diagramElements.addAll(getDiagramElementsByAssociations(pckage.getAssociations()));
        diagramElements.addAll(getDiagramElementsByDependency(pckage.getDependencies()));
        return diagramElements;
    }
    
    /**
     * 通过子包获取图标元素
     *
     * @param subPackages 子包集合
     * @return 图标元素集合
     */
    private List<UMLDiagramElement> getDiagramElementsBySubPckages(List<UMLPackage> subPackages) {
        List<UMLDiagramElement> diagramElements = new ArrayList<UMLDiagramElement>();
        for (Iterator<UMLPackage> iterator = subPackages.iterator(); iterator.hasNext();) {
            UMLPackage aPackage = iterator.next();
            String geometry = getGeometryByPackage(aPackage);
            // String geometry = "Left=" + i * 100 + ";Top=" + i * 100 + ";Right=" + (i + 1) * 100 + ";Bottom=" + (i +
            // 1) * 100 + ";";
            
            String subject = "EAID_" + aPackage.getId();
            String seqno = diagram.getAndIncreaseSeqno() + "";
            UMLDiagramElement diagramElement = new UMLDiagramElement(geometry, subject, seqno);
            diagramElementMap.put(subject, diagramElement);
            diagramElements.add(diagramElement);
        }
        return diagramElements;
    }
    
    /**
     * 获取包的几何图形 大小及位置
     *
     * @param aPackage UMLPackage
     * @return 几何图形
     */
    private String getGeometryByPackage(UMLPackage aPackage) {
        int height = 20;
        height += aPackage.getPackages().size() * DiagramConstants.PACKAGE_PER_ELEM_HEIGHT;
        height += aPackage.getClasses().size() * DiagramConstants.PACKAGE_PER_ELEM_HEIGHT;
        height = height > DiagramConstants.PACKAGE_MIN_HEIGHT ? height : DiagramConstants.PACKAGE_MIN_HEIGHT;
        int width = DiagramConstants.PACKAGE_MIN_WIDTH;
        int col = getPackageFillColumn();
        int left = DiagramConstants.PADDING + col * (width + DiagramConstants.PACKAGE_HORIZONTAL_SPACING);
        int top = packageCols[col] == 0 ? DiagramConstants.PADDING
            : (DiagramConstants.PACKAGE_VERTICAL_SPACING + packageCols[col]);
        int right = left + width;
        int bottom = top + height;
        packageCols[col] = bottom;
        return "Left=" + left + ";Top=" + top + ";Right=" + right + ";Bottom=" + bottom + ";";
    }
    
    /**
     * 获取类元素的几何图形 大小及位置
     *
     * @param aClass UMLClass
     * @return 几何图形
     */
    private String getGeometryByClass(UMLClass aClass) {
        int height = DiagramConstants.CLASS_GRAPH_HEIGHT_HEIGHT;
        height += aClass.getAttributes().size() * DiagramConstants.CLASS_PER_ELEM_HEIGHT;
        height += aClass.getOperations().size() * DiagramConstants.CLASS_PER_ELEM_HEIGHT;
        height = height > DiagramConstants.CLASS_MIN_HEIGHT ? height : DiagramConstants.CLASS_MIN_HEIGHT;
        int col = getClassFillColumn();
        
        int left = DiagramConstants.PADDING + col * (classElemWidth + DiagramConstants.CLASS_HORIZONTAL_SPACING);
        int top = classCols[col] == classStartTop ? (classStartTop + DiagramConstants.CLASS_PACKAGE_MARGIN)
            : (DiagramConstants.CLASS_VERTICAL_SPACING + classCols[col]);
        int right = left + classElemWidth;
        int bottom = top + height;
        classCols[col] = bottom;
        return "Left=" + left + ";Top=" + top + ";Right=" + right + ";Bottom=" + bottom + ";";
    }
    
    /**
     * UMLClass的宽度
     *
     * @param aClass UMLClass
     * @return UMLClass的宽度
     */
    private int getWidth(UMLClass aClass) {
        int maxWidth = DiagramConstants.CLASS_MIN_WIDTH;
        List<UMLAttribute> attributes = aClass.getAttributes();
        for (Iterator<UMLAttribute> iterator = attributes.iterator(); iterator.hasNext();) {
            UMLAttribute umlAttribute = iterator.next();
            int w = (umlAttribute.getName().length() + umlAttribute.getDatatype().getName().length()) * 6;
            maxWidth = w > maxWidth ? w : maxWidth;
        }
        List<UMLOperation> operations = aClass.getOperations();
        for (Iterator<UMLOperation> iterator = operations.iterator(); iterator.hasNext();) {
            UMLOperation umlOperation = iterator.next();
            List<UMLOperationParameter> parameters = umlOperation.getOperationParameters();
            int tmpLen = 0;
            for (Iterator<UMLOperationParameter> iterator2 = parameters.iterator(); iterator2.hasNext();) {
                UMLOperationParameter umlOperationParameter = iterator2.next();
                tmpLen += umlOperationParameter.getDatatype().getName().length();
            }
            int w = (umlOperation.getName().length() + umlOperation.getDatatype().getName().length() + tmpLen) * 6;
            maxWidth = w > maxWidth ? w : maxWidth;
        }
        return maxWidth;
    }
    
    /**
     * 初始化classCols数组 并返回起始位置
     *
     * @return 起始位置
     */
    private int initClassCols() {
        int startTop = packageCols[0];
        for (int i = 1; i < packageCols.length; i++) {
            if (packageCols[i] > startTop) {
                startTop = packageCols[i];
            }
        }
        for (int i = 0; i < classCols.length; i++) {
            classCols[i] = startTop;
        }
        return startTop;
    }
    
    /**
     * 获取包填充到哪一列
     *
     * @return 包填充到哪一列
     */
    private int getPackageFillColumn() {
        int col = 0;
        for (int i = 1; i < packageCols.length; i++) {
            if (packageCols[i] < packageCols[col]) {
                col = i;
            }
        }
        return col;
    }
    
    /**
     * 获取类填充到哪一列
     *
     * 
     * @return 类填充到哪一列
     */
    private int getClassFillColumn() {
        int col = 0;
        for (int i = 1; i < classCols.length; i++) {
            if (classCols[i] < classCols[col]) {
                col = i;
            }
        }
        return col;
    }
    
    /**
     * 通过class获取UMLDiagramElement集合
     *
     * @param classess 类元素集合
     * @return UMLDiagramElement集合
     */
    private List<UMLDiagramElement> getDiagramElementsByClasses(List<UMLClass> classess) {
    	for (Iterator<UMLClass> iterator = classess.iterator(); iterator.hasNext();) {
    		UMLClass aClass = iterator.next();
    		int tmpWidth = getWidth(aClass);
    		classElemWidth = classElemWidth > tmpWidth ? classElemWidth : tmpWidth;
    		classElemWidth = classElemWidth > DiagramConstants.CLASS_DEFAULT_WIDTH ? classElemWidth : DiagramConstants.CLASS_DEFAULT_WIDTH;
    	}
        List<UMLDiagramElement> diagramElements = new ArrayList<UMLDiagramElement>();
        for (Iterator<UMLClass> iterator = classess.iterator(); iterator.hasNext();) {
            UMLClass aClass = iterator.next();
            String geometry = getGeometryByClass(aClass);
            String subject = aClass.getXMIID();
            String seqno = diagram.getAndIncreaseSeqno() + "";
            UMLDiagramElement diagramElement = new UMLDiagramElement(geometry, subject, seqno);
            diagramElementMap.put(subject, diagramElement);
            diagramElements.add(diagramElement);
        }
        return diagramElements;
    }
    
    /**
     * 通过关联关系集合获取UMLDiagramElement集合
     *
     * @param associations 关联关系集合
     * @return UMLDiagramElement集合
     */
    private List<UMLDiagramElement> getDiagramElementsByAssociations(List<UMLAssociation> associations) {
        List<UMLDiagramElement> diagramElements = new ArrayList<UMLDiagramElement>();
        for (Iterator<UMLAssociation> iterator = associations.iterator(); iterator.hasNext();) {
            UMLAssociation association = iterator.next();
            String geometry = "SX=0;SY=0;EX=0;EY=0;EDGE=2;$LLB=CX=6:CY=13:OX=0:OY=0:HDN=0:BLD=0:ITA=0:UND=0:CLR=-1:ALN=0:DIR=0:ROT=0;LLT=;LMT=;LMB=;LRT=;LRB=CX=16:CY=13:OX=0:OY=0:HDN=0:BLD=0:ITA=0:UND=0:CLR=-1:ALN=0:DIR=0:ROT=0;IRHS=;ILHS=;Path=;";
            String subject = association.getXMIID();
            UMLDiagramElement diagramElement1 = diagramElementMap.get(association.getSourceClass().getXMIID());
            UMLDiagramElement diagramElement2 = diagramElementMap.get(association.getTargetClass().getXMIID());
            String SOID = diagramElement1.getDUID();
            String EOID = diagramElement2.getDUID();
            String style = "Mode=3;EOID=" + EOID + ";SOID=" + SOID + ";Color=-1;LWidth=0;Hidden=0;";
            UMLDiagramElement diagramElement = new UMLDiagramElement(geometry, subject, null, style);
            diagramElements.add(diagramElement);
        }
        return diagramElements;
    }
    
    /**
     * 通过依赖关系集合获取UMLDiagramElement集合
     *
     * @param dependencies 关联关系集合
     * @return UMLDiagramElement集合
     */
    private List<UMLDiagramElement> getDiagramElementsByDependency(List<UMLDependency> dependencies) {
        List<UMLDiagramElement> diagramElements = new ArrayList<UMLDiagramElement>();
        for (Iterator<UMLDependency> iterator = dependencies.iterator(); iterator.hasNext();) {
            UMLDependency dependency = iterator.next();
            String geometry = "SX=0;SY=0;EX=0;EY=0;EDGE=2;$LLB=;LLT=;LMT=;LMB=;LRT=;LRB=;IRHS=;ILHS=;Path=;";
            String subject = dependency.getXMIID();
            UMLDiagramElement diagramElement1 = diagramElementMap.get("EAID_" + dependency.getSourcePackage().getId());
            UMLDiagramElement diagramElement2 = diagramElementMap.get("EAID_" + dependency.getTargetPackage().getId());
            String SOID = diagramElement1.getDUID();
            String EOID = diagramElement2.getDUID();
            String style = "Mode=3;EOID=" + EOID + ";SOID=" + SOID + ";Color=-1;LWidth=0;Hidden=0;";
            UMLDiagramElement diagramElement = new UMLDiagramElement(geometry, subject, null, style);
            diagramElements.add(diagramElement);
        }
        return diagramElements;
    }
    
}
