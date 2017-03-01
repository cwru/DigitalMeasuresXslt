<?xml version="1.0"?>
<xsl:stylesheet version="2.0"
	xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    xmlns:xs="http://www.w3.org/2001/XMLSchema"
    xmlns:dmd="http://www.digitalmeasures.com/schema/data-metadata"
    xmlns:fn="http://weatherhead.case.edu/xslt"
    exclude-result-prefixes="xs dmd fn"
    xpath-default-namespace="http://www.digitalmeasures.com/schema/data">
<xsl:output method="xhtml" />
<xsl:include href="D:\web\weatherhead\data\DigitalMeasures\xslt\DigitalMeasuresHelper.xslt" />
  <xsl:param name="program" select="'Doctor of Management'" />
  <xsl:param name="year" select="'2017'" />

<xsl:template match="Data">
  <xsl:variable name="students" select="fn:getCurrentStudents(.)"/>
  <xsl:variable name="today" select="format-date(current-date(),'[Y0001]-[M01]-[D01]')" />
  <Data>
    <Classes>
      <xsl:for-each select="distinct-values($students/DOCTORAL[(PROGRAM = $program and MILESTONE = 'Anticipated graduation', PROGRAM = $program and MILESTONE = 'Graduation')[1]]/DTY_DATE)">
        <xsl:sort select="." />
        <Class><xsl:value-of select="." /></Class>
      </xsl:for-each>
    </Classes>
    <Roster>
        <ul class="list-unstyled list-roster">
            <xsl:for-each select="$students/DOCTORAL[(PROGRAM = $program and DTY_DATE = $year and MILESTONE = 'Anticipated graduation', PROGRAM = $program and DTY_DATE = $year and MILESTONE = 'Graduation')[1]]/..">
                <xsl:sort select="PCI/LNAME" />
                <xsl:sort select="(PCI/PFNAME,PCI/PNAME)[1]" />
                <li>
                    <strong>
                        <xsl:value-of select="fn:getPreferredFirstName(.)" />
                        <xsl:text> </xsl:text>
                        <xsl:if test="string-length(PCI/MNAME) &gt; 0">
                            <xsl:value-of select="PCI/MNAME" />
                            <xsl:if test="string-length(PCI/MNAME) = 1">.</xsl:if>
                            <xsl:text> </xsl:text>
                        </xsl:if>
                        <xsl:value-of select="PCI/LNAME" />
                    </strong>
                    <xsl:variable name="jobs" select="PASTHIST[@dmd:startDate &lt; $today and (not(@dmd:endDate) or @dmd:endDate &gt; $today)]" />
                    <xsl:if test="$jobs">
                        <ul>
                            <xsl:for-each select="$jobs">
                                <li>
                                    <xsl:value-of select="TITLE" /><br/>
                                    <xsl:value-of select="ORG" />
                                    <xsl:if test="string-length(CITY)">
                                        <br/>
                                        <xsl:value-of select="CITY" />
                                    </xsl:if>
                                    <xsl:if test="string-length(STATE)">
                                        <xsl:text>, </xsl:text>
                                        <xsl:value-of select="STATE" />
                                    </xsl:if>
                                    <xsl:if test="string-length(COUNTRY) and COUNTRY != 'United States'">
                                        <xsl:text>, </xsl:text>
                                        <xsl:value-of select="COUNTRY" />
                                    </xsl:if>
                                </li>
                            </xsl:for-each>
                        </ul>
                    </xsl:if>
                </li>
            </xsl:for-each>
        </ul>
    </Roster>
  </Data>
</xsl:template>	
		
</xsl:stylesheet>