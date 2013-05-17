<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Strict//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-strict.dtd">
<%@ page language="java" contentType="text/html; charset=ISO-8859-1"
    pageEncoding="ISO-8859-1"%>
<%@ taglib uri="http://displaytag.sf.net" prefix="display" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<jsp:useBean id="geneQueryState" class="org.ncibi.mimiweb.data.GeneQueryStateHolder" scope="session"/>
<%
        request.setAttribute("geneinfo",geneQueryState.getGenes());
%>
<script type="text/javascript">
	console.log("reloading table");
</script>

    <display:table export="true" name="geneinfo" class="displaytag" id="geneinfo1" pagesize="20" requestURI="replaceURI">
        <display:setProperty name="export.csv.filename" value="geneinfo.csv"/>
        <display:setProperty name="export.xml.filename" value="geneinfo.xml"/>
        <display:setProperty name="export.excel.filename" value="geneinfo.xls"/>
		<display:column property="checkBoxHtml" title="sel" />
        <display:column property="symbol" title="Gene" sortable="true" headerClass="sortable" sortName="symbol" href="gene-details-page-front.jsp" paramId="geneid" paramProperty="id"/>
        <display:column property="taxScientificName" title="Organism" sortable="true" headerClass="sortable" sortName="scientificTaxName"/>
        <display:column property="geneType" title="Type" sortable="true" headerClass="sortable" sortName="geneType"/>
        <display:column property="moleculeNamesString" title="Other Names"/>
        <display:column property="description" title="Description"/>
        <display:column property="cellularComponents" title="Cellular Components" decorator="org.ncibi.mimiweb.decorator.GoColumnWrapper"/>
        <display:column property="biologicalProcesses" title="Biological Processes" decorator="org.ncibi.mimiweb.decorator.GoColumnWrapper"/>
        <display:column property="molecularFunctions" title="Molecular Functions" decorator="org.ncibi.mimiweb.decorator.GoColumnWrapper"/>
        <display:column property="interactionCountHTML" title="Int" sortable="true" headerClass="sortable" sortProperty="interactionCount"/>
        <display:column property="pubCountHTML" title="Doc" sortable="true" headerClass="sortable" sortProperty="pubCount"/>
        <display:column property="pathwayCountHTML" title="Path" sortable="true" headerClass="sortable" sortProperty="pathwayCount"/>
    </display:table>

