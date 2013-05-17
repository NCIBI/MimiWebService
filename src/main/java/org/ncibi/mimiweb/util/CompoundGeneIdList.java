package org.ncibi.mimiweb.util;

import java.util.ArrayList;

public class CompoundGeneIdList
{
	public String cid ;
	public ArrayList<Integer> geneIdList ;
	
	public CompoundGeneIdList(String cid)
	{
		this.cid = cid ;
		geneIdList = new ArrayList<Integer>() ;
	}
}
