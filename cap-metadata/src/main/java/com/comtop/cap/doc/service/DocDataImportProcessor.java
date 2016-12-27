/******************************************************************************
 * Copyright (C) 2016 ShenZhen ComTop Information Technology Co.,Ltd
 * All Rights Reserved.
 * 本软件为深圳康拓普开发研制。未经本公司正式书面同意，其他任何个人、团体不得使用、
 * 复制、修改或发布本软件.
 *****************************************************************************/

package com.comtop.cap.doc.service;

import java.io.File;
import java.io.FileInputStream;
import java.io.InputStream;
import java.sql.Timestamp;
import java.util.HashMap;
import java.util.List;
import java.util.Map;
import java.util.Map.Entry;

import org.apache.commons.io.IOUtils;
import org.apache.commons.lang.StringUtils;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;

import com.comtop.cap.doc.DocProcessParams;
import com.comtop.cap.doc.info.facade.DocumentFacade;
import com.comtop.cap.doc.info.model.DocumentVO;
import com.comtop.cap.doc.operatelog.facade.DocOperLogFacade;
import com.comtop.cap.doc.operatelog.model.DocOperLogVO;
import com.comtop.cap.doc.tmpl.facade.CapDocTemplateFacade;
import com.comtop.cap.doc.tmpl.model.CapDocTemplateVO;
import com.comtop.cap.document.word.WordOptions;
import com.comtop.cap.document.word.docconfig.DocConfigManager;
import com.comtop.cap.document.word.docconfig.datatype.DocConfigType;
import com.comtop.cap.document.word.docconfig.model.DocConfig;
import com.comtop.cap.document.word.docmodel.data.BaseDTO;
import com.comtop.cap.document.word.docmodel.data.WordDocument;
import com.comtop.cap.document.word.expression.Configuration;
import com.comtop.cap.document.word.expression.Configuration.Strategy;
import com.comtop.cap.document.word.expression.ContainerInitializer;
import com.comtop.cap.document.word.parse.WordParseException;
import com.comtop.cap.document.word.parse.WordParser;
import com.comtop.cap.document.word.parse.util.ExprUtil;
import com.comtop.cap.document.word.util.DocUtil;
import com.comtop.cap.runtime.core.AppBeanUtil;
import com.comtop.top.component.common.systeminit.WebGlobalInfo;

/**
 * 抽象的doc数据处理器
 *
 * @author lizhiyong
 * @since jdk1.6
 * @version 2016年1月29日 lizhiyong
 */
abstract public class DocDataImportProcessor implements IDocDataProcessor {
    
    /** 日志对象 */
    private final static Logger LOGGER = LoggerFactory.getLogger(DocDataImportProcessor.class);
    
    /** 全局变量 */
    private final Map<String, Object> globalVals = new HashMap<String, Object>();
    
    /** 文档Facade */
    private final DocumentFacade documentFacade = AppBeanUtil.getBean(DocumentFacade.class);
    
    /** 文档操作记录Facade */
    private final DocOperLogFacade docOperLogFacade = AppBeanUtil.getBean(DocOperLogFacade.class);
    
    /** 文档模板Facade */
    private final CapDocTemplateFacade docTemplFacade = AppBeanUtil.getBean(CapDocTemplateFacade.class);
    
    @Override
    public void process(DocProcessParams docProcessParams) {
        // 保存文档初始化
        start(docProcessParams);
        String documentId = saveDocument(docProcessParams);
        // 更新文档的当前状态
        documentFacade.updatePropertyByID(documentId, "status", "正在导入");
        String operLogId = saveOperLogVO(docProcessParams, documentId);
        InputStream inputStream = null;
        try {
            // 初始化word导入所需的环境
            LOGGER.info("准备初始化导入环境");
            ContainerInitializer initializer = (ContainerInitializer) WebGlobalInfo.getServletContext().getAttribute(
                ContainerInitializer.class.getName());
            Configuration configuration = new Configuration(Strategy.WRITE, initializer);
            // 初始化word选项
            WordOptions options = new WordOptions(configuration, docProcessParams.getLogPath());
            // 初始化模板配置
            DocConfig docConfig = getDocconfig(docProcessParams.getDocTemplateVO(), options);
            inputStream = new FileInputStream(docProcessParams.getDocFile());
            importDoc(inputStream, docProcessParams.getDocument(), options, docConfig);
            
            // 如果配置有变化
            if (docConfig.getModifyTimes() >= 0) {
                // 更新模板文件
                updateDocconfig(docProcessParams.getDocument(), docConfig);
                // 更新文档及模板VO
                updateDocAndTemp(docProcessParams.getDocument(), docProcessParams.getDocTemplateVO(), docConfig);
            }
            finish(true);
            // 完成导入 记录日志
            LOGGER.info("导入完成");
            documentFacade.updatePropertyByID(documentId, "status", "导入成功");
            docOperLogFacade.updateOperResult(operLogId, "SUCCEED");
        } catch (Exception e) {
            LOGGER.error("导入word文档时发生异常", e);
            documentFacade.updatePropertyByID(documentId, "status", "导入失败");
            docOperLogFacade.updateOperResult(operLogId, "FAIL");
            finish(false);
        } finally {
            IOUtils.closeQuietly(inputStream);
            System.gc();
        }
    }
    
    /**
     * 获得模板配置
     *
     * @param capDocTemplateVO 模板对象
     * @param options 选项
     * @return 模板配置
     */
    private DocConfig getDocconfig(CapDocTemplateVO capDocTemplateVO, WordOptions options) {
        String webInfoPath = WebGlobalInfo.getWebInfoPath();
        File wordTempFile = new File(webInfoPath + capDocTemplateVO.getPath());
        DocConfigManager templateParser = new DocConfigManager();
        return templateParser.parseXml(wordTempFile, options);
    }
    
    /**
     * 保存文档信息
     *
     * @param docProcessParams 参数
     * @return 文档VO
     */
    private String saveDocument(DocProcessParams docProcessParams) {
        // 将当前要导入的文档信息入库 因为操作过程是一边解析一边导，所以无论如何，数据都入进入到数据库 ;
        DocumentVO documentVO = docProcessParams.getDocument();
        CapDocTemplateVO capDocTemplateVO = docProcessParams.getDocTemplateVO();
        // 保存文档信息
        List<DocumentVO> documentVOs = documentFacade.queryDocumentByName(documentVO);
        if (documentVOs == null || documentVOs.size() == 0) {
            if (StringUtils.isBlank(documentVO.getDocType())) {
                documentVO.setDocType(capDocTemplateVO.getType());
            }
            // 将当前要导入的文档信息入库 因为操作过程是一边解析一边导，所以无论如何，数据都入进入到数据库 ;
            documentVO.setSummaryFlag("SUM");
            documentVO.setNewTmplId(capDocTemplateVO.getId());
            documentVO.setDocTmplId(capDocTemplateVO.getId());
            documentVO.setDocTemplateName(capDocTemplateVO.getName());
            String documentId = documentFacade.insertDocument(documentVO).toString();
            documentVO.setId(documentId);
            
        } else {
            DocumentVO exist = documentVOs.get(0);
            documentVO.setId(exist.getId());
            documentVO.setDocTmplId(exist.getId());
            documentVO.setNewTmplId(capDocTemplateVO.getId());
            documentVO.setDocType(capDocTemplateVO.getType());
            documentVO.setSummaryFlag(exist.getSummaryFlag());
            documentVO.setBizDomain(exist.getBizDomain());
        }
        
        return documentVO.getId();
    }
    
    /**
     * 更新配置
     *
     * @param documentVO 文档
     * @param docConfig 配置
     */
    private void updateDocconfig(DocumentVO documentVO, DocConfig docConfig) {
        LOGGER.info("开始更新模板");
        File newFile = DocUtil.createNewConfigFilePath(documentVO.getDocType(), documentVO.getId(),
            docConfig.getConfigFile());
        docConfig.setName("专用模板-" + documentVO.getName());
        docConfig.setConfigFile(newFile);
        // 持久化新模板 创建一个新的模板文件
        DocConfigManager docConfigManager = new DocConfigManager();
        docConfigManager.createNewDocConfig(docConfig);
        LOGGER.info("结束更新模板");
    }
    
    /**
     * 更新模板和文档对象
     * 
     * @param documentVO 文档对象
     *
     * @param curTemp 当前关联的模板对象
     * @param docConfig 模板配置
     */
    private void updateDocAndTemp(DocumentVO documentVO, CapDocTemplateVO curTemp, DocConfig docConfig) {
        CapDocTemplateVO capDocTemplateVO = new CapDocTemplateVO();
        // 持久化新模板 将模板信息持久化到数据库
        capDocTemplateVO.setName(docConfig.getName());
        capDocTemplateVO.setPath(DocUtil.getDocConfigFilePath(docConfig.getConfigFile()));
        capDocTemplateVO.setType(documentVO.getDocType());
        capDocTemplateVO.setDocConfigType(DocConfigType.PRIVATE.name());
        capDocTemplateVO.setRemark("专用模板:" + documentVO.getName());
        // 更新文档与模板的关联关系 如果当前文档使用的专用模板，则直接更新模板的路径。否则创建一个新的模板对象，并将当前word文档关联到该模板上
        if (StringUtils.equals(DocConfigType.PRIVATE.name(), curTemp.getDocConfigType())) {
            capDocTemplateVO.setId(curTemp.getId());
            docTemplFacade.updateCapDocTemplate(capDocTemplateVO);
        } else {
            String tempId = docTemplFacade.insertCapDocTemplate(capDocTemplateVO).toString();
            documentFacade.updatePropertyByID(documentVO.getId(), "docTmplId", tempId);
        }
    }
    
    /**
     * 导入文档
     *
     * @param inputStream 输入流
     * @param doucment 文档
     * @param options 选项
     * @param docConfig 模板
     * @throws WordParseException 异常
     */
    private void importDoc(InputStream inputStream, DocumentVO doucment, WordOptions options, DocConfig docConfig)
        throws WordParseException {
        if (LOGGER.isInfoEnabled()) {
            LOGGER.info("开始导入文档：" + doucment.getName());
        }
        if (globalVals.size() > 0) {
            for (Entry<String, Object> entry : globalVals.entrySet()) {
                ExprUtil.execute(options.getExpExecuter(), entry.getKey(), entry.getValue());
            }
        }
        // 初始化WordDocument对象
        WordDocument doc = new WordDocument(docConfig);
        doc.setId(doucment.getId());
        doc.setName(doucment.getName());
        doc.setDomainId(doucment.getBizDomain());
        // 解析析word文档
        doc.setOptions(options);
        
        // 初始化需要缓存的对象管理器。每次执行都初始化一次，保证不会有脏数据
        CommonDataManager.init();
        CommonDataManager.setCurrentWordDocument(doc);
        CommonDataManager.setDocConfig(docConfig);
        DataIndexManager dataIndexManager = new DataIndexManager();
        CommonDataManager.setCurrentDataIndexManager(dataIndexManager);
        Map<Class<? extends BaseDTO>, IIndexBuilder> map = getIndexBuilders();
        if (map != null && map.size() > 0) {
            for (Entry<Class<? extends BaseDTO>, IIndexBuilder> entry : map.entrySet()) {
                dataIndexManager.registerIndexBuilder(entry.getKey(), entry.getValue());
            }
        }
        
        WordParser parser = new WordParser();
        parser.parse(inputStream, doc);
        
        dataIndexManager.clearDataIndexMap();
        CommonDataManager.removeCurrentDataIndexManager();
        
        CommonDataManager.removeDocConfig();
        CommonDataManager.removeCurrentWordDocument();
        if (LOGGER.isInfoEnabled()) {
            LOGGER.info("结束导入文档：" + doc.getName());
        }
    }
    
    /**
     * 得到索引构建器
     *
     * @return 索引构建器集
     */
    protected Map<Class<? extends BaseDTO>, IIndexBuilder> getIndexBuilders() {
        // 子类按需实现
        return null;
    }
    
    /**
     * 保存导入、导出日志
     * 
     * @param params 文档操作参数
     * @param documentId 文档id
     * @return 插入后的日志数据ID
     */
    private String saveOperLogVO(DocProcessParams params, String documentId) {
        // 创建 操作日志
        String logPath = DocUtil.createLogPath(params.getWebPath(), documentId, "docimport");
        params.setLogPath(logPath);
        String logFileUrl = logPath.substring(params.getWebPath().length());
        Timestamp curTime = new Timestamp(System.currentTimeMillis());
        DocumentVO documentVO = params.getDocument();
        DocOperLogVO operLogVO = new DocOperLogVO();
        operLogVO.setUserId(params.getCurUserId());
        operLogVO.setUserName(params.getCurUserName());
        operLogVO.setBizDomainId(documentVO.getBizDomain());
        operLogVO.setOperType("IMP");
        operLogVO.setOperTime(curTime);
        operLogVO.setFileAddr(params.getFileHttpUrl());// loadFile.toFileLocation().toHttpUrlString()
        operLogVO.setDocumentId(documentVO.getId());
        operLogVO.setLogFilePath(logFileUrl);
        operLogVO.setRemark(documentVO.getName());// 暂使用备注字段保存文档名称
        return docOperLogFacade.inserOperLog(operLogVO);
    }
    
    /**
     * 初始化变量
     * 
     * @param docProcessParams 参数集
     */
    private void start(DocProcessParams docProcessParams) {
        beforeImport(docProcessParams);
    }
    
    /**
     * 添加全局变量
     *
     * @param varName 变量名
     * @param value 变量值
     */
    final protected void addGlobalVar(String varName, Object value) {
        globalVals.put(varName, value);
    }
    
    /**
     * 导入完成之后的操作
     * 
     * @param isSuccesss 成功与否
     *
     */
    private void finish(boolean isSuccesss) {
        afterImport(isSuccesss);
    }
    
    /**
     * 初始化变量
     * 
     * @param params 参数集
     */
    abstract protected void beforeImport(DocProcessParams params);
    
    /**
     * 导入完成之后的操作
     * 
     * @param isSuccesss 是否处理成功
     *
     */
    abstract protected void afterImport(boolean isSuccesss);
}
