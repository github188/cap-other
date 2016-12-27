# -*- coding: utf-8 -*-
from selenium.webdriver.remote.webelement import WebElement
from selenium.webdriver.common.action_chains import ActionChains
from selenium.webdriver.common.keys import Keys
from Selenium2Library  import  Selenium2Library
from robot.api import logger
from robot.libraries import BuiltIn
import time
import random
import math

BUILTIN = BuiltIn.BuiltIn()

try:
	basestring # attempt to evaluate basestring
	def isstr(s):
		return isinstance(s, basestring)
except NameError:
	def isstr(s):
		return isinstance(s, str)

class ComtopLibrary(Selenium2Library):

	def choose_multi_user(self,id,num,clear=False):
		''' 执行人员控件多选，该关键字将自动通过人员控件进行选择，注意：该关键字只支持人员控件设置为多选模式下使用.
		- ‘id’ 为人员控件的id。工具将通过该Id进行人员控件以及弹出框的定位.
		- ‘num’ 表示多选人员时的最大数量，默认值为3，如果首次查找到的人员数量少于最大数量，则会实际找到的数量进行选择
		- ‘clear’ 表示执行选择之前是否需要清空以前的选项。
		'''
		self._info("Verifying chooseUser '%s' is exsited." % id)
		components = self._element_find("id="+id,False,True)
		if len(components) > 1:
			raise ValueError("Element id '%s' did match more elements." % id)
		if self._is_readonly(id):
			return
		self.click_link("id="+id+"_open")
		currentFrameId = self._currentFrameId()
		if currentFrameId:
			self.unselect_frame()
		self.select_frame("//div[@id='topdialog_"+id+"']/div/iframe[@class='dialog-content-iframe']")
		time.sleep(2)
		if clear :
			self.click_element("//div[@id='choose_page_box']/div[@class='choose_page_bottom']/span[@id='clear']")
		users =  self._find_multi()
		if len(users) == 0:
			raise ValueError("Element id '%s' can not find any user." % id)
		if num < 0 or num == '':
			num = 3
		n = min(len(users),num)
		for i in range(0,n):
			user[i].click()
			time.sleep(0.5)
		self.click_link("//div[@id='chooseCenterDiv']/div[@class='center_btns']/a[@class='btns_group addBtn']")
		time.sleep(2)
		self.click_element("//div[@id='choose_page_box']/div[@class='choose_page_bottom']/span[@id='ok']")
		self.unselect_frame()
		if currentFrameId:
			self._switchToFrame(currentFrameId,[])


	def choose_single_user(self,id,clear=False):
		''' 执行人员控件单选，该关键字将自动通过人员控件进行选择，注意：该关键字只支持人员控件设置为多选、单选模式均可使用.
		- ‘id’ 为人员控件的id。工具将通过该Id进行人员控件以及弹出框的定位.
		- ‘clear’ 表示执行选择之前是否需要清空以前的选项。
		'''
		self._info("Verifying chooseUser '%s' is exsited." % id)
		components = self._element_find("id="+id,False,True)
		if len(components) > 1:
			raise ValueError("Element id '%s' did match more elements." % id)
		if self._is_readonly(id):
			return
		self.click_link("id="+id+"_open")
		currentFrameId = self._currentFrameId()
		if currentFrameId:
			self.unselect_frame()
		self.select_frame("//div[@id='topdialog_"+id+"']/div/iframe[@class='dialog-content-iframe']")
		time.sleep(2)
		selected = self._element_find("//div[@id='choose_page_right' and @style='display: none;']",False,False)
		if len(selected) == 0 :
			if clear:
				self.click_element("//div[@id='choose_page_box']/div[@class='choose_page_bottom']/span[@id='clear']")
			users =  self._find_multi()
			if len(users) == 0:
				raise ValueError("Element id '%s' can not find any user." % id)
			users[0].click()
			self.click_link("//div[@id='chooseCenterDiv']/div[@class='center_btns']/a[@class='btns_group addBtn']")
		else:
			users = self._find_single_user()
			if len(users) == 0:
				raise ValueError("Element id '%s' can not find any user." % id)
			users[0].click()
		time.sleep(2)
		self.click_element("//div[@id='choose_page_box']/div[@class='choose_page_bottom']/span[@id='ok']")
		self.unselect_frame()
		if currentFrameId:
			self._switchToFrame(currentFrameId,[])

	def choose_multi_org(self,id,num,clear=False):
		''' 执行组织控件多选，该关键字将自动通过组织控件进行选择，注意：该关键字只支持组织控件设置为多选模式下使用.
		- ‘id’ 为组织控件的id。工具将通过该Id进行组织控件以及弹出框的定位.
		- ‘num’ 表示多选组织时的最大数量，默认值为3，如果首次查找到的组织数量少于最大数量，则会实际找到的数量进行选择
		- ‘clear’ 表示执行选择之前是否需要清空以前的选项。
		'''
		self._info("Verifying chooseOrg '%s' is exsited." % id)
		components = self._element_find("id="+id,False,True)
		if len(components) > 1:
			raise ValueError("Element id '%s' did match more elements." % id)
		if self._is_readonly(id):
			return
		self.click_link("id="+id+"_open")
		currentFrameId = self._currentFrameId()
		if currentFrameId:
			self.unselect_frame()
		self.select_frame("//div[@id='topdialog_"+id+"']/div/iframe[@class='dialog-content-iframe']")
		time.sleep(2)
		if clear :
			self.click_element("//div[@id='choose_page_box']/div[@class='choose_page_bottom']/span[@id='clear']")
		orgs =  self._find_multi()
		if len(orgs) == 0:
			raise ValueError("Element id '%s' can not find any org." % id)
		if num < 0 or num == '':
			num = 3
		n = min(len(orgs),num)
		self._info("min(len(orgs),num) :::: '%s' is exsited." % num)
		for i in range(0,n):
			orgs[i].click()
			time.sleep(0.5)
		self.click_link("//div[@id='chooseCenterDiv']/div[@class='center_btns']/a[@class='btns_group addBtn']")
		time.sleep(2)
		self.click_element("//div[@id='choose_page_box']/div[@class='choose_page_bottom']/span[@id='ok']")
		self.unselect_frame()
		if currentFrameId:
			self._switchToFrame(currentFrameId,[])

	def choose_single_org(self,id,clear=False):
		''' 执行组织控件单选，该关键字将自动通过组织控件进行选择，注意：该关键字只支持组织控件设置为多选、单选模式均可使用.
		- ‘id’ 为组织控件的id。工具将通过该Id进行组织控件以及弹出框的定位.
		- ‘clear’ 表示执行选择之前是否需要清空以前的选项。
		'''
		self._info("Verifying chooseOrg '%s' is exsited." % id)
		components = self._element_find("id="+id,False,True)
		if len(components) > 1:
			raise ValueError("Element id '%s' did match more elements." % id)
		if self._is_readonly(id):
			return
		self.click_link("id="+id+"_open")
		currentFrameId = self._currentFrameId()
		if currentFrameId:
			self.unselect_frame()			
		self.select_frame("//div[@id='topdialog_"+id+"']/div/iframe[@class='dialog-content-iframe']")
		time.sleep(2)
		selected = self._element_find("//div[@id='choose_page_right' and @style='display: none;']",False,False)
		if len(selected)==0 :
			if clear:
				self.click_element("//div[@id='choose_page_box']/div[@class='choose_page_bottom']/span[@id='clear']")
			orgs =  self._find_multi()
			if len(orgs) == 0:
				raise ValueError("Element id '%s' can not find any org." % id)
			orgs[0].click()
			time.sleep(0.5)
			self.click_link("//div[@id='chooseCenterDiv']/div[@class='center_btns']/a[@class='btns_group addBtn']")
		else:
			orgs = self._find_single_org()
			if len(orgs) == 0:
				raise ValueError("Element id '%s' can not find any user." % id)
			orgs[0].click()
		time.sleep(2)
		self.click_element("//div[@id='choose_page_box']/div[@class='choose_page_bottom']/span[@id='ok']")
		self.unselect_frame()
		if currentFrameId:
			self._switchToFrame(currentFrameId,[])

	def pulldown_single_select(self,id,index=1):
		'''执行cui的Pulldown控件的单选操作，注意：该关键字只支持Pulldown控件为单选模式下使用。
		- ‘id’ 为组织控件的id。工具将通过该Id进行Pulldown控件以及下拉列表的定位.
		- ‘index’ 选项索引，起始值为1，默认值为1；
		'''
		self._info("Verifying pulldown single select '%s' is exsited." % id)
		if self._is_readonly(id):
			return
		components = self._element_find("id="+id,False,True)
		if len(components) > 1:
			raise ValueError("Element id '%s' did match more elements." % id)
		locator = "id="+id;
		self.click_element(locator)
		time.sleep(2)
		style = self._current_browser().execute_script("var sytle=cui('#"+id+"').$box[0].style.cssText ; return sytle == undefined ? null : sytle;")
		if style is None:
			raise ValueError("The Pulldown box of id = '%s' error!." % id)
		options = self._element_find("//div[(@class='pulldown-box') and (@style='"+style+"')]/div/a[contains(@class,'pulldown-list')]",False,False)
		if len(options) == 0:
			raise ValueError("The Pulldown id ='%s' can not find any select items!." % id)
		options[int(index)-1].click()
		time.sleep(1)
		self._current_browser().execute_script("arguments[0].blur();", components[0])
		time.sleep(2)

	def pulldown_multi_select(self,id,indexes=[1]):
		''' 执行cui的Pulldown控件的单选操作，注意：该关键字只支持Pulldown控件为多模式下使用。
		- ‘id’ 为Pulldown控件的id。工具将通过该Id进行Pulldown控件以及下拉列表的定位.
		- ‘indexes’ 选项索引数组，选项索引起始值为1，默认值为1；
		'''
		self._info("Verifying pulldown single select '%s' is exsited." % id)
		if self._is_readonly(id):
			return
		components = self._element_find("id="+id,False,True)
		if len(components) > 1:
			raise ValueError("Element id '" + id + "' did match more elements.")
		locator = "id="+id;
		self.click_element(locator)
		time.sleep(1)
		style = self._current_browser().execute_script("var sytle= cui('#"+id+"').$box[0].style.cssText; return sytle == undefined ? null : sytle;")
		if style is None:
			raise ValueError("The Pulldown box of id'%s' error!." % id)
		items = self._element_find("//div[(@class='pulldown-box multi-pulldown-box') and (@style='"+style+"')]/div/a[contains(@class,'pulldown-list')]",False,False)
		l = len(items)
		if l == 0:
			raise ValueError("The Pulldown id ='%s' can not find any select items!." % id)
		options = []
		if type(indexes) is list:
			options = indexes
		elif type(indexes) is int:
			options.append(indexes)
		elif type(indexes) is unicode:
			ret = str(indexes).replace('[','').replace(']','').split(',')
			for item in ret:
				options.append(int(item));
		else:
			options.append(1)
		for i in options:
			if i <= l and i>=1:
				items[i-1].click()
		self._current_browser().execute_script("arguments[0].blur();", components[0])
		time.sleep(2)

	def calender_select(self,id):
		''' 执行cui的Calender控件的选择操作。参数如下所示：
		- ‘id’ 为组织控件的id。工具将通过该Id进行Calender控件以及选择面板定位.
		'''
		self._info("Verifying Calender select '%s' is exsited." % id)
		components = self._element_find("id="+id,False,True)
		if len(components) > 1:
			raise ValueError("Element id '%s' did match more elements." % id)
		if self._is_readonly(id):
			return
		options = self._current_browser().execute_script("var options = cui('#"+id+"').options; return options == undefined ? null : options;")
		if options is None:
			raise ValueError("The Calender box of id = '%s' error!." % id)
		trigger = options["trigger"]
		locator = "//span[@id='"+id+"']/div/a"
		if trigger == "click" :
			self.click_link(locator)
		elif trigger == "mouseover":
			self.mouse_over(locator)
		else:
			raise ValueError("CUI Calender id='%s' trigger '%s' is error." % (id,trigger))
		time.sleep(1)
		isrange =options['isrange']
		uuid = options['uuid']
		items = self._element_find("//div[@id='C_CR_"+uuid+"']/div[@class='C_CR_main_wrap']/div/descendant::a",False,False)
		l = len(items)
		if l == 0:
			raise ValueError("Calender id '%s' can not selected!." % id)
		max = l-2
		if max > 0 :
			end = max
		else :
			end = l-1
		index = random.randint(0,end)
		items[index].click()
		if isrange :
			time.sleep(1)
			max = l-index-1
			if l-index-1 >0:
				gap = random.randint(1,max)
			else:
				gap = max
			items[index+gap].click()
		if options['okbtn']:
			ok = self._element_find("//div[@id='C_CR_"+uuid+"']/div[@class='C_CR_OPBar_wrap']/a[@val='ok']",True,False)
			if ok is not None:
				ok.click()
		time.sleep(2)
		

	def input_text(self, locator, text):
		'''扩展文本输入关键字，支持输入内容为函数执行。函数请用fn()进行包裹。参数如下所示：
		- ‘locator’ 为输入控件的位置。
		- ‘text’ 为需要输入的文本，如果需要使用函数，请用fn()进行包裹。
		'''
		self._info("Typing text '%s' into text field '%s'" % (text, locator))
		element = self._element_find(locator, True, True)
		readonly = element.get_attribute("readonly")
		if readonly is not None and readonly.lower() == "readonly":
			self._info("Unable typing text into text field '%s' when it readonly" % (locator))
			return
		if text.startswith('fn(') and text.endswith(')') and len(text)>4:
			fn = text[3:(len(text)-1)]
			self._info(fn)
			text = BUILTIN.evaluate(fn,modules="string,random,os,sys")
		self._input_text_into_text_field(locator, text)
		time.sleep(2)

	def click_button(self, locator):
		'''扩展点击按钮关键字，检查当前按钮是否被禁用，如果按钮为禁用状态，则不执行点击操作。参数如下所示：
		- ‘locator’ 为按钮控件的位置。
		'''
		self._info("Clicking button '%s'." % locator)
		element = self._element_find(locator, True, False, 'input')
		if element is None:
			element = self._element_find(locator, True, True, 'button')
		disable = element.get_attribute("disable")
		if disable is None or disable.lower() != "disable":
			element.click()

	def cui_input_text(self,id,text):
		'''扩展文本输入关键字，支持输入内容为函数执行，并且支持CUI Input组件的readonly 和textmode,如果当前组件为只读或者文本模式，则忽略该文本的输入。函数请用fn()进行包裹。参数如下所示：
		- ‘id’ 为输入控件的Id。
		- ‘text’ 为需要输入的文本，如果需要使用函数，请用fn()进行包裹。
		'''
		if self._is_readonly(id):
			return
		options = self._current_browser().execute_script("var options = cui('#"+id+"').options; return options == undefined ? null : options;")
		name=options["name"]
		self.input_text("name="+name,text)

	def click_cui_button(self,id):
		'''扩展点击按钮关键字，支持CUI Button 组件，检查当前按钮是否被禁用，如果按钮为禁用状态，则不执行点击操作。参数如下所示：
		- ‘id’ 为按钮控件的id。
		'''
		options = self._current_browser().execute_script("var options = cui('#"+id+"').options; return options == undefined ? null : options;")
		if options is not None and options["disable"]:
			self._info("CUI '%s' component id = '%s' is disable" % (options["uitype"],id))
			return
		self.click_element("id="+id)

	def select_radio(self,id,index='1'):
		'''支持CUI Radio Group的选择。参数如下所示：
		- ‘id’ 为Radio Group控件的Id。
		- ‘index’ 选项索引，起始值为1，默认值为1；
		'''
		self._info("Select radio (id = '%s')  by index '%s'" % (id, index))
		if self._is_readonly(id):
			return
		locator = "//span[@id = '" + id + "']/descendant::input["+index+"]"
		element = self._element_find(locator,True,True)
		if element is not None:
			readonly = element.get_attribute("readonly")
			if readonly is None or readonly.lower() != "readonly":
				self.click_element(locator)

	def select_checkbox(self,id,indexes=[1]):
		'''支持CUI Checkbox Group的选择。参数如下所示：
		- ‘id’ 为Checkbox Group控件的Id。
		- ‘indexes’ 选项索引，起始值为1，默认值为1；格式为:[1,2,3]
		'''
		self._info("Select checkbox (id = '%s')  by index '%s'" % (id, str(indexes)))
		if self._is_readonly(id):
			return
		self._current_browser().execute_script("cui('#"+id+"').setValue([])")
		locator = "//span[@id = '" + id + "']/descendant::input"
		items = self._element_find(locator,False,False)
		l = len(items)
		if l == 0:
			raise ValueError("Checkbox (id = '%s') can not selected!." % id)
		options = []
		if type(indexes) is list:
			options = rIndexes
		elif type(indexes) is int:
			options.append(rIndexes)
		elif type(indexes) is unicode:
			ret = str(indexes).replace('[','').replace(']','').split(',')
			for item in ret:
				options.append(int(item));
		else:
			options.append(1)
		for i in options:
			if i <= l and i>=1:
				element = items[i-1]
				readonly = element.get_attribute("readonly")
				if readonly is None or readonly.lower() != "readonly":
					element.click()
		
	def input_editgrid_text(self,tableId,rowIndex,colIndex,text):
		'''支持CUI EditGrid中的文本输入，参数如下所示：
		- ‘tableId’ EditGrid的Id，用于定位表格。
		- ‘rowIndex’ 为当前表格需要输入的行索引，起始值为1；
		- ‘colIndex’ 为当前表格需要输入的列索引，起始值为1；
		- ‘text’ 为需要输入的文本，如果需要使用函数，请用fn()进行包裹。
		'''
		self._info("Typing text '%s' into editgrid '%s' row '%s' column '%s' text field " % (text, tableId,rowIndex,colIndex))
		td = "//table[@id='"+tableId+"']/tbody/tr["+rowIndex+"]/td["+colIndex+"]"
		self.click_element(td)
		time.sleep(1)
		input_locator = td+"/descendant::input"
		self.input_text(input_locator,text)
		self.click_element("//table[@id='"+tableId+"']/ancestor::div[@class='eg-body']")
		time.sleep(1)

	def input_editgrid_textarea(self,tableId,rowIndex,colIndex,text):
		'''支持CUI EditGrid中的文本输入，参数如下所示：
		- ‘tableId’ EditGrid的Id，用于定位表格。
		- ‘rowIndex’ 为当前表格需要输入的行索引，起始值为1；
		- ‘colIndex’ 为当前表格需要输入的列索引，起始值为1；
		- ‘text’ 为需要输入的文本，如果需要使用函数，请用fn()进行包裹。
		'''
		self._info("Typing text '%s' into editgrid '%s' row '%s' column '%s' text field " % (text, tableId,rowIndex,colIndex))
		td = "//table[@id='"+tableId+"']/tbody/tr["+rowIndex+"]/td["+colIndex+"]"
		self.click_element(td)
		time.sleep(1)
		input_locator = td+"/descendant::textarea"
		self.input_text(input_locator,text)
		self.click_element("//table[@id='"+tableId+"']/ancestor::div[@class='eg-body']")
		time.sleep(1)

	def select_editgrid_radio(self,tableId,rowIndex,colIndex,rIndex='1'):
		'''支持CUI EditGrid中的Radio Group选择，默认选择第一项。参数如下所示：
		- ‘tableId’ EditGrid的Id，用于定位表格。
		- ‘rowIndex’ 为当前表格需要输入的行索引，起始值为1；
		- ‘colIndex’ 为当前表格需要输入的列索引，起始值为1；
		- ‘rIndex’ 选项索引，起始值为1，默认值为1；
		'''
		self._info("Radio click on editgrid '%s' row '%s' column '%s' " % (tableId,rowIndex,colIndex))
		td = "//table[@id='"+tableId+"']/tbody/tr["+rowIndex+"]/td["+colIndex+"]"
		self.click_element(td)
		time.sleep(1)
		input_locator = td+"/descendant::input["+rIndex+"]"
		self.click_element(input_locator)
		self.click_element("//table[@id='"+tableId+"']/ancestor::div[@class='eg-body']")
		time.sleep(1)

	def select_editgrid_checkbox(self,tableId,rowIndex,colIndex,rIndexes=[1]):
		'''支持CUI EditGrid中的Checkbox Group选择，默认选择第一项。参数如下所示：
		- ‘tableId’ EditGrid的Id，用于定位表格。
		- ‘rowIndex’ 为当前表格需要输入的行索引，起始值为1；
		- ‘colIndex’ 为当前表格需要输入的列索引，起始值为1；
		- ‘rIndexes’ 选项索引数组，选项索引起始值为1，默认值为1；格式为:[1,2,3]
		'''
		self._info("Checkbox click on editgrid '%s' row '%s' column '%s' " % (tableId,rowIndex,colIndex))
		td = "//table[@id='"+tableId+"']/tbody/tr["+rowIndex+"]/td["+colIndex+"]"
		self.click_element(td)
		time.sleep(1)
		input_locator = td+"/descendant::input"
		items = self._element_find(input_locator,False,False)
		l = len(items)
		if l == 0:
			raise ValueError("Checkbox click on editgrid '%s' row '%s' column '%s'  can not selected!." % (tableId,rowIndex,colIndex))
		options = []
		if type(rIndexes) is list:
			options = rIndexes
		elif type(rIndexes) is int:
			options.append(rIndexes)
		elif type(rIndexes) is unicode:
			ret = str(rIndexes).replace('[','').replace(']','').split(',')
			for item in ret:
				options.append(int(item));
		else:
			options.append(1)
		for i in options:
			if i <= l and i>=1:
				items[i-1].click()
		self.click_element("//table[@id='"+tableId+"']/ancestor::div[@class='eg-body']")
		time.sleep(1)

	def select_editgrid_pulldown_single(self,tableId,rowIndex,colIndex,rIndex=1):
		'''支持CUI EditGrid中的Pulldown 单项选择，默认选择第一项。参数如下所示：
		- ‘tableId’ EditGrid的Id，用于定位表格。
		- ‘rowIndex’ 为当前表格需要输入的行索引，起始值为1；
		- ‘colIndex’ 为当前表格需要输入的列索引，起始值为1；
		- ‘rIndex’ 选项索引，起始值为1，默认值为1；
		'''
		self._info("Pulldown selected on editgrid '%s' row '%s' column '%s' " % (tableId,rowIndex,colIndex))
		td = "//table[@id='"+tableId+"']/tbody/tr["+rowIndex+"]/td["+colIndex+"]"
		self.click_element(td)
		time.sleep(1)
		input_locator = td+"/div[@class='eg-edit-box pulldown-main']"
		self.click_element(input_locator)
		time.sleep(1)
		style = self._current_browser().execute_script("var style = cui('#"+tableId+"').editObj.cuiObj.$box[0].style.cssText; return style == undefined ? null : style;")
		if style is None:
			raise ValueError("The Pulldown box of editgrid '%s' row '%s' column '%s' error!." % (tableId,rowIndex,colIndex))
		options = self._element_find("//div[(@class='pulldown-box') and (@style='"+style+"')]/div/a[contains(@class,'pulldown-list')]",False,False)
		if len(options) == 0:
			raise ValueError("The Pulldown box of editgrid '%s' row '%s' column '%s' can not find any select items!." % (tableId,rowIndex,colIndex))
		options[int(rIndex)-1].click()
		self.click_element("//table[@id='"+tableId+"']/ancestor::div[@class='eg-body']")
		time.sleep(1)

	def select_editgrid_pulldown_multi(self,tableId,rowIndex,colIndex,rIndexes=[1]):
		'''支持CUI EditGrid中的Pulldown 多项选择，默认选择第一项。参数如下所示：
		- ‘tableId’ EditGrid的Id，用于定位表格。
		- ‘rowIndex’ 为当前表格需要输入的行索引，起始值为1；
		- ‘colIndex’ 为当前表格需要输入的列索引，起始值为1；
		- ‘rIndexes’ 选项索引数组，选项索引起始值为1，默认值为1；格式为:[1,2,3]
		'''
		self._info("Pulldown selected on editgrid '%s' row '%s' column '%s' " % (tableId,rowIndex,colIndex))
		td = "//table[@id='"+tableId+"']/tbody/tr["+rowIndex+"]/td["+colIndex+"]"
		self.click_element(td)
		time.sleep(1)
		input_locator = td+"/div[@class='eg-edit-box pulldown-main']"
		self.click_element(input_locator)
		time.sleep(1)
		style = self._current_browser().execute_script("var style =  cui('#"+tableId+"').editObj.cuiObj.$box[0].style.cssText; return style == undefined ? null : style;")
		if style is None:
			raise ValueError("The Pulldown box of editgrid '%s' row '%s' column '%s' error!." % (tableId,rowIndex,colIndex))
		items = self._element_find("//div[(@class='pulldown-box multi-pulldown-box') and (@style='"+style+"')]/div/a[contains(@class,'pulldown-list')]",False,False)
		l = len(items)
		if l == 0:
			raise ValueError("The Pulldown box of editgrid '%s' row '%s' column '%s' can not find any select items!." % (tableId,rowIndex,colIndex))
		options = []
		if type(rIndexes) is list:
			options = rIndexes
		elif type(rIndexes) is int:
			options.append(rIndexes)
		elif type(rIndexes) is unicode:
			ret = str(rIndexes).replace('[','').replace(']','').split(',')
			for item in ret:
				options.append(int(item));
		else:
			options.append(1)
		for i in options:
			if i <= l and i>=1:
				items[i-1].click()
		self.click_element("//table[@id='"+tableId+"']/ancestor::div[@class='eg-body']")
		time.sleep(1)

	def select_editgrid_calender(self,tableId,rowIndex,colIndex):
		'''支持CUI EditGrid中的Pulldown 单项选择，默认选择第一项。参数如下所示：
		- ‘tableId’ EditGrid的Id，用于定位表格。
		- ‘rowIndex’ 为当前表格需要输入的行索引，起始值为1；
		- ‘colIndex’ 为当前表格需要输入的列索引，起始值为1；
		'''
		self._info("Calender selected on editgrid '%s' row '%s' column '%s' " % (tableId,rowIndex,colIndex))
		td = "//table[@id='"+tableId+"']/tbody/tr["+rowIndex+"]/td["+colIndex+"]"
		self.click_element(td)
		time.sleep(1)
		input_locator = td+"/div[@class='eg-edit-box']"
		self.click_element(input_locator)
		time.sleep(1)
		options = self._current_browser().execute_script("var options = cui('#"+tableId+"').editObj.cuiObj.options; return options == undefined ? null : options;")
		time.sleep(2)
		isrange =options['isrange']
		uuid = options['uuid']
		items = self._element_find("//div[@id='C_CR_"+uuid+"']/div[@class='C_CR_main_wrap']/div/descendant::a",False,False)
		l = len(items)
		if l == 0:
			raise ValueError("Calender  on editgrid '%s' row '%s' column '%s' can not selected!." % (tableId,rowIndex,colIndex))
		index = random.randint(0,l-1)
		items[index].click()
		if isrange :
			time.sleep(1)
			gap = random.randint(1,l-index)
			items[index+gap].click()
		time.sleep(2)
		self.click_element("//table[@id='"+tableId+"']/ancestor::div[@class='eg-body']")
		time.sleep(1)

	def choose_editgrid_user_single(self,tableId,rowIndex,colIndex,clear=False):
		'''支持CUI EditGrid中的人员选择控件的单项选择。参数如下所示：
		- ‘tableId’ EditGrid的Id，用于定位表格。
		- ‘rowIndex’ 为当前表格需要输入的行索引，起始值为1；
		- ‘colIndex’ 为当前表格需要输入的列索引，起始值为1；
		- ‘clear’ 表示执行选择之前是否需要清空以前的选项。
		'''
		self._info("Calender selected on editgrid '%s' row '%s' column '%s' " % (tableId,rowIndex,colIndex))
		td = "//table[@id='"+tableId+"']/tbody/tr["+rowIndex+"]/td["+colIndex+"]"
		self.click_element(td)
		time.sleep(1)
		input_locator = td+"/div[@class='eg-edit-box']"
		element = self._element_find(input_locator,True,False)
		id = element.get_attribute("id")
		self.choose_single_user(id,clear)
		self.click_element("//table[@id='"+tableId+"']/ancestor::div[@class='eg-body']")
		time.sleep(1)

	def choose_editgrid_user_multi(self,tableId,rowIndex,colIndex,num,clear=False):
		'''支持CUI EditGrid中的人员选择控件的多项选择。参数如下所示：
		- ‘tableId’ EditGrid的Id，用于定位表格。
		- ‘rowIndex’ 为当前表格需要输入的行索引，起始值为1；
		- ‘colIndex’ 为当前表格需要输入的列索引，起始值为1；
		- ‘num’ 表示多选人员时的最大数量，默认值为3，如果首次查找到的人员数量少于最大数量，则会实际找到的数量进行选择
		- ‘clear’ 表示执行选择之前是否需要清空以前的选项。
		'''
		self._info("Calender selected on editgrid '%s' row '%s' column '%s' " % (tableId,rowIndex,colIndex))
		td = "//table[@id='"+tableId+"']/tbody/tr["+rowIndex+"]/td["+colIndex+"]"
		self.click_element(td)
		time.sleep(1)
		input_locator = td+"/div[@class='eg-edit-box']"
		element = self._element_find(input_locator,True,False)
		id = element.get_attribute("id")
		self.choose_multi_user(id,num,clear)
		self.click_element("//table[@id='"+tableId+"']/ancestor::div[@class='eg-body']")
		time.sleep(1)

	def choose_editgrid_org_single(self,tableId,rowIndex,colIndex,clear=False):
		'''支持CUI EditGrid中的组织选择控件的单项选择。参数如下所示：
		- ‘tableId’ EditGrid的Id，用于定位表格。
		- ‘rowIndex’ 为当前表格需要输入的行索引，起始值为1；
		- ‘colIndex’ 为当前表格需要输入的列索引，起始值为1；
		- ‘clear’ 表示执行选择之前是否需要清空以前的选项。
		'''
		self._info("Calender selected on editgrid '%s' row '%s' column '%s' " % (tableId,rowIndex,colIndex))
		td = "//table[@id='"+tableId+"']/tbody/tr["+rowIndex+"]/td["+colIndex+"]"
		self.click_element(td)
		time.sleep(1)
		input_locator = td+"/div[@class='eg-edit-box']"
		element = self._element_find(input_locator,True,False)
		id = element.get_attribute("id")
		self.choose_single_org(id,clear)
		self.click_element("//table[@id='"+tableId+"']/ancestor::div[@class='eg-body']")
		time.sleep(1)

	def choose_editgrid_org_multi(self,tableId,rowIndex,colIndex,num,clear=False):
		'''支持CUI EditGrid中的组织选择控件的多项选择。参数如下所示：
		- ‘tableId’ EditGrid的Id，用于定位表格。
		- ‘rowIndex’ 为当前表格需要输入的行索引，起始值为1；
		- ‘colIndex’ 为当前表格需要输入的列索引，起始值为1；
		- ‘num’ 表示多选人员时的最大数量，默认值为3，如果首次查找到的人员数量少于最大数量，则会实际找到的数量进行选择
		- ‘clear’ 表示执行选择之前是否需要清空以前的选项。
		'''
		self._info("Calender selected on editgrid '%s' row '%s' column '%s' " % (tableId,rowIndex,colIndex))
		td = "//table[@id='"+tableId+"']/tbody/tr["+rowIndex+"]/td["+colIndex+"]"
		self.click_element(td)
		time.sleep(1)
		input_locator = td+"/div[@class='eg-edit-box']"
		element = self._element_find(input_locator,True,False)
		id = element.get_attribute("id")
		self.choose_multi_org(id,num,clear)
		self.click_element("//table[@id='"+tableId+"']/ancestor::div[@class='eg-body']")
		time.sleep(1)
	
	def _find_multi(self):
		ret = self._element_find("//li/span/span[@class='dynatree-checkbox']",False,False)
		while len(ret) == 0:
			folders = self._element_find("//li/span[(contains(@class,'dynatree-folder') and contains(@class, 'dynatree-has-children') and contains(@class, 'dynatree-exp-cd'))]",False,False)
			self._info("Elements is %s ..." % folders)
			if len(folders) == 0: return ret
			for folder in folders: folder.click()
			ret  = self._element_find("//li/span/span[@class='dynatree-checkbox']",False,False)
		return ret

	def _find_single_user(self):
		ret = self._element_find("//li/span[contains(@class,'dynatree-exp-c') and not(contains(@class,'dynatree-exp-cd')) and not(contains(@class,'dynatree-folder'))]/a",False,False)
		while len(ret) == 0:
			folders = self._element_find("//li/span[(contains(@class,'dynatree-folder') and contains(@class, 'dynatree-has-children') and contains(@class, 'dynatree-exp-cd'))]",False,False)
			if len(folders) == 0: return ret
			for folder in folders: folder.click()
			ret  = self._element_find("//li/span[contains(@class,'dynatree-exp-c') and not(contains(@class,'dynatree-exp-cd')) and not(contains(@class,'dynatree-folder'))]/a",False,False)
		return ret

	def _find_single_org(self):
		ret = self._element_find("//li/span[contains(@class,'dynatree-exp-c') and not(contains(@class,'dynatree-exp-cd'))]/a",False,False)
		while len(ret) == 0:
			folders = self._element_find("//li/span[(contains(@class,'dynatree-folder') and contains(@class, 'dynatree-has-children') and contains(@class, 'dynatree-exp-cd'))]",False,False)
			if len(folders) == 0: return ret
			for folder in folders: folder.click()
			ret  = self._element_find("//li/span[contains(@class,'dynatree-exp-c') and not(contains(@class,'dynatree-exp-cd'))]/a",False,False)
		return ret

	def _is_readonly(self,id):
		options = self._current_browser().execute_script("var options = cui('#"+id+"').options; return options == undefined ? null : options;")
		if options is not None and (options["readonly"]  or options["textmode"]):
			self._info("CUI '%s' component id = '%s' is readonly or textmode" % (options["uitype"],id))
			return True
		return False
	
	def _currentFrame(self):
		return self._current_browser().execute_script("var elem = window.frameElement; return elem == undefined ? null : elem;")

	def _currentFrameId(self):
		return self._current_browser().execute_script("var id = (window.frameElement==null ? null : window.frameElement.getAttribute('id')); return id == undefined ? null : id;")

	def _currentFrameName(self):
		return self._current_browser().execute_script("var name = (window.frameElement==null ? null : window.frameElement.getAttribute('name')); return name == undefined ? null : name;")

	def _switchToFrame(self,frameId,rems):
		browser = self._current_browser()
		frames = self._element_find("xpath=//frame|//iframe", False, False)
		self._info('Current frame has %d subframes' % len(frames))
		if len(frames)==0:
			return False
		for frame in frames:
			rems.append(frame)
			browser.switch_to_frame(frame)
			currentId = self._currentFrameId()
			self._info("Current frame id is '%s'" % currentId)
			if frameId == currentId:
				return True
			ret = self._switchToFrame(frameId,rems)
			if ret:
				return True
			else:
				rems.pop()
				browser.switch_to_default_content()
				if len(rems)>0:
					for rem in rems:
						browser.switch_to_frame(rem)					

	def decode(self,str,mode):
		'''解码，将后台传输过来的数据按照指定编码重新进行编码，解决中文乱码的问题。参数如下所示：
		- ‘str’ 编码后的字符串
		- ‘mode’  字符编码名称，如utf-8,gbk等等
		'''
		return str.decode(mode)

	def  defined_javascript_error_cache(self):
		'''定义JavaScript报错缓存，如果需要检测JavaScript脚本是否报错，需要在执行操作之前先执行该关键字进行定义。'''
		browser = self._current_browser()
		script = "window.errors = [] ;  window.onerror = function(message,source,lineno,colno,error){ window.errors.push('Error:'+message+' Script:'+source+' Line:' + lineno+' Column:' + colno); return false;}"
		browser.execute_script(script)

	def clean_javascript_error(self):
		'''清理JavaScript报错信息。如果在一个用例中需要在多个操作中检测JavaScript异常，只需要执行一次定义关键字，后续操作在执行之前需要执行清除JavaScript报错信息，以便下一次进行检测。'''
		browser = self._current_browser()
		script = "window.errors = []; "
		browser.execute_script(script)

	def check_javascript_error(self):
		'''检测JavaScript缓存中是否存在异常，如果存在，则会抛出异常，测试工具会自动截图并记录日志'''
		browser = self._current_browser()
		script = "return window.errors.length > 0;"
		ret = browser.execute_script(script)
		if ret :
			script = "return window.errors;"
			es = browser.execute_script(script)
			for e in es:
				self._info('%s' % e)
			raise AssertionError("Current action has erros,view detail message in console!" )


	chars = ['0','1','2','3','4','5','6','7','8','9','A','B','C','D','E','F','G','H','I','J','K','L','M','N','O','P','Q','R','S','T','U','V','W','X','Y','Z']

	def _gen_mixed(self,n):
		ret = ""
		for i in range(0,int(n)):
			id = math.ceil(random.random()*35);
			ret += ComtopLibrary.chars[int(id)]
		print ret
		return ret;

	def top_encrypt(self,code):
		'''TOP密码加密方式'''
		start = self._gen_mixed(10)
		end = self._gen_mixed(10)
		enTxt = []
		enTxt.append(start)
		for c in code:
			ret = hex(ord(c)).replace('0x','')
			enTxt.append(ret)
		enTxt.append(end)
		ret = '\\'.join(enTxt)
		self._info('Rest : %s' % ret)
		return ret

