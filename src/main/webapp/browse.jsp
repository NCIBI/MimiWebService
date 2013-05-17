<%@ page language="java" contentType="text/html; charset=ISO-8859-1"
    pageEncoding="ISO-8859-1"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<%@page import="java.util.Iterator,
	java.util.ArrayList,
	java.net.URL,
	org.ncibi.mimiweb.browser.Constraint,
	org.ncibi.mimiweb.browser.BrowserUtil,
	org.ncibi.mimiweb.browser.hibernate.BrowserHibernateInterface,
	org.ncibi.mimiweb.browser.hibernate.data.GeneAttributeCount"%>
<jsp:useBean id="state" class="org.ncibi.mimiweb.browser.BrowserState" scope="session"/>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<html>
<head>
	<meta http-equiv="Content-Type" content="text/html; charset=ISO-8859-1">
	<title>AttributeBrowser</title>
	<script type='text/javascript' src='<c:url value="/dwr/interface/DisplayTagService.js"/>'></script>
	<script type='text/javascript' src='<c:url value="/dwr/engine.js"/>'></script>
	<script type='text/javascript' src='<c:url value="/dwr/util.js"/>'></script>
	<link rel="stylesheet" type="text/css" href='<c:url value="/css/displaytag.css"/>' />
</head>
<body>
<jsp:include page="mimiHeaderInc.html" />
<div id="mimi-nav">
<ul><li id="active">
<a href="main-page.jsp">Free Text Search</a></li>
<li><a href="upload-page.jsp">List Search</a></li>
<li><a href="interaction-query-page.jsp">Query Interactions</a></li>
<li><a href="AboutPage.html">About MiMI</a></li>
<li><a href="HelpPage.html">Help</a></li>
</ul>
</div>
<!-- End mimi-nav div -->
<div id="displayTable">

<%
	// constents
	String TOP_COUNT = "top_count_parameter";
	String BOTTOM_COUNT = "bottom_count_parameter";
	String RECORDS_TO_SHOW = "records_to_show_parameter";
	String GENES_TO_SHOW = "genes_to_show_parameter";
	String REMOVE_CONSTRAINT = "remote_constraint_parameter";
	String CLEAR_COMMAND = "clear";
	String REMOVE_COMMAND = "remove";
	
	// set up
	BrowserHibernateInterface h = BrowserHibernateInterface.getInterface();
	String hostname = request.getSession().getServletContext().getInitParameter("external-hostname");
	if ((hostname != null) && (hostname.length() == 0)) hostname = null;
	String serverName = request.getServerName();
	if (hostname != null) serverName = hostname;
	String uri = request.getRequestURI();
	int pos = uri.indexOf("/",1);
	String webappName = "MimiWeb";
	if (pos > 0) {
		webappName = uri.substring(1,pos);
	}
	int port = request.getServerPort();
	String baseUrl = (new URL(request.getScheme(),serverName,port,"/" + webappName)).toString();
	if (hostname != null)
		baseUrl = "http://" + hostname + "/" + webappName;

	ArrayList<GeneAttributeCount> list = null;

	// commands
	String clear = request.getParameter(CLEAR_COMMAND);
	String remove = request.getParameter(REMOVE_COMMAND);
	
	// parameters
	String selectCategory = request.getParameter("selectCategory");
	String selectAttribute = request.getParameter("selectAttribute");
	String topCountParameter = request.getParameter(TOP_COUNT);
	String bottomCountParameter = request.getParameter(BOTTOM_COUNT);
	String recordsToShowParameter = request.getParameter(RECORDS_TO_SHOW);
	String genesToShowParameter = request.getParameter(GENES_TO_SHOW);
	String removeConstraintParameter = request.getParameter(REMOVE_CONSTRAINT);
	
	if (topCountParameter != null)
	{
		try {
			int value = Integer.parseInt(topCountParameter);
			state.setTopCount(value);
		} catch (Throwable ignore){}
	}
	
	if (bottomCountParameter != null)
	{
		try {
			int value = Integer.parseInt(bottomCountParameter);
			state.setBottomCount(value);
		} catch (Throwable ignore){}
	}

	if (recordsToShowParameter != null)
	{
		try {
			int value = Integer.parseInt(recordsToShowParameter);
			state.setRecordsToShow(value);
		} catch (Throwable ignore){}
	}

	if (genesToShowParameter != null)
	{
		try {
			int value = Integer.parseInt(genesToShowParameter);
			state.setGenesToShow(value);
		} catch (Throwable ignore){}
	}

	int removeIndex = -1;
	if (removeConstraintParameter != null)
	{
		try {
			removeIndex = Integer.parseInt(removeConstraintParameter);
		} catch (Throwable ignore){}
	}
	
	String name = null;
	String value = null;
	if (selectAttribute != null){
		name = state.getSearchConstraint();
		value = selectAttribute;
	}
	
	//get and cache catagory list
	if (state.getCategoryList() == null) {
		state.setCategoryList(h.getAllAttributeCounts());
	}

	if (selectCategory != null) {
		state.setSearchConstraint(selectCategory);	
		state.setTopCount(-1);
		state.setBottomCount(-1);
	}
		
	if (clear != null) {
		state.clearConstraints();
		state.clearSearchConstraint();
		state.setTopCount(-1);
		state.setBottomCount(-1);
	} else if ((remove != null) && (removeIndex > -1) && (state.getConstraints().size() > 0)){
		state.removeConstraint(removeIndex);
	} else if ((name != null) && (value!= null) && (state.getSearchConstraint() != null)){
		state.addConstraint(name,value);
	}
	
%>
<h2>Constraint Based MiMI Browser</h2>
<!-- debugging display 
<ul>
	<li>selectCategory: <%= selectCategory %></li>
	<li>selectAttribute: <%= selectAttribute %></li>
	<li>clear: <%= clear %></li>
	<li>remove: <%= remove %></li>
	<li>name: <%= name %></li>
	<li>value: <%= value %></li>
</ul>
-->

<form action='<%= request.getRequestURI() %>' method="post"/>
<img id="browse-disclamer-image" src="images/under_construction_icon.jpg"><br />
<span id="browse-disclamer">Note, this part of the site is currently under development, please report problems to
the <a href="mailto:mimi-help@umich.edu">MiMI development team</a>.</span><br /><br />

<span id="browse-section-title">Query by Constraints on MiMI Database Attributes</span><br>
<table id="browse-current-query">
<tr>
<td style="vertical-align: top; width: 30%;">
<span id="browse-bold">Current query clauses:</span><br />
<%
	int clauseCount = 0;
	if (state.count() == 0) {
%>
		<i>none</i>
<%	
	} else {
		for (Constraint c: state.getConstraints()){
			clauseCount++;
%>
			<input type="radio" name="<%= REMOVE_CONSTRAINT %>" value="<%= (clauseCount - 1) %>" />
			<%= c.getType() %>: 
				<%= c.getValue() + ((clauseCount != state.count())?" AND ":"")%> <br />
<%
		}
	}
%>
</td>
<td>
<input id="browse-submit"
	type="submit" value="Clear all constraints" name="<%= CLEAR_COMMAND %>" />
<br />
<input id="browse-submit"
	type="submit" value="Delete selected constraint" name="<%= REMOVE_COMMAND %>" />
</td>
<td>
<br />
</td>
</tr>
</table>
</form>
<%
	if (state.getSearchConstraint() == null) {
%>
<span id="browse-section-title">Configure browse table</span>
<%
	} else {
%>
<span id="browse-section-title">Reconfigure Browse table</span>
<%
	}

	ArrayList<GeneAttributeCount> attributeCounts 
		= h.getAllAttributeCounts(state.getSearchConstraint(),state.getConstraints());
	
	int totalResponses = attributeCounts.size();
	int recordsToShow = state.getRecordsToShow();
	recordsToShow = Math.min(recordsToShow,attributeCounts.size());
	int genesToShow = state.getGenesToShow();

	int totalTopCount = 0;
	if (totalResponses > 0)
		totalTopCount = attributeCounts.get(0).getCount(); // first item has highest count
	int topCount = state.getTopCount();
	if ((topCount < 0) && (totalTopCount > 0)) {
		topCount = totalTopCount;
		state.setTopCount(topCount);
	}
	
	int totalBottomCount = 0;
	if (totalResponses > 0)
		totalBottomCount = attributeCounts.get(attributeCounts.size()-1).getCount(); // last item has lowest count
	int bottomCount = state.getBottomCount();
	if ((bottomCount < 0) && (totalBottomCount > 0)) {
		bottomCount = totalBottomCount;
		state.setBottomCount(totalBottomCount);
	}
	
%>
<table><tr><td>
<form action='<%= request.getRequestURI() %>' method="post"/>
<%
	int colCount = 0;
	String selection = state.getSearchConstraint();
	if (selection == null) selection = "";
	for (GeneAttributeCount c: state.getCategoryList()){
		String categoryValue = c.getId().getAttributeType();
		boolean match = selection.equalsIgnoreCase(categoryValue);
		String printName = BrowserUtil.attributeDisplayName(c.getId().getAttributeType());
		if (printName != null)
		{
%>
			<input id="browse-submit" type="radio" name="selectCategory" value="<%= categoryValue %>" />
<%			if (match) 
			{
%>
				<b><%= printName %></b>
<%
			} else {
%>
				<%= printName %>
<%
			}
%>
			<br />
<%
		} // if (printName ...)
	} // for
%>
<input type="submit" value="Select Attribute" />
</form>
</td>
<%

if (state.getSearchConstraint() != null) {
%>
<td>
	<span>
	<b>Viewing summary records for Attribute, '<%= selection %>'</b>, in the context of the current query. <br />
	There are a total of <b><%= totalResponses %></b> summary records with gene 
		counts ranging from <b><%= totalBottomCount %></b> to <b><%= totalTopCount %></b>. <br />
<%	
	if (recordsToShow == attributeCounts.size()) {
%>
	Viewing all <b><%= recordsToShow %></b> 
<%	
	} else { 
%>
	Viewing the first <b><%= recordsToShow %></b> 
<%
	}  
%>
		summary records sorted by <b>gene count decreasing</b>,
		with gene counts ranging from <b><%= bottomCount %></b> to <b><%= topCount %></b> inclusive. <br />
	Viewing the first <b><%= genesToShow %></b> genes in each summary record. <br />
	</span><br />
<form action='<%= request.getRequestURI() %>' method="post"/>
	<input type="text" name="<%= BOTTOM_COUNT %>" value="<%= bottomCount %>" /> low gene count; 
		<input type="text" name="<%= TOP_COUNT %>" value="<%= topCount %>" /> high gene count <br />
	<input type="text" name="<%= RECORDS_TO_SHOW %>" value="<%= recordsToShow %>" /> number of summary records to show <br />
	<input type="text" name="<%= GENES_TO_SHOW %>" value="<%= genesToShow %>" /> number of genes to show per record <br />
	<input type="submit" value="change table configuration" />
</form>
</td>
<%
}
%>
</tr>
</table>
<%
if (state.getSearchConstraint() != null) {
%>
	<form action='<%= request.getRequestURI() %>' method="post"/>
	<table id="browse-result-table">
	<thead>
	<tr><td><b><input type="submit" id="browse-submit" value="Select" /> <%= state.getSearchConstraint() %></b></td>
	<td><b>Number of Genes</b></td>
	<td><b>Value for <%= state.getSearchConstraint() %> attribute</b></td>
	<td><b>Links to gene detail in MiMI Web (** indicates incomplete list)</b></td>
	</tr>
	</thead>
<%
	
	int index = 0;
	for (GeneAttributeCount c: attributeCounts) {
		String v = c.getId().getAttributeValue();
		int n = c.getCount();
		if ((n >= bottomCount) && (n <= topCount)) {
%>
	<tr>
		<td>
			<input type="radio" id="browse-submit" name="selectAttribute" value="<%= v %>" />
		</td>
		<td><%= n %></td>
		<td><%= v %></td>
		<td><%= BrowserUtil.makeLinkString(baseUrl,state,c) %> 
		<a href="exportBrowse.jsp?index=<%= index %>">Download All Genes</a>
		</td>
	</tr>
<%
			index++;
			if (index > recordsToShow) break;
		}
	}
%>
	</table>
	</form>
<%
} // if (state.getSearchConstraint() != null)
%>

</div> <!-- end of display table div -->
<jsp:include page="mimiFooterInc.html" />
</body>
</html>
