
package com.comtop.cap.component.loader.util;

import java.awt.Graphics2D;
import java.awt.image.BufferedImage;
import java.io.File;
import java.io.FileNotFoundException;
import java.io.FileOutputStream;
import java.io.IOException;
import java.io.InputStream;
import java.io.OutputStream;

import javax.imageio.ImageIO;

import org.freehep.graphicsio.emf.EMFInputStream;
import org.freehep.graphicsio.emf.EMFRenderer;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;

import com.comtop.cap.component.loader.LoaderHelper;

/**
 * 将EMF图片文件转换PNG、JPG的工具类
 * 
 * @author yangsai
 */
public class EMFConvertUtil {
    
    /**
     * log
     */
    private final static Logger LOG = LoggerFactory.getLogger(EMFConvertUtil.class);
    
    /**
     * EMF文件转换
     * 
     * @param inputStream emf文件流
     * @param outfile 转换输出文件
     * @throws IOException 抛出异常
     */
    public static void convert(InputStream inputStream, File outfile) throws IOException {
        String fileName = outfile.getName();
        FileOutputStream fileOutputStream = null;
        try {
            fileOutputStream = new FileOutputStream(outfile);
            convert(inputStream, fileOutputStream, fileName.substring(fileName.lastIndexOf(".") + 1, fileName.length()));
        } catch (FileNotFoundException e) {
            LOG.error("file can not found: " + outfile.getPath(), e);
        } finally {
            LoaderHelper.close(fileOutputStream);
        }
    }
    
    /**
     * 
     * @param inputStream emf输入流
     * @param outPutStream emf输出流
     * @param formatName 转换格式 png jpg gif
     * @throws IOException 抛出异常
     */
    public static void convert(InputStream inputStream, OutputStream outPutStream, String formatName)
        throws IOException {
        EMFInputStream emfInputStream = null;
        try {
            emfInputStream = new EMFInputStream(inputStream, EMFInputStream.DEFAULT_VERSION);
            // System.out.println("height = " + emfInputStream.readHeader().getBounds().getHeight());
            // System.out.println("widht = " + emfInputStream.readHeader().getBounds().getWidth());
            EMFRenderer emfRenderer = new EMFRenderer(emfInputStream);
            // create buffered image object from EMF render
            final int width = (int) emfInputStream.readHeader().getBounds().getWidth();
            final int height = (int) emfInputStream.readHeader().getBounds().getHeight();
            // System.out.println("widht = " + width + " and height = " + height);
            final BufferedImage result = new BufferedImage(width + 10, height + 10, BufferedImage.TYPE_4BYTE_ABGR);// .TYPE_INT_RGB);
            Graphics2D g2 = result.createGraphics();
            emfRenderer.paint(g2);
            // write it as png/jpg/gif, up to you
            ImageIO.write(result, formatName, outPutStream);
            
        } catch (FileNotFoundException e) {
            LOG.error("file can not found", e);
            throw e;
        } catch (IOException e) {
            LOG.error("IO Exception", e);
            throw e;
        } finally {
            LoaderHelper.close(emfInputStream);
        }
    }
}
