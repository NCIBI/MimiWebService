<%@ page contentType="text/html; charset=UTF-8"%>
<%@ page isELIgnored="false" %>
<%@ taglib uri="http://displaytag.sf.net" prefix="display" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ page import="java.util.ArrayList,
    	org.ncibi.mimiweb.data.*,
        org.ncibi.mimiweb.data.hibernate.*,
    	org.ncibi.mimiweb.hibernate.HibernateInterface,
    	org.ncibi.mimiweb.lucene.LuceneInterface"
%>
<jsp:useBean id="state" class="org.ncibi.mimiweb.data.DocumentInteractionSelectState" scope="session"/>
<%
	String thisPage = "document-interaction-page.jsp"; // there has to be some way to get this from the request
	
	int debugInt = 0;
	
	String error = null;
    String geneid = request.getParameter("geneid") ;
	String interactionid = request.getParameter("interactionid") ;
	String meshSelectionUpdate = request.getParameter("updateMeshSelection");
	String selectWithMesh = request.getParameter("selectWithMesh");
	String addWithMesh = request.getParameter("addWithMesh");

	state.setCommand(DocumentInteractionSelectState.NONE);
	if (meshSelectionUpdate != null)
		state.setCommand(DocumentInteractionSelectState.SHOW_HIDE_MESH);
	if (selectWithMesh != null)
		state.setCommand(DocumentInteractionSelectState.SELECT_DOCS_WITH_MESH);
	if (addWithMesh != null)
		state.setCommand(DocumentInteractionSelectState.ADD_DOCS_WITH_MESH);
	if (geneid != null)
		state.setCommand(DocumentInteractionSelectState.INIT_GENE);
	if (interactionid != null)
		state.setCommand(DocumentInteractionSelectState.INIT_INTERACTION);
	
    //For commands: parse parameters; update state...
    if (state.getCommand() == DocumentInteractionSelectState.INIT_GENE)
    {
    	int value = -1;
    	try {
	    	value = Integer.parseInt(geneid);
    	}
    	catch (Throwable ignore){
    		error = "Unable to parse Gene Id paramter; geneid = " + geneid;
    	}
    	if (error == null) {
    		try {
	    		state.initWithGeneId(value);
    		} catch (Throwable ex) {
    			error = "Failed to get gene information for gene id = " + value + "; " + ex.getMessage();
    		}
    	}
    }
    else if (state.getCommand() == DocumentInteractionSelectState.INIT_INTERACTION)
    {
    	int value = -1;
    	try {
	    	value = Integer.parseInt(interactionid);
    	}
    	catch (Throwable ignore){
    		error = "Unable to parse Interaction Id paramter; interactionid = " + interactionid;
    	}
    	if (error == null) {
    		try {
    	    	state.initWithInteractionId(value);
    		} catch (Throwable ex) {
    			error = "Failed to get interaction information for interaction id = " + value + "; " + ex.getMessage();
    		}
    	}
    }
    else if (state.getCommand() == DocumentInteractionSelectState.SHOW_HIDE_MESH)
    {
    	for (MeshDescriptor term: state.getAlphaSortedMeshKeyList()){
    		String name = "hideShow-" + term.getId();
    		String value = request.getParameter(name);
    		term.setShown((value != null) && (value.equalsIgnoreCase("show")));
    	}
    }
    else if ((state.getCommand() == DocumentInteractionSelectState.SELECT_DOCS_WITH_MESH) ||
    		(state.getCommand() == DocumentInteractionSelectState.ADD_DOCS_WITH_MESH))
    {
    	String[] meshIdStrings = request.getParameterValues("meshIndex");
    	if (meshIdStrings == null) meshIdStrings = new String[0];
    	ArrayList<Integer> inputIdValueList = new ArrayList<Integer>(meshIdStrings.length);
    	String attempt = "";
    	try {
	    	for (String value: meshIdStrings){
	    		attempt = value;
	    		inputIdValueList.add(new Integer(Integer.parseInt(attempt)));
	    	}
    	} catch (Throwable t) {
    		error = "Failured to parse MeSH term (internal) index: " + attempt;
    	}
    	if (error == null) {
    		// clear previous mesh term selections
			ArrayList<MeshDescriptor> terms = state.getCountSortedMeshKeyList();
		    for (MeshDescriptor term: terms)
		    	term.setSelected(false);
		    // mark mesh term selections and relevent docs
    		state.markDocsFromMeshIds(inputIdValueList,
    				(state.getCommand() == DocumentInteractionSelectState.SELECT_DOCS_WITH_MESH));
    	}
    }
    
    if (error != null)
    {
		out.println(state.errorMessage(error));
		return;
    }
    
    int initialTermListLength = 20;
    
    if ((state.getCommand() == DocumentInteractionSelectState.INIT_GENE) ||
    		(state.getCommand() == DocumentInteractionSelectState.INIT_INTERACTION)) {
	    // set up an initial list of selected terms
		ArrayList<MeshDescriptor> terms = state.getCountSortedMeshKeyList();
	    for (MeshDescriptor term: terms)
	    	term.setSelected(false);
	    for (int i = 0; (i<terms.size()) && (i < initialTermListLength);i++)
	    	terms.get(i).setShown(true);	
    }

    state.checkForOrLaunchFullMeshTree();
%>

<html><head><title>MiMI Document List</title>
<script type='text/javascript' src='<c:url value="/dwr/interface/DisplayTagService.js"/>'></script>
<script type='text/javascript' src='<c:url value="/dwr/engine.js"/>'></script>
<script type='text/javascript' src='<c:url value="/dwr/util.js"/>'></script>
<link rel="stylesheet" type="text/css" href='<c:url value="/css/displaytag.css"/>' />

<script type="text/javascript">
	function selectAll(ref) {
		var chkAll = document.getElementById('checkAll');
		var checks = document.getElementsByName('select');
		var length = checks.length;
		var checked = chkAll.checked;
		for (i = 0; i < length; i++) {
			checks[i].checked = checked;
		}
	}
</script>
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
        <div id="displayTable">
<%		if (state.isGene()) { %>
			<h2>Documents for Gene <%= state.getGene().getSymbol() + "(" + state.getGene().getTaxScientificName() + ")" %></h2>
<%		} else if (state.isInteraction()){ %>
			<h2>Documents for Gene Interactions <%=state.getInteraction().getSymbol1()%> 
				and <%=state.getInteraction().getSymbol2()%></h2>
<%		} else { %>
			<h2>No Documents</h2>
<%		} 
if (state.isGene() || state.isInteraction()) {
	// the body of the document...
%>
<%
// ----------------------- DEBUGGING -----------------------------------
// insert debugging information to be displayed on the page, between these marks
%>
<%
// ----------------------- DEBUGGING -----------------------------------
%>
<form name="documentForm" action="<%= thisPage %>" method="post" >
<span id="interact-doc-term-title">Use MeSH terms to select documents or add to document selection...</span> <br />
<input type="submit" value="Select Documents" name="selectWithMesh" />
or
<input type="submit" value="Add to Document selection" name="addWithMesh" />
<br />
<%	ArrayList<MeshDescriptor> keys = state.getCountSortedMeshKeyList();
	int numberOfTermsShown = 0;
	for (MeshDescriptor termDesc: keys)
		if (termDesc.isShown()) 
			numberOfTermsShown++;
%>
<span class="interact-doc-term-heading">
MeSH Terms (Showing <%= numberOfTermsShown %> of <%= state.getMeshKeySet().size() %>)</span> - 
<a href="document-interaction-term-choice.jsp">change</a> the list of terms shown/hidden:	
<%	
	int n = 0;
	for (MeshDescriptor termDesc: keys){
		if (termDesc.isShown()) {
			n++;
			String term = termDesc.getName();
			String index = termDesc.getId().toString();
			int count = state.getDocCountForMeshTerm(termDesc);
			boolean selected = termDesc.isSelected();
%>
			<input type="checkbox" name="meshIndex" value="<%= index %>" <%= selected?"checked":"" %> />
			<%= term %> (<%= count %> docs)<%= (n<numberOfTermsShown)?",":"" %>
<%
		}
	}
%>
<hr />
<span id="document-list">
<%
    request.setAttribute("dinfo",state.getDocumentList()) ;
%>
	<display:table export="true" name="dinfo" class="displaytag" id="dtable" requestURI="<%= thisPage %>">
		<display:column property="htmlCheckbox"
			title="<input type='checkbox' name='selectall' id='checkAll' onclick='selectAll(this)'/>"
			/>
        <display:setProperty name="export.csv.filename" value="abstracts_tags.csv"/>
        <display:setProperty name="export.xml.filename" value="abstracts_tags.xml"/>
        <display:setProperty name="export.excel.filename" value="abstracts_tags.xls"/>
	    <display:column sortable="true" property="pubmedHTML" title="Pubmed Id"/>
	    <display:column sortable="true" title="View Details" href="document-details-page-front.jsp" paramId="pubmedid" paramProperty="id">View</display:column>
		<display:column sortable="true" property="year" title="Year"/>
	    <display:column sortable="true" property="citation" title="Full Citation"/>
		<display:column sortable="true" property="authors" title="Author(s)"/>
	    <display:column sortable="true" property="title" title="Title"/>
	    <display:column property="meshTermString" title="MeSH"/>
	</display:table>
</span>
</form>
<%
}
%>
</div>
<jsp:include page="mimiFooterInc.html" />
</body>
</html>
