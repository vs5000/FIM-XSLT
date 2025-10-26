Mit der XSLT-Datei QS-DF_x_yy_xdf3.xsl kann ein (Qualitäts-)Bericht zu XDF3-Datenschemata, -Datenfeldgruppen und - Dokumentsteckbriefen erzeugt werden. 

Die Konfigurationswerte werden durch die genannten Übergabeparameter an die XSLT-Datei übergeben. 
Die Defaultwerte werden im Folgenden immer zuerst genannt. 
Ein Beispiel folgt am Ende der Datei.
		
		DateiOutput
		0 = Bericht wird an die Standardausgabe übermittelt
		1 = Bericht wird in einer Datei gespeichert
		
		Navigation
		1 = das Navigationsfenster ist eingeblendet
		0 = das Navigationsfenster ist generell ausgeblendet
		2 = das Navigationsfenster ist generell ausgeblendet - eine Inline-Navigation wird angezeigt
		
		JavaScript
		1 = die HTML-Datei enthält Javaschript, z.B. zum ein- und ausblenden der Navigation
		0 = die HTML-Datei enthält kein Javaschript

		Meldungen
		1 = Hinweise, Warnungs- und Fehlermeldungen werden ausgegeben
		0 = Hinweise, Warnungs- und Fehlermeldungen werden nicht ausgegeben

		MeldungsFazit
		1 = am Anfang des QS-Berichts wird eine Zusammenfassungen mit Typ und Anzahl der Meldungen angezeigt
		0 = am Anfang des QS-Berichts wird keine Zusammenfassungen der Meldungen angezeigt

		VersionsHinweise
		0 = Hinweise zur Erleichterung der Versionierung werden nicht ausgegeben
		1 = Hinweise zur Erleichterung der Versionierung werden ausgegeben

		CodelistenInhalt
		0 = die Inhalte der Codelisten werden nicht angezeigt
		1 = die Inhalte der Codelisten werden aus dem XRepository geladen, wenn eine Version ermittelt werden kann

		AktuelleCodelisteLaden
		1 = wenn bei einer Codeliste keine Version angegeben ist, wird versucht die aktuelle Version aus dem XRepository zu laden
		0 = wenn bei einer Codeliste keine Version angegeben ist, werden die Inhalte der Codeliste nicht geladen

		SammelrepositoryCheck
		0 = Baukstenelemente werden nicht auf Aktualität geprüft
		1 = bei Baukastenelementen wird versucht auf das Sammelrepository zuzugreifen, um zu prüfen ab es aktuellere Versionen gibt

		WurzelAlleUnterelemente
		0 = im obersten Element (Datenschema oder Datenfeldgruppe) werden nur die direkten Unterelemente aufgelistet
		1 = im obersten Element (Datenschema oder Datenfeldgruppe) wird der gesamte Baum mit allen Unterelementen angezeigt

		XRepoAufruf
		1 = zu den Codelisten werden Links auf die zugehörigen Seiten im XRepository angezeigt
		0 = zu den Codelisten werden keine Links zum XRepository angezeigt

		ToolAufruf
		1 = es sind Links auf den Datenfeldeditor vorhanden
		0 = es sind keine Links auf den Datenfeldeditor vorhanden

		ToolPfadPrefix
		Start der URL auf den Datenfeldeditor (gefolgt von der ID des Objektes)
		https://fred.niedersachsen.de/fim/portal/fim/16/client/index.html#/datenmodellierung/
	
		ToolPfadPostfix
		Ende der URL auf den Datenfeldeditor (nach der ID des Objektes)

		Statistik
		0 = die Statistik wird nicht angezeigt
		1 = die Statistik wird angezeigt
		2 = es wird nur die Statistik angezeigt

		StatistikKennzahlen
		1 = es werden generelle Kennzahlen zu Verwendung von Baukastenelementen gezeigt
		0 = es werden keine Kennzahlen zu Verwendung von Baukastenelementen gezeigt
		
		StatistikVerwendung
		1 = die Verwendungsstatistik wird angezeigt
		0 = die Verwendungsstatistik wird nicht angezeigt

		StatistikStrukturart
		1 = die Liste der Elemente nach Strukturart wird angezeigt
		0 = die Liste der Elemente nach Strukturart wird nicht angezeigt

		StatistikStatus
		1 = die Liste der Elemente nach Status wird angezeigt
		0 = die Liste der Elemente nach Status wird nicht angezeigt

		StatistikIDVersion
		1 = die Liste der Elemente nach Nummernkreis, ID und Version wird angezeigt
		0 = die Liste der Elemente nach Nummernkreis, ID und Version wird nicht angezeigt

		StatistikHandlungsgrundlage
		1 = die Liste der Elemente nach Nummernkreis und Handlungsgrundlagen wird angezeigt
		0 = die Liste der Elemente nach Nummernkreis und Handlungsgrundlagen wird nicht angezeigt

		StatistikAktualitaet
		1 = die Liste der Elemente nach Nummernkreis, ID, Version mit Aktualität wird angezeigt
		0 = die Liste der Elemente nach Nummernkreis, ID, Version mit Aktualität wird nicht angezeigt

		StatistikFachlicherErsteller
		1 = die Liste der Elemente sortiert nach Fachlichem Ersteller wird angezeigt
		0 = die Liste der Elemente sortiert nach Fachlichem Ersteller wird nicht angezeigt

		DebugMode
		3 = Debugmeldungen auf auf Detailebene mit Name des Details
		0 = keine Debugmeldungen
		1 = Debugmeldungen auf Abschnittsebene
		2 = Debugmeldungen auf auf Detailebene
		4 = Debugmeldungen mit allen Templates

Beispiel für eine Batch-Datei zum Aufruf mit Java:

java -jar "C:\Program Files\Saxonica\SaxonHE10-6J\saxon-he-10.6.jar" -s:S00123000159V1.4_xdf3.xml -xsl:..\QS-DF_1_14_xdf3.xsl DateiOutput=1 Navigation=1 JavaScript=1 Meldungen=1 MeldungsFazit=0 CodelistenInhalt=0 AktuelleCodelisteLaden=1 ToolAufruf=1 ToolPfadPrefix="https://fred.niedersachsen.de/fim/portal/fim/16/client/index.html#/datenmodellierung/" ToolPfadPostfix="" Statistik=0 StatistikVerwendung=1 StatistikStrukturart=1 StatistikZustandsinfos=1 DebugMode=3
pause

Beispiel für eine Batch-Datei zum Aufruf mit .NET - (externe) Codelisten können nicht geladen werden, daher ist die Java-Version zu bevorzugen:

"C:\Program Files\Saxonica\SaxonHE10.2N\bin\Transform.exe" -s:S00123000159V1.4_xdf3.xml -xsl:..\QS-DF_1_14_xdf3.xsl DateiOutput=1 Navigation=1 JavaScript=1 Meldungen=1 MeldungsFazit=0 CodelistenInhalt=0 AktuelleCodelisteLaden=1 ToolAufruf=1 ToolPfadPrefix="https://fred.niedersachsen.de/fim/portal/fim/16/client/index.html#/datenmodellierung/" ToolPfadPostfix="" Statistik=0 StatistikVerwendung=1 StatistikStrukturart=1 StatistikZustandsinfos=1 DebugMode=3
pause

NEU: die Meldungen des Qualitätsberichts sind ausgelagert in eine externe Codeliste, die in der Datei Meldungen.xml enthalten ist. Diese muss in dem selben Verzeichnis, wie die XSLT-Datei liegen.

Vorschlag Verzeichnisaufbau:

- Basis: 
+ QS-DF_1_14_xdf3.xsl (XSLT zur Transformation der Stammdaten-XML-Datei in eine QS-Bericht als HTML-Datei)
+ Meldungen.xml (Codeliste mit den Meldungen)

- Basis\SDS159 (Arbeitsverzeichnis für ein Datenschema):
+ Stammdatenschema als XML-Datei im Format XDatenfelder (z.B. S00123000159V1.4_xdf3.xml)
+ Batch-Datei mit Aufruf gemäß o.g. Beispiel (z.B. qs_159.bat)

