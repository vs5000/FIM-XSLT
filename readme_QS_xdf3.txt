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

Beispiel für eine Batch-Datei zum Aufruf mit Java:

java -jar "C:\Program Files\Saxonica\SaxonHE10-6J\saxon-he-10.6.jar" -s:S00123000159V1.4_xdf3.xml -xsl:..\QS-DF_0_986_xdf3.xsl DateiOutput=1 Navigation=1 JavaScript=1 Meldungen=1 AbstraktWarnung=1 MeldungsFazit=0 CodelistenInhalt=0 ToolAufruf=1 ToolPfadPrefix="https://www.fim-formular.niedersachsen.de/fim/portal/fim/9/editor/" ToolPfadPostfix="/view" Statistik=0 StatistikVerwendung=1 StatistikStrukturart=1 StatistikZustandsinfos=1 DebugMode=3
pause

Beispiel für eine Batch-Datei zum Aufruf mit .NET - (externen) Codelisten können nicht geladen werden, daher siehe unten (*):

"C:\Program Files\Saxonica\SaxonHE10.2N\bin\Transform.exe" -s:S00123000159V1.4_xdf3.xml -xsl:..\QS-DF_0_986_xdf3.xsl DateiOutput=1 Navigation=1 JavaScript=1 Meldungen=1 AbstraktWarnung=1 MeldungsFazit=0 CodelistenInhalt=0 ToolAufruf=1 ToolPfadPrefix="https://www.fim-formular.niedersachsen.de/fim/portal/fim/9/editor/" ToolPfadPostfix="/view" Statistik=0 StatistikVerwendung=1 StatistikStrukturart=1 StatistikZustandsinfos=1 DebugMode=3
pause

Vorschlag Verzeichnisaufbau:

- Basis: 
+ QS-DF_0_986_xdf3.xsl (XSLT zur Transformation der Stammdaten-XML-Datei in eine QS-Bericht als HTML-Datei)

- Basis\SDS159 (Arbeitsverzeichnis für ein Stammdatenschema):
+ Stammdatenschema als XML-Datei im Format XDatenfelder (z.B. S00123000159V1.4_xdf3.xml)
+ (*)bei der Verwendung von .NET müssen hier alle referenzierten Codelisten im Genericodeformat mit Benennung CanonicalVersionUri.xml vorliegen, wobei Doppelpunkte durch einfache Punkte ersetzt werden (z.B. urn.de.bund.destatis.bevoelkerungsstatistik.schluessel.staat_2019-02-01.xml)
+ Batch-Datei mit Aufruf gemäß o.g. Beispiel (z.B. qs_159.bat)

