<?xml version="1.0"?>
<xsl:stylesheet version="2.0"
    xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    xmlns:dmd="http://www.digitalmeasures.com/schema/data-metadata"
    xmlns:xs="http://www.w3.org/2001/XMLSchema"
    xmlns:fn="http://weatherhead.case.edu/xslt"
    exclude-result-prefixes="xs fn dmd"
    xpath-default-namespace="http://www.digitalmeasures.com/schema/data">
<!--
This is a collection of utility functions for transforming data from Digital Measures. 
They are documented here, listed with the format [returnType] [name]([parameters])

xs:boolean fn:isCurrent(start, end)
    Returns true if the current date is between the start and end parameters
    
xs:boolean fn:isWithinCurrentAcademicYear(start, end)
    Returns true if the current data is between July 1 of the year specified by start
    and June 30 of the year specified by end
    
xs:boolean fn:isWithinCurrentAcademicYear(node)
    Convenience function which calls fn:isWithinCurrentAcademicYear(start, end)
    with start = $node/YEAR_START and end = $node/YEAR_END
    
node-set fn:getDepartmentList(data)
    Returns the list of current academic departments. The data parameter should be the 
    <Data> element of the Digital Measures document
    
node-set fn:getProgramList(data)
    Returns the list of doctoral programs. The data parameter should be the 
    <Data> element of the Digital Measures document
    
node-set fn:getAllDepartments(data)
    Returns the list of all past and present academic departments. The data parameter should be the 
    <Data> element of the Digital Measures document  

node-set fn:getAllPrograms(data)
    Returns the list of all past and present academic departments. The data parameter should be the 
    <Data> element of the Digital Measures document  

xs:boolean fn:isCurrentFaculty(person)
    Returns true if the person (passed as the Digital Measures <Record> element)
    is a current faculty member
    
xs:boolean fn:isCurrentFaculty(person, includeAdjunct)
    Returns true if the person is a current faculty member. If includeAjdunct 
    is true, then adjunct faculty will be considered as current faculty members.
    
node-set fn:getCurrentFaculty(data)
    Returns the list of current faculty. The data parameter should be the 
    <Data> element of the Digital Measures document
    
node-set fn:getCurrentFaculty(data, includeAdjunct)
    Returns the list of current faculty. If includeAjdunct is true, then 
    adjunct faculty will be considered as current faculty members.
    
xs:string fn:getPreferredFirstName(person)
    Returns the PFNAME of the person (passed as the Digital Measures <Record> 
    element) if it is defined. Otherwise, returns the FNAME

node-set fn:getDegreesText(person)
    Returns the student's degree programs and years, with line breaks between elements.
    
xs:string fn:getProfileLink(person)
    Returns the relative URL to the person's Weatherhead profile page.

node-set fn:lineBreaksToBrs(content)
    Replaces line break characters (LF) with br elements.
    Make sure to use copy-of instead of value-of so that the br 
    tags are preserved.
    
node-set fn:lineBreaksToParagraphs(content)
    Splits text into paragraphs based on line break character (LF).
    Make sure to use copy-of instead of value-of so that the paragraph 
    tags are preserved.
    
xs:string fn:monthNameToNumber(month)
    Returns the numeric representation (zero-prefixed) of a month from the text representation thereof. 
    Example: fn:monthNameToNumber('July') returns '07'
    Adapted from http://stackoverflow.com/a/19800923/3983649
    
-->
  
<xsl:function name="fn:isCurrent" as="xs:boolean">
    <xsl:param name="start" />
    <xsl:param name="end" />
    <xsl:value-of select="(
        $start = '' or 
        not($start) or 
        (if($start castable as xs:date) then current-date() >= xs:date($start) else false())
    ) and 
    (
        $end = '' or 
        not($end) or                    
        (if($end castable as xs:date) then xs:date($end) >= current-date() else false())
    )" />
</xsl:function>
  
<xsl:function name="fn:isWithinCurrentAcademicYear" as="xs:boolean">
    <xsl:param name="start" />
    <xsl:param name="end" />
    <xsl:value-of select="(
        $start = '' or 
        not($start) or 
        format-date(current-date(),'[Y0001][M01][D01]') >= concat(year-from-date($start),'0701')
    ) and 
    (
        $end = '' or 
        not($end) or                    
        concat(year-from-date($end),'0630') >= format-date(current-date(),'[Y0001][M01][D01]')
    )" />
</xsl:function>
<!-- Convenient function for a common pattern of YEAR_START and YEAR_END -->
<xsl:function name="fn:isWithinCurrentAcademicYear" as="xs:boolean">
    <xsl:param name="what" />
    <xsl:value-of select="fn:isWithinCurrentAcademicYear($what/YEAR_START, $what/YEAR_END)" />
</xsl:function>

<xsl:function name="fn:getProgramListgetDepartmentList">
    <xsl:param name="data" />
    <xsl:copy-of select="$data/Record/dmd:IndexEntry[
        @indexKey = 'DOCTORAL_PROGRAM' and 
        not(@entryKey=parent::node()/preceding-sibling::node()/dmd:IndexEntry[@indexKey = 'DOCTORAL_PROGRAM']/@entryKey)
    ]" />
</xsl:function>

<xsl:function name="fn:getDepartmentList">
    <xsl:param name="data" />
    <xsl:copy-of select="$data/Record/dmd:IndexEntry[
        @indexKey = 'DEPARTMENT' and 
        not(@entryKey='Information Systems') and 
        not(@entryKey='Marketing and Policy Studies') and 
        not(@entryKey=parent::node()/preceding-sibling::node()/dmd:IndexEntry[@indexKey = 'DEPARTMENT']/@entryKey)
    ]" />
</xsl:function>

<xsl:function name="fn:getAllDepartments">
  <xsl:param name="data" />
  <xsl:copy-of select="$data/Record/dmd:IndexEntry[
    @indexKey = 'DEPARTMENT' and 
      not(@entryKey=parent::node()/preceding-sibling::node()/dmd:IndexEntry[@indexKey = 'DEPARTMENT']/@entryKey)
  ]" />
</xsl:function>

<xsl:function name="fn:getAllPrograms">
  <xsl:param name="data" />
  <xsl:copy-of select="$data/Record/dmd:IndexEntry[
    @indexKey = 'DOCTORAL_PROGRAM' and 
      not(@entryKey=parent::node()/preceding-sibling::node()/dmd:IndexEntry[@indexKey = 'DOCTORAL_PROGRAM']/@entryKey)
  ]" />
</xsl:function>

<xsl:function name="fn:isCurrentFaculty" as="xs:boolean">
    <xsl:param name="person" />
    <xsl:param name="includeAdjunct" as="xs:boolean" />
    <xsl:value-of select="$person/ADMIN_PERM[
            DTM_SEPARATION = '' or
            DTD_SEPARATION = '' or
            DTY_SEPARATION = '' or
            not(DTM_SEPARATION) or
            not(DTD_SEPARATION) or
            not(DTY_SEPARATION) or
            concat(DTY_SEPARATION,fn:monthNameToNumber(DTM_SEPARATION),DTD_SEPARATION) > format-date(current-date(),'[Y0001][M01][D01]') and DTD_SEPARATION > '10' or
            concat(DTY_SEPARATION,fn:monthNameToNumber(DTM_SEPARATION),'0',DTD_SEPARATION) > format-date(current-date(),'[Y0001][M01][D01]') and DTD_SEPARATION &lt; '10'
        ] and
        $person/ADMIN/ADMIN_DEP[
            (
                ../RANK = 'Assistant Professor' or 
                ../RANK = 'Associate Professor' or 
                ../RANK = 'Full Time Lecturer' or 
                ../RANK = 'Professor' or 
                ../RANK = 'Professor for the Practice of' or 
                ../RANK = 'Senior Lecturer' or
                ($includeAdjunct and ../RANK = 'Adjunct Professor') or
                ../RANK = 'Assistant Professor, Pending Ph.D.' or
                ../RANK = 'Visiting Assistant Professor' or                
                ../RANK = 'Visiting Associate Professor'                
            ) and
            fn:isWithinCurrentAcademicYear(../YEAR_START, ../YEAR_END)
        ]" />
</xsl:function>
  
<xsl:function name="fn:isCurrentStudent" as="xs:boolean">
	<xsl:param name="person" />
    <xsl:value-of select="count($person/DOCTORAL[
            MILESTONE/text() = 'Program entry' and 
            DATE_START/text() &lt;= format-date(current-date(),'[Y0001]-[M01]-[D01]') and
            not (../DOCTORAL[
                    (MILESTONE/text() = 'Graduation' or MILESTONE/text() = 'Program withdrawal') and
                    DATE_START/text() &lt;= format-date(current-date(),'[Y0001]-[M01]-[D01]')
                  ]/PROGRAM = PROGRAM)
        ]) &gt; 0 and
        (not($person/WEB_PROFILE/INCLUDE_PROFILE) or $person/WEB_PROFILE/INCLUDE_PROFILE != 'No')" />
</xsl:function>

<xsl:function name="fn:isCurrentFaculty" as="xs:boolean">
    <xsl:param name="person" />
    <xsl:value-of select="fn:isCurrentFaculty($person, false())" />
</xsl:function>
  
<xsl:function name="fn:getCurrentFaculty">
    <xsl:param name="data" />
    <xsl:param name="includeAdjunct" as="xs:boolean" />
    <xsl:copy-of select="$data/Record[fn:isCurrentFaculty(., $includeAdjunct)]" />
</xsl:function>

<xsl:function name="fn:getCurrentFaculty">
    <xsl:param name="data" />
    <xsl:copy-of select="$data/Record[fn:isCurrentFaculty(.)]" />
</xsl:function>

<xsl:function name="fn:getProgramList">
    <xsl:param name="data" />
    <xsl:copy-of select="$data/Record/dmd:IndexEntry[
        @indexKey = 'DOCTORAL_PROGRAM' and 
        not(@entryKey=parent::node()/preceding-sibling::node()/dmd:IndexEntry[@indexKey = 'DOCTORAL_PROGRAM']/@entryKey)
    ]" />
</xsl:function>
  
<xsl:function name="fn:isCurrentStudentInProgram" as="xs:boolean">
    <xsl:param name="person" />
    <xsl:param name="program" />
    <xsl:value-of select="count($person/DOCTORAL[
            MILESTONE/text() = 'Program entry' and 
            PROGRAM/text() = $program and
            DATE_START/text() &lt;= format-date(current-date(),'[Y0001]-[M01]-[D01]') and
            not (../DOCTORAL[
                    (MILESTONE/text() = 'Graduation' or MILESTONE/text() = 'Program withdrawal') and
                    DATE_START/text() &lt;= format-date(current-date(),'[Y0001]-[M01]-[D01]')
                  ]/PROGRAM = PROGRAM)
        ]) &gt; 0" />
</xsl:function>

<xsl:function name="fn:getCurrentStudents">
    <xsl:param name="data" />
    <xsl:copy-of select="$data/Record[fn:isCurrentStudent(.)]" />
</xsl:function>

<xsl:function name="fn:getCurrentStudentsInProgram">
    <xsl:param name="data" />
    <xsl:param name="program" />
    <xsl:copy-of select="$data/Record[fn:isCurrentStudent(.) and dmd:IndexEntry[@entryKey=$program]]" />
</xsl:function>

<xsl:function name="fn:getPreferredFirstName" as="xs:string">
    <xsl:param name="person" />
    <xsl:choose>
        <xsl:when test="$person/PCI/PFNAME != ''">
            <xsl:value-of select="$person/PCI/PFNAME" />
        </xsl:when>
        <xsl:otherwise>
            <xsl:value-of select="$person/PCI/FNAME" />
        </xsl:otherwise>
    </xsl:choose>
</xsl:function>

<xsl:function name="fn:getDegreesText">
    <xsl:param name="person" />

    <!-- Current Program -->
    <xsl:variable name="programSet" select="distinct-values($person/DOCTORAL/PROGRAM/text())" />
    <xsl:variable name="programCount" select="count($programSet)" />
    <xsl:for-each select="$programSet">
        <xsl:variable name="currentProgram" select="." />
        <xsl:value-of select="$currentProgram" />
        <xsl:if test="count($person/DOCTORAL[PROGRAM = $currentProgram and MILESTONE/text() = 'Program entry']) &gt; 0">, 
            <xsl:value-of select="$person/DOCTORAL[MILESTONE/text() = 'Program entry' and PROGRAM/text() = $currentProgram]/DTY_DATE" /> 
            - Present
        </xsl:if>
        <xsl:if test="position() &lt; $programCount and $programCount != 1">
            <br/>
        </xsl:if>
    </xsl:for-each>
    
    <!-- If there is a record for Doctor of Management program entry and the current program is something other than Doctor of Management (i.e. PhD in Mgmt - Designing Sustainable Systems), show the Doctor of Management degree too -->
    <!-- <xsl:for-each select="$person/DOCTORAL">
        <xsl:if test="@dmd:primaryKey='Doctor of Management|Program entry' and ../dmd:IndexEntry[@indexKey='DOCTORAL_PROGRAM' and @entryKey != 'Doctor of Management']">
            <br/>Doctor of Management, <xsl:value-of select="substring(DATE_START,1,4)" /> - Present                       
        </xsl:if>
    </xsl:for-each> -->
</xsl:function>

<xsl:function name="fn:getDegreesTextWithAsterix">
    <xsl:param name="person" />

    <!-- Current Program -->
    <xsl:for-each select="distinct-values($person/DOCTORAL/PROGRAM/text())">
        <xsl:variable name="currentProgram" select="." />
        <xsl:value-of select="$currentProgram" />
        <xsl:if test="count($person/DOCTORAL[PROGRAM = $currentProgram and MILESTONE/text() = 'Program entry']) &gt; 0">, 
            <xsl:value-of select="$person/DOCTORAL[MILESTONE/text() = 'Program entry' and PROGRAM/text() = $currentProgram]/DTY_DATE" /> 
            - Present
        </xsl:if>
        *
    </xsl:for-each>
    
    <!-- If there is a record for Doctor of Management program entry and the current program is something other than Doctor of Management (i.e. PhD in Mgmt - Designing Sustainable Systems), show the Doctor of Management degree too -->
    <!-- <xsl:for-each select="$person/DOCTORAL">
        <xsl:if test="@dmd:primaryKey='Doctor of Management|Program entry' and ../dmd:IndexEntry[@indexKey='DOCTORAL_PROGRAM' and @entryKey != 'Doctor of Management']">
            *Doctor of Management, <xsl:value-of select="substring(DATE_START,1,4)" /> - Present                       
        </xsl:if>
    </xsl:for-each> -->
</xsl:function>

<xsl:function name="fn:getProfileLink" as="xs:string">
    <xsl:param name="person" />
    <xsl:param name="section" />
    <xsl:value-of select="concat('/',$section,'/', translate(fn:getPreferredFirstName($person),' .,','-'), '-', translate($person/PCI/LNAME,' .,','-'), '/')" />
</xsl:function>

<xsl:function name="fn:getProfileLink" as="xs:string">
    <xsl:param name="person" />
    <xsl:value-of select="fn:getProfileLink($person,'faculty')" />
</xsl:function>

<xsl:function name="fn:getStudentProfileLink" as="xs:string">
    <xsl:param name="person" />
    <xsl:value-of select="fn:getProfileLink($person,'students')" />
</xsl:function>

<xsl:function name="fn:lineBreaksToBrs">
    <xsl:param name="content" />
    <xsl:for-each select="tokenize($content, '&#xa;')">
        <xsl:value-of select="." /><br />
    </xsl:for-each>
</xsl:function>

<xsl:function name="fn:lineBreaksToParagraphs">
    <xsl:param name="content" />
    <xsl:for-each select="tokenize($content, '&#xa;')">
        <p><xsl:value-of select="." /></p>
    </xsl:for-each>
</xsl:function>

<xsl:function name="fn:monthNameToNumber" as="xs:string">
    <xsl:param name="month" />
    <xsl:value-of select="format-number(
      string-length(substring-before(
     'JanFebMarAprMayJunJulAugSepOctNovDec',
     substring($month,1,3))) div 3 + 1,'00')"/>
</xsl:function>

</xsl:stylesheet>