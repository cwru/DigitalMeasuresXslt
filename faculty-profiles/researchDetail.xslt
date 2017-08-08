<?xml version="1.0"?>
<xsl:stylesheet exclude-result-prefixes="dmd fn" version="2.0" xmlns:dmd="http://www.digitalmeasures.com/schema/data-metadata" xmlns:fn="http://weatherhead.case.edu/xslt" xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xpath-default-namespace="http://www.digitalmeasures.com/schema/data">
  <xsl:output method="xhtml"/>
  <xsl:include href="D:\web\common\xslt\DigitalMeasures\DigitalMeasuresHelper.xslt"/>
  <!-- Input Parameters -->
  <xsl:param name="id" select="''"/>
  <xsl:key match="Record" name="facultyList" use="@userId"/>
  <!-- Main Template -->
  <!-- Export Title, MainCol, and RightCol elements to correspond with the desired page regions -->
  <xsl:template match="Data">
    <xsl:variable name="research" select="Record/INTELLCONT[@id = $id and not(@id = parent::node()/preceding-sibling::node()/INTELLCONT/@id)]"/>
    <Data>
      <xsl:choose>
        <!-- If the research ID was found -->
        <xsl:when test="count($research) &gt;0">
          <Title>
            <xsl:value-of select="$research/TITLE"/>
          </Title>
          <MainCol>
            <!-- Title -->
            <h2 class="title">
              <xsl:value-of select="$research/TITLE"/>
            </h2>
            <!-- Authors -->
            <h4>Authors</h4>
            <ul>
              <xsl:for-each select="$research/INTELLCONT_AUTH">
                <xsl:choose>
                  <xsl:when test="FACULTY_NAME != '' and fn:isCurrentFaculty(key('facultyList', FACULTY_NAME))">
                    <li>
                      <a>
                        <xsl:attribute name="href">
                          <xsl:value-of select="fn:getProfileLink(key('facultyList', FACULTY_NAME))"/>
                        </xsl:attribute>
                        <span xml:space="preserve">
                          <xsl:value-of select="fn:getPreferredFirstName(key('facultyList', FACULTY_NAME))"/>
                          <xsl:text/>
                          <xsl:value-of select="key('facultyList', FACULTY_NAME)/PCI/LNAME"/>
                        </span>
                      </a>
                    </li>
                  </xsl:when>
                  <xsl:otherwise>
                    <li xml:space="preserve">
                      <xsl:value-of select="FNAME"/>
                      <xsl:text/>
                      <xsl:if test="MNAME != ''">
                        <xsl:value-of select="substring(MNAME,1,1)"/>
                        <xsl:text>. </xsl:text>
                      </xsl:if>
                      <xsl:value-of select="LNAME"/>
                    </li>
                  </xsl:otherwise>
                </xsl:choose>
              </xsl:for-each>
            </ul>
            <!-- Published in Journal -->
            <xsl:if test="substring($research/CONTYPE,1,15) = 'Journal Article' and $research/PUBLISHER != ''">
              <h4>Published</h4>
              <p>
                <xsl:value-of select="$research/PUBLISHER"/>
                <xsl:if test="$research/ISSUE != ''">, 
                  <xsl:value-of select="$research/ISSUE"/>
                  ed.</xsl:if>
                <xsl:if test="$research/VOLUME != ''">, vol. 
                  <xsl:value-of select="$research/VOLUME"/></xsl:if>
                <xsl:if test="$research/PAGENUM != ''">, pp. 
                  <xsl:value-of select="$research/PAGENUM"/></xsl:if>
                <xsl:if test="$research/DTY_PUB != ''">, 
                  <span xml:space="preserve">
                    <xsl:value-of select="$research/DTM_PUB"/>
                    <xsl:value-of select="$research/DTY_PUB"/></span>
                </xsl:if>
              </p>
            </xsl:if>
            <!-- Published in Book-->
            <xsl:if test="substring($research/CONTYPE,1,4) = 'Book' and $research/BOOK_TITLE != ''">
              <h4>Published</h4>
              <p>
                <xsl:value-of select="$research/BOOK_TITLE"/>
                <xsl:if test="$research/PAGENUM != ''">, pp. 
                  <xsl:value-of select="$research/PAGENUM"/></xsl:if>
                <xsl:if test="$research/DTY_PUB != ''">, 
                  <span xml:space="preserve">
                    <xsl:value-of select="$research/DTM_PUB"/>
                    <xsl:value-of select="$research/DTY_PUB"/></span>
                </xsl:if>
              </p>
            </xsl:if>
            <!-- Website -->
            <xsl:if test="$research/WEB_ADDRESS != ''">
              <h4>Website</h4>
              <p>
                <a href="http://{$research/WEB_ADDRESS}" target="_blank">http://
                  <xsl:value-of select="$research/WEB_ADDRESS"/></a>
              </p>
            </xsl:if>
            <!-- Abstract -->
            <h4 style="clear:right;">Abstract</h4>
            <p>
              <xsl:value-of select="$research/ABSTRACT"/>
            </p>
          </MainCol>
          <RightCol>
            <!-- Author photos and names -->
            <xsl:for-each select="$research/INTELLCONT_AUTH">
                <xsl:if test="FACULTY_NAME != '' and fn:isCurrentFaculty(key('facultyList', FACULTY_NAME))">
                <div class="imageContainer">
                  <div class="image">
                    <a href="{fn:getProfileLink(key('facultyList', FACULTY_NAME))}">
                      <img border="0" onerror="this.style.display='none'" src="/images/people/{key('facultyList', current()/FACULTY_NAME)/@username}.jpg"/>
                      <div class="imageCaption">
                        <xsl:value-of select="fn:getPreferredFirstName(key('facultyList', FACULTY_NAME))"/>
                         
                        <xsl:value-of select="key('facultyList', FACULTY_NAME)/PCI/LNAME"/>
                      </div>
                    </a>
                  </div>
                </div>
                <br/>
              </xsl:if>
            </xsl:for-each>
          </RightCol>
        </xsl:when>
        <xsl:otherwise>
          <Title/>
          <MainCol>
            <p>Could not find the research.</p>
          </MainCol>
          <RightCol/>
          <StatusCode>404</StatusCode>
        </xsl:otherwise>
      </xsl:choose>
    </Data>
  </xsl:template>
</xsl:stylesheet>