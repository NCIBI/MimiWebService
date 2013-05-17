package org.ncibi.mimiweb.dwr;

import java.util.HashMap;

import org.apache.log4j.Logger;
import org.ncibi.mimiweb.data.GeneCoverForSelection;
import org.ncibi.mimiweb.data.GeneQueryStateHolder;

public class SelectionHolder {

	private static Logger logger = Logger.getLogger(SelectionHolder.class);

	private static int count = 0;
	
	private Integer index = new Integer(count);
	private long when = 0;
	private HashMap<Integer, GeneCoverForSelection> map = new HashMap<Integer, GeneCoverForSelection>();
	
	public SelectionHolder(GeneQueryStateHolder s) {
		count++;
		when = System.currentTimeMillis();
		createMap(s);
	}

	public void markItem(int geneid, boolean selected){
		updateTimestamp();
		Integer key = new Integer(geneid);
		GeneCoverForSelection gene = map.get(key);
		if (gene == null) return;
		gene.setSelected(selected);
		logger.debug("Set mark on " + key + " to " + selected + "," + gene.hashCode());
	}
	
	public void markAll(boolean selected){
		updateTimestamp();
		for (Integer key: map.keySet()) {
			map.get(key).setSelected(selected);
		}
	}
	
	public Integer getIndex() {
		return index;
	}

	public long getWhen () {
		return when;
	}
	
	private void updateTimestamp() {
		when = System.currentTimeMillis();		
	}

	private void createMap(GeneQueryStateHolder s) {
		for (GeneCoverForSelection gene: s.getGenes()){
			map.put(gene.getId(), gene);
		}
	}

}
