XDF3_2_XFall_0_01_xdf3.xsl: XSLT zur Transformation einer xdf3-Dateien in ein analoges XFall-XML-Schema xsd

Die Konfigurationswerte werden durch die genannten Übergabeparameter an die XSLT-Datei übergeben. 
Werden einzelne Parameter nicht übergeben, werden die (zuerst) genannten Defaultwerte genutzt. 
Ein Beispiel folgt am Ende der Datei.
		
		DateiOutput
		0 = Bericht wird an die Standardausgabe übermittelt
		1 = Bericht wird in einer Datei gespeichert
		
		Annotationen
		1 = in der XFall-XML-Schema-Datei werden Annotation eingefügt, um die Nutzung zu erleichtern
		0 = es werden keine Annotationen in die XFall-XML-Schema-Datei eingefügt

		Praezisierungen
		1 = Datentypen werden mit Präzisierungen, wie Feldlängen, Wertebereichen und Aufzählungswerten detailliert
		0 = Datentypen werden nicht detailliert

		DebugMode
		3 = Debugmeldungen auf auf Detailebene mit Name des Details
		0 = keine Debugmeldungen
		1 = Debugmeldungen auf Abschnittsebene
		2 = Debugmeldungen auf auf Detailebene
		4 = Debugmeldungen mit allen Templates

Beispiel für eine Batch-Datei zum Aufruf mit Java (zu präferieren):

java -jar "C:\Program Files\Saxonica\SaxonHE10-6J\saxon-he-10.6.jar" -s:S00000000159_xdf3.xml -xsl:..\XDF3_2_XFall_0_04_xdf3.xsl DateiOutput=1 Annotationen=1 Praezisierungen=1 DebugMode=3
pause

Beispiel für eine Batch-Datei zum Aufruf mit .NET - (externen) Codelisten können nicht geladen werden, daher siehe unten (*):

"C:\Program Files\Saxonica\SaxonHE10.6N\bin\Transform.exe" -s:S00000000159_xdf3.xml -xsl:..\XDF3_2_XFall_0_04_xdf3.xsl DateiOutput=1 Annotationen=1 Praezisierungen=1 DebugMode=3
pause

Vorschlag Verzeichnisaufbau:

- Basis: 
+ XDF3_2_XFall_0_04_xdf3.xsl (XSLT zur Transformation der Stammdaten-XML-Datei im Format XDF2 ins Format XDF3)

- Basis\SDS159 (Arbeitsverzeichnis für ein Stammdatenschema):
+ Datenschema als XML-Datei im Format XDatenfelder 3 (z.B. S00000000159_xdf3.xml)
+ (*)bei der Verwendung von .NET müssen hier alle referenzierten Codelisten im Genericodeformat mit Benennung CanonicalVersionUri.xml vorliegen, wobei Doppelpunkte durch einfache Punkte ersetzt werden (z.B. urn.de.bund.destatis.bevoelkerungsstatistik.schluessel.staat_2019-02-01.xml)
+ Batch-Datei mit Aufruf gemäß o.g. Beispiel (z.B. tr_159.bat)


