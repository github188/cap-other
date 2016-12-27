/******************************************************************************
 * Copyright (C) 2015 ShenZhen ComTop Information Technology Co.,Ltd
 * All Rights Reserved.
 * 本软件为深圳康拓普开发研制。未经本公司正式书面同意，其他任何个人、团体不得使用、
 * 复制、修改或发布本软件.
 *****************************************************************************/

package com.comtop.cap.bm.metadata.converter.page;

import java.util.HashMap;
import java.util.Map;

import com.comtop.cap.bm.metadata.common.dwr.CapMap;
import com.comtop.cap.bm.metadata.common.storage.exception.OperateException;
import com.comtop.cap.bm.metadata.page.desinger.model.LayoutVO;
import com.comtop.cip.json.JSON;
import com.comtop.cip.json.JSONArray;
import com.comtop.cip.json.JSONObject;

/**
 * LayoutVO中option属性转换
 * @author yangsai
 *
 */
public class OptionConverter {
	/**
	 * 原型设计页面转换成页面元数据所有控件的需要跳过处理的公共属性
	 */
	private static final String SKIP_PROPERTY = "|datasource|databind|";
	
	/**
	 * 原型设计页面转换成页面元数据不同控件需要跳过处理的属性
	 */
	private static final Map<String,String> UI_CUSTOM_SKIP_PROPERTY = new HashMap<String, String>();
	
	static {
		// option转换时各组件需要跳过转换的属性值
		UI_CUSTOM_SKIP_PROPERTY.put("Input", "|value|");
		UI_CUSTOM_SKIP_PROPERTY.put("PullDown", "|value|");
		UI_CUSTOM_SKIP_PROPERTY.put("Calender", "|value|");
		UI_CUSTOM_SKIP_PROPERTY.put("Textarea", "|value|");
		UI_CUSTOM_SKIP_PROPERTY.put("CheckboxGroup", "|value|");
		UI_CUSTOM_SKIP_PROPERTY.put("ClickInput", "|value|");
		UI_CUSTOM_SKIP_PROPERTY.put("Input", "|value|");
		UI_CUSTOM_SKIP_PROPERTY.put("ChooseUser", "|idName|valueName|");
		UI_CUSTOM_SKIP_PROPERTY.put("ChooseOrg", "|idName|valueName|");
	}
	
	/**
	 * 页面layoutVO对象
	 */
	private LayoutVO pageLayoutVO;
	
	/**
	 * @param pageLayoutVO 页面layoutVO对象
	 */
	public OptionConverter(LayoutVO pageLayoutVO) {
		this.pageLayoutVO = pageLayoutVO;
	}

	/**
     * 将原型设计页面里的option转换为元数据的option
     * @param ptLayoutVO	原型layoutVO对象
     * @throws OperateException xml操作异常
     */
	public void convert(LayoutVO ptLayoutVO) throws OperateException {
		if(PageConstant.LAYOUT_TYPE_UI.equals(pageLayoutVO.getType())) {
			convertUIOption(ptLayoutVO);
		}else if(PageConstant.LAYOUT_TYPE_LAYOUT.equals(pageLayoutVO.getType())){
    		convertLayoutOption(ptLayoutVO);
    	} else {
    		pageLayoutVO.setOptions(pageLayoutVO.getOptions().clone());
    	}
    	
	}
	
	/**
	 * type为 layout类型的layout的option值转换
	 * @param ptLayoutVO	原型layoutVO对象
	 */
	private void convertLayoutOption(LayoutVO ptLayoutVO) {
		CapMap ptOptions = ptLayoutVO.getOptions();
    	for(Object key : ptOptions.keySet()) {
    		pageLayoutVO.getOptions().put(key, ptOptions.get(key));
    	}
	}
	
	/**
	 * type为 ui类型的layout的option值转换
	 * @param ptLayoutVO	原型layoutVO对象
	 */
	private void convertUIOption(LayoutVO ptLayoutVO) {
		// 去除需要跳过的属性
		removeSkipProperty(ptLayoutVO.getOptions());
		// 调整特定属性内容，比如grid控件去掉columns里的render属性值
		adjustSpecificProperty();
	}
	

	/**
	 * 调整特定属性内容，比如grid控件去掉columns里的render属性值等。
	 */
	private void adjustSpecificProperty() {
		if(PageConstant.UI_TYPE_GRID.equals(pageLayoutVO.getUiType())) {
			adjustGridProperty();
		}
	}

	/**
	 * 去除需要跳过的属性 
	 * @param ptOptions 待转换的原型设计页面对象中LayoutVO里的option对象
	 */
	private void removeSkipProperty(CapMap ptOptions) {
		for(Object key : ptOptions.keySet()) {
    		if(isSkip((String)key)) {
    			continue;
    		}
    		pageLayoutVO.getOptions().put(key, ptOptions.get(key));
    	}
	}

	/**
	 * 调整grid控件属性，主要调整内容如下：
	 * <ul>
	 * 	<li>清空columns、extras中tableHeader里的render属性值</li>
	 * 	<li>清空columns、extras中tableHeader里的bindName属性值</li>
	 * </ul>
	 */
	private void adjustGridProperty() {
		assert PageConstant.UI_TYPE_GRID.equals(pageLayoutVO.getUiType());
		
		// 元数据去掉渲染函数
		JSONArray columns = JSON.parseArray((String)pageLayoutVO.getOptions().get("columns"));
		for(Object column : columns) {
			JSONObject jsonObj = (JSONObject) column;
			jsonObj.remove(PageConstant.GRID_COLUMN_RENDER);	// 清空columns里render属性值
			jsonObj.remove(PageConstant.GRID_COLUMN_BINDNAME);	// 清空columns里bindName属性值
		}
		pageLayoutVO.getOptions().put("columns", columns.toJSONString());
		
		// 用于生成页面的grid控件使用的配置信息也需要去掉
		JSONObject extras = JSON.parseObject((String)pageLayoutVO.getOptions().get("extras"));
		JSONArray tableHeaders = JSON.parseArray(extras.getString("tableHeader"));
		for(Object tableHeader : tableHeaders) {
			JSONObject jsonObj = (JSONObject) tableHeader;
			jsonObj.remove(PageConstant.GRID_COLUMN_RENDER);
			jsonObj.remove(PageConstant.GRID_COLUMN_BINDNAME);
		}
		extras.put("tableHeader", tableHeaders.toJSONString());
		pageLayoutVO.getOptions().put("extras", extras.toJSONString());
	}

	/**
	 * 原型设计页面option的转换为页面设计的时候是否跳过不转换<br/>
	 * <p>以下情况的属性值将会跳过<p>
	 * <ul>
	 * 	<li>控件事件</li>
	 * 	<li>databind</li>
	 * 	<li>多余属性如：datasource、value</li>
	 * </ul>
	 * @param key key
	 * @return true 跳过 false 不跳过
	 */
	private boolean isSkip(String key) {
		assert key != null;
		if(key.startsWith("on_") || isSkipProperty(key)) {	//控件事件跳过
			return true;
		}
		return false;
	}
	
	/**
	 * 是否是跳过转换的key值 
	 * @param key key
	 * @return true 是  false 不是
	 */
	private boolean isSkipProperty(String key) {
		assert key != null;
		String wrapKey = "|" + key + "|";
		if(SKIP_PROPERTY.indexOf(wrapKey) != -1) {
			return true;
		}
		if(UI_CUSTOM_SKIP_PROPERTY.containsKey(pageLayoutVO.getUiType()) && UI_CUSTOM_SKIP_PROPERTY.get(pageLayoutVO.getUiType()).indexOf(wrapKey) != -1 ) {
			return true;
		}
		return false;
	}
}
