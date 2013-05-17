<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<%@ taglib uri="http://displaytag.sf.net" prefix="display" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ include file="inc/header2.jsp" %>

<%@ page import="java.util.List,
    org.ncibi.mimiweb.data.hibernate.*,
    org.ncibi.mimiweb.hibernate.*,
   	org.ncibi.mimiweb.data.ResultGeneMolecule,
 	org.ncibi.mimiweb.lucene.LuceneInterface,
 	java.util.Collections,
    org.ncibi.mimiweb.data.GeneInteractionList" 
%>

    <%
	    String geneid = (String) request.getParameter("geneid") ;
	    int id = Integer.parseInt(geneid);

		LuceneInterface l = LuceneInterface.getInterface();
		ResultGeneMolecule gene = l.getGeneData(id);
		String geneName = gene.getSymbol();
		String taxName = gene.getTaxScientificName();

	    List interactionList = new GeneInteractionList(id);
	    if (interactionList == null)
	    {
	        interactionList = Collections.emptyList();
	    }
        request.setAttribute("interactions", interactionList) ;

    %>

<h2>Interactions - for Gene <%out.println(geneName + "(" + taxName + ")");%></h2>

<display:table export="true" name="interactions" pagesize="50" class="displaytag" id="interactionspage" requestURI="replaceURI">
	<display:setProperty name="basic.msg.empty_list" value="No interactions were found in the database." />
    <display:setProperty name="export.csv.filename" value="interactions.csv"/>
    <display:setProperty name="export.xml.filename" value="interactions.xml"/>
    <display:setProperty name="export.excel.filename" value="interactions.xls"/>
	<display:setProperty name="paging.banner.item_name" value="interaction" />
	<display:setProperty name="paging.banner.items_name" value="interactions" />
    <display:column property="symbol1" title="Gene1" sortable="true" headerClass="sortable" sortName="symbol1"/>
    <display:column property="symbol2" title="Gene2" sortable="true" headerClass="sortable" sortName="symbol2" href="gene-details-page-front.jsp" paramId="geneid" paramProperty="geneid2"/>
    <display:column property="provenanceDatabaseLinksString" title="Source Provenance" />
    <display:column property="pubMedCount" title="Lit. Count" href="document-list-page-front.jsp" paramId="interactionid" paramProperty="ggIntID"/>
    <display:column property="interactionTypesStr" title="Interaction Info"/>
    <display:column property="experimentsStr" title="Experiments"/>
</display:table>

