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

	ArrayList<MimiDocument>	externalGeneList = docUtil.getMimiDocsForDocument(pubmedid);

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
<h3><%= header %></h3>
<%= abstractText %>

<%
String geneDetailUrl = "gene-details-page-front.jsp?geneid=";

if (externalGeneList.size() != 0)
{
%>
<h3>Genes associated with this article from the merged sources *</h3>
<ul>
<%
for (MimiDocument gene: externalGeneList) {
	String url = geneDetailUrl + gene.geneid;
%>
	<li><a href="<%= url %>" ><%= gene.geneSymbol %></a> of <%= gene.sciTaxName %></li>
<%
}
%>
</ul>
<%
} else {
%>
<p><i>No associated genes *</i></p>
<%
}

if (geneTags.size() != 0)
{
%>
	<h3>Genes tagged via NLP processing *</h3>
	<ul>
<%
	for (Iterator<NamedEntityTag> i = geneTags.iterator(); i.hasNext();)
	{
		NamedEntityTag tag = (NamedEntityTag) i.next();
		String geneSymbol = tag.getGeneSymbol();
		String taxName = tag.getTaxName();

		boolean highlight = false;
		String linkLine, tagLine;
		if ((geneSymbol == null) || (taxName == null)) {
			linkLine = "tag is <span class=\"doc-detail-text-highlight\" id=\"doc-detail-text-highlight\" >" + tag.getActualString() + "</span>;";
			tagLine = "tagged but not yet in database";
		}
		else {
			int tagGeneId = tag.getGeneId().intValue();
			highlight = ((geneid != null) && (tagGeneId == geneid.intValue()));
			String url =  geneDetailUrl + tag.getGeneId().toString();
			linkLine = "<a href=\"" + url + "\">" + geneSymbol + "</a> ";
			tagLine = "of " + taxName + " - tag: " + 
				"<span class=\"doc-detail-text-highlight\" id=\"doc-detail-text-highlight\" >" + tag.getActualString() + "</span>";
		}
		if (highlight) {
%>				
			<li><span class="doc-detail-highlight"><%= linkLine %> <%= tagLine %></span></li>
<%
		} else {
%>				
			<li><%= linkLine %> <%= tagLine %> </li>
<%
		}
	}
%>
	</ul>
<%
}
else {
%>
<p><i>No tagged genes *<i></p>
<%
}
// if (meshTags.size() == 0)
// html += "<p><b>No MeSH Tags.</b></p>" + EOL;
// else {
// html += "<h4>MeSH Tags</h4>" + EOL + "<p>" + EOL + "<ul>" + EOL;
// for (NamedEntityTag tag: sortTagsAlphabetical(meshTags)){
// html += "<li>" + tag.getActualString() + "</li>" + EOL;
// }
// html += "</ul" + EOL + "</p>" + EOL;
// }
%>
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
