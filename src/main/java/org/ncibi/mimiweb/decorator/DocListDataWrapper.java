package org.ncibi.mimiweb.decorator;

import org.ncibi.mimiweb.data.hibernate.DocumentBriefSimple;

public class DocListDataWrapper extends DocumentBriefSimple{

	private DocumentBriefSimple doc;
	private String refId;
	private String whichCase = "";
	private String linkText = "see";
	public static final String GENE = "forGeneId";
	public static final String GENE_INTERACTION = "forGenesInteractingWithGeneId";
	public static final String INTERACTION = "forInteractionId";
	
	public DocListDataWrapper(String whichCase, int id, DocumentBriefSimple doc, String linkText){
		this(whichCase, ""+id,doc,linkText);
	}

	public DocListDataWrapper(String whichCase, Integer id, DocumentBriefSimple doc, String linkText){
		this(whichCase,id.toString(),doc,linkText);
	}

	public DocListDataWrapper(String whichCase, String id, DocumentBriefSimple doc, String linkText){
		this.doc = doc;
		this.whichCase = whichCase;
		this.refId = id;
		this.linkText = linkText;
	}
	
	public DocListDataWrapper getItself() {
		return this;
	}	

	public String getRefId() {
		return refId;
	}
	
	public String getWhichCase() {
		return whichCase;
	}
	
	public String getLinkText() {
		return linkText;
	}

	public String getAuthors() {
		return doc.getAuthors();
	}

	public String getCitation() {
		return doc.getCitation();
	}

	public String getDate() {
		return doc.getDate();
	}

	public Integer getGeneId() {
		return doc.getGeneId();
	}

	public Integer getId() {
		return doc.getId();
	}

	public String getIssue() {
		return doc.getIssue();
	}

	public String getJournalTitle() {
		return doc.getJournalTitle();
	}

	public String getPages() {
		return doc.getPages();
	}

	public String getRawdate() {
		return doc.getRawdate();
	}

	public String getTitle() {
		return doc.getTitle();
	}

	public String getVolume() {
		return doc.getVolume();
	}

	public String getYear() {
		return doc.getYear();
	}

	public int hashCode() {
		return doc.hashCode();
	}
	
	public String toString(){
		String ref = "";
		if (whichCase.equals(GENE)||whichCase.equals(GENE_INTERACTION))
			ref = "(refFrom-geneid=" + refId;
		if (whichCase.equals(INTERACTION))
			ref = "(refFrom-interactionid=" + refId;
		return "pubmed:" + getId() + ref;
	}
}
