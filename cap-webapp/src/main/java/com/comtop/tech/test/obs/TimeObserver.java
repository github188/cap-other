/******************************************************************************
 * Copyright (C) 2016 ShenZhen ComTop Information Technology Co.,Ltd
 * All Rights Reserved.
 * 本软件为深圳康拓普开发研制。未经本公司正式书面同意，其他任何个人、团体不得使用、
 * 复制、修改或发布本软件.
 *****************************************************************************/
package com.comtop.tech.test.obs;

import java.util.Observable;
import java.util.Observer;

import com.comtop.cip.jodd.util.StringUtil;

/**
 * 
 * @author 许畅
 * @since JDK1.7
 * @version 2016年12月15日 许畅 新建
 */
public class TimeObserver implements Observer {

	/** TimeObservable */
	private TimeObservable timeObservable;

	/** key */
	private String key;

	/**
	 * 构造方法
	 */
	public TimeObserver() {
	}

	/**
	 * 
	 */
	public void lilei() {
		TimeObservable a = new TimeObservable(this, 0);
		System.out.println(a);
		if (StringUtil.isEmpty(key)) {
			System.out.println("lilei:你的等级不够不能乘坐当前游艇");
		} else {
			System.out.println("lilei:欢迎乘坐当前豪华游艇");
		}
	}

	/**
	 * 
	 */
	public void hanmeimei() {
		TimeObservable a = new TimeObservable(this, 1);
		System.out.println(a);
		if (StringUtil.isEmpty(key)) {
			System.out.println("hanmeimei:你的等级不够不能乘坐当前游艇");
		} else {
			System.out.println("hanmeimei:欢迎乘坐当前豪华游艇");
		}
	}

	/**
	 * @param args
	 *            参数
	 */
	public static void main(String[] args) {
		TimeObserver ob = new TimeObserver();
		ob.lilei();
		TimeObserver ob2 = new TimeObserver();
		ob2.hanmeimei();
	}

	/**
	 *
	 * @param o
	 *            xx
	 * @param arg
	 *            xx
	 *
	 * @see java.util.Observer#update(java.util.Observable, java.lang.Object)
	 */
	@Override
	public void update(Observable o, Object arg) {
		TimeObservable ob = (TimeObservable) o;
		setKey(ob.getTicket());
	}

	/**
	 * @return the timeObservable
	 */
	public TimeObservable getTimeObservable() {
		return timeObservable;
	}

	/**
	 * @param timeObservable
	 *            the timeObservable to set
	 */
	public void setTimeObservable(TimeObservable timeObservable) {
		this.timeObservable = timeObservable;
	}

	/**
	 * @return the key
	 */
	public String getKey() {
		return key;
	}

	/**
	 * @param key
	 *            the key to set
	 */
	public void setKey(String key) {
		this.key = key;
	}

}
