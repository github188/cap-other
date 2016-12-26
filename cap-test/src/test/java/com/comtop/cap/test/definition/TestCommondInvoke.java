/******************************************************************************
 * Copyright (C) 2016 ShenZhen ComTop Information Technology Co.,Ltd
 * All Rights Reserved.
 * 本软件为深圳康拓普开发研制。未经本公司正式书面同意，其他任何个人、团体不得使用、
 * 复制、修改或发布本软件.
 *****************************************************************************/

package com.comtop.cap.test.definition;

import java.io.BufferedReader;
import java.io.IOException;
import java.io.InputStream;
import java.io.InputStreamReader;

import org.apache.commons.io.IOUtils;
import org.apache.commons.lang.StringUtils;
import org.junit.Test;

/**
 * 测试命令执行
 *
 * @author lizhongwen
 * @since jdk1.6
 * @version 2016年8月17日 lizhongwen
 */
public class TestCommondInvoke {
    
    /**
     * 执行
     * 
     * @throws IOException xxx
     * @throws InterruptedException xxxx
     */
    @Test
    public void invoke() throws IOException, InterruptedException {
        Runtime rt = Runtime.getRuntime();
        Process proc = rt
            .exec("pybot.bat D:/eclipse4.4/workspace/CAP/cap-webapp/src/main/webapp/testcase-scripts/资产管理系统");
        Logger stdLogger = new Logger(proc.getInputStream());
        Logger errLogger = new Logger(proc.getErrorStream());
        stdLogger.start();
        errLogger.start();
        proc.waitFor();
        proc.destroy();
    }
    
    /**
     * 日志记录线程
     *
     * @author lizhongwen
     * @since jdk1.6
     * @version 2016年8月17日 lizhongwen
     */
    class Logger implements Runnable {
        
        /** FIXME */
        private static final String SHELL_CHARSET = "GBK";
        
        /** FIXME */
        private static final String LOG_CHARSET = "UTF-8";
        
        /** FIXME */
        private InputStream input;
        
        /**
         * FIXME 方法注释信息
         *
         */
        public void start() {
            Thread thread = new Thread(this);
            thread.setDaemon(true);
            thread.start();
        }
        
        /**
         * 构造函数
         * 
         * @param input input
         */
        public Logger(InputStream input) {
            super();
            this.input = input;
        }
        
        /**
         * 
         * @see java.lang.Runnable#run()
         */
        @Override
        public void run() {
            BufferedReader reader = null;
            try {
                reader = new BufferedReader(new InputStreamReader(input, SHELL_CHARSET));
                String line = null;
                while ((line = reader.readLine()) != null) {
                    if (StringUtils.isNotBlank(line)) {
                        System.out.println(new String(line.getBytes(), LOG_CHARSET));
                    }
                }
            } catch (Exception e) {
                e.printStackTrace();
            } finally {
                IOUtils.closeQuietly(reader);
            }
            
        }
        
    }
}
