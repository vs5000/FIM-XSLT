Die Konfigurationswerte werden durch die genannten Übergabeparameter an die XSLT-Datei übergeben. 
Die Defaultwerte werden im Folgenden immer zuerst genannt. 
Ein Beispiel folgt am Ende der Datei.
		
		VergleichsDateiName
		Name der Datei, mit welcher die übergebene Datei verglichen werden soll
		z.B. S00000159V1.3_xdf2.xml - kein Defaultwert
		
		RegelDetails
		1 = Regeln werden verglichen
		0 = Regeln werden nicht verglichen

		CodelistenInhalt
		0 = die Inhalte der Codelisten werden nicht verglichen
		1 = die Inhalte der Codelisten werden aus Dateien CODELISTENID_genericode.xml (z.B. C00000030_genericode.xml) aus dem selben Verzeichnis, wie die Datendatei eingelesen und verglichen

		AenderungsFazit
		1 = am Anfang des Vergleichs wird eine Zusammenfassungen mit der Anzahl der Änderungen angezeigt
		0 = am Anfang des Vergleichs wird keine Zusammenfassungen angezeigt

		DateiOutput
		0 = Bericht wird an die Standardausgabe übermittelt
		1 = Bericht wird in einer Datei gespeichert
		
		Navigation
		1 = das Navigationsfenster ist eingeblendet
		0 = das Navigationsfenster ist generell ausgeblendet
		
		JavaScript
		1 = die HTML-Datei enthält Javaschript, z.B. zum ein- und ausblenden der Navigation
		0 = die HTML-Datei enthält kein Javaschript

		ToolAufruf
		1 = es sind Links auf den Datenfeldeditor vorhanden
		0 = es sind keine Links auf den Datenfeldeditor vorhanden

		ToolPfadPrefix
		Start der URL auf den Datenfeldeditor (gefolgt von der ID des Objektes)
		z.B. https://www.fim-formular.niedersachsen.de/fim/portal/fim/9/editor/
	
		ToolPfadPostfix
		Ende der URL auf den Datenfeldeditor (nach der ID des Objektes)
		/view

		DebugMode
		3 = Debugmeldungen auf auf Detailebene mit Name des Details
		0 = keine Debugmeldungen
		1 = Debugmeldungen auf Abschnittsebene
		2 = Debugmeldungen auf auf Detailebene
		4 = Debugmeldungen mit allen Templates

Beispiel für eine Batch-Datei zum Aufruf:

"C:\Program Files\Saxonica\SaxonHE10.6N\bin\Transform.exe" -s:S00000159V1.4_xdf2.xml -xsl:..\COMP-DF_0_11_xdf2.xsl VergleichsDateiName=S00000159V1.3_xdf2.xml RegelDetails=1 CodelistenInhalt=1 AenderungsFazit=1 DateiOutput=1 Navigation=1 JavaScript= 1 ToolAufruf=1 ToolPfadPrefix="https://www.fim-formular.niedersachsen.de/fim/portal/fim/9/editor/" ToolPfadPostfix="/view" DebugMode=3
pause

Vorschlag Verzeichnisaufbau:

- Basis: 
+ COMP-DF_0_11_xdf2.xsl (XSLT zur Transformation der Stammdaten-XML-Datei in einen Änderungsbericht als HTML-Datei)

- Basis\SDS159 (Arbeitsverzeichnis für ein Stammdatenschema):
+ Neues Stammdatenschema als XML-Datei im Format XDatenfelder (z.B. S00000159V1.4_xdf2.xml)
+ Altes Stammdatenschema als XML-Datei im Format XDatenfelder (z.B. S00000159V1.3_xdf2.xml)
+ sollen Codelisteninhalte verglichen werden, alle verwendeten Codelisten beider XDatenfelder-Dateien im Genericodeformat mit Benennung CodelistenID_genericode.xml (z.B. C00000030_genericode.xml)
+ Batch-Datei mit Aufruf gemäß o.g. Beispiel (z.B. co_159.bat)

