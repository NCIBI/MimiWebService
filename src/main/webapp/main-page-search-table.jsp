<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<%@ taglib uri="http://displaytag.sf.net" prefix="display" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ include file="inc/header2.jsp" %>
<%@ page import="java.util.ArrayList,
			java.util.List,
            org.ncibi.mimiweb.data.*, 
            org.ncibi.mimiweb.util.PropertiesUtil,
            org.apache.lucene.queryParser.ParseException,
            org.ncibi.mimiweb.lucene.*, 
            org.ncibi.mimiweb.util.SearchTermUtil,
            org.ncibi.commons.lang.StrUtils,
            org.ncibi.commons.closure.AbstractFieldGetter,
            org.ncibi.mimiweb.data.*" 
%>

<hr/>
<h3>Search Results</h3>
    <%
        String search = (String) request.getParameter("search") ;
        String listsearch = (String) request.getParameter("listsearch") ;

        String saveListString = PropertiesUtil.getProperty("savelist") ;
        boolean useSaveList = (saveListString != null) && saveListString.equals("on");

        if (search == null && listsearch == null)
        {
            listsearch = (String) session.getAttribute("query");
        }

        if (listsearch != null)
        {
            search = listsearch ; // override search if present
        }

        int taxid = -1;
        String taxString = (String) request.getParameter("taxid");
        if (taxString != null) {
	        try {
	        	taxid = Integer.parseInt(taxString);
	        } catch (Throwable ignore) {}
        }
        LuceneInterface l = LuceneInterface.getInterface() ;
        boolean sawError = false ;
        List<ResultGeneMolecule> genes = null ;
        try
        {
            genes = l.fullGeneSearch(taxid, search, -1) ;
        }
        catch (ParseException e)
        {
            sawError = true ;
        }

        if (sawError == false)
        {
            if (listsearch != null)
            {
                List<String> notFoundTerms = SearchTermUtil.getNotFoundList(search, genes) ;
                if (notFoundTerms.size() > 0)
                {
    %>
                    <h3> Terms not found </h3>
                    <ul>
    <%
                    for (String term : notFoundTerms)
                    {
    %>
                        <li><%=term%></li>
    <%
                    }
    %>
                    </ul>
    <%
                }
            }
            request.setAttribute("geneinfo", genes) ;
			
            if (useSaveList && (genes != null) && (genes.size() > 0)) {            	            	
            	String ids = StrUtils.fieldJoin(genes, ",", new AbstractFieldGetter<String,ResultGeneMolecule>(){
            		public String getField(ResultGeneMolecule g){
            			return g.getId().toString();
            		}
            	});
            	
            	String userName = (String)application.getAttribute("NCIBI-List-Save-Username");

            	String viewUrl = "/" + PropertiesUtil.getProperty("saveWebappName") + "/getDataList.jsp" ;
     %>
	<div id="save-list">
	<form action="/<%= PropertiesUtil.getProperty("saveWebappName") %>/saveGeneList.jsp" method="post" target="_blank">
	<input type="submit" name="formName" value="Save Gene List" />
	<input type="hidden" name="requestSource" value="MimiWeb" />
	<input type="hidden" name="comment" value="<%= search %>" />
	<input type="hidden" name="ids" value="<%= ids %>" />
	<a href="<%= viewUrl %>">View</a> list of data sets<%= ((userName != null)?(" for " + userName):"") %>.
	</form>
	</div>

	<%		} %>
    <display:table export="true" name="geneinfo" class="displaytag" id="geneinfo1" pagesize="20" requestURI="replaceURI" decorator="org.ncibi.mimiweb.decorator.ResultGeneMoleculeDecorator">
		<display:setProperty name="basic.msg.empty_list" value="No genes were found in the database." />
        <display:setProperty name="export.csv.filename" value="searchresults.csv"/>
        <display:setProperty name="export.xml.filename" value="searchresults.xml"/>
        <display:setProperty name="export.excel.filename" value="searchresults.xls"/>
		<display:setProperty name="paging.banner.item_name" value="gene" />
		<display:setProperty name="paging.banner.items_name" value="genes" />
        <display:column property="symbol" title="Gene" sortable="true" headerClass="sortable" sortName="symbol" href="gene-details-page-front.jsp" paramId="geneid" paramProperty="id"/>
        <display:column property="taxScientificName" title="Organism" sortable="true" headerClass="sortable" sortName="scientificTaxName"/>
        <display:column property="geneType" title="Type" sortable="true" headerClass="sortable" sortName="geneType"/>
        <display:column property="moleculeNamesString" title="Other Names"/>
        <display:column property="description" title="Description"/>
        <display:column property="cellularComponents" title="Cellular Components" />
        <display:column property="biologicalProcesses" title="Biological Processes" />
        <display:column property="molecularFunctions" title="Molecular Functions" />
        <display:column property="interactionCount" title="Int" sortable="true" headerClass="sortable" sortProperty="interactionCount"/>
        <display:column property="pubCount" title="Doc" sortable="true" headerClass="sortable" sortProperty="pubCount"/>
        <display:column property="pathwayCount" title="Path" sortable="true" headerClass="sortable" sortProperty="pathwayCount"/>
    </display:table>
<%
    }
    else
    {
%>
<p>The search term '<%=search%>' returned an error. You may have specified a term that
matches too many entries (for example, a*), or has an incorrect format (for example, you
cannot specify a wildcard, such as *, as the first character).Please change your search term. </p>

<p>If you feel you received this error incorrectly please send an email to
<a href="mailto:mimi-help@umich.edu?subject=Free Text Search Problems:'<%=search%>'">mimi-help@umich.edu</a>
describing the problem.</p>
<%
    }
%>

