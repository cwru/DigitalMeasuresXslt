<?xml version="1.0" encoding="utf-8"?>
<xsl:stylesheet version="2.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    xmlns:xs="http://www.w3.org/2001/XMLSchema"
    xmlns:dmd="http://www.digitalmeasures.com/schema/data-metadata"
    xmlns:fn="http://weatherhead.case.edu/xslt"
    exclude-result-prefixes="xs dmd fn"
    xpath-default-namespace="http://www.digitalmeasures.com/schema/data">
  <!-- output needs a BOM so ColdFusion chooses the correct encoding to read the file -->
  <xsl:output method="xml"
  	indent="no"
    omit-xml-declaration="yes"
    encoding="utf-8"
    byte-order-mark="yes" />
  <xsl:include href="D:\web\common\xslt\DigitalMeasures\DigitalMeasuresHelper.xslt" />

  <xsl:param name="byDepartmentFile">file:///C:/testing/DigitalMeasures/cached/byDepartment.xml</xsl:param>
  <xsl:param name="byTopicFile">file:///C:/testing/DigitalMeasures/cached/byTopic.xml</xsl:param>

  <xsl:template match="Data">
    <!-- Organize the research by department -->
    <xsl:result-document href="{$byDepartmentFile}">
      <!-- Can't use DigitalMeasuresHelper getDepartmentList because we need to 
          keep within the context of the document. getDepartmentList 
          copies the node set and returns it outside of the document 
          context -->
      <xsl:variable name="departments" select="Record/dmd:IndexEntry[
          @indexKey = 'DEPARTMENT' and 
          not(@*[name()='entryKey']='Information Systems') and 
          not(@*[name()='entryKey']='Marketing and Policy Studies') and 
          not(@*[name()='entryKey']=parent::node()/preceding-sibling::node()/dmd:IndexEntry[@indexKey = 'DEPARTMENT']/@*[name()='entryKey'])]"/>

      <xsl:variable name="vAllowedSymbols" select="'ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz'"/>

      <ul class="list-group" id="researchAccordion">
        <xsl:for-each select="$departments">
          <xsl:sort select="@entryKey" order="ascending" />
          <xsl:variable name="department" select="@entryKey" />
          <xsl:variable name="cleanedEntryKey" select="translate(translate(@entryKey, translate(@entryKey, $vAllowedSymbols, ''), ''), 'ABCDEFGHIJKLMNOPQRSTUVWXYZ', 'abcdefghijklmnopqrstuvwxyz')" />
          
          <li class="list-group-item">
            <div>
              <a class="list-group-item-heading" data-toggle="collapse" data-parent="#researchAccordion" href="#collapse_{$cleanedEntryKey}">
                <h2 class="big-header">
                  <xsl:value-of select="$department" />
                </h2>
              </a>
            </div>
            <div id="collapse_{$cleanedEntryKey}" class="list-group-item-text collapse">
              <xsl:call-template name="GenerateResearchList">
                <xsl:with-param name="researchList" select="//Record[
                    dmd:IndexEntry[@indexKey = 'DEPARTMENT']/@entryKey = $department
                  ]/INTELLCONT[
                      WEBSITE = 'Yes' and 
                      not(@id = parent::node()/preceding-sibling::node()[
                          dmd:IndexEntry[@indexKey = 'DEPARTMENT']/@entryKey = $department
                      ]/INTELLCONT/@id)
                  ]" />
              </xsl:call-template>
            </div>
          </li>
        </xsl:for-each>
      </ul>
    </xsl:result-document>

    <!-- Organize the research by topic -->
    <xsl:result-document href="{$byTopicFile}">
      <xsl:variable name="topics" select="Record/INTELLCONT[WEBSITE = 'Yes']/GENERAL_TOPIC[
			    not(.='') and
			    not(.=parent::node()/parent::node()/preceding-sibling::node()/INTELLCONT[WEBSITE = 'Yes']/GENERAL_TOPIC) and 
			    not(.=parent::node()/preceding-sibling::node()[WEBSITE = 'Yes']/GENERAL_TOPIC)
		    ]"/>

      <ul class="list-group" id="researchAccordion">
        <xsl:for-each select="$topics">
          <xsl:sort select="." order="ascending" />
          <xsl:variable name="topic" select="." />
          <li class="list-group-item">
            <div>
              <xsl:choose>
                <xsl:when test=".='Accounting Regulation and Standards'">
                  <a name="A" class="anchor"></a>
                </xsl:when>
                <xsl:when test=".='Business Economics'">
                  <a name="B" class="anchor"></a>
                </xsl:when>
                <xsl:when test=".='Capacity Building'">
                  <a name="C" class="anchor"></a>
                </xsl:when>
                <xsl:when test=".='Design Aspects'">
                  <a name="D" class="anchor"></a>
                </xsl:when>
                <xsl:when test=".='Emotional Intelligence'">
                  <a name="E" class="anchor"></a>
                </xsl:when>
                <xsl:when test=".='Gender and Diversity'">
                  <a name="G" class="anchor"></a>
                </xsl:when>
                <xsl:when test=".='Healthcare Management'">
                  <a name="H" class="anchor"></a>
                </xsl:when>
                <xsl:when test=".='Innovation'">
                  <a name="I" class="anchor"></a>
                </xsl:when>
                <xsl:when test=".='Leadership'">
                  <a name="L" class="anchor"></a>
                </xsl:when>
                <xsl:when test=".='Manage by Designing'">
                  <a name="M" class="anchor"></a>
                </xsl:when>
                <xsl:when test=".='NGOs'">
                  <a name="N" class="anchor"></a>
                </xsl:when>
                <xsl:when test=".='Operations'">
                  <a name="O" class="anchor"></a>
                </xsl:when>
                <xsl:when test=".='Public Policy'">
                  <a name="P" class="anchor"></a>
                </xsl:when>
                <xsl:when test=".='Quantitative Methods'">
                  <a name="Q" class="anchor"></a>
                </xsl:when>
                <xsl:when test=".='Risk Management'">
                  <a name="R" class="anchor"></a>
                </xsl:when>
                <xsl:when test=".='Social Capital'">
                  <a name="S" class="anchor"></a>
                </xsl:when>
                <xsl:when test=".='Trust'">
                  <a name="T" class="anchor"></a>
                </xsl:when>
              </xsl:choose>
              <h2 class="big-header">
                <a class="list-group-item-heading" data-toggle="collapse" data-parent="#researchAccordion" href="#collapse_{translate(.,' ','-')}">
                  <xsl:value-of select="$topic" />
                </a>
              </h2>
            </div>
            <div id="collapse_{translate(.,' ','-')}" class="list-group-item-text collapse">
              <xsl:call-template name="GenerateResearchList">
                <xsl:with-param name="researchList" select="../../../Record/INTELLCONT[
                                WEBSITE = 'Yes' and
                                not(@id = parent::node()/preceding-sibling::node()/INTELLCONT/@id) and 
                                GENERAL_TOPIC = $topic
                            ]" />
              </xsl:call-template>
            </div>
          </li>
        </xsl:for-each>
      </ul>
    </xsl:result-document>
  </xsl:template>

  <!--
  Transforms a node-set of INTELLCONT into a list of 
  titles, authors, and publication dates
  -->
  <xsl:template name="GenerateResearchList">
    <xsl:param name="researchList" />

    <ul class="list-unstyled">
      <xsl:for-each select="$researchList">

        <xsl:sort select="DTY_PUB" order="descending" />
        <xsl:sort select="TITLE" order="ascending" />

        <li style="padding: 10px 0;">
          <xsl:if test="ABSTRACT != ''">
            <a href="/faculty/research/library/detail.cfm?id={./@id}">
              <xsl:value-of select="TITLE" />
            </a>
          </xsl:if>
          <xsl:if test="ABSTRACT = ''">
            <xsl:value-of select="TITLE" />
          </xsl:if>

          <xsl:if test="count(INTELLCONT_AUTH) > 0 or DTY_PUB != ''"> (</xsl:if>
          <xsl:for-each select="INTELLCONT_AUTH">
            <xsl:value-of select="LNAME" />
            <xsl:if test="position() != last()">, </xsl:if>
          </xsl:for-each>
          <xsl:if test="DTY_PUB != ''">
            <xsl:text> </xsl:text>
            <xsl:value-of select="DTY_PUB" />
          </xsl:if>
          <xsl:if test="count(INTELLCONT_AUTH) > 0 or DTY_PUB != ''">)</xsl:if>
        </li>
      </xsl:for-each>
    </ul>
  </xsl:template>

</xsl:stylesheet>