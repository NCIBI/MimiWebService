<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<%@ taglib uri="http://displaytag.sf.net" prefix="display" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ include file="inc/header2.jsp" %>
<%@ page import="java.util.ArrayList, 
        java.util.List,
    	org.ncibi.mimiweb.data.*,
        org.ncibi.mimiweb.data.hibernate.*,
        org.ncibi.mimiweb.decorator.DocListDataWrapper,
        org.ncibi.mimiweb.hibernate.HibernateInterface,
        org.ncibi.mimiweb.lucene.LuceneInterface"
%>
<jsp:useBean id="docUtil" class="org.ncibi.mimiweb.util.DocPageUtil" scope="page"/>
<%
	int pageSize = 25;
	String pageSizeString = (String) request.getParameter("pageSize") ;
	if (pageSizeString != null) {
		try {
	pageSize = Integer.parseInt(pageSizeString);
		} catch (Throwable ignore) {}
	}
	
    String geneName = "" ;
    String taxName = "" ;
    String gene1 = "" ;
    String gene2 = "" ;

	String geneId = (String) request.getParameter("geneid") ;
    String interactionId = (String) request.getParameter("interactionid") ;
    String unionInteractions = (String) request.getParameter("unioninteractions");
    
    String linkText = "See Text";

    ArrayList<DocListDataWrapper> wrapperList = new ArrayList<DocListDataWrapper>();

    if (geneId != null)
    {
	    int id = Integer.parseInt(geneId);

	    LuceneInterface l = LuceneInterface.getInterface();
	    ResultGeneMolecule gene = l.getGeneData(id);
	    geneName = gene.getSymbol();
	    taxName = gene.getTaxScientificName();
	    if (unionInteractions == null) {
	    	ArrayList<DocumentBriefSimple> dlist = docUtil.getDocumentsForGeneId(id) ;
	        for (DocumentBriefSimple doc: dlist) {
	        	wrapperList.add(new DocListDataWrapper(DocListDataWrapper.GENE,id,doc,linkText));
	        }
	    } else {
	    	ArrayList<DocumentBriefSimple> dlist = docUtil.getDocumentsForGeneInteractions(gene);
	        for (DocumentBriefSimple doc: dlist) {
	        	wrapperList.add(new DocListDataWrapper(DocListDataWrapper.GENE_INTERACTION,id,doc,linkText));
	        }
	    }
    }
    else if (interactionId != null)
    {
	    int id = Integer.parseInt(interactionId);

	    DenormInteraction i = docUtil.getBasicInteractionDetails(id) ;
        gene1 = i.getSymbol1() ;
        gene2 = i.getSymbol2() ;
        List<DocumentBriefSimple> dlist = docUtil.getDocumentsForInteraction(id);
        for (DocumentBriefSimple doc: dlist) {
        	wrapperList.add(new DocListDataWrapper(DocListDataWrapper.INTERACTION,id,doc,linkText));
        }
    }

	String showAll = request.getParameter("showAll");
	if (showAll != null) {
		pageSize = wrapperList.size();
	}
    
    request.setAttribute("dinfo", wrapperList) ;
%>

<%
    if (geneId != null) {
    	if (unionInteractions == null) {
%>
<h2>Documents for Gene <% out.println(geneName + "(" + taxName + ")");%></h2>
<%
    	} else {
%>
<h2>Documents for All the Interactions of Gene <% out.println(geneName + "(" + taxName + ")");%></h2>
<%
    	}
    } else if (interactionId != null) {
%>
<h2>Documents for Gene Interactions <%=gene1%> and <%=gene2%></h2>
<%
    } else {
%>
<h2>No Document list (Missing gene or interaction id value)</h2>
<%
    }
%>
<!-- removed table-size form for November 20, 2008 deploy --------------------------
<form>
	<input type="text" name="pageSize" value="<%= pageSize %>" size="5" />
	<input type="submit" name="setPageSize" value="Set New Page Size" />
	<input type="submit" name="showAll" value="Show All" />
<%
    if (geneId != null) {
%>
	<input type="hidden" name="geneid" value=<%= geneId %> />
<%
    }
	if (interactionId != null) {
%>
	<input type="hidden" name="interactionid" value=<%= interactionId %> />
<%
    }
	if (unionInteractions != null) {
%>
	<input type="hidden" name="unioninteractions" value=<%= unionInteractions %> />
<%
    }
%>
</form>
-----------------------------------------------------------------------------  -->

<display:table export="true" pagesize="<%= pageSize %>" name="dinfo" class="displaytag" id="dtable" requestURI="replaceURI">
    <display:setProperty name="export.csv.filename" value="gene_interaction_abstracts.csv"/>
    <display:setProperty name="export.xml.filename" value="gene_interaction_abstracts.xml"/>
    <display:setProperty name="export.excel.filename" value="gene_interaction_abstracts.xls"/>
	<display:setProperty name="basic.msg.empty_list" value="No documents were found in the database." />
	<display:setProperty name="paging.banner.item_name" value="document" />
	<display:setProperty name="paging.banner.items_name" value="documents" />
    <display:column property="id" title="Pubmed Id" sortable="true" sortProperty="id"
    	decorator="org.ncibi.mimiweb.decorator.PubmedColumnDecorator"/>
    <display:column property="itself" title="See Mined Text" 
    	decorator="org.ncibi.mimiweb.decorator.DocListTableLinkColumnDecorator" />
	<display:column property="year" sortable="true" title="Year"/>
	<display:column property="authors" sortable="true" title="Author(s)"/>
    <display:column property="title" sortable="true" title="Title"/>
    <display:column property="citation" sortable="true" title="Full Citation"/>
</display:table>
