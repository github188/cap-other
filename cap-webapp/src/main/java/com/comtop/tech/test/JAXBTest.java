/******************************************************************************
 * Copyright (C) 2016 ShenZhen ComTop Information Technology Co.,Ltd
 * All Rights Reserved.
 * 本软件为深圳康拓普开发研制。未经本公司正式书面同意，其他任何个人、团体不得使用、
 * 复制、修改或发布本软件.
 *****************************************************************************/
package com.comtop.tech.test;

import java.io.FileReader;
import java.io.FileWriter;
import java.math.BigDecimal;
import java.util.Date;
import java.util.HashSet;
import java.util.Set;

import javax.xml.bind.JAXBContext;
import javax.xml.bind.JAXBException;
import javax.xml.bind.Marshaller;
import javax.xml.bind.Unmarshaller;

import org.apache.commons.io.IOUtils;

/**
 * 
 * @author 许畅
 * @since JDK1.7
 * @version 2016年11月23日 许畅 新建
 */
public class JAXBTest {

	/**
	 * @param args
	 *            xx
	 * @throws JAXBException
	 *             xx
	 */
	public static void main(String[] args) throws JAXBException {
		Set<Order> orders = new HashSet<Order>();
		Order order1 = new Order("Mart", "LH59900", new Date(), new BigDecimal(
				60), 1);
		Order order2 = new Order("Mart", "LH59800", new Date(), new BigDecimal(
				80), 1);

		orders.add(order1);
		orders.add(order2);

		Address address3 = new Address("China", "ZheJiang", "HangZhou",
				"XiHuRoad", "310000");
		Shop shop = new Shop("CHMart", "100000", "EveryThing", address3);
		shop.setOrders(orders);

		FileWriter writer = null;
		FileReader reader = null;
		JAXBContext context = JAXBContext.newInstance(Shop.class);
		try {
			Marshaller marshal = context.createMarshaller();
			marshal.setProperty(Marshaller.JAXB_FORMATTED_OUTPUT, true);
			marshal.marshal(shop, System.out);

//			File file = new File(
//					"D:/CAP/BM/code/CAP/cap-webapp/src/main/java/com/comtop/tech/test/shop.xml");
//			if (!file.exists())
//				file.createNewFile();

			writer = new FileWriter("D:/CAP/BM/code/CAP/cap-webapp/src/main/java/com/comtop/tech/test/shop.xml");
			marshal.marshal(shop, writer);

			Unmarshaller unmarshal = context.createUnmarshaller();
			reader = new FileReader("D:/CAP/BM/code/CAP/cap-webapp/src/main/java/com/comtop/tech/test/shop.xml");
			Shop shop1 = (Shop) unmarshal.unmarshal(reader);

			Set<Order> orders1 = shop1.getOrders();
			for (Order order : orders1) {
				System.out.println("***************************");
				System.out.println(order.getOrderNumber());
				System.out.println("***************************");
			}
		} catch (Exception e) {
			e.printStackTrace();
		} finally {
			IOUtils.closeQuietly(writer);
			IOUtils.closeQuietly(reader);
		}

	}

}
