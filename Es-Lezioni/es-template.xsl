<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform" version="1.0">
    <xsl:output method="html" encoding="UTF-8" indent="yes" />
    <xsl:variable name="style" >
        <style>
            h1{
                color:blue;
            }
        </style>
    </xsl:variable>

    <xsl:template match="/">
        <html>
            <head>
               
                <title>
                    <xsl:value-of select="TEI/teiHeader/fileDesc/titleStmt/title" />
                </title>

                 <link rel="stylesheet" type="text/css" href="./mycss.css" />
            </head>
            <body>
                <div class="index">
                    <xsl:element name="h1">
                        <xsl:attribute name="style" select="$style"/>
                        INDEX
                    </xsl:element>
                    <ul>
                        <xsl:call-template name="div-named">
                            <xsl:with-param name="style" select="$style"/>
                        </xsl:call-template>
                    </ul>
                </div>
                <div>
                    <xsl:apply-templates select="child::node()" />
                </div>
            </body>
        </html>
    </xsl:template>

    <xsl:template name="div-named">
        <xsl:param name="style"/>
        <ul>
            <xsl:for-each select="//div[@type='chapter']">
                <li style="style">
                    <xsl:value-of select="head" />
                </li>
            </xsl:for-each>
        </ul>
    </xsl:template>
    <xsl:template match="titleStmt/title">
        <h2>
            <xsl:value-of select="." />
        </h2>
    </xsl:template>
    <xsl:template match="div/head">
        <h3>
            <xsl:value-of select="." />
        </h3>
    </xsl:template>

<xsl:template match="teiHeader">
    <span>[identificativo del documento: <xsl:value-of select="@xml:id" />]</span>
</xsl:template>


</xsl:stylesheet>