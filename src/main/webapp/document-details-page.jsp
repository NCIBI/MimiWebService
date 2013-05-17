<%@ taglib uri="http://displaytag.sf.net" prefix="display" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ include file="inc/header2.jsp" %>
<%@ page import="java.util.ArrayList,
    java.util.Set,
    java.util.Iterator,
    org.ncibi.lucene.MimiDocument,
    org.ncibi.db.pubmed.*,
    org.ncibi.mimiweb.hibernate.*, 
    org.ncibi.mimiweb.data.hibernate.*,
    org.ncibi.mimiweb.util.DocPageUtil, 
    org.ncibi.mimiweb.util.DocPageUtilGenePojo,
    org.ncibi.mimiweb.util.DocAuthorCollectiveCover,
    org.ncibi.mimiweb.util.TaxonomyCover" 
%>
<jsp:useBean id="docUtil" class="org.ncibi.mimiweb.util.DocPageUtil" scope="page"/>
<%
	String pubmedidString = (String) request.getParameter("pubmedid") ;
	String geneIdString = (String) request.getParameter("geneid");
	String interactionIdString = (String) request.getParameter("interactionid");

    if (pubmedidString == null) 
    {
%>
		<h3>No pubmed id given</h3>
		This page needs a pubmed id as a parameter, e.g. pubmedid=1334406.
<%
       	return;
    }

    int pubmedid = -1;
   	try {
   		pubmedid = Integer.parseInt(pubmedidString);
   	} catch (Throwable ignore) {}
	
	if (pubmedid == -1) 
	{
    %>
		<h3>Pubmed ID is not an integer = <%= pubmedidString %></h3>
		This page needs a pubmed id as a parameter, e.g. pubmedid=1334406.
	<%
	   	return;
	}        

	Integer geneid = null;
	if (geneIdString != null) {
	   	try {
	   		geneid = new Integer(Integer.parseInt(geneIdString));
	   	} catch (Throwable ignore) {}	
	}
	
   	Integer interactionid = null;
   	if (interactionIdString != null) {
	   	try {
	   		interactionid = new Integer(Integer.parseInt(interactionIdString));
	   	} catch (Throwable ignore) {}	   		
   	}

	HibernateInterface h = HibernateInterface.getInterface() ;
	Document doc = h.getFullDocumentDetails(pubmedid) ;

	String abstractText = docUtil.getAbstractAndSetPagePartsForDocument(doc);
	   	
   	ArrayList<DocPageUtilGenePojo> externalGeneList = docUtil.getUtilPojoForGenes(pubmedid);
   	ArrayList<DocPageUtilGenePojo> tagGeneList = docUtil.getUtilPojoForTags();

   	ArrayList<DocPageUtilGenePojo> geneList = new ArrayList<DocPageUtilGenePojo>();

   	for (DocPageUtilGenePojo gene: externalGeneList) {
   		geneList.add(gene);
   	}
   	for (DocPageUtilGenePojo gene: tagGeneList) {
   		geneList.add(gene);	
   	}

   	DocPageUtilGenePojo highlightGene = null;
   	DenormInteraction highlightInteraction = null;

   	if (geneid != null) {
   		// Note: gene.isHighlight() == true will set the id of the row to 'doc-detail-gene-table-highlight'
   		// see: org.ncibi.mimiweb.decorator.DocDetailGeneTableDecorator
   		for (DocPageUtilGenePojo gene: geneList) {
   			if (gene.getId() == geneid.intValue()){
   				gene.setHighlight(true);
   				highlightGene = gene;
   			}
   			else
   				gene.setHighlight(false);
   		}
   	}

   	if (interactionid != null) {
   		// Note: gene.isHighlight() == true will set the id of the row to 'doc-detail-gene-table-highlight'
   		// see: org.ncibi.mimiweb.decorator.DocDetailGeneTableDecorator
   		highlightInteraction = docUtil.getBasicInteractionDetails(interactionid) ;
   		for (DocPageUtilGenePojo gene: geneList) {
   			gene.setHighlight(false);
   			if (gene.getId() == highlightInteraction.getGeneid1())
   				gene.setHighlight(true);
   			if (gene.getId() == highlightInteraction.getGeneid2())
   				gene.setHighlight(true);
   		}
   	}
        
	request.setAttribute("citation", doc.getCitations()) ;

	%>
<h2><img src="images/Annotated_article.jpg" alt="Annotated Article Abstract" /></h2>
<%
	if (highlightGene != null){
%>
	<h3>Gene of interest: <%= highlightGene.getSymbol() %></h3>
<%
	}
	if (highlightInteraction != null){
		// if both geneids are the same
		if (highlightInteraction.getGeneid1() == highlightInteraction.getGeneid2()){
%>
			<h3>Self-related gene of interest: <%= highlightInteraction.getSymbol1() %> </h3>
<%
			
		} else {
%>
			<h3>Related genes of interest: <%= highlightInteraction.getSymbol1() %> and <%= highlightInteraction.getSymbol2() %> </h3>
<%
		}
	}
%>
<display:table export="true" name="citation" class="displaytag" id="dtable" requestURI="replaceURI">
    <display:column property="pmid" title="Pubmed Id" decorator="org.ncibi.mimiweb.decorator.PubmedColumnDecorator"/>
    <display:setProperty name="export.csv.filename" value="abstracts.csv"/>
    <display:setProperty name="export.xml.filename" value="abstracts.xml"/>
    <display:setProperty name="export.excel.filename" value="abstracts.xls"/>
    <display:column property="authorList" title="Author(s)"/>
    <display:column property="title" title="Title"/>
	<display:column property="nlmTa" title="Publication" /> 
    <display:column property="volume" title="Volume"/>
    <display:column property="issue" title="Issue"/>
    <display:column property="pages" title="Pages"/>
    <display:column property="date" title="Date"/>
</display:table>

<hr/>
<%
	String noAbstract = "No Abstract in the database. See " +
	DocPageUtil.getPubmedRefUrlText(doc.getPmid()) + " for additional information.</p>";
	String header = "Annotated Abstract (showing tagged text)";
	
	if (abstractText.length() == 0) {
		abstractText = noAbstract;
		header = "No Abstract";
	}

	ArrayList<NamedEntityTag> geneTags = docUtil.getGeneTags();

	if (geneTags.size() == 0) {
		header = "Abstract";
	}	
%>
<h3><%= header %></h3>
<%= abstractText %>

<%
request.setAttribute("geneinfo", geneList) ;

%>
<h3>Genes associated with this article (either through tagging or through merging of external sources *)</h3>
<%
	if (highlightGene != null){
%>
		<span class="doc-detail-highlight-note">... with the gene of interest, <%= highlightGene.getSymbol() %>, 
			<span id="doc-detail-gene-table-highlight">highlighted</span>.</span>
<%
	}
	if (highlightInteraction != null){
		// if both geneids are the same
		if (highlightInteraction.getGeneid1() == highlightInteraction.getGeneid2()){
%>
		<span class="doc-detail-highlight-note">... with the self related gene of interest, 
			<%= highlightInteraction.getSymbol1() %>, 
			<span id="doc-detail-gene-table-highlight">highlighted</span>.</span>
<%
			
		} else {
%>
		<span class="doc-detail-highlight-note">... with the related genes of interest, 
			<%= highlightInteraction.getSymbol1() %> and <%= highlightInteraction.getSymbol2() %>, 
			<span id="doc-detail-gene-table-highlight">highlighted</span>.</span>
<%
		}
	}
%>
    <display:table export="true" name="geneinfo" class="displaytag" id="gtable" pagesize="20" requestURI="replaceURI" decorator="org.ncibi.mimiweb.decorator.DocDetailGeneTableDecorator" >
		<display:setProperty name="basic.msg.empty_list" value="No genes for this document were found in the database." />
        <display:setProperty name="export.csv.filename" value="genesforarticle.csv"/>
        <display:setProperty name="export.xml.filename" value="genesforarticle.xml"/>
        <display:setProperty name="export.excel.filename" value="genesforarticle.xls"/>
		<display:setProperty name="paging.banner.item_name" value="gene" />
		<display:setProperty name="paging.banner.items_name" value="genes" />
        <display:column property="symbol" title="Gene" sortable="true" headerClass="sortable" sortName="symbol" href="gene-details-page-front.jsp" paramId="geneid" paramProperty="id"/>
        <display:column property="taxScientificName" title="Organism" sortable="true" headerClass="sortable" sortName="scientificTaxName"/>
        <display:column property="geneType" title="Type" sortable="true" headerClass="sortable" sortName="geneType"/>
        <display:column property="moleculeNamesString" title="Other Names"/>
        <display:column property="description" title="Description"/>
        <display:column property="cellularComponents" title="Cellular Components" />
        <display:column property="biologicalProcesses" title="Biological Processes" />
        <display:column property="molecularFunctions" title="Molecular Functions" />
        <display:column property="interactionCount" title="Int" sortable="true" headerClass="sortable" sortProperty="interactionCount"/>
        <display:column property="pubCount" title="Doc" sortable="true" headerClass="sortable" sortProperty="pubCount"/>
        <display:column property="pathwayCount" title="Path" sortable="true" headerClass="sortable" sortProperty="pathwayCount"/>
        <display:column property="tagged" title="From *" />
        <display:column property="tagText" title="Tag" />
    </display:table>

<hr />
<div id="doc-detail-note">
* Gene's are associated with the PubMed Abstracts from two sources. 
When we merge gene data to form the MiMI database, we also merge any
association of PubMed ID with the gene. Hence the merged information
contains the association of a PubMed ID with an Entrez Gene ID.
In addition, we also apply a tagging process to the text of the abstract
of the article, when we can obtain that abstract. This tagging process attempts to
discover the potential association of a gene to the content of the abstract, by locating
the gene's name or synonym in the text of the abstract. Those tags so discovered are shown above.
See 'About MiMI' for information on the merge process.
</div>
