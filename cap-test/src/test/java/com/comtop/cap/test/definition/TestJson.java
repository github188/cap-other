
package com.comtop.cap.test.definition;

/******************************************************************************
 * Copyright (C) 2016 ShenZhen ComTop Information Technology Co.,Ltd
 * All Rights Reserved.
 * 本软件为深圳康拓普开发研制。未经本公司正式书面同意，其他任何个人、团体不得使用、
 * 复制、修改或发布本软件.
 *****************************************************************************/

import java.util.Calendar;
import java.util.LinkedList;
import java.util.List;

import org.junit.Assert;
import org.junit.Test;

import com.comtop.cip.json.JSON;
import com.comtop.cip.json.serializer.SerializerFeature;

/**
 * 测试JSON
 *
 * @author lizhongwen
 * @since jdk1.6
 * @version 2016年8月10日 lizhongwen
 */
public class TestJson {
    
    /**
     * 测试继承
     */
    @Test
    public void testJsonInheritance() {
        List<Person> persons = new LinkedList<Person>();
        persons.add(new Student("张三", "12", "锦绣中学"));
        persons.add(new Employee("李四", "12", "康拓普"));
        Market market = new Market("家乐福", persons);
        String str = JSON.toJSONString(market, SerializerFeature.WriteClassName);
        Object result = JSON.parseObject(str, Market.class);
        Assert.assertNotNull(result);
    }
    
    /**
     * FIXME 方法注释信息
     *
     */
    @Test
    public void testWeek() {
        Calendar calendar = Calendar.getInstance();
        System.out.println(calendar.get(Calendar.WEEK_OF_YEAR));
        System.out.println(getWeek(calendar));
    }
    
    /**
     * FIXME 方法注释信息
     *
     * @param calendar xxx
     * @return xx
     */
    public int getWeek(Calendar calendar) {
        int week = calendar.get(Calendar.WEEK_OF_YEAR);
        int year = calendar.get(Calendar.YEAR);
        Calendar firstDayOfYear = Calendar.getInstance();
        firstDayOfYear.set(year, 1, 1);
        if (firstDayOfYear.get(Calendar.DAY_OF_WEEK) != Calendar.SUNDAY) {
            week = week - 1;
        }
        return week == 0 ? 52 : week;
    }
    
    /**
     * FIXME 类注释信息
     *
     * @author lizhongwen
     * @since jdk1.6
     * @version 2016年8月10日 lizhongwen
     */
    static class Market {
        
        /** 名称 */
        private String name;
        
        /** ddd */
        private List<Person> customers;
        
        /**
         * 构造函数
         */
        public Market() {
            super();
        }
        
        /**
         * 构造函数
         * 
         * @param name name
         * @param customers customers
         */
        public Market(String name, List<Person> customers) {
            super();
            this.name = name;
            this.customers = customers;
        }
        
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
         * @return 获取 customers属性值
         */
        public List<Person> getCustomers() {
            return customers;
        }
        
        /**
         * @param customers 设置 customers 属性值为参数值 customers
         */
        public void setCustomers(List<Person> customers) {
            this.customers = customers;
        }
    }
    
    /**
     * 雇员
     *
     * @author lizhongwen
     * @since jdk1.6
     * @version 2016年8月10日 lizhongwen
     */
    static class Employee extends Person {
        
        /** FIXME */
        private String company;
        
        /**
         * 构造函数
         */
        public Employee() {
            super();
        }
        
        /**
         * 构造函数
         * 
         * @param name name
         * @param age age
         * @param company company
         */
        public Employee(String name, String age, String company) {
            super(name, age);
            this.company = company;
        }
        
        /**
         * @return 获取 company属性值
         */
        public String getCompany() {
            return company;
        }
        
        /**
         * @param company 设置 company 属性值为参数值 company
         */
        public void setCompany(String company) {
            this.company = company;
        }
    }
    
    /**
     * 学生
     *
     * @author lizhongwen
     * @since jdk1.6
     * @version 2016年8月10日 lizhongwen
     */
    static class Student extends Person {
        
        /** FIXME */
        private String school;
        
        /**
         * 构造函数
         */
        public Student() {
            super();
        }
        
        /**
         * 构造函数
         * 
         * @param name name
         * @param age age
         * @param school school
         */
        public Student(String name, String age, String school) {
            super(name, age);
            this.school = school;
        }
        
        /**
         * @return 获取 school属性值
         */
        public String getSchool() {
            return school;
        }
        
        /**
         * @param school 设置 school 属性值为参数值 school
         */
        public void setSchool(String school) {
            this.school = school;
        }
    }
    
    /**
     * 人员
     *
     * @author lizhongwen
     * @since jdk1.6
     * @version 2016年8月10日 lizhongwen
     */
    static abstract class Person {
        
        /** FIXME */
        private String name;
        
        /** FIXME */
        private String age;
        
        /**
         * 构造函数
         */
        public Person() {
            super();
        }
        
        /**
         * 构造函数
         * 
         * @param name name
         * @param age age
         */
        public Person(String name, String age) {
            super();
            this.name = name;
            this.age = age;
        }
        
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
         * @return 获取 age属性值
         */
        public String getAge() {
            return age;
        }
        
        /**
         * @param age 设置 age 属性值为参数值 age
         */
        public void setAge(String age) {
            this.age = age;
        }
        
    }
    
}
