<!DOCTYPE html>
<!-- 扩展Taglibs.jsp,用户可以根据自己的需要增加全局变量-->
<script>
	function HTMLEnCode(str) {
		var s = "";
		if (str.length == 0)
			return "";
		s = str.replace(/&/g, "&amp;");
		s = s.replace(/</g, "&lt;");
		s = s.replace(/>/g, "&gt;");
		s = s.replace(/    /g, "&nbsp;");
		s = s.replace(/\'/g, "&apos;");
		s = s.replace(/\"/g, "&quot;");
		s = s.replace(/\©/g, "&copy;");
		s = s.replace(/\®/g, "&reg;");
		return s;
	}
</script>