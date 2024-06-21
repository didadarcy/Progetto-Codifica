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
                <link rel="stylesheet" href="stile.css" />
            </head>
            <body>
                <header>
                    <h1>La Rassegna Settimanale</h1>
                    <h2>Codifica di sezioni ed articoli scelti dell'anno 1878.</h2>
                    <nav>
                        <a href="#">L'amore cavalleresco</a>
                        <a href="#">La scuola poetica siciliana</a>
                        <a href="#">Bibliografia: letteratura</a>
                        <a href="#">Bibliografia: scienze naturali</a>
                        <a href="#">Notizie</a>
                    </nav>
                </header>
                <div> 
                    Titolo: <xsl:value-of select="/tei:TEI/tei:teiHeader/tei:fileDesc/tei:titleStmt/tei:title"/><br/>
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
            <xsl:apply-templates select="tei:teiHeader"/>
            <!-- Testo e immagini corrispondenti: -->
            <div>
                <xsl:apply-templates select=".//tei:body"/>
            </div>
        </div>
    </xsl:template>

    <!-- Template per il tei header: -->
    <xsl:template match="tei:teiHeader">
        <div>
            <h2><xsl:value-of select="tei:fileDesc/tei:titleStmt/tei:title"/></h2>
            <span class="bold"><xsl:value-of select="tei:fileDesc/tei:titleStmt/tei:respStmt/tei:resp"/>: </span>
            <xsl:value-of select="tei:fileDesc/tei:titleStmt/tei:respStmt/tei:persName"/><br/>
            <span class="bold">Editore: </span> <xsl:value-of select="tei:fileDesc/tei:publicationStmt"/> <br/><br/>
            <xsl:apply-templates select="tei:fileDesc/tei:sourceDesc/tei:bibl"/>
        </div>
    </xsl:template>

    <!-- Template per la citazione bibliografica alla fonte: -->
    <xsl:template match="tei:sourceDesc/tei:bibl">
        <div class="header-bibl">
            <h3><span class="bold">Fonte: </span></h3> 
            <span class="bold">Titolo: </span> <xsl:value-of select="tei:title[@level='a']"/><br/>
            <xsl:if test="tei:author">
                <span class="bold">Autore: </span> <xsl:value-of select="tei:author"/><br/>  
            </xsl:if>
            <span class="bold">Titolo della rivista: </span> <xsl:value-of select="tei:title[@level='j']"/><br/>
            <span class="bold">Casa Editrice: </span> <xsl:value-of select="tei:publisher"/><br/>
            <span class="bold">Anno di pubblicazione: </span> <xsl:value-of select="tei:date"/><br/>
            <span class="bold">Volume: </span> <xsl:value-of select="tei:biblScope[@unit='volume']"/><br/>
            <span class="bold">Fascicolo: </span> <xsl:value-of select="tei:biblScope[@unit='issue']"/><br/>
        </div>
    </xsl:template>

        <!-- Template per il corpo del testo: -->
    <xsl:template match="tei:body">
        <xsl:variable name="curr-body" select="."/>
        <xsl:for-each-group select="descendant::node()" group-starting-with="tei:pb">
            <xsl:if test="current-group()[self::tei:pb]">
                <div class="page">
                    <!-- Scrivo il numero della pagina -->
                        <h2>Pagina <xsl:value-of select="current-group()[self::tei:pb]/@n"/></h2>
                    <div class="pagecols">
                    <!-- Mostro l'immagine corrispondente: -->
                        <xsl:apply-templates select="current-group()[self::tei:pb]"/>
                    <!-- Mostro il testo della pagina, prendendo il contenuto dei paragrafi nella pagina: -->
                        <div class="pagebody">
                            <xsl:apply-templates select="$curr-body/(tei:list | tei:p | tei:fw | tei:head | tei:signed | tei:bibl)[descendant-or-self::node() intersect current-group()]"/>
                        </div>
                    </div>
                </div>
            </xsl:if>
        </xsl:for-each-group> 
    </xsl:template>

    <!-- Template per i paragrafi: -->
    <xsl:template match="tei:p">    
        <p class="paragraph">
            <!-- Seleziono solo i nodi nella pagina (gruppo) corrente: -->
            <xsl:apply-templates select="node()[not(self::tei:pb)][descendant-or-self::node() intersect current-group()]"/>
        </p>  
    </xsl:template>

    <!-- Template per le liste contenute in body: -->
    <xsl:template match="tei:body//tei:list">
        <xsl:apply-templates select="tei:item intersect current-group()"/>
    </xsl:template>

    <!-- Template per gli item delle liste contenute in body: -->
    <xsl:template match="tei:body//tei:item">
        <p class="list-item font-small">
            <!-- Seleziono solo i nodi nella pagina (gruppo) corrente: -->
            <xsl:apply-templates select="node()[not(self::tei:pb)] intersect current-group()"/>
        </p>   
    </xsl:template>

    <!-- Template per la pagina: -->
    <xsl:template match="tei:pb">
        <xsl:variable name="numero-pag" select="@n"/>
        <div class="pageimg">
            <xsl:apply-templates select="//tei:surface[@xml:id=concat('pag',$numero-pag)]"/>
        </div>
    </xsl:template>

    <!-- Template per le immagini: -->
    <xsl:template match="tei:surface">
        <xsl:element name="img">
            <xsl:attribute name="src" select="tei:graphic/@url"/>
        </xsl:element>
    </xsl:template>

    <!-- Template per mandare a capo le righe: -->
    <xsl:template match="tei:lb" >
        <br/>
    </xsl:template>

    <!-- Template per non mostrare il tag br prima della nota: -->
    <xsl:template match="tei:note//tei:lb[position() = 1]" />

    <!-- Template per posizionare il titolo dei testi: -->
    <xsl:template match="tei:head">
        <h3 class="align-center allcaps"><xsl:apply-templates/></h3>
    </xsl:template>

    <!-- Template per le note: -->
    <xsl:template match="tei:note">
        <span class="note">*<span class="note-text"><xsl:apply-templates/></span></span>
    </xsl:template>

    <!-- Template per il corsivo: -->
    <xsl:template match="*[@rend='italics']" priority="-1">
        <span class="italics"><xsl:apply-templates/></span>
    </xsl:template>

    <!-- Template per l'header della pagina: -->
    <xsl:template match="tei:fw[@type='header']">
        <div class="page-header"><xsl:apply-templates/></div>
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

    <!-- Template per le scelte: -->
    <xsl:template match="tei:choice">
        <span class="choice"><xsl:apply-templates /></span>
    </xsl:template>

    <!-- Template per le abbreviazioni: -->
    <xsl:template match="tei:abbr">
        <xsl:choose>
            <xsl:when test="@rend='italics'">
                <span class="abbr italics"><xsl:apply-templates/></span>
            </xsl:when>
            <xsl:otherwise>
                <span class="abbr"><xsl:apply-templates/></span>
            </xsl:otherwise>
        </xsl:choose>
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

     <!-- Template per i titoli: -->
    <xsl:template match="tei:body//tei:title | tei:body//tei:bibl">
        <xsl:choose>
            <xsl:when test="@rend='italics'">
                <span class="title italics"><xsl:apply-templates/></span>
            </xsl:when>
            <xsl:otherwise>
                <span class="title"><xsl:apply-templates/></span>
            </xsl:otherwise>
        </xsl:choose>
    </xsl:template>

    <!-- Template per citazioni bibliografiche inserite: -->
    <xsl:template match="tei:cit">
        <span class="cit">
            <xsl:apply-templates select="tei:quote"/>
            <span class="cit-bibl"><xsl:apply-templates select="tei:bibl"/></span>
        </span>
    </xsl:template>

    <!-- Template per i term: -->
    <xsl:template match="tei:term">
        <xsl:choose>
            <xsl:when test="@rend='italics'">
                <span class="term italics"><xsl:apply-templates/></span>
            </xsl:when>
            <xsl:otherwise>
                <span class="term"><xsl:apply-templates/></span>
            </xsl:otherwise>
        </xsl:choose>
    </xsl:template>

    <!-- Template per gli eventi: -->
    <xsl:template match="tei:eventName">
        <span class="eventName"><xsl:apply-templates/></span>
    </xsl:template>

    <!-- Template per le date: -->
    <xsl:template match="tei:date">
        <span class="date"><xsl:apply-templates/></span>
    </xsl:template>

    <!-- Template per i nomi di persona: -->
    <xsl:template match="tei:persName | tei:roleName | tei:addName">
        <span class="persName"><xsl:apply-templates/></span>
    </xsl:template>

    <!-- Template per i nomi di luoghi: -->
    <xsl:template match="tei:placeName | tei:geogName">
        <span class="placeName"><xsl:apply-templates/></span>
    </xsl:template>

    <!-- Template per i nomi delle organizzazioni: -->
    <xsl:template match="tei:orgName">
        <xsl:choose>
            <xsl:when test="@rend='italics'">
                <span class="orgName italics"><xsl:apply-templates/></span>
            </xsl:when>
            <xsl:otherwise>
                <span class="orgName"><xsl:apply-templates/></span>
            </xsl:otherwise>
        </xsl:choose>
    </xsl:template>

    <!-- Template per le quote: -->
    <xsl:template match="tei:quote[@rend='align(center) font-size(small)']">
        <span class="quote align-center font-small"><xsl:apply-templates/></span>
    </xsl:template>

    <!-- Template per i versi poetici: -->
    <xsl:template match="tei:l">
        <br/><xsl:apply-templates/>
    </xsl:template>

</xsl:stylesheet>