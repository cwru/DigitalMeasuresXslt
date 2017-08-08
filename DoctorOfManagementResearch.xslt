<!DOCTYPE stylesheet [
  <!ENTITY nbsp   "&#160;" >
]>
<xsl:stylesheet version="2.0"
  xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
  xmlns:dmd="http://www.digitalmeasures.com/schema/data-metadata"
  xmlns:xf="http://www.w3.org/2005/xpath-functions"
  xmlns:xs="http://www.w3.org/2001/XMLSchema"
  xmlns:fn="http://weatherhead.case.edu/xslt"
  exclude-result-prefixes="fn xf"
  xpath-default-namespace="http://www.digitalmeasures.com/schema/data">
  <xsl:output method="xml" indent="yes" omit-xml-declaration="yes" />
  <xsl:include href="D:\web\common\xslt\DigitalMeasures\DigitalMeasuresHelper.xslt" />
  
  <xsl:variable name="dm">Doctor of Management</xsl:variable>
  <xsl:variable name="phd">PhD Management - Designing Sustainable Systems</xsl:variable>
  <xsl:variable name="grad">Graduation</xsl:variable>
  <xsl:variable name="entry">Program entry</xsl:variable>

  <!-- Main Template -->
  <xsl:template match="Data">
    <Data>
      <xsl:apply-templates select="Record[
        dmd:IndexEntry[
          @indexKey='DOCTORAL_PROGRAM' and 
          (@entryKey = $dm or @entryKey = $phd)
        ]
      ]">
      </xsl:apply-templates>
    </Data>
  </xsl:template>

  <xsl:template match="Record">
    <Record>
      <xsl:copy-of select="PCI" />
      <xsl:copy-of select="DOCTORAL" />
      <xsl:copy-of select="PRESENT" />
      <xsl:copy-of select="INTELLCONT" />
    </Record>
  </xsl:template>

</xsl:stylesheet>