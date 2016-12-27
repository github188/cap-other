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
import java.util.regex.Matcher;
import java.util.regex.Pattern;

import org.apache.commons.lang.StringUtils;

import com.comtop.cap.doc.content.appservice.DocChapterContentAppService;
import com.comtop.cap.doc.content.appservice.DocChapterContentStructAppService;
import com.comtop.cap.doc.content.model.DocChapterContentStructVO;
import com.comtop.cap.doc.content.model.DocChapterContentVO;
import com.comtop.cap.doc.service.CommonDataManager;
import com.comtop.cap.document.expression.annotation.DocumentService;
import com.comtop.cap.document.word.dao.IWordDataAccessor;
import com.comtop.cap.document.word.docmodel.data.ContentSeg;
import com.comtop.cip.jodd.petite.meta.PetiteBean;
import com.comtop.cip.jodd.petite.meta.PetiteInject;
import com.comtop.cap.runtime.base.facade.BaseFacade;

/**
 * 章节内容服务
 *
 * @author lizhiyong
 * @since jdk1.6
 * @version 2015年11月10日 lizhiyong
 */
@PetiteBean
@DocumentService(name = "ContentSeg", dataType = ContentSeg.class)
public class ContentSegFacade extends BaseFacade implements IWordDataAccessor<ContentSeg> {
    
    /** 章节内容服务 */
    @PetiteInject
    protected DocChapterContentAppService docChapterContentAppService;
    
    /** 章节结构服务 */
    @PetiteInject
    protected DocChapterContentStructAppService docChapterContentStructAppService;
    
    /** UUID正则 */
    private static final Pattern PATTERN_UUID = Pattern.compile("[0-9A-Za-z]{32}");
    
    @Override
    public void saveData(List<ContentSeg> collection) {
        
        /** 章节表达式执行计数器 */
        Map<String, String> counterMap = new HashMap<String, String>();
        for (ContentSeg docContentSegDTO : collection) {
            DocChapterContentVO chapterContentVO = new DocChapterContentVO();
            chapterContentVO.setId(docContentSegDTO.getContentId());
            chapterContentVO.setContent(docContentSegDTO.getContent());
            String contentId = docChapterContentAppService.save(chapterContentVO).toString();
            
            DocChapterContentStructVO docChapterContentStruct = new DocChapterContentStructVO();
            String containerUri = docContentSegDTO.getContainerUri();
            Matcher matcher = PATTERN_UUID.matcher(containerUri);
            if (matcher.find()) {
                int index = containerUri.lastIndexOf('/');
                String sourceId = containerUri;
                if (index >= 0) {
                    sourceId = sourceId.substring(0, index);
                }
                String storedId = CommonDataManager.getMappingId(sourceId);
                if (StringUtils.isNotBlank(storedId)) {
                    if (counterMap.get(storedId) == null) {
                        deleteByContainerUri(storedId, docContentSegDTO.getDocumentId());
                        counterMap.put(storedId, storedId);
                    }
                    if (index >= 0) {
                        containerUri = storedId + containerUri.substring(index);
                    } else {
                        containerUri = storedId;
                    }
                }
            }
            docChapterContentStruct.setContainerUri(containerUri);
            docChapterContentStruct.setSortNo(docContentSegDTO.getSortNo());
            docChapterContentStruct.setDocumentId(docContentSegDTO.getDocumentId());
            docChapterContentStruct.setContainerType(docContentSegDTO.getContainerType());
            docChapterContentStruct.setContentId(contentId);
            docChapterContentStruct.setDataFrom(docContentSegDTO.getDataFrom());
            docChapterContentStruct.setDocumentId(docContentSegDTO.getDocumentId());
            docChapterContentStruct.setContentType(docContentSegDTO.getContentType());
            docChapterContentStruct.setId(docContentSegDTO.getId());
            docChapterContentStructAppService.save(docChapterContentStruct);
        }
    }
    
    @Override
    public List<ContentSeg> loadData(ContentSeg condition) {
        
        List<ContentSeg> alRet = docChapterContentStructAppService.loadContentSegDTOList(condition);
        for (ContentSeg docContentSegDTO : alRet) {
            docContentSegDTO.setNewData(false);
        }
        return alRet;
        
    }
    
    /**
     * 根据ID获取文档DTO
     * 
     * @param id ID
     * @return 文档DTO
     */
    public ContentSeg readByIdUri(final String id) {
        DocChapterContentStructVO structVO = docChapterContentStructAppService.readById(id);
        if (structVO != null) {
            DocChapterContentVO chapterContentVO = docChapterContentAppService.loadDocChapterContentById(structVO
                .getContentId());
            final ContentSeg contentSegDTO = new ContentSeg();
            contentSegDTO.setContainerType(structVO.getContainerType());
            contentSegDTO.setContainerUri(structVO.getContainerUri());
            contentSegDTO.setContentId(structVO.getContentId());
            contentSegDTO.setContentType(structVO.getContentType());
            contentSegDTO.setDataFrom(structVO.getDataFrom());
            contentSegDTO.setDocumentId(structVO.getDocumentId());
            contentSegDTO.setDomainId(structVO.getDomainId());
            contentSegDTO.setId(structVO.getId());
            contentSegDTO.setSortNo(structVO.getSortNo());
            if (chapterContentVO != null) {
                contentSegDTO.setContent(chapterContentVO.getContent());
            }
            contentSegDTO.setNewData(false);
            return contentSegDTO;
        }
        
        return null;
    }
    
    @Override
    public void updatePropertyByID(String id, String propertyName, Object value) {
        if ("content".equals(propertyName)) {
            docChapterContentAppService.updatePropertyById(id, propertyName, value);
        } else {
            docChapterContentStructAppService.updatePropertyById(id, propertyName, value);
        }
    }
    
    /**
     * 更新容器Uri
     *
     * @param oldUriPrefix 原来的uri前缀
     * @param newUriPrefix 新的uri 前缀
     * @param documentId 文档id
     */
    public void updateContainerUri(String oldUriPrefix, String newUriPrefix, String documentId) {
        docChapterContentStructAppService.updateContainerUri(oldUriPrefix, newUriPrefix, documentId);
    }
    
    /**
     * 根据Uri前缀删除内容更新容器Uri
     *
     * @param oldUriPrefix uri前缀
     * @param documentId 文档id
     */
    public void deleteByContainerUri(String oldUriPrefix, String documentId) {
        
        docChapterContentAppService.deleteContentByContainerUri(oldUriPrefix, documentId);
        docChapterContentStructAppService.deleteByContainerUri(oldUriPrefix, documentId);
    }
}
