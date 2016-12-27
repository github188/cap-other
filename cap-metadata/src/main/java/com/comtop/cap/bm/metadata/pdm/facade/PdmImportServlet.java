/******************************************************************************
 * Copyright (C) 2015 ShenZhen ComTop Information Technology Co.,Ltd
 * All Rights Reserved.
 * 本软件为深圳康拓普开发研制。未经本公司正式书面同意，其他任何个人、团体不得使用、
 * 复制、修改或发布本软件.
 ******************************************************************************/

package com.comtop.cap.bm.metadata.pdm.facade;

import java.io.File;
import java.io.FileOutputStream;
import java.io.IOException;
import java.io.InputStream;
import java.io.OutputStream;
import java.net.URLEncoder;
import java.util.List;

import javax.servlet.ServletException;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.apache.commons.fileupload.FileItem;
import org.apache.commons.fileupload.FileUploadException;
import org.apache.commons.fileupload.disk.DiskFileItemFactory;
import org.apache.commons.fileupload.servlet.ServletFileUpload;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;

import com.comtop.cap.bm.metadata.pdm.util.PdmUtils;
import com.comtop.top.component.app.session.HttpSessionUtil;

/**
 * Pdm导入servlet
 * 
 * @author 陈志伟
 * @since 1.0
 * @version 2015年3月10日 陈志伟
 */
public class PdmImportServlet extends HttpServlet {
    
    /** 串行化标识 */
    private static final long serialVersionUID = 8646119985194569277L;
    
    /** 日志 */
    private final static Logger LOGGER = LoggerFactory.getLogger(PdmImportServlet.class);
    
    /**
     * @param request HttpServletRequest
     * @param response HttpServletResponse
     * @throws ServletException ServletException
     * @throws IOException IOException
     * @see javax.servlet.http.HttpServlet#doGet(javax.servlet.http.HttpServletRequest,
     *      javax.servlet.http.HttpServletResponse)
     */
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
		String parentNodeName = request.getParameter("parentNodeName") == null ? ""
				: new String(request.getParameter("parentNodeName").getBytes("ISO-8859-1"), "utf-8");
        // 设置编码
        request.setCharacterEncoding("utf-8");
        request.getSession().setAttribute("parentNodeName", URLEncoder.encode(parentNodeName, "UTF-8"));//tomcat容器编码为ISO-8859-1解决传中文存在乱码问题
        
        // 获得磁盘文件条目工厂
        DiskFileItemFactory objDiskFileItemFactory = new DiskFileItemFactory();
        // 获取文件需要上传到的路径
        String strPath = PdmUtils.createTmpFileDir();
        String strFileName = "";
        objDiskFileItemFactory.setRepository(new File(strPath));
        // 设置 缓存的大小，当上传文件的容量超过该缓存时，直接放到 暂时存储室
        objDiskFileItemFactory.setSizeThreshold(1024 * 1024);
        
        // 高水平的API文件上传处理
        ServletFileUpload objServletFileUpload = new ServletFileUpload(objDiskFileItemFactory);
        
        try {
            // 可以上传多个文件
            @SuppressWarnings("unchecked")
			List<FileItem> lstFileItem = objServletFileUpload.parseRequest(request);
            
            for (FileItem item : lstFileItem) {
                // 获取表单的属性名字
                String strName = item.getFieldName();
                
                // 如果获取的 表单信息是普通的 文本 信息
                if (item.isFormField()) {
                    // 获取用户具体输入的字符串 ，名字起得挺好，因为表单提交过来的是 字符串类型的
                    String strValue = item.getString();
                    request.setAttribute(strName, strValue);
                }
                // 对传入的非 简单的字符串进行处理 ，比如说二进制的 图片，电影这些
                else {
                    // 以下三步，主要获取 上传文件的名字
                    // 获取路径名
                    String strValue = item.getName();
                    // 索引到最后一个反斜杠
                    int iStart = strValue.lastIndexOf("\\");
                    // 截取 上传文件的 字符串名字，加1是 去掉反斜杠，
                    strFileName = strValue.substring(iStart + 1);
                    request.setAttribute(strName, strFileName);
                    OutputStream out = new FileOutputStream(new File(strPath, strFileName));
                    InputStream in = item.getInputStream();
                    
                    int iLength = 0;
                    byte[] buf = new byte[1024];
                    // 文件写入
                    while ((iLength = in.read(buf)) != -1) {
                        out.write(buf, 0, iLength);
                    }
                    
                    in.close();
                    out.close();
                }
            }
            File objFile = new File(strPath, strFileName);
            HttpSessionUtil.getSession().setAttribute("filePath", objFile.getAbsolutePath());
        } catch (FileUploadException e) {
            LOGGER.error("PDM文件上传失败", e);
            request.getRequestDispatcher("/cap/bm/dev/pdm/error.jsp").forward(request, response);
        } catch (Exception e) {
            LOGGER.error("PDM文件上传失败", e);
            request.getRequestDispatcher("/cap/bm/dev/pdm/error.jsp").forward(request, response);
        }
        request.getRequestDispatcher("/cap/bm/dev/pdm/success.jsp").forward(request, response);
    }
    
    /**
     * @param req HttpServletRequest
     * @param resp HttpServletResponse
     * @throws ServletException HttpServletRequest
     * @throws IOException IOException
     * @see javax.servlet.http.HttpServlet#doPost(javax.servlet.http.HttpServletRequest,
     *      javax.servlet.http.HttpServletResponse)
     */
    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        doGet(req, resp);
    }
    
}
