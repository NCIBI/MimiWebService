<%@ page language="java" contentType="text/html; charset=ISO-8859-1"
    pageEncoding="ISO-8859-1"
    import="org.ncibi.mimiweb.util.PropertiesUtil,
    org.ncibi.mimiweb.lucene.LuceneInterface,
    org.ncibi.mimiweb.hibernate.HibernateInterface,
    org.ncibi.mimiweb.data.ResultGeneMolecule,
    org.ncibi.db.factory.GeneSessionFactory,
    org.ncibi.db.gene.Taxonomy,
    org.ncibi.db.pubmed.Document,
	org.ncibi.mimiweb.data.MoleculeRecord,
	org.ncibi.mimiweb.util.DocPageUtil,
	org.ncibi.mimiweb.util.QuickProbe,
	org.ncibi.db.factory.DatabaseUrlFactory,
	org.hibernate.Session,
    java.util.ArrayList,
    java.util.Properties,
    java.util.Collections,
    java.util.Enumeration"
    %>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=ISO-8859-1">
<title>Debugging - probes Lucene and Database</title>
</head>
<body>
<%
	LuceneInterface l = LuceneInterface.getInterface();
	HibernateInterface h = HibernateInterface.getInterface();
	String lucene = request.getParameter("lucene") ;
	String hibernate = request.getParameter("hibernate") ;
	String hostname = request.getSession().getServletContext().getInitParameter("external-hostname");
	String serverName = request.getServerName();
	if (hostname != null) serverName = hostname;
	int port = request.getServerPort();
	String uri = request.getRequestURI();
	int pos = uri.indexOf("/",1);
	String webappName = "unspecified";
	if (pos > 0) {
		webappName = uri.substring(1,pos);
	}

	
%>
	<h3>General</h3>
	Request server name = <%= request.getServerName() %><br />
	Request server port = <%= request.getServerPort() %> <br />
	Request 'local' name = <%= request.getLocalName() %> <br />
	Request 'local' port = <%= request.getLocalPort() %> <br />
	Request URI = <%= request.getRequestURI() %><br />
	Request set header 'Host' = <%= request.getHeader("Host") %> <br />
	Context parameter 'external-hostname' <%= (hostname == null)?" is unspecified":" = " + hostname %> <br />
	Name of webapp is <%= webappName %> <br />
	<h3>Properties probe</h3>
<%
	ArrayList<String> dbNamesList = new ArrayList<String>();
	try {
		Properties test = PropertiesUtil.getProperties();

		if (test == null) {
%>
			<font color="red">Properties file is null.</font><br />		
<%		
		} else {
			Enumeration<String> keys = (Enumeration<String>) test.propertyNames();
			if (keys == null ) {
%>
				<font color="red">Properties file key set is null.</font><br />		
<%		
			}
			else if (! keys.hasMoreElements()) 
			{
%>
				<font color="red">Properties file key set is empty.</font><br />		
<%		
			} else {
				keys = (Enumeration<String>) test.propertyNames();
				ArrayList<String> keyList = new ArrayList();
				while (keys.hasMoreElements()){
					keyList.add(keys.nextElement());
				}
				Collections.sort(keyList);
%>
				Properties are...
				<ul>
<%				
				for (String key: keyList) {
%>
					<li><%= key %>:: <%= test.getProperty(key)%></li>		
<%						
				}
%>
				</ul>
<%		
			}
		}
	} catch (Throwable t) {
%>	
		Exception on properties probe: <%= t.getMessage() %>
<%
	}
	
%>
Database properties, with default shadowing, are... 
<%	String[] dbNames = {
		PropertiesUtil.DATABASE_SYMBOL_DEFAULT,
		PropertiesUtil.DATABASE_SYMBOL_MIMI,
		PropertiesUtil.DATABASE_SYMBOL_GENE,
		PropertiesUtil.DATABASE_SYMBOL_PUBMED,
		PropertiesUtil.DATABASE_SYMBOL_HUMDB,
		PropertiesUtil.DATABASE_SYMBOL_REACTOME
	};
%>
	<h3>Database URLs Probe</h3>
<ul>
<% 	for (String db: dbNames) { %>
<li><%= PropertiesUtil.getDatabaseProperty(db,PropertiesUtil.DATABASE_SYMBOL_BRIEF) %>:
	<%= DatabaseUrlFactory.getDatabaseUrl(db) %>
</li>
<%	} %>
</ul>

	<h3>Quick probe of all databases (counts of small tables)</h3>
	<ul>
<%	
		QuickProbe probeMap = new QuickProbe();
		
		for (String key: probeMap.keys()){
			if (probeMap.probe(key)) {
%>
				<li>Quick probe of database <%= key %>. OK.</li>
<%	
			}
			else {
%>
				<li>Quick probe failed on database <%= key %>. See log for details.</li>
<%	
			}
			System.out.println("Probe of " + key + " database. OK.");
		}
%>
	</ul>
	<h3>Lucene probe</h3>
<%	
	String luceneQuery = "max-like blue AND plasma";
	if (lucene != null)
		luceneQuery = lucene;
	try {
		if (l.probe()){
			ArrayList<ResultGeneMolecule> geneList = l.fullGeneSearch(-1,luceneQuery);
%>
			Lucene probe was successful. <br />
			Making a Lucene query of "<%= luceneQuery %>" for all taxids.... <br />
			For a different query value use the parameter 'lucene' with any string. <br /> 
			Query returns the following genes... <br />
			Gene count = <%= geneList.size() %><br />
			<ul>
<%
			for (ResultGeneMolecule gene: geneList) {
%>
				<li><b><%= gene.getSymbol() %></b>(<%= gene.getId() %>): <%= gene.getDescription() %> </li>
<% 
			}
%>
			</ul>
<%
			if (geneList.size() == 0) {
%>
				Lucene returned an empty list, this is unexpected. <br />
<%
			} else {
%>
				Lucene appears to be working. <br />
<%
			}
		} else {
%>
			<font color="red">Lucene probe failed.</font><br />
			The reason is: <%= l.probeReason() %> <br />
<%
		}
	} catch (Throwable t) {
%>
		<font color="red">An exception occured during the Lucene Probe.</font> <br />
		Reason: <%= t.getMessage() %><br />
<%
	}
	
	
%>
	<h3>Hibernate Probe</h3>
	<i>Probe consists of an attempt to get the Human CSFR1 Gene (gene id = 1436); <br />
	for a different gene query use the parameter 'hibernate' with the gene id. </i> <br /><br />
<%
	try {
		int geneid = 1436;
		if (hibernate != null) {
			try {
				geneid = Integer.parseInt(hibernate);
			} catch (Throwable ignore) {}
		}
%>
		Making hibernate probe for geneid = <%= geneid %><br />
<%
		ResultGeneMolecule gene = h.getSingleGene(geneid);
		if (gene != null) {
%>
			Probe for geneid = <%= geneid %> was sucessful.<br />
			BriefString = <%= gene.briefString() %>
<%	
		} else {
%>
			Probe for geneid = <%= geneid %> was unexpecedly null.<br />
<%
		}
	} catch (Throwable t) {
%>
		<font color="red">An exception occured during the Hibernate Probe.</font> <br />
		Reason: <%= t.getMessage() %><br />
<%		
	}
%>
	<h3>Database Probes</h3>
<%
	try {
		Session geneSession = GeneSessionFactory.getSessionFactory().getCurrentSession();
		geneSession.beginTransaction();
		// attempt an data from gene database
		Object o = geneSession.createQuery("from org.ncibi.db.gene.Taxonomy where taxid=9606").uniqueResult();
		Taxonomy t = (Taxonomy)o;
%>
		<b>Gene database test:</b> Get Taxonomy record for taxid=9606. <br />
<%				

		
		if (t != null) {
			t.getTaxid();
			if (t.getTaxid().intValue() == 9606) {
%>
				Gene database appears to work. <br />
<%				
			} else {
%>
				<font color="red">An exception occurred during the Gene Database probe; value mismatch on Taxonomy id.</font> <br />
<%								
			}
		} else {
%>
			<font color="red">An exception occurred during the Gene Database probe; null Taxonomy record.</font> <br />
<%			
		}
		geneSession.close();

%>
		<br />
		<b>Mimi Database test:</b> Get molecules for geneid = 1436; aka CSF1R <br />
<%				
		// 1436 is CSF1R, gene id
		ArrayList<MoleculeRecord> list = h.getMoleculeRecordsForGeneId(1436);
		if (list != null){
%>
			Molecule list is: 
<%				
			for (MoleculeRecord rec: list) {
%>
				<%= rec.getDisplayId() %>
<%				
			}
%>
			<br />
			Mimi database test appears to work <br />
<%				
		} else {
%>
			<font color="red">An exception occured during the Mimi Database probe; null Molecule list.</font> <br />
<%				
		}

%>
		<br />
		<b>Pubmed database test:</b> Get document for pubmed id = 2172781 <br />
<%						
		Document d = h.getFullDocumentForPubmedId(2172781);
		if (d != null) {
%>
			Document successfully fetched; id = <%= d.getDocumentId() %> <br />
			Pubmed database test appears to work <br />
<%				
		} else {
%>
			<font color="red">An exception occured during the Pubmed Database probe; null Document.</font> <br />
<%				
		}
	} catch (Throwable t) {
%>
		<font color="red">An exception occured during the Database Probes.</font> <br />
		Reason: <%= t.getMessage() %><br />
<%		
	}
%>
</body>
</html>
