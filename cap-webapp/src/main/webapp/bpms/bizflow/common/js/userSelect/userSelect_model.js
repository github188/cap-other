function Node (nodeId, nodeName, nodeType, nodeInstanceId, cooperationFlag, cooperationId, processId, processVersion) {
	this.nodeId = nodeId;
	this.nodeName = nodeName;
	this.nodeType = nodeType;
	this.nodeInstanceId = nodeInstanceId;
	this.cooperationFlag = cooperationFlag;
	this.cooperationId = cooperationId;
	this.processId = processId;
	this.processVersion = processVersion;
	this.users = {};
}

Node.prototype = {
	toString: function () {
		var usersString = "{";
		for (key in this.users) {
			usersString += this.users[key].toString();
		};
		usersString += "}";
		return "Node [nodeId: " + this.nodeId + ", nodeName: " + this.nodeName + ", nodeType: " + this.nodeType + ", users: " + usersString + "]";
	}, 

	getKey: function() {
		//jquery md5
		return $.md5("Node [nodeId: " + this.nodeId + ", nodeName: " + this.nodeName + ", nodeType: " + this.nodeType + "]");
	}
}

function User(nodeId, userId, userName, deptId, deptPath, postName, sendEmail, sendSMS) {
	this.nodeId = nodeId;
	this.userId = userId;
	this.userName = userName;
	this.deptId = deptId;
	this.deptPath = deptPath;
	this.postName = postName;
	this.sendEmail = sendEmail;
	this.sendSMS = sendSMS;
}

User.prototype = {
	toString: function () {
		return "User [nodeId: " + this.nodeId + ", userId: " + this.userId + ", userName: " + this.userName + 
			", deptId: " + this.deptId + ", deptPath: " + this.deptPath + ", postName: "+ this.postName + "]";
	},

	getKey: function() {
		//jquery md5
		return $.md5("User [nodeId: " + this.nodeId + ", userId: " + this.userId + ", userName: " + this.userName + 
			", deptId: " + this.deptId + ", postName: "+ this.postName + "]");
	}
}