
package com.comtop.cap.bm.util;

import java.io.File;

import org.apache.commons.io.FileUtils;

/**
 * 
 * 文件操作类
 *
 * @author 诸焕辉
 * @since jdk1.6
 * @version 2016年5月3日 诸焕辉
 */
public class CapFileUtils extends FileUtils {
    
    /**
     * 删除空目录
     *
     * @param path 文件路径
     * @return 是否成功
     */
    public static boolean deleteEmptyDir(String path) {
        boolean bResult = true;
        File objFile = new File(path);
        if (objFile.exists()) {
            if (objFile.isDirectory()) {
                File[] objFiles = objFile.listFiles();
                if (objFiles != null && objFiles.length > 0) {
                    for (File objSubFile : objFiles) {
                        if (objSubFile.isDirectory()) {
                            deleteEmptyDir(objSubFile.getPath());
                        }
                    }
                } else {
                    bResult = objFile.delete();
                }
                // 已没有子目录，则把自身目录删除
                objFiles = objFile.listFiles();
                if (objFiles == null || objFiles.length == 0) {
                    bResult = objFile.delete();
                }
            }
        }
        return bResult;
    }
}
