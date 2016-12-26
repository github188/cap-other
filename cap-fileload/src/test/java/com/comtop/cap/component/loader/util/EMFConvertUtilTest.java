
package com.comtop.cap.component.loader.util;

import java.io.FileNotFoundException;
import java.io.FileOutputStream;
import java.io.IOException;
import java.io.InputStream;

import org.junit.Test;

/**
 * FIXME 类注释信息
 *
 * @author lizhiyong
 * @since jdk1.6
 * @version 2016年1月15日 lizhiyong
 */
public class EMFConvertUtilTest {
    
    /**
     * FIXME 方法注释信息
     * 
     * @throws IOException 异常
     *
     */
    @Test
    public void testConvertInputStreamOutputStreamString() throws IOException {
        String uploadPath = "uploadFile";
        InputStream inputStream = LoaderUtilTest.class.getClassLoader()
            .getResourceAsStream(uploadPath + "/image35.emf");
        FileOutputStream outPutStream;
        try {
            outPutStream = new FileOutputStream("D:/xx.emf");
            EMFConvertUtil.convert(inputStream, outPutStream, "png");
        } catch (FileNotFoundException e) {
            e.printStackTrace();
        }
        
    }
    
}
