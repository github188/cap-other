
package com.comtop.cip.graph.entity.util;

import javax.servlet.ServletContext;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;

import com.comtop.cap.bm.metadata.common.storage.GraphMainObservable;
import com.comtop.cap.runtime.core.InitBean;

/**
 * Graph观察者初始化
 *
 * @author 刘城
 * @since jdk1.6
 * @version 2016年12月14日 刘城
 */
@InitBean
public class GraphModuleInitializer {
    
    /** 日志 */
    private final static Logger LOGGER = LoggerFactory.getLogger(GraphModuleInitializer.class);
    
    /**
     * 添加观察者
     * 
     * @param context web上下文
     */
    public void init(ServletContext context) {
        GraphMainObservable observable = GraphMainObservable.getInstance();
        GraphProcessObserver observer = new GraphProcessObserver();
        observable.addObserver("update", observer);
        observable.doBusiness("update");
        LOGGER.info("观察者添加完成");
    }
}
