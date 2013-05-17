<%@ page language="java"
    import="org.ncibi.mimiweb.util.Organism,
    org.ncibi.mimiweb.data.ResultGeneMolecule,
    org.ncibi.mimiweb.lucene.LuceneInterface,
    java.util.ArrayList"
%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="display" uri="http://displaytag.sf.net" %>

<html>
   <head>
       <title>MiMI Web - Main Search</title>
       <script type='text/javascript' src='<c:url value="/dwr/interface/DisplayTagService.js"/>'></script>
       <script type='text/javascript' src='<c:url value="/dwr/engine.js"/>'></script>
       <script type='text/javascript' src='<c:url value="/dwr/util.js"/>'></script>
       <link rel="stylesheet" type="text/css" href='<c:url value="/css/displaytag.css"/>' />
</head>
<body>
<%
	String search = request.getParameter("search") ;
	String taxidString = request.getParameter("taxid") ;
	if ((search != null) && (search.length() == 0)) search = null ;
%>
<jsp:include page="mimiHeaderInc.html" />
<div id="mimi-wrapper">
	<div id="mimi-top">
		<div id="mimi-search-form">
	        <form  name="luceneform" method="get" action="alt-main-page.jsp">
            	Search: <input name="search" <%= ((search==null)?"":"value=\""+search +"\"") %> /> 
				<input type="submit" value="Search" /> Limit Search by Organism: 
<%				String[][] orgs = Organism.organismArray;
				int sel = 1;

				if ((taxidString != null) && (taxidString.equals("-1"))) sel = 0; 
				else if (taxidString != null) {
					for (int i = 0; i < orgs.length; i++) {
						if (taxidString.equals(orgs[i][1])) sel = i;
					}
				}
%>            	<select name="taxid">
<%				for (int i = 0; i < orgs.length; i++) {
					if (i == sel) {
%>            			<option value="<%= orgs[i][1] %>" selected ><%= orgs[i][0] %></option>
<%					} else { 
%>            			<option value="<%= orgs[i][1] %>" ><%= orgs[i][0] %></option>
<%					}
				} 
%>          	</select>
	        </form>
		</div> <!-- end mimi-search-form -->
	</div> <!-- end mimi-top -->
	<div id="mimi-search-results">
		<div id="searchresults">
<%		if(search == null) {
%>			<i>Search results will be displayed here.</i>
<%		} else { 
        	int taxid = -1;
        	if (taxidString != null) {
	        	try {
	        		taxid = Integer.parseInt(taxidString);
	        	} catch (Throwable ignore) {}
        	}
        	LuceneInterface l = LuceneInterface.getInterface() ;
        	ArrayList<ResultGeneMolecule> mols = l.fullGeneSearch(taxid, search) ;
        	request.setAttribute("geneinfo", mols) ;
        	if (mols.size() == 0) {
%>
				<b>Search returns an empty result set: no results to display</b>
<%
        	} else {
%>
			    <display:table export="false" name="geneinfo" class="displaytag" id="geneinfo1" pagesize="20" requestURI="replaceURI">
					<display:setProperty name="basic.msg.empty_list" value="No genes were found in the database." />
					<display:setProperty name="paging.banner.item_name" value="gene" />
					<display:setProperty name="paging.banner.items_name" value="genes" />
			        <display:column property="symbol" title="Gene" sortable="true" headerClass="sortable" sortName="symbol" href="gene-details-page-front.jsp" paramId="geneid" paramProperty="id"/>
			        <display:column property="taxScientificName" title="Organism" sortable="true" headerClass="sortable" sortName="scientificTaxName"/>
			        <display:column property="geneType" title="Type" sortable="true" headerClass="sortable" sortName="geneType"/>
			        <display:column property="moleculeNamesString" title="Other Names"/>
			        <display:column property="description" title="Description"/>
			        <display:column property="cellularComponentsString" title="Components"/>
			        <display:column property="molecularFunctionsString" title="Functions"/>
			        <display:column property="biologicalProcessesString" title="Processes"/>
			        <display:column property="interactionCount" title="Int" sortable="true" headerClass="sortable" sortName=""/>
			        <display:column property="pubCount" title="Doc" sortable="true" headerClass="sortable" sortName="pubCount" href="document-list-page-front.jsp" paramId="geneid" paramProperty="id"/>
			        <display:column property="pathwayCount" title="P" sortable="true" headerClass="sortable" sortName="pathwayCount" href="pathway-list-page.jsp" paramId="geneid" paramProperty="id"/>
			    </display:table>
<%        		
        	}
%>
<%		}
%>
		</div> <!-- end searchresults -->
	</div> <!-- end  mimi-search-results-->
</div> <!-- end mimi-wrapper div -->
<jsp:include page="mimiFooterInc.html" />
</body>
</html>
