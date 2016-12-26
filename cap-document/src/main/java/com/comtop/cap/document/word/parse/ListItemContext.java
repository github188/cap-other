/******************************************************************************
 * Copyright (C) 2015 ShenZhen ComTop Information Technology Co.,Ltd
 * All Rights Reserved.
 * 本软件为深圳康拓普开发研制。未经本公司正式书面同意，其他任何个人、团体不得使用、
 * 复制、修改或发布本软件.
 *****************************************************************************/

package com.comtop.cap.document.word.parse;

import java.math.BigInteger;
import java.util.ArrayList;
import java.util.List;

import org.openxmlformats.schemas.wordprocessingml.x2006.main.CTDecimalNumber;
import org.openxmlformats.schemas.wordprocessingml.x2006.main.CTLvl;
import org.openxmlformats.schemas.wordprocessingml.x2006.main.CTNumFmt;
import org.openxmlformats.schemas.wordprocessingml.x2006.main.STNumberFormat;

/**
 * 列表项上下文
 *
 * @author lizhiyong
 * @since jdk1.6
 * @version 2015年10月23日 lizhiyong
 */
public class ListItemContext {
    
    /** 开始索引 */
    private int startIndex = 0;
    
    /** nb */
    private int nb = 0;
    
    /** 编号 */
    private final int number;
    
    /** 层级 */
    private final CTLvl lvl;
    
    /** 上级 */
    private final ListItemContext parent;
    
    /** 编号文本 */
    private final String numberText;
    
    /**
     * 构造函数
     * 
     * @param lvl lvl
     * @param number number
     * @param parent parent
     */
    public ListItemContext(CTLvl lvl, int number, ListItemContext parent) {
        this.lvl = lvl;
        this.parent = parent;
        this.startIndex = 0;
        if (lvl != null) {
            CTDecimalNumber start = lvl.getStart();
            if (start != null) {
                BigInteger val = start.getVal();
                if (val != null) {
                    this.startIndex = val.intValue();
                }
            }
        }
        this.nb = 0;
        this.number = number + startIndex;
        if (lvl != null) {
            CTNumFmt numFmt = lvl.getNumFmt();
            this.numberText = computeNumberText(this.number, numFmt != null ? numFmt.getVal() : null);
        } else {
            this.numberText = null;
        }
    }
    
    /**
     * @return 获取 startIndex属性值
     */
    public int getStartIndex() {
        return startIndex;
    }
    
    /**
     * @param startIndex 设置 startIndex 属性值为参数值 startIndex
     */
    public void setStartIndex(int startIndex) {
        this.startIndex = startIndex;
    }
    
    /**
     * @return 获取 nb属性值
     */
    public int getNb() {
        return nb;
    }
    
    /**
     * @param nb 设置 nb 属性值为参数值 nb
     */
    public void setNb(int nb) {
        this.nb = nb;
    }
    
    /**
     * @return 获取 number属性值
     */
    public int getNumber() {
        return number;
    }
    
    /**
     * @return 获取 lvl属性值
     */
    public CTLvl getLvl() {
        return lvl;
    }
    
    /**
     * @return 获取 parent属性值
     */
    public ListItemContext getParent() {
        return parent;
    }
    
    /**
     * @return 获取 numberText属性值
     */
    public String getNumberText() {
        return numberText;
    }
    
    /**
     * 计算编号 文本
     *
     * @param number number
     * @param numFmt numFmt
     * @return String
     */
    private static String computeNumberText(int number, STNumberFormat.Enum numFmt) {
        if (STNumberFormat.LOWER_LETTER.equals(numFmt)) {
            return RomanAlphabetFactory.getLowerCaseString(number);
        } else if (STNumberFormat.UPPER_LETTER.equals(numFmt)) {
            return RomanAlphabetFactory.getUpperCaseString(number);
        } else if (STNumberFormat.LOWER_ROMAN.equals(numFmt)) {
            return RomanNumberFactory.getLowerCaseString(number);
        } else if (STNumberFormat.UPPER_ROMAN.equals(numFmt)) {
            return RomanNumberFactory.getUpperCaseString(number);
        }
        return String.valueOf(number);
    }
    
    /**
     * 创建并添加列表项
     *
     * @param lvl1 lvl1
     * @return ListItemContext
     */
    public ListItemContext createAndAddItem(CTLvl lvl1) {
        return new ListItemContext(lvl1, nb++, this);
    }
    
    /**
     * 是否是根
     *
     * @return boolean
     */
    public boolean isRoot() {
        return false;
    }
    
    /**
     * 获得文本
     *
     * @return String
     */
    public String getText() {
        String text = lvl.getLvlText().getVal();
        
        CTNumFmt numFmt = lvl.getNumFmt();
        if (STNumberFormat.BULLET.equals(numFmt)) {
            //
        } else {
            List<String> numbers = new ArrayList<String>();
            ListItemContext item = this;
            while (!item.isRoot()) {
                numbers.add(0, item.getNumberText());
                item = item.getParent();
            }
            String number1 = null;
            for (int i = 0; i < numbers.size(); i++) {
                number1 = numbers.get(i);
                text = replaceAll(text, "%" + (i + startIndex), number1);
            }
        }
        return text;
    }
    
    /**
     * 替换
     *
     * @param line line
     * @param oldString oldString
     * @param newString newString
     * @return String
     */
    public static final String replaceAll(String line, String oldString, String newString) {
        int i = 0;
        if ((i = line.indexOf(oldString, i)) >= 0) {
            char line2[] = line.toCharArray();
            char newString2[] = newString.toCharArray();
            int oLength = oldString.length();
            StringBuilder buf = new StringBuilder(line2.length);
            buf.append(line2, 0, i).append(newString2);
            i += oLength;
            int j;
            for (j = i; (i = line.indexOf(oldString, i)) > 0; j = i) {
                buf.append(line2, j, i - j).append(newString2);
                i += oLength;
            }
            
            buf.append(line2, j, line2.length - j);
            return buf.toString();
        }
        return line;
    }
    
    /**
     * This class can produce String combinations representing a number.
     * "a" to "z" represent 1 to 26, "AA" represents 27, "AB" represents 28,
     * and so on; "ZZ" is followed by "AAA".
     */
    public static class RomanAlphabetFactory {
        
        /**
         * Translates a positive integer (not equal to zero)
         * into a String using the letters 'a' to 'z';
         * 1 = a, 2 = b, ..., 26 = z, 27 = aa, 28 = ab,...
         * 
         * @param index index
         * @return String
         */
        public static final String getString(int index) {
            if (index < 1)
                throw new NumberFormatException("You can't translate a negative number into an alphabetical value.");
            int iIndex = index;
            iIndex--;
            int bytes = 1;
            int start = 0;
            int symbols = 26;
            while (iIndex >= symbols + start) {
                bytes++;
                start += symbols;
                symbols *= 26;
            }
            
            int c = iIndex - start;
            char[] value = new char[bytes];
            while (bytes > 0) {
                value[--bytes] = (char) ('a' + (c % 26));
                c /= 26;
            }
            
            return new String(value);
        }
        
        /**
         * Translates a positive integer (not equal to zero)
         * into a String using the letters 'a' to 'z';
         * 1 = a, 2 = b, ..., 26 = z, 27 = aa, 28 = ab,...
         * 
         * @param index index
         * @return @return
         */
        public static final String getLowerCaseString(int index) {
            return getString(index);
        }
        
        /**
         * Translates a positive integer (not equal to zero)
         * into a String using the letters 'A' to 'Z';
         * 1 = A, 2 = B, ..., 26 = Z, 27 = AA, 28 = AB,...
         * 
         * @param index index
         * @return @return
         */
        public static final String getUpperCaseString(int index) {
            return getString(index).toUpperCase();
        }
        
        /**
         * Translates a positive integer (not equal to zero)
         * into a String using the letters 'a' to 'z'
         * (a = 1, b = 2, ..., z = 26, aa = 27, ab = 28,...).
         * 
         * @param index String
         * @param lowercase lowercase
         * @return String
         */
        public static final String getString(int index, boolean lowercase) {
            if (lowercase) {
                return getLowerCaseString(index);
            }
            return getUpperCaseString(index);
        }
    }
    
    /**
     * Helper class for Roman Digits
     */
    private static class RomanDigit {
        
        /** part of a roman number */
        public char digit;
        
        /** value of the roman digit */
        public int value;
        
        /** can the digit be used as a prefix */
        public boolean pre;
        
        /**
         * Constructs a roman digit
         * 
         * @param digit the roman digit
         * @param value the value
         * @param pre can it be used as a prefix
         */
        RomanDigit(char digit, int value, boolean pre) {
            this.digit = digit;
            this.value = value;
            this.pre = pre;
        }
    }
    
    /**
     * This class can produce String combinations representing a roman number.
     */
    public static class RomanNumberFactory {
        
        /**
         * Array with Roman digits.
         */
        private static final RomanDigit[] roman = { new RomanDigit('m', 1000, false), new RomanDigit('d', 500, false),
            new RomanDigit('c', 100, true), new RomanDigit('l', 50, false), new RomanDigit('x', 10, true),
            new RomanDigit('v', 5, false), new RomanDigit('i', 1, true) };
        
        /**
         * Changes an int into a lower case roman number.
         * 
         * @param index the original number
         * @return the roman number (lower case)
         */
        public static final String getString(int index) {
            StringBuffer buf = new StringBuffer();
            int iIndex = index;
            // lower than 0 ? Add minus
            if (iIndex < 0) {
                buf.append('-');
                iIndex = -iIndex;
            }
            
            // greater than 3000
            if (iIndex > 3000) {
                buf.append('|');
                buf.append(getString(iIndex / 1000));
                buf.append('|');
                // remainder
                iIndex = iIndex - (iIndex / 1000) * 1000;
            }
            
            // number between 1 and 3000
            int pos = 0;
            while (true) {
                // loop over the array with values for m-d-c-l-x-v-i
                RomanDigit dig = roman[pos];
                // adding as many digits as we can
                while (iIndex >= dig.value) {
                    buf.append(dig.digit);
                    iIndex -= dig.value;
                }
                // we have the complete number
                if (iIndex <= 0) {
                    break;
                }
                // look for the next digit that can be used in a special way
                int j = pos;
                while (!roman[++j].pre) {
                    //
                }
                
                // does the special notation apply?
                if (iIndex + roman[j].value >= dig.value) {
                    buf.append(roman[j].digit).append(dig.digit);
                    iIndex -= dig.value - roman[j].value;
                }
                pos++;
            }
            return buf.toString();
        }
        
        /**
         * Changes an int into a lower case roman number.
         * 
         * @param index the original number
         * @return the roman number (lower case)
         */
        public static final String getLowerCaseString(int index) {
            return getString(index);
        }
        
        /**
         * Changes an int into an upper case roman number.
         * 
         * @param index the original number
         * @return the roman number (lower case)
         */
        public static final String getUpperCaseString(int index) {
            return getString(index).toUpperCase();
        }
        
        /**
         * Changes an int into a roman number.
         * 
         * @param index the original number
         * @param lowercase lowercase
         * @return the roman number (lower case)
         */
        public static final String getString(int index, boolean lowercase) {
            if (lowercase) {
                return getLowerCaseString(index);
            }
            return getUpperCaseString(index);
        }
    }
    
}
