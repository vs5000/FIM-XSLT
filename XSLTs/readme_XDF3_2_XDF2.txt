XDF3_2_XDF2_0_03_xdf3.xsl: XSLT zur Transformation der xdf2-Dateien ins xdf3-Format

Die Konfigurationswerte werden durch die genannten Übergabeparameter an die XSLT-Datei übergeben. 
Werden einzelne Parameter nicht übergeben, werden die (zuerst) genannten Defaultwerte genutzt. 
Ein Beispiel folgt am Ende der Datei.
		
		DateiOutput
		0 = Bericht wird an die Standardausgabe übermittelt
		1 = Bericht wird in einer Datei gespeichert
		
		HiddenWeglassen
		1 = versteckte Felder werden nicht in XDF2 umgewandelt
		0 = versteckte Felder werden in XDF2-Textfelder umgewandelt
	
		FreitextRegelKorrektur
		1 = in der metasprachlichen Beschreibung der Regeln im XDF3-Feld freitextRegel werden alle Feld- oder Feldgruppenbezeichungen um den Unternummernkreis gekürzt und anschließend in das XDF2-Feld definition übernommen
		0 = metasprachlichen Beschreibung der Regeln im XDF3-Feld freitextRegel werden unverändert in das XDF2-Feld definition übernommen

		CodelistenInternIdentifier
		URN, die bei der Umwandlung von Wertelisten den Start der Kennung bildet
		urn:de:fim:

		CodelistendateienErzeugen
		1 = es werden Genericode-Codelisten-Dateien erzeugt
		0 = es werden keine Genericode-Codelisten-Dateien erzeugt
	
		OriginalwerteDoku
		1 = Werte eines Objektes (Datenschema, Baukastenlement, Regel, Dokumentsteckbrief) aus der Originaldatei, die bei der Konvertierung verändert werden müssen oder verloren gehen, werden im Beschreibungsfeld des ensprechen Objektes hinzugefügt.
		2 = Werte eines Objektes (Datenschema, Baukastenlement, Regel, Dokumentsteckbrief) aus der Originaldatei, die bei der Konvertierung verändert werden müssen oder verloren gehen, werden in einem Kommentar innerhalb des ensprechen Objektes hinzugefügt.
		3 = Werte eines Objektes (Datenschema, Baukastenlement, Regel, Dokumentsteckbrief) aus der Originaldatei, die bei der Konvertierung verändert werden müssen oder verloren gehen, werden sowohl im Beschreibungsfeld als auch in einem Kommentar innerhalb des ensprechen Objektes hinzugefügt.
		0 = es erfolgt keine Hinterlegung der veränderten oder verlorenen Originalwerte

		XDF2WerteErhalten
		0 = Orignialwerte, die im Beschreibungsfeld aus einer vorherigen Konvertieren entahlten sind werden gelöscht
		1 = Orignialwerte, die im Beschreibungsfeld aus einer vorherigen Konvertieren entahlten sind werden erhalten

		XMLXRepoMitVersionPfadPrefix
		Start der URL zum Abruf von Codelisten aus dem XRepository (gefolgt von der Versionskennung der Codeliste)
		https://www.xrepository.de/api/version_codeliste/
	
		XMLXRepoMitVersionPfadPostfix
		Ende der URL zum Abruf von Codelisten aus dem XRepository (nach der Versionskennung der Codeliste)
		/genericode

		XMLXRepoOhneVersionPfadPrefix
		Start der URL zur Ermittlung der aktuellen Version einer Codelisten im XRepository (gefolgt von der Kennung der Codeliste)
		https://www.xrepository.de/api/codeliste/
	
		XMLXRepoOhneVersionPfadPostfix
		Ende der URL zur Ermittlung der aktuellen Version einer Codelisten im XRepository (nach der Kennung der Codeliste)
		/gueltigeVersion

		DebugMode
		3 = Debugmeldungen auf auf Detailebene mit Name des Details
		0 = keine Debugmeldungen
		1 = Debugmeldungen auf Abschnittsebene
		2 = Debugmeldungen auf auf Detailebene
		4 = Debugmeldungen mit allen Templates

Beispiel für eine Batch-Datei zum Aufruf mit Java (zu präferieren):

java -jar "C:\Program Files\Saxonica\SaxonHE10-6J\saxon-he-10.6.jar" -s:S00000000159_Wohngeld_Mietzuschuss_-_Erstantrag_xdf3.xml -xsl:..\XDF3_2_XDF2_0_03_xdf3.xsl DateiOutput=1 HiddenWeglassen=1 FreitextRegelKorrektur=1 CodelistenInternIdentifier="urn:de:fim:" CodelistendateienErzeugen=1 OriginalwerteDoku=1 XDF2WerteErhalten=0 DebugMode=3
pause

Beispiel für eine Batch-Datei zum Aufruf mit .NET:
"C:\Program Files\Saxonica\SaxonHE10.6N\bin\Transform.exe" -s:S00000000159_Wohngeld_Mietzuschuss_-_Erstantrag_xdf3.xml -xsl:..\XDF3_2_XDF2_0_03_xdf3.xsl DateiOutput=1 HiddenWeglassen=1 FreitextRegelKorrektur=1 CodelistenInternIdentifier="urn:de:fim:" CodelistendateienErzeugen=1 OriginalwerteDoku=1 XDF2WerteErhalten=0 DebugMode=3
pause

Vorschlag Verzeichnisaufbau:

- Basis: 
+ XDF3_2_XDF2_0_03_xdf3.xsl (XSLT zur Transformation der Stammdaten-XML-Datei im Format XDF3 ins Format XDF2 plus zugehöriger Genericode-Codelisten)

- Basis\SDS159 (Arbeitsverzeichnis für ein Stammdatenschema):
+ Datenschema als XML-Datei im Format XDatenfelder3 (z.B. S00000000159_Wohngeld_Mietzuschuss_-_Erstantrag_xdf3.xml)
+ Batch-Datei mit Aufruf gemäß o.g. Beispiel (z.B. tr_159.bat)


