<xsl:stylesheet version="2.0"
  xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    xmlns:dmd="http://www.digitalmeasures.com/schema/data-metadata"
    xmlns:fn="http://weatherhead.case.edu/xslt"
    exclude-result-prefixes="dmd fn"
    xpath-default-namespace="http://www.digitalmeasures.com/schema/data">
  <xsl:output method="xml" indent="yes" omit-xml-declaration="yes" />
  <xsl:include href="D:\web\weatherhead\data\DigitalMeasures\xslt\DigitalMeasuresHelper.xslt" />
  
  <!-- Main Template -->
  <xsl:template match="Data">
    <!-- Get current faculty, include adjunct (second parameter set to true) -->
    <xsl:variable name="records" select="fn:getCurrentFaculty(., true())" />
    
    <rewriteMaps>
      <rewriteMap name="FacultyNames">
        <xsl:for-each select="$records">
          <!-- output for both the preferred name and actual name -->
          <xsl:if test="PCI/PFNAME != ''">
            <xsl:variable name="url">
              <xsl:text>/faculty/</xsl:text>
              <xsl:value-of select="translate(PCI/PFNAME,' .,','-')" />
              <xsl:text>-</xsl:text>
              <xsl:value-of select="translate(PCI/LNAME,' .,','-')" />
            </xsl:variable>
            <add key="{$url}"  value="{@userId}" />
            <add key="{$url}/" value="{@userId}" />
          </xsl:if>
          <xsl:if test="PCI/FNAME != ''">
            <xsl:variable name="url">
              <xsl:text>/faculty/</xsl:text>
              <xsl:value-of select="translate(PCI/FNAME,' .,','-')" />
              <xsl:text>-</xsl:text>
              <xsl:value-of select="translate(PCI/LNAME,' .,','-')" />
            </xsl:variable>
            <add key="{$url}"  value="{@userId}" />
            <add key="{$url}/" value="{@userId}" />
          </xsl:if>
        </xsl:for-each>
      </rewriteMap>
    </rewriteMaps> 
    
  </xsl:template>

</xsl:stylesheet>