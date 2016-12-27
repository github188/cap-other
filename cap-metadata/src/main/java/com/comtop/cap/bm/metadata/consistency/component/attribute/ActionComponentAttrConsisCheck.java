/******************************************************************************
 * Copyright (C) 2016 ShenZhen ComTop Information Technology Co.,Ltd
 * All Rights Reserved.
 * 本软件为深圳康拓普开发研制。未经本公司正式书面同意，其他任何个人、团体不得使用、
 * 复制、修改或发布本软件.
 *****************************************************************************/

package com.comtop.cap.bm.metadata.consistency.component.attribute;

import java.util.ArrayList;
import java.util.List;
import java.util.Map;
import java.util.regex.Matcher;
import java.util.regex.Pattern;

import org.apache.commons.lang.StringUtils;

import com.comtop.cap.bm.metadata.base.consistency.ConsistencyCheckUtil;
import com.comtop.cap.bm.metadata.base.consistency.ConsistencyException;
import com.comtop.cap.bm.metadata.base.consistency.model.ConsistencyCheckResult;
import com.comtop.cap.bm.metadata.base.consistency.model.FieldConsistencyConfigVO;
import com.comtop.cap.bm.metadata.base.model.BaseMetadata;
import com.comtop.cap.bm.metadata.consistency.ConsistencyCheckResultType;
import com.comtop.cap.bm.metadata.consistency.IComponentConsisCheck;
import com.comtop.cap.bm.metadata.page.desinger.model.LayoutVO;
import com.comtop.cap.bm.metadata.page.desinger.model.PageVO;
import com.comtop.cap.bm.metadata.page.preference.facade.BuiltInActionPreferenceFacade;
import com.comtop.cap.bm.metadata.page.uilibrary.model.ComponentVO;
import com.comtop.cap.bm.metadata.page.uilibrary.model.EventVO;
import com.comtop.cip.json.JSONArray;
import com.comtop.cip.json.JSONObject;
import com.comtop.top.core.jodd.AppContext;
import com.comtop.top.core.util.StringUtil;

/**
 * 控件涉及到需要行为的属性一致性校验
 * 
 * @author 诸焕辉
 * @since jdk1.6
 * @version 2016年6月28日 诸焕辉
 */
public class ActionComponentAttrConsisCheck extends DefaultComponentAttrConsisCheck {
	
    /**
     * 内置行为函数facade类
     */
    private final BuiltInActionPreferenceFacade builtInActionPreferenceFacade = AppContext
        .getBean(BuiltInActionPreferenceFacade.class);
    
    /**
     * 默认的控件校验类处理类名称
     */
    private static String DEFAULT_COMPONENT_CONSISCHECK_CLASS = "com.comtop.cap.bm.metadata.consistency.component.DefaultComponentConsisCheck";
    
    /**
     * 事件校验表达式
     */
    private static final String eventCheckExpression = "./pageActionVOList[ename=\"{0}\"]";
    
    @Override
    public ConsistencyCheckResult checkAttrValueConsis(ComponentVO com, BaseMetadata baseMetadataVO, LayoutVO data,
        PageVO root) {
        EventVO objEventVO = (EventVO) baseMetadataVO;
        String strFuncName = (String) data.getOptions().get(objEventVO.getEname());
        return this.checkAttrValueHandler(com, objEventVO.getEname(), strFuncName, data, root);
    }
    
    /**
     * 校验属性值的处理器
     * 
     * @param com 组件VO
     * @param attrName 属性名称
     * @param funcName 行为名称
     * @param data 布局名称
     * @param root 页面VO
     * @return ConsistencyCheckResult
     */
    private ConsistencyCheckResult checkAttrValueHandler(ComponentVO com, String attrName, String funcName,
        LayoutVO data, PageVO root) {
        ConsistencyCheckResult objRes = null;
        // 页面自定义行为
        boolean bExist = ConsistencyCheckUtil.executeExpression(root, eventCheckExpression, null, funcName);
        if (!bExist) {
            // 内置行为
            bExist = builtInActionPreferenceFacade.existBuiltInActionMethodName(funcName);
            if (!bExist) {
                objRes = new ConsistencyCheckResult();
                objRes.setMessage(this.createMessage(com, attrName, funcName, data));
                objRes.setAttrMap(this.createLayoutAttrMap(root, data, attrName));
                objRes.setType(ConsistencyCheckResultType.CONSISTENCY_TYPE_PAGE_LAYOUT.getValue());
            }
        }
        return objRes;
    }
    
    /**
     * 检验grid或editableGrid的列渲染函数数据一致性
     *
     * @param com 控件信息
     * @param columns 控件属性名称
     * @param data 控件对应的布局对象
     * @param root page对象
     * @return 校验结果
     */
    @SuppressWarnings("unchecked")
    public ConsistencyCheckResult checkColumnsRenderConsis(ComponentVO com, JSONArray columns, LayoutVO data,
        PageVO root) {
        StringBuffer strMsg = new StringBuffer();
        Map<String, Object> objOptions = data.getOptions();
        String strCmpName = (String) (objOptions.get("label") != null ? objOptions.get("label") : objOptions
            .get("name") != null ? objOptions.get("name") : objOptions.get("id") != null ? objOptions.get("id") != null
            : data.getId());
        for (int i = 0, len = columns.size(); i < len; i++) {
            JSONObject objCol = (JSONObject) columns.get(i);
            String strEvent = getColumnEvent(objCol);
            if (StringUtil.isNotBlank(strEvent)) {
                if (!(ConsistencyCheckUtil.executeExpression(root, eventCheckExpression, null, strEvent) || builtInActionPreferenceFacade.existBuiltInActionMethodName(strEvent))) {
                    strMsg.append(strMsg.length() > 0 ? "<br/>" : "").append("页面控件").append("（")
                        .append(com.getModelName()).append("->").append(strCmpName).append("）第【").append(i + 1)
                        .append("】列的表头：render绑定的渲染函数【").append(strEvent).append("】不存在");
                }
            }
        }
        ConsistencyCheckResult objConsisCheckResult = null;
        if (strMsg.length() > 0) {
            objConsisCheckResult = new ConsistencyCheckResult();
            objConsisCheckResult.setMessage(strMsg.toString());
            objConsisCheckResult.setAttrMap(this.createLayoutAttrMap(root, data, "columns"));
            objConsisCheckResult.setType(ConsistencyCheckResultType.CONSISTENCY_TYPE_PAGE_LAYOUT.getValue());
        }
        return objConsisCheckResult;
    }
    
    /**
     * 获取grid或者edit grid行属性里的事件信息
     * @param objCol grid或者edit grid行属性对象
     * @return 事件名
     */
    private String getColumnEvent(JSONObject objCol) {
    	String strRender = (String) objCol.get("render");
    	if("a".equals(strRender) || "button".equals(strRender) || "image".equals(strRender)) {		// 链接渲染、按钮渲染、图片渲染
    		String strOptions = objCol.getString("options");
    		return findValue("click", strOptions);
    	}
   		return strRender;
    }
    
    /**
     * 给定的字符串里找到对应属性的值 <br>
     * <pre>
     * 	findValue("name",{"name":"建设单位名称","bindName":"constructionUnitName","render":"a"}) // return 建设单位名称
     * 	findValue("render",{"name":"建设单位名称","bindName":'constructionUnitName','render':'a'}) // return a
     * </pre>
     * @param property 属性 
     * @param input 字符串
     * @return 字符串里满足"property":"value"格式的value值
     */
    private String findValue(String property, String input) {
    	if(StringUtils.isBlank(property) || StringUtils.isBlank(input)) {
			return null;
		}
    	String regex = "[\"|']" + property + "[\"|']:[\"|'](.*?)[\"|']";
    	Pattern pattern = Pattern.compile(regex);        
        Matcher matcher = pattern.matcher(input);
        while (matcher.find()) {
            return matcher.group(1);
        }
        return null;
    }
    
    /**
     * 检验grid或editableGrid的列渲染函数数据一致性
     *
     * @param com 控件信息
     * @param options 控件定义类型
     * @param data 控件对应的布局对象
     * @param root page对象
     * @return 校验结果
     */
    public ConsistencyCheckResult checkEditTypeConsis(ComponentVO com, JSONObject options, LayoutVO data, PageVO root) {
        StringBuffer strMsg = new StringBuffer();
        List<EventVO> lstEvent = com.getEvents();
        if (lstEvent == null) {
            return null;
        }
        FieldConsistencyConfigVO objConsistencyConfig = com.getConsistencyConfig();
        if (objConsistencyConfig == null) {
            return null;
        }
        List<ConsistencyCheckResult> lstRes = new ArrayList<ConsistencyCheckResult>();
        if (objConsistencyConfig.getCheckConsistency().booleanValue()) {
            String strCheckClass = StringUtil.isBlank(objConsistencyConfig.getCheckClass()) ? objConsistencyConfig
                .getCheckClass() : DEFAULT_COMPONENT_CONSISCHECK_CLASS;
            IComponentConsisCheck objCheckClazz = ConsistencyCheckUtil.getConsistencyCheck(strCheckClass,
                IComponentConsisCheck.class);
            if (objCheckClazz == null) {
                throw new ConsistencyException("控件：" + com.getModelId() + "定义的一致性校验类：" + strCheckClass + "不存在。");
            }
            for (EventVO objEvent : lstEvent) {
                String strAttrName = objEvent.getEname();
                String strFunction = options.getString(strAttrName);
                if (StringUtils.isNotBlank(strFunction)) {
                    ConsistencyCheckResult objCheck = this.checkAttrValueHandler(com, objEvent.getEname(), strFunction,
                        data, root);
                    if (objCheck != null) {
                        lstRes.add(objCheck);
                    }
                }
            }
        }
        for (ConsistencyCheckResult objResult : lstRes) {
            strMsg.append(strMsg.length() > 0 ? "<br/>" : "").append(objResult.getMessage());
        }
        ConsistencyCheckResult objRes = null;
        if (strMsg.length() > 0) {
            objRes = new ConsistencyCheckResult();
            objRes.setMessage(strMsg.toString());
        }
        return objRes;
    }
    
    /**
     * 包装提示信息
     * 
     * @param com 控件定义
     * @param field 属性
     * @param value 属性值
     * @param data layout对象
     * @return 返回消息
     */
    @Override
    @SuppressWarnings("unchecked")
    protected String createMessage(ComponentVO com, String field, Object value, LayoutVO data) {
        StringBuffer sbMsg = new StringBuffer();
        Map<String, Object> objOptions = data.getOptions();
        sbMsg.append("页面控件（");
        sbMsg.append(com.getModelName());
        sbMsg.append("->");
        if (objOptions.get("label") != null) {
            sbMsg.append(objOptions.get("label"));
        } else if (objOptions.get("name") != null) {
            sbMsg.append(objOptions.get("name"));
        } else if (objOptions.get("id") != null) {
            sbMsg.append(objOptions.get("id"));
        } else {
            sbMsg.append(data.getId());
        }
        sbMsg.append("）的属性");
        sbMsg.append(field);
        sbMsg.append("关联的行为");
        sbMsg.append(value);
        sbMsg.append("不存在");
        return sbMsg.toString();
    }
}
