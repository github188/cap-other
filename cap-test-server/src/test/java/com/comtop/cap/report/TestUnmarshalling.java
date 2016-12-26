/******************************************************************************
 * Copyright (C) 2016 ShenZhen ComTop Information Technology Co.,Ltd
 * All Rights Reserved.
 * 本软件为深圳康拓普开发研制。未经本公司正式书面同意，其他任何个人、团体不得使用、
 * 复制、修改或发布本软件.
 *****************************************************************************/

package com.comtop.cap.report;

import java.io.File;
import java.io.FileInputStream;

import javax.xml.bind.JAXBContext;
import javax.xml.bind.Unmarshaller;

import org.junit.Assert;
import org.junit.Test;

import com.comtop.cap.report.domain.Robot;
import com.fasterxml.jackson.annotation.JsonInclude.Include;
import com.fasterxml.jackson.databind.ObjectMapper;
import com.fasterxml.jackson.databind.ObjectWriter;
import com.fasterxml.jackson.databind.SerializationFeature;

/**
 * 测试解析测试报告
 *
 * @author lizhongwen
 * @since jdk1.6
 * @version 2016年9月7日 lizhongwen
 */
public class TestUnmarshalling {
    
    /**
     * 测试解析
     */
    @Test
    public void testUnmarshall() {
        try (FileInputStream fileInputStream = new FileInputStream(
            new File("D:/testcase-logs/1471858246601/output.xml"));) {
            JAXBContext context = JAXBContext.newInstance(Robot.class);
            Unmarshaller unmarshaller = context.createUnmarshaller();
            Robot robot = (Robot) unmarshaller.unmarshal(fileInputStream);
            Assert.assertNotNull(robot);
        } catch (Throwable e) {
            e.printStackTrace();
        }
    }
    
    /**
     * 测试转JSON
     */
    @Test
    public void toJson() {
        try (FileInputStream fileInputStream = new FileInputStream(
            new File("D:/testcase-logs/1471858246601/output.xml"));) {
            JAXBContext context = JAXBContext.newInstance(Robot.class);
            Unmarshaller unmarshaller = context.createUnmarshaller();
            Robot robot = (Robot) unmarshaller.unmarshal(fileInputStream);
            Assert.assertNotNull(robot);
            String json = objectToJSON(robot);
            System.out.println(json);
            Assert.assertNotNull(json);
        } catch (Throwable e) {
            e.printStackTrace();
        }
    }
    
    /**
     * 对象转JSON
     *
     * @param object 对象
     * @return JSON
     */
    public static String objectToJSON(Object object) {
        ObjectMapper mapper = new ObjectMapper();
        mapper.configure(SerializationFeature.WRITE_NULL_MAP_VALUES, false).setSerializationInclusion(Include.NON_NULL);
        ObjectWriter jsonWriter = null;
        String text = "";
        try {
            jsonWriter = mapper.writerWithDefaultPrettyPrinter();
            text = jsonWriter.writeValueAsString(object);
        } catch (Exception e) {
            e.printStackTrace();
        }
        return text;
    }
}
