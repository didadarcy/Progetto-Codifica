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
                <!-- -->
                <xsl:apply-templates select="tei:text/tei:body/child::*"/>
                
            </div>
        </div>
        
    </xsl:template>

</xsl:stylesheet>