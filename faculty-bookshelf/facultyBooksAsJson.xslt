<xsl:stylesheet version="2.0"
	xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
	xmlns:fn="http://weatherhead.case.edu/xslt"
    exclude-result-prefixes="fn"    
    xpath-default-namespace="http://www.digitalmeasures.com/schema/data">
<xsl:output method="text" />
<xsl:include href="D:/web/common/xslt/DigitalMeasures/DigitalMeasuresHelper.xslt" />

<!-- create a key to select all unique titles -->
<xsl:key name="booksByTitle" match="INTELLCONT[STATUS = 'Published' and starts-with(CONTYPE,'Book') and not(contains(CONTYPE,'Chapter')) and PUBLICAVAIL = 'Yes' and (WEBSITE = 'Yes' or PROFILE = 'Yes') and fn:isCurrentFaculty(..)]" use="TITLE" />

<!-- filter duplicates and sort -->
<xsl:template match="/">
<div>
	<xsl:text>[</xsl:text>
    <xsl:apply-templates select="//INTELLCONT[generate-id() = generate-id(key('booksByTitle', TITLE)[1])]">
        <xsl:sort select="DTY_PUB" order="descending" />
    </xsl:apply-templates>
   	<xsl:text>]</xsl:text>
</div>
</xsl:template>

<!-- Replace quotes in titles so that the JSON remains valid -->
<xsl:template match="INTELLCONT">
{
    "title":"<xsl:value-of select="replace(TITLE, '&quot;', '\\&quot;')" />",
    "authors":[
        <xsl:for-each select="INTELLCONT_AUTH">
            "<xsl:choose>
                <xsl:when test="PFNAME != ''">
                    <xsl:value-of select="PFNAME" />
                </xsl:when>
                <xsl:otherwise>
                    <xsl:value-of select="FNAME" />
                </xsl:otherwise>
            </xsl:choose>
            <xsl:text> </xsl:text>
            <xsl:value-of select="LNAME" />"
            <xsl:if test="position() != last()">,</xsl:if>
        </xsl:for-each>
    ],
    "publisher":"<xsl:value-of select="PUBLISHER" />",
    "year":"<xsl:choose>
        <xsl:when test="DTY_PUB != ''">
            <xsl:value-of select="DTY_PUB" />
        </xsl:when>
        <xsl:otherwise>
            <xsl:value-of select="DTY_PROJECT" />
        </xsl:otherwise>
    </xsl:choose>",
    "link":"<xsl:value-of select="fn:getProfileLink(..)" />",
    "id":"<xsl:value-of select="@id" />"
}
    <xsl:if test="position() != last()">,</xsl:if>
</xsl:template>

</xsl:stylesheet>