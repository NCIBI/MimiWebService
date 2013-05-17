<?xml version="1.0" encoding="ISO-8859-1" ?><%@ 
	page language="java" contentType="text/html; charset=ISO-8859-1"
    pageEncoding="ISO-8859-1"
    import="org.ncibi.mimiweb.util.PropertiesUtil" 
    %><%
    String webappName = PropertiesUtil.getProperty("saveWebappName");

	String redirectURL = "/" + webappName + "/getDataList.jsp" ;
%>
<html>
<head>
    <META HTTP-EQUIV="Refresh" CONTENT="0; URL=<%= redirectURL %>"
>
    <meta http-equiv="Content-Type" content="text/html; charset=iso-8859-1">
    <title><%= application.getServerInfo() %></title>
</head>

<body>
You should have been redirected to the Application To Application <a href="<%= redirectURL %>">List Display</a>.
</body>
</html>
