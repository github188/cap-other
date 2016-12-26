/******************************************************************************
 * Copyright (C) 2016 ShenZhen ComTop Information Technology Co.,Ltd
 * All Rights Reserved.
 * 本软件为深圳康拓普开发研制。未经本公司正式书面同意，其他任何个人、团体不得使用、
 * 复制、修改或发布本软件.
 *****************************************************************************/
package com.comtop.tech.model;

import java.math.BigDecimal;
import java.sql.Blob;
import java.sql.Clob;
import java.sql.Date;
import java.sql.Timestamp;
import java.util.List;
import java.util.Map;

import com.comtop.top.core.base.model.CoreVO;

/**
 * 
 * @author 许畅
 * @since JDK1.7
 * @version 2016年11月28日 许畅 新建
 */
public abstract class BaseContractVO extends CoreVO {
	//

	/**  */
	private String id;
	/**  */
	private int number;
	/**  */
	private List<String> lst;
	/**  */
	private Map<String, Object> map;
	/**  */
	private boolean isUsed;
	/**  */
	private Date createDate;
	/**  */
	private Timestamp createTime;
	/**  */
	private BigDecimal amount;
	/**  */
	private Blob blob;
	/**  */
	private Clob clob;
	/**  */
	private Object obj;
	/**  */
	private Integer no;
	/**  */
	private double bill;
	/**  */
	private long lg;
	/**  */
	private float fl;

	/**
	 * @return the id
	 */
	public String getId() {
		return id;
	}

	/**
	 * @param id
	 *            the id to set
	 */
	public void setId(String id) {
		this.id = id;
	}

	/**
	 * @return the number
	 */
	public int getNumber() {
		return number;
	}

	/**
	 * @param number
	 *            the number to set
	 */
	public void setNumber(int number) {
		this.number = number;
	}

	/**
	 * @return the lst
	 */
	public List<String> getLst() {
		return lst;
	}

	/**
	 * @param lst
	 *            the lst to set
	 */
	public void setLst(List<String> lst) {
		this.lst = lst;
	}

	/**
	 * @return the map
	 */
	public Map<String, Object> getMap() {
		return map;
	}

	/**
	 * @param map
	 *            the map to set
	 */
	public void setMap(Map<String, Object> map) {
		this.map = map;
	}

	/**
	 * @return the isUsed
	 */
	public boolean isUsed() {
		return isUsed;
	}

	/**
	 * @param isUsed
	 *            the isUsed to set
	 */
	public void setUsed(boolean isUsed) {
		this.isUsed = isUsed;
	}

	/**
	 * @return the createDate
	 */
	public Date getCreateDate() {
		return createDate;
	}

	/**
	 * @param createDate
	 *            the createDate to set
	 */
	public void setCreateDate(Date createDate) {
		this.createDate = createDate;
	}

	/**
	 * @return the createTime
	 */
	public Timestamp getCreateTime() {
		return createTime;
	}

	/**
	 * @param createTime
	 *            the createTime to set
	 */
	public void setCreateTime(Timestamp createTime) {
		this.createTime = createTime;
	}

	/**
	 * @return the amount
	 */
	public BigDecimal getAmount() {
		return amount;
	}

	/**
	 * @param amount
	 *            the amount to set
	 */
	public void setAmount(BigDecimal amount) {
		this.amount = amount;
	}

	/**
	 * @return the blob
	 */
	public Blob getBlob() {
		return blob;
	}

	/**
	 * @param blob
	 *            the blob to set
	 */
	public void setBlob(Blob blob) {
		this.blob = blob;
	}

	/**
	 * @return the clob
	 */
	public Clob getClob() {
		return clob;
	}

	/**
	 * @param clob
	 *            the clob to set
	 */
	public void setClob(Clob clob) {
		this.clob = clob;
	}

	/**
	 * @return the obj
	 */
	public Object getObj() {
		return obj;
	}

	/**
	 * @param obj
	 *            the obj to set
	 */
	public void setObj(Object obj) {
		this.obj = obj;
	}

	/**
	 * @return the no
	 */
	public Integer getNo() {
		return no;
	}

	/**
	 * @param no
	 *            the no to set
	 */
	public void setNo(Integer no) {
		this.no = no;
	}

	/**
	 * @return the bill
	 */
	public double getBill() {
		return bill;
	}

	/**
	 * @param bill
	 *            the bill to set
	 */
	public void setBill(double bill) {
		this.bill = bill;
	}

	/**
	 * @return the lg
	 */
	public long getLg() {
		return lg;
	}

	/**
	 * @param lg
	 *            the lg to set
	 */
	public void setLg(long lg) {
		this.lg = lg;
	}

	/**
	 * @return the fl
	 */
	public float getFl() {
		return fl;
	}

	/**
	 * @param fl
	 *            the fl to set
	 */
	public void setFl(float fl) {
		this.fl = fl;
	}

}
