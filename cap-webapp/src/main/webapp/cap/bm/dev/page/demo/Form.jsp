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
    <title>CUI控件占位和定义分离</title>
    <link rel="stylesheet" href="${pageScope.cuiWebRoot}/cap/bm/common/cui/themes/default/css/comtop.ui.min.css"/>
    <link rel="stylesheet" href="${pageScope.cuiWebRoot}cap/bm/common/base/css/base.css"/>
    <script type="text/javascript" src="${pageScope.cuiWebRoot}/cap/bm/common/top/js/jquery.js"></script>
    <script type="text/javascript" src="${pageScope.cuiWebRoot}/cap/bm/common/cui/js/comtop.ui.min.js"></script>
    <script type="text/javascript" src="${pageScope.cuiWebRoot}/cap/bm/common/cui/js/comtop.ui.editor.min.js"></script>
    <script type="text/javascript" src="${pageScope.cuiWebRoot}/cap/bm/dev/page/demo/js/data.js"></script>
    <script type='text/javascript' src='${pageScope.cuiWebRoot}/cap/dwr/engine.js'></script>
	<script type='text/javascript' src='${pageScope.cuiWebRoot}/cap/dwr/util.js'></script>
	<script type='text/javascript' src='${pageScope.cuiWebRoot}/cap/dwr/interface/FormAction.js'></script>
    <script type="text/javascript">
    	//页面参数自动生成JavaScript变量
    	var stringAttr="<%=request.getAttribute("stringAttr")%>";
    	var intAttr=<%=request.getAttribute("intAttr")%>;
    	var verifyAttr=<%=request.getAttribute("verifyAttr")%>;
    	
    
        //页面控件属性配置
        var uiConfig={
            button:{
                uitype:'Button',
                name:'save_continue_btn',
                label:'保存继续',
                icon:'glass',
                hide:false,//初始化时候是否隐藏,hidden会与标签的默认属性冲突
                disable:false,//初始化时候是否禁用
                on_click:null,//点击事件
                menu:{
                    datasource:
                            [
                                {id:'item1',label:'选项1'},
                                {id:'item2',label:'选项2'},
                                {id:'item3',label:'选项3'}
                    ],
                    on_click: function(obj){
                        alert(obj.id);
                    }
                },//下拉菜单
                button_type:"blue-button",//菜单的样式
                mark:""
            },
            input:{
                uitype:'Input',
                databind:'data.input',
                validate:[
                    {'type':'required', 'rule':{m: '缺陷名称不能为空'}},
                    {'type':'length', 'rule':{max:3,maxm: '缺陷名称小余3个字符'}},
                    {'type':'numeric', 'rule':{'oi':true,'notim':'学号必是数字'}},
                    {'type':'numeric', 'rule':{'min':5.4,'max':10.2,minm:'学号应该大于等于5.4',maxm:'学号应该小余等于10'}},
                    {'type':'format', 'rule':{pattern: '(\\d+)\\.(\\d+)\\.(\\d+)\\.(\\d+)',m: 'IP输入不合法'}},
                    {'type':'custom', 'rule':{against:'input_custom_validate',m:'输入的学号必须大于10000'}}
                ],
                name:'code',
                width: '200px',         //默认宽度
                readonly: false,        //是否只读
                maxlength: -1,          //最大长度-1为不限制长度
                byte: true,             //最大长度计算方式，true按字节计算，false按字符计算
                value: '似懂非懂',              //默认文本值
                emptytext: '点点滴滴',          //当前没有输入时显示的值
                type: 'text',           //组件类型text/password
                mask: '',               //inputmask模板属性
                fill: '',               //当输入框为空的时候，代替字符，比如，当mask="Money"，在清空输入框的时候，失焦，这时候，自动填充
                maskoptions: {},        //inputmask模板扩展
                textmode: false,        //是否为只读模式
                align: 'left',          //input框的文字对齐
                on_change: null,        //值改变事件
                on_focus: null,         //获得焦点事件
                on_blur: null,          //丢失焦点事件
                on_keyup: null,         //keyup事件
                on_keydown: null,        //keydown事件
                on_keypress: null       //keypress事件
            },
            calender:{
                uitype: 'Calender',
                databind:'data.calender',
                name: 'calender',
                model: 'date',              //功能模式，默认值为 date，值有[date|year|quarter|month|week|all]，
                //分别代表[选择日期|选择年份|选择季度|选择月份|选择周|所有功能]
                //同时也支持自由组合，如'date;year'，则代表只显示日期和年
                isrange: false,             //是否开启范围选择
                trigger: 'click',           //触发事件，默认为click
                value: [],                  //默认日期，存放日期
                defdate: '',                //面板默认日期
                format: '',                 //输出格式，如果model为all，format可为数组 ['yyyy-MM-dd','yyyy年第q季度']
                entering: true,            //文本框是否可以输入
                emptytext: '',              //空文本提示
                readonly: false,            //是否可读
                disable: false,             //是否不可用
                icon: true,                 //是否提供图标点击打开日期组件
                textmode: false,            //是否开启文本模式
                panel: 1,                   //显示供选择的月份版块，默认为1
                panel_increase: true,       //多面板的日期是否是递增的，比如，面板1是2月，则，面板2是3月  TODO此功能还没有完全开发
                zindex: 11000,              //层级控制
                width: '200px',             //输入框宽度
                okbtn: false,               //是否启用okbtn，启用okbtn后，需要点击确定才能让选择的值传至输入框
                clearbtn: true,             //是否启用清空按钮
                mindate: null,              //最小日期
                maxdate: null,              //最大日期
                nocurrent: false,           //最大最小日期，是否包含当天/当月/当年，默认为包含
                iso8601: false,             //是否启用iso8601标准，开启此标准后，每周默认第一天为星期一，每年的第一个星期四所在的周为第一周
                on_before_show: null,       //打开前的回调事件，返回true则继续执行代码，否则则中止
                on_change: null,            //回调函数，在点选日期后执行
                separator: false,           //区间模式下，单日期是否保留间隔符号
                sunday_first: false         //每周的第一天是否是星期天，默认是星期一
            } ,
            checkboxGroup:{
                uitype:"CheckboxGroup",
                databind:'data.checkboxGroup',
                name : "checkboxGroup",
                checkbox_list :[{
                    text: '足球',
                    readonly : "readonly",
                    value: '0'
                },{
                    text: '篮球',
                    value: '1'
                },{
                    text: '兵乓球',
                    value: '2'
                },{
                    text: '羽毛球',
                    value: '3'
                }],
                direction : "horizontal",
                value :[1,2],
                color : "#0078ff",  //#4585e5
                textmode: false,
                allselect: "全选",
                br : [],
                readonly : false,
                border: false
            },
            radioGroup:{
                uitype: "RadioGroup",
                databind:'data.radioGroup',
                name: "radioGroup",
                radio_list: [{
                    text: '男',
                    readonly: "readonly",
                    value: '0'
                },{
                    text: '女',
                    value: '1'
                }],
                direction: "horizontal",
                value: '1',
                readonly: false,
                color : "#0078ff",  //#4585e5
                br: [],
                border: false,
                textmode: false,
                on_change : null
            },
            clickInput: {
                uitype: 'ClickInput',     //组件类型
                databind:'data.clickInput',
                name: 'clickInput',                 //组件名
                value: 'ddd',                //默认文本值
                emptytext: '',            //当前没有输入时显示的值
                width: '',                //默认宽度
                maxlength: -1,            //最大长度-1为不限制长度
                readonly: false,          //是否只读
                icon: 'eject',                 //图片路径或者样式名
                iconwidth: '',            //图片长度
                enterable: false,         //点击回车是否触发图片点击事件
                editable: false,          //是否可编辑
                textmode: false,          //是否为文本模式
                on_iconclick: null,       //图片点击事件
                on_change: null,          //值改变事件
                on_focus: null,           //获得焦点事件
                on_blur: null,            //丢失焦点事件
                on_keyup: null,           //keyup事件
                on_keydown: null          //keydown事件
            },
            textarea: {
                uitype: 'Textarea',     //组件类型
                databind:'data.textarea',
                name: 'textarea',               //组件名
                relation: 'textarea_text',           //剩余可输入字符数显示的元素ID
                value: '',              //默认文本值
                width: '300',         //文本域组件宽度
                height: '57',        //文本域高度
                readonly: false,       //是否是只读
                maxlength: 300,          //最大能输入字符数，-1表示不限制
                byte: true,             //输入字符计算方式，true表示使用字节计算，false表示使用字符计算
                emptytext: '',          //为空时提示的内容
                autoheight: false,      //是否随着输入文本域自动增高
                maxheight: '',          //当文本域自动增高时限制最大增大高度
                textmode: false,        //是否为只读模式
                on_change: null,           //值改变事件
                on_focus: null,            //获得焦点事件
                on_blur: null,             //丢失焦点事件
                on_keyup: null,            //keyup事件
                on_keydown: null           //keydown事件
            },
            editor: {
                uitype: "Editor",
                databind:'data.editor',
                width: 0,  			// 不设置会自适应宽度
                min_frame_height: 320,  			// 默认320px
                readonly: false,       //是否只读
                initial_content: "", 	// 默认文本
                word_count: true, 		// 是否开启字数统计
                maximum_words: 10000,		// 允许最大字符数
                textmode: false,        //是否为只读模式
                focus: true,
                toolbars: [],
                server_url: ''
            },
            listBox:{
                uitype:'ListBox',
                databind:'data2.listBox',
                //组件宽度
                width:'200',
                //组件高度
                height:'200',
                //组件名
                name:'listBox',
                //默认值
                value:'',
                //记录数据集中隐藏列名
                value_field: 'id',
                //记录数据集中显示列名
                label_field: 'text',
                //是否多选
                multi:true,
                //文本模式
                textmode:false,
                //接收数据
                datasource:[
                    {id:'item1',text:'选项1'},
                    {id:'item2',text:'选项2'},
                    {id:'item3',text:'选项3'},
                    {id:'item4',text:'选项4'}
                ],
                //双击触发的方法
                on_dbclick:null,
                //单击触发的方法
                on_click:null,
                //选中改变时触发
                on_select_change:null,
                //添加行时触发
                on_add:null,
                //删除行时触发
                on_remove:null,

                //图标路径
                icon_path:null
            },
            pullDown : {
                uitype : "PullDown",
                databind:'data2.pullDown',
                empty_text: "请选择",
                value: '',
                readonly: false,
                textmode: false,
                width: "200",
                height: "200",
                editable: true,
                //下拉渲染模式，暂时可以为"Single"和"Multi"。
                mode : "Single",
                datasource: [
                    {id:'item1',text:'选项1'},
                    {id:'item2',text:'选项2'},
                    {id:'item3',text:'选项3'},
                    {id:'item4',text:'选项4'},
                    {id:'item5',text:'选项5'},
                    {id:'item6',text:'选项6'},
                    {id:'item7',text:'选项7'},
                    {id:'item8',text:'选项8'}
                ],
                //下面这个是用于数据字典的，不与后端结合的时候，不需要理会此参数
                dictionary: '',
                //下面为继承部分参数内容。
                name : "pullDown",
                select: -1,
                must_exist: true,
                auto_complete: false,
                value_field : "id",
                label_field : "text",
                filter_fields : [],
                on_filter_data: null,
                on_change: null,
                on_filter: null
            },
            menu: {
                uitype: 'Menu',//组件类型，menu
                trigger: 'click',//组件触发的方式，click|| hover
                width: '',//菜单的宽度
                on_click: null,//点击事件
                datasource: [
                    {id:'item1',label:'选项1'},
                    {id:'item2',label:'选项2'},
                    {id:'item3',label:'选项3'},
                    {id:'item4',label:'选项4'}
                ]//菜单的数据源
            },
            tree: {
                uitype: "Tree",
                children:  [
                    { title: "设备类别结构", key: "k1" },
                    { title: "Folder 2", key: "k2", isFolder: "true", children: [
                        { title: "无形资产", key: "k2-1" },
                        { title: "有形资产", key: "k2-2", isFolder: "true", children: [
                            { title: "hello" }]
                        }]
                    },
                    { title: "其他", key: "k3", hideCheckbox: "true" }
                ], 		// 树的节点数据
                checkbox: false, 	//
                select_mode: 1, 		// 1:单选; 2:多选; 3:多选并级联;
                persist: false, 	// 使用cookie存储状态
                icon: "", 		// fasle不使用图标, url为自定义图标. 默认无图标.要自定义须传url.
                checkbox_style:"",
                on_dbl_click:null,
                on_expand: null, 	// 展开/收缩时回调			function(flag, node) {}
                on_select: null, 	// 选中/取消选中回调		function(flag, node) {}
                on_click: null, 	// 点击时回调				function(node, event) {}
                on_activate: null, 	// 节点激活时的回调函数;	function(node) {}
                on_focus: null, 	// 获取焦点时回调			function(node) {}
                on_blur: null, 	// 失焦时回调				function(node) {}
                on_lazy_read:null,      // lazy load时回调 	function(node) {}
                auto_focus: false, // Set focus to first child, when expanding or lazy-loading.
                keyboard: false,
                click_folder_mode:3,
                min_expand_level:1,
                default_expand_level:1,//默认展开 一 级节点
                theme:"cui",//树的样式风格,可选classic,cui;默认是cui 样式
                on_post_init:null ,//Callback(isReloading, isError) when tree was (re)loaded.
                reactive:true//已激活的节点是否需要触发onActivate事件，默认true
            },
            "searchBtn":{
                uitype:"Button",
                label:"搜索"
            },
            "gridtable":{
                uitype:'Grid',
                datasource:initData,
                primarykey:'ID',
                gridwidth:1200,
                gridheight:"auto",
                tablewidth:1200,
                adaptive:false,
                titleellipsis:false,
                lazy:false,
                selectrows:"multi",
                selectedrowclass:"selected_row",
                sortstyle:1,
                sortname:[],
                sorttype:[],
                pagination:true,
                pagination_model:"pagination_min_1",
                pageno:1,
                pagesize:50,
                custom_pagesize:false,
                pagesize_list:[25,50,100],
                colrender:null,
                colstylerender:null,
                rowsstylerender:null,
                resizeheight:null,
                resizewidth:null,
                titlelock:true,
                fixcolumnnumber:0,
                oddevenrow:false,
                oddevenclass:'cardinal_row',
                titlerender:null,
                colhidden:true,
                colmaxheight:"auto",
                colmove:false,
                loadtip:true,
                adddata_callback:null,
                removedata_callback:null,
                rowclick_callback:null,
                rowdblclick_callback:null,
                loadcomplate_callback:null,
                selectall_callback:null,
                onstatuschange:null,
                config:null,
                operation:{
                    search:{
                        btn:"#searchBtn"
                    }
                },
                columns:[
                    [
                        {rowspan:3,width:60,type:'checkbox'},
                        {rowspan:2,colspan:2,name:"学生信息"},
                        {colspan:9,name:"考试成绩"}
                    ],[
                        {colspan:5,name:"文科"},
                        {colspan:4,name:"理科"}
                    ],[
                        {renderStyle:"text-align: center;",bindName:"info.name",render:"a",options:"{'url':'#'}",name:"姓名"},
                        {renderStyle:"text-align: center;",sort:"true",bindName:"info.class",name:"班级",hide:false,disabled:false},
                        {renderStyle:"text-align: center;",sort:"true",bindName:"chinese",name:"语文"},
                        {renderStyle:"text-align: center;",sort:"true",bindName:"english",name:"英语"},
                        {renderStyle:"text-align: center;",sort:"true",bindName:"politics",name:"政治"},
                        {renderStyle:"text-align: center;",sort:"true",bindName:"history",name:"历史"},
                        {renderStyle:"text-align: center;",sort:"true",bindName:"geography",name:"地理"},
                        {renderStyle:"text-align: center;",sort:"true",bindName:"math",name:"数学"},
                        {renderStyle:"text-align: center;",sort:"true",bindName:"physics",name:"物理"},
                        {renderStyle:"text-align: center;",sort:"true",bindName:"organisms",name:"生物"},
                        {renderStyle:"text-align: center;",sort:"true",bindName:"chemistry",name:"化学"}
                    ]
                ]
            },
            "editgridtable":{
                uitype:"EditableGrid",
                datasource: datasource,
                columns:[
                    {renderStyle:"text-align: center",bindName:"1",name:"序号"},
                    {renderStyle:"text-align: center",bindName:"Input",name:"Input"},
                    {renderStyle:"text-align: center",bindName:"RadioGroup",name:"RadioGroup"},
                    {renderStyle:"text-align: center",bindName:"CheckboxGroup",name:"CheckboxGroup"},
                    {renderStyle:"text-align: center",bindName:"ClickInput",name:"ClickInput"},
                    {renderStyle:"text-align: center",bindName:"SinglePullDown",name:"SinglePullDown"},
                    {renderStyle:"text-align: center",bindName:"MultiPullDown",name:"MultiPullDown"},
                    {renderStyle:"text-align: center",bindName:"ThreeParty",name:"ThreeParty"}
                ],
                selectrows:"single",
                edittype: {
                    "Input" : {
                        uitype: "Input",
                        validate: [
                            {
                                type: 'required',
                                rule: {
                                    m: '不能为空'
                                }
                            }
                        ]
                    },
                    "RadioGroup": {
                        uitype: "RadioGroup",
                        radio_list: [
                            {value: "1", text: "北京"},
                            {value: "2", text: "上海"},
                            {value: "3", text: "广州"}
                        ]
                    },
                    "CheckboxGroup": {
                        uitype: "checkboxGroup",
                        checkbox_list: [
                            {text: "学生", value: "0"},
                            {text: "工人", value: "1"},
                            {text: "农民", value: "2"}
                        ]
                    },
                    "ClickInput" : {
                        uitype: "ClickInput",
                        editable: "true"
                    },
                    "SinglePullDown": {
                        uitype: "PullDown",
                        mode: "Single",
                        datasource: [
                            {id: "1", text: "小学"},
                            {id: "2", text: "初中"},
                            {id: "3", text: "幼儿园"}
                        ]
                    },
                    "MultiPullDown": {
                        uitype: "PullDown",
                        mode: "Multi",
                        datasource: [
                            {id: "1", text: "看书"},
                            {id: "2", text: "读报"},
                            {id: "3", text: "看日本电影"}
                        ]
                    },
                    "ThreeParty": {
                        create: function (box, rowData) {
                            //实现渲染
                            box.innerHTML = "<input style='width: 95%;' value='" + rowData.ThreeParty + "'>";
                        },
                        returnValue: function (box) {
                            //获取值
                            return box.getElementsByTagName("input")[0].value;
                        }
                    }
                },
                gridwidth:1200,
                gridheight:300,
                tablewidth:1200,
                adaptive:false,
                titleellipsis:false,
                lazy:false,
                selectrows:"multi",
                selectedrowclass:"selected_row",
                sortstyle:1,
                sortname:[],
                sorttype:[],
                pagination:true,
                pagination_model:"pagination_min_1",
                pageno:1,
                pagesize:50,
                custom_pagesize:false,
                pagesize_list:[25,50,100],
                colrender:null,
                colstylerender:null,
                rowsstylerender:null,
                resizeheight:null,
                resizewidth:null,
                titlelock:true,
                fixcolumnnumber:0,
                oddevenrow:false,
                oddevenclass:'cardinal_row',
                titlerender:null,
                colhidden:true,
                colmaxheight:"auto",
                colmove:false,
                loadtip:true,
                adddata_callback:null,
                removedata_callback:null,
                rowclick_callback:null,
                rowdblclick_callback:null,
                loadcomplate_callback:null,
                selectall_callback:null,
                onstatuschange:null,
                config:null,
                primarykey: "ID",
                submitdata: save,
                editbefore:null,
                editafter:null,
                deletebefore:null,
                deleteafter:null
            }
        }

        var data={input:'绑定input', calender:'2015-05-07',checkboxGroup:[0,1],radioGroup:0,clickInput:'绑定clickInput',
            textarea:'绑定textarea',editor:'<span style="font-size: 20px;">绑定editor</span>',b:true
        };

        var data2={listBox:'item1;item2',pullDown:'item1'
        };

        function initData(gridObj,query){
            gridObj.setDatasource(gridData.slice((query.pageNo - 1) * query.pageSize, query.pageNo * query.pageSize), 150);
        }

        /**
         * 编辑Grid数据加载
         * @param obj {Object} Grid组件对象
         * @param query {Object} 查询条件
         */
        function datasource(obj, query) {
            //模拟ajax
            setTimeout(function () {
                obj.setDatasource(editGridData.slice((query.pageNo - 1) * query.pageSize, query.pageNo * query.pageSize), editGridData.length);
            }, 500);
        }

        function save(){

        }

        /*
        * 通过uiConfig databind属性设置数据绑定
        */
        function initDataBind(){
            for(var item in uiConfig){
                if(uiConfig[item].databind){
                    var bindObject=uiConfig[item].databind.split(".")[0];
                    var bindName=uiConfig[item].databind.split(".")[1];
                    cui(window[bindObject]).databind().addBind('#'+item, bindName);
                }
            }
        }

        /**
         * 根据模型生成校验
         */
        var validater = cui().validate();
        function initValidate(){
            /*var validateRule=[
             {'type':'required', 'rule':{m: '缺陷名称不能为空'}},
             {'type':'length', 'rule':{max:3,maxm: '缺陷名称小余3个字符'}},
             {'type':'numeric', 'rule':{'oi':true,'notim':'学号必是数字'}},
             {'type':'numeric', 'rule':{'min':5.4,'max':10.2,minm:'学号应该大于等于5.4',maxm:'学号应该小余等于10'}},
             {'type':'format', 'rule':{pattern: '(\\d+)\\.(\\d+)\\.(\\d+)\\.(\\d+)',m: 'IP输入不合法'}},
             {'type':'custom', 'rule':{against:'input_custom_validate',m:'输入的学号必须大于10000'}}
             ]*/

            for(var item in uiConfig){
                if(uiConfig[item].validate){
                    for(var validateNode in uiConfig[item].validate){
                        var vl=uiConfig[item].validate[validateNode];
                        validater.add(item, vl.type, vl.rule);
                    }
                }
            }


        }

        //自定义验证方法
        function input_custom_validate(value){
            if(value>10000){
                return true;
            }else{
                return false;
            }
        }

        /**
         * 弹出校验错误信息
         */
        function alertValidateMessage(){
        	var validOjb=validater.validAllElement();
            var validateResult=validOjb[2];
            var validateMessage=validOjb[0];
            var str="";
            if(!validateResult){
                for(var i=0;i<validateMessage.length;i++){
                    str=str+validateMessage[i].message;
                }
                cui.error(str);
            }
        }
        
        // state 1:编辑  2：只读  3：隐藏
        var pageState={
       		tempCheck:{
       			button:{
    				state:1,
    				isValidate:false
                },
                input:{
	   				state:2,
	   				isValidate:false
                }
       		}
        }
        
        //切换页面状态
        function changePageState(stateName){
        	var uiList=pageState[stateName];
        	for(var id in uiList){
        		
        		//设置控件状态
        		if(uiList[id].state==1){
        			cui('#'+id).show();
        			cui('#'+id).setReadonly(false);
        		}else if(uiList[id].state==2){
        			cui('#'+id).show();
        			cui('#'+id).setReadonly(true);
        		}else if(uiList[id].state==3){
        			cui('#'+id).hide();
        		}
        		
        		//设置控件是否校验
        		if(uiList[id].isValidate){
        			validater.disValid(id, false);
        		}else{
        			validater.disValid(id, true);
        		}
        	}
        }
        
      	//页面初始过程
        function pageInit(){
        	comtop.UI.scan();
            initDataBind();
            initValidate();
            //设置页面到初始化状态
            pageInitState();
        }
        
        //页面初始化状态
        function pageInitState(){
        	if(verifyAttr){
        		cui('#button').hide();
        		cui('#button').show();
        		cui('#button').setReadonly(true);
        		cui('#button').setReadonly(false);
        	}
        }
        
      	//页面初始化行为
        function pageInitAction(){
        	FormAction.readFormById(stringAttr,function(data){
        		cui(window['data']).databind().setValue(data);
        		pageInit();
			});
        }
        
        //页面行为绑定页面参数
        function readFormById(){
        	FormAction.readFormById(stringAttr,function(data){
        		console.log(data);
        		cui(window['data']).databind().setValue(data);
			});
		}
        
		//页面行为绑定页面参数
		function insertForm(){
			var data={b:true,d:new Date(),d1:1.23,i:3,f:[0,1],g:["sdf","sdfds"],k:{b:true,h:{y:'sdfds'}}};
		    FormAction.insertForm(data,function(data){
		    	alert(data);
			});
		}

        jQuery(document).ready(function(){
        	pageInitAction();
        });

        function testDataBind(){
            console.log(data);
        }
    </script>
</head>
<body>
<table>
    <tr>
        <td colspan="2">
        <c:if test="${verifyAttr}">
            <button onclick="testDataBind()">测试数据绑定</button>
        </c:if>
            <button onclick="alertValidateMessage()">测试校验</button>
            <button onclick="changePageState('tempCheck')">更改页面状态</button>
            <button onclick="readFormById()">页面行为_读取表单</button>
            <button onclick="insertForm()">页面行为_提交表单</button>
        </td>
    </tr>
    
    <tr>
        <td><span id="button" uitype="Button"></span></td>
        <td><span uitype="Label" value="停电时间："></span></td>
    </tr>
    <tr>
        <td>
            <span id="input" uitype="Input" ></span>
        </td>
        <td>
            <span id="calender" uitype="Calender"></span>
        </td>
    </tr>
    <tr>
        <td>
            <span id="checkboxGroup" uitype="CheckboxGroup" ></span>
        </td>
        <td>
            <span id="radioGroup" uitype="RadioGroup" ></span>
        </td>
    </tr>
    <tr>
        <td>
            <span id="clickInput" uitype="ClickInput" ></span>
        </td>
        <td>
            <span id="textarea_text"></span>
            <span id="textarea" uitype="Textarea"></span>
        </td>
    </tr>
    <tr>
        <td colspan="2">
            <span id="editor" uitype="Editor"></span>
        </td>
    </tr>
    <tr>
        <td>
            <span id="listBox" uitype="ListBox"></span>
        </td>
        <td>
            <span id="pullDown" uitype="PullDown"></span>
        </td>
    </tr>
    <tr>
        <td>
            <span id="menu" uitype="Menu">菜单点击</span>
        </td>
        <td>
            <span id="tree" uitype="Tree"></span>
        </td>
    </tr>
    <tr>
        <td colspan=2>
            <span id="searchBtn" uitype="Button"></span>
            <table id="gridtable" uitype="Grid"></table>
        </td>
    </tr>
    <tr>
        <td colspan=2>
            <table id="editgridtable" uitype="EditableGrid"></table>
        </td>
    </tr>
</table>

</body>
</html>