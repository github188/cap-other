<%@ taglib uri="http://www.szcomtop.com/top" prefix="top"%>
<%@ include file="/top/component/common/Taglibs.jsp"%>
<%@ page contentType="text/html; charset=GBK" %>
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
    <title>choose example</title>
    <link rel="stylesheet" href="${pageScope.cuiWebRoot}/top/component/topui/cui/themes/default/css/comtop.ui.min.css" type="text/css"/>
    <link rel="stylesheet" href="${pageScope.cuiWebRoot}/top/sys/usermanagement/orgusertag/css/choose.css" type="text/css"/>
   <script  type="text/javascript" src="${pageScope.cuiWebRoot}/top/component/topui/cui/js/comtop.ui.min.js"></script>
    <script type="text/javascript" src="${pageScope.cuiWebRoot}/top/sys/usermanagement/orgusertag/js/userOrgUtil.js"></script>
    <script type="text/javascript" src="${pageScope.cuiWebRoot}/top/sys/usermanagement/orgusertag/js/choose.js" ></script>
    <style type="text/css">
    html,body{
    margin:0px;
    }
    </style>
    <script type="text/javascript">
// var dept = [
//   {id:"1040000008",name:"�й�/��dddd/��������"},{id:"1040000110",name:"������������"},{id:"1040000091",name:"���Ź����"}];
// 	var sing = {id:"1040000008",name:"��������"};
// 	var data = {"dept":dept};
	var opts = {'codeName':'testCodeName2'};
	</script>
</head>
<body>
<div uitype="borderlayout"  id="le" is_root="true" >
<form name="testOrgname">
<div>��֯��</div>
    <top:chooseOrg id="chooseOrgMultiOrder_22" opts="{'codeName':'testCodeName'}" isFullName="true" formName="testOrgname" idName="jsp_singleOrgId" valueName="jsp_singleOrgName"  width="200px" textmode="false" levelFilter="5" value='dept' isSearch="true" height="50px" unselectableCode="03"  isAllowOther="true" callback="chooseCallback" rootId="1040000001" showLevel="3"  showOrder="order" delCallback="delCallback" ></top:chooseOrg>
    
    <span uitype="ChooseOrg" id="chooseOrgMultiOrder_23" opts='{"codeName":"testCodeName2"}' isFullName="true"  formName="testOrgname" idName="jsp_singleOrgId" valueName="jsp_singleOrgName"  width="200px" textmode="false" levelFilter="5" value='dept' isSearch="true"  height="50px" unselectableCode="03"  isAllowOther="true" callback="chooseCallback" rootId="1040000001" showLevel="3"  showOrder="order" delCallback="delCallback" ></span>
    
    <input type="hidden" id="multiOrgId" value="1040000008">
</form>
<form name="testUserName">
<input type="hidden" id="singleUserId" value="SuperAdmin">
<div>�û���</div>
</form>
<div>
	<div>ֻ���������������</div>
	<span id="chooseOrgOnlyinput"  uitype="ChooseOrg" height="50px" chooseMode="10" maxLength="10" canSelect='false' delCallback="delCallback" ></span>
	<top:chooseOrg id="chooseOrgOnlyinput2" height="50px" chooseMode="10" maxLength="10" canSelect='false' delCallback="delCallback" ></top:chooseOrg>
	
	<div style="margin: 10px;">
	   	<div>
	   		<span>����һ����ѡ��֯ѡ���ǩ���ԣ�������ʾ</span>
	   		<span style="padding-left:100px;">����������ѡ��֯ѡ���ǩ���ԣ�������ʾ</span>
	   	</div>
	    <div >
		    <span id="chooseOrgSingleOrder" uitype="ChooseOrg" height="30px"  width="250px" validate="����У��" openCallback="openCallback" value="sing"  isSearch="false" rootId="0" defaultOrgId="1040000004" levelFilter="6" chooseMode="1" readonly="false" unselectableCode="^(00)" isAllowOther="true" callback="chooseCallback"  showLevel="4"  showOrder="order" delCallback="delCallback" ></span>
	    	<span style="padding-left:100px;">
			    <span id="chooseOrgMultiOrder" uitype="ChooseOrg" height="90px" width="500px" textmode="false" value='dept' isSearch="true" defaultOrgId="1040000004" height="50px" chooseMode="10" readonly="false" unselectableCode="03"  isAllowOther="false" callback="chooseCallback" rootId="0" showLevel="3"  showOrder="order" delCallback="delCallback" ></span>
	    	</span>
	    </div>
	</div>
	   
	<div style="margin: 10px;">    
	    <div>
	   		<span>����������ѡ��֯ѡ���ǩ���ԣ�������ʾ</span>
	   		<span style="padding-left:100px;">�����ģ���ѡ��֯ѡ���ǩ���ԣ�������ʾ</span>
	   	</div>
	   	<div>
		   	<top:chooseOrg id="chooseOrgSingleReverse" height="30px" width="250px"  openCallback="openCallback" chooseMode="1" readonly="false" isAllowOther="true" callback="chooseCallback" rootId="" showLevel="1"  showOrder="reverse" delCallback="delCallback" ></top:chooseOrg>
		    <span style="padding-left:100px;">
		    	<span id="chooseOrgMultiReverse" uitype="ChooseOrg" width="500px"  height="90px" databind="data.dept" chooseMode="10" readonly="false" isAllowOther="true" callback="chooseCallback" rootId="" showLevel="1"  showOrder="reverse" delCallback="delCallback" ></span>
		    </span>
	   	</div>
	 </div>
	 <div style="margin: 10px;">
	 	<div>
	   		<span>�����壺��ѡ��֯ѡ���ǩ���ԣ�����</span>
	   		<span style="padding-left:100px;">����������ѡ��֯ѡ���ǩ���ԣ�����</span>
	   	</div>
	   	<div>
		    <top:chooseOrg id="chooseOrgSingleForm" width="250px" height="30px" chooseMode="1" readonly="false" isAllowOther="true" callback="chooseCallback" rootId="" formName="testOrgname" idName="singleOrgId" valueName="singleOrgName" delCallback="delCallback" ></top:chooseOrg>
			<span style="padding-left:100px;">
		    	<top:chooseOrg id="chooseOrgMultiForm" width="500px" height="90px" chooseMode="10" readonly="false" isAllowOther="true" callback="chooseCallback" rootId="" formName="testOrgname" idName="multiOrgId" valueName="multiOrgName" delCallback="delCallback" ></top:chooseOrg>
			</span>
	   	</div>
	   	
	 </div>
	 
	 <div style="margin: 10px;">
	 	<div>
	   		<span>�����ߣ���ѡ��Աѡ���ǩ���ԣ�����</span>
	   		<span style="padding-left:100px;">�����ˣ���ѡ��Աѡ���ǩ���ԣ�����</span>
	   	</div>
	   	<div>
		    <span   uitype="ChooseUser" id="chooseUserSingleForm" width="250px" height="30px"  chooseMode="1" userType="1" readonly="false" isAllowOther="true" callback="chooseCallback" orgStructureId="" rootId="1190000001" formName="testUserName" idName="singleUserId" valueName="singleUserName"  ></span>
		    <span style="padding-left:100px;">
		    	<top:chooseUser id="chooseUserMultiForm" height="90px" width="500px" chooseMode="0" userType="1" readonly="false" isAllowOther="false" orgStructureId="" callback="chooseCallback"   rootId="0" defaultOrgId="1040000004" formName="testUserName" idName="multiUserId" valueName="multiUserName" ></top:chooseUser>
	   		</span>
	   	</div>
	 </div>
	 
	 
	 <div style="margin: 10px;">
	 	<div>
	   		<span>�����ţ���ѡ��Աѡ���ǩ  ���ڵ�����ʽ</span>
	   		<span style="padding-left:100px;">����ʮ����ѡ��Աѡ���ǩ���ԣ����ڵ�����ʽ</span>
	   	</div>
	   	<div>
		    <span   uitype="ChooseUser" id="chooseUserSingleFormW" width="250px" height="30px" validate="[{'type': 'required','rule':{'m':'����Ϊ��'}}]" winType="window"  chooseMode="1" userType="1" readonly="false" isAllowOther="true" callback="chooseCallback" orgStructureId="" rootId="1190000001" formName="testUserName" idName="singleUserId" valueName="singleUserName"  ></span>
		    <span style="padding-left:100px;">
		    	<top:chooseUser id="chooseUserMultiFormW" height="90px" width="500px" winType="window" chooseMode="0" userType="1" readonly="false" isAllowOther="false" orgStructureId="" callback="chooseCallback"   rootId="0" defaultOrgId="1040000004" formName="testUserName" idName="multiUserId" valueName="multiUserName" ></top:chooseUser>
	   		</span>
	   	</div>
	 </div>
	 
	 <div style="margin: 10px;">
	 	<div>
	   		<span>����ʮһ����ѡ��֯ѡ���ǩ  ���ڵ�����ʽ</span>
	   		<span style="padding-left:100px;">����ʮ������ѡ��֯ѡ���ǩ���ԣ����ڵ�����ʽ</span>
	   	</div>
	   	<div>
		    <top:chooseOrg id="chooseOrgSingleFormW" width="250px"  height="30px"  winType="window"  chooseMode="1" readonly="false" isAllowOther="true" callback="chooseCallback" rootId="" formName="testOrgname" idName="singleOrgId" valueName="singleOrgName" delCallback="delCallback" ></top:chooseOrg>
			<span style="padding-left:100px;">
		    	<top:chooseOrg id="chooseOrgMultiFormW" width="500px" height="90px"  winType="window"  chooseMode="10" readonly="false" isAllowOther="true" callback="chooseCallback" rootId="" formName="testOrgname" idName="multiOrgId" valueName="multiOrgName" delCallback="delCallback" ></top:chooseOrg>
			</span>
	   	</div>
	 </div>
	 
	 <div style="margin: 10px;">
	 	<div>
	   		<span>����ʮ������ѡ��Աѡ���ǩ���ԣ��������Ϊһ��ʱ�����س�ѡ�н��</span>
	   	</div>
	   	<div>
		    <span   uitype="ChooseUser" id="chooseUserSingleFormSC" singleChoose="true" width="250px" height="30px"  chooseMode="1" userType="1" readonly="false" isAllowOther="false"></span>
	   	</div>
	 </div>
	 
	 <div style="margin: 10px;">
	 	<div>
	   		<span>����ʮ�ģ���ѡ��Աѡ���ǩ���ԣ��������Ϊһ��ʱ�����س�ѡ�н��</span>
	   	</div>
	   	<div>
		    <span>
		    	<top:chooseUser id="chooseUserMultiFormSC" singleChoose="true" height="90px" width="500px" chooseMode="0" userType="1" readonly="false" isAllowOther="false"></top:chooseUser>
	   		</span>
	   	</div>
	 </div>
	 
	 <div style="margin: 10px;">
	 	<div>
	   		<span>����ʮ�壺��ѡ��֯ѡ���ǩ����,����ѡ���¼�����֯</span>
	   	</div>
	   	<div>
		    <top:chooseOrg id="chooseOrgMultiCas" childSelect="true" width="500px" height="90px" chooseMode="0" readonly="false" isAllowOther="true" ></top:chooseOrg>
			
	   	</div>
	 </div>
	<top:chooseUser  id="chooseUser" chooseMode="1" height="30px" width="250px" isSearch="true" userType="1" readonly="false" isAllowOther="true" orgStructureId="" callback="chooseCallback" rootId="1030000284" defaultOrgId="1030011142" delCallback="delCallback" validate="����Ϊ��" ></top:chooseUser>	
	<top:chooseUser id="chooseUser2" width="500px" height="90px" chooseMode="0" userType="1" readonly="false" isAllowOther="true" orgStructureId="" callback="chooseCallback" rootId="1030011142" delCallback="delCallback" validate="����Ϊ��" isSearch="true"></top:chooseUser>	
	<top:chooseOrg id="chooseOrgMulti" childSelect="true" rootId="0" defaultOrgId="1040000001"  width="500px" height="90px" chooseMode="0" orgStructureId="" readonly="false" isAllowOther="true" callback="chooseCallback"  showLevel="4"  showOrder="order" delCallback="delCallback" ></top:chooseOrg>
	<div>
		<span uitype="Button" label="����" on_click="disable"></span>
		<span uitype="Button" label="����" on_click="enable"></span>
		<span uitype="Button" label="������Ա" on_click="setUser"></span>
		<span uitype="Button" label="��ȡ��Ա" on_click="getUser"></span>
		<span uitype="Button" label="��ȡ��Ա2" on_click="getUser2"></span>
		<span uitype="Button" label="����һ��ȡ��֯��" on_click="chooseOrgs1"></span>
		<span uitype="Button" label="��������ȡ��֯��" on_click="chooseOrgs2"></span>
		<span uitype="Button" label="��������ȡ��֯��" on_click="chooseOrgs3"></span>
		<span uitype="Button" label="�����Ļ�ȡ��֯��" on_click="chooseOrgs4"></span>
		<span uitype="Button" label="������Ա��ѡѡ��Ի���" mark="0" on_click="displayUserTag"></span>
		<span uitype="Button" label="������֯��ѡѡ��Ի���" mark="0" on_click="displayOrgTag"></span>
		<span uitype="Button" label="������Ա��ѡѡ��Ի���" mark="1" on_click="displayUserTag"></span>
		<span uitype="Button" label="������֯��ѡѡ��Ի���" mark="1" on_click="displayOrgTag"></span>
		
		<span uitype="Button" label="������Ա��ѡѡ�񴰿�" mark="0" on_click="displayUserTag2"></span>
		<span uitype="Button" label="������֯��ѡѡ�񴰿�" mark="0" on_click="displayOrgTag2"></span>
		<span uitype="Button" label="������Ա��ѡѡ�񴰿�" mark="1" on_click="displayUserTag2"></span>
		<span uitype="Button" label="������֯��ѡѡ�񴰿�" mark="1" on_click="displayOrgTag2"></span>
	</div>
</div>
<div uitype="borderlayout"  id="le" is_root="true" >

<script src="${pageScope.cuiWebRoot}/top/js/jquery.js" type="text/javascript"></script>
<script src="${pageScope.cuiWebRoot}/top/sys/dwr/engine.js" type="text/javascript"></script>
<script src="${pageScope.cuiWebRoot}/top/sys/dwr/interface/ChooseAction.js" type="text/javascript"></script>

<script type="text/javascript">
	window.onload = function(){
		comtop.UI.scan.debug = true;
// 		comtop.UI.scan.textmode = true;
var dept = [
  {id:"1040000008",title:"�й�/��dddd/��������"},{id:"1040000110",title:"������������"},{id:"1040000091",title:"���Ź����"}];
var dept2 = [
            {id:"1040000008"},{id:"isother1",name:"testother1",isOther:true},{id:"1040000110",title:"������������"},{id:"isother2",name:"testother2",isOther:true},{id:"isother3",name:"testother3",isOther:true},{id:"1040000091",name:"���Ź����"},{id:"isother4",name:"testother4",isOther:true}];

		comtop.UI.scan();
		cui("#chooseOrgMultiForm").setValue(dept2);
// 		cui("#chooseOrgSingleOrder").setValue([{id:"1040000008",title:"��������"}]);
// 		cui("#chooseOrgMultiOrder").setValue(dept);
		/*cui("#myChoose").chooseUser({
			id:"myChoose",
			width:"300px",
			height:"50px",
			chooseMode:"0",
			userType:"1",
			readonly:false,
			isAllowOther:"true",
			orgStructureId:"A",
			callback:chooseCallback,
			rootId:"",
			delCallback:delCallback,
			validate:"����Ϊ��o", 
			isSearch:"true"
		});*/
		//�����֤
		window.validater = cui().validate();
		window.validater.add('myChoose', 'required', { 
			m:'����Ϊ��'
			})
			
			cui.tip(
		        '#myChoose', //Ҫ��ʾTip��λ�ã�����ָ�������ĳ��HTML��ǩ����ʽ��һ��jqueryѡ�������ʽ
		        {
		            tipEl: $('#myChoose')  
		        }
		    );
		//ִ����֤
	    //window.validater.validAllElement(); 

	};

	window.onresize=function(){
// 		console.log("====xxxx");
	}
	
	function disable(){
		cui('#chooseUser').setReadonly(true);
	}

	
	function enable(){
		cui('#chooseUser').setReadonly(false);
	}

	function setUser(){
		var data = [{id:'aaa',name:'aaa',mobilePhone:'11111111111',fixPhone:'0000000',isOther:false}];
		data=[{id:'',name:''}];
		cui('#chooseUser').setValue([]);
	}

	function getUser(){
		alert(cui('#chooseUser').getValue()[0].orgId+'----'+cui('#chooseUser').getValue()[0].orgName);
		console.log(cui('#chooseUser').getValue());
	}
	function getUser2(){
		alert(cui('#chooseUser2').getValue()[0].orgId+'-----'+cui('#chooseUser2').getValue()[0].orgName);
		console.log(cui('#chooseUser2').getValue());
	}
	/**�˴�Ϊ�ص���ҵ����*/
	function chooseCallback(selected,id){
		console.log("ss:"+cui(data).databind().getValue());

// 		cui("#chooseUserSingleForm").setAttr("orgStructureId","B");
		comtop.UI.scan.textmode=false;
		comtop.UI.scan();
		console.log(selected);
		console.log("==="+id)
	}

	function delCallback(data,id){
		console.log(data);
		console.log("==="+id)
	}
	
	function openCallback(){
// 		alert("99");
		return true;
	}

	function chooseUsers(){
		var winWidth = 510;
		var chooseMode = 5;
		var chooseType = 'user';
		var userType = 1;
		var callback = 'chooseCallback';
		window.open("<cui:webRoot/>/top/sys/usermanagement/orgusertag/ChoosePage.jsp?chooseMode="+chooseMode+'&chooseType='+chooseType+'&userType='+userType+'&callback='+callback,"choosePage","left=300,top=250,width="+winWidth+",height=505,menu=no,toolbar=no,resizable=no,scrollbars=no");
	}

	function chooseUser(){
		var winWidth = 335;
		var chooseMode = 1;
		var chooseType = 'user';
		var userType = 1;
		var callback = 'chooseCallback';
		window.open("<cui:webRoot/>/top/sys/usermanagement/orgusertag/ChoosePage.jsp?chooseMode="+chooseMode+'&chooseType='+chooseType+'&userType='+userType+'&callback='+callback,"choosePage","left=300,top=250,width="+winWidth+",height=505,menu=no,toolbar=no,resizable=no,scrollbars=no");
	}

	function chooseOrgs(){
		var data = cui('#chooseOrgMulti').getValue();
		for(var i=0; i< data.length; i++){
		  alert(data[i].id + "  " + data[i].name + "  " + data[i].title);
		}
	}

	function chooseOrgs1(){
		var data = cui('#chooseOrgSingleOrder').getValue();
		for(var i=0; i< data.length; i++){
		  alert(data[i].id + "  " + data[i].name + "  " + data[i].title);
		}
	}

	function chooseOrgs2(){
		var data = cui('#chooseOrgMultiOrder').getValue();
		for(var i=0; i< data.length; i++){
		  alert(data[i].id + "  " + data[i].name + "  " + data[i].title);
		}
	}

	function chooseOrgs3(){
		var data = cui('#chooseOrgSingleReverse').getValue();
		for(var i=0; i< data.length; i++){
		  alert(data[i].id + "  " + data[i].name + "  " + data[i].title);
		}
	}

	function chooseOrgs4(){
		var data = cui('#chooseOrgMultiReverse').getValue();
		for(var i=0; i< data.length; i++){
		  alert(data[i].id + "  " + data[i].name + "  " + data[i].title);
		}
	}

	function displayUserTag(event,self,mark){
		  var obj ={};
		  obj.id="user"+mark;
		  obj.chooseMode = Number(mark);
		  obj.chooseType = 'user';
		  obj.userType = 1;
		  obj.callback = 'chooseCallback';
		  displayUserOrgTag(obj);
	}

	function displayOrgTag(event,self,mark){
		var obj ={};
		  obj.id = "org"+mark;
		  obj.chooseMode =  Number(mark);
		  obj.chooseType = 'org';
		  obj.userType = 1;
		  obj.callback = 'chooseCallback';
		  displayUserOrgTag(obj);
	}

	function displayUserTag2(event,self,mark){
		  var obj ={};
		  obj.id="user"+mark;
		  obj.chooseMode = Number(mark);
		  obj.chooseType = 'user';
		  obj.userType = 1;
		  obj.callback = 'chooseCallback';
		  obj.winType="window";
		  displayUserOrgTag(obj);
	}

	function displayOrgTag2(event,self,mark){
		var obj ={};
		  obj.id = "org"+mark;
		  obj.chooseMode =  Number(mark);
		  obj.chooseType = 'org';
		  obj.userType = 1;
		  obj.callback = 'chooseCallback';
		  obj.winType="window";
		  displayUserOrgTag(obj);
	}
	
</script>
</body>
</html>