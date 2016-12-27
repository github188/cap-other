package com.comtop.cap.bm.metadata.page.external;

import java.text.SimpleDateFormat;

import org.apache.commons.jxpath.ExpressionContext;
import org.apache.commons.jxpath.Pointer;

import com.comtop.cap.bm.metadata.page.external.XpathTest.Book;

/**
 * @author yangsai
 *
 */
public class Formats {
	
    /**
     * @param context c
     * @param pattern p
     * @return string x
     */
    public static boolean date(ExpressionContext context, String pattern){
    	Pointer pointer = context.getContextNodePointer();
        if (pointer == null){
          return false;
        }
        
        if(((Book)pointer.getValue()).getTitle() == "c++") {
        	return true;
        }
        
        System.out.println(new SimpleDateFormat(pattern).format(((Book)pointer.getValue()).getDate()));
        return false;
    }
    
    /**
     * @param context c
     * @param pattern p
     * @return string x
     */
    public static boolean isC(ExpressionContext context, String pattern){
    	Pointer pointer = context.getContextNodePointer();
        if (pointer == null){
          return false;
        }
        
        if(((Book)pointer.getValue()).getTitle() == "c") {
        	return true;
        }
        
        System.out.println("not c");
        return false;
    }
 }
