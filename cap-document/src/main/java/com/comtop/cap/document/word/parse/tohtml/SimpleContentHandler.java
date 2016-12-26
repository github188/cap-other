/******************************************************************************
 * Copyright (C) 2015 ShenZhen ComTop Information Technology Co.,Ltd
 * All Rights Reserved.
 * 本软件为深圳康拓普开发研制。未经本公司正式书面同意，其他任何个人、团体不得使用、
 * 复制、修改或发布本软件.
 *****************************************************************************/

package com.comtop.cap.document.word.parse.tohtml;

import org.xml.sax.Attributes;
import org.xml.sax.SAXException;
import org.xml.sax.helpers.DefaultHandler;

/**
 * 简单内容handler
 *
 * @author lizhiyong
 * @since jdk1.6
 * @version 2015年11月3日 lizhiyong
 */
public class SimpleContentHandler extends DefaultHandler {
    
    /** 是否开始元素 */
    private boolean startingElement;
    
    /** 当前字符集 */
    private StringBuilder currentCharacters;
    
    /** 缩进 */
    private final Integer indent;
    
    /** nbElements */
    private int nbElements;
    
    /** 是否第一个元素 */
    private boolean firstElement;
    
    /** html串 */
    private StringBuffer html = new StringBuffer(1024);
    
    /**
     * 构造函数
     * 
     * @param indent 缩进
     */
    public SimpleContentHandler(Integer indent) {
        this.currentCharacters = new StringBuilder();
        this.indent = indent;
        this.firstElement = true;
    }
    
    @Override
    public void startElement(String uri, String localName, String name, Attributes attributes) throws SAXException {
        
        if (startingElement) {
            write(">");
        }
        if (currentCharacters.length() > 0) {
            flushCharacters(currentCharacters.toString());
            resetCharacters();
        }
        
        doIndentIfNeeded();
        write("<");
        write(localName);
        if (attributes != null) {
            int length = attributes.getLength();
            if (length > 0) {
                String attrName = null;
                String attrValue = null;
                for (int i = 0; i < length; i++) {
                    attrName = attributes.getLocalName(i);
                    attrValue = attributes.getValue(i);
                    write(" ");
                    write(attrName);
                    write("=\"");
                    write(attrValue);
                    write("\"");
                }
            }
        }
        
        startingElement = true;
        firstElement = false;
        nbElements++;
    }
    
    /**
     * 如果需要执行缩进
     *
     */
    private void doIndentIfNeeded() {
        if (indent == null || firstElement) {
            return;
        }
        StringBuilder content = new StringBuilder("");
        for (int i = 0; i < nbElements; i++) {
            for (int j = 0; j < indent; j++) {
                content.append(' ');
            }
        }
        write(content.toString());
    }
    
    @Override
    public final void endElement(String uri, String localName, String name) throws SAXException {
        nbElements--;
        if (currentCharacters.length() > 0) {
            // Flush caracters
            flushCharacters(currentCharacters.toString());
            resetCharacters();
        }
        // Start of end element
        if (startingElement) {
            write("/>");
            startingElement = false;
        } else {
            doIndentIfNeeded();
            write("</");
            write(localName);
            write(">");
        }
    }
    
    @Override
    public final void characters(char[] ch, int start, int length) throws SAXException {
        if (startingElement) {
            write(">");
        }
        startingElement = false;
        char c;
        for (int i = start; i < start + length; i++) {
            c = ch[i];
            // if ( mustEncodeCharachers() )
            // {
            // if ( c == '<' )
            // {
            // currentCharacters.append( LT );
            // }
            // else if ( c == '>' )
            // {
            // currentCharacters.append( GT );
            // }
            // else if ( c == '\'' )
            // {
            // currentCharacters.append( APOS );
            // }
            // else if ( c == '&' )
            // {
            // currentCharacters.append( AMP );
            // }
            // else
            // {
            // currentCharacters.append( c );
            // }
            // }
            // else
            // {
            currentCharacters.append(c);
            // }
            
        }
    }
    
    /**
     * 是否对字符进行编码
     *
     * @return true 是 flase 否
     */
    protected boolean mustEncodeCharachers() {
        return true;
    }
    
    /**
     * 存为字符集
     *
     * @param characters 字符串
     */
    protected void flushCharacters(String characters) {
        write(characters);
    }
    
    /**
     * 重置字符串
     *
     */
    protected void resetCharacters() {
        currentCharacters.setLength(0);
    }
    
    /**
     * 写入字符串
     *
     * @param content x
     */
    private void write(String content) {
        html.append(content);
        
        // try {
        // if (out != null) {
        // out.write(content.getBytes());
        // } else {
        // writer.write(content);
        // }
        // } catch (IOException e) {
        // throw new SAXException(e);
        // }
    }
    
    /**
     * @return 获取 html属性值
     */
    public String getHtml() {
        return html.toString();
    }
}
