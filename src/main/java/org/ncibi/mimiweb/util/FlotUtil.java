package org.ncibi.mimiweb.util;

import java.util.ArrayList;
import java.util.Collections;
import java.util.Comparator;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import org.ncibi.commons.exception.ConstructorCalledError;
import org.ncibi.mimiweb.data.StringItem;

/**
 * Utility methods for generating a Flot graph.
 * 
 * @author gtarcea
 *
 */
public final class FlotUtil
{ 
    /**
     * Constructor. Should never be called.
     */
    private FlotUtil()
    {
        throw new ConstructorCalledError(this.getClass());
    }

    /**
     * Generates a subcellular bar graph.
     * @param tag The Flot tag to use.
     * @param locations A list of Subcellular locations.
     * @return Javascript string to insert into a jsp.
     */
    public static String generateSubcellularBarGraph(final String tag,
            final List<StringItem> locations)
    {
        /**
         * Local class used to keep count of Subcellular location entries.
         * 
         * @author gtarcea
         *
         */
        final class SubcellularEntry
        {
            /**
             * How many times was this location seen?
             */
            public Integer count = 1;
            
            /**
             * The location name.
             */
            public final String location;

            /**
             * Constructor.
             * @param l The location name.
             */
            public SubcellularEntry(final String l)
            {
                location = l;
            }
        }
        
        final Map<String, SubcellularEntry> locationMap = new HashMap<String, SubcellularEntry>();
        SubcellularEntry e;

        for (final StringItem loc : locations)
        {
            e = locationMap.get(loc.getStr());
            if (e == null)
            {
                e = new SubcellularEntry(loc.getStr());
            }
            else
            {
                e.count++;
            }
            locationMap.put(loc.getStr(), e);
        }

        final List<SubcellularEntry> sortedLocations = new ArrayList<SubcellularEntry>(
                locationMap.values());

        Collections.sort(sortedLocations, new Comparator<SubcellularEntry>()
        {
            public int compare(final SubcellularEntry s1, final SubcellularEntry s2)
            {
                return s2.count - s1.count;
            }
        });

        String jscript = "<script id=\"executeme\" language=\"javascript\" type=\"text/javascript\">\n";
        jscript += "function callme () {\n";
        jscript += "var data_" + tag + " = [\n";

        final int numBars = Math.min(sortedLocations.size(), 10);

        for (int i = 0; i < numBars; i++)
        {
            e = sortedLocations.get(i);
            jscript += "{\n";
            jscript += "  data: [[" + i + ", " + e.count + "]],\n";
            jscript += "  bars: { show: true },\n";
            jscript += "  label: \"" + e.location + "\"\n";
            if (i != (numBars - 1))
            {
                jscript += "},\n";
            }
            else
            {
                jscript += "}\n";
            }
        }

        jscript += "] ;\n";
        jscript += "$.plot($(\"#" + tag + "\"), " + "data_" + tag + ") ;\n";
        jscript += "}\n";
        jscript += "callme() ;";
        jscript += "</script>";
        return jscript;
    }
}
