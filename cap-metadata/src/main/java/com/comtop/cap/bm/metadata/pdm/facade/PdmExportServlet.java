/******************************************************************************
 * Copyright (C) 2015 ShenZhen ComTop Information Technology Co.,Ltd
 * All Rights Reserved.
 * 本软件为深圳康拓普开发研制。未经本公司正式书面同意，其他任何个人、团体不得使用、
 * 复制、修改或发布本软件.
 ******************************************************************************/

package com.comtop.cap.bm.metadata.pdm.facade;

import java.io.BufferedInputStream;
import java.io.BufferedOutputStream;
import java.io.File;
import java.io.FileInputStream;
import java.io.IOException;

import javax.servlet.ServletException;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;

import com.comtop.cap.bm.metadata.common.storage.exception.OperateException;
import com.comtop.cap.bm.metadata.pdm.model.PdmVO;
import com.comtop.cap.bm.metadata.pdm.util.PdmExportUtils;
import com.comtop.top.core.jodd.AppContext;

/**
 * Pdm导出servlet
 * 
 * @author 陈志伟
 * @since 1.0
 * @version 2015年3月10日 陈志伟
 */
public class PdmExportServlet extends HttpServlet {
    
    /** 串行化标识 */
    private static final long serialVersionUID = 8646119985194569277L;
    
    /** 日志 */
    private final static Logger LOGGER = LoggerFactory.getLogger(PdmExportServlet.class);
    
    /** Facade */
    private final PdmFacade pdmFacade = AppContext.getBean(PdmFacade.class);
    
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
        // 设置编码
        request.setCharacterEncoding("utf-8");
        String strPackageId = request.getParameter("packageId");
        try {
            // 查询表和视图信息
            PdmVO objPdmVO = pdmFacade.exportPdm(strPackageId);
            PdmExportUtils objPdmExportUtils = new PdmExportUtils(objPdmVO);
            // 导出文件
            File objFile = new File(objPdmExportUtils.exportPdm());
            response.setCharacterEncoding("UTF-8");
            String fileType = "application/octet-stream";
            response.setContentType(fileType);
            String newFileName = new String((objPdmVO.getCode() + ".pdm").getBytes(), "ISO8859_1");
            response.setHeader("Content-disposition", "attachment;filename=\"" + newFileName + "\"");
            
            BufferedInputStream bis = new BufferedInputStream(new FileInputStream(objFile));
            BufferedOutputStream bos = new BufferedOutputStream(response.getOutputStream());
            
            byte[] buffer = new byte[1024];
            int length = 0;
            
            while ((length = bis.read(buffer)) != -1) {
                bos.write(buffer, 0, length);
            }
            
            if (bis != null)
                bis.close();
            if (bos != null)
                bos.close();
            
            if (objFile.exists()) {
                objFile.delete();
            }
        } catch (OperateException e) {
            LOGGER.error("PDM文件导出失败", e);
        } catch (Exception e) {
            LOGGER.error("PDM文件导出失败", e);
        }
        
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
