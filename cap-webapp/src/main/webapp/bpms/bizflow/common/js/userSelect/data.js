//获取节点数据
var nodeinfolist = [
    {
        processId: 'processId1',
        nodeId: 'nodeId1',
        nodeName: '财务专责节点专责节点1',
        nodeType: 'USERTASK',
        cooperationFlag: 'true',
        cooperationId: 'cooperationId0',
        processVersion: 2,
        nodeInstanceId: 'fs234ttr3i2ng3434232342fwe',
        isViewSelectDept:true
    },
    {
        processId: 'processId1',
        nodeId: 'nodeId2',
        nodeName: '财务专责节点专责节点2',
        nodeType: 'USERTASK',
        cooperationFlag: 'true',
        cooperationId: 'cooperationId1',
        processVersion: 2,
        nodeInstanceId: 'fs234ttr3i2ng3434232342dwe',
        isViewSelectDept:true
    },
    {
        processId: 'processId1',
        nodeId: 'nodeId3',
        nodeName: '财务专责节点专责节点3',
        nodeType: 'USERTASK',
        cooperationFlag: 'true',
        cooperationId: 'cooperationId2',
        processVersion: 2,
        nodeInstanceId: 'fs234ttr3i2ng3434232342rwe',
        isViewSelectDept:true
    },
    {
        processId: 'processId1',
        nodeId: 'nodeId3',
        nodeName: '结束工单',
        nodeType: 'ENDEVENT',
        cooperationFlag: 'true',
        cooperationId: 'cooperationId2',
        processVersion: 2,
        nodeInstanceId: 'fs234ttr3i2ng3434232342rwe',
        isViewSelectDept:true
    }
]

//获取节点数据
var userlist = [
    {
        userId: '235dg4w232',
        userName: "超级管理员1-1",
        deptId: "tech_01",
        deptPath : "基建部",
        position : "基建工程师",
        sendSMS : true,
        sendEmail : true
    },
    {
        userId: '23525sfsdw232',
        userName: "超级管理员",
        deptId: "tech_01",
        deptPath : "广东电网公司/佛山供电局/基建部",
        position : "基建工程师",
        sendSMS : false,
        sendEmail : true
    },
    {
        userId: '235d5252w232',
        userName: "张三1-3",
        deptId: "tech_01",
        deptPath : "广东电网公司/佛山供电局/基建部",
        position : "基建工程师",
        sendSMS : false,
        sendEmail : false
    },
    {
        userId: '2tgsfsd4w232',
        userName: "张三1-4",
        deptId: "tech_01",
        deptPath : "广东电网公司/佛山供电局/基建部",
        position : "基建工程师",
        sendSMS : true,
        sendEmail : true
    },
    {
        userId: '23bfgergw232',
        userName: "张三1-5",
        deptId: "tech_01",
        deptPath : "广东电网公司/佛山供电局/基建部",
        position : "基建工程师",
        sendSMS : true,
        sendEmail : false
    },
    {
        userId: '23dxgsdf32',
        userName: "张三1-6",
        deptId: "tech_01",
        deptPath : "广东电网公司/佛山供电局/基建部",
        position : "基建工程师",
        sendSMS : false,
        sendEmail : true
    },
    {
        userId: '235dg4w232',
        userName: "超级管理员1-1",
        deptId: "tech_01",
        deptPath : "基建部",
        position : "基建工程师",
        sendSMS : true,
        sendEmail : true
    },
    {
        userId: '23525sfsdw232',
        userName: "超级管理员",
        deptId: "tech_01",
        deptPath : "广东电网公司/佛山供电局/基建部",
        position : "基建工程师",
        sendSMS : false,
        sendEmail : true
    },
    {
        userId: '235d5252w232',
        userName: "张三1-3",
        deptId: "tech_01",
        deptPath : "广东电网公司/佛山供电局/基建部",
        position : "基建工程师",
        sendSMS : false,
        sendEmail : false
    },
    {
        userId: '2tgsfsd4w232',
        userName: "张三1-4",
        deptId: "tech_01",
        deptPath : "广东电网公司/佛山供电局/基建部",
        position : "基建工程师",
        sendSMS : true,
        sendEmail : true
    },
    {
        userId: '23bfgergw232',
        userName: "张三1-5",
        deptId: "tech_01",
        deptPath : "广东电网公司/佛山供电局/基建部",
        position : "基建工程师",
        sendSMS : true,
        sendEmail : false
    },
    {
        userId: '23dxgsdf32',
        userName: "张三1-6",
        deptId: "tech_01",
        deptPath : "广东电网公司/佛山供电局/基建部",
        position : "基建工程师",
        sendSMS : false,
        sendEmail : true
    },
    {
        userId: '235dg4w232',
        userName: "超级管理员1-1",
        deptId: "tech_01",
        deptPath : "基建部",
        position : "基建工程师",
        sendSMS : true,
        sendEmail : true
    },
    {
        userId: '23525sfsdw232',
        userName: "超级管理员",
        deptId: "tech_01",
        deptPath : "广东电网公司/佛山供电局/基建部",
        position : "基建工程师",
        sendSMS : false,
        sendEmail : true
    },
    {
        userId: '235d5252w232',
        userName: "张三1-3",
        deptId: "tech_01",
        deptPath : "广东电网公司/佛山供电局/基建部",
        position : "基建工程师",
        sendSMS : false,
        sendEmail : false
    },
    {
        userId: '2tgsfsd4w232',
        userName: "张三1-4",
        deptId: "tech_01",
        deptPath : "广东电网公司/佛山供电局/基建部",
        position : "基建工程师",
        sendSMS : true,
        sendEmail : true
    },
    {
        userId: '23bfgergw232',
        userName: "张三1-5",
        deptId: "tech_01",
        deptPath : "广东电网公司/佛山供电局/基建部",
        position : "基建工程师",
        sendSMS : true,
        sendEmail : false
    },
    {
        userId: '23dxgsdf32',
        userName: "张三1-6",
        deptId: "tech_01",
        deptPath : "广东电网公司/佛山供电局/基建部",
        position : "基建工程师",
        sendSMS : false,
        sendEmail : true
    }
]

//data的数据可以通过ajax等方式获取
var data = [
	{
		processId: 'processId12345',
		nodeId: 'nodeId12345',
		nodeName: '财务专责节点专责节点1',
		nodeType: 'USERTASK',
		cooperationFlag: 'true',
		cooperationId: 'cooperationId0',
		processVersion: 2,
		nodeInstanceId: 'fs234ttr3i2ng3434232342fwe',
		users: [
			{
				userId: '235dg4w232',
		        userName: "超级管理员1-1",
		        deptId: "tech_01",
		        deptPath : "基建部",
		        position : "基建工程师",
		        sendSMS : true,
		        sendEmail : true
			},
			{
				userId: '23525sfsdw232',
		        userName: "超级管理员",
		        deptId: "tech_01",
		        deptPath : "广东电网公司/佛山供电局/基建部",
		        position : "基建工程师",
		        sendSMS : false,
		        sendEmail : true
			},
			{
				userId: '235d5252w232',
		        userName: "张三1-3",
		        deptId: "tech_01",
		        deptPath : "广东电网公司/佛山供电局/基建部",
		        position : "基建工程师",
		        sendSMS : false,
		        sendEmail : false
			},
			{
				userId: '2tgsfsd4w232',
		        userName: "张三1-4",
		        deptId: "tech_01",
		        deptPath : "广东电网公司/佛山供电局/基建部",
		        position : "基建工程师",
		        sendSMS : true,
		        sendEmail : true
			},
			{
				userId: '23bfgergw232',
		        userName: "张三1-5",
		        deptId: "tech_01",
		        deptPath : "广东电网公司/佛山供电局/基建部",
		        position : "基建工程师",
		        sendSMS : true,
		        sendEmail : false
			},
			{
				userId: '23dxgsdf32',
		        userName: "张三1-6",
		        deptId: "tech_01",
		        deptPath : "广东电网公司/佛山供电局/基建部",
		        position : "基建工程师",
		        sendSMS : false,
		        sendEmail : true
			}
		]
	},
	{
		processId: 'processId2',
		nodeId: 'nodeId2',
		nodeName: '财务专责节点专责节点专责节点2',
		nodeType: 'USERTASK',
		cooperationFlag: 'true',
		cooperationId: 'cooperationId1',
		processVersion: 2,
		nodeInstanceId: 'fs234ttr3523523r32522342fwe',
		users: [
			{
				userId: '23gxfdsfs32',
		        userName: "张三2-1",
		        deptId: "tech_01",
		        deptPath : "广东电网公司/佛山供电局/安全监察部",
		        position : "安监员",
		        sendSMS : true,
		        sendEmail : true
			},
			{
				userId: '235dggfgfghdf32',
		        userName: "张三2-2",
		        deptId: "tech_01",
		        deptPath : "广东电网公司/佛山供电局/安全监察部",
		        position : "安监员",
		        sendSMS : false,
		        sendEmail : true
			},
			{
				userId: '2gdsfgsfs232',
		        userName: "张三2-3",
		        deptId: "tech_01",
		        deptPath : "广东电网公司/佛山供电局/安全监察部",
		        position : "安监员",
		        sendSMS : false,
		        sendEmail : true
			}
		]
	},
	{
		processId: 'processId3',
		nodeId: 'nodeId3',
		nodeName: '财务专责节点3',
		nodeType: 'USERTASK',
		cooperationFlag: 'false',
		cooperationId: '',
		processVersion: 2,
		nodeInstanceId: 'fs234ttr453452342fwe',
		users: [
			{
				userId: '235hdfgrw32',
		        userName: "张三3-1",
		        deptId: "tech_01",
		        deptPath : "广东电网公司/佛山供电局",
		        position : "程序员",
		        sendSMS : true,
		        sendEmail : false
			},
			{
				userId: '235erererwe32',
		        userName: "张三3-2",
		        deptId: "tech_01",
		        deptPath : "广东电网公司/佛山供电局",
		        position : "程序员",
		        sendSMS : true,
		        sendEmail : false
			},
			{
				userId: '23dfgdfsdf32',
		        userName: "张三3-3",
		        deptId: "tech_01",
		        deptPath : "广东电网公司/佛山供电局",
		        position : "程序员",
		        sendSMS : true,
		        sendEmail : false
			},
			{
				userId: '23dgdfgdfg2',
		        userName: "张三3-4",
		        deptId: "tech_01",
		        deptPath : "广东电网公司/佛山供电局",
		        position : "程序员",
		        sendSMS : false,
		        sendEmail : false
			},
			{
				userId: '235r23r2332',
		        userName: "张三3-5",
		        deptId: "tech_01",
		        deptPath : "广东电网公司/佛山供电局",
		        position : "程序员",
		        sendSMS : true,
		        sendEmail : true
			},
			{
				userId: '235dgjghdgds2',
		        userName: "张三3-6",
		        deptId: "tech_01",
		        deptPath : "广东电网公司/佛山供电局",
		        position : "程序员",
		        sendSMS : false,
		        sendEmail : false
			},
			{
				userId: '23kyujty32',
		        userName: "张三3-7",
		        deptId: "tech_01",
		        deptPath : "广东电网公司/佛山供电局",
		        position : "程序员",
		        sendSMS : true,
		        sendEmail : false
			},
			{
				userId: '235gbcswe232',
		        userName: "张三3-8",
		        deptId: "tech_01",
		        deptPath : "广东电网公司/佛山供电局",
		        position : "程序员",
		        sendSMS : false,
		        sendEmail : false
			},
			{
				userId: '235drgdfgdsfs32',
		        userName: "张三3-9",
		        deptId: "tech_01",
		        deptPath : "广东电网公司/佛山供电局",
		        position : "程序员",
		        sendSMS : true,
		        sendEmail : false
			}
		]
	},
	{
		processId: 'processId4',
		nodeId: 'nodeId4',
		nodeName: '财务专责节点4',
		nodeType: 'USERTASK',
		cooperationFlag: 'true',
		cooperationId: null,
		processVersion: 2,
		nodeInstanceId: 'fs23345453242342522342fwe',
		users: [
			{
				userId: '23jtryrt232',
		        userName: "张三4-1",
		        deptId: "tech_01",
		        deptPath : "广东电网公司/佛山供电局/物流服务中心",
		        position : "物流专员",
		        sendSMS : true,
		        sendEmail : true
			},
			{
				userId: '235dghfhgdf2',
		        userName: "张三4-2",
		        deptId: "tech_01",
		        deptPath : "广东电网公司/佛山供电局/物流服务中心",
		        position : "物流专员",
		        sendSMS : false,
		        sendEmail : false
			},
			{
				userId: '235dfhfghfgh32',
		        userName: "张三4-3",
		        deptId: "tech_01",
		        deptPath : "广东电网公司/佛山供电局/物流服务中心",
		        position : "物流专员",
		        sendSMS : false,
		        sendEmail : true
			},
			{
				userId: '235dfgdgerw232',
		        userName: "张三4-4",
		        deptId: "tech_01",
		        deptPath : "广东电网公司/佛山供电局/物流服务中心",
		        position : "物流专员",
		        sendSMS : true,
		        sendEmail : false
			},
			{
				userId: '235dg4sfsdfsds2',
		        userName: "张三4-5",
		        deptId: "tech_01",
		        deptPath : "广东电网公司/佛山供电局/物流服务中心",
		        position : "物流专员",
		        sendSMS : false,
		        sendEmail : false
			},
			{
				userId: '235dhfhdfhg32',
		        userName: "张三4-6",
		        deptId: "tech_01",
		        deptPath : "广东电网公司/佛山供电局/物流服务中心",
		        position : "物流专员",
		        sendSMS : false,
		        sendEmail : true
			},
			{
				userId: '235hdfgdgdf',
		        userName: "张三4-7",
		        deptId: "tech_01",
		        deptPath : "广东电网公司/佛山供电局/物流服务中心",
		        position : "物流专员",
		        sendSMS : false,
		        sendEmail : false
			},
			{
				userId: '23xghrgeaw232',
		        userName: "张三4-8",
		        deptId: "tech_01",
		        deptPath : "广东电网公司/佛山供电局/物流服务中心",
		        position : "物流专员",
		        sendSMS : true,
		        sendEmail : false
			},
			{
				userId: '235detwfsefs32',
		        userName: "张三4-9",
		        deptId: "tech_01",
		        deptPath : "广东电网公司/佛山供电局/物流服务中心",
		        position : "物流专员",
		        sendSMS : false,
		        sendEmail : false
			},
			{
				userId: '235dh4rtetwe32',
		        userName: "张三4-10",
		        deptId: "tech_01",
		        deptPath : "广东电网公司/佛山供电局/物流服务中心",
		        position : "物流专员",
		        sendSMS : false,
		        sendEmail : false
			},
			{
				userId: '235heaasefds232',
		        userName: "张三4-11",
		        deptId: "tech_01",
		        deptPath : "广东电网公司/佛山供电局/物流服务中心",
		        position : "物流专员",
		        sendSMS : false,
		        sendEmail : false
			},
			{
				userId: '23rw3rwef32',
		        userName: "张三4-12",
		        deptId: "tech_01",
		        deptPath : "广东电网公司/佛山供电局/物流服务中心",
		        position : "物流专员",
		        sendSMS : false,
		        sendEmail : true
			},
			{
				userId: '235dr23dsdfsd32',
		        userName: "张三4-13",
		        deptId: "tech_01",
		        deptPath : "广东电网公司/佛山供电局/物流服务中心",
		        position : "物流专员",
		        sendSMS : false,
		        sendEmail : false
			},
			{
				userId: '23xxvd32',
		        userName: "张三4-14",
		        deptId: "tech_01",
		        deptPath : "广东电网公司/佛山供电局/物流服务中心",
		        position : "物流专员",
		        sendSMS : true,
		        sendEmail : false
			},
			{
				userId: '235wwrwerwer',
		        userName: "张三4-15",
		        deptId: "tech_01",
		        deptPath : "广东电网公司/佛山供电局/物流服务中心",
		        position : "物流专员",
		        sendSMS : false,
		        sendEmail : true
			},
			{
				userId: '235r23dwsf232',
		        userName: "张三4-16",
		        deptId: "tech_01",
		        deptPath : "广东电网公司/佛山供电局/物流服务中心",
		        position : "物流专员",
		        sendSMS : true,
		        sendEmail : false
			},
			{
				userId: '235werwerwer232',
		        userName: "张三4-17",
		        deptId: "tech_01",
		        deptPath : "广东电网公司/佛山供电局/物流服务中心",
		        position : "物流专员",
		        sendSMS : false,
		        sendEmail : false
			},
			{
				userId: '235drwerwerwe32',
		        userName: "张三4-18",
		        deptId: "tech_01",
		        deptPath : "广东电网公司/佛山供电局/物流服务中心",
		        position : "物流专员",
		        sendSMS : false,
		        sendEmail : true
			}
		]
	},
	{
		processId: 'processId5',
		nodeId: 'nodeId5',
		nodeName: '财务专责节点5',
		nodeType: 'USERTASK',
		cooperationFlag: 'true',
		cooperationId: 'cooperationId2',
		processVersion: 2,
		nodeInstanceId: 'fs234tt86756dgetr32522342fwe',
		users: [
			{
				userId: '235dr23fsdfs32',
		        userName: "张三5-1",
		        deptId: "tech_01",
		        deptPath : "广东电网公司/佛山供电局/变电管理一所",
		        position : "变电专员",
		        sendSMS : true,
		        sendEmail : false
			}
		]
	},
	{
		processId: 'processId6',
		nodeId: 'nodeId6',
		nodeName: '财务专责节点6',
		nodeType: 'USERTASK',
		cooperationFlag: 'true',
		cooperationId: 'cooperationId1',
		users: [
			{
				userId: '235234234232',
		        userName: "张三6-1",
		        deptId: "tech_01",
		        deptPath : "广东电网公司/佛山供电局/试验研究所",
		        position : "研究员",
		        sendSMS : true,
		        sendEmail : true
			}
		]
	},
	{
		processId: 'processId8',
		nodeId: 'nodeId8',
		nodeName: '财务专责节点8',
		nodeType: 'USERTASK',
		cooperationFlag: 'true',
		cooperationId: 'cooperationId1',
		processVersion: 2,
		nodeInstanceId: 'fs234ttr3i2ng34t75dge2342fwe',
		users: [
			{
				userId: '235242342332',
		        userName: "张三8-1",
		        deptId: "tech_01",
		        deptPath : "广东电网公司/佛山供电局/客户服务中心",
		        position : "客服",
		        sendSMS : true,
		        sendEmail : true
			}
		]
	},
	{
		processId: 'processId7',
		nodeId: 'nodeId7',
		nodeName: '结束节点',
		nodeType: 'ENDEVENT',
		cooperationFlag: 'true',
		cooperationId: 'cooperationId1',
		processVersion: 2,
		nodeInstanceId: 'fs234t75fhgsdr32522342fwe',
		users: []
	}
]