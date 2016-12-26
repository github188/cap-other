<%
  /**********************************************************************
	* CIP元数据建模----模型对象
	* 2015-9-10 姜子豪  新增
  **********************************************************************/
%>
<%@ include file="/cap/bm/common/Taglibs.jsp"%>
<%@ include file="/cap/bm/common/taglib/ExtendTaglibs.jsp"%>
<%@ page language="java" contentType="text/html; charset=UTF-8"  pageEncoding="UTF-8"%>
<!doctype html>
<html>
	<head>
		<title>服务新增</title>
		<top:link href="/cap/bm/common/top/css/top_base.css" />
		<top:link href="/cap/bm/common/top/css/top_sys.css" />
		<top:link href="/cap/bm/common/cui/themes/default/css/comtop.ui.min.css"/>
		<top:link href="/cap/bm/common/styledefine/css/public.css"/>
		<top:script src="/cap/bm/common/cui/js/comtop.ui.min.js" />
		<top:link href="/eic/css/eic.css" />
		<top:script src="/cap/bm/common/top/js/jquery.js" />
		<top:script src="/eic/js/comtop.eic.js" />
		<top:script src="/eic/js/comtop.ui.emDialog.js"/>
		<top:script src="/cap/dwr/engine.js" />
		<top:script src="/cap/dwr/util.js" />
		<top:script src="/cap/bm/common/js/capCommon.js" />
		<top:script src="/cap/dwr/interface/CapDocClassDefAction.js" />
	</head>
	<body>
		<div uitype="Borderlayout" id="border">
			<div position="left" width="200">
				<div id="tree" uitype="Tree" checkbox="false" select_mode="1" on_click="onclick" children="getReqListData"></div>
			</div>
			<div position="center">
				<div id="entityManTab" uitype="tab" tab_width="100px" tabs="tabs" fill_height="true" ></div>
			</div>
		</div>
		<script type="text/javascript">
			var classUri;
			var classKey;
			var tabs_1 = [ {
		        title: "模型对象属性配置",
		        url: "ReqConfigList.jsp?"
		    },{
		        title: "需求附件元素配置",
		        url: "AttTypeList.jsp?"
		    }
		    ];
			
			var tabs  = tabs_1;
			//初始化 
			window.onload = function(){
				comtop.UI.scan();
				cui("#tree").getNode(classUri).activate(true);
				cui("#entityManTab").setTab(0, "url", "ReqConfigList.jsp?classUri="+classUri+"&reqType="+classKey);
				cui("#entityManTab").setTab(1, "url", "AttTypeList.jsp?classUri="+classUri+"&reqType="+classKey);
		   	}
			
			//需求Tree数据加载
			function getReqListData(obj){
				dwr.TOPEngine.setAsync(false);
				CapDocClassDefAction.queryReqList(function(data){
					var initData = [];
			    	for(var i=0;i<data.list.length;i++)
			    	{
			    		var item={'title':data.list[i].name+"【"+data.list[i].cnName+"】",'key':data.list[i].uri};
			    		initData.push(item);
			    	}
			    	classKey=data.list[0].name;
			    	classUri=data.list[0].uri;
			    	obj.setDatasource(initData);
 				});
				dwr.TOPEngine.setAsync(true);
			}
			
			//点击数节点修改grid数据源
			function onclick(node, event){
				//获取需求类型 
				var str = node.getData("title").split("【");
				classUri=node.getData("key");
				classKey=str[0];
				cui("#entityManTab").setTab(0, "url", "ReqConfigList.jsp?classUri="+classUri+"&reqType="+classKey);
				cui("#entityManTab").setTab(1, "url", "AttTypeList.jsp?classUri="+classUri+"&reqType="+classKey);
	        }
		</script>
	</body>
</html>
