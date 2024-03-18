Die Konfigurationswerte werden durch die genannten Übergabeparameter an die XSLT-Datei übergeben. 
Die Defaultwerte werden im Folgenden immer zuerst genannt. 
Ein Beispiel folgt am Ende der Datei.
		
		DateiOutput
		0 = Bericht wird an die Standardausgabe übermittelt
		1 = Bericht wird in einer Datei gespeichert
		
		Navigation
		1 = das Navigationsfenster ist eingeblendet
		0 = das Navigationsfenster ist generell ausgeblendet
		
		JavaScript
		1 = die HTML-Datei enthält Javaschript, z.B. zum ein- und ausblenden der Navigation
		0 = die HTML-Datei enthält kein Javaschript

		Meldungen
		1 = Warnungs- und Fehlermeldungen werden ausgegeben
		0 = Warnungs- und Fehlermeldungen werden nicht ausgegeben

		AbstraktWarnung
		1 = Warnungen zu abstrakten Feldern werden erzeugt
		0 = Warnungen zu abstrakten Feldern werden nicht erzeugt

		VersionsHinweise
		0 = Hinweise zur Erstellung einer Version werden nicht erzeugt
		1 = Hinweise zur Erstellung einer Version werden erzeugt

		MeldungsFazit
		0 = am Anfang des QS-Berichts wird keine Zusammenfassungen angezeigt
		1 = am Anfang des QS-Berichts wird eine Zusammenfassungen mit der Anzahl der Fehler und Warnungen angezeigt

		CodelistenInhalt
		0 = die Inhalte der Codelisten werden nicht angezeigt
		1 = die Inhalte der Codelisten werden aus Dateien CODELISTENID_genericode.xml (z.B. C00000030_genericode.xml) aus dem selben Verzeichnis, wie die Datendatei eingelesen

		ToolAufruf
		1 = es sind Links auf den Datenfeldeditor vorhanden
		0 = es sind keine Links auf den Datenfeldeditor vorhanden

		ToolPfadPrefix
		Start der URL auf den Datenfeldeditor (gefolgt von der ID des Objektes)
		https://www.fim-formular.niedersachsen.de/fim/portal/fim/9/editor/
	
		ToolPfadPostfix
		Ende der URL auf den Datenfeldeditor (nach der ID des Objektes)
		/view

		Statistik
		0 = die Statistik wird nicht angezeigt
		1 = die Statistik wird angezeigt
		2 = es wird nur die Statistik angezeigt (ist nur sinnvoll für den Inhalt des Baukastens Datenfelder)

		StatistikVerwendung
		1 = die Verwendungsstatistik wird angezeigt
		0 = die Verwendungsstatistik wird nicht angezeigt

		StatistikStrukturart
		1 = die Liste der Elemente nach Strukturart wird angezeigt
		0 = die Liste der Elemente nach Strukturart wird nicht angezeigt

		StatistikZustandsinfos
		1 = die Liste der Elemente, bei denen der fachlicher Ersteller leer ist oder deren Status nicht aktiv ist, wird angezeigt
		0 = die Liste der Elemente, bei denen der fachlicher Ersteller leer ist oder deren Status nicht aktiv ist, wird nicht angezeigt

		DebugMode
		3 = Debugmeldungen auf auf Detailebene mit Name des Details
		0 = keine Debugmeldungen
		1 = Debugmeldungen auf Abschnittsebene
		2 = Debugmeldungen auf auf Detailebene
		4 = Debugmeldungen mit allen Templates

Beispiel für eine Batch-Datei zum Aufruf:

"C:\Program Files\Saxonica\SaxonHE10.2N\bin\Transform.exe" -s:S00000159V1.0_xdf2.xml -xsl:..\QS-DF_0_973_xdf2.xsl DateiOutput=1 Navigation=1 JavaScript=1 Meldungen=1 AbstraktWarnung=1 VersionsHinweise=0 MeldungsFazit=0 CodelistenInhalt=0 ToolAufruf=1 ToolPfadPrefix="https://www.fim-formular.niedersachsen.de/fim/portal/fim/9/editor/" ToolPfadPostfix="/view" Statistik=0 StatistikVerwendung=1 StatistikStrukturart=1 StatistikZustandsinfos=1 DebugMode=3
pause

NEU: die Meldungen des Qualitätsberichts sind ausgelagert in eine externe Codeliste, die in der Datei Meldungen.xml enthalten ist. Diese muss in dem selben Verzeichnis, wie die XSLT-Datei liegen.

Vorschlag Verzeichnisaufbau:

- Basis: 
+ QS-DF_0_973_xdf2.xsl (XSLT zur Transformation der Stammdaten-XML-Datei in eine QS-Bericht als HTML-Datei)
+ Meldungen.xml (Codeliste mit den Meldungen)

- Basis\SDS159 (Arbeitsverzeichnis für ein Stammdatenschema):
+ Stammdatenschema als XML-Datei im Format XDatenfelder (z.B. S00000159V1.0_xdf2.xml)
+ sollen Codelisten mit angezeigt werden, alle verwendeten Codelisten im Genericodeformat mit Benennung CodelistenID_genericode.xml (z.B. C00000030_genericode.xml)
+ Batch-Datei mit Aufruf gemäß o.g. Beispiel (z.B. qs_159.bat)

