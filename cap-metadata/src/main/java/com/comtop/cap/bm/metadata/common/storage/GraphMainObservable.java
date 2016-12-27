
package com.comtop.cap.bm.metadata.common.storage;

import java.util.HashMap;
import java.util.Iterator;
import java.util.Map;
import java.util.Observable;
import java.util.Observer;

/**
 * Graph关系观察者类
 *
 * @author 刘城
 * @since jdk1.6
 * @version 2016年12月13日 刘城
 */
public class GraphMainObservable extends Observable {
    
    /** 单例 */
    private static final GraphMainObservable instance = new GraphMainObservable();
    
    /** 存储观察者 */
    protected Map<String, Object> obs = new HashMap<String, Object>();
    
    /** 存储Graph关联关系 */
    protected Map<String, Object> graphMap = new HashMap<String, Object>();
    
    /** 同步状态 true 默认状态 false为正在同步 */
    private boolean sycnFlag = true;
    
    /** 是否生效 */
    private boolean isAlbe = false;
    
    /**
     * @return 获取 sycnFlag属性值
     */
    public boolean isSycnFlag() {
        return sycnFlag;
    }
    
    /**
     * @param sycnFlag 设置 sycnFlag 属性值为参数值 sycnFlag
     */
    public void setSycnFlag(boolean sycnFlag) {
        this.sycnFlag = sycnFlag;
    }
    
    /**
     * @return 获取 isAlbe属性值
     */
    public boolean isAlbe() {
        return isAlbe;
    }
    
    /**
     * @param isAlbe 设置 isAlbe 属性值为参数值 isAlbe
     */
    public void setAlbe(boolean isAlbe) {
        this.isAlbe = isAlbe;
    }
    
    /**
     * 构造函数
     */
    private GraphMainObservable() {
    }
    
    /**
     * 创建对象
     * 
     * @return instance
     */
    public static GraphMainObservable getInstance() {
        return instance;
    }
    
    /**
     * @Title: doBusiness
     * @Description: 当被观察者有Changed时,通知观察者
     * @param arg xx
     * @date 2013-5-2
     */
    public void doBusiness(Object arg) {
        // 设置修改状态
        // 通知观察者
        if (isAlbe) {
            super.setChanged();
            this.notifyObservers(arg);
        }
        
    }
    
    /**
     * @Title: notifyObservers
     * @Description: 模仿不同的业务通知对应业务的观察者
     * @param arg xx
     * @see java.util.Observable#notifyObservers(java.lang.Object)
     */
    @Override
    public void notifyObservers(Object arg) {
        
        String msg = arg.toString();
        
        String[] msgs = msg.split(":");
        
        if (obs.containsKey(msgs[0])) {
            Observer ob = (Observer) obs.get(msgs[0]);
            ob.update(this, msgs[0]);
        }
    }
    
    /**
     * @Title: addObserver
     * @Description: 添加一个观察者
     * @param name 观察者名称
     * @param o 观察者对象
     */
    public synchronized void addObserver(String name, Observer o) {
        
        obs.put(name, o);
    }
    
    /**
     * @Title: updateObserver
     * @Description: 修改一个观察者
     * @param name 观察者名称
     * @param o 观察者对象
     */
    public synchronized void updateObserver(String name, Observer o) {
        
        Iterator<String> it = obs.keySet().iterator();
        
        String key = null;
        
        while (it.hasNext()) {
            
            key = it.next();
            
            if (key.equals(name)) {
                obs.put(key, o);
                break;
            }
        }
    }
    
    /**
     * @Title: deleteObserver
     * @Description: 删除观察者
     * @param o :观察者对象
     * @see java.util.Observable#deleteObserver(java.util.Observer)
     */
    @Override
    public synchronized void deleteObserver(Observer o) {
        
        if (obs.values().contains(o)) {
            
            Iterator<String> it = obs.keySet().iterator();
            
            String key = null;
            
            while (it.hasNext()) {
                
                key = it.next();
                
                if (obs.get(key).equals(o)) {
                    // System.out.println("被删除的key为:" + key);
                    obs.remove(key);
                    break;
                }
            }
        }
    }
    
    /**
     * @return 获取 graphMap属性值
     */
    public Map<String, Object> getGraphMap() {
        return graphMap;
    }
    
    /**
     * @param graphMap 设置 graphMap 属性值为参数值 graphMap
     */
    public void setGraphMap(Map<String, Object> graphMap) {
        this.graphMap = graphMap;
    }
    
}
