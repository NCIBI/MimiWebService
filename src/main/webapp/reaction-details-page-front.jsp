<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<%@ page contentType="text/html; charset=UTF-8"%>
<%@ page isELIgnored="false" %>
<%@ page import="java.io.*,
                java.util.ArrayList, java.util.List,
                org.ncibi.mimiweb.data.hibernate.*,
                org.ncibi.mimiweb.hibernate.*,
                org.ncibi.mimiweb.util.FlotUtil,
                org.ncibi.mimiweb.data.*" %>

<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>

<%
    String rid = request.getParameter("rid") ;
    String idparm = "rid=" + rid ;
%>

<html>
    <head>
        <title>MiMI Reaction Details</title>
        <script type='text/javascript' src='<c:url value="/dwr/interface/DisplayTagService.js"/>'></script>
        <script type='text/javascript' src='<c:url value="/dwr/engine.js"/>'></script>
        <script type='text/javascript' src='<c:url value="/dwr/util.js"/>'></script>
        <script language="javascript" type="text/javascript" src="js/excanvas.pack.js"></script>
        <script language="javascript" type="text/javascript" src="js/jquery.js"></script>
        <script language="javascript" type="text/javascript" src="js/jquery.flot.js"></script>
        <script type="text/javascript" src="js/ncibi.js"></script>
        <link rel="stylesheet" type="text/css" href='<c:url value="/css/displaytag.css"/>' />

        <script type="text/javascript">

            function update(js, jsp, criteria) {
                DisplayTagService.updateLinks(js, jsp, criteria, ncibi_callback) ;
            }
            //update("update", "/reaction-details-page.jsp", "<%=idparm%>") ;
        </script>
    </head>
    <body>
   <jsp:include page="mimiHeaderInc.html" />
   <input type="hidden" id="savestate" value="no"/>
   <input type="hidden" id="savestate2" value="no"/>
   <div id="mimi-nav">
	<ul>
	<li><a href="main-page.jsp">Free Text Search</a></li>
	<li><a href="upload-page.jsp">List Search</a></li>
	<li><a href="interaction-query-page.jsp">Query Interactions</a></li>
	<li><a href="AboutPage.html">About MiMI</a></li>
	<li><a href="HelpPage.html">Help</a></li>
	</ul>
</div><!-- End mimi-nav div -->
        <div id="displayTable">
<h2><img src="images/Reaction_Details.jpg" alt="Reaction Details" /></h2>
<div id="reaction-content">
<%
    HumDBQueryInterface humdb = HumDBQueryInterface.getInterface() ;
    MetabReaction r = humdb.getReactionDetailsForRid(rid) ;
    if (r == null)
    {

%>
    <p>No such reaction <%=rid%></p>
<%
    }
    else
    {
        String desc = r.getDescription();
        if (desc == null)
        {
            desc = " ";
        }
%>
<h3>Reaction Description:</h3> <%=desc%>
<h3>ReactionID:</h3> <%=r.getRid()%> 
<%
        if (r.getRid().startsWith("RE") == false)
        {
%>
<a href="http://www.genome.jp/dbget-bin/www_bget?rn+<%=r.getRid()%>">View Reaction in KEGG</a>
<%
        }
%>
<div class="shortenWidth">
<h3>Reversible:</h3> <%=r.isReversible()%>
<h3>Reaction Text:</h3> <%=r.getRxntxt()%>
<h3>Equation:</h3> <%=r.getEquation()%>
</div>
<%
    List<StringItem> locs = humdb.getSubcellularLocationsForRid(rid) ;
    if (locs.size() != 0)
    {
%>
<div id="subcell-graph">
<h3>Subcellular Locations:</h3>
<div id="subcellular" style="width:400px;height:200px"></div>
<%
        out.println(FlotUtil.generateSubcellularBarGraph("subcellular", locs)) ;
    }
%>
</div>
<h3>Enzymes for Reaction:</h3>
<%
        for (String e : r.getEnzymes())
        {
            out.println(e) ;
        }
%>
<h3>Genes for Reaction:</h3>
<%

        for (StringItem g : r.getGenes())
        {
            out.println("<a href=\"gene-details-page-front.jsp?geneid=" + g.getId() + "\">" + g.getStr() + "</a>") ;
        }

        List<Compound> compounds = new ArrayList<Compound>() ;
        for (String cid : r.getCompoundIds())
        {
            Compound c = humdb.getCompoundDetailsForCid(cid) ;
            compounds.add(c) ;
        }
        session.setAttribute("compounds", compounds) ;
%>
            <span id="dt-replace-here">
			<p>Data loading from database... <br />
			<image src="images/new_status_bar.gif"></p>
			</span>
        <script type="text/javascript">
            update("update", "/reaction-details-page.jsp", "<%=idparm%>") ;
        </script>
<%
    }
%>
      
        <jsp:include page="mimiFooterInc.html" />
    </body>
</html>
