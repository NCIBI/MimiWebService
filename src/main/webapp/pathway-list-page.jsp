<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<%@ taglib uri="http://displaytag.sf.net" prefix="display" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ include file="inc/header2.jsp" %>
<%@ page import="java.util.ArrayList, 
    org.ncibi.mimiweb.data.hibernate.*,
    org.ncibi.mimiweb.lucene.LuceneInterface,
    org.ncibi.mimiweb.data.ResultGeneMolecule,
    org.ncibi.mimiweb.data.hibernate.GenePathways,
    org.ncibi.mimiweb.hibernate.*" %>

<%
    String geneid = (String) request.getParameter("geneid") ;
    HibernateInterface h = HibernateInterface.getInterface() ;
    int id = Integer.parseInt(geneid);

    ArrayList<GenePathways> plist = h.getPathwayListForGeneId(id) ;
    request.setAttribute("pinfo", plist) ;

    LuceneInterface l = LuceneInterface.getInterface();
    ResultGeneMolecule gene = l.getGeneData(id);
    String geneName = gene.getSymbol();
    String taxName = gene.getTaxScientificName();
%>

<h2>Pathways for Gene <%out.println(geneName + "(" + taxName + ")");%></h2>

<display:table export="true" name="pinfo" class="displaytag" id="ptable" pagesize="50"
        requestURI="replaceURI">
    <display:setProperty name="export.csv.filename" value="pathways_for_gene.csv"/>
    <display:setProperty name="export.xml.filename" value="pathways_for_gene.xml"/>
    <display:setProperty name="export.excel.filename" value="pathways_for_gene.xls"/>
 	<display:setProperty name="basic.msg.empty_list" value="No pathways were found in the database." />
	<display:setProperty name="paging.banner.item_name" value="pathway" />
	<display:setProperty name="paging.banner.items_name" value="pathways" />
   <display:column property="pathname" title="Id and Link to Source" decorator="org.ncibi.mimiweb.decorator.PathwayNameColumnDecorator"/>
    <display:column property="description" title="Description"/>
    <display:column title="View Detail" href="pathway-details-page-front.jsp" paramId="pathwayid" paramProperty="id">View</display:column>
</display:table>
