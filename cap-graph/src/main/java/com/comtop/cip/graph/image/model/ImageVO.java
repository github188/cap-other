/******************************************************************************
 * Copyright (C) 2015 ShenZhen ComTop Information Technology Co.,Ltd
 * All Rights Reserved.
 * 本软件为深圳康拓普开发研制。未经本公司正式书面同意，其他任何个人、团体不得使用、
 * 复制、修改或发布本软件.
 *****************************************************************************/

package com.comtop.cip.graph.image.model;

/**
 * 实体关联关系VO
 * 
 * @author 杨育
 * @since 1.0
 * @version 2015-7-22 杨育
 */
public class ImageVO {

	/**图片路径 */
	private String imagePath;
	
	/**图片名称*/
	private String imageName;
	
	/**高度*/
	private int high;
	
	/**宽度*/
	private int width;

	/**
	 * @return the imagePath
	 */
	public String getImagePath() {
		return imagePath;
	}

	/**
	 * @param imagePath the imagePath to set
	 */
	public void setImagePath(String imagePath) {
		this.imagePath = imagePath;
	}

	/**
	 * @return the imageName
	 */
	public String getImageName() {
		return imageName;
	}

	/**
	 * @param imageName the imageName to set
	 */
	public void setImageName(String imageName) {
		this.imageName = imageName;
	}

	/**
	 * @return the high
	 */
	public int getHigh() {
		return high;
	}

	/**
	 * @param high the high to set
	 */
	public void setHigh(int high) {
		this.high = high;
	}

	/**
	 * @return the width
	 */
	public int getWidth() {
		return width;
	}

	/**
	 * @param width the width to set
	 */
	public void setWidth(int width) {
		this.width = width;
	}

	
}
