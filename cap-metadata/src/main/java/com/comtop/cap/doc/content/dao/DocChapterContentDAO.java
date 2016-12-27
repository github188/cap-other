/******************************************************************************
 * Copyright (C) 2015 ShenZhen ComTop Information Technology Co.,Ltd
 * All Rights Reserved.
 * 本软件为深圳康拓普开发研制。未经本公司正式书面同意，其他任何个人、团体不得使用、
 * 复制、修改或发布本软件.
 *****************************************************************************/

package com.comtop.cap.doc.content.dao;

import java.util.List;

import com.comtop.cap.base.MDBaseDAO;
import com.comtop.cap.doc.content.model.DocChapterContentVO;
import com.comtop.cip.jodd.jtx.JtxPropagationBehavior;
import com.comtop.cip.jodd.jtx.meta.Transaction;
import com.comtop.cip.jodd.petite.meta.PetiteBean;

/**
 * 指word中的纯文本内容、非结构化的表格内容。非结构化的表格内容以原始的表格结构字符串存储扩展DAO
 * 
 * @author 李小芬
 * @since 1.0
 * @version 2015-11-24 李小芬
 */
@PetiteBean
public class DocChapterContentDAO extends MDBaseDAO<DocChapterContentVO> {
    
    /**
     * 新增 指word中的纯文本内容、非结构化的表格内容。非结构化的表格内容以原始的表格结构字符串存储
     * 
     * @param docChapterContent 指word中的纯文本内容、非结构化的表格内容。非结构化的表格内容以原始的表格结构字符串存储对象
     * @return 指word中的纯文本内容、非结构化的表格内容。非结构化的表格内容以原始的表格结构字符串存储Id
     */
    @Transaction(propagation = JtxPropagationBehavior.PROPAGATION_REQUIRED, readOnly = false)
    public Object insertDocChapterContent(DocChapterContentVO docChapterContent) {
        Object result = insert(docChapterContent);
        return result;
    }
    
    /**
     * 更新 指word中的纯文本内容、非结构化的表格内容。非结构化的表格内容以原始的表格结构字符串存储
     * 
     * @param docChapterContent 指word中的纯文本内容、非结构化的表格内容。非结构化的表格内容以原始的表格结构字符串存储对象
     * @return 更新成功与否
     */
    @Transaction(propagation = JtxPropagationBehavior.PROPAGATION_REQUIRED, readOnly = false)
    public boolean updateDocChapterContent(DocChapterContentVO docChapterContent) {
        return update(docChapterContent);
    }
    
    /**
     * 删除 指word中的纯文本内容、非结构化的表格内容。非结构化的表格内容以原始的表格结构字符串存储
     * 
     * @param docChapterContent 指word中的纯文本内容、非结构化的表格内容。非结构化的表格内容以原始的表格结构字符串存储对象
     * @return 删除成功与否
     */
    @Transaction(propagation = JtxPropagationBehavior.PROPAGATION_REQUIRED, readOnly = false)
    public boolean deleteDocChapterContent(DocChapterContentVO docChapterContent) {
        return delete(docChapterContent);
    }
    
    /**
     * 读取 指word中的纯文本内容、非结构化的表格内容。非结构化的表格内容以原始的表格结构字符串存储
     * 
     * @param docChapterContent 指word中的纯文本内容、非结构化的表格内容。非结构化的表格内容以原始的表格结构字符串存储对象
     * @return 指word中的纯文本内容、非结构化的表格内容。非结构化的表格内容以原始的表格结构字符串存储
     */
    public DocChapterContentVO loadDocChapterContent(DocChapterContentVO docChapterContent) {
        DocChapterContentVO objDocChapterContent = load(docChapterContent);
        return objDocChapterContent;
    }
    
    /**
     * 根据指word中的纯文本内容、非结构化的表格内容。非结构化的表格内容以原始的表格结构字符串存储主键读取 指word中的纯文本内容、非结构化的表格内容。非结构化的表格内容以原始的表格结构字符串存储
     * 
     * @param id 指word中的纯文本内容、非结构化的表格内容。非结构化的表格内容以原始的表格结构字符串存储主键
     * @return 指word中的纯文本内容、非结构化的表格内容。非结构化的表格内容以原始的表格结构字符串存储
     */
    public DocChapterContentVO loadDocChapterContentById(String id) {
        DocChapterContentVO objDocChapterContent = new DocChapterContentVO();
        objDocChapterContent.setId(id);
        return loadDocChapterContent(objDocChapterContent);
    }
    
    /**
     * 读取 指word中的纯文本内容、非结构化的表格内容。非结构化的表格内容以原始的表格结构字符串存储 列表
     * 
     * @param condition 查询条件
     * @return 指word中的纯文本内容、非结构化的表格内容。非结构化的表格内容以原始的表格结构字符串存储列表
     */
    public List<DocChapterContentVO> queryDocChapterContentList(DocChapterContentVO condition) {
        return queryList("com.comtop.cap.doc.content.model.queryDocChapterContentList", condition,
            condition.getPageNo(), condition.getPageSize());
    }
    
    /**
     * 读取 指word中的纯文本内容、非结构化的表格内容。非结构化的表格内容以原始的表格结构字符串存储 数据条数
     * 
     * @param condition 查询条件
     * @return 指word中的纯文本内容、非结构化的表格内容。非结构化的表格内容以原始的表格结构字符串存储数据条数
     */
    public int queryDocChapterContentCount(DocChapterContentVO condition) {
        return ((Integer) selectOne("com.comtop.cap.doc.content.model.queryDocChapterContentCount", condition))
            .intValue();
    }
    
}
