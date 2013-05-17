<%@ page language="java" contentType="text/html; charset=ISO-8859-1"
    pageEncoding="ISO-8859-1"
    import="java.io.Writer,
    java.io.OutputStream,
    java.io.IOException,
    java.util.ArrayList,
    java.util.HashMap,
    org.ncibi.mimiweb.data.ResultGeneMolecule
    "
%><jsp:useBean id="access" class="org.ncibi.app2app.relay.DataListAccess" /><%
	String user = request.getParameter("user");
	String pw = request.getParameter("pw");
	String dsAppName = request.getParameter("dsAppName");
	String dsName = request.getParameter("dsName");
	if (dsName == null) dsName = "";
	dsName = dsName.trim();
	String dsMemo = request.getParameter("dsMemo");
	String fieldsString = request.getParameter("fields");

	String[] checked = request.getParameterValues("geneCheck");
	if (checked == null) checked = new String[0];

	boolean save = 
		(user != null) 
		&& (pw != null)
		&& (dsAppName != null)
		&& (dsName.length() > 0)
		&& (fieldsString != null)
		&& (checked.length > 0);
	
	if (dsMemo == null) dsMemo = "";
	
	String[][] data = new String[checked.length][1];
	String[] fields = {fieldsString};
		
	for (int i = 0; i < checked.length; i++){
		data[i][0] = checked[i];
	}
	
	String title = "Data Set List Access - Error";
	
	if (save) title = "Saveing new Data Set '" + dsName + "' for " + user;
	
%><!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN">
<html>
<head>
<meta http-equiv="content-type" content="text/html; charset=ISO-8859-1" >
<%	application.setAttribute("page-header-title",title); %>
<jsp:include page="metaHeader.jsp"></jsp:include>
</head>
<body>
<div id="wrapper">
<jsp:include page="header.jsp"></jsp:include>
<div id="main-text">
<%
	if (!save) {
		if (user == null) out.println("User name is required. <br/>");
		if (pw == null) out.println("Password is require. <br/>");
		if ((fieldsString == null) || (dsAppName == null))
			out.println("Save must be submitted from Mimi result pages. <br/>");
		if (dsName.length() == 0) out.println("A dataset name is required. <br/>");
		if (checked.length == 0) out.println("No genes were selected; list is empty. <br/>");
	}
	else {
		
		session.setAttribute("username", user);
		session.setAttribute("pw", pw);

		final Writer wout = out;
	
		OutputStream os = new OutputStream(){
			public void write(int b) throws IOException {
				char c = (char)b;
				wout.append(c);
			}
		};
		try {
			access.insertNewDataSet(user,pw,dsName,fields,dsAppName,data,dsMemo,dsMemo,os);
		} catch (Throwable t) {
			out.println("Some problem: " + t.getMessage());
		}
		out.flush();
	}
%>
Return to <a href="../main-page.jsp">Mimi Search</a>.
</div>
<div id="footer">&nbsp;
</div>
</div>
</body>
</html>
