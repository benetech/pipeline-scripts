<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:c="http://www.w3.org/ns/xproc-step" xmlns:opf="http://www.idpf.org/2007/opf" exclude-result-prefixes="#all" version="2.0">

    <!-- href to this xhtml document -->
    <xsl:param name="href" required="yes"/>
    <xsl:param name="pub-id" select="''"/>

    <xsl:template match="@*|node()">
        <xsl:copy>
            <xsl:apply-templates select="@*|node()"/>
        </xsl:copy>
    </xsl:template>

    <xsl:template match="/*">
        <xsl:copy>
            <xsl:apply-templates select="@*"/>
            <xsl:attribute name="profile" select="'http://www.idpf.org/epub/30/profile/content/'"/>
            <xsl:apply-templates select="node()"/>
        </xsl:copy>
    </xsl:template>

    <xsl:template match="head">
        <head>
            <xsl:apply-templates select="@*"/>
            <xsl:choose>
                <xsl:when test="$pub-id">
                    <meta name="dc:identifier">
                        <xsl:value-of select="$pub-id"/>
                    </meta>
                    <xsl:apply-templates select="*[not(self::meta and @name='dc:identifier')]"/>
                </xsl:when>
                <xsl:otherwise>
                    <xsl:apply-templates select="*"/>
                </xsl:otherwise>
            </xsl:choose>
        </head>
    </xsl:template>

    <xsl:template match="a">
        <xsl:variable name="link-href" select="tokenize(@href,'#')[1]"/>
        <xsl:variable name="link-id" select="if (contains(@href,'#')) then tokenize(@href,'#')[last()] else ''"/>
        <xsl:variable name="self-id" select="ancestor-or-self::*/@id"/>
        <xsl:choose>
            <xsl:when test="not($link-href='') and $link-href=$href and not($link-id='') and $self-id=$link-id">
                <!-- is link to self; remove it -->
                <span>
                    <xsl:apply-templates select="@id"/>
                    <xsl:apply-templates select="node()"/>
                </span>
            </xsl:when>
            <xsl:otherwise>
                <xsl:copy>
                    <xsl:apply-templates select="@*|node()"/>
                </xsl:copy>
            </xsl:otherwise>
        </xsl:choose>
    </xsl:template>

</xsl:stylesheet>