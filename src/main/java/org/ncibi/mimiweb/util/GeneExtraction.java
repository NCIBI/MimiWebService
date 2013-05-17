package org.ncibi.mimiweb.util;

import java.util.ArrayList;

public class GeneExtraction {

	public static final int UNDEFINED_LIST = 0;
	public static final int SYMBOL_LIST = 1;
	public static final int ID_LIST =2;
	
	private ArrayList<String> geneSymbolList = new ArrayList<String>();
	private ArrayList<Integer> geneIdList = new ArrayList<Integer>();
	private int type = UNDEFINED_LIST;
	
	public int getType() {
		return type;
	}
	public void setType(int type) {
		this.type = type;
	}
	public ArrayList<String> getGeneSymbolList() throws IllegalAccessException {
		if (type != SYMBOL_LIST) throw new IllegalAccessException("Not a Gene Symbol List");
		return geneSymbolList;
	}
	public void setGeneSymbolList(ArrayList<String> geneSymbolList) {
		type = SYMBOL_LIST;
		this.geneSymbolList = geneSymbolList;
	}
	public ArrayList<Integer> getGeneIdList() throws IllegalAccessException {
		if (type != ID_LIST) throw new IllegalAccessException("Not a Gene ID List");
		return geneIdList;
	}
	public void setGeneIdList(ArrayList<Integer> geneIdList) {
		type = ID_LIST;
		this.geneIdList = geneIdList;
	}
	
}
