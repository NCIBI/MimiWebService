package org.ncibi.mimiweb.util;

import java.util.ArrayList;

import org.ncibi.db.pubmed.DocAuthor;

public class DocAuthorCollectiveCover {
	
	DocAuthor theAuthor = null;
	
	public DocAuthorCollectiveCover(DocAuthor a) {
		theAuthor = a;
	}

	public String getPersonalOrCollectiveName(){
		String name = theAuthor.getAuthorPersonalName();
		if (name == null) name = theAuthor.getAuthorCollectiveName();
		return name;
	}
	
	public String getEmailAddress() {
		return theAuthor.getAuthorEmailAddress();
	}
	
	public String getAffiliation() {
		return theAuthor.getAuthorAffiliation();
	}
	
	public String makeEntry(){
		String ret = getPersonalOrCollectiveName();
		if (ret == null) ret = "";
		ret = ret.trim();
		if ((getAffiliation() != null) && (getAffiliation().length() > 0))
			ret += ", <i>" + getAffiliation().trim() + "</i>";
		if ((getEmailAddress() != null) && (getEmailAddress().length() > 0))
			ret += " (" + getEmailAddress().trim() + ")";
		return ret;
	}
	
	@SuppressWarnings("unchecked")
	public static ArrayList<DocAuthorCollectiveCover> makeCovers(ArrayList authorRecords){
		ArrayList<DocAuthorCollectiveCover> ret = new ArrayList<DocAuthorCollectiveCover>();
		for (Object rec: authorRecords) {
			ret.add(new DocAuthorCollectiveCover((DocAuthor)rec));
		}
		return ret;
	}
}
