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

import com.comtop.cap.doc.content.appservice.DocChapterContentStructAppService;
import com.comtop.cap.doc.content.model.DocChapterContentStructVO;
import com.comtop.cap.doc.info.model.DocumentVO;
import com.comtop.cip.jodd.petite.meta.PetiteBean;
import com.comtop.cip.jodd.petite.meta.PetiteInject;
import com.comtop.cap.runtime.base.facade.BaseFacade;

/**
 * 章节内容结构。章节的所有内容均会在此表中存在。以类型字段区分具体的内容存储在什么地方。如果是文本、图片、嵌入式对象内容，则对应存储在文本内容表、图片内容表、嵌入式对象内容表。如果已定义的表格内容，
 * 则将表格内容对应的模型定义将其存储在已定义的模型存储结构中，比如业务事项表、业务对象表等。如果某段纯文本归属于一个已经定义的对象，则会将该文本存储在该对象自己的结构中。扩展实现
 * 
 * @author 李小芬
 * @since 1.0
 * @version 2015-11-24 李小芬
 */
@PetiteBean
public class DocChapterContentStructFacade extends BaseFacade {
    
    /** 注入AppService **/
    @PetiteInject
    protected DocChapterContentStructAppService docChapterContentStructAppService;
    
    /**
     * 新增 章节内容结构。章节的所有内容均会在此表中存在。以类型字段区分具体的内容存储在什么地方。如果是文本、图片、嵌入式对象内容，则对应存储在文本内容表、图片内容表、嵌入式对象内容表。如果已定义的表格内容，
     * 则将表格内容对应的模型定义将其存储在已定义的模型存储结构中，比如业务事项表、业务对象表等。如果某段纯文本归属于一个已经定义的对象，则会将该文本存储在该对象自己的结构中。
     * 
     * @param docChapterContentStructVO
     *            章节内容结构。章节的所有内容均会在此表中存在。以类型字段区分具体的内容存储在什么地方。如果是文本、图片、嵌入式对象内容，则对应存储在文本内容表、图片内容表、嵌入式对象内容表。如果已定义的表格内容，
     *            则将表格内容对应的模型定义将其存储在已定义的模型存储结构中，比如业务事项表、业务对象表等。如果某段纯文本归属于一个已经定义的对象，则会将该文本存储在该对象自己的结构中。对象
     * @return 章节内容结构。章节的所有内容均会在此表中存在。以类型字段区分具体的内容存储在什么地方。如果是文本、图片、嵌入式对象内容，则对应存储在文本内容表、图片内容表、嵌入式对象内容表。如果已定义的表格内容，
     *         则将表格内容对应的模型定义将其存储在已定义的模型存储结构中，比如业务事项表、业务对象表等。如果某段纯文本归属于一个已经定义的对象，则会将该文本存储在该对象自己的结构中。
     */
    public Object insertDocChapterContentStruct(DocChapterContentStructVO docChapterContentStructVO) {
        return docChapterContentStructAppService.insertDocChapterContentStruct(docChapterContentStructVO);
    }
    
    /**
     * 更新 章节内容结构。章节的所有内容均会在此表中存在。以类型字段区分具体的内容存储在什么地方。如果是文本、图片、嵌入式对象内容，则对应存储在文本内容表、图片内容表、嵌入式对象内容表。如果已定义的表格内容，
     * 则将表格内容对应的模型定义将其存储在已定义的模型存储结构中，比如业务事项表、业务对象表等。如果某段纯文本归属于一个已经定义的对象，则会将该文本存储在该对象自己的结构中。
     * 
     * @param docChapterContentStructVO
     *            章节内容结构。章节的所有内容均会在此表中存在。以类型字段区分具体的内容存储在什么地方。如果是文本、图片、嵌入式对象内容，则对应存储在文本内容表、图片内容表、嵌入式对象内容表。如果已定义的表格内容，
     *            则将表格内容对应的模型定义将其存储在已定义的模型存储结构中，比如业务事项表、业务对象表等。如果某段纯文本归属于一个已经定义的对象，则会将该文本存储在该对象自己的结构中。对象
     * @return 更新结果
     */
    public boolean updateDocChapterContentStruct(DocChapterContentStructVO docChapterContentStructVO) {
        return docChapterContentStructAppService.updateDocChapterContentStruct(docChapterContentStructVO);
    }
    
    /**
     * 保存或更新章节内容结构。章节的所有内容均会在此表中存在。以类型字段区分具体的内容存储在什么地方。如果是文本、图片、嵌入式对象内容，则对应存储在文本内容表、图片内容表、嵌入式对象内容表。如果已定义的表格内容，
     * 则将表格内容对应的模型定义将其存储在已定义的模型存储结构中，比如业务事项表、业务对象表等。如果某段纯文本归属于一个已经定义的对象，则会将该文本存储在该对象自己的结构中。，根据ID是否为空
     * 
     * @param docChapterContentStructVO
     *            章节内容结构。章节的所有内容均会在此表中存在。以类型字段区分具体的内容存储在什么地方。如果是文本、图片、嵌入式对象内容，则对应存储在文本内容表、图片内容表、嵌入式对象内容表。如果已定义的表格内容，
     *            则将表格内容对应的模型定义将其存储在已定义的模型存储结构中，比如业务事项表、业务对象表等。如果某段纯文本归属于一个已经定义的对象，则会将该文本存储在该对象自己的结构中。ID
     * @return 章节内容结构。章节的所有内容均会在此表中存在。以类型字段区分具体的内容存储在什么地方。如果是文本、图片、嵌入式对象内容，则对应存储在文本内容表、图片内容表、嵌入式对象内容表。如果已定义的表格内容，
     *         则将表格内容对应的模型定义将其存储在已定义的模型存储结构中，比如业务事项表、业务对象表等。如果某段纯文本归属于一个已经定义的对象，则会将该文本存储在该对象自己的结构中。保存后的主键ID
     */
    public String saveDocChapterContentStruct(DocChapterContentStructVO docChapterContentStructVO) {
        // if (docChapterContentStructVO.getId() == null) {
        // String strId = (String) this.insertDocChapterContentStruct(docChapterContentStructVO);
        // docChapterContentStructVO.setId(strId);
        // } else {
        // this.updateDocChapterContentStruct(docChapterContentStructVO);
        // }
        return docChapterContentStructAppService.saveDocChapterContentStruct(docChapterContentStructVO);
    }
    
    /**
     * 读取 章节内容结构。章节的所有内容均会在此表中存在。以类型字段区分具体的内容存储在什么地方。如果是文本、图片、嵌入式对象内容，则对应存储在文本内容表、图片内容表、嵌入式对象内容表。如果已定义的表格内容，
     * 则将表格内容对应的模型定义将其存储在已定义的模型存储结构中，比如业务事项表、业务对象表等。如果某段纯文本归属于一个已经定义的对象，则会将该文本存储在该对象自己的结构中。 列表，分页查询--新版设计器使用
     * 
     * @param condition 查询条件
     * @return 章节内容结构。章节的所有内容均会在此表中存在。以类型字段区分具体的内容存储在什么地方。如果是文本、图片、嵌入式对象内容，则对应存储在文本内容表、图片内容表、嵌入式对象内容表。如果已定义的表格内容，
     *         则将表格内容对应的模型定义将其存储在已定义的模型存储结构中，比如业务事项表、业务对象表等。如果某段纯文本归属于一个已经定义的对象，则会将该文本存储在该对象自己的结构中。列表
     */
    public Map<String, Object> queryDocChapterContentStructListByPage(DocChapterContentStructVO condition) {
        final Map<String, Object> ret = new HashMap<String, Object>(2);
        int count = docChapterContentStructAppService.queryDocChapterContentStructCount(condition);
        List<DocChapterContentStructVO> docChapterContentStructVOList = null;
        if (count > 0) {
            docChapterContentStructVOList = docChapterContentStructAppService
                .queryDocChapterContentStructList(condition);
        }
        ret.put("list", docChapterContentStructVOList);
        ret.put("count", count);
        return ret;
    }
    
    /**
     * 删除 章节内容结构。章节的所有内容均会在此表中存在。以类型字段区分具体的内容存储在什么地方。如果是文本、图片、嵌入式对象内容，则对应存储在文本内容表、图片内容表、嵌入式对象内容表。如果已定义的表格内容，
     * 则将表格内容对应的模型定义将其存储在已定义的模型存储结构中，比如业务事项表、业务对象表等。如果某段纯文本归属于一个已经定义的对象，则会将该文本存储在该对象自己的结构中。
     * 
     * @param docChapterContentStructVO
     *            章节内容结构。章节的所有内容均会在此表中存在。以类型字段区分具体的内容存储在什么地方。如果是文本、图片、嵌入式对象内容，则对应存储在文本内容表、图片内容表、嵌入式对象内容表。如果已定义的表格内容，
     *            则将表格内容对应的模型定义将其存储在已定义的模型存储结构中，比如业务事项表、业务对象表等。如果某段纯文本归属于一个已经定义的对象，则会将该文本存储在该对象自己的结构中。对象
     * @return 删除结果
     */
    public boolean deleteDocChapterContentStruct(DocChapterContentStructVO docChapterContentStructVO) {
        return docChapterContentStructAppService.deleteDocChapterContentStruct(docChapterContentStructVO);
    }
    
    /**
     * 删除 章节内容结构。章节的所有内容均会在此表中存在。以类型字段区分具体的内容存储在什么地方。如果是文本、图片、嵌入式对象内容，则对应存储在文本内容表、图片内容表、嵌入式对象内容表。如果已定义的表格内容，
     * 则将表格内容对应的模型定义将其存储在已定义的模型存储结构中，比如业务事项表、业务对象表等。如果某段纯文本归属于一个已经定义的对象，则会将该文本存储在该对象自己的结构中。集合
     * 
     * @param docChapterContentStructVOList
     *            章节内容结构。章节的所有内容均会在此表中存在。以类型字段区分具体的内容存储在什么地方。如果是文本、图片、嵌入式对象内容，则对应存储在文本内容表、图片内容表、嵌入式对象内容表。如果已定义的表格内容，
     *            则将表格内容对应的模型定义将其存储在已定义的模型存储结构中，比如业务事项表、业务对象表等。如果某段纯文本归属于一个已经定义的对象，则会将该文本存储在该对象自己的结构中。对象
     * @return 删除结果
     */
    public boolean deleteDocChapterContentStructList(List<DocChapterContentStructVO> docChapterContentStructVOList) {
        return docChapterContentStructAppService.deleteDocChapterContentStructList(docChapterContentStructVOList);
    }
    
    /**
     * 读取 章节内容结构。章节的所有内容均会在此表中存在。以类型字段区分具体的内容存储在什么地方。如果是文本、图片、嵌入式对象内容，则对应存储在文本内容表、图片内容表、嵌入式对象内容表。如果已定义的表格内容，
     * 则将表格内容对应的模型定义将其存储在已定义的模型存储结构中，比如业务事项表、业务对象表等。如果某段纯文本归属于一个已经定义的对象，则会将该文本存储在该对象自己的结构中。
     * 
     * @param docChapterContentStructVO
     *            章节内容结构。章节的所有内容均会在此表中存在。以类型字段区分具体的内容存储在什么地方。如果是文本、图片、嵌入式对象内容，则对应存储在文本内容表、图片内容表、嵌入式对象内容表。如果已定义的表格内容，
     *            则将表格内容对应的模型定义将其存储在已定义的模型存储结构中，比如业务事项表、业务对象表等。如果某段纯文本归属于一个已经定义的对象，则会将该文本存储在该对象自己的结构中。对象
     * @return 章节内容结构。章节的所有内容均会在此表中存在。以类型字段区分具体的内容存储在什么地方。如果是文本、图片、嵌入式对象内容，则对应存储在文本内容表、图片内容表、嵌入式对象内容表。如果已定义的表格内容，
     *         则将表格内容对应的模型定义将其存储在已定义的模型存储结构中，比如业务事项表、业务对象表等。如果某段纯文本归属于一个已经定义的对象，则会将该文本存储在该对象自己的结构中。
     */
    public DocChapterContentStructVO loadDocChapterContentStruct(DocChapterContentStructVO docChapterContentStructVO) {
        return docChapterContentStructAppService.loadDocChapterContentStruct(docChapterContentStructVO);
    }
    
    /**
     * 根据章节内容结构。章节的所有内容均会在此表中存在。以类型字段区分具体的内容存储在什么地方。如果是文本、图片、嵌入式对象内容，则对应存储在文本内容表、图片内容表、嵌入式对象内容表。如果已定义的表格内容，
     * 则将表格内容对应的模型定义将其存储在已定义的模型存储结构中，比如业务事项表、业务对象表等。如果某段纯文本归属于一个已经定义的对象，则会将该文本存储在该对象自己的结构中。主键 读取
     * 章节内容结构。章节的所有内容均会在此表中存在。以类型字段区分具体的内容存储在什么地方
     * 。如果是文本、图片、嵌入式对象内容，则对应存储在文本内容表、图片内容表、嵌入式对象内容表。如果已定义的表格内容，则将表格内容对应的模型定义将其存储在已定义的模型存储结构中
     * ，比如业务事项表、业务对象表等。如果某段纯文本归属于一个已经定义的对象，则会将该文本存储在该对象自己的结构中。
     * 
     * @param id 章节内容结构。章节的所有内容均会在此表中存在。以类型字段区分具体的内容存储在什么地方。如果是文本、图片、嵌入式对象内容，则对应存储在文本内容表、图片内容表、嵌入式对象内容表。如果已定义的表格内容，
     *            则将表格内容对应的模型定义将其存储在已定义的模型存储结构中，比如业务事项表、业务对象表等。如果某段纯文本归属于一个已经定义的对象，则会将该文本存储在该对象自己的结构中。主键
     * @return 章节内容结构。章节的所有内容均会在此表中存在。以类型字段区分具体的内容存储在什么地方。如果是文本、图片、嵌入式对象内容，则对应存储在文本内容表、图片内容表、嵌入式对象内容表。如果已定义的表格内容，
     *         则将表格内容对应的模型定义将其存储在已定义的模型存储结构中，比如业务事项表、业务对象表等。如果某段纯文本归属于一个已经定义的对象，则会将该文本存储在该对象自己的结构中。
     */
    public DocChapterContentStructVO loadDocChapterContentStructById(String id) {
        return docChapterContentStructAppService.loadDocChapterContentStructById(id);
    }
    
    /**
     * 读取 章节内容结构。章节的所有内容均会在此表中存在。以类型字段区分具体的内容存储在什么地方。如果是文本、图片、嵌入式对象内容，则对应存储在文本内容表、图片内容表、嵌入式对象内容表。如果已定义的表格内容，
     * 则将表格内容对应的模型定义将其存储在已定义的模型存储结构中，比如业务事项表、业务对象表等。如果某段纯文本归属于一个已经定义的对象，则会将该文本存储在该对象自己的结构中。 列表
     * 
     * @param condition 查询条件
     * @return 章节内容结构。章节的所有内容均会在此表中存在。以类型字段区分具体的内容存储在什么地方。如果是文本、图片、嵌入式对象内容，则对应存储在文本内容表、图片内容表、嵌入式对象内容表。如果已定义的表格内容，
     *         则将表格内容对应的模型定义将其存储在已定义的模型存储结构中，比如业务事项表、业务对象表等。如果某段纯文本归属于一个已经定义的对象，则会将该文本存储在该对象自己的结构中。列表
     */
    public List<DocChapterContentStructVO> queryDocChapterContentStructList(DocChapterContentStructVO condition) {
        return docChapterContentStructAppService.queryDocChapterContentStructList(condition);
    }
    
    /**
     * 读取 章节内容结构。章节的所有内容均会在此表中存在。以类型字段区分具体的内容存储在什么地方。如果是文本、图片、嵌入式对象内容，则对应存储在文本内容表、图片内容表、嵌入式对象内容表。如果已定义的表格内容，
     * 则将表格内容对应的模型定义将其存储在已定义的模型存储结构中，比如业务事项表、业务对象表等。如果某段纯文本归属于一个已经定义的对象，则会将该文本存储在该对象自己的结构中。 数据条数
     * 
     * @param condition 查询条件
     * @return 章节内容结构。章节的所有内容均会在此表中存在。以类型字段区分具体的内容存储在什么地方。如果是文本、图片、嵌入式对象内容，则对应存储在文本内容表、图片内容表、嵌入式对象内容表。如果已定义的表格内容，
     *         则将表格内容对应的模型定义将其存储在已定义的模型存储结构中，比如业务事项表、业务对象表等。如果某段纯文本归属于一个已经定义的对象，则会将该文本存储在该对象自己的结构中。数据条数
     */
    public int queryDocChapterContentStructCount(DocChapterContentStructVO condition) {
        return docChapterContentStructAppService.queryDocChapterContentStructCount(condition);
    }
    
    /**
     * 查询章节内容
     *
     * @param objDocChapterContentStructVO 章节内容
     * @return 章节内容
     */
    public DocChapterContentStructVO queryDocChapterContentStruct(DocChapterContentStructVO objDocChapterContentStructVO) {
        return docChapterContentStructAppService.queryDocChapterContentStruct(objDocChapterContentStructVO);
    }
    
    /**
     * 取章节树信息
     * 
     * @param documentVO 文档基本信息
     * 
     * @return 返回章节树信息
     */
    public List<DocChapterContentStructVO> getAllChapterTree(DocumentVO documentVO) {
        return docChapterContentStructAppService.getAllChapterTree(documentVO);
    }
    
    /**
     * 查询xml配置
     *
     * @param docChapterContentStructVO id信息
     * @return 内容信息
     */
    public List<DocChapterContentStructVO> getChapterXmlContentById(DocChapterContentStructVO docChapterContentStructVO) {
        return docChapterContentStructAppService.getChapterXmlContentById(docChapterContentStructVO);
    }
    
    /**
     * 懒加载树
     *
     * @param docChapterContentStructVO 树查询条件
     * @return 懒加载树
     */
    public List<DocChapterContentStructVO> getChapterTree(DocChapterContentStructVO docChapterContentStructVO) {
        return docChapterContentStructAppService.getChapterTree(docChapterContentStructVO);
    }
    
    /**
     * 将对应功能子项原型页面截图保存到文档对应章节内容中，保证需求文档中功能子项下的界面原型里的内容完整。
     * @param reqFunctionSubitemId 功能子项id
     * @return true 成功，false 失败
     */
    public boolean saveReqFunctionPrototype(String reqFunctionSubitemId) {
    	return docChapterContentStructAppService.saveReqFunctionPrototype(reqFunctionSubitemId);
    }
    
    /**
     * 将用户在线增加的功能子项下原型页面截图保存到指定文档对应章节内容中，保证需求文档中功能子项下的界面原型里的内容完整。
     * <p>
     * 	由于用户在线增加的功能子项是不属于任何文档的，若使用方法  {@link com.comtop.cap.doc.content.facade.DocChapterContentStructFacade#saveReqFunctionPrototype}
     * 无法达到预期的目的。因此提供了本方法用于在处理这类功能子项，该方法是在文档第一次创建时调用。
     * </p>
     * @param documentId 文档id
     * @param domainId 业务域id
     */
    public void saveNoDocReqFunctionPrototype(String documentId, String domainId) {
    	docChapterContentStructAppService.saveNoDocReqFunctionPrototype(documentId, domainId);
    }
    
}
