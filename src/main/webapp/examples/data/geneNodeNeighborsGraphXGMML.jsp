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
			return makeTagWithParams("node","label=\" + id + \" id=\"\"",
					makeTagWithParams("att","type=\"string\" name=\"Network Distance\" value=\"1\"",null)
					+ makeTagWithParams("att","type=\"string\" name=\"Description\" value=\"v-yes-1 Yamaguchi sarcoma viral oncogene homolog 1\"",null)
					+ makeTagWithParams("att","type=\"string\" name=\"Taxid\" value=\"9606\"",null)
					+ makeTagWithParams("att","type=\"string\" name=\"Function\" value=\"ATP binding [GO:0005524]; non-membrane spanning protein tyrosine kinase activity [GO:0004715]; nucleotide binding [GO:0000166]; protein binding [GO:0005515]; transferase activity [GO:0016740]\"",null)
					+ makeTagWithParams("att","type=\"string\" name=\"Chromosome\" value=\"18\"",null)
					+ makeTagWithParams("att","type=\"string\" name=\"Kegg gene\" value=\"hsa:7525\"",null)
					+ makeTagWithParams("att","type=\"boolean\" name=\"UserAnnot\" value=\"false\"",null)
					+ makeTagWithParams("att","type=\"string\" name=\"canonicalName\" value=\"7525\"",null)
					+ makeTagWithParams("att","type=\"integer\" name=\"Node Color\" value=\"1\"",null)
					+ makeTagWithParams("att","type=\"string\" name=\"Process\" value=\"glucose transport [GO:0015758]; protein amino acid autophosphorylation [GO:0046777]; protein modification process [GO:0006464]\"",null)
					+ makeTagWithParams("att","type=\"string\" name=\"Pathway\" value=\"\"",null)
					+ makeTagWithParams("att","type=\"string\" name=\"Component\" value=\"\"",null)
					+ makeTagWithParams("att","type=\"string\" name=\"Gene type\" value=\"\"",null)
					+ makeTagWithParams("att","type=\"string\" name=\"Other Gene Names\" value=\"\"",null)
					+ makeTagWithParams("att","type=\"string\" name=\"Gene Name\" value=\"\"",null)
					+ makeTagWithParams("att","type=\"string\" name=\"Map_loc\" value=\"\"",null)
					+ makeTagWithParams("att","type=\"string\" name=\"Organism\" value=\"\"",null)
					+ makeTagWithParams("graphics","type=\"ELLIPSE\" h=\"35.0\" w=\"35.0\" x=\"232.36029052734375\" y=\"80.68094635009766\" fill=\"#ff9999\" width=\"1\" outline=\"#000000\" cy:nodeTransparency=\"1.0\" cy:nodeLabelFont=\"Default-0-12\" cy:borderLineType=\"solid\"",null)
					);
//			  <node label="7525" id="-19">
//			    <att type="string" name="Network Distance" value="1"/>
//			    <att type="string" name="Description" value="v-yes-1 Yamaguchi sarcoma viral oncogene homolog 1"/>
//			    <att type="string" name="Taxid" value="9606"/>
//			    <att type="string" name="Function" value="ATP binding [GO:0005524]; non-membrane spanning protein tyrosine kinase activity [GO:0004715]; nucleotide binding [GO:0000166]; protein binding [GO:0005515]; transferase activity [GO:0016740]"/>
//			    <att type="string" name="Chromosome" value="18"/>
//			    <att type="string" name="Kegg gene" value="hsa:7525"/>
//			    <att type="boolean" name="UserAnnot" value="false"/>
//			    <att type="string" name="canonicalName" value="7525"/>
//			    <att type="integer" name="Node Color" value="1"/>
//			    <att type="string" name="Process" value="glucose transport [GO:0015758]; protein amino acid autophosphorylation [GO:0046777]; protein modification process [GO:0006464]"/>
//			    <att type="string" name="Pathway" value="Adherens junction [path:hsa04520]; Tight junction [path:hsa04530]"/>
//			    <att type="string" name="Component" value="cytoplasm [GO:0005737]; membrane fraction [GO:0005624]"/>
//			    <att type="string" name="Gene type" value="protein-coding"/>
//			    <att type="string" name="Other Gene Names" value="[c-yes; HsT441; P61-YES; YES; YES1 ]"/>
//			    <att type="string" name="Gene Name" value="YES1"/>
//			    <att type="string" name="Map_loc" value="18p11.31-p11.21"/>
//			    <att type="string" name="Organism" value="Homo sapiens"/>
//			    <graphics type="ELLIPSE" h="35.0" w="35.0" x="232.36029052734375" y="80.68094635009766" fill="#ff9999" width="1" outline="#000000" cy:nodeTransparency="1.0" cy:nodeLabelFont="Default-0-12" cy:borderLineType="solid"/>
//			  </node>
		}
		
		public String makeInteractionTag(int id1, int id2){
			return makeTagWithParams("edge","label=\"\" source=\"-4\" target=\"-5\"",
					makeTagWithParams("att","type=\"string\" name=\"Pubmed\" value=\"\"",null)
					+ makeTagWithParams("att","type=\"string\" name=\"Provenance\" value=\"\"",null)
					+ makeTagWithParams("att","type=\"string\" name=\"Gene name\" value=\"\"",null)
					+ makeTagWithParams("att","type=\"string\" name=\"canonicalName\" value=\"\"",null)
					+ makeTagWithParams("att","type=\"string\" name=\"InteractionID\" value=\"\"",null)
					+ makeTagWithParams("att","type=\"string\" name=\"Function\" value=\"\"",null)
					+ makeTagWithParams("att","type=\"string\" name=\"Interactiontype\" value=\"\"",null)
					+ makeTagWithParams("att","type=\"boolean\" name=\"EdgeUserAnnot\" value=\"\"",null)
					+ makeTagWithParams("att","type=\"string\" name=\"interaction\" value=\"\"",null)
					+ makeTagWithParams("graphics","width=\"1\" fill=\"#000000\" cy:sourceArrow=\"0\" cy:targetArrow=\"0\" cy:sourceArrowColor=\"#000000\" cy:targetArrowColor=\"#000000\" cy:edgeLabelFont=\"SanSerif-0-10\" cy:edgeLineType=\"SOLID\" cy:curved=\"STRAIGHT_LINES\"",null)
					);
//			  <edge label="2534 ( ) 8651" source="-4" target="-15">
//			    <att type="string" name="Pubmed" value="[10022833]"/>
//			    <att type="string" name="Provenance" value="[BIND; GRID; HPRD]"/>
//			    <att type="string" name="Gene name" value="(FYN , SOCS1)"/>
//			    <att type="string" name="canonicalName" value="2534 ( ) 8651"/>
//			    <att type="string" name="InteractionID" value="98531"/>
//			    <att type="string" name="Function" value="[protein binding [GO:0005515]]"/>
//			    <att type="string" name="Interactiontype" value="[bidirectional [reverse]; in vitro [reverse]; Invitro]"/>
//			    <att type="boolean" name="EdgeUserAnnot" value="false"/>
//			    <att type="string" name="interaction" value=" "/>
//			    <graphics width="1" fill="#000000" cy:sourceArrow="0" cy:targetArrow="0" cy:sourceArrowColor="#000000" cy:targetArrowColor="#000000" cy:edgeLabelFont="SanSerif-0-10" cy:edgeLineType="SOLID" cy:curved="STRAIGHT_LINES"/>
//			  </edge>
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
			return makeTagWithParams("graph",
				"label=\"Generated by MimiWeb\" "
				+ "xmlns:dc=\"http://purl.org/dc/elements/1.1/\" "
				+ "xmlns:xlink=\"http://www.w3.org/1999/xlink\" "
				+ "xmlns:rdf=\"http://www.w3.org/1999/02/22-rdf-syntax-ns#\" "
				+ "xmlns:cy=\"http://www.cytoscape.org\" "
				+ "xmlns=\"http://www.cs.rpi.edu/XGMML\" >",
				xml);
		}
		
		public String makeHeader() {
			return
				makeTagWithParams("att","name=\"documentVersion\" value=\"1.1\"", null)
				+ makeTagWithParams("att","name=\"networkMetadata\"", 
						makeTag("rdf:RDF",
								makeTagWithParams("rdf:Description",
										"rdf:about=\"http://www.cytoscape.org/\"",
										makeTag("dc:type", "Protein-Protein Interaction")
										+ makeTag("dc:description", "N/A")
										+ makeTag("dc:identifier","N/A")
										+ makeTag("dc:date","2009-02-18 09:43:33")
										+ makeTag("dc:title","Generated by MimiWeb")
										+ makeTag("dc:source","http://mimi.ncibi.org")
										)
						)
					)
				+ makeTagWithParams("att","type=\"string\" name=\"backgroundColor\" value=\"#ffffff\"", null)
				+ makeTagWithParams("att","type=\"real\" name=\"GRAPH_VIEW_ZOOM\" value=\"1.0\"", null)
				+ makeTagWithParams("att","type=\"real\" name=\"GRAPH_VIEW_CENTER_X\" value=\"100.0\"", null)
				+ makeTagWithParams("att","type=\"real\" name=\"GRAPH_VIEW_CENTER_Y\" value=\"100.0\"", null)
				+ makeTagWithParams("att","type=\"string\" name=\"Data Source\" value=\"All Data Sources\"", null)
				+ makeTagWithParams("att","type=\"string\" name=\"Input Genes\" value=\"csf1r\"", null)
				+ makeTagWithParams("att","type=\"string\" name=\"Displays for results\" value=\"1. Query genes + nearest neighbors\"", null)
				+ makeTagWithParams("att","type=\"string\" name=\"Organism\" value=\"Homo sapiens\"", null)
				+ makeTagWithParams("att","type=\"string\" name=\"Molecule Type\" value=\"All Molecule Types\"", null)
				;
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

	out.println(util.makeEnclosingTag(util.makeHeader() + graph));
%>