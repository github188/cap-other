/******************************************************************************
 * Copyright (C) 2015 ShenZhen ComTop Information Technology Co.,Ltd
 * All Rights Reserved.
 * 本软件为深圳康拓普开发研制。未经本公司正式书面同意，其他任何个人、团体不得使用、
 * 复制、修改或发布本软件.
 *****************************************************************************/

package com.comtop.cap.doc.info.facade;

import java.util.HashMap;
import java.util.List;
import java.util.Map;

import com.comtop.cap.doc.content.facade.DocChapterContentStructFacade;
import com.comtop.cap.doc.info.appservice.DocumentAppService;
import com.comtop.cap.doc.info.model.DocumentDTO;
import com.comtop.cap.doc.info.model.DocumentVO;
import com.comtop.cap.document.expression.annotation.DocumentService;
import com.comtop.cap.document.word.dao.IWordDataAccessor;
import com.comtop.cip.jodd.petite.meta.PetiteBean;
import com.comtop.cip.jodd.petite.meta.PetiteInject;
import com.comtop.cap.runtime.base.facade.BaseFacade;

/**
 * 文档 业务逻辑处理类 门面
 * 
 * @author 李小芬
 * @since 1.0
 * @version 2015-11-9 李小芬
 */
@PetiteBean
@DocumentService(name = "Document", dataType = DocumentDTO.class)
public class DocumentFacade extends BaseFacade implements IWordDataAccessor<DocumentDTO> {
    
    /** 注入AppService **/
    @PetiteInject
    protected DocumentAppService documentAppService;

    /** 注入AppService **/
    @PetiteInject
    protected DocChapterContentStructFacade docChapterContentStructFacade;
    
    /**
     * 新增 文档
     * 
     * @param documentVO 文档对象
     * @return 文档
     */
    public Object insertDocument(DocumentVO documentVO) {
    	String documentId = (String) documentAppService.insertDocument(documentVO);
    	docChapterContentStructFacade.saveNoDocReqFunctionPrototype(documentId, documentVO.getBizDomain());
        return documentId;
    }
    
    /**
     * 更新 文档
     * 
     * @param documentVO 文档对象
     * @return 更新结果
     */
    public boolean updateDocument(DocumentVO documentVO) {
        return documentAppService.updateDocument(documentVO);
    }
    
    /**
     * 保存或更新文档，根据ID是否为空
     * 
     * @param documentVO 文档ID
     * @return 文档保存后的主键ID
     */
    public String saveDocument(DocumentVO documentVO) {
        if (documentVO.getId() == null) {
            String strId = (String) this.insertDocument(documentVO);
            documentVO.setId(strId);
        } else {
            this.updateDocument(documentVO);
        }
        return documentVO.getId();
    }
    
    /**
     * 读取 文档 列表，分页查询--新版设计器使用
     * 
     * @param condition 查询条件
     * @return 文档列表
     */
    public Map<String, Object> queryDocumentListByPage(DocumentVO condition) {
        final Map<String, Object> ret = new HashMap<String, Object>(2);
        int count = documentAppService.queryDocumentCount(condition);
        List<DocumentVO> documentVOList = null;
        if (count > 0) {
            documentVOList = documentAppService.queryDocumentList(condition);
        }
        ret.put("list", documentVOList);
        ret.put("count", count);
        return ret;
    }
    
    /**
     * 删除 文档
     * 
     * @param documentVO 文档对象
     * @param bCascade 是否级联删除文档对象
     */
    public void deleteDocument(DocumentVO documentVO, boolean bCascade) {
        documentAppService.deleteDocument(documentVO, bCascade);
    }
    
    /**
     * 删除 文档集合
     * 
     * @param documentVOList 文档对象
     */
    public void deleteDocumentList(List<DocumentVO> documentVOList) {
        documentAppService.deleteDocumentList(documentVOList);
    }
    
    /**
     * 读取 文档
     * 
     * @param documentVO 文档对象
     * @return 文档
     */
    public DocumentVO loadDocument(DocumentVO documentVO) {
        return documentAppService.loadDocument(documentVO);
    }
    
    /**
     * 根据文档主键 读取 文档
     * 
     * @param id 文档主键
     * @return 文档
     */
    public DocumentVO loadDocumentById(String id) {
        return documentAppService.loadDocumentById(id);
    }
    
    /**
     * 读取 文档 列表
     * 
     * @param condition 查询条件
     * @return 文档列表
     */
    public List<DocumentVO> queryDocumentList(DocumentVO condition) {
        return documentAppService.queryDocumentList(condition);
    }
    
    /**
     * 读取 文档 数据条数
     * 
     * @param condition 查询条件
     * @return 文档数据条数
     */
    public int queryDocumentCount(DocumentVO condition) {
        return documentAppService.queryDocumentCount(condition);
    }
    
    /**
     * 判断重名
     * 
     * @param document 文档对象
     * @return 存在同名时返回true，否则返回false
     */
    public List<DocumentVO> queryDocumentByName(DocumentVO document) {
        return documentAppService.queryDocumentByName(document);
    }
    
    @Override
    public void saveData(List<DocumentDTO> collection) {
        //
    }
    
    @Override
    public List<DocumentDTO> loadData(DocumentDTO condition) {
        return null;
    }
    
    @Override
    public void updatePropertyByID(String id, String propertyName, Object value) {
        documentAppService.updatePropertyById(id, propertyName, value);
    }
}
