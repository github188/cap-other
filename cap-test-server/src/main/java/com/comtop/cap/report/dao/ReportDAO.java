
package com.comtop.cap.report.dao;

import java.io.File;
import java.io.FileInputStream;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.sql.Timestamp;
import java.text.SimpleDateFormat;
import java.time.Instant;
import java.util.ArrayList;
import java.util.Calendar;
import java.util.Date;
import java.util.HashMap;
import java.util.List;
import java.util.Map;
import java.util.UUID;

import javax.xml.bind.JAXBContext;
import javax.xml.bind.Unmarshaller;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.jdbc.core.BatchPreparedStatementSetter;
import org.springframework.jdbc.core.JdbcTemplate;
import org.springframework.jdbc.core.RowMapper;
import org.springframework.stereotype.Service;
import org.springframework.util.StringUtils;

import com.comtop.cap.report.domain.Module;
import com.comtop.cap.report.domain.ResultType;
import com.comtop.cap.report.domain.Robot;
import com.comtop.cap.report.domain.Status;
import com.comtop.cap.report.domain.Suite;
import com.comtop.cap.report.domain.Test;
import com.comtop.cap.report.domain.TestResult;

/**
 *
 * @author 章尊志
 * @since jdk1.6
 * @version 2016年12月15日 章尊志
 */
@Service
public class ReportDAO {
    
    /** 时间格式化 */
    private static final SimpleDateFormat FORMATTER = new SimpleDateFormat("yyyyMMdd");
    
    /** JDBC模板 */
    @Autowired
    protected JdbcTemplate jdbc;
    
    /** 测试用例根目录 */
    @Value("${ftp.home}")
    private String home;
    
    /** 测试报告目录 */
    private static final String LOGS_HOME = "testcase-logs";
    
    /** SQL */
    @Autowired
    protected Map<String, String> sqlMap;
    
    /**
     * @param condition 查询条件
     * @return 按周获取测试结果统计
     */
    public List<TestResult> queryTestResultStatisticsByWeek(TestResult condition) {
        Date startTime = trim(condition.getStartTime());
        Date endTime = end(condition.getEndTime());
        String strStartTime = FORMATTER.format(startTime);
        String strEndTime = FORMATTER.format(endTime);
        Object[] strArr = { strStartTime, strEndTime, startTime, endTime };
        List<TestResult> lstResults = jdbc.query(sqlMap.get("QUERY_TEST_RESULT_BY_WEEK"), strArr,
            new RowMapper<TestResult>() {
                
                @Override
                public TestResult mapRow(ResultSet rs, int rowNum) throws SQLException {
                    TestResult objTestResult = new TestResult();
                    objTestResult.setAxisName(rs.getString(1));
                    objTestResult.setStartTime(rs.getDate(2));
                    objTestResult.setEndTime(rs.getDate(3));
                    objTestResult.setPassCount(rs.getInt(4));
                    objTestResult.setFailCount(rs.getInt(5));
                    return objTestResult;
                }
                
            });
        return lstResults;
    }
    
    /**
     * @param condition 查询条件
     * @return 按月获取测试结果统计
     */
    public List<TestResult> queryTestResultStatisticsByMonth(TestResult condition) {
        Date startTime = trim(condition.getStartTime());
        Date endTime = end(condition.getEndTime());
        String strStartTime = FORMATTER.format(startTime);
        String strEndTime = FORMATTER.format(endTime);
        Object[] strArr = { strStartTime, strEndTime, startTime, endTime };
        List<TestResult> lstResults = jdbc.query(sqlMap.get("QUERY_TEST_RESULT_BY_MONTH"), strArr,
            new RowMapper<TestResult>() {
                
                @Override
                public TestResult mapRow(ResultSet rs, int rowNum) throws SQLException {
                    TestResult objTestResult = new TestResult();
                    objTestResult.setAxisName(rs.getString(1));
                    objTestResult.setStartTime(rs.getDate(2));
                    objTestResult.setEndTime(rs.getDate(3));
                    objTestResult.setPassCount(rs.getInt(4));
                    objTestResult.setFailCount(rs.getInt(5));
                    return objTestResult;
                }
                
            });
        return lstResults;
    }
    
    /**
     * @param condition 查询条件
     * @return 查询最好或者最差的排名
     */
    public List<TestResult> queryTopTestResultStatistics(TestResult condition) {
        Date startTime = trim(condition.getStartTime());
        Date endTime = end(condition.getEndTime());
        String strStartTime = FORMATTER.format(startTime);
        String strEndTime = FORMATTER.format(endTime);
        Object[] strArr = { strStartTime, strEndTime, startTime, endTime };
        if (condition.getExcellent() == null || !condition.getExcellent()) {// 最差
            return queryTopTestResult(sqlMap.get("QUERY_TOP_WORST_TEST_RESULT"), strArr);
        }
        return queryTopTestResult(sqlMap.get("QUERY_TOP_EXCELLENT_TEST_RESULT"), strArr);
    }
    
    /**
     * @param condition 查询条件
     * @return 按模块获取测试结果统计
     */
    public List<TestResult> queryTestResultStatisticsByModule(TestResult condition) {
        Date startTime = trim(condition.getStartTime());
        Date endTime = end(condition.getEndTime());
        if (StringUtils.hasText(condition.getAppId()) && StringUtils.hasText(condition.getAppFullName())) {
            String appFullName = condition.getAppFullName();
            if (!appFullName.endsWith("/")) {
                appFullName = appFullName + "/%";
            }
            Object[] objArr = { startTime, endTime, condition.getAppId(), appFullName };
            return this.queryTestResultByModule(sqlMap.get("QUERY_TEST_RESULT_BY_MODULE_FULL_NAME_AND_APP_ID"), objArr);
        } else if (StringUtils.hasText(condition.getAppId()) && StringUtils.isEmpty(condition.getAppFullName())) {
            Object[] objArr = { startTime, endTime, condition.getAppId() };
            return this.queryTestResultByModule(sqlMap.get("QUERY_TEST_RESULT_BY_MODULE_APP_ID"), objArr);
        } else if (StringUtils.isEmpty(condition.getAppId()) && StringUtils.hasText(condition.getAppFullName())) {
            String appFullName = condition.getAppFullName();
            if (!appFullName.endsWith("/")) {
                appFullName = appFullName + "/%";
            }
            Object[] objArr = { startTime, endTime, appFullName };
            return this.queryTestResultByModule(sqlMap.get("QUERY_TEST_RESULT_BY_MODULE_FULL_NAME"), objArr);
        } else {
            Object[] objArr = { startTime, endTime };
            return this.queryTestResultByModule(sqlMap.get("QUERY_TEST_RESULT_BY_MODULE"), objArr);
        }
    }
    
    /**
     * 根据sql和参数查询数据
     *
     * <pre>
     * 
     * </pre>
     * 
     * @param strSQL sql
     * @param objArr 参数
     * @return 测试结果集合
     */
    private List<TestResult> queryTopTestResult(String strSQL, Object[] objArr) {
        List<TestResult> lstResults = jdbc.query(strSQL, objArr, new RowMapper<TestResult>() {
            
            @Override
            public TestResult mapRow(ResultSet rs, int rowNum) throws SQLException {
                TestResult objTestResult = new TestResult();
                objTestResult.setAppName(rs.getString(1));
                objTestResult.setAppFullName(rs.getString(2));
                objTestResult.setStartTime(rs.getDate(3));
                objTestResult.setEndTime(rs.getDate(4));
                objTestResult.setPassCount(rs.getInt(5));
                objTestResult.setFailCount(rs.getInt(6));
                return objTestResult;
            }
            
        });
        return lstResults;
        
    }
    
    /**
     * 根据sql和参数查询数据
     *
     * <pre>
     * 
     * </pre>
     * 
     * @param strSQL sql
     * @param objArr 参数
     * @return 测试结果集合
     */
    private List<TestResult> queryTestResultByModule(String strSQL, Object[] objArr) {
        List<TestResult> lstResults = jdbc.query(strSQL, objArr, new RowMapper<TestResult>() {
            
            @Override
            public TestResult mapRow(ResultSet rs, int rowNum) throws SQLException {
                TestResult objTestResult = new TestResult();
                objTestResult.setMetaName(rs.getString(1));
                objTestResult.setFuncName(rs.getString(2));
                boolean bReuslt = rs.getInt(3) == 0 ? false : true;
                objTestResult.setResult(bReuslt);
                objTestResult.setTestTime(rs.getTimestamp(4));
                return objTestResult;
            }
            
        });
        return lstResults;
        
    }
    
    /**
     * @param lstTestCaseName 查询条件
     * @param packageId 应用Id
     * @return 测试结果
     */
    public List<TestResult> queryTestResultByTestCaseName(String[] lstTestCaseName, String packageId) {
        String strCaseName = "";
        for (int i = 0, length = lstTestCaseName.length; i < length; i++) {
            if (i == length - 1) {
                strCaseName += "'" + lstTestCaseName[i] + "'";
            } else {
                strCaseName += "'" + lstTestCaseName[i] + "',";
            }
        }
        String strQuerySQL = sqlMap.get("QUERY_TEST_RESULT_BY_TEST_CASE_NAME").replace(":param", strCaseName);
        Object[] strArr = { packageId };
        List<TestResult> lstResults = jdbc.query(strQuerySQL, strArr, new RowMapper<TestResult>() {
            
            @Override
            public TestResult mapRow(ResultSet rs, int rowNum) throws SQLException {
                TestResult objTestResult = new TestResult();
                objTestResult.setTestcaseName(rs.getString(1));
                objTestResult.setMetaName(rs.getString(2));
                objTestResult.setFuncName(rs.getString(3));
                boolean bReuslt = rs.getInt(4) == 0 ? false : true;
                objTestResult.setResult(bReuslt);
                objTestResult.setTestTime(rs.getTimestamp(5));
                return objTestResult;
            }
            
        });
        return lstResults;
    }
    
    /**
     * 根据测试ID获取测试数据
     *
     * @param testUuid 测试Id
     * @return 测试报告
     */
    public List<TestResult> queryTestResultByTestUuid(String testUuid) {
        String[] strArr = { testUuid };
        List<TestResult> lstResults = jdbc.query(sqlMap.get("QUERY_TEST_RESULT_SQL"), strArr,
            new RowMapper<TestResult>() {
                
                @Override
                public TestResult mapRow(ResultSet rs, int rowNum) throws SQLException {
                    TestResult objTestResult = new TestResult();
                    objTestResult.setMetaName(rs.getString(1));
                    objTestResult.setFuncName(rs.getString(2));
                    boolean bReuslt = rs.getInt(3) == 0 ? false : true;
                    objTestResult.setResult(bReuslt);
                    objTestResult.setAppName(rs.getString(4));
                    
                    return objTestResult;
                }
                
            });
        return lstResults;
    }
    
    /***
     * 是否存在指定test-UUID的测试数据
     * 
     * @param testUuid 测试uuid。不可为空
     * @return 如果存在则返回true,否则返回false(uuid为空\null也返回false)
     */
    public boolean isExistTestuuidData(String testUuid) {
        String[] strArr = { testUuid };
        int iCount = jdbc.queryForObject(sqlMap.get("IS_EXIST_TESTDATA_BY_TESTUUID"), strArr, new RowMapper<Integer>() {
            
            @Override
            public Integer mapRow(ResultSet rs, int rowNum) throws SQLException {
                return rs.getInt(1);
            }
            
        });
        return iCount == 0 ? false : true;
    }
    
    /***
     * 指定的testUuid是否存在测试失败的数据
     * 
     * @param testUuid testUuid 测试uuid。不可为空
     * @return 当且仅当有测试数据失败时返回true；否则返回false(没有指定uuid的测试数据、指定uuid的测试数据不存在失败、指定uuid为空\null也返回false)
     */
    public boolean isExistFailDataByTestUuid(String testUuid) {
        String[] strArr = { testUuid };
        int iCount = jdbc.queryForObject(sqlMap.get("IS_EXIST_FAILDATA_BY_TESTUUID"), strArr, new RowMapper<Integer>() {
            
            @Override
            public Integer mapRow(ResultSet rs, int rowNum) throws SQLException {
                return rs.getInt(1);
            }
            
        });
        return iCount == 0 ? false : true;
    }
    
    /**
     * 保存测试结果
     *
     * @param uuid 测试Id
     */
    public void saveTestResult(final String uuid) {
        Robot robot = this.readReport(uuid);
        if (robot == null) {
            return;
        }
        final Map<String, Module> modules = new HashMap<String, Module>();
        jdbc.query(sqlMap.get("QUERY_MODULE_SQL"), new RowMapper<Module>() {
            
            @Override
            public Module mapRow(ResultSet rs, int rowNum) throws SQLException {
                Module module = new Module(rs.getString(1), rs.getString(2), rs.getString(3));
                modules.put(module.getFullPath(), module);
                return module;
            }
            
        });
        List<TestResult> results = analyseRobotReport(robot.getSuties(), robot.getGenerated(), modules);
        if (results == null || results.isEmpty()) {
            return;
        }
        jdbc.batchUpdate(sqlMap.get("INSERT_SQL"), new BatchPreparedStatementSetter() {
            
            @Override
            public void setValues(PreparedStatement ps, int i) throws SQLException {
                ps.setString(1, results.get(i).getId());
                ps.setString(2, uuid);
                ps.setString(3, results.get(i).getTestcaseName());
                ps.setString(4, results.get(i).getMetaName());
                ps.setString(5, results.get(i).getFuncName());
                ps.setString(6, results.get(i).getAppName());
                ps.setBoolean(7, results.get(i).getResult());
                ps.setTimestamp(8, results.get(i).getTestTime());
                ps.setInt(9, results.get(i).getTestcaseLevel());
                ps.setString(10, results.get(i).getAppId());
                ps.setString(11, results.get(i).getAppFullName());
                ps.setInt(12, results.get(i).getYear());
                ps.setInt(13, results.get(i).getMonth());
                ps.setInt(14, results.get(i).getDay());
                ps.setInt(15, results.get(i).getWeek());
                ps.setInt(16, results.get(i).getWeekOfMonth());
            }
            
            @Override
            public int getBatchSize() {
                return results.size();
            }
        });
    }
    
    /**
     * 读取测试报告
     *
     * @param uuid 测试Id
     * @return 测试报告
     */
    public Robot readReport(String uuid) {
        String logPath = new File(home).getParent() + File.separator + LOGS_HOME + File.separator + uuid;
        File file = new File(logPath);
        if (!file.exists()) {
            return null;
        }
        String reportPath = logPath + File.separator + "output.xml";
        file = new File(reportPath);
        if (!file.exists()) {
            return null;
        }
        Robot robot = null;
        try (FileInputStream fileInputStream = new FileInputStream(file);) {
            JAXBContext context = JAXBContext.newInstance(Robot.class);
            Unmarshaller unmarshaller = context.createUnmarshaller();
            robot = (Robot) unmarshaller.unmarshal(fileInputStream);
        } catch (Throwable e) {
            throw new RuntimeException("读取测试报告失败.", e);
        }
        return robot;
    }
    
    /**
     * 分析测试报告
     *
     * @param suites 测试用例
     * @param instant 测试时间
     * @param modules 系统模块树缓存
     * @return 分析后的测试结果
     */
    private List<TestResult> analyseRobotReport(List<Suite> suites, Instant instant, Map<String, Module> modules) {
        if (suites == null || suites.isEmpty()) {
            return null;
        }
        List<TestResult> results = new ArrayList<TestResult>();
        TestResult result = null;
        for (Suite suite : suites) {
            if (suite.getTests() != null && !suite.getTests().isEmpty()) {
                String source = suite.getSource();
                String[] values = source.replace('\\', '/').split("/");
                if (values.length <= 3) {
                    continue;
                }
                String appName = values[values.length - 2];
                String appFullName = "";
                for (int i = 2; i < values.length - 1; i++) {
                    appFullName += "/" + values[i];
                }
                int level = values.length - 2;
                String appId = null;
                Module module = modules.get(appFullName);
                if (module != null) {
                    appId = module.getId();
                }
                List<Test> tests = suite.getTests();
                for (Test test : tests) {
                    result = new TestResult();
                    String[] names = test.getName().split("_");
                    result.setId(genUUID());
                    result.setAppName(appName);
                    result.setAppFullName(appFullName + "/");
                    result.setTestcaseName(test.getName());
                    if (names.length >= 2) {
                        result.setMetaName(names[1]);
                        result.setFuncName(names[0]);
                    }
                    result.setTestTime(Timestamp.from(instant));
                    result.setTestcaseLevel(level);
                    result.setAppId(appId);
                    Status status = test.getStatus();
                    if (status != null) {
                        result.setResult(ResultType.PASS.equals(status.getStatus()));
                    } else {
                        result.setResult(Boolean.FALSE);
                    }
                    results.add(result);
                }
            }
            if (suite.getSuties() != null && !suite.getSuties().isEmpty()) {
                List<TestResult> temps = this.analyseRobotReport(suite.getSuties(), instant, modules);
                if (temps != null) {
                    results.addAll(temps);
                }
            }
        }
        return results;
    }
    
    /**
     * @return 生成UUID
     */
    private String genUUID() {
        return UUID.randomUUID().toString().replace("-", "").toUpperCase();
    }
    
    /**
     * @param date 日期
     * @return 将时、分、秒置为0
     */
    public static Date trim(Date date) {
        Calendar calendar = Calendar.getInstance();
        calendar.setTime(date);
        calendar.set(Calendar.HOUR_OF_DAY, 0);
        calendar.set(Calendar.MINUTE, 0);
        calendar.set(Calendar.SECOND, 0);
        calendar.set(Calendar.MILLISECOND, 0);
        return calendar.getTime();
    }
    
    /**
     * @param date 日期
     * @return 将时、分、秒置为0
     */
    public static Date end(Date date) {
        Calendar calendar = Calendar.getInstance();
        calendar.setTime(date);
        calendar.set(Calendar.HOUR_OF_DAY, 24);
        calendar.set(Calendar.MINUTE, 59);
        calendar.set(Calendar.SECOND, 59);
        calendar.set(Calendar.MILLISECOND, 999);
        return calendar.getTime();
    }
    
}
