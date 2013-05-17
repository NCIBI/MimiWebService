<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<%@ taglib uri="http://displaytag.sf.net" prefix="display" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ include file="inc/header2.jsp" %>
<%@ page import="org.ncibi.mimiweb.data.ExternalReference,
                org.ncibi.mimiweb.data.ResultGeneMolecule,
                java.util.ArrayList, org.ncibi.mimiweb.hibernate.HibernateInterface"
%>
<%
    String geneidstr = request.getParameter("geneid") ;
    int geneid = Integer.parseInt(geneidstr) ;
    HibernateInterface h = HibernateInterface.getInterface() ;
    ResultGeneMolecule g = h.getSingleGene(geneid) ;
    g = h.extendSingleGene(g) ;
    request.setAttribute("xrefs", g.getExternalRefs()) ;
%>

<display:table export="false" name="xrefs" class="displaytag" id="xrefstable">
    <display:column property="idType" title="idType"/>
    <display:column property="idValue" title="idValue"/>
</display:table>

