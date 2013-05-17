<jsp:root version="1.2" xmlns:jsp="http://java.sun.com/JSP/Page" xmlns:display="urn:jsptld:http://displaytag.sf.net">
    <jsp:directive.page contentType="text/html; charset=UTF-8" />
    <jsp:directive.page import="java.util.ArrayList, org.ncibi.mimiweb.data.*, org.ncibi.mimiweb.lucene.*, org.ncibi.mimiweb.data.*" />
    <jsp:include page="inc/header2.jsp" flush="true" />

<hr/>
<h3>Gene Details</h3>
    <jsp:scriptlet>
        String search = (String) request.getParameter("search") ;
        LuceneInterface l = LuceneInterface.getInterface() ;
        ArrayList mols = l.fullGeneSearch(9606, search) ;
        ResultGeneMolecule g = (ResultGeneMolecule) mols.get(0) ;
        request.setAttribute("geneinfo", mols) ;
        String h = "Hello" ;
    </jsp:scriptlet>

    <display:table export="false" name="geneinfo" class="displaytag" id="geneinfo1">
        <display:column property="symbol" maxLength="15" title="Gene Name:"/>
        <display:column property="id" maxLength="15" title="GeneId:"/>
        <display:column property="taxScientificName" maxLength="15" title="Organism:"/>
    </display:table>

    <display:table export="false" name="geneinfo" class="displaytag" id="geneinfo2">
        <display:column property="moleculeNames" maxLength="15" title="Other Names:"/>
        <display:column property="geneType" maxLength="15" title="Type:"/>
        <display:column property="keggIds" maxLength="15" title="KeggIds:"/>
    </display:table>

    <display:table export="false" name="geneinfo" class="displaytag" id="geneinfo3">
        <display:column property="chromosome" maxLength="15" title="Chromosome:"/>
        <display:column property="mapLocus" maxLength="15" title="Map Locus:"/>
        <display:column property="locusTag" maxLength="15" title="Locus Tag:"/>
    </display:table>

<hr/>
<h3>Descriptions</h3>
<h4>Authorized Gene Description:</h4>
<p> <jsp:scriptlet> out.println(g.getAuthorizedDescription()) ; </jsp:scriptlet></p>
<h4>Other Gene Descriptions:</h4>
<p> <jsp:scriptlet> out.println(g.getOtherDescription()) ;</jsp:scriptlet></p>
<h4>Molecule Descriptions:</h4>
<p> <jsp:scriptlet> out.println(g.getMoleculeDescriptionsString()) ; </jsp:scriptlet></p>

<hr/>
<h3>Pathways</h3>

<hr/>
<h3>Go Terms</h3>

<hr/>
<h3>Interactions</h3>

    <jsp:scriptlet> 
        //String geneid = (String) request.getParameter("geneid") ;
        request.setAttribute("interactions", new GeneInteractionList(g.getId())) ;
        //request.setAttribute("interactions", new GeneInteractionList(1436)) ; 
    </jsp:scriptlet>
    <display:table export="true" name="interactions" pagesize="4" class="displaytag" id="interactionspage" requestURI="replaceURI">
        <display:column property="symbol1" title="Gene1" sortable="true" headerClass="sortable" sortName="symbol1"/>
        <display:column property="symbol2" title="Gene2" sortable="true" headerClass="sortable" sortName="symbol2"/>
        <display:column property="components" title="GO:Component"/>
        <display:column property="functions" title="GO:Function"/>
        <display:column property="processes" title="GO:Process"/>
        <display:column property="interactionTypes" title="Interaction Info"/>
    </display:table>

<hr/>
<h3>Molecule Provenance</h3>

<hr/>
<h3>Related Documents</h3>
</jsp:root>

