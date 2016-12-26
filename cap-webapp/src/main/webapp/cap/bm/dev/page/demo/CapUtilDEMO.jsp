<%
/**********************************************************************
* 示例页面
* 2015-5-13 郑重 新建
**********************************************************************/
%>
<%@ page language="java" contentType="text/html; charset=UTF-8"  pageEncoding="UTF-8"%>
<%@ include file="/cap/bm/common/Taglibs.jsp" %>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>CAP公共JS示例</title>
    <link rel="stylesheet" href="lib/cui/themes/default/css/comtop.ui.min.css"/>
    <script type="text/javascript" src="${pageScope.cuiWebRoot}/cap/bm/common/top/js/jquery.js"></script>
    <script type="text/javascript" src="${pageScope.cuiWebRoot}/cap/bm/common/base/js/comtop.cap.js"></script>
    <script type="text/javascript" src="${pageScope.cuiWebRoot}/cap/bm/common/cui/js/cui.utils.js"></script>
    <script type="text/javascript" src="${pageScope.cuiWebRoot}/cap/bm/common/jct/js/jct.js"></script>
    <top:script src="/cap/bm/common/cui/js/comtop.ui.min.js"></top:script>
    <top:script src="/cap/rt/common/base/js/comtop.cap.rt.js"></top:script>
    <script type="text/javascript">

        /**
         * 测试会话方法
         */
        function testSession(){
            //所有会话变量的key的前缀
            var pageSession = new cap.SessionStorage("page1");
            //设置变量
            pageSession.set("page","");
            pageSession.set("expression","111");
            pageSession.remove("page");
            alert(pageSession.get("expression"));
            pageSession.clear();
        }
        
        /**
         * 测试数据存储方法
         */
        function testDBStorage(){
            //所有会话变量的key的前缀
            var dbStorage = new cap.DBStorage("page1",function(){
            	 //设置变量
                this.set("page","12321");
                this.set("expression",{a:'1111'});
                this.remove("page");
                this.get("expression",function(value){
                	console.log(value);
                });
                //this.clear();
            });
            dbStorage.remove("page");
        }
        
        var listData = [
            {"firstName": "Vicki", "lastName": "Green", "age": 55, "salary": 69000},
            {"firstName": "Paul", "lastName": "Jones", "age": 33, "salary": 31000},
            {"firstName": "Susanna", "lastName": "Green", "age": 21, "salary": 46000}
        ];

        /**
         * 测试集合操作
         */
        function testQuery(){
            var q=new cap.CollectionUtil(listData);
            //查询方法，注意this不可删除，可以使用任何JavaScript表达式
            console.log(q.query('this.firstName=="Vicki"',"salary","asc"));
          	//新增方法
            q.insert({"firstName": "Vicki22", "lastName": "Green22", "age": 55, "salary": 69000});
            console.log(listData);
          	//修改方法
            q.update('this.salary==46000',{"age": 55555});
            console.log(listData);
          	//删除方法
            q.delete('this.salary==46000');
            console.log(listData);
			//查询结果排序
            var q2=new cap.CollectionUtil(listData);
            console.log(q2.query('this.age>1',"salary","asc"));
        }

        /**
         * 测试对象监控，用于页面自动存储事件触发
         */
        var dd={"a": "Vicki22", "b":{c:"dd",d:[{f:1}]}};
        function addObserve(){
            cap.addObserve(dd,function(changes){
            	addObserve();
                //当模型变化了自动保存到session中
                autoSave();
                changes.forEach(function(change) {
                 	console.log(change.type, change.name, change.oldValue);
                });
            });
        }
        function testObserve(){
            dd.a="zz";
            dd.b.c="zz1";
            dd.b.d[1]={f:2};
            dd.b.d[0]={f:2};
            /*var q=new cap.CollectionUtil(listData2);
            q.insert({"firstName": "Vicki22", "lastName": "Green22", "age": 55, "salary": 69000});*/
        }
        /**
         * 如果模型变化了自动保存到session
         */
        function autoSave(){
            //所有会话变量的key的前缀
            var pageSession = new cap.SessionStorage("page1");
            //设置变量
            pageSession.set("page",cui.utils.stringifyJSON(dd));
        }
        
        function testValidate(){
        	var validate = new cap.Validate();
        	/*console.log(validate.validateElement('required',{m:'第三方的'},''));
    		console.log(validate.validateElement('numeric',{min:1,max:2},0));
    		console.log(validate.validateElement('email',{},'sss@163.com'));
    		console.log(validate.validateElement('dateFormat',{},'2001-01-01'));
    		console.log(validate.validateElement('length',{min:1,max:2},'2'));
    		console.log(validate.validateElement('inclusion',{within:['ff']},'ff'));
    		console.log(validate.validateElement('exclusion',{within:['ff']},'ff'));
    		console.log(validate.validateElement('custom',{against:function(value,args){return (value+args)==2;},args:1},1));*/
    		var validateRule={dd:[{type:'required',rule:{m:'第三方的'}}],iData:[{type:'numeric',rule:{min:1,max:2}}]};
    		var data={dd:null,iData:0};
    		console.log(validate.validateAllElement(data,validateRule));
    		
    		var data2=[{dd:null,iData:0},{dd:null,iData:0}];
    		console.log(validate.validateAllElement(data2,validateRule));
        }
        
        var data={html:'<input/>',url:'pageURL',closeable:true,tab_width:100,on_switch:'funS'};
        
        //字符串模板例子
        function testStringTemplete(){
    		var instance = new jCT(jQuery('#template').val());
    		instance.Build();
    		console.log(instance.GetView());
        }
        
      	//字符串模板例子
        function buildURL(){
        	console.log(cap.buildURL("${pageScope.cuiWebRoot}/cap/bm/common/top/js/form.ac",{"aa":'1',"b":'sdfd'}));
        	console.log(cap.buildURL("${pageScope.cuiWebRoot}/cap/bm/common/top/js/form.ac?",{aa:1,b:'sdfd'}));
        	console.log(cap.buildURL("${pageScope.cuiWebRoot}/cap/bm/common/top/js/form.ac?g=3",{aa:1,b:'sdfd'}));
    		console.log(cap.buildURL("${pageScope.cuiWebRoot}/cap/bm/common/top/js/form.ac?g=3&",{aa:1,b:'sdfd'}));
        }
      	
      	//获取数据字典
        function getDic(){
        	cap.dicDatas=[{"attrs":["isImport"],"list":[{"text":"工作施工难度大","value":"1"},{"text":"施工环境限制","value":"2"},{"text":"工作需要其他班组配合","value":"3"}],"code":"LCAM_zhengzhong_longTimeOutageReason"},{"attrs":["contractType","isOnFile"],"list":[{"text":"馈线没有联系","value":"1"},{"text":"馈线空载","value":"2"},{"text":"用户设备工作","value":"3"}],"code":"LCAM_zhengzhong_notTurnpowerReasonDic"}];
        	console.log(cap.getDicByCode('LCAM_zhengzhong_longTimeOutageReason'));
        	console.log(cap.getDicByAttr('isOnFile'));
        }
        
      	//测试cap.array.remove方法
      	function Human(name,age){
      		this.name = name;
      		this.age = age;
      	}
      	
      	var source = [1,2,3,1,4,3,5,true,"false",null,undefined,Infinity,new Human("z3",20),new Human("w5",22),{id:20,text:"some data"}];
      	var target = [0,1,3,5,"false","true",null,undefined,Infinity,new Human("z3",55),{name:"w5"},{id:20}];		
      	
      	var result = cap.array.remove(source,target,true);
      	//var result1 = cap.array.remove(source,target,false);
		
      	console.log(result);
      	//console.log(result1);
		
    </script>
</head>
<body>
    <button onclick="testSession()">测试会话</button>
    <button onclick="testQuery()">测试查询</button>
    <button onclick="addObserve()">添加对象监控</button>
    <button onclick="testObserve()">测试对象变化</button>
    <button onclick="testValidate()">测试校验工具</button>
    <button onclick="testStringTemplete()">测试模板</button>
    <button onclick="buildURL()">URL生成</button>
    <button onclick="getDic()">获取数据字典</button>
    <button onclick="testDBStorage()">测试数据存储</button>
    
    
    <textarea id="template" style="display:none">
    	{
			<!---if(data.title!=null){-->
			title: '+-data.title-+', 
			<!---}-->
			html: '+-data.html-+', 
			url: +-data.url-+,  
			closeable: +-data.closeable-+, 
			tab_width: +-data.tab_width-+,
			on_switch: +-data.on_switch-+
		}
	</textarea>
</body>
</html>