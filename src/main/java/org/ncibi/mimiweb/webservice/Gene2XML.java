package org.ncibi.mimiweb.webservice;

/*
	Milyn - Copyright (C) 2006

	This library is free software; you can redistribute it and/or
	modify it under the terms of the GNU Lesser General Public
	License (version 2.1) as published by the Free Software
	Foundation.

	This library is distributed in the hope that it will be useful,
	but WITHOUT ANY WARRANTY; without even the implied warranty of
	MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.

	See the GNU Lesser General Public License for more details:
	http://www.gnu.org/licenses/lgpl.txt
*/

import org.milyn.Smooks;
import org.milyn.SmooksException;
import org.milyn.event.report.HtmlReportGenerator;
import org.milyn.container.ExecutionContext;
import org.milyn.payload.JavaSource;
import org.xml.sax.SAXException;

import javax.xml.transform.stream.StreamResult;
import java.io.BufferedReader;
import java.io.IOException;
import java.io.InputStreamReader;
import java.io.StringWriter;

/**
 * Simple example main class.
 * @author <a href="mailto:tom.fennelly@gmail.com">tom.fennelly@gmail.com</a>
 */
public class Gene2XML {

    /**
     * Run the transform for the request or response.
     * @param inputJavaObject The input Java Object.
     * @return The transformed Java Object XML.
     */
    public String runSmooksTransform(Object inputJavaObject, String configFile) throws IOException, SAXException {
        Smooks smooks = new Smooks(configFile);
        String resultString = new String();
        try {
            ExecutionContext executionContext = smooks.createExecutionContext();
            StringWriter writer = new StringWriter();

            // Configure the execution context to generate a report...
            //executionContext.setEventListener(new HtmlReportGenerator("target/report/report.html"));

            // Filter the message to the result writer, using the execution context...
            smooks.filterSource(executionContext, new JavaSource(inputJavaObject), new StreamResult(writer));               
            resultString = writer.toString();
/*            resultString = this.replace(resultString, "list", "ResultSet");
            resultString = this.replace(resultString, "<id>", "<GeneID type='entrez'>");
            resultString = this.replace(resultString, "</id>", "</GeneID>");
            resultString = this.replace(resultString, "<symbol>", "<GeneSymbol>");
            resultString = this.replace(resultString, "</symbol>", "</GeneSymbol>");
            resultString = this.replace(resultString, "org.ncibi.mimiweb.data.ResultGeneMolecule", "Result");
            resultString = this.replace(resultString, "<taxid>", "<TaxonomyID>");
            resultString = this.replace(resultString, "</taxid>", "</TaxonomyID>");
            resultString = this.replace(resultString, "<description>", "<GeneDescription>");
            resultString = this.replace(resultString, "</description>", "</GeneDescription>");
            resultString = this.replace(resultString, "interactionGeneIds", "InteractingGeneIDSet");
            resultString = this.replace(resultString, "<int>", "<GeneID type='entrez'>");
            resultString = this.replace(resultString, "</int>", "</GeneID>");
            resultString = this.replace(resultString, "interactionGeneSymbols", "InteractingGeneSymbolSet");
*/            
            return resultString;
            
        } finally {
            smooks.close();
        }
    }
    
        // found this here: http://www.exampledepot.com/egs/java.lang/ReplaceString.html
    	private String replace(String str, String pattern, String replace) 
    	{ 
    		int s = 0; 
    		int e = 0; 
    		StringBuffer result = new StringBuffer(); 
    		while ((e = str.indexOf(pattern, s)) >= 0) 
    		{ 
    			result.append(str.substring(s, e)); 
    			result.append(replace); 
    			s = e+pattern.length(); 
    		} 
    		result.append(str.substring(s)); 
    		return result.toString(); 
    	} 
}