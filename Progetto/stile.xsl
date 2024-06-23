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
                <script src="https://code.jquery.com/jquery-3.6.0.js"/>
                <script src="script.js"/>
            </head>
            <body>
                <div id="highlights">
                    <button id="highlight-button">Annotazioni (mostra)</button>
                    <div id="colors">
                        <span class="term"></span>Termini <br/>
                        <span class="eventName"></span>Eventi <br/>
                        <span class="date"></span>Date <br/>
                        <span class="persName"></span>Persone <br/>
                        <span class="placeName"></span>Luoghi <br/>
                        <span class="orgName"></span>Orgs.<br/>
                    </div>
                </div>
                <header>
                    <h1>La Rassegna Settimanale</h1>
                    <h2>Codifica di sezioni ed articoli scelti dell'anno 1878.</h2>
                    <nav>
                        <a href="#TEI-AC">L'amore cavalleresco</a>
                        <a href="#TEI-LSPS">La scuola poetica siciliana</a>
                        <a href="#TEI-Lett">Bibliografia: letteratura</a>
                        <a href="#TEI-SN">Bibliografia: scienze naturali</a>
                        <a href="#TEI-Not">Notizie</a>
                    </nav>
                </header>
                <xsl:apply-templates select="/tei:TEI/tei:teiHeader" />
                
                <!-- Chiamo il template per le parti codificate: -->
                <main>
                    <xsl:apply-templates select="/tei:TEI/tei:TEI"/>  
                </main>       
            </body>
        </html>
    </xsl:template>

    <!-- Template per gli statement di responsabilità: -->
    <xsl:template match="tei:respStmt">
        <span class="bold"><xsl:value-of select="tei:resp"/>: </span> <xsl:value-of select="tei:persName"/><br/>
    </xsl:template>

    <xsl:template match="tei:publicationStmt">
        <span class="bold">Pubblicato da: </span> <xsl:value-of select="tei:publisher"/><br/>
        <span class="bold">Copyright: </span> <xsl:value-of select="tei:availability"/><br/>
    </xsl:template>

    <!-- Template per le parti codificate: -->
    <xsl:template match="/tei:TEI/tei:TEI">
        <xsl:element name='article'>
            <xsl:attribute name="id" select="@xml:id"/>
            <!-- Titolo della parte codificata -->
            <h2><xsl:value-of select="tei:teiHeader/tei:fileDesc/tei:titleStmt/tei:title"/></h2>
            <!-- TEI header: -->
            <xsl:apply-templates select="tei:teiHeader"/>
            <!-- Testo e immagini corrispondenti: -->
            <xsl:apply-templates select=".//tei:body"/>
        </xsl:element>
    </xsl:template>

    <!-- Template per il tei header: -->
    <xsl:template match="tei:teiHeader">
        <div class="teiHeader"> 
            <h3>Informazioni generali</h3>
            <span class="bold">Titolo: </span> <xsl:value-of select="tei:fileDesc/tei:titleStmt/tei:title"/><br/>
            
            <!-- Informazioni sull'edizione: -->
            <xsl:if test=".//tei:editionStmt/tei:edition">
                <span class="bold">Edizione: </span> <xsl:value-of select=".//tei:editionStmt/tei:edition"/><br/>
            </xsl:if>
            <!-- Informazioni sugli statement di responsabilità: -->
            <xsl:apply-templates select=".//tei:respStmt"/>
            <!-- Informazioni sulla pubblicazione: -->
            <xsl:apply-templates select=".//tei:publicationStmt"/>
            <!-- Informazioni sulla fonte: -->
            <xsl:apply-templates select=".//tei:bibl"/>
        </div>
    </xsl:template>

    <!-- Template per la citazione bibliografica alla fonte: -->
    <xsl:template match="tei:sourceDesc/tei:bibl">
        <div class="header-bibl">
            <h3><span class="bold">Informazioni sulla fonte</span></h3> 
            <xsl:if test="tei:title[@level='a']">
                <span class="bold">Titolo: </span> <xsl:value-of select="tei:title[@level='a']"/><br/>
            </xsl:if>
            <xsl:if test="tei:author">
                <span class="bold">Autore: </span> <xsl:value-of select="tei:author"/><br/>  
            </xsl:if>
            <span class="bold">Titolo della rivista: </span> <xsl:value-of select="tei:title[@level='j']"/><br/>
            <span class="bold">Casa Editrice: </span> <xsl:value-of select="tei:publisher"/><br/>
            <xsl:if test="tei:pubPlace">
                <span class="bold">Luogo di pubblicazione: </span> <xsl:value-of select="tei:pubPlace"/><br/>
            </xsl:if>
            <span class="bold">Anno di pubblicazione: </span> <xsl:value-of select="tei:date"/><br/>
            <xsl:if test="tei:biblScope">
                <span class="bold">Volume: </span> <xsl:value-of select="tei:biblScope[@unit='volume']"/><br/>
                <span class="bold">Fascicolo: </span> <xsl:value-of select="tei:biblScope[@unit='issue']"/><br/>
            </xsl:if>
            <xsl:element name="a">
                <xsl:attribute name="href" select="tei:edition/@source"/>
                Edizione digitale 
            </xsl:element> 
            a cura di: <ul>
                <xsl:for-each select="tei:edition/*">
                    <li><xsl:value-of select="."/></li>
                </xsl:for-each>
            </ul>
        </div>
    </xsl:template>

        <!-- Template per il corpo del testo: -->
    <xsl:template match="tei:body">
        <xsl:variable name="curr-body" select="."/>
        <!-- Divido il testo in pagine, separandolo all'inizio di ogni tei:pb: -->
        <xsl:for-each-group select="descendant::node()" group-starting-with="tei:pb">
            <!-- Ignoro i gruppi che non contengono tei:pb: -->
            <xsl:if test="current-group()[self::tei:pb]">
                <div class="page">
                    <!-- Scrivo il numero della pagina: -->
                        <h2>Pagina <xsl:value-of select="current-group()[self::tei:pb]/@n"/></h2>
                    <div class="pagecols">
                        <!-- Mostro l'immagine corrispondente: -->
                        <xsl:apply-templates select="current-group()[self::tei:pb]"/>
                        <!-- Mostro il testo della pagina, prendendo il contenuto dei paragrafi nella pagina: -->
                        <div class="pagebody">
                            <!-- Mostro l'header della pagina, se presente -->
                            <xsl:apply-templates select="$curr-body//tei:fw[@type='header'] intersect current-group()"/>
                            <!-- Divido la pagina per colonne e mostro i contenuti della colonna: -->
                            <xsl:for-each-group select="current-group()" group-starting-with="tei:cb">
                                <!-- Seleziono tutti i figli del body corrente che 
                                        1) sono di tipo list|p|head|signed|bibl
                                        2) sono contenuti nella colonna corrente, o hanno almeno un discendente che è contenuto nella colonna corrente
                                -->
                                <xsl:apply-templates select="$curr-body/(tei:list | tei:p | tei:head | tei:signed | tei:bibl)[descendant-or-self::node() intersect current-group()]"/>
                            </xsl:for-each-group>
                        </div>
                    </div>
                </div>
            </xsl:if>
        </xsl:for-each-group> 
    </xsl:template>

    <!-- Template per i paragrafi: -->
    <xsl:template match="tei:p">
        <xsl:element name="p">
            <!-- Inserisco il riferimento alla tei:zone: -->
            <!-- L'attributo @facs potrebbe essere sia contenuto nel tag tei:p (se l'intero paragrafo è in una singola colonna)
                oppure potrebbe essere contenuto in un tei:milestone (se il paragrafo è separato su più colonne): -->
            <xsl:choose>
                <!-- Caso 1: L'attributo è contenuto nel tag tei:p: -->
                <xsl:when test="@facs">
                    <xsl:attribute name="data-facs" select="@facs"/>
                </xsl:when>
                <!-- Caso 2: L'attributo è contenuto in un tag tei:milestone: -->
                <xsl:otherwise>
                    <xsl:attribute name="data-facs" select="(tei:milestone[@unit='paragraph-part'] intersect current-group())/@facs"/>
                </xsl:otherwise>
            </xsl:choose>

            <!-- Seleziono solo i nodi nella colonna (gruppo) corrente: -->
            <!-- Ignoro i tag tei:p e tei:fw perché vengono gestiti dal template di tei:body: -->
            <xsl:apply-templates select="node()[not(self::tei:pb | self::tei:fw)][descendant-or-self::node() intersect current-group()]"/>
        </xsl:element>  
    </xsl:template>

    <!-- Template per le liste contenute in body: -->
    <xsl:template match="tei:body//tei:list">
        <!-- Seleziono solo i tei:item contenuti nella colonna (gruppo) corrente: -->
        <xsl:apply-templates select="tei:item intersect current-group()"/>
    </xsl:template>

    <!-- Template per gli item delle liste contenute in body: -->
    <xsl:template match="tei:body//tei:item">
        <xsl:element name="p">
            <!-- Se @rend contiene font-size(small) lo inserisco nella classe, altrimenti no: -->
            <xsl:choose>
                <xsl:when test="@rend='font-size(small)'">
                    <xsl:attribute name="class">list-item font-small</xsl:attribute>        
                </xsl:when>
                <xsl:otherwise>
                    <xsl:attribute name="class">list-item</xsl:attribute>
                </xsl:otherwise>
            </xsl:choose>

            <!-- Inserisco il riferimento alla tei:zone: -->
            <xsl:attribute name="data-facs" select="@facs"/>

            <!-- Seleziono solo i nodi nella pagina (gruppo) corrente: -->
            <!-- Ignoro i tag tei:p e tei:fw perché vengono gestiti dal template di tei:body: -->
            <xsl:apply-templates select="node()[not(self::tei:pb | self::tei:fw)] intersect current-group()"/>
        </xsl:element>
    </xsl:template>

    <!-- Template per la pagina: -->
    <xsl:template match="tei:pb">
        <xsl:variable name="numero-pag" select="@n"/>
        <div class="pageimg">
            <!-- Inserisco l'immagine corrispondente alla pagina corrente: -->
            <xsl:apply-templates select="//tei:surface[@xml:id=concat('pag',$numero-pag)]"/>
        </div>
    </xsl:template>

    <!-- Template per le immagini: -->
    <xsl:template match="tei:surface">
        <xsl:element name="svg">
            <xsl:attribute name="id" select="@xml:id" />

            <!-- La viewBox serve a dare un sistema di riferimento per l'intera immagine: -->
            <xsl:attribute name="viewBox">
                <!-- Coordinata x del vertice in alto a sinistra -->
                <xsl:text>0,</xsl:text>
                <!-- Coordinata y del vertice in alto a sinistra -->
                <xsl:text>0,</xsl:text>
                <!-- La larghezza dell'immagine è contenuta nell'attributo @width di tei:graphic, ma dobbiamo eliminare la stringa 'px' -->
                <xsl:value-of select="substring-before(tei:graphic/@width, 'px')"/><xsl:text>,</xsl:text>
                <!-- L'altezza dell'immagine è contenuta nell'attributo @height di tei:graphic, ma dobbiamo eliminare la stringa 'px' -->
                <xsl:value-of select="substring-before(tei:graphic/@height, 'px')"/>
            </xsl:attribute>

            <!-- Dimensioni effettive dell'immagine visualizzata: -->
            <xsl:attribute name="width">480</xsl:attribute>
            <xsl:attribute name="height">700</xsl:attribute>

            <!-- Immagine: -->
            <xsl:element name="image">
                <xsl:attribute name="href" select="tei:graphic/@url" />
                <xsl:attribute name="x" select="0"/>
                <xsl:attribute name="y" select="0"/>
                <xsl:attribute name="width">100%</xsl:attribute>
                <xsl:attribute name="height">100%</xsl:attribute>
            </xsl:element>

            <!-- Per ogni tei:zone creiamo un elemento rect oppure polygon -->
            <xsl:for-each select="tei:zone">
                <xsl:choose>
                    <!-- Se il tei:zone contiene l'attributo @ulx allora è un rettangolo -->
                    <xsl:when test="@ulx">
                        <xsl:element name="rect">
                            <xsl:attribute name="id" select="@xml:id"/>
                            <!-- Posizione del vertice in alto a sinistra -->
                            <xsl:attribute name="x" select="@ulx"/>
                            <xsl:attribute name="y" select="@uly"/>
                            <!-- La larghezza del rettangolo è la differenza tra le ascisse -->
                            <xsl:attribute name="width" select="@lrx - @ulx"/>
                            <!-- L'altezza del rettangolo è la differenza tra le ordinate -->
                            <xsl:attribute name="height" select="@lry - @uly"/>
                        </xsl:element>
                    </xsl:when>
                    <!-- Altrimenti è un poligono -->
                    <xsl:otherwise>
                        <xsl:element name="polygon">
                            <xsl:attribute name="id" select="@xml:id"/>
                            <xsl:attribute name="points" select="@points"/>
                        </xsl:element>
                    </xsl:otherwise>
                </xsl:choose>
            </xsl:for-each>
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
        <xsl:element name="h3">
            <xsl:attribute name="class">align-center allcaps</xsl:attribute>
            <xsl:attribute name="data-facs" select="@facs"/>

            <xsl:apply-templates/>
        </xsl:element>
    </xsl:template>

    <!-- Template per le note: -->
    <xsl:template match="tei:note">
        <span class="note">*<span class="note-text"><xsl:apply-templates/></span></span>
    </xsl:template>

    <!-- Template per il corsivo: -->
    <!-- La priority serve a fare in modo che, in caso di conflitto, questo template abbia priorità più bassa -->
    <xsl:template match="*[@rend='italics']" priority="-1">
        <span class="italics"><xsl:apply-templates/></span>
    </xsl:template>

    <!-- Template per l'header della pagina: -->
    <xsl:template match="tei:fw[@type='header']">
        <xsl:element name="div">
            <xsl:attribute name="class">page-header</xsl:attribute>
            <xsl:attribute name="data-facs" select="@facs"/>
            
            <xsl:apply-templates/>
        </xsl:element>
    </xsl:template>

    <!-- Template per le parti dell'header della pagina: -->
    <xsl:template match="tei:fw/tei:fw">
        <xsl:element name="span">
            <xsl:choose>
                <xsl:when test="@rend='align(left)'">
                    <xsl:attribute name="class">align-left</xsl:attribute>
                </xsl:when>
                <xsl:when test="@rend='align(center) case(allcaps)'">
                    <xsl:attribute name="class">align-center allcaps</xsl:attribute>
                </xsl:when>
                <xsl:when test="@rend='align(right)'">
                    <xsl:attribute name="class">align-right</xsl:attribute>
                </xsl:when>
            </xsl:choose>
            <xsl:attribute name="data-facs" select="@facs"/>
            
            <xsl:apply-templates/>
        </xsl:element>       
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
        <xsl:element name="span">
            <xsl:attribute name="class">align-right allcaps</xsl:attribute>
            <xsl:attribute name="data-facs" select="@facs"/>

            <xsl:apply-templates/>
        </xsl:element>
    </xsl:template>

    <!-- Template per le firme: -->
    <xsl:template match="tei:seg">
        <span class="align-right"><xsl:apply-templates/></span>
    </xsl:template>

     <!-- Template per i titoli: -->
    <xsl:template match="tei:body//tei:title">
        <xsl:choose>
            <xsl:when test="@rend='italics'">
                <span class="title italics"><xsl:apply-templates/></span>
            </xsl:when>
            <xsl:otherwise>
                <span class="title"><xsl:apply-templates/></span>
            </xsl:otherwise>
        </xsl:choose>
    </xsl:template>

    <!-- Template per posizionare il titolo dei testi: -->
    <xsl:template match="tei:body//tei:bibl">
        <xsl:element name="span">
            <xsl:attribute name="class">bibl</xsl:attribute>
            <xsl:attribute name="data-facs" select="@facs"/>

            <xsl:apply-templates/>
        </xsl:element>
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