<?xml version="1.0"?>
<%@ page contentType="text/xml" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ page import="java.util.ArrayList, 
            org.ncibi.mimiweb.data.*, 
            org.ncibi.mimiweb.util.PropertiesUtil,
            org.apache.lucene.queryParser.ParseException,
            org.ncibi.mimiweb.lucene.*, 
            org.ncibi.mimiweb.util.SearchTermUtil,
            org.ncibi.commons.lang.StrUtils,
            org.ncibi.commons.closure.AbstractFieldGetter,
            org.ncibi.mimiweb.data.*,
            org.ncibi.mimiweb.webservice.*,          
		    java.util.List,
		    org.ncibi.db.pubmed.gin.ClassifiedInteraction,
		    org.ncibi.mimiweb.hibernate.*,
		    org.ncibi.mimiweb.data.hibernate.*,
			org.ncibi.mimiweb.decorator.DocListDataWrapper,
		    org.ncibi.mimiweb.decorator.RxnTxtColumnDecorator,
		    org.ncibi.mimiweb.decorator.InteractionPublicationCountColumnDecorator,
		    org.ncibi.mimiweb.util.GoUtils,
		    org.ncibi.mimiweb.util.PsiDownload,
		    org.ncibi.mimiweb.util.PropertiesUtil,
		    org.ncibi.mimiweb.util.GeneLinkoutUtil" 
%>
<NCIBI>
   <MiMI>
   	
    <%
    boolean sawError = false ;
	boolean noResults = false;
	boolean useLimit = false;
	int limitCount = 100;
	String errorMsg = "There was an error getting results.";
	String xmlOutput = new String();
	String searchType = new String();
	String searchTerm = new String();
	String configFile = new String();
	String typeParam = request.getParameter("type");
	Object output = new Object(); 
	HumDBQueryInterface humdb = HumDBQueryInterface.getInterface();
	
	Gene2XML g2xml = new Gene2XML();
	
    if(request.getParameter("geneid") != null)
    {
    	searchType = "GeneID";
    	searchTerm = (String) request.getParameter("geneid");
        String geneid = searchTerm ;
        int id = Integer.parseInt(geneid);
                
    	if((request.getParameter("type") != null) && (request.getParameter("type").equals("compounds")))
    	{
    		configFile = "genecompound-config.xml";
    		output = humdb.getCompoundsForGeneid(id);

    	}
    	else if((request.getParameter("type") != null) && (request.getParameter("type").equals("reactions")))
    	{
    		configFile = "genereaction-config.xml";
        	output = humdb.getEnzymeForGeneId(id);

    	}
    	else if(typeParam == null || ((typeParam != null) && (typeParam.equals("interactions"))))
    	{
	    	
	    	configFile = "geneinteraction-config.xml";
	    	LuceneInterface l = LuceneInterface.getInterface();
	    	ResultGeneMolecule gene = l.getGeneData(id);
	    	if (gene != null)
	    	{
		    	String geneName = gene.getSymbol();
		    	String taxName = gene.getTaxScientificName();
		    	output = new GeneInteractionList(id);
	    	}
	    	else 
	    		output = null;
    	}
    	else if (typeParam.equals("nlp"))
    	{
    	    System.out.println("typeParam = nlp");
    	    configFile = "genenlp-config.xml";
    	    PubmedDBQueryInterface pubmed = PubmedDBQueryInterface.getInterface();
    	    List<ClassifiedInteraction> p = pubmed.getNlpInteractionsForGeneId(id);
    	    System.out.println("size = " + p.size());
    	    output = pubmed.getNlpInteractionsForGeneId(id);
    	}
    	else 
    	{
    		sawError = true;
    		errorMsg = "Please supply a valid query type.";
    	}
    }
    else if((request.getParameter("cid") != null))
    {
    	searchType = "CompoundID";
    	configFile = "compound-config.xml";
    	searchTerm = (String) request.getParameter("cid");
        String cid = searchTerm;
        output = humdb.getCompoundDetailsForCid(cid);
    }
    else if((request.getParameter("rid") != null))
    {
    	searchType = "ReactionID";
    	configFile = "reaction-config.xml";
    	searchTerm = (String) request.getParameter("rid");
        String rid = searchTerm ;
		output = humdb.getReactionDetailsForRid(rid);
    } 
    else if((request.getParameter("search") != null))
    {

        String limitResultsString = request.getParameter("limitResults");
        System.out.println("limitResults = " + limitResultsString);
        
        if (limitResultsString != null){
        	try {
        		int probe = Integer.parseInt(limitResultsString);
        		limitCount = probe;
        		useLimit = true;
        	} catch (Throwable ignore){
        		System.out.println("could not parse " + limitResultsString);
            	useLimit = false;
        	}
        } else {
        	useLimit = false;
        }

        searchType = "SearchTerm";
    	configFile = "genemolecule-config.xml";
        searchTerm = (String) request.getParameter("search") ;
        String listsearch = (String) request.getParameter("listsearch") ;

        String saveListString = PropertiesUtil.getProperty("savelist") ;
        boolean useSaveList = (saveListString != null) && saveListString.equals("on");

        if (searchTerm == null && listsearch == null)
        {
            listsearch = (String) session.getAttribute("query");
        }

        if (listsearch != null)
        {
            searchTerm = listsearch ; // override search if present
        }

        int taxid = -1;
        String taxString = (String) request.getParameter("taxid");
        if (taxString != null) {
	        try {
	        	taxid = Integer.parseInt(taxString);
	        } catch (Throwable ignore) {}
        }
        LuceneInterface l = LuceneInterface.getInterface() ;
        
        List<ResultGeneMolecule> rgm = null ;
        try
        { 
        	if (useLimit) {
    			System.out.println("Using limit: " + searchTerm + ", count = " + limitCount);
    			rgm = l.fullGeneSearch(taxid,searchTerm,limitCount);
        	} else {
    			System.out.println("Not using limit: " + searchTerm + ", count = " + limitCount);
	        	rgm = l.fullGeneSearch(taxid, searchTerm);
        	}
			System.out.println("Length of results = " + rgm.size());
        	if(!rgm.isEmpty())
            	output = rgm;
        }
        catch (Exception e)
        {
            sawError = true ;
            e.printStackTrace();
        }
    }//if geneid
    
        if (sawError == false && output != null)
        {
        	xmlOutput = g2xml.runSmooksTransform(output, configFile);
%>   	<Request type="fetch">  		
   			<ParameterSet>
   			<<%=searchType%>><%=searchTerm%></<%=searchType%>>
   			</ParameterSet>  		
   		</Request>
   		<Response>
		   <Copyright>
				<Statement>
					Copyright 2010 by the Regents of the University of Michigan
				</Statement>
				<Year>2009</Year>
				<Details>http://mimi.ncibi.org/MimiWeb/AboutPage.html#licensing</Details>
			</Copyright>
	   		<Support>
				<Statement>
				Supported by the National Institutes of Health as part of the NIH\'s National Center for Integrative Biomedical Informatics (NCIBI)
				</Statement>
				<GrantNumber>U54 DA021519</GrantNumber>
				<Details>http://www.ncibi.org</Details>
			</Support>
   			<%=xmlOutput%>
   		</Response>
<%
    }
    else if(!sawError)//if no results
    {
%> 
   		<Request type="fetch">  		
   			<ParameterSet>
   			<<%=searchType%>><%=searchTerm%></<%=searchType%>>
   			</ParameterSet>  		
   		</Request>
  		 <Response>
  			There were no records that matched your query.
  		</Response>
<%
    }
    else //if error
    {
%> 
  		 <Response>
  			<Error>
  			<Message><%=errorMsg%></Message>
  			</Error>
  		</Response>
<%
    }
%>
   </MiMI>
	</NCIBI>


