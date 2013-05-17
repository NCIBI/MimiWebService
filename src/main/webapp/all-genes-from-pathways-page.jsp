<%@ taglib uri="http://displaytag.sf.net" prefix="display" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ page import="org.ncibi.mimiweb.hibernate.PathwayQueryInterface,
                java.util.ArrayList,
                org.ncibi.mimiweb.lucene.LuceneInterface,
                org.ncibi.lucene.MimiLuceneFields,
                org.ncibi.mimiweb.data.*"
%>

<%
    String geneid = request.getParameter("geneid") ;
    PathwayQueryInterface pq = PathwayQueryInterface.getInterface() ;
    ArrayList<GenePathwayParticipant> p = pq.getPathwaysAndGenesInForGene(Integer.parseInt(geneid)) ;
    String search = null ;
    boolean firstTime = true ;
    for (GenePathwayParticipant gp : p)
    {
        if (firstTime)
        {
            search = MimiLuceneFields.FIELD_GENEID + ":" + gp.getId() ;
            firstTime = false ;
        }
        else
        {
            search += " OR " + MimiLuceneFields.FIELD_GENEID + ":" + gp.getId() ;
        }
    }
%>

<html>
   <head>
       <title>MiMI Web - Genes in Gene Pathways</title>
       <script type='text/javascript' src='<c:url value="/dwr/interface/DisplayTagService.js"/>'></script>
       <script type='text/javascript' src='<c:url value="/dwr/engine.js"/>'></script>
       <script type='text/javascript' src='<c:url value="/dwr/util.js"/>'></script>
       <script type="text/javascript" src="js/ncibi.js"></script>
       <link rel="stylesheet" type="text/css" href='<c:url value="/css/displaytag.css"/>' />
       <script type="text/javascript">
           function update() {
               html = "<p>Searching...<br/><image src=\"images/new_status_bar.gif\"/>" ;
               dwr.util.setValue("dt-replace-here", html, { escapeHtml:false }) ;
               val = "search=<%=search%>" ;
               val += "&taxid=-1" ;
               DisplayTagService.updateLinks("update2","/main-page-search-table.jsp", val, ncibi_callback);
           }

          function update2(js, jsp, criteria) {
              DisplayTagService.updateLinks(js, jsp, criteria, ncibi_callback);
          }
       </script>
</head>
<body>
<jsp:include page="mimiHeaderInc.html" />
		<div id="mimi-search-results">
            <span id="dt-replace-here">
            </span>
		</div> <!-- end  mimi-search-results-->
<jsp:include page="mimiFooterInc.html" />
</body>
<%	if (search != null) { %>
       <script type="text/javascript">update(); </script>
<% 	}%>
</html>
