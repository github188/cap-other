
package com.comtop.cap.document.word.parse;

import java.io.File;
import java.io.FileOutputStream;
import java.io.IOException;

import javax.xml.bind.JAXBContext;
import javax.xml.bind.JAXBException;
import javax.xml.bind.SchemaOutputResolver;
import javax.xml.transform.Result;
import javax.xml.transform.stream.StreamResult;

import com.comtop.cap.document.word.docconfig.model.DocConfig;

/**
 * FIXME 类注释信息
 *
 * @author lizhiyong
 * @since jdk1.6
 * @version 2015年10月23日 lizhiyong
 */
public class XsdGenerater {
    
    /**
     * FIXME 方法注释信息
     *
     * @param args xx
     */
    public static void main(String[] args) {
        try {
            testGenerateSchema();
        } catch (JAXBException e) {
            e.printStackTrace();
        } catch (IOException e) {
            e.printStackTrace();
        }
    }
    
    /**
     * 生成Schema文件
     * 
     * @throws JAXBException JAXB解析异常
     * @throws IOException IO异常
     */
    public static void testGenerateSchema() throws JAXBException, IOException {
        JAXBContext objContext = JAXBContext.newInstance(DocConfig.class);
        String strOutfilePath = "D:\\CAP\\BM\\code\\cip\\cap-document\\src\\main\\resources\\DocConfig.xsd";
        final FileOutputStream objOut = new FileOutputStream(new File(strOutfilePath));
        // targetNamespace="http://www.szcomtop.com/wt" xmlns="http://www.szcomtop.com/wt"
        // elementFormDefault="qualified"
        objContext.generateSchema(new SchemaOutputResolver() {
            
            /**
             * @see javax.xml.bind.SchemaOutputResolver#createOutput(java.lang.String, java.lang.String)
             */
            @Override
            public Result createOutput(String namespaceUri, String suggestedFileName) throws IOException {
                StreamResult objStreamResult = new StreamResult(objOut);
                
                objStreamResult.setSystemId("");
                return objStreamResult;
            }
        });
        objOut.flush();
        objOut.close();
    }
}
