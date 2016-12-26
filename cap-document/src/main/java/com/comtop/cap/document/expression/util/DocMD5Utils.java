/******************************************************************************
 * Copyright (C) 2015 ShenZhen ComTop Information Technology Co.,Ltd
 * All Rights Reserved.
 * 本软件为深圳康拓普开发研制。未经本公司正式书面同意，其他任何个人、团体不得使用、
 * 复制、修改或发布本软件.
 *****************************************************************************/

package com.comtop.cap.document.expression.util;

import com.comtop.cap.document.expression.annotation.Function;

/**
 * CAP文档管理，表达式函数，D5加密工具类
 *
 * @author 李小强
 * @since jdk1.6
 * @version 2015年11月19日 李小强
 */
public class DocMD5Utils {
    

    /** 属性S11 */
    protected static final int S11 = 7;
    
    /** 属性S12 */
    protected static final int S12 = 12;
    
    /** 属性S13 */
    protected static final int S13 = 17;
    
    /** 属性S14 */
    protected static final int S14 = 22;
    
    /** 属性S21 */
    protected static final int S21 = 5;
    
    /** 属性S22 */
    protected static final int S22 = 9;
    
    /** 属性S23 */
    protected static final int S23 = 14;
    
    /** 属性S24 */
    protected static final int S24 = 20;
    
    /** 属性S31 */
    protected static final int S31 = 4;
    
    /** 属性S32 */
    protected static final int S32 = 11;
    
    /** 属性S33 */
    protected static final int S33 = 16;
    
    /** 属性S34 */
    protected static final int S34 = 23;
    
    /** 属性S41 */
    protected static final int S41 = 6;
    
    /** 属性S42 */
    protected static final int S42 = 10;
    
    /** 属性S43 */
    protected static final int S43 = 15;
    
    /** 属性S44 */
    protected static final int S44 = 21;
    
    /** 属性PADDING */
    protected static final byte PADDING[] = { -128, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0,
        0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0,
        0, 0, 0, 0 };
    
    /** 属性state */
    private long[] state;
    
    /** 属性count */
    private long[] count;
    
    /** 属性buffer */
    private final byte[] buffer;
    
    /** 属性digestHexStr */
    private String digestHexStr;
    
    /** 属性digest */
    private final byte[] digest;
    
   
    /**
     * 构造函数
     */
    public DocMD5Utils() {
        state = new long[4];
        count = new long[2];
        buffer = new byte[64];
        digest = new byte[16];
        md5Init();
    }
    
    /**
     * 初始化函数，初始化核心变量
     */
    private void md5Init() {
        // 初始化部分变量
        count[0] = 0L;
        count[1] = 0L;
        state[0] = 0x67452301L;
        state[1] = 0xefcdab89L;
        state[2] = 0x98badcfeL;
        state[3] = 0x10325476L;
    }
    
    /**
     * 基本的MD5函数,F函数
     * 
     * @param l 长整型变量
     * @param l1 长整型变量
     * @param l2 长整型变量
     * @return 位运算后的结果
     */
    private long methodF(long l, long l1, long l2) {
        return l & l1 | ~l & l2;
    }
    
    /**
     * 基本的MD5函数,G函数
     * 
     * @param l 长整型变量
     * @param l1 长整型变量
     * @param l2 长整型变量
     * @return 位运算后的结果
     */
    private long methodG(long l, long l1, long l2) {
        return l & l2 | l1 & ~l2;
    }
    
    /**
     * 基本的MD5函数,H函数
     * 
     * @param l 长整型变量
     * @param l1 长整型变量
     * @param l2 长整型变量
     * @return 位运算后的结果
     */
    private long methodH(long l, long l1, long l2) {
        return l ^ l1 ^ l2;
    }
    
    /**
     * 基本的MD5函数,I函数
     * 
     * @param l 长整型变量
     * @param l1 长整型变量
     * @param l2 长整型变量
     * @return 位运算后的结果
     */
    private long methodI(long l, long l1, long l2) {
        return l1 ^ (l | ~l2);
    }
    
    /**
     * FF函数，调用F函数进行进一步变换
     * 
     * @param l 长整型变量
     * @param l1 长整型变量
     * @param l2 长整型变量
     * @param l3 长整型变量
     * @param l4 长整型变量
     * @param l5 长整型变量
     * @param l6 长整型变量
     * @return F函数进行进一步变换后的结果
     */
    private long methodFF(long l, long l1, long l2, long l3, long l4, long l5, long l6) {
        long lR = l + methodF(l1, l2, l3) + l4 + l6;
        // l += methodF(l1, l2, l3) + l4 + l6;
        lR = (int) lR << (int) l5 | (int) lR >>> (int) (32L - l5);
        lR += l1;
        return lR;
    }
    
    /**
     * GG函数，调用G函数进行进一步变换
     * 
     * @param l 长整型变量
     * @param l1 长整型变量
     * @param l2 长整型变量
     * @param l3 长整型变量
     * @param l4 长整型变量
     * @param l5 长整型变量
     * @param l6 长整型变量
     * @return G函数进行进一步变换后的结果
     */
    private long methodGG(long l, long l1, long l2, long l3, long l4, long l5, long l6) {
        long lR = l + methodG(l1, l2, l3) + l4 + l6;
        lR = (int) lR << (int) l5 | (int) lR >>> (int) (32L - l5);
        lR += l1;
        return lR;
    }
    
    /**
     * HH函数，调用H函数进行进一步变换
     * 
     * @param l 长整型变量
     * @param l1 长整型变量
     * @param l2 长整型变量
     * @param l3 长整型变量
     * @param l4 长整型变量
     * @param l5 长整型变量
     * @param l6 长整型变量
     * @return H函数进行进一步变换后的结果
     */
    private long methodHH(long l, long l1, long l2, long l3, long l4, long l5, long l6) {
        long lR = l + methodH(l1, l2, l3) + l4 + l6;
        lR = (int) lR << (int) l5 | (int) lR >>> (int) (32L - l5);
        lR += l1;
        return lR;
    }
    
    /**
     * II函数，调用I函数进行进一步变换
     * 
     * @param l 长整型变量
     * @param l1 长整型变量
     * @param l2 长整型变量
     * @param l3 长整型变量
     * @param l4 长整型变量
     * @param l5 长整型变量
     * @param l6 长整型变量
     * @return I函数进行进一步变换后的结果
     */
    private long methodII(long l, long l1, long l2, long l3, long l4, long l5, long l6) {
        long lR = l + methodI(l1, l2, l3) + l4 + l6;
        lR = (int) lR << (int) l5 | (int) lR >>> (int) (32L - l5);
        lR += l1;
        return lR;
    }
    
    /**
     * md5Update是MD5的主计算过程，由getMD5ofStr调用
     * 
     * @param abyte0 需要进行MD5加密的字符串
     * @param i int 字符串长度
     */
    private void md5Update(byte[] abyte0, int i) {
        byte byteA1[] = new byte[64];
        int k = (int) (count[0] >>> 3) & 0x3f;
        int iI = i << 3;
        count[0] += iI;
        if (count[0] < iI) {
            count[1]++;
        }
        count[1] += i >>> 29;
        int l = 64 - k;
        int j;
        if (i >= l) {
            md5Memcpy(buffer, abyte0, k, 0, l);
            md5Transform(buffer);
            for (j = l; j + 63 < i; j += 64) {
                md5Memcpy(byteA1, abyte0, 0, j, 64);
                md5Transform(byteA1);
            }
            k = 0;
        } else {
            j = 0;
        }
        md5Memcpy(buffer, abyte0, k, j, i - j);
    }
    
    /**
     * md5Final整理和填写输出结果
     */
    private void md5Final() {
        // 最终处理，将得到的128位（16字节）MD5码存放在digest数组中
        byte byteA0[] = new byte[8];
        methodEncode(byteA0, count, 8);
        int i = (int) (count[0] >>> 3) & 0x3f;
        int j = i >= 56 ? 120 - i : 56 - i;
        md5Update(PADDING, j);
        md5Update(byteA0, 8);
        methodEncode(digest, state, 16);
    }
    
    /**
     * md5Memcpy是一个内部使用的byte数组的块拷贝函数，从源数组abyte0的i开始把k长度的 字节拷贝到从j位置开始的目标byte数组abyte1
     * 
     * @param abyte0 目标byte数组
     * @param abyte1 源byte数组
     * @param i 目标数组的开始位置
     * @param j 源byte数组的开始位置
     * @param k 需要拷贝的字节长度
     */
    private void md5Memcpy(byte[] abyte0, byte[] abyte1, int i, int j, int k) {
        for (int l = 0; l < k; l++) {
            abyte0[i + l] = abyte1[j + l];
        }
    }
    
    /**
     * md5Transform是MD5核心变换程序，有md5Update调用
     * 
     * @param abyte0 分块的原始字节
     */
    private void md5Transform(byte[] abyte0) {
        long l = state[0];
        long lL1 = state[1];
        long lL2 = state[2];
        long lL3 = state[3];
        long lAl[] = new long[16];
        methodDecode(lAl, abyte0, 64);
        l = methodFF(l, lL1, lL2, lL3, lAl[0], 7L, 0xd76aa478L);
        lL3 = methodFF(lL3, l, lL1, lL2, lAl[1], 12L, 0xe8c7b756L);
        lL2 = methodFF(lL2, lL3, l, lL1, lAl[2], 17L, 0x242070dbL);
        lL1 = methodFF(lL1, lL2, lL3, l, lAl[3], 22L, 0xc1bdceeeL);
        l = methodFF(l, lL1, lL2, lL3, lAl[4], 7L, 0xf57c0fafL);
        lL3 = methodFF(lL3, l, lL1, lL2, lAl[5], 12L, 0x4787c62aL);
        lL2 = methodFF(lL2, lL3, l, lL1, lAl[6], 17L, 0xa8304613L);
        lL1 = methodFF(lL1, lL2, lL3, l, lAl[7], 22L, 0xfd469501L);
        l = methodFF(l, lL1, lL2, lL3, lAl[8], 7L, 0x698098d8L);
        lL3 = methodFF(lL3, l, lL1, lL2, lAl[9], 12L, 0x8b44f7afL);
        lL2 = methodFF(lL2, lL3, l, lL1, lAl[10], 17L, 0xffff5bb1L);
        lL1 = methodFF(lL1, lL2, lL3, l, lAl[11], 22L, 0x895cd7beL);
        l = methodFF(l, lL1, lL2, lL3, lAl[12], 7L, 0x6b901122L);
        lL3 = methodFF(lL3, l, lL1, lL2, lAl[13], 12L, 0xfd987193L);
        lL2 = methodFF(lL2, lL3, l, lL1, lAl[14], 17L, 0xa679438eL);
        lL1 = methodFF(lL1, lL2, lL3, l, lAl[15], 22L, 0x49b40821L);
        l = methodGG(l, lL1, lL2, lL3, lAl[1], 5L, 0xf61e2562L);
        lL3 = methodGG(lL3, l, lL1, lL2, lAl[6], 9L, 0xc040b340L);
        lL2 = methodGG(lL2, lL3, l, lL1, lAl[11], 14L, 0x265e5a51L);
        lL1 = methodGG(lL1, lL2, lL3, l, lAl[0], 20L, 0xe9b6c7aaL);
        l = methodGG(l, lL1, lL2, lL3, lAl[5], 5L, 0xd62f105dL);
        lL3 = methodGG(lL3, l, lL1, lL2, lAl[10], 9L, 0x2441453L);
        lL2 = methodGG(lL2, lL3, l, lL1, lAl[15], 14L, 0xd8a1e681L);
        lL1 = methodGG(lL1, lL2, lL3, l, lAl[4], 20L, 0xe7d3fbc8L);
        l = methodGG(l, lL1, lL2, lL3, lAl[9], 5L, 0x21e1cde6L);
        lL3 = methodGG(lL3, l, lL1, lL2, lAl[14], 9L, 0xc33707d6L);
        lL2 = methodGG(lL2, lL3, l, lL1, lAl[3], 14L, 0xf4d50d87L);
        lL1 = methodGG(lL1, lL2, lL3, l, lAl[8], 20L, 0x455a14edL);
        l = methodGG(l, lL1, lL2, lL3, lAl[13], 5L, 0xa9e3e905L);
        lL3 = methodGG(lL3, l, lL1, lL2, lAl[2], 9L, 0xfcefa3f8L);
        lL2 = methodGG(lL2, lL3, l, lL1, lAl[7], 14L, 0x676f02d9L);
        lL1 = methodGG(lL1, lL2, lL3, l, lAl[12], 20L, 0x8d2a4c8aL);
        l = methodHH(l, lL1, lL2, lL3, lAl[5], 4L, 0xfffa3942L);
        lL3 = methodHH(lL3, l, lL1, lL2, lAl[8], 11L, 0x8771f681L);
        lL2 = methodHH(lL2, lL3, l, lL1, lAl[11], 16L, 0x6d9d6122L);
        lL1 = methodHH(lL1, lL2, lL3, l, lAl[14], 23L, 0xfde5380cL);
        l = methodHH(l, lL1, lL2, lL3, lAl[1], 4L, 0xa4beea44L);
        lL3 = methodHH(lL3, l, lL1, lL2, lAl[4], 11L, 0x4bdecfa9L);
        lL2 = methodHH(lL2, lL3, l, lL1, lAl[7], 16L, 0xf6bb4b60L);
        lL1 = methodHH(lL1, lL2, lL3, l, lAl[10], 23L, 0xbebfbc70L);
        l = methodHH(l, lL1, lL2, lL3, lAl[13], 4L, 0x289b7ec6L);
        lL3 = methodHH(lL3, l, lL1, lL2, lAl[0], 11L, 0xeaa127faL);
        lL2 = methodHH(lL2, lL3, l, lL1, lAl[3], 16L, 0xd4ef3085L);
        lL1 = methodHH(lL1, lL2, lL3, l, lAl[6], 23L, 0x4881d05L);
        l = methodHH(l, lL1, lL2, lL3, lAl[9], 4L, 0xd9d4d039L);
        lL3 = methodHH(lL3, l, lL1, lL2, lAl[12], 11L, 0xe6db99e5L);
        lL2 = methodHH(lL2, lL3, l, lL1, lAl[15], 16L, 0x1fa27cf8L);
        lL1 = methodHH(lL1, lL2, lL3, l, lAl[2], 23L, 0xc4ac5665L);
        l = methodII(l, lL1, lL2, lL3, lAl[0], 6L, 0xf4292244L);
        lL3 = methodII(lL3, l, lL1, lL2, lAl[7], 10L, 0x432aff97L);
        lL2 = methodII(lL2, lL3, l, lL1, lAl[14], 15L, 0xab9423a7L);
        lL1 = methodII(lL1, lL2, lL3, l, lAl[5], 21L, 0xfc93a039L);
        l = methodII(l, lL1, lL2, lL3, lAl[12], 6L, 0x655b59c3L);
        lL3 = methodII(lL3, l, lL1, lL2, lAl[3], 10L, 0x8f0ccc92L);
        lL2 = methodII(lL2, lL3, l, lL1, lAl[10], 15L, 0xffeff47dL);
        lL1 = methodII(lL1, lL2, lL3, l, lAl[1], 21L, 0x85845dd1L);
        l = methodII(l, lL1, lL2, lL3, lAl[8], 6L, 0x6fa87e4fL);
        lL3 = methodII(lL3, l, lL1, lL2, lAl[15], 10L, 0xfe2ce6e0L);
        lL2 = methodII(lL2, lL3, l, lL1, lAl[6], 15L, 0xa3014314L);
        lL1 = methodII(lL1, lL2, lL3, l, lAl[13], 21L, 0x4e0811a1L);
        l = methodII(l, lL1, lL2, lL3, lAl[4], 6L, 0xf7537e82L);
        lL3 = methodII(lL3, l, lL1, lL2, lAl[11], 10L, 0xbd3af235L);
        lL2 = methodII(lL2, lL3, l, lL1, lAl[2], 15L, 0x2ad7d2bbL);
        lL1 = methodII(lL1, lL2, lL3, l, lAl[9], 21L, 0xeb86d391L);
        state[0] += l;
        state[1] += lL1;
        state[2] += lL2;
        state[3] += lL3;
    }
    
    /**
     * methodEncode将long数组按顺序拆成byte数组
     * 
     * @param abyte0 拆分后的byte数组
     * @param al 需要拆的long数组
     * @param i 长度
     */
    private void methodEncode(byte[] abyte0, long[] al, int i) {
        // 低位字节在前，高位字节在后；
        int j = 0;
        for (int k = 0; k < i; k += 4) {
            abyte0[k] = (byte) (int) (al[j] & 255L);
            abyte0[k + 1] = (byte) (int) (al[j] >>> 8 & 255L);
            abyte0[k + 2] = (byte) (int) (al[j] >>> 16 & 255L);
            abyte0[k + 3] = (byte) (int) (al[j] >>> 24 & 255L);
            j++;
        }
    }
    
    /**
     * methodDecode把byte数组按顺序合成成long数组，只合成低32bit，高32bit清零
     * 
     * @param al 需要合成的byte数组
     * @param abyte0 合成后的long数组
     * @param i 长度
     */
    private void methodDecode(long[] al, byte[] abyte0, int i) {
        int j = 0;
        for (int k = 0; k < i; k += 4) {
            al[j] = b2iu(abyte0[k]) | b2iu(abyte0[k + 1]) << 8 | b2iu(abyte0[k + 2]) << 16 | b2iu(abyte0[k + 3]) << 24;
            j++;
        }
    }
    
    /**
     * byte按照不考虑正负号的原则＂升位＂
     * 
     * @param byte0 字节
     * @return long型
     */
    public static long b2iu(byte byte0) {
        return byte0 >= 0 ? byte0 : byte0 & 0xff;
    }
    
    /**
     * 将字节转换成十六进制的ASCII表示
     * 
     * @param byte0 字节
     * @return 十六进制的ASCII表示
     */
    @Function(name = "MD5Utils_byteHEX", description = "将字节转换成十六进制的ASCII表示")
    public static String byteHEX(byte byte0) {
        char chAC[] = { '0', '1', '2', '3', '4', '5', '6', '7', '8', '9', 'A', 'B', 'C', 'D', 'E', 'F' };
        char chAC1[] = new char[2];
        chAC1[0] = chAC[byte0 >>> 4 & 0xf];
        chAC1[1] = chAC[byte0 & 0xf];
        String s = new String(chAC1);
        return s;
    }
    
    /**
     * 将字符串转换为MD5串的静态方法
     * 
     * @param s 需要转换的字符串
     * @return 转换后的MD5串
     */
    @Function(name = "MD5Utils_toMD5", description = "将字符串转换为MD5串的静态方法")
    public static String toMD5(String s) {
        DocMD5Utils objMD5 = new DocMD5Utils();
        return objMD5.getMD5ofStr(s);
    }
    /**
     * 将字符串转换为MD5串
     * 
     * @param s 要进行MD5变换的字符串
     * @return MD5串
     */
    private String getMD5ofStr(String s) {
        int i;
        md5Init();
        md5Update(s.getBytes(), s.length());
        md5Final();
        digestHexStr = "";
        for (i = 0; i < 16; i++) {
            digestHexStr = digestHexStr + byteHEX(digest[i]);
        }
        
        // 返回MD5串
        return digestHexStr;
    }
    
}
