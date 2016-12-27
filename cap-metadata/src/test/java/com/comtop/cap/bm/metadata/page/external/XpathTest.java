package com.comtop.cap.bm.metadata.page.external;

import static org.junit.Assert.assertTrue;

import java.util.Date;

import org.apache.commons.jxpath.ClassFunctions;
import org.apache.commons.jxpath.JXPathContext;
import org.apache.commons.jxpath.JXPathException;
import org.apache.commons.jxpath.Pointer;
import org.junit.Before;
import org.junit.Rule;
import org.junit.Test;
import org.junit.rules.ExpectedException;

/**
 * PageMetadataProvider test类
 * @author yangsai
 *
 */
public class XpathTest {
	/**
	 * 
	 */
	Auth auth;
	
	/**
	 * 
	 */
	@Before
	public void setup() {
		System.out.println("create auth object");
		auth = new Auth();
		auth.books[0] = new Book("java", new Page(100, new Price(100)));
		auth.books[1] = new Book("c++", new Page(200, new Price(200)));
		auth.books[2] = new Book("c", new Page(300, new Price(300)));
	}
	
	
	/**
	 * 
	 */
	@Rule
	public ExpectedException thrown = ExpectedException.none();
	
	/**
	 * test 
	 */
	@Test
	public void testContextVariableCycle() {
		
//		fail("Not yet implemented");
		JXPathContext context = JXPathContext.newContext(auth);
		context.getVariables().declareVariable("index", new Integer(1));		
		context.getVariables().declareVariable("myIndex", new Integer(2));
		assertTrue("book is java", "java".equals(((Book)context.getValue("books[$index]")).title));
		assertTrue("book is c++", "c++".equals(((Book)context.getValue("books[$myIndex]")).title));
		
		context.setValue("$myIndex", new Integer(3));
		assertTrue("book is c", "c".equals(((Book)context.getValue("books[$myIndex]")).title));
		
		context.getVariables().declareVariable("myIndex", 1);
		
		assertTrue("book is java", "java".equals(((Book)context.getValue("books[$myIndex]")).title));

//		assertEquals("")
		
		//注意：在后面的代码不会被执行，应该是在setValue()里跳出了测试方法
		thrown.expect(JXPathException.class);
	    thrown.expectMessage("Cannot set undefined variable: myIndex2");
		context.setValue("$myIndex2", new Integer(3));	//throw JXPathException
	}
	
	/**
	 * test 
	 */
	@Test
	public void testGetValue() {
		JXPathContext context = JXPathContext.newContext(auth);
		assertTrue("price = 300 book is c", "c".equals(((Book)context.getValue("books[page/price[num=300]]")).title));

		assertTrue("num = 300 book is c", "c".equals(((Book)context.getValue("books[page[num=300]]")).title));

		assertTrue("price = 300 book is c", "c".equals(((Book)context.getValue("books[page/price[num=300]]")).title));
		
		assertTrue("price = 300 book is c", "c".equals(((Book)context.getValue("books[page/price[*=300]]")).title));
	}
	
	/**
	 * test 
	 */
	@Test
	public void testFunction() {
		JXPathContext context = JXPathContext.newContext(auth);
		context.setFunctions(new ClassFunctions(Formats.class, "format"));
//		Book today = (Book)context.getValue("books[format:isC('MM/dd/yyyy')]");
		assertTrue("book is c", "c".equals(((Book)context.getValue("books[format:isC('MM/dd/yyyy')]")).title));
//		assertEquals("data same", "","" );
	}
	
	
	/**
	 * 
	 */
	@Test
	public void testXpathReturnObject() {
		JXPathContext context = JXPathContext.newContext(auth);
		assertTrue("return book", (context.getValue("books[page[num=300]]")) instanceof Book);
		assertTrue("return page", (context.getValue("books/page[num=300]")) instanceof Page);
		assertTrue("return page", (context.getValue("books/page[num=300 and price[num=300]]")) instanceof Page);
		assertTrue("return price", (context.getValue("books/page[num=300]/price")) instanceof Price);
	}
	
	/**
	 * 
	 */
	@Test
	public void testPointer() {
		JXPathContext context = JXPathContext.newContext(auth);
		Pointer p = context.getPointer("books[*='java']");
		assertTrue("book is java", "java".equals(((Book)p.getValue()).title));
	}
	
	/**
	 * 
	 */
	@Test
	public void testAttrLike() {
		JXPathContext context = JXPathContext.newContext(auth);
		assertTrue("book is java", "java".equals(((Book)context.getValue("books[*='java']")).title));
	}
	
	
	/**
	 * @author yangsai
	 *
	 */
	public class Auth {
		/**
		 * 
		 */
		private String name;
		/**
		 * 
		 */
		private Book[] books = new Book[5];

		/**
		 * @return the books
		 */
		public Book[] getBooks() {
			return books;
		}
		/**
		 * @param books the books to set
		 */
		public void setBooks(Book[] books) {
			this.books = books;
		}
		/**
		 * @return the name
		 */
		public String getName() {
			return name;
		}
		/**
		 * @param name the name to set
		 */
		public void setName(String name) {
			this.name = name;
		}
		
	}
	
	/**
	 * @author yangsai
	 *
	 */
	public class Book {
		/**
		 * 
		 */
		public Book() {
			
		}

		/**
		 * 
		 */
		private Date date = new Date();
		
		/**
		 * @param page page
		 */
		public Book(Page page) {
			this.page = page;
		}
		
		/**
		 * 
		 */
		private Page page;
		
		/**
		 * @param title title
		 * @param page page
		 */
		public Book(String title, Page page) {
			this.title = title;
			this.page = page;
		}

		/**
		 * 
		 */
		private String title;

		/**
		 * @return title
		 */
		public String getTitle() {
			return title;
		}

		/**
		 * @param title title
		 */
		public void setTitle(String title) {
			this.title = title;
		}

		/**
		 * @return the page
		 */
		public Page getPage() {
			return page;
		}

		/**
		 * @param page the page to set
		 */
		public void setPage(Page page) {
			this.page = page;
		}

		/**
		 * @return the date
		 */
		public Date getDate() {
			return date;
		}

		/**
		 * @param date the date to set
		 */
		public void setDate(Date date) {
			this.date = date;
		}
	}
	
	/**
	 * @author yangsai
	 *
	 */
	public class Page {
		/**
		 * 
		 */
		public Page() {
			
		}
		
		/**
		 * @param num num
		 * @param price  price
		 */
		public Page(Integer num, Price price) {
			this.num = num;
			this.price = price;
		}
		
		/**
		 * 
		 */
		private Price price;
		
		/**
		 * 
		 */
		private Integer num;

		/**
		 * @return the num
		 */
		public Integer getNum() {
			return num;
		}

		/**
		 * @param num the num to set
		 */
		public void setNum(Integer num) {
			this.num = num;
		}

		/**
		 * @return the price
		 */
		public Price getPrice() {
			return price;
		}

		/**
		 * @param price the price to set
		 */
		public void setPrice(Price price) {
			this.price = price;
		}
	}
	
	/**
	 * @author yangsai
	 *
	 */
	public class Price {
		/**
		 * 
		 */
		public Price() {
			
		}
		
		/**
		 * @param num num
		 */
		public Price(Integer num) {
			this.num = num;
		}
		
		/**
		 * 
		 */
		private Integer num;

		/**
		 * @return the num
		 */
		public Integer getNum() {
			return num;
		}

		/**
		 * @param num the num to set
		 */
		public void setNum(Integer num) {
			this.num = num;
		}
	}
}
