<?xml version="1.0"?>
<xsl:stylesheet version="2.0"
	xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    xmlns:fn="http://weatherhead.case.edu/xslt"
    exclude-result-prefixes="fn"
    xpath-default-namespace="http://www.digitalmeasures.com/schema/data">
    
<xsl:output omit-xml-declaration="yes" />
<xsl:include href="D:/web/weatherhead/data/DigitalMeasures/xslt/DigitalMeasuresHelper.xslt" />

	<xsl:template match="Record">
		<div id="profileheadTextContainer" class="masthead-profile-name">
			<div class="row">
				<div class="col-sm-2">
					<!-- Photo -->	
					<img src="/images/people/{@username}.jpg" style="border:0;padding-top:1em;" onerror="this.style.visibility='hidden';" class="img-responsive">
						<xsl:attribute name="alt">
							<xsl:value-of select="fn:getPreferredFirstName(.)" /><xsl:text> </xsl:text><xsl:value-of select="PCI/LNAME" />
						</xsl:attribute>
					</img>
				</div>
				<div class="col-sm-10">
					<h1><xsl:value-of select="fn:getPreferredFirstName(.)" />&#160;<xsl:value-of select="PCI/LNAME" /><xsl:if test="EDUCATION/HIGHEST[text()='Yes']/../DEG">, <xsl:value-of select="EDUCATION/HIGHEST[text()='Yes']/../DEG" /></xsl:if></h1>
					<p>
						<xsl:for-each select="ENDOWED_CHAIR[
						fn:isCurrent(START_START, END_START)
						]">
							<xsl:value-of select="ROLE" /><br />
						</xsl:for-each>
						
						<xsl:for-each select="ADMIN_ASSIGNMENTS[
						fn:isCurrent(START_START, END_START) and 
							SCOPE = 'College'
						]">
							<xsl:value-of select="ROLE" /><br />
						</xsl:for-each>
						
						<xsl:for-each select="ADMIN_ASSIGNMENTS[
						fn:isCurrent(START_START, END_START) and 
							SCOPE = 'Department'
						]">
							<xsl:value-of select="ROLE" /><br />
						</xsl:for-each>
				
						<xsl:for-each select="ADMIN/ADMIN_DEP[
						fn:isWithinCurrentAcademicYear(..)
						]">
							<xsl:value-of select="../RANK" /><xsl:choose><xsl:when test="../DISCIPLINE != ''"> of <xsl:value-of select="../DISCIPLINE" />;</xsl:when><xsl:when test="../RANK != 'Professor for the Practice of'">,</xsl:when><xsl:otherwise></xsl:otherwise></xsl:choose>&#160;<xsl:value-of select="DEP" /><br />
						</xsl:for-each>
						Weatherhead School of Management<br/>
				
						<xsl:for-each select="PASTHIST[
							fn:isCurrent(START_START, END_START) and 
						PROFILE = 'Yes'
						]">
							<xsl:value-of select="TITLE" />, <xsl:value-of select="ORG" /><br />
						</xsl:for-each>
					</p>
				</div>
			</div>
		</div>				
	</xsl:template>	
</xsl:stylesheet>