<%@ page language="java" contentType="text/xml; charset=ISO-8859-1"
    pageEncoding="ISO-8859-1"
    import="
    	org.ncibi.lucene.MimiDocument,
    	org.ncibi.mimiweb.lucene.LuceneInterface,
    	org.ncibi.mimiweb.data.GeneCoverForSelection,
    	org.apache.lucene.queryParser.ParseException,
    	java.util.ArrayList,
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
		public String makeGeneTag(int id, int tax, String name){
			return makeTagWithParams("gene","id=\"" + id + "\" taxid=\"" + tax + "\" name=\"" + name + "\" prop=\"" + name + "\"", null);
		}
		public String makeInteractionTag(int id1, int id2){
			return makeTagWithParams("interaction","id1=\"" + id1 + "\" id2=\"" + id2 + "\"", null);
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
	}

	Util util = new Util();
	
	LuceneInterface l = LuceneInterface.getInterface();
	
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
		if (gene.getId().intValue() != geneId)
			nodes += util.makeGeneTag(gene.getId().intValue(),gene.getTaxid(),gene.getSymbol());
	}

	String edges = "";
	for (GeneCoverForSelection gene: genes) {
		Integer[] targets = gene.getInteractionGeneIds();
		for (Integer id2: targets) {
			edges += util.makeInteractionTag(gene.getId().intValue(), id2.intValue());
		}
	}

	out.println(util.makeTag("graph", nodes + edges));
%>