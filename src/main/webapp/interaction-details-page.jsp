<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<%@ taglib uri="http://displaytag.sf.net" prefix="display" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ include file="inc/header2.jsp" %>
<%@ page import="java.util.ArrayList, 
	org.ncibi.mimiweb.decorator.DocListDataWrapper,
	org.ncibi.mimiweb.data.hibernate.*, 
	org.ncibi.mimiweb.data.*,
	org.ncibi.mimiweb.hibernate.*" 
%>

<h2><img src="images/Interaction_details.jpg" alt="Interaction Details" /></h2>
<h3><img src="images/gene_icon.jpg" alt="Genes"/>Genes</h3>
<hr/>
<%
    String interactionid = (String) request.getParameter("interactionid") ;
    HibernateInterface h = HibernateInterface.getInterface() ;
    DenormInteraction i = h.getBasicInteractionDetails(Integer.parseInt(interactionid)) ;
    request.setAttribute("intinfo", i) ;
    String namesWithLinks = i.getNamesWithLinks() ;
%>
<p><%=namesWithLinks%></p>
<br>
<h3><a href="javascript:toggleBox('1')"><img src="images/Pathway_icon.jpg" alt="Pathways containing both genes"/></a><a name="pathways">Pathways</a> - <a href="javascript:toggleBox('1')">show/hide</a></h3> 
<hr /> 
<div class="hiddenelement" id="1" style="visibility: hidden; display: none;">
<%
    PathwayQueryInterface pq = PathwayQueryInterface.getInterface() ;
    ArrayList<ResultPathwayDetail> pathways = pq.getPathwaysBothGenesAreIn(i.getGeneid1(), i.getGeneid2()) ;
    request.setAttribute("pathways", pathways) ;
%>
<display:table export="false" name="pathways" class="displaytag" id="pathwaystable">
    <display:column property="name" title="Name" decorator="org.ncibi.mimiweb.decorator.PathwayNameColumnDecorator"/>
    <display:column property="description" title="Description"/>
    <display:column title="View Detail" href="pathway-details-page-front.jsp" paramId="pathwayid" paramProperty="pathwayId">View</display:column> 
</display:table>
</div>
<h3><a href="javascript:toggleBox('2')"><img src="images/GO.jpg" alt="GO Terms"/></a>GO Terms - <a href="javascript:toggleBox('2')">show/hide</a></h3>
<hr/>
<div class="hiddenelement" id="2" style="visibility: hidden; display: none;"> 
    <display:table export="true" name="intinfo" class="displaytag" id="interactionspage">
        <display:setProperty name="export.csv.filename" value="goterms.csv"/>
        <display:setProperty name="export.xml.filename" value="goterms.xml"/>
        <display:setProperty name="export.excel.filename" value="goterms.xls"/>
        <display:column property="components" title="GO:Component" decorator="org.ncibi.mimiweb.decorator.GoColumnWrapper"/>
        <display:column property="functions" title="GO:Function" decorator="org.ncibi.mimiweb.decorator.GoColumnWrapper"/>
        <display:column property="processes" title="GO:Process" decorator="org.ncibi.mimiweb.decorator.GoColumnWrapper"/>
    </display:table>
</div>
<h3><a href="javascript:toggleBox('3')"><img src="images/Protein2_icon.jpg" alt="Protein Interaction Types And Annotations"/></a>Protein Interaction Types And Annotations - <a href="javascript:toggleBox('3')">show/hide</a></h3>
<hr/>
<div class="hiddenelement" id="3" style="visibility: hidden; display: none;"> 
    <display:table name="intinfo" class="displaytag" id="itypetable" requestURI="replaceURI">
        <display:column property="interactionTypesStr" title="Interaction Types"/>
        <display:column property="experimentsStr" title="Experiments"/>
    </display:table>
</div>


<h3><a href="javascript:toggleBox('4')"><img src="images/Provenance_icon.jpg" alt="Provenance Sources"/></a>Provenance Sources - <a href="javascript:toggleBox('4')">show/hide</a></h3> 
<hr /> 
<div class="hiddenelement" id="4" style="visibility: hidden; display: none;">
<%
    request.setAttribute("provsources", i.getProvenanceDatabaseLinks()) ;
%>
    <display:table name="provsources" class="displaytag" id="provtable" requestURI="replaceURI">
        <display:column property="str" title="Provenance"/>
    </display:table>
</div>

<h3><a href="javascript:toggleBox('5')"><img src="images/Literature_icon01.jpg" alt="Literature associating interactions"/></a>Literature associating interactions - <a href="javascript:toggleBox('5')">show/hide</a> </h3> 
<hr />
<div class="hiddenelement" id="5" style="visibility: hidden; display: none;">
<%
    ArrayList<Integer> pmids = i.getPubmedIdList() ;
    ArrayList<DocumentBriefSimple> docs = h.getDocumentDetailsForPubmedList(pmids) ;
	ArrayList<DocListDataWrapper> wrapperList = new ArrayList<DocListDataWrapper>();
    for (DocumentBriefSimple doc: docs) {
    	wrapperList.add(new DocListDataWrapper(DocListDataWrapper.INTERACTION,interactionid,doc,"View"));
    }

    request.setAttribute("pubmedinfo", wrapperList) ;
%>

    <display:table export="true" name="pubmedinfo" class="displaytag" id="docstable">
        <display:column property="id" title="Pubmed Id" sortable="true" headerClass="sortable" sortName="pubmedId" decorator="org.ncibi.mimiweb.decorator.PubmedColumnDecorator"/>
	    <display:column property="itself" title="View Details" 
    		decorator="org.ncibi.mimiweb.decorator.DocListTableLinkColumnDecorator" />
        <display:setProperty name="export.csv.filename" value="abstracts.csv"/>
        <display:setProperty name="export.xml.filename" value="abstracts.xml"/>
        <display:setProperty name="export.excel.filename" value="abstracts.xls"/>
		<display:column property="year" title="Year" sortable="true" />
        <display:column property="citation" title="Citation"/>
        <display:column property="title" title="Title"/>
        <display:column property="authors" title="Author(s)"/>
    </display:table>
 </div>

