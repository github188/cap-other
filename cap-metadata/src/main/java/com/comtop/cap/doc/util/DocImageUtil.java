/******************************************************************************
* Copyright (C) 2014 ShenZhen ComTop Information Technology Co.,Ltd
* All Rights Reserved.
* 本软件为深圳康拓普开发研制。未经本公司正式书面同意，其他任何个人、团体不得使用、
* 复制、修改或发布本软件.
*****************************************************************************/

package com.comtop.cap.doc.util;

import java.awt.image.BufferedImage;
import java.io.IOException;
import java.net.URL;

import javax.imageio.ImageIO;

/**
 * 文档图片工具类
 * @author  杨赛
 * @since   jdk1.6
 * @version 2016年12月1日 杨赛
 */
public class DocImageUtil {
	/**
	 * 将图片按照给定的宽度进行等比压缩，若图片本身的宽度比给定的宽度少则不压缩。
	 * @param imageUrl 图片访问http_url
	 * @param targetWidth 等比压缩后的宽度
	 * @return	[width, height]
	 * @throws IOException 文件读取异常
	 */
	public static int[] getImageSize(String imageUrl, int targetWidth) throws IOException {
		BufferedImage bimg = ImageIO.read(new URL(imageUrl));
		int[] size = new int[2];
		size[0]  = bimg.getWidth();
		size[1] = bimg.getHeight();
		if(size[0] > targetWidth) {
			double ratio = size[0] / (double)targetWidth;
			size[1] = (int) (size[1] / ratio);
			size[0] = targetWidth;
		}
		
		return size;
	}
}
