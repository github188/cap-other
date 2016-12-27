/******************************************************************************
 * Copyright (C) 2016 ShenZhen ComTop Information Technology Co.,Ltd
 * All Rights Reserved.
 * 本软件为深圳康拓普开发研制。未经本公司正式书面同意，其他任何个人、团体不得使用、
 * 复制、修改或发布本软件.
 *****************************************************************************/
package com.comtop.cap.bm.metadata.workbenchconfig.model;

import javax.persistence.Column;
import javax.persistence.Id;
import javax.persistence.Table;

import com.comtop.cap.runtime.base.model.CapBaseVO;
import comtop.org.directwebremoting.annotations.DataTransferObject;

/**
 * 工作台配置VO
 * 
 * @author 许畅
 * @since JDK1.6
 * @version 2016年2月24日 许畅 新建
 */
@DataTransferObject
@Table(name = "workbench_process_config")
public class WorkbenchConfigVO extends CapBaseVO {

	/**
	 * 默认序列
	 */
	private static final long serialVersionUID = 1L;

	/**
	 * processId 流程ID
	 */
	@Id
	@Column(name = "process_id")
	private String processId;

	/**
	 * processName 流程名称
	 */
	@Column(name = "process_name")
	private String processName;

	/**
	 * todo_url 已办url
	 */
	@Column(name = "todo_url")
	private String todo_url;

	/**
	 * 待办URL
	 */
	@Column(name = "done_url")
	private String done_url;

	/**
	 * pathType 是否待办 pathType =1 已办 , pathType =2 待办
	 */
	private int pathType;

	/**
	 * 页面URL
	 */
	private String pageURL;

	/**
	 * @return the processId
	 */
	public String getProcessId() {
		return processId;
	}

	/**
	 * @param processId
	 *            the processId to set
	 */
	public void setProcessId(String processId) {
		this.processId = processId;
	}

	/**
	 * @return the processName
	 */
	public String getProcessName() {
		return processName;
	}

	/**
	 * @param processName
	 *            the processName to set
	 */
	public void setProcessName(String processName) {
		this.processName = processName;
	}

	/**
	 * @return the pathType
	 */
	public int getPathType() {
		return pathType;
	}

	/**
	 * @param pathType
	 *            the pathType to set
	 */
	public void setPathType(int pathType) {
		this.pathType = pathType;
	}

	/**
	 * @return the pageURL
	 */
	public String getPageURL() {
		return pageURL;
	}

	/**
	 * @param pageURL
	 *            the pageURL to set
	 */
	public void setPageURL(String pageURL) {
		this.pageURL = pageURL;
	}

	/**
	 * @return the todo_url
	 */
	public String getTodo_url() {
		return todo_url;
	}

	/**
	 * @param todo_url
	 *            the todo_url to set
	 */
	public void setTodo_url(String todo_url) {
		this.todo_url = todo_url;
	}

	/**
	 * @return the done_url
	 */
	public String getDone_url() {
		return done_url;
	}

	/**
	 * @param done_url
	 *            the done_url to set
	 */
	public void setDone_url(String done_url) {
		this.done_url = done_url;
	}

	/**
	 * @param processId
	 *            processId
	 */
	public void setPrimaryValue(String processId) {
		this.processId = processId;
	}

}
