/******************************************************************************
 * Copyright (C) 2016 ShenZhen ComTop Information Technology Co.,Ltd
 * All Rights Reserved.
 * 本软件为深圳康拓普开发研制。未经本公司正式书面同意，其他任何个人、团体不得使用、
 * 复制、修改或发布本软件.
 *****************************************************************************/
package com.comtop.tech.test.obs;

import java.util.Observable;

/**
 * 
 * 
 * @author 许畅
 * @since JDK1.7
 * @version 2016年12月15日 许畅 新建
 */
public class TimeObservable extends Observable {

	/** TimeObserver */
	private TimeObserver observer;

	/** TimeObserver */
	private String ticket;

	/**
	 * @param observer
	 *            TimeObserver
	 * @param level
	 *            xx
	 */
	public TimeObservable(TimeObserver observer, int level) {
		if (observer != null) {
			addObserver(observer);
		}

		if (level > 0) {
			setTicket("you are the best");
			setChanged();
			notifyObservers("高级客户");
		}
	}

	/**
	 * @return the observer
	 */
	public TimeObserver getObserver() {
		return observer;
	}

	/**
	 * @param observer
	 *            the observer to set
	 */
	public void setObserver(TimeObserver observer) {
		this.observer = observer;
	}

	/**
	 * @return the ticket
	 */
	public String getTicket() {
		return ticket;
	}

	/**
	 * @param ticket
	 *            the ticket to set
	 */
	public void setTicket(String ticket) {
		this.ticket = ticket;
	}

}
