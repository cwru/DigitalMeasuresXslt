<?xml version="1.0"?>
<xsl:stylesheet version="2.0"
	xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    xmlns:xs="http://www.w3.org/2001/XMLSchema"
    xmlns:dmd="http://www.digitalmeasures.com/schema/data-metadata"
    xmlns:fn="http://weatherhead.case.edu/xslt"
    exclude-result-prefixes="xs dmd fn"
    xpath-default-namespace="http://www.digitalmeasures.com/schema/data">
<xsl:output method="xhtml" />
<xsl:include href="D:\web\common\xslt\DigitalMeasures\DigitalMeasuresHelper.xslt" />
	
<xsl:template match="Record">
    <Data>
    	<MastHead>
            <div class="row masthead-profile-name">
                <div class="col-xs-12">
                    <h1>Faculty &#8211; <span itemprop="name"><span itemprop="givenName"><xsl:value-of select="fn:getPreferredFirstName(.)" /></span><xsl:text> </xsl:text><span itemprop="familyName"><xsl:value-of select="PCI/LNAME" /></span></span></h1>
                </div>
            </div>
            <div class="row masthead-profile-details">
                <div class="col-sm-2">
                    <!-- Photo -->	
                    <img src="/images/people/{@username}.jpg" class="img-responsive" style="border:0;" onerror="this.style.visibility='hidden';" itemprop="image">
                        <xsl:attribute name="alt">
                            <xsl:value-of select="fn:getPreferredFirstName(.)" /><xsl:text> </xsl:text><xsl:value-of select="PCI/LNAME" /><xsl:text> - </xsl:text><xsl:value-of select="ADMIN/RANK[fn:isCurrent(../YEAR_START, ../YEAR_END)]" /> <xsl:if test="ADMIN/RANK != 'Professor for the Practice of'">,</xsl:if><xsl:text> </xsl:text><xsl:value-of select="ADMIN/ADMIN_DEP[fn:isCurrent(../YEAR_START, ../YEAR_END)]/DEP" />
                        </xsl:attribute>
                    </img>
                </div>
                <div class="col-sm-10">
                    <!-- Titles -->
                    
                    <xsl:for-each select="ENDOWED_CHAIR[fn:isCurrent(START_START, END_START)]">
                        <span itemprop="jobTitle"><xsl:value-of select="ROLE" /></span><br />
                    </xsl:for-each>
                    
                    <xsl:for-each select="ADMIN_ASSIGNMENTS[
                        fn:isCurrent(START_START, END_START) and 
                        SCOPE = 'College'
                    ]">
                        <span itemprop="jobTitle"><xsl:value-of select="ROLE" /></span><br />
                    </xsl:for-each>
                    
                    <xsl:for-each select="ADMIN_ASSIGNMENTS[
                        fn:isCurrent(START_START, END_START) and 
                        SCOPE = 'Department'
                    ]">
                        <span itemprop="jobTitle"><xsl:value-of select="ROLE" /></span><br />
                    </xsl:for-each>
            
                    <xsl:for-each select="ADMIN/ADMIN_DEP[
                        fn:isWithinCurrentAcademicYear(..)
                    ]">
                        <span itemprop="jobTitle"><xsl:value-of select="../RANK" /><xsl:choose><xsl:when test="../DISCIPLINE != ''"> of <xsl:value-of select="../DISCIPLINE" />;</xsl:when><xsl:when test="../RANK != 'Professor for the Practice of'">,</xsl:when><xsl:otherwise></xsl:otherwise></xsl:choose>&#160;<xsl:value-of select="DEP" /></span><br />
                    </xsl:for-each>
            
                    <xsl:for-each select="PASTHIST[
                        fn:isCurrent(START_START, END_START) and
                        PROFILE = 'Yes'
                    ]">
                        <span itemprop="jobTitle"><xsl:value-of select="TITLE" />, <xsl:value-of select="ORG" /></span><br />
                    </xsl:for-each>
                    <br />
                    
                    <!-- Contact Info -->
                    <xsl:if test="PCI/EMAIL != ''">
                        <a><xsl:attribute name="href">mailto:<xsl:value-of select="PCI/EMAIL" /></xsl:attribute><span itemprop="email"><xsl:value-of select="PCI/EMAIL" /></span></a><br />
                    </xsl:if>
                    <xsl:if test="PCI/OPHONE1 != '' and PCI/OPHONE2 != '' and PCI/OPHONE3 != ''"> 
                        <a itemprop="telephone">
                            <xsl:attribute name="href">tel:+1<xsl:value-of select="PCI/OPHONE1" /><xsl:value-of select="PCI/OPHONE2" /><xsl:value-of select="PCI/OPHONE3" /></xsl:attribute>
                            <xsl:value-of select="PCI/OPHONE1" />.<xsl:value-of select="PCI/OPHONE2" />.<xsl:value-of select="PCI/OPHONE3" />
                        </a><br />
                    </xsl:if>
                    <xsl:if test="PCI/BUILDING != ''">
                        <xsl:value-of select="PCI/BUILDING" />&#160;<xsl:value-of select="PCI/ROOMNUM" /><br/>
                    </xsl:if>
                    
                    
                    <xsl:if test="PCI/OFFICE_HOURS != ''">
                        Office Hours: <xsl:value-of select="PCI/OFFICE_HOURS" /><br/>
                    </xsl:if>
                </div>
            </div>
        </MastHead>
        <MainCol>
            <!-- Bio -->
            <xsl:if test="WEB_PROFILE/BIO_PROFILE != ''">
                <span itemprop="description"><xsl:copy-of select="fn:lineBreaksToParagraphs(WEB_PROFILE/BIO_PROFILE)" /></span>
            </xsl:if>    
        
            <!-- Website -->
            <xsl:if test="PCI/WEBSITE != ''">
                <a href="http://{PCI/WEBSITE}" target="_blank" itemprop="url">Personal Website</a><br />
            </xsl:if>
            <!-- CV -->
            <xsl:if test="WEB_PROFILE/UPLOAD_VITA != ''">
                <a href="http://intranet.weatherhead.case.edu/digitalMeasuresDocuments/{WEB_PROFILE/UPLOAD_VITA}" target="_blank">Curriculum Vita</a><br />
            </xsl:if>
    
            <!-- Education -->
            <xsl:if test="EDUCATION">
                <p>
                <xsl:for-each select="EDUCATION">
                    <xsl:sort select="COMP_END" data-type="text" order="descending"/>
                    <xsl:sort select="DEG" data-type="text" order="descending"/>
                    <span itemprop="alumniOf" itemscope="itemscope" itemtype="http://schema.org/CollegeOrUniversity"><xsl:value-of select="DEG" />, <span itemprop="name"><xsl:value-of select="SCHOOL" /></span>, <xsl:value-of select="YR_COMP" /></span><br />
                </xsl:for-each>
                </p>
            </xsl:if>
            
            <xsl:if test="ADMIN_PERM/DTY_HIRE != ''">
                <xsl:if test="ADMIN/RANK != 'Adjunct Professor'">
                    Initially Appointed: <xsl:value-of select="ADMIN_PERM/DTY_HIRE" /><br/>
                </xsl:if>
            </xsl:if>
            
            <hr />
            
            <!-- Interests -->
            
            <h2 class="big-header">Interests and Courses</h2>
            <!--<xsl:if test="WEB_PROFILE/TEACHING_INTERESTS != '' or WEB_PROFILE/RESEARCH_INTERESTS != ''"> -->
                
                <xsl:if test="WEB_PROFILE/RESEARCH_INTERESTS != ''">
                    <h3>Research</h3>
                    <xsl:copy-of select="fn:lineBreaksToParagraphs(WEB_PROFILE/RESEARCH_INTERESTS)" />
                </xsl:if>
                
                <xsl:if test="WEB_PROFILE/TEACHING_INTERESTS != ''">
                    <h3>Teaching</h3>
                    <xsl:copy-of select="fn:lineBreaksToParagraphs(WEB_PROFILE/TEACHING_INTERESTS)" />
                </xsl:if>		
                
            <!--</xsl:if> -->
            
            <!-- Get Unique Courses -->
            <xsl:variable name="courses" select="SCHTEACH[
                not(TERM_START = '') and
                not(EXCLUDE_FROM_AACSB_REPORTS = 'Yes') and
                xs:date(TERM_START) >= (current-date() - xs:yearMonthDuration('P1Y')) and
                not(TITLE = preceding-sibling::node()[
                                not(TERM_START = '') and
                                xs:date(TERM_START) >= (current-date() - xs:yearMonthDuration('P1Y'))
                            ]/TITLE)
            ]"/>
            
            <!-- Courses Taught -->
            
                <h3>Recent Courses and Syllabi</h3>
                <xsl:if test="count($courses)">
                    <ul>
                    <xsl:for-each select="$courses">
                        <xsl:choose>
                            <xsl:when test="contains(COURSEPRE,'/')">
                                <li><a href="/academics/courses/{substring-before(COURSEPRE,'/')}{substring-before(COURSENUM,'/')}"><xsl:value-of select="TITLE" /></a></li>
                            </xsl:when>
                            <xsl:otherwise>				
                                <li><a href="/academics/courses/{COURSEPRE}{COURSENUM}"><xsl:value-of select="TITLE" /></a></li>
                            </xsl:otherwise>
                        </xsl:choose>
                    </xsl:for-each>
                    </ul>
                </xsl:if>
          
            
            <!-- Course Evaluations -->		
            <a href="http://intranet.weatherhead.case.edu/evaluations/results/evals.cfm?type=i&amp;pid={@idPeople}" target="_blank">Course evaluation ratings (login required)</a>
            
            <hr />
             
            <!-- Publications -->
            <xsl:if test="INTELLCONT[PROFILE = 'Yes']">
                <h2 class="big-header">Selected Publications</h2>
                <ul class="list-unstyled publications">
                <xsl:for-each select="INTELLCONT[PROFILE = 'Yes' and (STATUS='Published' or STATUS='Accepted' or STATUS='Working Paper Completed')]">
                    <xsl:sort select="DTY_PUB" order="descending" />			
                    <li style="word-wrap: break-word; margin-bottom: 15px;">
                        <xsl:for-each select="INTELLCONT_AUTH">		
                            <xsl:value-of select="LNAME" /><xsl:text>, </xsl:text><xsl:value-of select="substring(FNAME,1,1)" /><xsl:text>.</xsl:text><xsl:if test="MNAME != ''"><xsl:text> </xsl:text><xsl:value-of select="substring(MNAME,1,1)" /><xsl:text>.</xsl:text></xsl:if><xsl:if test="position() != last()"><xsl:text>, </xsl:text></xsl:if>
                        </xsl:for-each>
                        <xsl:if test="DTY_PUB != ''">
                            (<xsl:value-of select="DTY_PUB" />).
                        </xsl:if>
                        
                        <xsl:if test="EDITORS != ''">
                            In <xsl:value-of select="EDITORS" /> (Ed.),
                        </xsl:if>
                        <br />
                        <xsl:if test="ABSTRACT != ''">
                            <a href="../../faculty/research/library/detail?id={./@id}"><em xml:space="preserve"> <xsl:value-of select="TITLE" /></em></a> 
                        </xsl:if>
                        <xsl:if test="ABSTRACT = ''">
                            <em xml:space="preserve"><xsl:value-of select="TITLE" /></em>
                        </xsl:if>
                        <xsl:text> </xsl:text>
                        <xsl:if test="ISSUE != '' or VOLUME != '' or PAGENUM != ''">
                            <xsl:if test="CONTYPE = 'Journal Article, Academic Journal' or CONTYPE = 'Journal Article, Professional Journal'">
                                (<xsl:if test="VOLUME != ''">vol. <xsl:value-of select="VOLUME" />, </xsl:if>
                                <xsl:if test="ISSUE != ''">issue <xsl:value-of select="ISSUE" />, </xsl:if>
                                <xsl:if test="PAGENUM != ''">pp. <xsl:value-of select="PAGENUM" /></xsl:if>).                      
                            </xsl:if>
                            <xsl:if test="CONTYPE != 'Journal Article, Academic Journal' and CONTYPE != 'Journal Article, Professional Journal'">
                                (<xsl:if test="VOLUME != ''">vol. <xsl:value-of select="VOLUME" />, </xsl:if>
                                <xsl:if test="ISSUE != ''"><xsl:value-of select="ISSUE" /> ed., </xsl:if>
                                <xsl:if test="PAGENUM != ''">pp. <xsl:value-of select="PAGENUM" /></xsl:if>).
                            </xsl:if>                            
                        </xsl:if>
    
                        <xsl:if test="PUBCTYST != ''">
                            <xsl:value-of select="PUBCTYST" />:
                        </xsl:if>
                        <xsl:if test="PUBLISHER != ''">
                            <xsl:value-of select="PUBLISHER" />.
                        </xsl:if>
                    </li>
                </xsl:for-each>
                </ul>
                <hr />
            </xsl:if>
            
            <!-- Presentations -->
            <xsl:if test="PRESENT[PROFILE = 'Yes']">
                <h2 class="big-header">Presentations</h2>
                <ul class="list-unstyled presentations">
                <xsl:for-each select="PRESENT[PROFILE = 'Yes']">
                    <xsl:sort select="DTY_DATE" order="descending" />
                    <li style="margin-bottom: 15px;">
                        <xsl:for-each select="PRESENT_AUTH">	
                            <xsl:value-of select="LNAME" /><xsl:text>, </xsl:text><xsl:value-of select="substring(FNAME,1,1)" /><xsl:text>.</xsl:text><xsl:if test="MNAME != ''"><xsl:text> </xsl:text><xsl:value-of select="substring(MNAME,1,1)" /><xsl:text>.</xsl:text></xsl:if><xsl:if test="ROLE != ''"> (<xsl:value-of select="ROLE"/>)</xsl:if><xsl:if test="position() != last()"><xsl:text>, </xsl:text></xsl:if>	
                        </xsl:for-each>
                        <xsl:if test="NAME != ''">
                            <xsl:text> </xsl:text><xsl:value-of select="NAME" />,
                        </xsl:if>
                        <xsl:if test="TITLE != ''">
                            "<xsl:value-of select="TITLE" />",
                        </xsl:if>
                        <xsl:if test="ORG != ''">
                            <xsl:value-of select="ORG" />,
                        </xsl:if>
                        <xsl:if test="LOCATION != ''">
                            <xsl:value-of select="LOCATION" />.
                        </xsl:if>
                        <xsl:if test="DTY_DATE != ''">
                            (<xsl:value-of select="DTY_DATE" />).
                        </xsl:if>
                    </li>
                </xsl:for-each>
                </ul>
                <hr />
            </xsl:if>
            
            <!-- Activities -->
            <xsl:if test="MEMBER[PROFILE = 'Yes'] or SERVICE_DEPARTMENT[PROFILE = 'Yes'] or SERVICE_COLLEGE[PROFILE = 'Yes'] or SERVICE_UNIVERSITY[PROFILE = 'Yes'] or SERVICE_PROFESSIONAL[PROFILE = 'Yes'] or SERVICE_PUBLIC[PROFILE = 'Yes']">
                <h2 class="big-header">Academic and Professional Activities</h2>
                <ul class="list-unstyled activities">
                <xsl:for-each select="MEMBER[PROFILE = 'Yes']"> 
                    <xsl:sort select="DTY_START" order="descending" />
                    <li style="margin-bottom: 15px;">
                        <xsl:if test="LEADERSHIP != ''"><xsl:value-of select="LEADERSHIP" />, </xsl:if>
                        <xsl:if test="NAME != ''"><span itemprop="affiliation" itemscope="itemscope"  itemtype="http://schema.org/Organization"><span itemprop="name"><xsl:value-of select="NAME" /></span></span>. </xsl:if>
                        <xsl:value-of select="DTY_START" />
                        <xsl:if test="DTY_START != '' and DTY_END != DTY_START"> - </xsl:if>
                        <xsl:if test="DTY_END != DTY_START"><xsl:value-of select="DTY_END" /></xsl:if>
                        <xsl:if test="DTY_START != '' and DTY_END = ''">Present</xsl:if>
                    </li>
                </xsl:for-each>	
                <xsl:for-each select="*[(self::SERVICE_DEPARTMENT or self::SERVICE_COLLEGE or self::SERVICE_UNIVERSITY or self::SERVICE_PROFESSIONAL or self::SERVICE_PUBLIC) and PROFILE = 'Yes']">
                    <xsl:sort select="DTY_START" order="descending" />
                    <li style="margin-bottom: 15px;">
                        <xsl:if test="ROLE != '' and ROLE != 'Other'"><xsl:value-of select="ROLE" />, </xsl:if>
                        <xsl:if test="ROLEOTHER != '' and (ROLE = '' or ROLE = 'Other')"><xsl:value-of select="ROLEOTHER" />, </xsl:if>
                        <xsl:if test="ORG != ''"><span itemprop="affiliation" itemscope="itemscope"  itemtype="http://schema.org/Organization"><span itemprop="name"><xsl:value-of select="ORG" /></span></span>, </xsl:if>
                        <xsl:if test="CITY != ''"><xsl:value-of select="CITY" />, </xsl:if>
                        <xsl:if test="STATE != ''"><xsl:value-of select="STATE" />, </xsl:if>
                        <xsl:value-of select="DTY_START" />
                        <xsl:if test="DTY_START != '' and DTY_END != DTY_START"> - </xsl:if>
                        <xsl:if test="DTY_END != DTY_START"><xsl:value-of select="DTY_END" /></xsl:if>
                        <xsl:if test="DTY_START != '' and DTY_END = ''">Present</xsl:if>
                    </li>
                </xsl:for-each>
                </ul>
                <hr />
            </xsl:if>
            
            <!-- Awards -->
            <xsl:if test="AWARDHONOR[PROFILE = 'Yes']">
                <h2 class="big-header">Awards</h2>
                <ul class="list-unstyled awards">
                <xsl:for-each select="AWARDHONOR[PROFILE = 'Yes']">
                    <xsl:sort select="DTY_DATE" order="descending" />
                    <li style="margin-bottom: 15px;" itemprop="award">
                        <xsl:if test="NAME != ''"><xsl:value-of select="NAME" />, </xsl:if>
                        <xsl:if test="ORG != ''"><xsl:value-of select="ORG" />. </xsl:if>
                        <xsl:if test="DTY_DATE != ''">(<xsl:value-of select="DTY_DATE" />).</xsl:if>
                    </li>
                </xsl:for-each>
                </ul>
            </xsl:if>
		</MainCol>
    </Data>				
</xsl:template>	
		
</xsl:stylesheet>