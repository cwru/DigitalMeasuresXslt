<xsl:stylesheet version="2.0"
    xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    xmlns:fn="http://weatherhead.case.edu/xslt"
    xmlns:dm="http://www.digitalmeasures.com/schema/data"
    exclude-result-prefixes="fn">
	<xsl:output method="xml" encoding="UTF-8" />
	<xsl:include href="D:/web/common/xslt/DigitalMeasures/DigitalMeasuresHelper.xslt" />
    
    <xsl:param name="department" />
	
    <xsl:template match="/">
    	<!-- only select current, non-adjunct faculty -->
        <Data>
        	<xsl:variable name="faculty" select="fn:getCurrentFaculty(dm:Data, false())" />
            <xsl:choose>
            	<xsl:when test="$department != ''">
            		<xsl:copy-of select="$faculty[dm:ADMIN/dm:ADMIN_DEP/dm:DEP=$department]" />
                </xsl:when>
                <xsl:otherwise>
                	<xsl:copy-of select="$faculty" />
                </xsl:otherwise>
            </xsl:choose>
        </Data>
    </xsl:template>
</xsl:stylesheet>