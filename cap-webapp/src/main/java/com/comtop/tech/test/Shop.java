/******************************************************************************
 * Copyright (C) 2016 ShenZhen ComTop Information Technology Co.,Ltd
 * All Rights Reserved.
 * 本软件为深圳康拓普开发研制。未经本公司正式书面同意，其他任何个人、团体不得使用、
 * 复制、修改或发布本软件.
 *****************************************************************************/
package com.comtop.tech.test;

import java.util.Set;

import javax.xml.bind.annotation.XmlAccessOrder;
import javax.xml.bind.annotation.XmlAccessType;
import javax.xml.bind.annotation.XmlAccessorOrder;
import javax.xml.bind.annotation.XmlAccessorType;
import javax.xml.bind.annotation.XmlAttribute;
import javax.xml.bind.annotation.XmlElement;
import javax.xml.bind.annotation.XmlElementWrapper;
import javax.xml.bind.annotation.XmlRootElement;
import javax.xml.bind.annotation.XmlType;

/**
 * 
 * 
 * @author 许畅
 * @since JDK1.7
 * @version 2016年11月23日 许畅 新建
 */
@XmlAccessorOrder(XmlAccessOrder.ALPHABETICAL)
@XmlAccessorType(XmlAccessType.FIELD)
@XmlType(name = "shop", propOrder = { "name", "number", "describer", "address",
		"orders" })
@XmlRootElement(name = "Market")
public class Shop {

	/**
	 * xx
	 */
	public Shop() {

	}

	/**
	 * @param name
	 *            xx
	 * @param number
	 *            xx
	 * @param describer
	 *            xx
	 * @param address
	 *            xx
	 */
	public Shop(String name, String number, String describer, Address address) {
		setName(name);
		setNumber(number);
		setDescriber(describer);
		setAddress(address);
	}

	/**  */
	@XmlAttribute
	private String name;

	/**  */
	@XmlElement
	private String number;

	/**  */
	@XmlElement
	private String describer;

	/**  */
	@XmlElementWrapper(name = "orders")
	@XmlElement(name = "order")
	private Set<Order> orders;

	/**  */
	@XmlElement
	private Address address;

	/**
	 * @return the name
	 */
	public String getName() {
		return name;
	}

	/**
	 * @param name
	 *            the name to set
	 */
	public void setName(String name) {
		this.name = name;
	}

	/**
	 * @return the number
	 */
	public String getNumber() {
		return number;
	}

	/**
	 * @param number
	 *            the number to set
	 */
	public void setNumber(String number) {
		this.number = number;
	}

	/**
	 * @return the describer
	 */
	public String getDescriber() {
		return describer;
	}

	/**
	 * @param describer
	 *            the describer to set
	 */
	public void setDescriber(String describer) {
		this.describer = describer;
	}

	/**
	 * @return the orders
	 */
	public Set<Order> getOrders() {
		return orders;
	}

	/**
	 * @param orders
	 *            the orders to set
	 */
	public void setOrders(Set<Order> orders) {
		this.orders = orders;
	}

	/**
	 * @return the address
	 */
	public Address getAddress() {
		return address;
	}

	/**
	 * @param address
	 *            the address to set
	 */
	public void setAddress(Address address) {
		this.address = address;
	}

}
