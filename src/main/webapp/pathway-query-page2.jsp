<?xml version="1.0"?>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<%@ page import="org.ncibi.mimiweb.util.Organism,
	org.ncibi.mimiweb.util.FileUploadHelper,
	org.ncibi.mimiweb.util.GeneExtraction,
	org.apache.commons.fileupload.servlet.ServletFileUpload,
	java.util.ArrayList, java.util.Iterator, java.io.File" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<html>
   <head>
       <title>MiMI Web - Gene List Search page</title>
       <script type='text/javascript' src='<c:url value="/dwr/interface/DisplayTagService.js"/>'></script>
       <script type='text/javascript' src='<c:url value="/dwr/engine.js"/>'></script>
       <script type='text/javascript' src='<c:url value="/dwr/util.js"/>'></script>
       <script type="text/javascript" src="js/ncibi.js"></script>
       <link rel="stylesheet" type="text/css" href='<c:url value="/css/displaytag.css"/>' />
       <script type="text/javascript">
          function fireQuery(val) 
          {
              html = "<p>Searching...<br/><image src=\"images/new_status_bar.gif\"/>" ;
              dwr.util.setValue("dt-replace-here", html, { escapeHtml:false }) ;
              val2 = "search="+val ;
              DisplayTagService.updateLinks("updateTable", "/pathway-query-table2.jsp", 
                                               val2, ncibi_callback) ;
          }

          function updateTable(js, jsp, criteria) 
          {
              html = "<p>Searching...<br/><image src=\"images/new_status_bar.gif\"/>" ;
              dwr.util.setValue("dt-replace-here", html, { escapeHtml:false }) ;
              DisplayTagService.updateLinks(js, jsp, criteria, ncibi_callback) ;
          }
       </script>
<%
String geneList = request.getParameter("genelist");
String listType = request.getParameter("typeselection");
String taxidString = request.getParameter("taxid");

String[] geneArray = null;

ArrayList<String> uploaded = null;
ArrayList<String> items = null;
boolean typeIsSymbol = true; // default
int taxid = -1;
String escapedQueryText = null;

if (taxidString != null){
	try {
		taxid = Integer.parseInt(taxidString);
	} catch (Throwable ignore) {}
}

if (ServletFileUpload.isMultipartContent(request)) {
    //System.out.println("in ServletFileUpload.isMultipartContent") ;
	GeneExtraction genes = FileUploadHelper.extractGenes(request);
    //System.out.println("genes.getType() = " + genes.getType()) ;
	if (genes.getType() == GeneExtraction.SYMBOL_LIST)
    {
        //System.out.println("calling genes.getGeneSymbolList()") ;
		items = genes.getGeneSymbolList();
    }
	else if (genes.getType() == GeneExtraction.ID_LIST)
    {
        //System.out.println("getType != GeneExtraction.SYMBOL_LIST") ;
		typeIsSymbol = false;
		items = new ArrayList<String>();
		for (Integer id: genes.getGeneIdList()) 
        {
            //System.out.println("   geneid = " + id) ;
            items.add(id.toString());
        }
	}
}

if (geneList != null) {
	geneArray = geneList.trim().split("\n");
	if (listType != null)
		typeIsSymbol = listType.equals("symbol");
}

if (geneArray != null) {
	escapedQueryText = FileUploadHelper.buildQuery(geneArray, typeIsSymbol, taxid);	
}
%>
</head>
<body>
<jsp:include page="mimiHeaderInc.html" />

<div id="mimi-wrapper">
	<div id="mimi-nav">
		<ul>
			<li><a href="main-page.jsp">Free Text Search</a></li>
			<li><a href="upload-page.jsp" id="current">List Search</a></li>
			<li><a href="interaction-query-page.jsp">Query Interactions</a></li>
			<li><a href="AboutPage.html">About MiMI</a></li>
			<li><a href="HelpPage.html">Help</a></li>
		</ul>
	</div> <!-- End mimi-nav div -->
	  <div id="mimi-top-2">
	    <div id="mimi-search-form-2">
		<div id="bd"><!-- AutoComplete begins -->
	    <div id="divmain">
<form action="" method="get">
<div id="search-field-2">
List of genes to search for:<br />
<textarea name="genelist">
<%
    //System.out.println("in text area") ;
	if (items != null) {
        //System.out.println("items != null") ;
		for (String s: items) {
            //System.out.println("s = " + s) ;
			out.println(s.trim());
		}
	} else if (geneArray != null) {
        //System.out.println("geneArray != null") ;
		for (String s: geneArray) {
			out.println(s.trim());
		}
	} 
    else
    {
        //System.out.println("textarea no matches") ;
    }

%>
</textarea>
Type or insert a list of gene names or gene id values into text box.
</div> <!-- end search-field-2 -->
<div id="search-gene-type">
	Select type: <br />
	<input type="radio" name="typeselection" value="symbol" <%= (typeIsSymbol)?"checked":"" %> />symbols <br />
	<input type="radio" name="typeselection" value="id" <%= (!typeIsSymbol)?"checked":"" %> />id values <br /> <br />
	<input type="submit" value="MiMI Search" /><br /> <br />
</div> <!-- end search-gene-type -->
<div id="filter-field-2">
Limit Search by Organism: 
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
</div> <!-- end filter-field-2 -->
<% 				if ((escapedQueryText != null) && (escapedQueryText.length() > 0)) { %>
<input type="hidden" name="query" value="<%= escapedQueryText %>" />
<% 				} %>
</form>
<div id="upload-gene-list">
Upload Gene List <br />
<form action="" enctype="multipart/form-data" method="post"> 
	<input type="file" name="filename" />
    <input type="submit" value="Copy to Text Box" /><br /><br />
    <b>Optional:</b> Upload a text file. File should contain a list of gene symbols or gene id values; one entry per line.
</div> <!-- end upload-gene-list -->
    </div> <!-- end of devmain -->
</div> <!-- end of db -->
	    </div><!--  end  mimi-search-form-2 -->
	  </div><!--  end mimi-top-->
</div> <!-- end mimi-wrapper -->
<div id="mimi-search-results">
	<div id="dt-replace-here">
	</div> 
</div>


<jsp:include page="mimiFooterInc.html" />
</body>
<%	if (escapedQueryText != null) { %>
       <script type="text/javascript">
       		queryValue = "<%=escapedQueryText%>";
       		fireQuery(queryValue); 
		</script>
<% 	}%>
</html>
