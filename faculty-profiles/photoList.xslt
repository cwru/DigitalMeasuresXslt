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
	
		<xsl:variable name="records" select="fn:getCurrentFaculty(.)" />
		<xsl:variable name="departments" select="fn:getDepartmentList(.)" />	

		<!-- ****** SORT BY NAME ****** -->
		<xsl:if test="$sortBy != 'd'">
        
            <xsl:call-template name="BuildRow">
                <xsl:with-param name="records" select="$records"/>
            </xsl:call-template>
            
		</xsl:if>
		
		<!-- ****** SORT BY DEPARTMENT ****** -->
		<xsl:if test="$sortBy = 'd'">
			
            <xsl:for-each select="$departments">
                <xsl:sort select="@entryKey" order="ascending" />
                <section>
                    <h2 class="big-header"><xsl:value-of select="@entryKey" /></h2>
                
                <xsl:call-template name="BuildColumn">
                    <xsl:with-param name="records" select="$records[
                        ADMIN/ADMIN_DEP[DEP = current()/@entryKey]
                    ]" />
                </xsl:call-template>
                </section>
                <hr />
            </xsl:for-each>
		
		</xsl:if>
					
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
        	<dl>
			<xsl:for-each select="$records">
				<div class="well row">
					<div class="col-sm-3">
						<h4><xsl:value-of select="@username" /></h4>
                        <xsl:value-of select="PCI/LNAME" />, <xsl:value-of select="fn:getPreferredFirstName(.)" />
					</div>
					<div class="col-sm-3">
						<center>260 square</center>
						<img src="https://weatherhead.case.edu/images/people/{@username}.jpg" class="img-responsive" onerror="this.src='/images/people/no-photo.jpg';" />
					</div>
					<div class="col-sm-3">
						<center>210 circle</center>
						<img src="https://weatherhead.case.edu/images/people/circles/210/{@username}.png" class="img-responsive" onerror="this.style.visibility='hidden';" />
					</div>
					<div class="col-sm-3">
						<center>133 circle</center>
						<img src="https://weatherhead.case.edu/images/people/circles/133/{@username}.png" class="img-responsive" onerror="this.style.visibility='hidden';" />
					</div>
				</div>
			</xsl:for-each>
            </dl>
	</xsl:template>
	
</xsl:stylesheet>