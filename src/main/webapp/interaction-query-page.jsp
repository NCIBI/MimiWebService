<?xml version="1.0"?>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<%@
    page language="java"
    import="org.ncibi.mimiweb.util.Organism,
    org.ncibi.mimiweb.util.InteractionTypes,
    java.util.ArrayList"
%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%
    String geneSymbol1 = request.getParameter("gene1") ;
    String geneSymbol2 = request.getParameter("gene2") ;
    String taxidString = request.getParameter("taxid") ;
    String interactionType = request.getParameter("interactionType") ;
	
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

    if (interactionType != null) 
    {
        titleExtend += " - " + interactionType;
    }

    if (taxidString != null) 
    {
        titleExtend += "(" + taxidString + ")";
    }

    int taxid = -1;
    try 
    {
        taxid = Integer.parseInt(taxidString);
    } 
    catch (Throwable ignore) {}
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
        function updateInteraction() 
        {
            html = "<p>Searching...<br/><image src=\"images/new_status_bar.gif\"/>" ;
            dwr.util.setValue("dt-replace-here", html, { escapeHtml:false }) ;
            val = "interactionType=" + document.interactionform.interactionType.value ;
            val += "&taxid=" + document.interactionform.taxid.value ;
            val += "&gene1=" + document.interactionform.gene1.value ;
            val += "&gene2=" + document.interactionform.gene2.value ;
            DisplayTagService.updateLinks("updateInteraction2","/interaction-query-table.jsp", 
                val, ncibi_callback);
        }

        function updateInteraction2(js, jsp, criteria) 
        {
            DisplayTagService.updateLinks(js, jsp, criteria, ncibi_callback) ;
        }
    </script>
    </head>
<body>
<jsp:include page="mimiHeaderInc.html" />

    <div id="mimi-wrapper">
    <div id="mimi-nav">
<ul>
<li><a href="main-page.jsp">Free Text Search</a></li>
<li><a href="upload-page.jsp">List Search</a></li>
<li><a href="interaction-query-page.jsp" id="current"> Query Interactions</a></li>
<li><a href="AboutPage.html">About MiMI</a></li>
<li><a href="HelpPage.html">Help</a></li>
</ul>
</div>
<!-- End mimi-nav div -->
    <div id="interaction-query-top">
    <div id="interaction-query-search-form">
        <form name="interactionform" method="get" action="">
            <div id="gene1-field">     
                Gene 1: <input name="gene1"  
                        <%= ((geneSymbol1==null)?"":"value=\""+geneSymbol1 +"\"") %> />  
            </div>
            <div id="gene2-field">     
                Gene 2: <input name="gene2"  
                        <%= ((geneSymbol2==null)?"":"value=\""+geneSymbol2 +"\"") %> />                             
            </div>
            <div id="interaction-query-field-button">
            <input id="interaction-query-button" type="submit" value="MiMI Interaction Query" />
            </div>         
            <div id="interaction-query-field-example">
		    	Example:
		    	<br /> 
		    	Gene 1 = CSF1R
		    	<br />
		    	Gene 2 = CBL 
		    	<br /> <br />
		    	Blank entries are treated as a 'wild card'.
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
                <select name="taxid">
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
                <select name="interactionType">
                    <option value="">all interaction types</option>
<%
                String selectionString = (interactionType == null)?"":interactionType;
                ArrayList<String> iTypes = InteractionTypes.getInteractionTypesList();
                for (String type: iTypes) 
                {
                    if (selectionString.equals(type)) 
                    {
%>            			
                        <option value="<%= type %>" selected ><%= type %></option>
<%					
                    } 
                    else
                    {
%>            			
                        <option value="<%= type %>" ><%= type %></option>
<%					
                    }
				} 
%>            	
                </select>

            </div> <!-- end filter-field-1b -->

            <div id="filter-field-bottom-1">
                Limit Search by Organism and/or Interaction Type
            </div>

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
    if (interactionType != null) 
    {
%>
        <script type="text/javascript">
            updateInteraction();
        </script>
<% 	
    } 
%>
</html>
