/******************************************************************************
 * Copyright (C) 2016 ShenZhen ComTop Information Technology Co.,Ltd
 * All Rights Reserved.
 * 本软件为深圳康拓普开发研制。未经本公司正式书面同意，其他任何个人、团体不得使用、
 * 复制、修改或发布本软件.
 *****************************************************************************/
package com.comtop.tech.test;

import javax.xml.bind.annotation.XmlAccessOrder;
import javax.xml.bind.annotation.XmlAccessType;
import javax.xml.bind.annotation.XmlAccessorOrder;
import javax.xml.bind.annotation.XmlAccessorType;
import javax.xml.bind.annotation.XmlAttribute;
import javax.xml.bind.annotation.XmlElement;
import javax.xml.bind.annotation.XmlRootElement;
import javax.xml.bind.annotation.XmlType;

/**
 * 
 * @author 许畅
 * @since JDK1.7
 * @version 2016年11月23日 许畅 新建
 */
@XmlType(propOrder = { "state", "province", "city", "street", "zip" })
@XmlAccessorOrder(XmlAccessOrder.ALPHABETICAL)
@XmlAccessorType(XmlAccessType.NONE)
@XmlRootElement
public class Address {
	
	/**
	 * 
	 */
	public Address(){
		
	}

	/**
	 * @param state
	 *            xx
	 * @param province
	 *            xx
	 * @param city
	 *            xx
	 * @param street
	 *            xx
	 * @param zip
	 *            xx
	 */
	public Address(String state, String province, String city, String street,
			String zip) {
		setState(state);
		setProvince(province);
		setCity(city);
		setStreet(street);
		setZip(zip);
	}

	/**
	 * 
	 */
	@XmlAttribute
	private String state;

	/**
     * 
     */
	@XmlElement
	private String province;

	/**
     * 
     */
	@XmlElement
	private String city;

	/**
     * 
     */
	@XmlElement
	private String street;

	/**
     * 
     */
	@XmlElement
	private String zip;

	/**
	 * @return the state
	 */
	public String getState() {
		return state;
	}

	/**
	 * @param state
	 *            the state to set
	 */
	public void setState(String state) {
		this.state = state;
	}

	/**
	 * @return the province
	 */
	public String getProvince() {
		return province;
	}

	/**
	 * @param province
	 *            the province to set
	 */
	public void setProvince(String province) {
		this.province = province;
	}

	/**
	 * @return the city
	 */
	public String getCity() {
		return city;
	}

	/**
	 * @param city
	 *            the city to set
	 */
	public void setCity(String city) {
		this.city = city;
	}

	/**
	 * @return the street
	 */
	public String getStreet() {
		return street;
	}

	/**
	 * @param street
	 *            the street to set
	 */
	public void setStreet(String street) {
		this.street = street;
	}

	/**
	 * @return the zip
	 */
	public String getZip() {
		return zip;
	}

	/**
	 * @param zip
	 *            the zip to set
	 */
	public void setZip(String zip) {
		this.zip = zip;
	}

}
