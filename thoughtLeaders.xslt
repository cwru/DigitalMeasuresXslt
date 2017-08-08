<?xml version="1.0" encoding="ISO-8859-1"?>
<xsl:stylesheet version="2.0"
	  xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    xmlns:dmd="http://www.digitalmeasures.com/schema/data-metadata"
    xmlns:fn="http://weatherhead.case.edu/xslt"
    exclude-result-prefixes="dmd fn"
    xpath-default-namespace="http://www.digitalmeasures.com/schema/data">
    
<xsl:include href="D:\web\common\xslt\DigitalMeasures\DigitalMeasuresHelper.xslt" />

    <!-- Main Template -->
    <xsl:template match="Data">
        
        <FacultySet>
        	<xsl:apply-templates select="fn:getCurrentFaculty(.)" />
        </FacultySet>
                
    </xsl:template>		
	
    <!-- output the selected faculty -->
	<xsl:template match="Record">
        <Faculty id="{@username}">
            <xsl:attribute name="href"><xsl:value-of select="fn:getProfileLink(.)" /></xsl:attribute>
            <xsl:attribute name="first">
                <xsl:value-of select="fn:getPreferredFirstName(.)" />
            </xsl:attribute>
            <xsl:attribute name="last">
                <xsl:value-of select="PCI/LNAME" />
            </xsl:attribute>


        <!-- Titles -->
        <xsl:for-each select="ENDOWED_CHAIR[
            fn:isCurrent(START_START, END_START)
        ]">
            <Title>
                <xsl:value-of select="ROLE" />
            </Title>
        </xsl:for-each>
        
        <xsl:for-each select="ADMIN_ASSIGNMENTS[
            fn:isCurrent(START_START, END_START) and 
            SCOPE = 'College'
        ]">
            <Title>
                <xsl:value-of select="ROLE" />
            </Title>
        </xsl:for-each>
        
        <xsl:for-each select="ADMIN_ASSIGNMENTS[
            fn:isCurrent(START_START, END_START) and 
            SCOPE = 'Department'
        ]">
            <Title>
                <xsl:value-of select="ROLE" />
            </Title>
        </xsl:for-each>

        <xsl:for-each select="ADMIN/ADMIN_DEP[
            fn:isWithinCurrentAcademicYear(..)
        ]">
            <Title>
                <xsl:value-of select="../RANK" /><xsl:choose><xsl:when test="../DISCIPLINE != ''"> of <xsl:value-of select="../DISCIPLINE" />;</xsl:when><xsl:when test="../RANK != 'Professor for the Practice of'">,</xsl:when><xsl:otherwise></xsl:otherwise></xsl:choose>&#160;<xsl:value-of select="DEP" />
            </Title>

        </xsl:for-each>

        <xsl:for-each select="PASTHIST[
            fn:isCurrent(START_START, END_START) and 
            PROFILE = 'Yes'
        ]">
            <Title>
                <xsl:value-of select="TITLE" />, <xsl:value-of select="ORG" />
            </Title>
        </xsl:for-each>

        </Faculty>
	</xsl:template>
	
</xsl:stylesheet>