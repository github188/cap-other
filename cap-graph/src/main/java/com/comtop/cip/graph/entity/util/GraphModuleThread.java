
package com.comtop.cip.graph.entity.util;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;

import com.comtop.cap.bm.metadata.common.storage.GraphMainObservable;
import com.comtop.cip.graph.entity.facade.GraphModuleFacadeImpl;
import com.comtop.cip.graph.entity.facade.IGraphModuleFacade;
import com.comtop.top.core.jodd.AppContext;

/**
 * 模块关系线程类，启动现成生成结果数据
 *
 * @author 刘城
 * @since jdk1.6
 * @version 2016年12月13日 刘城
 */
public class GraphModuleThread extends Thread {
    
    /** 日志 */
    private final static Logger LOGGER = LoggerFactory.getLogger(GraphModuleThread.class);
    
    @Override
    public void run() {
        
        GraphMainObservable observable = GraphMainObservable.getInstance();
        // 如果不是正在同步中
        try {
            if (observable.isSycnFlag()) {
                observable.setSycnFlag(false);
                sycn();
                observable.setSycnFlag(true);
                LOGGER.debug("同步完成");
                return;
            }
            // 如果连续发生元数据变化 因为无法确认这次同步时是否会读取所有变化的数据
            // 并且依赖关系变化并不会产生太大的影响，所以放弃轮询方式,采用延时同步
            Thread.sleep(5000);
            if (observable.isSycnFlag()) {
                observable.setSycnFlag(false);
                sycn();
                observable.setSycnFlag(true);
                LOGGER.debug("延时同步完成");
            }
        } catch (InterruptedException e) {
            LOGGER.error("同步异常", e);
        }
    }
    
    /**
     * 同步
     */
    private static void sycn() {
        IGraphModuleFacade graphModuleFacade = AppContext.getBean(GraphModuleFacadeImpl.class);
        graphModuleFacade.saveGraphModuleVORelations();
    }
}
