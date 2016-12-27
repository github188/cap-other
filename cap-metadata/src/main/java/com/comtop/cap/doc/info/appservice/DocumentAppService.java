/******************************************************************************
 * Copyright (C) 2015 ShenZhen ComTop Information Technology Co.,Ltd
 * All Rights Reserved.
 * 本软件为深圳康拓普开发研制。未经本公司正式书面同意，其他任何个人、团体不得使用、
 * 复制、修改或发布本软件.
 *****************************************************************************/

package com.comtop.cap.doc.info.appservice;

import java.util.List;

import com.comtop.cap.base.MDBaseAppservice;
import com.comtop.cap.base.MDBaseDAO;
import com.comtop.cap.doc.content.appservice.DocChapterContentAppService;
import com.comtop.cap.doc.content.appservice.DocChapterContentStructAppService;
import com.comtop.cap.doc.info.dao.DocumentDAO;
import com.comtop.cap.doc.info.model.DocumentVO;
import com.comtop.cap.doc.service.DocType;
import com.comtop.cip.jodd.petite.meta.PetiteBean;
import com.comtop.cip.jodd.petite.meta.PetiteInject;

/**
 * 文档 业务逻辑处理类
 * 
 * @author 李小芬
 * @since 1.0
 * @version 2015-11-9 李小芬
 */
@PetiteBean
public class DocumentAppService extends MDBaseAppservice<DocumentVO> {
    
    /** 注入DAO **/
    @PetiteInject
    protected DocumentDAO documentDAO;
    
    /** 注入DAO **/
    @PetiteInject
    protected DocChapterContentStructAppService docChapterContentStructAppService;
    
    /** 注入DAO **/
    @PetiteInject
    protected DocChapterContentAppService docChapterContentAppService;
    
    /**
     * 新增 文档
     * 
     * @param document 文档对象
     * @return 文档Id
     */
    public Object insertDocument(DocumentVO document) {
        return documentDAO.insertDocument(document);
    }
    
    /**
     * 更新 文档
     * 
     * @param document 文档对象
     * @return 更新成功与否
     */
    public boolean updateDocument(DocumentVO document) {
        return documentDAO.updateDocument(document);
    }
    
    /**
     * 删除 文档
     * 
     * @param document 文档对象，需要文档ID、模板类型条件
     * @param bCascade 是否级联删除文档数据
     */
    public void deleteDocument(DocumentVO document, boolean bCascade) {
        documentDAO.deleteDocument(document);
        if (bCascade) {
            deleteDocumentObjectChapterData(document.getId());
            if (DocType.BIZ_MODEL.toString().equals(document.getDocType())) {
                deleteDocumentObjectBizData(document.getId());
            } else if (DocType.SRS.toString().equals(document.getDocType())) {
                deleteDocumentObjectReqData(document.getId());
            }
        }
    }
    
    /**
     * 删除 文档集合
     * 
     * @param documentList 文档对象
     */
    public void deleteDocumentList(List<DocumentVO> documentList) {
        for (DocumentVO document : documentList) {
            deleteDocument(document, true);
        }
    }
    
    /**
     * 读取 文档
     * 
     * @param document 文档对象
     * @return 文档
     */
    public DocumentVO loadDocument(DocumentVO document) {
        return documentDAO.loadDocument(document);
    }
    
    /**
     * 根据文档主键读取 文档
     * 
     * @param id 文档主键
     * @return 文档
     */
    public DocumentVO loadDocumentById(String id) {
        return documentDAO.loadDocumentById(id);
    }
    
    /**
     * 读取 文档 列表
     * 
     * @param condition 查询条件
     * @return 文档列表
     */
    public List<DocumentVO> queryDocumentList(DocumentVO condition) {
        return documentDAO.queryDocumentList(condition);
    }
    
    /**
     * 读取 文档 数据条数
     * 
     * @param condition 查询条件
     * @return 文档数据条数
     */
    public int queryDocumentCount(DocumentVO condition) {
        return documentDAO.queryDocumentCount(condition);
    }
    
    /**
     * 判断重名
     * 
     * @param document 文档对象
     * @return 存在同名时返回true，否则返回false
     */
    public List<DocumentVO> queryDocumentByName(DocumentVO document) {
        return documentDAO.queryDocumentByName(document);
    }
    
    /**
     * 根据查询条件查询文档list
     *
     * @param queryCondition 查询条件
     * @return 文档list
     */
    public List<DocumentVO> queryDocumentListByCondition(DocumentVO queryCondition) {
        return documentDAO.queryDocumentListByCondition(queryCondition);
    }
    
    @Override
    protected MDBaseDAO<DocumentVO> getDAO() {
        return this.documentDAO;
    }
    
    // @Override
    // public List<DocumentVO> loadList(DocumentVO condition) {
    // return this.queryDocumentList(condition);
    // }
    
    /**
     * 删除文档章节和通用数据
     *
     * @param documentId 条件，文档ID
     */
    private void deleteDocumentObjectChapterData(String documentId) {
        // 删除CAP_DOC_CHAPTER_CONTENT_STRUCT
        documentDAO.delete("com.comtop.cap.doc.info.model.deleteDocContentStruct", documentId);
        // 删除CAP_DOC_CHAPTER_CONTENT
        documentDAO.delete("com.comtop.cap.doc.info.model.deleteDocContent", documentId);
        // 删除cap_doc_template
        documentDAO.delete("com.comtop.cap.doc.info.model.deleteDocTemplate", documentId);
    }
    
    /**
     * 删除文档业务数据
     *
     * @param documentId 条件，文档ID
     */
    private void deleteDocumentObjectBizData(String documentId) {
        // 删除CAP_BIZ_ITEMS
        documentDAO.delete("com.comtop.cap.doc.info.model.deleteBizItems", documentId);
        // 删除CAP_BIZ_PROCESS_INFO
        documentDAO.delete("com.comtop.cap.doc.info.model.deleteBizProcessInfo", documentId);
        // 删除CAP_BIZ_PROCESS_NODE、CAP_BIZ_FORM_NODE_REL、CAP_BIZ_NODE_CONSTRAINT
        documentDAO.delete("com.comtop.cap.doc.info.model.deleteBizFormNodeRel", documentId);
        documentDAO.delete("com.comtop.cap.doc.info.model.deleteBizNodeConstraint", documentId);
        documentDAO.delete("com.comtop.cap.doc.info.model.deleteBizProcessNode", documentId);
        // 删除CAP_BIZ_OBJ_INFO
        documentDAO.delete("com.comtop.cap.doc.info.model.deleteBizObjInfo", documentId);
        // 删除CAP_BIZ_OBJ_DATA_ITEM
        documentDAO.delete("com.comtop.cap.doc.info.model.deleteBizObjDataItem", documentId);
        // 删除CAP_BIZ_FORM
        documentDAO.delete("com.comtop.cap.doc.info.model.deleteBizForm", documentId);
        // 删除CAP_BIZ_FORM_DATA
        documentDAO.delete("com.comtop.cap.doc.info.model.deleteBizFormData", documentId);
        // 删除CAP_BIZ_REL_INFO、CAP_BIZ_REL_DATA
        documentDAO.delete("com.comtop.cap.doc.info.model.deleteBizRelData", documentId);
        documentDAO.delete("com.comtop.cap.doc.info.model.deleteBizRelInfo", documentId);
        // 删除CAP_BIZ_ROLE
        documentDAO.delete("com.comtop.cap.doc.info.model.deleteBizRole", documentId);
    }
    
    /**
     * 删除文档需求数据
     *
     * @param documentId 条件，文档ID
     */
    private void deleteDocumentObjectReqData(String documentId) {
        // 删除CAP_REQ_FUNCTION_ITEM、CAP_REQ_FUNCTION_REL、CAP_REQ_FUNCTION_REL_ITEMS、CAP_REQ_FUNCTION_REL_FLOW
        documentDAO.delete("com.comtop.cap.doc.info.model.deleteReqFunctionRel", documentId);
        documentDAO.delete("com.comtop.cap.doc.info.model.deleteReqFunctionRelItems", documentId);
        documentDAO.delete("com.comtop.cap.doc.info.model.deleteReqFunctionRelFlow", documentId);
        documentDAO.delete("com.comtop.cap.doc.info.model.deleteReqFunctionItem", documentId);
        // 删除CAP_REQ_FUNCTION_DISTRIBUTED
        documentDAO.delete("com.comtop.cap.doc.info.model.deleteReqFunctionDistribute", documentId);
        // 删除CAP_REQ_FUNCTION_SUBITEM、CAP_REQ_DUTY_REL_ROLE、CAP_REQ_SUBITEM_DUTY
        documentDAO.delete("com.comtop.cap.doc.info.model.deleteReqDutyRelRole", documentId);
        documentDAO.delete("com.comtop.cap.doc.info.model.deleteReqSubitemDuty", documentId);
        documentDAO.delete("com.comtop.cap.doc.info.model.deleteReqFunctionSubitem", documentId);
        // 删除CAP_BIZ_ROLE
        documentDAO.delete("com.comtop.cap.doc.info.model.deleteBizRole", documentId);
        // 删除CAP_REQ_PAGE
        documentDAO.delete("com.comtop.cap.doc.info.model.deleteReqPage", documentId);
        // 删除CAP_REQ_FUNCTION_USECASE、CAP_REQ_USECASE_REL_FORM
        documentDAO.delete("com.comtop.cap.doc.info.model.deleteReqUsecaseRelForm", documentId);
        documentDAO.delete("com.comtop.cap.doc.info.model.deleteReqFunctionUsecase", documentId);
    }
}
