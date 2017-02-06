<?xml version="1.0"?>
<xsl:stylesheet version="2.0"
	xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    xmlns:dmd="http://www.digitalmeasures.com/schema/data-metadata"
    xmlns:fn="http://weatherhead.case.edu/xslt"
    exclude-result-prefixes="dmd fn"
    xpath-default-namespace="http://www.digitalmeasures.com/schema/data">
    
<xsl:output method="xhtml" encoding="UTF-8" />
<xsl:include href="D:/web/weatherhead/data/DigitalMeasures/xslt/DigitalMeasuresHelper.xslt" />

	<!-- Input Parameters -->
	<xsl:param name="sortBy" select="p" />

  <!-- Main Template -->
	<xsl:template match="Data">
    <div>

      <xsl:variable name="records" select="fn:getCurrentFaculty(.)" />
		<xsl:variable name="departments" select="fn:getDepartmentList(.)" />	

		<!-- ****** SORT BY NAME ****** -->
		<xsl:if test="$sortBy != 'd'">
			<xsl:variable name="sorted" as="element(Record)+">
				<xsl:perform-sort select="$records">
					<xsl:sort select="PCI/LNAME"/>
				</xsl:perform-sort>
			</xsl:variable>
            <xsl:call-template name="BuildRow">
                <xsl:with-param name="records" select="$sorted"/>
            </xsl:call-template>
            
		</xsl:if>
		
		<!-- ****** SORT BY DEPARTMENT ****** -->
		<xsl:if test="$sortBy = 'd'">
			
            <xsl:for-each select="$departments">
                <xsl:sort select="@entryKey" order="ascending" />
                <section>
                    <h2 class="big-header"><xsl:value-of select="@entryKey" /></h2>
                
                <xsl:call-template name="BuildRow">
                    <xsl:with-param name="records" select="$records[
                        ADMIN/ADMIN_DEP[DEP = current()/@entryKey and fn:isWithinCurrentAcademicYear(..)]
                    ]" />
                </xsl:call-template>
                </section>
                <hr />
            </xsl:for-each>
		
		</xsl:if>

    </div>
  </xsl:template>		
	
	<!-- Template To Build 3 Columns of Passed Records -->
	<xsl:template name="BuildRow">
		<xsl:param name="records" />
		<xsl:variable name="columnLength" select="ceiling(count($records) div 2)" />
		<xsl:variable name="columnLength2" select="$columnLength + round(count($records) div 2)" />
		<div class="row">
			<xsl:call-template name="BuildColumn">
				<xsl:with-param name="records" select="$records[position() &lt;= $columnLength]"/>
			</xsl:call-template>
			<xsl:call-template name="BuildColumn">
				<xsl:with-param name="records" select="$records[position() &gt; $columnLength and position() &lt;= $columnLength2]"/>
			</xsl:call-template>
			<!--<xsl:call-template name="BuildColumn">
				<xsl:with-param name="records" select="$records[position() &gt; $columnLength2]"/>
			</xsl:call-template>-->
		</div>	
	</xsl:template>	
	
	<!-- Template To Build A Column Of Passed Records -->
	<xsl:template name="BuildColumn">
		<xsl:param name="records" />		
		<div class="col-sm-6">
        	<dl>
			<xsl:for-each select="$records">
				<dt>
					<a class="instructor" data-id="{@username}">
						<xsl:attribute name="href"><xsl:value-of select="fn:getProfileLink(.)" /></xsl:attribute>
                        <xsl:value-of select="PCI/LNAME" />, <xsl:value-of select="fn:getPreferredFirstName(.)" />
					</a>
				</dt>
					
				<xsl:for-each select="ADMIN/ADMIN_DEP[fn:isWithinCurrentAcademicYear(..)]">
                	<dd><xsl:value-of select="../RANK" /><xsl:if test="../DISCIPLINE != ''"> of <xsl:value-of select="../DISCIPLINE" /></xsl:if><!--<xsl:if test="../RANK != 'Professor for the Practice of'">,</xsl:if>&#160;<xsl:value-of select="DEP" />--></dd>
				</xsl:for-each>
			</xsl:for-each>
            </dl>
		</div>
	</xsl:template>
	
</xsl:stylesheet>