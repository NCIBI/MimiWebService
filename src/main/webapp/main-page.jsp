<?xml version="1.0"?>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<%@
    page language="java"
    import="org.ncibi.mimiweb.util.Organism"
%>

<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%
	String search = request.getParameter("search") ;
	String taxidString = request.getParameter("taxid") ;
	if ((search != null) && (search.length() == 0)) search = null ;
	String titleExtend = "";
	if (search != null) titleExtend = " - " + search;
	if (taxidString != null) titleExtend += "(" + taxidString + ")";
%>
<html>
   <head>
       <title>MiMI Web - Main Search<%= titleExtend %></title>
       <meta name="description" content="MiMI: (Michigan Molecular Interactions) is part of the NIH funded  National Center for Integrative Biomedical Informatics (NCIBI). MiMI provides access to the knowledge and data from several curated protein interaction databases. MiMI merges these data with deep integration into a single database so that you can query and analyze the information in one. MiMi also provides you with links to the data sources at your point of need." />
       <meta name="keywords" content="MIMI, molecule, interaction, gene, pathway, pudmed, NCIBI, National Center for Integrative Biomedical Informatics, NCBC, ncibi, u54da021519, U54-DA021519, integration, UM, University of Michigan, CCMB, NIH, bioinformatics, computational biology, mimi, NLP, Brian Athey, Jagadish, Omenn, States" />

      <script type='text/javascript' src='<c:url value="/dwr/interface/DisplayTagService.js"/>'></script>
      <script type='text/javascript' src='<c:url value="/dwr/interface/CountWebService.js"/>'></script>
       <script type='text/javascript' src='<c:url value="/dwr/engine.js"/>'></script>
       <script type='text/javascript' src='<c:url value="/dwr/util.js"/>'></script>
       <script type="text/javascript" src="js/ncibi.js"></script>
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

	      function gene2MeshMeshCount()
	      {
				var mesh = document.luceneform.search.value;
	            var taxid = document.luceneform.taxid.value;
	            CountWebService.getHtmlMeshCountForGene2Mesh(mesh, taxid, 
	                      	function(data) 
	                      	{
	            	  			dwr.util.setValue("gene2mesh-mesh-count-here", data, 
	    	            	  			{ escapeHtml:false });
	                      	});
	      }

	      function conceptgenCount()
	      {
		      var searchterm = document.luceneform.search.value;
		      CountWebService.getHtmlConceptCountForConceptgen(searchterm,
				      function(data)
				      {
			      			dwr.util.setValue("conceptgen-count-here", data, { escapeHtml:false });
				      });
	      }

          function gene2MeshGeneCount()
          {
              var gene = document.luceneform.search.value;
              var taxid = document.luceneform.taxid.value;
              CountWebService.getHtmlGeneCountForGene2Mesh(gene, taxid, 
                      	function(data) 
                      	{      			
            	  			dwr.util.setValue("gene2mesh-gene-count-here", data, 
                    	  				{ escapeHtml:false });
                      	});
          }
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
            	<input name="search"  <%= ((search==null)?"":"value=\""+search +"\"") %> />  
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

	  </div> <!-- end mimi-top -->
        <div id="tool-counts">
			<span id="gene2mesh-gene-count-here"></span>
			<span id="gene2mesh-mesh-count-here"></span>
			<span id="conceptgen-count-here"></span>
        </div>

		<div id="mimi-search-results">
            <span id="dt-replace-here">
            </span>
		</div> <!-- end  mimi-search-results-->

<jsp:include page="mimiFooterInc.html" />
</body>
<%	if (search != null) { %>
       <script type="text/javascript">update(); gene2MeshGeneCount(); gene2MeshMeshCount(); conceptgenCount();</script>
<% 	} else { %>
       <script type="text/javascript">showWelcome(); </script>
<% 	
	}
%>
</html>
