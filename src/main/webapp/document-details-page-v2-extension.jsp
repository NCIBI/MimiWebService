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

	Integer geneid = null;
   	try {
   		geneid = new Integer(Integer.parseInt(geneIdString));
   	} catch (Throwable ignore) {}	
	
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
        
	HibernateInterface h = HibernateInterface.getInterface() ;
	Document doc = h.getFullDocumentDetails(pubmedid) ;
	ArrayList<Integer> pm = new ArrayList<Integer>() ;
	pm.add(pubmedid) ;
	ArrayList<DocumentBriefSimple> docbrief = h.getDocumentDetailsForPubmedList(pm) ;
	
	if ((docbrief == null) || (docbrief.size() < 1))
	{
    %>
		<h3>No document record for pmid = <%= pubmedid %></h3>
	<%
	   	return;
	}        
	
	DocumentBriefSimple dbrief = docbrief.get(0) ;

	request.setAttribute("dinfo", dbrief) ;

	%>
<h2><img src="images/Annotated_article.jpg" alt="Annotated Article Abstract" /></h2>
<display:table export="true" name="dinfo" class="displaytag" id="dtable" requestURI="replaceURI">
    <display:column property="id" title="Pubmed Id" decorator="org.ncibi.mimiweb.decorator.PubmedColumnDecorator"/>
    <display:setProperty name="export.csv.filename" value="abstracts.csv"/>
    <display:setProperty name="export.xml.filename" value="abstracts.xml"/>
    <display:setProperty name="export.excel.filename" value="abstracts.xls"/>
    <display:column property="year" title="Year"/>
    <display:column property="authors" title="Author(s)"/>
    <display:column property="title" title="Title"/>
    <display:column property="citation" title="Full Citation"/>
</display:table>

<hr/>
<%
	String abstractText = docUtil.getAbstractAndSetPagePartsForDocument(doc);
	
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
ArrayList<DocPageUtilGenePojo> externalGeneList = docUtil.getUtilPojoForGenes(pubmedid);
ArrayList<DocPageUtilGenePojo> tagGeneList = docUtil.getUtilPojoForTags();

ArrayList<DocPageUtilGenePojo> geneList = new ArrayList<DocPageUtilGenePojo>();

for (DocPageUtilGenePojo gene: externalGeneList) {
	geneList.add(gene);
}
for (DocPageUtilGenePojo gene: tagGeneList) {
	geneList.add(gene);	
}

request.setAttribute("geneinfo", geneList) ;

%>
<h3>Genes associated with this article (either through tagging or through merging of external sources *)</h3>
    <display:table export="true" name="geneinfo" class="displaytag" id="geneinfo1" pagesize="20" requestURI="replaceURI" decorator="org.ncibi.mimiweb.decorator.DocDetailGeneTableDecorator" >
		<display:setProperty name="basic.msg.empty_list" value="No genes for this document were found in the database." />
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
