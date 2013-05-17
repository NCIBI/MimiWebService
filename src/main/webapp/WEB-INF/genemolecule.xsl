<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
				version="1.0">

    <xsl:output method="xml" encoding="UTF-8" />

    <xsl:template match="/">
    		
	    <xsl:for-each select="list/org.ncibi.mimiweb.data.ResultGeneMolecule">
	    	<Result>
	    	<GeneID type="entrez"><xsl:value-of select="id"/></GeneID>
	    	<GeneSymbol><xsl:value-of select="symbol"/></GeneSymbol>
	        <TaxonomyID><xsl:value-of select="taxid"/></TaxonomyID>
	        <Organism><xsl:value-of select="taxScientificName"/></Organism>
	        <GeneDescription><xsl:value-of select="description"/></GeneDescription>
	        <GeneType><xsl:value-of select="geneType"/></GeneType>
	        <InteractingGeneIDs>
		        <xsl:for-each select="interactionGeneIds/int[text()!=-1]">
		        	<GeneID type="entrez"><xsl:value-of select="text()"/></GeneID>
		        </xsl:for-each>
	        </InteractingGeneIDs>
	        <InteractingGeneSymbols>
		        <xsl:for-each select="interactionGeneSymbols/string">
		        	<GeneSymbol><xsl:value-of select="text()"/></GeneSymbol>
		        </xsl:for-each>
	        </InteractingGeneSymbols>	        
	        </Result>	    
	    </xsl:for-each>
    </xsl:template>

</xsl:stylesheet>

