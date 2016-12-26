
package com.comtop.cap.runtime.dwr.converter;

import java.io.IOException;
import java.net.URI;

import org.apache.commons.lang.StringUtils;

import com.comtop.cap.component.loader.LoadFile;
import com.comtop.cap.component.loader.util.LoaderUtil;
import comtop.org.directwebremoting.ConversionException;
import comtop.org.directwebremoting.WebContextFactory;
import comtop.org.directwebremoting.extend.FormField;
import comtop.org.directwebremoting.extend.InboundVariable;

/**
 * 附件上传对象转换
 * 
 * @author yangsai
 */
public class FileConverter extends comtop.org.directwebremoting.convert.FileConverter {
    
    @Override
    public Object convertInbound(Class<?> paramType, InboundVariable data) throws ConversionException {
        if (data.isNull()) {
            return null;
        }
        if (paramType == LoadFile.class) {
            try {
                return uploadFile(data,
                    (String) WebContextFactory.get().getHttpServletRequest().getAttribute("uploadKey"),
                    (String) WebContextFactory.get().getHttpServletRequest().getAttribute("uploadId"));
            } catch (IOException ex) {
                throw new ConversionException(paramType, ex);
            }
        }
        return super.convertInbound(paramType, data);
    }
    
    /**
     * 上传文件并创建上传文件信息
     * 
     * @param data 提交属性值对象
     * @param uploadKey 上传业务code
     * @param uploadId 上传id 可以为null
     * @return 上传的文件信息
     * @throws IOException io异常
     */
    private LoadFile uploadFile(InboundVariable data, String uploadKey, String uploadId) throws IOException {
        FormField formField = data.getFormField();
        LoadFile loadFile = new LoadFile();
        loadFile.setName(formField.getName());
        loadFile.setUploadKey(uploadKey);
        loadFile.setContextType(formField.getMimeType());
        loadFile.setFileSize(formField.getFileSize());
        if (loadFile.getFileSize() == 0) { // 大小为0，表示木有文件
            throw new RuntimeException();
            // return loadFile;
        }
        loadFile.setFileSuffix(LoaderUtil.getSuffix(loadFile.getName()));
        // 上传文件
        if (StringUtils.isBlank(uploadId)) {
            uploadId = LoaderUtil.generateUploadId();
        }
        loadFile.setUploadId(uploadId);
        loadFile.setFolderPath(LoaderUtil.getFolderPath(uploadKey, loadFile.getUploadId()));
//        loadFile.setFileName(LoaderUtil.createRandomFileName(loadFile.getName()));
        loadFile.setFileName(loadFile.getName());
        URI uri = LoaderUtil.upLoad(formField.getInputStream(), loadFile.getFolderPath(), loadFile.getFileName());
        loadFile.setUri(uri);
        return loadFile;
    }
}
