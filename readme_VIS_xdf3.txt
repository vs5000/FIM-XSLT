Die XSLT kann sowohl Stammdatenschema als auch Feldgruppen visualisieren. Voraussetzung ist, dass alle Codelisten im Genericodeformat im selben Ordner liegen.

Die Konfigurationswerte werden durch die genannten Übergabeparameter an die XSLT-Datei übergeben. 
Die Defaultwerte werden im Folgenden immer zuerst genannt. 
Ein Beispiel folgt am Ende der Datei.
		
		DateiOutput
		0 = Bericht wird an die Standardausgabe übermittelt
		1 = Bericht wird in einer Datei gespeichert
		
		Navigation
		1 = das Navigationsfenster ist eingeblendet
		0 = das Navigationsfenster ist generell ausgeblendet
		
		Infobox
		1 = die Info-Buttons werden angezeigt
		0 = die Info-Buttons werden nicht angezeigt

		Copybutton
		1 = die Kopier-Buttons werden angezeigt
		0 = die Kopier-Buttons werden nicht angezeigt

		ZeigeVersteckte
		1 = im Funktionsbereich wird ein Link zum Ein- und Ausbelden versteckter Felder angezeigt
		0 = im Funktionsbereich wird kein Link zum Ein- und Ausbelden versteckter Felder angezeigt

		ZeigeDaten
		0 = eine Anzeige aller Daten in einer Liste ist nicht möglich
		1 = am Ende des Formulars werden Button angezeigt mit denen alle Daten in einer Liste angezeigt werden können

		ToolAufruf
		0 = es sind keine Links auf den Datenfeldeditor vorhanden
		1 = es sind Links auf den Datenfeldeditor vorhanden

		ToolPfadPrefix
		Start der URL auf den Datenfeldeditor (gefolgt von der ID des Objektes)
		default: https://www.fim-formular.niedersachsen.de/fim/portal/fim/9/client/index.html#/datenmodellierung/
	
		ToolPfadPostfix
		Ende der URL auf den Datenfeldeditor (nach der ID des Objektes)
		default ist leer

		DebugMode
		3 = Debugmeldungen auf auf Detailebene mit Name des Details
		0 = keine Debugmeldungen
		1 = Debugmeldungen auf Abschnittsebene
		2 = Debugmeldungen auf auf Detailebene
		4 = Debugmeldungen mit allen Templates

Beispiel für eine Batch-Datei zum Aufruf mit Java:

java -jar "C:\Program Files\Saxonica\SaxonHE10-6J\saxon-he-10.6.jar" -s:S00000000204_xdf2.xml -xsl:..\VIS-DF_0_19_xdf3.xsl DateiOutput=1 Navigation=1 Infobox=1 Copybutton=1 ZeigeVersteckte=1 ZeigeDaten=0 ToolAufruf=0 ToolPfadPrefix="https://www.fim-formular.niedersachsen.de/fim/portal/fim/9/client/index.html#/datenmodellierung/" ToolPfadPostfix="" DebugMode=3
pause

Beispiel für eine Batch-Datei zum Aufruf mit .NET - (externen) Codelisten können nicht geladen werden, daher siehe unten (*):

"C:\Program Files\Saxonica\SaxonHE10.2N\bin\Transform.exe" -s:S00000000204_xdf2.xml -xsl:..\VIS-DF_0_19_xdf3.xsl DateiOutput=1 Navigation=1 Infobox=1 Copybutton=1 ZeigeVersteckte=1 ZeigeDaten=0 ToolAufruf=0 ToolPfadPrefix="https://www.fim-formular.niedersachsen.de/fim/portal/fim/9/client/index.html#/datenmodellierung/" ToolPfadPostfix="" DebugMode=3
pause

Vorschlag Verzeichnisaufbau:

- Basis: 
+ VIS-DF_0_19_xdf3.xsl (XSLT zur Transformation der Stammdaten-XML-Datei in ein visualisierendes Formular als HTML-Datei)

- Basis\SDS204 (Arbeitsverzeichnis für ein Stammdatenschema):
+ Stammdatenschema als XML-Datei im Format XDatenfelder (z.B. S00000000204_xdf2.xml)
+ (*)bei der Verwendung von .NET müssen hier alle referenzierten Codelisten im Genericodeformat mit Benennung CanonicalVersionUri.xml vorliegen, wobei Doppelpunkte durch einfache Punkte ersetzt werden (z.B. urn.de.bund.destatis.bevoelkerungsstatistik.schluessel.staat_2019-02-01.xml)
+ Batch-Datei mit Aufruf gemäß o.g. Beispiel (z.B. vis_204.bat)

