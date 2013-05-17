<%@
    page language="java"
    import="org.ncibi.mimiweb.util.Organism,
    java.util.ArrayList"
%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%
    String geneSymbol1 = request.getParameter("gene1") ;
    String geneSymbol2 = request.getParameter("gene2") ;
    String taxidString = request.getParameter("taxid") ;
	
    if ((geneSymbol1 != null) && (geneSymbol1.length() == 0)) 
    {
        geneSymbol1 = null ;
    }

    if ((geneSymbol2 != null) && (geneSymbol2.length() == 0)) 
    {
        geneSymbol2 = null ;
    }
    String titleExtend = " ";
	
    if ((geneSymbol1 != null) && (geneSymbol2 != null)) 
    {
        titleExtend += geneSymbol1 + " & " + geneSymbol2;
    } 
    else if (geneSymbol1 != null) 
    {
        titleExtend += geneSymbol1;		
    } 
    else if (geneSymbol2 != null) 
    {
        titleExtend += geneSymbol2;		
    }

    int taxid = 9606 ;
    try
    {
        taxid = Integer.parseInt(taxidString) ;
    }
    catch (Throwable ignore) 
    {
        taxid = 9606 ;
    }

%>
<html>
    <head>
    <title>MiMI Web - Main Search<%= titleExtend %></title>
    <script type='text/javascript' 
        src='<c:url value="/dwr/interface/DisplayTagService.js"/>'></script>
    <script type='text/javascript' src='<c:url value="/dwr/engine.js"/>'></script>
    <script type='text/javascript' src='<c:url value="/dwr/util.js"/>'></script>
    <script type="text/javascript" src="js/ncibi.js"></script>
    <link rel="stylesheet" type="text/css" href='<c:url value="/css/displaytag.css"/>' />
    <script type="text/javascript">
        function updatePathways() 
        {
            html = "<p>Searching...<br/><image src=\"images/new_status_bar.gif\"/>" ;
            dwr.util.setValue("dt-replace-here", html, { escapeHtml:false }) ;
            var val = "gene1=" + document.pathwayform.gene1.value ;
            val += "&gene2=" + document.pathwayform.gene2.value ;
            val += "&taxid=" + document.pathwayform.taxid.value ;
            DisplayTagService.updateLinks("updatePathways2","/pathway-query-table.jsp", 
                                            val, ncibi_callback) ;
        }

        function updatePathways2(js, jsp, criteria) 
        {
            DisplayTagService.updateLinks(js, jsp, criteria, ncibi_callback) ;
        }
    </script>
    </head>
<body>

<jsp:include page="mimiHeaderInc.html" />
    <div id="mimi-wrapper">
    <div id="interaction-query-top">

    <div id="interaction-query-search-form">
        <form name="pathwayform" method="get" action="">
            <div id="gene1-field">     
                Gene 1: <input name="gene1"  
                        <%= ((geneSymbol1==null)?"":"value=\""+geneSymbol1 +"\"") %> />  
            </div>
            <div id="gene2-field">     
                Gene 2: <input name="gene2"  
                        <%= ((geneSymbol2==null)?"":"value=\""+geneSymbol2 +"\"") %> />  
            </div>

            <div id="interaction-query-field-bottom">
		    	Looks for Pathways containing both genes. Example: gene1 = CSF1R, gene2 = CBL
                <br />
		    	<input id="interaction-query-button" type="submit" value="MiMI Pathway Query" />
            </div>

            <div id="filter-field-1a">
<%
                String[][] orgs = Organism.organismArray;
                int sel = 1;

                if ((taxidString != null) && (taxidString.equals("-1")))
                {
                    sel = 0;
                }
                else if (taxidString != null)
                {
                    for (int i = 0; i < orgs.length; i++)
                    {
                        if (taxidString.equals(orgs[i][1]))
                        {
                            sel = i;
                            break;
                        }
                    }
                }
%>
                Organism: <select name="taxid">
<%
                for (int i = 0; i < orgs.length; i++)
                {
                    if (i == sel)
                    {
%>
                        <option value="<%= orgs[i][1] %>" selected ><%= orgs[i][0] %></option>
<%
                    }
                    else
                    {
%>
                        <option value="<%= orgs[i][1] %>" ><%= orgs[i][0] %></option>
<%
                    }
                }
%>
                </select>
		    </div> <!-- end filter-field-1a -->

			<div id="filter-field-1b">

            </div> <!-- end filter-field-1b -->

        </form>
	        	
    </div> <!-- end interaction-query-search-form -->

    </div> <!-- end interaction-query-top -->

        <div id="mimi-search-results">
            <span id="dt-replace-here"></span>
        </div> <!-- end  mimi-search-results-->

	</div> <!-- end mimi-wrapper -->

<jsp:include page="mimiFooterInc.html" />
</body>
<%	
    if (taxidString != null && geneSymbol1 != null && geneSymbol2 != null) 
    {
%>
        <script type="text/javascript">
            updatePathways();
        </script>
<% 	
    } 
%>
</html>
