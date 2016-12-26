/******************************************************************************
 * Copyright (C) 2015 ShenZhen ComTop Information Technology Co.,Ltd
 * All Rights Reserved.
 * 本软件为深圳康拓普开发研制。未经本公司正式书面同意，其他任何个人、团体不得使用、
 * 复制、修改或发布本软件.
 *****************************************************************************/

package com.comtop.cap.document.util;

import java.io.ByteArrayInputStream;
import java.io.ByteArrayOutputStream;
import java.io.ObjectInputStream;
import java.io.ObjectOutputStream;
import java.util.Arrays;

/**
 * 对象工具类
 *
 * @author lizhongwen
 * @since jdk1.6
 * @version 2015年11月10日 lizhongwen
 */
public final class ObjectUtils {
    
    /**
     * 比较两个对象是否相等
     *
     * @param o1 对象1
     * @param o2 对象2
     * @return 是否相等
     */
    public static boolean nullSafeEquals(Object o1, Object o2) {
        if (o1 == o2) {
            return true;
        }
        if (o1 == null || o2 == null) {
            return false;
        }
        if (o1.equals(o2)) {
            return true;
        }
        if (o1.getClass().isArray() && o2.getClass().isArray()) {
            if (o1 instanceof Object[] && o2 instanceof Object[]) {
                return Arrays.equals((Object[]) o1, (Object[]) o2);
            }
            if (o1 instanceof boolean[] && o2 instanceof boolean[]) {
                return Arrays.equals((boolean[]) o1, (boolean[]) o2);
            }
            if (o1 instanceof byte[] && o2 instanceof byte[]) {
                return Arrays.equals((byte[]) o1, (byte[]) o2);
            }
            if (o1 instanceof char[] && o2 instanceof char[]) {
                return Arrays.equals((char[]) o1, (char[]) o2);
            }
            if (o1 instanceof double[] && o2 instanceof double[]) {
                return Arrays.equals((double[]) o1, (double[]) o2);
            }
            if (o1 instanceof float[] && o2 instanceof float[]) {
                return Arrays.equals((float[]) o1, (float[]) o2);
            }
            if (o1 instanceof int[] && o2 instanceof int[]) {
                return Arrays.equals((int[]) o1, (int[]) o2);
            }
            if (o1 instanceof long[] && o2 instanceof long[]) {
                return Arrays.equals((long[]) o1, (long[]) o2);
            }
            if (o1 instanceof short[] && o2 instanceof short[]) {
                return Arrays.equals((short[]) o1, (short[]) o2);
            }
        }
        return false;
    }
    
    /**
     * 深度复制
     *
     * @param src 源对象
     * @return 复制对象
     */
    public static Object deepClone(Object src) {
        try {
            ByteArrayOutputStream baos = new ByteArrayOutputStream();
            ObjectOutputStream oos = new ObjectOutputStream(baos);
            oos.writeObject(src);
            ByteArrayInputStream bais = new ByteArrayInputStream(baos.toByteArray());
            ObjectInputStream ois = new ObjectInputStream(bais);
            return ois.readObject();
        } catch (Exception e) {
            e.printStackTrace();
            return null;
        }
    }
    
    /**
     * 
     * 对象转换为字符串
     *
     * @param obj 对象
     * @return 字符串
     */
    public static String objectToString(Object obj) {
        if (obj == null) {
            return "";
        }
        return String.valueOf(obj);
    }
    
    /**
     * 清理文本
     *
     * @param text 文本
     * @return 清理后的文本
     */
    public static String clean(final String text) {
        String result = text.trim();
        if (result.startsWith("\r")) {
            result = result.substring(2);
            clean(result);
        } else if (result.startsWith("\n")) {
            result = result.substring(2);
            clean(result);
        } else if (result.startsWith("\t")) {
            result = result.substring(2);
            clean(result);
        } else if (result.endsWith("\r") && result.length() > 2) {
            result = result.substring(0, result.length() - 2);
            clean(result);
        } else if (result.endsWith("\n") && result.length() > 2) {
            result = result.substring(0, result.length() - 2);
            clean(result);
        } else if (result.endsWith("\t") && result.length() > 2) {
            result = result.substring(0, result.length() - 2);
            clean(result);
        }
        return result;
    }
    
}
