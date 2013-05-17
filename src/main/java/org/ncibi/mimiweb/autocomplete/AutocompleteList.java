package org.ncibi.mimiweb.autocomplete;

import java.util.ArrayList;

/*
 * This class exists to allow synchronization on a single in-memory list.
 */
public class AutocompleteList
{	
	public static final ArrayList<String> acList = new ArrayList<String>() ;
	public static boolean isLoaded = false;
}
