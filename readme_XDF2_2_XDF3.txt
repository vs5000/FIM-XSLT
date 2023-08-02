XDF2_2_XDF3_0_05.xsl: XSLT zur Transformation der xdf2-Dateien ins xdf3-Format

Die Konfigurationswerte werden durch die genannten Übergabeparameter an die XSLT-Datei übergeben. 
Werden einzelne Parameter nicht übergeben, werden die (zuerst) genannten Defaultwerte genutzt. 
Ein Beispiel folgt am Ende der Datei.
		
		DateiOutput
		0 = Bericht wird an die Standardausgabe übermittelt
		1 = Bericht wird in einer Datei gespeichert
		
		Unternummernkreis
		Der Unternummernkreis, der ergänzt wird um von der 9-stelligen zur 12-stelligen ID zu kommen
		000
	
		SubstitutionS
		Gibt an, ob vor der eigentlich Konvertierung von XDF2 nach XDF3 zusätzlich die ID des Datenschema/Dokumentsteckbriefs verändert werden sollen. 
		Jede Transformationsregel wird durch ein Tupel von drei Werten repräsentiert, die durch Kommata getrennt sind: Ursprungshauptnummerkreis, Zielhauptnummerkreis,Verschiebung der IDs. 
		Werden mehrere solche Transformationen angegeben, werden diese durch Semikola getrennt.
		Beispiel: 17,01,1000 bedeutet, dass z.B. ein Datenschema S17000001 umbenannt wird in S01001001.
		Default ist, dass keine Substitution definiert ist, also die Angabe leer ist.

		SubstitutionB
		Gibt an, ob vor der eigentlich Konvertierung von XDF2 nach XDF3 zusätzlich die ID der enthaltenen Baukastenelemente (soweit möglich auch in Regeln) verändert werden sollen. 
		Jede Transformationsregel wird durch ein Tupel von drei Werten repräsentiert, die durch Kommata getrennt sind: Ursprungshauptnummerkreis, Zielhauptnummerkreis,Verschiebung der IDs. 
		Werden mehrere solche Transformationen angegeben, werden diese durch Semikola getrennt.
		Beispiel: 17,01,500;05,01,5000 bedeutet, dass 
		1. alle Baukastenelemente aus dem Hauptnummerkreis 17 in den Hauptnummernkreis 01 verschoben und die ID dabi um 500 erhöht wird, z.B. eine Feldgruppe G17000010 umbenannt wird in G01000510 und
		2. alle Baukastenelemente aus dem Hauptnummerkreis 05 in den Hauptnummernkreis 01 verschoben und die ID dabi um 5000 erhöht wird, z.B. eine Feldgruppe G05000005 umbenannt wird in G05005005.
		Default ist, dass keine Substitution definiert ist, also die Angabe leer ist.

		BezuegeAufteilen
		1 = das Input-Feld bezug im xdf2-Format wird über das Trennzeichen ';' auf u.U. mehrere Felder bezug im xdf3-Format aufgeteilt
		0 = das Feld bezug (mit dem Handlungsbezug) wird vom xdf2-Format unverändert in das xdf3-Format übernommen

		DokumentsteckbriefID
		ID des Dokumentsteckbriefs der als Default im xdf3-Feld dokumentsteckbrief zum Datenschema hinzugefügt werden muss
		D00000000001

		Codelisten2Wertelisten
		1 = Interne Codelisten werden in Wertelisten umgewandelt, falls deren URN einen der CodelistenInternIdentifier enthält
		0 = Interne Codelisten werden nie in Wertelisten umgewandelt gemäß der CodelistenInternIdentifier

		CodelistenInternIdentifier
		Teile der URN zur Identifikation einer internen Codeliste - es können mehrere Teilstrings, durch Semikola getrennt, angegeben werden - z.B. "urn:de:fim:;hamburg"
		urn:de:fim:

		FreitextRegelKorrektur
		1 = in der metasprachlichen Beschreibung der Regeln im XDF2-Feld definition werden alle Feld- oder Feldgruppenbezeichungen um den Unternummernkreis ergänzt und anschließend in das XDF3-Feld freitextRegel übernommen
		0 = metasprachlichen Beschreibung der Regeln im XDF2-Feld definition werden unverändert in das XDF3-Feld freitextRegel übernommen

		PruefeCodelistenErreichbarkeit (erfordert Saxon Java)
		1 = wandelt externe Codelisten nur dann in codelisteReferenzen um, wenn diese auch im XRepository enthalten sind - falls sie nicht enthalten sind werden diese in Wertelisten umgewandelt
		0 = wandelt externe Codelisten immer, ohne Verfügbarkeitsprüfung in codelisteReferenzen um

		OriginalwerteDoku
		1 = Werte eines Objektes (Datenschema, Baukastenlement, Regel, Dokumentsteckbrief) aus der Originaldatei, die bei der Konvertierung verändert werden müssen oder verloren gehen, werden im Beschreibungsfeld des ensprechen Objektes hinzugefügt.
		2 = Werte eines Objektes (Datenschema, Baukastenlement, Regel, Dokumentsteckbrief) aus der Originaldatei, die bei der Konvertierung verändert werden müssen oder verloren gehen, werden in einem Kommentar innerhalb des ensprechen Objektes hinzugefügt.
		2 = Werte eines Objektes (Datenschema, Baukastenlement, Regel, Dokumentsteckbrief) aus der Originaldatei, die bei der Konvertierung verändert werden müssen oder verloren gehen, werden sowohl im Beschreibungsfeld als auch in einem Kommentar innerhalb des ensprechen Objektes hinzugefügt.
		0 = es erfolgt keine Hinterlegung der verlustbehafteten Originalwerte

		DebugMode
		3 = Debugmeldungen auf auf Detailebene mit Name des Details
		0 = keine Debugmeldungen
		1 = Debugmeldungen auf Abschnittsebene
		2 = Debugmeldungen auf auf Detailebene
		4 = Debugmeldungen mit allen Templates

Beispiel für eine Batch-Datei zum Aufruf mit Java:

java -jar "C:\Program Files\Saxonica\SaxonHE10-6J\saxon-he-10.6.jar" -s:S00000159_xdf2.xml -xsl:..\XDF2_2_XDF3_0_05_xdf2.xsl DateiOutput=1 Unternummernkreis="000" SubstitutionS="" SubstitutionB="" BezuegeAufteilen=1 DokumentsteckbriefID="D00000000001" Codelisten2Wertelisten="1" CodelistenInternIdentifier="urn:de:fim:" FreitextRegelKorrektur=1 PruefeCodelistenErreichbarkeit=1 OriginalwerteDoku=1 DebugMode=3
pause

Beispiel für eine Batch-Datei zum Aufruf mit .NET:
"C:\Program Files\Saxonica\SaxonHE10.6N\bin\Transform.exe" -s:S00000159_xdf2.xml -xsl:..\XDF2_2_XDF3_0_05_xdf2.xsl DateiOutput=1 Unternummernkreis="000" SubstitutionS="" SubstitutionB="" BezuegeAufteilen=1 DokumentsteckbriefID="D00000000001" Codelisten2Wertelisten="1" CodelistenInternIdentifier="urn:de:fim:" FreitextRegelKorrektur=1 PruefeCodelistenErreichbarkeit=1 OriginalwerteDoku=1 DebugMode=3
pause

Vorschlag Verzeichnisaufbau:

- Basis: 
+ XDF2_2_XDF3_0_05_xdf2.xsl (XSLT zur Transformation der Stammdaten-XML-Datei im Format XDF2 ins Format XDF3)

- Basis\SDS159 (Arbeitsverzeichnis für ein Stammdatenschema):
+ Stammdatenschema als XML-Datei im Format XDatenfelder2 (z.B. S00000159_xdf2.xml)
+ alle verwendeten Codelisten im Genericodeformat mit Benennung CodelistenID_genericode.xml (z.B. C00000030_genericode.xml)
+ Batch-Datei mit Aufruf gemäß o.g. Beispiel (z.B. tr_159.bat)


