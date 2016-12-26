/******************************************************************************
 * Copyright (C) 2015 ShenZhen ComTop Information Technology Co.,Ltd
 * All Rights Reserved.
 * 本软件为深圳康拓普开发研制。未经本公司正式书面同意，其他任何个人、团体不得使用、
 * 复制、修改或发布本软件.
 *****************************************************************************/

package com.comtop.cap.document.word.write;

import java.util.List;

import org.jsoup.Jsoup;
import org.jsoup.nodes.Document;
import org.jsoup.nodes.Node;
import org.junit.Test;

/**
 * Jsoup测试
 *
 * @author lizhongwen
 * @since jdk1.6
 * @version 2015年12月16日 lizhongwen
 */
public class JsoupTest {
    
    /**
     * 测试解析
     */
    @Test
    public void testParse() {
        // Connection conn = Jsoup.connect("http://www.163.com");
        // Response response = conn.execute();
        Document document = Jsoup.parse("<p><span>ddddd</span><br/></p>");
        Node element = document.body();
        printNode(element, 0);
        
    }
    
    /**
     * FIXME 方法注释信息
     *
     * @param element node
     * @param level level
     */
    private void printNode(Node element, int level) {
        List<Node> nodes = element.childNodes();
        String str = " ";
        StringBuffer buffer = new StringBuffer();
        for (int i = 0; i < level; i++) {
            buffer.append(str);
        }
        for (Node node : nodes) {
            int l = level + 1;
            System.out.println(buffer.toString() + node.nodeName());
            printNode(node, l);
        }
        
    }
}
