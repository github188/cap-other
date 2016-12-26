/******************************************************************************
 * Copyright (C) 2015 ShenZhen ComTop Information Technology Co.,Ltd
 * All Rights Reserved.
 * 本软件为深圳康拓普开发研制。未经本公司正式书面同意，其他任何个人、团体不得使用、
 * 复制、修改或发布本软件.
 *****************************************************************************/

package com.comtop.cap.runtime.dwr;

import java.io.File;
import java.io.IOException;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpSession;

import org.apache.commons.fileupload.FileItem;
import org.apache.commons.fileupload.FileUploadBase.FileSizeLimitExceededException;
import org.apache.commons.fileupload.FileUploadException;
import org.apache.commons.fileupload.disk.DiskFileItemFactory;
import org.apache.commons.fileupload.servlet.ServletFileUpload;

import comtop.org.directwebremoting.dwrp.CommonsFileUpload;
import comtop.org.directwebremoting.event.SessionProgressListener;
import comtop.org.directwebremoting.extend.FormField;
import comtop.org.directwebremoting.extend.ServerException;
import comtop.org.directwebremoting.extend.SimpleInputStreamFactory;
import comtop.org.directwebremoting.io.InputStreamFactory;

/**
 * FIXME 类注释信息
 *
 * @author lizhiyong
 * @since jdk1.6
 * @version 2015年12月3日 lizhiyong
 */
public class CapFileUpload extends CommonsFileUpload {
    
    /** FIXME */
    private static final int DEFAULT_SIZE_THRESHOLD = 262144;
    
    @Override
    public Map<String, FormField> parseRequest(HttpServletRequest req) throws ServerException {
        File location = new File(System.getProperty("java.io.tmpdir"));
        DiskFileItemFactory itemFactory = new DiskFileItemFactory(DEFAULT_SIZE_THRESHOLD, location);
        ServletFileUpload fileUploader = new ServletFileUpload(itemFactory);
        fileUploader.setHeaderEncoding("UTF-8");
        if (getFileUploadMaxBytes() > 0) {
            fileUploader.setFileSizeMax(getFileUploadMaxBytes());
        }
        HttpSession session = req.getSession(false);
        if (session != null) {
            fileUploader.setProgressListener(new SessionProgressListener(session));
            session.setAttribute("CANCEL_UPLOAD", null);
            session.setAttribute(PROGRESS_LISTENER, fileUploader.getProgressListener());
        }
        
        try {
            Map<String, FormField> map = new HashMap<String, FormField>();
            List<FileItem> fileItems = fileUploader.parseRequest(req);
            for (final FileItem fileItem : fileItems) {
                FormField formField;
                if (fileItem.isFormField()) {
                    formField = new FormField(fileItem.getString());
                } else {
                    InputStreamFactory inFactory = new SimpleInputStreamFactory(fileItem.getInputStream());
                    formField = new FormField(fileItem.getName(), fileItem.getContentType(), fileItem.getSize(),
                        inFactory);
                }
                map.put(fileItem.getFieldName(), formField);
            }
            return map;
        } catch (FileSizeLimitExceededException fsle) {
            throw new ServerException("One or more files is larger (" + fsle.getActualSize()
                + " bytes) than the configured limit (" + fsle.getPermittedSize() + " bytes).");
        } catch (IOException ex) {
            throw new ServerException("Upload failed: " + ex.getMessage(), ex);
        } catch (FileUploadException ex) {
            throw new ServerException("Upload failed: " + ex.getMessage(), ex);
        }
    }
}
