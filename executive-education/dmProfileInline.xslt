<?xml version="1.0"?>
<xsl:stylesheet version="2.0"
	xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    xmlns:fn="http://weatherhead.case.edu/xslt"
    exclude-result-prefixes="fn"
    xpath-default-namespace="http://www.digitalmeasures.com/schema/data">
    
<xsl:output omit-xml-declaration="yes" />
<xsl:include href="D:/web/common/xslt/DigitalMeasures/DigitalMeasuresHelper.xslt" />

	<xsl:template match="Record">
		<!-- Photo -->
		<img src="/images/people/{@username}.jpg" style="border:0;margin:0 1em 0 0;" class="img-responsive pull-left" onerror="this.style.visibility='hidden';">
			<xsl:attribute name="alt">
				<xsl:value-of select="fn:getPreferredFirstName(.)" /><xsl:text> </xsl:text><xsl:value-of select="PCI/LNAME" />
			</xsl:attribute>
		</img>
		<!-- Name and degree -->
		<p>
			<strong>
				<xsl:value-of select="fn:getPreferredFirstName(.)" />&#160;<xsl:value-of select="PCI/LNAME" />
                <xsl:if test="EDUCATION/HIGHEST[text()='Yes']/../DEG">, <xsl:value-of select="EDUCATION/HIGHEST[text()='Yes']/../DEG" /></xsl:if>
			</strong><br />
			

			<!-- Titles -->
				
				<xsl:for-each select="ENDOWED_CHAIR[
                	fn:isCurrent(START_START, END_START)
				]">
					<span itemprop="jobTitle"><xsl:value-of select="ROLE" /></span><br />
				</xsl:for-each>
				
				<xsl:for-each select="ADMIN_ASSIGNMENTS[
                	fn:isCurrent(START_START, END_START) and 
					SCOPE = 'College'
				]">
					<span itemprop="jobTitle"><xsl:value-of select="ROLE" /></span><br />
				</xsl:for-each>
				
				<xsl:for-each select="ADMIN_ASSIGNMENTS[
                	fn:isCurrent(START_START, END_START) and 
					SCOPE = 'Department'
				]">
					<span itemprop="jobTitle"><xsl:value-of select="ROLE" /></span><br />
				</xsl:for-each>
		
				<xsl:for-each select="ADMIN/ADMIN_DEP[
                	fn:isWithinCurrentAcademicYear(..)
				]">
					<span itemprop="jobTitle"><xsl:value-of select="../RANK" /><xsl:if test="../DISCIPLINE != ''"> of <xsl:value-of select="../DISCIPLINE" /></xsl:if><xsl:if test="../RANK != 'Professor for the Practice of'">,</xsl:if>&#160;<xsl:value-of select="DEP" /></span><br />Weatherhead School of Management<br />
				</xsl:for-each>
				
				<xsl:for-each select="PASTHIST[
                	fn:isCurrent(START_START, END_START) and
					PROFILE = 'Yes'
				]">
					<xsl:value-of select="TITLE" />, <xsl:value-of select="ORG" /><br />
				</xsl:for-each>

		</p>
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
	</xsl:template>
	
</xsl:stylesheet>