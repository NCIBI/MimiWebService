<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
				version="1.0">

    <xsl:output method="xml" encoding="UTF-8" />

    <xsl:template match="/">
    	<ResultSet>	
	    <xsl:for-each select="org.ncibi.mimiweb.data.Compound">
	    	<Result>
	    	<Compound>
	    	<CompoundID><xsl:value-of select="cid"/></CompoundID>
	    	<CompoundName><xsl:value-of select="name"/></CompoundName>
	    	<MolecularFormula><xsl:value-of select="mf"/></MolecularFormula>
	        <MolecularWeight><xsl:value-of select="molecularWeight"/></MolecularWeight>
			<CASNumber><xsl:value-of select="casnum"/></CASNumber>        
	        </Compound>
	        </Result>	        	    
	    </xsl:for-each>
	    </ResultSet>
    </xsl:template>

</xsl:stylesheet>

