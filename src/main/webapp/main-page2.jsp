<?xml version="1.0"?>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<%@
    page language="java"
    import="java.util.ArrayList,
            org.ncibi.mimiweb.util.WebApp,
            org.ncibi.mimiweb.util.Organism,
            org.ncibi.mimiweb.breadcrumbs.*"
%>

<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%
    BreadcrumbBean bb = (BreadcrumbBean) session.getAttribute("Breadcrumbs") ;
    String host = request.getLocalName() ;
    if (bb == null)
    {
        bb = new BreadcrumbBean() ;
        bb.addBreadcrumb("Home", WebApp.constructWebAppPath(request, "main-page2.jsp")) ;
        session.setAttribute("Breadcrumbs", bb) ;
    }

    BreadcrumbBean searchCrumb = (BreadcrumbBean) session.getAttribute("Searchcrumbs") ;
    if (searchCrumb == null)
    {
        searchCrumb = new BreadcrumbBean("searchCrumb0") ;
        searchCrumb.addBreadcrumb("Searches", 
            WebApp.constructWebAppPath(request, "main-page2.jsp")) ;
        session.setAttribute("Searchcrumbs", searchCrumb) ;
    }

	String search = request.getParameter("search") ;
	String taxidString = request.getParameter("taxid") ;
	if ((search != null) && (search.length() == 0)) search = null ;
	String titleExtend = "";
	if (search != null) titleExtend = " - " + search;
	if (taxidString != null) titleExtend += "(" + taxidString + ")";

    if (search != null)
    {
        String searchUrl = "main-page2.jsp?search="+search ;
        String searchStr = "Search:("+search ;
        if (taxidString != null)
        {
            searchUrl += "&taxid=" + taxidString ;
            searchStr += ";taxid:" ;
            if (taxidString.equals("-1"))
            {
                searchStr += "all" ;
            }
            else
            {
                if ((! search.contains("AND taxid:")) && (! search.contains("geneid:")))
                {
                    searchStr += taxidString ;
                }
            }
        }
        searchStr += ")" ;
        searchCrumb.addUniqueBreadcrumb(searchStr, 
            WebApp.constructWebAppPath(request, searchUrl)) ;
    }
%>
<html>
   <head>
       <title>MiMI Web - Main Search<%= titleExtend %></title>
       <meta name="description" content="MiMI: (Michigan Molecular Interactions) is part of the NIH funded  National Center for Integrative Biomedical Informatics (NCIBI). MiMI provides access to the knowledge and data from several curated protein interaction databases. MiMI merges these data with deep integration into a single database so that you can query and analyze the information in one. MiMi also provides you with links to the data sources at your point of need." />
       <meta name="keywords" content="MIMI, molecule, interaction, gene, pathway, pudmed, NCIBI, National Center for Integrative Biomedical Informatics, NCBC, ncibi, u54da021519, U54-DA021519, integration, UM, University of Michigan, CCMB, NIH, bioinformatics, computational biology, mimi, NLP, Brian Athey, Jagadish, Omenn, States" />

      <script type='text/javascript' src='<c:url value="/dwr/interface/DisplayTagService.js"/>'></script>
       <script type='text/javascript' src='<c:url value="/dwr/engine.js"/>'></script>
       <script type='text/javascript' src='<c:url value="/dwr/util.js"/>'></script>
       <script type="text/javascript" src="js/ncibi.js"></script>
        <script type='text/javascript' src="http://code.jquery.com/jquery-latest.js"></script>
        <script type='text/javascript' src="js/jquery.easing.1.3.js"></script>
        <script type='text/javascript' src="js/jquery.jBreadCrumb.js"></script>
        <script type='text/javascript' src="js/jquery.highlight-2.js"></script>
        <!-- <link rel="stylesheet" href="css/Base.css" type="text/css"> -->
        <link rel="stylesheet" href="css/BreadCrumb.css" type="text/css">
        <link rel="stylesheet" href="http://dev.jquery.com/view/trunk/plugins/autocomplete/jquery.autocomplete.css" type="text/css" />
        <script type="text/javascript" src="http://dev.jquery.com/view/trunk/plugins/autocomplete/lib/jquery.bgiframe.min.js"></script>
        <script type="text/javascript" src="http://dev.jquery.com/view/trunk/plugins/autocomplete/lib/jquery.dimensions.js"></script>
        <script type="text/javascript" src="http://dev.jquery.com/view/trunk/plugins/autocomplete/jquery.autocomplete.js"></script>
       <link rel="stylesheet" type="text/css" href='<c:url value="/css/displaytag.css"/>' />
       <script type="text/javascript">
       	   function showWelcome()
       	   {
       			DisplayTagService.updateLinks("","/welcome.html","",ncibi_callback)
       	   }
           function update() 
           {
               html = "<p>Searching...<br/><image src=\"images/new_status_bar.gif\"/></p>" ;
               dwr.util.setValue("dt-replace-here", html, { escapeHtml:false }) ;
               val = "search=" + document.luceneform.search.value ;
               val += "&taxid=" + document.luceneform.taxid.value ;
               DisplayTagService.updateLinks("update2","/main-page-search-table.jsp", val, ncibi_callback) ;
           }

          function update2(js, jsp, criteria) 
          {
              DisplayTagService.updateLinks(js, jsp, criteria, ncibi_callback) ;
          }

           $().ready(function() {

               $("#search").autocomplete("gene-symbol-autocomplete.jsp", {
                        width: 260,
                        selectFirst: false,
                        formatItem: function(data, i, total) {
                                        return data[0];
                                    }
               });
               jQuery("#breadCrumb0").jBreadCrumb();
               jQuery("#searchCrumb0").jBreadCrumb();
           }) ;

       </script>
</head>
<body>
<jsp:include page="mimiHeaderInc.html" />
<div id="mimi-nav">
	<ul>
	<li><a href="main-page.jsp" id="current">Free Text Search</a></li>
	<li><a href="upload-page.jsp">List Search</a></li>
	<li><a href="interaction-query-page.jsp">Query Interactions</a></li>
	<li><a href="AboutPage.html">About MiMI</a></li>
	<li><a href="HelpPage.html">Help</a></li>
	</ul>
</div><!-- End mimi-nav div -->
	
<div id="mimi-top">
	   
  <div id="mimi-search-form">
	        <form name="luceneform" method="get" action="">
    <div id="search-field">     
            	<input id="search" name="search"  <%= ((search==null)?"":"value=\""+search +"\"") %> />  
    </div> <!-- end search-field -->
    <div id="search-field-bottom">
			Example: pwp1 <input id="search-button" type="submit" value="MiMI Search" />
    </div> <!-- end search-field-bottom -->
    
    <div id="filter-field">
				<%				String[][] orgs = Organism.organismArray;
				int sel = 1;

				if ((taxidString != null) && (taxidString.equals("-1"))) sel = 0; 
				else if (taxidString != null) {
					for (int i = 0; i < orgs.length; i++) {
						if (taxidString.equals(orgs[i][1])) sel = i;
					}
				}
%>            	<select name="taxid">
<%				for (int i = 0; i < orgs.length; i++) {
					if (i == sel) {
%>            			<option value="<%= orgs[i][1] %>" selected ><%= orgs[i][0] %></option>
<%					} else { 
%>            			<option value="<%= orgs[i][1] %>" ><%= orgs[i][0] %></option>
<%					}
				} 
%>            	</select>
    </div> <!-- end filter-field -->
    <div id="filter-field-bottom">
				Limit Search by Organism
    </div> <!-- end filter-field-bottom -->


	        </form>
	        	
  </div> <!-- end mimi-search-form -->

    <% out.println(bb.generateBreadcrumbTrail()) ; %>
    <% out.println(searchCrumb.generateBreadcrumbTrail()) ; %>
    <div class="chevronOverlay main"></div>


	  </div> <!-- end mimi-top -->
<a href="javascript:void($('#highlight-here').removeHighlight().each(function() { $.highlight(this, '<%=search%>'.toUpperCase())}))">Highlight Search Term</a>
<a href="javascript:void($('#highlight-here').removeHighlight())">Remove Highlight</a>
		<div id="mimi-search-results">
<div id="highlight-here">
            <span id="dt-replace-here">
            </span>
</div>
		</div> <!-- end  mimi-search-results-->

<jsp:include page="mimiFooterInc.html" />
</body>
<%	if (search != null) { %>
        <script type="text/javascript">
                update(); 
        </script>
<% 	} else { %>
       <script type="text/javascript">showWelcome(); </script>
<% 	
	}
%>
</html>
