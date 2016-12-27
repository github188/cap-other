/******************************************************************************
 * Copyright (C) 2016 ShenZhen ComTop Information Technology Co.,Ltd
 * All Rights Reserved.
 * 本软件为深圳康拓普开发研制。未经本公司正式书面同意，其他任何个人、团体不得使用、
 * 复制、修改或发布本软件.
 *****************************************************************************/
package com.comtop.cap.bm.metadata.preferencesconfig;

import java.util.Map;

/**
 * 首选项配置接口
 * 
 * @author 许畅
 * @since JDK1.6
 * @version 2016年5月27日 许畅 新建
 */
public interface PreferenceConfig {

	/**
	 * 加载首选项配置xml中配置数据
	 * 
	 * @return data
	 */
	public Map<String, String> loadPreferenceConfig();

	/**
	 * 保存首选项配置信息到xml中
	 * 
	 * @param configs
	 *            首选项配置集合
	 * @return 返回信息
	 */
	public String savePreferenceConfig(Map<String, String> configs);

	/**
	 * 删除首选项配置信息
	 * 
	 * @param configs
	 *            首选项配置集合
	 * @return 是否成功
	 */
	public boolean deletePreferenceConfig(Map<String, String> configs);

	/**
	 * 加载首选项默认xml配置数据
	 * 
	 * @return 加载首选项默认xml配置数据
	 */
	public Map<String, String> loadDefaultPreferenceConfig();
}
