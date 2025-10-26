XDF3 Transformer

Ein Java-Tool zur Transformation von XDF3-Dateien mittels XSLT.

Beschreibung
XDF3 Transformer ermöglicht die Verarbeitung und Transformation von XDF3-Dateien (XML-Datenaustauschformat) unter Verwendung von XSLT-Stylesheets. Das Tool nutzt den leistungsfähigen Saxon-HE XSLT-Prozessor.

Features
- XSLT-basierte Transformation von XDF3-Dateien
-- Qualitätsbericht
-- Visualisierung
-- Vergleich zweier XDF3-Dateien
-- XFall- / XML-Schema-Generierung
-- JSON-Generierung
- GUI-Oberfläche zur Einstellung der Parameter und Strat der Transformation
- Windows-EXE-Wrapper verfügbar

Systemanforderungen
- Java Runtime Environment (JRE) 8 oder höher
- Windows (für .exe-Version) oder beliebiges Betriebssystem (für JAR-Version)

Installation

Windows (EXE)
- Laden Sie xdf3-transformer.exe aus den Releases herunter
- Stellen Sie sicher, dass Java 8 oder höher installiert ist
- Führen Sie die EXE-Datei aus

Alle Betriebssysteme (JAR)
- Laden Sie xdf3-transformer-0.7.2-jar-with-dependencies.jar herunter
- Führen Sie aus mit: java -jar xdf3-transformer-0.7.2-jar-with-dependencies.jar

Verwendete Technologien
- Java 8 - Programmiersprache
- Saxon-HE 10.6 - XSLT-Prozessor
- Maven - Build-Management
- Launch4j - Windows EXE Wrapper

Lizenz
Dieses Projekt ist unter der Apache License 2.0 lizenziert.
Siehe THIRD-PARTY-LICENSES.txt für Lizenzen der verwendeten Bibliotheken.

Credits
Entwickelt von:
Volker Schmitz IT Beratung

Verwendet folgende Open-Source-Bibliotheken:
- Saxon-HE 10.6 © Saxonica Limited (Mozilla Public License 2.0)
- Launch4j © Grzegorz Kowal (BSD/MIT License)
