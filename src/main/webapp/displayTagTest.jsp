<?xml version="1.0" encoding="ISO-8859-1" ?>
<%@ page language="java" contentType="text/html; charset=ISO-8859-1"
    pageEncoding="ISO-8859-1"
    import="
    org.hibernate.Session,
	org.ncibi.db.factory.GeneSessionFactory,
	org.ncibi.db.factory.MimiSessionFactory,
	org.ncibi.db.factory.PubmedSessionFactory, 
    java.util.ArrayList,
    java.util.List
    "
    %>
<%@ taglib uri="http://displaytag.sf.net" prefix="display" %>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
<meta http-equiv="Content-Type" content="text/html; charset=ISO-8859-1" />
<title>Insert title here</title>
<%
	int pageSize = 25;
	String pageSizeString = (String) request.getParameter("pageSize") ;
	if (pageSizeString != null) {
		try {
			pageSize = Integer.parseInt(pageSizeString);
		} catch (Throwable ignore) {}
	}

	String sqlType = (String)  request.getParameter("sqlType") ;
	if (sqlType == null) sqlType = "sql";
	
	String expression = (String) request.getParameter("expression") ;
	if (expression == null) expression = "";
	
	String dataSource = (String) request.getParameter("dataSource") ;
	if (dataSource == null) dataSource = "mimi";
	
	Session testSession = null;
	ArrayList<Object> results = null;
	
	String error = null;
	
	if (expression.length() > 0) {
		if (dataSource.equals("mimi")) {
			testSession = MimiSessionFactory.getSessionFactory().getCurrentSession();
		}
		if (dataSource.equals("gene")) {
			testSession = GeneSessionFactory.getSessionFactory().getCurrentSession();
		}
		if (dataSource.equals("pubmed")) {
			testSession = PubmedSessionFactory.getSessionFactory().getCurrentSession();
		}
		if (testSession != null) {
			if (sqlType.equals("sql")) {
				try {
					testSession.beginTransaction();
					List<Object> get = (List<Object>)testSession.createSQLQuery(expression).list();
					if ((get != null) && (get.size() > 0)) {
						results = new ArrayList<Object>(get);
					}
				}
				catch (Throwable t) {
					error = "Sql error = " + t.getMessage();
				}
				finally {
					testSession.close();
				}
			}
		}
		if (testSession != null) {
			if (sqlType.equals("hsql")) {
				try {
					testSession.beginTransaction();
					List<Object> get = (List<Object>)testSession.createQuery(expression).list();
					if ((get != null) && (get.size() > 0)) {
						results = new ArrayList<Object>(get);
					}
				}
				catch (Throwable t) {
					error = "Hsql error = " + t.getMessage();
				}
				finally {
					testSession.close();
				}
			}
		}
		
		if (results != null) {
		    request.setAttribute("tableList", results) ;			
		}
	}
%>
</head>
<body>
<h3>Hibernate Utility</h3>
<p>Input SQL or HSQL to see a paged table of results</p>
<form>
	<input type="text" name="pageSize" value="<%= pageSize %>" size="5" /> Page Size <br/>
	<input type="radio" name="sqlType" value="sql" <%= sqlType.equals("sql")?"checked":"" %> /> SQL
	<input type="radio" name="sqlType" value="hsql"<%= sqlType.equals("hsql")?"checked":"" %> /> HSQL <br />
	<input type="radio" name="dataSource" value="mimi" <%= dataSource.equals("mimi")?"checked":"" %> /> mimi
	<input type="radio" name="dataSource" value="gene" <%= dataSource.equals("gene")?"checked":"" %> /> gene
	<input type="radio" name="dataSource" value="pubmed" <%= dataSource.equals("pubmed")?"checked":"" %> /> pubmed <br />
	<textarea name="expression" rows="10" cols="70"><%= expression %></textarea> <br />
	<input type="submit">
</form>

<%
	if (expression.length() > 0) {
%>
		SQL or Hsql = <%= expression %> <br />
<%
	}
%>

<%
	if (results == null) {
%>
		results list is null. <br />
<%
	} else {
%>
		length of results list = <%= results.size() %>
<%
	}
%>
<%
	if (error != null)
	{
%>
		<font color=red><%= error %></font>
<%
	}
%>

<display:table name="tableList" pagesize="<%= pageSize %>" />

</body>
</html>
