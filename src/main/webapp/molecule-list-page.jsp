<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<%@ taglib uri="http://displaytag.sf.net" prefix="display" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ include file="inc/header2.jsp" %>
<%@ page import="java.util.ArrayList,
    org.ncibi.mimiweb.data.hibernate.*,
    org.ncibi.mimiweb.hibernate.*,
    org.ncibi.mimiweb.lucene.LuceneInterface,
    org.ncibi.mimiweb.data.ResultGeneMolecule,
    org.ncibi.mimiweb.data.GeneInteractionList" 
%>

    <%
	    String geneid = (String) request.getParameter("geneid") ;
	    int id = Integer.parseInt(geneid);
		HibernateInterface h = HibernateInterface.getInterface();
		ArrayList list = h.getMoleculeRecordsForGeneId(id);
        request.setAttribute("molecules", list) ;

    	LuceneInterface l = LuceneInterface.getInterface();
    	ResultGeneMolecule gene = l.getGeneData(id);
    	String geneName = gene.getSymbol();
    	String taxName = gene.getTaxScientificName();
        
    %>

<h2>Molecule Source Records for Gene <%out.println(geneName + "(" + taxName + ")");%></h2>

    <display:table export="true" name="molecules" pagesize="50" class="displaytag" id="moleculespage" requestURI="replaceURI">
        <display:column property="nameString" title="Names" />
        <display:column property="numberOfInteractions" title="# Int" />
        <display:column title="View Molecule" href="molecule-details-page-front.jsp" paramId="moleculeid" paramProperty="id">View</display:column>
        <display:column property="databaseProvString" title="Database Provenance" />
        <display:column property="pubmedProvString" title="Pubmed Provenance"/>
        <display:column property="attributeString" title="GO Attributes"/>
    </display:table>
