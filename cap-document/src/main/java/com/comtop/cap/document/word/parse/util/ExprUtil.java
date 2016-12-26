/******************************************************************************
 * Copyright (C) 2015 ShenZhen ComTop Information Technology Co.,Ltd
 * All Rights Reserved.
 * 本软件为深圳康拓普开发研制。未经本公司正式书面同意，其他任何个人、团体不得使用、
 * 复制、修改或发布本软件.
 *****************************************************************************/

package com.comtop.cap.document.word.parse.util;

import java.lang.reflect.Field;
import java.text.MessageFormat;
import java.util.Collection;
import java.util.HashMap;
import java.util.List;
import java.util.Map;
import java.util.Map.Entry;
import java.util.regex.Matcher;

import org.apache.commons.lang.StringUtils;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;

import com.comtop.cap.document.expression.support.TypedValue;
import com.comtop.cap.document.util.CollectionTypeResolver;
import com.comtop.cap.document.util.ReflectionHelper;
import com.comtop.cap.document.word.docconfig.datatype.ChapterType;
import com.comtop.cap.document.word.docconfig.model.DCChapter;
import com.comtop.cap.document.word.docconfig.model.DCContainer;
import com.comtop.cap.document.word.docconfig.model.DCContentSeg;
import com.comtop.cap.document.word.docconfig.model.DCTable;
import com.comtop.cap.document.word.docmodel.data.Chapter;
import com.comtop.cap.document.word.docmodel.data.Container;
import com.comtop.cap.document.word.docmodel.data.ContentSeg;
import com.comtop.cap.document.word.docmodel.data.Section;
import com.comtop.cap.document.word.docmodel.data.Table;
import com.comtop.cap.document.word.docmodel.data.WordDocument;
import com.comtop.cap.document.word.docmodel.datatype.ContentType;
import com.comtop.cap.document.word.docmodel.datatype.DataFromType;
import com.comtop.cap.document.word.expression.ExprEvent;
import com.comtop.cap.document.word.expression.ExprType;
import com.comtop.cap.document.word.expression.IExpressionExecuter;
import com.comtop.cap.document.word.parse.WordParseException;
import com.comtop.cap.document.word.util.IdGenerator;

/**
 * 表达式操作工具类
 *
 * @author lizhiyong
 * @since jdk1.6
 * @version 2015年11月13日 lizhiyong
 */
public class ExprUtil {
    
    /** 日志对象 */
    private static final Logger LOGGER = LoggerFactory.getLogger(ExprUtil.class);
    
    /** 非结构化存储数据对应的过滤表达式 */
    private static final String CONTENT_SEG_FILTER_EXPR = "contentSeg=$selectWithType(contentSeg[],''{0}'',''containerUri:{1}'',''sortNo:{2}'')";
    
    /** 非结构化存储数据对应的表达式 */
    private static final String CONTENT_SEG_EXPR = "$contentSeg[]=#ContentSeg(documentId=''{0}'')";
    
    /**
     * 将章节数据转为模型对象
     * 
     * @param expExecuter 表达式执行器
     *
     * @param chapter 当前章节
     */
    public static void startChapter(IExpressionExecuter expExecuter, Chapter chapter) {
        DCChapter definition = (DCChapter) chapter.getDefinition();
        Chapter preChapter = chapter.getPreChapter();
        DCChapter preChapterDefinition = null;
        if (preChapter != null) {
            preChapterDefinition = (DCChapter) preChapter.getDefinition();
        }
        // 结束前一个章节
        if (preChapter != null) {
            endPreChapterChain(expExecuter, chapter);
        }
        if (!hasChapterExpr(definition)) {
            return;
        }
        
        if (!definition.equals(preChapterDefinition)) {
            // 表示当前章节是一个新启的章节，可能是某个大章节的第一个子章节，也可能是一个新的已定义的章节，此时，如果有表达式，应该执行章节上的表达式。
            // 第一次进入某个章节表达式
            notify(expExecuter, ExprEvent.START);
            execute(expExecuter, definition.getMappingTo(), TypedValue.NULL);
        }
        // 如果当前章节定义是动态章节，则开始 一个新的动态章节
        if (definition.getChapterType() == ChapterType.DYNAMIC) {
            notify(expExecuter, ExprEvent.START);
        }
        // 计数器加一
        chapter.getDocument().getChapterCounter().incrementAndGet();
        
        // 动态章节需要进行过滤和添加基本属性
        if (definition.getChapterType() == ChapterType.DYNAMIC) {
            // 过滤当前章节对应的数据，使当前章节能够和已有的数据对应 上
            String filterExpr = getSelectExprWithType(expExecuter, definition, chapter);
            if (StringUtils.isNotBlank(filterExpr)) {
                execute(expExecuter, filterExpr, TypedValue.NULL);
            }
            // 动态章节需要添加基本属性
            addDynamicChapterBasicAttribute(expExecuter, definition, chapter);
        }
        
    }
    
    /**
     * 将章节数据转为模型对象
     * 
     * @param expExecuter 表达式执行器
     *
     * @param chapter 当前章节
     */
    public static void endPreChapterChain(IExpressionExecuter expExecuter, Chapter chapter) {
        Chapter preChapter = chapter.getPreChapter();
        if (preChapter != null) {
            Chapter preLastChapter = preChapter.getLastChapter();
            Chapter chapterChain = preLastChapter;
            // 处理一个指定章节的下级章节链结束
            while (chapterChain != null && chapterChain != preChapter) {
                endChapter(expExecuter, chapterChain, chapter);
                chapterChain = chapterChain.getParentChapter();
            }
            
            // 结束指定章节
            endChapter(expExecuter, preChapter, chapter);
            
        }
    }
    
    /**
     * 结束分节的内容
     *
     * @param expExecuter 执行器
     * @param section 分节
     */
    public static void endSectionContent(IExpressionExecuter expExecuter, Section section) {
        ContentSeg contentSeg = section.getLastHtmlTextContent();
        execHtmlText(expExecuter, contentSeg);
    }
    
    /**
     * 将章节数据转为模型对象
     * 
     * @param expExecuter 表达式执行器
     * @param toEndChapter 待结束章节
     * @param curChapter 当前章节
     */
    public static void endChapter(IExpressionExecuter expExecuter, Chapter toEndChapter, Chapter curChapter) {
        // 处理一个章节结束
        if (toEndChapter != null) {
            // 将本章节最后一个文本段落模型化
            ContentSeg contentSeg = toEndChapter.getLastHtmlTextContent();
            execHtmlText(expExecuter, contentSeg);
            DCChapter definition = (DCChapter) toEndChapter.getDefinition();
            // 如果需要处理
            if (hasChapterExpr(definition)) {
                // 计数器加一
                toEndChapter.getDocument().getChapterCounter().decrementAndGet();
                notify(expExecuter, ExprEvent.END);
            }
            DCChapter curDefinition = null;
            if (curChapter != null) {
                curDefinition = (DCChapter) curChapter.getDefinition();
            }
            if (definition != null) {
                // 结束动态章节的List
                if (definition.getChapterType() == ChapterType.DYNAMIC && !definition.equals(curDefinition)) {
                    notify(expExecuter, ExprEvent.END);
                }
            }
        }
    }
    
    /**
     * 是否需要执行表达式
     *
     * @param definition 章节定义
     * @return true 需要执行 false 不需要执行
     */
    private static boolean hasChapterExpr(DCChapter definition) {
        // 如果没有定义mapptingTo ，直接结束
        return StringUtils.isNotBlank(definition.getMappingTo());
    }
    
    /**
     * 全文章节结束
     * 
     * @param expExecuter 表达式执行器
     * @param doc 文档对象
     *
     */
    public static void endDocChapter(IExpressionExecuter expExecuter, WordDocument doc) {
        // 处理一个章节结束
        Chapter chapter = doc.getMainSection().getLastChapter();
        Chapter chapterChain = chapter;
        while (chapterChain != null) {
            endChapter(expExecuter, chapterChain, null);
            chapterChain = chapterChain.getParentChapter();
        }
        
        if (doc.getChapterCounter().get() > 0) {
            throw new WordParseException("章节表达式未正确结束");
        }
        Section lastSection = doc.getSections().get(doc.getSections().size() - 1);
        endSectionContent(expExecuter, lastSection);
    }
    
    /**
     * 创建全局文本内容
     *
     * @param expExecuter 表达式执行器
     * @param documentId 文档id
     */
    public static void createGlobalHtmlTextContent(IExpressionExecuter expExecuter, String documentId) {
        notify(expExecuter, ExprEvent.START);
        String expr = MessageFormat.format(CONTENT_SEG_EXPR, documentId);
        execute(expExecuter, expr, TypedValue.NULL);
    }
    
    /**
     * 结束全局图片内容
     *
     * @param expExecuter 表达式执行器
     */
    public static void endGlobalHtmlTextContent(IExpressionExecuter expExecuter) {
        notify(expExecuter, ExprEvent.END);
    }
    
    /**
     * 将章节中的某段以html方式存储的数据转为模型对象
     * 
     * @param expExecuter 表达式执行器
     *
     * @param contentSeg 当前数据
     */
    public static void execHtmlText(IExpressionExecuter expExecuter, ContentSeg contentSeg) {
        if (contentSeg == null) {
            return;
        }
        DCContentSeg definition = (DCContentSeg) contentSeg.getDefinition();
        String mappingTo = definition.getMappingTo();
        if (StringUtils.indexOf(mappingTo, "#ContentSeg(") >= 0) {
            if (definition.isNeedStore()) {
                // 创建章节内容对象
                createHtmlTextContentModel(expExecuter, definition, contentSeg, ContentType.UN_DEF_TXT);
            }
            return;
        }
        execute(expExecuter, mappingTo, contentSeg.getContent());
    }
    
    /**
     * 创建文本内容
     *
     * @param expExecuter 表达式执行器
     * @param contentSeg html文本
     * @param definition 文本定义
     * @param contentType 内容模型
     */
    private static void createHtmlTextContentModel(IExpressionExecuter expExecuter, DCContentSeg definition,
        ContentSeg contentSeg, ContentType contentType) {
        Container container = contentSeg.getContainer();
        Object sortNo = getExprValue(contentSeg.getSortNo());
        Object containerUir = getExprValue(container.getUri());
        String contentSegClassName = definition.getContainer().getDocConfig().getOptions().getConfiguration()
            .getContext().lookupValueObject("ContentSeg").getName();
        String filterExpr = MessageFormat.format(CONTENT_SEG_FILTER_EXPR, contentSegClassName, containerUir, sortNo);
        notify(expExecuter, ExprEvent.START);
        execute(expExecuter, filterExpr, TypedValue.NULL);
        // 创建章节内容对象
        String bizClassName = null;
        String containerType = container.getClass().getSimpleName();
        DCContainer containerDef = (DCContainer) container.getDefinition();
        if (containerDef != null && containerDef.getMappingToClass() != null) {
            bizClassName = containerDef.getMappingToClass().getSimpleName();
            containerType += "-" + bizClassName;
        }
        
        execute(expExecuter, "contentSeg.containerUri", containerUir);
        execute(expExecuter, "contentSeg.containerUriName", getExprValue(container.getUriName()));
        execute(expExecuter, "contentSeg.containerType", containerType);
        execute(expExecuter, "contentSeg.contentType", contentType.name());
        execute(expExecuter, "contentSeg.content", getExprValue(contentSeg.getContent()));
        execute(expExecuter, "contentSeg.sortNo", sortNo);
        execute(expExecuter, "contentSeg.container", container);
        addBasicAttribute(expExecuter, "contentSeg", container.getDocument(), null, container);
        notify(expExecuter, ExprEvent.END);
    }
    
    /**
     * 将章节数据转为模型对象
     * 
     * @param expExecuter 表达式执行器
     *
     * @param table 当前章节
     */
    public static void startTable(IExpressionExecuter expExecuter, Table table) {
        
        DCTable definition = (DCTable) table.getDefinition();
        if (definition == null || StringUtils.isBlank(definition.getMappingTo())) {
            return;
        }
        notify(expExecuter, ExprEvent.START);
        execute(expExecuter, definition.getMappingTo(), TypedValue.NULL);
        
        // 如果表格标题是表达式
        // if (StringUtils.isNotBlank(definition.getTitle()) && EXP_PATTERN.matcher(definition.getTitle()).find()) {
        // execute(expExecuter, definition.getTitle(), table.getTitle());
        // }
        
    }
    
    /**
     * 将章节数据转为模型对象
     * 
     * @param expExecuter 表达式执行器
     *
     * @param table 当前章节
     */
    public static void endTable(IExpressionExecuter expExecuter, Table table) {
        if (table == null) {
            return;
        }
        DCTable definition = (DCTable) table.getDefinition();
        // 处理一个表格结束
        if (definition == null || StringUtils.isBlank(definition.getMappingTo())) {
            return;
        }
        notify(expExecuter, ExprEvent.END);
    }
    
    /**
     * 一个业务对象开始 。行扩展表的一行 或列扩展表的一个，一个完整的固定结构表，均可视为一个业务对象
     * 
     * @param expExecuter 表达式执行器
     * @param filterExpr 过滤表达式
     * @param expr 创建对象的表达式
     *
     * @param valueMap 当前业务对象的属性集
     * @param doc 文档对象
     * @param container 容器
     */
    public static void execOneBizObject(IExpressionExecuter expExecuter, String filterExpr, String expr,
        Map<String, Object> valueMap, WordDocument doc, Container container) {
        String var = ExprUtil.getVarNameFromExpr(expr);
        notify(expExecuter, ExprEvent.START);
        if (StringUtils.isNotBlank(filterExpr)) {
            execute(expExecuter, filterExpr, TypedValue.NULL);
        }
        Object id = getValue(expExecuter, var + ".id");
        String strId = (id == null ? null : id.toString());
        execute(expExecuter, var + ".container", container);
        // 如果id为空，表示这新创建的对象
        if (StringUtils.isBlank(strId)) {
            addBasicAttribute(expExecuter, var, doc, IdGenerator.getUUID(), container);
        }
        addAttribute(expExecuter, valueMap);
        notify(expExecuter, ExprEvent.END);
    }
    
    /**
     * 一个业务对象开始 。行扩展表的一行 或列扩展表的一个，一个完整的固定结构表，均可视为一个业务对象
     * 
     * @param expExecuter 表达式执行器
     * @param filterExpr 过滤表达式
     * @param expr 创建对象的表达式
     *
     * @param valueMap 当前业务对象的属性集
     * @param doc 文档对象
     * @param container 容器
     */
    public static void execOneBizObjectOnFixTable(IExpressionExecuter expExecuter, String filterExpr, String expr,
        Map<String, Object> valueMap, WordDocument doc, Container container) {
        String var = ExprUtil.getVarNameFromExpr(expr);
        notify(expExecuter, ExprEvent.START);
        execute(expExecuter, expr, TypedValue.NULL);
        if (StringUtils.isNotBlank(filterExpr)) {
            execute(expExecuter, filterExpr, TypedValue.NULL);
        }
        Object id = getValue(expExecuter, var + ".id");
        String strId = (id == null ? null : id.toString());
        execute(expExecuter, var + ".container", container);
        // 如果id为空，表示这新创建的对象
        if (StringUtils.isBlank(strId)) {
            addBasicAttribute(expExecuter, var, doc, IdGenerator.getUUID(), container);
        }
        addAttribute(expExecuter, valueMap);
        notify(expExecuter, ExprEvent.END);
    }
    
    /**
     * 给变量代表的对象属性赋值
     *
     * @param expExecuter 表达式执行器
     * @param valueMap 值集
     */
    public static void addAttribute(IExpressionExecuter expExecuter, Map<String, Object> valueMap) {
        for (Entry<String, Object> entry : valueMap.entrySet()) {
            execute(expExecuter, entry.getKey(), getExprValue(entry.getValue()));
        }
    }
    
    /**
     * 添加基本属性
     * 
     * @param expExecuter 表达式执行器
     * @param definition 章节定义
     * @param chapter 章节实例
     */
    private static void addDynamicChapterBasicAttribute(IExpressionExecuter expExecuter, DCChapter definition,
        Chapter chapter) {
        // 处理章节标题表达式
        String varName = getVarNameFromExpr(definition.getMappingTo());
        execute(expExecuter, definition.getTitle(), chapter.getTitle());
        // 处理章节uri
        // 从业务对象中查找是否已经存在id。如果已经存在，则用该id作为章节id。否则生成新的对象id作为章节id。
        Object id = getValue(expExecuter, varName + ".id");
        String chapterUri = (id == null ? null : id.toString());
        execute(expExecuter, varName + ".container", chapter);
        if (StringUtils.isBlank(chapterUri)) {
            chapterUri = IdGenerator.getUUID();
            addBasicAttribute(expExecuter, varName, chapter.getDocument(), chapterUri, chapter);
        }
        chapter.setUri(chapterUri);
        chapter.setUriName(chapterUri + "(" + chapter.getTitle() + ")");
    }
    
    /**
     * 添加基本属性值
     *
     * @param expExecuter 执行器
     * @param doc 文档对象
     * @param var 变量名
     * @param id id值
     * @param container 对象所属文档容器
     */
    private static void addBasicAttribute(IExpressionExecuter expExecuter, String var, WordDocument doc, String id,
        Container container) {
        execute(expExecuter, var + ".domainId", doc.getDomainId());
        execute(expExecuter, var + ".dataFrom", DataFromType.IMPORT);
        execute(expExecuter, var + ".documentId", doc.getId());
        execute(expExecuter, var + ".id", id);
    }
    
    /**
     * 获得可执行的dataItem表达式
     * 
     * @param tableMapptingTo 表格的对应关系
     * @param selectSource 原始的表达式
     * @param valueMap 值集
     * @return 已替换变量的表达式
     */
    public static String getSelectExpr(String tableMapptingTo, String selectSource, Map<String, Object> valueMap) {
        if (StringUtils.isBlank(selectSource) || StringUtils.isBlank(tableMapptingTo)) {
            return null;
        }
        String select[] = selectSource.split(",");
        String vars = tableMapptingTo.substring(0, tableMapptingTo.indexOf('=')).trim();
        String var = vars.replace("[]", "");
        StringBuffer sb = new StringBuffer();
        sb.append(var).append("=").append("$select(").append(vars);
        for (int i = 0; i < select.length; i++) {
            String string = select[i];
            int index = string.lastIndexOf('.');
            sb.append(",'").append(string.substring(index + 1)).append(":").append(valueMap.get(string)).append("'");
        }
        sb.append(")");
        return sb.toString();
    }
    
    /**
     * 获得可执行的dataItem表达式
     * 
     * @param expExecuter 表达式执行器
     * 
     * @param defintion 章节定义
     * @param chapter 章节
     * @return 已替换变量的表达式
     */
    public static String getSelectExprWithType(IExpressionExecuter expExecuter, DCChapter defintion, Chapter chapter) {
        String selectSource = defintion.getTitle();
        if (StringUtils.isBlank(selectSource) || StringUtils.isBlank(defintion.getMappingTo())) {
            return null;
        }
        
        boolean selector = defintion.getTitleAsSelector();
        // 如果配置了章节标题不作为选择器，直接返回。
        if (!selector) {
            return null;
        }
        String className = defintion.getMappingToClassName();
        if (StringUtils.isBlank(className)) {
            return null;
        }
        String select = defintion.getTitle();
        String vars = getVarsName(defintion.getMappingTo());
        String var = getVarName(vars);
        StringBuffer sb = new StringBuffer();
        sb.append(var).append("=").append("$selectWithType(").append(vars).append(",");
        sb.append("'").append(className).append("'");
        int index = select.lastIndexOf('.');
        sb.append(",'").append(select.substring(index + 1)).append(":").append(chapter.getTitle()).append("'");
        
        // 过滤时能够得到在mappingTo中定义的参数变量
        Object value = null;
        Map<String, String> queryParamExprs = defintion.getSelfQueryParamExprs();
        for (Entry<String, String> entry : queryParamExprs.entrySet()) {
            String string = entry.getKey();
            int index2 = string.lastIndexOf('.');
            value = getValue(expExecuter, entry.getValue());
            sb.append(",'").append(string.substring(index2 + 1)).append(":").append(value).append("'");
        }
        
        sb.append(")");
        return sb.toString();
    }
    
    /**
     * 获得可执行的dataItem表达式
     * 
     * @param expExecuter 表达式执行器
     * 
     * @param tableDefinition 表格定义
     * @param selectSource 原始的表达式
     * @param valueMap 值集
     * @return 已替换变量的表达式
     */
    public static String getSelectExprWithType(IExpressionExecuter expExecuter, DCTable tableDefinition,
        String selectSource, Map<String, Object> valueMap) {
        
        // 搞定配置的表达式是函数的情况
        
        String tableMapptingTo = tableDefinition.getMappingTo();
        if (StringUtils.isBlank(selectSource) || StringUtils.isBlank(tableMapptingTo)) {
            return null;
        }
        Class<?> clazz = tableDefinition.getMappingToClass();
        String className = (clazz == null ? null : clazz.getName());
        if (StringUtils.isBlank(className)) {
            return null;
        }
        String select[] = selectSource.split(",");
        String vars = tableMapptingTo.substring(0, tableMapptingTo.indexOf('=')).trim();
        String var = vars.replace("[]", "");
        StringBuffer sb = new StringBuffer();
        sb.append(var).append("=").append("$selectWithType(").append(vars).append(",'").append(className).append("'");
        for (int i = 0; i < select.length; i++) {
            String string = select[i];
            int index = string.lastIndexOf('.');
            sb.append(",'").append(string.substring(index + 1)).append(":").append(valueMap.get(string)).append("'");
        }
        Object value = null;
        Map<String, String> queryParamExprs = tableDefinition.getQueryParamExprs();
        for (Entry<String, String> entry : queryParamExprs.entrySet()) {
            String string = entry.getKey();
            int index2 = string.lastIndexOf('.');
            value = getValue(expExecuter, entry.getValue());
            sb.append(",'").append(string.substring(index2 + 1)).append(":").append(value).append("'");
        }
        sb.append(")");
        return sb.toString();
    }
    
    /**
     * 获得表达式对应的模型对象类型
     *
     * @param definition 表格定义
     * @return 对象类型
     */
    public static Class<?> getExprClass(DCTable definition) {
        String mappingTo = definition.getMappingTo();
        Matcher matcher = ExprType.QUERY.getPattern().matcher(mappingTo);
        if (matcher.find()) {
            String className = matcher.group(2);
            return definition.getContainer().getDocConfig().getOptions().getConfiguration().getContext()
                .lookupValueObject(className);
        }
        
        DCContainer container = definition.getContainer();
        Class<?> parentClass = null;
        while (container != null) {
            parentClass = container.getMappingToClass();
            if (parentClass != null) {
                break;
            }
            container = container.getParent();
        }
        if (container == null) {
            return null;
        }
        matcher = ExprType.VAR_ATTRIBUTE.getPattern().matcher(mappingTo);
        if (matcher.find()) {
            String fieldName = matcher.group(3);
            Field field = ReflectionHelper.findField(parentClass, fieldName);
            if (field != null) {
                Class<?> type = field.getType();
                if (Collection.class.isAssignableFrom(type)) {
                    return CollectionTypeResolver.getCollectionFieldType(field);
                }
                return type;
            }
        }
        return null;
        
    }
    
    /**
     * 获得表达式对应的模型对象类型
     *
     * @param definition 章节定义
     * @return 对象类型
     */
    public static Class<?> getExprClass(DCChapter definition) {
        String mappingTo = definition.getMappingTo();
        // if (StringUtils.isBlank(mappingTo)) {
        // return null;
        // }
        Matcher matcher = ExprType.QUERY.getPattern().matcher(mappingTo);
        if (matcher.find()) {
            String className = matcher.group(2);
            return definition.getDocConfig().getOptions().getConfiguration().getContext().lookupValueObject(className);
        }
        
        //解析以下场景中的界面元素的mappingTo
        //对应模板xml场景：
//        <WtChapter type="DYNAMIC" mappingTo="page[]=#Page(packageId=p1.id)" title="$StringUtils_join('【',page.code,'】',page.name)" enable="$equals(p1.type,2)">
//			<WtChapter title="参考界面" type="FIXED">
//				<WtGraphic mappingTo="page.crudeUIs" />
//			</WtChapter>
//			<WtChapter title="界面元素" type="FIXED">
//				<table name="界面元素" type="EXT_ROWS"
//					mappingTo="pageElement[]=page.elements">
//					<tr>
//						<td mappingTo="pageElement.sortIndex">元素序号</td>
//						<td mappingTo="pageElement.cnUiType">元素类型</td>
//						<td mappingTo="pageElement.cnName">元素名称</td>
//					</tr>
//				</table>
//			</WtChapter>
//		</WtChapter>
        DCChapter parentChapter = definition.getParentChapter();
        Class<?> parentClass = null;
        while (parentChapter != null) {
            parentClass = parentChapter.getMappingToClass();
            if (parentClass != null) {
                break;
            }
            parentChapter = parentChapter.getParentChapter();
        }
        if (parentChapter == null) {
            return null;
        }
        //匹配父章节中获取的变量名对应的属性
        matcher = ExprType.VAR_ATTRIBUTE.getPattern().matcher(mappingTo);
        if (matcher.find()) {
            String fieldName = matcher.group(3);
            Field field = ReflectionHelper.findField(parentClass, fieldName);
            if (field != null) {
                Class<?> type = field.getType();
                if (Collection.class.isAssignableFrom(type)) {
                    return CollectionTypeResolver.getCollectionFieldType(field);
                }
                return type;
            }
        }
        return null;
    }
    
    /**
     * 获得表达式中的原始变量名
     *
     * @param expr 表达式
     * @return 原始变量名，没有返回空。
     */
    public static String getVarsName(String expr) {
        if (StringUtils.isBlank(expr)) {
            return null;
        }
        int index = expr.indexOf('=');
        if (index < 0) {
            return null;
        }
        return expr.substring(0, index).trim();
    }
    
    /**
     * 获得查询参数.建立查询表达式中属性名和值表达式之间的关系，便于在页面展示数据和构建模板对象时使用
     * 
     * @param mappingTo mappingTo表达式
     * @return 获得查询参数
     *
     */
    public static Map<String, String> getQueryParams(String mappingTo) {
        Matcher matcher = ExprType.QUERY.getPattern().matcher(mappingTo);
        if (!matcher.find()) {
            return null;
        }
        String strQueryParamExprs = matcher.group(3);
        if (StringUtils.isBlank(strQueryParamExprs)) {
            return null;
        }
        Map<String, String> queryParams = new HashMap<String, String>();
        String[] curQueryParamExprs = strQueryParamExprs.split("[,]");
        for (int i = 0; i < curQueryParamExprs.length; i++) {
            int beginIndex = curQueryParamExprs[i].indexOf('=');
            String attributeExpr = curQueryParamExprs[i].substring(0, beginIndex).trim();
            String valueExpr = curQueryParamExprs[i].substring(beginIndex + 1).trim();
            queryParams.put(attributeExpr, valueExpr);
        }
        return queryParams;
    }
    
    /**
     * 获得表达式中关于单个对象的变量名
     *
     * @param expr 表达式
     * @return 单个对象的变量名
     */
    public static String getVarNameFromExpr(String expr) {
        String vars = getVarsName(expr);
        return StringUtils.isBlank(vars) ? null : vars.replace("[]", "");
    }
    
    /**
     * 获得表达式中关于单个对象的变量名
     * 
     * @param vars 获得变量表达式
     *
     * @return 单个对象的变量名
     */
    public static String getVarName(String vars) {
        return StringUtils.isBlank(vars) ? null : vars.replace("[]", "");
    }
    
    /**
     * 获得表达式中关于单个对象的变量名
     *
     * @param expr 表达式
     * @return 单个对象的变量名
     */
    public static String getVarNameFromAttribute(String expr) {
        if (StringUtils.isBlank(expr)) {
            return null;
        }
        int index = expr.indexOf(".");
        return index >= 0 ? expr.substring(0, index) : null;
    }
    
    /**
     * 获得表达式类型
     *
     * @param expr 表达式
     * @return 类型
     */
    public static ExprType getExprType(String expr) {
        if (StringUtils.isBlank(expr)) {
            return ExprType.NULL;
        }
        List<ExprType> exprTypes = ExprType.getSortedExprTypes();
        for (ExprType exprType : exprTypes) {
            if (exprType.getPattern().matcher(expr).find()) {
                return exprType;
            }
        }
        return ExprType.UNKNOWN;
    }
    
    /**
     * 获得表达式类型
     *
     * @param expr 表达式
     * @return 类型
     */
    public static Matcher getExprMatcher(String expr) {
        if (StringUtils.isBlank(expr)) {
            return null;
        }
        List<ExprType> exprTypes = ExprType.getSortedExprTypes();
        for (ExprType exprType : exprTypes) {
            Matcher matcher = exprType.getPattern().matcher(expr);
            if (matcher.find()) {
                return matcher;
            }
        }
        return ExprType.UNKNOWN.getPattern().matcher(expr);
    }
    
    /**
     * 获得传递给表达式参数的值
     *
     * @param sourceValue 源值
     * @return 处理后的值
     */
    private static Object getExprValue(Object sourceValue) {
        return sourceValue == null ? TypedValue.NULL : sourceValue;
    }
    
    /**
     * 事件通知
     * 
     * @param expExecuter 执行器
     *
     * @param event 事件
     * @see com.comtop.cap.document.word.expression.IExpressionExecuter#notify(com.comtop.cap.document.word.expression.ExprEvent)
     */
    public static void notify(IExpressionExecuter expExecuter, final ExprEvent event) {
        try {
            expExecuter.notify(event);
        } catch (Exception e) {
            String message = MessageFormat.format("表达式通知执行错误。当前事件{0}", event);
            LOGGER.error(message, e);
            throw new WordParseException(message, e);
        }
    }
    
    /**
     * 表达式执行器
     ** 
     * @param expExecuter 执行器
     * @param expression 表达式
     * @param value 数据
     * @return 执行的结果
     * @see com.comtop.cap.document.word.expression.IExpressionExecuter#execute(java.lang.String, java.lang.Object)
     */
    public static Object execute(IExpressionExecuter expExecuter, final String expression, final Object value) {
        try {
            return expExecuter.execute(expression, value);
        } catch (Exception e) {
            String message = MessageFormat.format("表达式执行错误。当前表达式{0}：当前值{1}", expression, value);
            LOGGER.error(message, e);
            throw new WordParseException(message, e);
        }
    }
    
    /**
     * 表达式执行器
     ** 
     * @param expExecuter 执行器
     * @param expression 表达式
     * @return 执行的结果
     * @see com.comtop.cap.document.word.expression.IExpressionExecuter#execute(java.lang.String, java.lang.Object)
     */
    public static Object getValue(IExpressionExecuter expExecuter, final String expression) {
        try {
            return expExecuter.execute(expression, null);
        } catch (Exception e) {
            String message = MessageFormat.format("表达式执行错误。当前表达式{0}", expression);
            LOGGER.error(message, e);
            throw new WordParseException(message, e);
        }
    }
    
}
