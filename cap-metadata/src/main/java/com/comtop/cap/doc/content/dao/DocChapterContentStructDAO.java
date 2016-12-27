/******************************************************************************
 * Copyright (C) 2015 ShenZhen ComTop Information Technology Co.,Ltd
 * All Rights Reserved.
 * 本软件为深圳康拓普开发研制。未经本公司正式书面同意，其他任何个人、团体不得使用、
 * 复制、修改或发布本软件.
 *****************************************************************************/

package com.comtop.cap.doc.content.dao;

import java.util.List;

import com.comtop.cap.base.MDBaseDAO;
import com.comtop.cap.doc.content.model.DocChapterContentStructVO;
import com.comtop.cip.jodd.jtx.JtxPropagationBehavior;
import com.comtop.cip.jodd.jtx.meta.Transaction;
import com.comtop.cip.jodd.petite.meta.PetiteBean;

/**
 * 章节内容结构。章节的所有内容均会在此表中存在。以类型字段区分具体的内容存储在什么地方。如果是文本、图片、嵌入式对象内容，则对应存储在文本内容表、图片内容表、嵌入式对象内容表。如果已定义的表格内容，
 * 则将表格内容对应的模型定义将其存储在已定义的模型存储结构中，比如业务事项表、业务对象表等。如果某段纯文本归属于一个已经定义的对象，则会将该文本存储在该对象自己的结构中。扩展DAO
 * 
 * @author 李小芬
 * @since 1.0
 * @version 2015-11-24 李小芬
 */
@PetiteBean
public class DocChapterContentStructDAO extends MDBaseDAO<DocChapterContentStructVO> {
    
    /**
     * 新增 章节内容结构。章节的所有内容均会在此表中存在。以类型字段区分具体的内容存储在什么地方。如果是文本、图片、嵌入式对象内容，则对应存储在文本内容表、图片内容表、嵌入式对象内容表。如果已定义的表格内容，
     * 则将表格内容对应的模型定义将其存储在已定义的模型存储结构中，比如业务事项表、业务对象表等。如果某段纯文本归属于一个已经定义的对象，则会将该文本存储在该对象自己的结构中。
     * 
     * @param docChapterContentStruct
     *            章节内容结构。章节的所有内容均会在此表中存在。以类型字段区分具体的内容存储在什么地方。如果是文本、图片、嵌入式对象内容，则对应存储在文本内容表、图片内容表、嵌入式对象内容表。如果已定义的表格内容，
     *            则将表格内容对应的模型定义将其存储在已定义的模型存储结构中，比如业务事项表、业务对象表等。如果某段纯文本归属于一个已经定义的对象，则会将该文本存储在该对象自己的结构中。对象
     * @return 章节内容结构。章节的所有内容均会在此表中存在。以类型字段区分具体的内容存储在什么地方。如果是文本、图片、嵌入式对象内容，则对应存储在文本内容表、图片内容表、嵌入式对象内容表。如果已定义的表格内容，
     *         则将表格内容对应的模型定义将其存储在已定义的模型存储结构中，比如业务事项表、业务对象表等。如果某段纯文本归属于一个已经定义的对象，则会将该文本存储在该对象自己的结构中。Id
     */
    @Transaction(propagation = JtxPropagationBehavior.PROPAGATION_REQUIRED, readOnly = false)
    public Object insertDocChapterContentStruct(DocChapterContentStructVO docChapterContentStruct) {
        Object result = insert(docChapterContentStruct);
        return result;
    }
    
    /**
     * 更新 章节内容结构。章节的所有内容均会在此表中存在。以类型字段区分具体的内容存储在什么地方。如果是文本、图片、嵌入式对象内容，则对应存储在文本内容表、图片内容表、嵌入式对象内容表。如果已定义的表格内容，
     * 则将表格内容对应的模型定义将其存储在已定义的模型存储结构中，比如业务事项表、业务对象表等。如果某段纯文本归属于一个已经定义的对象，则会将该文本存储在该对象自己的结构中。
     * 
     * @param docChapterContentStruct
     *            章节内容结构。章节的所有内容均会在此表中存在。以类型字段区分具体的内容存储在什么地方。如果是文本、图片、嵌入式对象内容，则对应存储在文本内容表、图片内容表、嵌入式对象内容表。如果已定义的表格内容，
     *            则将表格内容对应的模型定义将其存储在已定义的模型存储结构中，比如业务事项表、业务对象表等。如果某段纯文本归属于一个已经定义的对象，则会将该文本存储在该对象自己的结构中。对象
     * @return 更新成功与否
     */
    @Transaction(propagation = JtxPropagationBehavior.PROPAGATION_REQUIRED, readOnly = false)
    public boolean updateDocChapterContentStruct(DocChapterContentStructVO docChapterContentStruct) {
        return update(docChapterContentStruct);
    }
    
    /**
     * 删除 章节内容结构。章节的所有内容均会在此表中存在。以类型字段区分具体的内容存储在什么地方。如果是文本、图片、嵌入式对象内容，则对应存储在文本内容表、图片内容表、嵌入式对象内容表。如果已定义的表格内容，
     * 则将表格内容对应的模型定义将其存储在已定义的模型存储结构中，比如业务事项表、业务对象表等。如果某段纯文本归属于一个已经定义的对象，则会将该文本存储在该对象自己的结构中。
     * 
     * @param docChapterContentStruct
     *            章节内容结构。章节的所有内容均会在此表中存在。以类型字段区分具体的内容存储在什么地方。如果是文本、图片、嵌入式对象内容，则对应存储在文本内容表、图片内容表、嵌入式对象内容表。如果已定义的表格内容，
     *            则将表格内容对应的模型定义将其存储在已定义的模型存储结构中，比如业务事项表、业务对象表等。如果某段纯文本归属于一个已经定义的对象，则会将该文本存储在该对象自己的结构中。对象
     * @return 删除成功与否
     */
    @Transaction(propagation = JtxPropagationBehavior.PROPAGATION_REQUIRED, readOnly = false)
    public boolean deleteDocChapterContentStruct(DocChapterContentStructVO docChapterContentStruct) {
        return delete(docChapterContentStruct);
    }
    
    /**
     * 读取 章节内容结构。章节的所有内容均会在此表中存在。以类型字段区分具体的内容存储在什么地方。如果是文本、图片、嵌入式对象内容，则对应存储在文本内容表、图片内容表、嵌入式对象内容表。如果已定义的表格内容，
     * 则将表格内容对应的模型定义将其存储在已定义的模型存储结构中，比如业务事项表、业务对象表等。如果某段纯文本归属于一个已经定义的对象，则会将该文本存储在该对象自己的结构中。
     * 
     * @param docChapterContentStruct
     *            章节内容结构。章节的所有内容均会在此表中存在。以类型字段区分具体的内容存储在什么地方。如果是文本、图片、嵌入式对象内容，则对应存储在文本内容表、图片内容表、嵌入式对象内容表。如果已定义的表格内容，
     *            则将表格内容对应的模型定义将其存储在已定义的模型存储结构中，比如业务事项表、业务对象表等。如果某段纯文本归属于一个已经定义的对象，则会将该文本存储在该对象自己的结构中。对象
     * @return 章节内容结构。章节的所有内容均会在此表中存在。以类型字段区分具体的内容存储在什么地方。如果是文本、图片、嵌入式对象内容，则对应存储在文本内容表、图片内容表、嵌入式对象内容表。如果已定义的表格内容，
     *         则将表格内容对应的模型定义将其存储在已定义的模型存储结构中，比如业务事项表、业务对象表等。如果某段纯文本归属于一个已经定义的对象，则会将该文本存储在该对象自己的结构中。
     */
    public DocChapterContentStructVO loadDocChapterContentStruct(DocChapterContentStructVO docChapterContentStruct) {
        DocChapterContentStructVO objDocChapterContentStruct = load(docChapterContentStruct);
        return objDocChapterContentStruct;
    }
    
    /**
     * 根据章节内容结构。章节的所有内容均会在此表中存在。以类型字段区分具体的内容存储在什么地方。如果是文本、图片、嵌入式对象内容，则对应存储在文本内容表、图片内容表、嵌入式对象内容表。如果已定义的表格内容，
     * 则将表格内容对应的模型定义将其存储在已定义的模型存储结构中，比如业务事项表、业务对象表等。如果某段纯文本归属于一个已经定义的对象，则会将该文本存储在该对象自己的结构中。主键读取
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
        DocChapterContentStructVO objDocChapterContentStruct = new DocChapterContentStructVO();
        objDocChapterContentStruct.setId(id);
        return loadDocChapterContentStruct(objDocChapterContentStruct);
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
        return queryList("com.comtop.cap.doc.content.model.queryDocChapterContentStructList", condition,
            condition.getPageNo(), condition.getPageSize());
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
        return ((Integer) selectOne("com.comtop.cap.doc.content.model.queryDocChapterContentStructCount", condition))
            .intValue();
    }
    
    /**
     * 根据文档ID、章节ID、序号查询内容
     *
     * 
     * @param docChapterContentStructVO 条件
     * @return 内容VO
     */
    public DocChapterContentStructVO queryDocChapterStructByUniqueCondition(
        DocChapterContentStructVO docChapterContentStructVO) {
        List<DocChapterContentStructVO> lstResult = queryList(
            "com.comtop.cap.doc.content.model.queryDocChapterStructByUniqueCondition", docChapterContentStructVO);
        if (lstResult == null || lstResult.size() == 0) {
            return null;
        }
        return lstResult.get(0);
    }
}
