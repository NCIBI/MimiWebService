<%@ taglib uri="http://displaytag.sf.net" prefix="display" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ include file="inc/header2.jsp" %>
<%@ page import="java.io.*,
				java.util.List,
				java.util.Collections,
                org.ncibi.mimiweb.data.hibernate.*, 
                org.ncibi.mimiweb.hibernate.*,
                org.ncibi.mimiweb.data.*" %>

<h2><img src="images/Compound_Details.jpg" alt="Compound Details" /></h2>
<div id="compound-content">
<%
    String cid = (String) request.getParameter("cid") ;
    HumDBQueryInterface humdb = HumDBQueryInterface.getInterface() ;
    Compound c = humdb.getCompoundDetailsForCid(cid) ;
    List<MetabReaction> reactions = Collections.emptyList();
    List<ResultPathway> pathways = Collections.emptyList();
    if (c == null)
    {
%>
    <p>No such compound <%=cid%></p>
<%
    }
    else
    {
        reactions = humdb.getReactionsContainingCompound(cid);
        pathways = humdb.getPathwaysForCid(cid);
        request.setAttribute("pathways", pathways) ;
        request.setAttribute("reactions", reactions) ;
        String casnum = c.getCasnum() ;
        String smile = c.getSmile() ;
%>
<h3>Compound:</h3> <%=c.getName()%> 
<h3>CompoundID:</h3> <%=c.getCid()%> <a href="http://www.genome.jp/dbget-bin/www_bget?compound+<%=c.getCid()%>">View in KEGG</a>
<a href="http://mimi.ncibi.org/metscape/launcher?cmpdID=<%=c.getCid()%>">View in Metscape</a>
<h3>MF:</h3> <%=c.getMf()%>
<h3>Molecular Weight:</h3> <%=c.getMolecularWeight()%>
<%
        if (casnum != null)
        {
%>
<h3>CASNUM:</h3> <%=casnum%>
<%
        }
%>

<%
        if (smile != null)
        {
%>
<div id="smile-block">
<h3>Smile:</h3>
<p><%=smile%></p>
<%
        }
%>
<%
        String relativepath = "images/smiles/png/" + cid + ".png" ;
        String fullfilepath = application.getRealPath("images/smiles/png") + "/" + cid + ".png" ;
        File f = new File(fullfilepath) ;
        if (f.exists())
        {
%>
<p><img src="<%=relativepath%>"></p>
<%
        }
%>
</div>
</div>
<h3><img src="images/Enzyme01.png" alt="Enzyme Reactions"/>Reactions compound participates in (<%=reactions.size()%> reactions found) - <a href="javascript:toggleBox('reaction-sh')">show/hide</a></h3>
    <hr/>
<div class="hiddenelement" id="reaction-sh" style="visibility: hidden; display:none;">
<display:table name="reactions" class="displaytag" pagesize="20" 
        id="reactionstable" requestURI="replaceURI">
    <display:setProperty name="basic.msg.empty_list" value="No reactions for this compound were found."/>
    <display:setProperty name="paging.banner.item_name" value="reaction" />
    <display:setProperty name="paging.banner.items_name" value="reactions" />
    <display:column property="rid" sortable="true" title="Id"
        href="reaction-details-page-front.jsp" paramId="rid" paramProperty="rid"/>
    <display:column property="description" sortable="true" title="Description"/>
    <display:column property="reversible" title="Reversible?"/>
    <display:column property="ridrxntxt" title="Equation"
        decorator="org.ncibi.mimiweb.decorator.RxnTxtColumnDecorator"/>
</display:table>
</div>
<h3><img src="images/Pathway_icon.jpg" alt="Pathways"/>Pathways compound is found in (<%=pathways.size()%> pathways found) - <a href="javascript:toggleBox('pathway-sh')">show/hide</a></h3>
   <hr/>
<div class="hiddenelement" id="pathway-sh" style="visibility: hidden; display:none;">
<display:table name="pathways" class="displaytag" pagesize="20" id="pathwaystable"
        requestURI="replaceURI">
    <display:setProperty name="basic.msg.empty_list" value="No pathways containing this compound were found."/>
    <display:setProperty name="paging.banner.item_name" value="pathway" />
    <display:setProperty name="paging.banner.items_name" value="pathways" />
    <display:column property="pathwayDescription" sortable="true" title="Pathway"/>
    <display:column property="pathwayKeggId" sortable="true" title="KeggId"
        decorator="org.ncibi.mimiweb.decorator.CompoundPathwayKeggIdColumnDecorator"/>
</display:table>
</div>
<%
    }
%>

