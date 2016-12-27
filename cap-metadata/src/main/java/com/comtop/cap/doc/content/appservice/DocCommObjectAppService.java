/******************************************************************************
 * Copyright (C) 2015 ShenZhen ComTop Information Technology Co.,Ltd
 * All Rights Reserved.
 * 本软件为深圳康拓普开发研制。未经本公司正式书面同意，其他任何个人、团体不得使用、
 * 复制、修改或发布本软件.
 *****************************************************************************/

package com.comtop.cap.doc.content.appservice;

import java.util.HashMap;
import java.util.Iterator;
import java.util.List;
import java.util.Map;
import java.util.Map.Entry;

import com.comtop.cap.bm.req.cfg.appservice.CapDocAttributeDefAppService;
import com.comtop.cap.bm.req.cfg.model.CapDocAttributeDefVO;
import com.comtop.cap.doc.content.dao.DocCommObjectDAO;
import com.comtop.cap.doc.content.model.DocChapterContentVO;
import com.comtop.cap.doc.content.model.DocCommAttributeVO;
import com.comtop.cap.doc.content.model.DocCommObjectVO;
import com.comtop.cip.jodd.petite.meta.PetiteBean;
import com.comtop.cip.jodd.petite.meta.PetiteInject;
import com.comtop.cap.runtime.base.appservice.BaseAppService;

/**
 * 模型对象实例。如果扩展的模型对象没有独立的存储结构，则对象本身存储在此表中，对象属性存储在CAP_DOC_COMM_ATTRIBUTE表中 业务逻辑处理类
 * 
 * @author 李小芬
 * @since 1.0
 * @version 2015-11-11 李小芬
 */
@PetiteBean
public class DocCommObjectAppService extends BaseAppService {
    
    /** 注入DAO **/
    @PetiteInject
    protected DocCommObjectDAO docCommObjectDAO;
    
    /** 注入docCommAttributeAppService **/
    @PetiteInject
    protected DocCommAttributeAppService docCommAttributeAppService;
    
    /** 注入reqElementAppService **/
    @PetiteInject
    protected CapDocAttributeDefAppService reqElementAppService;
    
    /** 注入docTextContentAppService **/
    @PetiteInject
    protected DocChapterContentAppService docChapterContentAppService;
    
    /**
     * 新增 模型对象实例。如果扩展的模型对象没有独立的存储结构，则对象本身存储在此表中，对象属性存储在CAP_DOC_COMM_ATTRIBUTE表中
     * 
     * @param docCommObject 模型对象实例。如果扩展的模型对象没有独立的存储结构，则对象本身存储在此表中，对象属性存储在CAP_DOC_COMM_ATTRIBUTE表中对象
     * @return 模型对象实例。如果扩展的模型对象没有独立的存储结构，则对象本身存储在此表中，对象属性存储在CAP_DOC_COMM_ATTRIBUTE表中Id
     */
    public Object insertDocCommObject(DocCommObjectVO docCommObject) {
        // 新增时保存模型对象实例
        // 查询对象实例的顺序号最大值
        docCommObject.setSortNo(Integer.parseInt("1"));
        String objectId = (String) docCommObjectDAO.insertDocCommObject(docCommObject);
        // 保存对象属性实例
        Map<String, String> objPropertiesMap = docCommObject.getPropertiesMap();
        if (objPropertiesMap == null) {
            objPropertiesMap = new HashMap<String, String>();
        }
        for (Entry<String, String> objProperty : objPropertiesMap.entrySet()) {
            DocCommAttributeVO objDocCommAttributeVO = new DocCommAttributeVO();
            objDocCommAttributeVO.setClassUri(docCommObject.getClassUri());
            objDocCommAttributeVO.setObjectId(objectId);
            objDocCommAttributeVO.setAttributeUri(objProperty.getKey());
            // 判断取值类型
            CapDocAttributeDefVO objReqElementVO = reqElementAppService.queryReqElementByURI(
                docCommObject.getClassUri(), objProperty.getKey());
            if ("text".equals(objReqElementVO.getValueType())) { // 文本类型存到文本表
                // 插入都文本表
                DocChapterContentVO objDocChapterContentVO = new DocChapterContentVO();
                objDocChapterContentVO.setContent(objProperty.getValue());
                String strTextContentId = (String) this.docChapterContentAppService
                    .insertDocChapterContent(objDocChapterContentVO);
                objDocCommAttributeVO.setValueType("text");
                objDocCommAttributeVO.setValue(strTextContentId);
            } else {
                objDocCommAttributeVO.setValue(objProperty.getValue());
            }
            docCommAttributeAppService.insertDocCommAttribute(objDocCommAttributeVO);
        }
        return objectId;
    }
    
    /**
     * 更新 模型对象实例。如果扩展的模型对象没有独立的存储结构，则对象本身存储在此表中，对象属性存储在CAP_DOC_COMM_ATTRIBUTE表中
     * 
     * @param docCommObject 模型对象实例。如果扩展的模型对象没有独立的存储结构，则对象本身存储在此表中，对象属性存储在CAP_DOC_COMM_ATTRIBUTE表中对象
     * @return 更新成功与否
     */
    public boolean updateDocCommObject(DocCommObjectVO docCommObject) {
        DocCommObjectVO oldDocCommObjectVO = this.readObjectInstance(docCommObject);
        docCommObject.setSortNo(oldDocCommObjectVO.getSortNo());
        // 更新对象实例
        docCommObject.setUri(docCommObject.getUri());
        boolean bFlag = docCommObjectDAO.updateDocCommObject(docCommObject);
        // 更新对象实例属性，先删后增
        List<DocCommAttributeVO> lstDocCommAttribute = oldDocCommObjectVO.getDocCommAttributeByReattris();
        docCommAttributeAppService.deleteDocCommAttributeList(lstDocCommAttribute);
        Map<String, String> objPropertiesMap = docCommObject.getPropertiesMap();
        if (objPropertiesMap == null) {
            objPropertiesMap = new HashMap<String, String>();
        }
        for (Entry<String, String> objProperty : objPropertiesMap.entrySet()) {
            DocCommAttributeVO objDocCommAttributeVO = new DocCommAttributeVO();
            objDocCommAttributeVO.setClassUri(docCommObject.getClassUri());
            objDocCommAttributeVO.setObjectId(docCommObject.getId());
            objDocCommAttributeVO.setAttributeUri(objProperty.getKey());
            
            // 判断取值类型
            CapDocAttributeDefVO objReqElementVO = reqElementAppService.queryReqElementByURI(
                docCommObject.getClassUri(), objProperty.getKey());
            if ("text".equals(objReqElementVO.getValueType())) { // 文本类型存到文本表
                // 插入都文本表
                DocChapterContentVO objDocChapterContentVO = new DocChapterContentVO();
                objDocChapterContentVO.setContent(objProperty.getValue());
                String strTextContentId = (String) this.docChapterContentAppService
                    .insertDocChapterContent(objDocChapterContentVO);
                objDocCommAttributeVO.setValueType("text");
                objDocCommAttributeVO.setValue(strTextContentId);
            } else {
                objDocCommAttributeVO.setValue(objProperty.getValue());
            }
            docCommAttributeAppService.insertDocCommAttribute(objDocCommAttributeVO);
        }
        return bFlag;
    }
    
    /**
     * 删除 模型对象实例。如果扩展的模型对象没有独立的存储结构，则对象本身存储在此表中，对象属性存储在CAP_DOC_COMM_ATTRIBUTE表中
     * 
     * @param docCommObject 模型对象实例。如果扩展的模型对象没有独立的存储结构，则对象本身存储在此表中，对象属性存储在CAP_DOC_COMM_ATTRIBUTE表中对象
     * @return 删除成功与否
     */
    public boolean deleteDocCommObject(DocCommObjectVO docCommObject) {
        return docCommObjectDAO.deleteDocCommObject(docCommObject);
    }
    
    /**
     * 删除 模型对象实例。如果扩展的模型对象没有独立的存储结构，则对象本身存储在此表中，对象属性存储在CAP_DOC_COMM_ATTRIBUTE表中集合
     * 
     * @param docCommObjectList 模型对象实例。如果扩展的模型对象没有独立的存储结构，则对象本身存储在此表中，对象属性存储在CAP_DOC_COMM_ATTRIBUTE表中对象
     * @return 删除成功与否
     */
    public boolean deleteDocCommObjectList(List<DocCommObjectVO> docCommObjectList) {
        if (docCommObjectList == null) {
            return true;
        }
        for (DocCommObjectVO docCommObject : docCommObjectList) {
            this.deleteDocCommObject(docCommObject);
        }
        return true;
    }
    
    /**
     * 读取 模型对象实例。如果扩展的模型对象没有独立的存储结构，则对象本身存储在此表中，对象属性存储在CAP_DOC_COMM_ATTRIBUTE表中
     * 
     * @param docCommObject 模型对象实例。如果扩展的模型对象没有独立的存储结构，则对象本身存储在此表中，对象属性存储在CAP_DOC_COMM_ATTRIBUTE表中对象
     * @return 模型对象实例。如果扩展的模型对象没有独立的存储结构，则对象本身存储在此表中，对象属性存储在CAP_DOC_COMM_ATTRIBUTE表中
     */
    public DocCommObjectVO loadDocCommObject(DocCommObjectVO docCommObject) {
        return docCommObjectDAO.loadDocCommObject(docCommObject);
    }
    
    /**
     * 根据模型对象实例。如果扩展的模型对象没有独立的存储结构，则对象本身存储在此表中，对象属性存储在CAP_DOC_COMM_ATTRIBUTE表中主键读取
     * 模型对象实例。如果扩展的模型对象没有独立的存储结构，则对象本身存储在此表中，对象属性存储在CAP_DOC_COMM_ATTRIBUTE表中
     * 
     * @param id 模型对象实例。如果扩展的模型对象没有独立的存储结构，则对象本身存储在此表中，对象属性存储在CAP_DOC_COMM_ATTRIBUTE表中主键
     * @return 模型对象实例。如果扩展的模型对象没有独立的存储结构，则对象本身存储在此表中，对象属性存储在CAP_DOC_COMM_ATTRIBUTE表中
     */
    public DocCommObjectVO loadDocCommObjectById(String id) {
        return docCommObjectDAO.loadDocCommObjectById(id);
    }
    
    /**
     * 读取 模型对象实例。如果扩展的模型对象没有独立的存储结构，则对象本身存储在此表中，对象属性存储在CAP_DOC_COMM_ATTRIBUTE表中 列表
     * 
     * @param condition 查询条件
     * @return 模型对象实例。如果扩展的模型对象没有独立的存储结构，则对象本身存储在此表中，对象属性存储在CAP_DOC_COMM_ATTRIBUTE表中列表
     */
    public List<DocCommObjectVO> queryDocCommObjectList(DocCommObjectVO condition) {
        return docCommObjectDAO.queryDocCommObjectList(condition);
    }
    
    /**
     * 读取 模型对象实例。如果扩展的模型对象没有独立的存储结构，则对象本身存储在此表中，对象属性存储在CAP_DOC_COMM_ATTRIBUTE表中 数据条数
     * 
     * @param condition 查询条件
     * @return 模型对象实例。如果扩展的模型对象没有独立的存储结构，则对象本身存储在此表中，对象属性存储在CAP_DOC_COMM_ATTRIBUTE表中数据条数
     */
    public int queryDocCommObjectCount(DocCommObjectVO condition) {
        return docCommObjectDAO.queryDocCommObjectCount(condition);
    }
    
    /**
     * 根据对象定义URI和对象ID，查询对象实例VO及对象实例属性VO
     *
     * @param docCommObject 对象实例VO
     * @return 对象实例VO
     */
    public DocCommObjectVO readObjectInstance(DocCommObjectVO docCommObject) {
        DocCommObjectVO objDocCommObjectVO = this.loadDocCommObjectById(docCommObject.getId());
        if (objDocCommObjectVO == null) {
            objDocCommObjectVO = new DocCommObjectVO();
            objDocCommObjectVO.setClassUri(docCommObject.getClassUri());
            return objDocCommObjectVO;
        }
        DocCommAttributeVO objCondition = new DocCommAttributeVO();
        objCondition.setObjectId(docCommObject.getId());
        objCondition.setClassUri(docCommObject.getClassUri());
        List<DocCommAttributeVO> lstDocCommAttribute = docCommAttributeAppService
            .queryDocCommAttributeList(objCondition);
        // 处理取值类型不同的值--文本类型、图片类型、对象类型。目前只支持text--Editor控件。图片类型和对象类型需要附件支持。
        for (Iterator<DocCommAttributeVO> iterator = lstDocCommAttribute.iterator(); iterator.hasNext();) {
            DocCommAttributeVO docCommAttributeVO = iterator.next();
            if ("text".equals(docCommAttributeVO.getValueType())) {
                docCommAttributeVO.setValue(getTextTypeValue(docCommAttributeVO.getValue()));
            }
        }
        objDocCommObjectVO.setDocCommAttributeByReattris(lstDocCommAttribute);
        return objDocCommObjectVO;
    }
    
    /**
     * 从文本表中获取文本值
     *
     * @param value 文本表ID
     * @return 文本值
     */
    private String getTextTypeValue(String value) {
        DocChapterContentVO objDocChapterContentVO = this.docChapterContentAppService.loadDocChapterContentById(value);
        return objDocChapterContentVO.getContent();
    }
    
}
