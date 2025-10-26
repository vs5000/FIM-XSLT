Mit der XSLT-Datei XDF3_2_JSON_x_yy_xdf3.xsl kann aus einer XDF3-Datenschemata-Datei ein analoges JSON-Schema generiert werden.

Die Konfigurationswerte werden durch die genannten Übergabeparameter an die XSLT-Datei übergeben. 
Werden einzelne Parameter nicht übergeben, werden die (zuerst) genannten Defaultwerte genutzt. 
Ein Beispiel folgt am Ende der Datei.
		
		MitVersionen
		1 = Baukastenelemente werden exakt gemäß der FIM-Methodik mit Versionsnummern angegeben und referenziert
		0 = bei Baukastenelemente werden abweichend zur FIM-Methodik keine Versionsnummern angegeben und es erfolgt eine lokale Definition

		Praezisierungen
		1 = Datentypen werden mit Präzisierungen, wie Feldlängen, Wertebereichen und Aufzählungswerten detailliert
		0 = Datentypen werden nicht detailliert

		CodelistenInhalt
		0 = die Inhalte der Codelisten werden nicht verarbeitet
		1 = die Inhalte der Codelisten werden aus dem XRepository geladen, wenn eine Version ermittelt werden kann, und verarbeitet
		
		AktuelleCodelisteLaden
		1 = wenn bei einer Codeliste keine Version angegeben ist, wird versucht die aktuelle Version aus dem XRepository zu laden
		0 = wenn bei einer Codeliste keine Version angegeben ist, werden die Inhalte der Codeliste nicht verarbeitet

		Annotationen
		1 = in der XFall-XML-Schema-Datei werden Annotation eingefügt, um die Nutzung zu erleichtern, z. B. der Name des Baukatenelementes, ggfs. die Version oder der Datentyp
		0 = es werden keine Annotationen in die XFall-XML-Schema-Datei eingefügt

		KeineErweiterungen
		1 = in einer JSON-Datei gemäß des JSON-Schema sind ausschließlich die definierten Baukastenelemente erlaubt
		0 = eine JSON-Datei gemäß des JSON-Schema kann eigene zusätzliche Inhalte hinzufügen (diese Option sind nur in Ausnahmefällen genutzt werden)

		DateiOutput
		0 = Bericht wird an die Standardausgabe übermittelt
		1 = Bericht wird in einer Datei gespeichert
		
		DebugMode
		3 = Debugmeldungen auf auf Detailebene mit Name des Details
		0 = keine Debugmeldungen
		1 = Debugmeldungen auf Abschnittsebene
		2 = Debugmeldungen auf auf Detailebene
		4 = Debugmeldungen mit allen Templates

Beispiel für eine Batch-Datei zum Aufruf mit Java (zu präferieren):

java -jar "C:\Program Files\Saxonica\SaxonHE10-6J\saxon-he-10.6.jar" -s:S00000000159_xdf3.xml -xsl:..\XDF3_2_JSON_0_02_xdf3.xsl DateiOutput=1 MitVersionen=1 Praezisierungen=1 CodelistenInhalt=1 AktuelleCodelisteLaden=1 Annotationen=1 DebugMode=3
pause

Beispiel für eine Batch-Datei zum Aufruf mit .NET - (externe) Codelisten können nicht geladen werden, daher ist die Java-Version zu bevorzugen:

"C:\Program Files\Saxonica\SaxonHE10.6N\bin\Transform.exe" -s:S00000000159_xdf3.xml -xsl:..\XDF3_2_JSON_0_02_xdf3.xsl DateiOutput=1 MitVersionen=1 Praezisierungen=1 CodelistenInhalt=1 AktuelleCodelisteLaden=1 Annotationen=1 DebugMode=3
pause

Vorschlag Verzeichnisaufbau:

- Basis: 
+ XDF3_2_JSON_0_02_xdf3.xsl (XSLT zur Transformation der Datenschemata-XML-Datei im Format XDF3 in ein JSON-Schema)

- Basis\SDS159 (Arbeitsverzeichnis für ein Datenschema):
+ Datenschema als XML-Datei im Format XDatenfelder 3 (z.B. S00000000159_xdf3.xml)
+ Batch-Datei mit Aufruf gemäß o.g. Beispiel (z.B. tr_159.bat)


