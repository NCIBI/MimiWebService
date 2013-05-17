<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN">
<%@
    page language="java" 
    import="
    org.ncibi.mimiweb.hibernate.HibernateInterface,
    org.ncibi.mimiweb.hibernate.HibernateInterfaceForGeneQuery,
    org.ncibi.mimiweb.lucene.LuceneInterface,
    org.ncibi.mimiweb.dwr.SelectionServiceForGeneQueryPage,
    org.ncibi.mimiweb.data.GeneCoverForSelection,
    org.ncibi.mimiweb.data.GeneQueryInteraction,
    org.ncibi.mimiweb.data.AttributeFilter,
    org.ncibi.mimiweb.data.AttributeTreeNode,
    org.ncibi.mimiweb.util.GeneQueryPageUtil,
    org.ncibi.mimiweb.util.Organism,
    java.util.ArrayList,
    org.apache.log4j.Logger
    "
%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<jsp:useBean id="geneQueryState" class="org.ncibi.mimiweb.data.GeneQueryStateHolder" scope="session"/>
<jsp:useBean id="userProfile" class="org.ncibi.mimiweb.xml.UserProfileCover" scope="session"/>
<%

	Logger logger = Logger.getLogger("org.ncibi.jsp.gene-query-page");

	String pageName = "gene-query-page.jsp"; //ToDo: we should be able to get this from the request!

	String attributeFilterClearCommand = request.getParameter("attributeFilterClearCommand");
	String attributeFilterCommand = request.getParameter("attributeFilterCommand");
	String geneQueryCommand = request.getParameter("geneQueryCommand");
	if (attributeFilterClearCommand != null) {
		attributeFilterCommand = null;
		geneQueryCommand = null;
	}
	if (attributeFilterCommand != null) geneQueryCommand=null;
	
	String search = request.getParameter("search") ;
	if ((search != null) && (search.length() == 0)) search = null ;
	
	String taxidString = request.getParameter("taxid") ;
	
	String[] geneAttrSelection = request.getParameterValues("gene-checkbox");
	String[] intrAttrSelection = request.getParameterValues("interest-checkbox");

	if ((geneQueryCommand != null) && (search != null)) {
		GeneQueryPageUtil.setGeneQueryStateFromSearch(geneQueryState, search,taxidString);
		logger.debug("set query from search: " + search + "," + taxidString);
	}
	
	// in case it is changed by setGeneQueryStateFromSearch above, or not specified by the input
	search = geneQueryState.getOriginalSearch();
	taxidString = "" + geneQueryState.getTaxid();
	
	if (attributeFilterCommand != null) {
		if (geneAttrSelection != null)
			geneQueryState.setGeneSelection(geneAttrSelection);
		if (intrAttrSelection != null)
			geneQueryState.setIntrSelection(intrAttrSelection);

		//Note: gene selections are updated 'on the fly' by the GeneSelectionService, see javascript, below
		GeneQueryPageUtil.updateAttributeSelections(geneQueryState);
		GeneQueryPageUtil.setAttributeFilters(geneQueryState);

	} else if (attributeFilterClearCommand != null)
	{
		geneQueryState.setGeneSelection(null);
		geneQueryState.setIntrSelection(null);
		GeneQueryPageUtil.clearAttributeSelections(geneQueryState);
		GeneQueryPageUtil.clearAttributeFilters(geneQueryState);
	}
	
	GeneQueryPageUtil.determineMarkedSets(geneQueryState);
	
//	logger.debug("just before update user profile");
	userProfile = GeneQueryPageUtil.updateUserProfile(userProfile, geneQueryState);
	
	if ((geneQueryState.getGenes() != null) && (geneQueryState.getGenes().size() > 0))
		SelectionServiceForGeneQueryPage.register(geneQueryState);

	String titleExtend = "";
	if (geneQueryState.getOriginalSearch() != null)
	    titleExtend = " - " + geneQueryState.getOriginalSearch();
	if (geneQueryState.getOrganism() != null) titleExtend += "(" + geneQueryState.getOrganism() + ")";

//	logger.debug("end of prolog");
%>

<%@page import="org.ncibi.mimiweb.xml.UserProfileCover"%><html>
<head>
<title>MiMI Web - Gene Query<%=titleExtend%></title>
<script type='text/javascript' src='<c:url value="/dwr/interface/DisplayTagService.js"/>'></script>
<script type='text/javascript' src='<c:url value="/dwr/interface/GeneSelectionService.js"/>'></script>
<script type='text/javascript' src='<c:url value="/dwr/engine.js"/>'></script>
<script type='text/javascript' src='<c:url value="/dwr/util.js"/>'></script>
<script type="text/javascript" src="js/ncibi.js"></script>
<script type='text/javascript' language="javascript">

</script>
<link rel="stylesheet" type="text/css"
	href='<c:url value="/css/displaytag.css"/>' />
<script type="text/javascript">
	var openImg = new Image();
	openImg.src = "images/opened.png";
	var closedImg = new Image();
	closedImg.src = "images/closed.png";

	function showBranch(branch) {
	    var objBranch = 
	       document.getElementById(branch).style;
	    if(objBranch.display=="block")
	       objBranch.display="none";
	    else
	       objBranch.display="block";
	}
	 
	function swapFolder(img) {
	    objImg = document.getElementById(img);
	    if(objImg.src.indexOf('closed.png')>-1)
	       objImg.src = openImg.src;
	    else
	       objImg.src = closedImg.src;
	}

	function updateSearch() {
		html = "<p>Searching...<br/><image src=\"images/new_status_bar.gif\"/>" ;
		dwr.util.setValue("dt-replace-here", html, { escapeHtml:false }) ;
		DisplayTagService.updateLinks("update2","/gene-query-table.jsp", "", ncibi_callback) ;
	}
	
	function update2(js, jsp, criteria) {
		console.log("update2", js, jsp, criteria);
		DisplayTagService.updateLinks(js, jsp, criteria, ncibi_callback);
	}

	// see the method getCheckBoxHtml in GeneCoverForSelection
	function geneTableSelectionClick(element, geneid){
		console.log("geneTableSelectionClick", geneid);
		var marked = element.checked;
		GeneSelectionService.mark(<%= geneQueryState.getKey() %>,geneid,marked,markReply);
	}

	function markReply(data){
		console.log("markReply",data);
		if (!data) refreshThePage();
	}

	function refreshThePage() {
		alert("User Interaction information has expired; refreshing page");
		location.reload(true);
	}

	function unregister() {
		console.log("unregister",<%= geneQueryState.getKey() %>);		
		GeneSelectionService.unregisterByKey(<%= geneQueryState.getKey() %>);
	}

	function geneSelectAll() {
		GeneSelectionService.selectAll(<%= geneQueryState.getKey() %>);
	}

	function geneSelectNone() {
		GeneSelectionService.selectNone(<%= geneQueryState.getKey() %>);
	}
</script>
</head>
<body onunload="unregister()" >
<jsp:include page="mimiHeaderInc.html" />
<div id="mimi-wrapper">
<div id="mimi-nav">
<ul>
<li><a href="main-page.jsp">Free Text Search</a></li>
<li><a href="upload-page.jsp">List Search</a></li>
<li><a href="interaction-query-page.jsp">Query Interactions</a></li>
<li><a href="AboutPage.html">About MiMI</a></li>
<li><a href="HelpPage.html">Help</a></li>
</ul>
</div>
<!-- End mimi-nav div -->
<span id="debug-gene-list">
<%
	if (geneQueryState.getGenes() != null) {
%>
		<p>
		Debugging Information -- <br />
		Command:
		<ul>
		<li>Clear: <%= (attributeFilterClearCommand != null)?"yes":"no" %></li>
		<li>Query: <%= (geneQueryCommand != null)?"yes":"no" %></li>
		<li>Filter: <%= (attributeFilterCommand != null)?"yes":"no" %></li>
		</ul>
		State: 
		<ul>
		<li>Search - <%= geneQueryState.getOriginalSearch() %></li>
		<li>Organism - <%= geneQueryState.getOrganism() %></li>
		<li>taxid - <%= geneQueryState.getTaxid() %></li>
		<li>Key - <%= geneQueryState.getKey() %></li>
		</ul>
		Genes:
<%
			boolean first = true;
			for (GeneCoverForSelection gene: geneQueryState.getGenes()) {
				String geneName = gene.getId().toString();
				if (gene.isSelected()) geneName = geneName + "**";
				if (!first) geneName = ", " + geneName;
%>
				<%=geneName%>
<%
				first=false;
			}
%>
		<br><span>Gene Attribute Selection Input is: 
		<%
			if (geneAttrSelection == null) {
		%>
			null
			<%
			} else {
			for (String s: geneAttrSelection) {
		%>
				<%=s%>
				<%
					}
						}
				%>
		</span>
		<br><span>Gene Attribute Selected Nodes are: 
		<%
			String outStr = null;
			for (AttributeTreeNode attr: geneQueryState.getGeneAttrTree()) {
				if (attr.isSelected()){
					if (outStr == null) outStr = attr.getName();
					else outStr += "; " + attr.getName();
				}
				for (AttributeTreeNode value: attr.getChildList()) {
					if (value.isSelected()){
						String entry = attr.getName() + ": " + value.getName();
						if (outStr == null) outStr = entry;
						else outStr += "; " + entry;
					}
				}
			}
		%>
		<%= outStr %>
		</span>
		<br><span>Interaction Attribute Selection Input is:
		<%
			if (intrAttrSelection == null) {
		%>
			null
			<%
			} else {
			for (String s: intrAttrSelection) {
		%>
				<%=s%>
				<%
					}
						}
				%>
		</span>
		<br><span>Interaction Attribute Selected Nodes are: 
		<%
			outStr = null;
			for (AttributeTreeNode attr: geneQueryState.getIntrAttrTree()) {
				if (attr.isSelected()){
					if (outStr == null) outStr = attr.getName();
					else outStr += "; " + attr.getName();
				}
				for (AttributeTreeNode value: attr.getChildList()) {
					if (value.isSelected()){
						String entry = attr.getName() + ": " + value.getName();
						if (outStr == null) outStr = entry;
						else outStr += "; " + entry;
					}
				}
			}
		%>
		<%= outStr %>
		</span>
		<br><span>Gene Attribute Filters are: 
		<%
			outStr = null;
			for (AttributeFilter attr: geneQueryState.getGeneAttributeFilters()) {
				String entry = attr.getName() + ": " + attr.getValue();
				if (outStr == null) outStr = entry;
				else outStr += "; " + entry;
			}
		%>
		<%= outStr %>
		</span>
		<br><span>Interaction Attribute Filters are: 
		<%
			outStr = null;
			for (AttributeFilter attr: geneQueryState.getIntrAttributeFilters()) {
				String entry = attr.getName() + ": " + attr.getValue();
				if (outStr == null) outStr = entry;
				else outStr += "; " + entry;
			}
		%>
		<%= outStr %>
		</span>
		<br><span>Gene Filters are: 
		<%
			outStr = null;
			for (GeneCoverForSelection gene: geneQueryState.getGeneFilters()) {
				String entry = gene.getSymbol();
				if (outStr == null) outStr = entry;
				else outStr += "; " + entry;
			}
		%>
		<%= outStr %>
		</span>
		</p>
<%
	}
//	logger.debug("End of debug output");
%>
</span>
<table id="mimi-gene-query-table">
	<tbody>
		<tr id="query-row">
			<td>
			<div id="mimi-gene-query-top">

			<span id="mimi-gene-query-title">Search for genes and their 'first neighbor' interactions in MiMI</span>
			<div id="mimi-gene-query-form">
			<form name="luceneform" method="post" action="<%= pageName %>">
			<div id="search-field">
				<input name="search" <%=((search==null)?"":"value=\""+search +"\"")%> />
			</div>
			<!-- end search-field -->
			<div id="search-field-bottom">
				<span id="query-example">Examples: pwp1; csfr1, csf, csf1</span>
				<input id="search-button" type="submit" value="MiMI Search" name="geneQueryCommand" /></div>
			<!-- end search-field-bottom -->
			<div id="filter-field">
				<%
					String[][] orgs = Organism.organismArray;
						int sel = 1;
						
						if ((taxidString != null) && (taxidString.equals("-1"))) sel = 0; 
						else if (taxidString != null) {
							for (int i = 0; i < orgs.length; i++) {
								if (taxidString.equals(orgs[i][1])) sel = i;
							}
						}
				%> 
				<select name="taxid">
				<%
					for (int i = 0; i < orgs.length; i++) {
							if (i == sel) {
				%>
						<option value="<%=orgs[i][1]%>" selected><%=orgs[i][0]%></option>
						<%
							} else {
						%>
						<option value="<%=orgs[i][1]%>"><%=orgs[i][0]%></option>
						<%
							}
								}
						%>
				</select>
			</div><!-- end filter-field -->
			<div id="filter-field-bottom">Limit Search by Organism</div>
	</form>
	</div> <!-- end mimi-gene-query-form -->
</div><!-- end mimi-top -->

</td>
</tr>
</tbody>
</table>
<form action="<%= pageName %>" method="post">
<table>
<tbody>
<tr>
<td id="filter-addtions">
<h2 id="filter-additions-title">Additional Filters</h2>
<span id="submit-label">
	Use the check boxes on the attribute values and gene table to select construct and add filters to the search.<br />
	<input type="submit" value="add or update filters" name="attributeFilterCommand"/>
	<input type="submit" value="clear all filters" name="attributeFilterClearCommand" />
</span>
<br />
<%
if (!(geneQueryState.getGeneAttributeFilters().isEmpty()
		&& geneQueryState.getIntrAttributeFilters().isEmpty()
		&& geneQueryState.getGeneFilters().isEmpty()))
{
	%>
	Using the following filters:
	<%

	if (!(geneQueryState.getGeneFilters().isEmpty())){
		String geneList = null;
		for (GeneCoverForSelection gene: geneQueryState.getGeneFilters()) {
			String part = gene.getSymbol() + "(" + gene.getTaxScientificName() + ")";
			if (geneList == null) geneList = part;
			else geneList += ", " + part;
		}
%>
		Select, for marked set, genes from these: <%= geneList %> <br />
<%
	}
	if (!(geneQueryState.getGeneAttributeFilters().isEmpty())){
%>
		Select, for marked set, only genes with these attribute-value pairs:
		<ul>
<% 		for (AttributeFilter f: geneQueryState.getGeneAttributeFilters()) {%>
		<li><%= f.getName() %> - <%= f.getValue() %></li>
<% 		} %>
		</ul>
<%
	}
	if (!(geneQueryState.getIntrAttributeFilters().isEmpty())){
%>
		Select, for marked set, only interactions with these attribute-value pairs:
		<ul>
<% 		for (AttributeFilter f: geneQueryState.getIntrAttributeFilters()) {%>
		<li><%= f.getName() %> - <%= f.getValue() %></li>
<% 		} %>
		</ul>
<%
	}
%>
	<br />
	The marked set of genes is:
<%
	if (geneQueryState.getMarkedGeneSet().isEmpty()){
%>
	empty.
<%
	} else {
%>
		<ul>
<%		
		for (GeneCoverForSelection gene: geneQueryState.getMarkedGeneSet()){
%>
			<li><%= gene.getSymbol() + "(" + gene.getTaxScientificName() + ")" %></li>
<%		
		}
%>
		</ul>	
<%		
	}
%>
	<br />
	The marked set of interacions is:
<%
	if (geneQueryState.getMarkedIntrSet().isEmpty()){
%>
	empty.
<%
	} else {
%>
		<ul>
<%		
		for (GeneQueryInteraction intr: geneQueryState.getMarkedIntrSet()){
			GeneCoverForSelection gene1 = intr.getGene1();
			GeneCoverForSelection gene2 = intr.getGene1();
%>
			<li><%= gene1.getSymbol() + "(" + gene1.getTaxScientificName() + ")" %> --
			<%= gene2.getSymbol() + "(" + gene2.getTaxScientificName() + ")" %>
			</li>
<%		
		}
%>
		</ul>	
<%		
	}
} else {
%>
	No Filters. No genes or interactions in the marked set.
<%	
}
%>
</td>
</tr>
</tbody>
</table>
<table id="mimi-results-table">
	<tbody>
		<tr id="results-title">
			<td colspan="2">
			<h2 id="result-title">Query Results</h2>
			<span id="download-lable"><a href="gene-query-save.jsp">Save</a> or <a href="gene-query-restore.jsp">restore</a> user state.</span><br />
			<span id="">See this data <a href="link-to-cytoscape">in Cytoscape</a>.</span><br />  
			</td>
		</tr>
		<tr id="result">
			<td id="attribute-listings-holder">
			<div class="attribute-listing-title">Gene Attributes<span class="attribute-count">number of genes</span></div>
			<div class="attribute-listing" id="gene-attribute-list">
			<%
				if ((geneQueryState.getGeneAttrTree() == null) || (geneQueryState.getGeneAttrTree().size() == 0)){
			%>
				<span class="attribute-listing-empty">none</span>
			<%
				} else {
					int index = 0;
					for (AttributeTreeNode node: geneQueryState.getGeneAttrTree()) {
						index++;
						ArrayList<AttributeTreeNode> childList = new ArrayList<AttributeTreeNode>();
						if (node.getChildList() != null) childList = node.getChildList();
						int size = childList.size();
			%>
					<div class="trigger" 
							onClick="showBranch('gene-branch<%=index%>');swapFolder('gene-folder<%=index%>')">
			  							<img src="images/closed.png" border="0" id="gene-folder<%=index%>">
					<% 	if (node.isSelected()) {%>
						<span class="attribute-type-bold"><%=node.getName()%></span>
					<% 	} else {%>
						<span class="attribute-type"><%=node.getName()%></span>
					<% 	}%>
						<span class="attribute-count"><%=node.getCount()%></span>
					</div>
					<%
						if (node.getChildList() != null) {
					%>
						<span class="branch" id="gene-branch<%=index%>" >
						<%
							int sub = 0;
										for (AttributeTreeNode child: node.getChildList()) {
											sub++;
						%>
							<span class="attribute-select"><input type="checkbox" 
								value="<%="" + index + "-" + sub%>" name="gene-checkbox" 
								<%=((child.isSelected())?"Checked":"")%>/></span>
							<span class="attribute-item"><%=child.getName()%></span>
							<span class="attribute-count"><%=child.getCount()%></span>
							<br />					
						<%
												}
											%>
						</span>
						<%
							}
								}
							}
						%>
			</div>
			<div class="attribute-listing-title">Interaction Attributes</div>
			<div class="attribute-listing" id="interaction-attribute-list">
			<%
				if ((geneQueryState.getIntrAttrTree() == null) || (geneQueryState.getIntrAttrTree().size() == 0)){
			%>
			<span class="attribute-listing-empty">none</span>
			<%
				} else {
					int index = 0;
					for (AttributeTreeNode node: geneQueryState.getIntrAttrTree()) {
						index++;
						ArrayList<AttributeTreeNode> childList = new ArrayList<AttributeTreeNode>();
						if (node.getChildList() != null) childList = node.getChildList();
						int size = childList.size();
			%>
					<div class="trigger" 
							onClick="showBranch('intr-branch<%=index%>');swapFolder('intr-folder<%=index%>')">
			  							<img src="images/closed.png" border="0" id="intr-folder<%=index%>">
					<% 	if (node.isSelected()) {%>
						<span class="attribute-type-bold"><%=node.getName()%></span>
					<% 	} else {%>
						<span class="attribute-type"><%=node.getName()%></span>
					<% 	}%>
						<span class="attribute-count"><%=node.getCount()%></span>
					</div>
					<%
						if (node.getChildList() != null) {
					%>
						<span class="branch" id="intr-branch<%=index%>" >
						<%
							int sub = 0;
										for (AttributeTreeNode child: node.getChildList()) {
											sub++;
						%>
							<span class="attribute-select"><input type="checkbox" 
								value="<%="" + index + "-" + sub%>" name="interest-checkbox" 
								<%=(child.isSelected()?"Checked":"")%>/></span>
							<span class="attribute-item"><%=child.getName()%></span>
							<span class="attribute-count"><%=child.getCount()%></span>
							<br />					
						<%
												}
											%>
						</span>
						<%
							}
								}
							}
						%>
			</div>
			</td>
			<td id="network-display-holder">
			<%
				String geneList = null;
				if (geneQueryState.getGenes() != null) {
					for (GeneCoverForSelection g: geneQueryState.getGenes()) {
						if (geneList == null) geneList = g.getSymbol();
						else geneList += "," + g.getSymbol();
					}
				}
				String iframeUrl = "http://biosearch2d.ncibi.org/conceptgen/Network/mimi.jsp?";
				iframeUrl += "taxid=9606&geneid=NA&symbol=";
				iframeUrl += geneList;
			%>
			See <a href="<%= iframeUrl %>" target="_blank" >this network</a> in a new window.<br />
			<iframe id="network-display-iframe" src="<%= iframeUrl %>" >
			</iframe>
			</td>
		</tr>
		<tr id="gene-list">
			<td colspan="2" id="mimi-gene-query-results">
			<hr/>	
			<h3 id="gene-table-title">Gene List Table</h3>
			<%
			if ((geneQueryState.getGenes() == null) || (geneQueryState.getGenes().size() == 0)) {
			%>
			<span id="gene-table-empty">no genes yet</span>
			<%
			} else {
			%>
			<span id="gene-table-header">
			Select <a href="<%= pageName %>" onclick="geneSelectAll()">all genes</a>; 
			select <a href="<%= pageName %>" onclick="geneSelectNone()">none</a>.
			</span>
			<%	
			}
			%>
				<span id="dt-replace-here"></span>
			</div>
			<!-- end  mimi-gene-query-results--></td>
		</tr>
	</tbody>
</table>
</form>
</div>
<!-- end mimi-wrapper div -->
<jsp:include page="mimiFooterInc.html" />
</body>
<%	
if (search != null) {
%>
<script type="text/javascript">
	updateSearch();
</script>
<%
}
logger.debug("done with page");
%>
</html>
