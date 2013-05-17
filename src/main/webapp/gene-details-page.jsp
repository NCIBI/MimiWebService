<%@ taglib uri="http://displaytag.sf.net" prefix="display" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ include file="inc/header2.jsp" %>
<%@ page import="java.util.ArrayList, org.ncibi.mimiweb.data.*, 
    java.util.List,
    org.ncibi.db.pubmed.gin.ClassifiedInteraction,
    org.ncibi.mimiweb.lucene.*, 
    org.ncibi.mimiweb.data.*, 
    org.ncibi.mimiweb.hibernate.*,
    org.ncibi.mimiweb.data.hibernate.*,
	org.ncibi.mimiweb.decorator.DocListDataWrapper,
    org.ncibi.mimiweb.decorator.RxnTxtColumnDecorator,
    org.ncibi.mimiweb.decorator.InteractionPublicationCountColumnDecorator,
    org.ncibi.mimiweb.util.GoUtils,
    org.ncibi.mimiweb.util.PsiDownload,
    org.ncibi.mimiweb.util.PropertiesUtil,
    org.ncibi.mimiweb.util.GeneLinkoutUtil" 
%>

<%
    String geneid = (String) request.getParameter("geneid") ;
    int igeneid = Integer.parseInt(geneid) ;
	String overflowString = (String) request.getParameter("overflow") ;

	boolean displayOverflow = (overflowString != null);
	String overflowURL = "gene-details-page-front.jsp?geneid=" + geneid + "&overflow=yes";
	String overflowHTML = "...see <a href=\"" + overflowURL + "\">full list</a>"; 
	// max list lengths, and max length for other names
	int maxLengthOtherNames = 11;
	int maxLengthAttributes = 25;
	int maxLengthOtherDescriptions = 10;
	int maxStringLengthOtherNames = 40;
	boolean overflow; // reused for each situaiton
	int count, length;// reused for each situaiton
	
    LuceneInterface l = LuceneInterface.getInterface() ;
    HibernateInterface h = HibernateInterface.getInterface() ;
    ResultGeneMolecule g = l.getGeneData(igeneid) ;
    g = h.extendSingleGene(g) ;
    String uri = request.getRequestURI();
    int pos = uri.indexOf("/",1);
    String webappName = uri.substring(1,pos);

    String meshUrl = GeneLinkoutUtil.getGene2MeshBaseUrl() 
        + "?view=simple&qtype=gene&term=" + g.getSymbol()
        + "&taxid=" + g.getTaxid() ;
    String cytoUrl = GeneLinkoutUtil.getCytoscapeLauncherUrl()
        + "/launcher?queryMiMIById=" + g.getId() ;
    String netbrowserUrl = GeneLinkoutUtil.getNetbrowserLinkout(g) ;
    String ginUrl = "http://gene2mesh-t.ncibi.org/GIN/viewMolecule.php?gene="+g.getSymbol() ;
    String misearchUrl = "http://misearch.ncibi.org?query=" + g.getSymbol() + "&user=mimiweb_" ;
	ArrayList geneInteractionsList = new GeneInteractionList(g.getId());

    PubmedDBQueryInterface pubmedInterface = PubmedDBQueryInterface.getInterface();
    List<ClassifiedInteraction> ciList = pubmedInterface.getNlpInteractionsForGeneId(igeneid);
    int nlpInteractionCount = ciList.size();

    ArrayList<DocumentBriefSimple> docs = h.getDocumentsForGeneId(g.getId()) ;
    request.setAttribute("geneinfo", g) ;

    out.print(PsiDownload.getAnchorTag(webappName, igeneid));
%>
<h2><img src="images/Gene_details.jpg" alt="Gene Details" /></h2>
<h3><a href="javascript:toggleBox('gd')"><img src="images/gene_icon.jpg" alt="Molecule Details for Gene Entry <%=g.getSymbol()%>"/></a>Molecule Details for Gene Entry <%=g.getSymbol()%> (GeneId: <%=g.getId()%>) - <a href="javascript:toggleBox('gd')">show/hide</a></h3>
<hr/>
<div class="hiddenelement" id="gd" style="visibility: visible; display: block;">
<table class="gene-detail-top-table"><tr class="gene-detail-top-table-tr"><td class="gene-detail-top-table-td">
<h3><%=g.getAuthorizedDescription().trim()%> </h3>
<h3><%= g.getSymbol()%>(<%= g.getTaxScientificName() %>)</h3>
<ul>
	<li><b>Gene Type</b>: <%= g.getGeneType() %></li>
<%		
		String url =  "http://www.ncbi.nlm.nih.gov/projects/mapview/maps.cgi?"
			+ "taxid=" + g.getTaxid()
			+ "&chr=" + g.getChromosome();
%>
	<li><b>Chromosome</b>: <a href="<%= url %>"><%= g.getChromosome() %></a></li>
<%		
		url = "http://www.ncbi.nlm.nih.gov/sites/entrez?"
		+ "db=gene&cmd=search&term=" + g.getMapLocus();
%>
	<li><b>Map Locus</b>: <a href="<%= url %>"><%= g.getMapLocus() == null ? "" : g.getMapLocus() %></a></li>
	<li><b>Locus Tag</b>: <%= g.getLocusTag() == null ? "" : g.getLocusTag() %></li>
</ul>
<h4>Other Names...</h4>
<ul>
<%
	length = g.getMoleculeNames().length;
	overflow = (length > maxLengthOtherNames) && !displayOverflow;
	if (overflow) length = (maxLengthOtherNames - 1); // make room for the link
	count = 0;
	for(String name: g.getMoleculeNames()) {
		if (count++ > length) break;
		if ((name.length() > maxStringLengthOtherNames) && !displayOverflow)
		{	
			name = name.substring(0,maxStringLengthOtherNames-3) + "...";
			if (!overflow) {
				overflow = true;
				length = length - 1;
				if (count > length) break;
			}
		}
%>
		<li><%= name %></li>
<%	
	}
	if (overflow){
%>
		<li><%= overflowHTML %></li>
<%	}
%>
</ul>
<h4>Descriptions...</h4>
<ul>
<%
	boolean authorized = true;
	String mainDescription = g.getAuthorizedDescription().trim();
	if (g.getAuthorizedDescription().equals("None")) {
		authorized = false;
		mainDescription = g.getDescription();
	}
%>
	<li><b><%= (authorized)?"Authorized ":"" %>Gene Description</b>: <%= mainDescription %></li>
	<li><b>Other descriptions...</b>
		<ul>
<%			
			count = 0;
			if (!mainDescription.equals(g.getDescription().trim())) {
				count++;
%>
				<li><%= g.getDescription() %></li>
<%				
			}

			length = g.getOtherDescription().split("\\|").length + count;
			overflow = (length > maxLengthOtherDescriptions) && !displayOverflow;
			if (overflow) length = (maxLengthOtherDescriptions - 1 - count); // make room for the link
			for (String desc: g.getOtherDescription().split("\\|")) {
				if (count++ > length) break;
%>
				<li><%= desc %></li>
<%			} 
			if (overflow)
			{
%>
				<li><%= overflowHTML %></li>
<%
			}
%>
		</ul>
	</li>
</ul>
</td><td class="gene-detail-top-table-td">
<table class="gene-detail-goterm-table">
<tr class="gene-detail-goterm-table-first-row-tr">
<td colspan="3" class="gene-detail-goterm-table-first-row-td">
<h4>Gene Attributes</h4>
</td></tr>
<tr class="gene-detail-goterm-table-tr"><td class="gene-detail-goterm-table-td">
	<b>Cellular Components...</b><br />
<%
		length = g.getCellularComponents().size();
		overflow = (length > maxLengthAttributes) && !displayOverflow;
		if (overflow) length = (maxLengthAttributes - 1); // make room for the link
		count = 0;
		for (String term: g.getCellularComponents()) {
		if (count++ > length) break;
%>
			<%= GoUtils.constructGoTerm(term) %><br />
<%
		}
		if (overflow)
		{
%>
			<%= overflowHTML %><br />
<%
		}
%>
</td><td class="gene-detail-goterm-table-td">
	<b>Biological Processes...</b><br />
<%
		length = g.getBiologicalProcesses().size();
		overflow = (length > maxLengthAttributes) && !displayOverflow;
		if (overflow) length = (maxLengthAttributes - 1); // make room for the link
		count = 0;
		for (String term: g.getBiologicalProcesses()) {
			if (count++ > length) break;
%>
			<%= GoUtils.constructGoTerm(term) %><br />
<%
		}
		if (overflow)
		{
%>
			<%= overflowHTML %><br />
<%
		}
%>
</td><td class="gene-detail-goterm-table-td">
	<b>Molecular Functions...</b><br />
<%
		length = g.getMolecularFunctions().size();
		overflow = (length > maxLengthAttributes) && !displayOverflow;
		if (overflow) length = (maxLengthAttributes - 1); // make room for the link
		count = 0;
		for (String term: g.getMolecularFunctions()) {
			if (count++ > length) break;
%>
			<%= GoUtils.constructGoTerm(term) %><br />
<%
		}
		if (overflow)
		{
%>
			<%= overflowHTML %><br />
<%
		}
%>
</td></tr></table>
</td></tr></table>
</div> <!-- hiddenelement div -->
<h3><a href="javascript:toggleBox('2')"><img src="images/Protein2_icon.jpg" alt="Protein Interactions for Gene <%=g.getSymbol()%>"/></a>
<a name="interactionspiece">Protein Interactions</a> (<%=g.getInteractionCount()%> gene interactions found) - <a href="javascript:toggleBox('2')">show/hide</a></h3>
<hr/>
<div class="hiddenelement" id="2" style="visibility: hidden; display: none;"> 
<%
	if (geneInteractionsList.size() == 0) 
    {
%>
	<p>No Interactions in Gene Record.</p>
<%
	} 
    else 
    {
        request.setAttribute("interactions", geneInteractionsList) ;
%>
	<span class="gene-detail-veiw-all-interactions">View 
		<a href="document-list-page-front.jsp?geneid=<%= geneid %>&unioninteractions=yes">documents</a> for all interactions with <%=g.getSymbol()%>. 
		To see document for an individual interaction click in the 'Lit. count' column.
    </span>

    <display:table export="true" name="interactions" pagesize="50" class="displaytag" id="interactionspage" requestURI="replaceURI">
		<display:setProperty name="basic.msg.empty_list" value="No Interactions were found in the database." />
        <display:setProperty name="export.csv.filename" value="interactions.csv"/>
        <display:setProperty name="export.xml.filename" value="interactions.xml"/>
        <display:setProperty name="export.excel.filename" value="interactions.xls"/>
		<display:setProperty name="paging.banner.item_name" value="interaction" />
		<display:setProperty name="paging.banner.items_name" value="interactions" />
        <display:column property="symbol1" title="Gene1" sortable="true" headerClass="sortable" sortName="symbol1"/>
        <display:column property="symbol2" title="Gene2" sortable="true" headerClass="sortable" sortName="symbol2" href="gene-details-page-front.jsp" paramId="geneid" paramProperty="geneid2"/>
        <display:column property="provenanceDatabaseLinksString" title="Source Provenance" />
        <display:column property="thisObject" title="Lit. Count" 
        	decorator="org.ncibi.mimiweb.decorator.InteractionPublicationCountColumnDecorator" />  
        <display:column property="interactionTypesStr" title="Interaction Info"/>
        <display:column property="experimentsStr" title="Experiments"/>
<%
    String r = PropertiesUtil.getProperty("reactome") ;
    if (r != null && r.equals("on"))
    {
%>
        <display:column title="Pathways" href="interaction-pathways-page-front.jsp" paramId="interactionid" paramProperty="ggIntID">See Pathways</display:column>
<%
    }
%>

    </display:table>

</div> <!-- hiddenelement div -->
<h3><a href="javascript:toggleBox('nlp')"><img src="images/GIN_logo_small.jpg" alt="NLP Derived Protein Interactions for Gene <%=g.getSymbol()%>"/></a>
	<a>Literature Mined Interactions (<%=nlpInteractionCount%> Interactions found) - <a href="javascript:toggleBox('nlp')">show/hide</a></h3>
<hr/>
<div class="hiddenelement" id="nlp" style="visibility: hidden; display: none;"> 
<%
	}

    if (ciList.size() != 0)
    {
        request.setAttribute("nlpinteractions", ciList) ;
%>
    <h3>Text Mined Interactions</h3>
    <display:table export="true" name="nlpinteractions" pagesize="20" class="displaytag"
            id="nlpinteractions" requestURI="replaceURI">
        <display:setProperty name="export.csv.filename" value="nlp_derived_interactions.csv"/>
        <display:setProperty name="export.xml.filename" value="nlp_derived_interactions.xml"/>
        <display:setProperty name="export.excel.filename" value="nlp_derived_interactions.xls"/>
        <display:setProperty name="basic.msg.empty_list" value="No NLP interactions were found."/>
		<display:setProperty name="paging.banner.item_name" value="nlp interaction" />
		<display:setProperty name="paging.banner.items_name" value="nlp interactions" />
        <display:column property="tag1" title="Gene1" sortable="true" headerClass="sortable" 
            sortName="tag1"/>
        <display:column property="tag2" title="Gene2" sortable="true" headerClass="sortable" 
            sortName="tag2" href="gene-details-page-front.jsp" paramId="geneid" 
            paramProperty="geneID2"/>
        <display:column property="taxid" title="Taxid" sortable="true" headerClass="sortable"
            sortName="taxid"/>
        <display:column property="type" title="Interaction Type"/>
        <display:column property="sentence" title="Sentence"/>
        <display:column property="pmid" title="Pubmed Id" headerClass="sortable" 
            sortName="pmid" decorator="org.ncibi.mimiweb.decorator.PubmedColumnDecorator"/>
        <display:column property="self" title="See Mined Text"
            decorator="org.ncibi.mimiweb.decorator.ClassifiedInteractionMinedTextDecorator"/>
    </display:table>

<%
    }
    else
    {
%>
	<p>No NLP derived interactions were found for Gene <%=g.getSymbol()%></p>
<%        
    }
%>
<hr/>
</div> <!-- hiddenelement div -->
<h3><a href="javascript:toggleBox('3')"><img src="images/Literature_icon01.jpg" alt="Literature on Gene <%=g.getSymbol()%>"/></a>
	<a name="genelit">Literature on gene <%=g.getSymbol()%></a> (<%=g.getPubCount()%> publications found) - <a href="javascript:toggleBox('3')">show/hide</a> </h3> 
<hr />
<div class="hiddenelement" id="3" style="visibility: hidden; display: none;">
    <%
        if (docs == null)
        {
    %>
    <p>No related documents</p>
    <%
        }
        else
        {
        	ArrayList<DocListDataWrapper> wrapperList = new ArrayList<DocListDataWrapper>();
	        for (DocumentBriefSimple doc: docs) {
	        	wrapperList.add(new DocListDataWrapper(DocListDataWrapper.GENE,geneid,doc,"view"));
	        }
            request.setAttribute("genedocs", wrapperList) ;
    %>
    <display:table export="true" name="genedocs" pagesize="50" class="displaytag" id="docstable" requestURI="replaceURI">
		<display:setProperty name="basic.msg.empty_list" value="No Documents were found in the database." />
        <display:setProperty name="export.csv.filename" value="gene_abstracts.csv"/>
        <display:setProperty name="export.xml.filename" value="gene_abstracts.xml"/>
        <display:setProperty name="export.excel.filename" value="gene_abstracts.xls"/>
		<display:setProperty name="paging.banner.item_name" value="document" />
		<display:setProperty name="paging.banner.items_name" value="documents" />
        <display:column property="id" title="Pubmed Id" headerClass="sortable" sortName="pubmedId" decorator="org.ncibi.mimiweb.decorator.PubmedColumnDecorator"/>
	    <display:column property="itself" title="See Mined Text" 
    		decorator="org.ncibi.mimiweb.decorator.DocListTableLinkColumnDecorator" />
	    <display:column property="year" title="Year" />
        <display:column property="citation" title="Citation"/>
        <display:column property="title" title="Title"/>
        <display:column property="authors" title="Author(s)"/>
    </display:table>
    <p><a href="http://scholar.google.com/scholar?q=<%=g.getSymbol()%>&scoring=r">Search Google Scholar</a> for recent articles on gene <%=g.getSymbol()%></p>
<%
        }
%>
<hr/>
</div> <!-- hiddenelement div -->
<h3><a href="javascript:toggleBox('4')"><img src="images/Pathway_icon.jpg" alt="Pathways for Gene <%=g.getSymbol()%>"/></a>
	<a name="pathways">Pathways</a> (<%=g.getParticipatingPathways().size()%> pathways found) - <a href="javascript:toggleBox('4')">show/hide</a></h3> 
<hr /> 
<div class="hiddenelement" id="4" style="visibility: hidden; display: none;">
<%
	if (g.getParticipatingPathways().size() == 0) 
    {
%>
	<p>No Pathways in Gene Record.</p>
<%
	} 
    else 
    {
        request.setAttribute("pathways", g.getParticipatingPathways()) ;
%>
    <display:table name="pathways" class="displaytag" id="pathwaystable" pagesize="20" requestURI="replaceURI" 
    		decorator="org.ncibi.mimiweb.decorator.GenePathwaysDecorator">
		<display:setProperty name="basic.msg.empty_list" value="No Pathways were found in the database." />
		<display:setProperty name="paging.banner.item_name" value="pathway" />
		<display:setProperty name="paging.banner.items_name" value="pathways" />
        <display:column property="pathname" title="Pathway" decorator="org.ncibi.mimiweb.decorator.PathwayNameColumnDecorator"/>
        <display:column property="description" title="Description"/>
        <display:column title="Genes Related to Pathway" property="id"/>
    </display:table>
<%
	}
%>

<hr/>
</div> <!-- hiddenelement div --> 

<!-- Metabolomics Additions -->

<%
    String metab = PropertiesUtil.getProperty("metabolomics") ;
	HumDBQueryInterface humdb = HumDBQueryInterface.getInterface() ;
	if (metab.equals("on"))
	{	    
    	if (metab != null)
    	{    	
        	List<Compound> compounds = humdb.getCompoundsForGeneid(igeneid) ;
        	request.setAttribute("compounds", compounds) ;
%>
    <h3><img src="images/Compound01.png" alt="Compounds"/>Compounds associated with Gene (<%=compounds.size()%> compounds found) - <a href="javascript:toggleBox('cmpd')">show/hide</a></h3>
    <hr/>
<div class="hiddenelement" id="cmpd" style="visibility: hidden; display:none;">

    <display:table name="compounds" class="displaytag" id="compoundstable" requestURI="replaceURI">
		<display:setProperty name="basic.msg.empty_list" value="No compounds for this gene were found in the database." />
		<display:setProperty name="paging.banner.item_name" value="compound" />
		<display:setProperty name="paging.banner.items_name" value="compounds" />
        <display:column property="cid" sortable="true" title="Id"
            href="compound-details-page-front.jsp" paramId="cid" paramProperty="cid" />
        <display:column property="name" sortable="true" title="Name"/>
        <display:column property="mf" title="MF"/>
        <display:column property="molecularWeight" sortable="true" title="Mol. Weight"/>
        <display:column property="casnum" sortable="true" title="CASNUM"/>
        <display:column property="smile" title="Smile"/>
    </display:table>
    <hr/>
</div> <!-- hiddenelement div -->
<%
    	}
    	else
    	{
%>
			<p>No Compounds associated with Gene.</p>
<%
    	}
    	
    	Enzyme e = humdb.getEnzymeForGeneId(igeneid) ;	
        if (e != null)
        {
            request.setAttribute("reactions", e.getReactions()) ;
%>
    <h3> <img src="images/Enzyme01.png" alt="Enzyme Reactions"/>Enzyme Reactions (<%=e.getReactions().size()%> reactions found) - <a href="javascript:toggleBox('rxn')">show/hide</a></h3>
    <hr/>
<div class="hiddenelement" id="rxn" style="visibility: hidden; display:none;">
    <p><b>Enzyme Name:</b> <%=e.getName()%></p>
    <p><b>EC Number:</b> <%=e.getEc()%></p>

    <display:table name="reactions" class="displaytag" id="reactionstable" requestURI="replaceURI">
        <display:setProperty name="basic.msg.empty_list" value="No reactions for this gene were found."/>
		<display:setProperty name="paging.banner.item_name" value="reaction" />
		<display:setProperty name="paging.banner.items_name" value="reactions" />
        <display:column property="rid" sortable="true" title="Id"
            href="reaction-details-page-front.jsp" paramId="rid" paramProperty="rid"/>
        <display:column property="description" title="Description"/>
        <display:column property="reversible" title="Reversible?"/>
        <display:column property="ridrxntxt" title="Equation" 
            decorator="org.ncibi.mimiweb.decorator.RxnTxtColumnDecorator"/>
    </display:table>
</div> <!-- hiddenelement div -->
<%
        }
        else
        {
%>
			<p>No Reactions for Enzyme (Gene) were found.</p>
<%           
        }
    }
%>

<!-- End Metabolomics Additions -->


<div id="tool-buttons" style="text-align: center">
View <%=g.getSymbol()%> With Other NCIBI Tools
	<ul>
		<li>            
			<a href="<%=meshUrl%>" title="View MeSH terms related to <%=g.getSymbol()%>"><img src="images/Gene2MeSH_button.jpg" alt="Gene2Mesh"/></a>
        	<a href="javascript:toggleBox('g2m')" title="Gene2MeSH Info"><img src="images/help_icon.jpg" alt="Gene2MeSH Info"/></a>
		</li>
		<li>
	        <a href="<%=cytoUrl%>" title="View interactions for <%=g.getSymbol()%> in Cytoscape"><img src="images/Cytoscape_button.jpg" alt="Cytoscape"/></a>
            <a href="javascript:toggleBox('cyto')" title="Cytoscape Info"><img src="images/help_icon.jpg" alt="Cytoscape Info"/></a>
		</li>
		<li>
		    <a href="<%=misearchUrl%>" title="Perform Adaptive Pubmed Search"><img src="images/MiSearch_button.jpg" alt="MiSearch"/></a>
            <a href="javascript:toggleBox('mis')" title="MiSearch Info"><img src="images/help_icon.jpg" alt="MiSearch Info"/></a>
		</li>
	</ul>
</div><!-- End tool-buttons div -->
<br>
<div class="hiddenelement" id="g2m" style="visibility: hidden; display: none;">
<h3>Gene2MeSH</h3>
<p>When you click on the Gene2MeSH button you can view MeSH terms related to the gene you have selected with the NCIBI Gene2MeSH tool.</p>
<a href="javascript:toggleBox('g2m')">close</a> <br />
</div> 

<div class="hiddenelement" id="cyto" style="visibility: hidden; display: none;">
<h3>Cytoscape</h3>
<p>When you click on the Cytoscape button you can view interactions for your selected gene with Cytoscape.</p>
<a href="javascript:toggleBox('cyto')">close</a> <br /><br />
</div> 

<div class="hiddenelement" id="mis" style="visibility: hidden; display: none;">
<h3>MiSearch</h3>
<p>When you click on the MiSearch button you can perform an adaptive PubMed search on your selected gene. 
<a href="javascript:toggleBox('mis')">close</a> <br /><br />
</div> 
