/******************************************************************************
 * Copyright (C) 2015 ShenZhen ComTop Information Technology Co.,Ltd
 * All Rights Reserved.
 * 本软件为深圳康拓普开发研制。未经本公司正式书面同意，其他任何个人、团体不得使用、
 * 复制、修改或发布本软件.
 *****************************************************************************/

package com.comtop.cap.doc.content.facade;

import java.util.HashMap;
import java.util.List;
import java.util.Map;

import com.comtop.cap.doc.content.appservice.DocChapterContentAppService;
import com.comtop.cap.doc.content.model.DocChapterContentVO;
import com.comtop.cip.jodd.petite.meta.PetiteBean;
import com.comtop.cip.jodd.petite.meta.PetiteInject;
import com.comtop.cap.runtime.base.facade.BaseFacade;

/**
 * 指word中的纯文本内容、非结构化的表格内容。非结构化的表格内容以原始的表格结构字符串存储扩展实现
 * 
 * @author 李小芬
 * @since 1.0
 * @version 2015-11-24 李小芬
 */
@PetiteBean
public class DocChapterContentFacade extends BaseFacade {
    
    /** 注入AppService **/
    @PetiteInject
    protected DocChapterContentAppService docChapterContentAppService;
    
    /**
     * 新增 指word中的纯文本内容、非结构化的表格内容。非结构化的表格内容以原始的表格结构字符串存储
     * 
     * @param docChapterContentVO 指word中的纯文本内容、非结构化的表格内容。非结构化的表格内容以原始的表格结构字符串存储对象
     * @return 指word中的纯文本内容、非结构化的表格内容。非结构化的表格内容以原始的表格结构字符串存储
     */
    public Object insertDocChapterContent(DocChapterContentVO docChapterContentVO) {
        return docChapterContentAppService.insertDocChapterContent(docChapterContentVO);
    }
    
    /**
     * 更新 指word中的纯文本内容、非结构化的表格内容。非结构化的表格内容以原始的表格结构字符串存储
     * 
     * @param docChapterContentVO 指word中的纯文本内容、非结构化的表格内容。非结构化的表格内容以原始的表格结构字符串存储对象
     * @return 更新结果
     */
    public boolean updateDocChapterContent(DocChapterContentVO docChapterContentVO) {
        return docChapterContentAppService.updateDocChapterContent(docChapterContentVO);
    }
    
    /**
     * 保存或更新指word中的纯文本内容、非结构化的表格内容。非结构化的表格内容以原始的表格结构字符串存储，根据ID是否为空
     * 
     * @param docChapterContentVO 指word中的纯文本内容、非结构化的表格内容。非结构化的表格内容以原始的表格结构字符串存储ID
     * @return 指word中的纯文本内容、非结构化的表格内容。非结构化的表格内容以原始的表格结构字符串存储保存后的主键ID
     */
    public String saveDocChapterContent(DocChapterContentVO docChapterContentVO) {
        if (docChapterContentVO.getId() == null) {
            String strId = (String) this.insertDocChapterContent(docChapterContentVO);
            docChapterContentVO.setId(strId);
        } else {
            this.updateDocChapterContent(docChapterContentVO);
        }
        return docChapterContentVO.getId();
    }
    
    /**
     * 读取 指word中的纯文本内容、非结构化的表格内容。非结构化的表格内容以原始的表格结构字符串存储 列表，分页查询--新版设计器使用
     * 
     * @param condition 查询条件
     * @return 指word中的纯文本内容、非结构化的表格内容。非结构化的表格内容以原始的表格结构字符串存储列表
     */
    public Map<String, Object> queryDocChapterContentListByPage(DocChapterContentVO condition) {
        final Map<String, Object> ret = new HashMap<String, Object>(2);
        int count = docChapterContentAppService.queryDocChapterContentCount(condition);
        List<DocChapterContentVO> docChapterContentVOList = null;
        if (count > 0) {
            docChapterContentVOList = docChapterContentAppService.queryDocChapterContentList(condition);
        }
        ret.put("list", docChapterContentVOList);
        ret.put("count", count);
        return ret;
    }
    
    /**
     * 删除 指word中的纯文本内容、非结构化的表格内容。非结构化的表格内容以原始的表格结构字符串存储
     * 
     * @param docChapterContentVO 指word中的纯文本内容、非结构化的表格内容。非结构化的表格内容以原始的表格结构字符串存储对象
     * @return 删除结果
     */
    public boolean deleteDocChapterContent(DocChapterContentVO docChapterContentVO) {
        return docChapterContentAppService.deleteDocChapterContent(docChapterContentVO);
    }
    
    /**
     * 删除 指word中的纯文本内容、非结构化的表格内容。非结构化的表格内容以原始的表格结构字符串存储集合
     * 
     * @param docChapterContentVOList 指word中的纯文本内容、非结构化的表格内容。非结构化的表格内容以原始的表格结构字符串存储对象
     * @return 删除结果
     */
    public boolean deleteDocChapterContentList(List<DocChapterContentVO> docChapterContentVOList) {
        return docChapterContentAppService.deleteDocChapterContentList(docChapterContentVOList);
    }
    
    /**
     * 读取 指word中的纯文本内容、非结构化的表格内容。非结构化的表格内容以原始的表格结构字符串存储
     * 
     * @param docChapterContentVO 指word中的纯文本内容、非结构化的表格内容。非结构化的表格内容以原始的表格结构字符串存储对象
     * @return 指word中的纯文本内容、非结构化的表格内容。非结构化的表格内容以原始的表格结构字符串存储
     */
    public DocChapterContentVO loadDocChapterContent(DocChapterContentVO docChapterContentVO) {
        return docChapterContentAppService.loadDocChapterContent(docChapterContentVO);
    }
    
    /**
     * 根据指word中的纯文本内容、非结构化的表格内容。非结构化的表格内容以原始的表格结构字符串存储主键 读取 指word中的纯文本内容、非结构化的表格内容。非结构化的表格内容以原始的表格结构字符串存储
     * 
     * @param id 指word中的纯文本内容、非结构化的表格内容。非结构化的表格内容以原始的表格结构字符串存储主键
     * @return 指word中的纯文本内容、非结构化的表格内容。非结构化的表格内容以原始的表格结构字符串存储
     */
    public DocChapterContentVO loadDocChapterContentById(String id) {
        return docChapterContentAppService.loadDocChapterContentById(id);
    }
    
    /**
     * 读取 指word中的纯文本内容、非结构化的表格内容。非结构化的表格内容以原始的表格结构字符串存储 列表
     * 
     * @param condition 查询条件
     * @return 指word中的纯文本内容、非结构化的表格内容。非结构化的表格内容以原始的表格结构字符串存储列表
     */
    public List<DocChapterContentVO> queryDocChapterContentList(DocChapterContentVO condition) {
        return docChapterContentAppService.queryDocChapterContentList(condition);
    }
    
    /**
     * 读取 指word中的纯文本内容、非结构化的表格内容。非结构化的表格内容以原始的表格结构字符串存储 数据条数
     * 
     * @param condition 查询条件
     * @return 指word中的纯文本内容、非结构化的表格内容。非结构化的表格内容以原始的表格结构字符串存储数据条数
     */
    public int queryDocChapterContentCount(DocChapterContentVO condition) {
        return docChapterContentAppService.queryDocChapterContentCount(condition);
    }
}
