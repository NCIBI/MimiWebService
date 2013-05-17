<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<%@ taglib uri="http://displaytag.sf.net" prefix="display" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ include file="inc/header2.jsp" %>
<%@ page import="java.util.List,
                java.util.ArrayList,
                org.ncibi.mimiweb.hibernate.HumDBQueryInterface,
                org.ncibi.mimiweb.data.Compound,
                org.ncibi.mimiweb.util.SearchListCompare,
                org.apache.commons.lang.StringUtils"
%>

<hr/>
<h3>Search Results</h3>

<%
    String cids = (String) request.getParameter("search") ;
    String[] symbols = null;
    if (cids == null)
    {
        cids = (String) session.getAttribute("query");
        symbols = (String[]) session.getAttribute("symbolArray");
    }

    String[] cidList = StringUtils.split(cids, ",") ;
    HumDBQueryInterface humdb = HumDBQueryInterface.getInterface() ;
    List<Compound> compounds = humdb.getCompoundsForCids(cidList) ;
    List<String> notFoundList;

    if (symbols != null)
    {
        notFoundList = SearchListCompare.compoundsNotFound(compounds, symbols);
    }
    else
    {
        notFoundList = new ArrayList<String>();
    }

    request.setAttribute("compounds", compounds) ;

    if (notFoundList.size() > 0)
    {
%>
        <h3> Terms not found </h3>
        <ul>

        <%

        for (String c : notFoundList)
        {

        %>

            <li><%=c%></li>

        <%

        }

        %>

        </ul>

    <%

    }

    %>

<display:table name="compounds" class="displaytag" pagesize="20" 
        id="compoundstable" requestURI="replaceURI">
    <display:setProperty name="basic.msg.empty_list" value="No compounds found"/>
    <display:setProperty name="paging.banner.item_name" value="compound" />
    <display:setProperty name="paging.banner.items_name" value="compounds" />

    <display:column property="cid" sortable="true" title="Id"
        href="compound-details-page-front.jsp" paramId="cid" paramProperty="cid" />
    <display:column property="name" sortable="true" title="Name"/>
    <display:column property="mf" title="MF"/>
    <display:column property="molecularWeight" sortable="true" title="Mol. Weight"/>
    <display:column property="casnum" sortable="true" title="CASNUM"/>
    <display:column property="smile" title="Smile"/>
</display:table>
