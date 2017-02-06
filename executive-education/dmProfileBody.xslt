<?xml version="1.0"?>
<xsl:stylesheet version="2.0"
	xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    xmlns:fn="http://weatherhead.case.edu/xslt"
    exclude-result-prefixes="fn"
    xpath-default-namespace="http://www.digitalmeasures.com/schema/data">
    
<xsl:output omit-xml-declaration="yes" />
<xsl:include href="D:/web/weatherhead/data/DigitalMeasures/xslt/DigitalMeasuresHelper.xslt" />

<xsl:template match="Record">
	<div class="profileContent">
   		<!-- Bio -->
        <xsl:variable name="bio">
            <xsl:choose>
                <xsl:when test="WEB_PROFILE/BIO_EXEC != ''">
                    <xsl:copy-of select="WEB_PROFILE/BIO_EXEC" />
                </xsl:when>
                <xsl:when test="WEB_PROFILE/BIO_PROFILE != ''">
                    <xsl:copy-of select="WEB_PROFILE/BIO_PROFILE" />
                </xsl:when>
                <xsl:otherwise>
                    <xsl:copy-of select="WEB_PROFILE/BIO" />
                </xsl:otherwise>
            </xsl:choose>
        </xsl:variable>
    	<p><xsl:copy-of select="fn:lineBreaksToBrs($bio)" /></p>
        <!-- More info link goes to faculty profile -->
		<p>More information about <a href="{fn:getProfileLink(.)}"><xsl:value-of select="fn:getPreferredFirstName(.)" /><xsl:text disable-output-escaping="yes"> </xsl:text><xsl:value-of select="PCI/LNAME"/></a></p>
	</div>
</xsl:template>	

</xsl:stylesheet>