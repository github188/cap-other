/******************************************************************************
 * Copyright (C) 2015 ShenZhen ComTop Information Technology Co.,Ltd
 * All Rights Reserved.
 * 本软件为深圳康拓普开发研制。未经本公司正式书面同意，其他任何个人、团体不得使用、
 * 复制、修改或发布本软件.
 *****************************************************************************/

package com.comtop.cap.doc.content.appservice;

import java.io.IOException;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;

import com.comtop.cap.base.MDBaseAppservice;
import com.comtop.cap.base.MDBaseDAO;
import com.comtop.cap.bm.req.prototype.design.model.PrototypeVO;
import com.comtop.cap.component.loader.util.LoaderUtil;
import com.comtop.cap.doc.content.dao.DocChapterContentDAO;
import com.comtop.cap.doc.content.model.DocChapterContentVO;
import com.comtop.cap.doc.util.DocImageUtil;
import com.comtop.cip.jodd.petite.meta.PetiteBean;
import com.comtop.cip.jodd.petite.meta.PetiteInject;

/**
 * 指word中的纯文本内容、非结构化的表格内容。非结构化的表格内容以原始的表格结构字符串存储服务扩展类
 * 
 * @author 李小芬
 * @since 1.0
 * @version 2015-11-24 李小芬
 */
@PetiteBean
public class DocChapterContentAppService extends MDBaseAppservice<DocChapterContentVO> {
    
	/** log */
	private static Logger log = LoggerFactory.getLogger(DocChapterContentAppService.class);
	
    /** 注入DAO **/
    @PetiteInject
    protected DocChapterContentDAO docChapterContentDAO;
    
    /**
     * 新增 指word中的纯文本内容、非结构化的表格内容。非结构化的表格内容以原始的表格结构字符串存储
     * 
     * @param docChapterContent 指word中的纯文本内容、非结构化的表格内容。非结构化的表格内容以原始的表格结构字符串存储对象
     * @return 指word中的纯文本内容、非结构化的表格内容。非结构化的表格内容以原始的表格结构字符串存储Id
     */
    public Object insertDocChapterContent(DocChapterContentVO docChapterContent) {
        return docChapterContentDAO.insertDocChapterContent(docChapterContent);
    }
    
    /**
     * 更新 指word中的纯文本内容、非结构化的表格内容。非结构化的表格内容以原始的表格结构字符串存储
     * 
     * @param docChapterContent 指word中的纯文本内容、非结构化的表格内容。非结构化的表格内容以原始的表格结构字符串存储对象
     * @return 更新成功与否
     */
    public boolean updateDocChapterContent(DocChapterContentVO docChapterContent) {
        return docChapterContentDAO.updateDocChapterContent(docChapterContent);
    }
    
    /**
     * 删除 指word中的纯文本内容、非结构化的表格内容。非结构化的表格内容以原始的表格结构字符串存储
     * 
     * @param docChapterContent 指word中的纯文本内容、非结构化的表格内容。非结构化的表格内容以原始的表格结构字符串存储对象
     * @return 删除成功与否
     */
    public boolean deleteDocChapterContent(DocChapterContentVO docChapterContent) {
        return docChapterContentDAO.deleteDocChapterContent(docChapterContent);
    }
    
    /**
     * 删除 指word中的纯文本内容、非结构化的表格内容。非结构化的表格内容以原始的表格结构字符串存储集合
     * 
     * @param docChapterContentList 指word中的纯文本内容、非结构化的表格内容。非结构化的表格内容以原始的表格结构字符串存储对象
     * @return 删除成功与否
     */
    public boolean deleteDocChapterContentList(List<DocChapterContentVO> docChapterContentList) {
        if (docChapterContentList == null) {
            return true;
        }
        for (DocChapterContentVO docChapterContent : docChapterContentList) {
            this.deleteDocChapterContent(docChapterContent);
        }
        return true;
    }
    
    /**
     * 读取 指word中的纯文本内容、非结构化的表格内容。非结构化的表格内容以原始的表格结构字符串存储
     * 
     * @param docChapterContent 指word中的纯文本内容、非结构化的表格内容。非结构化的表格内容以原始的表格结构字符串存储对象
     * @return 指word中的纯文本内容、非结构化的表格内容。非结构化的表格内容以原始的表格结构字符串存储
     */
    public DocChapterContentVO loadDocChapterContent(DocChapterContentVO docChapterContent) {
        return docChapterContentDAO.loadDocChapterContent(docChapterContent);
    }
    
    /**
     * 根据指word中的纯文本内容、非结构化的表格内容。非结构化的表格内容以原始的表格结构字符串存储主键读取 指word中的纯文本内容、非结构化的表格内容。非结构化的表格内容以原始的表格结构字符串存储
     * 
     * @param id 指word中的纯文本内容、非结构化的表格内容。非结构化的表格内容以原始的表格结构字符串存储主键
     * @return 指word中的纯文本内容、非结构化的表格内容。非结构化的表格内容以原始的表格结构字符串存储
     */
    public DocChapterContentVO loadDocChapterContentById(String id) {
        return docChapterContentDAO.loadDocChapterContentById(id);
    }
    
    /**
     * 读取 指word中的纯文本内容、非结构化的表格内容。非结构化的表格内容以原始的表格结构字符串存储 列表
     * 
     * @param condition 查询条件
     * @return 指word中的纯文本内容、非结构化的表格内容。非结构化的表格内容以原始的表格结构字符串存储列表
     */
    public List<DocChapterContentVO> queryDocChapterContentList(DocChapterContentVO condition) {
        return docChapterContentDAO.queryDocChapterContentList(condition);
    }
    
    /**
     * 读取 指word中的纯文本内容、非结构化的表格内容。非结构化的表格内容以原始的表格结构字符串存储 数据条数
     * 
     * @param condition 查询条件
     * @return 指word中的纯文本内容、非结构化的表格内容。非结构化的表格内容以原始的表格结构字符串存储数据条数
     */
    public int queryDocChapterContentCount(DocChapterContentVO condition) {
        return docChapterContentDAO.queryDocChapterContentCount(condition);
    }
    
    @Override
    protected MDBaseDAO<DocChapterContentVO> getDAO() {
        return docChapterContentDAO;
    }
    
    /**
     * 根据Uri前缀删除内容更新容器Uri
     *
     * @param oldUriPrefix uri前缀
     * @param documentId 文档id
     */
    public void deleteContentByContainerUri(String oldUriPrefix, String documentId) {
        Map<String, String> params = new HashMap<String, String>();
        params.put("oldUriPrefix", oldUriPrefix);
        params.put("documentId", documentId);
        docChapterContentDAO.delete("com.comtop.cap.doc.content.model.deleteContentByContainerUri", params);
    }

	/**
	 * 将用户设计的原型页面截图插入到文档对应章节内容中，保证需求文档中功能子项下的界面原型里的内容完整。
	 * @param prototypeVOList 功能子项对应页面原型对象
	 * @return DocChapterContentVO
	 */
	public DocChapterContentVO insertProtoTypeChapterContent(List<PrototypeVO> prototypeVOList) {
		DocChapterContentVO docChapterContentVO = new DocChapterContentVO();
		docChapterContentVO.setContent(getProtoTypeHTML(prototypeVOList));
		docChapterContentVO.setId(insert(docChapterContentVO));
		return docChapterContentVO;
	}
	
	/**
	 * 将用户设计的原型页面截图插入到文档对应章节内容中，保证需求文档中功能子项下的界面原型里的内容完整。
	 * @param docChapterContentId ChapterContentId
	 * @param prototypeVOList 功能子项对应页面原型对象
	 * @return DocChapterContentVO
	 */
	public boolean updateProtoTypeChapterContent(String docChapterContentId, List<PrototypeVO> prototypeVOList) {
		DocChapterContentVO docChapterContentVO = new DocChapterContentVO();
		docChapterContentVO.setId(docChapterContentId);
		docChapterContentVO.setContent(getProtoTypeHTML(prototypeVOList));
		return update(docChapterContentVO);
	}

	/**
	 * FIXME 
	 * @param prototypeVOList 功能子项对应页面原型对象
	 * @return ProtoTypeHTML
	 */
	private String getProtoTypeHTML(List<PrototypeVO> prototypeVOList) {
		if(prototypeVOList == null || prototypeVOList.isEmpty()) {
			return null;
		}
		StringBuilder sb = new StringBuilder();
		for(PrototypeVO prototypeVO : prototypeVOList) {
			String imageUrl = null;
			int[] imageSize = null;
			try {
			imageUrl = LoaderUtil.getVisitUrl() + prototypeVO.getImageURL();
			imageSize = DocImageUtil.getImageSize(imageUrl, 700);
			
			} catch (IOException e) {
				log.warn("获取原型图片宽高失败,将使用默认宽高,原型图片url{}.", imageUrl, e);
				imageSize = new int[]{700,700};
			}
			sb.append("<p style=\"text-align: center;\">");
			sb.append("<img src=\"" + imageUrl + "\" width=\""+ imageSize[0] + "\" height=\"" + imageSize[1] + "\" border=\"0\" vspace=\"0\" title=\"\"/>");
			sb.append("</p>");
			sb.append("<p style=\"text-align: center;\">");
			sb.append(prototypeVO.getCname());
			sb.append("</p>");
		}
		return sb.toString();
	}
}
