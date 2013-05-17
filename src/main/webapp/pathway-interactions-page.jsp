<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<%@ taglib uri="http://displaytag.sf.net" prefix="display" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ include file="inc/header2.jsp" %>
<%@ page import="org.ncibi.mimiweb.data.hibernate.DenormInteraction,
                java.util.ArrayList, 
                org.ncibi.mimiweb.util.PathwayUtil,
                org.ncibi.mimiweb.data.ResultPathwayDetail,
                org.ncibi.mimiweb.hibernate.HibernateInterface,
                org.ncibi.mimiweb.hibernate.PathwayQueryInterface"
%>
<%
    String pathwayidstr = request.getParameter("pathwayid") ;
    HibernateInterface h = HibernateInterface.getInterface() ;
    int pathwayid = Integer.parseInt(pathwayidstr) ;
    ResultPathwayDetail p = h.getPathwayDetailsFromPathwayId(pathwayid) ;
    PathwayQueryInterface pq = PathwayQueryInterface.getInterface() ;
    ArrayList<DenormInteraction> interactions = pq.getInteractionGenesInPathway(pathwayid) ;
    request.setAttribute("interactions", interactions) ;
%>

<hr/>
<h3>Genes in Pathway <i><%out.print(PathwayUtil.getPathnameHTML(p.getName()));%></i> that interact (inside or outside of Pathway) </h3>
Description: <%out.print(p.getDescription());%>

<display:table export="false" pagesize="20" name="interactions" class="displaytag" id="pinteractions" requestURI="replaceURI">
	<display:setProperty name="basic.msg.empty_list" value="No interactions were found in the database." />
	<display:setProperty name="paging.banner.item_name" value="interaction" />
	<display:setProperty name="paging.banner.items_name" value="interactions" />
    <display:column property="symbol1" title="Gene Symbol 1" sortable="true" headerClass="sortable" sortName="symbol1" href="gene=details-page-front.jsp" paramId="geneid" paramProperty="geneid1"/>
    <display:column property="symbol2" title="Gene Symbol 2" sortable="true" headerClass="sortable" sortName="symbol2" href="gene=details-page-front.jsp" paramId="geneid" paramProperty="geneid2"/>
    <display:column title="View Interaction" href="interaction-details-page-front.jsp" paramId="interactionid" paramProperty="ggIntID">View</display:column>
</display:table>

