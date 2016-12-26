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
public class ThreadA extends Thread {

	/**
	 * 
	 */
	private int count;

	/**
	 * @param count
	 *            xx
	 */
	public ThreadA(int count) {
		setCount(count);
	}

	/**
	 *
	 *
	 * @see java.lang.Thread#run()
	 */
	@Override
	public void run() {
		for (int i = 0; i < 2; i++) {
			try {
				ThreadA.sleep(3000);
			} catch (InterruptedException e) {
				e.printStackTrace();
			}
			System.out.println("run:" + i + " ;线程名称:" + count);
		}
	}

	/**
	 * @return the count
	 */
	public int getCount() {
		return count;
	}

	/**
	 * @param count
	 *            the count to set
	 */
	public void setCount(int count) {
		this.count = count;
	}

}
