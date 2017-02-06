<?xml version="1.0"?>
<xsl:stylesheet version="2.0"
    xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    xmlns:dmd="http://www.digitalmeasures.com/schema/data-metadata"
    xmlns:xs="http://www.w3.org/2001/XMLSchema"
    xmlns:fn="http://weatherhead.case.edu/xslt"
    exclude-result-prefixes="xs fn dmd"
    xpath-default-namespace="http://www.digitalmeasures.com/schema/data">
  <xsl:output encoding="UTF-8" method="xhtml"/>
  <xsl:include href="D:/web/weatherhead/data/DigitalMeasures/xslt/DigitalMeasuresHelper.xslt"/>
  <!-- Input Parameters -->
  <xsl:param name="sortBy" select="p"/>
  <!-- Main Template -->
  <xsl:template match="Data">
    <div>
      <xsl:variable name="records" select="fn:getCurrentStudents(.)"/>
      <xsl:variable name="programs" select="fn:getProgramList(.)"/>
      <!-- ****** SORT BY NAME ****** -->
      <xsl:if test="$sortBy != 'p'">
        <xsl:call-template name="BuildRow">
          <xsl:with-param name="records" select="$records"/>
        </xsl:call-template>
      </xsl:if>
      <!-- ****** SORT BY DEPARTMENT ****** -->
      <xsl:if test="$sortBy = 'p'">
        <ul class="list-group" id="studentsAccordion">
          <xsl:for-each select="$programs">
            <xsl:sort order="ascending" select="@entryKey"/>
            <xsl:variable name="program" select="@entryKey"/>
            <xsl:variable name="students"/>
            <xsl:choose>
              <xsl:when test="$records/dmd:IndexEntry[@indexKey = 'DOCTORAL_PROGRAM' and $program = 'Doctor of Management']/..">
                <xsl:call-template name="BuildProgramCollapse">
                  <xsl:with-param name="program" select="$program"/>
                  <xsl:with-param name="students" select="$records/DOCTORAL[@dmd:primaryKey = concat($program,'|Program entry') or @dmd:primaryKey = 'PhD Management - Designing Sustainable Systems|Program entry']/.."/>
                </xsl:call-template>
              </xsl:when>
              <xsl:otherwise>
                <xsl:call-template name="BuildProgramCollapse">
                  <xsl:with-param name="program" select="$program"/>
                  <xsl:with-param name="students" select="$records/DOCTORAL[@dmd:primaryKey = concat($program,'|Program entry')]/.."/>
                </xsl:call-template>
              </xsl:otherwise>
            </xsl:choose>
          </xsl:for-each>
        </ul>
      </xsl:if>
    </div>
  </xsl:template>
  <xsl:template name="BuildProgramCollapse">
    <xsl:param name="program"/>
    <xsl:param name="students"/>
    <xsl:if test="count($students) &gt; 0">
      <xsl:variable name="slug" select="translate($program, 'ABCDEFGHIJKLMNOPQRSTUVWXYZ ,.#_!?*:;=+&amp;', 'abcdefghijklmnopqrstuvwxyz-------------')" />
      <li class="list-group-item">
        <div>
          <a class="list-group-item-heading" data-parent="#studentsAccordion" data-toggle="collapse" href="#collapse_{$slug}">
            <h2 class="big-header">
              <xsl:value-of select="$program"/>
            </h2>
          </a>
        </div>
        <div class="list-group-item-text collapse" id="collapse_{$slug}">
          <xsl:call-template name="BuildRow">
            <xsl:with-param name="records" select="$students"/>
          </xsl:call-template>
        </div>
      </li>
    </xsl:if>
  </xsl:template>
  <!-- Template To Build 3 Columns of Passed Records -->
  <xsl:template name="BuildRow">
    <xsl:param name="records"/>
    <xsl:variable name="columnLength" select="ceiling(count($records) div 2)"/>
    <xsl:variable name="columnLength2" select="$columnLength + round(count($records) div 2)"/>
    <div class="row">
      <xsl:call-template name="BuildColumn">
        <xsl:with-param name="records" select="$records[position() &lt;= $columnLength]"/>
      </xsl:call-template>
      <xsl:call-template name="BuildColumn">
        <xsl:with-param name="records" select="$records[position() &gt; $columnLength and position() &lt;= $columnLength2]"/>
      </xsl:call-template>
      <!--<xsl:call-template name="BuildColumn"><xsl:with-param name="records" select="$records[position() &gt; $columnLength2]"/></xsl:call-template>-->
    </div>
  </xsl:template>
  <!-- Template To Build A Column Of Passed Records -->
  <xsl:template name="BuildColumn">
    <xsl:param name="records"/>
    <div class="col-sm-6">
      <dl>
        <xsl:for-each select="$records">
          <dt>
            <a class="instructor" data-id="{@username}">
              <xsl:attribute name="href">
                <xsl:value-of select="fn:getProfileLink(.,'students')"/>
              </xsl:attribute>
              <xsl:value-of select="PCI/LNAME"/>, 
              
              <xsl:value-of select="fn:getPreferredFirstName(.)"/></a>
          </dt>
          <!--<xsl:for-each select="ADMIN/ADMIN_DEP[fn:isWithinCurrentAcademicYear(..)]"><dd><xsl:value-of select="../RANK" /><xsl:if test="../RANK != 'Professor for the Practice of'">,</xsl:if>&#160;<xsl:value-of select="DEP" /></dd></xsl:for-each>-->
        </xsl:for-each>
      </dl>
    </div>
  </xsl:template>

</xsl:stylesheet>