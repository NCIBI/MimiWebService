<%@ page language="java" contentType="text/html; charset=ISO-8859-1"
    pageEncoding="ISO-8859-1"
    import="
    java.util.ArrayList,
    org.ncibi.mimiweb.data.ResultGeneMolecule
    "
%><jsp:useBean id="access" class="org.ncibi.app2app.relay.DataListAccess" /><%

	ArrayList<ResultGeneMolecule> genes = (ArrayList<ResultGeneMolecule>)session.getAttribute("genelist");

	String title = "Save Gene List";
%>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN">
<html>
<head>
<meta http-equiv="content-type" content="text/html; charset=ISO-8859-1" >
<%	application.setAttribute("page-header-title",title); %>
<jsp:include page="metaHeader.jsp"></jsp:include>
<script type="text/javascript">

	function setAllCheckBoxes(FormName, FieldName, CheckValue)
	{
		if(!document.forms[FormName])
			return;
		var objCheckBoxes = document.forms[FormName].elements[FieldName];
		if (objCheckBoxes == null)
			return;
		var countCheckBoxes = objCheckBoxes.length;
		if(!countCheckBoxes)
			objCheckBoxes.checked = CheckValue;
		else
			// set the check value for all check boxes
			for(var i = 0; i < countCheckBoxes; i++)
				objCheckBoxes[i].checked = CheckValue;
	}

	function toggleAll(checked)
	{
		setAllCheckBoxes('submitForm','geneCheck',checked);
	}
</script>
</head>
<body onload="toggleAll(true);">
<div id="wrapper">
<jsp:include page="header.jsp"></jsp:include>
<div id="main-text">
<form id="save-form" method="post" action="saveGeneListConfirm.jsp" name="submitForm">
<input class="submit-button" name="saveList" value="Save Gene List" type="submit" />
<input type="hidden" name="dsAppName" value="MimiListSave" /> <br />
<table id="save-list-layout-table">
<tr><td>Email of User:</td><td><input type="text" name="user" value="test@test.com"/> Demo: test@test.com</td></tr>
<tr><td>Password:</td><td><input type="password" name="pw" value="test"/> Demo: test</td></tr>
<tr><td>Data set Name:</td><td><input type="text" name="dsName" /></td></tr>
<tr><td colspan="2">Data set Memo (comment):</td><td> 
<tr><td colspan="2"><textarea rows="2" cols="50" name="dsMemo" ></textarea></td></tr>
</table>
<input type="hidden" name="fields" value="GENEID_ENTREZ" />
<table id="save-list-table">
<tr><th>Select <input type="checkbox" name="allCheck" onclick="toggleAll(this.checked);" checked/></th>
	<th>Gene Symbol</th><th>Taxonomy</th></tr>
<%	for (ResultGeneMolecule gene: genes) {%>
<tr><td><input type="checkbox" name="geneCheck" value="<%= gene.getId() %>" /></td>
	<td><%= gene.getSymbol() %></td><td><%= gene.getTaxScientificName() %></td></tr>
<%	} %>
</table>
</form>
</div>
<div id="footer">&nbsp;
</div>
</div>
</body>
</html>
