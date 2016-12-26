/******************************************************************************
 * Copyright (C) 2016 ShenZhen ComTop Information Technology Co.,Ltd
 * All Rights Reserved.
 * 本软件为深圳康拓普开发研制。未经本公司正式书面同意，其他任何个人、团体不得使用、
 * 复制、修改或发布本软件.
 *****************************************************************************/
package com.comtop.tech.test;

import java.math.BigDecimal;
import java.util.Date;

import javax.xml.bind.annotation.XmlAccessOrder;
import javax.xml.bind.annotation.XmlAccessType;
import javax.xml.bind.annotation.XmlAccessorOrder;
import javax.xml.bind.annotation.XmlAccessorType;
import javax.xml.bind.annotation.XmlAttribute;
import javax.xml.bind.annotation.XmlRootElement;
import javax.xml.bind.annotation.XmlType;
import javax.xml.bind.annotation.adapters.XmlJavaTypeAdapter;

/**
 * 
 * @author 许畅
 * @since JDK1.7
 * @version 2016年11月23日 许畅 新建
 */
@XmlAccessorOrder(XmlAccessOrder.ALPHABETICAL)
@XmlAccessorType(XmlAccessType.FIELD)
@XmlType(name = "order", propOrder = { "shopName", "orderNumber", "price",
		"amount", "purDate" })
@XmlRootElement
public class Order {
	
	/**
	 * 
	 */
	public Order(){
		
	}

	/**
	 * @param shopName
	 *            xx
	 * @param orderNumber
	 *            xx
	 * @param purDate
	 *            xx
	 * @param price
	 *            xx
	 * @param amount
	 *            xx
	 */
	public Order(String shopName, String orderNumber, Date purDate,
			BigDecimal price, int amount) {
		setShopName(shopName);
		setOrderNumber(orderNumber);
		setPurDate(purDate);
		setPrice(price);
		setAmount(amount);
	}

	/**
     * 
     */
	// @XmlElement
	private String shopName;

	/**
     * 
     */
	@XmlAttribute
	private String orderNumber;

	/**
     * 
     */
	// @XmlElement
	@XmlJavaTypeAdapter(value = DateAdapter.class)
	private Date purDate;

	/**
     * 
     */
	// @XmlElement
	private BigDecimal price;

	/**
     * 
     */
	// @XmlElement
	private int amount;

	/**
	 * @return the shopName
	 */
	public String getShopName() {
		return shopName;
	}

	/**
	 * @param shopName
	 *            the shopName to set
	 */
	public void setShopName(String shopName) {
		this.shopName = shopName;
	}

	/**
	 * @return the orderNumber
	 */
	public String getOrderNumber() {
		return orderNumber;
	}

	/**
	 * @param orderNumber
	 *            the orderNumber to set
	 */
	public void setOrderNumber(String orderNumber) {
		this.orderNumber = orderNumber;
	}

	/**
	 * @return the purDate
	 */
	public Date getPurDate() {
		return purDate;
	}

	/**
	 * @param purDate
	 *            the purDate to set
	 */
	public void setPurDate(Date purDate) {
		this.purDate = purDate;
	}

	/**
	 * @return the price
	 */
	public BigDecimal getPrice() {
		return price;
	}

	/**
	 * @param price
	 *            the price to set
	 */
	public void setPrice(BigDecimal price) {
		this.price = price;
	}

	/**
	 * @return the amount
	 */
	public int getAmount() {
		return amount;
	}

	/**
	 * @param amount
	 *            the amount to set
	 */
	public void setAmount(int amount) {
		this.amount = amount;
	}

}
