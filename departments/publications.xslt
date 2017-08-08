<?xml version="1.0"?>
<xsl:stylesheet version="2.0"
	xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    xmlns:dmd="http://www.digitalmeasures.com/schema/data-metadata"
    xmlns:fn="http://weatherhead.case.edu/xslt"
    exclude-result-prefixes="dmd fn"
    xpath-default-namespace="http://www.digitalmeasures.com/schema/data">
<xsl:output method="xhtml" />
<xsl:include href="D:/web/common/xslt/DigitalMeasures//DigitalMeasuresHelper.xslt" />

	<!-- Input Parameters -->
	<xsl:param name="department" />
	<xsl:param name="uidList" />
	<xsl:param name="sort" select="'f'" />
	
	<!-- Main Template -->
	<xsl:template match="Data">
    <div>
		<xsl:variable name="departments" select="Record/dmd:IndexEntry[@indexKey = 'DEPARTMENT' and not(@*[name()='entryKey']=parent::node()/preceding-sibling::node()/dmd:IndexEntry[@indexKey = 'DEPARTMENT']/@*[name()='entryKey'])]"/>
		
		<xsl:if test="$sort = 'f'">
			<xsl:if test="$department != ''">
				<xsl:apply-templates select="Record[dmd:IndexEntry/@indexKey = 'DEPARTMENT' and dmd:IndexEntry/@entryKey = $department and INTELLCONT[PROFILE = 'Yes']]" />
			</xsl:if>
			<xsl:if test="$uidList != ''">
				<xsl:apply-templates select="Record[contains(concat($uidList,','),concat(@username,',')) and INTELLCONT[PROFILE = 'Yes' or WEBSITE = 'Yes']]" />
			</xsl:if>
		</xsl:if>
		<xsl:if test="$sort = 'd'">
			<ul>
			<xsl:apply-templates select="Record[contains(concat($uidList,','),concat(@username,','))]/INTELLCONT[PROFILE = 'Yes' or WEBSITE = 'Yes']">
				<xsl:sort select="DTY_PUB" order="descending" />
			</xsl:apply-templates>
			</ul>
		</xsl:if>
		</div>			
	</xsl:template>
	
	<xsl:template match="Record">
		<h4 xml:space="preserve"><xsl:value-of select="fn:getPreferredFirstName(.)" /> <xsl:value-of select="PCI/LNAME" /></h4>
		
		<ul>
        	<xsl:apply-templates select="INTELLCONT[WEBSITE = 'Yes']" />
		</ul>	
	</xsl:template>
	
	<xsl:template match="INTELLCONT">
		<li>
			<xsl:for-each select="INTELLCONT_AUTH">		
                <xsl:apply-templates select="." /><xsl:if test="position() != last()">, </xsl:if>
			</xsl:for-each>
			<xsl:if test="DTY_PUB != ''">
				(<xsl:value-of select="DTY_PUB" />).
			</xsl:if>
			<xsl:if test="EDITORS != ''">
				In <xsl:value-of select="EDITORS" /> (Ed.),
			</xsl:if>
			<xsl:if test="ABSTRACT != ''">
				<a href="../../research/library/detail?id={./@id}"><i xml:space="preserve"> <xsl:value-of select="TITLE" /> </i></a> 
			</xsl:if>
			<xsl:if test="ABSTRACT = ''">
				<i xml:space="preserve"> <xsl:value-of select="TITLE" /> </i>
			</xsl:if>  
			<xsl:if test="ISSUE != '' or VOLUME != '' or PAGENUM != ''">
				(<xsl:if test="ISSUE != ''"><xsl:value-of select="ISSUE" /> ed., </xsl:if>
				<xsl:if test="VOLUME != ''">vol. <xsl:value-of select="VOLUME" />, </xsl:if>
				<xsl:if test="PAGENUM != ''">pp. <xsl:value-of select="PAGENUM" /></xsl:if>).
			</xsl:if>
			<xsl:if test="PUBCTYST != ''">
				<xsl:value-of select="PUBCTYST" />:
			</xsl:if>
			<xsl:if test="PUBLISHER != ''">
				<xsl:value-of select="PUBLISHER" />.
			</xsl:if>
			<xsl:value-of select="WEB_ADDRESS" />
				</li>
	</xsl:template>
    
    <xsl:template match="INTELLCONT_AUTH">
    	<xsl:variable name="authorName">
        	<xsl:value-of select="LNAME" />, <xsl:value-of select="substring(FNAME,1,1)" />.<xsl:if test="matches(MNAME,'[A-Za-z]')"><xsl:text> </xsl:text><xsl:value-of select="substring(MNAME,1,1)" /><xsl:text>.</xsl:text></xsl:if>
        </xsl:variable>
    	<xsl:choose>
        	<xsl:when test="$sort = 'd' and LNAME = ../../PCI/LNAME and FNAME = ../../PCI/FNAME">
            	<xsl:value-of select="$authorName" />
            </xsl:when>
            <xsl:otherwise>
            	<xsl:value-of select="$authorName" />
            </xsl:otherwise>
        </xsl:choose>
    </xsl:template>
		
</xsl:stylesheet>