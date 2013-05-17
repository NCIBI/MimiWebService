<%@ page language="java" contentType="text/html; charset=ISO-8859-1"
    pageEncoding="ISO-8859-1"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN">
<html>
<head>
<meta http-equiv="content-type" content="text/html; charset=ISO-8859-1" >
<%	application.setAttribute("page-header-title","Data List Access"); %>
<jsp:include page="metaHeader.jsp"></jsp:include>
</head>
<body>
<div id="wrapper">
<jsp:include page="header.jsp"></jsp:include>
<div id="main-text">
To view the data set list (or data set's contents), you must supply a user name and password.
<form id="access-form" method="get" action="getDataList.jsp">
<input type="text" name="user" value="test@test.com" /> for demo use: test@test.com <br />
<input type="password" name="pw" value="test" /> for demo use: test<br />
<input class="submit-button" value="Login to See or Save Data Sets" type="submit" />
</form>
</div>
<div id="footer">&nbsp;
</div>
</div>
</body>
</html>
