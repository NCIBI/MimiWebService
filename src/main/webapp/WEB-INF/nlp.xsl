<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
				version="1.0">

    <xsl:output method="xml" encoding="UTF-8" />

    <xsl:template match="/">
    	<ResultSet>	
	    <xsl:for-each select="list/org.ncibi.db.pubmed.gin.ClassifiedInteraction">
	    	<Result>
	    	<NlpInteractingGene>
	    	<GeneID type="entrez"><xsl:value-of select="geneID2"/></GeneID>
	    	<Tag2><xsl:value-of select="tag2"/></Tag2>
	        <TaxonomyID><xsl:value-of select="taxid"/></TaxonomyID>
            <Sentence><xsl:value-of select="sentence"/></Sentence>
            <PubMed><xsl:value-of select="pmid"/></PubMed>
	        </NlpInteractingGene>
	        </Result>	        	    
	    </xsl:for-each>
	    </ResultSet>
    </xsl:template>

</xsl:stylesheet>

