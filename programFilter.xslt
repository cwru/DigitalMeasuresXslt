<xsl:stylesheet version="2.0"
    xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    xmlns:fn="http://weatherhead.case.edu/xslt"
    xmlns:dm="http://www.digitalmeasures.com/schema/data"
	xmlns:dmd="http://www.digitalmeasures.com/schema/data-metadata"
    exclude-result-prefixes="fn">
	<xsl:output method="xml" encoding="UTF-8" />
	<xsl:include href="D:/web/common/xslt/DigitalMeasures/DigitalMeasuresHelper.xslt" />
    
    <xsl:param name="program" />
	
    <xsl:template match="/">

        <Data>
        	<xsl:variable name="student" select="fn:getCurrentStudents(dm:Data)" />
            <xsl:choose>
            	<xsl:when test="$program != ''">
            		<xsl:copy-of select="$student[dmd:IndexEntry[@entryKey=$program]]" />
                </xsl:when>
                <xsl:otherwise>
                	<xsl:copy-of select="$student" />
                </xsl:otherwise>
            </xsl:choose>
        </Data>
    </xsl:template>
</xsl:stylesheet>