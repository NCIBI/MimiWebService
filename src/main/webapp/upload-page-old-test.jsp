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
               val2 = "search="+val ;
               DisplayTagService.updateLinks("updateTable", "/main-page-search-table.jsp", 
                                                val2, ncibi_callback) ;
           }

           function updateTable(js, jsp, criteria) 
           {
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
String escapedQueryText = "";

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
	<div id="bd"><!-- AutoComplete begins -->
	    <div id="divmain">
<h3>Search for gene list</h3>
Search using a list of gene symbols or gene id values.. <br />
Optionally, use the form on the right to submit a file to be inserted into the "list of..." area, below.<br />
Or, just type list of gene symbols or geneid values in the text area, on seperate lines.
<table border="1"><tr><td>
<form action="" method="post">
<table>
<tr><td>
List of genes to search for:<br />
<textarea cols="30" rows="10" name="genelist">
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
</td><td>
Select type: <br />
<input type="radio" name="typeselection" value="symbol" <%= (typeIsSymbol)?"checked":"" %> />symbols <br />
<input type="radio" name="typeselection" value="id" <%= (!typeIsSymbol)?"checked":"" %> />id values <br />
<input type="submit" value="Search" />
</td></tr>
<tr><td colspan="2">
Filter by Organism: 
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
</td></tr>
</table>
<% 				if ((escapedQueryText != null) && (escapedQueryText.length() > 0)) { %>
<input type="hidden" name="query" value="<%= escapedQueryText %>" />
<% 				} %>
</form>
</td>
<td>
<form action="" enctype="multipart/form-data" method="post"> 
	<b>Optional upload:</b> Select text file for upload. File should contain a list of
	either gene symbols or gene id values; one entry per line. <br />
    <input type="file" name="filename" />
    <input type="submit" value="upload" />
</form>
</td></tr>
</table>
<hr />
This is just a temporary (debugging) display of results: <br />
<%
	if (geneList != null) {
%>
Organism id: <%= taxid %> <br />
List type: <%= listType %> <br />
Query text: <%= escapedQueryText %> <br />
<%		
	} else {
%>
No gene list. <br />
<%= (items == null)?"No file upload.":"File upload with " + items.size() + " items" %><br />
<%		
	}
%>
<hr />
		<div name="dt-replace-here" />
<% 				if ((escapedQueryText != null) && (escapedQueryText.length() > 0)) { 
                    out.println("WOULD FIRE escapedQueryText = '" + escapedQueryText + "'") ;
%>
<br /><b>Fire script.</b><br />
<script language='Javascript'>
<!--alert('trying to launch query and results!');-->
fireQuery("<%=escapedQueryText%>");
</script>
<% 				} else { 
                    out.println("NO FIRE escapedQueryText = '" + escapedQueryText + "'") ;
                } %>
<!--  if you uncomment this is will run the script, so why not the one above?
<script language='Javascript'>
alert("this works");
</script>
 -->
	    </div> <!-- end of devmain -->
	</div> <!-- end of db -->
<jsp:include page="mimiFooterInc.html" />
</body>
</html>
