package org.ncibi.mimiweb.util;

import java.util.ArrayList;

import org.ncibi.lucene.MimiDocument;

/**
 * This class is a 'cover' for the gene summary to enable the addition of two columns
 * for the table displayed on the Document Detail page: (1) the classification of gene
 * as derived from merging or from tagging (2) in the tagging case, the tag.  
 */
public class DocPageUtilGenePojo{
	
	private MimiDocument theGeneDoc = null;
	private boolean tag = false;
	private boolean highlight = false;
	private String tagText = "";
	private ArrayList<String> cellularComponentsArray = null;
	private ArrayList<String> biologicalProcessesArray = null;
	private ArrayList<String> molecularFunctionsArray = null;

	public DocPageUtilGenePojo(MimiDocument doc, boolean itsATag, String tagText)
	{
		theGeneDoc = doc;
		tag = itsATag;
		if (tagText == null) tagText="";
		this.tagText = tagText;
		if (doc.biologicalProcesses == null) doc.biologicalProcesses="";
		if (doc.cellularComponents == null) doc.cellularComponents="";
		if (doc.geneDescription == null) doc.geneDescription="";
		if (doc.geneType == null) doc.geneType="";
		if (doc.molecularFunctions == null) doc.molecularFunctions="";
		if (doc.moleculeNames == null) doc.moleculeNames="";
	}
	
	public int getId(){return theGeneDoc.geneid;}
    public String getSymbol(){return theGeneDoc.geneSymbol;}
    public String getTaxScientificName(){return theGeneDoc.sciTaxName;}
    public String getGeneType(){return theGeneDoc.geneType;}
    public String getMoleculeNamesString(){return theGeneDoc.moleculeNames;}
    public String getDescription(){return theGeneDoc.moleculeDescriptions;}
    public String getCellularComponentsString(){return theGeneDoc.cellularComponents;}
    public String getBiologicalProcessesString(){return theGeneDoc.biologicalProcesses;}
    public String getMolecularFunctionsString(){return theGeneDoc.molecularFunctions;}
    public int getInteractionCount(){return theGeneDoc.interactionCount;}
    public int getPubCount(){return theGeneDoc.pubCount;}
    public int getPathwayCount(){return theGeneDoc.pathwayCount;}
    public boolean getTagged(){return tag;}
    public String getTagText(){return tagText;}
    public boolean isHighlight() { return highlight;}

	public void setHighlight(boolean highlight) {this.highlight = highlight; }

	public ArrayList<String> getCellularComponents(){
    	if (cellularComponentsArray != null) return cellularComponentsArray;
    	String target = getCellularComponentsString();
    	if (target == null) target = "";
    	target = target.trim();
    	cellularComponentsArray = new ArrayList<String>();
    	if (target.length() > 0) {
	    	target = target.substring(0,target.length()-1); // remove trailing ;
	    	String[] array = getCellularComponentsString().split(";");
	    	for (String s: array)
	    		cellularComponentsArray.add(s.trim());
    	}
    	return cellularComponentsArray;
    }
    
    public ArrayList<String> getBiologicalProcesses(){
    	if (biologicalProcessesArray != null) return biologicalProcessesArray;
    	String target = getMolecularFunctionsString();
    	if (target == null) target = "";
    	target = target.trim();
    	biologicalProcessesArray = new ArrayList<String>();
    	if (target.length() > 0) {
	    	target = target.substring(0,target.length()-1); // remove trailing ;
	    	String[] array = getCellularComponentsString().split(";");
	    	for (String s: array)
	    		biologicalProcessesArray.add(s.trim());
    	}
    	return biologicalProcessesArray;
    }

    public ArrayList<String> getMolecularFunctions(){
    	if (molecularFunctionsArray != null) return molecularFunctionsArray;
    	String target = getMolecularFunctionsString();
    	if (target == null) target = "";
    	target = target.trim();
    	molecularFunctionsArray = new ArrayList<String>();
    	if (target.length() > 0) {
	    	target = target.substring(0,target.length()-1); // remove trailing ;
	    	String[] array = getCellularComponentsString().split(";");
	    	for (String s: array)
	    		molecularFunctionsArray.add(s.trim());
    	}
    	return molecularFunctionsArray;
    }
}
