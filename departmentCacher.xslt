<?xml version="1.0" encoding="utf-8"?>
<xsl:stylesheet version="2.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    xmlns:xs="http://www.w3.org/2001/XMLSchema"
    xmlns:dmd="http://www.digitalmeasures.com/schema/data-metadata"
    xmlns:fn="http://weatherhead.case.edu/xslt"
    exclude-result-prefixes="xs fn"
    xpath-default-namespace="http://www.digitalmeasures.com/schema/data">
  <!-- output needs a BOM so ColdFusion chooses the correct encoding to read the file -->
  <xsl:output method="xml"
  	indent="no"
    omit-xml-declaration="yes"
    encoding="utf-8"
    byte-order-mark="yes" />
  <xsl:include href="D:\web\common\xslt\DigitalMeasures\DigitalMeasuresHelper.xslt" />

  <xsl:param name="departmentCacheDirectory">file:///C:/testing/DigitalMeasures/cached/departments/</xsl:param>
  
  <xsl:template match="Data">
    <xsl:variable name="data" select="." />
    <xsl:for-each select="fn:getAllDepartments(.)">
      <xsl:variable name="dep" select="@entryKey" />
      <xsl:result-document href="{$departmentCacheDirectory}{$dep}.{format-dateTime(current-dateTime(),'[Y0001][M01][D01][H01][m01]')}.xml">
        <Data xmlns="http://www.digitalmeasures.com/schema/data">
          <!-- Copy all root attributes -->
          <xsl:copy-of select="$data/@*" />
          <!-- Copy the records that are part of the department -->
          <xsl:copy-of select="$data/Record[ADMIN/ADMIN_DEP/DEP = $dep]" />
        </Data>
      </xsl:result-document>
    </xsl:for-each>  
  </xsl:template>

</xsl:stylesheet>