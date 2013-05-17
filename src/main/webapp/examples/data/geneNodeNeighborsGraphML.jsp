<?xml version="1.0" encoding="UTF-8"?>
<%@ page language="java" contentType="text/xml; charset=ISO-8859-1"
    pageEncoding="ISO-8859-1"
    import="
    	org.ncibi.lucene.MimiDocument,
    	org.ncibi.mimiweb.lucene.LuceneInterface,
    	org.ncibi.mimiweb.data.GeneCoverForSelection,
    	org.apache.lucene.queryParser.ParseException,
    	java.util.ArrayList,
    	java.util.HashSet,
    	java.io.IOException
    "%><%
	final String EOL = "\n";

	// example: geneid=1463

	class Util {
		public String errorReturn(String message) {
			return makeTag("error", makeTag("message", message));
		}
		
		public String makeTag(String tag, String content) {
			if ((content != null) && (content.length() > 0))
				return 
					"<" + tag + ">" + EOL +
					content + EOL +
					"</" + tag + ">" + EOL ; 
			return "<" + tag + "/>" + EOL;
			
		}
		
		public String makeTagWithParams(String tag, String params, String content) {
			if ((params == null) || (params.length() == 0))
				return makeTag(tag,content);
			if ((content != null) && (content.length() > 0))
				return 
					"<" + tag + " " + params + ">" + EOL +
					content + EOL +
					"</" + tag + ">" + EOL ; 
			return "<" + tag + " " + params + "/>" + EOL;
		}
		
		public String makeGeneTag(int id, int taxid, String name){
			String ret;
			ret  = makeTagWithParams("data","key = \"taxidKey\"",""+taxid);
			ret += makeTagWithParams("data","key = \"nameKey\"",name);
			ret += makeTagWithParams("data","key = \"propKey\"",name);
			return makeTagWithParams("node","id=\"" + id + "\"", ret);
		}
		
		public String makeInteractionTag(int id1, int id2){
			return makeTagWithParams("edge","source=\"" + id1 + "\" target=\"" + id2 + "\"", null);
		}
		
		public ArrayList<GeneCoverForSelection> getFirstNeighborListForGeneQuery(int taxid, String search) throws IOException, ParseException {
			LuceneInterface l = LuceneInterface.getInterface();
		    ArrayList<MimiDocument> docs = l.getFirstNeighborListForQuery(taxid, search) ;
		    ArrayList<GeneCoverForSelection> genes = new  ArrayList<GeneCoverForSelection>();

		    for (MimiDocument doc: docs) {
				if ((taxid < 0) || (doc.taxid == taxid)) {
					genes.add(new GeneCoverForSelection(l.makeResultGeneFromMimiDoc(doc)));
				}
			}
			return genes;
		}
		
		public String makeEnclosingTag(String xml) {
			return makeTagWithParams("graphml",
				"xmlns=\"http://graphml.graphdrawing.org/xmlns\" " +
			    "xmlns:xsi=\"http://www.w3.org/2001/XMLSchema-instance\" " +
				"xsi:schemaLocation=\"http://graphml.graphdrawing.org/xmlns " +
			    "	http://graphml.graphdrawing.org/xmlns/1.0/graphml.xsd\" ",
			    xml);
		}
		
		public String makeHeader() {
			return
				makeTagWithParams("key","id=\"taxidKey\" for=\"node\" attr.name=\"taxid\" attr.type=\"int\" ",null) +
			    makeTagWithParams("key","id=\"nameKey\" for=\"node\" attr.name=\"name\" attr.type=\"string\" ",null) + 
			    makeTagWithParams("key","id=\"propKey\" for=\"node\" attr.name=\"prop\" attr.type=\"string\" ",null);
		}
	}

	Util util = new Util();
	
	LuceneInterface l = LuceneInterface.getInterface();
	
	HashSet idSet = new HashSet();
	
	String geneIdString = request.getParameter("geneid");
	
	if (geneIdString == null) {
		out.println(util.errorReturn("'geneid' is a required parameter"));
		return;
	}
	int geneId = -999;
	try {
		geneId = Integer.parseInt(geneIdString);
	} catch (Throwable ignore) {
	}
	if (geneId == -999) {
		out.println(util.errorReturn("geneid = " + geneIdString + "; must be an integer"));
		return;
	}

	ArrayList<GeneCoverForSelection> genes = util.getFirstNeighborListForGeneQuery(-1,"geneid:" + geneId);
	
	//the first node writen is the default "center" of the graph
	
	String nodes = "";
	for (GeneCoverForSelection gene: genes) {
		if (gene.getId().intValue() == geneId)
			nodes += util.makeGeneTag(gene.getId().intValue(),gene.getTaxid(),gene.getSymbol());
	}

	for (GeneCoverForSelection gene: genes) {
		idSet.add(gene.getId());
		if (gene.getId().intValue() != geneId)
			nodes += util.makeGeneTag(gene.getId().intValue(),gene.getTaxid(),gene.getSymbol());
	}

	String edges = "";
	for (GeneCoverForSelection gene: genes) {
		Integer[] targets = gene.getInteractionGeneIds();
		for (Integer id2: targets) {
			if (idSet.contains(id2))
				edges += util.makeInteractionTag(gene.getId().intValue(), id2.intValue());
		}
	}

	String graph = nodes + edges;
	graph = util.makeTagWithParams("graph","id=\"mimiGraph\" edgedefault=\"undirected\"",graph);
	
	out.println(util.makeEnclosingTag(util.makeHeader() + graph));
%>