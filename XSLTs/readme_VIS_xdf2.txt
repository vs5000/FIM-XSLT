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

		ToolAufruf
		0 = es sind keine Links auf den Datenfeldeditor vorhanden
		1 = es sind Links auf den Datenfeldeditor vorhanden

		ZeigeDaten
		0 = eine Anzeige aller Daten in einer Liste ist nicht möglich
		1 = am Ende des Formulars werden Button angezeigt mit denen alle Daten in einer Liste angezeigt werden können

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

Beispiel für eine Batch-Datei zum Aufruf:

"C:\Program Files\Saxonica\SaxonHE10.2N\bin\Transform.exe" -s:S00000204_xdf2.xml -xsl:..\VIS-DF_0_17_xdf2.xsl DateiOutput=1 Navigation=1 Infobox=1 ToolAufruf=0 ToolPfadPrefix="https://www.fim-formular.niedersachsen.de/fim/portal/fim/9/client/index.html#/datenmodellierung/" ToolPfadPostfix="" DebugMode=3
pause

Vorschlag Verzeichnisaufbau:

- Basis: 
+ VIS-DF_0_17_xdf2.xsl (XSLT zur Transformation der Stammdaten-XML-Datei in ein visualisierendes Formular als HTML-Datei)

- Basis\SDS204 (Arbeitsverzeichnis für ein Stammdatenschema):
+ Stammdatenschema als XML-Datei im Format XDatenfelder (z.B. S00000204_xdf2.xml)
+ alle verwendeten Codelisten im Genericodeformat mit Benennung CodelistenID_genericode.xml (z.B. C00000030_genericode.xml)
+ Batch-Datei mit Aufruf gemäß o.g. Beispiel (z.B. vis_204.bat)

