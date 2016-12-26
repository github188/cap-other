
package com.comtop.cip.graph.entity.util;

import java.util.Observable;
import java.util.Observer;

/**
 * Graph计算流程观察者
 *
 * @author 刘城
 * @since jdk1.6
 * @version 2016年12月13日 刘城
 */
public class GraphProcessObserver implements Observer {
    
    @Override
    public void update(Observable o, Object arg) {
        Thread thread = new GraphModuleThread();
        thread.start();
    }
    
}
