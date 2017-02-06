<?xml version="1.0"?>
<xsl:stylesheet version="2.0"
	xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    xmlns:dmd="http://www.digitalmeasures.com/schema/data-metadata"
    exclude-result-prefixes="dmd"
    xpath-default-namespace="http://www.digitalmeasures.com/schema/data">
<xsl:output method="xhtml" />

<!-- Main Template -->
<xsl:template match="Data">
    <xsl:variable name="topics" select="Record/INTELLCONT[WEBSITE = 'Yes']/GENERAL_TOPIC[
        not(.='') and
        not(.=parent::node()/parent::node()/preceding-sibling::node()/INTELLCONT[WEBSITE = 'Yes']/GENERAL_TOPIC) and 
        not(.=parent::node()/preceding-sibling::node()[WEBSITE = 'Yes']/GENERAL_TOPIC)
    ]"/>

    <ul id="topics" class="research">
        <xsl:for-each select="$topics">
            <xsl:sort select="." order="ascending" />
            <li><a href="/faculty/research/topics/{translate(.,' ','-')}/"><xsl:value-of select="." /></a></li>
        </xsl:for-each>
    </ul>

</xsl:template>
	
</xsl:stylesheet>