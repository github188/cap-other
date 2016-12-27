/******************************************************************************
 * Copyright (C) 2015 ShenZhen ComTop Information Technology Co.,Ltd
 * All Rights Reserved.
 * 本软件为深圳康拓普开发研制。未经本公司正式书面同意，其他任何个人、团体不得使用、
 * 复制、修改或发布本软件.
 *****************************************************************************/

package com.comtop.cap.bm.metadata.common.model;

import java.util.ArrayList;
import java.util.HashMap;
import java.util.Iterator;
import java.util.List;
import java.util.Map;

import com.comtop.cap.bm.metadata.base.model.BaseModel;

import comtop.org.directwebremoting.annotations.DataTransferObject;

/**
 * 树模型
 * 
 * @author 诸焕辉
 * @version jdk1.6
 * @version 2015-6-03 诸焕辉
 */
@DataTransferObject
public class MetadataCuiTreeVO extends BaseModel {

	/** 标识 */
	private static final long serialVersionUID = 6969959504922530866L;

	/**
	 * 树数据源
	 */
	private List<CuiTreeNodeVO> datasource = new ArrayList<CuiTreeNodeVO>();

	/**
	 * @return 获取 datasource属性值
	 */
	public List<CuiTreeNodeVO> getDatasource() {
		return datasource;
	}

	/**
	 * @param datasource
	 *            设置 datasource 属性值为参数值 datasource
	 */
	public void setDatasource(List<CuiTreeNodeVO> datasource) {
		this.datasource = datasource;
	}

	/**
	 * 将tree转换为Map,Map的key为 CuiTreeNodeVO.id, value为CuiTreeNodeVO
	 * 
	 * @return Map<id, CuiTreeNodeVO>
	 */
	public Map<String, CuiTreeNodeVO> treeToMap() {
		Map<String, CuiTreeNodeVO> treeNodeMap = new HashMap<String, CuiTreeNodeVO>();
		traverseTreeNode(datasource, treeNodeMap);
		return treeNodeMap;
	}

	/**
	 * 遍历tree，将节点放入对应的map中
	 * 
	 * @param nodeList
	 *            tree节点
	 * @param nodeMap
	 *            tree map
	 */
	private void traverseTreeNode(List<CuiTreeNodeVO> nodeList, Map<String, CuiTreeNodeVO> nodeMap) {
		if (nodeList == null || nodeList.isEmpty()) {
			return;
		}

		for (CuiTreeNodeVO node : nodeList) {
			nodeMap.put(node.getId(), node);
			traverseTreeNode(node.getChildren(), nodeMap);
		}
	}

	/**
     * 遍历树集合，剔除mapKey集合中不存在的key的节点
     * @param mapKey 过滤后需要显示的key集合(map<key,key>),使用Map而不是Set原因：判断节点时性能更好
	 * @return 过滤后的根节点集合
     */
	public List<CuiTreeNodeVO> filterNodeByKey(final Map<String, String> mapKey) {
		filterNodeByKey(this.datasource, true, new IFilter() {
			@Override
			public boolean filter(CuiTreeNodeVO objNodeVO) {
				if(objNodeVO.getIsFolder()) {
					return false;
				}
				return !mapKey.containsKey(objNodeVO.getKey());
			}
			
		});
		return this.getDatasource();
	}
	
	/**
     * 遍历树集合，根据过滤器过滤节点。
     * @param lstCuiTreeNodeVO 树集合
	 * @param iFilter 过滤处理器
	 * @param emptyClear 过滤完后是否需要去掉空目录，true 是， false 否 
     */
	public static void filterNodeByKey(List<CuiTreeNodeVO> lstCuiTreeNodeVO, boolean emptyClear, IFilter iFilter) {
		if(lstCuiTreeNodeVO == null || lstCuiTreeNodeVO.isEmpty()) {
			return;
		}
		
		Iterator<CuiTreeNodeVO> iterator = lstCuiTreeNodeVO.iterator();
		while (iterator.hasNext()) {
			CuiTreeNodeVO objNodeVO = iterator.next();
			boolean isMove = false;
			// 包含就不处理
			if(iFilter.filter(objNodeVO)) {
				isMove = true;
				iterator.remove();
			}
			// 递归处理子节点
			filterNodeByKey(objNodeVO.getChildren(), emptyClear, iFilter);
			
			if(!emptyClear) {
				continue;
			}
			
			if(objNodeVO.getIsFolder()) {
				// 处理完子节点后，若当前节点为目录且无子节点,则移除
				if(!isMove && objNodeVO.getChildren().isEmpty()) {
					iterator.remove();
				}
			}
			
		}
	}
	
	/**
	 * tree filter
	 */
	public interface IFilter {
		
		/**
		 * 当前节点是否过滤
		 * @param objNodeVO 节点
		 * @return true 过滤 false 不过滤
		 */
		boolean filter(CuiTreeNodeVO objNodeVO);
	}
}
