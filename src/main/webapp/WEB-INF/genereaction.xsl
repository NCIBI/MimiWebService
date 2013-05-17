<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
				version="1.0">

    <xsl:output method="xml" encoding="UTF-8" />

    <xsl:template match="/">
    	<ResultSet>	
	    <xsl:for-each select="org.ncibi.mimiweb.data.Enzyme">
	    	<Result>
	    	<Enzyme>
	    	<Name><xsl:value-of select="name"/></Name>
	    	<ECNumber><xsl:value-of select="ec"/></ECNumber>
	    	<Reactions>
	    	<xsl:for-each select="reactions/org.ncibi.mimiweb.data.MetabReaction">
	    		<Reaction>
	    			<Description><xsl:value-of select="description"/></Description>
	    			<KEGGID><xsl:value-of select="rid"/></KEGGID>
	    			<Equation><xsl:value-of select="equation"/></Equation>
	    			<ReactionText><xsl:value-of select="rxntxt"/></ReactionText>
	    			<CompoundIDs>
		    			<xsl:for-each select="compoundIds/string">
		    				<ID><xsl:value-of select="text()"/></ID>
		    			</xsl:for-each>
	    			</CompoundIDs>
	    		</Reaction>
	    	</xsl:for-each>
	    	</Reactions>
	    	</Enzyme>
	        </Result>	        	    
	    </xsl:for-each>
	    </ResultSet>
    </xsl:template>

</xsl:stylesheet>

