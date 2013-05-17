<%@ page language="java" contentType="text/html; charset=ISO-8859-1"
    pageEncoding="ISO-8859-1"
%><%
	long max = Runtime.getRuntime().maxMemory();
	long total = Runtime.getRuntime().totalMemory();
	long free = Runtime.getRuntime().freeMemory();
	if (request.getParameter("xml") != null) {
		response.setContentType("text/xml");
		out.println("<memory-usage><free>" + free + "</free><total>" + total + "</total><max>" + max + "</max></memory-usage>");
		return;
	}
%>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=ISO-8859-1">
<title>Report memory usave</title>
</head>
<body>
<h4>Memory Usage</h4>
<ul>
<li>Free: <%= free %></li>
<li>Total: <%= total %></li>
<li>Max: <%= max %></li>
</ul>
</body>
</html>