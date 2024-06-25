# Progetto-Codifica

Repository del progetto e degli esercizi del corso di Codifica di Testi 23/24 
della studentessa del corso triennale di Informatica Umanistica Diana De Marinis (MAT.597112)


Per validare l'XML ho usato il comando:

```
java -cp "xerces-2_12_2/*" dom.Counter -v progetto.xml
```

Per applicare il foglio di stile XSLT ho usato il comando:

```
java -jar "./SaxonHE10-3J/saxon-he-10.3.jar" -s:progetto.xml -xsl:stile.xsl -o:progetto.html
```