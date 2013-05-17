package org.ncibi.mimiweb.util;

import java.util.ArrayList;
import java.util.HashMap;

import org.ncibi.db.gene.TaxName;
import org.ncibi.mimiweb.hibernate.HibernateInterface;

public class FullOrganismNameList {

	private static HashMap<Integer,TaxName> lookup = new HashMap<Integer,TaxName>();
		
	public static String getOrganismNameForTaxId(String id){
		return getOrganismNameForTaxId(Integer.parseInt(id));
	}
	
	public static String getOrganismNameForTaxId(int id){
		return getOrganismNameForTaxId(new Integer(id));
	}

	public static String getOrganismNameForTaxId(Integer i){
		if (lookup.size() > 10000) lookup.clear(); // keep if from getting too large
		TaxName name = lookup.get(i);
		if (name == null) {
			prepareForSingle(i);
			name = lookup.get(i);
			if (name == null)
				return null;
		}
		String ret = name.getTaxname();
		return ret;
	}
	
	public static void prepareForSingle(Integer i){
		ArrayList<Integer> queryList = new ArrayList<Integer>();
		queryList.add(i);
		prepareForMultiple(queryList);
	}
	
	public static void prepareForMultiple(ArrayList<Integer> queryList) {
		HibernateInterface h = HibernateInterface.getInterface();
		ArrayList<TaxName> list = h.getTaxNameList(queryList);
		for (TaxName t: list){
			lookup.put(t.getTaxid(), t);
		}
	}

	public static int[] testIdValues = {9606, 6239, 283166};

	public static void main(String[] args){
		long time = System.currentTimeMillis();
		for (int id: testIdValues){
			System.out.println("The name for id " + id + " is " + getOrganismNameForTaxId(id));
		}
		long now = System.currentTimeMillis();
		System.out.println("Ran for " + (now-time) + " Milliseconds");
		time = System.currentTimeMillis();
		for (int id: testIdValues){
			System.out.println("The name for id " + id + " is " + getOrganismNameForTaxId(id));
		}
		now = System.currentTimeMillis();
		System.out.println("Ran for " + (now-time) + " Milliseconds");
	}
}
