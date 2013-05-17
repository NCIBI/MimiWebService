package org.ncibi.mimiweb.util;

import java.util.ArrayList;
import java.util.Set;

import org.ncibi.db.pubmed.DocTaxonomy;

public class TaxonomyCover {
	
	private ArrayList<Integer> list;
	private int index;
	
	public TaxonomyCover(ArrayList<Integer> list, int index) {
		this.list = list;
		this.index = index;
	}
	
	public String getTaxName0() {
		return getTaxName(index);
	}

	public String getTaxName1() {
		return getTaxName(index+1);
	}

	public String getTaxName2() {
		return getTaxName(index+2);
	}
	
	private String getTaxName(int i) {
		if (i >= list.size()) return "";
		Integer taxid = list.get(i);
		String name = FullOrganismNameList.getOrganismNameForTaxId(taxid);
		if (name == null)
			name = "not in database (tax id = " + taxid + ")";
		return name;
	}

	public static ArrayList<TaxonomyCover> makeCovers(Set taxRecords){
		
		// extract tax id values
    	ArrayList<Integer> list = new ArrayList<Integer>();
		for (Object dtObj: taxRecords){
			DocTaxonomy dt = (DocTaxonomy)dtObj;
			list.add(dt.getId().getTaxonomyId());
		}

		// fetch the tax id names, if necessary
		FullOrganismNameList.prepareForMultiple(list);
		
		// set up the cover list (for use in the table)
		ArrayList<TaxonomyCover> ret = new ArrayList<TaxonomyCover>();
				
		int i = 0;
		while (i < taxRecords.size()){
			ret.add(new TaxonomyCover(list,i));
			i += 3;
		}

		return ret;
	}
}
