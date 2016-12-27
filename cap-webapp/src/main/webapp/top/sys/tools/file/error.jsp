<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN">
<html>
<head>
<%@ page language="java" contentType="text/html; charset=GBK"
    pageEncoding="GBK"%>
<meta http-equiv="Content-Type" content="text/html; charset=GBK">
<title>success</title>
</head>
<body>
   <script type="text/javascript">
   window.parent.dialog.hide();
   window.parent.cui.alert('上传失败,失败原因：${errorCause}');
   </script>
</body>
</html>