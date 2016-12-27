/******************************************************************************
 * Copyright (C) 2015 ShenZhen ComTop Information Technology Co.,Ltd
 * All Rights Reserved.
 * 本软件为深圳康拓普开发研制。未经本公司正式书面同意，其他任何个人、团体不得使用、
 * 复制、修改或发布本软件.
 *****************************************************************************/

package com.comtop.cap.ptc.report.utils;
import java.text.Format;
import java.text.MessageFormat;
import java.text.SimpleDateFormat;
import java.util.ArrayList;
import java.util.Calendar;
import java.util.Date;
import java.util.List;

/**
 * 报表时间工具类，针对时间进行处理后用于报表使用
 * @author yangsai
 *
 */
public class ReportDateUtil {
	
	/**
	 * 获取时间段之内的以周划分的日期范围对象
	 * @param startTime 开始时间
	 * @param endTime 结束时间
	 * @return 日期范围对象
	 */
	public static List<RangeDate> getWeekRangeDate(Date startTime, Date endTime) {
		if(startTime == null || endTime == null || !startTime.before(endTime)) {
			return new ArrayList<RangeDate>(0);
		}
		
		Calendar objStartCal = Calendar.getInstance();
		objStartCal.setTime(startTime);
		Calendar objEndCal = Calendar.getInstance();
		objEndCal.setTime(endTime);
		List<RangeDate> lstCalendar = new ArrayList<RangeDate>();
		RangeDate objRangeDate = null;
		int iIndex = 0;
		while(objStartCal.before(objEndCal)) {
			iIndex ++;
			objRangeDate = new RangeDate("第" + iIndex + "周");
			lstCalendar.add(objRangeDate);
			objRangeDate.setStartTime((Calendar)objStartCal.clone());
			objStartCal.add(Calendar.DATE, 7);	//开始时间增加7天
			if(!objEndCal.after(objStartCal)) {
				objRangeDate.setEndTime((Calendar) objEndCal.clone());
				break;
			}
			objRangeDate.setEndTime((Calendar)objStartCal.clone());
		}
		return lstCalendar;
	}
	
	/**
	 * 获取时间段之内的以月份划分的日期范围对象
	 * @param startTime	开始时间
	 * @param endTime	结束时间
	 * @return	日期范围对象
	 */
	public static List<RangeDate> getMonthRangeDate(Date startTime, Date endTime) {
		int[] monthPoint = new int[12];
		int[] datePoint = new int[12];
		for(int i = 0; i < 12; i++) {
			monthPoint[i] = i + 1;
			datePoint[i] = 1;
		}
		return getRangeDate(startTime, endTime, monthPoint, datePoint, "{0}年{1}月");
	}
	
	/**
	 * 获取时间段之内的以季度划分的日期范围对象
	 * @param startTime	开始时间
	 * @param endTime	结束时间
	 * @return	日期范围对象
	 */
	public static List<RangeDate> getQuarterRangeDate(Date startTime, Date endTime) {
		int[] monthPoint = new int[]{1,4,7,10};	  	//季度分界月份
		int[] datePoint = new int[]{1,1,1,1}; 		//季度分界日期 第一季度其实时间为monthPoint[0]月datePoint[0]日
		return getRangeDate(startTime, endTime, monthPoint, datePoint, "{0}第{1}季度");
	}
	
	/**
	 * 根据开始时间和结束时间以及给定的时间单位获取RangeDate对象
	 * @param startTime 开始时间
	 * @param endTime	结束时间
	 * @param monthPoint 分界月份 以季度分解为例 int[] monthPoint = new int[]{1,4,7,10};	
	 * @param datePoint  分界日期  以季度分解为例  int[] datePoint = new int[]{1,1,1,1}; 第一季度时间为monthPoint[0]月datePoint[0]日
	 * @param rangeName	范围日期描述,{0}表示年份,{1}表示分解描述（季度中为季度数，按月份来就是月份数）例如：{0}第{1}季度
	 * @return 日期范围对象
	 */
	public static List<RangeDate> getRangeDate(Date startTime, Date endTime, int[] monthPoint, int[] datePoint, String rangeName) {
		if(startTime == null || endTime == null || !startTime.before(endTime)) {
			return new ArrayList<RangeDate>(0);
		}
		
		Calendar objStartCal = Calendar.getInstance();
		objStartCal.setTime(startTime);
		Calendar objEndCal = Calendar.getInstance();
		objEndCal.setTime(endTime);
		int iSize = (objEndCal.get(Calendar.YEAR)- objStartCal.get(Calendar.YEAR) + 1) * monthPoint.length;
		List<RangeDate> lstCalendar = new ArrayList<RangeDate>(iSize);
		RangeDate objRangeDate = null;
		while (objStartCal.before(objEndCal)) {
			int iStartMonth = objStartCal.get(Calendar.MONTH) + 1;
			int IStartYear = objStartCal.get(Calendar.YEAR);
			for(int i = 0; i< monthPoint.length; i++) {
				if(iStartMonth < monthPoint[i]) {	//
//					System.out.print(IStartYear + " " + (i) + "季度 :");
//					System.out.print(format(objStartCal) + " to ");
					objRangeDate = new RangeDate(MessageFormat.format(rangeName,String.valueOf(IStartYear), i));
					lstCalendar.add(objRangeDate);
					objRangeDate.setStartTime((Calendar) objStartCal.clone());
					objStartCal.set(IStartYear, (monthPoint[i] - 1), datePoint[i], 0, 0, 0);	//新起点
					if(!objEndCal.after(objStartCal)) {
//						System.out.println(format(objEndCal));
						objRangeDate.setEndTime((Calendar) objEndCal.clone());
						break;
					} 
//					System.out.println(format(objStartCal));
					objRangeDate.setEndTime((Calendar) objStartCal.clone());
					
					if(i == monthPoint.length - 1) {
//						System.out.print(IStartYear + " " + (i + 1) + "季度 :");
						objRangeDate = new RangeDate(MessageFormat.format(rangeName,String.valueOf(IStartYear), i + 1));
						lstCalendar.add(objRangeDate);
//						System.out.print(format(objStartCal) + " to ");
						objRangeDate.setStartTime((Calendar) objStartCal.clone());
						objStartCal.set(IStartYear + 1, (monthPoint[0] - 1), datePoint[0], 0, 0, 0);	//夸年新起点
						if(!objEndCal.after(objStartCal)) {
//							System.out.println(format(objEndCal));
							objRangeDate.setEndTime((Calendar) objEndCal.clone());
							break;
						} 
//						System.out.println(format(objStartCal));
						objRangeDate.setEndTime((Calendar) objStartCal.clone());
					} 
				}
			}
		}
		
		return lstCalendar;
	}
	
	/** 时间格式化 */
	private final static Format format = new SimpleDateFormat("yyyy-MM-dd HH:mm:ss");
	
	/**
	 * 日期范围对象
	 * @author yangsai
	 */
	public static class RangeDate {
		
		/** 范围name */
		private String rangeName;
		
		/** 范围开始时间 */
		private Calendar startTime;
		
		/** 范围结束时间 */
		private Calendar endTime;

		/**
		 * 构造方法
		 */
		public RangeDate() {
			super();
		}
		
		/**
		 * 构造方法
		 * @param rangeName 范围name
		 */
		public RangeDate(String rangeName) {
			super();
			this.rangeName = rangeName;
		}
		
		/**
		 * get 范围name
		 * @return 范围name
		 */
		public String getRangeName() {
			return rangeName;
		}

		/**
		 * set 范围name
		 * @param rangeName 范围name
		 */
		public void setRangeName(String rangeName) {
			this.rangeName = rangeName;
		}

		/**
		 * get 范围开始时间
		 * @return 范围开始时间
		 */
		public Calendar getStartTime() {
			return startTime;
		}

		/**
		 * set 范围开始时间
		 * @param startTime 范围开始时间
		 */
		public void setStartTime(Calendar startTime) {
			this.startTime = startTime;
		}

		/**
		 * get 范围结束时间
		 * @return 范围结束时间
		 */
		public Calendar getEndTime() {
			return endTime;
		}

		/**
		 * set 范围结束时间
		 * @param endTime 范围结束时间
		 */
		public void setEndTime(Calendar endTime) {
			this.endTime = endTime;
		}
		
		/**
		 * toString方法重写
		 */
		@Override
		public String toString() {
			return rangeName + ":" + startTime == null ? " " : format.format(startTime.getTime()) + " to " +  endTime == null ? " " : format.format(endTime.getTime());
		}
	}
	

}
