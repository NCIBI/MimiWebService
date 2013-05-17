<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
				version="1.0">

    <xsl:output method="xml" encoding="UTF-8" />

    <xsl:template match="/">
    	<ResultSet>	
	    <xsl:for-each select="org.ncibi.mimiweb.data.GeneInteractionList/list/org.ncibi.mimiweb.data.hibernate.DenormInteraction">
	    	<Result>
	    	<InteractingGene>
	    	<InteractionID><xsl:value-of select="ggIntID"/></InteractionID>
	    	<GeneID type="entrez"><xsl:value-of select="geneid2"/></GeneID>
	    	<GeneSymbol><xsl:value-of select="symbol2"/></GeneSymbol>
	        <TaxonomyID><xsl:value-of select="taxid2"/></TaxonomyID>
	       	<xsl:for-each select="attributes/org.ncibi.mimiweb.data.hibernate.DenormInteractionAttribute">
	       		<InteractionAttribute>
		       		<xsl:attribute name="type">
	                	<xsl:value-of select="id/attrType/text()"/>
	                </xsl:attribute>
	                <xsl:value-of select="id/attrValue/text()"/>	
	       		</InteractionAttribute>
	       	</xsl:for-each>	        
	        </InteractingGene>
	        </Result>	        	    
	    </xsl:for-each>
	    </ResultSet>
    </xsl:template>

</xsl:stylesheet>

