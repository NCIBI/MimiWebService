<%@ taglib uri="http://displaytag.sf.net" prefix="display" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ include file="inc/header2.jsp" %>
<%@ page import="java.util.ArrayList, 
            org.ncibi.mimiweb.data.hibernate.*, 
            org.ncibi.mimiweb.util.PathwayUtil,
            org.ncibi.mimiweb.hibernate.*, 
            org.ncibi.lucene.MimiLuceneFields,
            org.ncibi.mimiweb.lucene.LuceneInterface,
            org.ncibi.mimiweb.data.*" %>

<h2><img src="images/Pathway_details.jpg" alt="Pathway Details" /></h2>
<%
    String pathwayid = (String) request.getParameter("pathwayid") ;
    HibernateInterface h = HibernateInterface.getInterface() ;
    ResultPathwayDetail p = h.getPathwayDetailsFromPathwayId(Integer.parseInt(pathwayid)) ;
    String link = "pathway-interactions-page-front.jsp?pathwayid=" + pathwayid ;
%>
<h3>Name: <%out.println(PathwayUtil.getPathnameHTML(p.getName()));%></h3>
<h3>Data Source: KEGG</h3>
<h3>Description: <%out.println(p.getDescription());%></h3>
<% out.print("<a href=\"" + link + "\">Show Genes</a> in this pathway that interact (inside or outside of Pathway)") ; %>

<hr/>
<h3>Genes Associated with Pathway</h3>
<%
    String searchStr = "" ;
    boolean firstTime = true ;
    for (PathwayGeneInfo item : p.getPathwayGeneInfo())
    {
        if (firstTime)
        {
            searchStr =  MimiLuceneFields.FIELD_GENEID + ":" + item.getGeneId() ;
            firstTime = false ;
        }
        else
        {
            searchStr += " OR " + MimiLuceneFields.FIELD_GENEID + ":" + item.getGeneId() ;
        }
    }

    LuceneInterface l = LuceneInterface.getInterface() ;
    ArrayList<ResultGeneMolecule> glist = l.fullGeneSearch(-1, searchStr) ;
    request.setAttribute("geneinfo", glist) ;
%>

    <display:table export="true" name="geneinfo" class="displaytag" id="geneinfo1" pagesize="20" requestURI="replaceURI" decorator="org.ncibi.mimiweb.decorator.ResultGeneMoleculeDecorator">
        <display:setProperty name="export.csv.filename" value="genes_for_pathway.csv"/>
        <display:setProperty name="export.xml.filename" value="genes_for_pathway.xml"/>
        <display:setProperty name="export.excel.filename" value="genes_for_pathway.xls"/>
        <display:column property="symbol" title="Gene" sortable="true" headerClass="sortable" sortName="symbol" href="gene-details-page-front.jsp" paramId="geneid" paramProperty="id"/>
        <display:column property="taxScientificName" title="Organism" sortable="true" headerClass="sortable" sortName="scientificTaxName"/>
        <display:column property="geneType" title="Type" sortable="true" headerClass="sortable" sortName="geneType"/>
        <display:column property="moleculeNamesString" title="Other Names"/>
        <display:column property="description" title="Description"/>
        <display:column property="cellularComponents" title="Cellular Components"/>
        <display:column property="biologicalProcesses" title="Biological Processes"/>
        <display:column property="molecularFunctions" title="Molecular Functions"/>
        <display:column property="interactionCount" title="Int" sortable="true" headerClass="sortable" sortProperty="interactionCount"/>
        <display:column property="pubCount" title="Doc" sortable="true" headerClass="sortable" sortProperty="pubCount"/>
        <display:column property="pathwayCount" title="All Path" sortable="true" headerClass="sortable" sortProperty="pathwayCount"/>
    </display:table>

