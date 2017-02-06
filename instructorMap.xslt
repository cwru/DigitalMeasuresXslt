<xsl:stylesheet version="2.0"
	xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    xmlns:dmd="http://www.digitalmeasures.com/schema/data-metadata"
    xmlns:fn="http://weatherhead.case.edu/xslt"
    exclude-result-prefixes="dmd fn"
    xpath-default-namespace="http://www.digitalmeasures.com/schema/data">
<xsl:output method="xml" indent="yes" omit-xml-declaration="no" />

  <xsl:include href="D:\web\weatherhead\data\DigitalMeasures\xslt\DigitalMeasuresHelper.xslt" />

	<!-- Main Template -->
  <xsl:template match="Data">
    <!-- Get current faculty, include adjunct (second parameter set to true) -->
    <xsl:variable name="records" select="fn:getCurrentFaculty(., true())" />
		
		<Instructors>
			<xsl:for-each select="$records">
				<Instructor name="{translate(fn:getPreferredFirstName(.),'ABCDEFGHIJKLMNOPQRSTUVWXYZ .,','abcdefghijklmnopqrstuvwxyz-')}-{translate(PCI/LNAME,'ABCDEFGHIJKLMNOPQRSTUVWXYZ .,','abcdefghijklmnopqrstuvwxyz-')}" netid="{translate(@username,'ABCDEFGHIJKLMNOPQRSTUVWXYZ','abcdefghijklmnopqrstuvwxyz')}" dmid="{@userId}" />
			</xsl:for-each>
		</Instructors> 
		
	</xsl:template>

</xsl:stylesheet>