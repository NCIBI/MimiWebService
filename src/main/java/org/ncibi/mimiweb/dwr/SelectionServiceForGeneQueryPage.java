package org.ncibi.mimiweb.dwr;

import java.util.ArrayList;
import java.util.Collections;
import java.util.HashMap;
import java.util.Map;

import org.apache.log4j.Logger;
import org.ncibi.mimiweb.data.GeneQueryStateHolder;

public class SelectionServiceForGeneQueryPage {

	private static Logger logger = Logger.getLogger(SelectionServiceForGeneQueryPage.class);

	private static boolean cleanupTriggered = false; 
	private static final long TIME_LIMIT = 1 * 60 * 1000; // an hour in milliseconds
	private static final long CLEANUP_WAIT = 60 * 1000; // 60 seconds in milliseconds 

	// cache registered Holders
	private static Map<Integer,SelectionHolder> map = Collections.synchronizedMap(new HashMap<Integer, SelectionHolder>());
	
	public boolean mark(Integer holderIndex, Integer geneid, boolean flag){
		SelectionHolder h = map.get(holderIndex);
		if (h == null) {
//			logger.debug("ERROR: attempt to mark a null holder: " + holderIndex);
			return false;
		}
		
		h.markItem(geneid, flag);
//		logger.debug("set mark (holder " + h.getIndex() + "): " + geneid + "(" + flag+ ")" + " - " + h.getIndex());
		return true;
	}
	
	public static void register(GeneQueryStateHolder h){
		map.put(h.getKey(), new SelectionHolder(h));
		logger.debug("Register Added: " + h.getKey());
		triggerCleanup();
	}
	
	public static void unregisterByKey(Integer key){
		map.remove(key);
		logger.debug("Unregistered: " + key);
	}
	
	public static void selectAll(Integer key){
		SelectionHolder h = map.get(key);
		if (h != null) h.markAll(true);	
	}
	
	public static void selectNone(Integer key){
		SelectionHolder h = map.get(key);
		if (h != null) h.markAll(false);	
	}
	
	private static void triggerCleanup()
	{
		if (cleanupTriggered) return;
		cleanupTriggered = true;
		Runnable r = new Runnable(){
			public void run(){
				try { Thread.sleep(CLEANUP_WAIT);
				} catch (InterruptedException fallthrough) {}
				cleanup();
				cleanupTriggered = false;
			}
		};
		Thread t = new Thread(r);
		t.start();
	}
	
	private static void cleanup(){
//		logger.debug("Cleanup of stale GeneSelectionHolders (see gene-query-page.jsp)...");
		Long now = System.currentTimeMillis();
		ArrayList<Integer> oldKeys = new ArrayList<Integer>();
		synchronized (map) {
			for (Integer key: map.keySet()){
				SelectionHolder h = map.get(key);
				long time = now - h.getWhen();
				if (time > TIME_LIMIT) {
					oldKeys.add(key);
				}
			}
		}
		for (Integer key: oldKeys){
			map.remove(key);
			logger.debug("Cleanup Removed: " + key);
		}
	}
}
