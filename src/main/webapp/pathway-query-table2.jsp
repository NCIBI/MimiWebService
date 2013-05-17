<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<%@ taglib uri="http://displaytag.sf.net" prefix="display" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ include file="inc/header2.jsp" %>
<%@ page import="org.ncibi.mimiweb.data.ResultPathwayDetail,
                org.ncibi.mimiweb.data.ResultGeneMolecule,
                org.ncibi.mimiweb.lucene.LuceneInterface,
                org.ncibi.lucene.MimiLuceneFields,
                java.util.ArrayList, org.ncibi.mimiweb.hibernate.PathwayQueryInterface"
%>
<hr/>
<%
    String search = request.getParameter("search") ;
    LuceneInterface l = LuceneInterface.getInterface() ;
    ArrayList<ResultGeneMolecule> genes = l.fullGeneSearch(Integer.parseInt(taxid), search) ;
    PathwayQueryInterface pq = PathwayQueryInterface.getInterface() ;
    ArrayList<ResultPathwayDetail> pathways = pq.getPathwaysNGenesAreIn(genes) ;
    request.setAttribute("pathways", pathways) ;
%>

<h3>Pathways that <a href="gene-details-page-front.jsp?geneid=<%=g1id%>"><%=gene1%></a> and <a href="gene-details-page-front.jsp?geneid=<%=g2id%>"><%=gene2%></a> are in</h3>
<display:table export="false" name="pathways" class="displaytag" id="pathwaystable">
 	<display:setProperty name="basic.msg.empty_list" value="No pathways were found in the database." />
	<display:setProperty name="paging.banner.item_name" value="pathway" />
	<display:setProperty name="paging.banner.items_name" value="pathways" />
    <display:column property="nameHTML" title="Name"/>
    <display:column property="description" title="Description"/>
    <display:column title="View Detail" href="pathway-details-page-front.jsp" paramId="pathwayid" paramProperty="pathwayId">View</display:column>
</display:table>

<%
    }
%>

