package com.comtop.meeting.model;

import java.sql.Timestamp;

import javax.persistence.Column;
import javax.persistence.Id;
import javax.persistence.Table;

import com.comtop.top.core.base.model.CoreVO;

import comtop.org.directwebremoting.annotations.DataTransferObject;

/**
 * 会议管理VO
 * 
 * @author xu_chang
 */
@DataTransferObject
@Table(name = "OMS_demo_xc_MEETINGROOM")
public class MeetingManageViewVO extends CoreVO {

	/**
	 * 默认系列
	 */
	private static final long serialVersionUID = 1L;

	/**
	 * 会议室id
	 */
	@Id
	@Column(name = "ROOMID")
	private String roomId;

	/**
	 * 会议室名称
	 */
	@Column(name = "NAME")
	private String roomName;

	/**
	 * 申请人id
	 */
	private String applierId;

	/**
	 * 申请人名称
	 */
	private String applierName;

	/**
	 * 开始时间
	 */
	private Timestamp startDate;

	/**
	 * 结束时间
	 */
	private Timestamp endDate;

	/**
	 * @return the roomId
	 */
	public String getRoomId() {
		return roomId;
	}

	/**
	 * @param roomId
	 *            the roomId to set
	 */
	public void setRoomId(String roomId) {
		this.roomId = roomId;
	}

	/**
	 * @return the roomName
	 */
	public String getRoomName() {
		return roomName;
	}

	/**
	 * @param roomName
	 *            the roomName to set
	 */
	public void setRoomName(String roomName) {
		this.roomName = roomName;
	}

	/**
	 * @return the applierId
	 */
	public String getApplierId() {
		return applierId;
	}

	/**
	 * @param applierId
	 *            the applierId to set
	 */
	public void setApplierId(String applierId) {
		this.applierId = applierId;
	}

	/**
	 * @return the applierName
	 */
	public String getApplierName() {
		return applierName;
	}

	/**
	 * @param applierName
	 *            the applierName to set
	 */
	public void setApplierName(String applierName) {
		this.applierName = applierName;
	}

	/**
	 * @return the endDate
	 */
	public Timestamp getEndDate() {
		return endDate;
	}

	/**
	 * @param endDate
	 *            the endDate to set
	 */
	public void setEndDate(Timestamp endDate) {
		this.endDate = endDate;
	}

	/**
	 * @return the startDate
	 */
	public Timestamp getStartDate() {
		return startDate;
	}

	/**
	 * @param startDate
	 *            the startDate to set
	 */
	public void setStartDate(Timestamp startDate) {
		this.startDate = startDate;
	}

}
