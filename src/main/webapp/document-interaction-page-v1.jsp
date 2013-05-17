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
	String thisPage = "document-interaction-page-v1.jsp"; // there has to be some way to get this from the request
	
	String error = null;
    String geneid = request.getParameter("geneid") ;
	String interactionid = request.getParameter("interactionid") ;

    //save local params for reloop
    if (geneid != null)
    {
    	try {
	    	int value = Integer.parseInt(geneid);
	    	state.initWithGeneId(value);
    	}
    	catch (Throwable ignore){
    		error = "Unable to parse Gene Id paramter; geneid = " + geneid;
    	}
    }
    else if (interactionid != null)
    {
    	try {
	    	int value = Integer.parseInt(interactionid);
	    	state.initWithInteractionId(value);
    	}
    	catch (Throwable ignore){
    		error = "Unable to parse Interaction Id paramter; interactionid = " + interactionid;
    	}
    }
    
    if (error != null)
    {
		out.println(state.errorMessage(error));
		return;
    }
    
    HibernateInterface h = HibernateInterface.getInterface() ;
    ArrayList<DocumentBriefSimple> dlist = null ;

    String geneName = null ;
    String taxName = null ;
    DenormInteraction i = null ;

    if (state.isGene())
    {
	    LuceneInterface l = LuceneInterface.getInterface();
	    ResultGeneMolecule gene = l.getGeneData(state.getGeneId());
	    geneName = gene.getSymbol();
	    taxName = gene.getTaxScientificName();
        dlist = h.getDocumentsForGeneId(state.getGeneId()) ;
        state.setDocumentListFromDocs(dlist);
        state.computeKeywordMaps();
    }
    else if (state.isInteraction())
    {
        i = h.getBasicInteractionDetails(state.getInteractionId()) ;
        ArrayList<Integer> pmids = i.getPubmedIdList() ;
        dlist = h.getDocumentDetailsForPubmedList(pmids) ;
        state.setDocumentListFromDocs(dlist);        
        state.computeKeywordMaps();
    }

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
			<h2>Documents for Gene <% out.println(geneName + "(" + taxName + ")");%></h2>
<%		} else if (state.isInteraction()){ %>
			<h2>Documents for Gene Interactions <%=i.getSymbol1()%> and <%=i.getSymbol2()%></h2>
<%		} else { %>
			<h2>No Documents</h2>
<%		} 
if (state.isGene() || state.isInteraction()) {
	// the body of the document...
%>
<form name="documentForm" action="<%= thisPage %>" method="get" >
<span id="interact-doc-term-title">Select documents with...</span> <br />
<%	boolean first = true;
	String html = "";
	for (String term: state.getMeshKeySet()){
		String flatList = null;
		for (DocumentCoverForSelection doc: state.docsFroMeshTerm(term)) {
			if (flatList == null) flatList = doc.getId().toString();
			else flatList += "," + doc.getId().toString();
		}
		String part = term;
		if (flatList != null) part = "<a href=\"" + thisPage + "?select=" + flatList + "\">" + term + "</a>";
		if (first) html = part;
		else html += ", " + part;
		first = false;
	}
%>
<span class="interact-doc-term-heading">MeSH Terms (<%= state.getMeshKeySet().size() %>):</span> <%= html %><br >
<span class="interact-doc-term-heading">Tagged Gene Symbols:</span> <br />
<hr />
<span id="document-list">
<%
    request.setAttribute("dinfo",state.getDocumentList()) ;
%>
	<display:table export="true" name="dinfo" class="displaytag" id="dtable" requestURI="<%= thisPage %>">
		<display:column property="htmlCheckbox"
			title="<input type='checkbox' name='selectall' id='checkAll' onclick='selectAll(this)'/>"
			/>
        <display:setProperty name="export.csv.filename" value="abstracts.csv"/>
        <display:setProperty name="export.xml.filename" value="abstracts.xml"/>
        <display:setProperty name="export.excel.filename" value="abstracts.xls"/>
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
