/******************************************************************************
 * Copyright (C) 2015 ShenZhen ComTop Information Technology Co.,Ltd
 * All Rights Reserved.
 * 本软件为深圳康拓普开发研制。未经本公司正式书面同意，其他任何个人、团体不得使用、
 * 复制、修改或发布本软件.
 *****************************************************************************/

package com.comtop.cap.doc.content.appservice;

import java.lang.reflect.InvocationTargetException;
import java.lang.reflect.Method;
import java.text.NumberFormat;
import java.util.ArrayList;
import java.util.Collection;
import java.util.HashMap;
import java.util.List;
import java.util.Map;
import java.util.Map.Entry;

import org.apache.commons.lang.StringUtils;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;

import com.comtop.cap.base.MDBaseAppservice;
import com.comtop.cap.base.MDBaseDAO;
import com.comtop.cap.bm.metadata.common.storage.exception.OperateException;
import com.comtop.cap.bm.req.prototype.design.facade.PrototypeFacade;
import com.comtop.cap.bm.req.prototype.design.model.PrototypeVO;
import com.comtop.cap.bm.req.subfunc.appservice.ReqFunctionSubitemAppService;
import com.comtop.cap.bm.req.subfunc.model.ReqFunctionSubitemVO;
import com.comtop.cap.doc.content.dao.DocChapterContentStructDAO;
import com.comtop.cap.doc.content.model.DocChapterContentStructVO;
import com.comtop.cap.doc.content.model.DocChapterContentVO;
import com.comtop.cap.doc.content.model.DocGridDataVO;
import com.comtop.cap.doc.content.util.CapContentHelper;
import com.comtop.cap.doc.content.util.CapDocContentConstant;
import com.comtop.cap.doc.info.appservice.DocumentAppService;
import com.comtop.cap.doc.info.model.DocumentVO;
import com.comtop.cap.doc.service.CommonDataManager;
import com.comtop.cap.doc.tmpl.appservice.CapDocTemplateAppService;
import com.comtop.cap.doc.tmpl.model.CapDocTemplateVO;
import com.comtop.cap.document.word.WordOptions;
import com.comtop.cap.document.word.docconfig.DocConfigManager;
import com.comtop.cap.document.word.docconfig.datatype.ChapterType;
import com.comtop.cap.document.word.docconfig.datatype.TableType;
import com.comtop.cap.document.word.docconfig.model.DCChapter;
import com.comtop.cap.document.word.docconfig.model.DCContentSeg;
import com.comtop.cap.document.word.docconfig.model.DCGraphic;
import com.comtop.cap.document.word.docconfig.model.DCSection;
import com.comtop.cap.document.word.docconfig.model.DCTable;
import com.comtop.cap.document.word.docconfig.model.DCTableCell;
import com.comtop.cap.document.word.docconfig.model.DCTableRow;
import com.comtop.cap.document.word.docconfig.model.DocConfig;
import com.comtop.cap.document.word.docmodel.data.ContentSeg;
import com.comtop.cap.document.word.docmodel.datatype.ContentType;
import com.comtop.cap.document.word.docmodel.datatype.DataFromType;
import com.comtop.cap.document.word.expression.Configuration;
import com.comtop.cap.document.word.expression.Configuration.Strategy;
import com.comtop.cap.document.word.expression.ContainerInitializer;
import com.comtop.cap.document.word.expression.ExpressionExecuteHelper;
import com.comtop.cap.document.word.parse.util.ExprUtil;
import com.comtop.cap.document.word.util.DocUtil;
import com.comtop.cip.common.constant.CapNumberConstant;
import com.comtop.cip.common.util.CAPCollectionUtils;
import com.comtop.cip.common.util.CAPStringUtils;
import com.comtop.cip.jodd.petite.meta.PetiteBean;
import com.comtop.cip.jodd.petite.meta.PetiteInject;
import com.comtop.cip.jodd.util.StringUtil;
import com.comtop.cap.runtime.core.AppBeanUtil;
import com.comtop.top.component.common.systeminit.WebGlobalInfo;
import com.comtop.top.core.util.constant.NumberConstant;

/**
 * 章节内容结构。章节的所有内容均会在此表中存在。以类型字段区分具体的内容存储在什么地方。如果是文本、图片、嵌入式对象内容，则对应存储在文本内容表、图片内容表、嵌入式对象内容表。如果已定义的表格内容，
 * 则将表格内容对应的模型定义将其存储在已定义的模型存储结构中，比如业务事项表、业务对象表等。如果某段纯文本归属于一个已经定义的对象，则会将该文本存储在该对象自己的结构中。服务扩展类
 * 
 * @author 李小芬
 * @since 1.0
 * @version 2015-11-24 李小芬
 */
@PetiteBean
public class DocChapterContentStructAppService extends MDBaseAppservice<DocChapterContentStructVO> {
    
	/** 日志 */
    private final static Logger LOG = LoggerFactory.getLogger(DocChapterContentStructAppService.class);
    
    /** 注入DAO **/
    @PetiteInject
    protected DocChapterContentStructDAO docChapterContentStructDAO;
    
    /** 注入docChapterContentAppService **/
    @PetiteInject
    protected DocChapterContentAppService docChapterContentAppService;
    
    /** 注入documentAppService **/
    @PetiteInject
    protected DocumentAppService documentAppService;
    
    /** 注入reqFunctionSubitemAppService **/
    @PetiteInject
    protected ReqFunctionSubitemAppService reqFunctionSubitemAppService;
    
    /** 注入capDocTemplateAppService **/
    @PetiteInject
    protected CapDocTemplateAppService capDocTemplateAppService;
    
    /** prototypeFacade */
    @PetiteInject
    protected PrototypeFacade prototypeFacade;
    
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
    public Object insertDocChapterContentStruct(DocChapterContentStructVO docChapterContentStruct) {
        return docChapterContentStructDAO.insertDocChapterContentStruct(docChapterContentStruct);
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
    public boolean updateDocChapterContentStruct(DocChapterContentStructVO docChapterContentStruct) {
        return docChapterContentStructDAO.updateDocChapterContentStruct(docChapterContentStruct);
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
    public boolean deleteDocChapterContentStruct(DocChapterContentStructVO docChapterContentStruct) {
        return docChapterContentStructDAO.deleteDocChapterContentStruct(docChapterContentStruct);
    }
    
    /**
     * 删除 章节内容结构。章节的所有内容均会在此表中存在。以类型字段区分具体的内容存储在什么地方。如果是文本、图片、嵌入式对象内容，则对应存储在文本内容表、图片内容表、嵌入式对象内容表。如果已定义的表格内容，
     * 则将表格内容对应的模型定义将其存储在已定义的模型存储结构中，比如业务事项表、业务对象表等。如果某段纯文本归属于一个已经定义的对象，则会将该文本存储在该对象自己的结构中。集合
     * 
     * @param docChapterContentStructList
     *            章节内容结构。章节的所有内容均会在此表中存在。以类型字段区分具体的内容存储在什么地方。如果是文本、图片、嵌入式对象内容，则对应存储在文本内容表、图片内容表、嵌入式对象内容表。如果已定义的表格内容，
     *            则将表格内容对应的模型定义将其存储在已定义的模型存储结构中，比如业务事项表、业务对象表等。如果某段纯文本归属于一个已经定义的对象，则会将该文本存储在该对象自己的结构中。对象
     * @return 删除成功与否
     */
    public boolean deleteDocChapterContentStructList(List<DocChapterContentStructVO> docChapterContentStructList) {
        if (docChapterContentStructList == null) {
            return true;
        }
        for (DocChapterContentStructVO docChapterContentStruct : docChapterContentStructList) {
            this.deleteDocChapterContentStruct(docChapterContentStruct);
        }
        return true;
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
        return docChapterContentStructDAO.loadDocChapterContentStruct(docChapterContentStruct);
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
        return docChapterContentStructDAO.loadDocChapterContentStructById(id);
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
        return docChapterContentStructDAO.queryDocChapterContentStructList(condition);
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
        return docChapterContentStructDAO.queryDocChapterContentStructCount(condition);
    }
    
    /**
     * 根据文档ID查询文档结构VO，文本内容VO
     *
     * @param docChapterContentStructVO 章节内容
     * @return 章节内容
     */
    public DocChapterContentStructVO queryDocChapterContentStruct(DocChapterContentStructVO docChapterContentStructVO) {
        DocChapterContentStructVO objDocChapterContentStructVO = this
            .loadDocChapterContentStructById(docChapterContentStructVO.getId());
        DocChapterContentVO objDocChapterContentVO = docChapterContentAppService
            .loadDocChapterContentById(objDocChapterContentStructVO.getContentId());
        objDocChapterContentStructVO.setDocChapterContentVO(objDocChapterContentVO);
        return objDocChapterContentStructVO;
    }
    
    /** xml解析内容的Map--key：模板ID；value：模板内容 */
    private Map<String, DocConfig> docConfigMap = new HashMap<String, DocConfig>();
    
    /**
     * 表达式初始化上下文
     * 
     * @return 表达式初始化上下文
     */
    private ContainerInitializer getInitializer(){
    	return (ContainerInitializer) WebGlobalInfo.getServletContext().getAttribute(
            ContainerInitializer.class.getName());
    }
    
    /**
     * 取章节树信息
     * 
     * @param condition 传入条件
     * @return 返回章节树信息
     */
    public List<DocChapterContentStructVO> getAllChapterTree(DocumentVO condition) {
        // 获取xml解析结构
        DocumentVO objDocumentVO = documentAppService.loadDocumentById(condition.getId());
        // 初始化表达式执行器：一个文档树，一个执行器
        Configuration configuration = new Configuration(Strategy.READ, getInitializer());
        ExpressionExecuteHelper executer = new ExpressionExecuteHelper(configuration);
        
        DocConfig objDocConfig = getDocConfig(objDocumentVO, configuration);
        CommonDataManager.setDocConfig(objDocConfig);
        // 文档结构树
        List<DocChapterContentStructVO> lstTree = new ArrayList<DocChapterContentStructVO>();
        
        // 树根节点
        DocChapterContentStructVO objDocStructRootVO = getDocStructRoot(objDocumentVO);
        lstTree.add(objDocStructRootVO);
        
        // 树的下级：分节-章节-子章节-子章节
        List<DCSection> sections = objDocConfig.getSections();
        for (DCSection section : sections) {
            // 循环章节，如果分节下无子章节，不加入树节点
            List<DCChapter> chapters = section.getChapters();
            if (CAPCollectionUtils.isEmpty(chapters)) {
                continue;
            }
            // 递归查找所有级联下级
            // section不显示，需要设置root的xml全路径
            objDocStructRootVO.setXmlfullPath(section.getName());
            chapterTree(section.getChapters(), objDocStructRootVO, lstTree, executer);
        }
        CommonDataManager.removeDocConfig();
        return lstTree;
    }
    
    /**
     * 递归查找所有章节节点，构造文档结构树
     * 
     * @param chapters 直接下级章节list
     * @param parentDocStructVO 上级章节节点VO
     * @param lstChapter 节点集合
     * @param executer 表达式执行器
     */
    private void chapterTree(List<DCChapter> chapters, DocChapterContentStructVO parentDocStructVO,
        List<DocChapterContentStructVO> lstChapter, ExpressionExecuteHelper executer) {
        DocChapterContentStructVO objDocChapterContentStructVO;
        // 章节同级编号的序号
        int iWordNumber = CapNumberConstant.NUMBER_INT_ZERO;
        for (DCChapter chapter : chapters) {
            // 区分固定-动态章节
            if (isDynamicChapter(chapter)) {
                // 构造堆栈
                executer.notifyStart();
                // 设置全局变量
                setVariable(executer, parentDocStructVO);
                String dataSource = chapter.getMappingTo();
                Object result = null;
                if (StringUtils.isNotBlank(dataSource)) {
                    result = executer.read(dataSource);
                }
                // 通过堆栈来执行循环的顺序
                if (result != null && result instanceof Collection<?>) {
                    Collection<?> coll = (Collection<?>) result;
                    int iCollSize = coll.size();
                    for (int i = 0; i < iCollSize; i++) {
                        // 取堆栈数据
                        iWordNumber++;
                        executer.notifyStart();
                        objDocChapterContentStructVO = getDynamicChapterToVO(parentDocStructVO, iWordNumber, chapter,
                            executer);
                        lstChapter.add(objDocChapterContentStructVO);
                        chapterTree(chapter.getChildChapters(), objDocChapterContentStructVO, lstChapter, executer);
                        executer.notifyEnd();
                    }
                }
                executer.notifyEnd();
            } else {
                iWordNumber++;
                // 固定章节基本信息
                objDocChapterContentStructVO = getFixedChapterNodeVO(parentDocStructVO, iWordNumber, chapter, executer);
                // 递归查询下级
                lstChapter.add(objDocChapterContentStructVO);
                chapterTree(chapter.getChildChapters(), objDocChapterContentStructVO, lstChapter, executer);
            }
        }
    }
    
    /**
     * 表达式设置全局变量
     *
     * @param executer executer
     * @param parentDocStructVO parentDocStructVO
     */
    private void setVariable(ExpressionExecuteHelper executer, DocChapterContentStructVO parentDocStructVO) {
        executer.setVariable("domainId", parentDocStructVO.getDomainId());
        executer.setVariable("documentId", parentDocStructVO.getDocumentId());
    }
    
    /**
     * 动态章节构造成VO
     *
     * @param parentStructVO 父章节
     * @param iWordNumber 章节序号
     * @param chapter 章节
     * @param executer 执行器
     * @return DocChapterContentStructVO
     */
    private DocChapterContentStructVO getDynamicChapterToVO(DocChapterContentStructVO parentStructVO, int iWordNumber,
        DCChapter chapter, ExpressionExecuteHelper executer) {
        // 动态章节获取章节名称、URI
        String strChapterName = (String) executer.read(chapter.getTitle());
        String strExpId = getExpIdByAttribute(chapter.getTitle());
        String strContainerUri = (String) executer.read(strExpId);
        // Other Info
        DocChapterContentStructVO objDocChapterContentStructVO = getChapterNodeVO(parentStructVO, iWordNumber, chapter,
            executer, strChapterName, strContainerUri);
        return objDocChapterContentStructVO;
    }
    
    /**
     * 构造文档结构树-章节信息VO
     *
     * @param parentStructVO 上级树节点VO
     * @param iWordNumber 同级序号
     * @param chapter 当前章节
     * @param executer 执行器
     * @return 章节信息VO
     */
    private DocChapterContentStructVO getFixedChapterNodeVO(DocChapterContentStructVO parentStructVO, int iWordNumber,
        DCChapter chapter, ExpressionExecuteHelper executer) {
        // 固定章节获取章节名称、URI
        String strChapterName = chapter.getFixedTitle();
        String strContainerUri = parentStructVO.getContainerUri() + CapDocContentConstant.URI_CONNECTOR
            + chapter.getFixedTitle();
        // Other Info
        DocChapterContentStructVO objDocChapterContentStructVO = getChapterNodeVO(parentStructVO, iWordNumber, chapter,
            executer, strChapterName, strContainerUri);
        return objDocChapterContentStructVO;
    }
    
    /**
     * 设置章节VO
     *
     * @param parentStructVO 上级树节点VO
     * @param iWordNumber 同级序号
     * @param chapter 当前章节
     * @param executer 执行器
     * @param strChapterName 章节名称
     * @param strContainerUri 章节IRI
     * @return 章节VO
     */
    private DocChapterContentStructVO getChapterNodeVO(DocChapterContentStructVO parentStructVO, int iWordNumber,
        DCChapter chapter, ExpressionExecuteHelper executer, String strChapterName, String strContainerUri) {
        DocChapterContentStructVO objDocChapterContentStructVO = new DocChapterContentStructVO();
        objDocChapterContentStructVO.setChapterName(strChapterName);
        objDocChapterContentStructVO.setDocumentId(parentStructVO.getDocumentId());
        objDocChapterContentStructVO.setDomainId(parentStructVO.getDomainId());
        objDocChapterContentStructVO.setContainerUri(strContainerUri);
        objDocChapterContentStructVO.setParentUri(parentStructVO.getContainerUri());
        if (StringUtil.isNotBlank(parentStructVO.getXmlfullPath())) {
            objDocChapterContentStructVO.setXmlfullPath(parentStructVO.getXmlfullPath()
                + CapDocContentConstant.URI_CONNECTOR + chapter.getTitle());
        } else {
            objDocChapterContentStructVO.setXmlfullPath(chapter.getTitle());
        }
        objDocChapterContentStructVO.setContainerType(CapDocContentConstant.DOC_CONTAINER_TYPE_CHAPTER);
        objDocChapterContentStructVO.setContentType(chapter.getChapterType().toString());
        // objDocChapterContentStructVO.setSortNo(iWordNumber);
        objDocChapterContentStructVO.setOptional(chapter.getOptional());
        // 设置章节编号
        setWordNumber(parentStructVO, objDocChapterContentStructVO, iWordNumber);
        objDocChapterContentStructVO.setTreeId(objDocChapterContentStructVO.getChapterWordNumber() + "/"
            + objDocChapterContentStructVO.getChapterName());
        objDocChapterContentStructVO.setParentTreeId(parentStructVO.getTreeId());
        
        // 设置隐藏属性
        setHiddenAttribute(parentStructVO, objDocChapterContentStructVO, executer, chapter);
        
        // 判断是否存在下级章节
        objDocChapterContentStructVO.setHasChild(getHasChild(objDocChapterContentStructVO, executer,
            chapter.getChildChapters()));
        
        return objDocChapterContentStructVO;
    }
    
    /**
     * 判断是否存在下级子章节
     * 
     * @param chapterContentStructVO 当前父节点对象
     * @param executer 表达式执行器
     * @param childChapters 子章节
     * @return 是否存在下级子章节
     */
    private boolean getHasChild(DocChapterContentStructVO chapterContentStructVO, ExpressionExecuteHelper executer,
        List<DCChapter> childChapters) {
        if (CAPCollectionUtils.isEmpty(childChapters)) {
            return false;
        }
        boolean hasChild = false;
        for (DCChapter chapter : childChapters) {
            // 区分固定-动态章节
            if (isDynamicChapter(chapter)) {
                executer.notifyStart();
                setVariable(executer, chapterContentStructVO);
                String dataSource = chapter.getMappingTo();
                Object result = null;
                if (StringUtils.isNotBlank(dataSource)) {
                    result = executer.read(replaceMappingTo(chapterContentStructVO, dataSource));
                }
                // 通过堆栈来执行循环的顺序
                if (result != null && result instanceof Collection<?>) {
                    Collection<?> coll = (Collection<?>) result;
                    if (coll.size() > 0) {
                        hasChild = true;
                    }
                }
                executer.notifyEnd();
            } else {
                hasChild = true;
            }
        }
        return hasChild;
    }
    
    /**
     * 设置章节隐藏属性
     *
     * @param parentDocStructVO 父章节VO
     * @param docStructVO 当前章节VO
     * @param executer 表达式执行器
     * @param chapter 当前章节
     */
    private void setHiddenAttribute(DocChapterContentStructVO parentDocStructVO, DocChapterContentStructVO docStructVO,
        ExpressionExecuteHelper executer, DCChapter chapter) {
        // 节点隐藏值-下级表达式需要的条件值。如{bizItem.id：13DHYYUO765SADSAD}，作用于：章节编辑执行表达式时进行替换
        docStructVO.setExpParamsMap(getExpParamsMap(chapter, parentDocStructVO, executer));
        
        // 节点隐藏值-自顶向下的服务集合，如{bizProcessInfo[]：BizProcessInfoFacade}，章节编辑时使用
        docStructVO.setServiceMap(getServiceMap(chapter, parentDocStructVO, executer));
        
        // 节点隐藏值-自顶向下的对象ID集合，如{bizItem.id：13DHYYUO765SADSAD，flowNode.id:XXXX}
        docStructVO.setObjectIdMap(getObjectIdMap(chapter, parentDocStructVO, executer));
        
    }
    
    /**
     * 章节对应的表达式集合
     *
     * @param chapter 章节
     * @param parentDocStructVO 父章节
     * @param executer 执行器
     * @return 表达式集合
     */
    private Map<String, String> getServiceMap(DCChapter chapter, DocChapterContentStructVO parentDocStructVO,
        ExpressionExecuteHelper executer) {
        Map<String, String> objMap = new HashMap<String, String>();
        Map<String, String> objParentMap = parentDocStructVO.getServiceMap();
        if (objParentMap != null) {
            objMap.putAll(objParentMap);
        }
        if (StringUtil.isNotBlank(chapter.getMappingTo())) {
            // bizProcessInfo[]=#BizProcess(bizItemId=bizItem.id)
            String strMappingTo = chapter.getMappingTo();
            // bizProcessInfo[]
            String strReference = executer.readReference(strMappingTo);
            // BizProcess
            String strService = executer.readServiceName(strMappingTo);
            // 类名全路径
            String strKeyTwo = getOtherKey(strReference);
            Object objClass = executer.readService(strMappingTo);
            String strClassName = objClass.getClass().getName();
            if (StringUtil.isNotBlank(strClassName) && strClassName.endsWith(CapDocContentConstant.PROXETTA_FLAG)) {
                strClassName = strClassName.substring(0, strClassName.length() - 10);
            }
            objMap.put(strReference, strService);
            objMap.put(strKeyTwo, strClassName);
        }
        return objMap;
    }
    
    /**
     * key+2，作为新的key
     *
     * @param strReference 表达式key
     * @return 新的key
     */
    private String getOtherKey(String strReference) {
        return strReference + CapNumberConstant.NUMBER_INT_TWO;
    }
    
    /**
     * 章节对应的表达式集合
     *
     * @param chapter 章节
     * @param parentDocStructVO 父章节
     * @param executer 执行器
     * @return 表达式集合
     */
    private Map<String, String> getObjectIdMap(DCChapter chapter, DocChapterContentStructVO parentDocStructVO,
        ExpressionExecuteHelper executer) {
        Map<String, String> objMap = new HashMap<String, String>();
        Map<String, String> objParentMap = parentDocStructVO.getObjectIdMap();
        if (objParentMap != null) {
            objMap.putAll(objParentMap);
        }
        if (StringUtil.isNotBlank(chapter.getMappingTo())) {
            // bizItem[]=#BizItem(domainId=$domainId)
            String strMappingTo = chapter.getMappingTo();
            // bizItem[] bizItem;
            String strReference = executer.readReference(strMappingTo);
            String strExpId = strReference.replace("[]", "") + CapDocContentConstant.ID_EXP_CONNECTOR;
            // bizItem.id
            // String strExpId = getExpIdByVariable(strReference);
            String strIdValue = (String) executer.read(strExpId);
            objMap.put(strExpId, strIdValue);
        }
        return objMap;
    }
    
    /**
     * 获取表达式参数的条件值
     *
     * @param chapter 当前章节
     * @param parentDocStructVO 父节点
     * @param executer 执行器
     * @return 表达式参数的条件值
     */
    private Map<String, String> getExpParamsMap(DCChapter chapter, DocChapterContentStructVO parentDocStructVO,
        ExpressionExecuteHelper executer) {
        Map<String, String> objMap = new HashMap<String, String>();
        Map<String, String> objParentMap = parentDocStructVO.getExpParamsMap();
        if (objParentMap != null) {
            objMap.putAll(objParentMap);
        }
        Collection<String> lstParam = chapter.getQueryParamExprs().values();
        for (String strParam : lstParam) {
            objMap.put(strParam, (String) executer.read(strParam));
        }
        return objMap;
    }
    
    /**
     * 根据属性的表达式获取ID的表达式
     *
     * @param exp 属性的表达式 xx.xx
     * @return ID的表达式 xx.id
     */
    private String getExpIdByAttribute(String exp) {
        return ExprUtil.getVarNameFromAttribute(exp) + CapDocContentConstant.ID_EXP_CONNECTOR;
    }
    
    /**
     * 根据属性的表达式获取变量的表达式
     *
     * @param exp 属性的表达式 xx.xx
     * @param fullPath 是否为查询全路径标识
     * @return ID的表达式 xx[]
     */
    private String getExpVariableByAttribute(String exp, boolean fullPath) {
        if (fullPath) {
            return ExprUtil.getVarNameFromAttribute(exp) + CapDocContentConstant.VARIABLE_FLAG
                + CapNumberConstant.NUMBER_INT_TWO;
        }
        return ExprUtil.getVarNameFromAttribute(exp) + CapDocContentConstant.VARIABLE_FLAG;
    }
    
    /**
     * 是否动态章节
     *
     * @param chapter 章节
     * @return true 是 false 否
     */
    private boolean isDynamicChapter(DCChapter chapter) {
        return ChapterType.DYNAMIC.toString().equals(chapter.getChapterType().toString());
    }
    
    /**
     * 设置章节编号
     *
     * @param parentDocStructVO 父章节VO
     * @param docStructVO 当前章节VO
     * @param iWordNumber 同级序号
     */
    private void setWordNumber(DocChapterContentStructVO parentDocStructVO, DocChapterContentStructVO docStructVO,
        int iWordNumber) {
        String wordNumber = getWordNumber(parentDocStructVO.getChapterWordNumber(), iWordNumber);
        docStructVO.setChapterWordNumber(wordNumber);
    }
    
    /**
     * 获取章节编号
     *
     * @param chapterWordNumber 父章节编号
     * @param iWordNumber 同级序号
     * @return 章节编号
     */
    private String getWordNumber(String chapterWordNumber, int iWordNumber) {
        if (StringUtil.isNotBlank(chapterWordNumber)) {
            return chapterWordNumber + CapDocContentConstant.WORD_NUMBER_CONNECTOR + String.valueOf(iWordNumber);
        }
        return String.valueOf(iWordNumber);
    }
    
    /**
     * 构造文档结构树的根节点
     *
     * @param documentVO 文档对象
     * @return 根节点VO
     */
    private DocChapterContentStructVO getDocStructRoot(DocumentVO documentVO) {
        DocChapterContentStructVO objRootDocChapterContentStruct = new DocChapterContentStructVO();
        objRootDocChapterContentStruct.setChapterName(documentVO.getName());
        objRootDocChapterContentStruct.setContainerUri(CapDocContentConstant.TREE_ROOT_URI);
        objRootDocChapterContentStruct.setParentUri(CapDocContentConstant.TREE_ROOT_PARENT_ID);
        objRootDocChapterContentStruct.setTreeId(documentVO.getName());
        objRootDocChapterContentStruct.setParentTreeId(CapDocContentConstant.TREE_ROOT_PARENT_ID);
        objRootDocChapterContentStruct.setDocumentId(documentVO.getId());
        objRootDocChapterContentStruct.setDomainId(documentVO.getBizDomain());
        objRootDocChapterContentStruct.setHasChild(true);
        return objRootDocChapterContentStruct;
    }
    
    /**
     * 获取xml文档对象--一个模板一个解析结构
     *
     * @param documentVO 文档
     * @param configuration 配置
     * @return xml文档对象
     */
    private DocConfig getDocConfig(DocumentVO documentVO, Configuration configuration) {
        if (docConfigMap.get(documentVO.getDocTmplId()) == null) {
            CapDocTemplateVO objCapDocTemplateVO = capDocTemplateAppService.loadCapDocTemplateById(documentVO
                .getDocTmplId());
            String classesPath = WebGlobalInfo.getWebInfoPath();
            String filePath = classesPath + objCapDocTemplateVO.getPath();
            String logPath = DocUtil.createLogPath(WebGlobalInfo.getWebPath(), documentVO.getId(), "docShow");
            WordOptions options = new WordOptions(configuration, logPath);
            DocConfig objTempDocConfig = new DocConfigManager().parseXml(filePath, options);
            docConfigMap.put(documentVO.getDocTmplId(), objTempDocConfig);
        }
        
        return docConfigMap.get(documentVO.getDocTmplId());
    }
    
    /**
     * 查询xml配置
     * 
     * @param docChapterContentStructVO id信息
     * @return 内容信息
     */
    public List<DocChapterContentStructVO> getChapterXmlContentById(DocChapterContentStructVO docChapterContentStructVO) {
        // 初始化表达式执行器
        Configuration configuration = new Configuration(Strategy.READ, getInitializer());
        ExpressionExecuteHelper expression = new ExpressionExecuteHelper(configuration);
        expression.notifyStart();
        setVariable(expression, docChapterContentStructVO);
        // 获取xml解析结构
        DocumentVO objDocumentVO = documentAppService.loadDocumentById(docChapterContentStructVO.getDocumentId());
        DocConfig objDocConfig = getDocConfig(objDocumentVO, configuration);
        CommonDataManager.setDocConfig(objDocConfig);
        docChapterContentStructVO.setDomainId(objDocumentVO.getBizDomain());
        List<DCSection> sections = objDocConfig.getSections();
        // 解析上级章节名称和本次编辑章节名称
        String[] strName = docChapterContentStructVO.getXmlfullPath().split(CapDocContentConstant.URI_CONNECTOR);
        // 点击的是分节信息
        if (strName.length == 1) {
            for (DCSection section : sections) {
                if (section.getName() != null && section.getName().equals(strName[0])) { // 对应节点内容
                    // 定位到具体分节后，解析分节内容
                    return getAllDocContent(expression, section.getContents(), docChapterContentStructVO);
                }
            }
        } else {
            // 点击的是章节信息
            for (DCSection section : sections) {
                DCChapter objChapter = getEditChapter(strName, section.getChapters(), 1);
                if (objChapter != null) {
                    // 定位到具体章节后，解析章节内容
                    return getAllDocContent(expression, objChapter.getContents(), docChapterContentStructVO);
                }
            }
        }
        expression.notifyEnd();
        CommonDataManager.removeDocConfig();
        return null;
    }
    
    /**
     * 查询正在编辑的章节结构 （有缺陷，重复的情况。。。。）
     *
     * @param strName XML结构 section/chapter/chapter/...
     * @param chapters 章节集合
     * @param iArray 序号
     * @return 编辑的章节结构信息
     */
    private DCChapter getEditChapter(String[] strName, List<DCChapter> chapters, int iArray) {
        int iSort = iArray;
        String strCurrentName = strName[iArray];
        for (DCChapter chapter : chapters) {
            if (chapter.getTitle() != null && chapter.getTitle().equals(strCurrentName)) {
                if (strName.length - 1 == iArray) {
                    return chapter;
                }
                if (CAPCollectionUtils.isEmpty(chapter.getChildChapters())) {
                    continue;
                }
                iSort++;
                DCChapter objEditChapter = getEditChapter(strName, chapter.getChildChapters(), iSort);
                if (objEditChapter != null) {
                    return objEditChapter;
                }
            }
        }
        return null;
    }
    
    /**
     * 解析章节内容结构，按顺序加入集合
     * 
     * @param expression 表达式执行器
     * @param contents 章节内容xml
     * @param docChapterContentStructVO 章节基本信息
     * @return 章节内容结构集合
     */
    private List<DocChapterContentStructVO> getAllDocContent(ExpressionExecuteHelper expression,
        List<DCContentSeg> contents, DocChapterContentStructVO docChapterContentStructVO) {
        // 内容结构集合
        List<DocChapterContentStructVO> lstDocChapterContentStruct = new ArrayList<DocChapterContentStructVO>();
        DocChapterContentStructVO objDocChapterContentStructVO;
        int iSortNo = 0;
        // 循环内容块，每块为一个StrutVO
        for (DCContentSeg contentSeg : contents) {
            // 每块内容自带的信息-继承自章节树节点
            objDocChapterContentStructVO = getContentSegVO(docChapterContentStructVO);
            objDocChapterContentStructVO.setSortNo(iSortNo);
            // 设置每块内容的html展示以及html内容值
            setContentSegHtml(expression, objDocChapterContentStructVO, contentSeg);
            lstDocChapterContentStruct.add(objDocChapterContentStructVO);
            iSortNo++;
        }
        return lstDocChapterContentStruct;
    }
    
    /**
     * 拼凑html文本
     * 
     * @param expression 表达式执行器
     * @param docChapterContentStructVO 当前分块信息
     * @param contentSeg xml配置的分段信息
     */
    private void setContentSegHtml(ExpressionExecuteHelper expression,
        DocChapterContentStructVO docChapterContentStructVO, DCContentSeg contentSeg) {
        if (contentSeg instanceof DCTable) {
            // 如果配置为Table
            DCTable objTable = (DCTable) contentSeg;
            if (TableType.FIXED.toString().equals(objTable.getType().name())) {
                // FIXED Table
                docChapterContentStructVO.setContentType(TableType.FIXED.toString());
                obtainXmlForFixedTable(expression, docChapterContentStructVO, objTable);
            } else if (TableType.EXT_ROWS.toString().equals(objTable.getType().name())) {
                // EXT_ROWS Table
                docChapterContentStructVO.setContentType(TableType.EXT_ROWS.toString());
                obtainXmlForExtRowsTable(expression, docChapterContentStructVO, objTable);
            } else if (TableType.EXT_COLS.toString().equals(objTable.getType().name())) {
                // EXT_COLS Table
                docChapterContentStructVO.setContentType(TableType.EXT_COLS.toString());
                docChapterContentStructVO.setXmlContent("");
            } else if (TableType.UNKNOWN.toString().equals(objTable.getType().name())) {
                // UNKNOWN Table
                docChapterContentStructVO.setContentType(TableType.UNKNOWN.toString());
                obtainXmlForTextContent(expression, docChapterContentStructVO, contentSeg);
            }
        } else if (contentSeg instanceof DCGraphic) {
            // 配置为图片
            docChapterContentStructVO.setContentType(ContentType.GRAPHIC.toString());
            obtainXmlForTextContent(expression, docChapterContentStructVO, contentSeg);
        } else {
            // 配置为文本
            docChapterContentStructVO.setContentType(ContentType.TEXT.toString());
            obtainXmlForTextContent(expression, docChapterContentStructVO, contentSeg);
        }
        
    }
    
    /**
     * 获取每个分块的内容信息
     *
     * @param nodeVO 树节点VO
     * @return 每个分块的内容信息
     */
    private DocChapterContentStructVO getContentSegVO(DocChapterContentStructVO nodeVO) {
        // 继承自树节点的信息
        DocChapterContentStructVO objDocChapterContentStructVO = new DocChapterContentStructVO();
        objDocChapterContentStructVO.setContainerUri(nodeVO.getContainerUri());
        objDocChapterContentStructVO.setContainerType(nodeVO.getContainerType());
        objDocChapterContentStructVO.setDocumentId(nodeVO.getDocumentId());
        objDocChapterContentStructVO.setDomainId(nodeVO.getDomainId());
        objDocChapterContentStructVO.setExpParamsMap(nodeVO.getExpParamsMap());
        objDocChapterContentStructVO.setServiceMap(nodeVO.getServiceMap());
        objDocChapterContentStructVO.setObjectIdMap(nodeVO.getObjectIdMap());
        objDocChapterContentStructVO.setChapterName(nodeVO.getChapterName());
        objDocChapterContentStructVO.setChapterWordNumber(nodeVO.getChapterWordNumber());
        return objDocChapterContentStructVO;
    }
    
    /**
     * 生成富文本编辑
     * 
     * @param expression 表达式执行器
     * @param docChapterContentStruct 编辑的章节信息
     * @param contentSeg 内容片段，可能为null
     */
    private void obtainXmlForTextContent(ExpressionExecuteHelper expression,
        DocChapterContentStructVO docChapterContentStruct, DCContentSeg contentSeg) {
        String strDivId = CapContentHelper.getUUID();
        docChapterContentStruct.setId(strDivId);
        docChapterContentStruct.setMappingTo(contentSeg.getMappingTo());
        
        // 判断文本内容来源：通用文本或者业务建模的某个字段
        String strText = "";
        if (isExecuteMappingTo(docChapterContentStruct, contentSeg.getMappingTo())) {
            strText = getBizAttrValue(expression, docChapterContentStruct, contentSeg.getMappingTo());
        } else {
            strText = getCommTextContent(docChapterContentStruct);
            
        }
        if (CAPStringUtils.isNotBlank(strText)) {
            strText = strText.replaceAll("\\.emf", ".png");
        }
        docChapterContentStruct.setEditorHtml(strText);
        // 设置jsp的html
        docChapterContentStruct.setXmlContent(getTextXmlContent(docChapterContentStruct));
    }
    
    /**
     * 获取文本内容的html
     *
     * @param docChapterContentStruct 当前分段信息
     * @return 文本内容的html
     */
    private String getTextXmlContent(DocChapterContentStructVO docChapterContentStruct) {
        StringBuffer sbXml = new StringBuffer();
        sbXml.append("<button");
        sbXml.append(" id=\"EditEditor").append(docChapterContentStruct.getId()).append("\"");
        sbXml.append(" onclick=\"EditEditorText('").append(docChapterContentStruct.getId()).append("')\"");
        sbXml.append(">编 辑</button>");
        sbXml.append("<button");
        sbXml.append(" id=\"SaveEditor").append(docChapterContentStruct.getId()).append("\"");
        sbXml.append(" onclick=\"SaveEditorText('").append(docChapterContentStruct.getId()).append("')\"");
        sbXml.append(">保 存</button>");
        sbXml.append("<table class=\"form_table\" style=\"table-layout:fixed;\"> ");
        sbXml.append("<tr>");
        sbXml.append("<td>");
        sbXml
            .append("<span uitype=\"Editor\" min_frame_height=\"30\"  toolbars=\"toolbars\" word_count=\"false\" width=\"100%\" readonly=\"true\"");
        sbXml.append(" id=\"Editor").append(docChapterContentStruct.getId()).append("\"");
        sbXml.append("></span>");
        sbXml.append("</td></tr></table>");
        return sbXml.toString();
    }
    
    /**
     * 获取通用文本内容值
     *
     * @param docChapterContentStruct 当前分段VO
     * @return 文本内容值
     */
    private String getCommTextContent(DocChapterContentStructVO docChapterContentStruct) {
        DocChapterContentStructVO objDocChapterContentStructVO = this.docChapterContentStructDAO
            .queryDocChapterStructByUniqueCondition(docChapterContentStruct);
        if (objDocChapterContentStructVO != null) { // 数据库有值
            DocChapterContentStructVO objAllVO = this.queryDocChapterContentStruct(objDocChapterContentStructVO);
            return objAllVO.getDocChapterContentVO().getContent();
        }
        return null;
    }
    
    /**
     * 获取业务文本内容值
     * 
     * @param expression 表达式执行器
     * @param docChapterContentStruct 当前分段VO
     * @param mappingTo 配置的mappingTo -bizProcessInfo.workDemand
     * @return 文本内容值
     */
    private String getBizAttrValue(ExpressionExecuteHelper expression,
        DocChapterContentStructVO docChapterContentStruct, String mappingTo) {
        String strObjectId = getObjectIdByExp(mappingTo, docChapterContentStruct);
        String strServiceName = getServiceNameByExp(mappingTo, docChapterContentStruct, false);
        // 拼凑查询表达式--bizProcessInfo = #BizProcessNode(id=strObjectId)
        String strVoExpLeft = ExprUtil.getVarNameFromAttribute(mappingTo);
        String strVoExp = getVoExp(strVoExpLeft, strServiceName, strObjectId);
        expression.notifyStart();
        if (StringUtils.isNotBlank(strVoExp)) {
            expression.read(strVoExp);
        }
        Object objTextValue = expression.read(mappingTo);
        expression.notifyEnd();
        if (objTextValue != null) {
            return objTextValue.toString();
        }
        return "";
    }
    
    /**
     * 拼凑查询表达式--bizProcessInfo = #BizProcessNode(id=strObjectId)
     *
     * @param strVoExpLeft 左侧变量名
     * @param strServiceName 服务名
     * @param strObjectId ID条件值
     * @return 表达式
     */
    private String getVoExp(String strVoExpLeft, String strServiceName, String strObjectId) {
        StringBuffer sbVo = new StringBuffer();
        sbVo.append(strVoExpLeft).append(" ");
        sbVo.append("=");
        sbVo.append(" ").append("#").append(strServiceName).append("(");
        sbVo.append("id='").append(strObjectId).append("')");
        return sbVo.toString();
    }
    
    /**
     * 获取对象ID值
     *
     * @param strMappingTo 表达式 XX.XX
     * @param docChapterContentStruct 当前分段VO
     * @return 对象ID值
     */
    private String getObjectIdByExp(String strMappingTo, DocChapterContentStructVO docChapterContentStruct) {
        Map<String, String> objObjectIdMap = docChapterContentStruct.getObjectIdMap();
        String strObjectIdExp = getExpIdByAttribute(strMappingTo);
        String strObjectId = "";
        for (Entry<String, String> objId : objObjectIdMap.entrySet()) {
            if (strObjectIdExp.equals(objId.getKey())) {
                strObjectId = objId.getValue();
            }
        }
        return strObjectId;
    }
    
    /**
     * 获取服务对象名称
     *
     * @param strMappingTo 表达式 XX.XX
     * @param docChapterContentStruct 当前分段VO
     * @param fullPath 是否查询全路径
     * @return 对象的服务名
     */
    private String getServiceNameByExp(String strMappingTo, DocChapterContentStructVO docChapterContentStruct,
        boolean fullPath) {
        Map<String, String> objServiceMap = docChapterContentStruct.getServiceMap();
        String strKey = getExpVariableByAttribute(strMappingTo, fullPath);// xx[] xx[]2
        String key2 = strKey.replace("[]", "");
        String strService = objServiceMap.get(strKey);
        if (StringUtil.isBlank(strService)) {
            return objServiceMap.get(key2);
        }
        return strService;
        // for (Entry<String, String> service : objServiceMap.entrySet()) {
        // if (strKey.equals(service.getKey())) {
        // strService = service.getValue();
        // }
        // }
        // return strService;
    }
    
    /**
     * 是否需要解析MappingTo
     *
     * @param docChapterContentStruct 当前分段VO
     * @param mappingTo 分段配置的mappingTo内容
     * @return true 是 false 否
     */
    private boolean isExecuteMappingTo(DocChapterContentStructVO docChapterContentStruct, String mappingTo) {
        // mappingTo 有值且不为自动设置值，contentSeg = #ContentSeg(documentId=$documentId,containerUri={0},sortNo=0)
        // 表格类型不为unknown
        return !TableType.UNKNOWN.toString().equals(docChapterContentStruct.getContentType())
            && StringUtil.isNotBlank(mappingTo) && mappingTo.indexOf(CapDocContentConstant.MAPPINGTO_CONTENTSEG) == -1;
    }
    
    /**
     * 构造行扩展表
     * 
     * @param expression 表达式执行器
     * @param docChapterContentStruct 内容
     * @param objTable xml内容
     */
    private void obtainXmlForExtRowsTable(ExpressionExecuteHelper expression,
        DocChapterContentStructVO docChapterContentStruct, DCTable objTable) {
        StringBuffer sbXml = new StringBuffer();
        String strDivId = CapContentHelper.getUUID();
        docChapterContentStruct.setId(strDivId);
        if (StringUtil.isNotBlank(objTable.getMappingTo())) {// 替换表达式
            docChapterContentStruct.setMappingTo(replaceMappingTo(docChapterContentStruct, objTable.getMappingTo()));
        }
        // sbXml.append("<button");
        // sbXml.append(" id=\"ExtRowsTable").append(docChapterContentStruct.getId()).append("\"");
        // sbXml.append(" onclick=\"editOpen('").append(docChapterContentStruct.getId()).append("')\"");
        // sbXml.append(">编 辑</button>");
        // table表头
        sbXml
            .append("<table uitype=\"Grid\" selectrows=\"no\" pagination=\"false\" titlerender=\"titlerender\" gridheight=\"auto\"");
        sbXml.append(" resizewidth=\"").append("resizeWidth").append("\"");
        // sbXml.append(" resizeheight=\"").append("resizeHeight").append("\"");
        sbXml.append(" datasource=\"").append("initData").append("\"");
        sbXml.append(" id=\"gridTable").append(docChapterContentStruct.getId()).append("\"");
        sbXml.append(">");
        sbXml.append("  <thead>");
        List<DCTableRow> rows = objTable.getRows();
        // for (TableRow row : rows) {
        // // TODO 合并单元格
        // }
        // cui不支持合并单元格，仅支持一行的扩展行
        if (rows.size() > 0) {
            DCTableRow tableRow = rows.get(rows.size() - 1);
            sbXml.append("<tr>");
            List<DCTableCell> cells = tableRow.getCells();
            for (DCTableCell tableCell : cells) {
                sbXml.append("<th ");
                if (tableCell.getWidth() > 0) {
                    sbXml.append(" width=\"").append(getFixedWidth(tableCell.getWidth())).append("\"");
                }
                sbXml.append(" bindName=\"").append(getBindName(tableCell.getMappingTo())).append("\"");
                sbXml.append(">");
                // <td></td>之间的内容
                sbXml.append(tableCell.getHeaderName());
                sbXml.append("</th>");
            }
            sbXml.append("</tr>");
        }
        sbXml.append("  </thead>");
        sbXml.append("</table><br>");
        docChapterContentStruct.setXmlContent(sbXml.toString());
        docChapterContentStruct.setGridDataVO(obtainGridData(expression, docChapterContentStruct, objTable));
    }
    
    /**
     * 表达式替换
     *
     * @param docChapterContentStruct 上下文信息
     * @param mappingTo 表达式
     * @return 正确的表达式
     */
    private String replaceMappingTo(DocChapterContentStructVO docChapterContentStruct, String mappingTo) {
        String strMappingTo = mappingTo;
        Map<String, String> expParamsMap = docChapterContentStruct.getExpParamsMap();
        for (Entry<String, String> objParam : expParamsMap.entrySet()) {
            strMappingTo = strMappingTo.replaceAll(objParam.getKey(), "'" + objParam.getValue() + "'");
        }
        return strMappingTo;
    }
    
    /**
     * 获取绑定属性
     *
     * @param mappingTo 映射关系
     * @return 映射属性
     */
    private String getBindName(String mappingTo) {
        if (StringUtil.isBlank(mappingTo)) {
            return "";
        }
        return mappingTo.substring(mappingTo.indexOf('.') + 1);
    }
    
    /**
     * 设置表格数据源
     * 
     * @param expression 表达式执行器
     * @param objDocChapterContentStructVO 章节内容结构信息
     * @param objTable 表格
     * @return 表格数据VO
     */
    private DocGridDataVO obtainGridData(ExpressionExecuteHelper expression,
        DocChapterContentStructVO objDocChapterContentStructVO, DCTable objTable) {
        DocGridDataVO objGridDataVO = new DocGridDataVO();
        expression.notifyStart();
        String dataSource = objDocChapterContentStructVO.getMappingTo();
        Object result = null;
        if (StringUtils.isNotBlank(dataSource)) {
            if (dataSource.indexOf("#") > 0) { // constraint[]=#BizNodeConstraint(nodeId=flowNode.id,domainId=$domainId)
                result = expression.read(dataSource);
            } else { // dataItem[]=bizRelation.dataItems
                // 先获取bizRelation，获取方式：执行表达式bizRelation=#BizRelation(id="")
                // 获取dataItem，获取方式：执行表达式dataItem[]=bizRelation.dataItems
                // String strReference = ExprUtil.getVarsName(dataSource);
                String strReference = dataSource.substring(dataSource.indexOf("=") + 1, dataSource.indexOf("."));
                String strObjectIdExp = strReference.replace("[]", "") + CapDocContentConstant.ID_EXP_CONNECTOR;
                String strObjectId = objDocChapterContentStructVO.getObjectIdMap().get(strObjectIdExp);
                String strServiceName = objDocChapterContentStructVO.getServiceMap().get(strReference + "[]");
                String strVoExp = getVoExp(strReference, strServiceName, strObjectId);
                expression.notifyStart();
                if (StringUtils.isNotBlank(strVoExp)) {
                    expression.read(strVoExp);
                }
                result = expression.read(dataSource);
                expression.notifyEnd();
            }
        }
        if (result != null && result instanceof List<?>) { // 通过堆栈来执环的顺序
            List<?> coll = (List<?>) result;
            objGridDataVO.setLstGrid(coll);
        }
        expression.notifyEnd();
        return objGridDataVO;
    }
    
    /**
     * 获取固定表结构
     * 
     * @param expression 表达式执行器
     * @param docChapterContentStruct 内容
     * @param objTable 节点
     */
    private void obtainXmlForFixedTable(ExpressionExecuteHelper expression,
        DocChapterContentStructVO docChapterContentStruct, DCTable objTable) {
        StringBuffer sbXml = new StringBuffer();
        String strDivId = CapContentHelper.getUUID();
        docChapterContentStruct.setId(strDivId);
        if (StringUtil.isNotBlank(objTable.getMappingTo())) {// 执行表达式
            docChapterContentStruct.setMappingTo(objTable.getMappingTo());
            expression.notifyStart();
            expression.read(replaceMappingTo(docChapterContentStruct, objTable.getMappingTo()));
        }
        // sbXml.append("<button");
        // sbXml.append(" id=\"FixedTable").append(docChapterContentStruct.getId()).append("\"");
        // sbXml.append(" onclick=\"editOpen('").append(docChapterContentStruct.getId()).append("')\"");
        // sbXml.append(">编 辑</button>");
        // table表头
        sbXml.append("<table style=\"width:100%;\" border=\"1\"");
        sbXml.append(" name=\"").append(objTable.getName()).append("\"");
        sbXml.append(">");
        
        List<DCTableRow> rows = objTable.getRows();
        // 获取固定表的最大列数量
        int iMaxTd = CapContentHelper.getMaxTdCount(rows);
        for (DCTableRow tableRow : rows) {
            sbXml.append("<tr style=\"height:28px;\" >");
            List<DCTableCell> cells = tableRow.getXmlCells();
            for (DCTableCell tableCell : cells) {
                // 设置每列宽度比
                String strWidth = CapContentHelper.getPercentWidth(tableCell.getColspan(), iMaxTd);
                sbXml.append("<td ");
                // 样式
                setTableTdStyle(sbXml, tableCell, strWidth);
                // 属性
                setTableTdAttribute(sbXml, tableCell);
                sbXml.append(">");
                // <td></td>之间的内容
                setTableTdValue(expression, docChapterContentStruct, objTable, sbXml, tableCell);
                sbXml.append("</td>");
            }
            sbXml.append("</tr>");
        }
        if (StringUtil.isNotBlank(objTable.getMappingTo())) {
            expression.notifyEnd();
        }
        sbXml.append("</table>");
        docChapterContentStruct.setXmlContent(sbXml.toString());
    }
    
    /**
     * 设置单元格值
     *
     * @param expression 表达式执行器
     * @param docChapterContentStruct 上下文信息IdMap，ServiceMap
     * @param objTable table信息
     * @param sbXml html字符串
     * @param tableCell 单元格信息
     */
    private void setTableTdValue(ExpressionExecuteHelper expression, DocChapterContentStructVO docChapterContentStruct,
        DCTable objTable, StringBuffer sbXml, DCTableCell tableCell) {
        if (StringUtil.isNotBlank(tableCell.getMappingTo())) {
            // mappingTo有值
            if (StringUtil.isBlank(objTable.getMappingTo())) {
                // 取上下文表达式的值
                sbXml.append(getBizAttrValue(expression, docChapterContentStruct, tableCell.getMappingTo()));
            } else {
                // 取表达式执行器的值
                String strMappingValue = (String) expression.read(tableCell.getMappingTo());
                sbXml.append(strMappingValue == null ? "" : strMappingValue);
            }
        } else if (StringUtil.isNotBlank(tableCell.getHeaderName())) {
            // mappingTo无值，取xml配置的固定内容
            sbXml.append(tableCell.getHeaderName());
        }
    }
    
    /**
     * 设置table的列属性
     *
     * 
     * @param sbXml html字符串
     * @param tableCell 单元格信息
     */
    private void setTableTdAttribute(StringBuffer sbXml, DCTableCell tableCell) {
        if (tableCell.getColspan() > 1) {
            sbXml.append(" colspan=\"").append(tableCell.getColspan()).append("\"");
        }
        if (tableCell.getRowspan() > 1) {
            sbXml.append(" rowspan=\"").append(tableCell.getRowspan()).append("\"");
        }
        if (StringUtil.isNotBlank(tableCell.getMappingTo())) {
            sbXml.append(" mappingTo=\"").append(tableCell.getMappingTo()).append("\"");
        }
    }
    
    /**
     * 设置Table的列样式
     *
     * @param sbXml html字符串
     * @param tableCell 单元格信息
     * @param strWidth 宽
     */
    private void setTableTdStyle(StringBuffer sbXml, DCTableCell tableCell, String strWidth) {
        if (tableCell.getWidth() > 0) {
            sbXml.append(" style=\"width:").append(getFixedWidth(tableCell.getWidth())).append(";");
        } else {
            sbXml.append(" style=\"width:").append(strWidth).append(";");
        }
        if (StringUtil.isNotBlank(tableCell.getHeaderName())) {
            sbXml.append(" background-color:#ddd; ");
        }
        sbXml.append("\"");
    }
    
    /**
     * 计算xml配置的width（例：3），单位为cm 占用的宽度比
     *
     * @param width 宽度
     * @return 宽度比
     */
    private String getFixedWidth(float width) {
        float fPxWidth = width * 25;
        double dPxWidth = Double.parseDouble(String.valueOf(fPxWidth));
        double dMaxPx = 1024 * 1.0;
        double dResult = dPxWidth / dMaxPx;
        NumberFormat objNf = NumberFormat.getPercentInstance();
        objNf.setMinimumFractionDigits(0);
        return objNf.format(dResult);
    }
    
    /**
     * 保存文本内容
     *
     * @param docChapterContentStructVO 内容VO
     * @return 返回内容结构ID
     */
    public String saveDocChapterContentStruct(DocChapterContentStructVO docChapterContentStructVO) {
        if (isExecuteMappingTo(docChapterContentStructVO, docChapterContentStructVO.getMappingTo())) {
            // 有上下文，保存到业务建模表。只可能为update
            String strBizObjectId = saveBizText(docChapterContentStructVO);
            return strBizObjectId;
        }
        // 保存信息到通用文本表。insert或update
        String strCommObjectId = saveCommText(docChapterContentStructVO);
        return strCommObjectId;
    }
    
    /**
     * 保存文本信息到通用表
     *
     * @param docStructVO 当前分段内容
     * @return 对象ID
     */
    private String saveCommText(DocChapterContentStructVO docStructVO) {
        DocChapterContentStructVO objDocChapterContentStructVO = this.docChapterContentStructDAO
            .queryDocChapterStructByUniqueCondition(docStructVO);
        if (objDocChapterContentStructVO == null) { // 新增
            String strContent = docStructVO.getEditorHtml();
            DocChapterContentVO objDocChapterContentVO = new DocChapterContentVO();
            objDocChapterContentVO.setContent(strContent);
            String contentId = (String) docChapterContentAppService.insertDocChapterContent(objDocChapterContentVO);
            docStructVO.setContentId(contentId);
            docStructVO.setDataFrom(DataFromType.MANUAL_CREATE);
            return (String) this.insertDocChapterContentStruct(docStructVO);
        }
        String strContent = docStructVO.getEditorHtml();
        DocChapterContentVO objDocChapterContentVO = new DocChapterContentVO();
        objDocChapterContentVO.setId(objDocChapterContentStructVO.getContentId());
        objDocChapterContentVO.setContent(strContent);
        docChapterContentAppService.updateDocChapterContent(objDocChapterContentVO);
        return objDocChapterContentStructVO.getId();
    }
    
    /**
     * 保存文本信息到业务建模表
     *
     * @param docStructVO 当前分段内容
     * @return 对象ID
     */
    @SuppressWarnings({ "unchecked", "rawtypes" })
    private String saveBizText(DocChapterContentStructVO docStructVO) {
        String strMappingTo = docStructVO.getMappingTo();
        String[] strAttrName = strMappingTo.split("\\.");
        String strObjectId = getObjectIdByExp(strMappingTo, docStructVO);
        String strServiceClassFullName = getServiceNameByExp(strMappingTo, docStructVO, true);
        try {
            Class objClass = Class.forName(strServiceClassFullName);
            Object objInstance = AppBeanUtil.getBean(objClass);
            Method objMethod = objClass.getMethod("updatePropertyByID", String.class, String.class, Object.class);
            objMethod.invoke(objInstance, strObjectId, strAttrName[1], docStructVO.getEditorHtml());
        } catch (ClassNotFoundException e) {
            e.printStackTrace();
        } catch (NoSuchMethodException e) {
            e.printStackTrace();
        } catch (SecurityException e) {
            e.printStackTrace();
        } catch (IllegalAccessException e) {
            e.printStackTrace();
        } catch (IllegalArgumentException e) {
            e.printStackTrace();
        } catch (InvocationTargetException e) {
            e.printStackTrace();
        }
        return strObjectId;
    }
    
    /**
     * 根据URI查询唯一值
     *
     * @param docChapterContentStructVO 查询条件
     * @return 返回值
     */
    public DocChapterContentStructVO queryDocChapterStructByUniqueCondition(
        DocChapterContentStructVO docChapterContentStructVO) {
        return docChapterContentStructDAO.queryDocChapterStructByUniqueCondition(docChapterContentStructVO);
    }
    
    @Override
    protected MDBaseDAO<DocChapterContentStructVO> getDAO() {
        return docChapterContentStructDAO;
    }
    
    /**
     * 获取内容片段
     *
     * @param condition 条件
     * @return 内容片段
     */
    public List<ContentSeg> loadContentSegDTOList(ContentSeg condition) {
        return docChapterContentStructDAO.queryList("com.comtop.cap.doc.content.model.loadContentSegList", condition);
    }
    
    /**
     * 更新容器内容
     *
     * @param oldUriPrefix 老URI
     * @param newUriPrefix 新URI
     * @param documentId 文档ID
     */
    public void updateContainerUri(String oldUriPrefix, String newUriPrefix, String documentId) {
        Map<String, String> params = new HashMap<String, String>();
        params.put("oldUriPrefix", oldUriPrefix);
        params.put("newUriPrefix", newUriPrefix);
        params.put("documentId", documentId);
        docChapterContentStructDAO.update("com.comtop.cap.doc.content.model.updateContainerUri", params);
    }
    
    /**
     * 根据容器URI删除内容
     *
     * @param oldUriPrefix URI
     * @param documentId 文档ID
     */
    public void deleteByContainerUri(String oldUriPrefix, String documentId) {
        Map<String, String> params = new HashMap<String, String>();
        params.put("oldUriPrefix", oldUriPrefix);
        params.put("documentId", documentId);
        docChapterContentStructDAO.delete("com.comtop.cap.doc.content.model.deleteByContainerUri", params);
    }
    
    /**
     * 懒加载树
     *
     * @param docChapterContentStructVO 父节点信息
     * @return 懒加载树
     */
    public List<DocChapterContentStructVO> getChapterTree(DocChapterContentStructVO docChapterContentStructVO) {
        // 获取xml解析结构
        DocumentVO objDocumentVO = documentAppService.loadDocumentById(docChapterContentStructVO.getDocumentId());
        
        // 初始化表达式执行器：一个文档树，一个执行器
        Configuration objConfiguration = new Configuration(Strategy.READ, getInitializer());
        ExpressionExecuteHelper executer = new ExpressionExecuteHelper(objConfiguration);
        DocConfig objDocConfig = getDocConfig(objDocumentVO, objConfiguration);
        CommonDataManager.setDocConfig(objDocConfig);
        // 文档结构树
        List<DocChapterContentStructVO> lstTree = new ArrayList<DocChapterContentStructVO>();
        DocChapterContentStructVO objParentDocStructVO;
        
        if (String.valueOf(NumberConstant.MINUS_ONE).equals(docChapterContentStructVO.getParentTreeId())) {
            // 根节点
            objParentDocStructVO = getDocStructRoot(objDocumentVO);
            lstTree.add(objParentDocStructVO);
            // 根节点下级
            List<DCSection> sections = objDocConfig.getSections();
            for (DCSection section : sections) {
                List<DCChapter> chapters = section.getChapters();
                if (CAPCollectionUtils.isEmpty(chapters)) {
                    continue;
                }
                objParentDocStructVO.setContainerUri(section.getName());
                objParentDocStructVO.setXmlfullPath(section.getName());
                chapterSubTree(section.getChapters(), objParentDocStructVO, lstTree, executer);
            }
        } else {
            // 懒加载父节点
            docChapterContentStructVO.setDomainId(objDocumentVO.getBizDomain());
            lstTree.add(docChapterContentStructVO);
            // 懒加载下级
            List<DCSection> sections = objDocConfig.getSections();
            String[] strName = docChapterContentStructVO.getXmlfullPath().split(CapDocContentConstant.URI_CONNECTOR);
            for (DCSection section : sections) {
                DCChapter objChapter = getEditChapter(strName, section.getChapters(), 1);
                if (objChapter != null) {
                    chapterSubTree(objChapter.getChildChapters(), docChapterContentStructVO, lstTree, executer);
                }
            }
        }
        CommonDataManager.removeDocConfig();
        return lstTree;
    }
    
    /**
     * 懒加载-树的直接下级
     * 
     * @param chapters 直接下级章节list
     * @param parentDocStructVO 上级章节节点VO
     * @param lstChapter 节点集合
     * @param executer 表达式执行器
     */
    private void chapterSubTree(List<DCChapter> chapters, DocChapterContentStructVO parentDocStructVO,
        List<DocChapterContentStructVO> lstChapter, ExpressionExecuteHelper executer) {
        DocChapterContentStructVO objDocChapterContentStructVO;
        // 章节同级编号的序号
        int iWordNumber = CapNumberConstant.NUMBER_INT_ZERO;
        for (DCChapter chapter : chapters) {
            // 区分固定-动态章节
            if (isDynamicChapter(chapter)) {
                // 构造堆栈
                executer.notifyStart();
                executer.setVariable("domainId", parentDocStructVO.getDomainId());
                String dataSource = chapter.getMappingTo();
                Object result = null;
                if (StringUtils.isNotBlank(dataSource)) {
                    result = executer.read(replaceMappingTo(parentDocStructVO, dataSource));
                }
                // 通过堆栈来执行循环的顺序
                if (result != null && result instanceof Collection<?>) {
                    Collection<?> coll = (Collection<?>) result;
                    int iCollSize = coll.size();
                    for (int i = 0; i < iCollSize; i++) {
                        // 取堆栈数据
                        iWordNumber++;
                        executer.notifyStart();
                        objDocChapterContentStructVO = getDynamicChapterToVO(parentDocStructVO, iWordNumber, chapter,
                            executer);
                        lstChapter.add(objDocChapterContentStructVO);
                        executer.notifyEnd();
                    }
                }
                executer.notifyEnd();
            } else {
                if (StringUtil.isNotBlank(chapter.getMappingTo())) {
                    executer.notifyStart();
                    executer.read(chapter.getMappingTo());
                }
                iWordNumber++;
                // 固定章节基本信息
                objDocChapterContentStructVO = getFixedChapterNodeVO(parentDocStructVO, iWordNumber, chapter, executer);
                lstChapter.add(objDocChapterContentStructVO);
                if (StringUtil.isNotBlank(chapter.getMappingTo())) {
                    executer.notifyEnd();
                }
            }
        }
    }

    /**
     * 将用户设计的原型页面截图保存到文档对应章节内容中，保证需求文档中功能子项下的界面原型里的内容完整。
     * @param reqFunctionSubitemId 功能子项id
     * @return true 成功，false 失败
     */
	public boolean saveReqFunctionPrototype(String reqFunctionSubitemId) {
		ReqFunctionSubitemVO objReqFunctionSubitemVO = reqFunctionSubitemAppService.loadReqFunctionSubitemById(reqFunctionSubitemId);
		return saveReqFunctionPrototype(objReqFunctionSubitemVO);
	}
	
	/**
     * 将用户设计的原型页面截图保存到文档对应章节内容中，保证需求文档中功能子项下的界面原型里的内容完整。
     * @param objReqFunctionSubitemVO	功能子项对象
     * @return true 成功，false 失败
     */
	public boolean saveReqFunctionPrototype(ReqFunctionSubitemVO objReqFunctionSubitemVO) {
		if(objReqFunctionSubitemVO == null || objReqFunctionSubitemVO.getDocumentId() == null) {
			return false;
		}
		
		List<PrototypeVO> prototypeVOList;
		try {
			prototypeVOList = prototypeFacade.queryPrototypesByFunctionSubitemId(objReqFunctionSubitemVO.getId());
		} catch (OperateException e) {
			LOG.error("保存页面原型图片到文档时读取功能子项下原型页面元数据错误，功能子项id={}。", objReqFunctionSubitemVO.getId(), e);
			return false;
		}
		
		return saveReqFunctionPrototype(objReqFunctionSubitemVO, prototypeVOList);
	}
	
	/**
     * 将用户设计的原型页面截图保存到文档对应章节内容中，保证需求文档中功能子项下的界面原型里的内容完整。
     * @param objReqFunctionSubitemVO	功能子项对象
	 * @param prototypeVOList 功能子项对应页面原型对象
     * @return true 成功，false 失败
     */
	public boolean saveReqFunctionPrototype(ReqFunctionSubitemVO objReqFunctionSubitemVO, List<PrototypeVO> prototypeVOList) {
		if(objReqFunctionSubitemVO == null || objReqFunctionSubitemVO.getDocumentId() == null || prototypeVOList == null || prototypeVOList.isEmpty()) {
			return false;
		}
		
		DocChapterContentStructVO docChapterContentStructVO = queryDocChapterStructBycontainerUri(objReqFunctionSubitemVO.getDocumentId(), objReqFunctionSubitemVO.getId() + "/界面原型");
		if(docChapterContentStructVO == null) {
			insertProtoTypeDocChapterContentStructVO(objReqFunctionSubitemVO, prototypeVOList);
		} else {
			return docChapterContentAppService.updateProtoTypeChapterContent(docChapterContentStructVO.getContentId(), prototypeVOList);
		}
		return true;
	}
	
	/**
	 * 新增功能子项界面原型章节结构和内容
	 * @param objReqFunctionSubitemVO	功能子项对象
	 * @param prototypeVOList 功能子项对应页面原型对象
	 */
	private void insertProtoTypeDocChapterContentStructVO(ReqFunctionSubitemVO objReqFunctionSubitemVO, List<PrototypeVO> prototypeVOList) {
		DocChapterContentVO docChapterContentVO = docChapterContentAppService.insertProtoTypeChapterContent(prototypeVOList);
		DocChapterContentStructVO docChapterContentStructVO = new DocChapterContentStructVO();
		docChapterContentStructVO.setContainerUri(objReqFunctionSubitemVO.getId() + "/界面原型");
		docChapterContentStructVO.setContainerType("Chapter");
		docChapterContentStructVO.setContentType(ContentType.TEXT.toString());
		docChapterContentStructVO.setSortNo(0);
		docChapterContentStructVO.setContentId(docChapterContentVO.getId());
		docChapterContentStructVO.setDataFrom(0);
		docChapterContentStructVO.setDocumentId(objReqFunctionSubitemVO.getDocumentId());
		insertDocChapterContentStruct(docChapterContentStructVO);
	}

	/**
	 * 根据给定的documentId和 containerUri查询对应的DocChapterContentStructVO
	 * @param documentId 文档id
	 * @param containerUri containerUri
	 * @return DocChapterContentStructVO
	 */
	private DocChapterContentStructVO queryDocChapterStructBycontainerUri(String documentId, String containerUri) {
		DocChapterContentStructVO paramVO = new DocChapterContentStructVO();
		paramVO.setDocumentId(documentId);
		paramVO.setContainerUri(containerUri);
		return (DocChapterContentStructVO) docChapterContentStructDAO.selectOne("com.comtop.cap.doc.content.model.queryDocChapterStructBycontainerUri", paramVO);
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
		List<ReqFunctionSubitemVO> lstReqFunctionSubitemVO = reqFunctionSubitemAppService.queryNoDoumentSubitemVO(domainId);
		for(ReqFunctionSubitemVO vo : lstReqFunctionSubitemVO) {
			vo.setDocumentId(documentId);
			saveReqFunctionPrototype(vo);
		}
	}
    
}
