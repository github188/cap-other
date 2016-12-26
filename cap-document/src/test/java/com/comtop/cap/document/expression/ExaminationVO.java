/******************************************************************************
 * Copyright (C) 2016 ShenZhen ComTop Information Technology Co.,Ltd
 * All Rights Reserved.
 * 本软件为深圳康拓普开发研制。未经本公司正式书面同意，其他任何个人、团体不得使用、
 * 复制、修改或发布本软件.
 *****************************************************************************/

package com.comtop.cap.document.expression;

import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

/**
 * 考试成绩VO
 *
 * @author lizhongwen
 * @since jdk1.6
 * @version 2016年1月8日 lizhongwen
 */
public class ExaminationVO {
    
    /** 姓名 */
    private String name;
    
    /** 班级 */
    private String clazz;
    
    /** 成绩 */
    private Map<String, Integer> scores;
    
    /** 成绩 */
    private List<ScoreVO> scoreList;
    
    /** 总成绩 */
    private Integer total;
    
    /** 分页开始 */
    private int start;
    
    /** 分页结束 */
    private int end;
    
    /**
     * @return 获取 name属性值
     */
    public String getName() {
        return name;
    }
    
    /**
     * @param name 设置 name 属性值为参数值 name
     */
    public void setName(String name) {
        this.name = name;
    }
    
    /**
     * @return 获取 clazz属性值
     */
    public String getClazz() {
        return clazz;
    }
    
    /**
     * @param clazz 设置 clazz 属性值为参数值 clazz
     */
    public void setClazz(String clazz) {
        this.clazz = clazz;
    }
    
    /**
     * @return 获取 scores属性值
     */
    public Map<String, Integer> getScores() {
        return scores;
    }
    
    /**
     * @param scores 设置 scores 属性值为参数值 scores
     */
    public void setScores(Map<String, Integer> scores) {
        this.scores = scores;
    }
    
    /**
     * @param course 科目
     * @param score 成绩
     * 
     */
    public void addScore(String course, Integer score) {
        if (this.scores == null) {
            this.scores = new HashMap<String, Integer>();
        }
        this.scores.put(course, score);
    }
    
    /**
     * @return 获取 total属性值
     */
    public Integer getTotal() {
        return total;
    }
    
    /**
     * @param total 设置 total 属性值为参数值 total
     */
    public void setTotal(Integer total) {
        this.total = total;
    }
    
    /**
     * @return 获取 start属性值
     */
    public int getStart() {
        return start;
    }
    
    /**
     * @param start 设置 start 属性值为参数值 start
     */
    public void setStart(int start) {
        this.start = start;
    }
    
    /**
     * @return 获取 end属性值
     */
    public int getEnd() {
        return end;
    }
    
    /**
     * @param end 设置 end 属性值为参数值 end
     */
    public void setEnd(int end) {
        this.end = end;
    }
    
    /**
     * @return 获取 scoreList属性值
     */
    public List<ScoreVO> getScoreList() {
        return scoreList;
    }
    
    /**
     * @param scoreList 设置 scoreList 属性值为参数值 scoreList
     */
    public void setScoreList(List<ScoreVO> scoreList) {
        this.scoreList = scoreList;
    }
    
    /**
     * @param score 添加一个成绩对象
     */
    public void addScore(ScoreVO score) {
        if (this.scoreList == null) {
            this.scoreList = new ArrayList<ScoreVO>();
        }
        this.scoreList.add(score);
    }
    
}
