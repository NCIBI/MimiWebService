<%@ page language="java" contentType="text/html; charset=ISO-8859-1"
    pageEncoding="ISO-8859-1"
    import="java.util.Enumeration"
    %>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=ISO-8859-1">
<title>Debugging - hostnames and ports</title>
</head>
<body>
	<h3>Hostnames and ports - specific probes</h3>
	Request server name = <%= request.getServerName() %><br />
	Request server port = <%= request.getServerPort() %> <br />
	Request 'local' name = <%= request.getLocalName() %> <br />
	Request 'local' port = <%= request.getLocalPort() %> <br />
	Request URI = <%= request.getRequestURI() %><br />
	Request message header 'Host' = <%= request.getHeader("Host") %> <br />
<%
	Enumeration names = request.getAttributeNames();
%>
	<h3>Dumps of parameter and attributes lists...</h3>
	<b>Attributes - </b>
	<ul>
<%
	while (names.hasMoreElements()) {
		String name = (String)names.nextElement();
%>
		<li><%= name %>: <%= request.getAttribute(name) %></li>
<%
	}
	names = request.getParameterNames();
%>
	</ul>
	<b>Parameters - </b>
	<ul>
<%
	while (names.hasMoreElements()) {
		String name = (String)names.nextElement();
%>
		<li><%= name %>: <%= request.getParameter(name) %></li>
<%
	}
%>
	</ul>
	<h3>Test Links - what do these resolve to?</h3>
	<p>href="test" <a href="test">link</a></p>
	<p>href="/test" <a href="/test">link</a></p>
	<p>href="./test" <a href="./test">link</a></p>
	<p>href="../test" <a href="../test">link</a></p>
</body>
</html>
