/******************************************************************************
 * Copyright (C) 2015 ShenZhen ComTop Information Technology Co.,Ltd
 * All Rights Reserved.
 * 本软件为深圳康拓普开发研制。未经本公司正式书面同意，其他任何个人、团体不得使用、
 * 复制、修改或发布本软件.
 *****************************************************************************/

package com.comtop.cip.graph.image.qt;

import java.util.ArrayList;
import java.util.Iterator;
import java.util.List;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;

import com.comtop.cip.graph.image.Base64Util;
import com.comtop.cip.graph.image.Cookie;
import com.fasterxml.jackson.core.type.TypeReference;
import com.fasterxml.jackson.databind.DeserializationFeature;
import com.fasterxml.jackson.databind.ObjectMapper;
import com.trolltech.qt.core.QByteArray;
import com.trolltech.qt.core.QUrl;
import com.trolltech.qt.gui.QCloseEvent;
import com.trolltech.qt.gui.QMainWindow;
import com.trolltech.qt.network.QNetworkCookie;
import com.trolltech.qt.network.QNetworkCookieJar;
import com.trolltech.qt.webkit.QWebView;

/**
 * 浏览页面窗口
 * 
 * @author duqi
 *
 */
public class Browser extends QMainWindow {

	/** 日志 */
	private static final Logger LOGGER = LoggerFactory.getLogger(Browser.class);

	/** 浏览页面类 */
	private QWebView view;

	/** 插件集合 */
	private List<BrowserPlugin> pluginList = new ArrayList<BrowserPlugin>();

	/**
	 * 构造函数
	 */
	public Browser() {
		this(3000, 3000);
	}

	/**
	 * 构造函数
	 * 
	 * @param width
	 *            宽
	 * @param height
	 *            高
	 */
	public Browser(int width, int height) {
		LOGGER.info("初始化浏览窗口。");
		view = new QWebView();
		this.reSizeBrowser(width, height);
		setCentralWidget(view);
		view.loadFinished.connect(this, "loadDone()");
	}

	/**
	 * addPlugin
	 * 
	 * @param plugin
	 *            BrowserPlugin
	 * @return true 成功 false 失败
	 */
	public boolean addPlugin(BrowserPlugin plugin) {
		return pluginList.add(plugin);
	}

	/**
	 * 重置浏览器窗口宽高
	 * 
	 * @param width
	 *            宽
	 * @param height
	 *            高
	 */
	public void reSizeBrowser(int width, int height) {
		this.resize(width, height);
		view.resize(width, height);
	}

	/**
	 * @return 获取 view属性值
	 */
	public QWebView getView() {
		return view;
	}

	/**
	 * 打开请求路径
	 * 
	 * @param url
	 *            请求地址
	 * @param cookieString
	 *            访问cookieString（将会使用Base64算法解密），访问页面需要登录时使用
	 */
	public void open(final String url, String cookieString) {
		List<Cookie> cookies = this.getCookies(cookieString);
		final QUrl qUrl = new QUrl(url);
		initCookies(cookies, qUrl);
		LOGGER.info("加载页面：{}", url);
		view.load(new QUrl(qUrl));
	}

	/**
	 * 获取cookie列表
	 * 
	 * @param cookieString
	 *            cookie加密字符串
	 * @return cookie列表
	 */
	private List<Cookie> getCookies(String cookieString) {
		if (cookieString == null || cookieString.length() == 0) {
			return null;
		}
		List<Cookie> cookies = null;

		ObjectMapper mapper = new ObjectMapper();
		mapper.configure(DeserializationFeature.FAIL_ON_UNKNOWN_PROPERTIES, false);
		String json = Base64Util.decode(cookieString);
		try {
			cookies = mapper.readValue(json, new TypeReference<List<Cookie>>() {
				// do nothing
			});

		} catch (Exception e) {
			LOGGER.error("反序列化异常", e);
			System.exit(2);
		}
		return cookies;
	}

	/**
	 * 初始化页面的cookie
	 * 
	 * @param cookies
	 *            cookie列表
	 * @param qUrl
	 *            页面URL
	 */
	public void initCookies(List<Cookie> cookies, QUrl qUrl) {
		if (cookies == null || cookies.size() <= 0) {
			return;
		}
		QNetworkCookieJar qNetworkCookieJar = new QNetworkCookieJar();
		view.page().networkAccessManager().setCookieJar(qNetworkCookieJar);
		List<QNetworkCookie> qNetworkCookieList = new ArrayList<QNetworkCookie>();
		for (Iterator<Cookie> iterator = cookies.iterator(); iterator.hasNext();) {
			Cookie cookie = iterator.next();
			QNetworkCookie qNetworkCookie = new QNetworkCookie();
			qNetworkCookie.setName(new QByteArray(cookie.getName()));
			qNetworkCookie.setValue(new QByteArray(cookie.getValue()));
			qNetworkCookieList.add(qNetworkCookie);
		}
		qNetworkCookieJar.setCookiesFromUrl(qNetworkCookieList, qUrl);
	}

	@Override
	protected void closeEvent(QCloseEvent event) {
		view.loadFinished.disconnect(this);
	}

	/**
	 * 当页面加载完成执行该函数，主要是获取需要渲染的元素 渲染到图片对象上 并保存
	 */
	public void loadDone() {
		LOGGER.info("页面加载完成。");

		try {
			for (BrowserPlugin plugin : pluginList) {
				plugin.done(this);
			}
		} catch (RuntimeException e) {
			LOGGER.error(e.getMessage(), e);
			this.close();
			LOGGER.info("浏览器关闭。");
			System.exit(2);
		} finally {
			this.close();
			LOGGER.info("浏览器关闭。");
		}
		System.exit(0);
	}

	// public static void main(String args[]) {
	// QApplication.initialize(args);
	//
	// Browser browser = new Browser();
	// browser.show();
	// QApplication.execStatic();
	// QApplication.shutdown();
	// }
}
