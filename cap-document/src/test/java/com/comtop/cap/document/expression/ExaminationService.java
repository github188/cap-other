/******************************************************************************
 * Copyright (C) 2016 ShenZhen ComTop Information Technology Co.,Ltd
 * All Rights Reserved.
 * 本软件为深圳康拓普开发研制。未经本公司正式书面同意，其他任何个人、团体不得使用、
 * 复制、修改或发布本软件.
 *****************************************************************************/

package com.comtop.cap.document.expression;

import java.util.ArrayList;
import java.util.Arrays;
import java.util.List;

import org.apache.commons.lang.math.RandomUtils;

import com.comtop.cap.document.expression.annotation.DocumentService;

/**
 * 考试成绩服务
 *
 * @author lizhongwen
 * @since jdk1.6
 * @version 2016年1月8日 lizhongwen
 */
@DocumentService(name = "Examination", dataType = ExaminationVO.class)
public class ExaminationService {
    
    /** 业务对象 */
    static List<ExaminationVO> items;
    
    /** 姓名 */
    static String[] names = { "曹操", "曹丕", "曹睿", "曹芳", "曹髦", "曹奂", "曹仁", "曹洪", "曹纯", "曹真", "曹休", "曹爽", "曹植", "曹昂", "曹彰",
        "曹冲", "曹羲", "曹训", "曹彦", "夏侯渊", "夏侯敦", "夏侯茂", "夏侯衡", "夏侯霸", "夏侯称", "夏侯威", "夏侯荣", "夏侯惠", "夏侯和", "夏侯尚", "夏侯玄",
        "司马懿", "司马师", "司马昭", "钟会", "邓艾", "羊祜", "杜预", "王浚", "唐彬", "郭淮", "许褚", "典韦", "张辽", "臧霸", "鲜于辅", "徐质", "徐晃", "王基",
        "文聘", "张郃", "胡遵", "孙观", "吕虔", "乐进", "于禁", "朱灵", "车胄", "徐邈", "李通", "孙礼", "陈骞", "申仪", "申耽", "庞德", "庞会", "李典",
        "吕昭", "阎柔", "贾逵", "田豫", "秦朗", "王双", "前高览", "郭嘉", "贾诩", "蒋济", "满宠", "辛敞", "程昱", "钟繇", "华歆", "王朗", "王肃", "追贾充",
        "杜畿", "伯侯", "杜袭", "傅嘏", "毛玠", "杨彪", "刘劭", "山涛", "郭修", "王戎", "韩暨", "董昭", "陈矫", "荀攸", "荀彧", "荀顗", "温恢", "张既",
        "李立", "刘馥", "刘晔", "孔融", "孟建", "卫瓘", "陈登", "华表", "观阳伯", "杨济", "张华", "裴秀", "高堂隆", "蒯越", "杨阜", "李丰", "徐奕", "邢颙",
        "薛悌", "鲍勋", "冯紞", "许攸", "陈群", "陈泰", "何晏", "刘靖", "丁仪", "丁廙", "向秀", "管宁", "杨修", "刘桢", "傅干", "石韬", "蒋干", "管辂",
        "杜夔", "王粲", "徐干", "陈琳", "阮咸", "阮瑀", "阮籍", "应玚", "嵇康", "刘伶", "刘备", "刘禅", "刘永", "刘理", "刘谌", "诸葛亮", "庞统", "关羽",
        "张飞", "阆中牧", "赵云", "马超", "黄忠", "姜维", "魏延", "马岱", "关兴", "张苞", "关平", "廖化", "张翼", "王平", "陈到", "吴懿", "吴班", "李严",
        "胡济", "蒋斌", "诸葛瞻", "罗宪", "马忠", "李恢", "刘敏", "邓芝", "张嶷", "高翔", "辅匡", "阎宇", "句扶", "向宠", "刘琰", "赵统", "杨戏", "诸葛乔",
        "刘邕", "邓方", "霍弋", "李球", "赵累", "黄权", "傅佥", "刘封", "霍峻", "冯习", "张南", "刘巴", "吕乂", "黄崇", "张遵", "陈式", "严颜", "徐庶",
        "蒋琬", "费祎", "董厥", "陈祗", "李福", "法正", "宗预", "向朗", "王连", "费观", "孙乾", "简雍", "糜竺", "来敏", "伊籍", "杨洪", "张裔", "董允",
        "卫继", "李撰", "杨颙", "谯周", "张绍", "邓良", "郤正", "廖立", "王甫", "杨仪", "费诗", "杜微", "五梁", "刘豹", "向举", "尹默", "董和", "许靖",
        "马良", "王谋", "杜琼", "秦宓", "孟光", "许慈", "何宗", "韩冉", "周群", "陈震", "程畿", "樊建", "殷观", "陈寿", "孟达", "射援", "射坚", "李密",
        "吕凯", "庞宏", "王伉", "马谡", "彭羕", "黄皓", "孙权", "孙亮", "孙休", "孙皓", "孙坚", "孙策", "孙和", "孙邵", "孙峻", "顾雍", "陆逊", "步鹭",
        "滕胤", "张悌", "周瑜", "鲁肃", "吕蒙", "孙韶", "孙桓", "孙静", "孙瑜", "孙皎", "孙贲", "孙翊", "朱然", "全琮", "程普", "甘宁", "周泰", "蒋钦",
        "丁奉", "徐盛", "潘璋", "诸葛靓", "留赞", "施绩", "吕岱", "朱治", "鲁淑", "虞汜", "贺齐", "张承", "钟离牧", "太史慈", "韩当", "沈莹", "黄盖", "祖茂",
        "凌统", "董袭", "陈武", "吕范", "步阐", "步玑", "楼玄", "张昭", "张休", "华核", "胡综", "陆抗", "阚泽", "是仪", "桓阶", "全尚", "潘浚", "顾谭",
        "士燮", "朱据", "陆景", "骆统", "严畯", "诸葛诞", "诸葛瑾", "诸葛恪", "陆绩", "张纮", "张温", "虞翻", "刘基", "程秉", "薛综", "吾粲", "刘协", "袁绍",
        "袁术", "刘表", "刘璋", "马腾", "吕布", "公孙瓒", "张绣", "张鲁", "张燕", "张杨", "陶谦", "刘繇", "刘虞", "刘岱", "鲍信", "韩馥", "公孙度", "公孙恭",
        "公孙渊", "韩遂", "孔伷", "董卓", "张邈", "卢植", "何进", "朱皓", "王允", "皇甫嵩", "颜良", "文丑", "审配", "逢纪", "田丰", "沮授", "蔡瑁", "祢衡",
        "诸葛玄", "许劭", "刘焉", "王累", "张任", "张松", "马铁", "马休", "严象", "郑泰", "田楷", "单经", "严纲", "张闿", "董旻", "李傕", "华雄", "李儒",
        "蔡邕", "陈宫", "张角", "张宝", "张梁", "华佗", "董奉", "张机", "陈翔", "范滂", "孔昱", "范康", "檀敷", "张俭", "岑晊", "皇甫谧", "左慈", "黄承彦",
        "司马徽", "孟获", "沙摩柯", "轲比能", "楼班", "强端", "难升米", "蹋顿" };
    
    /** 科目 */
    static String[] courses = { "chinese", "english", "politics", "history", "geography", "math", "physics",
        "organisms", "chemistry" };
    
    /** 科目 */
    static String[] courseNames = { "语文", "英语", "政治", "历史", "地理", "数学", "物理", "生物", "化学" };
    
    /** 科目 */
    static String[] branchs = { "liberal", "liberal", "liberal", "liberal", "liberal", "science", "science", "science",
        "science" };
    
    /** 科目 */
    static String[] branchNames = { "文科", "文科", "文科", "文科", "文科", "理科", "理科", "理科", "理科" };
    
    static {
        items = new ArrayList<ExaminationVO>();
        generateData();
    }
    
    /**
     * 根据条件加载VO
     *
     * @param param 条件
     * @return vos
     */
    public List<ExaminationVO> loadExaminationList(ExaminationVO param) {
        int start = param.getStart();
        int end = param.getEnd();
        if (start < 0) {
            start = 0;
        }
        if (end <= start) {
            end = start + 10;
        }
        return items.subList(start, end);
    }
    
    /**
     * 根据条件加载VO
     *
     * @param vos 数据
     */
    public void saveExaminationList(List<ExaminationVO> vos) {
        System.out.println(Arrays.toString(items.toArray()));
    }
    
    /**
     * 生成数据
     *
     */
    private static void generateData() {
        ExaminationVO vo;
        ScoreVO sv;
        for (String name : names) {
            vo = new ExaminationVO();
            vo.setName(name);
            vo.setClazz((RandomUtils.nextInt(10) + 1) + "班");
            int total = 0;
            int index = 0;
            for (String course : courses) {
                int score = RandomUtils.nextInt(100) + 1;
                sv = new ScoreVO(course, courseNames[index], branchs[index], branchNames[index], score);
                vo.addScore(course, score);
                vo.addScore(sv);
                total += score;
                index++;
            }
            vo.setTotal(total);
            items.add(vo);
        }
    }
}
