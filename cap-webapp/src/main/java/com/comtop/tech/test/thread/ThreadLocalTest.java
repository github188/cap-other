/******************************************************************************
 * Copyright (C) 2016 ShenZhen ComTop Information Technology Co.,Ltd
 * All Rights Reserved.
 * 本软件为深圳康拓普开发研制。未经本公司正式书面同意，其他任何个人、团体不得使用、
 * 复制、修改或发布本软件.
 *****************************************************************************/
package com.comtop.tech.test.thread;

/**
 * 
 * @author 许畅
 * @since JDK1.7
 * @version 2016年12月15日 许畅 新建
 */
public class ThreadLocalTest {

	/** 线程量 */
	private static final ThreadLocal<String> threadLocal = new ThreadLocal<String>();

	/**
	 * @param args
	 *            xx
	 */
	public static void main(String[] args) {
		//
		String str = "aaa";
		String str2 = "bbb";
		threadLocal.set(str);
		System.out.println(threadLocal.get());
		threadLocal.set(str2);
		System.out.println(threadLocal.get());

		for (int i = 0; i < 5; i++) {
			ThreadA a = new ThreadA(i);
			a.start();
		}

	}

}
