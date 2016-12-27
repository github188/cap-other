/******************************************************************************
 * Copyright (C) 2015 ShenZhen ComTop Information Technology Co.,Ltd
 * All Rights Reserved.
 * 本软件为深圳康拓普开发研制。未经本公司正式书面同意，其他任何个人、团体不得使用、
 * 复制、修改或发布本软件.
 *****************************************************************************/

package com.comtop.cap.doc.content.dao;

import java.util.List;

import com.comtop.cap.doc.content.model.DocCommObjectVO;
import com.comtop.cip.jodd.jtx.JtxPropagationBehavior;
import com.comtop.cip.jodd.jtx.meta.Transaction;
import com.comtop.cip.jodd.petite.meta.PetiteBean;
import com.comtop.top.core.base.dao.CoreDAO;

/**
 * 模型对象实例。如果扩展的模型对象没有独立的存储结构，则对象本身存储在此表中，对象属性存储在CAP_DOC_COMM_ATTRIBUTE表中DAO
 * 
 * @author 李小芬
 * @since 1.0
 * @version 2015-11-11 李小芬
 */
@PetiteBean
public class DocCommObjectDAO extends CoreDAO<DocCommObjectVO> {
    
    /**
     * 新增 模型对象实例。如果扩展的模型对象没有独立的存储结构，则对象本身存储在此表中，对象属性存储在CAP_DOC_COMM_ATTRIBUTE表中
     * 
     * @param docCommObject 模型对象实例。如果扩展的模型对象没有独立的存储结构，则对象本身存储在此表中，对象属性存储在CAP_DOC_COMM_ATTRIBUTE表中对象
     * @return 模型对象实例。如果扩展的模型对象没有独立的存储结构，则对象本身存储在此表中，对象属性存储在CAP_DOC_COMM_ATTRIBUTE表中Id
     */
    @Transaction(propagation = JtxPropagationBehavior.PROPAGATION_REQUIRED, readOnly = false)
    public Object insertDocCommObject(DocCommObjectVO docCommObject) {
        Object result = insert(docCommObject);
        return result;
    }
    
    /**
     * 更新 模型对象实例。如果扩展的模型对象没有独立的存储结构，则对象本身存储在此表中，对象属性存储在CAP_DOC_COMM_ATTRIBUTE表中
     * 
     * @param docCommObject 模型对象实例。如果扩展的模型对象没有独立的存储结构，则对象本身存储在此表中，对象属性存储在CAP_DOC_COMM_ATTRIBUTE表中对象
     * @return 更新成功与否
     */
    @Transaction(propagation = JtxPropagationBehavior.PROPAGATION_REQUIRED, readOnly = false)
    public boolean updateDocCommObject(DocCommObjectVO docCommObject) {
        return update(docCommObject);
    }
    
    /**
     * 删除 模型对象实例。如果扩展的模型对象没有独立的存储结构，则对象本身存储在此表中，对象属性存储在CAP_DOC_COMM_ATTRIBUTE表中
     * 
     * @param docCommObject 模型对象实例。如果扩展的模型对象没有独立的存储结构，则对象本身存储在此表中，对象属性存储在CAP_DOC_COMM_ATTRIBUTE表中对象
     * @return 删除成功与否
     */
    @Transaction(propagation = JtxPropagationBehavior.PROPAGATION_REQUIRED, readOnly = false)
    public boolean deleteDocCommObject(DocCommObjectVO docCommObject) {
        return delete(docCommObject);
    }
    
    /**
     * 读取 模型对象实例。如果扩展的模型对象没有独立的存储结构，则对象本身存储在此表中，对象属性存储在CAP_DOC_COMM_ATTRIBUTE表中
     * 
     * @param docCommObject 模型对象实例。如果扩展的模型对象没有独立的存储结构，则对象本身存储在此表中，对象属性存储在CAP_DOC_COMM_ATTRIBUTE表中对象
     * @return 模型对象实例。如果扩展的模型对象没有独立的存储结构，则对象本身存储在此表中，对象属性存储在CAP_DOC_COMM_ATTRIBUTE表中
     */
    public DocCommObjectVO loadDocCommObject(DocCommObjectVO docCommObject) {
        DocCommObjectVO objDocCommObject = load(docCommObject);
        return objDocCommObject;
    }
    
    /**
     * 根据模型对象实例。如果扩展的模型对象没有独立的存储结构，则对象本身存储在此表中，对象属性存储在CAP_DOC_COMM_ATTRIBUTE表中主键读取
     * 模型对象实例。如果扩展的模型对象没有独立的存储结构，则对象本身存储在此表中，对象属性存储在CAP_DOC_COMM_ATTRIBUTE表中
     * 
     * @param id 模型对象实例。如果扩展的模型对象没有独立的存储结构，则对象本身存储在此表中，对象属性存储在CAP_DOC_COMM_ATTRIBUTE表中主键
     * @return 模型对象实例。如果扩展的模型对象没有独立的存储结构，则对象本身存储在此表中，对象属性存储在CAP_DOC_COMM_ATTRIBUTE表中
     */
    public DocCommObjectVO loadDocCommObjectById(String id) {
        DocCommObjectVO objDocCommObject = new DocCommObjectVO();
        objDocCommObject.setId(id);
        return loadDocCommObject(objDocCommObject);
    }
    
    /**
     * 读取 模型对象实例。如果扩展的模型对象没有独立的存储结构，则对象本身存储在此表中，对象属性存储在CAP_DOC_COMM_ATTRIBUTE表中 列表
     * 
     * @param condition 查询条件
     * @return 模型对象实例。如果扩展的模型对象没有独立的存储结构，则对象本身存储在此表中，对象属性存储在CAP_DOC_COMM_ATTRIBUTE表中列表
     */
    public List<DocCommObjectVO> queryDocCommObjectList(DocCommObjectVO condition) {
        return queryList("com.comtop.cap.doc.content.model.queryDocCommObjectList", condition, condition.getPageNo(),
            condition.getPageSize());
    }
    
    /**
     * 读取 模型对象实例。如果扩展的模型对象没有独立的存储结构，则对象本身存储在此表中，对象属性存储在CAP_DOC_COMM_ATTRIBUTE表中 数据条数
     * 
     * @param condition 查询条件
     * @return 模型对象实例。如果扩展的模型对象没有独立的存储结构，则对象本身存储在此表中，对象属性存储在CAP_DOC_COMM_ATTRIBUTE表中数据条数
     */
    public int queryDocCommObjectCount(DocCommObjectVO condition) {
        return ((Integer) selectOne("com.comtop.cap.doc.content.model.queryDocCommObjectCount", condition)).intValue();
    }
    
}
