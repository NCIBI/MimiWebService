<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
				version="1.0">

    <xsl:output method="xml" encoding="UTF-8" />

    <xsl:template match="/">
    	<ResultSet>	
	    	<Result>
	    	<xsl:for-each select="org.ncibi.mimiweb.data.MetabReaction">
	    		<Reaction>
	    			<Description><xsl:value-of select="description"/></Description>
	    			<KEGGID><xsl:value-of select="rid"/></KEGGID>
	    			<Equation><xsl:value-of select="equation"/></Equation>
	    			<ReactionText><xsl:value-of select="rxntxt"/></ReactionText>
	    			<Genes>
		    			<xsl:for-each select="genes/org.ncibi.mimiweb.data.StringItem">
		    				<Gene>
			    				<ID><xsl:value-of select="id"/></ID>
			    				<Symbol><xsl:value-of select="str"/></Symbol>
		    				</Gene>
		    			</xsl:for-each>
	    			</Genes>
	    			<CompoundIDs>
		    			<xsl:for-each select="compoundIds/string">
		    				<ID><xsl:value-of select="text()"/></ID>
		    			</xsl:for-each>
	    			</CompoundIDs>
	    		</Reaction>
	    	</xsl:for-each>
	        </Result>	        	    
	    </ResultSet>
    </xsl:template>

</xsl:stylesheet>

