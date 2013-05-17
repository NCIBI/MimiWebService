<%@ page contentType="text/html; charset=UTF-8"%>
<%@ page isELIgnored="false" %>
<%@ page import="
	org.ncibi.mimiweb.data.*,
	org.ncibi.mimiweb.data.hibernate.*
"
%>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<jsp:useBean id="state" class="org.ncibi.mimiweb.data.DocumentInteractionSelectState" scope="session"/>
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
<meta http-equiv="Content-Type" content="text/html; charset=ISO-8859-1" />
<link rel="stylesheet" type="text/css" href='css/displaytag.css' />
<title>Update MeSH Terms of Interest (for Document Selection Page)</title>
</head>
<body>
    <jsp:include page="mimiHeaderInc.html" />
    <div id="mimi-nav">
	<ul>
	<li><a href="main-page.jsp">Free Text Search</a></li>
	<li><a href="upload-page.jsp">List Search</a></li>
	<li><a href="interaction-query-page.jsp">Query Interactions</a></li>
	<li><a href="AboutPage.html">About MiMI</a></li>
	<li><a href="HelpPage.html">Help</a></li>
	</ul>
</div><!-- End mimi-nav div -->

<h2>Select MeSH Terms of Interest</h2>
<div>
<form action="document-interaction-page.jsp" method="post">
<input type="submit" value="Update the MeSH Term list" name="updateMeshSelection" />
or <a href="document-interaction-page.jsp">return</a> to the document selection page.
<table>
<thead>
<tr><td>Hide</td><td>Show</td><td>MeSH Term</td><td>Notes</td></tr>
</thead>
<tbody>
<%	for (MeshDescriptor term: state.getAlphaSortedMeshKeyList()){
%>
<tr><td><input type="radio" name="hideShow-<%= term.getId() %>" 
			value="hide" <%= (!term.isShown())?"checked":"" %>/></td>
	<td><input type="radio" name="hideShow-<%= term.getId() %>" 
			value="show" <%= (term.isShown())?"checked":"" %>/></td>
	<td><%= term.getName() %></td>
	<td><%= term.getScopeNote() %></td>
</tr>
<%	}  %>
</tbody>
</table>
</form>
</div>
<jsp:include page="mimiFooterInc.html" />
</body>
</html>
