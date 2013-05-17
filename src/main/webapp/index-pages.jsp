<%@ page language="java" contentType="text/html; charset=ISO-8859-1"
    pageEncoding="ISO-8859-1"
    import="java.net.URL"
    %>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=ISO-8859-1">
<title>ExampleLinks</title>
</head>
<body>
<%
	String geneidParameter = request.getParameter("geneid") ;
	String interactionidParamter = request.getParameter("interactionid") ;
	String pubmedidParamter = request.getParameter("pubmedid") ;
	String pathwayParamter = request.getParameter("pathwayid") ;
	String molIdParameter = request.getParameter("molid") ;
    String gene1 = request.getParameter("gene1") ;
    String gene2 = request.getParameter("gene2") ;
    String interactionType = request.getParameter("interactionType") ;
    String taxidstr = request.getParameter("taxid") ;

    if (gene1 == null)
    {
        gene1 = "csf1r" ;
    }

    if (gene2 == null)
    {
        gene2 = "cr1" ;
    }

    if (interactionType == null)
    {
        interactionType = "" ;
    }

    if (taxidstr == null)
    {
        taxidstr = "9606" ;
    }
	
	int geneid = 1436;
	if (geneidParameter != null) try { geneid = Integer.parseInt(geneidParameter); } catch (Throwable ignore){}
	int interactionid = 135371;
	if (interactionidParamter != null) try { interactionid = Integer.parseInt(interactionidParamter); } catch (Throwable ignore){}
	int pubmedid = 11297560;
	if (pubmedidParamter != null) try { pubmedid = Integer.parseInt(pubmedidParamter); } catch (Throwable ignore){}
	int pathwayid = 1290;
	if (pathwayParamter != null) try { pathwayid = Integer.parseInt(pathwayParamter); } catch (Throwable ignore){}
	int molId = 108012;
	if (molIdParameter != null) try { pathwayid = Integer.parseInt(molIdParameter); } catch (Throwable ignore){}
	
	String hostname = request.getSession().getServletContext().getInitParameter("external-hostname");
	if ((hostname != null) && (hostname.length() == 0)) hostname = null;
	String serverName = request.getServerName();
	if (hostname != null) serverName = hostname;
	String uri = request.getRequestURI();
	int pos = uri.indexOf("/",1);
	String webappName = "MimiWeb";
	if (pos > 0) {
		webappName = uri.substring(1,pos);
	}
	int port = request.getServerPort();
	String base = (new URL(request.getScheme(),serverName,port,"/" + webappName)).toString();
	if (hostname != null)
		base = "http://" + hostname + "/" + webappName;

	String probePageUrl = base + "/probe.jsp";
	String mainPageUrl = base + "/index.jsp";
    String uploadPageUrl = base + "/upload-page.jsp" ;
    String browsePageUrl = base + "/browse.jsp";
    String helpPageUrl = base + "/HelpPage.html";
    String aboutPageUrl = base + "/AboutPage.html";
	String neighborhoodQueryPageURL = base + "/gene-query-page.jsp";
	String documentListWithGeneIdUrl = base + "/document-list-page-front.jsp?geneid="+geneid;
	String documentListWithInteractionIdUrl = base + "/document-list-page-front.jsp?interactionid="+interactionid;
	String interactionListUrl = base + "/interaction-list-page-front.jsp?geneid="+geneid;
	String pathwayListUrl = base + "/pathway-list-page-front.jsp?geneid="+geneid;
	String moleculeListUrl = base + "/molecule-list-page-front.jsp?geneid="+geneid;
	String geneDetailUrl = base + "/gene-details-page-front.jsp?geneid="+geneid;
	String geneDetailTestPageUrl = base + "/worst-case.jsp";
	String interactionDetailUrl = base + "/interaction-details-page-front.jsp?interactionid="+interactionid;
	String documentDetailUrl = base + "/document-details-page-front.jsp?pubmedid=" + pubmedid;
	String documentDetailUrlNoTag = base + "/document-details-page-front.jsp?pubmedid=" + 18788612;
	String documentDetailUrlNoAbstract = base + "/document-details-page-front.jsp?pubmedid=" + 16708222;
	String interactiveDocUrl = base + "/document-interaction-page.jsp?geneid=" + geneid;
	String interactiveDocUrl2 = base + "/document-interaction-page.jsp?geneid=441519";
	String pathwayDetailUrl = base + "/pathway-details-page-front.jsp?pathwayid=" + pathwayid;
	String moleculeDetailUrl = base + "/molecule-details-page-front.jsp?moleculeid="+molId;
    String interactionQueryUrl = base + "/interaction-query-page.jsp?gene1=" + gene1 
                + "&gene2=" + "&taxid=" + taxidstr 
                + "&interactionType=" + interactionType ;
    String pathwayQueryUrl = base + "/pathway-query-page.jsp?gene1=" + gene1 
                + "&gene2=" + gene2 + "&taxid=" + taxidstr ;
    String cytoscapeLinkURL = base + "/show-interaction.jsp?interactionid=" + interactionid;
%>
<h2>Development Test Page.</h2>
This is the test site for MimiWeb development. To get to the 'front page' of the site, use the Main Page link, below.<br />
<h3>Site pages</h3>
<h4>Parameters (enter these on the URL to change their value(s)</h4>
<ul>
<li>geneid = <%= geneid %></li>
<li>interactionid = <%= interactionid %></li>
<li>pubmedid = <%= pubmedid %></li>
<li>pathwayid = <%= pathwayid %></li>
<li>molid = <%= molId %></li>
</ul>
<b><u>Top Pages and Query pages</u></b>
<ul>
<li>Main page (Free Text Search): <a href="<%= mainPageUrl %>"><%= mainPageUrl %></a></li>
<li>Gene List and File Upload page: <a href="<%= uploadPageUrl %>"><%= uploadPageUrl %></a></li>
<li>Interaction query page: <a href="<%= interactionQueryUrl %>"><%= interactionQueryUrl %></a></li>
<li>Browse page: <a href="<%= browsePageUrl %>" ><%= browsePageUrl %></a></li>
<li>About page: <a href="<%= aboutPageUrl %>" ><%= aboutPageUrl %></a></li>
<li>Help page: <a href="<%= helpPageUrl %>" ><%= helpPageUrl %></a></li>
<li>*Gene Neighborhood-Query page: <a href="<%= neighborhoodQueryPageURL %>"><%= neighborhoodQueryPageURL %></a></li>
<li>Used by Cytoscape Link-Out: <a href="<%=cytoscapeLinkURL %>"><%=cytoscapeLinkURL %></a></li>
<li>*Test probe page: <a href="<%= probePageUrl %>"><%= probePageUrl %></a></li>
</ul>
<b><u>Gene Pages</u></b>
<ul>
<li>Gene detail page: <a href="<%= geneDetailUrl %>"><%= geneDetailUrl %></a></li>
<li>Gene detail overflow test page: <a href="<%= geneDetailTestPageUrl %>"><%= geneDetailTestPageUrl %></a></li>
</ul>
<b><u>Interaction Pages</u></b>
<ul>
<li>Interaction list page: <a href="<%= interactionListUrl %>"><%= interactionListUrl %></a></li>
<li>Interaction detail page: <a href="<%= interactionDetailUrl %>"><%= interactionDetailUrl %></a></li>
<li>Interaction query page: <a href="<%= interactionQueryUrl %>"><%= interactionQueryUrl %></a></li>
</ul>
<b><u>Document Pages</u></b>
<ul>
<li>Document list (with GeneId) page: <a href="<%= documentListWithGeneIdUrl %>"><%= documentListWithGeneIdUrl %></a></li>
<li>Document list (with InteractionId) page: <a href="<%= documentListWithInteractionIdUrl %>"><%= documentListWithInteractionIdUrl %></a></li>
<li>Document detail page: <a href="<%= documentDetailUrl %>"><%= documentDetailUrl %></a></li>
<li>*Interactive Document page: <a href="<%= interactiveDocUrl %>"><%= interactiveDocUrl %></a></li>
<li>*Interactive Document short page: <a href="<%= interactiveDocUrl2 %>"><%= interactiveDocUrl2 %></a></li>
<li>*Special Case - Detail, No tags: <a href="<%= documentDetailUrlNoTag %>"><%= documentDetailUrlNoTag %></a></li>
<li>*Special Case - Detail, No abstract: <a href="<%= documentDetailUrlNoAbstract %>"><%= documentDetailUrlNoAbstract %></a></li>
</ul>
<b><u>Pathway Pages</u></b>
<ul>
<li>Pathway list page: <a href="<%= pathwayListUrl %>"><%= pathwayListUrl %></a></li>
<li>Pathway detail page: <a href="<%= pathwayDetailUrl %>"><%= pathwayDetailUrl %></a></li>
<li>Pathway query page: <a href="<%= pathwayQueryUrl %>"><%= pathwayQueryUrl %></a></li>
</ul>
<b><u>Molecule Pages</u></b>
<ul>
<li>*Molecule list page: <a href="<%= moleculeListUrl %>"><%= moleculeListUrl %></a></li>
<li>*Molecule detail page: <a href="<%= moleculeDetailUrl %>"><%= moleculeDetailUrl %></a></li>
</ul>
* These pages are not currently used in the site.

<h3>MimiWeb Site, Test Plan:</h3>
<ol>
<li>Click on the "Test Probe" link, above. You should see a successful 
connection to the Lucene interface and to the Database. Also, this page
will 'query' for key object types from the Hibernate/Database. Failures appear as red text on the page.</li>
<li>Click on each of the links that does not have an asterisk (*), each of these pages should display results.
Errors will be obvious: the page will produce an error message or worse.</li>
</ol>
</body>
</html>
