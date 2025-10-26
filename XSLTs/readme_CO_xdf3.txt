Mit der XSLT-Datei COMP-DF_x_yy_xdf3.xsl können zwei XDF3-Dateien des selben Typs miteinander verglichen werden. Es lassen sich also zwei Datenschemata oder zwei Datenfeldgruppen miteinander vergleichen.

Die Konfigurationswerte werden durch die genannten Übergabeparameter an die XSLT-Datei übergeben. 
Die Defaultwerte werden im Folgenden immer zuerst genannt. 
Ein Beispiel folgt am Ende der Datei.
		
		VergleichsDateiName
		Name der Datei, mit welcher die übergebene Datei verglichen werden soll
		z.B. S00000000159V1.5.0_Erstantrag_Wohngeld_Mietzuschuss_xdf3.xml oder G60000000025V1.2.0_Signatur_(Unterschriftsbereich)_xdf3.xml - kein Defaultwert
		
		VergleichsGrad
		0 = alle Unterschiede werden angezeigt
		1 = es werden keine Felder verglichen, die interne Statusinformationen und Historie enthalten - folgende Feldern werden nicht verglichen: 
			Version, Versionshinweis, Name, Fachlicher Ersteller, Status, Status gesetzt am, Veröffentlichungsdatum, Letzte Änderung
		2 = es werden nur Felder verglichen, die direkt relevant für Endnutzer sind - es werden keine Felder aus Vergleichsgrad 1 und zusätzlich werden folgende Felder nicht verglichen: 
			Stichwörter, Definition, Handlungsgrundlagen, Beschreibung, Änderbarkeit Struktur, Änderbarkeit Repräsentation, Strukturelementart, Vorbefüllung, Gültig ab, Gültig bis, Dokumentsteckbrief, Relationen
		3 = es werden nur Felder verglichen, die die Struktur und Art der Daten beschreiben - es werden keine Felder aus den Vergleichsgrad 1 sowie 2 und zusätzlich werden folgende Felder nicht verglichen:
			Bezeichnung, Bezeichnung Eingabe, Bezeichnung Ausgabe, Hilfetext, Hilfetext Eingabe, Hilfetext Ausgabe 

		RegelDetails
		1 = Regeln werden im Detail verglichen
		0 = Regeln werden nicht im Detail verglichen

		CodelistenInhalt
		0 = die Inhalte der Codelisten werden nicht verglichen
		1 = die Inhalte der Codelisten werden aus dem XRepository geladen, wenn eine Version ermittelt werden kann, und verglichen
		
		AktuelleCodelisteLaden
		1 = wenn bei einer Codeliste keine Version angegeben ist, wird versucht die aktuelle Version zum Vergleich aus dem XRepository zu laden
		0 = wenn bei einer Codeliste keine Version angegeben ist, werden die Inhalte der Codeliste nicht verglichen

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

		HandlungsgrundlagenLinks
		1 = die Links auf die Handlungsgrundlagen werden angezeigt
		0 = die Links auf die Handlungsgrundlagen werden nicht angezeigt
		
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

		DebugMode
		3 = Debugmeldungen auf auf Detailebene mit Name des Details
		0 = keine Debugmeldungen
		1 = Debugmeldungen auf Abschnittsebene
		2 = Debugmeldungen auf auf Detailebene
		4 = Debugmeldungen mit allen Templates

Beispiel für eine Batch-Datei zum Aufruf mit Java:

java -jar "C:\Program Files\Saxonica\SaxonHE10-6J\saxon-he-10.6.jar" -s:"S00000000159V1.6.0_Erstantrag_Wohngeld_Mietzuschuss_xdf3.xml" -xsl:..\COMP-DF_1_01_xdf3.xsl VergleichsDateiName="S00000000159V1.5.0_Erstantrag_Wohngeld_Mietzuschuss_xdf3.xml" VergleichsGrad=0 RegelDetails=1 CodelistenInhalt=1 AktuelleCodelisteLaden=1 AenderungsFazit=1 DateiOutput=1 Navigation=1 JavaScript=1 HandlungsgrundlagenLinks=1 XRepoAufruf=1 ToolAufruf=1 ToolPfadPrefix="https://fred.niedersachsen.de/fim/portal/fim/16/client/index.html#/datenmodellierung/" ToolPfadPostfix="" DebugMode=3
pause

Beispiel für eine Batch-Datei zum Aufruf mit .NET - (externe) Codelisten können nicht geladen werden, daher ist die Java-Version zu bevorzugen:

"C:\Program Files\Saxonica\SaxonHE10.2N\bin\Transform.exe" -s:"S00000000159V1.6.0_Erstantrag_Wohngeld_Mietzuschuss_xdf3.xml" -xsl:..\COMP-DF_1_01_xdf3.xsl VergleichsDateiName="S00000000159V1.5.0_Erstantrag_Wohngeld_Mietzuschuss_xdf3.xml" VergleichsGrad=0 RegelDetails=1 CodelistenInhalt=1 AktuelleCodelisteLaden=1 AenderungsFazit=1 DateiOutput=1 Navigation=1 JavaScript=1 HandlungsgrundlagenLinks=1 XRepoAufruf=1 ToolAufruf=1 ToolPfadPrefix="https://fred.niedersachsen.de/fim/portal/fim/16/client/index.html#/datenmodellierung/" ToolPfadPostfix="" DebugMode=3
pause

Vorschlag Verzeichnisaufbau:

- Basis: 
+ COMP-DF_1_01_xdf3.xsl (XSLT zur Transformation der beiden Input-XDF3-Dateien in einen Änderungsbericht als HTML-Datei)

- Basis\SDS159 (Arbeitsverzeichnis für ein Datenschema):
+ Neues Datenschema/Datenfeldgruppe als XML-Datei im Format XDatenfelder3 (z.B. S00000000159V1.6.0_Erstantrag_Wohngeld_Mietzuschuss_xdf3.xml)
+ Altes Datenschema/Datenfeldgruppe als XML-Datei im Format XDatenfelder3 (z.B. S00000000159V1.5.0_Erstantrag_Wohngeld_Mietzuschuss_xdf3.xml)
+ Batch-Datei mit Aufruf gemäß o.g. Beispiel (z.B. co_159.bat)

