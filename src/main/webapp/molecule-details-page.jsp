<%@ taglib uri="http://displaytag.sf.net" prefix="display" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ include file="inc/header2.jsp" %>
<%@ page import="java.util.ArrayList, 
            org.ncibi.mimiweb.data.hibernate.*, 
            org.ncibi.mimiweb.hibernate.*, 
            org.ncibi.mimiweb.data.*" 
%>

<h2>MiMI Molecule Source Record Details</h2>

<hr/>
<h3>MiMI Molecule Source Record Overview</h3>
    <%
        String molId = (String) request.getParameter("moleculeid") ;
        HibernateInterface h = HibernateInterface.getInterface() ;
        ArrayList moleculeList = h.getMoleculeRecordsForMolId(Integer.parseInt(molId)) ;
        MoleculeRecord mol = (MoleculeRecord) moleculeList.get(0) ;
        request.setAttribute("molecules", moleculeList) ;
    %>
	<dl><dt>Name(s):</dt>
		<dd><% out.println(mol.getNameString()); %></dd>
		<dt>Pathways(s):</dt>
		<dd><% out.println(mol.getPathwayString()); %></dd>
		<dt>Database Provenance:</dt>
		<dd><% out.println(mol.getDatabaseProvString()); %></dd>
		<dt>Pubmed Provenance:</dt>
		<dd><% out.println(mol.getPubmedProvString()); %></dd>
		<dt>Attribute Value(s):</dt>
		<dd><% out.println(mol.getAttributeString()); %></dd>
		<dt>KeggGeneId(s):</dt>
		<dd><% out.println(mol.getKeggGeneIdString()); %></dd>
	</dl>
    <%
    	if (mol.getMoleculeInteactionList() == null) 
        {
	%>
			<i>No interactions for this Molecule Record.</i>
	<%
		} 
        else if (mol.getMoleculeAttributeList().size() == 0) 
        {
	%>
			<i>No interactions for this Molecule Record.</i>
	<%
		} 
        else 
        {
	    	request.setAttribute("mol-interactions", mol.getMoleculeInteactionList());
    %>
	<h4>Interactions for Molecule Record:</h4>
    <display:table export="true" name="mol-interactions" pagesize="20" class="displaytag" id="interactionstable" requestURI="replaceURI">
        <display:column property="name1String" title="Molecule1" sortable="true" headerClass="sortable" sortName="symbol1" href="molecule-details-page-front.jsp" paramId="moleculeid" paramProperty="molID1"/>
        <display:column property="name2String" title="Molecule2" sortable="true" headerClass="sortable" sortName="symbol2" href="molecule-details-page-front.jsp" paramId="moleculeid" paramProperty="molID2"/>
        <display:column property="typeString" title="Type"/>
        <display:column property="databaseProvString" title="Database Provenance"/>
        <display:column property="pubmedProvString" title="Pubmed Provenance"/>
    </display:table>

	<%
		}
	%>
