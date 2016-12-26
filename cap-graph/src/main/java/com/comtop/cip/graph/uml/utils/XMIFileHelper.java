/******************************************************************************
 * Copyright (C) 2015 ShenZhen ComTop Information Technology Co.,Ltd
 * All Rights Reserved.
 * 本软件为深圳康拓普开发研制。未经本公司正式书面同意，其他任何个人、团体不得使用、
 * 复制、修改或发布本软件.
 *****************************************************************************/

package com.comtop.cip.graph.uml.utils;

import java.io.File;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.Iterator;
import java.util.List;
import java.util.Map;

import org.dom4j.Document;
import org.dom4j.DocumentException;
import org.dom4j.Element;

import com.comtop.cap.bm.metadata.entity.model.DataTypeVO;
import com.comtop.cap.bm.metadata.entity.model.EntityAttributeVO;
import com.comtop.cap.bm.metadata.entity.model.EntityRelationshipVO;
import com.comtop.cap.bm.metadata.entity.model.EntityVO;
import com.comtop.cap.bm.metadata.entity.model.MethodVO;
import com.comtop.cap.bm.metadata.entity.model.ParameterVO;
import com.comtop.cap.bm.metadata.entity.model.RelatioMultiple;
import com.comtop.cip.graph.entity.model.GraphModuleRelaVO;
import com.comtop.cip.graph.entity.model.GraphModuleVO;
import com.comtop.cip.graph.xmi.bean.UMLAssociation;
import com.comtop.cip.graph.xmi.bean.UMLAttribute;
import com.comtop.cip.graph.xmi.bean.UMLClass;
import com.comtop.cip.graph.xmi.bean.UMLDatatype;
import com.comtop.cip.graph.xmi.bean.UMLDependency;
import com.comtop.cip.graph.xmi.bean.UMLDiagram;
import com.comtop.cip.graph.xmi.bean.UMLModel;
import com.comtop.cip.graph.xmi.bean.UMLOperation;
import com.comtop.cip.graph.xmi.bean.UMLOperationParameter;
import com.comtop.cip.graph.xmi.bean.UMLPackage;
import com.comtop.cip.graph.xmi.bean.XMIContent;
import com.comtop.cip.graph.xmi.handler.EAHandler;

/**
 * 生成XMI文档的帮助类
 *
 * @author duqi
 * @since jdk1.6
 * @version 2015年10月13日 duqi
 */
public class XMIFileHelper {
    
    /**
     * 输出基本的xmi内容
     *
     * @param file xmifile
     * @return uml模型
     * @throws DocumentException 文档异常
     */
    public static UMLModel outputDocument(File file) throws DocumentException {
        EAHandler handler = new EAHandler();
        XMIContent content = new XMIContent();
        UMLModel model = generateUMLModel();
        content.addModel(model);
        content.toDom(handler.getRootElement());
        handler.write(file);
        return model;
    }
    
    /**
     * 
     * 生成UMLModel
     *
     * @return UMLModel
     */
    private static UMLModel generateUMLModel() {
        UMLModel model = new UMLModel();
        UMLPackage rootPackage = model.getRootPackage();
        rootPackage.addClassModelPackage();
        return model;
    }
    
    /**
     * 获取umlPackage实例
     *
     * @param graphModuleVO 模块实体
     * @param umlModel uml模型
     * @param parentUMLPackage 父包
     * @param umlDatatypeMap 数据类型映射集合
     * @param umlPackageMap umlPackage映射集合
     */
    public static void initUMLPackage(GraphModuleVO graphModuleVO, UMLModel umlModel, UMLPackage parentUMLPackage,
        Map<String, UMLDatatype> umlDatatypeMap, Map<String, UMLPackage> umlPackageMap) {
        UMLPackage currentUMLPackage = umlPackageMap.get(graphModuleVO.getModuleId());
        Map<String, UMLClass> umlClassMap = new HashMap<String, UMLClass>();
        
        List<EntityVO> entityVOList = graphModuleVO.getEntityVOList();
        for (Iterator<EntityVO> iterator = entityVOList.iterator(); iterator.hasNext();) {
            EntityVO entityVO = iterator.next();
            UMLClass umlClass = new UMLClass(currentUMLPackage, entityVO.getModelName());
            List<EntityAttributeVO> entityAttributeVOList = entityVO.getAttributes();
            if (entityAttributeVOList != null) {
                for (Iterator<EntityAttributeVO> iterator2 = entityAttributeVOList.iterator(); iterator2.hasNext();) {
                    EntityAttributeVO entityAttributeVO = iterator2.next();
                    UMLDatatype umlDatatype = umlDatatypeMap.get(entityAttributeVO.getAttributeType().getType());
                    UMLAttribute umlAttribute = new UMLAttribute(umlDatatype, entityAttributeVO.getEngName(),
                        entityAttributeVO.getAccessLevel(), umlClass.getAndIncrAttrPosition());
                    umlClass.addAttribute(umlAttribute);
                }
            }
            
            List<MethodVO> methodVOList = entityVO.getMethods();
            if (methodVOList != null) {
                for (Iterator<MethodVO> iterator2 = methodVOList.iterator(); iterator2.hasNext();) {
                    MethodVO methodVO = iterator2.next();
                    UMLDatatype umlDatatype = umlDatatypeMap.get(methodVO.getReturnType().getType());
                    
                    UMLOperation umlOperation = new UMLOperation(umlDatatype, methodVO.getEngName(),
                        methodVO.getAccessLevel(), umlClass.getAndIncrAttrPosition());
                    UMLOperationParameter returnParam = new UMLOperationParameter("return", umlDatatype);
                    umlOperation.addParameter(returnParam);
                    List<ParameterVO> parameterVOList = methodVO.getParameters();
                    if (parameterVOList == null) {
                        continue;
                    }
                    for (Iterator<ParameterVO> iterator3 = parameterVOList.iterator(); iterator3.hasNext();) {
                        ParameterVO parameterVO = iterator3.next();
                        UMLDatatype paramDatatype = umlDatatypeMap.get(parameterVO.getDataType().getType());
                        UMLOperationParameter operationParameter = new UMLOperationParameter("in", paramDatatype,
                            parameterVO.getChName());
                        umlOperation.addParameter(operationParameter);
                    }
                    umlClass.addOperation(umlOperation);
                }
            }
            
            umlClassMap.put(entityVO.getModelId(), umlClass);
            currentUMLPackage.addClass(umlClass);
        }
        List<EntityRelationshipVO> entityRelationshipVOList = graphModuleVO.getEntityRelationshipVOList();
        if (entityRelationshipVOList != null) {
            for (Iterator<EntityRelationshipVO> iterator = entityRelationshipVOList.iterator(); iterator.hasNext();) {
                EntityRelationshipVO entityRelationshipVO = iterator.next();
                String multiple = entityRelationshipVO.getMultiple();
                String sourceMultiplicity = null;
                String targetMultiplicity = null;
                if (RelatioMultiple.ONE_MANY.getValue().equals(multiple)) {
                    sourceMultiplicity = "1";
                    targetMultiplicity = "0..*";
                } else if (RelatioMultiple.ONE_ONE.getValue().equals(multiple)) {
                    sourceMultiplicity = "1";
                    targetMultiplicity = "1";
                } else if (RelatioMultiple.MANY_ONE.getValue().equals(multiple)) {
                    sourceMultiplicity = "0..*";
                    targetMultiplicity = "1";
                } else if (RelatioMultiple.MANY_MANY.getValue().equals(multiple)) {
                    sourceMultiplicity = "0..*";
                    targetMultiplicity = "0..*";
                } else {
                    sourceMultiplicity = "1";
                    targetMultiplicity = "1";
                }
                UMLAssociation association = new UMLAssociation(umlClassMap.get(entityRelationshipVO
                    .getSourceEntityId()), umlClassMap.get(entityRelationshipVO.getTargetEntityId()),
                    sourceMultiplicity, targetMultiplicity);
                currentUMLPackage.addAssociation(association);
            }
        }
        List<GraphModuleVO> subGraphModuleVOList = graphModuleVO.getInnerModuleVOList();
        for (Iterator<GraphModuleVO> iterator = subGraphModuleVOList.iterator(); iterator.hasNext();) {
            GraphModuleVO subGraphModuleVO = iterator.next();
            UMLPackage subUMLPackage = currentUMLPackage.addPackage(subGraphModuleVO.getModuleName(),
                subGraphModuleVO.getPackageFullPath());
            umlPackageMap.put(subGraphModuleVO.getModuleId(), subUMLPackage);
        }
        List<GraphModuleRelaVO> graphModuleRelaVOList = graphModuleVO.getInnerModuleRelaVOList();
        for (Iterator<GraphModuleRelaVO> iterator = graphModuleRelaVOList.iterator(); iterator.hasNext();) {
            GraphModuleRelaVO graphModuleRelaVO = iterator.next();
            UMLPackage sourcePackage = umlPackageMap.get(graphModuleRelaVO.getSourceModuleId());
            UMLPackage targetPackage = umlPackageMap.get(graphModuleRelaVO.getTargetModuleId());
            if (sourcePackage != null && targetPackage != null) {
                UMLDependency umlDependency = new UMLDependency(sourcePackage, targetPackage);
                currentUMLPackage.addDependency(umlDependency);
            }
        }
    }
    
    /**
     * 
     * 添加一个UMLDiagram
     * 
     * @param umlPackage uml包模型
     * @return UMLDiagram
     */
    public static UMLDiagram getUMLDiagram(UMLPackage umlPackage) {
        return new UMLDiagram(umlPackage);
    }
    
    /**
     * 
     * 输出UMLDataType到xmi文件
     *
     * @param file xmi文件
     * @param umlDatatypeList UMLDataType集合
     * @param umlModel uml模型
     * @throws DocumentException 文档异常
     */
    public static void outputUMLDataType(File file, List<UMLDatatype> umlDatatypeList, UMLModel umlModel)
        throws DocumentException {
        if (umlDatatypeList == null || umlDatatypeList.size() <= 0) {
            return;
        }
        EAHandler handler = new EAHandler(file);
        Document document = handler.getDocument();
        Element element = (Element) document.selectSingleNode("//UML:Model[@xmi.id='" + umlModel.getXMIID()
            + "']/UML:Namespace.ownedElement");
        for (Iterator<UMLDatatype> iterator = umlDatatypeList.iterator(); iterator.hasNext();) {
            UMLDatatype next = iterator.next();
            next.toDom(element);
        }
        handler.write();
    }
    
    /**
     * 
     * 输出UMLPackage到xmi文件
     *
     * @param file xmi文件
     * @param umlPackage uml包
     * @param parentUMLPackage 父包
     * @throws DocumentException 文档异常
     */
    public static void outputUMLPackage(File file, UMLPackage umlPackage, UMLPackage parentUMLPackage)
        throws DocumentException {
        EAHandler handler = new EAHandler(file);
        Document document = handler.getDocument();
        Element element = (Element) document.selectSingleNode("//UML:Package[@xmi.id='" + parentUMLPackage.getXMIID()
            + "']/UML:Namespace.ownedElement");
        umlPackage.currentElementToDom(element);
        handler.write();
    }
    
    /**
     * 
     * 输出UMLPackage到xmi文件
     *
     * @param file xmi文件
     * @param umlPackage uml包
     * @throws DocumentException 文档异常
     */
    public static void outputUMLPackageSubElement(File file, UMLPackage umlPackage) throws DocumentException {
        EAHandler handler = new EAHandler(file);
        Document document = handler.getDocument();
        Element element = (Element) document.selectSingleNode("//UML:Package[@xmi.id='" + umlPackage.getXMIID()
            + "']/UML:Namespace.ownedElement");
        umlPackage.subElementToDom(element);
        handler.write();
    }
    
    /**
     * 
     * 输出UMLDiagram到xmi文件
     *
     * @param file xmi文件
     * @param umlDiagram uml图标
     * @throws DocumentException 文档异常
     */
    public static void outputUMLDiagram(File file, UMLDiagram umlDiagram) throws DocumentException {
        EAHandler handler = new EAHandler(file);
        Document document = handler.getDocument();
        Element element = (Element) document.selectSingleNode("/XMI/XMI.content");
        umlDiagram.toDom(element);
        handler.write();
    }
    
    /**
     * 
     * 抽取数据类型
     * 
     * @param graphModuleVO 图形模块实体
     * @param umlModel uml模型
     * @return List<UMLDatatype>
     */
    public static List<UMLDatatype> extractUMLDatatype(GraphModuleVO graphModuleVO, UMLModel umlModel) {
        List<UMLDatatype> umlDatatypeList = new ArrayList<UMLDatatype>();
        
        List<EntityVO> entityVOList = graphModuleVO.getEntityVOList();
        for (Iterator<EntityVO> iterator = entityVOList.iterator(); iterator.hasNext();) {
            EntityVO entityVO = iterator.next();
            List<EntityAttributeVO> entityAttributeVOList = entityVO.getAttributes();
            if (entityAttributeVOList != null) {
                for (Iterator<EntityAttributeVO> iterator2 = entityAttributeVOList.iterator(); iterator2.hasNext();) {
                    EntityAttributeVO entityAttributeVO = iterator2.next();
                    DataTypeVO dataTypeVO = entityAttributeVO.getAttributeType();
                    UMLDatatype datatype = new UMLDatatype(umlModel.getAndIncrease(), dataTypeVO.getType());
                    umlDatatypeList.add(datatype);
                }
            }
            List<MethodVO> methodVOList = entityVO.getMethods();
            if (methodVOList != null) {
                for (Iterator<MethodVO> iterator2 = methodVOList.iterator(); iterator2.hasNext();) {
                    MethodVO methodVO = iterator2.next();
                    DataTypeVO dataTypeVO = methodVO.getReturnType();
                    UMLDatatype datatype = new UMLDatatype(umlModel.getAndIncrease(), dataTypeVO.getType());
                    umlDatatypeList.add(datatype);
                    List<ParameterVO> parameterVOList = methodVO.getParameters();
                    if (parameterVOList == null) {
                        continue;
                    }
                    for (Iterator<ParameterVO> iterator3 = parameterVOList.iterator(); iterator3.hasNext();) {
                        ParameterVO parameterVO = iterator3.next();
                        DataTypeVO paramDataTypeVO = parameterVO.getDataType();
                        UMLDatatype paramDatatype = new UMLDatatype(umlModel.getAndIncrease(),
                            paramDataTypeVO.getType());
                        umlDatatypeList.add(paramDatatype);
                    }
                }
            }
        }
        return umlDatatypeList;
    }
    
}
