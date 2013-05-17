<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<%@ taglib uri="http://displaytag.sf.net" prefix="display" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ include file="inc/header2.jsp" %>
<%@ page import="java.util.ArrayList, org.ncibi.mimiweb.data.*, org.ncibi.mimiweb.hibernate.*, org.ncibi.mimiweb.data.*" 
%>

<hr/>
<h3>Search Results</h3>
    <%
        String gene1 = (String) request.getParameter("gene1") ;
        if (gene1.length() == 0)
            gene1 = null ;

        String gene2 = (String) request.getParameter("gene2") ;
        if (gene2.length() == 0)
            gene2 = null ;

        int taxid = -1;
        String taxString = (String) request.getParameter("taxid");
        if (taxString != null) {
	        try {
	        	taxid = Integer.parseInt(taxString);
	        } catch (Throwable ignore) {}
        }
    	String interactionType = request.getParameter("interactionType") ;
		if (interactionType != null)
        {
            if (interactionType.length() == 0)
			    interactionType = null;
        }
    	
		HibernateInterface h = HibernateInterface.getInterface();
        ArrayList interactions = null ;

        if (gene1 != null || gene2 != null)
            {
                interactions =  h.getInteractionsByGeneSymbol(gene1, gene2, interactionType, taxid);
                request.setAttribute("interactions", interactions) ;
    %>


<h2>Interactions Search Results </h2>

<display:table export="true" name="interactions" pagesize="50" class="displaytag" id="interactionspage" requestURI="replaceURI">
	<display:setProperty name="basic.msg.empty_list" value="No interactions were found in the database." />
    <display:setProperty name="export.csv.filename" value="interactions.csv"/>
    <display:setProperty name="export.xml.filename" value="interactions.xml"/>
    <display:setProperty name="export.excel.filename" value="interactions.xls"/>
	<display:setProperty name="paging.banner.item_name" value="interaction" />
	<display:setProperty name="paging.banner.items_name" value="interactions" />
    <display:column property="symbol1" title="Gene1" sortable="true" headerClass="sortable" sortName="symbol1" href="gene-details-page-front.jsp" paramId="geneid" paramProperty="geneid1"/>
    <display:column property="symbol2" title="Gene2" sortable="true" headerClass="sortable" sortName="symbol2" href="gene-details-page-front.jsp" paramId="geneid" paramProperty="geneid2"/>
    <display:column title="View Interaction" href="interaction-details-page-front.jsp" paramId="interactionid" paramProperty="ggIntID">View</display:column>
    <display:column property="components" title="GO:Component" decorator="org.ncibi.mimiweb.decorator.GoColumnWrapper"/>
    <display:column property="functions" title="GO:Function" decorator="org.ncibi.mimiweb.decorator.GoColumnWrapper"/>
    <display:column property="processes" title="GO:Process" decorator="org.ncibi.mimiweb.decorator.GoColumnWrapper"/>
    <display:column property="interactionTypesStr" title="Interaction Info"/>
    <display:column property="experimentsStr" title="Experiments"/>
</display:table>
<%
        }
        else
        {
%>
<p> You cannot specify a blank for both genes. Please re-enter your query.</p>
<%
        }
%>

