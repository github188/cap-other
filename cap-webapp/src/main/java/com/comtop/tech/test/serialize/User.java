/******************************************************************************
 * Copyright (C) 2016 ShenZhen ComTop Information Technology Co.,Ltd
 * All Rights Reserved.
 * 本软件为深圳康拓普开发研制。未经本公司正式书面同意，其他任何个人、团体不得使用、
 * 复制、修改或发布本软件.
 *****************************************************************************/
package com.comtop.tech.test.serialize;

import java.io.FileInputStream;
import java.io.FileOutputStream;
import java.io.IOException;
import java.io.ObjectInputStream;
import java.io.ObjectOutputStream;
import java.io.Serializable;

/**
 * 
 * @author 许畅
 * @since JDK1.7
 * @version 2016年12月19日 许畅 新建
 */
public class User implements Serializable {

	/**
	 * @param args
	 *            xx
	 */
	public static void main(String[] args) {
		//
		User u = new User("xcxc1990", "110@许畅");
		System.out.println("orign info:" + u);

		try {
			ObjectOutputStream o = new ObjectOutputStream(new FileOutputStream(
					"user.out"));

			o.writeObject(u);

			ObjectInputStream in = new ObjectInputStream(new FileInputStream(
					"user.out"));
			User userInfo = (User) in.readObject();
			System.out.println("user info:" + userInfo.toString());
		} catch (IOException e) {
			e.printStackTrace();
		} catch (ClassNotFoundException e) {
			e.printStackTrace();
		}
	}

	/**
	 *
	 * @return xx
	 *
	 * @see java.lang.Object#toString()
	 */
	@Override
	public String toString() {
		return "\n phone:" + this.phone + "\n password:" + this.password
				+ "\n username:" + this.username;
	}

	/**
	 * @param username
	 *            用户名
	 * @param password
	 *            密码
	 */
	public User(String username, String password) {
		setUsername(username);
		setPassword(password);
		setPhone(username);
	}

	/**  */
	private String username;

	/**  */
	private String password;

	/** 反序列化不读该字段 */
	private transient String phone;

	/**
	 * @return the username
	 */
	public String getUsername() {
		return username;
	}

	/**
	 * @param username
	 *            the username to set
	 */
	public void setUsername(String username) {
		this.username = username;
	}

	/**
	 * @return the password
	 */
	public String getPassword() {
		return password;
	}

	/**
	 * @param password
	 *            the password to set
	 */
	public void setPassword(String password) {
		this.password = password;
	}

	/**
	 * @return the phone
	 */
	public String getPhone() {
		return phone;
	}

	/**
	 * @param phone
	 *            the phone to set
	 */
	public void setPhone(String phone) {
		this.phone = phone;
	}

}
