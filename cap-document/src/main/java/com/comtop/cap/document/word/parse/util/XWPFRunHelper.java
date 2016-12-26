/******************************************************************************
 * Copyright (C) 2015 ShenZhen ComTop Information Technology Co.,Ltd
 * All Rights Reserved.
 * 本软件为深圳康拓普开发研制。未经本公司正式书面同意，其他任何个人、团体不得使用、
 * 复制、修改或发布本软件.
 *****************************************************************************/

package com.comtop.cap.document.word.parse.util;

import java.util.List;

import org.apache.commons.lang.StringUtils;
import org.openxmlformats.schemas.wordprocessingml.x2006.main.CTBr;
import org.openxmlformats.schemas.wordprocessingml.x2006.main.CTFldChar;
import org.openxmlformats.schemas.wordprocessingml.x2006.main.CTR;
import org.openxmlformats.schemas.wordprocessingml.x2006.main.CTText;
import org.openxmlformats.schemas.wordprocessingml.x2006.main.STBrType;
import org.openxmlformats.schemas.wordprocessingml.x2006.main.STFldCharType;

/**
 * 
 * XWPFRun帮助类。本类的代码拷贝自第三方的实现，拷贝的目的在于不引第三方的jar包
 *
 * @author lizhiyong
 * @since jdk1.6
 * @version 2016年2月16日 lizhiyong
 */
public class XWPFRunHelper {
    
    /** page */
    private static final String PAGE = "page";
    
    /** numpages */
    private static final String NUMPAGES = "numpages";
    
    /** page */
    private static final String PAGE_AND_SPACE = "page ";
    
    /** HYPERLINK */
    private static final String HYPERLINK = "HYPERLINK";
    
    /** \" */
    private static final String QUOTE = "\"";
    
    /**
     * Returns the fldChar of the given run and null otherwise.
     * <p>
     * <w:r> <w:rPr /> <w:fldChar w:fldCharType="begin" /> </w:r>
     * </p>
     * 
     * @param r r
     * @return CTFldChar
     */
    public static CTFldChar getFldChar(CTR r) {
        List<CTFldChar> fldChars = r.getFldCharList();
        if (fldChars == null || fldChars.size() < 1) {
            return null;
        }
        return fldChars.get(0);
    }
    
    /**
     * Returns the fldCharType of the given run and null otherwise.
     * <p>
     * <w:r> <w:rPr /> <w:fldChar w:fldCharType="begin" /> </w:r>
     * </p>
     * 
     * @param r r
     * @return STFldCharType
     */
    public static STFldCharType.Enum getFldCharType(CTR r) {
        CTFldChar fldChar = getFldChar(r);
        if (fldChar == null) {
            return null;
        }
        return fldChar.getFldCharType();
    }
    
    /**
     * Returns the instr text of the given run and null otherwise.
     * 
     * @param r r
     * @return String
     */
    public static String getInstrText(CTR r) {
        List<CTText> instrTextList = r.getInstrTextList();
        if (instrTextList == null || instrTextList.size() < 1) {
            return null;
        }
        if (instrTextList.size() == 1) {
            return instrTextList.get(0).getStringValue();
        }
        
        StringBuilder instrText = new StringBuilder();
        for (CTText ctText : instrTextList) {
            instrText.append(ctText.getStringValue());
        }
        return instrText.toString();
    }
    
    /**
     * Returns true if the given instr is PAGE and false otherwise.
     * 
     * @param instr instr
     * @return boolean
     */
    public static boolean isInstrTextPage(String instr) {
        if (StringUtils.isEmpty(instr)) {
            return false;
        }
        String strInstr = instr;
        strInstr = strInstr.trim().toLowerCase();
        return strInstr.equals(PAGE) || strInstr.startsWith(PAGE_AND_SPACE);
    }
    
    /**
     * Returns the hyperlink of teh given instr and null otehrwise.
     * <p>
     * <w:instrText>HYPERLINK "http://code.google.com/p/xdocreport"</w:instrText>
     * </p>
     * 
     * @param instr instr
     * @return String
     */
    public static String getInstrTextHyperlink(String instr) {
        if (StringUtils.isEmpty(instr)) {
            return null;
        }
        String strInstr = instr;
        strInstr = strInstr.trim();
        // test if it's <w:instrText>HYPERLINK "http://code.google.com/p/xdocreport"</w:instrText>
        if (strInstr.startsWith(HYPERLINK)) {
            strInstr = strInstr.substring(HYPERLINK.length(), strInstr.length());
            strInstr = strInstr.trim();
            if (strInstr.startsWith(QUOTE)) {
                strInstr = strInstr.substring(1, strInstr.length());
            }
            if (strInstr.endsWith(QUOTE)) {
                strInstr = strInstr.substring(0, strInstr.length() - 1);
            }
            return strInstr;
        }
        return null;
    }
    
    /**
     * Returns the br type;
     * 
     * @param br br
     * @return STBrType
     */
    public static STBrType.Enum getBrType(CTBr br) {
        if (br != null) {
            STBrType.Enum brType = br.getType();
            if (brType != null) {
                return brType;
            }
        }
        return STBrType.TEXT_WRAPPING;
    }
    
    /**
     * Returns true if the given instr is PAGE and false otherwise.
     * 
     * @param instr instr
     * @return boolean
     */
    public static boolean isInstrTextNumpages(String instr) {
        if (StringUtils.isEmpty(instr)) {
            return false;
        }
        String strInstr = instr;
        strInstr = strInstr.trim().toLowerCase();
        return strInstr.startsWith(NUMPAGES);
    }
}
