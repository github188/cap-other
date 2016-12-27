/******************************************************************************
 * Copyright (C) 2015 ShenZhen ComTop Information Technology Co.,Ltd
 * All Rights Reserved.
 * 本软件为深圳康拓普开发研制。未经本公司正式书面同意，其他任何个人、团体不得使用、
 * 复制、修改或发布本软件.
 *****************************************************************************/

package com.comtop.cap.doc.info.dao;

import java.util.List;

import com.comtop.cap.base.MDBaseDAO;
import com.comtop.cap.doc.info.model.DocumentVO;
import com.comtop.cip.jodd.jtx.JtxPropagationBehavior;
import com.comtop.cip.jodd.jtx.meta.Transaction;
import com.comtop.cip.jodd.petite.meta.PetiteBean;

/**
 * 文档DAO
 * 
 * @author 李小芬
 * @since 1.0
 * @version 2015-11-9 李小芬
 */
@PetiteBean
public class DocumentDAO extends MDBaseDAO<DocumentVO> {
    
    /**
     * 新增 文档
     * 
     * @param document 文档对象
     * @return 文档Id
     */
    @Transaction(propagation = JtxPropagationBehavior.PROPAGATION_REQUIRED, readOnly = false)
    public Object insertDocument(DocumentVO document) {
        return insert(document);
    }
    
    /**
     * 更新 文档
     * 
     * @param document 文档对象
     * @return 更新成功与否
     */
    @Transaction(propagation = JtxPropagationBehavior.PROPAGATION_REQUIRED, readOnly = false)
    public boolean updateDocument(DocumentVO document) {
        return update(document);
    }
    
    /**
     * 删除 文档
     * 
     * @param document 文档对象
     * @return 删除成功与否
     */
    @Transaction(propagation = JtxPropagationBehavior.PROPAGATION_REQUIRED, readOnly = false)
    public boolean deleteDocument(DocumentVO document) {
        return delete(document);
    }
    
    /**
     * 读取 文档
     * 
     * @param document 文档对象
     * @return 文档
     */
    public DocumentVO loadDocument(DocumentVO document) {
        return load(document);
    }
    
    /**
     * 根据文档主键读取 文档
     * 
     * @param id 文档主键
     * @return 文档
     */
    public DocumentVO loadDocumentById(String id) {
        DocumentVO objDocument = new DocumentVO();
        objDocument.setId(id);
        return loadDocument(objDocument);
    }
    
    /**
     * 读取 文档 列表
     * 
     * @param condition 查询条件
     * @return 文档列表
     */
    public List<DocumentVO> queryDocumentList(DocumentVO condition) {
        return queryList("com.comtop.cap.doc.info.model.queryDocumentList", condition, condition.getPageNo(),
            condition.getPageSize());
    }
    
    /**
     * 读取 文档 数据条数
     * 
     * @param condition 查询条件
     * @return 文档数据条数
     */
    public int queryDocumentCount(DocumentVO condition) {
        return ((Integer) selectOne("com.comtop.cap.doc.info.model.queryDocumentCount", condition)).intValue();
    }
    
    /**
     * 判断重名
     * 
     * @param document 文档对象
     * @return 存在同名时返回true，否则返回false
     */
    public List<DocumentVO> queryDocumentByName(DocumentVO document) {
        return this.queryList("com.comtop.cap.doc.info.model.queryDocumentByName", document);
    }
    
    /**
     * 根据查询条件查询文档list
     *
     * @param queryCondition 查询条件
     * @return 文档list
     */
    public List<DocumentVO> queryDocumentListByCondition(DocumentVO queryCondition) {
        return this.queryList("com.comtop.cap.doc.info.model.queryDocumentListByCondition", queryCondition);
    }
    
}
