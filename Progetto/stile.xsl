<?xml version="1.0" encoding="UTF-8" standalone="no" ?>
<!-- Radice e dichiarazione dei namespace TEI: -->
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
                xmlns:tei="http://www.tei-c.org/ns/1.0"
                xmlns="http://www.w3.org/1999/xhtml"
                version="2.0">

    <xsl:output method="html" indent="yes"/>

    <!-- Template iniziale: -->
    <xsl:template match="/">
        <html>
            <head>
                <title>Progetto Codifica di Testi - De Marinis</title>
            </head>
            <body>
                <h1>La Rassegna Settimanale</h1>
                <h2>Codifica di sezioni ed articoli scelti dell'anno 1878.</h2>
                <nav>
                    <a href="#">L'amore cavalleresco</a>
                    <a href="#">La scuola poetica siciliana</a>
                    <a href="#">Bibliografia: letteratura</a>
                    <a href="#">Bibliografia: scienze naturali</a>
                    <a href="#">Notizie</a>
                </nav>
                <div> 
                    Titolo: <xsl:value-of select="/tei:TEI/tei:teiHeader/tei:fileDesc/tei:titleStmt/tei:title"/>
                    Trascrizione a cura di: <xsl:value-of select="/tei:TEI/tei:teiHeader/tei:fileDesc//tei:persName"/>
                </div>
                <!-- Chiamo il template per le parti codificate: -->
                <xsl:apply-templates select="/tei:TEI/tei:TEI"/>         
            </body>
        </html>
    </xsl:template>

    <!-- Template per le parti codificate: -->
    <xsl:template match="/tei:TEI/tei:TEI">
        <div>
            <!-- TEI header: -->
            <div></div>
            <!-- Testo e immagini corrispondenti: -->
            <div>
                <xsl:apply-templates select=".//tei:surface"/>
                <xsl:apply-templates select=".//tei:body"/>
            </div>
        </div>
    </xsl:template>

    <!-- Template per le immagini: -->
    <xsl:template match="tei:surface">
        <xsl:element name="img">
            <xsl:attribute name="src" select="tei:graphic/@url"/>
        </xsl:element>
    </xsl:template>

    <!-- Template per mandare a capo le righe: -->
    <xsl:template match="tei:lb">
        <br/>
    </xsl:template>

    <!-- Template per posizionare il titolo dei testi: -->
    <xsl:template match="tei:head">
        <h3><xsl:apply-templates/></h3>
    </xsl:template>

    <!-- Template per le note: -->
    <xsl:template match="tei:note">
         *
        <span class="note">
            <xsl:apply-templates/>
        </span>  
    </xsl:template>

    <!-- Template per i paragrafi: -->
    <xsl:template match="tei:p">
        <div class="paragraph"><xsl:apply-templates/></div>
    </xsl:template>

    <!-- Template per il corsivo: -->
    <xsl:template match="*[@rend='italics']">
        <i><xsl:apply-templates/></i>
    </xsl:template>

    <!-- Template per l'header della pagina: -->
    <xsl:template match="tei:fw[@type='header']">
        <div class="page-header">
            <br/>
            <xsl:apply-templates/>
        </div>
    </xsl:template>

    <!-- Template per le parti dell'header della pagina: -->
    <xsl:template match="tei:fw/tei:fw">
        <xsl:choose>
            <xsl:when test="@rend='align(left)'">
                <span class="align-left"><xsl:apply-templates/></span>
            </xsl:when>
            <xsl:when test="@rend='align(center) case(allcaps)'">
                <span class="align-center allcaps"><xsl:apply-templates/></span>
            </xsl:when>
            <xsl:when test="@rend='align(right)'">
                <span class="align-right"><xsl:apply-templates/></span>
            </xsl:when>
        </xsl:choose>
        
    </xsl:template>

    <!-- Template per le abbreviazioni: -->
    <xsl:template match="tei:abbr">
        <span class="abbr"><xsl:apply-templates/></span> 
    </xsl:template>

    <!-- Template per le espansioni: -->
    <xsl:template match="tei:expan">
        <span class="expan"><xsl:apply-templates/></span> 
    </xsl:template>

    <!-- Template per le firme: -->
    <xsl:template match="tei:signed">
        <span class="align-right allcaps"><xsl:apply-templates/></span>
    </xsl:template>

    <!-- Template per le firme: -->
    <xsl:template match="tei:seg">
        <span class="align-right"><xsl:apply-templates/></span>
    </xsl:template>

    

</xsl:stylesheet>