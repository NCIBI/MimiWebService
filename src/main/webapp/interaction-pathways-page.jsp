<%@ taglib uri="http://displaytag.sf.net" prefix="display" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ include file="inc/header2.jsp" %>
<%@ page import="java.io.*,
                java.util.ArrayList,
                org.ncibi.mimiweb.data.hibernate.*, 
                org.ncibi.mimiweb.hibernate.*, 
                org.ncibi.mimiweb.data.*" %>

<%
    String interactionid = (String) request.getParameter("interactionid") ;
    HibernateInterface h = HibernateInterface.getInterface() ;
    DenormInteraction di = h.getBasicInteractionDetails(Integer.parseInt(interactionid)) ;
%>
<h2>Pathways in interaction: <%=di.getSymbol1()%> <--> <%=di.getSymbol2()%></h2>
<%
    ReactomeQueryInterface reactome = ReactomeQueryInterface.getInterface() ;
    ArrayList<GenePathways> pathways = reactome.getReactomePathwaysForInteraction(
                        di.getGeneid1(), di.getGeneid2()) ;
    if (pathways == null)
    {
%>
    <p>No pathways where these genes interact </p>
<%
    }
    else
    {
        request.setAttribute("pathways", pathways) ;
%>

<display:table name="pathways" class="displaytag" id="pathwaystable" pagesize="20" requestURI="replaceURI">
    <display:setProperty name="basic.msg.empty_list" value="No Pathways were found in the database." />
    <display:setProperty name="paging.banner.item_name" value="pathway" />
    <display:setProperty name="paging.banner.items_name" value="pathways" />
    <display:column property="pathname" title="Pathway" decorator="org.ncibi.mimiweb.decorator.PathwayNameColumnDecorator"/>
    <display:column property="description" title="Description"/>
</display:table>

<%
    }
%>
