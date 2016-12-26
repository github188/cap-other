/******************************************************************************
* Copyright (C) 2014 ShenZhen ComTop Information Technology Co.,Ltd
* All Rights Reserved.
* 本软件为深圳康拓普开发研制。未经本公司正式书面同意，其他任何个人、团体不得使用、
* 复制、修改或发布本软件.
*****************************************************************************/

package com.comtop.cip.graph.image;

import org.junit.Before;
import org.junit.Test;

/**
 * @author 杨赛
 * @since jdk1.6
 * @version 2016年12月1日 杨赛
 */
public class GraphToImageToolTest {

	/**
	 * FIXME
	 */
	@Before
	public void setUp() {
		String logdir = "d:/Code/test";
		System.setProperty("logs.home", logdir);
	}
	//
	// @After
	// public void tearDown() throws Exception {
	// }

	/**
	 * Test method for Screenshot
	 */
	@Test
	public final void testScreenshot() {
		String pageUrl = "http://10.10.50.143:8080/web/prototype/DM-0000000032/E-IM01-001/E-IM01-001-001/YsMeetingEdit.html";
		String cookieString = "cookiesW3sibmFtZSI6IkpTRVNTSU9OSUQiLCJ2YWx1ZSI6IjUzMUVBRkZDQkE4RkUxNzE1QTlEMDQ2Mzc5OEE3MTc2IiwiY29tbWVudCI6bnVsbCwiZG9tYWluIjpudWxsLCJtYXhBZ2UiOi0xLCJwYXRoIjpudWxsLCJzZWN1cmUiOmZhbHNlLCJ2ZXJzaW9uIjowLCJodHRwT25seSI6ZmFsc2V9LHsibmFtZSI6IkRXUlNFU1NJT05JRCIsInZhbHVlIjoiQkszTUpKd2ZuSTA5d0tMWXlxU3E1aFBlR3lsIiwiY29tbWVudCI6bnVsbCwiZG9tYWluIjpudWxsLCJtYXhBZ2UiOi0xLCJwYXRoIjpudWxsLCJzZWN1cmUiOmZhbHNlLCJ2ZXJzaW9uIjowLCJodHRwT25seSI6ZmFsc2V9LHsibmFtZSI6IkdFTl9DT0RFX1BBVEhfQ05BTUUiLCJ2YWx1ZSI6IkQlM0ElMkZDQVAlMkZCTSUyRmNvZGUlMkZDQVAlMkZjYXAtd2ViYXBwIiwiY29tbWVudCI6bnVsbCwiZG9tYWluIjpudWxsLCJtYXhBZ2UiOi0xLCJwYXRoIjpudWxsLCJzZWN1cmUiOmZhbHNlLCJ2ZXJzaW9uIjowLCJodHRwT25seSI6ZmFsc2V9LHsibmFtZSI6ImNzX2NTdG9yYWdlXyIsInZhbHVlIjoiMSIsImNvbW1lbnQiOm51bGwsImRvbWFpbiI6bnVsbCwibWF4QWdlIjotMSwicGF0aCI6bnVsbCwic2VjdXJlIjpmYWxzZSwidmVyc2lvbiI6MCwiaHR0cE9ubHkiOmZhbHNlfSx7Im5hbWUiOiJDb210b3BTZXNzaW9uU0lEIiwidmFsdWUiOiI8U05BSUQ+NTMxRUFGRkNCQThGRTE3MTVBOUQwNDYzNzk4QTcxNzY8L1NOQUlEPiIsImNvbW1lbnQiOm51bGwsImRvbWFpbiI6bnVsbCwibWF4QWdlIjotMSwicGF0aCI6bnVsbCwic2VjdXJlIjpmYWxzZSwidmVyc2lvbiI6MCwiaHR0cE9ubHkiOmZhbHNlfV0=";
		String browserWidth = "1920";
		String browserHeight = "1080";
		String imagePath = "d:/Code/test/YsMeetingEdit.png";
		String selector = "#pageRoot";
		GraphToImageTool.screenshot(pageUrl, cookieString, browserWidth, browserHeight, imagePath, selector);
	}

	/**
	 * Test method for main
	 */
	@Test
	public final void testMain() {
		GraphToImageTool.main(new String[] {
				"http://www.jianshu.com",
				"d:/Code/test/jianshu#list-container.png", "selector=#list-container", "width=1920", "height=1080", "logdir=d:/Code/test",
				"codcookies" });
	}

	/**
	 * Test method for main
	 */
	@Test
	public final void testMainWithNoSelector() {
		GraphToImageTool.main(new String[] {
				"http://www.jianshu.com",
				"d:/Code/test/jianshu.png", "width=1920", "height=1080", "logdir=d:/Code/test",
				});
	}

}
