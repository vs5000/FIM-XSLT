<?xml version="1.0" encoding="iso-8859-1"?>
<xsl:stylesheet version="2.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:html="http://www.w3.org/1999/xhtml" xmlns="http://www.w3.org/1999/xhtml" xmlns:fn="http://www.w3.org/2005/xpath-functions" xmlns:xdf="urn:xoev-de:fim:standard:xdatenfelder_2" xmlns:gc="http://docs.oasis-open.org/codelist/ns/genericode/1.0/" xmlns:xs="http://www.w3.org/2001/XMLSchema" exclude-result-prefixes="html xs">
	<!--
	Copyright 2023 Volker Schmitz
	
	Licensed under the Apache License, Version 2.0 (the "License");
	you may not use this file except in compliance with the License.
	
	You may obtain a copy of the License at
		http://www.apache.org/licenses/LICENSE-2.0
	
	Unless required by applicable law or agreed to in writing, software
	distributed under the License is distributed on an "AS IS" BASIS,
	WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
	
	See the License for the specific language governing permissions and
	limitations under the License.
	-->
	<xsl:variable name="StyleSheetURI" select="fn:static-base-uri()"/>
	<xsl:variable name="DocumentURI" select="fn:document-uri(.)"/>

	<xsl:variable name="StyleSheetName" select="'QS-DF_0_968_xdf2.xsl'"/> <!-- BackUp, falls fn:static-base-uri() leer -->
	
	<xsl:output method="xhtml" doctype-system="http://www.w3.org/TR/xhtml11/DTD/xhtml11.dtd" doctype-public="-//W3C//DTD XHTML 1.1//EN" omit-xml-declaration="yes"/>

	<xsl:strip-space elements="*"/>

	<xsl:param name="DateiOutput" select="'0'"/>
	<xsl:param name="JavaScript" select="'1'"/>
	<xsl:param name="Navigation" select="'1'"/>
	<xsl:param name="InterneLinks" select="'1'"/>
	<xsl:param name="Meldungen" select="'1'"/>
	<xsl:param name="AbstraktWarnung" select="'1'"/>
	<xsl:param name="VersionsHinweise" select="'0'"/>
	<xsl:param name="MeldungsFazit" select="'1'"/>
	<xsl:param name="CodelistenInhalt" select="'0'"/>
	<xsl:param name="ToolAufruf" select="'1'"/>
	<xsl:param name="ToolPfadPrefix" select="'https://www.fim-formular.niedersachsen.de/fim/portal/fim/9/editor/'"/>
	<xsl:param name="ToolPfadPostfix" select="'/view'"/>
	<xsl:param name="Statistik" select="'0'"/>
	<xsl:param name="StatistikVerwendung" select="'1'"/>
	<xsl:param name="StatistikStrukturart" select="'1'"/>
	<xsl:param name="StatistikZustandsinfos" select="'1'"/>
	<xsl:param name="StatistikFehlendeArbeitskopien" select="'0'"/>
	<xsl:param name="DebugMode" select="'3'"/>
	<xsl:param name="TestMode"/>
	<xsl:variable name="Daten" select="/"/>
	<xsl:variable name="InputDateiname" select="(tokenize($DocumentURI,'/'))[last()]"/>
	<xsl:variable name="InputPfad" select="fn:substring-before($DocumentURI, $InputDateiname)"/>
	<xsl:template match="/">
		<xsl:if test="$DebugMode = '1' or $DebugMode = '2' or $DebugMode = '3' or $DebugMode = '4'">
			<xsl:message>
				Start
				Input: <xsl:value-of select="$InputDateiname"/>
			</xsl:message>
		</xsl:if>
		<xsl:if test="$DebugMode = '4'">
			<xsl:message>
				Parameter
				StyleSheetURI: <xsl:value-of select="$StyleSheetURI"/>
				DocumentURI: <xsl:value-of select="$DocumentURI"/>
				DateiOutput: <xsl:value-of select="$DateiOutput"/>
				JavaScript: <xsl:value-of select="$JavaScript"/>
				Navigation: <xsl:value-of select="$Navigation"/>
				InterneLinks: <xsl:value-of select="$InterneLinks"/>
				ToolAufruf: <xsl:value-of select="$ToolAufruf"/>
				ToolPfadPrefix: <xsl:value-of select="$ToolPfadPrefix"/>
				ToolPfadPostfix: <xsl:value-of select="$ToolPfadPostfix"/>
				Meldungen: <xsl:value-of select="$Meldungen"/>
				AbstraktWarnung: <xsl:value-of select="$AbstraktWarnung"/>
				VersionsHinweise: <xsl:value-of select="$VersionsHinweise"/>
				MeldungsFazit: <xsl:value-of select="$MeldungsFazit"/>
				CodelistenInhalt: <xsl:value-of select="$CodelistenInhalt"/>
				Statistik: <xsl:value-of select="$Statistik"/>
				StatistikVerwendung: <xsl:value-of select="$StatistikVerwendung"/>
				StatistikStrukturart: <xsl:value-of select="$StatistikStrukturart"/>
				StatistikZustandsinfos: <xsl:value-of select="$StatistikZustandsinfos"/>
				DebugMode: <xsl:value-of select="$DebugMode"/>
			</xsl:message>
		</xsl:if>
		<xsl:choose>
			<xsl:when test="$DateiOutput ='1'">
				<xsl:variable name="OutputDateiname">
					<xsl:choose>
						<xsl:when test="name(/*) ='xdf:xdatenfelder.stammdatenschema.0102'">Bericht_<xsl:value-of select="/*/xdf:stammdatenschema/xdf:identifikation/xdf:id"/>
							<xsl:if test="/*/xdf:stammdatenschema/xdf:identifikation/xdf:version">V<xsl:value-of select="/*/xdf:stammdatenschema/xdf:identifikation/xdf:version"/>
							</xsl:if>.html</xsl:when>
						<xsl:when test="name(/*) ='xdf:fim.backup'">Bericht_Datenfelder.html</xsl:when>
						<xsl:otherwise>Bericht_FEHLER.html</xsl:otherwise>
					</xsl:choose>
				</xsl:variable>
				<xsl:result-document href="{$OutputDateiname}">
					<xsl:call-template name="hauptfunktion"/>
				</xsl:result-document>
				<xsl:if test="$DebugMode = '1' or $DebugMode = '2' or $DebugMode = '3' or $DebugMode = '4'">
					<xsl:message>
						Output: <xsl:value-of select="$OutputDateiname"/>
						Ende
					</xsl:message>
				</xsl:if>
			</xsl:when>
			<xsl:otherwise>
				<xsl:call-template name="hauptfunktion"/>
				<xsl:if test="$DebugMode = '1' or $DebugMode = '2' or $DebugMode = '3' or $DebugMode = '4'">
					<xsl:message>
						Ende
					</xsl:message>
				</xsl:if>
			</xsl:otherwise>
		</xsl:choose>
	</xsl:template>
	<!-- ############################################################################################################# -->
	<xsl:template name="hauptfunktion">
		<html>
			<head>
				<xsl:choose>
					<xsl:when test="name(/*) ='xdf:xdatenfelder.stammdatenschema.0102'">
						<title>Details zum Datenschema <xsl:value-of select="/*/xdf:stammdatenschema/xdf:identifikation/xdf:id"/>
							<xsl:if test="/*/xdf:stammdatenschema/xdf:identifikation/xdf:version"> Version <xsl:value-of select="/*/xdf:stammdatenschema/xdf:identifikation/xdf:version"/>
							</xsl:if>
						</title>
					</xsl:when>
					<xsl:when test="name(/*) ='xdf:fim.backup'">
						<title>FIM-Baustein Datenfelder</title>
					</xsl:when>
					<xsl:otherwise>
						<title>Unbekanntes Dateiformat</title>
					</xsl:otherwise>
				</xsl:choose>
				<meta name="author" content="Volker Schmitz"/>
				<xsl:call-template name="styleandscript"/>
			</head>
			<body onload="ZaehleMeldungen()">
				<xsl:if test="$Navigation = '1' and $Statistik !='2'">
					<div id="fixiert" class="Navigation">
						<xsl:if test="$JavaScript = '1'">
							<p align="right">
								<a href="#" title="Schließe das Navigationsfenster" onclick="VersteckeNavigation(); return false;">&#10006;</a>
							</p>
						</xsl:if>
						<h2>Navigation</h2>
						<xsl:choose>
							<xsl:when test="name(/*) ='xdf:xdatenfelder.stammdatenschema.0102'">
								<xsl:if test="$MeldungsFazit = '1' and $Meldungen = '1' and $JavaScript = '1'">
									<p id="ZusammenfassungLink">
										<a href="#Zusammenfassung">QS-Zusammenfassung</a>
									</p>
								</xsl:if>
								<p>
									<a href="#StammDetails">Details zu den Datenschemata</a>
								</p>
								<p>
									<a href="#ElementDetails">Details zu den Baukastenelementen</a>
								</p>
								<p>
									<a href="#RegelDetails">Details zu den Regeln</a>
								</p>
								<p>
									<a href="#CodelisteDetails">Details zu den Codelisten</a>
								</p>
								<xsl:if test="$Statistik = '1' or $Statistik = '2'">
									<p>
										<a href="#StatistikKennzahlen">Statistikkennzahlen</a>
									</p>
									<xsl:if test="$StatistikVerwendung = '1'">
										<p>
											<a href="#StatistikVerwendung">Verwendung der Elemente</a>
										</p>
									</xsl:if>
									<xsl:if test="$StatistikStrukturart = '1'">
										<p>
											<a href="#StatistikAbstrakte">Abstrakte Elemente</a>
										</p>
										<p>
											<a href="#StatistikHarmonisierte">Harmonisierte Elemente</a>
										</p>
										<p>
											<a href="#StatistikRechtsnormgebundene">Rechtsnormgebundene Elemente</a>
										</p>
									</xsl:if>
									<xsl:if test="$StatistikZustandsinfos = '1'">
										<p>
											<a href="#StatistikZustandsinfos">Zustandsinfos der Elemente</a>
										</p>
									</xsl:if>
								</xsl:if>
								<xsl:if test="$Meldungen = '1' and $JavaScript = '1'">
									<p>
										<br/>
									</p>
									<p id="versteckeLink">
										<a href="#" onclick="VersteckeMeldungen(); return false;">Blende Meldungen aus</a>
									</p>
									<p id="zeigeLink">
										<a href="#" onclick="ZeigeMeldungen(); return false;">Zeige Meldungen an</a>
									</p>
								</xsl:if>
							</xsl:when>
							<xsl:when test="name(/*) ='xdf:fim.backup'">
								<p class="NavigationsHeadline">Katalog</p>
								<p>
									<a href="#SteckbriefListe">Übersicht der Dokumentsteckbriefe</a>
								</p>
								<p>
									<a href="#SteckbriefDetails">Details zu den Dokumentsteckbriefen</a>
								</p>
								<p class="NavigationsHeadline">Bibliothek</p>
								<p>
									<a href="#StammListe">Übersicht der Datenschemata</a>
								</p>
								<p>
									<a href="#StammDetails">Details zu den Datenschemata</a>
								</p>
								<p class="NavigationsHeadline">Baukasten</p>
								<p>
									<a href="#ElementListe">Übersicht der Elemente</a>
								</p>
								<p>
									<a href="#ElementDetails">Details zu den Baukastenelementen</a>
								</p>
								<p>
									<a href="#RegelDetails">Details zu den Regeln</a>
								</p>
								<p>
									<a href="#CodelisteDetails">Details zu den Codelisten</a>
								</p>
								<xsl:if test="$Statistik = '1'">
									<p class="NavigationsHeadline">Statistik</p>
									<p>
										<a href="#StatistikKennzahlen">Statistikkennzahlen</a>
									</p>
									<xsl:if test="$StatistikVerwendung = '1'">
										<p>
											<a href="#StatistikVerwendung">Verwendung der Elemente</a>
										</p>
									</xsl:if>
									<xsl:if test="$StatistikStrukturart = '1'">
										<p>
											<a href="#StatistikAbstrakte">Abstrakte Elemente</a>
										</p>
										<p>
											<a href="#StatistikHarmonisierte">Harmonisierte Elemente</a>
										</p>
										<p>
											<a href="#StatistikRechtsnormgebundene">Rechtsnormgebundene Elemente</a>
										</p>
									</xsl:if>
									<xsl:if test="$StatistikZustandsinfos = '1'">
										<p>
											<a href="#StatistikZustandsinfos">Zustandsinfos der Elemente</a>
										</p>
									</xsl:if>
									<xsl:if test="$StatistikFehlendeArbeitskopien = '1'">
										<p>
											<a href="#StatistikFehlendeArbeitskopien">Baukastenelemente ohne Arbeitskopie</a>
										</p>
									</xsl:if>
								</xsl:if>
								<xsl:if test="$Meldungen = '1' and $JavaScript = '1'">
									<p>
										<br/>
									</p>
									<p id="versteckeLink">
										<a href="#" onclick="VersteckeMeldungen(); return false;">Blende Meldungen aus</a>
									</p>
									<p id="zeigeLink">
										<a href="#" onclick="ZeigeMeldungen(); return false;">Zeige Meldungen an</a>
									</p>
								</xsl:if>
							</xsl:when>
							<xsl:otherwise>
								<p>Unbekanntes Dateiformat</p>
							</xsl:otherwise>
						</xsl:choose>
					</div>
				</xsl:if>
				<div id="Inhalt">
					<xsl:choose>
						<xsl:when test="name(/*) ='xdf:xdatenfelder.stammdatenschema.0102'">
							<h1>
								<xsl:choose>
									<xsl:when test="$Meldungen = '1'">
											Qualitätsbericht Datenschema <xsl:value-of select="/*/xdf:stammdatenschema/xdf:identifikation/xdf:id"/>
										<xsl:if test="/*/xdf:stammdatenschema/xdf:identifikation/xdf:version">&#160;Version&#160;<xsl:value-of select="/*/xdf:stammdatenschema/xdf:identifikation/xdf:version"/>
										</xsl:if>
									</xsl:when>
									<xsl:otherwise>
											Übersicht Datenschema <xsl:value-of select="/*/xdf:stammdatenschema/xdf:identifikation/xdf:id"/>
										<xsl:if test="/*/xdf:stammdatenschema/xdf:identifikation/xdf:version">&#160;Version&#160;<xsl:value-of select="/*/xdf:stammdatenschema/xdf:identifikation/xdf:version"/>
										</xsl:if>
									</xsl:otherwise>
								</xsl:choose>
							</h1>
							<xsl:if test="$Statistik != '2'">
								<div id="Zusammenfassungsbereich">
									<xsl:if test="$MeldungsFazit = '1' and $Meldungen = '1' and $JavaScript = '1'">
										<h2>
											<a name="Zusammenfassung"/>QS-Zusammenfassung des Datenschemas <xsl:value-of select="/*/xdf:stammdatenschema/xdf:identifikation/xdf:id"/>
											<xsl:if test="/*/xdf:stammdatenschema/xdf:identifikation/xdf:version">&#160;Version&#160;<xsl:value-of select="/*/xdf:stammdatenschema/xdf:identifikation/xdf:version"/>
											</xsl:if>
										</h2>
										<p class="Zusammenfassung" id="AnzahlFehler"/>
										<p id="FehlerListe"/>
										<p class="Zusammenfassung" id="AnzahlWarnungen"/>
										<p id="WarnungsListe"/>
									</xsl:if>
								</div>
								<xsl:call-template name="stammdatenschemaeinzeln"/>
								<xsl:call-template name="listeelementedetailzustammdatenschema"/>
								<xsl:call-template name="listeregeldetailszustammdatenschema"/>
								<xsl:call-template name="listecodelistendetailszustammdatenschema"/>
							</xsl:if>
							<xsl:if test="$Statistik = '1' or $Statistik = '2'">
								<xsl:call-template name="statistikzustammdatenschema"/>
							</xsl:if>

							<p>Erstellt am: <xsl:value-of select="format-date(fn:current-date(),'[D01].[M01].[Y0001]')"/> um <xsl:value-of select="format-time(fn:current-time(),'[H01]:[m01]')"/> Uhr</p>
							<p>XSLT: <xsl:choose><xsl:when test="empty($StyleSheetURI)"><xsl:value-of select="$StyleSheetName"/></xsl:when><xsl:otherwise><xsl:call-template name="fileName"><xsl:with-param name="path" select="$StyleSheetURI"/></xsl:call-template></xsl:otherwise></xsl:choose></p>
							<xsl:if test="not(empty($DocumentURI))">
								<p>XML: <xsl:call-template name="fileName"><xsl:with-param name="path" select="$DocumentURI"/></xsl:call-template></p>
							</xsl:if>

						</xsl:when>
						<xsl:when test="name(/*) ='xdf:fim.backup'">
							<h1>
								<xsl:choose>
									<xsl:when test="$Meldungen = '1'">
											Qualitätsbericht FIM-Baustein Leistungen
										</xsl:when>
									<xsl:otherwise>
											Übersicht FIM-Baustein Leistungen
										</xsl:otherwise>
								</xsl:choose>
							</h1>
							<xsl:if test="$Statistik != '2'">
								<xsl:if test="$TestMode != '1'">
									<h2>Katalog</h2>
									<xsl:call-template name="listedokumentsteckbriefe"/>
									<xsl:call-template name="listedokumentsteckbriefedetails"/>
									<h2>Bibliothek</h2>
									<xsl:call-template name="listestammdatenschema"/>
									<xsl:call-template name="listestammdatenschemadetails"/>
								</xsl:if>
								<h2>Baukasten</h2>
								<xsl:call-template name="listeelementezubaukasten"/>
								<xsl:call-template name="listeelementedetailszubaukasten"/>
								<xsl:call-template name="listeregeldetailszubaukasten"/>
								<xsl:call-template name="listecodelistendetailszubaukasten"/>
							</xsl:if>
							<xsl:if test="$Statistik = '1' or $Statistik = '2'">
								<h2>Statistik</h2>
								<xsl:call-template name="statistikzubaukasten"/>
							</xsl:if>

							<p>Erstellt am: <xsl:value-of select="format-date(fn:current-date(),'[D01].[M01].[Y0001]')"/> um <xsl:value-of select="format-time(fn:current-time(),'[H01]:[m01]')"/> Uhr</p>
							<p>XSLT: <xsl:choose><xsl:when test="empty($StyleSheetURI)"><xsl:value-of select="$StyleSheetName"/></xsl:when><xsl:otherwise><xsl:call-template name="fileName"><xsl:with-param name="path" select="$StyleSheetURI"/></xsl:call-template></xsl:otherwise></xsl:choose></p>
							<xsl:if test="not(empty($DocumentURI))">
								<p>XML: <xsl:call-template name="fileName"><xsl:with-param name="path" select="$DocumentURI"/></xsl:call-template></p>
							</xsl:if>

						</xsl:when>
						<xsl:otherwise>
							<p>Unbekanntes Dateiformat</p>
						</xsl:otherwise>
					</xsl:choose>
				</div>
			</body>
		</html>
	</xsl:template>
	<!-- ############################################################################################################# -->
	<xsl:template name="statistikzustammdatenschema">
		<xsl:if test="$DebugMode = '1' or $DebugMode = '2' or $DebugMode = '3' or $DebugMode = '4'">
			<xsl:message>
				++++ statistik ++++
			</xsl:message>
		</xsl:if>
		<xsl:choose>
			<xsl:when test="$Statistik = '2'">
				<h2>
					<a name="Statistik"/>Statistik zum Datenschema <xsl:value-of select="/*/xdf:stammdatenschema/xdf:identifikation/xdf:id"/>
					<xsl:if test="/*/xdf:stammdatenschema/xdf:identifikation/xdf:version">&#160;Version&#160;<xsl:value-of select="/*/xdf:stammdatenschema/xdf:identifikation/xdf:version"/>
					</xsl:if>
				</h2>
				<xsl:if test="$StatistikVerwendung = '1'">
					<p>
						<a href="#StatistikVerwendung">Verwendung der Elemente</a>
					</p>
				</xsl:if>
				<xsl:if test="$StatistikStrukturart = '1'">
					<p>Liste der Elemente: <a href="#StatistikAbstrakte">Abstrakte</a> - <a href="#StatistikHarmonisierte">Harmonisierte</a> - <a href="#StatistikRechtsnormgebundene">Rechtsnormgebundene</a>
					</p>
				</xsl:if>
				<xsl:if test="$StatistikZustandsinfos = '1'">
					<p>
						<a href="#StatistikZustandsinfos">Liste der Elemente ohne fachlichen Ersteller oder mit Status ungleich aktiv</a>
					</p>
				</xsl:if>
			</xsl:when>
			<xsl:otherwise>
				<h2>
					<a name="Statistik"/>Statistik zum Datenschema <xsl:value-of select="/*/xdf:stammdatenschema/xdf:identifikation/xdf:id"/>
					<xsl:if test="/*/xdf:stammdatenschema/xdf:identifikation/xdf:version">&#160;Version&#160;<xsl:value-of select="/*/xdf:stammdatenschema/xdf:identifikation/xdf:version"/>
					</xsl:if>
				</h2>
			</xsl:otherwise>
		</xsl:choose>
		<xsl:if test="$DebugMode = '2' or $DebugMode = '3' or $DebugMode = '4'">
			<xsl:message>
				++++++++ StatistikKennzahlen ++++++++
			</xsl:message>
		</xsl:if>
		<h3>
			<a name="StatistikKennzahlen"/>Übersicht der Kennzahlen<br/>
		</h3>
		<table style="page-break-after:always">
			<thead>
				<tr>
					<th>Kennzahl</th>
					<th>Wert</th>
				</tr>
			</thead>
			<tbody>
				<xsl:variable name="AnzahlFeldgruppenString">
					<xsl:for-each-group select="//xdf:datenfeldgruppe" group-by="concat(xdf:identifikation/xdf:id,xdf:identifikation/xdf:version)">
						<xsl:if test="fn:position() = 1">
							<xsl:value-of select="fn:last()"/>
						</xsl:if>
					</xsl:for-each-group>
				</xsl:variable>
				<xsl:variable name="AnzahlFeldgruppen">
					<xsl:choose>
						<xsl:when test="empty($AnzahlFeldgruppenString/text())">0</xsl:when>
						<xsl:otherwise>
							<xsl:value-of select="$AnzahlFeldgruppenString"/>
						</xsl:otherwise>
					</xsl:choose>
				</xsl:variable>
				<xsl:variable name="AnzahlFeldgruppenAbstraktString">
					<xsl:for-each-group select="//xdf:datenfeldgruppe[xdf:schemaelementart/code/text() = 'ABS']" group-by="concat(xdf:identifikation/xdf:id,xdf:identifikation/xdf:version)">
						<xsl:if test="fn:position() = 1">
							<xsl:value-of select="fn:last()"/>
						</xsl:if>
					</xsl:for-each-group>
				</xsl:variable>
				<xsl:variable name="AnzahlFeldgruppenAbstrakt">
					<xsl:choose>
						<xsl:when test="empty($AnzahlFeldgruppenAbstraktString/text())">0</xsl:when>
						<xsl:otherwise>
							<xsl:value-of select="$AnzahlFeldgruppenAbstraktString"/>
						</xsl:otherwise>
					</xsl:choose>
				</xsl:variable>
				<xsl:variable name="AnzahlFeldgruppenHarmonisiertString">
					<xsl:for-each-group select="//xdf:datenfeldgruppe[xdf:schemaelementart/code/text() = 'HAR']" group-by="concat(xdf:identifikation/xdf:id,xdf:identifikation/xdf:version)">
						<xsl:if test="fn:position() = 1">
							<xsl:value-of select="fn:last()"/>
						</xsl:if>
					</xsl:for-each-group>
				</xsl:variable>
				<xsl:variable name="AnzahlFeldgruppenHarmonisiert">
					<xsl:choose>
						<xsl:when test="empty($AnzahlFeldgruppenHarmonisiertString/text())">0</xsl:when>
						<xsl:otherwise>
							<xsl:value-of select="$AnzahlFeldgruppenHarmonisiertString"/>
						</xsl:otherwise>
					</xsl:choose>
				</xsl:variable>
				<xsl:variable name="AnzahlFeldgruppenRechtsnormgebundenString">
					<xsl:for-each-group select="//xdf:datenfeldgruppe[xdf:schemaelementart/code/text() = 'RNG']" group-by="concat(xdf:identifikation/xdf:id,xdf:identifikation/xdf:version)">
						<xsl:if test="fn:position() = 1">
							<xsl:value-of select="fn:last()"/>
						</xsl:if>
					</xsl:for-each-group>
				</xsl:variable>
				<xsl:variable name="AnzahlFeldgruppenRechtsnormgebunden">
					<xsl:choose>
						<xsl:when test="empty($AnzahlFeldgruppenRechtsnormgebundenString/text())">0</xsl:when>
						<xsl:otherwise>
							<xsl:value-of select="$AnzahlFeldgruppenRechtsnormgebundenString"/>
						</xsl:otherwise>
					</xsl:choose>
				</xsl:variable>
				<xsl:variable name="AnzahlFelderString">
					<xsl:for-each-group select="//xdf:datenfeld" group-by="concat(xdf:identifikation/xdf:id,xdf:identifikation/xdf:version)">
						<xsl:if test="fn:position() = 1">
							<xsl:value-of select="fn:last()"/>
						</xsl:if>
					</xsl:for-each-group>
				</xsl:variable>
				<xsl:variable name="AnzahlFelder">
					<xsl:choose>
						<xsl:when test="empty($AnzahlFelderString/text())">0</xsl:when>
						<xsl:otherwise>
							<xsl:value-of select="$AnzahlFelderString"/>
						</xsl:otherwise>
					</xsl:choose>
				</xsl:variable>
				<xsl:variable name="AnzahlFelderAbstraktString">
					<xsl:for-each-group select="//xdf:datenfeld[xdf:schemaelementart/code/text() = 'ABS']" group-by="concat(xdf:identifikation/xdf:id,xdf:identifikation/xdf:version)">
						<xsl:if test="fn:position() = 1">
							<xsl:value-of select="fn:last()"/>
						</xsl:if>
					</xsl:for-each-group>
				</xsl:variable>
				<xsl:variable name="AnzahlFelderAbstrakt">
					<xsl:choose>
						<xsl:when test="empty($AnzahlFelderAbstraktString/text())">0</xsl:when>
						<xsl:otherwise>
							<xsl:value-of select="$AnzahlFelderAbstraktString"/>
						</xsl:otherwise>
					</xsl:choose>
				</xsl:variable>
				<xsl:variable name="AnzahlFelderHarmonisiertString">
					<xsl:for-each-group select="//xdf:datenfeld[xdf:schemaelementart/code/text() = 'HAR']" group-by="concat(xdf:identifikation/xdf:id,xdf:identifikation/xdf:version)">
						<xsl:if test="fn:position() = 1">
							<xsl:value-of select="fn:last()"/>
						</xsl:if>
					</xsl:for-each-group>
				</xsl:variable>
				<xsl:variable name="AnzahlFelderHarmonisiert">
					<xsl:choose>
						<xsl:when test="empty($AnzahlFelderHarmonisiertString/text())">0</xsl:when>
						<xsl:otherwise>
							<xsl:value-of select="$AnzahlFelderHarmonisiertString"/>
						</xsl:otherwise>
					</xsl:choose>
				</xsl:variable>
				<xsl:variable name="AnzahlFelderRechtsnormgebundenString">
					<xsl:for-each-group select="//xdf:datenfeld[xdf:schemaelementart/code/text() = 'RNG']" group-by="concat(xdf:identifikation/xdf:id,xdf:identifikation/xdf:version)">
						<xsl:if test="fn:position() = 1">
							<xsl:value-of select="fn:last()"/>
						</xsl:if>
					</xsl:for-each-group>
				</xsl:variable>
				<xsl:variable name="AnzahlFelderRechtsnormgebunden">
					<xsl:choose>
						<xsl:when test="empty($AnzahlFelderRechtsnormgebundenString/text())">0</xsl:when>
						<xsl:otherwise>><xsl:value-of select="$AnzahlFelderRechtsnormgebundenString"/>
						</xsl:otherwise>
					</xsl:choose>
				</xsl:variable>
				<xsl:variable name="AnzahlRegelnString">
					<xsl:for-each-group select="//xdf:regel" group-by="xdf:identifikation/xdf:id">
						<xsl:if test="fn:position() = 1">
							<xsl:value-of select="fn:last()"/>
						</xsl:if>
					</xsl:for-each-group>
				</xsl:variable>
				<xsl:variable name="AnzahlRegeln">
					<xsl:choose>
						<xsl:when test="empty($AnzahlRegelnString/text())">0</xsl:when>
						<xsl:otherwise>><xsl:value-of select="$AnzahlRegelnString"/>
						</xsl:otherwise>
					</xsl:choose>
				</xsl:variable>
				<xsl:variable name="AnzahlCodelistenString">
					<xsl:for-each-group select="//xdf:codelisteReferenz" group-by="concat(xdf:canonicalIdentification,xdf:version)">
						<xsl:sort select="concat(xdf:canonicalIdentification,xdf:version)"/>
						<xsl:if test="fn:position() = 1">
							<xsl:value-of select="fn:last()"/>
						</xsl:if>
					</xsl:for-each-group>
				</xsl:variable>
				<xsl:variable name="AnzahlCodelisten">
					<xsl:choose>
						<xsl:when test="empty($AnzahlCodelistenString/text())">0</xsl:when>
						<xsl:otherwise>><xsl:value-of select="$AnzahlCodelistenString"/>
						</xsl:otherwise>
					</xsl:choose>
				</xsl:variable>
				<tr>
					<td>Anzahl Baukastenelemente</td>
					<td>
						<xsl:value-of select="$AnzahlFeldgruppen + $AnzahlFelder"/>
					</td>
				</tr>
				<tr>
					<td>&#160;&#160;Anzahl Datenfeldgruppen</td>
					<td>
						<xsl:value-of select="$AnzahlFeldgruppen"/>, davon abstrakt: <xsl:value-of select="$AnzahlFeldgruppenAbstrakt"/>, harmonisiert: <xsl:value-of select="$AnzahlFeldgruppenHarmonisiert"/>, rechtsnormgebunden: <xsl:value-of select="$AnzahlFeldgruppenRechtsnormgebunden"/>
					</td>
				</tr>
				<tr>
					<td>&#160;&#160;Anzahl Datenfelder</td>
					<td>
						<xsl:value-of select="$AnzahlFelder"/>, davon abstrakt: <xsl:value-of select="$AnzahlFelderAbstrakt"/>, harmonisiert: <xsl:value-of select="$AnzahlFelderHarmonisiert"/>, rechtsnormgebunden: <xsl:value-of select="$AnzahlFelderRechtsnormgebunden"/>
					</td>
				</tr>
				<tr>
					<td>&#160;&#160;Anteil harmonisierter Baukastenelemente</td>
					<td>
						<xsl:value-of select="format-number((fn:number($AnzahlFelderHarmonisiert) + fn:number($AnzahlFeldgruppenHarmonisiert)) div (fn:number($AnzahlFeldgruppen) + fn:number($AnzahlFelder)),'#.## %')"/>
					</td>
				</tr>
				<tr>
					<td colspan="2">&#160;</td>
				</tr>
				<tr>
					<td>Anzahl Regeln</td>
					<td>
						<xsl:value-of select="$AnzahlRegeln"/>
					</td>
				</tr>
				<tr>
					<td colspan="2">&#160;</td>
				</tr>
				<tr>
					<td>Anzahl Codelisten</td>
					<td>
						<xsl:value-of select="$AnzahlCodelisten"/>
					</td>
				</tr>
				<tr>
					<td colspan="2">&#160;</td>
				</tr>
			</tbody>
		</table>
		<xsl:if test="$StatistikVerwendung = '1'">
			<xsl:if test="$DebugMode = '2' or $DebugMode = '3' or $DebugMode = '4'">
				<xsl:message>
					++++++++ StatistikVerwendung ++++++++
				</xsl:message>
			</xsl:if>
			<xsl:choose>
				<xsl:when test="$Statistik = '2'">
					<h3>
						<a name="StatistikVerwendung"/>Verwendung von Baukastenelementen im FIM-Baustein Datenfelder&#160;<a href="#Statistik" title="nach oben">&#8593;</a>
						<br/>
					</h3>
				</xsl:when>
				<xsl:otherwise>
					<h3>
						<a name="StatistikVerwendung"/>Verwendung von Baukastenelementen im FIM-Baustein Datenfelder<br/>
					</h3>
				</xsl:otherwise>
			</xsl:choose>
			<table style="page-break-after:always">
				<thead>
					<tr>
						<th>Position</th>
						<th>ID</th>
						<th>Version</th>
						<th>Name</th>
						<th>Auftreten im Datenschema</th>
					</tr>
				</thead>
				<tbody>
					<xsl:for-each-group select="//xdf:datenfeld | //xdf:datenfeldgruppe" group-by="concat(xdf:identifikation/xdf:id,xdf:identifikation/xdf:version)">
						<xsl:sort select="count(fn:current-group())" order="descending"/>
						<xsl:sort select="xdf:identifikation/xdf:id"/>
						<xsl:sort select="xdf:identifikation/xdf:version"/>
						<xsl:if test="$DebugMode = '3' or $DebugMode = '4'">
							<xsl:message>
								-------- <xsl:value-of select="./xdf:identifikation/xdf:id"/>
								<xsl:if test="./xdf:identifikation/xdf:version">V<xsl:value-of select="./xdf:identifikation/xdf:version"/>
								</xsl:if> --------
							</xsl:message>
						</xsl:if>
						<tr>
							<td>
								<xsl:value-of select="fn:position()"/>
							</td>
							<td>
								<xsl:choose>
									<xsl:when test="$Statistik = '2'">
										<xsl:value-of select="./xdf:identifikation/xdf:id"/>
										<xsl:if test="$ToolAufruf = '1'">
											&#160;&#160;
											<xsl:element name="a">
												<xsl:attribute name="href"><xsl:value-of select="$ToolPfadPrefix"/><xsl:value-of select="./xdf:identifikation/xdf:id"/><xsl:if test="./xdf:identifikation/xdf:version">V<xsl:value-of select="./xdf:identifikation/xdf:version"/></xsl:if><xsl:value-of select="$ToolPfadPostfix"/></xsl:attribute>
												<xsl:attribute name="target">FIMTool</xsl:attribute>
												<xsl:attribute name="title">Springe in den Datenfeldeditor (man muss vorher angemeldet sein).</xsl:attribute>
												&#8658;
											</xsl:element>&#160;&#160;&#160;&#160;
										</xsl:if>
									</xsl:when>
									<xsl:otherwise>
										<xsl:choose>
											<xsl:when test="$InterneLinks = '1'">
												<xsl:element name="a">
													<xsl:attribute name="href">#<xsl:value-of select="./xdf:identifikation/xdf:id"/><xsl:if test="./xdf:identifikation/xdf:version">V<xsl:value-of select="./xdf:identifikation/xdf:version"/></xsl:if></xsl:attribute>
													<xsl:value-of select="./xdf:identifikation/xdf:id"/>
												</xsl:element>
											</xsl:when>
											<xsl:otherwise>
												<xsl:value-of select="./xdf:identifikation/xdf:id"/>
											</xsl:otherwise>
										</xsl:choose>
									</xsl:otherwise>
								</xsl:choose>
							</td>
							<td>
								<xsl:value-of select="./xdf:identifikation/xdf:version"/>
							</td>
							<td>
								<xsl:value-of select="./xdf:name"/>
							</td>
							<td>
								<xsl:value-of select="count(fn:current-group())"/>
							</td>
						</tr>
					</xsl:for-each-group>
					<tr style="page-break-after:always">
						<td colspan="2" class="Navigation">
							<xsl:call-template name="navigationszeile"/>
						</td>
					</tr>
				</tbody>
			</table>
		</xsl:if>
		<xsl:if test="$StatistikStrukturart = '1'">
			<xsl:if test="$DebugMode = '2' or $DebugMode = '3' or $DebugMode = '4'">
				<xsl:message>
					++++++++ StatistikStrukturart ++++++++
				</xsl:message>
			</xsl:if>
			<h3>
				<a name="StatistikStrukturart"/>Baukastenelemente nach Strukturart<br/>
			</h3>
			<xsl:choose>
				<xsl:when test="$Statistik = '2'">
					<h4>
						<br/>
						<a name="StatistikAbstrakte"/>Abstrakte Baukastenelemente&#160;<a href="#Statistik" title="nach oben">&#8593;</a>
						<br/>
					</h4>
				</xsl:when>
				<xsl:otherwise>
					<h4>
						<br/>
						<a name="StatistikAbstrakte"/>Abstrakte Baukastenelemente<br/>
					</h4>
				</xsl:otherwise>
			</xsl:choose>
			<table style="page-break-after:always">
				<thead>
					<tr>
						<th>ID</th>
						<th>Version</th>
						<th>Name</th>
						<th>Handlungsgrundlagen</th>
					</tr>
				</thead>
				<tbody>
					<xsl:for-each-group select="//xdf:datenfeldgruppe[xdf:schemaelementart/code='ABS'] | //xdf:datenfeld[xdf:schemaelementart/code='ABS']" group-by="xdf:identifikation/xdf:id">
						<xsl:sort select="./xdf:name"/>
						<xsl:sort select="./xdf:identifikation/xdf:id"/>
						<xsl:for-each-group select="fn:current-group()" group-by="string(xdf:identifikation/xdf:version)">
							<xsl:sort select="./xdf:identifikation/xdf:version"/>
							<xsl:if test="$DebugMode = '3' or $DebugMode = '4'">
								<xsl:message>
									-------- <xsl:value-of select="./xdf:identifikation/xdf:id"/>
									<xsl:if test="./xdf:identifikation/xdf:version">V<xsl:value-of select="./xdf:identifikation/xdf:version"/>
									</xsl:if> --------
								</xsl:message>
							</xsl:if>
							<tr>
								<td>
									<xsl:choose>
										<xsl:when test="$Statistik = '2' or empty(./xdf:identifikation/xdf:id)">
											<xsl:value-of select="./xdf:identifikation/xdf:id"/>
											<xsl:if test="$ToolAufruf = '1'">&#160;&#160;<xsl:element name="a">
													<xsl:attribute name="href"><xsl:value-of select="$ToolPfadPrefix"/><xsl:value-of select="./xdf:identifikation/xdf:id"/><xsl:if test="./xdf:identifikation/xdf:version">V<xsl:value-of select="./xdf:identifikation/xdf:version"/></xsl:if><xsl:value-of select="$ToolPfadPostfix"/></xsl:attribute>
													<xsl:attribute name="target">FIMTool</xsl:attribute>
													<xsl:attribute name="title">Springe in den Datenfeldeditor (man muss vorher angemeldet sein).</xsl:attribute>&#8658;</xsl:element>&#160;&#160;&#160;&#160;</xsl:if>
										</xsl:when>
										<xsl:otherwise>
											<xsl:choose>
												<xsl:when test="$InterneLinks = '1'">
													<xsl:element name="a">
														<xsl:attribute name="href">#<xsl:value-of select="./xdf:identifikation/xdf:id"/><xsl:if test="./xdf:identifikation/xdf:version">V<xsl:value-of select="./xdf:identifikation/xdf:version"/></xsl:if></xsl:attribute>
														<xsl:value-of select="./xdf:identifikation/xdf:id"/>
													</xsl:element>
												</xsl:when>
												<xsl:otherwise>
													<xsl:value-of select="./xdf:identifikation/xdf:id"/>
												</xsl:otherwise>
											</xsl:choose>
										</xsl:otherwise>
									</xsl:choose>
								</td>
								<td>
									<xsl:value-of select="./xdf:identifikation/xdf:version"/>
								</td>
								<td>
									<xsl:value-of select="./xdf:name"/>
								</td>
								<td>
									<xsl:value-of select="./xdf:bezug"/>
								</td>
							</tr>
						</xsl:for-each-group>
					</xsl:for-each-group>
				</tbody>
			</table>
			<xsl:choose>
				<xsl:when test="$Statistik = '2'">
					<h4>
						<br/>
						<a name="StatistikHarmonisierte"/>Harmonisierte Baukastenelemente&#160;<a href="#Statistik" title="nach oben">&#8593;</a>
						<br/>
					</h4>
				</xsl:when>
				<xsl:otherwise>
					<h4>
						<br/>
						<a name="StatistikHarmonisierte"/>Harmonisierte Baukastenelemente<br/>
					</h4>
				</xsl:otherwise>
			</xsl:choose>
			<table style="page-break-after:always">
				<thead>
					<tr>
						<th>ID</th>
						<th>Version</th>
						<th>Name</th>
						<th>Handlungsgrundlagen</th>
					</tr>
				</thead>
				<tbody>
					<xsl:for-each-group select="//xdf:datenfeldgruppe[xdf:schemaelementart/code='HAR'] | //xdf:datenfeld[xdf:schemaelementart/code='HAR']" group-by="xdf:identifikation/xdf:id">
						<xsl:sort select="./xdf:name"/>
						<xsl:sort select="./xdf:identifikation/xdf:id"/>
						<xsl:for-each-group select="fn:current-group()" group-by="string(xdf:identifikation/xdf:version)">
							<xsl:sort select="./xdf:identifikation/xdf:version"/>
							<xsl:if test="$DebugMode = '3' or $DebugMode = '4'">
								<xsl:message>
									-------- <xsl:value-of select="./xdf:identifikation/xdf:id"/>
									<xsl:if test="./xdf:identifikation/xdf:version">V<xsl:value-of select="./xdf:identifikation/xdf:version"/>
									</xsl:if> --------
								</xsl:message>
							</xsl:if>
							<tr>
								<td>
									<xsl:choose>
										<xsl:when test="$Statistik = '2' or empty(./xdf:identifikation/xdf:id)">
											<xsl:value-of select="./xdf:identifikation/xdf:id"/>
											<xsl:if test="$ToolAufruf = '1'">&#160;&#160;<xsl:element name="a">
													<xsl:attribute name="href"><xsl:value-of select="$ToolPfadPrefix"/><xsl:value-of select="./xdf:identifikation/xdf:id"/><xsl:if test="./xdf:identifikation/xdf:version">V<xsl:value-of select="./xdf:identifikation/xdf:version"/></xsl:if><xsl:value-of select="$ToolPfadPostfix"/></xsl:attribute>
													<xsl:attribute name="target">FIMTool</xsl:attribute>
													<xsl:attribute name="title">Springe in den Datenfeldeditor (man muss vorher angemeldet sein).</xsl:attribute>&#8658;</xsl:element>&#160;&#160;&#160;&#160;</xsl:if>
										</xsl:when>
										<xsl:otherwise>
											<xsl:choose>
												<xsl:when test="$InterneLinks = '1'">
													<xsl:element name="a">
														<xsl:attribute name="href">#<xsl:value-of select="./xdf:identifikation/xdf:id"/><xsl:if test="./xdf:identifikation/xdf:version">V<xsl:value-of select="./xdf:identifikation/xdf:version"/></xsl:if></xsl:attribute>
														<xsl:value-of select="./xdf:identifikation/xdf:id"/>
													</xsl:element>
												</xsl:when>
												<xsl:otherwise>
													<xsl:value-of select="./xdf:identifikation/xdf:id"/>
												</xsl:otherwise>
											</xsl:choose>
										</xsl:otherwise>
									</xsl:choose>
								</td>
								<td>
									<xsl:value-of select="./xdf:identifikation/xdf:version"/>
								</td>
								<td>
									<xsl:value-of select="./xdf:name"/>
								</td>
								<td>
									<xsl:value-of select="./xdf:bezug"/>
								</td>
							</tr>
						</xsl:for-each-group>
					</xsl:for-each-group>
				</tbody>
			</table>
			<xsl:choose>
				<xsl:when test="$Statistik = '2'">
					<h4>
						<br/>
						<a name="StatistikRechtsnormgebundene"/>Rechtsnormgebundene Baukastenelemente&#160;<a href="#Statistik" title="nach oben">&#8593;</a>
						<br/>
					</h4>
				</xsl:when>
				<xsl:otherwise>
					<h4>
						<br/>
						<a name="StatistikRechtsnormgebundene"/>Rechtsnormgebundene Baukastenelemente<br/>
					</h4>
				</xsl:otherwise>
			</xsl:choose>
			<table style="page-break-after:always">
				<thead>
					<tr>
						<th>ID</th>
						<th>Version</th>
						<th>Name</th>
						<th>Handlungsgrundlagen</th>
					</tr>
				</thead>
				<tbody>
					<xsl:for-each-group select="//xdf:datenfeldgruppe[xdf:schemaelementart/code='RNG'] | //xdf:datenfeld[xdf:schemaelementart/code='RNG']" group-by="xdf:identifikation/xdf:id">
						<xsl:sort select="./xdf:name"/>
						<xsl:sort select="./xdf:identifikation/xdf:id"/>
						<xsl:for-each-group select="fn:current-group()" group-by="string(xdf:identifikation/xdf:version)">
							<xsl:sort select="./xdf:identifikation/xdf:version"/>
							<xsl:if test="$DebugMode = '3' or $DebugMode = '4'">
								<xsl:message>
									-------- <xsl:value-of select="./xdf:identifikation/xdf:id"/>
									<xsl:if test="./xdf:identifikation/xdf:version">V<xsl:value-of select="./xdf:identifikation/xdf:version"/>
									</xsl:if> --------
								</xsl:message>
							</xsl:if>
							<tr>
								<td>
									<xsl:choose>
										<xsl:when test="$Statistik = '2' or empty(./xdf:identifikation/xdf:id)">
											<xsl:value-of select="./xdf:identifikation/xdf:id"/>
											<xsl:if test="$ToolAufruf = '1'">&#160;&#160;<xsl:element name="a">
													<xsl:attribute name="href"><xsl:value-of select="$ToolPfadPrefix"/><xsl:value-of select="./xdf:identifikation/xdf:id"/><xsl:if test="./xdf:identifikation/xdf:version">V<xsl:value-of select="./xdf:identifikation/xdf:version"/></xsl:if><xsl:value-of select="$ToolPfadPostfix"/></xsl:attribute>
													<xsl:attribute name="target">FIMTool</xsl:attribute>
													<xsl:attribute name="title">Springe in den Datenfeldeditor (man muss vorher angemeldet sein).</xsl:attribute>&#8658;</xsl:element>&#160;&#160;&#160;&#160;</xsl:if>
										</xsl:when>
										<xsl:otherwise>
											<xsl:choose>
												<xsl:when test="$InterneLinks = '1'">
													<xsl:element name="a">
														<xsl:attribute name="href">#<xsl:value-of select="./xdf:identifikation/xdf:id"/><xsl:if test="./xdf:identifikation/xdf:version">V<xsl:value-of select="./xdf:identifikation/xdf:version"/></xsl:if></xsl:attribute>
														<xsl:value-of select="./xdf:identifikation/xdf:id"/>
													</xsl:element>
												</xsl:when>
												<xsl:otherwise>
													<xsl:value-of select="./xdf:identifikation/xdf:id"/>
												</xsl:otherwise>
											</xsl:choose>
										</xsl:otherwise>
									</xsl:choose>
								</td>
								<td>
									<xsl:value-of select="./xdf:identifikation/xdf:version"/>
								</td>
								<td>
									<xsl:value-of select="./xdf:name"/>
								</td>
								<td>
									<xsl:value-of select="./xdf:bezug"/>
								</td>
							</tr>
						</xsl:for-each-group>
					</xsl:for-each-group>
				</tbody>
			</table>
		</xsl:if>
		<xsl:if test="$StatistikZustandsinfos = '1'">
			<xsl:if test="$DebugMode = '2' or $DebugMode = '3' or $DebugMode = '4'">
				<xsl:message>
					++++++++ StatistikZustandsinfos ++++++++
				</xsl:message>
			</xsl:if>
			<xsl:choose>
				<xsl:when test="$Statistik = '2'">
					<h3>
						<a name="StatistikZustandsinfos"/>Baukastenelemente ohne Ersteller oder nicht aktiv&#160;<a href="#Statistik" title="nach oben">&#8593;</a>
						<br/>
					</h3>
				</xsl:when>
				<xsl:otherwise>
					<h3>
						<a name="StatistikZustandsinfos"/>Baukastenelemente ohne Ersteller oder nicht aktiv<br/>
					</h3>
				</xsl:otherwise>
			</xsl:choose>
			<table style="page-break-after:always">
				<thead>
					<tr>
						<th>ID</th>
						<th>Version</th>
						<th>Name</th>
					</tr>
				</thead>
				<tbody>
					<xsl:for-each-group select="//xdf:datenfeldgruppe[empty(xdf:fachlicherErsteller) or xdf:status/code!='aktiv'] | //xdf:datenfeld[empty(xdf:fachlicherErsteller) or xdf:status/code!='aktiv']" group-by="xdf:identifikation/xdf:id">
						<xsl:sort select="./xdf:name"/>
						<xsl:sort select="./xdf:identifikation/xdf:id"/>
						<xsl:for-each-group select="fn:current-group()" group-by="string(xdf:identifikation/xdf:version)">
							<xsl:sort select="./xdf:identifikation/xdf:version"/>
							<xsl:if test="$DebugMode = '3' or $DebugMode = '4'">
								<xsl:message>
									-------- <xsl:value-of select="./xdf:identifikation/xdf:id"/>
									<xsl:if test="./xdf:identifikation/xdf:version">V<xsl:value-of select="./xdf:identifikation/xdf:version"/>
									</xsl:if> --------
								</xsl:message>
							</xsl:if>
							<tr>
								<td>
									<xsl:choose>
										<xsl:when test="$Statistik = '2' or empty(./xdf:identifikation/xdf:id)">
											<xsl:value-of select="./xdf:identifikation/xdf:id"/>
											<xsl:if test="$ToolAufruf = '1'">
												&#160;&#160;
												<xsl:element name="a">
													<xsl:attribute name="href"><xsl:value-of select="$ToolPfadPrefix"/><xsl:value-of select="./xdf:identifikation/xdf:id"/><xsl:if test="./xdf:identifikation/xdf:version">V<xsl:value-of select="./xdf:identifikation/xdf:version"/></xsl:if><xsl:value-of select="$ToolPfadPostfix"/></xsl:attribute>
													<xsl:attribute name="target">FIMTool</xsl:attribute>
													<xsl:attribute name="title">Springe in den Datenfeldeditor (man muss vorher angemeldet sein).</xsl:attribute>
													&#8658;
												</xsl:element>&#160;&#160;&#160;&#160;
											</xsl:if>
										</xsl:when>
										<xsl:otherwise>
											<xsl:choose>
												<xsl:when test="$InterneLinks = '1'">
													<xsl:element name="a">
														<xsl:attribute name="href">#<xsl:value-of select="./xdf:identifikation/xdf:id"/><xsl:if test="./xdf:identifikation/xdf:version">V<xsl:value-of select="./xdf:identifikation/xdf:version"/></xsl:if></xsl:attribute>
														<xsl:value-of select="./xdf:identifikation/xdf:id"/>
													</xsl:element>
												</xsl:when>
												<xsl:otherwise>
													<xsl:value-of select="./xdf:identifikation/xdf:id"/>
												</xsl:otherwise>
											</xsl:choose>
										</xsl:otherwise>
									</xsl:choose>
								</td>
								<td>
									<xsl:value-of select="./xdf:identifikation/xdf:version"/>
								</td>
								<td>
									<xsl:value-of select="./xdf:name"/>
								</td>
							</tr>
						</xsl:for-each-group>
					</xsl:for-each-group>
				</tbody>
			</table>
		</xsl:if>
	</xsl:template>
	<!-- ############################################################################################################# -->
	<xsl:template name="statistikzubaukasten">
		<xsl:if test="$DebugMode = '1' or $DebugMode = '2' or $DebugMode = '3' or $DebugMode = '4'">
			<xsl:message>
				++++ statistik ++++ 
			</xsl:message>
		</xsl:if>
		<xsl:choose>
			<xsl:when test="$Statistik = '2'">
				<h2>
					<a name="Statistik"/>Statistik zum Inhalt des FIM-Bausteins Datenfelder</h2>
				<xsl:if test="$StatistikVerwendung = '1'">
					<p>
						<a href="#StatistikVerwendung">Verwendung der Elemente</a>
					</p>
				</xsl:if>
				<xsl:if test="$StatistikStrukturart = '1'">
					<p>Liste der Elemente: <a href="#StatistikAbstrakte">Abstrakte</a> - <a href="#StatistikHarmonisierte">Harmonisierte</a> - <a href="#StatistikRechtsnormgebundene">Rechtsnormgebundene</a>
					</p>
				</xsl:if>
				<xsl:if test="$StatistikZustandsinfos = '1'">
					<p>
						<a href="#StatistikZustandsinfos">Baukastenelemente ohne Ersteller oder nicht aktiv</a>
					</p>
				</xsl:if>
				<xsl:if test="$StatistikFehlendeArbeitskopien = '1'">
					<p>
						<a href="#StatistikFehlendeArbeitskopien">Baukastenelemente ohne Arbeitskopie</a>
					</p>
				</xsl:if>
			</xsl:when>
			<xsl:otherwise>StatistikZustandsinfos
					<h2>
					<a name="Statistik"/>Statistik zum Inhalt des FIM-Bausteins Datenfelder</h2>
			</xsl:otherwise>
		</xsl:choose>
		<xsl:if test="$DebugMode = '2' or $DebugMode = '3' or $DebugMode = '4'">
			<xsl:message>
				++++++++ StatistikKennzahlen ++++++++
			</xsl:message>
		</xsl:if>
		<h3>
			<a name="StatistikKennzahlen"/>Übersicht der Kennzahlen<br/>
		</h3>
		<table style="page-break-after:always">
			<thead>
				<tr>
					<th>Kennzahl</th>
					<th>Wert</th>
				</tr>
			</thead>
			<tbody>
				<xsl:variable name="AnzahlSteckbriefe">
					<xsl:for-each-group select="//xdf:dokumentsteckbrief[not(xdf:identifikation/xdf:version)]" group-by="xdf:identifikation/xdf:id">
						<xsl:if test="fn:position() = 1">
							<xsl:value-of select="fn:last()"/>
						</xsl:if>
					</xsl:for-each-group>
				</xsl:variable>
				<xsl:variable name="AnzahlSteckbriefeMitVersionen">
					<xsl:for-each-group select="//xdf:dokumentsteckbrief" group-by="concat(xdf:identifikation/xdf:id,xdf:identifikation/xdf:version)">
						<xsl:if test="fn:position() = 1">
							<xsl:value-of select="fn:last()"/>
						</xsl:if>
					</xsl:for-each-group>
				</xsl:variable>
				<xsl:variable name="AnzahlSDS">
					<xsl:for-each-group select="//xdf:stammdatenschema[not(xdf:identifikation/xdf:version)]" group-by="xdf:identifikation/xdf:id">
						<xsl:if test="fn:position() = 1">
							<xsl:value-of select="fn:last()"/>
						</xsl:if>
					</xsl:for-each-group>
				</xsl:variable>
				<xsl:variable name="AnzahlSDSMitVersionen">
					<xsl:for-each-group select="//xdf:stammdatenschema" group-by="concat(xdf:identifikation/xdf:id,xdf:identifikation/xdf:version)">
						<xsl:if test="fn:position() = 1">
							<xsl:value-of select="fn:last()"/>
						</xsl:if>
					</xsl:for-each-group>
				</xsl:variable>
				<xsl:variable name="AnzahlFeldgruppen">
					<xsl:for-each-group select="//xdf:datenfeldgruppe[not(xdf:identifikation/xdf:version)]" group-by="xdf:identifikation/xdf:id">
						<xsl:if test="fn:position() = 1">
							<xsl:value-of select="fn:last()"/>
						</xsl:if>
					</xsl:for-each-group>
				</xsl:variable>
				<xsl:variable name="AnzahlFeldgruppenMitVersionen">
					<xsl:for-each-group select="//xdf:datenfeldgruppe" group-by="concat(xdf:identifikation/xdf:id,xdf:identifikation/xdf:version)">
						<xsl:if test="fn:position() = 1">
							<xsl:value-of select="fn:last()"/>
						</xsl:if>
					</xsl:for-each-group>
				</xsl:variable>
				<xsl:variable name="AnzahlFeldgruppenAbstrakt">
					<xsl:for-each-group select="//xdf:datenfeldgruppe[not(xdf:identifikation/xdf:version) and xdf:schemaelementart/code/text() = 'ABS']" group-by="xdf:identifikation/xdf:id">
						<xsl:if test="fn:position() = 1">
							<xsl:value-of select="fn:last()"/>
						</xsl:if>
					</xsl:for-each-group>
				</xsl:variable>
				<xsl:variable name="AnzahlFeldgruppenHarmonisiert">
					<xsl:for-each-group select="//xdf:datenfeldgruppe[not(xdf:identifikation/xdf:version) and xdf:schemaelementart/code/text() = 'HAR']" group-by="xdf:identifikation/xdf:id">
						<xsl:if test="fn:position() = 1">
							<xsl:value-of select="fn:last()"/>
						</xsl:if>
					</xsl:for-each-group>
				</xsl:variable>
				<xsl:variable name="AnzahlFeldgruppenRechtsnormgebunden">
					<xsl:for-each-group select="//xdf:datenfeldgruppe[not(xdf:identifikation/xdf:version) and xdf:schemaelementart/code/text() = 'RNG']" group-by="xdf:identifikation/xdf:id">
						<xsl:if test="fn:position() = 1">
							<xsl:value-of select="fn:last()"/>
						</xsl:if>
					</xsl:for-each-group>
				</xsl:variable>
				<xsl:variable name="AnzahlFelder">
					<xsl:for-each-group select="//xdf:datenfeld[not(xdf:identifikation/xdf:version)]" group-by="xdf:identifikation/xdf:id">
						<xsl:if test="fn:position() = 1">
							<xsl:value-of select="fn:last()"/>
						</xsl:if>
					</xsl:for-each-group>
				</xsl:variable>
				<xsl:variable name="AnzahlFelderMitVersion">
					<xsl:for-each-group select="//xdf:datenfeld" group-by="concat(xdf:identifikation/xdf:id,xdf:identifikation/xdf:version)">
						<xsl:if test="fn:position() = 1">
							<xsl:value-of select="fn:last()"/>
						</xsl:if>
					</xsl:for-each-group>
				</xsl:variable>
				<xsl:variable name="AnzahlFelderAbstrakt">
					<xsl:for-each-group select="//xdf:datenfeld[not(xdf:identifikation/xdf:version) and xdf:schemaelementart/code/text() = 'ABS']" group-by="xdf:identifikation/xdf:id">
						<xsl:if test="fn:position() = 1">
							<xsl:value-of select="fn:last()"/>
						</xsl:if>
					</xsl:for-each-group>
				</xsl:variable>
				<xsl:variable name="AnzahlFelderHarmonisiert">
					<xsl:for-each-group select="//xdf:datenfeld[not(xdf:identifikation/xdf:version) and xdf:schemaelementart/code/text() = 'HAR']" group-by="xdf:identifikation/xdf:id">
						<xsl:if test="fn:position() = 1">
							<xsl:value-of select="fn:last()"/>
						</xsl:if>
					</xsl:for-each-group>
				</xsl:variable>
				<xsl:variable name="AnzahlFelderRechtsnormgebunden">
					<xsl:for-each-group select="//xdf:datenfeld[not(xdf:identifikation/xdf:version) and xdf:schemaelementart/code/text() = 'RNG']" group-by="xdf:identifikation/xdf:id">
						<xsl:if test="fn:position() = 1">
							<xsl:value-of select="fn:last()"/>
						</xsl:if>
					</xsl:for-each-group>
				</xsl:variable>
				<xsl:variable name="AnzahlRegeln">
					<xsl:for-each-group select="//xdf:regel[not(xdf:identifikation/xdf:version)]" group-by="xdf:identifikation/xdf:id">
						<xsl:if test="fn:position() = 1">
							<xsl:value-of select="fn:last()"/>
						</xsl:if>
					</xsl:for-each-group>
				</xsl:variable>
				<xsl:variable name="AnzahlRegelnMitVersion">
					<xsl:for-each-group select="//xdf:regel" group-by="concat(xdf:identifikation/xdf:id,xdf:identifikation/xdf:version)">
						<xsl:if test="fn:position() = 1">
							<xsl:value-of select="fn:last()"/>
						</xsl:if>
					</xsl:for-each-group>
				</xsl:variable>
				<xsl:variable name="AnzahlCodelisten">
					<xsl:for-each-group select="//xdf:codeliste" group-by="xdf:identifikation/xdf:id">
						<xsl:if test="fn:position() = 1">
							<xsl:value-of select="fn:last()"/>
						</xsl:if>
					</xsl:for-each-group>
				</xsl:variable>
				<tr>
					<td class="NavigationsHeadline" colspan="2">Katalog</td>
				</tr>
				<tr>
					<td>&#160;&#160;Anzahl Dokumentensteckbriefe</td>
					<td>
						<xsl:value-of select="$AnzahlSteckbriefe"/>, Versionen mitgezählt: <xsl:value-of select="$AnzahlSteckbriefeMitVersionen"/>
					</td>
				</tr>
				<tr>
					<td class="NavigationsHeadline" colspan="2">Bibliothek</td>
				</tr>
				<tr>
					<td>&#160;&#160;Anzahl Datenschemata</td>
					<td>
						<xsl:value-of select="$AnzahlSDS"/>, Versionen mitgezählt: <xsl:value-of select="$AnzahlSDSMitVersionen"/>
					</td>
				</tr>
				<tr>
					<td class="NavigationsHeadline" colspan="2">Baukasten</td>
				</tr>
				<tr>
					<td>&#160;&#160;Anzahl Baukastenelemente</td>
					<td>
						<xsl:value-of select="$AnzahlFeldgruppen + $AnzahlFelder"/>, Versionen mitgezählt: <xsl:value-of select="$AnzahlFeldgruppenMitVersionen + $AnzahlFelderMitVersion"/>
					</td>
				</tr>
				<tr>
					<td>&#160;&#160;&#160;&#160;Anzahl Datenfeldgruppen</td>
					<td>
						<xsl:value-of select="$AnzahlFeldgruppen"/>, davon abstrakt: <xsl:value-of select="$AnzahlFeldgruppenAbstrakt"/>, harmonisiert: <xsl:value-of select="$AnzahlFeldgruppenHarmonisiert"/>, rechtsnormgebunden: <xsl:value-of select="$AnzahlFeldgruppenRechtsnormgebunden"/>
					</td>
				</tr>
				<tr>
					<td>&#160;&#160;&#160;&#160;Anzahl Datenfelder</td>
					<td>
						<xsl:value-of select="$AnzahlFelder"/>, davon abstrakt: <xsl:value-of select="$AnzahlFelderAbstrakt"/>, harmonisiert: <xsl:value-of select="$AnzahlFelderHarmonisiert"/>, rechtsnormgebunden: <xsl:value-of select="$AnzahlFelderRechtsnormgebunden"/>
					</td>
				</tr>
				<tr>
					<td>&#160;&#160;&#160;&#160;Anteil harmonisierter Baukastenelemente</td>
					<td>
						<xsl:value-of select="format-number(($AnzahlFelderHarmonisiert + $AnzahlFeldgruppenHarmonisiert) div ($AnzahlFeldgruppen + $AnzahlFelder),'#.## %')"/>
					</td>
				</tr>
				<tr>
					<td colspan="2">&#160;</td>
				</tr>
				<tr>
					<td>&#160;&#160;Anzahl Regeln</td>
					<td>
						<xsl:value-of select="$AnzahlRegeln"/>, Versionen mitgezählt: <xsl:value-of select="$AnzahlRegelnMitVersion"/>
					</td>
				</tr>
				<tr>
					<td colspan="2">&#160;</td>
				</tr>
				<tr>
					<td>&#160;&#160;Anzahl Codelisten</td>
					<td>
						<xsl:value-of select="$AnzahlCodelisten"/>
					</td>
				</tr>
				<tr>
					<td colspan="2">&#160;</td>
				</tr>
			</tbody>
		</table>
		<xsl:if test="$StatistikVerwendung = '1'">
			<xsl:if test="$DebugMode = '2' or $DebugMode = '3' or $DebugMode = '4'">
				<xsl:message>
					++++++++ StatistikVerwendung ++++++++
				</xsl:message>
			</xsl:if>
			<xsl:choose>
				<xsl:when test="$Statistik = '2'">
					<h3>
						<a name="StatistikVerwendung"/>Verwendung von Baukastenelementen im FIM-Baustein Datenfelder&#160;<a href="#Statistik" title="nach oben">&#8593;</a>
						<br/>
					</h3>
				</xsl:when>
				<xsl:otherwise>
					<h3>
						<a name="StatistikVerwendung"/>Verwendung von Baukastenelementen im FIM-Baustein Datenfelder<br/>
					</h3>
				</xsl:otherwise>
			</xsl:choose>
			<table style="page-break-after:always">
				<thead>
					<tr>
						<th>Position</th>
						<th>ID</th>
						<th>Version</th>
						<th>Name</th>
						<th>Verwendung im FIM-Baustein Datenfelder</th>
					</tr>
				</thead>
				<tbody>
					<xsl:for-each-group select="//xdf:enthaelt" group-by="xdf:id">
						<xsl:sort select="count(fn:current-group())" order="descending"/>
						<xsl:sort select="./xdf:id"/>
						<xsl:if test="$DebugMode = '3' or $DebugMode = '4'">
							<xsl:message>
								-------- <xsl:value-of select="./xdf:id"/> --------
							</xsl:message>
						</xsl:if>
						<xsl:variable name="ElementID">
							<xsl:choose>
								<xsl:when test="substring-before(string(./xdf:id),'V')=''">
									<xsl:value-of select="string(./xdf:id)"/>
								</xsl:when>
								<xsl:otherwise>
									<xsl:value-of select="substring-before(string(./xdf:id),'V')"/>
								</xsl:otherwise>
							</xsl:choose>
						</xsl:variable>
						<xsl:variable name="ElementVersion">
							<xsl:value-of select="substring-after(string(./xdf:id),'V')"/>
						</xsl:variable>
						<xsl:variable name="Element">
							<xsl:call-template name="getelementbyidandversion">
								<xsl:with-param name="ElementID" select="$ElementID"/>
								<xsl:with-param name="ElementVersion" select="$ElementVersion"/>
							</xsl:call-template>
						</xsl:variable>
						<tr>
							<td>
								<xsl:value-of select="fn:position()"/>
							</td>
							<td>
								<xsl:choose>
									<xsl:when test="$Statistik = '2' or empty($Element/*/xdf:identifikation/xdf:id)">
										<xsl:value-of select="$ElementID"/>
										<xsl:if test="$ToolAufruf = '1'">
											&#160;&#160;
											<xsl:element name="a">
												<xsl:attribute name="href"><xsl:value-of select="$ToolPfadPrefix"/><xsl:value-of select="./xdf:id"/><xsl:value-of select="$ToolPfadPostfix"/></xsl:attribute>
												<xsl:attribute name="target">FIMTool</xsl:attribute>
												<xsl:attribute name="title">Springe in den Datenfeldeditor (man muss vorher angemeldet sein).</xsl:attribute>
												&#8658;
											</xsl:element>&#160;&#160;&#160;&#160;
										</xsl:if>
									</xsl:when>
									<xsl:otherwise>
										<xsl:element name="a">
											<xsl:attribute name="href">#<xsl:value-of select="./xdf:id"/></xsl:attribute>
											<xsl:value-of select="$ElementID"/>
										</xsl:element>
									</xsl:otherwise>
								</xsl:choose>
							</td>
							<td>
								<xsl:value-of select="$ElementVersion"/>
							</td>
							<td>
								<xsl:value-of select="$Element/*/xdf:name"/>
							</td>
							<td>
								<xsl:value-of select="count(fn:current-group())"/>
							</td>
						</tr>
						<xsl:if test="fn:position() = fn:last()">
							<xsl:variable name="ListeUnverwendeterElemente">
								<xdf:ListeUnverwendeterElemente>
									<xsl:for-each-group select="//xdf:datenfeld | //xdf:datenfeldgruppe" group-by="concat(xdf:identifikation/xdf:id,xdf:identifikation/xdf:version)">
										<xsl:sort select="xdf:identifikation/xdf:id"/>
										<xsl:sort select="xdf:identifikation/xdf:version"/>
										<xsl:variable name="ElementNameVersion">
											<xsl:value-of select="xdf:identifikation/xdf:id"/>
											<xsl:if test="xdf:identifikation/xdf:version">V<xsl:value-of select="xdf:identifikation/xdf:version"/>
											</xsl:if>
										</xsl:variable>
										<xsl:variable name="ElementID" select="xdf:identifikation/xdf:id"/>
										<xsl:variable name="ElementVersion">
											<xsl:if test="xdf:identifikation/xdf:version">
												<xsl:value-of select="xdf:identifikation/xdf:version"/>
											</xsl:if>
										</xsl:variable>
										<xsl:if test="not(//xdf:enthaelt[xdf:id = $ElementNameVersion])">
											<xsl:if test="$DebugMode = '3' or $DebugMode = '4'">
												<xsl:message>
													-------- <xsl:value-of select="$ElementNameVersion"/> --------
												</xsl:message>
											</xsl:if>
											<xdf:eintrag>
												<xdf:id>
													<xsl:value-of select="$ElementID"/>
												</xdf:id>
												<xdf:version>
													<xsl:value-of select="$ElementVersion"/>
												</xdf:version>
											</xdf:eintrag>
										</xsl:if>
									</xsl:for-each-group>
								</xdf:ListeUnverwendeterElemente>
							</xsl:variable>
							<xsl:variable name="LetztesVerwendetesElement" select="fn:last()"/>
							<xsl:for-each select="$ListeUnverwendeterElemente/*/xdf:eintrag">
								<xsl:variable name="ElementID" select="./xdf:id"/>
								<xsl:variable name="ElementVersion">
									<xsl:if test="./xdf:version">
										<xsl:value-of select="./xdf:version"/>
									</xsl:if>
								</xsl:variable>
								<xsl:variable name="Element">
									<xsl:call-template name="getelementbyidandversion">
										<xsl:with-param name="ElementID" select="$ElementID"/>
										<xsl:with-param name="ElementVersion" select="$ElementVersion"/>
									</xsl:call-template>
								</xsl:variable>
								<tr>
									<td>
										<xsl:value-of select="$LetztesVerwendetesElement + fn:position()"/>
									</td>
									<td>
										<xsl:choose>
											<xsl:when test="$Statistik = '2'">
												<xsl:value-of select="$Element/*/xdf:identifikation/xdf:id"/>
												<xsl:if test="$ToolAufruf = '1'">
													&#160;&#160;
													<xsl:element name="a">
														<xsl:attribute name="href"><xsl:value-of select="$ToolPfadPrefix"/><xsl:value-of select="$Element/*/xdf:identifikation/xdf:id"/><xsl:if test="$Element/*/xdf:identifikation/xdf:version">V<xsl:value-of select="$Element/*/xdf:identifikation/xdf:version"/></xsl:if><xsl:value-of select="$ToolPfadPostfix"/></xsl:attribute>
														<xsl:attribute name="target">FIMTool</xsl:attribute>
														<xsl:attribute name="title">Springe in den Datenfeldeditor (man muss vorher angemeldet sein).</xsl:attribute>
														&#8658;
													</xsl:element>&#160;&#160;&#160;&#160;
												</xsl:if>
											</xsl:when>
											<xsl:otherwise>
												<xsl:element name="a">
													<xsl:attribute name="href">#<xsl:value-of select="$Element/*/xdf:identifikation/xdf:id"/><xsl:if test="$Element/*/xdf:identifikation/xdf:version">V<xsl:value-of select="$Element/*/xdf:identifikation/xdf:version"/></xsl:if></xsl:attribute>
													<xsl:value-of select="$Element/*/xdf:identifikation/xdf:id"/>
												</xsl:element>
											</xsl:otherwise>
										</xsl:choose>
									</td>
									<td>
										<xsl:value-of select="$Element/*/xdf:identifikation/xdf:version"/>
									</td>
									<td>
										<xsl:value-of select="$Element/*/xdf:name"/>
										<xsl:choose>
											<xsl:when test="$Meldungen = '1'and $Element/*/xdf:identifikation/xdf:version">
												<div class="Warnung W1012">Warnung!! W1012: Versionierte Baukastenelemente, die nicht verwendet werden, sollten gelöscht werden.</div>
											</xsl:when>
											<xsl:when test="$Meldungen = '1'and not($Element/*/xdf:identifikation/xdf:version)">
												<xsl:if test="count($Daten//xdf:datenfeld[xdf:identifikation/xdf:id = $ElementID] | $Daten//xdf:datenfeldgruppe[xdf:identifikation/xdf:id = $ElementID]) = 1">
													<div class="Warnung W1013">Warnung!! W1013: Eine Arbeitsversion, die nicht verwendet wird und keine Versionen hat, sollte gelöscht werden.</div>
												</xsl:if>
											</xsl:when>
											<xsl:otherwise>
											</xsl:otherwise>
										</xsl:choose>
									</td>
									<td>
										0
									</td>
								</tr>
							</xsl:for-each>
						</xsl:if>
					</xsl:for-each-group>
					<tr style="page-break-after:always">
						<td colspan="2" class="Navigation">
							<xsl:call-template name="navigationszeile"/>
						</td>
					</tr>
				</tbody>
			</table>
		</xsl:if>
		<xsl:if test="$StatistikStrukturart = '1'">
			<xsl:if test="$DebugMode = '2' or $DebugMode = '3' or $DebugMode = '4'">
				<xsl:message>
					++++++++ StatistikStrukturart ++++++++
				</xsl:message>
			</xsl:if>
			<h3>
				<a name="StatistikStrukturart"/>Baukastenelemente nach Strukturart<br/>
			</h3>
			<xsl:choose>
				<xsl:when test="$Statistik = '2'">
					<h4>
						<br/>
						<a name="StatistikAbstrakte"/>Abstrakte Baukastenelemente&#160;<a href="#Statistik" title="nach oben">&#8593;</a>
						<br/>
					</h4>
				</xsl:when>
				<xsl:otherwise>
					<h4>
						<br/>
						<a name="StatistikAbstrakte"/>Abstrakte Baukastenelemente<br/>
					</h4>
				</xsl:otherwise>
			</xsl:choose>
			<table style="page-break-after:always">
				<thead>
					<tr>
						<th>ID</th>
						<th>Version</th>
						<th>Name</th>
						<th>Handlungsgrundlagen</th>
					</tr>
				</thead>
				<tbody>
					<xsl:for-each-group select="/*/xdf:datenfeldgruppe[xdf:schemaelementart/code='ABS'] | /*/xdf:datenfeld[xdf:schemaelementart/code='ABS']" group-by="xdf:identifikation/xdf:id">
						<xsl:sort select="./xdf:name"/>
						<xsl:sort select="./xdf:identifikation/xdf:id"/>
						<xsl:for-each-group select="fn:current-group()" group-by="string(xdf:identifikation/xdf:version)">
							<xsl:sort select="./xdf:identifikation/xdf:version"/>
							<xsl:if test="$DebugMode = '3' or $DebugMode = '4'">
								<xsl:message>
									-------- <xsl:value-of select="./xdf:identifikation/xdf:id"/>
									<xsl:if test="./xdf:identifikation/xdf:version">V<xsl:value-of select="./xdf:identifikation/xdf:version"/>
									</xsl:if> --------
								</xsl:message>
							</xsl:if>
							<tr>
								<td>
									<xsl:choose>
										<xsl:when test="$Statistik = '2' or empty(./xdf:identifikation/xdf:id)">
											<xsl:value-of select="./xdf:identifikation/xdf:id"/>
											<xsl:if test="$ToolAufruf = '1'">&#160;&#160;<xsl:element name="a">
													<xsl:attribute name="href"><xsl:value-of select="$ToolPfadPrefix"/><xsl:value-of select="./xdf:identifikation/xdf:id"/><xsl:if test="./xdf:identifikation/xdf:version">V<xsl:value-of select="./xdf:identifikation/xdf:version"/></xsl:if><xsl:value-of select="$ToolPfadPostfix"/></xsl:attribute>
													<xsl:attribute name="target">FIMTool</xsl:attribute>
													<xsl:attribute name="title">Springe in den Datenfeldeditor (man muss vorher angemeldet sein).</xsl:attribute>&#8658;</xsl:element>&#160;&#160;&#160;&#160;</xsl:if>
										</xsl:when>
										<xsl:otherwise>
											<xsl:element name="a">
												<xsl:attribute name="href">#<xsl:value-of select="./xdf:identifikation/xdf:id"/><xsl:if test="./xdf:identifikation/xdf:version">V<xsl:value-of select="./xdf:identifikation/xdf:version"/></xsl:if></xsl:attribute>
												<xsl:value-of select="./xdf:identifikation/xdf:id"/>
											</xsl:element>
										</xsl:otherwise>
									</xsl:choose>
								</td>
								<td>
									<xsl:value-of select="./xdf:identifikation/xdf:version"/>
								</td>
								<td>
									<xsl:value-of select="./xdf:name"/>
								</td>
								<td>
									<xsl:value-of select="./xdf:bezug"/>
								</td>
							</tr>
						</xsl:for-each-group>
					</xsl:for-each-group>
				</tbody>
			</table>
			<xsl:choose>
				<xsl:when test="$Statistik = '2'">
					<h4>
						<br/>
						<a name="StatistikHarmonisierte"/>Harmonisierte Baukastenelemente&#160;<a href="#Statistik" title="nach oben">&#8593;</a>
						<br/>
					</h4>
				</xsl:when>
				<xsl:otherwise>
					<h4>
						<br/>
						<a name="StatistikHarmonisierte"/>Harmonisierte Baukastenelemente<br/>
					</h4>
				</xsl:otherwise>
			</xsl:choose>
			<table style="page-break-after:always">
				<thead>
					<tr>
						<th>ID</th>
						<th>Version</th>
						<th>Name</th>
						<th>Handlungsgrundlagen</th>
					</tr>
				</thead>
				<tbody>
					<xsl:for-each-group select="/*/xdf:datenfeldgruppe[xdf:schemaelementart/code='HAR'] | /*/xdf:datenfeld[xdf:schemaelementart/code='HAR']" group-by="xdf:identifikation/xdf:id">
						<xsl:sort select="./xdf:name"/>
						<xsl:sort select="./xdf:identifikation/xdf:id"/>
						<xsl:for-each-group select="fn:current-group()" group-by="string(xdf:identifikation/xdf:version)">
							<xsl:sort select="./xdf:identifikation/xdf:version"/>
							<xsl:if test="$DebugMode = '3' or $DebugMode = '4'">
								<xsl:message>
									-------- <xsl:value-of select="./xdf:identifikation/xdf:id"/>
									<xsl:if test="./xdf:identifikation/xdf:version">V<xsl:value-of select="./xdf:identifikation/xdf:version"/>
									</xsl:if> --------
								</xsl:message>
							</xsl:if>
							<tr>
								<td>
									<xsl:choose>
										<xsl:when test="$Statistik = '2' or empty(./xdf:identifikation/xdf:id)">
											<xsl:value-of select="./xdf:identifikation/xdf:id"/>
											<xsl:if test="$ToolAufruf = '1'">&#160;&#160;<xsl:element name="a">
													<xsl:attribute name="href"><xsl:value-of select="$ToolPfadPrefix"/><xsl:value-of select="./xdf:identifikation/xdf:id"/><xsl:if test="./xdf:identifikation/xdf:version">V<xsl:value-of select="./xdf:identifikation/xdf:version"/></xsl:if><xsl:value-of select="$ToolPfadPostfix"/></xsl:attribute>
													<xsl:attribute name="target">FIMTool</xsl:attribute>
													<xsl:attribute name="title">Springe in den Datenfeldeditor (man muss vorher angemeldet sein).</xsl:attribute>&#8658;</xsl:element>&#160;&#160;&#160;&#160;</xsl:if>
										</xsl:when>
										<xsl:otherwise>
											<xsl:element name="a">
												<xsl:attribute name="href">#<xsl:value-of select="./xdf:identifikation/xdf:id"/><xsl:if test="./xdf:identifikation/xdf:version">V<xsl:value-of select="./xdf:identifikation/xdf:version"/></xsl:if></xsl:attribute>
												<xsl:value-of select="./xdf:identifikation/xdf:id"/>
											</xsl:element>
										</xsl:otherwise>
									</xsl:choose>
								</td>
								<td>
									<xsl:value-of select="./xdf:identifikation/xdf:version"/>
								</td>
								<td>
									<xsl:value-of select="./xdf:name"/>
								</td>
								<td>
									<xsl:value-of select="./xdf:bezug"/>
								</td>
							</tr>
						</xsl:for-each-group>
					</xsl:for-each-group>
				</tbody>
			</table>
			<xsl:choose>
				<xsl:when test="$Statistik = '2'">
					<h4>
						<br/>
						<a name="StatistikRechtsnormgebundene"/>Rechtsnormgebundene Baukastenelemente&#160;<a href="#Statistik" title="nach oben">&#8593;</a>
						<br/>
					</h4>
				</xsl:when>
				<xsl:otherwise>
					<h4>
						<br/>
						<a name="StatistikRechtsnormgebundene"/>Rechtsnormgebundene Baukastenelemente<br/>
					</h4>
				</xsl:otherwise>
			</xsl:choose>
			<table style="page-break-after:always">
				<thead>
					<tr>
						<th>ID</th>
						<th>Version</th>
						<th>Name</th>
						<th>Handlungsgrundlagen</th>
					</tr>
				</thead>
				<tbody>
					<xsl:for-each-group select="/*/xdf:datenfeldgruppe[xdf:schemaelementart/code='RNG'] | /*/xdf:datenfeld[xdf:schemaelementart/code='RNG']" group-by="xdf:identifikation/xdf:id">
						<xsl:sort select="./xdf:name"/>
						<xsl:sort select="./xdf:identifikation/xdf:id"/>
						<xsl:for-each-group select="fn:current-group()" group-by="string(xdf:identifikation/xdf:version)">
							<xsl:sort select="./xdf:identifikation/xdf:version"/>
							<xsl:if test="$DebugMode = '3' or $DebugMode = '4'">
								<xsl:message>
									-------- <xsl:value-of select="./xdf:identifikation/xdf:id"/>
									<xsl:if test="./xdf:identifikation/xdf:version">V<xsl:value-of select="./xdf:identifikation/xdf:version"/>
									</xsl:if> --------
								</xsl:message>
							</xsl:if>
							<tr>
								<td>
									<xsl:choose>
										<xsl:when test="$Statistik = '2' or empty(./xdf:identifikation/xdf:id)">
											<xsl:value-of select="./xdf:identifikation/xdf:id"/>
											<xsl:if test="$ToolAufruf = '1'">&#160;&#160;<xsl:element name="a">
													<xsl:attribute name="href"><xsl:value-of select="$ToolPfadPrefix"/><xsl:value-of select="./xdf:identifikation/xdf:id"/><xsl:if test="./xdf:identifikation/xdf:version">V<xsl:value-of select="./xdf:identifikation/xdf:version"/></xsl:if><xsl:value-of select="$ToolPfadPostfix"/></xsl:attribute>
													<xsl:attribute name="target">FIMTool</xsl:attribute>
													<xsl:attribute name="title">Springe in den Datenfeldeditor (man muss vorher angemeldet sein).</xsl:attribute>&#8658;</xsl:element>&#160;&#160;&#160;&#160;</xsl:if>
										</xsl:when>
										<xsl:otherwise>
											<xsl:element name="a">
												<xsl:attribute name="href">#<xsl:value-of select="./xdf:identifikation/xdf:id"/><xsl:if test="./xdf:identifikation/xdf:version">V<xsl:value-of select="./xdf:identifikation/xdf:version"/></xsl:if></xsl:attribute>
												<xsl:value-of select="./xdf:identifikation/xdf:id"/>
											</xsl:element>
										</xsl:otherwise>
									</xsl:choose>
								</td>
								<td>
									<xsl:value-of select="./xdf:identifikation/xdf:version"/>
								</td>
								<td>
									<xsl:value-of select="./xdf:name"/>
								</td>
								<td>
									<xsl:value-of select="./xdf:bezug"/>
								</td>
							</tr>
						</xsl:for-each-group>
					</xsl:for-each-group>
				</tbody>
			</table>
		</xsl:if>
		<xsl:if test="$StatistikZustandsinfos = '1'">
			<xsl:if test="$DebugMode = '2' or $DebugMode = '3' or $DebugMode = '4'">
				<xsl:message>
					++++++++ StatistikZustandsinfos ++++++++
				</xsl:message>
			</xsl:if>
			<xsl:choose>
				<xsl:when test="$Statistik = '2'">
					<h3>
						<a name="StatistikZustandsinfos"/>Baukastenelemente ohne Ersteller oder nicht aktiv&#160;<a href="#Statistik" title="nach oben">&#8593;</a>
						<br/>
					</h3>
				</xsl:when>
				<xsl:otherwise>
					<h3>
						<a name="StatistikZustandsinfos"/>Baukastenelemente ohne Ersteller oder nicht aktiv<br/>
					</h3>
				</xsl:otherwise>
			</xsl:choose>
			<table style="page-break-after:always">
				<thead>
					<tr>
						<th>ID</th>
						<th>Version</th>
						<th>Name</th>
					</tr>
				</thead>
				<tbody>
					<xsl:for-each-group select="/*/xdf:datenfeldgruppe[empty(xdf:fachlicherErsteller) or xdf:status/code!='aktiv'] | /*/xdf:datenfeld[empty(xdf:fachlicherErsteller) or xdf:status/code!='aktiv']" group-by="xdf:identifikation/xdf:id">
						<xsl:sort select="./xdf:name"/>
						<xsl:sort select="./xdf:identifikation/xdf:id"/>
						<xsl:for-each-group select="fn:current-group()" group-by="string(xdf:identifikation/xdf:version)">
							<xsl:sort select="./xdf:identifikation/xdf:version"/>
							<xsl:if test="$DebugMode = '3' or $DebugMode = '4'">
								<xsl:message>
									-------- <xsl:value-of select="./xdf:identifikation/xdf:id"/>
									<xsl:if test="./xdf:identifikation/xdf:version">V<xsl:value-of select="./xdf:identifikation/xdf:version"/>
									</xsl:if> --------
								</xsl:message>
							</xsl:if>
							<tr>
								<td>
									<xsl:choose>
										<xsl:when test="$Statistik = '2' or empty(./xdf:identifikation/xdf:id)">
											<xsl:value-of select="./xdf:identifikation/xdf:id"/>
											<xsl:if test="$ToolAufruf = '1'">
												&#160;&#160;
												<xsl:element name="a">
													<xsl:attribute name="href"><xsl:value-of select="$ToolPfadPrefix"/><xsl:value-of select="./xdf:identifikation/xdf:id"/><xsl:if test="./xdf:identifikation/xdf:version">V<xsl:value-of select="./xdf:identifikation/xdf:version"/></xsl:if><xsl:value-of select="$ToolPfadPostfix"/></xsl:attribute>
													<xsl:attribute name="target">FIMTool</xsl:attribute>
													<xsl:attribute name="title">Springe in den Datenfeldeditor (man muss vorher angemeldet sein).</xsl:attribute>
													&#8658;
												</xsl:element>&#160;&#160;&#160;&#160;
											</xsl:if>
										</xsl:when>
										<xsl:otherwise>
											<xsl:element name="a">
												<xsl:attribute name="href">#<xsl:value-of select="./xdf:identifikation/xdf:id"/><xsl:if test="./xdf:identifikation/xdf:version">V<xsl:value-of select="./xdf:identifikation/xdf:version"/></xsl:if></xsl:attribute>
												<xsl:value-of select="./xdf:identifikation/xdf:id"/>
											</xsl:element>
										</xsl:otherwise>
									</xsl:choose>
								</td>
								<td>
									<xsl:value-of select="./xdf:identifikation/xdf:version"/>
								</td>
								<td>
									<xsl:value-of select="./xdf:name"/>
								</td>
							</tr>
						</xsl:for-each-group>
					</xsl:for-each-group>
				</tbody>
			</table>
		</xsl:if>
		<xsl:if test="$StatistikFehlendeArbeitskopien = '1'">
			<xsl:if test="$DebugMode = '2' or $DebugMode = '3' or $DebugMode = '4'">
				<xsl:message>
					++++++++ StatistikFehlendeArbeitskopien ++++++++
				</xsl:message>
			</xsl:if>
			<xsl:choose>
				<xsl:when test="$Statistik = '2'">
					<h3>
						<a name="StatistikFehlendeArbeitskopien"/>Baukastenelemente ohne Arbeitskopie&#160;<a href="#Statistik" title="nach oben">&#8593;</a>
						<br/>
					</h3>
				</xsl:when>
				<xsl:otherwise>
					<h3>
						<a name="StatistikFehlendeArbeitskopien"/>Baukastenelemente ohne Arbeitskopie<br/>
					</h3>
				</xsl:otherwise>
			</xsl:choose>
			<table style="page-break-after:always">
				<thead>
					<tr>
						<th>ID</th>
						<th>Version</th>
					</tr>
				</thead>
				<tbody>
					<xsl:for-each-group select="//xdf:enthaelt" group-by="xdf:id">
						<xsl:sort select="./xdf:id"/>
						<xsl:if test="$DebugMode = '3' or $DebugMode = '4'">
							<xsl:message>
								-------- <xsl:value-of select="./xdf:id"/> --------
							</xsl:message>
						</xsl:if>
						<xsl:variable name="ElementID">
							<xsl:choose>
								<xsl:when test="substring-before(string(./xdf:id),'V')=''">
									<xsl:value-of select="string(./xdf:id)"/>
								</xsl:when>
								<xsl:otherwise>
									<xsl:value-of select="substring-before(string(./xdf:id),'V')"/>
								</xsl:otherwise>
							</xsl:choose>
						</xsl:variable>
						<xsl:variable name="ElementVersion">
							<xsl:value-of select="substring-after(string(./xdf:id),'V')"/>
						</xsl:variable>
						<xsl:variable name="Element">
							<xsl:call-template name="getelementbyidandversion">
								<xsl:with-param name="ElementID" select="$ElementID"/>
								<xsl:with-param name="ElementVersion" select="$ElementVersion"/>
							</xsl:call-template>
						</xsl:variable>
						<xsl:if test="fn:empty($Element/*/xdf:name)">
							<tr>
								<td>
									<xsl:choose>
										<xsl:when test="$Statistik = '2' or empty(./xdf:id)">
											<xsl:value-of select="$ElementID"/>
											<xsl:if test="$ToolAufruf = '1'">
												&#160;&#160;
												<xsl:element name="a">
													<xsl:attribute name="href"><xsl:value-of select="$ToolPfadPrefix"/><xsl:value-of select="./xdf:id"/><xsl:value-of select="$ToolPfadPostfix"/></xsl:attribute>
													<xsl:attribute name="target">FIMTool</xsl:attribute>
													<xsl:attribute name="title">Springe in den Datenfeldeditor (man muss vorher angemeldet sein).</xsl:attribute>
													&#8658;
												</xsl:element>&#160;&#160;&#160;&#160;
											</xsl:if>
										</xsl:when>
										<xsl:otherwise>
											<xsl:element name="a">
												<xsl:attribute name="href">#<xsl:value-of select="./xdf:id"/></xsl:attribute>
												<xsl:value-of select="$ElementID"/>
											</xsl:element>
										</xsl:otherwise>
									</xsl:choose>
								</td>
								<td>
									<xsl:value-of select="$ElementVersion"/>
								</td>
							</tr>
						</xsl:if>
					</xsl:for-each-group>
				</tbody>
			</table>
		</xsl:if>
	</xsl:template>
	<!-- ############################################################################################################# -->
	<xsl:template name="listedokumentsteckbriefe">
		<xsl:if test="$DebugMode = '1' or $DebugMode = '2' or $DebugMode = '3' or $DebugMode = '4'">
			<xsl:message>
				++++ listedokumentsteckbriefe ++++
			</xsl:message>
		</xsl:if>
		<h2>
			<a name="SteckbriefListe"/>Übersicht der Dokumentsteckbriefe</h2>
		<table style="page-break-after:always">
			<thead>
				<tr>
					<th>ID</th>
					<th>Version</th>
					<th>Name</th>
					<th>Bezeichnung</th>
				</tr>
			</thead>
			<tbody>
				<xsl:for-each-group select="/*/xdf:dokumentsteckbrief" group-by="xdf:identifikation/xdf:id">
					<xsl:sort select="./xdf:identifikation/xdf:id"/>
					<xsl:for-each-group select="fn:current-group()" group-by="string(xdf:identifikation/xdf:version)">
						<xsl:sort select="./xdf:identifikation/xdf:version"/>
						<xsl:call-template name="minielementcore">
							<xsl:with-param name="Element" select="."/>
						</xsl:call-template>
					</xsl:for-each-group>
				</xsl:for-each-group>
			</tbody>
		</table>
	</xsl:template>
	<!-- ############################################################################################################# -->
	<xsl:template name="listedokumentsteckbriefedetails">
		<xsl:if test="$DebugMode = '1' or $DebugMode = '2' or $DebugMode = '3' or $DebugMode = '4'">
			<xsl:message>
				++++ listedokumentsteckbriefedetails ++++
			</xsl:message>
		</xsl:if>
		<h2>
			<a name="SteckbriefDetails"/>Details zu den Dokumentsteckbriefen</h2>
		<table style="page-break-after:always">
			<thead>
				<tr>
					<th>Metadatum</th>
					<th>Inhalt</th>
				</tr>
			</thead>
			<tbody>
				<xsl:for-each-group select="/*/xdf:dokumentsteckbrief" group-by="xdf:identifikation/xdf:id">
					<xsl:sort select="./xdf:identifikation/xdf:id"/>
					<xsl:for-each-group select="fn:current-group()" group-by="string(xdf:identifikation/xdf:version)">
						<xsl:sort select="./xdf:identifikation/xdf:version"/>
						<xsl:call-template name="dokumentsteckbriefdetails">
							<xsl:with-param name="Element" select="."/>
						</xsl:call-template>
					</xsl:for-each-group>
				</xsl:for-each-group>
			</tbody>
		</table>
	</xsl:template>
	<!-- ############################################################################################################# -->
	<xsl:template name="listestammdatenschema">
		<xsl:if test="$DebugMode = '1' or $DebugMode = '2' or $DebugMode = '3' or $DebugMode = '4'">
			<xsl:message>
				++++ listestammdatenschema ++++
			</xsl:message>
		</xsl:if>
		<h2>
			<a name="StammListe"/>Übersicht der Datenschemata</h2>
		<table style="page-break-after:always">
			<thead>
				<tr>
					<th>ID</th>
					<th>Version</th>
					<th>Name</th>
					<th>Bezeichnung</th>
				</tr>
			</thead>
			<tbody>
				<xsl:for-each-group select="/*/xdf:stammdatenschema" group-by="xdf:identifikation/xdf:id">
					<xsl:sort select="./xdf:identifikation/xdf:id"/>
					<xsl:for-each-group select="fn:current-group()" group-by="string(xdf:identifikation/xdf:version)">
						<xsl:sort select="./xdf:identifikation/xdf:version"/>
						<xsl:call-template name="minielementcore">
							<xsl:with-param name="Element" select="."/>
						</xsl:call-template>
					</xsl:for-each-group>
				</xsl:for-each-group>
			</tbody>
		</table>
	</xsl:template>
	<!-- ############################################################################################################# -->
	<xsl:template name="listestammdatenschemadetails">
		<xsl:if test="$DebugMode = '1' or $DebugMode = '2' or $DebugMode = '3' or $DebugMode = '4'">
			<xsl:message>
				++++ listestammdatenschemadetails ++++
			</xsl:message>
		</xsl:if>
		<h2>
			<a name="StammDetails"/>Details zu den Datenschemata</h2>
		<table style="page-break-after:always">
			<thead>
				<tr>
					<th>Metadatum</th>
					<th>Inhalt</th>
				</tr>
			</thead>
			<tbody>
				<xsl:for-each-group select="/*/xdf:stammdatenschema" group-by="xdf:identifikation/xdf:id">
					<xsl:sort select="./xdf:identifikation/xdf:id"/>
					<xsl:for-each-group select="fn:current-group()" group-by="string(xdf:identifikation/xdf:version)">
						<xsl:sort select="./xdf:identifikation/xdf:version"/>
						<xsl:call-template name="stammdatenschemadetailszubaukasten">
							<xsl:with-param name="Element" select="."/>
						</xsl:call-template>
					</xsl:for-each-group>
				</xsl:for-each-group>
			</tbody>
		</table>
	</xsl:template>
	<!-- ############################################################################################################# -->
	<xsl:template name="stammdatenschemaeinzeln">
		<xsl:if test="$DebugMode = '1' or $DebugMode = '2' or $DebugMode = '3' or $DebugMode = '4'">
			<xsl:message>
				++++ stammdatenschemaeinzeln ++++
			</xsl:message>
		</xsl:if>
		<h2>
			<a name="StammDetails"/>Details zum Datenschema <xsl:value-of select="/*/xdf:stammdatenschema/xdf:identifikation/xdf:id"/>
			<xsl:if test="/*/xdf:stammdatenschema/xdf:identifikation/xdf:version">&#160;Version&#160;<xsl:value-of select="/*/xdf:stammdatenschema/xdf:identifikation/xdf:version"/>
			</xsl:if>
		</h2>
		<table style="page-break-after:always">
			<thead>
				<tr>
					<th>Metadatum</th>
					<th>Inhalt</th>
				</tr>
			</thead>
			<tbody>
				<xsl:call-template name="stammdatenschemadetailszustammdatenschema">
					<xsl:with-param name="Element" select="/*/xdf:stammdatenschema"/>
				</xsl:call-template>
			</tbody>
		</table>
	</xsl:template>
	<!-- ############################################################################################################# -->
	<xsl:template name="stammdatenschemadetailszubaukasten">
		<xsl:param name="Element"/>
		<xsl:if test="$DebugMode = '2' or $DebugMode = '3' or $DebugMode = '4'">
			<xsl:message>
				++++++++ stammdatenschemadetailszubaukasten ++++++++
			</xsl:message>
		</xsl:if>
		<xsl:if test="$DebugMode = '3' or $DebugMode = '4'">
			<xsl:message>
				-------- <xsl:value-of select="$Element/xdf:identifikation/xdf:id"/>
				<xsl:if test="$Element/xdf:identifikation/xdf:version">V<xsl:value-of select="$Element/xdf:identifikation/xdf:version"/>
				</xsl:if> --------
			</xsl:message>
		</xsl:if>
		<tr>
			<td>
				<xsl:element name="a">
					<xsl:attribute name="name"><xsl:value-of select="$Element/xdf:identifikation/xdf:id"/><xsl:if test="$Element/xdf:identifikation/xdf:version">V<xsl:value-of select="$Element/xdf:identifikation/xdf:version"/></xsl:if></xsl:attribute>
				</xsl:element>
												ID
											</td>
			<td>
				<xsl:value-of select="$Element/xdf:identifikation/xdf:id"/>
				<xsl:if test="$ToolAufruf = '1'">
													&#160;&#160;
													<xsl:element name="a">
						<xsl:attribute name="href"><xsl:value-of select="$ToolPfadPrefix"/><xsl:value-of select="$Element/xdf:identifikation/xdf:id"/><xsl:if test="$Element/xdf:identifikation/xdf:version">V<xsl:value-of select="$Element/xdf:identifikation/xdf:version"/></xsl:if><xsl:value-of select="$ToolPfadPostfix"/></xsl:attribute>
						<xsl:attribute name="target">FIMTool</xsl:attribute>
						<xsl:attribute name="title">Springe in den Datenfeldeditor (man muss vorher angemeldet sein).</xsl:attribute>
														&#8658;
													</xsl:element>
				</xsl:if>
			</td>
		</tr>
		<tr>
			<td>Version</td>
			<td>
				<xsl:value-of select="$Element/xdf:identifikation/xdf:version"/>
			</td>
		</tr>
		<tr>
			<td>Name</td>
			<xsl:choose>
				<xsl:when test="empty($Element/xdf:name/text())">
					<td class="SDSName">
						<xsl:if test="$Meldungen = '1'">
							<div class="Fehler E1002">Fehler!! E1002: Der Name muss befüllt werden.</div>
						</xsl:if>
					</td>
				</xsl:when>
				<xsl:otherwise>
					<td class="ElementName">
						<xsl:value-of select="$Element/xdf:name"/>
					</td>
				</xsl:otherwise>
			</xsl:choose>
		</tr>
		<tr>
			<td>Bezeichnung Eingabe</td>
			<td>
				<xsl:value-of select="$Element/xdf:bezeichnungEingabe"/>
			</td>
		</tr>
		<tr>
			<td>Hilfetext</td>
			<td>
				<xsl:value-of select="fn:replace($Element/xdf:hilfetext,'\n','&lt;br/&gt;')" disable-output-escaping="yes"/>
			</td>
		</tr>
		<tr>
			<td>Bezeichnung Ausgabe</td>
			<td>
				<xsl:value-of select="$Element/xdf:bezeichnungAusgabe"/>
			</td>
		</tr>
		<tr>
			<td>Handlungsgrundlagen
											</td>
			<xsl:choose>
				<xsl:when test="$Element/xdf:schemaelementart/code/text() = 'RNG' and empty($Element/xdf:bezug/text())">
					<td>
						<xsl:if test="$Meldungen = '1'">
							<div class="Fehler E1006">Fehler!! E1006: Der Bezug zur Handlungsgrundlage darf bei Elementen mit der Strukturelementart 'rechtsnormgebunden' nicht leer sein.</div>
						</xsl:if>
					</td>
				</xsl:when>
				<xsl:when test="$Element/xdf:schemaelementart/code/text() = 'HAR' and empty($Element/xdf:bezug/text())">
					<td>
						<xsl:if test="$Meldungen = '1'">
							<div class="Warnung W1001">Warnung!! W1001: Der Bezug zur Handlungsgrundlage sollte bei Elementen mit der Strukturelementart 'harmonisiert' möglichst nicht leer sein.</div>
						</xsl:if>
					</td>
				</xsl:when>
				<xsl:otherwise>
					<td>
						<xsl:value-of select="$Element/xdf:bezug"/>
					</td>
				</xsl:otherwise>
			</xsl:choose>
		</tr>
		<tr>
			<td>Beschreibung</td>
			<td>
				<xsl:value-of select="fn:replace($Element/xdf:beschreibung,'\n','&lt;br/&gt;')" disable-output-escaping="yes"/>
			</td>
		</tr>
		<tr>
			<td>Definition</td>
			<td>
				<xsl:value-of select="fn:replace($Element/xdf:definition,'\n','&lt;br/&gt;')" disable-output-escaping="yes"/>
			</td>
		</tr>
		<tr>
			<td>Änderbarkeit Struktur</td>
			<td>
				<xsl:apply-templates select="$Element/xdf:ableitungsmodifikationenStruktur"/>
			</td>
		</tr>
		<tr>
			<td>Änderbarkeit Repräsentation</td>
			<td>
				<xsl:apply-templates select="$Element/xdf:ableitungsmodifikationenRepraesentation"/>
			</td>
		</tr>
		<tr>
			<td>Status</td>
			<xsl:choose>
				<xsl:when test="$Element/xdf:status/code/text() != 'aktiv' and $VersionsHinweise ='1'">
					<td>
						<xsl:apply-templates select="$Element/xdf:status"/>
						<xsl:if test="$Meldungen = '1'">
							<div class="Hinweis">Hinweis!! Der Status muss zur Versionierung oder Veröffentlichung den Wert 'aktiv' haben.</div>
						</xsl:if>
					</td>
				</xsl:when>
				<xsl:otherwise>
					<td>
						<xsl:apply-templates select="$Element/xdf:status"/>
					</td>
				</xsl:otherwise>
			</xsl:choose>
		</tr>
		<tr>
			<td>Gültig ab</td>
			<td>
				<xsl:value-of select="$Element/xdf:gueltigAb"/>
			</td>
		</tr>
		<tr>
			<td>Gültig bis</td>
			<td>
				<xsl:value-of select="$Element/xdf:gueltigBis"/>
			</td>
		</tr>
		<tr>
			<td>Fachlicher Ersteller</td>
			<xsl:choose>
				<xsl:when test="empty($Element/xdf:fachlicherErsteller/text()) and $VersionsHinweise ='1'">
					<td>
						<xsl:value-of select="$Element/xdf:fachlicherErsteller"/>
						<xsl:if test="$Meldungen = '1'">
							<div class="Hinweis">Hinweis!! Der Fachliche Ersteller darf zur Versionierung oder Veröffentlichung nicht leer sein.</div>
						</xsl:if>
					</td>
				</xsl:when>
				<xsl:otherwise>
					<td>
						<xsl:value-of select="$Element/xdf:fachlicherErsteller"/>
					</td>
				</xsl:otherwise>
			</xsl:choose>
		</tr>
		<tr>
			<td>Freigabedatum</td>
			<td>
				<xsl:value-of select="$Element/xdf:freigabedatum"/>
			</td>
		</tr>
		<tr>
			<td>Veröffentlichungsdatum</td>
			<td>
				<xsl:value-of select="$Element/xdf:veroeffentlichungsdatum"/>
			</td>
		</tr>
		<!--
									<xsl:if test="$PrivateMode = '0'">
										<tr>
											<td>Letzter Bearbeiter</td>
											<td>
												<xsl:value-of select="./LetzterBearbeiter"/>
											</td>
										</tr>
										<tr>
											<td>Zeitpunkt der Erstellung</td>
											<td>
												<xsl:value-of select="./Erstelldatum"/>
											</td>
										</tr>
										<tr>
											<td>Zeitpunkt der letzten Änderung</td>
											<td>
												<xsl:value-of select="./LetztesAenderungsdatum"/>
											</td>
										</tr>
									</xsl:if>
-->
		<!--
										<tr>
											<td>
												<b>Formularsteckbrief</b>
											</td>
											<xsl:choose>
												<xsl:when test="$Formularsteckbrief">
													<td>
														<table>
															<thead>
																<tr>
																	<th>ID</th>
																	<th>Art des Formulars</th>
																</tr>
															</thead>
															<tbody>
																<tr>
																	<td>
																		<xsl:element name="a">
																			<xsl:attribute name="href">#<xsl:value-of select="$Formularsteckbrief//xdf:id"/></xsl:attribute>
																			<xsl:value-of select="./xdf:id"/>
																		</xsl:element>
																	</td>
																	<td>
																		<xsl:value-of select="$Formularsteckbrief//Formularart"/>
																	</td>
																</tr>
															</tbody>
														</table>
													</td>
												</xsl:when>
												<xsl:otherwise>
													<td class="Fehler">Es ist kein Formularsteckbrief zugeordnet!</td>
												</xsl:otherwise>
											</xsl:choose>
										</tr>
-->
		<xsl:if test="count($Element/xdf:struktur) + count($Element/xdf:regel)">
			<tr>
				<td>
					<b>Unterelemente</b>
				</td>
				<td>
					<table>
						<thead>
							<tr>
								<th>ID</th>
								<th>Version</th>
								<th>Name</th>
								<th>Bezeichnung</th>
								<th>Strukturart</th>
								<th>Status</th>
								<th>Multiplizität</th>
								<th>Handlungsgrundlage</th>
							</tr>
						</thead>
						<tbody>
							<xsl:call-template name="unterelementezubaukasten">
								<xsl:with-param name="Element" select="$Element"/>
								<xsl:with-param name="Tiefe" select="1"/>
								<xsl:with-param name="Strukturelementart" select="'SDS'"/>
							</xsl:call-template>
						</tbody>
					</table>
				</td>
			</tr>
		</xsl:if>
		<!--										
										<xsl:if test="count(./Relationen/*)">
											<tr>
												<td>
													<b>Relationen</b>
												</td>
												<td>
													<table>
														<thead>
															<tr>
																<th>ID</th>
																<th>Version</th>
																<th>Name</th>
																<th>Bezeichnung</th>
																<th>Art der Relation</th>
																<th>Beschreibung der Relation</th>
															</tr>
														</thead>
														<tbody>
															<xsl:for-each select="./Relationen/Relation">
																<xsl:variable name="ElementID" select="./xdf:id"/>
																<xsl:variable name="Element2">
																	<xsl:copy-of select="$Daten/*/Stammformulare/Stammformular[Id = $ElementID]"/>
																</xsl:variable>
																<xsl:variable name="Element3">
																	<xsl:copy-of select="$Daten/*/Formularsteckbriefe/Formularsteckbrief[Id = $ElementID]"/>
																</xsl:variable>
																<tr>
																	<td>
																		<xsl:element name="a">
																			<xsl:attribute name="href">#<xsl:value-of select="./xdf:id"/></xsl:attribute>
																			<xsl:value-of select="./xdf:id"/>
																		</xsl:element>
																	</td>
																	<td>
																		<xsl:value-of select="$Element2/*/xdf:version"/>
																	</td>
																	<td>
																		<xsl:value-of select="$Element3/*/xdf:name"/>
																	</td>
																	<td>
																		<xsl:value-of select="$Element3/*/Bezeichnung"/>
																	</td>
																	<td>
																		<xsl:value-of select="./Art"/>
																	</td>
																	<td>
																		<xsl:value-of select="./Beschreibung"/>
																	</td>
																</tr>
															</xsl:for-each>
														</tbody>
													</table>
												</td>
											</tr>
										</xsl:if>
-->
		<tr style="page-break-after:always">
			<td colspan="2" class="Navigation">
				<xsl:call-template name="navigationszeile"/>
			</td>
		</tr>
	</xsl:template>
	<!-- ############################################################################################################# -->
	<xsl:template name="stammdatenschemadetailszustammdatenschema">
		<xsl:param name="Element"/>
		<xsl:if test="$DebugMode = '2' or $DebugMode = '3' or $DebugMode = '4'">
			<xsl:message>
				++++++++ stammdatenschemadetailszustammdatenschema ++++++++
			</xsl:message>
		</xsl:if>
		<xsl:if test="$DebugMode = '3' or $DebugMode = '4'">
			<xsl:message>
				-------- <xsl:value-of select="$Element/xdf:identifikation/xdf:id"/>
				<xsl:if test="$Element/xdf:identifikation/xdf:version">V<xsl:value-of select="$Element/xdf:identifikation/xdf:version"/>
				</xsl:if> --------
			</xsl:message>
		</xsl:if>
		<tr>
			<td>
				<xsl:element name="a">
					<xsl:attribute name="name"><xsl:value-of select="$Element/xdf:identifikation/xdf:id"/><xsl:if test="$Element/xdf:identifikation/xdf:version">V<xsl:value-of select="$Element/xdf:identifikation/xdf:version"/></xsl:if></xsl:attribute>
				</xsl:element>
												ID
											</td>
			<td>
				<xsl:value-of select="$Element/xdf:identifikation/xdf:id"/>
				<xsl:analyze-string regex="^S\d{{8}}$" select="$Element/xdf:identifikation/xdf:id">
					<xsl:matching-substring>
						<xsl:if test="$ToolAufruf = '1'">
															&#160;&#160;
															<xsl:element name="a">
								<xsl:attribute name="href"><xsl:value-of select="$ToolPfadPrefix"/><xsl:value-of select="$Element/xdf:identifikation/xdf:id"/><xsl:if test="$Element/xdf:identifikation/xdf:version">V<xsl:value-of select="$Element/xdf:identifikation/xdf:version"/></xsl:if><xsl:value-of select="$ToolPfadPostfix"/></xsl:attribute>
								<xsl:attribute name="target">FIMTool</xsl:attribute>
								<xsl:attribute name="title">Springe in den Datenfeldeditor (man muss vorher angemeldet sein).</xsl:attribute>
																&#8658;
															</xsl:element>
						</xsl:if>
					</xsl:matching-substring>
					<xsl:non-matching-substring>
						<xsl:if test="$Meldungen = '1'">
							<div class="Fehler E1039">Fehler!! E1039: Die ID entspricht nicht den Formatvorgaben.</div>
						</xsl:if>
					</xsl:non-matching-substring>
				</xsl:analyze-string>
			</td>
		</tr>
		<tr>
			<td>Version</td>
			<td>
				<xsl:value-of select="$Element/xdf:identifikation/xdf:version"/>
			</td>
		</tr>
		<tr>
			<td>Name</td>
			<xsl:choose>
				<xsl:when test="empty($Element/xdf:name/text())">
					<td class="SDSName">
						<xsl:if test="$Meldungen = '1'">
							<div class="Fehler E1002">Fehler!! E1002: Der Name muss befüllt werden.</div>
						</xsl:if>
					</td>
				</xsl:when>
				<xsl:otherwise>
					<td class="ElementName">
						<xsl:value-of select="$Element/xdf:name"/>
					</td>
				</xsl:otherwise>
			</xsl:choose>
		</tr>
		<tr>
			<td>Bezeichnung Eingabe</td>
			<td>
				<xsl:value-of select="$Element/xdf:bezeichnungEingabe"/>
			</td>
		</tr>
		<tr>
			<td>Hilfetext</td>
			<td>
				<xsl:value-of select="fn:replace($Element/xdf:hilfetext,'\n','&lt;br/&gt;')" disable-output-escaping="yes"/>
			</td>
		</tr>
		<tr>
			<td>Bezeichnung Ausgabe</td>
			<td>
				<xsl:value-of select="$Element/xdf:bezeichnungAusgabe"/>
			</td>
		</tr>
		<tr>
			<td>Handlungsgrundlagen</td>
			<xsl:choose>
				<xsl:when test="$Element/xdf:schemaelementart/code/text() = 'RNG' and empty($Element/xdf:bezug/text())">
					<td>
						<xsl:if test="$Meldungen = '1'">
							<div class="Fehler E1006">Fehler!! E1006: Der Bezug zur Handlungsgrundlage darf bei Elementen mit der Strukturelementart 'rechtsnormgebunden' nicht leer sein.</div>
						</xsl:if>
					</td>
				</xsl:when>
				<xsl:when test="$Element/xdf:schemaelementart/code/text() = 'HAR' and empty($Element/xdf:bezug/text())">
					<td>
						<xsl:if test="$Meldungen = '1'">
							<div class="Warnung W1001">Warnung!! W1001: Der Bezug zur Handlungsgrundlage sollte bei Elementen mit der Strukturelementart 'harmonisiert' möglichst nicht leer sein.</div>
						</xsl:if>
					</td>
				</xsl:when>
				<xsl:otherwise>
					<td>
						<xsl:value-of select="$Element/xdf:bezug"/>
					</td>
				</xsl:otherwise>
			</xsl:choose>
		</tr>
		<tr>
			<td>Beschreibung</td>
			<td>
				<xsl:value-of select="fn:replace($Element/xdf:beschreibung,'\n','&lt;br/&gt;')" disable-output-escaping="yes"/>
			</td>
		</tr>
		<tr>
			<td>Definition</td>
			<td>
				<xsl:value-of select="fn:replace($Element/xdf:definition,'\n','&lt;br/&gt;')" disable-output-escaping="yes"/>
			</td>
		</tr>
		<tr>
			<td>Änderbarkeit Struktur</td>
			<td>
				<xsl:apply-templates select="$Element/xdf:ableitungsmodifikationenStruktur"/>
			</td>
		</tr>
		<tr>
			<td>Änderbarkeit Repräsentation</td>
			<td>
				<xsl:apply-templates select="$Element/xdf:ableitungsmodifikationenRepraesentation"/>
			</td>
		</tr>
		<tr>
			<td>Status</td>
			<xsl:choose>
				<xsl:when test="$Element/xdf:status/code/text() != 'aktiv' and $VersionsHinweise ='1'">
					<td>
						<xsl:apply-templates select="$Element/xdf:status"/>
						<xsl:if test="$Meldungen = '1'">
							<div class="Hinweis">Hinweis!! Der Status muss zur Versionierung oder Veröffentlichung den Wert 'aktiv' haben.</div>
						</xsl:if>
					</td>
				</xsl:when>
				<xsl:otherwise>
					<td>
						<xsl:apply-templates select="$Element/xdf:status"/>
					</td>
				</xsl:otherwise>
			</xsl:choose>
		</tr>
		<tr>
			<td>Gültig ab</td>
			<td>
				<xsl:value-of select="$Element/xdf:gueltigAb"/>
			</td>
		</tr>
		<tr>
			<td>Gültig bis</td>
			<td>
				<xsl:value-of select="$Element/xdf:gueltigBis"/>
			</td>
		</tr>
		<tr>
			<td>Fachlicher Ersteller</td>
			<xsl:choose>
				<xsl:when test="empty($Element/xdf:fachlicherErsteller/text()) and $VersionsHinweise ='1'">
					<td>
						<xsl:value-of select="$Element/xdf:fachlicherErsteller"/>
						<xsl:if test="$Meldungen = '1'">
							<div class="Hinweis">Hinweis!! Der Fachliche Ersteller darf zur Versionierung oder Veröffentlichung nicht leer sein.</div>
						</xsl:if>
					</td>
				</xsl:when>
				<xsl:otherwise>
					<td>
						<xsl:value-of select="$Element/xdf:fachlicherErsteller"/>
					</td>
				</xsl:otherwise>
			</xsl:choose>
		</tr>
		<tr>
			<td>Freigabedatum</td>
			<td>
				<xsl:value-of select="$Element/xdf:freigabedatum"/>
			</td>
		</tr>
		<tr>
			<td>Veröffentlichungsdatum</td>
			<td>
				<xsl:value-of select="$Element/xdf:veroeffentlichungsdatum"/>
			</td>
		</tr>
		<!--
									<xsl:if test="$PrivateMode = '0'">
										<tr>
											<td>Letzter Bearbeiter</td>
											<td>
												<xsl:value-of select="./LetzterBearbeiter"/>
											</td>
										</tr>
										<tr>
											<td>Zeitpunkt der Erstellung</td>
											<td>
												<xsl:value-of select="./Erstelldatum"/>
											</td>
										</tr>
										<tr>
											<td>Zeitpunkt der letzten Änderung</td>
											<td>
												<xsl:value-of select="./LetztesAenderungsdatum"/>
											</td>
										</tr>
									</xsl:if>
-->
		<!--
										<tr>
											<td>
												<b>Formularsteckbrief</b>
											</td>
											<xsl:choose>
												<xsl:when test="$Formularsteckbrief">
													<td>
														<table>
															<thead>
																<tr>
																	<th>ID</th>
																	<th>Art des Formulars</th>
																</tr>
															</thead>
															<tbody>
																<tr>
																	<td>
																		<xsl:element name="a">
																			<xsl:attribute name="href">#<xsl:value-of select="$Formularsteckbrief//xdf:id"/></xsl:attribute>
																			<xsl:value-of select="./xdf:id"/>
																		</xsl:element>
																	</td>
																	<td>
																		<xsl:value-of select="$Formularsteckbrief//Formularart"/>
																	</td>
																</tr>
															</tbody>
														</table>
													</td>
												</xsl:when>
												<xsl:otherwise>
													<td class="Fehler">Es ist kein Formularsteckbrief zugeordnet!</td>
												</xsl:otherwise>
											</xsl:choose>
										</tr>
-->
		<xsl:if test="count($Element/xdf:struktur) + count($Element/xdf:regel)">
			<tr>
				<td>
					<b>Unterelemente</b>
				</td>
				<td>
					<table>
						<thead>
							<tr>
								<th>ID</th>
								<th>Version</th>
								<th>Name</th>
								<th>Bezeichnung</th>
								<th>Strukturart</th>
								<th>Status</th>
								<th>Multiplizität</th>
								<th>Handlungsgrundlagen</th>
							</tr>
						</thead>
						<tbody>
							<xsl:call-template name="unterelementezustammdatenschema">
								<xsl:with-param name="Element" select="$Element"/>
								<xsl:with-param name="Tiefe" select="1"/>
								<xsl:with-param name="Strukturelementart" select="'SDS'"/>
							</xsl:call-template>
						</tbody>
					</table>
				</td>
			</tr>
		</xsl:if>
		<!--										
										<xsl:if test="count(./Relationen/*)">
											<tr>
												<td>
													<b>Relationen</b>
												</td>
												<td>
													<table>
														<thead>
															<tr>
																<th>ID</th>
																<th>Version</th>
																<th>Name</th>
																<th>Bezeichnung</th>
																<th>Art der Relation</th>
																<th>Beschreibung der Relation</th>
															</tr>
														</thead>
														<tbody>
															<xsl:for-each select="./Relationen/Relation">
																<xsl:variable name="ElementID" select="./xdf:id"/>
																<xsl:variable name="Element2">
																	<xsl:copy-of select="$Daten/*/Stammformulare/Stammformular[Id = $ElementID]"/>
																</xsl:variable>
																<xsl:variable name="Element3">
																	<xsl:copy-of select="$Daten/*/Formularsteckbriefe/Formularsteckbrief[Id = $ElementID]"/>
																</xsl:variable>
																<tr>
																	<td>
																		<xsl:element name="a">
																			<xsl:attribute name="href">#<xsl:value-of select="./xdf:id"/></xsl:attribute>
																			<xsl:value-of select="./xdf:id"/>
																		</xsl:element>
																	</td>
																	<td>
																		<xsl:value-of select="$Element2/*/xdf:version"/>
																	</td>
																	<td>
																		<xsl:value-of select="$Element3/*/xdf:name"/>
																	</td>
																	<td>
																		<xsl:value-of select="$Element3/*/Bezeichnung"/>
																	</td>
																	<td>
																		<xsl:value-of select="./Art"/>
																	</td>
																	<td>
																		<xsl:value-of select="./Beschreibung"/>
																	</td>
																</tr>
															</xsl:for-each>
														</tbody>
													</table>
												</td>
											</tr>
										</xsl:if>
-->
		<tr style="page-break-after:always">
			<td colspan="2" class="Navigation">
				<xsl:call-template name="navigationszeile"/>
			</td>
		</tr>
	</xsl:template>
	<!-- ############################################################################################################# -->
	<xsl:template name="listeelementezubaukasten">
		<xsl:if test="$DebugMode = '1' or $DebugMode = '2' or $DebugMode = '3' or $DebugMode = '4'">
			<xsl:message>
				++++ listeelementezubaukasten ++++
			</xsl:message>
		</xsl:if>
		<h2>
			<a name="ElementListe"/>Übersicht der Elemente</h2>
		<span id="elementlisteallealpha">
			<table style="page-break-after:always">
				<thead>
					<tr>
						<th>ID&#160;<a href="#" title="Sortiere nach ID" onclick="ZeigeAlleID(); return false;">&#8593;</a>
						</th>
						<th>Version</th>
						<th>Name</th>
						<th>Bezeichnung</th>
					</tr>
				</thead>
				<tbody>
					<xsl:for-each-group select="/*/xdf:datenfeldgruppe | /*/xdf:datenfeld" group-by="xdf:identifikation/xdf:id">
						<xsl:sort select="./xdf:name"/>
						<xsl:sort select="./xdf:identifikation/xdf:id"/>
						<xsl:for-each-group select="fn:current-group()" group-by="string(xdf:identifikation/xdf:version)">
							<xsl:sort select="./xdf:identifikation/xdf:version"/>
							<xsl:call-template name="minielementcore">
								<xsl:with-param name="Element" select="."/>
							</xsl:call-template>
						</xsl:for-each-group>
					</xsl:for-each-group>
				</tbody>
			</table>
		</span>
		<span id="elementlistealleid">
			<table style="page-break-after:always">
				<thead>
					<tr>
						<th>ID</th>
						<th>Version</th>
						<th>Name&#160;<a href="#" title="Sortiere nach Name" onclick="ZeigeAlleAlpha(); return false;">&#8593;</a>
						</th>
						<th>Bezeichnung</th>
					</tr>
				</thead>
				<tbody>
					<xsl:for-each-group select="/*/xdf:datenfeldgruppe | /*/xdf:datenfeld" group-by="xdf:identifikation/xdf:id">
						<xsl:sort select="./xdf:identifikation/xdf:id"/>
						<xsl:for-each-group select="fn:current-group()" group-by="string(xdf:identifikation/xdf:version)">
							<xsl:sort select="./xdf:identifikation/xdf:version"/>
							<xsl:call-template name="minielementcore">
								<xsl:with-param name="Element" select="."/>
							</xsl:call-template>
						</xsl:for-each-group>
					</xsl:for-each-group>
				</tbody>
			</table>
		</span>
	</xsl:template>
	<!-- ############################################################################################################# -->
	<xsl:template name="listeelementedetailszubaukasten">
		<xsl:if test="$DebugMode = '1' or $DebugMode = '2' or $DebugMode = '3' or $DebugMode = '4'">
			<xsl:message>
				++++ listeelementedetailszubaukasten ++++
			</xsl:message>
		</xsl:if>
		<h2>
			<br/>
		</h2>
		<h2>
			<a name="ElementDetails"/>Details zu den Baukastenelementen</h2>
		<table style="page-break-after:always">
			<thead>
				<tr>
					<th>Metadatum</th>
					<th>Inhalt</th>
				</tr>
			</thead>
			<tbody>
				<xsl:for-each-group select="/*/xdf:datenfeldgruppe | /*/xdf:datenfeld" group-by="xdf:identifikation/xdf:id">
					<xsl:sort select="./xdf:identifikation/xdf:id"/>
					<xsl:for-each-group select="fn:current-group()" group-by="string(xdf:identifikation/xdf:version)">
						<xsl:sort select="./xdf:identifikation/xdf:version"/>
						<xsl:call-template name="elementdetailszubaukasten">
							<xsl:with-param name="Element" select="."/>
						</xsl:call-template>
					</xsl:for-each-group>
				</xsl:for-each-group>
			</tbody>
		</table>
	</xsl:template>
	<!-- ############################################################################################################# -->
	<xsl:template name="listeelementedetailzustammdatenschema">
		<xsl:if test="$DebugMode = '1' or $DebugMode = '2' or $DebugMode = '3' or $DebugMode = '4'">
			<xsl:message>
				++++ listeelementedetailzustammdatenschema ++++
			</xsl:message>
		</xsl:if>
		<h2>
			<br/>
		</h2>
		<h2>
			<a name="ElementDetails"/>Details zu den Baukastenelementen des Datenschemas <xsl:value-of select="/*/xdf:stammdatenschema/xdf:identifikation/xdf:id"/>
			<xsl:if test="/*/xdf:stammdatenschema/xdf:identifikation/xdf:version"> Version <xsl:value-of select="/*/xdf:stammdatenschema/xdf:identifikation/xdf:version"/>
			</xsl:if>
		</h2>
		<table style="page-break-after:always">
			<thead>
				<tr>
					<th>Metadatum</th>
					<th>Inhalt</th>
				</tr>
			</thead>
			<tbody>
				<xsl:for-each-group select="//xdf:datenfeldgruppe | //xdf:datenfeld" group-by="xdf:identifikation/xdf:id">
					<xsl:sort select="./xdf:identifikation/xdf:id"/>
					<xsl:for-each-group select="fn:current-group()" group-by="string(xdf:identifikation/xdf:version)">
						<xsl:sort select="./xdf:identifikation/xdf:version"/>
						<xsl:call-template name="elementdetailszustammdatenschema">
							<xsl:with-param name="Element" select="."/>
							<xsl:with-param name="VersionsAnzahl" select="fn:last()"/>
						</xsl:call-template>
					</xsl:for-each-group>
				</xsl:for-each-group>
			</tbody>
		</table>
	</xsl:template>
	<!-- ############################################################################################################# -->
	<xsl:template name="dokumentsteckbriefdetails">
		<xsl:param name="Element"/>
		<xsl:if test="$DebugMode = '2' or $DebugMode = '3' or $DebugMode = '4'">
			<xsl:message>
				++++++++ dokumentsteckbriefdetails ++++++++
			</xsl:message>
		</xsl:if>
		<xsl:if test="$DebugMode = '3' or $DebugMode = '4'">
			<xsl:message>
				-------- <xsl:value-of select="$Element/xdf:identifikation/xdf:id"/>
				<xsl:if test="$Element/xdf:identifikation/xdf:version">V<xsl:value-of select="$Element/xdf:identifikation/xdf:version"/>
				</xsl:if> --------
			</xsl:message>
		</xsl:if>
		<tr>
			<td>
				<xsl:element name="a">
					<xsl:attribute name="name"><xsl:value-of select="$Element/xdf:identifikation/xdf:id"/><xsl:if test="$Element/xdf:identifikation/xdf:version">V<xsl:value-of select="$Element/xdf:identifikation/xdf:version"/></xsl:if></xsl:attribute>
				</xsl:element>
													ID
												</td>
			<td class="SteckbriefID">
				<xsl:value-of select="$Element/xdf:identifikation/xdf:id"/>
				<xsl:if test="$ToolAufruf = '1'">
														&#160;&#160;
														<xsl:element name="a">
						<xsl:attribute name="href"><xsl:value-of select="$ToolPfadPrefix"/><xsl:value-of select="$Element/xdf:identifikation/xdf:id"/><xsl:if test="$Element/xdf:identifikation/xdf:version">V<xsl:value-of select="$Element/xdf:identifikation/xdf:version"/></xsl:if><xsl:value-of select="$ToolPfadPostfix"/></xsl:attribute>
						<xsl:attribute name="target">FIMTool</xsl:attribute>
						<xsl:attribute name="title">Springe in den Datenfeldeditor (man muss vorher angemeldet sein).</xsl:attribute>
															&#8658;
														</xsl:element>
				</xsl:if>
			</td>
		</tr>
		<tr>
			<td>Version</td>
			<td>
				<xsl:value-of select="$Element/xdf:identifikation/xdf:version"/>
			</td>
		</tr>
		<tr>
			<td>Name</td>
			<xsl:choose>
				<xsl:when test="empty($Element/xdf:name/text())">
					<td class="SteckbriefName">
						<xsl:if test="$Meldungen = '1'">
							<div class="Fehler E1002">Fehler!! E1002: Der Name muss befüllt werden.</div>
						</xsl:if>
					</td>
				</xsl:when>
				<xsl:otherwise>
					<td class="SteckbriefName">
						<xsl:value-of select="$Element/xdf:name"/>
					</td>
				</xsl:otherwise>
			</xsl:choose>
		</tr>
		<tr>
			<td>Definition</td>
			<td>
				<xsl:value-of select="fn:replace($Element/xdf:definition,'\n','&lt;br/&gt;')" disable-output-escaping="yes"/>
			</td>
		</tr>
		<tr>
			<td>Handlungsgrundlagen</td>
			<xsl:choose>
				<xsl:when test="empty($Element/xdf:bezug/text())">
					<td>
						<xsl:if test="$Meldungen = '1'">
							<div class="Fehler E1008">Fehler!! E1008: Der Bezug zur Handlungsgrundlage darf nicht leer sein.</div>
						</xsl:if>
					</td>
				</xsl:when>
				<xsl:otherwise>
					<td>
						<xsl:value-of select="$Element/xdf:bezug"/>
					</td>
				</xsl:otherwise>
			</xsl:choose>
		</tr>
		<tr>
			<td>Beschreibung</td>
			<td>
				<xsl:value-of select="fn:replace($Element/xdf:beschreibung,'\n','&lt;br/&gt;')" disable-output-escaping="yes"/>
			</td>
		</tr>
		<tr>
			<td>Bezeichnung</td>
			<xsl:choose>
				<xsl:when test="empty($Element/xdf:bezeichnungEingabe/text())">
					<td>
						<xsl:if test="$Meldungen = '1'">
							<div class="Fehler E1009">Fehler!! E1009: Die Bezeichnung Eingabe muss befüllt werden.</div>
						</xsl:if>
					</td>
				</xsl:when>
				<xsl:otherwise>
					<td>
						<xsl:value-of select="$Element/xdf:bezeichnungEingabe"/>
					</td>
				</xsl:otherwise>
			</xsl:choose>
		</tr>
		<tr>
			<td>Hilfetext</td>
			<xsl:choose>
				<xsl:when test="empty($Element/xdf:hilfetext/text())">
					<td>
						<xsl:if test="$Meldungen = '1'">
							<div class="Warnung W1007">Warnung!! W1007: Der Hilfetext sollte befüllt werden.</div>
						</xsl:if>
					</td>
				</xsl:when>
				<xsl:otherwise>
					<td>
						<xsl:value-of select="fn:replace($Element/xdf:hilfetext,'\n','&lt;br/&gt;')" disable-output-escaping="yes"/>
					</td>
				</xsl:otherwise>
			</xsl:choose>
		</tr>
		<tr>
			<td>Fachlicher Ersteller</td>
			<xsl:choose>
				<xsl:when test="empty($Element/xdf:fachlicherErsteller/text()) and $VersionsHinweise ='1'">
					<td>
						<xsl:value-of select="$Element/xdf:fachlicherErsteller"/>
						<xsl:if test="$Meldungen = '1'">
							<div class="Hinweis">Hinweis!! Der Fachliche Ersteller darf zur Versionierung oder Veröffentlichung nicht leer sein.</div>
						</xsl:if>
					</td>
				</xsl:when>
				<xsl:otherwise>
					<td>
						<xsl:value-of select="$Element/xdf:fachlicherErsteller"/>
					</td>
				</xsl:otherwise>
			</xsl:choose>
		</tr>
		<tr>
			<td>Status</td>
			<xsl:choose>
				<xsl:when test="$Element/xdf:status/code/text() != 'aktiv' and $VersionsHinweise ='1'">
					<td>
						<xsl:apply-templates select="$Element/xdf:status"/>
						<xsl:if test="$Meldungen = '1'">
							<div class="Hinweis">Hinweis!! Der Status muss zur Versionierung oder Veröffentlichung den Wert 'aktiv' haben.</div>
						</xsl:if>
					</td>
				</xsl:when>
				<xsl:otherwise>
					<td>
						<xsl:apply-templates select="$Element/xdf:status"/>
					</td>
				</xsl:otherwise>
			</xsl:choose>
		</tr>
		<tr>
			<td>Gültig ab</td>
			<td>
				<xsl:value-of select="$Element/xdf:gueltigAb"/>
			</td>
		</tr>
		<tr>
			<td>Gültig bis</td>
			<td>
				<xsl:value-of select="$Element/xdf:gueltigBis"/>
			</td>
		</tr>
		<tr>
			<td>Freigabedatum</td>
			<td>
				<xsl:value-of select="$Element/xdf:freigabedatum"/>
			</td>
		</tr>
		<tr>
			<td>Veröffentlichungsdatum</td>
			<td>
				<xsl:value-of select="$Element/xdf:veroeffentlichungsdatum"/>
			</td>
		</tr>
		<!--
										<xsl:if test="$PrivateMode = '0'">
											<tr>
												<td>Letzter Bearbeiter</td>
												<td>
													<xsl:value-of select="./LetzterBearbeiter"/>
												</td>
											</tr>
											<tr>
												<td>Zeitpunkt der Erstellung</td>
												<td>
													<xsl:value-of select="./Erstelldatum"/>
												</td>
											</tr>
											<tr>
												<td>Zeitpunkt der letzten Änderung</td>
												<td>
													<xsl:value-of select="./LetztesAenderungsdatum"/>
												</td>
											</tr>
										</xsl:if>
-->
		<!--
											<xsl:if test="count(Relationen/*)">
												<tr>
													<td>
														<b>Relationen</b>
													</td>
													<td>
														<table>
															<thead>
																<tr>
																	<th>ID</th>
																	<th>Version</th>
																	<th>Name</th>
																	<th>Bezeichnung</th>
																	<th>Art der Relation</th>
																	<th>Beschreibung der Relation</th>
																</tr>
															</thead>
															<tbody>
																<xsl:for-each select="./Relationen/Relation">
																	<xsl:variable name="RelationID" select="./xdf:id"/>
																	<xsl:variable name="Relation">
																		<xsl:copy-of select="$Daten/*/Formularfelder/Formularfeld[Id = $RelationID]"/>
																		<xsl:copy-of select="$Daten/*/Formularfeldgruppen/Formularfeldgruppe[Id = $RelationID]"/>
																	</xsl:variable>
																	<tr>
																		<td>
																			<xsl:element name="a">
																				<xsl:attribute name="href">#<xsl:value-of select="./xdf:id"/></xsl:attribute>
																				<xsl:value-of select="./xdf:id"/>
																			</xsl:element>
																		</td>
																		<td>
																			<xsl:value-of select="$Relation/*/xdf:version"/>
																		</td>
																		<td>
																			<xsl:value-of select="$Relation/*/xdf:name"/>
																		</td>
																		<td>
																			<xsl:value-of select="$Relation/*/Bezeichnung"/>
																		</td>
																		<td>
																			<xsl:value-of select="./Art"/>
																		</td>
																		<td>
																			<xsl:value-of select="./Beschreibung"/>
																		</td>
																	</tr>
																</xsl:for-each>
															</tbody>
														</table>
													</td>
												</tr>
											</xsl:if>
											<tr>
												<td>
													<b>Zugeordnete Datenschema</b>
												</td>

											
												<xsl:variable name="FeldIDmitVersion"><xsl:value-of select="$Element/xdf:identifikation/xdf:id"/><xsl:if test="$Element/xdf:identifikation/xdf:version">V<xsl:value-of select="$Element/xdf:identifikation/xdf:version"/></xsl:if></xsl:variable> 
												
												<xsl:choose>
													<xsl:when test="count(/*/xdf:stammdatenschema[xdf:struktur/xdf:enthaelt/xdf:id = $FeldIDmitVersion]) + count(/*/xdf:datenfeldgruppe[xdf:struktur/xdf:enthaelt/xdf:id = $FeldIDmitVersion])">
														<td>
															<table>
																<thead>
																	<tr>
																		<th>ID</th>
																		<th>Version</th>
																		<th>Name</th>
																		<th>Bezeichnung Eingabe</th>
																	</tr>
																</thead>
																<tbody>
																	<xsl:for-each-group select="/*/xdf:datenfeldgruppe[xdf:struktur/xdf:enthaelt/xdf:id = $FeldIDmitVersion]" group-by="xdf:identifikation/xdf:id">
																		<xsl:sort select="./xdf:identifikation/xdf:id"/>
																		
																		<xsl:for-each-group select="fn:current-group()" group-by="string(xdf:identifikation/xdf:version)">
																			<xsl:sort select="./xdf:identifikation/xdf:version"/>
																		
																			<xsl:call-template name="minielementcore">
																				<xsl:with-param name="Element" select="."/>
																			</xsl:call-template>
																		
																		</xsl:for-each-group>
																	</xsl:for-each-group>

																	<xsl:for-each-group select="/*/xdf:stammdatenschema[xdf:struktur/xdf:enthaelt/xdf:id = $FeldIDmitVersion]" group-by="./xdf:identifikation/xdf:id">
																		<xsl:sort select="./xdf:identifikation/xdf:id"/>
																		
																		<xsl:for-each-group select="fn:current-group()" group-by="string(xdf:identifikation/xdf:version)">
																			<xsl:sort select="./xdf:identifikation/xdf:version"/>
																		
																			<xsl:call-template name="minielementcore">
																				<xsl:with-param name="Element" select="."/>
																			</xsl:call-template>
																		
																		</xsl:for-each-group>
																	</xsl:for-each-group>
																</tbody>
															</table>
														</td>
													</xsl:when>
													<xsl:otherwise>
														<td>
															<xsl:if test="$Meldungen = '1'"><div class="Warnung">Warnung!! Kann technisch noch nicht ausgewertet werden!</div></xsl:if>
														</td>
													</xsl:otherwise>
												</xsl:choose>
											</tr>
-->
		<tr style="page-break-after:always">
			<td colspan="2" class="Navigation">
				<xsl:call-template name="navigationszeile"/>
			</td>
		</tr>
	</xsl:template>
	<!-- ############################################################################################################# -->
	<xsl:template name="elementdetailszubaukasten">
		<xsl:param name="Element"/>
		<xsl:if test="$DebugMode = '2' or $DebugMode = '3' or $DebugMode = '4'">
			<xsl:message>
				++++++++ elementdetailszubaukasten ++++++++
			</xsl:message>
		</xsl:if>
		<xsl:if test="$DebugMode = '3' or $DebugMode = '4'">
			<xsl:message>
				-------- <xsl:value-of select="$Element/xdf:identifikation/xdf:id"/>
				<xsl:if test="$Element/xdf:identifikation/xdf:version">V<xsl:value-of select="$Element/xdf:identifikation/xdf:version"/>
				</xsl:if> --------
			</xsl:message>
		</xsl:if>
		<xsl:choose>
			<xsl:when test="$Element/name() = 'xdf:datenfeld'">
				<tr>
					<td>
						<xsl:element name="a">
							<xsl:attribute name="name"><xsl:value-of select="$Element/xdf:identifikation/xdf:id"/><xsl:if test="$Element/xdf:identifikation/xdf:version">V<xsl:value-of select="$Element/xdf:identifikation/xdf:version"/></xsl:if></xsl:attribute>
						</xsl:element>
													ID
												</td>
					<td class="ElementID">
						<xsl:value-of select="$Element/xdf:identifikation/xdf:id"/>
						<xsl:if test="$ToolAufruf = '1'">
														&#160;&#160;
														<xsl:element name="a">
								<xsl:attribute name="href"><xsl:value-of select="$ToolPfadPrefix"/><xsl:value-of select="$Element/xdf:identifikation/xdf:id"/><xsl:if test="$Element/xdf:identifikation/xdf:version">V<xsl:value-of select="$Element/xdf:identifikation/xdf:version"/></xsl:if><xsl:value-of select="$ToolPfadPostfix"/></xsl:attribute>
								<xsl:attribute name="target">FIMTool</xsl:attribute>
								<xsl:attribute name="title">Springe in den Datenfeldeditor (man muss vorher angemeldet sein).</xsl:attribute>
															&#8658;
														</xsl:element>
						</xsl:if>
					</td>
				</tr>
				<tr>
					<td>Version</td>
					<td>
						<xsl:value-of select="$Element/xdf:identifikation/xdf:version"/>
					</td>
				</tr>
				<tr>
					<td>Name</td>
					<xsl:choose>
						<xsl:when test="empty($Element/xdf:name/text())">
							<td class="ElementName">
								<xsl:if test="$Meldungen = '1'">
									<div class="Fehler E1002">Fehler!! E1002: Der Name muss befüllt werden.</div>
								</xsl:if>
							</td>
						</xsl:when>
						<xsl:otherwise>
							<td class="ElementName">
								<xsl:value-of select="$Element/xdf:name"/>
							</td>
						</xsl:otherwise>
					</xsl:choose>
				</tr>
				<tr>
					<td>Definition</td>
					<td>
						<xsl:value-of select="fn:replace($Element/xdf:definition,'\n','&lt;br/&gt;')" disable-output-escaping="yes"/>
					</td>
				</tr>
				<tr>
					<td>Strukturelementart</td>
					<xsl:choose>
						<xsl:when test="$Element/xdf:schemaelementart/code/text() = 'ABS' and $AbstraktWarnung ='1'">
							<td>
								<xsl:apply-templates select="$Element/xdf:schemaelementart"/>
								<xsl:if test="$Meldungen = '1'">
									<div class="Fehler E1014">Fehler!! E1014: Datenfelder dürfen nicht die Strukturelementart 'abstrakt' haben.</div>
								</xsl:if>
							</td>
						</xsl:when>
						<xsl:otherwise>
							<td>
								<xsl:apply-templates select="$Element/xdf:schemaelementart"/>
							</td>
						</xsl:otherwise>
					</xsl:choose>
				</tr>
				<tr>
					<td>Handlungsgrundlagen</td>
					<xsl:choose>
						<xsl:when test="$Element/xdf:schemaelementart/code/text() = 'RNG' and empty($Element/xdf:bezug/text())">
							<td>
								<xsl:if test="$Meldungen = '1'">
									<div class="Fehler E1006">Fehler!! E1006: Der Bezug zur Handlungsgrundlage darf bei Elementen mit der Strukturelementart 'rechtsnormgebunden' nicht leer sein.</div>
								</xsl:if>
							</td>
						</xsl:when>
						<xsl:when test="$Element/xdf:schemaelementart/code/text() = 'ABS' and empty($Element/xdf:bezug/text())">
							<td>
								<xsl:if test="$Meldungen = '1'">
									<div class="Warnung W1001">Warnung!! W1001: Der Bezug zur Handlungsgrundlage sollte bei Elementen mit der Strukturelementart 'harmonisiert' möglichst nicht leer sein.</div>
								</xsl:if>
							</td>
						</xsl:when>
						<xsl:otherwise>
							<td>
								<xsl:value-of select="$Element/xdf:bezug"/>
							</td>
						</xsl:otherwise>
					</xsl:choose>
				</tr>
				<tr>
					<td>Feldart</td>
					<td>
						<xsl:apply-templates select="$Element/xdf:feldart"/>
					</td>
				</tr>
				<tr>
					<td>Datentyp</td>
					<xsl:choose>
						<xsl:when test="$Element/xdf:feldart/code/text() = 'select'">
							<xsl:choose>
								<xsl:when test="$Element/xdf:datentyp/code/text() = 'text'">
									<td>
										<xsl:apply-templates select="$Element/xdf:datentyp"/>
									</td>
								</xsl:when>
								<xsl:when test="$Element/xdf:datentyp/code/text() = 'int'">
									<td>
										<xsl:apply-templates select="$Element/xdf:datentyp"/>
										<xsl:if test="$Meldungen = '1'">
											<div class="Warnung W1008">Warnung!! W1008: Wenn ein Datenfeld die Feldart 'Auswahl' hat, sollte der Datentyp i. d. R. vom Typ 'Text' sein.</div>
										</xsl:if>
									</td>
								</xsl:when>
								<xsl:otherwise>
									<td>
										<xsl:apply-templates select="$Element/xdf:datentyp"/>
										<xsl:if test="$Meldungen = '1'">
											<div class="Fehler E1011">Fehler!! E1011: Bei Datenfeldern mit der Feldart 'Auswahlfeld' sollte der Datentyp 'Text' sein - in seltenen Fällen 'Ganzzahl'.</div>
										</xsl:if>
									</td>
								</xsl:otherwise>
							</xsl:choose>
						</xsl:when>
						<xsl:otherwise>
							<td>
								<xsl:apply-templates select="$Element/xdf:datentyp"/>
							</td>
						</xsl:otherwise>
					</xsl:choose>
				</tr>
				<tr>
					<td>Feldlänge</td>
					<xsl:choose>
						<xsl:when test="$Element/xdf:praezisierung/text() != ''">
							<xsl:variable name="Praezisierung" select="fn:replace($Element/xdf:praezisierung/text(),'\\&quot;','''')"/>
							<xsl:variable name="minLength">
								<xsl:if test="substring-before(substring-after($Praezisierung,'minLength&quot;:&quot;'),'&quot;') != ''">
									<xsl:value-of select="substring-before(substring-after($Praezisierung,'minLength&quot;:&quot;'),'&quot;')"/>
								</xsl:if>
							</xsl:variable>
							<xsl:variable name="maxLength">
								<xsl:if test="substring-before(substring-after($Praezisierung,'maxLength&quot;:&quot;'),'&quot;') != ''">
									<xsl:value-of select="substring-before(substring-after($Praezisierung,'maxLength&quot;:&quot;'),'&quot;')"/>
								</xsl:if>
							</xsl:variable>
							<xsl:choose>
								<xsl:when test="$Element/xdf:datentyp/code/text() = 'text'">
									<xsl:choose>
										<xsl:when test="$Element/xdf:feldart/code/text() = 'select' or $Element/xdf:feldart/code/text() = 'label'">
											<xsl:choose>
												<xsl:when test="$minLength != '' or $maxLength != ''">
													<td>
														<xsl:if test="$minLength != ''">
															von <xsl:value-of select="$minLength"/>
														</xsl:if>
														<xsl:if test="$maxLength != ''">
															bis <xsl:value-of select="$maxLength"/>
														</xsl:if>
														<xsl:if test="$Meldungen = '1'">
															<div class="Fehler E1012">Fehler!! E1012: Bei Datenfeldern mit der Feldart 'Auswahlfeld' oder 'Statisches, read-only Feld' dürfen weder die minimale noch die maximale Feldlänge angegeben werden.</div>
														</xsl:if>
													</td>
												</xsl:when>
												<xsl:otherwise>
													<td>
													</td>
												</xsl:otherwise>
											</xsl:choose>
										</xsl:when>
										<xsl:otherwise>
											<xsl:choose>
												<xsl:when test="$minLength != '' and $maxLength != ''">
													<td>
														von <xsl:value-of select="$minLength"/> 
														bis <xsl:value-of select="$maxLength"/>
														<xsl:if test="$Meldungen = '1' and not($minLength castable as xs:nonNegativeInteger)">
															<div class="Fehler E1059">Fehler!! E1059: Die minimale Feldlänge muss eine ganze Zahl größer oder gleich Null sein.</div>
														</xsl:if>
														<xsl:if test="$Meldungen = '1' and not($maxLength castable as xs:positiveInteger)">
															<div class="Fehler E1060">Fehler!! E1060: Die maximale Feldlänge muss eine ganze Zahl größer Null sein.</div>
														</xsl:if>
														<xsl:if test="$Meldungen = '1' and ($minLength castable as xs:nonNegativeInteger) and ($maxLength castable as xs:positiveInteger) and ($minLength cast as xs:nonNegativeInteger &gt; $maxLength cast as xs:positiveInteger)">
															<div class="Fehler E1061">Fehler!! E1061: Die minimale Feldlänge darf nicht größer sein als die maximale Feldlänge.</div>
														</xsl:if>
													</td>
												</xsl:when>
												<xsl:otherwise>
													<td>
														<xsl:if test="$minLength != ''">
															von <xsl:value-of select="$minLength"/>
														</xsl:if>
														<xsl:if test="$maxLength != ''">
															bis <xsl:value-of select="$maxLength"/>
														</xsl:if>
														<xsl:if test="$Meldungen = '1' and $minLength != '' and not($minLength castable as xs:nonNegativeInteger)">
															<div class="Fehler E1059">Fehler!! E1059: Die minimale Feldlänge muss eine ganze Zahl größer oder gleich Null sein.</div>
														</xsl:if>
														<xsl:if test="$Meldungen = '1' and $maxLength != '' and not($maxLength castable as xs:positiveInteger)">
															<div class="Fehler E1060">Fehler!! E1060: Die maximale Feldlänge muss eine ganze Zahl größer Null sein.</div>
														</xsl:if>
														<xsl:if test="$Meldungen = '1'">
															<div class="Warnung W1002">Warnung!! W1002: Bei Eingabedatenfeldern mit dem Datentyp 'Text' sollten, wenn möglich, die minimale und maximale Feldlänge angegeben werden.</div>
														</xsl:if>
													</td>
												</xsl:otherwise>
											</xsl:choose>
										</xsl:otherwise>
									</xsl:choose>
								</xsl:when>
								<xsl:when test="$minLength != '' or $maxLength != ''">
									<td>
										<xsl:if test="$minLength != ''">
											von <xsl:value-of select="$minLength"/>
										</xsl:if>
										<xsl:if test="$maxLength != ''">
											bis <xsl:value-of select="$maxLength"/>
										</xsl:if>
										<xsl:if test="$Meldungen = '1'">
											<div class="Fehler E1015">Fehler!! E1015: Eine Feldlänge darf nur bei einem Datenfeld mit dem Datentyp 'Text' angegeben werden.</div>
										</xsl:if>
									</td>
								</xsl:when>
								<xsl:otherwise>
									<td/>
								</xsl:otherwise>
							</xsl:choose>
						</xsl:when>
						<xsl:otherwise>
							<xsl:choose>
								<xsl:when test="$Element/xdf:datentyp/code/text() = 'text' and $Element/xdf:feldart/code/text() = 'input'">
									<td>
										<xsl:if test="$Meldungen = '1'">
											<div class="Warnung W1002">Warnung!! W1002: Bei Eingabedatenfeldern mit dem Datentyp 'Text' sollten, wenn möglich, die minimale und maximale Feldlänge angegeben werden.</div>
										</xsl:if>
									</td>
								</xsl:when>
								<xsl:otherwise>
									<td/>
								</xsl:otherwise>
							</xsl:choose>
						</xsl:otherwise>
					</xsl:choose>
				</tr>
				<tr>
					<td>Wertebereich</td>
					<xsl:choose>
						<xsl:when test="$Element/xdf:praezisierung/text() != ''">
							<xsl:variable name="Praezisierung" select="fn:replace($Element/xdf:praezisierung/text(),'\\&quot;','''')"/>
							<xsl:variable name="minValue">
								<xsl:if test="substring-before(substring-after($Praezisierung,'minValue&quot;:&quot;'),'&quot;') != ''">
									<xsl:value-of select="substring-before(substring-after($Praezisierung,'minValue&quot;:&quot;'),'&quot;')"/>
								</xsl:if>
							</xsl:variable>
							<xsl:variable name="maxValue">
								<xsl:if test="substring-before(substring-after($Praezisierung,'maxValue&quot;:&quot;'),'&quot;') != ''">
									<xsl:value-of select="substring-before(substring-after($Praezisierung,'maxValue&quot;:&quot;'),'&quot;')"/>
								</xsl:if>
							</xsl:variable>
							<xsl:choose>
								<xsl:when test="$Element/xdf:datentyp/code/text() = 'num' or $Element/xdf:datentyp/code/text() = 'num_currency'">
									<td>
										<xsl:if test="$minValue != ''">
											von <xsl:value-of select="$minValue"/>
										</xsl:if>
										<xsl:if test="$maxValue != ''">
											bis <xsl:value-of select="$maxValue"/>
										</xsl:if>
										<xsl:if test="$Meldungen = '1' and $minValue != '' and not($minValue castable as xs:double)">
											<div class="Fehler E1062">Fehler!! E1062: Die untere Wertgrenze muss eine Zahl sein.</div>
										</xsl:if>
										<xsl:if test="$Meldungen = '1' and $maxValue != '' and not($maxValue castable as xs:double)">
											<div class="Fehler E1063">Fehler!! E1063: Die obere Wertgrenze muss eine Zahl sein.</div>
										</xsl:if>
										<xsl:if test="$Meldungen = '1' and $minValue != '' and $maxValue != '' and ($minValue castable as xs:double) and ($maxValue castable as xs:double) and ($minValue cast as xs:double &gt; $maxValue cast as xs:double)">
											<div class="Fehler E1064">Fehler!! E1064: Die untere Wertgrenze darf nicht größer sein als die obere Wertgrenze.</div>
										</xsl:if>
									</td>
								</xsl:when>
								<xsl:when test="$Element/xdf:datentyp/code/text() = 'num_int'">
									<td>
										<xsl:if test="$minValue != ''">
											von <xsl:value-of select="$minValue"/>
										</xsl:if>
										<xsl:if test="$maxValue != ''">
											bis <xsl:value-of select="$maxValue"/>
										</xsl:if>
										<xsl:if test="$Meldungen = '1' and $minValue != '' and not($minValue castable as xs:integer)">
											<div class="Fehler E1065">Fehler!! E1065: Die untere Wertgrenze muss eine ganze Zahl sein.</div>
										</xsl:if>
										<xsl:if test="$Meldungen = '1' and $maxValue != '' and not($maxValue castable as xs:integer)">
											<div class="Fehler E1066">Fehler!! E1066: Die obere Wertgrenze muss eine ganze Zahl sein.</div>
										</xsl:if>
										<xsl:if test="$Meldungen = '1' and $minValue != '' and $maxValue != '' and ($minValue castable as xs:integer) and ($maxValue castable as xs:integer) and ($minValue cast as xs:integer &gt; $maxValue cast as xs:integer)">
											<div class="Fehler E1064">Fehler!! E1064: Die untere Wertgrenze darf nicht größer sein als die obere Wertgrenze.</div>
										</xsl:if>
									</td>
								</xsl:when>
								<xsl:when test="$Element/xdf:datentyp/code/text() = 'date'">
									<td>
										<xsl:if test="$minValue != ''">
											von <xsl:value-of select="$minValue"/>
										</xsl:if>
										<xsl:if test="$maxValue != ''">
											bis <xsl:value-of select="$maxValue"/>
										</xsl:if>
										<xsl:if test="$Meldungen = '1' and $minValue != '' and not($minValue castable as xs:date)">
											<div class="Fehler E1067">Fehler!! E1067: Die untere Wertgrenze muss ein Datum sein.</div>
										</xsl:if>
										<xsl:if test="$Meldungen = '1' and $maxValue != '' and not($maxValue castable as xs:date)">
											<div class="Fehler E1068">Fehler!! E1068: Die obere Wertgrenze muss ein Datum sein.</div>
										</xsl:if>
										<xsl:if test="$Meldungen = '1' and $minValue != '' and $maxValue != '' and ($minValue castable as xs:date) and ($maxValue castable as xs:date) and ($minValue cast as xs:date &gt; $maxValue cast as xs:date)">
											<div class="Fehler E1064">Fehler!! E1064: Die untere Wertgrenze darf nicht größer sein als die obere Wertgrenze.</div>
										</xsl:if>
									</td>
								</xsl:when>
								<xsl:otherwise>
									<xsl:choose>
										<xsl:when test="$minValue != '' or $maxValue != ''">
											<td>
												<xsl:if test="$minValue != ''">
																				von <xsl:value-of select="$minValue"/>
												</xsl:if>
												<xsl:if test="$maxValue != ''">
																				bis <xsl:value-of select="$maxValue"/>
												</xsl:if>
												<xsl:if test="$Meldungen = '1'">
													<div class="Fehler E1016">Fehler!! E1016: Ein Wertebereich darf nur bei einem Datenfeld mit einem nummerischen Datentyp (Nummer, Ganzzahl, Geldbetrag) oder einem Datumsdatentyp angegeben werden.</div>
												</xsl:if>
											</td>
										</xsl:when>
										<xsl:otherwise>
											<td>
											</td>
										</xsl:otherwise>
									</xsl:choose>
								</xsl:otherwise>
							</xsl:choose>
						</xsl:when>
						<xsl:otherwise>
							<xsl:choose>
								<xsl:when test="$Element/xdf:datentyp/code/text() = 'num' or $Element/xdf:datentyp/code/text() = 'num_int' or $Element/xdf:datentyp/code/text() = 'num_currency'">
									<td>
										<xsl:if test="$Meldungen = '1'">
											<div class="Warnung W1003">Warnung!! W1003: Bei Datenfeldern mit dem Datentyp 'Nummer', 'Ganzzahl', 'Geldbetrag' oder 'Datum' sollte, wenn möglich, ein Wertebereich angegeben werden.</div>
										</xsl:if>
									</td>
								</xsl:when>
								<xsl:otherwise>
									<td/>
								</xsl:otherwise>
							</xsl:choose>
						</xsl:otherwise>
					</xsl:choose>
				</tr>
				<tr>
					<td>Pattern</td>
					<td>
						<xsl:if test="$Element/xdf:praezisierung/text() != ''">
							<xsl:variable name="Praezisierung" select="fn:replace($Element/xdf:praezisierung/text(),'\\&quot;','''')"/>
							<xsl:if test="substring-before(substring-after($Praezisierung,'pattern&quot;:&quot;'),'&quot;') != ''">
								<xsl:value-of select="substring-before(substring-after($Praezisierung,'pattern&quot;:&quot;'),'&quot;')"/>
							</xsl:if>
						</xsl:if>
					</td>
				</tr>
				<tr>
					<td>Zugeordnete Codeliste</td>
					<xsl:choose>
						<xsl:when test="$Element/xdf:feldart/code/text() != 'select' and $Element/xdf:codeliste">
							<td>
								<xsl:choose>
									<xsl:when test="$InterneLinks = '1'">
										<xsl:element name="a">
											<xsl:attribute name="href">#<xsl:value-of select="$Element/xdf:codeliste/xdf:identifikation/xdf:id"/></xsl:attribute>
											<xsl:value-of select="$Element/xdf:codeliste/xdf:identifikation/xdf:id"/>
										</xsl:element>: <xsl:value-of select="$Element/xdf:codeliste/xdf:name"/>
									</xsl:when>
									<xsl:otherwise>
										<xsl:value-of select="$Element/xdf:codeliste/xdf:identifikation/xdf:id"/>: <xsl:value-of select="$Element/xdf:codeliste/xdf:name"/>
									</xsl:otherwise>
								</xsl:choose>
								<xsl:if test="$Meldungen = '1'">
									<div class="Fehler E1017">Fehler!! E1017: Ist eine Codeliste zugeordnet, muss die Feldart 'Auswahlfeld' sein.</div>
								</xsl:if>
							</td>
						</xsl:when>
						<xsl:when test="$Element/xdf:feldart/code/text() = 'select' and not($Element/xdf:codeliste)">
							<td>
								<xsl:if test="$Meldungen = '1'">
									<div class="Fehler E1018">Fehler!! E1018: Wenn ein Datenfeld die Feldart 'Auswahlfeld' hat, muss eine Codeliste zugeordnet sein.</div>
								</xsl:if>
							</td>
						</xsl:when>
						<xsl:when test="$Element/xdf:codeliste">
							<td>
								<xsl:choose>
									<xsl:when test="$InterneLinks = '1'">
										<xsl:element name="a">
											<xsl:attribute name="href">#<xsl:value-of select="$Element/xdf:codeliste/xdf:identifikation/xdf:id"/></xsl:attribute>
											<xsl:value-of select="$Element/xdf:codeliste/xdf:identifikation/xdf:id"/>
										</xsl:element>: <xsl:value-of select="$Element/xdf:codeliste/xdf:name"/>
									</xsl:when>
									<xsl:otherwise>
										<xsl:value-of select="$Element/xdf:codeliste/xdf:identifikation/xdf:id"/>: <xsl:value-of select="$Element/xdf:codeliste/xdf:name"/>
									</xsl:otherwise>
								</xsl:choose>
							</td>
						</xsl:when>
						<xsl:otherwise>
							<td>
														</td>
						</xsl:otherwise>
					</xsl:choose>
				</tr>
				<tr>
					<td>Hinweis</td>
					<xsl:if test="$Element/xdf:praezisierung/text() != ''">
						<xsl:variable name="Praezisierung" select="fn:replace($Element/xdf:praezisierung/text(),'\\&quot;','''')"/>
						<xsl:choose>
							<xsl:when test="substring($Praezisierung,1,1) = '{'">
								<td>
									<xsl:if test="substring-before(substring-after($Praezisierung,'note&quot;:&quot;'),'&quot;') != ''">
										<xsl:value-of select="substring-before(substring-after($Praezisierung,'note&quot;:&quot;'),'&quot;')"/>
									</xsl:if>
								</td>
							</xsl:when>
							<xsl:otherwise>
								<td>
									<xsl:value-of select="$Element/xdf:praezisierung"/>
									<xsl:if test="$Meldungen = '1'">
										<div class="Fehler E1035">Fehler!! E1035: Hinweis noch im alten Format. Element muss nochmals gespeichert werden.</div>
									</xsl:if>
								</td>
							</xsl:otherwise>
						</xsl:choose>
					</xsl:if>
				</tr>
				<tr>
					<td>Inhalt</td>
					<xsl:choose>
						<xsl:when test="$Element/xdf:feldart/code/text() = 'label' and empty($Element/xdf:inhalt/text())">
							<td>
								<xsl:if test="$Meldungen = '1'">
									<div class="Warnung W1009">Warnung!! W1009: Bei einem Feld mit nur lesendem Zugriff, der Feldart 'Statisch' wird i. d. R. der Inhalt mit einem Text befüllt.</div>
								</xsl:if>
							</td>
						</xsl:when>
						<xsl:otherwise>
							<td>
								<xsl:value-of select="fn:replace($Element/xdf:inhalt,'\n','&lt;br/&gt;')" disable-output-escaping="yes"/>
								<xsl:if test="$Meldungen = '1'">
									<xsl:variable name="Inhalt"><xsl:value-of select="$Element/xdf:inhalt"/></xsl:variable>
									<xsl:variable name="Praezisierung" select="fn:replace($Element/xdf:praezisierung/text(),'\\&quot;','''')"/>
									<xsl:variable name="minValue">
										<xsl:if test="substring-before(substring-after($Praezisierung,'minValue&quot;:&quot;'),'&quot;') != ''">
											<xsl:value-of select="substring-before(substring-after($Praezisierung,'minValue&quot;:&quot;'),'&quot;')"/>
										</xsl:if>
									</xsl:variable>
									<xsl:variable name="maxValue">
										<xsl:if test="substring-before(substring-after($Praezisierung,'maxValue&quot;:&quot;'),'&quot;') != ''">
											<xsl:value-of select="substring-before(substring-after($Praezisierung,'maxValue&quot;:&quot;'),'&quot;')"/>
										</xsl:if>
									</xsl:variable>
									<xsl:variable name="minLength">
										<xsl:if test="substring-before(substring-after($Praezisierung,'minLength&quot;:&quot;'),'&quot;') != ''">
											<xsl:value-of select="substring-before(substring-after($Praezisierung,'minLength&quot;:&quot;'),'&quot;')"/>
										</xsl:if>
									</xsl:variable>
									<xsl:variable name="maxLength">
										<xsl:if test="substring-before(substring-after($Praezisierung,'maxLength&quot;:&quot;'),'&quot;') != ''">
											<xsl:value-of select="substring-before(substring-after($Praezisierung,'maxLength&quot;:&quot;'),'&quot;')"/>
										</xsl:if>
									</xsl:variable>
									<xsl:choose>
										<xsl:when test="$Element/xdf:datentyp/code/text() = 'num' or $Element/xdf:datentyp/code/text() = 'num_currency'">
											<xsl:if test="$Inhalt != '' and not($Inhalt castable as xs:double)">
												<div class="Fehler E1069">Fehler!! E1069: Der Inhalt muss eine Zahl sein.</div>
											</xsl:if>
											<xsl:if test="$Inhalt != '' and $minValue != '' and ($Inhalt castable as xs:double) and ($minValue castable as xs:double) and ($minValue cast as xs:double &gt; $Inhalt cast as xs:double)">
												<div class="Fehler E1072">Fehler!! E1072: Der Inhalt unterschreitet die untere Wertgrenze.</div>
											</xsl:if>
											<xsl:if test="$Inhalt != '' and $maxValue != '' and ($Inhalt castable as xs:double) and ($maxValue castable as xs:double) and ($maxValue cast as xs:double &lt; $Inhalt cast as xs:double)">
												<div class="Fehler E1073">Fehler!! E1073: Der Inhalt überschreitet die obere Wertgrenze.</div>
											</xsl:if>
										</xsl:when>
										<xsl:when test="$Element/xdf:datentyp/code/text() = 'num_int'">
											<xsl:if test="$Inhalt != '' and not($Inhalt castable as xs:integer)">
												<div class="Fehler E1070">Fehler!! E1070: Der Inhalt muss eine ganze Zahl sein.</div>
											</xsl:if>
											<xsl:if test="$Inhalt != '' and $minValue != '' and ($Inhalt castable as xs:integer) and ($minValue castable as xs:integer) and ($minValue cast as xs:integer &gt; $Inhalt cast as xs:integer)">
												<div class="Fehler E1072">Fehler!! E1072: Der Inhalt unterschreitet die untere Wertgrenze.</div>
											</xsl:if>
											<xsl:if test="$Inhalt != '' and $maxValue != '' and ($Inhalt castable as xs:integer) and ($maxValue castable as xs:integer) and ($maxValue cast as xs:integer &lt; $Inhalt cast as xs:integer)">
												<div class="Fehler E1073">Fehler!! E1073: Der Inhalt überschreitet die obere Wertgrenze.</div>
											</xsl:if>
										</xsl:when>
										<xsl:when test="$Element/xdf:datentyp/code/text() = 'date'">
											<xsl:if test="$Inhalt != '' and not($Inhalt castable as xs:date)">
												<div class="Fehler E1071">Fehler!! E1071: Der Inhalt muss ein Datum sein.</div>
											</xsl:if>
											<xsl:if test="$Inhalt != '' and $minValue != '' and ($Inhalt castable as xs:date) and ($minValue castable as xs:date) and ($minValue cast as xs:date &gt; $Inhalt cast as xs:date)">
												<div class="Fehler E1072">Fehler!! E1072: Der Inhalt unterschreitet die untere Wertgrenze.</div>
											</xsl:if>
											<xsl:if test="$Inhalt != '' and $maxValue != '' and ($Inhalt castable as xs:date) and ($maxValue castable as xs:date) and ($maxValue cast as xs:date &lt; $Inhalt cast as xs:date)">
												<div class="Fehler E1073">Fehler!! E1073: Der Inhalt überschreitet die obere Wertgrenze.</div>
											</xsl:if>
										</xsl:when>
										<xsl:when test="$Element/xdf:datentyp/code/text() = 'text'">
											<xsl:if test="$Inhalt != '' and ($minLength castable as xs:integer) and (fn:string-length($Inhalt) &lt; $minLength)">
												<div class="Fehler E1074">Fehler!! E1074: Der Inhalt unterschreitet die Minimallänge.</div>
											</xsl:if>
											<xsl:if test="$Inhalt != '' and ($maxLength castable as xs:integer) and (fn:string-length($Inhalt) &gt; $maxLength)">
												<div class="Fehler E1075">Fehler!! E1075: Der Inhalt überschreitet die Maximallänge.</div>
											</xsl:if>
										</xsl:when>
										<xsl:when test="$Element/xdf:datentyp/code/text() = 'bool'">
											<xsl:if test="$Inhalt != '' and not($Inhalt castable as xs:boolean)">
												<div class="Fehler E1077">Fehler!! E1077: Der Inhalt muss ein Wahrheitswert sein (true oder false).</div>
											</xsl:if>
										</xsl:when>
									</xsl:choose>
								</xsl:if>
							</td>
						</xsl:otherwise>
					</xsl:choose>
				</tr>
				<tr>
					<td>Beschreibung</td>
					<td>
						<xsl:value-of select="fn:replace($Element/xdf:beschreibung,'\n','&lt;br/&gt;')" disable-output-escaping="yes"/>
					</td>
				</tr>
				<tr>
					<td>Bezeichnung Eingabe</td>
					<xsl:choose>
						<xsl:when test="empty($Element/xdf:bezeichnungEingabe/text())">
							<td>
								<xsl:if test="$Meldungen = '1'">
									<div class="Fehler E1009">Fehler!! E1009: Die Bezeichnung Eingabe muss befüllt werden.</div>
								</xsl:if>
							</td>
						</xsl:when>
						<xsl:otherwise>
							<td>
								<xsl:value-of select="$Element/xdf:bezeichnungEingabe"/>
							</td>
						</xsl:otherwise>
					</xsl:choose>
				</tr>
				<tr>
					<td>Bezeichnung Ausgabe</td>
					<xsl:choose>
						<xsl:when test="empty($Element/xdf:bezeichnungAusgabe/text())">
							<td>
								<xsl:if test="$Meldungen = '1'">
									<div class="Fehler E1010">Fehler!! E1010: Die Bezeichnung Ausgabe muss befüllt werden.</div>
								</xsl:if>
							</td>
						</xsl:when>
						<xsl:otherwise>
							<td>
								<xsl:value-of select="$Element/xdf:bezeichnungAusgabe"/>
							</td>
						</xsl:otherwise>
					</xsl:choose>
				</tr>
				<tr>
					<td>Hilfetext Eingabe</td>
					<td>
						<xsl:value-of select="fn:replace($Element/xdf:hilfetextEingabe,'\n','&lt;br/&gt;')" disable-output-escaping="yes"/>
					</td>
				</tr>
				<tr>
					<td>Hilfetext Ausgabe</td>
					<td>
						<xsl:value-of select="fn:replace($Element/xdf:hilfetextAusgabe,'\n','&lt;br/&gt;')" disable-output-escaping="yes"/>
					</td>
				</tr>
				<tr>
					<td>Fachlicher Ersteller</td>
					<xsl:choose>
						<xsl:when test="empty($Element/xdf:fachlicherErsteller/text()) and $VersionsHinweise ='1'">
							<td>
								<xsl:value-of select="$Element/xdf:fachlicherErsteller"/>
								<xsl:if test="$Meldungen = '1'">
									<div class="Hinweis">Hinweis!! Der Fachliche Ersteller darf zur Versionierung oder Veröffentlichung nicht leer sein.</div>
								</xsl:if>
							</td>
						</xsl:when>
						<xsl:otherwise>
							<td>
								<xsl:value-of select="$Element/xdf:fachlicherErsteller"/>
							</td>
						</xsl:otherwise>
					</xsl:choose>
				</tr>
				<tr>
					<td>Status</td>
					<xsl:choose>
						<xsl:when test="$Element/xdf:status/code/text() != 'aktiv' and $VersionsHinweise ='1'">
							<td>
								<xsl:apply-templates select="$Element/xdf:status"/>
								<xsl:if test="$Meldungen = '1'">
									<div class="Hinweis">Hinweis!! Der Status muss zur Versionierung oder Veröffentlichung den Wert 'aktiv' haben.</div>
								</xsl:if>
							</td>
						</xsl:when>
						<xsl:otherwise>
							<td>
								<xsl:apply-templates select="$Element/xdf:status"/>
							</td>
						</xsl:otherwise>
					</xsl:choose>
				</tr>
				<tr>
					<td>Gültig ab</td>
					<td>
						<xsl:value-of select="$Element/xdf:gueltigAb"/>
					</td>
				</tr>
				<tr>
					<td>Gültig bis</td>
					<td>
						<xsl:value-of select="$Element/xdf:gueltigBis"/>
					</td>
				</tr>
				<tr>
					<td>Freigabedatum</td>
					<td>
						<xsl:value-of select="$Element/xdf:freigabedatum"/>
					</td>
				</tr>
				<tr>
					<td>Veröffentlichungsdatum</td>
					<td>
						<xsl:value-of select="$Element/xdf:veroeffentlichungsdatum"/>
					</td>
				</tr>
				<!--
										<xsl:if test="$PrivateMode = '0'">
											<tr>
												<td>Letzter Bearbeiter</td>
												<td>
													<xsl:value-of select="./LetzterBearbeiter"/>
												</td>
											</tr>
											<tr>
												<td>Zeitpunkt der Erstellung</td>
												<td>
													<xsl:value-of select="./Erstelldatum"/>
												</td>
											</tr>
											<tr>
												<td>Zeitpunkt der letzten Änderung</td>
												<td>
													<xsl:value-of select="./LetztesAenderungsdatum"/>
												</td>
											</tr>
										</xsl:if>
-->
				<xsl:if test="count($Element/xdf:regel)">
					<tr>
						<td>
							<b>Regeln</b>
						</td>
						<td>
							<table>
								<thead>
									<tr>
										<th>ID</th>
										<th>Version</th>
										<th>Name</th>
										<th>Definition</th>
									</tr>
								</thead>
								<tbody>
									<xsl:for-each select="$Element/xdf:regel">
										<tr>
											<td>
												<xsl:choose>
													<xsl:when test="$InterneLinks = '1'">
														<xsl:element name="a">
															<xsl:attribute name="href">#<xsl:value-of select="./xdf:identifikation/xdf:id"/><xsl:if test="./xdf:identifikation/xdf:version">V<xsl:value-of select="./xdf:identifikation/xdf:version"/></xsl:if></xsl:attribute>
															<xsl:value-of select="./xdf:identifikation/xdf:id"/>
														</xsl:element>
													</xsl:when>
													<xsl:otherwise>
														<xsl:value-of select="./xdf:identifikation/xdf:id"/>
													</xsl:otherwise>
												</xsl:choose>
											</td>
											<td>
												<xsl:value-of select="./xdf:identifikation/xdf:version"/>
											</td>
											<td>
												<xsl:value-of select="./xdf:name"/>
											</td>
											<td>
												<xsl:value-of select="fn:replace(./xdf:definition,'\n','&lt;br/&gt;')" disable-output-escaping="yes"/>
												<xsl:if test="$Meldungen = '1'">
													<xsl:variable name="regellistedoppelte">
														<xdf:enthaltenebaukastenelemente>
															<xsl:analyze-string regex="[F|G]\d{{8}}" select="./xdf:definition">
																<xsl:matching-substring>
																	<xdf:elementid>
																		<xsl:value-of select="."/>
																	</xdf:elementid>
																</xsl:matching-substring>
																<xsl:non-matching-substring>
																							</xsl:non-matching-substring>
															</xsl:analyze-string>
														</xdf:enthaltenebaukastenelemente>
													</xsl:variable>
													<xsl:for-each-group select="$regellistedoppelte/*/xdf:elementid" group-by=".">
														<xsl:sort/>
														<xsl:variable name="TestElement">
															<xsl:value-of select="."/>
														</xsl:variable>
														<xsl:if test="fn:not($Element//xdf:identifikation[xdf:id/text() = $TestElement])">
															<div class="Fehler E1001">Fehler!! E1001: Die Regel kann auf kein Baukastenelement mit der ID <xsl:value-of select="$TestElement"/> zugreifen.</div>
														</xsl:if>
													</xsl:for-each-group>
													<xsl:variable name="regellisteversionen">
														<xdf:enthaltenebaukastenelemente>
															<xsl:analyze-string regex="[F|G]\d{{8}}V\d*\.\d*" select="./xdf:definition">
																<xsl:matching-substring>
																	<xdf:elementid>
																		<xsl:value-of select="."/>
																	</xdf:elementid>
																</xsl:matching-substring>
																<xsl:non-matching-substring>
																							</xsl:non-matching-substring>
															</xsl:analyze-string>
														</xdf:enthaltenebaukastenelemente>
													</xsl:variable>
													<xsl:for-each-group select="$regellisteversionen/*/xdf:elementid" group-by=".">
														<xsl:sort/>
														<div class="Fehler E1019">Fehler!! E1019: Baukastenelemente, die in Regeln referenziert werden, dürfen keine Versionsangaben beinhalten: <xsl:value-of select="."/>.</div>
													</xsl:for-each-group>
												</xsl:if>
											</td>
										</tr>
									</xsl:for-each>
								</tbody>
							</table>
						</td>
					</tr>
				</xsl:if>
				<!--
											<xsl:if test="count(Relationen/*)">
												<tr>
													<td>
														<b>Relationen</b>
													</td>
													<td>
														<table>
															<thead>
																<tr>
																	<th>ID</th>
																	<th>Version</th>
																	<th>Name</th>
																	<th>Bezeichnung</th>
																	<th>Art der Relation</th>
																	<th>Beschreibung der Relation</th>
																</tr>
															</thead>
															<tbody>
																<xsl:for-each select="./Relationen/Relation">
																	<xsl:variable name="RelationID" select="./xdf:id"/>
																	<xsl:variable name="Relation">
																		<xsl:copy-of select="$Daten/*/Formularfelder/Formularfeld[Id = $RelationID]"/>
																		<xsl:copy-of select="$Daten/*/Formularfeldgruppen/Formularfeldgruppe[Id = $RelationID]"/>
																	</xsl:variable>
																	<tr>
																		<td>
																			<xsl:element name="a">
																				<xsl:attribute name="href">#<xsl:value-of select="./xdf:id"/></xsl:attribute>
																				<xsl:value-of select="./xdf:id"/>
																			</xsl:element>
																		</td>
																		<td>
																			<xsl:value-of select="$Relation/*/xdf:version"/>
																		</td>
																		<td>
																			<xsl:value-of select="$Relation/*/xdf:name"/>
																		</td>
																		<td>
																			<xsl:value-of select="$Relation/*/Bezeichnung"/>
																		</td>
																		<td>
																			<xsl:value-of select="./Art"/>
																		</td>
																		<td>
																			<xsl:value-of select="./Beschreibung"/>
																		</td>
																	</tr>
																</xsl:for-each>
															</tbody>
														</table>
													</td>
												</tr>
											</xsl:if>
-->
				<tr>
					<td>
						<b>Verwendet in</b>
					</td>
					<xsl:variable name="FeldIDmitVersion">
						<xsl:value-of select="$Element/xdf:identifikation/xdf:id"/>
						<xsl:if test="$Element/xdf:identifikation/xdf:version">V<xsl:value-of select="$Element/xdf:identifikation/xdf:version"/>
						</xsl:if>
					</xsl:variable>
					<xsl:choose>
						<xsl:when test="count(/*/xdf:stammdatenschema[xdf:struktur/xdf:enthaelt/xdf:id = $FeldIDmitVersion]) + count(/*/xdf:datenfeldgruppe[xdf:struktur/xdf:enthaelt/xdf:id = $FeldIDmitVersion])">
							<td>
								<table>
									<thead>
										<tr>
											<th>ID</th>
											<th>Version</th>
											<th>Name</th>
											<th>Bezeichnung Eingabe</th>
										</tr>
									</thead>
									<tbody>
										<xsl:for-each-group select="/*/xdf:datenfeldgruppe[xdf:struktur/xdf:enthaelt/xdf:id = $FeldIDmitVersion]" group-by="xdf:identifikation/xdf:id">
											<xsl:sort select="./xdf:identifikation/xdf:id"/>
											<xsl:for-each-group select="fn:current-group()" group-by="string(xdf:identifikation/xdf:version)">
												<xsl:sort select="./xdf:identifikation/xdf:version"/>
												<xsl:call-template name="minielementcore">
													<xsl:with-param name="Element" select="."/>
												</xsl:call-template>
											</xsl:for-each-group>
										</xsl:for-each-group>
										<xsl:for-each-group select="/*/xdf:stammdatenschema[xdf:struktur/xdf:enthaelt/xdf:id = $FeldIDmitVersion]" group-by="./xdf:identifikation/xdf:id">
											<xsl:sort select="./xdf:identifikation/xdf:id"/>
											<xsl:for-each-group select="fn:current-group()" group-by="string(xdf:identifikation/xdf:version)">
												<xsl:sort select="./xdf:identifikation/xdf:version"/>
												<xsl:call-template name="minielementcore">
													<xsl:with-param name="Element" select="."/>
												</xsl:call-template>
											</xsl:for-each-group>
										</xsl:for-each-group>
									</tbody>
								</table>
							</td>
						</xsl:when>
						<xsl:otherwise>
							<td>
								<xsl:if test="$Meldungen = '1'">
									<div class="Warnung W1014">Warnung!! W1014: Element wird nicht verwendet.</div>
								</xsl:if>
							</td>
						</xsl:otherwise>
					</xsl:choose>
				</tr>
			</xsl:when>
			<xsl:when test="$Element/name() = 'xdf:datenfeldgruppe'">
				<tr>
					<td>
						<xsl:element name="a">
							<xsl:attribute name="name"><xsl:value-of select="$Element/xdf:identifikation/xdf:id"/><xsl:if test="$Element/xdf:identifikation/xdf:version">V<xsl:value-of select="$Element/xdf:identifikation/xdf:version"/></xsl:if></xsl:attribute>
						</xsl:element>
													ID
												</td>
					<td class="ElementID">
						<xsl:value-of select="$Element/xdf:identifikation/xdf:id"/>
						<xsl:if test="$ToolAufruf = '1'">
														&#160;&#160;
														<xsl:element name="a">
								<xsl:attribute name="href"><xsl:value-of select="$ToolPfadPrefix"/><xsl:value-of select="$Element/xdf:identifikation/xdf:id"/><xsl:if test="$Element/xdf:identifikation/xdf:version">V<xsl:value-of select="$Element/xdf:identifikation/xdf:version"/></xsl:if><xsl:value-of select="$ToolPfadPostfix"/></xsl:attribute>
								<xsl:attribute name="target">FIMTool</xsl:attribute>
								<xsl:attribute name="title">Springe in den Datenfeldeditor (man muss vorher angemeldet sein).</xsl:attribute>
															&#8658;
														</xsl:element>
						</xsl:if>
					</td>
				</tr>
				<tr>
					<td>Version</td>
					<td>
						<xsl:value-of select="$Element/xdf:identifikation/xdf:version"/>
					</td>
				</tr>
				<tr>
					<td>Name</td>
					<xsl:choose>
						<xsl:when test="empty($Element/xdf:name/text())">
							<td class="ElementName">
								<xsl:if test="$Meldungen = '1'">
									<div class="Fehler E1002">Fehler!! E1002: Der Name muss befüllt werden.</div>
								</xsl:if>
							</td>
						</xsl:when>
						<xsl:otherwise>
							<td class="ElementName">
								<xsl:value-of select="$Element/xdf:name"/>
							</td>
						</xsl:otherwise>
					</xsl:choose>
				</tr>
				<tr>
					<td>Definition</td>
					<td>
						<xsl:value-of select="fn:replace($Element/xdf:definition,'\n','&lt;br/&gt;')" disable-output-escaping="yes"/>
					</td>
				</tr>
				<tr>
					<td>Strukturelementart</td>
					<td>
						<xsl:apply-templates select="$Element/xdf:schemaelementart"/>
					</td>
				</tr>
				<tr>
					<td>Handlungsgrundlagen</td>
					<xsl:choose>
						<xsl:when test="$Element/xdf:schemaelementart/code/text() = 'RNG' and empty($Element/xdf:bezug/text())">
							<td>
								<xsl:if test="$Meldungen = '1'">
									<div class="Fehler E1006">Fehler!! E1006: Der Bezug zur Handlungsgrundlage darf bei Elementen mit der Strukturelementart 'rechtsnormgebunden' nicht leer sein.</div>
								</xsl:if>
							</td>
						</xsl:when>
						<xsl:when test="$Element/xdf:schemaelementart/code/text() = 'HAR' and empty($Element/xdf:bezug/text())">
							<td>
								<xsl:if test="$Meldungen = '1'">
									<div class="Warnung W1001">Warnung!! W1001: Der Bezug zur Handlungsgrundlage sollte bei Elementen mit der Strukturelementart 'harmonisiert' möglichst nicht leer sein.</div>
								</xsl:if>
							</td>
						</xsl:when>
						<xsl:otherwise>
							<td>
								<xsl:value-of select="$Element/xdf:bezug"/>
							</td>
						</xsl:otherwise>
					</xsl:choose>
				</tr>
				<tr>
					<td>Beschreibung</td>
					<td>
						<xsl:value-of select="fn:replace($Element/xdf:beschreibung,'\n','&lt;br/&gt;')" disable-output-escaping="yes"/>
					</td>
				</tr>
				<tr>
					<td>Bezeichnung Eingabe</td>
					<xsl:choose>
						<xsl:when test="empty($Element/xdf:bezeichnungEingabe/text())">
							<td>
								<xsl:if test="$Meldungen = '1'">
									<div class="Fehler E1009">Fehler!! E1009: Die Bezeichnung Eingabe muss befüllt werden.</div>
								</xsl:if>
							</td>
						</xsl:when>
						<xsl:otherwise>
							<td>
								<xsl:value-of select="$Element/xdf:bezeichnungEingabe"/>
							</td>
						</xsl:otherwise>
					</xsl:choose>
				</tr>
				<tr>
					<td>Bezeichnung Ausgabe</td>
					<xsl:choose>
						<xsl:when test="empty($Element/xdf:bezeichnungAusgabe/text())">
							<td>
								<xsl:if test="$Meldungen = '1'">
									<div class="Fehler E1010">Fehler!! E1010: Die Bezeichnung Ausgabe muss befüllt werden.</div>
								</xsl:if>
							</td>
						</xsl:when>
						<xsl:otherwise>
							<td>
								<xsl:value-of select="$Element/xdf:bezeichnungAusgabe"/>
							</td>
						</xsl:otherwise>
					</xsl:choose>
				</tr>
				<tr>
					<td>Hilfetext Eingabe</td>
					<td>
						<xsl:value-of select="fn:replace($Element/xdf:hilfetextEingabe,'\n','&lt;br/&gt;')" disable-output-escaping="yes"/>
					</td>
				</tr>
				<tr>
					<td>Hilfetext Ausgabe</td>
					<td>
						<xsl:value-of select="fn:replace($Element/xdf:hilfetextAusgabe,'\n','&lt;br/&gt;')" disable-output-escaping="yes"/>
					</td>
				</tr>
				<tr>
					<td>Fachlicher Ersteller</td>
					<xsl:choose>
						<xsl:when test="empty($Element/xdf:fachlicherErsteller/text()) and $VersionsHinweise ='1'">
							<td>
								<xsl:value-of select="$Element/xdf:fachlicherErsteller"/>
								<xsl:if test="$Meldungen = '1'">
									<div class="Hinweis">Hinweis!! Der Fachliche Ersteller darf zur Versionierung oder Veröffentlichung nicht leer sein.</div>
								</xsl:if>
							</td>
						</xsl:when>
						<xsl:otherwise>
							<td>
								<xsl:value-of select="$Element/xdf:fachlicherErsteller"/>
							</td>
						</xsl:otherwise>
					</xsl:choose>
				</tr>
				<tr>
					<td>Status</td>
					<xsl:choose>
						<xsl:when test="$Element/xdf:status/code/text() != 'aktiv' and $VersionsHinweise ='1'">
							<td>
								<xsl:apply-templates select="$Element/xdf:status"/>
								<xsl:if test="$Meldungen = '1'">
									<div class="Hinweis">Hinweis!! Der Status muss zur Versionierung oder Veröffentlichung den Wert "aktiv" haben.</div>
								</xsl:if>
							</td>
						</xsl:when>
						<xsl:otherwise>
							<td>
								<xsl:apply-templates select="$Element/xdf:status"/>
							</td>
						</xsl:otherwise>
					</xsl:choose>
				</tr>
				<tr>
					<td>Gültig ab</td>
					<td>
						<xsl:value-of select="$Element/xdf:gueltigAb"/>
					</td>
				</tr>
				<tr>
					<td>Gültig bis</td>
					<td>
						<xsl:value-of select="$Element/xdf:gueltigBis"/>
					</td>
				</tr>
				<tr>
					<td>Freigabedatum</td>
					<td>
						<xsl:value-of select="$Element/xdf:freigabedatum"/>
					</td>
				</tr>
				<tr>
					<td>Veröffentlichungsdatum</td>
					<td>
						<xsl:value-of select="$Element/xdf:veroeffentlichungsdatum"/>
					</td>
				</tr>
				<!--
										<xsl:if test="$PrivateMode = '0'">
											<tr>
												<td>Letzter Bearbeiter</td>
												<td>
													<xsl:value-of select="./LetzterBearbeiter"/>
												</td>
											</tr>
											<tr>
												<td>Zeitpunkt der Erstellung</td>
												<td>
													<xsl:value-of select="./Erstelldatum"/>
												</td>
											</tr>
											<tr>
												<td>Zeitpunkt der letzten Änderung</td>
												<td>
													<xsl:value-of select="./LetztesAenderungsdatum"/>
												</td>
											</tr>
										</xsl:if>
-->
				<tr>
					<xsl:variable name="AnzahlUnterelemente" select="count($Element/xdf:struktur)"/>
					<td>
						<b>Unterelemente</b>
						<xsl:if test="$AnzahlUnterelemente = 1 and $Meldungen = '1'">
							<div class="Warnung W1006">Warnung!! W1006: Eine Datenfeldgruppe sollte mehr als ein Unterelement haben.</div>
						</xsl:if>
					</td>
					<xsl:choose>
						<xsl:when test="$AnzahlUnterelemente &gt; 0">
							<td>
								<table>
									<thead>
										<tr>
											<th>ID</th>
											<th>Version</th>
											<th>Name</th>
											<th>Bezeichnung Eingabe</th>
											<th>Strukturart</th>
											<th>Status</th>
											<th>Multiplizität</th>
											<th>Handlungsgrundlagen</th>
										</tr>
									</thead>
									<tbody>
										<xsl:variable name="Strukturelementart">
											<xsl:value-of select="./xdf:schemaelementart/code"/>
										</xsl:variable>
										<xsl:for-each select="$Element/xdf:struktur">
											<xsl:variable name="ElementID">
												<xsl:choose>
													<xsl:when test="substring-before(string(./xdf:enthaelt/xdf:id),'V')=''">
														<xsl:value-of select="string(./xdf:enthaelt/xdf:id)"/>
													</xsl:when>
													<xsl:otherwise>
														<xsl:value-of select="substring-before(string(./xdf:enthaelt/xdf:id),'V')"/>
													</xsl:otherwise>
												</xsl:choose>
											</xsl:variable>
											<xsl:variable name="ElementVersion">
												<xsl:value-of select="substring-after(string(./xdf:enthaelt/xdf:id),'V')"/>
											</xsl:variable>
											<xsl:variable name="VergleichsElementIDVersion">
												<xsl:value-of select="./xdf:enthaelt/xdf:id"/>
											</xsl:variable>
											<xsl:variable name="Unterlement">
												<xsl:call-template name="getelementbyidandversion">
													<xsl:with-param name="ElementID" select="$ElementID"/>
													<xsl:with-param name="ElementVersion" select="$ElementVersion"/>
												</xsl:call-template>
											</xsl:variable>
											<tr>
												<td>
													<xsl:choose>
														<xsl:when test="$InterneLinks = '1'">
															<xsl:element name="a">
																<xsl:attribute name="href">#<xsl:value-of select="./xdf:enthaelt/xdf:id"/></xsl:attribute>
																<xsl:value-of select="$ElementID"/>
															</xsl:element>
														</xsl:when>
														<xsl:otherwise>
															<xsl:value-of select="$ElementID"/>
														</xsl:otherwise>
													</xsl:choose>
													<xsl:if test="count($Element/xdf:struktur/xdf:enthaelt[xdf:id=$VergleichsElementIDVersion]) &gt; 1">
														<xsl:if test="$Meldungen = '1'">
															<div class="Fehler E1004">Fehler!! E1004: In einer Datenfeldgruppe darf ein Baukastenelement nicht mehrfach in derselben Version enthalten sein.</div>
														</xsl:if>
													</xsl:if>
												</td>
												<td>
													<xsl:value-of select="$ElementVersion"/>
												</td>
												<td>
													<xsl:value-of select="$Unterlement/*/xdf:name"/>
												</td>
												<td>
													<xsl:value-of select="$Unterlement/*/xdf:bezeichnungEingabe"/>
												</td>
												<xsl:choose>
													<xsl:when test="$Unterlement/*/xdf:schemaelementart/code/text() = 'ABS' and $AbstraktWarnung = '1'">
														<td>
															<xsl:apply-templates select="$Unterlement/*/xdf:schemaelementart"/>
															<xsl:if test="$Meldungen = '1'">
																<div class="Fehler E1013">Fehler!! E1013: Innerhalb von Datenschemata und Datenfeldgruppen dürfen nur Elemente mit der Strukturelementart harmonisiert oder rechtnormgebunden verwendet werden.</div>
															</xsl:if>
														</td>
													</xsl:when>
													<xsl:otherwise>
														<td>
															<xsl:apply-templates select="$Unterlement/*/xdf:schemaelementart"/>
														</td>
													</xsl:otherwise>
												</xsl:choose>
												<xsl:choose>
													<xsl:when test="$Unterlement/*/xdf:status/code/text() = 'inaktiv'">
														<td>
															<xsl:apply-templates select="$Unterlement/*/xdf:status"/>
															<xsl:if test="$Meldungen = '1'">
																<div class="Warnung W1016">Warnung!! W1016: Baukastenelemente im Status 'inaktiv' sollten nur in Ausnahmefällen verwendet werden.</div>
															</xsl:if>
														</td>
													</xsl:when>
													<xsl:when test="$Unterlement/*/xdf:status/code/text() = 'inVorbereitung' and $VersionsHinweise ='1'">
														<td>
															<xsl:apply-templates select="$Unterlement/*/xdf:status"/>
															<xsl:if test="$Meldungen = '1'">
																<div class="Hinweis">Hinweis!! Der Status muss zur Versionierung oder Veröffentlichung den Wert 'aktiv' haben.</div>
															</xsl:if>
														</td>
													</xsl:when>
													<xsl:otherwise>
														<td>
															<xsl:apply-templates select="$Unterlement/*/xdf:status"/>
														</td>
													</xsl:otherwise>
												</xsl:choose>
												<xsl:choose>
													<xsl:when test="$Meldungen = '1'">
														<td>
															<xsl:value-of select="./xdf:anzahl"/>
															<xsl:variable name="AnzahlText" select="./xdf:anzahl/text()"/>
															<xsl:variable name="minCount" select="fn:substring-before(./xdf:anzahl/text(),':')"/>
															<xsl:variable name="maxCount" select="fn:substring-after(./xdf:anzahl/text(),':')"/>
															<xsl:analyze-string regex="^\d{{1,}}:[\d{{1,}}|*]$" select="./xdf:anzahl">
																<xsl:matching-substring>
																	<xsl:if test="$AnzahlText = '0:0'">
																		<div class="Fehler E1021">Fehler!! E1021: Es ist keine Multiplizität angegeben.</div>
																	</xsl:if>
																	<xsl:if test="(fn:number($minCount) &gt; fn:number($maxCount)) and $maxCount != '*'">
																		<div class="Fehler E1047">Fehler!! E1047: In der Multiplizität muss die minimale Anzahl kleiner oder gleich der maximalen Anzahl sein.</div>
																	</xsl:if>
																</xsl:matching-substring>
																<xsl:non-matching-substring>
																	<xsl:if test="$Meldungen = '1'">
																		<div class="Fehler E1046">Fehler!! E1046: Die Multiplizität entspricht nicht den Formatvorgaben.</div>
																	</xsl:if>
																</xsl:non-matching-substring>
															</xsl:analyze-string>
														</td>
													</xsl:when>
													<xsl:otherwise>
														<td>
															<xsl:value-of select="./xdf:anzahl"/>
														</td>
													</xsl:otherwise>
												</xsl:choose>
												<xsl:choose>
													<xsl:when test="$Strukturelementart ='RNG' and ($Unterlement/*/xdf:schemaelementart/code/text() = 'ABS' or $Unterlement/*/xdf:schemaelementart/code/text() = 'HAR') and empty(./xdf:bezug/text())">
														<td>
															<xsl:if test="$Meldungen = '1'">
																<div class="Fehler E1022">Fehler!! E1022: Bei Verwendung von Elementen mit der Strukturelementart 'abstrakt' oder 'harmonisiert' innerhalb von Datenfeldgruppen mit der Strukturelementart 'rechtsnormgebunden' muss zur Multiplizität ein Bezug zu einer Handlungsgrundlage angegeben werden.</div>
															</xsl:if>
														</td>
													</xsl:when>
													<xsl:otherwise>
														<td>
															<xsl:value-of select="./xdf:bezug"/>
														</td>
													</xsl:otherwise>
												</xsl:choose>
											</tr>
										</xsl:for-each>
									</tbody>
								</table>
							</td>
						</xsl:when>
						<xsl:otherwise>
							<td>
								<xsl:if test="$Meldungen = '1'">
									<div class="Fehler E1023">Fehler!! E1023: Datenfeldgruppe hat keine Unterelemente.</div>
								</xsl:if>
							</td>
						</xsl:otherwise>
					</xsl:choose>
				</tr>
				<xsl:if test="count($Element/xdf:regel)">
					<tr>
						<td>
							<b>Regeln</b>
						</td>
						<td>
							<table>
								<thead>
									<tr>
										<th>ID</th>
										<th>Version</th>
										<th>Name</th>
										<th>Definition</th>
									</tr>
								</thead>
								<tbody>
									<xsl:for-each select="$Element/xdf:regel">
										<tr>
											<td>
												<xsl:choose>
													<xsl:when test="$InterneLinks = '1'">
														<xsl:element name="a">
															<xsl:attribute name="href">#<xsl:value-of select="./xdf:identifikation/xdf:id"/><xsl:if test="./xdf:identifikation/xdf:version">V<xsl:value-of select="./xdf:identifikation/xdf:version"/></xsl:if></xsl:attribute>
															<xsl:value-of select="./xdf:identifikation/xdf:id"/>
														</xsl:element>
													</xsl:when>
													<xsl:otherwise>
														<xsl:value-of select="./xdf:identifikation/xdf:id"/>
													</xsl:otherwise>
												</xsl:choose>
											</td>
											<td>
												<xsl:value-of select="./xdf:identifikation/xdf:version"/>
											</td>
											<td>
												<xsl:value-of select="./xdf:name"/>
											</td>
											<td>
												<xsl:value-of select="fn:replace(./xdf:definition,'\n','&lt;br/&gt;')" disable-output-escaping="yes"/>
												<xsl:if test="$Meldungen = '1'">
													<xsl:variable name="regellistedoppelte">
														<xdf:enthaltenebaukastenelemente>
															<xsl:analyze-string regex="[F|G]\d{{8}}" select="./xdf:definition">
																<xsl:matching-substring>
																	<xdf:elementid>
																		<xsl:value-of select="."/>
																	</xdf:elementid>
																</xsl:matching-substring>
																<xsl:non-matching-substring>
																							</xsl:non-matching-substring>
															</xsl:analyze-string>
														</xdf:enthaltenebaukastenelemente>
													</xsl:variable>
													<xsl:for-each-group select="$regellistedoppelte/*/xdf:elementid" group-by=".">
														<xsl:sort/>
														<xsl:variable name="TestElement">
															<xsl:value-of select="."/>
														</xsl:variable>
														<xsl:if test="fn:not($Element//xdf:identifikation[xdf:id/text() = $TestElement])">
															<div class="Fehler E1001">Fehler!! E1001: Die Regel kann auf kein Baukastenelement mit der ID <xsl:value-of select="$TestElement"/> zugreifen.</div>
														</xsl:if>
													</xsl:for-each-group>
													<xsl:variable name="regellisteversionen">
														<xdf:enthaltenebaukastenelemente>
															<xsl:analyze-string regex="[F|G]\d{{8}}V\d*\.\d*" select="./xdf:definition">
																<xsl:matching-substring>
																	<xdf:elementid>
																		<xsl:value-of select="."/>
																	</xdf:elementid>
																</xsl:matching-substring>
																<xsl:non-matching-substring>
																							</xsl:non-matching-substring>
															</xsl:analyze-string>
														</xdf:enthaltenebaukastenelemente>
													</xsl:variable>
													<xsl:for-each-group select="$regellisteversionen/*/xdf:elementid" group-by=".">
														<xsl:sort/>
														<div class="Fehler E1019">Fehler!! E1019: Baukastenelemente, die in Regeln referenziert werden, dürfen keine Versionsangaben beinhalten: <xsl:value-of select="."/>.</div>
													</xsl:for-each-group>
												</xsl:if>
											</td>
										</tr>
									</xsl:for-each>
								</tbody>
							</table>
						</td>
					</tr>
				</xsl:if>
				<!--
											<xsl:if test="count(Relationen/*)">
												<tr>
													<td>
														<b>Relationen</b>
													</td>
													<td>
														<table>
															<thead>
																<tr>
																	<th>ID</th>
																	<th>Version</th>
																	<th>Name</th>
																	<th>Bezeichnung</th>
																	<th>Art der Relation</th>
																	<th>Beschreibung der Relation</th>
																</tr>
															</thead>
															<tbody>
																<xsl:for-each select="./Relationen/Relation">
																	<xsl:variable name="RelationID" select="./xdf:id"/>
																	<xsl:variable name="Element">
																		<xsl:copy-of select="$Daten/*/Formularfelder/Formularfeld[Id = $RelationID]"/>
																		<xsl:copy-of select="$Daten/*/Formularfeldgruppen/Formularfeldgruppe[Id = $RelationID]"/>
																	</xsl:variable>
																	<tr>
																		<td>
																			<xsl:element name="a">
																				<xsl:attribute name="href">#<xsl:value-of select="./xdf:id"/></xsl:attribute>
																				<xsl:value-of select="./xdf:id"/>
																			</xsl:element>
																		</td>
																		<td>
																			<xsl:value-of select="$Element/*/xdf:version"/>
																		</td>
																		<td>
																			<xsl:value-of select="$Element/*/xdf:name"/>
																		</td>
																		<td>
																			<xsl:value-of select="$Element/*/Bezeichnung"/>
																		</td>
																		<td>
																			<xsl:value-of select="./Art"/>
																		</td>
																		<td>
																			<xsl:value-of select="./Beschreibung"/>
																		</td>
																	</tr>
																</xsl:for-each>
															</tbody>
														</table>
													</td>
												</tr>
											</xsl:if>
-->
				<tr>
					<td>
						<b>Verwendet in</b>
					</td>
					<xsl:variable name="FeldIgruppenDmitVersion">
						<xsl:value-of select="$Element/xdf:identifikation/xdf:id"/>
						<xsl:if test="$Element/xdf:identifikation/xdf:version">V<xsl:value-of select="$Element/xdf:identifikation/xdf:version"/>
						</xsl:if>
					</xsl:variable>
					<xsl:choose>
						<xsl:when test="count(/*/xdf:stammdatenschema[xdf:struktur/xdf:enthaelt/xdf:id = $FeldIgruppenDmitVersion]) + count(//xdf:datenfeldgruppe[xdf:struktur/xdf:enthaelt/xdf:id = $FeldIgruppenDmitVersion])">
							<td>
								<table>
									<thead>
										<tr>
											<th>ID</th>
											<th>Version</th>
											<th>Name</th>
											<th>Bezeichnung Eingabe</th>
										</tr>
									</thead>
									<tbody>
										<xsl:for-each-group select="/*/xdf:datenfeldgruppe[xdf:struktur/xdf:enthaelt/xdf:id = $FeldIgruppenDmitVersion]" group-by="./xdf:identifikation/xdf:id">
											<xsl:sort select="./xdf:identifikation/xdf:id"/>
											<xsl:for-each-group select="fn:current-group()" group-by="string(xdf:identifikation/xdf:version)">
												<xsl:sort select="./xdf:identifikation/xdf:version"/>
												<xsl:call-template name="minielementcore">
													<xsl:with-param name="Element" select="."/>
												</xsl:call-template>
											</xsl:for-each-group>
										</xsl:for-each-group>
										<xsl:for-each-group select="/*/xdf:stammdatenschema[xdf:struktur/xdf:enthaelt/xdf:id = $FeldIgruppenDmitVersion]" group-by="./xdf:identifikation/xdf:id">
											<xsl:sort select="./xdf:identifikation/xdf:id"/>
											<xsl:for-each-group select="fn:current-group()" group-by="string(xdf:identifikation/xdf:version)">
												<xsl:sort select="./xdf:identifikation/xdf:version"/>
												<xsl:call-template name="minielementcore">
													<xsl:with-param name="Element" select="."/>
												</xsl:call-template>
											</xsl:for-each-group>
										</xsl:for-each-group>
									</tbody>
								</table>
							</td>
						</xsl:when>
						<xsl:otherwise>
							<td>
								<xsl:if test="$Meldungen = '1'">
									<div class="Warnung W1014">Warnung!! W1014: Element wird nicht verwendet.</div>
								</xsl:if>
							</td>
						</xsl:otherwise>
					</xsl:choose>
				</tr>
			</xsl:when>
		</xsl:choose>
		<tr style="page-break-after:always">
			<td colspan="2" class="Navigation">
				<xsl:call-template name="navigationszeile"/>
			</td>
		</tr>
	</xsl:template>
	<!-- ############################################################################################################# -->
	<xsl:template name="getelementbyidandversion">
		<xsl:param name="ElementID"/>
		<xsl:param name="ElementVersion"/>
		<xsl:if test="$DebugMode = '4'">
			<xsl:message>
				++++++++++++ getelementbyidandversion ++++++++++++
			</xsl:message>
		</xsl:if>
		<xsl:choose>
			<xsl:when test="$ElementVersion = ''">
				<xsl:for-each select="$Daten/*/xdf:datenfeld[xdf:identifikation/xdf:id = $ElementID and not(xdf:identifikation/xdf:version)] | $Daten/*/xdf:datenfeldgruppe[xdf:identifikation/xdf:id = $ElementID and not(xdf:identifikation/xdf:version)]">
					<xsl:copy-of select="."/>
				</xsl:for-each>
			</xsl:when>
			<xsl:otherwise>
				<xsl:for-each select="$Daten/*/xdf:datenfeld[xdf:identifikation/xdf:id = $ElementID and xdf:identifikation/xdf:version = $ElementVersion] | $Daten/*/xdf:datenfeldgruppe[xdf:identifikation/xdf:id = $ElementID and xdf:identifikation/xdf:version = $ElementVersion]">
					<xsl:copy-of select="."/>
				</xsl:for-each>
			</xsl:otherwise>
		</xsl:choose>
	</xsl:template>
	<!-- ############################################################################################################# -->
	<xsl:template name="elementdetailszustammdatenschema">
		<xsl:param name="Element"/>
		<xsl:param name="VersionsAnzahl"/>
		<xsl:if test="$DebugMode = '2' or $DebugMode = '3' or $DebugMode = '4'">
			<xsl:message>
				++++++++ elementdetailszustammdatenschema ++++++++
			</xsl:message>
		</xsl:if>
		<xsl:if test="$DebugMode = '3' or $DebugMode = '4'">
			<xsl:message>
				-------- <xsl:value-of select="$Element/xdf:identifikation/xdf:id"/>
				<xsl:if test="$Element/xdf:identifikation/xdf:version">V<xsl:value-of select="$Element/xdf:identifikation/xdf:version"/>
				</xsl:if> --------
			</xsl:message>
		</xsl:if>
		<xsl:choose>
			<xsl:when test="$Element/name() = 'xdf:datenfeld'">
				<tr>
					<td>
						<xsl:element name="a">
							<xsl:attribute name="name"><xsl:value-of select="$Element/xdf:identifikation/xdf:id"/><xsl:if test="$Element/xdf:identifikation/xdf:version">V<xsl:value-of select="$Element/xdf:identifikation/xdf:version"/></xsl:if></xsl:attribute>
						</xsl:element>
													ID
												</td>
					<xsl:choose>
						<xsl:when test="empty($Element/xdf:identifikation/xdf:id/text())">
							<td class="ElementID">
								<xsl:if test="$Meldungen = '1'">
									<div class="Fehler E1038">Fehler!! E1038: Die ID muss befüllt werden.</div>
								</xsl:if>
							</td>
						</xsl:when>
						<xsl:otherwise>
							<td class="ElementID">
								<xsl:value-of select="$Element/xdf:identifikation/xdf:id"/>
								<xsl:analyze-string regex="^F\d{{8}}$" select="$Element/xdf:identifikation/xdf:id">
									<xsl:matching-substring>
										<xsl:if test="$ToolAufruf = '1'">
																		&#160;&#160;
																		<xsl:element name="a">
												<xsl:attribute name="href"><xsl:value-of select="$ToolPfadPrefix"/><xsl:value-of select="$Element/xdf:identifikation/xdf:id"/><xsl:if test="$Element/xdf:identifikation/xdf:version">V<xsl:value-of select="$Element/xdf:identifikation/xdf:version"/></xsl:if><xsl:value-of select="$ToolPfadPostfix"/></xsl:attribute>
												<xsl:attribute name="target">FIMTool</xsl:attribute>
												<xsl:attribute name="title">Springe in den Datenfeldeditor (man muss vorher angemeldet sein).</xsl:attribute>
																			&#8658;
																		</xsl:element>
										</xsl:if>
									</xsl:matching-substring>
									<xsl:non-matching-substring>
										<xsl:if test="$Meldungen = '1'">
											<div class="Fehler E1039">Fehler!! E1039: Die ID entspricht nicht den Formatvorgaben.</div>
										</xsl:if>
									</xsl:non-matching-substring>
								</xsl:analyze-string>
							</td>
						</xsl:otherwise>
					</xsl:choose>
				</tr>
				<tr>
					<td>Version</td>
					<xsl:choose>
						<xsl:when test="$VersionsAnzahl &gt; 1">
							<td>
								<xsl:value-of select="$Element/xdf:identifikation/xdf:version"/>
								<xsl:if test="$Meldungen = '1'">
									<div class="Fehler E1003">Fehler!! E1003: In einem Datenschema darf ein Baukastenelement nicht mehrfach in unterschiedlichen Versionen enthalten sein.</div>
								</xsl:if>
							</td>
						</xsl:when>
						<xsl:otherwise>
							<td>
								<xsl:value-of select="$Element/xdf:identifikation/xdf:version"/>
							</td>
						</xsl:otherwise>
					</xsl:choose>
				</tr>
				<tr>
					<td>Name</td>
					<xsl:choose>
						<xsl:when test="empty($Element/xdf:name/text())">
							<td class="ElementName">
								<xsl:if test="$Meldungen = '1'">
									<div class="Fehler E1002">Fehler!! E1002: Der Name muss befüllt werden.</div>
								</xsl:if>
							</td>
						</xsl:when>
						<xsl:otherwise>
							<td class="ElementName">
								<xsl:value-of select="$Element/xdf:name"/>
							</td>
						</xsl:otherwise>
					</xsl:choose>
				</tr>
				<tr>
					<td>Definition</td>
					<td>
						<xsl:value-of select="fn:replace($Element/xdf:definition,'\n','&lt;br/&gt;')" disable-output-escaping="yes"/>
					</td>
				</tr>
				<tr>
					<td>Strukturelementart</td>
					<xsl:choose>
						<xsl:when test="$Element/xdf:schemaelementart/code/text() = 'ABS' and $AbstraktWarnung ='1'">
							<td>
								<xsl:apply-templates select="$Element/xdf:schemaelementart"/>
								<xsl:if test="$Meldungen = '1'">
									<div class="Fehler E1014">Fehler!! E1014: Datenfelder dürfen nicht die Strukturelementart 'abstrakt' haben.</div>
								</xsl:if>
							</td>
						</xsl:when>
						<xsl:otherwise>
							<td>
								<xsl:apply-templates select="$Element/xdf:schemaelementart"/>
							</td>
						</xsl:otherwise>
					</xsl:choose>
				</tr>
				<tr>
					<td>Handlungsgrundlagen</td>
					<xsl:choose>
						<xsl:when test="$Element/xdf:schemaelementart/code/text() = 'RNG' and empty($Element/xdf:bezug/text())">
							<td>
								<xsl:if test="$Meldungen = '1'">
									<div class="Fehler E1006">Fehler!! E1006: Der Bezug zur Handlungsgrundlage darf bei Elementen mit der Strukturelementart 'rechtsnormgebunden' nicht leer sein.</div>
								</xsl:if>
							</td>
						</xsl:when>
						<xsl:when test="$Element/xdf:schemaelementart/code/text() = 'HAR' and empty($Element/xdf:bezug/text())">
							<td>
								<xsl:if test="$Meldungen = '1'">
									<div class="Warnung W1001">Warnung!! W1001: Der Bezug zur Handlungsgrundlage sollte bei Elementen mit der Strukturelementart 'harmonisiert' möglichst nicht leer sein.</div>
								</xsl:if>
							</td>
						</xsl:when>
						<xsl:otherwise>
							<td>
								<xsl:value-of select="$Element/xdf:bezug"/>
							</td>
						</xsl:otherwise>
					</xsl:choose>
				</tr>
				<tr>
					<td>Feldart</td>
					<td>
						<xsl:apply-templates select="$Element/xdf:feldart"/>
					</td>
				</tr>
				<tr>
					<td>Datentyp</td>
					<xsl:choose>
						<xsl:when test="$Element/xdf:feldart/code/text() = 'select'">
							<xsl:choose>
								<xsl:when test="$Element/xdf:datentyp/code/text() = 'text'">
									<td>
										<xsl:apply-templates select="$Element/xdf:datentyp"/>
									</td>
								</xsl:when>
								<xsl:when test="$Element/xdf:datentyp/code/text() = 'int'">
									<td>
										<xsl:apply-templates select="$Element/xdf:datentyp"/>
										<xsl:if test="$Meldungen = '1'">
											<div class="Warnung W1008">Warnung!! W1008: Wenn ein Datenfeld die Feldart 'Auswahl' hat, sollte der Datentyp i. d. R. vom Typ 'Text' sein.</div>
										</xsl:if>
									</td>
								</xsl:when>
								<xsl:otherwise>
									<td>
										<xsl:apply-templates select="$Element/xdf:datentyp"/>
										<xsl:if test="$Meldungen = '1'">
											<div class="Fehler E1011">Fehler!! E1011: Bei Datenfeldern mit der Feldart 'Auswahlfeld' sollte der Datentyp 'Text' sein - in seltenen Fällen 'Ganzzahl'.</div>
										</xsl:if>
									</td>
								</xsl:otherwise>
							</xsl:choose>
						</xsl:when>
						<xsl:otherwise>
							<td>
								<xsl:apply-templates select="$Element/xdf:datentyp"/>
							</td>
						</xsl:otherwise>
					</xsl:choose>
				</tr>
				<tr>
					<td>Feldlänge</td>
					<xsl:choose>
						<xsl:when test="$Element/xdf:praezisierung/text() != ''">
							<xsl:variable name="Praezisierung" select="fn:replace($Element/xdf:praezisierung/text(),'\\&quot;','''')"/>
							<xsl:variable name="minLength">
								<xsl:if test="substring-before(substring-after($Praezisierung,'minLength&quot;:&quot;'),'&quot;') != ''">
									<xsl:value-of select="substring-before(substring-after($Praezisierung,'minLength&quot;:&quot;'),'&quot;')"/>
								</xsl:if>
							</xsl:variable>
							<xsl:variable name="maxLength">
								<xsl:if test="substring-before(substring-after($Praezisierung,'maxLength&quot;:&quot;'),'&quot;') != ''">
									<xsl:value-of select="substring-before(substring-after($Praezisierung,'maxLength&quot;:&quot;'),'&quot;')"/>
								</xsl:if>
							</xsl:variable>
							<xsl:choose>
								<xsl:when test="$Element/xdf:datentyp/code/text() = 'text'">
									<xsl:choose>
										<xsl:when test="$Element/xdf:feldart/code/text() = 'select' or $Element/xdf:feldart/code/text() = 'label'">
											<xsl:choose>
												<xsl:when test="$minLength != '' or $maxLength != ''">
													<td>
														<xsl:if test="$minLength != ''">
															von <xsl:value-of select="$minLength"/>
														</xsl:if>
														<xsl:if test="$maxLength != ''">
															bis <xsl:value-of select="$maxLength"/>
														</xsl:if>
														<xsl:if test="$Meldungen = '1'">
															<div class="Fehler E1012">Fehler!! E1012: Bei Datenfeldern mit der Feldart 'Auswahlfeld' oder 'Statisches, read-only Feld' dürfen weder die minimale noch die maximale Feldlänge angegeben werden.</div>
														</xsl:if>
													</td>
												</xsl:when>
												<xsl:otherwise>
													<td>
													</td>
												</xsl:otherwise>
											</xsl:choose>
										</xsl:when>
										<xsl:otherwise>
											<xsl:choose>
												<xsl:when test="$minLength != '' and $maxLength != ''">
													<td>
														von <xsl:value-of select="$minLength"/> 
														bis <xsl:value-of select="$maxLength"/>
														<xsl:if test="$Meldungen = '1' and not($minLength castable as xs:nonNegativeInteger)">
															<div class="Fehler E1059">Fehler!! E1059: Die minimale Feldlänge muss eine ganze Zahl größer oder gleich Null sein.</div>
														</xsl:if>
														<xsl:if test="$Meldungen = '1' and not($maxLength castable as xs:positiveInteger)">
															<div class="Fehler E1060">Fehler!! E1060: Die maximale Feldlänge muss eine ganze Zahl größer Null sein.</div>
														</xsl:if>
														<xsl:if test="$Meldungen = '1' and ($minLength castable as xs:nonNegativeInteger) and ($maxLength castable as xs:positiveInteger) and ($minLength cast as xs:nonNegativeInteger &gt; $maxLength cast as xs:positiveInteger)">
															<div class="Fehler E1061">Fehler!! E1061: Die minimale Feldlänge darf nicht größer sein als die maximale Feldlänge.</div>
														</xsl:if>
													</td>
												</xsl:when>
												<xsl:otherwise>
													<td>
														<xsl:if test="$minLength != ''">
																						von <xsl:value-of select="$minLength"/>
														</xsl:if>
														<xsl:if test="$maxLength != ''">
																						bis <xsl:value-of select="$maxLength"/>
														</xsl:if>
														<xsl:if test="$Meldungen = '1' and $minLength != '' and not($minLength castable as xs:nonNegativeInteger)">
															<div class="Fehler E1059">Fehler!! E1059: Die minimale Feldlänge muss eine ganze Zahl größer oder gleich Null sein.</div>
														</xsl:if>
														<xsl:if test="$Meldungen = '1' and $maxLength != '' and not($maxLength castable as xs:positiveInteger)">
															<div class="Fehler E1060">Fehler!! E1060: Die maximale Feldlänge muss eine ganze Zahl größer Null sein.</div>
														</xsl:if>
														<xsl:if test="$Meldungen = '1'">
															<div class="Warnung W1002">Warnung!! W1002: Bei Eingabedatenfeldern mit dem Datentyp 'Text' sollten, wenn möglich, die minimale und maximale Feldlänge angegeben werden.</div>
														</xsl:if>
													</td>
												</xsl:otherwise>
											</xsl:choose>
										</xsl:otherwise>
									</xsl:choose>
								</xsl:when>
								<xsl:when test="$minLength != '' or $maxLength != ''">
									<td>
										<xsl:if test="$minLength != ''">
																		von <xsl:value-of select="$minLength"/>
										</xsl:if>
										<xsl:if test="$maxLength != ''">
																		bis <xsl:value-of select="$maxLength"/>
										</xsl:if>
										<xsl:if test="$Meldungen = '1'">
											<div class="Fehler E1015">Fehler!! E1015: Eine Feldlänge darf nur bei einem Datenfeld mit dem Datentyp 'Text' angegeben werden.</div>
										</xsl:if>
									</td>
								</xsl:when>
								<xsl:otherwise>
									<td/>
								</xsl:otherwise>
							</xsl:choose>
						</xsl:when>
						<xsl:otherwise>
							<xsl:choose>
								<xsl:when test="$Element/xdf:datentyp/code/text() = 'text' and $Element/xdf:feldart/code/text() = 'input'">
									<td>
										<xsl:if test="$Meldungen = '1'">
											<div class="Warnung W1002">Warnung!! W1002: Bei Eingabedatenfeldern mit dem Datentyp 'Text' sollten, wenn möglich, die minimale und maximale Feldlänge angegeben werden.</div>
										</xsl:if>
									</td>
								</xsl:when>
								<xsl:otherwise>
									<td/>
								</xsl:otherwise>
							</xsl:choose>
						</xsl:otherwise>
					</xsl:choose>
				</tr>
				<tr>
					<td>Wertebereich</td>
					<xsl:choose>
						<xsl:when test="$Element/xdf:praezisierung/text() != ''">
							<xsl:variable name="Praezisierung" select="fn:replace($Element/xdf:praezisierung/text(),'\\&quot;','''')"/>
							<xsl:variable name="minValue">
								<xsl:if test="substring-before(substring-after($Praezisierung,'minValue&quot;:&quot;'),'&quot;') != ''">
									<xsl:value-of select="substring-before(substring-after($Praezisierung,'minValue&quot;:&quot;'),'&quot;')"/>
								</xsl:if>
							</xsl:variable>
							<xsl:variable name="maxValue">
								<xsl:if test="substring-before(substring-after($Praezisierung,'maxValue&quot;:&quot;'),'&quot;') != ''">
									<xsl:value-of select="substring-before(substring-after($Praezisierung,'maxValue&quot;:&quot;'),'&quot;')"/>
								</xsl:if>
							</xsl:variable>
							<xsl:choose>
								<xsl:when test="$Element/xdf:datentyp/code/text() = 'num' or $Element/xdf:datentyp/code/text() = 'num_currency'">
									<td>
										<xsl:if test="$minValue != ''">
											von <xsl:value-of select="$minValue"/>
										</xsl:if>
										<xsl:if test="$maxValue != ''">
											bis <xsl:value-of select="$maxValue"/>
										</xsl:if>
										<xsl:if test="$Meldungen = '1' and $minValue != '' and not($minValue castable as xs:double)">
											<div class="Fehler E1062">Fehler!! E1062: Die untere Wertgrenze muss eine Zahl sein.</div>
										</xsl:if>
										<xsl:if test="$Meldungen = '1' and $maxValue != '' and not($maxValue castable as xs:double)">
											<div class="Fehler E1063">Fehler!! E1063: Die obere Wertgrenze muss eine Zahl sein.</div>
										</xsl:if>
										<xsl:if test="$Meldungen = '1' and $minValue != '' and $maxValue != '' and ($minValue castable as xs:double) and ($maxValue castable as xs:double) and ($minValue cast as xs:double &gt; $maxValue cast as xs:double)">
											<div class="Fehler E1064">Fehler!! E1064: Die untere Wertgrenze darf nicht größer sein als die obere Wertgrenze.</div>
										</xsl:if>
									</td>
								</xsl:when>
								<xsl:when test="$Element/xdf:datentyp/code/text() = 'num_int'">
									<td>
										<xsl:if test="$minValue != ''">
											von <xsl:value-of select="$minValue"/>
										</xsl:if>
										<xsl:if test="$maxValue != ''">
											bis <xsl:value-of select="$maxValue"/>
										</xsl:if>
										<xsl:if test="$Meldungen = '1' and $minValue != '' and not($minValue castable as xs:integer)">
											<div class="Fehler E1065">Fehler!! E1065: Die untere Wertgrenze muss eine ganze Zahl sein.</div>
										</xsl:if>
										<xsl:if test="$Meldungen = '1' and $maxValue != '' and not($maxValue castable as xs:integer)">
											<div class="Fehler E1066">Fehler!! E1066: Die obere Wertgrenze muss eine ganze Zahl sein.</div>
										</xsl:if>
										<xsl:if test="$Meldungen = '1' and $minValue != '' and $maxValue != '' and ($minValue castable as xs:integer) and ($maxValue castable as xs:integer) and ($minValue cast as xs:integer &gt; $maxValue cast as xs:integer)">
											<div class="Fehler E1064">Fehler!! E1064: Die untere Wertgrenze darf nicht größer sein als die obere Wertgrenze.</div>
										</xsl:if>
									</td>
								</xsl:when>
								<xsl:when test="$Element/xdf:datentyp/code/text() = 'date'">
									<td>
										<xsl:if test="$minValue != ''">
											von <xsl:value-of select="$minValue"/>
										</xsl:if>
										<xsl:if test="$maxValue != ''">
											bis <xsl:value-of select="$maxValue"/>
										</xsl:if>
										<xsl:if test="$Meldungen = '1' and $minValue != '' and not($minValue castable as xs:date)">
											<div class="Fehler E1067">Fehler!! E1067: Die untere Wertgrenze muss ein Datum sein.</div>
										</xsl:if>
										<xsl:if test="$Meldungen = '1' and $maxValue != '' and not($maxValue castable as xs:date)">
											<div class="Fehler E1068">Fehler!! E1068: Die obere Wertgrenze muss ein Datum sein.</div>
										</xsl:if>
										<xsl:if test="$Meldungen = '1' and $minValue != '' and $maxValue != '' and ($minValue castable as xs:date) and ($maxValue castable as xs:date) and ($minValue cast as xs:date &gt; $maxValue cast as xs:date)">
											<div class="Fehler E1064">Fehler!! E1064: Die untere Wertgrenze darf nicht größer sein als die obere Wertgrenze.</div>
										</xsl:if>
									</td>
								</xsl:when>
								<xsl:otherwise>
									<xsl:choose>
										<xsl:when test="$minValue != '' or $maxValue != ''">
											<td>
												<xsl:if test="$minValue != ''">
													von <xsl:value-of select="$minValue"/>
												</xsl:if>
												<xsl:if test="$maxValue != ''">
													bis <xsl:value-of select="$maxValue"/>
												</xsl:if>
												<xsl:if test="$Meldungen = '1'">
													<div class="Fehler E1016">Fehler!! E1016: Ein Wertebereich darf nur bei einem Datenfeld mit einem nummerischen Datentyp (Nummer, Ganzzahl, Geldbetrag) oder einem Datumsdatentyp angegeben werden.</div>
												</xsl:if>
											</td>
										</xsl:when>
										<xsl:otherwise>
											<td>
											</td>
										</xsl:otherwise>
									</xsl:choose>
								</xsl:otherwise>
							</xsl:choose>
						</xsl:when>
						<xsl:otherwise>
							<xsl:choose>
								<xsl:when test="$Element/xdf:datentyp/code/text() = 'num' or $Element/xdf:datentyp/code/text() = 'num_int' or $Element/xdf:datentyp/code/text() = 'num_currency'">
									<td>
										<xsl:if test="$Meldungen = '1'">
											<div class="Warnung W1003">Warnung!! W1003: Bei Datenfeldern mit dem Datentyp 'Nummer', 'Ganzzahl', 'Geldbetrag' oder Datum sollte, wenn möglich, ein Wertebereich angegeben werden.</div>
										</xsl:if>
									</td>
								</xsl:when>
								<xsl:otherwise>
									<td/>
								</xsl:otherwise>
							</xsl:choose>
						</xsl:otherwise>
					</xsl:choose>
				</tr>
				<tr>
					<td>Pattern</td>
					<td>
						<xsl:if test="$Element/xdf:praezisierung/text() != ''">
							<xsl:variable name="Praezisierung" select="fn:replace($Element/xdf:praezisierung/text(),'\\&quot;','''')"/>
							<xsl:if test="substring-before(substring-after($Praezisierung,'pattern&quot;:&quot;'),'&quot;') != ''">
								<xsl:value-of select="substring-before(substring-after($Praezisierung,'pattern&quot;:&quot;'),'&quot;')"/>
							</xsl:if>
						</xsl:if>
					</td>
				</tr>
				<tr>
					<td>Zugeordnete Codeliste</td>
					<xsl:choose>
						<xsl:when test="$Element/xdf:feldart/code/text() != 'select' and $Element/xdf:codelisteReferenz">
							<td>
								<xsl:choose>
									<xsl:when test="$InterneLinks = '1'">
										<xsl:element name="a">
											<xsl:attribute name="href">#<xsl:value-of select="$Element/xdf:codelisteReferenz/xdf:identifikation/xdf:id"/><xsl:if test="$Element/xdf:codelisteReferenz/xdf:identifikation/xdf:version">V<xsl:value-of select="$Element/xdf:codelisteReferenz/xdf:identifikation/xdf:version"/></xsl:if></xsl:attribute>
											<xsl:value-of select="$Element/xdf:codelisteReferenz/xdf:identifikation/xdf:id"/><xsl:if test="$Element/xdf:codelisteReferenz/xdf:identifikation/xdf:version">V<xsl:value-of select="$Element/xdf:codelisteReferenz/xdf:identifikation/xdf:version"/></xsl:if>
										</xsl:element>
									</xsl:when>
									<xsl:otherwise>
										<xsl:value-of select="$Element/xdf:codelisteReferenz/xdf:identifikation/xdf:id"/><xsl:if test="$Element/xdf:codelisteReferenz/xdf:identifikation/xdf:version">V<xsl:value-of select="$Element/xdf:codelisteReferenz/xdf:identifikation/xdf:version"/></xsl:if>
									</xsl:otherwise>
								</xsl:choose>
								<xsl:if test="$Meldungen = '1'">
									<div class="Fehler E1017">Fehler!! E1017: Ist eine Codeliste zugeordnet, muss die Feldart 'Auswahlfeld' sein.</div>
								</xsl:if>
							</td>
						</xsl:when>
						<xsl:when test="$Element/xdf:feldart/code/text() = 'select' and not($Element/xdf:codelisteReferenz)">
							<td>
								<xsl:if test="$Meldungen = '1'">
									<div class="Fehler E1018">Fehler!! E1018: Wenn ein Datenfeld die Feldart 'Auswahlfeld' hat, muss eine Codeliste zugeordnet sein.</div>
								</xsl:if>
							</td>
						</xsl:when>
						<xsl:otherwise>
							<td>
								<xsl:choose>
									<xsl:when test="$InterneLinks = '1'">
										<xsl:element name="a">
											<xsl:attribute name="href">#<xsl:value-of select="$Element/xdf:codelisteReferenz/xdf:identifikation/xdf:id"/><xsl:if test="$Element/xdf:codelisteReferenz/xdf:identifikation/xdf:version">V<xsl:value-of select="$Element/xdf:codelisteReferenz/xdf:identifikation/xdf:version"/></xsl:if></xsl:attribute>
											<xsl:value-of select="$Element/xdf:codelisteReferenz/xdf:identifikation/xdf:id"/><xsl:if test="$Element/xdf:codelisteReferenz/xdf:identifikation/xdf:version">V<xsl:value-of select="$Element/xdf:codelisteReferenz/xdf:identifikation/xdf:version"/></xsl:if>
										</xsl:element>
									</xsl:when>
									<xsl:otherwise>
										<xsl:value-of select="$Element/xdf:codelisteReferenz/xdf:identifikation/xdf:id"/><xsl:if test="$Element/xdf:codelisteReferenz/xdf:identifikation/xdf:version">V<xsl:value-of select="$Element/xdf:codelisteReferenz/xdf:identifikation/xdf:version"/></xsl:if>
									</xsl:otherwise>
								</xsl:choose>
							</td>
						</xsl:otherwise>
					</xsl:choose>
				</tr>
				<tr>
					<td>Hinweis</td>
					<xsl:if test="$Element/xdf:praezisierung/text() != ''">
						<xsl:variable name="Praezisierung" select="fn:replace($Element/xdf:praezisierung/text(),'\\&quot;','''')"/>
						<xsl:choose>
							<xsl:when test="substring($Praezisierung,1,1) = '{'">
								<td>
									<xsl:if test="substring-before(substring-after($Praezisierung,'note&quot;:&quot;'),'&quot;') != ''">
										<xsl:value-of select="substring-before(substring-after($Praezisierung,'note&quot;:&quot;'),'&quot;')"/>
									</xsl:if>
								</td>
							</xsl:when>
							<xsl:otherwise>
								<td>
									<xsl:value-of select="$Element/xdf:praezisierung"/>
									<xsl:if test="$Meldungen = '1'">
										<div class="Fehler E1035">Fehler!! E1035: Hinweis noch im alten Format. Element muss nochmals gespeichert werden.</div>
									</xsl:if>
								</td>
							</xsl:otherwise>
						</xsl:choose>
					</xsl:if>
				</tr>
				<tr>
					<td>Inhalt</td>
					<xsl:choose>
						<xsl:when test="$Element/xdf:feldart/code/text() = 'label' and empty($Element/xdf:inhalt/text())">
							<td>
								<xsl:if test="$Meldungen = '1'">
									<div class="Warnung W1009">Warnung!! W1009: Bei einem Feld mit nur lesendem Zugriff, der Feldart 'Statisch' wird i. d. R. der Inhalt mit einem Text befüllt.</div>
								</xsl:if>
							</td>
						</xsl:when>
						<xsl:otherwise>
							<td>
								<xsl:value-of select="fn:replace($Element/xdf:inhalt,'\n','&lt;br/&gt;')" disable-output-escaping="yes"/>
								<xsl:if test="$Meldungen = '1'">
									<xsl:variable name="Inhalt"><xsl:value-of select="$Element/xdf:inhalt"/></xsl:variable>
									<xsl:variable name="Praezisierung" select="fn:replace($Element/xdf:praezisierung/text(),'\\&quot;','''')"/>
									<xsl:variable name="minValue">
										<xsl:if test="substring-before(substring-after($Praezisierung,'minValue&quot;:&quot;'),'&quot;') != ''">
											<xsl:value-of select="substring-before(substring-after($Praezisierung,'minValue&quot;:&quot;'),'&quot;')"/>
										</xsl:if>
									</xsl:variable>
									<xsl:variable name="maxValue">
										<xsl:if test="substring-before(substring-after($Praezisierung,'maxValue&quot;:&quot;'),'&quot;') != ''">
											<xsl:value-of select="substring-before(substring-after($Praezisierung,'maxValue&quot;:&quot;'),'&quot;')"/>
										</xsl:if>
									</xsl:variable>
									<xsl:variable name="minLength">
										<xsl:if test="substring-before(substring-after($Praezisierung,'minLength&quot;:&quot;'),'&quot;') != ''">
											<xsl:value-of select="substring-before(substring-after($Praezisierung,'minLength&quot;:&quot;'),'&quot;')"/>
										</xsl:if>
									</xsl:variable>
									<xsl:variable name="maxLength">
										<xsl:if test="substring-before(substring-after($Praezisierung,'maxLength&quot;:&quot;'),'&quot;') != ''">
											<xsl:value-of select="substring-before(substring-after($Praezisierung,'maxLength&quot;:&quot;'),'&quot;')"/>
										</xsl:if>
									</xsl:variable>
									<xsl:choose>
										<xsl:when test="$Element/xdf:datentyp/code/text() = 'num' or $Element/xdf:datentyp/code/text() = 'num_currency'">
											<xsl:if test="$Inhalt != '' and not($Inhalt castable as xs:double)">
												<div class="Fehler E1069">Fehler!! E1069: Der Inhalt muss eine Zahl sein.</div>
											</xsl:if>
											<xsl:if test="$Inhalt != '' and $minValue != '' and ($Inhalt castable as xs:double) and ($minValue castable as xs:double) and ($minValue cast as xs:double &gt; $Inhalt cast as xs:double)">
												<div class="Fehler E1072">Fehler!! E1072: Der Inhalt unterschreitet die untere Wertgrenze.</div>
											</xsl:if>
											<xsl:if test="$Inhalt != '' and $maxValue != '' and ($Inhalt castable as xs:double) and ($maxValue castable as xs:double) and ($maxValue cast as xs:double &lt; $Inhalt cast as xs:double)">
												<div class="Fehler E1073">Fehler!! E1073: Der Inhalt überschreitet die obere Wertgrenze.</div>
											</xsl:if>
										</xsl:when>
										<xsl:when test="$Element/xdf:datentyp/code/text() = 'num_int'">
											<xsl:if test="$Inhalt != '' and not($Inhalt castable as xs:integer)">
												<div class="Fehler E1070">Fehler!! E1070: Der Inhalt muss eine ganze Zahl sein.</div>
											</xsl:if>
											<xsl:if test="$Inhalt != '' and $minValue != '' and ($Inhalt castable as xs:integer) and ($minValue castable as xs:integer) and ($minValue cast as xs:integer &gt; $Inhalt cast as xs:integer)">
												<div class="Fehler E1072">Fehler!! E1072: Der Inhalt unterschreitet die untere Wertgrenze.</div>
											</xsl:if>
											<xsl:if test="$Inhalt != '' and $maxValue != '' and ($Inhalt castable as xs:integer) and ($maxValue castable as xs:integer) and ($maxValue cast as xs:integer &lt; $Inhalt cast as xs:integer)">
												<div class="Fehler E1073">Fehler!! E1073: Der Inhalt überschreitet die obere Wertgrenze.</div>
											</xsl:if>
										</xsl:when>
										<xsl:when test="$Element/xdf:datentyp/code/text() = 'date'">
											<xsl:if test="$Inhalt != '' and not($Inhalt castable as xs:date)">
												<div class="Fehler E1071">Fehler!! E1071: Der Inhalt muss ein Datum sein.</div>
											</xsl:if>
											<xsl:if test="$Inhalt != '' and $minValue != '' and ($Inhalt castable as xs:date) and ($minValue castable as xs:date) and ($minValue cast as xs:date &gt; $Inhalt cast as xs:date)">
												<div class="Fehler E1072">Fehler!! E1072: Der Inhalt unterschreitet die untere Wertgrenze.</div>
											</xsl:if>
											<xsl:if test="$Inhalt != '' and $maxValue != '' and ($Inhalt castable as xs:date) and ($maxValue castable as xs:date) and ($maxValue cast as xs:date &lt; $Inhalt cast as xs:date)">
												<div class="Fehler E1073">Fehler!! E1073: Der Inhalt überschreitet die obere Wertgrenze.</div>
											</xsl:if>
										</xsl:when>
										<xsl:when test="$Element/xdf:datentyp/code/text() = 'text'">
											<xsl:if test="$Inhalt != '' and ($minLength castable as xs:integer) and (fn:string-length($Inhalt) &lt; $minLength)">
												<div class="Fehler E1074">Fehler!! E1074: Der Inhalt unterschreitet die Minimallänge.</div>
											</xsl:if>
											<xsl:if test="$Inhalt != '' and ($maxLength castable as xs:integer) and (fn:string-length($Inhalt) &gt; $maxLength)">
												<div class="Fehler E1075">Fehler!! E1075: Der Inhalt überschreitet die Maximallänge.</div>
											</xsl:if>
										</xsl:when>
										<xsl:when test="$Element/xdf:datentyp/code/text() = 'bool'">
											<xsl:if test="$Inhalt != '' and not($Inhalt castable as xs:boolean)">
												<div class="Fehler E1077">Fehler!! E1077: Der Inhalt muss ein Wahrheitswert sein (true oder false).</div>
											</xsl:if>
										</xsl:when>
									</xsl:choose>
								</xsl:if>
							</td>
						</xsl:otherwise>
					</xsl:choose>
				</tr>
				<tr>
					<td>Beschreibung</td>
					<td>
						<xsl:value-of select="fn:replace($Element/xdf:beschreibung,'\n','&lt;br/&gt;')" disable-output-escaping="yes"/>
					</td>
				</tr>
				<tr>
					<td>Bezeichnung Eingabe</td>
					<xsl:choose>
						<xsl:when test="empty($Element/xdf:bezeichnungEingabe/text())">
							<td>
								<xsl:if test="$Meldungen = '1'">
									<div class="Fehler E1009">Fehler!! E1009: Die Bezeichnung Eingabe muss befüllt werden.</div>
								</xsl:if>
							</td>
						</xsl:when>
						<xsl:otherwise>
							<td>
								<xsl:value-of select="$Element/xdf:bezeichnungEingabe"/>
							</td>
						</xsl:otherwise>
					</xsl:choose>
				</tr>
				<tr>
					<td>Bezeichnung Ausgabe</td>
					<xsl:choose>
						<xsl:when test="empty($Element/xdf:bezeichnungAusgabe/text())">
							<td>
								<xsl:if test="$Meldungen = '1'">
									<div class="Fehler E1010">Fehler!! E1010: Die Bezeichnung Ausgabe muss befüllt werden.</div>
								</xsl:if>
							</td>
						</xsl:when>
						<xsl:otherwise>
							<td>
								<xsl:value-of select="$Element/xdf:bezeichnungAusgabe"/>
							</td>
						</xsl:otherwise>
					</xsl:choose>
				</tr>
				<tr>
					<td>Hilfetext Eingabe</td>
					<td>
						<xsl:value-of select="fn:replace($Element/xdf:hilfetextEingabe,'\n','&lt;br/&gt;')" disable-output-escaping="yes"/>
					</td>
				</tr>
				<tr>
					<td>Hilfetext Ausgabe</td>
					<td>
						<xsl:value-of select="fn:replace($Element/xdf:hilfetextAusgabe,'\n','&lt;br/&gt;')" disable-output-escaping="yes"/>
					</td>
				</tr>
				<tr>
					<td>Fachlicher Ersteller</td>
					<xsl:choose>
						<xsl:when test="empty($Element/xdf:fachlicherErsteller/text()) and $VersionsHinweise ='1'">
							<td>
								<xsl:value-of select="$Element/xdf:fachlicherErsteller"/>
								<xsl:if test="$Meldungen = '1'">
									<div class="Hinweis">Hinweis!! Der Fachliche Ersteller darf zur Versionierung oder Veröffentlichung nicht leer sein.</div>
								</xsl:if>
							</td>
						</xsl:when>
						<xsl:otherwise>
							<td>
								<xsl:value-of select="$Element/xdf:fachlicherErsteller"/>
							</td>
						</xsl:otherwise>
					</xsl:choose>
				</tr>
				<tr>
					<td>Status</td>
					<xsl:choose>
						<xsl:when test="$Element/xdf:status/code/text() != 'aktiv' and $VersionsHinweise ='1'">
							<td>
								<xsl:apply-templates select="$Element/xdf:status"/>
								<xsl:if test="$Meldungen = '1'">
									<div class="Hinweis">Hinweis!! Der Status muss zur Versionierung oder Veröffentlichung den Wert "aktiv" haben.</div>
								</xsl:if>
							</td>
						</xsl:when>
						<xsl:otherwise>
							<td>
								<xsl:apply-templates select="$Element/xdf:status"/>
							</td>
						</xsl:otherwise>
					</xsl:choose>
				</tr>
				<tr>
					<td>Gültig ab</td>
					<td>
						<xsl:value-of select="$Element/xdf:gueltigAb"/>
					</td>
				</tr>
				<tr>
					<td>Gültig bis</td>
					<td>
						<xsl:value-of select="$Element/xdf:gueltigBis"/>
					</td>
				</tr>
				<tr>
					<td>Freigabedatum</td>
					<td>
						<xsl:value-of select="$Element/xdf:freigabedatum"/>
					</td>
				</tr>
				<tr>
					<td>Veröffentlichungsdatum</td>
					<td>
						<xsl:value-of select="$Element/xdf:veroeffentlichungsdatum"/>
					</td>
				</tr>
				<!--
										<xsl:if test="$PrivateMode = '0'">
											<tr>
												<td>Letzter Bearbeiter</td>
												<td>
													<xsl:value-of select="./LetzterBearbeiter"/>
												</td>
											</tr>
											<tr>
												<td>Zeitpunkt der Erstellung</td>
												<td>
													<xsl:value-of select="./Erstelldatum"/>
												</td>
											</tr>
											<tr>
												<td>Zeitpunkt der letzten Änderung</td>
												<td>
													<xsl:value-of select="./LetztesAenderungsdatum"/>
												</td>
											</tr>
										</xsl:if>
-->
				<xsl:if test="count($Element/xdf:regel)">
					<tr>
						<td>
							<b>Regeln</b>
						</td>
						<td>
							<table>
								<thead>
									<tr>
										<th>ID</th>
										<th>Version</th>
										<th>Name</th>
										<th>Definition</th>
									</tr>
								</thead>
								<tbody>
									<xsl:for-each select="$Element/xdf:regel">
										<tr>
											<td>
												<xsl:choose>
													<xsl:when test="$InterneLinks = '1'">
														<xsl:element name="a">
															<xsl:attribute name="href">#<xsl:value-of select="./xdf:identifikation/xdf:id"/><xsl:if test="./xdf:identifikation/xdf:version">V<xsl:value-of select="./xdf:identifikation/xdf:version"/></xsl:if></xsl:attribute>
															<xsl:value-of select="./xdf:identifikation/xdf:id"/>
														</xsl:element>
													</xsl:when>
													<xsl:otherwise>
														<xsl:value-of select="./xdf:identifikation/xdf:id"/>
													</xsl:otherwise>
												</xsl:choose>
											</td>
											<td>
												<xsl:value-of select="./xdf:identifikation/xdf:version"/>
											</td>
											<td>
												<xsl:value-of select="./xdf:name"/>
											</td>
											<td>
												<xsl:value-of select="fn:replace(./xdf:definition,'\n','&lt;br/&gt;')" disable-output-escaping="yes"/>
												<xsl:if test="$Meldungen = '1'">
													<xsl:variable name="regellistedoppelte">
														<xdf:enthaltenebaukastenelemente>
															<xsl:analyze-string regex="[F|G]\d{{8}}" select="./xdf:definition">
																<xsl:matching-substring>
																	<xdf:elementid>
																		<xsl:value-of select="."/>
																	</xdf:elementid>
																</xsl:matching-substring>
																<xsl:non-matching-substring>
																							</xsl:non-matching-substring>
															</xsl:analyze-string>
														</xdf:enthaltenebaukastenelemente>
													</xsl:variable>
													<xsl:for-each-group select="$regellistedoppelte/*/xdf:elementid" group-by=".">
														<xsl:sort/>
														<xsl:variable name="TestElement">
															<xsl:value-of select="."/>
														</xsl:variable>
														<xsl:if test="fn:not($Element//xdf:identifikation[xdf:id/text() = $TestElement])">
															<div class="Fehler E1001">Fehler!! E1001: Die Regel kann auf kein Baukastenelement mit der ID <xsl:value-of select="$TestElement"/> zugreifen.</div>
														</xsl:if>
													</xsl:for-each-group>
													<xsl:variable name="regellisteversionen">
														<xdf:enthaltenebaukastenelemente>
															<xsl:analyze-string regex="[F|G]\d{{8}}V\d*\.\d*" select="./xdf:definition">
																<xsl:matching-substring>
																	<xdf:elementid>
																		<xsl:value-of select="."/>
																	</xdf:elementid>
																</xsl:matching-substring>
																<xsl:non-matching-substring>
																							</xsl:non-matching-substring>
															</xsl:analyze-string>
														</xdf:enthaltenebaukastenelemente>
													</xsl:variable>
													<xsl:for-each-group select="$regellisteversionen/*/xdf:elementid" group-by=".">
														<xsl:sort/>
														<div class="Fehler E1019">Fehler!! E1019: Baukastenelemente, die in Regeln referenziert werden, dürfen keine Versionsangaben beinhalten: <xsl:value-of select="."/>.</div>
													</xsl:for-each-group>
												</xsl:if>
											</td>
										</tr>
									</xsl:for-each>
								</tbody>
							</table>
						</td>
					</tr>
				</xsl:if>
				<!--
											<xsl:if test="count(Relationen/*)">
												<tr>
													<td>
														<b>Relationen</b>
													</td>
													<td>
														<table>
															<thead>
																<tr>
																	<th>ID</th>
																	<th>Version</th>
																	<th>Name</th>
																	<th>Bezeichnung</th>
																	<th>Art der Relation</th>
																	<th>Beschreibung der Relation</th>
																</tr>
															</thead>
															<tbody>
																<xsl:for-each select="./Relationen/Relation">
																	<xsl:variable name="RelationID" select="./xdf:id"/>
																	<xsl:variable name="Relation">
																		<xsl:copy-of select="$Daten/*/Formularfelder/Formularfeld[Id = $RelationID]"/>
																		<xsl:copy-of select="$Daten/*/Formularfeldgruppen/Formularfeldgruppe[Id = $RelationID]"/>
																	</xsl:variable>
																	<tr>
																		<td>
																			<xsl:element name="a">
																				<xsl:attribute name="href">#<xsl:value-of select="./xdf:id"/></xsl:attribute>
																				<xsl:value-of select="./xdf:id"/>
																			</xsl:element>
																		</td>
																		<td>
																			<xsl:value-of select="$Relation/*/xdf:version"/>
																		</td>
																		<td>
																			<xsl:value-of select="$Relation/*/xdf:name"/>
																		</td>
																		<td>
																			<xsl:value-of select="$Relation/*/Bezeichnung"/>
																		</td>
																		<td>
																			<xsl:value-of select="./Art"/>
																		</td>
																		<td>
																			<xsl:value-of select="./Beschreibung"/>
																		</td>
																	</tr>
																</xsl:for-each>
															</tbody>
														</table>
													</td>
												</tr>
											</xsl:if>
-->
				<tr>
					<td>
						<b>Verwendet in</b>
					</td>
					<xsl:variable name="FeldID" select="$Element/xdf:identifikation/xdf:id"/>
					<xsl:variable name="FeldVersion" select="$Element/xdf:identifikation/xdf:version"/>
					<td>
						<table>
							<thead>
								<tr>
									<th>ID</th>
									<th>Version</th>
									<th>Name</th>
									<th>Bezeichnung Eingabe</th>
								</tr>
							</thead>
							<tbody>
								<xsl:choose>
									<xsl:when test="not($Element/xdf:identifikation/xdf:version)">
										<xsl:for-each-group select="//xdf:datenfeldgruppe[xdf:struktur/xdf:enthaelt/xdf:datenfeld/xdf:identifikation/xdf:id = $FeldID]" group-by="concat(xdf:identifikation/xdf:id,xdf:identifikation/xdf:version)">
											<xsl:sort select="./xdf:identifikation/xdf:id"/>
											<xsl:sort select="./xdf:identifikation/xdf:version"/>
											<xsl:variable name="Elternelement" select="."/>
											<xsl:for-each-group select="fn:current-group()/xdf:struktur/xdf:enthaelt/xdf:datenfeld/xdf:identifikation[xdf:id = $FeldID and not(xdf:version)]" group-by="string(xdf:identifikation/xdf:version)">
												<xsl:sort select="./xdf:identifikation/xdf:version"/>
												<xsl:call-template name="minielementcore">
													<xsl:with-param name="Element" select="$Elternelement"/>
												</xsl:call-template>
											</xsl:for-each-group>
										</xsl:for-each-group>
										<xsl:for-each-group select="//xdf:stammdatenschema[xdf:struktur/xdf:enthaelt/xdf:datenfeld/xdf:identifikation/xdf:id = $FeldID]" group-by="concat(xdf:identifikation/xdf:id,xdf:identifikation/xdf:version)">
											<xsl:sort select="./xdf:identifikation/xdf:id"/>
											<xsl:sort select="./xdf:identifikation/xdf:version"/>
											<xsl:variable name="Elternelement" select="."/>
											<xsl:for-each-group select="fn:current-group()/xdf:struktur/xdf:enthaelt/xdf:datenfeld/xdf:identifikation[xdf:id = $FeldID and not(xdf:version)]" group-by="string(xdf:identifikation/xdf:version)">
												<xsl:sort select="./xdf:identifikation/xdf:version"/>
												<xsl:call-template name="minielementcore">
													<xsl:with-param name="Element" select="$Elternelement"/>
												</xsl:call-template>
											</xsl:for-each-group>
										</xsl:for-each-group>
									</xsl:when>
									<xsl:otherwise>
										<xsl:for-each-group select="//xdf:datenfeldgruppe[xdf:struktur/xdf:enthaelt/xdf:datenfeld/xdf:identifikation/xdf:id = $FeldID]" group-by="concat(xdf:identifikation/xdf:id,xdf:identifikation/xdf:version)">
											<xsl:sort select="./xdf:identifikation/xdf:id"/>
											<xsl:sort select="./xdf:identifikation/xdf:version"/>
											<xsl:variable name="Elternelement" select="."/>
											<xsl:for-each-group select="fn:current-group()/xdf:struktur/xdf:enthaelt/xdf:datenfeld/xdf:identifikation[xdf:id = $FeldID and xdf:version = $FeldVersion]" group-by="string(xdf:identifikation/xdf:version)">
												<xsl:sort select="./xdf:identifikation/xdf:version"/>
												<xsl:call-template name="minielementcore">
													<xsl:with-param name="Element" select="$Elternelement"/>
												</xsl:call-template>
											</xsl:for-each-group>
										</xsl:for-each-group>
										<xsl:for-each-group select="//xdf:stammdatenschema[xdf:struktur/xdf:enthaelt/xdf:datenfeld/xdf:identifikation/xdf:id = $FeldID]" group-by="concat(xdf:identifikation/xdf:id,xdf:identifikation/xdf:version)">
											<xsl:sort select="./xdf:identifikation/xdf:id"/>
											<xsl:sort select="./xdf:identifikation/xdf:version"/>
											<xsl:variable name="Elternelement" select="."/>
											<xsl:for-each-group select="fn:current-group()/xdf:struktur/xdf:enthaelt/xdf:datenfeld/xdf:identifikation[xdf:id = $FeldID and xdf:version = $FeldVersion]" group-by="string(xdf:identifikation/xdf:version)">
												<xsl:sort select="./xdf:identifikation/xdf:version"/>
												<xsl:call-template name="minielementcore">
													<xsl:with-param name="Element" select="$Elternelement"/>
												</xsl:call-template>
											</xsl:for-each-group>
										</xsl:for-each-group>
									</xsl:otherwise>
								</xsl:choose>
							</tbody>
						</table>
					</td>
				</tr>
			</xsl:when>
			<xsl:when test="$Element/name() = 'xdf:datenfeldgruppe'">
				<tr>
					<td>
						<xsl:element name="a">
							<xsl:attribute name="name"><xsl:value-of select="$Element/xdf:identifikation/xdf:id"/><xsl:if test="$Element/xdf:identifikation/xdf:version">V<xsl:value-of select="$Element/xdf:identifikation/xdf:version"/></xsl:if></xsl:attribute>
						</xsl:element>
													ID
												</td>
					<xsl:choose>
						<xsl:when test="empty($Element/xdf:identifikation/xdf:id/text())">
							<td class="ElementID">
								<xsl:if test="$Meldungen = '1'">
									<div class="Fehler E1038">Fehler!! E1038: Die ID muss befüllt werden.</div>
								</xsl:if>
							</td>
						</xsl:when>
						<xsl:otherwise>
							<td class="ElementID">
								<xsl:value-of select="$Element/xdf:identifikation/xdf:id"/>
								<xsl:analyze-string regex="^G\d{{8}}$" select="$Element/xdf:identifikation/xdf:id">
									<xsl:matching-substring>
										<xsl:if test="$ToolAufruf = '1'">
																		&#160;&#160;
																		<xsl:element name="a">
												<xsl:attribute name="href"><xsl:value-of select="$ToolPfadPrefix"/><xsl:value-of select="$Element/xdf:identifikation/xdf:id"/><xsl:if test="$Element/xdf:identifikation/xdf:version">V<xsl:value-of select="$Element/xdf:identifikation/xdf:version"/></xsl:if><xsl:value-of select="$ToolPfadPostfix"/></xsl:attribute>
												<xsl:attribute name="target">FIMTool</xsl:attribute>
												<xsl:attribute name="title">Springe in den Datenfeldeditor (man muss vorher angemeldet sein).</xsl:attribute>
																			&#8658;
																		</xsl:element>
										</xsl:if>
									</xsl:matching-substring>
									<xsl:non-matching-substring>
										<xsl:if test="$Meldungen = '1'">
											<div class="Fehler E1039">Fehler!! E1039: Die ID entspricht nicht den Formatvorgaben.</div>
										</xsl:if>
									</xsl:non-matching-substring>
								</xsl:analyze-string>
							</td>
						</xsl:otherwise>
					</xsl:choose>
				</tr>
				<tr>
					<td>Version</td>
					<xsl:choose>
						<xsl:when test="$VersionsAnzahl &gt; 1">
							<td>
								<xsl:value-of select="$Element/xdf:identifikation/xdf:version"/>
								<xsl:if test="$Meldungen = '1'">
									<div class="Fehler E1003">Fehler!! E1003: In einem Datenschema darf ein Baukastenelement nicht mehrfach in unterschiedlichen Versionen enthalten sein.</div>
								</xsl:if>
							</td>
						</xsl:when>
						<xsl:otherwise>
							<td>
								<xsl:value-of select="$Element/xdf:identifikation/xdf:version"/>
							</td>
						</xsl:otherwise>
					</xsl:choose>
				</tr>
				<tr>
					<td>Name</td>
					<xsl:choose>
						<xsl:when test="empty($Element/xdf:name/text())">
							<td class="ElementName">
								<xsl:if test="$Meldungen = '1'">
									<div class="Fehler E1002">Fehler!! E1002: Der Name muss befüllt werden.</div>
								</xsl:if>
							</td>
						</xsl:when>
						<xsl:otherwise>
							<td class="ElementName">
								<xsl:value-of select="$Element/xdf:name"/>
							</td>
						</xsl:otherwise>
					</xsl:choose>
				</tr>
				<tr>
					<td>Definition</td>
					<td>
						<xsl:value-of select="fn:replace($Element/xdf:definition,'\n','&lt;br/&gt;')" disable-output-escaping="yes"/>
					</td>
				</tr>
				<tr>
					<td>Strukturelementart</td>
					<td>
						<xsl:apply-templates select="$Element/xdf:schemaelementart"/>
					</td>
				</tr>
				<tr>
					<td>Handlungsgrundlagen</td>
					<xsl:choose>
						<xsl:when test="$Element/xdf:schemaelementart/code/text() = 'RNG' and empty($Element/xdf:bezug/text())">
							<td>
								<xsl:if test="$Meldungen = '1'">
									<div class="Fehler E1006">Fehler!! E1006: Der Bezug zur Handlungsgrundlage darf bei Elementen mit der Strukturelementart 'rechtsnormgebunden' nicht leer sein.</div>
								</xsl:if>
							</td>
						</xsl:when>
						<xsl:when test="$Element/xdf:schemaelementart/code/text() = 'HAR' and empty($Element/xdf:bezug/text())">
							<td>
								<xsl:if test="$Meldungen = '1'">
									<div class="Warnung W1001">Warnung!! W1001: Der Bezug zur Handlungsgrundlage sollte bei Elementen mit der Strukturelementart 'harmonisiert' möglichst nicht leer sein.</div>
								</xsl:if>
							</td>
						</xsl:when>
						<xsl:otherwise>
							<td>
								<xsl:value-of select="$Element/xdf:bezug"/>
							</td>
						</xsl:otherwise>
					</xsl:choose>
				</tr>
				<tr>
					<td>Beschreibung</td>
					<td>
						<xsl:value-of select="fn:replace($Element/xdf:beschreibung,'\n','&lt;br/&gt;')" disable-output-escaping="yes"/>
					</td>
				</tr>
				<tr>
					<td>Bezeichnung Eingabe</td>
					<xsl:choose>
						<xsl:when test="empty($Element/xdf:bezeichnungEingabe/text())">
							<td>
								<xsl:if test="$Meldungen = '1'">
									<div class="Fehler E1009">Fehler!! E1009: Die Bezeichnung Eingabe muss befüllt werden.</div>
								</xsl:if>
							</td>
						</xsl:when>
						<xsl:otherwise>
							<td>
								<xsl:value-of select="$Element/xdf:bezeichnungEingabe"/>
							</td>
						</xsl:otherwise>
					</xsl:choose>
				</tr>
				<tr>
					<td>Bezeichnung Ausgabe</td>
					<xsl:choose>
						<xsl:when test="empty($Element/xdf:bezeichnungAusgabe/text())">
							<td>
								<xsl:if test="$Meldungen = '1'">
									<div class="Fehler E1010">Fehler!! E1010: Die Bezeichnung Ausgabe muss befüllt werden.</div>
								</xsl:if>
							</td>
						</xsl:when>
						<xsl:otherwise>
							<td>
								<xsl:value-of select="$Element/xdf:bezeichnungAusgabe"/>
							</td>
						</xsl:otherwise>
					</xsl:choose>
				</tr>
				<tr>
					<td>Hilfetext Eingabe</td>
					<td>
						<xsl:value-of select="fn:replace($Element/xdf:hilfetextEingabe,'\n','&lt;br/&gt;')" disable-output-escaping="yes"/>
					</td>
				</tr>
				<tr>
					<td>Hilfetext Ausgabe</td>
					<td>
						<xsl:value-of select="fn:replace($Element/xdf:hilfetextAusgabe,'\n','&lt;br/&gt;')" disable-output-escaping="yes"/>
					</td>
				</tr>
				<tr>
					<td>Fachlicher Ersteller</td>
					<xsl:choose>
						<xsl:when test="empty($Element/xdf:fachlicherErsteller/text()) and $VersionsHinweise ='1'">
							<td>
								<xsl:value-of select="$Element/xdf:fachlicherErsteller"/>
								<xsl:if test="$Meldungen = '1'">
									<div class="Hinweis">Hinweis!! Der Fachliche Ersteller darf zur Versionierung oder Veröffentlichung nicht leer sein.</div>
								</xsl:if>
							</td>
						</xsl:when>
						<xsl:otherwise>
							<td>
								<xsl:value-of select="$Element/xdf:fachlicherErsteller"/>
							</td>
						</xsl:otherwise>
					</xsl:choose>
				</tr>
				<tr>
					<td>Status</td>
					<xsl:choose>
						<xsl:when test="$Element/xdf:status/code/text() != 'aktiv' and $VersionsHinweise ='1'">
							<td>
								<xsl:apply-templates select="$Element/xdf:status"/>
								<xsl:if test="$Meldungen = '1'">
									<div class="Hinweis">Hinweis!! Der Status muss zur Versionierung oder Veröffentlichung den Wert 'aktiv' haben.</div>
								</xsl:if>
							</td>
						</xsl:when>
						<xsl:otherwise>
							<td>
								<xsl:apply-templates select="$Element/xdf:status"/>
							</td>
						</xsl:otherwise>
					</xsl:choose>
				</tr>
				<tr>
					<td>Gültig ab</td>
					<td>
						<xsl:value-of select="$Element/xdf:gueltigAb"/>
					</td>
				</tr>
				<tr>
					<td>Gültig bis</td>
					<td>
						<xsl:value-of select="$Element/xdf:gueltigBis"/>
					</td>
				</tr>
				<tr>
					<td>Freigabedatum</td>
					<td>
						<xsl:value-of select="$Element/xdf:freigabedatum"/>
					</td>
				</tr>
				<tr>
					<td>Veröffentlichungsdatum</td>
					<td>
						<xsl:value-of select="$Element/xdf:veroeffentlichungsdatum"/>
					</td>
				</tr>
				<!--
										<xsl:if test="$PrivateMode = '0'">
											<tr>
												<td>Letzter Bearbeiter</td>
												<td>
													<xsl:value-of select="./LetzterBearbeiter"/>
												</td>
											</tr>
											<tr>
												<td>Zeitpunkt der Erstellung</td>
												<td>
													<xsl:value-of select="./Erstelldatum"/>
												</td>
											</tr>
											<tr>
												<td>Zeitpunkt der letzten Änderung</td>
												<td>
													<xsl:value-of select="./LetztesAenderungsdatum"/>
												</td>
											</tr>
										</xsl:if>
-->
				<tr>
					<xsl:variable name="AnzahlUnterelemente" select="count($Element/xdf:struktur)"/>
					<td>
						<b>Unterelemente</b>
						<xsl:if test="$AnzahlUnterelemente = 1 and $Meldungen = '1'">
							<div class="Warnung W1006">Warnung!! W1006: Eine Datenfeldgruppe sollte mehr als ein Unterelement haben.</div>
						</xsl:if>
					</td>
					<xsl:choose>
						<xsl:when test="$AnzahlUnterelemente &gt; 0">
							<td>
								<table>
									<thead>
										<tr>
											<th>ID</th>
											<th>Version</th>
											<th>Name</th>
											<th>Bezeichnung Eingabe</th>
											<th>Strukturart</th>
											<th>Status</th>
											<th>Multiplizität</th>
											<th>Handlungsgrundlagen</th>
										</tr>
									</thead>
									<tbody>
										<xsl:variable name="Strukturelementart">
											<xsl:value-of select="./xdf:schemaelementart/code"/>
										</xsl:variable>
										<xsl:for-each select="$Element/xdf:struktur">
											<xsl:variable name="VergleichsElement">
												<xsl:value-of select="./xdf:enthaelt/*/xdf:identifikation/xdf:id"/>
											</xsl:variable>
											<xsl:variable name="VergleichsVersion">
												<xsl:value-of select="./xdf:enthaelt/*/xdf:identifikation/xdf:version"/>
											</xsl:variable>
											<tr>
												<td>
													<xsl:choose>
														<xsl:when test="empty(./xdf:enthaelt/*/xdf:identifikation/xdf:id/text())">
															<xsl:if test="$Meldungen = '1'">
																<div class="Fehler E1038">Fehler!! E1038: Die ID muss befüllt werden.</div>
															</xsl:if>
														</xsl:when>
														<xsl:otherwise>
															<xsl:choose>
																<xsl:when test="$InterneLinks = '1'">
																	<xsl:element name="a">
																		<xsl:attribute name="href">#<xsl:value-of select="./xdf:enthaelt/*/xdf:identifikation/xdf:id"/><xsl:if test="./xdf:enthaelt/*/xdf:identifikation/xdf:version">V<xsl:value-of select="./xdf:enthaelt/*/xdf:identifikation/xdf:version"/></xsl:if></xsl:attribute>
																		<xsl:value-of select="./xdf:enthaelt/*/xdf:identifikation/xdf:id"/>
																	</xsl:element>
																</xsl:when>
																<xsl:otherwise>
																	<xsl:value-of select="./xdf:enthaelt/*/xdf:identifikation/xdf:id"/>
																</xsl:otherwise>
															</xsl:choose>
														</xsl:otherwise>
													</xsl:choose>
													<xsl:choose>
														<xsl:when test="$VergleichsVersion = ''">
															<xsl:if test="count($Element/xdf:struktur/./xdf:enthaelt/*/xdf:identifikation[xdf:id=$VergleichsElement and not(xdf:version)]) &gt; 1">
																<xsl:if test="$Meldungen = '1'">
																	<div class="Fehler E1004">Fehler!! E1004: In einer Datenfeldgruppe darf ein Baukastenelement nicht mehrfach in derselben Version enthalten sein.</div>
																</xsl:if>
															</xsl:if>
														</xsl:when>
														<xsl:otherwise>
															<xsl:if test="count($Element/xdf:struktur/./xdf:enthaelt/*/xdf:identifikation[xdf:id=$VergleichsElement and xdf:version=$VergleichsVersion]) &gt; 1">
																<xsl:if test="$Meldungen = '1'">
																	<div class="Fehler E1004">Fehler!! E1004: In einer Datenfeldgruppe darf ein Baukastenelement nicht mehrfach in derselben Version enthalten sein.</div>
																</xsl:if>
															</xsl:if>
														</xsl:otherwise>
													</xsl:choose>
												</td>
												<xsl:choose>
													<xsl:when test="empty(./xdf:enthaelt/*/xdf:identifikation/xdf:version/text()) and $VersionsHinweise ='1'">
														<td>
															<xsl:value-of select="./xdf:enthaelt/*/xdf:identifikation/xdf:version"/>
															<xsl:if test="$Meldungen = '1'">
																<div class="Hinweis">Hinweis!! Zur Versionierung und Veröffentlichung müssen alle verwendete Unterelemente versioniert sein.</div>
															</xsl:if>
														</td>
													</xsl:when>
													<xsl:otherwise>
														<td>
															<xsl:value-of select="./xdf:enthaelt/*/xdf:identifikation/xdf:version"/>
														</td>
													</xsl:otherwise>
												</xsl:choose>
												<td>
													<xsl:value-of select="./xdf:enthaelt/*/xdf:name"/>
												</td>
												<td>
													<xsl:value-of select="./xdf:enthaelt/*/xdf:bezeichnungEingabe"/>
												</td>
												<xsl:choose>
													<xsl:when test="./xdf:enthaelt/*/xdf:schemaelementart/code/text() = 'ABS' and $AbstraktWarnung = '1'">
														<td>
															<xsl:apply-templates select="./xdf:enthaelt/*/xdf:schemaelementart"/>
															<xsl:if test="$Meldungen = '1'">
																<div class="Fehler E1013">Fehler!! E1013: Innerhalb von Datenschemata und Datenfeldgruppen dürfen nur Elemente mit der Strukturelementart 'harmonisiert' oder 'rechtnormgebunden' verwendet werden.</div>
															</xsl:if>
														</td>
													</xsl:when>
													<xsl:otherwise>
														<td>
															<xsl:apply-templates select="./xdf:enthaelt/*/xdf:schemaelementart"/>
														</td>
													</xsl:otherwise>
												</xsl:choose>
												<xsl:choose>
													<xsl:when test="./xdf:enthaelt/*/xdf:status/code/text() = 'inaktiv'">
														<td>
															<xsl:apply-templates select="./xdf:enthaelt/*/xdf:status"/>
															<xsl:if test="$Meldungen = '1'">
																<div class="Warnung W1016">Warnung!! W1016: Baukastenelemente im Status 'inaktiv' sollten nur in Ausnahmefällen verwendet werden.</div>
															</xsl:if>
														</td>
													</xsl:when>
													<xsl:otherwise>
														<td>
															<xsl:apply-templates select="./xdf:enthaelt/*/xdf:status"/>
														</td>
													</xsl:otherwise>
												</xsl:choose>
												<xsl:choose>
													<xsl:when test="$Meldungen = '1'">
														<td>
															<xsl:value-of select="./xdf:anzahl"/>
															<xsl:variable name="AnzahlText" select="./xdf:anzahl/text()"/>
															<xsl:variable name="minCount" select="fn:substring-before(./xdf:anzahl/text(),':')"/>
															<xsl:variable name="maxCount" select="fn:substring-after(./xdf:anzahl/text(),':')"/>
															<xsl:analyze-string regex="^\d{{1,}}:[\d{{1,}}|*]$" select="./xdf:anzahl">
																<xsl:matching-substring>
																	<xsl:if test="$AnzahlText = '0:0'">
																		<div class="Fehler E1021">Fehler!! E1021: Es ist keine Multiplizität angegeben.</div>
																	</xsl:if>
																	<xsl:if test="(fn:number($minCount) &gt; fn:number($maxCount)) and $maxCount != '*'">
																		<div class="Fehler E1047">Fehler!! E1047: In der Multiplizität muss die minimale Anzahl kleiner oder gleich der maximalen Anzahl sein.</div>
																	</xsl:if>
																</xsl:matching-substring>
																<xsl:non-matching-substring>
																	<xsl:if test="$Meldungen = '1'">
																		<div class="Fehler E1046">Fehler!! E1046: Die Multiplizität entspricht nicht den Formatvorgaben.</div>
																	</xsl:if>
																</xsl:non-matching-substring>
															</xsl:analyze-string>
														</td>
													</xsl:when>
													<xsl:otherwise>
														<td>
															<xsl:value-of select="./xdf:anzahl"/>
														</td>
													</xsl:otherwise>
												</xsl:choose>
												<xsl:choose>
													<xsl:when test="$Strukturelementart ='RNG' and (./xdf:enthaelt/*/xdf:schemaelementart/code/text() = 'ABS' or ./xdf:enthaelt/*/xdf:schemaelementart/code/text() = 'HAR') and empty(./xdf:bezug/text())">
														<td>
															<xsl:if test="$Meldungen = '1'">
																<div class="Fehler E1022">Fehler!! E1022: Bei Verwendung von Elementen mit der Strukturelementart 'abstrakt' oder 'harmonisiert' innerhalb von Datenfeldgruppen mit der Strukturelementart 'rechtsnormgebunden' muss zur Multiplizität ein Bezug zu einer Handlungsgrundlage angegeben werden.</div>
															</xsl:if>
														</td>
													</xsl:when>
													<xsl:otherwise>
														<td>
															<xsl:value-of select="./xdf:bezug"/>
														</td>
													</xsl:otherwise>
												</xsl:choose>
											</tr>
										</xsl:for-each>
									</tbody>
								</table>
							</td>
						</xsl:when>
						<xsl:otherwise>
							<td>
								<xsl:if test="$Meldungen = '1'">
									<div class="Fehler E1023">Fehler!! E1023: Datenfeldgruppe hat keine Unterelemente.</div>
								</xsl:if>
							</td>
						</xsl:otherwise>
					</xsl:choose>
				</tr>
				<xsl:if test="count($Element/xdf:regel)">
					<tr>
						<td>
							<b>Regeln</b>
						</td>
						<td>
							<table>
								<thead>
									<tr>
										<th>ID</th>
										<th>Version</th>
										<th>Name</th>
										<th>Definition</th>
									</tr>
								</thead>
								<tbody>
									<xsl:for-each select="$Element/xdf:regel">
										<tr>
											<td>
												<xsl:choose>
													<xsl:when test="$InterneLinks = '1'">
														<xsl:element name="a">
															<xsl:attribute name="href">#<xsl:value-of select="./xdf:identifikation/xdf:id"/><xsl:if test="./xdf:identifikation/xdf:version">V<xsl:value-of select="./xdf:identifikation/xdf:version"/></xsl:if></xsl:attribute>
															<xsl:value-of select="./xdf:identifikation/xdf:id"/>
														</xsl:element>
													</xsl:when>
													<xsl:otherwise>
														<xsl:value-of select="./xdf:identifikation/xdf:id"/>
													</xsl:otherwise>
												</xsl:choose>
											</td>
											<td>
												<xsl:value-of select="./xdf:identifikation/xdf:version"/>
											</td>
											<td>
												<xsl:value-of select="./xdf:name"/>
											</td>
											<td>
												<xsl:value-of select="fn:replace(./xdf:definition,'\n','&lt;br/&gt;')" disable-output-escaping="yes"/>
												<xsl:if test="$Meldungen = '1'">
													<xsl:variable name="regellistedoppelte">
														<xdf:enthaltenebaukastenelemente>
															<xsl:analyze-string regex="[F|G]\d{{8}}" select="./xdf:definition">
																<xsl:matching-substring>
																	<xdf:elementid>
																		<xsl:value-of select="."/>
																	</xdf:elementid>
																</xsl:matching-substring>
																<xsl:non-matching-substring>
																							</xsl:non-matching-substring>
															</xsl:analyze-string>
														</xdf:enthaltenebaukastenelemente>
													</xsl:variable>
													<xsl:for-each-group select="$regellistedoppelte/*/xdf:elementid" group-by=".">
														<xsl:sort/>
														<xsl:variable name="TestElement">
															<xsl:value-of select="."/>
														</xsl:variable>
														<xsl:if test="fn:not($Element//xdf:identifikation[xdf:id/text() = $TestElement])">
															<div class="Fehler E1001">Fehler!! E1001: Die Regel kann auf kein Baukastenelement mit der ID <xsl:value-of select="$TestElement"/> zugreifen.</div>
														</xsl:if>
													</xsl:for-each-group>
													<xsl:variable name="regellisteversionen">
														<xdf:enthaltenebaukastenelemente>
															<xsl:analyze-string regex="[F|G]\d{{8}}V\d*\.\d*" select="./xdf:definition">
																<xsl:matching-substring>
																	<xdf:elementid>
																		<xsl:value-of select="."/>
																	</xdf:elementid>
																</xsl:matching-substring>
																<xsl:non-matching-substring>
																							</xsl:non-matching-substring>
															</xsl:analyze-string>
														</xdf:enthaltenebaukastenelemente>
													</xsl:variable>
													<xsl:for-each-group select="$regellisteversionen/*/xdf:elementid" group-by=".">
														<xsl:sort/>
														<div class="Fehler E1019">Fehler!! E1019: Baukastenelemente, die in Regeln referenziert werden, dürfen keine Versionsangaben beinhalten: <xsl:value-of select="."/>.</div>
													</xsl:for-each-group>
												</xsl:if>
											</td>
										</tr>
									</xsl:for-each>
								</tbody>
							</table>
						</td>
					</tr>
				</xsl:if>
				<!--
											<xsl:if test="count(Relationen/*)">
												<tr>
													<td>
														<b>Relationen</b>
													</td>
													<td>
														<table>
															<thead>
																<tr>
																	<th>ID</th>
																	<th>Version</th>
																	<th>Name</th>
																	<th>Bezeichnung</th>
																	<th>Art der Relation</th>
																	<th>Beschreibung der Relation</th>
																</tr>
															</thead>
															<tbody>
																<xsl:for-each select="./Relationen/Relation">
																	<xsl:variable name="RelationID" select="./xdf:id"/>
																	<xsl:variable name="Element">
																		<xsl:copy-of select="$Daten/*/Formularfelder/Formularfeld[Id = $RelationID]"/>
																		<xsl:copy-of select="$Daten/*/Formularfeldgruppen/Formularfeldgruppe[Id = $RelationID]"/>
																	</xsl:variable>
																	<tr>
																		<td>
																			<xsl:element name="a">
																				<xsl:attribute name="href">#<xsl:value-of select="./xdf:id"/></xsl:attribute>
																				<xsl:value-of select="./xdf:id"/>
																			</xsl:element>
																		</td>
																		<td>
																			<xsl:value-of select="$Element/*/xdf:version"/>
																		</td>
																		<td>
																			<xsl:value-of select="$Element/*/xdf:name"/>
																		</td>
																		<td>
																			<xsl:value-of select="$Element/*/Bezeichnung"/>
																		</td>
																		<td>
																			<xsl:value-of select="./Art"/>
																		</td>
																		<td>
																			<xsl:value-of select="./Beschreibung"/>
																		</td>
																	</tr>
																</xsl:for-each>
															</tbody>
														</table>
													</td>
												</tr>
											</xsl:if>
-->
				<tr>
					<td>
						<b>Verwendet in</b>
					</td>
					<xsl:variable name="FeldgruppenID" select="$Element/xdf:identifikation/xdf:id"/>
					<xsl:variable name="FeldgruppenVersion" select="$Element/xdf:identifikation/xdf:version"/>
					<td>
						<table>
							<thead>
								<tr>
									<th>ID</th>
									<th>Version</th>
									<th>Name</th>
									<th>Bezeichnung Eingabe</th>
								</tr>
							</thead>
							<tbody>
								<xsl:choose>
									<xsl:when test="not($Element/xdf:identifikation/xdf:version)">
										<xsl:for-each-group select="//xdf:datenfeldgruppe[xdf:struktur/xdf:enthaelt/xdf:datenfeldgruppe/xdf:identifikation/xdf:id = $FeldgruppenID]" group-by="concat(xdf:identifikation/xdf:id,xdf:identifikation/xdf:version)">
											<xsl:sort select="./xdf:identifikation/xdf:id"/>
											<xsl:sort select="./xdf:identifikation/xdf:version"/>
											<xsl:variable name="Elternelement" select="."/>
											<xsl:for-each-group select="fn:current-group()/xdf:struktur/xdf:enthaelt/xdf:datenfeldgruppe/xdf:identifikation[xdf:id = $FeldgruppenID and not(xdf:version)]" group-by="string(xdf:identifikation/xdf:version)">
												<xsl:sort select="./xdf:identifikation/xdf:version"/>
												<xsl:if test="current-grouping-key()=''">
													<xsl:call-template name="minielementcore">
														<xsl:with-param name="Element" select="$Elternelement"/>
													</xsl:call-template>
												</xsl:if>
											</xsl:for-each-group>
										</xsl:for-each-group>
										<xsl:for-each-group select="//xdf:stammdatenschema[xdf:struktur/xdf:enthaelt/xdf:datenfeldgruppe/xdf:identifikation/xdf:id = $FeldgruppenID]" group-by="concat(xdf:identifikation/xdf:id,xdf:identifikation/xdf:version)">
											<xsl:sort select="./xdf:identifikation/xdf:id"/>
											<xsl:sort select="./xdf:identifikation/xdf:version"/>
											<xsl:variable name="Elternelement" select="."/>
											<xsl:for-each-group select="fn:current-group()/xdf:struktur/xdf:enthaelt/xdf:datenfeldgruppe/xdf:identifikation[xdf:id = $FeldgruppenID and not(xdf:version)]" group-by="string(xdf:identifikation/xdf:version)">
												<xsl:sort select="./xdf:identifikation/xdf:version"/>
												<xsl:if test="current-grouping-key()=''">
													<xsl:call-template name="minielementcore">
														<xsl:with-param name="Element" select="$Elternelement"/>
													</xsl:call-template>
												</xsl:if>
											</xsl:for-each-group>
										</xsl:for-each-group>
									</xsl:when>
									<xsl:otherwise>
										<xsl:for-each-group select="//xdf:datenfeldgruppe[xdf:struktur/xdf:enthaelt/xdf:datenfeldgruppe/xdf:identifikation/xdf:id = $FeldgruppenID]" group-by="concat(xdf:identifikation/xdf:id,xdf:identifikation/xdf:version)">
											<xsl:sort select="./xdf:identifikation/xdf:id"/>
											<xsl:sort select="./xdf:identifikation/xdf:version"/>
											<xsl:variable name="Elternelement" select="."/>
											<xsl:for-each-group select="fn:current-group()/xdf:struktur/xdf:enthaelt/xdf:datenfeldgruppe/xdf:identifikation[xdf:id = $FeldgruppenID and xdf:version=$FeldgruppenVersion]" group-by="string(xdf:identifikation/xdf:version)">
												<xsl:sort select="./xdf:identifikation/xdf:version"/>
												<xsl:call-template name="minielementcore">
													<xsl:with-param name="Element" select="$Elternelement"/>
												</xsl:call-template>
											</xsl:for-each-group>
										</xsl:for-each-group>
										<xsl:for-each-group select="//xdf:stammdatenschema[xdf:struktur/xdf:enthaelt/xdf:datenfeldgruppe/xdf:identifikation/xdf:id = $FeldgruppenID]" group-by="concat(xdf:identifikation/xdf:id,xdf:identifikation/xdf:version)">
											<xsl:sort select="./xdf:identifikation/xdf:id"/>
											<xsl:sort select="./xdf:identifikation/xdf:version"/>
											<xsl:variable name="Elternelement" select="."/>
											<xsl:for-each-group select="fn:current-group()/xdf:struktur/xdf:enthaelt/xdf:datenfeldgruppe/xdf:identifikation[xdf:id = $FeldgruppenID and xdf:version=$FeldgruppenVersion]" group-by="string(xdf:identifikation/xdf:version)">
												<xsl:sort select="./xdf:identifikation/xdf:version"/>
												<xsl:call-template name="minielementcore">
													<xsl:with-param name="Element" select="$Elternelement"/>
												</xsl:call-template>
											</xsl:for-each-group>
										</xsl:for-each-group>
									</xsl:otherwise>
								</xsl:choose>
							</tbody>
						</table>
					</td>
				</tr>
			</xsl:when>
		</xsl:choose>
		<tr style="page-break-after:always">
			<td colspan="2" class="Navigation">
				<xsl:call-template name="navigationszeile"/>
			</td>
		</tr>
	</xsl:template>
	<!-- ############################################################################################################# -->
	<xsl:template name="listeregeldetailszubaukasten">
		<xsl:if test="$DebugMode = '1' or $DebugMode = '2' or $DebugMode = '3' or $DebugMode = '4'">
			<xsl:message>
				++++ listeregeldetailszubaukasten ++++
			</xsl:message>
		</xsl:if>
		<h2>
			<br/>
		</h2>
		<h2>
			<a name="RegelDetails"/>Details zu den Regeln
					</h2>
		<table style="page-break-after:always">
			<thead>
				<tr>
					<th>Metadatum</th>
					<th>Inhalt</th>
				</tr>
			</thead>
			<tbody>
				<xsl:for-each-group select="//xdf:regel" group-by="xdf:identifikation/xdf:id">
					<xsl:sort select="./xdf:identifikation/xdf:id"/>
					<xsl:for-each-group select="fn:current-group()" group-by="string(xdf:identifikation/xdf:version)">
						<xsl:sort select="./xdf:identifikation/xdf:version"/>
						<xsl:call-template name="regeldetails">
							<xsl:with-param name="Element" select="."/>
						</xsl:call-template>
					</xsl:for-each-group>
				</xsl:for-each-group>
			</tbody>
		</table>
	</xsl:template>
	<!-- ############################################################################################################# -->
	<xsl:template name="listeregeldetailszustammdatenschema">
		<xsl:if test="$DebugMode = '1' or $DebugMode = '2' or $DebugMode = '3' or $DebugMode = '4'">
			<xsl:message>
				++++ listeregeldetailszustammdatenschema ++++
			</xsl:message>
		</xsl:if>
		<h2>
			<br/>
		</h2>
		<h2>
			<a name="RegelDetails"/>Details zu den Regeln des Datenschemas <xsl:value-of select="/*/xdf:stammdatenschema/xdf:identifikation/xdf:id"/>
			<xsl:if test="/*/xdf:stammdatenschema/xdf:identifikation/xdf:version"> Version <xsl:value-of select="/*/xdf:stammdatenschema/xdf:identifikation/xdf:version"/>
			</xsl:if>
		</h2>
		<table style="page-break-after:always">
			<thead>
				<tr>
					<th>Metadatum</th>
					<th>Inhalt</th>
				</tr>
			</thead>
			<tbody>
				<xsl:for-each-group select="//xdf:regel" group-by="xdf:identifikation/xdf:id">
					<xsl:sort select="./xdf:identifikation/xdf:id"/>
					<xsl:for-each-group select="fn:current-group()" group-by="string(xdf:identifikation/xdf:version)">
						<xsl:sort select="./xdf:identifikation/xdf:version"/>
						<xsl:call-template name="regeldetails">
							<xsl:with-param name="Element" select="."/>
						</xsl:call-template>
					</xsl:for-each-group>
				</xsl:for-each-group>
			</tbody>
		</table>
	</xsl:template>
	<!-- ############################################################################################################# -->
	<xsl:template name="regeldetails">
		<xsl:param name="Element"/>
		<xsl:if test="$DebugMode = '2' or $DebugMode = '3' or $DebugMode = '4'">
			<xsl:message>
				++++++++ regeldetails ++++++++
			</xsl:message>
		</xsl:if>
		<xsl:if test="$DebugMode = '3' or $DebugMode = '4'">
			<xsl:message>
				-------- <xsl:value-of select="$Element/xdf:identifikation/xdf:id"/>
				<xsl:if test="$Element/xdf:identifikation/xdf:version">V<xsl:value-of select="$Element/xdf:identifikation/xdf:version"/>
				</xsl:if> --------
			</xsl:message>
		</xsl:if>
		<tr>
			<td>
				<xsl:element name="a">
					<xsl:attribute name="name"><xsl:value-of select="$Element/xdf:identifikation/xdf:id"/><xsl:if test="$Element/xdf:identifikation/xdf:version">V<xsl:value-of select="$Element/xdf:identifikation/xdf:version"/></xsl:if></xsl:attribute>
				</xsl:element>
										ID
									</td>
			<xsl:choose>
				<xsl:when test="empty($Element/xdf:identifikation/xdf:id/text())">
					<td class="RegelID">
						<xsl:if test="$Meldungen = '1'">
							<div class="Fehler E1038">Fehler!! E1038: Die ID muss befüllt werden.</div>
						</xsl:if>
					</td>
				</xsl:when>
				<xsl:otherwise>
					<td class="RegelID">
						<xsl:value-of select="$Element/xdf:identifikation/xdf:id"/>
						<xsl:analyze-string regex="^R\d{{8}}$" select="$Element/xdf:identifikation/xdf:id">
							<xsl:matching-substring>
								<xsl:if test="$ToolAufruf = '1'">
															&#160;&#160;
															<xsl:element name="a">
										<xsl:attribute name="href"><xsl:value-of select="$ToolPfadPrefix"/><xsl:value-of select="$Element/xdf:identifikation/xdf:id"/><xsl:if test="$Element/xdf:identifikation/xdf:version">V<xsl:value-of select="$Element/xdf:identifikation/xdf:version"/></xsl:if><xsl:value-of select="$ToolPfadPostfix"/></xsl:attribute>
										<xsl:attribute name="target">FIMTool</xsl:attribute>
										<xsl:attribute name="title">Springe in den Datenfeldeditor (man muss vorher angemeldet sein).</xsl:attribute>
																&#8658;
															</xsl:element>
								</xsl:if>
							</xsl:matching-substring>
							<xsl:non-matching-substring>
								<xsl:if test="$Meldungen = '1'">
									<div class="Fehler E1039">Fehler!! E1039: Die ID entspricht nicht den Formatvorgaben.</div>
								</xsl:if>
							</xsl:non-matching-substring>
						</xsl:analyze-string>
					</td>
				</xsl:otherwise>
			</xsl:choose>
		</tr>
		<tr>
			<td>Version</td>
			<td>
				<xsl:value-of select="$Element/xdf:identifikation/xdf:version"/>
			</td>
		</tr>
		<tr>
			<td>Name</td>
			<xsl:choose>
				<xsl:when test="empty($Element/xdf:name/text())">
					<td>
						<xsl:if test="$Meldungen = '1'">
							<div class="Fehler E1002">Fehler!! E1002: Der Name muss befüllt werden.</div>
						</xsl:if>
					</td>
				</xsl:when>
				<xsl:otherwise>
					<td class="RegelName">
						<xsl:value-of select="$Element/xdf:name"/>
					</td>
				</xsl:otherwise>
			</xsl:choose>
		</tr>
		<tr>
			<td>Definition</td>
			<xsl:choose>
				<xsl:when test="empty($Element/xdf:definition/text())">
					<td>
						<xsl:if test="$Meldungen = '1'">
							<div class="Fehler E1024">Fehler!! E1024: Die Definition einer Regel muss befüllt sein.</div>
						</xsl:if>
					</td>
				</xsl:when>
				<xsl:otherwise>
					<td>
						<xsl:value-of select="fn:replace($Element/xdf:definition,'\n','&lt;br/&gt;')" disable-output-escaping="yes"/>
					</td>
				</xsl:otherwise>
			</xsl:choose>
		</tr>
		<tr>
			<td>Script</td>
			<xsl:choose>
				<xsl:when test="string-length($Element/xdf:script) &lt; 25">
					<td>
						<xsl:value-of select="$Element/xdf:script"/>
						<!-- <xsl:if test="$Meldungen = '1'"><div class="Warnung W1004">Warnung!! W1004: Script nicht definiert</div></xsl:if> -->
					</td>
				</xsl:when>
				<xsl:otherwise>
					<td>
						<xsl:value-of select="$Element/xdf:script"/>
					</td>
				</xsl:otherwise>
			</xsl:choose>
		</tr>
		<tr>
			<td>Beschreibung</td>
			<td>
				<xsl:value-of select="fn:replace($Element/xdf:beschreibung,'\n','&lt;br/&gt;')" disable-output-escaping="yes"/>
			</td>
		</tr>
		<tr>
			<td>Handlungsgrundlagen</td>
			<td>
				<xsl:value-of select="$Element/xdf:bezug"/>
			</td>
		</tr>
		<!--
								<tr>
									<td>Bezeichnung Eingabe</td>
									<td>
										<xsl:value-of select="$Element/xdf:bezeichnungEingabe"/>
									</td>
								</tr>
								<tr>
									<td>Bezeichung Ausgabe</td>
									<td>
										<xsl:value-of select="$Element/xdf:bezeichnungAusgabe"/>
									</td>
								</tr>
-->
		<tr>
			<td>Status</td>
			<xsl:choose>
				<xsl:when test="$Element/xdf:status/code/text() != 'aktiv' and $VersionsHinweise ='1'">
					<td>
						<xsl:apply-templates select="$Element/xdf:status"/>
						<xsl:if test="$Meldungen = '1'">
							<div class="Hinweis">Hinweis!! Der Status muss zur Versionierung oder Veröffentlichung den Wert 'aktiv' haben.</div>
						</xsl:if>
					</td>
				</xsl:when>
				<xsl:otherwise>
					<td>
						<xsl:apply-templates select="$Element/xdf:status"/>
					</td>
				</xsl:otherwise>
			</xsl:choose>
		</tr>
		<tr>
			<td>Gültig ab</td>
			<td>
				<xsl:value-of select="$Element/xdf:gueltigAb"/>
			</td>
		</tr>
		<tr>
			<td>Gültig bis</td>
			<td>
				<xsl:value-of select="$Element/xdf:gueltigBis"/>
			</td>
		</tr>
		<tr>
			<td>Fachlicher Ersteller</td>
			<xsl:choose>
				<xsl:when test="empty($Element/xdf:fachlicherErsteller/text()) and $VersionsHinweise ='1'">
					<td>
						<xsl:value-of select="$Element/xdf:fachlicherErsteller"/>
						<xsl:if test="$Meldungen = '1'">
							<div class="Hinweis">Hinweis!! Der 'Fachliche Ersteller' darf zur Versionierung oder Veröffentlichung nicht leer sein.</div>
						</xsl:if>
					</td>
				</xsl:when>
				<xsl:otherwise>
					<td>
						<xsl:value-of select="$Element/xdf:fachlicherErsteller"/>
					</td>
				</xsl:otherwise>
			</xsl:choose>
		</tr>
		<!--

							<xsl:if test="$PrivateMode = '0'">
								<tr>
									<td>Letzter Bearbeiter</td>
									<td>
										<xsl:value-of select="./LetzterBearbeiter"/>
									</td>
								</tr>
								<tr>
									<td>Zeitpunkt der Erstellung</td>
									<td>
										<xsl:value-of select="./Erstelldatum"/>
									</td>
								</tr>
								<tr>
									<td>Zeitpunkt der letzten Änderung</td>
									<td>
										<xsl:value-of select="./LetztesAenderungsdatum"/>
									</td>
								</tr>
							</xsl:if>
-->
		<tr>
			<td>
				<b>Verwendet in</b>
			</td>
			<xsl:variable name="RegelID" select="$Element/xdf:identifikation/xdf:id"/>
			<xsl:variable name="RegelVersion" select="$Element/xdf:identifikation/xdf:version"/>
			<td>
				<table>
					<thead>
						<tr>
							<th>ID</th>
							<th>Version</th>
							<th>Name</th>
							<th>Bezeichnung Eingabe</th>
						</tr>
					</thead>
					<tbody>
						<xsl:choose>
							<xsl:when test="not($Element/xdf:identifikation/xdf:version)">
								<xsl:for-each-group select="//xdf:datenfeld[xdf:regel/xdf:identifikation/xdf:id = $RegelID]" group-by="xdf:identifikation/xdf:id">
									<xsl:sort select="./xdf:identifikation/xdf:id"/>
									<xsl:for-each-group select="fn:current-group()" group-by="string(xdf:identifikation/xdf:version)">
										<xsl:sort select="./xdf:identifikation/xdf:version"/>
										<xsl:if test="current-grouping-key()=''">
											<xsl:call-template name="minielementcore">
												<xsl:with-param name="Element" select="."/>
											</xsl:call-template>
										</xsl:if>
									</xsl:for-each-group>
								</xsl:for-each-group>
								<xsl:for-each-group select="//xdf:datenfeldgruppe[xdf:regel/xdf:identifikation/xdf:id = $RegelID]" group-by="xdf:identifikation/xdf:id">
									<xsl:sort select="./xdf:identifikation/xdf:id"/>
									<xsl:for-each-group select="fn:current-group()" group-by="string(xdf:identifikation/xdf:version)">
										<xsl:sort select="./xdf:identifikation/xdf:version"/>
										<xsl:if test="current-grouping-key()=''">
											<xsl:call-template name="minielementcore">
												<xsl:with-param name="Element" select="."/>
											</xsl:call-template>
										</xsl:if>
									</xsl:for-each-group>
								</xsl:for-each-group>
								<xsl:for-each-group select="//xdf:stammdatenschema[xdf:regel/xdf:identifikation/xdf:id = $RegelID]" group-by="xdf:identifikation/xdf:id">
									<xsl:sort select="./xdf:identifikation/xdf:id"/>
									<xsl:for-each-group select="fn:current-group()" group-by="string(xdf:identifikation/xdf:version)">
										<xsl:sort select="./xdf:identifikation/xdf:version"/>
										<xsl:if test="current-grouping-key()=''">
											<xsl:call-template name="minielementcore">
												<xsl:with-param name="Element" select="."/>
											</xsl:call-template>
										</xsl:if>
									</xsl:for-each-group>
								</xsl:for-each-group>
							</xsl:when>
							<xsl:otherwise>
								<xsl:for-each-group select="//xdf:datenfeld[xdf:regel/xdf:identifikation/xdf:id = $RegelID and xdf:regel/xdf:identifikation/xdf:version = $RegelVersion]" group-by="xdf:identifikation/xdf:id">
									<xsl:sort select="./xdf:identifikation/xdf:id"/>
									<xsl:for-each-group select="fn:current-group()" group-by="string(xdf:identifikation/xdf:version)">
										<xsl:sort select="./xdf:identifikation/xdf:version"/>
										<xsl:call-template name="minielementcore">
											<xsl:with-param name="Element" select="."/>
										</xsl:call-template>
									</xsl:for-each-group>
								</xsl:for-each-group>
								<xsl:for-each-group select="//xdf:datenfeldgruppe[xdf:regel/xdf:identifikation/xdf:id = $RegelID and xdf:regel/xdf:identifikation/xdf:version = $RegelVersion]" group-by="xdf:identifikation/xdf:id">
									<xsl:sort select="./xdf:identifikation/xdf:id"/>
									<xsl:for-each-group select="fn:current-group()" group-by="string(xdf:identifikation/xdf:version)">
										<xsl:sort select="./xdf:identifikation/xdf:version"/>
										<xsl:call-template name="minielementcore">
											<xsl:with-param name="Element" select="."/>
										</xsl:call-template>
									</xsl:for-each-group>
								</xsl:for-each-group>
								<xsl:for-each-group select="//xdf:stammdatenschema[xdf:regel/xdf:identifikation/xdf:id = $RegelID and xdf:regel/xdf:identifikation/xdf:version = $RegelVersion]" group-by="xdf:identifikation/xdf:id">
									<xsl:sort select="./xdf:identifikation/xdf:id"/>
									<xsl:for-each-group select="fn:current-group()" group-by="string(xdf:identifikation/xdf:version)">
										<xsl:sort select="./xdf:identifikation/xdf:version"/>
										<xsl:call-template name="minielementcore">
											<xsl:with-param name="Element" select="."/>
										</xsl:call-template>
									</xsl:for-each-group>
								</xsl:for-each-group>
							</xsl:otherwise>
						</xsl:choose>
					</tbody>
				</table>
			</td>
		</tr>
		<tr style="page-break-after:always">
			<td colspan="2" class="Navigation">
				<xsl:call-template name="navigationszeile"/>
			</td>
		</tr>
	</xsl:template>
	<!-- ############################################################################################################# -->
	<xsl:template name="listecodelistendetailszubaukasten">
		<xsl:if test="$DebugMode = '1' or $DebugMode = '2' or $DebugMode = '3' or $DebugMode = '4'">
			<xsl:message>
				++++ listecodelistendetailszubaukasten ++++
			</xsl:message>
		</xsl:if>
		<h2>
			<br/>
		</h2>
		<h2>
			<a name="CodelisteDetails"/>Details zu den Codelisten
					</h2>
		<table style="page-break-after:always">
			<thead>
				<tr>
					<th>Metadatum</th>
					<th>Inhalt</th>
				</tr>
			</thead>
			<tbody>
				<xsl:for-each-group select="//xdf:codeliste" group-by="xdf:identifikation/xdf:id">
					<xsl:sort select="./xdf:identifikation/xdf:id"/>
					<xsl:variable name="CodelisteGenericodeIDVersion" select="./xdf:genericodeIdentification/xdf:canonicalVersionUri"/>
					<xsl:variable name="CodelisteGenericodeID" select="./xdf:genericodeIdentification/xdf:canonicalIdentification"/>
					<xsl:variable name="CodelisteGenericodeVersion" select="./xdf:genericodeIdentification/xdf:version"/>
					<xsl:variable name="CodelisteFIMID" select="./xdf:identifikation/xdf:id"/>
					<xsl:variable name="ListeDoppelteCodelisten">
						<xdf:ListeDoppelteCodelisten>
							<xsl:for-each-group select="//xdf:codeliste[xdf:identifikation/xdf:id != $CodelisteFIMID and xdf:genericodeIdentification/xdf:canonicalVersionUri = $CodelisteGenericodeIDVersion]" group-by="xdf:identifikation/xdf:id">
								<xsl:sort select="xdf:identifikation/xdf:id"/>
								<xdf:codeliste>
									<xsl:value-of select="xdf:identifikation/xdf:id"/>
								</xdf:codeliste>
							</xsl:for-each-group>
						</xdf:ListeDoppelteCodelisten>
					</xsl:variable>
					<xsl:call-template name="codelistedetailszubaukasten">
						<xsl:with-param name="Element" select="."/>
						<xsl:with-param name="ListeDoppelteCodelisten" select="$ListeDoppelteCodelisten"/>
					</xsl:call-template>
				</xsl:for-each-group>
			</tbody>
		</table>
	</xsl:template>
	<!-- ############################################################################################################# -->
	<xsl:template name="listecodelistendetailszustammdatenschema">
		<xsl:if test="$DebugMode = '1' or $DebugMode = '2' or $DebugMode = '3' or $DebugMode = '4'">
			<xsl:message>
				++++ listecodelistendetailszustammdatenschema ++++
			</xsl:message>
		</xsl:if>
		<h2>
			<br/>
		</h2>
		<h2>
			<a name="CodelisteDetails"/>Details zu den Codelisten des Datenschemas <xsl:value-of select="/*/xdf:stammdatenschema/xdf:identifikation/xdf:id"/>
			<xsl:if test="/*/xdf:stammdatenschema/xdf:identifikation/xdf:version"> Version <xsl:value-of select="/*/xdf:stammdatenschema/xdf:identifikation/xdf:version"/>
			</xsl:if>
		</h2>
		<table style="page-break-after:always">
			<thead>
				<tr>
					<th>Metadatum</th>
					<th>Inhalt</th>
				</tr>
			</thead>
			<tbody>
				<xsl:for-each-group select="//xdf:codelisteReferenz" group-by="xdf:identifikation/xdf:id">
					<xsl:sort select="./xdf:identifikation/xdf:id"/>
					<xsl:variable name="CodelisteGenericodeIDVersion" select="./xdf:genericodeIdentification/xdf:canonicalVersionUri"/>
					<xsl:variable name="CodelisteGenericodeID" select="./xdf:genericodeIdentification/xdf:canonicalIdentification"/>
					<xsl:variable name="CodelisteGenericodeVersion" select="./xdf:genericodeIdentification/xdf:version"/>
					<xsl:variable name="CodelisteFIMID" select="./xdf:identifikation/xdf:id"/>
					<xsl:variable name="ListeDoppelteCodelisten">
						<xdf:ListeDoppelteCodelisten>
							<xsl:for-each-group select="//xdf:datenfeld[xdf:codelisteReferenz/xdf:identifikation/xdf:id != $CodelisteFIMID and xdf:codelisteReferenz/xdf:genericodeIdentification/xdf:canonicalVersionUri = $CodelisteGenericodeIDVersion]" group-by="xdf:codelisteReferenz/xdf:identifikation/xdf:id">
								<xsl:sort select="xdf:codelisteReferenz/xdf:identifikation/xdf:id"/>
								<xdf:codeliste>
									<xsl:value-of select="xdf:codelisteReferenz/xdf:identifikation/xdf:id"/>
								</xdf:codeliste>
							</xsl:for-each-group>
						</xdf:ListeDoppelteCodelisten>
					</xsl:variable>
					<xsl:variable name="ListeMehrereCodelistenVersionen">
						<xdf:ListeMehrereCodelistenVersionen>
							<xsl:for-each-group select="//xdf:datenfeld[xdf:codelisteReferenz/xdf:genericodeIdentification/xdf:canonicalIdentification = $CodelisteGenericodeID and xdf:codelisteReferenz/xdf:genericodeIdentification/xdf:version != $CodelisteGenericodeVersion]" group-by="xdf:codelisteReferenz/xdf:identifikation/xdf:id">
								<xsl:sort select="xdf:codelisteReferenz/xdf:identifikation/xdf:id"/>
								<xdf:codeliste>
									<xsl:value-of select="xdf:codelisteReferenz/xdf:identifikation/xdf:id"/>
								</xdf:codeliste>
							</xsl:for-each-group>
						</xdf:ListeMehrereCodelistenVersionen>
					</xsl:variable>
					<xsl:call-template name="codelistedetailszustammdatenschema">
						<xsl:with-param name="Element" select="."/>
						<xsl:with-param name="ListeDoppelteCodelisten" select="$ListeDoppelteCodelisten"/>
						<xsl:with-param name="ListeMehrereCodelistenVersionen" select="$ListeMehrereCodelistenVersionen"/>
					</xsl:call-template>
				</xsl:for-each-group>
			</tbody>
		</table>
	</xsl:template>
	<!-- ############################################################################################################# -->
	<xsl:template name="codelistedetailszubaukasten">
		<xsl:param name="Element"/>
		<xsl:param name="ListeDoppelteCodelisten"/>
		<xsl:if test="$DebugMode = '2' or $DebugMode = '3' or $DebugMode = '4'">
			<xsl:message>
				++++++++ codelistedetailszubaukasten ++++++++
			</xsl:message>
		</xsl:if>
		<xsl:if test="$DebugMode = '3' or $DebugMode = '4'">
			<xsl:message>
				-------- <xsl:value-of select="$Element/xdf:identifikation/xdf:id"/> --------
			</xsl:message>
		</xsl:if>
		<tr>
			<td>
				<xsl:element name="a">
					<xsl:attribute name="name"><xsl:value-of select="$Element/xdf:identifikation/xdf:id"/></xsl:attribute>
				</xsl:element>
										ID
									</td>
			<td>
				<xsl:value-of select="$Element/xdf:identifikation/xdf:id"/>
				<xsl:if test="$ToolAufruf = '1'">
											&#160;&#160;
											<xsl:element name="a">
						<xsl:attribute name="href"><xsl:value-of select="$ToolPfadPrefix"/><xsl:value-of select="$Element/xdf:identifikation/xdf:id"/><xsl:value-of select="$ToolPfadPostfix"/></xsl:attribute>
						<xsl:attribute name="target">FIMTool</xsl:attribute>
						<xsl:attribute name="title">Springe in den Datenfeldeditor (man muss vorher angemeldet sein).</xsl:attribute>
												&#8658;
											</xsl:element>
				</xsl:if>
				<xsl:if test="count($ListeDoppelteCodelisten/*/xdf:codeliste) &gt; 0">
					<xsl:if test="$Meldungen = '1'">
						<div class="Fehler E1036">Fehler!! E1036: Die Kombination aus Kennung und Version muss immer eindeutig sein. Dies steht im Konflikt mit Codeliste(n) 
												<xsl:for-each select="$ListeDoppelteCodelisten/*/xdf:codeliste">
								<xsl:element name="a">
									<xsl:attribute name="href">#<xsl:value-of select="."/></xsl:attribute>
									<xsl:value-of select="."/>
								</xsl:element>
								<xsl:if test="fn:position() != fn:last()">,&#160;</xsl:if>
							</xsl:for-each>
						</div>
					</xsl:if>
				</xsl:if>
			</td>
		</tr>
		<tr>
			<td>Name</td>
			<xsl:choose>
				<xsl:when test="empty($Element/xdf:name/text())">
					<td class="ElementName">
						<xsl:if test="$Meldungen = '1'">
							<div class="Fehler 1002">Fehler!! E1002: Der Name muss befüllt werden.</div>
						</xsl:if>
					</td>
				</xsl:when>
				<xsl:otherwise>
					<td class="ElementName">
						<xsl:value-of select="$Element/xdf:name"/>
					</td>
				</xsl:otherwise>
			</xsl:choose>
		</tr>
		<tr>
			<td>Kennung</td>
			<td>
				<xsl:value-of select="$Element/xdf:genericodeIdentification/xdf:canonicalIdentification"/>
				<xsl:if test="$Meldungen = '1'">
					<xsl:analyze-string regex="^urn:[A-Za-z0-9][A-Za-z0-9-]{{0,31}}:([A-Za-z0-9()+,\-.:=@;\$_!*&apos;]|%[0-9A-Fa-f]{{2}})+$" select="$Element/xdf:genericodeIdentification/xdf:canonicalIdentification">
						<xsl:matching-substring>
												</xsl:matching-substring>
						<xsl:non-matching-substring>
							<xsl:if test="$Meldungen = '1'">
								<xsl:choose>
									<xsl:when test="empty($Element/xdf:genericodeIdentification/xdf:canonicalIdentification/text())">
										<div class="Fehler E1040">Fehler!! E1040: Die Kennung ist leer.</div>
									</xsl:when>
									<xsl:when test="substring($Element/xdf:genericodeIdentification/xdf:canonicalIdentification/text(),1,4) != 'urn:'">
										<div class="Fehler E1005">Fehler!! E1005: Die Kennung einer Codeliste ist nicht als URN formuliert, z. B. urn:de:fim:codeliste:dokumenttyp.</div>
									</xsl:when>
									<xsl:otherwise>
										<div class="Fehler E1048">Fehler!! E1048: Die URN-Kennung einer Codeliste entspricht nicht den Formatvorgaben, z. B. urn:de:fim:codeliste:dokumenttyp (Umlaute sind nicht erlaubt!).</div>
									</xsl:otherwise>
								</xsl:choose>
							</xsl:if>
						</xsl:non-matching-substring>
					</xsl:analyze-string>
				</xsl:if>
			</td>
		</tr>
		<tr>
			<td>Version</td>
			<xsl:choose>
				<xsl:when test="substring($Element/xdf:genericodeIdentification/xdf:version/text(),5,1) != '-' or substring($Element/xdf:genericodeIdentification/xdf:version/text(),8,1) != '-'">
					<td>
						<xsl:value-of select="$Element/xdf:genericodeIdentification/xdf:version"/>
						<xsl:if test="$Meldungen = '1'">
							<div class="Warnung W1005">Warnung!! W1005: Die Version sollte im Datumsformat in folgender Form angegeben werden, z. B. 2018-03-01.</div>
						</xsl:if>
					</td>
				</xsl:when>
				<xsl:otherwise>
					<td>
						<xsl:value-of select="$Element/xdf:genericodeIdentification/xdf:version"/>
					</td>
				</xsl:otherwise>
			</xsl:choose>
		</tr>
		<tr>
			<td>Langer Name</td>
			<td>
				<xsl:value-of select="$Element/xdf:langname"/>
			</td>
		</tr>
		<tr>
			<td>Definition</td>
			<td>
				<xsl:value-of select="fn:replace($Element/xdf:definition,'\n','&lt;br/&gt;')" disable-output-escaping="yes"/>
			</td>
		</tr>
		<tr>
			<td>Beschreibung</td>
			<td>
				<xsl:value-of select="fn:replace($Element/xdf:beschreibung,'\n','&lt;br/&gt;')" disable-output-escaping="yes"/>
			</td>
		</tr>
		<tr>
			<td>Handlungsgrundlagen</td>
			<xsl:choose>
				<xsl:when test="empty($Element/xdf:bezug/text())">
					<td>
						<xsl:if test="$Meldungen = '1'">
							<div class="Warnung W1010">Warnung!! W1010: Der Bezug zur Handlungsgrundlage sollte nicht leer sein.</div>
						</xsl:if>
					</td>
				</xsl:when>
				<xsl:otherwise>
					<td>
						<xsl:value-of select="$Element/xdf:bezug"/>
					</td>
				</xsl:otherwise>
			</xsl:choose>
		</tr>
		<tr>
			<td>Bezeichnung Eingabe</td>
			<td>
				<xsl:value-of select="$Element/xdf:bezeichnungEingabe"/>
			</td>
		</tr>
		<tr>
			<td>Bezeichung Ausgabe</td>
			<td>
				<xsl:value-of select="$Element/xdf:bezeichnungAusgabe"/>
			</td>
		</tr>
		<tr>
			<td>Status</td>
			<xsl:choose>
				<xsl:when test="$Element/xdf:status/code/text() != 'aktiv' and $VersionsHinweise ='1'">
					<td>
						<xsl:apply-templates select="$Element/xdf:status"/>
						<xsl:if test="$Meldungen = '1'">
							<div class="Hinweis">Hinweis!! Der Status muss zur Versionierung oder Veröffentlichung den Wert 'aktiv' haben.</div>
						</xsl:if>
					</td>
				</xsl:when>
				<xsl:otherwise>
					<td>
						<xsl:apply-templates select="$Element/xdf:status"/>
					</td>
				</xsl:otherwise>
			</xsl:choose>
		</tr>
		<tr>
			<td>Gültig ab</td>
			<td>
				<xsl:value-of select="$Element/xdf:gueltigAb"/>
			</td>
		</tr>
		<tr>
			<td>Gültig bis</td>
			<td>
				<xsl:value-of select="$Element/xdf:gueltigBis"/>
			</td>
		</tr>
		<tr>
			<td>Fachlicher Ersteller</td>
			<xsl:choose>
				<xsl:when test="empty($Element/xdf:fachlicherErsteller/text()) and $VersionsHinweise ='1'">
					<td>
						<xsl:value-of select="$Element/xdf:fachlicherErsteller"/>
						<xsl:if test="$Meldungen = '1'">
							<div class="Hinweis">Hinweis!! Der 'Fachliche Ersteller' darf zur Versionierung oder Veröffentlichung nicht leer sein.</div>
						</xsl:if>
					</td>
				</xsl:when>
				<xsl:otherwise>
					<td>
						<xsl:value-of select="$Element/xdf:fachlicherErsteller"/>
					</td>
				</xsl:otherwise>
			</xsl:choose>
		</tr>
		<xsl:if test="$CodelistenInhalt = '1'">
			<xsl:variable name="CodelisteDatei" select="concat($InputPfad,$Element/xdf:identifikation/xdf:id, '_genericode.xml')"/>
			<xsl:variable name="CodelisteInhalt" select="document($CodelisteDatei)"/>
			<xsl:choose>
				<xsl:when test="empty($CodelisteInhalt)">
					<xsl:if test="$Meldungen = '1'">
						<tr>
							<td colspan="2">
								<div class="Warnung W1015">Warnung!! W1015: Die Codeliste konnte nicht geladen werden.</div>
							</td>
						</tr>
					</xsl:if>
				</xsl:when>
				<xsl:otherwise>
					<tr>
						<td>Inhalt</td>
						<td>
							<table>
								<thead>
									<tr>
										<xsl:for-each select="$CodelisteInhalt/*/gc:ColumnSet/gc:Column">
											<th>
												<xsl:value-of select="./gc:ShortName"/>
											</th>
										</xsl:for-each>
										<xsl:for-each select="$CodelisteInhalt/*/ColumnSet/Column">
											<th>
												<xsl:value-of select="./ShortName"/>
											</th>
										</xsl:for-each>
									</tr>
								</thead>
								<tbody>
									<xsl:for-each select="$CodelisteInhalt/*/gc:SimpleCodeList/gc:Row">
										<xsl:variable name="thisRow" select="."/>
										<tr>
											<xsl:for-each select="../../gc:ColumnSet/gc:Column/@Id">
												<td>
													<xsl:value-of select="$thisRow/gc:Value[@ColumnRef=current()]"/>
												</td>
											</xsl:for-each>
										</tr>
									</xsl:for-each>
									<xsl:for-each select="$CodelisteInhalt/*/SimpleCodeList/Row">
										<xsl:variable name="thisRow" select="."/>
										<tr>
											<xsl:for-each select="../../ColumnSet/Column/@Id">
												<td>
													<xsl:value-of select="$thisRow/Value[@ColumnRef=current()]"/>
												</td>
											</xsl:for-each>
										</tr>
									</xsl:for-each>
								</tbody>
							</table>
						</td>
					</tr>
				</xsl:otherwise>
			</xsl:choose>
		</xsl:if>
		<!--

							<xsl:if test="$PrivateMode = '0'">
								<tr>
									<td>Letzter Bearbeiter</td>
									<td>
										<xsl:value-of select="./LetzterBearbeiter"/>
									</td>
								</tr>
								<tr>
									<td>Zeitpunkt der Erstellung</td>
									<td>
										<xsl:value-of select="./Erstelldatum"/>
									</td>
								</tr>
								<tr>
									<td>Zeitpunkt der letzten Änderung</td>
									<td>
										<xsl:value-of select="./LetztesAenderungsdatum"/>
									</td>
								</tr>
							</xsl:if>
-->
		<tr>
			<td>
				<b>Verwendet in</b>
			</td>
			<xsl:variable name="CodelisteID" select="$Element/xdf:identifikation/xdf:id"/>
			<xsl:choose>
				<xsl:when test="count(//xdf:datenfeld[xdf:codeliste/xdf:identifikation/xdf:id = $CodelisteID])">
					<td>
						<table>
							<thead>
								<tr>
									<th>ID</th>
									<th>Version</th>
									<th>Name</th>
									<th>Bezeichnung Eingabe</th>
								</tr>
							</thead>
							<tbody>
								<xsl:for-each-group select="//xdf:datenfeld[xdf:codeliste/xdf:identifikation/xdf:id = $CodelisteID]" group-by="xdf:identifikation/xdf:id">
									<xsl:sort select="./xdf:identifikation/xdf:id"/>
									<xsl:for-each-group select="fn:current-group()" group-by="string(xdf:identifikation/xdf:version)">
										<xsl:sort select="./xdf:identifikation/xdf:version"/>
										<xsl:call-template name="minielementcore">
											<xsl:with-param name="Element" select="."/>
										</xsl:call-template>
									</xsl:for-each-group>
								</xsl:for-each-group>
							</tbody>
						</table>
					</td>
				</xsl:when>
				<xsl:otherwise>
					<td>
						<xsl:if test="$Meldungen = '1'">
							<div class="Warnung W1011">Warnung!! W1011: Codeliste wird nicht verwendet.</div>
						</xsl:if>
					</td>
				</xsl:otherwise>
			</xsl:choose>
		</tr>
		<tr style="page-break-after:always">
			<td colspan="2" class="Navigation">
				<xsl:call-template name="navigationszeile"/>
			</td>
		</tr>
	</xsl:template>
	<!-- ############################################################################################################# -->
	<xsl:template name="codelistedetailszustammdatenschema">
		<xsl:param name="Element"/>
		<xsl:param name="ListeDoppelteCodelisten"/>
		<xsl:param name="ListeMehrereCodelistenVersionen"/>
		<xsl:if test="$DebugMode = '2' or $DebugMode = '3' or $DebugMode = '4'">
			<xsl:message>
				++++++++ codelistedetailszustammdatenschema ++++++++
			</xsl:message>
		</xsl:if>
		<xsl:if test="$DebugMode = '3' or $DebugMode = '4'">
			<xsl:message>
				-------- <xsl:value-of select="$Element/xdf:identifikation/xdf:id"/> --------
			</xsl:message>
		</xsl:if>
		<tr>
			<td>
				<xsl:element name="a">
					<xsl:attribute name="name"><xsl:value-of select="$Element/xdf:identifikation/xdf:id"/><xsl:if test="$Element/xdf:identifikation/xdf:version">V<xsl:value-of select="$Element/xdf:identifikation/xdf:version"/></xsl:if></xsl:attribute>
				</xsl:element>
				ID
			</td>
			<td>
				<xsl:value-of select="$Element/xdf:identifikation/xdf:id"/>

				<xsl:analyze-string regex="^C\d{{8}}(V\d{{1,}}\.\d{{1,}})?$" select="$Element/xdf:identifikation/xdf:id">
					<xsl:matching-substring>
						<xsl:if test="$ToolAufruf = '1'">
													&#160;&#160;
													<xsl:element name="a">
								<xsl:attribute name="href"><xsl:value-of select="$ToolPfadPrefix"/><xsl:value-of select="$Element/xdf:identifikation/xdf:id"/><xsl:value-of select="$ToolPfadPostfix"/></xsl:attribute>
								<xsl:attribute name="target">FIMTool</xsl:attribute>
								<xsl:attribute name="title">Springe in den Datenfeldeditor (man muss vorher angemeldet sein).</xsl:attribute>
														&#8658;
													</xsl:element>
						</xsl:if>
					</xsl:matching-substring>
					<xsl:non-matching-substring>
						<xsl:if test="$Meldungen = '1'">
							<div class="Fehler E1039">Fehler!! E1039: Die ID entspricht nicht !!! den Formatvorgaben.</div>
						</xsl:if>
					</xsl:non-matching-substring>
				</xsl:analyze-string>
				<xsl:if test="count($ListeDoppelteCodelisten/*/xdf:codeliste) &gt; 0">
					<xsl:if test="$Meldungen = '1'">
						<div class="Fehler E1036">Fehler!! E1036: Die Kombination aus Kennung und Version muss immer eindeutig sein. Dies steht im Konflikt mit Codeliste(n) 
												<xsl:for-each select="$ListeDoppelteCodelisten/*/xdf:codeliste">
								<xsl:element name="a">
									<xsl:attribute name="href">#<xsl:value-of select="."/></xsl:attribute>
									<xsl:value-of select="."/>
								</xsl:element>
								<xsl:if test="fn:position() != fn:last()">,&#160;</xsl:if>
							</xsl:for-each>
						</div>
					</xsl:if>
				</xsl:if>
			</td>
		</tr>
		<tr>
			<td>Version</td>
			<td><xsl:value-of select="$Element/xdf:identifikation/xdf:version"/></td>
		</tr>
		<tr>
			<td>Kennung</td>
			<td>
				<xsl:value-of select="$Element/xdf:genericodeIdentification/xdf:canonicalIdentification"/>
				<xsl:if test="$Meldungen = '1'">
					<xsl:analyze-string regex="^urn:[A-Za-z0-9][A-Za-z0-9-]{{0,31}}:([A-Za-z0-9()+,\-.:=@;\$_!*&apos;]|%[0-9A-Fa-f]{{2}})+$" select="$Element/xdf:genericodeIdentification/xdf:canonicalIdentification">
						<xsl:matching-substring>
												</xsl:matching-substring>
						<xsl:non-matching-substring>
							<xsl:if test="$Meldungen = '1'">
								<xsl:choose>
									<xsl:when test="empty($Element/xdf:genericodeIdentification/xdf:canonicalIdentification/text())">
										<div class="Fehler E1040">Fehler!! E1040: Die Kennung ist leer.</div>
									</xsl:when>
									<xsl:when test="substring($Element/xdf:genericodeIdentification/xdf:canonicalIdentification/text(),1,4) != 'urn:'">
										<div class="Fehler E1005">Fehler!! E1005: Die Kennung einer Codeliste ist nicht als URN formuliert, z. B. urn:de:fim:codeliste:dokumenttyp.</div>
									</xsl:when>
									<xsl:otherwise>
										<div class="Fehler E1048">Fehler!! E1048: Die URN-Kennung einer Codeliste entspricht nicht den Formatvorgaben, z. B. urn:de:fim:codeliste:dokumenttyp (Umlaute sind nicht erlaubt!).</div>
									</xsl:otherwise>
								</xsl:choose>
							</xsl:if>
						</xsl:non-matching-substring>
					</xsl:analyze-string>
				</xsl:if>
			</td>
		</tr>
		<tr>
			<td>Kennungsversion</td>
			<xsl:choose>
				<xsl:when test="count($ListeMehrereCodelistenVersionen/*/xdf:codeliste) &gt; 0">
					<td>
						<xsl:value-of select="$Element/xdf:genericodeIdentification/xdf:version"/>
						<xsl:if test="$Meldungen = '1'">
							<div class="Fehler E1037">Fehler!! E1037: In einem Datenschema darf eine Codeliste nicht in mehreren Versionen verwendet werden. Dies steht im Konflikt mit Codeliste(n) 
													<xsl:for-each select="$ListeMehrereCodelistenVersionen/*/xdf:codeliste">
									<xsl:element name="a">
										<xsl:attribute name="href">#<xsl:value-of select="."/></xsl:attribute>
										<xsl:value-of select="."/>
									</xsl:element>
									<xsl:if test="fn:position() != fn:last()">,&#160;</xsl:if>
								</xsl:for-each>
							</div>
						</xsl:if>
					</td>
				</xsl:when>
				<xsl:when test="substring($Element/xdf:genericodeIdentification/xdf:version/text(),5,1) != '-' or substring($Element/xdf:genericodeIdentification/xdf:version/text(),8,1) != '-'">
					<td>
						<xsl:value-of select="$Element/xdf:genericodeIdentification/xdf:version"/>
						<xsl:if test="$Meldungen = '1'">
							<div class="Warnung W1005">Warnung!! W1005: Die Version sollte im Datumsformat in folgender Form angegeben werden, z. B. 2018-03-01.</div>
						</xsl:if>
					</td>
				</xsl:when>
				<xsl:otherwise>
					<td>
						<xsl:value-of select="$Element/xdf:genericodeIdentification/xdf:version"/>
					</td>
				</xsl:otherwise>
			</xsl:choose>
		</tr>
		<xsl:if test="$CodelistenInhalt = '1'">
			<xsl:variable name="IDVersion"><xsl:value-of select="$Element/xdf:identifikation/xdf:id"/><xsl:if test="$Element/xdf:identifikation/xdf:version">V<xsl:value-of select="$Element/xdf:identifikation/xdf:version"/></xsl:if></xsl:variable>
			<xsl:variable name="CodelisteDatei" select="concat($InputPfad,$IDVersion, '_genericode.xml')"/>
			<xsl:variable name="CodelisteInhalt">
				<xsl:choose>
					<xsl:when test="fn:doc-available($CodelisteDatei)">
						<xsl:copy-of select="fn:document($CodelisteDatei)"/>
						<xsl:if test="$DebugMode = '4'">
							<xsl:message>                                  FILE</xsl:message>
						</xsl:if>
					</xsl:when>
					<xsl:otherwise>
						<xsl:if test="$DebugMode = '4'">
							<xsl:message>                                  LEER</xsl:message>
						</xsl:if>
					</xsl:otherwise>
				</xsl:choose>
			</xsl:variable>
			<xsl:choose>
				<xsl:when test="fn:string-length($CodelisteInhalt) &lt; 10">
					<xsl:if test="$Meldungen = '1'">
						<tr>
							<td colspan="2">
								<div class="Warnung W1015">Warnung!! W1015: Die Codeliste konnte nicht geladen werden.</div>
							</td>
						</tr>
					</xsl:if>
				</xsl:when>
				<xsl:otherwise>
					<tr>
						<td>Inhalt</td>
						<td>
							<table>
								<thead>
									<tr>
										<xsl:for-each select="$CodelisteInhalt/*/gc:ColumnSet/gc:Column">
											<th>
												<xsl:value-of select="./gc:ShortName"/>
											</th>
										</xsl:for-each>
										<xsl:for-each select="$CodelisteInhalt/*/ColumnSet/Column">
											<th>
												<xsl:value-of select="./ShortName"/>
											</th>
										</xsl:for-each>
									</tr>
								</thead>
								<tbody>
									<xsl:for-each select="$CodelisteInhalt/*/gc:SimpleCodeList/gc:Row">
										<xsl:variable name="thisRow" select="."/>
										<tr>
											<xsl:for-each select="../../gc:ColumnSet/gc:Column/@Id">
												<td>
													<xsl:value-of select="$thisRow/gc:Value[@ColumnRef=current()]"/>
												</td>
											</xsl:for-each>
										</tr>
									</xsl:for-each>
									<xsl:for-each select="$CodelisteInhalt/*/SimpleCodeList/Row">
										<xsl:variable name="thisRow" select="."/>
										<tr>
											<xsl:for-each select="../../ColumnSet/Column/@Id">
												<td>
													<xsl:value-of select="$thisRow/Value[@ColumnRef=current()]"/>
												</td>
											</xsl:for-each>
										</tr>
									</xsl:for-each>
								</tbody>
							</table>
						</td>
					</tr>
				</xsl:otherwise>
			</xsl:choose>
		</xsl:if>
		<!--

							<xsl:if test="$PrivateMode = '0'">
								<tr>
									<td>Letzter Bearbeiter</td>
									<td>
										<xsl:value-of select="./LetzterBearbeiter"/>
									</td>
								</tr>
								<tr>
									<td>Zeitpunkt der Erstellung</td>
									<td>
										<xsl:value-of select="./Erstelldatum"/>
									</td>
								</tr>
								<tr>
									<td>Zeitpunkt der letzten Änderung</td>
									<td>
										<xsl:value-of select="./LetztesAenderungsdatum"/>
									</td>
								</tr>
							</xsl:if>
-->
		<tr>
			<td>
				<b>Verwendet in</b>
			</td>
			<xsl:variable name="CodelisteID" select="$Element/xdf:identifikation/xdf:id"/>
			<xsl:choose>
				<xsl:when test="count(//xdf:datenfeld[xdf:codelisteReferenz/xdf:identifikation/xdf:id = $CodelisteID])">
					<td>
						<table>
							<thead>
								<tr>
									<th>ID</th>
									<th>Version</th>
									<th>Name</th>
									<th>Bezeichnung Eingabe</th>
								</tr>
							</thead>
							<tbody>
								<xsl:for-each-group select="//xdf:datenfeld[xdf:codelisteReferenz/xdf:identifikation/xdf:id = $CodelisteID]" group-by="xdf:identifikation/xdf:id">
									<xsl:sort select="./xdf:identifikation/xdf:id"/>
									<xsl:for-each-group select="fn:current-group()" group-by="string(xdf:identifikation/xdf:version)">
										<xsl:sort select="./xdf:identifikation/xdf:version"/>
										<xsl:call-template name="minielementcore">
											<xsl:with-param name="Element" select="."/>
										</xsl:call-template>
									</xsl:for-each-group>
								</xsl:for-each-group>
							</tbody>
						</table>
					</td>
				</xsl:when>
				<xsl:otherwise>
					<td>
						<xsl:if test="$Meldungen = '1'">
							<div class="Warnung W1011">Warnung!! W1011: Codeliste wird nicht verwendet.</div>
						</xsl:if>
					</td>
				</xsl:otherwise>
			</xsl:choose>
		</tr>
		<tr style="page-break-after:always">
			<td colspan="2" class="Navigation">
				<xsl:call-template name="navigationszeile"/>
			</td>
		</tr>
	</xsl:template>
	<!-- ############################################################################################################# -->
	<xsl:template name="unterelementezubaukasten">
		<xsl:param name="Element"/>
		<xsl:param name="Tiefe"/>
		<xsl:param name="Strukturelementart"/>
		<xsl:if test="$DebugMode = '4'">
			<xsl:message>
				++++++++++++++++ unterelementezubaukasten ++++++++++++++++
			</xsl:message>
		</xsl:if>
		<xsl:variable name="OriginalID">
			<xsl:value-of select="$Element/xdf:identifikation/xdf:id"/>
			<xsl:if test="$Element/xdf:identifikation/xdf:version">V<xsl:value-of select="$Element/xdf:identifikation/xdf:version"/>
			</xsl:if>
		</xsl:variable>
		<xsl:for-each select="$Element/xdf:regel">
			<tr class="Regel">
				<td>
					<span class="Einrueckung">
						<xsl:call-template name="einrueckung">
							<xsl:with-param name="Tiefe" select="$Tiefe"/>
							<xsl:with-param name="Zaehler" select="0"/>
							<xsl:with-param name="Text"/>
						</xsl:call-template>
					</span>
					<xsl:element name="a">
						<xsl:attribute name="href">#<xsl:value-of select="./xdf:identifikation/xdf:id"/><xsl:if test="./xdf:identifikation/xdf:version">V<xsl:value-of select="./xdf:identifikation/xdf:version"/></xsl:if></xsl:attribute>
						<xsl:value-of select="./xdf:identifikation/xdf:id"/>
					</xsl:element>
				</td>
				<td>
					<xsl:value-of select="./xdf:identifikation/xdf:version"/>
				</td>
				<td>
					<xsl:value-of select="./xdf:name"/>
				</td>
				<td colspan="4">
					<xsl:value-of select="fn:replace(./xdf:definition,'\n','&lt;br/&gt;')" disable-output-escaping="yes"/>
				</td>
			</tr>
		</xsl:for-each>
		<xsl:for-each select="$Element/xdf:struktur">
			<xsl:variable name="ElementID">
				<xsl:choose>
					<xsl:when test="substring-before(string(./xdf:enthaelt/xdf:id),'V')=''">
						<xsl:value-of select="string(./xdf:enthaelt/xdf:id)"/>
					</xsl:when>
					<xsl:otherwise>
						<xsl:value-of select="substring-before(string(./xdf:enthaelt/xdf:id),'V')"/>
					</xsl:otherwise>
				</xsl:choose>
			</xsl:variable>
			<xsl:variable name="ElementVersion">
				<xsl:value-of select="substring-after(string(./xdf:enthaelt/xdf:id),'V')"/>
			</xsl:variable>
			<xsl:variable name="VergleichsElementIDVersion">
				<xsl:value-of select="./xdf:enthaelt/xdf:id"/>
			</xsl:variable>
			<xsl:variable name="Unterlement">
				<xsl:call-template name="getelementbyidandversion">
					<xsl:with-param name="ElementID" select="$ElementID"/>
					<xsl:with-param name="ElementVersion" select="$ElementVersion"/>
				</xsl:call-template>
			</xsl:variable>
			<tr>
				<td>
					<xsl:call-template name="einrueckung">
						<xsl:with-param name="Tiefe" select="$Tiefe"/>
						<xsl:with-param name="Zaehler" select="0"/>
						<xsl:with-param name="Text"/>
					</xsl:call-template>
					<xsl:element name="a">
						<xsl:attribute name="href">#<xsl:value-of select="./xdf:enthaelt/xdf:id"/></xsl:attribute>
						<xsl:value-of select="$ElementID"/>
					</xsl:element>
					<xsl:if test="$Tiefe = 1 and count($Element/xdf:struktur/xdf:enthaelt[xdf:id=$VergleichsElementIDVersion]) &gt; 1">
						<xsl:if test="$Meldungen = '1'">
							<div class="Fehler E1025">Fehler!! E1025: In einem Datenschema dürfen Baukastenelement auf oberster Ebene nicht mehrfach in derselben Version enthalten sein.</div>
						</xsl:if>
					</xsl:if>
				</td>
				<td>
					<xsl:value-of select="$ElementVersion"/>
				</td>
				<td>
					<xsl:value-of select="$Unterlement/*/xdf:name"/>
				</td>
				<td>
					<xsl:value-of select="$Unterlement/*/xdf:bezeichnungEingabe"/>
				</td>
				<xsl:choose>
					<xsl:when test="$Unterlement/*/xdf:schemaelementart/code/text() = 'ABS'and $Tiefe = 1 and $AbstraktWarnung ='1'">
						<td>
							<xsl:apply-templates select="$Unterlement/*/xdf:schemaelementart"/>
							<xsl:if test="$Meldungen = '1'">
								<div class="Fehler E1013">Fehler!! E1013: Innerhalb von Datenschemata und Datenfeldgruppen dürfen nur Elemente mit der Strukturelementart harmonisiert oder rechtnormgebunden verwendet werden.</div>
							</xsl:if>
						</td>
					</xsl:when>
					<xsl:otherwise>
						<td>
							<xsl:apply-templates select="$Unterlement/*/xdf:schemaelementart"/>
						</td>
					</xsl:otherwise>
				</xsl:choose>
				<xsl:choose>
					<xsl:when test="$Unterlement/*/xdf:status/code/text() = 'inaktiv'and $Tiefe = 1">
						<td>
							<xsl:apply-templates select="$Unterlement/*/xdf:status"/>
							<xsl:if test="$Meldungen = '1'">
								<div class="Warnung W1016">Warnung!! W1016: Baukastenelemente im Status 'inaktiv' sollten nur in Ausnahmefällen verwendet werden.</div>
							</xsl:if>
						</td>
					</xsl:when>
					<xsl:otherwise>
						<td>
							<xsl:apply-templates select="$Unterlement/*/xdf:status"/>
						</td>
					</xsl:otherwise>
				</xsl:choose>
				<xsl:choose>
					<xsl:when test="$Tiefe = 1 and $Meldungen = '1'">
						<td>
							<xsl:value-of select="./xdf:anzahl"/>
							<xsl:variable name="AnzahlText" select="./xdf:anzahl/text()"/>
							<xsl:variable name="minCount" select="fn:substring-before(./xdf:anzahl/text(),':')"/>
							<xsl:variable name="maxCount" select="fn:substring-after(./xdf:anzahl/text(),':')"/>
							<xsl:analyze-string regex="^\d{{1,}}:[\d{{1,}}|*]$" select="./xdf:anzahl">
								<xsl:matching-substring>
									<xsl:if test="$AnzahlText = '0:0'">
										<div class="Fehler E1021">Fehler!! E1021: Es ist keine Multiplizität angegeben.</div>
									</xsl:if>
									<xsl:if test="(fn:number($minCount) &gt; fn:number($maxCount)) and $maxCount != '*'">
										<div class="Fehler E1047">Fehler!! E1047: In der Multiplizität muss die minimale Anzahl kleiner oder gleich der maximalen Anzahl sein.</div>
									</xsl:if>
								</xsl:matching-substring>
								<xsl:non-matching-substring>
									<xsl:if test="$Meldungen = '1'">
										<div class="Fehler E1046">Fehler!! E1046: Die Multiplizität entspricht nicht den Formatvorgaben.</div>
									</xsl:if>
								</xsl:non-matching-substring>
							</xsl:analyze-string>
						</td>
					</xsl:when>
					<xsl:otherwise>
						<td>
							<xsl:value-of select="./xdf:anzahl"/>
						</td>
					</xsl:otherwise>
				</xsl:choose>
				<xsl:choose>
					<xsl:when test="$Strukturelementart ='RNG' and ($Unterlement/*/xdf:schemaelementart/code/text() = 'ABS' or $Unterlement/*/xdf:schemaelementart/code/text() = 'HAR') and empty(./xdf:bezug/text())and $Tiefe = 1">
						<td>
							<xsl:if test="$Meldungen = '1'">
								<div class="Fehler E1022">Fehler!! E1022: Bei Verwendung von Elementen mit der Strukturelementart 'abstrakt' oder 'harmonisiert' innerhalb von Datenfeldgruppen mit der Strukturelementart 'rechtsnormgebunden' muss zur Multiplizität ein Bezug zu einer Handlungsgrundlage angegeben werden.</div>
							</xsl:if>
						</td>
					</xsl:when>
					<xsl:when test="$Strukturelementart ='SDS' and ($Unterlement/*/xdf:schemaelementart/code/text() = 'ABS' or $Unterlement/*/xdf:schemaelementart/code/text() = 'HAR') and empty(./xdf:bezug/text())and $Tiefe = 1">
						<td>
							<xsl:if test="$Meldungen = '1'">
								<div class="Fehler E1022">Fehler!! E1022: Bei Verwendung von Elementen mit der Strukturelementart 'abstrakt' oder 'harmonisiert' innerhalb von Datenfeldgruppen mit der Strukturelementart 'rechtsnormgebunden' muss zur Multiplizität ein Bezug zu einer Handlungsgrundlage angegeben werden.</div>
							</xsl:if>
						</td>
					</xsl:when>
					<xsl:otherwise>
						<td>
							<xsl:value-of select="./xdf:bezug"/>
						</td>
					</xsl:otherwise>
				</xsl:choose>
			</tr>
			<xsl:choose>
				<xsl:when test="fn:compare(string(./xdf:enthaelt/xdf:id),string($OriginalID)) = 0">
					<tr>
						<td colspan="8">
							<xsl:if test="$Meldungen = '1'">
								<div class="Fehler E1026">Fehler!! E1026: Zirkelbezug</div>
							</xsl:if>
						</td>
					</tr>
				</xsl:when>
				<xsl:otherwise>
					<xsl:if test="$Unterlement/*/name() = 'xdf:datenfeldgruppe'">
						<xsl:call-template name="unterelementezubaukasten">
							<xsl:with-param name="Element" select="$Unterlement/*"/>
							<xsl:with-param name="Tiefe" select="$Tiefe + 1"/>
							<xsl:with-param name="Strukturelementart" select="$Unterlement/*/xdf:schemaelementart/code"/>
						</xsl:call-template>
					</xsl:if>
				</xsl:otherwise>
			</xsl:choose>
		</xsl:for-each>
	</xsl:template>
	<!-- ############################################################################################################# -->
	<xsl:template name="unterelementezustammdatenschema">
		<xsl:param name="Element"/>
		<xsl:param name="Tiefe"/>
		<xsl:param name="Strukturelementart"/>
		<xsl:if test="$DebugMode = '4'">
			<xsl:message>
				++++++++++++++++ unterelementezustammdatenschema ++++++++++++++++
			</xsl:message>
		</xsl:if>
		<xsl:for-each select="$Element/xdf:regel">
			<tr class="Regel">
				<td>
					<span class="Einrueckung">
						<xsl:call-template name="einrueckung">
							<xsl:with-param name="Tiefe" select="$Tiefe"/>
							<xsl:with-param name="Zaehler" select="0"/>
							<xsl:with-param name="Text"/>
						</xsl:call-template>
					</span>
					<xsl:choose>
						<xsl:when test="empty(./xdf:identifikation/xdf:id/text())">
							<xsl:if test="$Meldungen = '1'">
								<div class="Fehler E1038">Fehler!! E1038: Die ID muss befüllt werden.</div>
							</xsl:if>
						</xsl:when>
						<xsl:otherwise>
							<xsl:choose>
								<xsl:when test="$InterneLinks = '1'">
									<xsl:element name="a">
										<xsl:attribute name="href">#<xsl:value-of select="./xdf:identifikation/xdf:id"/><xsl:if test="./xdf:identifikation/xdf:version">V<xsl:value-of select="./xdf:identifikation/xdf:version"/></xsl:if></xsl:attribute>
										<xsl:value-of select="./xdf:identifikation/xdf:id"/>
									</xsl:element>
								</xsl:when>
								<xsl:otherwise>
									<xsl:value-of select="./xdf:identifikation/xdf:id"/>
								</xsl:otherwise>
							</xsl:choose>
						</xsl:otherwise>
					</xsl:choose>
				</td>
				<td>
					<xsl:value-of select="./xdf:identifikation/xdf:version"/>
				</td>
				<td>
					<xsl:value-of select="./xdf:name"/>
				</td>
				<td colspan="4">
					<xsl:value-of select="fn:replace(./xdf:definition,'\n','&lt;br/&gt;')" disable-output-escaping="yes"/>
					<xsl:if test="$Tiefe = 1">
						<xsl:variable name="regellistedoppelte">
							<xdf:enthaltenebaukastenelemente>
								<xsl:analyze-string regex="[F|G]\d{{8}}" select="./xdf:definition">
									<xsl:matching-substring>
										<xdf:elementid>
											<xsl:value-of select="."/>
										</xdf:elementid>
									</xsl:matching-substring>
									<xsl:non-matching-substring>
									</xsl:non-matching-substring>
								</xsl:analyze-string>
							</xdf:enthaltenebaukastenelemente>
						</xsl:variable>
						<xsl:for-each-group select="$regellistedoppelte/*/xdf:elementid" group-by=".">
							<xsl:sort/>
							<xsl:variable name="TestElement">
								<xsl:value-of select="."/>
							</xsl:variable>
							<xsl:if test="fn:not($Element//xdf:identifikation[xdf:id/text() = $TestElement])">
								<xsl:if test="$Meldungen = '1'">
									<div class="Fehler E1001">Fehler!! E1001: Die Regel kann auf kein Baukastenelement mit der ID <xsl:value-of select="$TestElement"/> zugreifen.</div>
								</xsl:if>
							</xsl:if>
						</xsl:for-each-group>
						<xsl:variable name="regellisteversionen">
							<xdf:enthaltenebaukastenelemente>
								<xsl:analyze-string regex="[F|G]\d{{8}}V\d*\.\d*" select="./xdf:definition">
									<xsl:matching-substring>
										<xdf:elementid>
											<xsl:value-of select="."/>
										</xdf:elementid>
									</xsl:matching-substring>
									<xsl:non-matching-substring>
																						</xsl:non-matching-substring>
								</xsl:analyze-string>
							</xdf:enthaltenebaukastenelemente>
						</xsl:variable>
						<xsl:for-each-group select="$regellisteversionen/*/xdf:elementid" group-by=".">
							<xsl:sort/>
							<div class="Fehler E1019">Fehler!! E1019: Baukastenelemente, die in Regeln referenziert werden, dürfen keine Versionsangaben beinhalten: <xsl:value-of select="."/>.</div>
						</xsl:for-each-group>
					</xsl:if>
				</td>
			</tr>
		</xsl:for-each>
		<xsl:for-each select="$Element/xdf:struktur">
			<xsl:variable name="VergleichsElement">
				<xsl:value-of select="./xdf:enthaelt/*/xdf:identifikation/xdf:id"/>
			</xsl:variable>
			<xsl:variable name="VergleichsVersion">
				<xsl:value-of select="./xdf:enthaelt/*/xdf:identifikation/xdf:version"/>
			</xsl:variable>
			<tr>
				<td>
					<xsl:call-template name="einrueckung">
						<xsl:with-param name="Tiefe" select="$Tiefe"/>
						<xsl:with-param name="Zaehler" select="0"/>
						<xsl:with-param name="Text"/>
					</xsl:call-template>
					<xsl:choose>
						<xsl:when test="empty(./xdf:enthaelt/*/xdf:identifikation/xdf:id/text())">
							<xsl:if test="$Meldungen = '1'">
								<div class="Fehler E1038">Fehler!! E1038: Die ID muss befüllt werden.</div>
							</xsl:if>
						</xsl:when>
						<xsl:otherwise>
							<xsl:choose>
								<xsl:when test="$InterneLinks = '1'">
									<xsl:element name="a">
										<xsl:attribute name="href">#<xsl:value-of select="./xdf:enthaelt/*/xdf:identifikation/xdf:id"/><xsl:if test="./xdf:enthaelt/*/xdf:identifikation/xdf:version">V<xsl:value-of select="./xdf:enthaelt/*/xdf:identifikation/xdf:version"/></xsl:if></xsl:attribute>
										<xsl:value-of select="./xdf:enthaelt/*/xdf:identifikation/xdf:id"/>
									</xsl:element>
								</xsl:when>
								<xsl:otherwise>
									<xsl:value-of select="./xdf:enthaelt/*/xdf:identifikation/xdf:id"/>
								</xsl:otherwise>
							</xsl:choose>
						</xsl:otherwise>
					</xsl:choose>
					<xsl:choose>
						<xsl:when test="$VergleichsVersion = ''">
							<xsl:if test="$Tiefe = 1 and count($Element/xdf:struktur/./xdf:enthaelt/*/xdf:identifikation[xdf:id=$VergleichsElement and not(xdf:version)]) &gt; 1">
								<xsl:if test="$Meldungen = '1'">
									<div class="Fehler E1025">Fehler!! E1025: In einem Datenschema dürfen Baukastenelement auf oberster Ebene nicht mehrfach in derselben Version enthalten sein.</div>
								</xsl:if>
							</xsl:if>
						</xsl:when>
						<xsl:otherwise>
							<xsl:if test="$Tiefe = 1 and count($Element/xdf:struktur/./xdf:enthaelt/*/xdf:identifikation[xdf:id=$VergleichsElement and xdf:version=$VergleichsVersion]) &gt; 1">
								<xsl:if test="$Meldungen = '1'">
									<div class="Fehler E1025">Fehler!! E1025: In einem Datenschema dürfen Baukastenelement auf oberster Ebene nicht mehrfach in derselben Version enthalten sein.</div>
								</xsl:if>
							</xsl:if>
						</xsl:otherwise>
					</xsl:choose>
				</td>
				<xsl:choose>
					<xsl:when test="$Tiefe = 1 and empty(./xdf:enthaelt/*/xdf:identifikation/xdf:version/text()) and $VersionsHinweise ='1'">
						<td>
							<xsl:value-of select="./xdf:enthaelt/*/xdf:identifikation/xdf:version"/>
							<xsl:if test="$Meldungen = '1'">
								<div class="Hinweis">Hinweis!! Zur Versionierung und Veröffentlichung müssen alle verwendete Unterelemente versioniert sein.</div>
							</xsl:if>
						</td>
					</xsl:when>
					<xsl:otherwise>
						<td>
							<xsl:value-of select="./xdf:enthaelt/*/xdf:identifikation/xdf:version"/>
						</td>
					</xsl:otherwise>
				</xsl:choose>
				<td>
					<xsl:value-of select="./xdf:enthaelt/*/xdf:name"/>
				</td>
				<td>
					<xsl:value-of select="./xdf:enthaelt/*/xdf:bezeichnungEingabe"/>
				</td>
				<xsl:choose>
					<xsl:when test="./xdf:enthaelt/*/xdf:schemaelementart/code/text() = 'ABS' and $Tiefe = 1 and$AbstraktWarnung ='1'">
						<td>
							<xsl:apply-templates select="./xdf:enthaelt/*/xdf:schemaelementart"/>
							<xsl:if test="$Meldungen = '1'">
								<div class="Fehler E1013">Fehler!! E1013: Innerhalb von Datenschemata und Datenfeldgruppen dürfen nur Elemente mit der Strukturelementart harmonisiert oder rechtnormgebunden verwendet werden.</div>
							</xsl:if>
						</td>
					</xsl:when>
					<xsl:otherwise>
						<td>
							<xsl:apply-templates select="./xdf:enthaelt/*/xdf:schemaelementart"/>
						</td>
					</xsl:otherwise>
				</xsl:choose>
				<xsl:choose>
					<xsl:when test="./xdf:enthaelt/*/xdf:status/code/text() = 'inaktiv'and $Tiefe = 1">
						<td>
							<xsl:apply-templates select="./xdf:enthaelt/*/xdf:status"/>
							<xsl:if test="$Meldungen = '1'">
								<div class="Warnung W1016">Warnung!! W1016: Baukastenelemente im Status 'inaktiv' sollten nur in Ausnahmefällen verwendet werden.</div>
							</xsl:if>
						</td>
					</xsl:when>
					<xsl:otherwise>
						<td>
							<xsl:apply-templates select="./xdf:enthaelt/*/xdf:status"/>
						</td>
					</xsl:otherwise>
				</xsl:choose>
				<xsl:choose>
					<xsl:when test="$Tiefe = 1 and $Meldungen = '1'">
						<td>
							<xsl:value-of select="./xdf:anzahl"/>
							<xsl:variable name="AnzahlText" select="./xdf:anzahl/text()"/>
							<xsl:variable name="minCount" select="fn:substring-before(./xdf:anzahl/text(),':')"/>
							<xsl:variable name="maxCount" select="fn:substring-after(./xdf:anzahl/text(),':')"/>
							<xsl:analyze-string regex="^\d{{1,}}:[\d{{1,}}|*]$" select="./xdf:anzahl">
								<xsl:matching-substring>
									<xsl:if test="$AnzahlText = '0:0'">
										<div class="Fehler E1021">Fehler!! E1021: Es ist keine Multiplizität angegeben.</div>
									</xsl:if>
									<xsl:if test="(fn:number($minCount) &gt; fn:number($maxCount)) and $maxCount != '*'">
										<div class="Fehler E1047">Fehler!! E1047: In der Multiplizität muss die minimale Anzahl kleiner oder gleich der maximalen Anzahl sein.</div>
									</xsl:if>
								</xsl:matching-substring>
								<xsl:non-matching-substring>
									<xsl:if test="$Meldungen = '1'">
										<div class="Fehler E1046">Fehler!! E1046: Die Multiplizität entspricht nicht den Formatvorgaben.</div>
									</xsl:if>
								</xsl:non-matching-substring>
							</xsl:analyze-string>
						</td>
					</xsl:when>
					<xsl:otherwise>
						<td>
							<xsl:value-of select="./xdf:anzahl"/>
						</td>
					</xsl:otherwise>
				</xsl:choose>
				<xsl:choose>
					<xsl:when test="$Strukturelementart ='RNG' and (./xdf:enthaelt/*/xdf:schemaelementart/code/text() = 'ABS' or ./xdf:enthaelt/*/xdf:schemaelementart/code/text() = 'HAR') and empty(./xdf:bezug/text())and $Tiefe = 1">
						<td>
							<xsl:if test="$Meldungen = '1'">
								<div class="Fehler E1022">Fehler!! E1022: Bei Verwendung von Elementen mit der Strukturelementart 'abstrakt' oder 'harmonisiert' innerhalb von Datenfeldgruppen mit der Strukturelementart 'rechtsnormgebunden' muss zur Multiplizität ein Bezug zu einer Handlungsgrundlage angegeben werden.</div>
							</xsl:if>
						</td>
					</xsl:when>
					<xsl:when test="$Strukturelementart ='SDS' and (./xdf:enthaelt/*/xdf:schemaelementart/code/text() = 'ABS' or ./xdf:enthaelt/*/xdf:schemaelementart/code/text() = 'HAR') and empty(./xdf:bezug/text())and $Tiefe = 1">
						<td>
							<xsl:if test="$Meldungen = '1'">
								<div class="Fehler E1022">Fehler!! E1022: Bei Verwendung von Elementen mit der Strukturelementart 'abstrakt' oder 'harmonisiert' innerhalb von Datenfeldgruppen mit der Strukturelementart 'rechtsnormgebunden' muss zur Multiplizität ein Bezug zu einer Handlungsgrundlage angegeben werden.</div>
							</xsl:if>
						</td>
					</xsl:when>
					<xsl:otherwise>
						<td>
							<xsl:value-of select="./xdf:bezug"/>
						</td>
					</xsl:otherwise>
				</xsl:choose>
			</tr>
			<xsl:if test="./xdf:enthaelt/xdf:datenfeldgruppe">
				<xsl:call-template name="unterelementezustammdatenschema">
					<xsl:with-param name="Element" select="./xdf:enthaelt/xdf:datenfeldgruppe"/>
					<xsl:with-param name="Tiefe" select="$Tiefe + 1"/>
					<xsl:with-param name="Strukturelementart" select="./xdf:enthaelt/*/xdf:schemaelementart/code"/>
				</xsl:call-template>
			</xsl:if>
		</xsl:for-each>
	</xsl:template>
	<!-- ############################################################################################################# -->
	<xsl:template name="minielementcore">
		<xsl:param name="Element"/>
		<xsl:if test="$DebugMode = '4'">
			<xsl:message>
				++++++++++++++++ minielementcore ++++++++++++++++
			</xsl:message>
		</xsl:if>
		<tr>
			<td>
				<xsl:choose>
					<xsl:when test="$InterneLinks = '1'">
						<xsl:element name="a">
							<xsl:attribute name="href">#<xsl:value-of select="$Element/xdf:identifikation/xdf:id"/><xsl:if test="$Element/xdf:identifikation/xdf:version">V<xsl:value-of select="$Element/xdf:identifikation/xdf:version"/></xsl:if></xsl:attribute>
							<xsl:value-of select="$Element/xdf:identifikation/xdf:id"/>
						</xsl:element>
					</xsl:when>
					<xsl:otherwise>
						<xsl:value-of select="$Element/xdf:identifikation/xdf:id"/>
					</xsl:otherwise>
				</xsl:choose>
			</td>
			<td>
				<xsl:value-of select="$Element/xdf:identifikation/xdf:version"/>
			</td>
			<td>
				<xsl:value-of select="$Element/xdf:name"/>
			</td>
			<td>
				<xsl:value-of select="$Element/xdf:bezeichnungEingabe"/>
			</td>
		</tr>
	</xsl:template>
	<!-- ############################################################################################################# -->
	<xsl:template match="xdf:feldart">
		<xsl:choose>
			<xsl:when test="./code/text() = 'input'">Eingabefeld</xsl:when>
			<xsl:when test="./code/text() = 'select'">Auswahlfeld</xsl:when>
			<xsl:when test="./code/text() = 'label'">Statisches, read-only Feld</xsl:when>
			<xsl:otherwise>
				<xsl:if test="$Meldungen = '1'">
					<div class="Fehler E1027">Fehler!! E1027: Unbekannte Feldart</div>
				</xsl:if>
			</xsl:otherwise>
		</xsl:choose>
	</xsl:template>
	<xsl:template match="xdf:datentyp">
		<xsl:choose>
			<xsl:when test="./code/text() = 'text'">Text</xsl:when>
			<xsl:when test="./code/text() = 'date'">Datum</xsl:when>
			<xsl:when test="./code/text() = 'bool'">Wahrheitswert</xsl:when>
			<xsl:when test="./code/text() = 'num'">Nummer (Fließkommazahl)</xsl:when>
			<xsl:when test="./code/text() = 'num_int'">Ganzzahl</xsl:when>
			<xsl:when test="./code/text() = 'num_currency'">Geldbetrag</xsl:when>
			<xsl:when test="./code/text() = 'file'">Anlage</xsl:when>
			<xsl:when test="./code/text() = 'obj'">Statisches Objekt</xsl:when>
			<xsl:otherwise>
				<xsl:if test="$Meldungen = '1'">
					<div class="Fehler E1028">Fehler!! E1028: Unbekannter Datentyp</div>
				</xsl:if>
			</xsl:otherwise>
		</xsl:choose>
	</xsl:template>
	<xsl:template match="xdf:schemaelementart">
		<xsl:choose>
			<xsl:when test="./code/text() = 'ABS'">abstrakt</xsl:when>
			<xsl:when test="./code/text() = 'HAR'">harmonisiert</xsl:when>
			<xsl:when test="./code/text() = 'RNG'">rechtsnormgebunden</xsl:when>
			<xsl:otherwise>
				<xsl:if test="$Meldungen = '1'">
					<div class="Fehler E1031">Fehler!! E1031: Unbekannte Strukturelementart</div>
				</xsl:if>
			</xsl:otherwise>
		</xsl:choose>
	</xsl:template>
	<xsl:template match="xdf:status">
		<xsl:choose>
			<xsl:when test="./code/text() = 'inVorbereitung'">in Vorbereitung</xsl:when>
			<xsl:when test="./code/text() = 'aktiv'">aktiv</xsl:when>
			<xsl:when test="./code/text() = 'inaktiv'">inaktiv</xsl:when>
			<xsl:otherwise>
				<xsl:if test="$Meldungen = '1'">
					<div class="Fehler E1032">Fehler!! E1032: Unbekannter Status</div>
				</xsl:if>
			</xsl:otherwise>
		</xsl:choose>
	</xsl:template>
	<xsl:template match="xdf:ableitungsmodifikationenStruktur">
		<xsl:choose>
			<xsl:when test="./code/text() = '0'">nicht modifizierbar</xsl:when>
			<xsl:when test="./code/text() = '1'">nur einschränkbar</xsl:when>
			<xsl:when test="./code/text() = '2'">nur erweiterbar</xsl:when>
			<xsl:when test="./code/text() = '3'">alles modifizierbar</xsl:when>
			<xsl:otherwise>
				<xsl:if test="$Meldungen = '1'">
					<div class="Fehler E1033">Fehler!! E1033: Unbekannte Änderbarkeit der Struktur</div>
				</xsl:if>
			</xsl:otherwise>
		</xsl:choose>
	</xsl:template>
	<xsl:template match="xdf:ableitungsmodifikationenRepraesentation">
		<xsl:choose>
			<xsl:when test="./code/text() = '0'">nicht modifizierbar</xsl:when>
			<xsl:when test="./code/text() = '1'">modifizierbar</xsl:when>
			<xsl:otherwise>
				<xsl:if test="$Meldungen = '1'">
					<div class="Fehler E1034">Fehler!! E1034: Unbekannte Änderbarkeit der Repräsentation</div>
				</xsl:if>
			</xsl:otherwise>
		</xsl:choose>
	</xsl:template>
	<!-- ############################################################################################################# -->
	<xsl:template name="einrueckung">
		<xsl:param name="Tiefe"/>
		<xsl:param name="Zaehler"/>
		<xsl:param name="Text"/>
		<xsl:choose>
			<xsl:when test="$Zaehler = 0">
				<xsl:variable name="Text2">&#8970;</xsl:variable>
				<xsl:call-template name="einrueckung">
					<xsl:with-param name="Tiefe" select="$Tiefe"/>
					<xsl:with-param name="Zaehler" select="$Zaehler + 1"/>
					<xsl:with-param name="Text" select="$Text2"/>
				</xsl:call-template>
			</xsl:when>
			<xsl:when test="$Zaehler &lt; $Tiefe">
				<xsl:variable name="Text2">
					<xsl:value-of select="concat($Text, '__')"/>
				</xsl:variable>
				<xsl:call-template name="einrueckung">
					<xsl:with-param name="Tiefe" select="$Tiefe"/>
					<xsl:with-param name="Zaehler" select="$Zaehler + 1"/>
					<xsl:with-param name="Text" select="$Text2"/>
				</xsl:call-template>
			</xsl:when>
			<xsl:when test="$Zaehler = $Tiefe">
				<xsl:value-of select="$Text"/>
			</xsl:when>
		</xsl:choose>
	</xsl:template>
	<!-- ############################################################################################################# -->

	<xsl:template name="fileName">
	  <xsl:param name="path" />
	  <xsl:choose>
		<xsl:when test="contains($path,'\')">
			<xsl:value-of select="tokenize($path, '\\')[last()]"/>
		</xsl:when>
		<xsl:when test="contains($path,'/')">
			<xsl:value-of select="tokenize($path, '/')[last()]"/>
		</xsl:when>
		<xsl:otherwise>
		  <xsl:value-of select="$path"/>
		</xsl:otherwise>
	  </xsl:choose>
	</xsl:template>

	<!-- ############################################################################################################# -->

	<xsl:template name="navigationszeile">
		<xsl:if test="$DebugMode = '4'">
			<xsl:message>
				++++++++++++++++ navigationszeile ++++++++++++++++
			</xsl:message>
		</xsl:if>
		<!--
										<br/>
										<a href="#ElementListe">Übersicht der Elemente</a> - <a href="#ElementDetails">Details zu den Baukastenelementen</a> - <a href="#RegelListe">Übersicht der Regeln</a> - <a href="#RegelDetails">Details zu den Regeln</a> - <a href="#FormularListe">Übersicht der Formularsteckbriefe</a> - <a href="#FormularDetails">Details zu den Formularsteckbriefen</a>- <a href="#StammListe">Übersicht der Stammformulare</a> - <a  style="page-break-after:always" href="#StammDetails">Details zu den Stammformularen</a>
	-->
		<xsl:choose>
			<xsl:when test="$Navigation = '1' and $Statistik != '2'">
				<br/>
				<span class="TrennerNavi">
					<a style="text-decoration:none;" href="#" title="Öffne das Navigationsfenster" onclick="ZeigeNavigation(); return false;">.</a>
				</span>
				<hr/>
				<br/>
			</xsl:when>
			<xsl:otherwise>
				<br/>
				<hr/>
				<br/>
			</xsl:otherwise>
		</xsl:choose>
	</xsl:template>
	<!-- ############################################################################################################# -->
	<xsl:template name="styleandscript">
		<xsl:if test="$DebugMode = '1' or $DebugMode = '2' or $DebugMode = '3' or $DebugMode = '4'">
			<xsl:message>
				++++ styleandscript ++++
			</xsl:message>
		</xsl:if>
		<style type="text/css">
							
			body,h1,h2,h3,h4,a,th,td 
			{
				font-family: Arial;
				text-decoration: none;
				padding: 0 0 0 0;
				margin: 0 0 0 0;
				color: #000;
				font-size: 13px;
			}
			
			body 
			{
				color: #333;
				margin: 5px;
				padding: 0 0 0 0;
			/*	background-color: #fbfbfb; */
				background-color: #ffffff;
			}
			
			* html body 
			{
			margin: 0px 0px 0px 5px;	
			}
			
			 #fixiert {
				position: fixed;
				top: 0.5em; left: 0.5em;
				width: 18em;
				background-color: white;
				border: 1px solid silver;
				padding: 5px 5px 5px 5px;
			<xsl:if test="$Navigation = '0' or $Statistik = '2'">
				display:none;
			</xsl:if>
			  }

			  #fixiert img {
				height: 6.8em; float: right;
			  }
			
			  #zeigeLink {
				display:none;
			  }

			  #versteckeLink {
				display:inherit;
			  }

			  #Inhalt {
			 <xsl:choose>
				<xsl:when test="$Navigation = '0' or $Statistik = '2'">
				margin-left: 0.5em; 
				</xsl:when>
				<xsl:otherwise>
				margin-left: 20em; 
				border-left: 2px ridge gray; 
				border-top: 2px ridge gray;
				</xsl:otherwise>
			</xsl:choose>
				padding: 0 1em;
			  }

			  #FussStand {
			 <xsl:choose>
				<xsl:when test="$Navigation = '0' or $Statistik = '2'">
				display:inline;
				</xsl:when>
				<xsl:otherwise>
				display:none;
				</xsl:otherwise>
			</xsl:choose>
			  }

			h1
			{
				font-weight: bold;	
				font-size: 200%;
				margin-top: 18px;
				margin-bottom: 6px;
				page-break-after: avoid;
			}
			
			h2
			{
				font-weight: bold;
				font-size:140%;
				margin-top: 9px;
				margin-bottom: 3px;
				page-break-after: avoid;
			}
			
			h3
			{
				font-weight: bold;
				font-size:120%;
				margin-top: 9px;
				margin-bottom: 3px;
				page-break-after: avoid;
			}
			
			h4
			{
				font-weight: bold;	
			}
			
			div 
			{
				text-align: left;
			}
			
			table {
				border-style: hidden;
				border-width: thin;
			}
			
			tr:nth-child(odd) { 
			background: #FAFAFA; 
			}
			
			tr:nth-child(even) { 
			background: #FFFFFF; 
			}
			
			th, td {
				border-style: hidden;
				border-width: thin;
				empty-cells: show;
				text-align: left;
				vertical-align: text-top;
			}
			
			a 
			{
				color: #000;
				text-decoration: underline;
			}
			
			a:hover 
			{
				color: #000;
				text-decoration: underline;
				background-color: #eee;
			}
			
			a:visited 
			{
				color: #000;
			}
			
			.active 
			{
				cursor: pointer;
			}
			
			
			.NavigationsHeadline
			{
				font-weight: bold;
				font-size: 100%;
			}
			
			.SteckbriefName
			{
				font-weight: bold;
				font-size: 100%;
			}
			
			.SteckbriefID
			{
			}
			
			.SDSName
			{
				font-weight: bold;
				font-size: 100%;
			}
			
			.SDSID
			{
			}
			
			.ElementName
			{
				font-weight: bold;
				font-size: 100%;
			}
			
			.ElementID
			{
			}
			
			.RegelName
			{
				font-weight: bold;
				font-size: 100%;
			}
			
			.RegelID
			{
			}
			
			.Regel
			{
				font-style:italic;
			}
			
			.Navigation
			{
			}
			
			.Einrueckung
			{
				font-style:normal;
			}
			
			.TrennerNavi
			{
				display: none;
			}
			
			<xsl:if test="$Meldungen = '1'">
			.Hinweis
			{
				font-weight: bold;
				color:blue;
			}
			
			.Warnung
			{
				font-weight: bold;
				color:orange;
			}
			
			.Fehler
			{
				font-weight: bold;
				color:red;
			}
			.Zusammenfassung
			{
				font-weight: bold;
				font-size: 110%;
			}
			
			</xsl:if>
			
			#elementlisteallealpha
			{
				display: inline;
			}
			
			#elementlistealleid
			{
				display: none;
			}
			#elementlisteauszugalpha
			{
				display: inline;
			}
			
			#elementlisteauszugid
			{
				display: none;
			}
		</style>
		<xsl:if test="$JavaScript = '1'">
			<script type="text/javascript">
			function ZeigeAlleAlpha () {
				document.getElementById('elementlisteallealpha').style.display='inline';
				document.getElementById('elementlistealleid').style.display='none';
			}

			function ZeigeAlleID () {
				document.getElementById('elementlistealleid').style.display='inline';
				document.getElementById('elementlisteallealpha').style.display='none';
				window.location= "#ElementListe";
			}

			function ZeigeAuszugAlpha () {
				document.getElementById('elementlisteauszugalpha').style.display='inline';
				document.getElementById('elementlisteauszugid').style.display='none';
				window.location= "#ElementListe";
			}

			function ZeigeAuszugID () {
				document.getElementById('elementlisteauszugid').style.display='inline';
				document.getElementById('elementlisteauszugalpha').style.display='none';
			}

			<xsl:if test="$Navigation = '1' and $Statistik != '2'">
			function VersteckeNavigation() {
				const trennerClass = document.getElementsByClassName('TrennerNavi');

				document.getElementById('fixiert').style.display='none';
				document.getElementById('Inhalt').style.marginLeft='0.5em';
				document.getElementById('Inhalt').style.borderLeftStyle='none';
				document.getElementById('Inhalt').style.borderTopStyle='none';

				for (i = 0; i <xsl:text disable-output-escaping="yes">&lt;</xsl:text> trennerClass.length; i++) {
				  trennerClass[i].style.display='initial';
				}
			}

			function ZeigeNavigation() {
				const trennerClass = document.getElementsByClassName('TrennerNavi');

				document.getElementById('fixiert').style.display='inline';
				document.getElementById('Inhalt').style.marginLeft='20em';
				document.getElementById('Inhalt').style.borderLeftStyle='solid';
				document.getElementById('Inhalt').style.borderTopStyle='solid';

				for (i = 0; i <xsl:text disable-output-escaping="yes">&lt;</xsl:text> trennerClass.length; i++) {
				  trennerClass[i].style.display='none';
				}
			}
			</xsl:if>
				<xsl:if test="$Meldungen = '1'">

			function VersteckeMeldungen() {
				const hinweisClass = document.getElementsByClassName('Hinweis');
				const warningClass = document.getElementsByClassName('Warnung');
				const fehlerClass = document.getElementsByClassName('Fehler');
				
				for (i = 0; i <xsl:text disable-output-escaping="yes">&lt;</xsl:text> hinweisClass.length; i++) {
				  hinweisClass[i].style.display='none';
				}
				for (i = 0; i <xsl:text disable-output-escaping="yes">&lt;</xsl:text> warningClass.length; i++) {
				  warningClass[i].style.display='none';
				}
				for (i = 0; i <xsl:text disable-output-escaping="yes">&lt;</xsl:text> fehlerClass.length; i++) {
				  fehlerClass[i].style.display='none';
				}
				document.getElementById('versteckeLink').style.display='none';
				document.getElementById('zeigeLink').style.display='inherit';
				document.getElementById('Zusammenfassungsbereich').style.display='none';
				document.getElementById('ZusammenfassungLink').style.display='none';
			}
			
			function ZeigeMeldungen() {
				const hinweisClass = document.getElementsByClassName('Hinweis');
				const warningClass = document.getElementsByClassName('Warnung');
				const fehlerClass = document.getElementsByClassName('Fehler');
				
				for (i = 0; i <xsl:text disable-output-escaping="yes">&lt;</xsl:text> hinweisClass.length; i++) {
				  hinweisClass[i].style.display='inherit';
				}
				for (i = 0; i <xsl:text disable-output-escaping="yes">&lt;</xsl:text> warningClass.length; i++) {
				  warningClass[i].style.display='inherit';
				}
				for (i = 0; i <xsl:text disable-output-escaping="yes">&lt;</xsl:text> fehlerClass.length; i++) {
				  fehlerClass[i].style.display='inherit';
				}
				document.getElementById('versteckeLink').style.display='inherit';
				document.getElementById('zeigeLink').style.display='none';
				document.getElementById('Zusammenfassungsbereich').style.display='inherit';
				document.getElementById('ZusammenfassungLink').style.display='inherit';
			}
			</xsl:if>

			function ZaehleMeldungen() {
			<xsl:if test="$MeldungsFazit = '1' and $Meldungen = '1' and $JavaScript = '1'">
				const AnzahlFehler = document.querySelectorAll('.Fehler').length;
			
				document.getElementById("AnzahlFehler").innerHTML = "Anzahl Fehler: " + AnzahlFehler;

				const AnzahlWarnungen = document.querySelectorAll('.Warnung').length;
				document.getElementById("AnzahlWarnungen").innerHTML = "Anzahl Warnungen: " + AnzahlWarnungen;

				if (AnzahlFehler != 0)
				{
					document.getElementById("AnzahlFehler").style.color = "red";
				}

				if (document.querySelectorAll('.E1001').length != 0)
				{
					document.getElementById("FehlerListe").insertAdjacentHTML('beforeend', document.querySelectorAll('.E1001').length + " mal E1001: Eine Regel kann nicht auf ein referenziertes Baukastenelement zugreifen." + "<xsl:text disable-output-escaping="yes">&lt;</xsl:text>br/<xsl:text disable-output-escaping="yes">&gt;</xsl:text>");
				}
				if (document.querySelectorAll('.E1002').length != 0)
				{
					document.getElementById("FehlerListe").insertAdjacentHTML('beforeend', document.querySelectorAll('.E1002').length + " mal E1002: Der Name eines Elements ist nicht gesetzt." + "<xsl:text disable-output-escaping="yes">&lt;</xsl:text>br/<xsl:text disable-output-escaping="yes">&gt;</xsl:text>");
				}
				if (document.querySelectorAll('.E1003').length != 0)
				{
					document.getElementById("FehlerListe").insertAdjacentHTML('beforeend', document.querySelectorAll('.E1003').length + " mal E1003: In einem Datenschema darf ein Baukastenelement nicht mehrfach in unterschiedlichen Versionen enthalten sein." + "<xsl:text disable-output-escaping="yes">&lt;</xsl:text>br/<xsl:text disable-output-escaping="yes">&gt;</xsl:text>");
				}
				if (document.querySelectorAll('.E1004').length != 0)
				{
					document.getElementById("FehlerListe").insertAdjacentHTML('beforeend', document.querySelectorAll('.E1004').length + " mal E1004: In einer Datenfeldgruppe darf ein Baukastenelement nicht mehrfach in derselben Version enthalten sein." + "<xsl:text disable-output-escaping="yes">&lt;</xsl:text>br/<xsl:text disable-output-escaping="yes">&gt;</xsl:text>");
				}
				if (document.querySelectorAll('.E1005').length != 0)
				{
					document.getElementById("FehlerListe").insertAdjacentHTML('beforeend', document.querySelectorAll('.E1005').length + " mal E1005: Die Kennung einer Codeliste ist nicht als URN formuliert, z. B. urn:de:fim:codeliste:dokumenttyp." + "<xsl:text disable-output-escaping="yes">&lt;</xsl:text>br/<xsl:text disable-output-escaping="yes">&gt;</xsl:text>");
				}
				if (document.querySelectorAll('.E1006').length != 0)
				{
					document.getElementById("FehlerListe").insertAdjacentHTML('beforeend', document.querySelectorAll('.E1006').length + " mal E1006: Der Bezug zur Handlungsgrundlage darf bei Elementen mit der Strukturelementart 'rechtsnormgebunden' nicht leer sein." + "<xsl:text disable-output-escaping="yes">&lt;</xsl:text>br/<xsl:text disable-output-escaping="yes">&gt;</xsl:text>");
				}
				if (document.querySelectorAll('.E1008').length != 0)
				{
					document.getElementById("FehlerListe").insertAdjacentHTML('beforeend', document.querySelectorAll('.E1008').length + " mal E1008: Der Bezug zur Handlungsgrundlage darf bei Dokumentsteckbriefen nicht leer sein." + "<xsl:text disable-output-escaping="yes">&lt;</xsl:text>br/<xsl:text disable-output-escaping="yes">&gt;</xsl:text>");
				}
				if (document.querySelectorAll('.E1009').length != 0)
				{
					document.getElementById("FehlerListe").insertAdjacentHTML('beforeend', document.querySelectorAll('.E1009').length + " mal E1009: Die 'Bezeichnung Eingabe' muss befüllt werden." + "<xsl:text disable-output-escaping="yes">&lt;</xsl:text>br/<xsl:text disable-output-escaping="yes">&gt;</xsl:text>");
				}
				if (document.querySelectorAll('.E1010').length != 0)
				{
					document.getElementById("FehlerListe").insertAdjacentHTML('beforeend', document.querySelectorAll('.E1010').length + " mal E1010: Die 'Bezeichnung Ausgabe' muss befüllt werden." + "<xsl:text disable-output-escaping="yes">&lt;</xsl:text>br/<xsl:text disable-output-escaping="yes">&gt;</xsl:text>");
				}
				if (document.querySelectorAll('.E1011').length != 0)
				{
					document.getElementById("FehlerListe").insertAdjacentHTML('beforeend', document.querySelectorAll('.E1011').length + " mal E1011: Bei Datenfeldern mit der Feldart 'Auswahlfeld' sollte der Datentyp 'Text' sein - in seltenen Fällen 'Ganzzahl'." + "<xsl:text disable-output-escaping="yes">&lt;</xsl:text>br/<xsl:text disable-output-escaping="yes">&gt;</xsl:text>");
				}
				if (document.querySelectorAll('.E1012').length != 0)
				{
					document.getElementById("FehlerListe").insertAdjacentHTML('beforeend', document.querySelectorAll('.E1012').length + " mal E1012: Bei Datenfeldern mit der Feldart 'Auswahlfeld' oder 'Statisches, read-only Feld' dürfen weder die minimale noch die maximale Feldlänge angegeben werden." + "<xsl:text disable-output-escaping="yes">&lt;</xsl:text>br/<xsl:text disable-output-escaping="yes">&gt;</xsl:text>");
				}
				if (document.querySelectorAll('.E1013').length != 0)
				{
					document.getElementById("FehlerListe").insertAdjacentHTML('beforeend', document.querySelectorAll('.E1013').length + " mal E1013: Innerhalb von Datenschemata und Datenfeldgruppen dürfen nur Elemente mit der Strukturelementart harmonisiert oder rechtnormgebunden verwendet werden." + "<xsl:text disable-output-escaping="yes">&lt;</xsl:text>br/<xsl:text disable-output-escaping="yes">&gt;</xsl:text>");
				}
				if (document.querySelectorAll('.E1014').length != 0)
				{
					document.getElementById("FehlerListe").insertAdjacentHTML('beforeend', document.querySelectorAll('.E1014').length + " mal E1014: Datenfelder dürfen nicht die Strukturelementart 'abstrakt' haben." + "<xsl:text disable-output-escaping="yes">&lt;</xsl:text>br/<xsl:text disable-output-escaping="yes">&gt;</xsl:text>");
				}
				if (document.querySelectorAll('.E1015').length != 0)
				{
					document.getElementById("FehlerListe").insertAdjacentHTML('beforeend', document.querySelectorAll('.E1015').length + " mal E1015: Eine Feldlänge darf nur bei einem Datenfeld mit dem Datentyp 'Text' angegeben werden." + "<xsl:text disable-output-escaping="yes">&lt;</xsl:text>br/<xsl:text disable-output-escaping="yes">&gt;</xsl:text>");
				}
				if (document.querySelectorAll('.E1016').length != 0)
				{
					document.getElementById("FehlerListe").insertAdjacentHTML('beforeend', document.querySelectorAll('.E1016').length + " mal E1016: Ein Wertebereich darf nur bei einem Datenfeld mit einem nummerischen Datentyp (Nummer, Ganzzahl, Geldbetrag) oder einem Datumsdatentyp angegeben werden." + "<xsl:text disable-output-escaping="yes">&lt;</xsl:text>br/<xsl:text disable-output-escaping="yes">&gt;</xsl:text>");
				}
				if (document.querySelectorAll('.E1017').length != 0)
				{
					document.getElementById("FehlerListe").insertAdjacentHTML('beforeend', document.querySelectorAll('.E1017').length + " mal E1017: Ist eine Codeliste zugeordnet, muss die Feldart 'Auswahlfeld' sein." + "<xsl:text disable-output-escaping="yes">&lt;</xsl:text>br/<xsl:text disable-output-escaping="yes">&gt;</xsl:text>");
				}
				if (document.querySelectorAll('.E1018').length != 0)
				{
					document.getElementById("FehlerListe").insertAdjacentHTML('beforeend', document.querySelectorAll('.E1018').length + " mal E1018: Wenn ein Datenfeld die Feldart 'Auswahlfeld' hat, muss eine Codeliste zugeordnet sein." + "<xsl:text disable-output-escaping="yes">&lt;</xsl:text>br/<xsl:text disable-output-escaping="yes">&gt;</xsl:text>");
				}
				if (document.querySelectorAll('.E1019').length != 0)
				{
					document.getElementById("FehlerListe").insertAdjacentHTML('beforeend', document.querySelectorAll('.E1019').length + " mal E1019: Baukastenelemente, die in Regeln referenziert werden, dürfen keine Versionsangaben beinhalten" + "<xsl:text disable-output-escaping="yes">&lt;</xsl:text>br/<xsl:text disable-output-escaping="yes">&gt;</xsl:text>");
				}
<!--
				if (document.querySelectorAll('.E1020').length != 0)
				{
					document.getElementById("FehlerListe").insertAdjacentHTML('beforeend', document.querySelectorAll('.E1020').length + " mal E1020: Baukastenelemente im Status 'inaktiv' dürfen nicht verwendet werden." + "<xsl:text disable-output-escaping="yes">&lt;</xsl:text>br/<xsl:text disable-output-escaping="yes">&gt;</xsl:text>");
				}
-->				if (document.querySelectorAll('.E1021').length != 0)
				{
					document.getElementById("FehlerListe").insertAdjacentHTML('beforeend', document.querySelectorAll('.E1021').length + " mal E1021: Es ist keine Multiplizität angegeben." + "<xsl:text disable-output-escaping="yes">&lt;</xsl:text>br/<xsl:text disable-output-escaping="yes">&gt;</xsl:text>");
				}
				if (document.querySelectorAll('.E1022').length != 0)
				{
					document.getElementById("FehlerListe").insertAdjacentHTML('beforeend', document.querySelectorAll('.E1022').length + " mal E1022: Bei Verwendung von Elementen mit der Strukturelementart 'abstrakt' oder 'harmonisiert' innerhalb von Datenfeldgruppen mit der Strukturelementart 'rechtsnormgebunden' muss zur Multiplizität ein Bezug zu einer Handlungsgrundlage angegeben werden." + "<xsl:text disable-output-escaping="yes">&lt;</xsl:text>br/<xsl:text disable-output-escaping="yes">&gt;</xsl:text>");
				}
				if (document.querySelectorAll('.E1023').length != 0)
				{
					document.getElementById("FehlerListe").insertAdjacentHTML('beforeend', document.querySelectorAll('.E1023').length + " mal E1023: Datenfeldgruppe hat keine Unterelemente." + "<xsl:text disable-output-escaping="yes">&lt;</xsl:text>br/<xsl:text disable-output-escaping="yes">&gt;</xsl:text>");
				}
				if (document.querySelectorAll('.E1024').length != 0)
				{
					document.getElementById("FehlerListe").insertAdjacentHTML('beforeend', document.querySelectorAll('.E1024').length + " mal E1024: Die Definition einer Regel muss befüllt sein." + "<xsl:text disable-output-escaping="yes">&lt;</xsl:text>br/<xsl:text disable-output-escaping="yes">&gt;</xsl:text>");
				}
				if (document.querySelectorAll('.E1025').length != 0)
				{
					document.getElementById("FehlerListe").insertAdjacentHTML('beforeend', document.querySelectorAll('.E1025').length + " mal E1025: In einem Datenschema dürfen Baukastenelement auf oberster Ebene nicht mehrfach in derselben Version enthalten sein." + "<xsl:text disable-output-escaping="yes">&lt;</xsl:text>br/<xsl:text disable-output-escaping="yes">&gt;</xsl:text>");
				}
				if (document.querySelectorAll('.E1026').length != 0)
				{
					document.getElementById("FehlerListe").insertAdjacentHTML('beforeend', document.querySelectorAll('.E1026').length + " mal E1026: Zirkelbezug" + "<xsl:text disable-output-escaping="yes">&lt;</xsl:text>br/<xsl:text disable-output-escaping="yes">&gt;</xsl:text>");
				}
				if (document.querySelectorAll('.E1027').length != 0)
				{
					document.getElementById("FehlerListe").insertAdjacentHTML('beforeend', document.querySelectorAll('.E1027').length + " mal E1027: Unbekannte Feldart." + "<xsl:text disable-output-escaping="yes">&lt;</xsl:text>br/<xsl:text disable-output-escaping="yes">&gt;</xsl:text>");
				}
				if (document.querySelectorAll('.E1028').length != 0)
				{
					document.getElementById("FehlerListe").insertAdjacentHTML('beforeend', document.querySelectorAll('.E1028').length + " mal E1028: Unbekannter Datentyp." + "<xsl:text disable-output-escaping="yes">&lt;</xsl:text>br/<xsl:text disable-output-escaping="yes">&gt;</xsl:text>");
				}
				if (document.querySelectorAll('.E1031').length != 0)
				{
					document.getElementById("FehlerListe").insertAdjacentHTML('beforeend', document.querySelectorAll('.E1031').length + " mal E1031: Unbekannte Strukturelementart." + "<xsl:text disable-output-escaping="yes">&lt;</xsl:text>br/<xsl:text disable-output-escaping="yes">&gt;</xsl:text>");
				}
				if (document.querySelectorAll('.E1032').length != 0)
				{
					document.getElementById("FehlerListe").insertAdjacentHTML('beforeend', document.querySelectorAll('.E1032').length + " mal E1032: Unbekannter Status." + "<xsl:text disable-output-escaping="yes">&lt;</xsl:text>br/<xsl:text disable-output-escaping="yes">&gt;</xsl:text>");
				}
				if (document.querySelectorAll('.E1033').length != 0)
				{
					document.getElementById("FehlerListe").insertAdjacentHTML('beforeend', document.querySelectorAll('.E1033').length + " mal E1033: Unbekannte Änderbarkeit der Struktur." + "<xsl:text disable-output-escaping="yes">&lt;</xsl:text>br/<xsl:text disable-output-escaping="yes">&gt;</xsl:text>");
				}
				if (document.querySelectorAll('.E1034').length != 0)
				{
					document.getElementById("FehlerListe").insertAdjacentHTML('beforeend', document.querySelectorAll('.E1034').length + " mal E1034: Unbekannte Änderbarkeit der Repräsentation." + "<xsl:text disable-output-escaping="yes">&lt;</xsl:text>br/<xsl:text disable-output-escaping="yes">&gt;</xsl:text>");
				}
				if (document.querySelectorAll('.E1046').length != 0)
				{
					document.getElementById("FehlerListe").insertAdjacentHTML('beforeend', document.querySelectorAll('.E1046').length + " mal E1046: Die Multiplizität entspricht nicht den Formatvorgaben." + "<xsl:text disable-output-escaping="yes">&lt;</xsl:text>br/<xsl:text disable-output-escaping="yes">&gt;</xsl:text>");
				}
				if (document.querySelectorAll('.E1047').length != 0)
				{
					document.getElementById("FehlerListe").insertAdjacentHTML('beforeend', document.querySelectorAll('.E1047').length + " mal E1047: In der Multiplizität muss die minimale Anzahl kleiner oder gleich der maximalen Anzahl sein." + "<xsl:text disable-output-escaping="yes">&lt;</xsl:text>br/<xsl:text disable-output-escaping="yes">&gt;</xsl:text>");
				}
				if (document.querySelectorAll('.E1048').length != 0)
				{
					document.getElementById("FehlerListe").insertAdjacentHTML('beforeend', document.querySelectorAll('.E1048').length + " mal E1048: Die URN-Kennung einer Codeliste entspricht nicht den Formatvorgaben, z. B. urn:de:fim:codeliste:dokumenttyp (Umlaute sind nicht erlaubt!)." + "<xsl:text disable-output-escaping="yes">&lt;</xsl:text>br/<xsl:text disable-output-escaping="yes">&gt;</xsl:text>");
				}
				if (document.querySelectorAll('.E1059').length != 0)
				{
					document.getElementById("FehlerListe").insertAdjacentHTML('beforeend', document.querySelectorAll('.E1059').length + " mal E1059: Die minimale Feldlänge muss eine ganze Zahl größer oder gleich Null sein." + "<xsl:text disable-output-escaping="yes">&lt;</xsl:text>br/<xsl:text disable-output-escaping="yes">&gt;</xsl:text>");
				}
				if (document.querySelectorAll('.E1060').length != 0)
				{
					document.getElementById("FehlerListe").insertAdjacentHTML('beforeend', document.querySelectorAll('.E1060').length + " mal E1060: Die maximale Feldlänge muss eine ganze Zahl größer Null sein." + "<xsl:text disable-output-escaping="yes">&lt;</xsl:text>br/<xsl:text disable-output-escaping="yes">&gt;</xsl:text>");
				}
				if (document.querySelectorAll('.E1061').length != 0)
				{
					document.getElementById("FehlerListe").insertAdjacentHTML('beforeend', document.querySelectorAll('.E1061').length + " mal E1061: Die minimale Feldlänge darf nicht größer sein als die maximale Feldlänge." + "<xsl:text disable-output-escaping="yes">&lt;</xsl:text>br/<xsl:text disable-output-escaping="yes">&gt;</xsl:text>");
				}
				if (document.querySelectorAll('.E1062').length != 0)
				{
					document.getElementById("FehlerListe").insertAdjacentHTML('beforeend', document.querySelectorAll('.E1062').length + " mal E1062: Die untere Wertgrenze muss eine Zahl sein." + "<xsl:text disable-output-escaping="yes">&lt;</xsl:text>br/<xsl:text disable-output-escaping="yes">&gt;</xsl:text>");
				}
				if (document.querySelectorAll('.E1063').length != 0)
				{
					document.getElementById("FehlerListe").insertAdjacentHTML('beforeend', document.querySelectorAll('.E1063').length + " mal E1063: Die obere Wertgrenze muss eine Zahl sein.." + "<xsl:text disable-output-escaping="yes">&lt;</xsl:text>br/<xsl:text disable-output-escaping="yes">&gt;</xsl:text>");
				}
				if (document.querySelectorAll('.E1064').length != 0)
				{
					document.getElementById("FehlerListe").insertAdjacentHTML('beforeend', document.querySelectorAll('.E1064').length + " mal E1064: Die untere Wertgrenze darf nicht größer sein als die obere Wertgrenze." + "<xsl:text disable-output-escaping="yes">&lt;</xsl:text>br/<xsl:text disable-output-escaping="yes">&gt;</xsl:text>");
				}
				if (document.querySelectorAll('.E1065').length != 0)
				{
					document.getElementById("FehlerListe").insertAdjacentHTML('beforeend', document.querySelectorAll('.E1065').length + " mal E1065: Die untere Wertgrenze muss eine ganze Zahl sein." + "<xsl:text disable-output-escaping="yes">&lt;</xsl:text>br/<xsl:text disable-output-escaping="yes">&gt;</xsl:text>");
				}
				if (document.querySelectorAll('.E1066').length != 0)
				{
					document.getElementById("FehlerListe").insertAdjacentHTML('beforeend', document.querySelectorAll('.E1066').length + " mal E1066: Die obere Wertgrenze muss eine ganze Zahl sein." + "<xsl:text disable-output-escaping="yes">&lt;</xsl:text>br/<xsl:text disable-output-escaping="yes">&gt;</xsl:text>");
				}
				if (document.querySelectorAll('.E1067').length != 0)
				{
					document.getElementById("FehlerListe").insertAdjacentHTML('beforeend', document.querySelectorAll('.E1067').length + " mal E1067: Die untere Wertgrenze muss ein Datum sein." + "<xsl:text disable-output-escaping="yes">&lt;</xsl:text>br/<xsl:text disable-output-escaping="yes">&gt;</xsl:text>");
				}
				if (document.querySelectorAll('.E1068').length != 0)
				{
					document.getElementById("FehlerListe").insertAdjacentHTML('beforeend', document.querySelectorAll('.E1068').length + " mal E1068: Die obere Wertgrenze muss ein Datum sein." + "<xsl:text disable-output-escaping="yes">&lt;</xsl:text>br/<xsl:text disable-output-escaping="yes">&gt;</xsl:text>");
				}
				if (document.querySelectorAll('.E1069').length != 0)
				{
					document.getElementById("FehlerListe").insertAdjacentHTML('beforeend', document.querySelectorAll('.E1069').length + " mal E1069: Der Inhalt muss eine Zahl sein." + "<xsl:text disable-output-escaping="yes">&lt;</xsl:text>br/<xsl:text disable-output-escaping="yes">&gt;</xsl:text>");
				}
				if (document.querySelectorAll('.E1070').length != 0)
				{
					document.getElementById("FehlerListe").insertAdjacentHTML('beforeend', document.querySelectorAll('.E1070').length + " mal E1070: Der Inhalt muss eine ganze Zahl sein.." + "<xsl:text disable-output-escaping="yes">&lt;</xsl:text>br/<xsl:text disable-output-escaping="yes">&gt;</xsl:text>");
				}
				if (document.querySelectorAll('.E1071').length != 0)
				{
					document.getElementById("FehlerListe").insertAdjacentHTML('beforeend', document.querySelectorAll('.E1071').length + " mal E1071: Der Inhalt muss ein Datum sein." + "<xsl:text disable-output-escaping="yes">&lt;</xsl:text>br/<xsl:text disable-output-escaping="yes">&gt;</xsl:text>");
				}
				if (document.querySelectorAll('.E1072').length != 0)
				{
					document.getElementById("FehlerListe").insertAdjacentHTML('beforeend', document.querySelectorAll('.E1072').length + " mal E1072: Der Inhalt unterschreitet die untere Wertgrenze." + "<xsl:text disable-output-escaping="yes">&lt;</xsl:text>br/<xsl:text disable-output-escaping="yes">&gt;</xsl:text>");
				}
				if (document.querySelectorAll('.E1073').length != 0)
				{
					document.getElementById("FehlerListe").insertAdjacentHTML('beforeend', document.querySelectorAll('.E1073').length + " mal E1073: Der Inhalt überschreitet die obere Wertgrenze." + "<xsl:text disable-output-escaping="yes">&lt;</xsl:text>br/<xsl:text disable-output-escaping="yes">&gt;</xsl:text>");
				}
				if (document.querySelectorAll('.E1074').length != 0)
				{
					document.getElementById("FehlerListe").insertAdjacentHTML('beforeend', document.querySelectorAll('.E1074').length + " mal E1074: Der Inhalt unterschreitet die Minimallänge." + "<xsl:text disable-output-escaping="yes">&lt;</xsl:text>br/<xsl:text disable-output-escaping="yes">&gt;</xsl:text>");
				}
				if (document.querySelectorAll('.E1075').length != 0)
				{
					document.getElementById("FehlerListe").insertAdjacentHTML('beforeend', document.querySelectorAll('.E1075').length + " mal E1075: Der Inhalt überschreitet die Maximallänge." + "<xsl:text disable-output-escaping="yes">&lt;</xsl:text>br/<xsl:text disable-output-escaping="yes">&gt;</xsl:text>");
				}
				if (document.querySelectorAll('.E1077').length != 0)
				{
					document.getElementById("FehlerListe").insertAdjacentHTML('beforeend', document.querySelectorAll('.E1077').length + " mal E1077: Der Inhalt muss ein Wahrheitswert sein (true oder false)." + "<xsl:text disable-output-escaping="yes">&lt;</xsl:text>br/<xsl:text disable-output-escaping="yes">&gt;</xsl:text>");
				}

<!-- nur XDF2 -->
				if (document.querySelectorAll('.E1035').length != 0)
				{
					document.getElementById("FehlerListe").insertAdjacentHTML('beforeend', document.querySelectorAll('.E1035').length + " mal E1035: Hinweis noch im alten Format." + "<xsl:text disable-output-escaping="yes">&lt;</xsl:text>br/<xsl:text disable-output-escaping="yes">&gt;</xsl:text>");
				}
				if (document.querySelectorAll('.E1036').length != 0)
				{
					document.getElementById("FehlerListe").insertAdjacentHTML('beforeend', document.querySelectorAll('.E1036').length + " mal E1036: In einer Codeliste muss die Kombination aus Kennung und Version immer eindeutig sein." + "<xsl:text disable-output-escaping="yes">&lt;</xsl:text>br/<xsl:text disable-output-escaping="yes">&gt;</xsl:text>");
				}
				if (document.querySelectorAll('.E1037').length != 0)
				{
					document.getElementById("FehlerListe").insertAdjacentHTML('beforeend', document.querySelectorAll('.E1037').length + " mal E1037: In einem Datenschema darf eine Codeliste nicht in mehreren Versionen verwendet werden." + "<xsl:text disable-output-escaping="yes">&lt;</xsl:text>br/<xsl:text disable-output-escaping="yes">&gt;</xsl:text>");
				}
				if (document.querySelectorAll('.E1038').length != 0)
				{
					document.getElementById("FehlerListe").insertAdjacentHTML('beforeend', document.querySelectorAll('.E1038').length + " mal E1038: Die ID eines Objektes ist nicht gesetzt." + "<xsl:text disable-output-escaping="yes">&lt;</xsl:text>br/<xsl:text disable-output-escaping="yes">&gt;</xsl:text>");
				}
				if (document.querySelectorAll('.E1039').length != 0)
				{
					document.getElementById("FehlerListe").insertAdjacentHTML('beforeend', document.querySelectorAll('.E1039').length + " mal E1039: Das Format der ID entspricht nicht den Vorgaben." + "<xsl:text disable-output-escaping="yes">&lt;</xsl:text>br/<xsl:text disable-output-escaping="yes">&gt;</xsl:text>");
				}
				if (document.querySelectorAll('.E1040').length != 0)
				{
					document.getElementById("FehlerListe").insertAdjacentHTML('beforeend', document.querySelectorAll('.E1040').length + " mal E1040: Die Kennung einer Codeliste ist leer." + "<xsl:text disable-output-escaping="yes">&lt;</xsl:text>br/<xsl:text disable-output-escaping="yes">&gt;</xsl:text>");
				}
				
				if (document.querySelectorAll('.W1001').length != 0)
				{
					document.getElementById("WarnungsListe").insertAdjacentHTML('beforeend', document.querySelectorAll('.W1001').length + " mal W1001: Der Bezug zur Handlungsgrundlage sollte bei Elementen mit der Strukturelementart 'harmonisiert' möglichst nicht leer sein." + "<xsl:text disable-output-escaping="yes">&lt;</xsl:text>br/<xsl:text disable-output-escaping="yes">&gt;</xsl:text>");
				}
				if (document.querySelectorAll('.W1002').length != 0)
				{
					document.getElementById("WarnungsListe").insertAdjacentHTML('beforeend', document.querySelectorAll('.W1002').length + " mal W1002: Bei Eingabedatenfeldern mit dem Datentyp 'Text' sollten, wenn möglich, die minimale und maximale Feldlänge angegeben werden." + "<xsl:text disable-output-escaping="yes">&lt;</xsl:text>br/<xsl:text disable-output-escaping="yes">&gt;</xsl:text>");
				}
				if (document.querySelectorAll('.W1003').length != 0)
				{
					document.getElementById("WarnungsListe").insertAdjacentHTML('beforeend', document.querySelectorAll('.W1003').length + " mal W1003: Bei Datenfeldern mit dem Datentyp 'Nummer', 'Ganzzahl', 'Geldbetrag' oder 'Datum' sollte, wenn möglich, ein Wertebereich angegeben werden." + "<xsl:text disable-output-escaping="yes">&lt;</xsl:text>br/<xsl:text disable-output-escaping="yes">&gt;</xsl:text>");
				}
<!--
				if (document.querySelectorAll('.W1004').length != 0)
				{
					document.getElementById("WarnungsListe").insertAdjacentHTML('beforeend', document.querySelectorAll('.W1004').length + " mal W1004: Zu einer Regel ist kein Script definiert" + "<xsl:text disable-output-escaping="yes">&lt;</xsl:text>br/<xsl:text disable-output-escaping="yes">&gt;</xsl:text>");
				}
-->
				if (document.querySelectorAll('.W1005').length != 0)
				{
					document.getElementById("WarnungsListe").insertAdjacentHTML('beforeend', document.querySelectorAll('.W1005').length + " mal W1005: Die Version einer Codeliste sollte im Datumsformat in folgender Form angegeben werden, z. B. 2018-03-01." + "<xsl:text disable-output-escaping="yes">&lt;</xsl:text>br/<xsl:text disable-output-escaping="yes">&gt;</xsl:text>");
				}
				if (document.querySelectorAll('.W1006').length != 0)
				{
					document.getElementById("WarnungsListe").insertAdjacentHTML('beforeend', document.querySelectorAll('.W1006').length + " mal W1006: Eine Datenfeldgruppe sollte mehr als ein Unterelement haben." + "<xsl:text disable-output-escaping="yes">&lt;</xsl:text>br/<xsl:text disable-output-escaping="yes">&gt;</xsl:text>");
				}
				if (document.querySelectorAll('.W1007').length != 0)
				{
					document.getElementById("WarnungsListe").insertAdjacentHTML('beforeend', document.querySelectorAll('.W1007').length + " mal W1007: Der Hilfetext eines Dokumentsteckbriefs sollte befüllt werden." + "<xsl:text disable-output-escaping="yes">&lt;</xsl:text>br/<xsl:text disable-output-escaping="yes">&gt;</xsl:text>");
				}
				if (document.querySelectorAll('.W1008').length != 0)
				{
					document.getElementById("WarnungsListe").insertAdjacentHTML('beforeend', document.querySelectorAll('.W1008').length + " mal W1008: Wenn ein Datenfeld die Feldart 'Auswahl' hat, sollte der Datentyp i. d. R. vom Typ 'Text' sein." + "<xsl:text disable-output-escaping="yes">&lt;</xsl:text>br/<xsl:text disable-output-escaping="yes">&gt;</xsl:text>");
				}
				if (document.querySelectorAll('.W1009').length != 0)
				{
					document.getElementById("WarnungsListe").insertAdjacentHTML('beforeend', document.querySelectorAll('.W1009').length + " mal W1009: Bei einem Feld mit nur lesendem Zugriff, der Feldart 'Statisch' wird i. d. R. der Inhalt mit einem Text befüllt." + "<xsl:text disable-output-escaping="yes">&lt;</xsl:text>br/<xsl:text disable-output-escaping="yes">&gt;</xsl:text>");
				}
				if (document.querySelectorAll('.W1010').length != 0)
				{
					document.getElementById("WarnungsListe").insertAdjacentHTML('beforeend', document.querySelectorAll('.W1010').length + " mal W1010: In Codelisten sollte der Bezug zur Handlungsgrundlage nicht leer sein." + "<xsl:text disable-output-escaping="yes">&lt;</xsl:text>br/<xsl:text disable-output-escaping="yes">&gt;</xsl:text>");
				}
				if (document.querySelectorAll('.W1011').length != 0)
				{
					document.getElementById("WarnungsListe").insertAdjacentHTML('beforeend', document.querySelectorAll('.W1011').length + " mal W1011: Codeliste wird nicht verwendet." + "<xsl:text disable-output-escaping="yes">&lt;</xsl:text>br/<xsl:text disable-output-escaping="yes">&gt;</xsl:text>");
				}
				if (document.querySelectorAll('.W1012').length != 0)
				{
					document.getElementById("WarnungsListe").insertAdjacentHTML('beforeend', document.querySelectorAll('.W1012').length + " mal W1012: Versionierte Baukastenelemente, die nicht verwendet werden, sollten gelöscht werden." + "<xsl:text disable-output-escaping="yes">&lt;</xsl:text>br/<xsl:text disable-output-escaping="yes">&gt;</xsl:text>");
				}
				if (document.querySelectorAll('.W1013').length != 0)
				{
					document.getElementById("WarnungsListe").insertAdjacentHTML('beforeend', document.querySelectorAll('.W1013').length + " mal W1013: Eine Arbeitsversion, die nicht verwendet wird und keine Versionen hat, sollte gelöscht werden." + "<xsl:text disable-output-escaping="yes">&lt;</xsl:text>br/<xsl:text disable-output-escaping="yes">&gt;</xsl:text>");
				}
				if (document.querySelectorAll('.W1014').length != 0)
				{
					document.getElementById("WarnungsListe").insertAdjacentHTML('beforeend', document.querySelectorAll('.W1014').length + " mal W1014: Element wird nicht verwendet." + "<xsl:text disable-output-escaping="yes">&lt;</xsl:text>br/<xsl:text disable-output-escaping="yes">&gt;</xsl:text>");
				}
				if (document.querySelectorAll('.W1015').length != 0)
				{
					document.getElementById("WarnungsListe").insertAdjacentHTML('beforeend', document.querySelectorAll('.W1015').length + " mal W1015: Die Codeliste konnte nicht geladen werden." + "<xsl:text disable-output-escaping="yes">&lt;</xsl:text>br/<xsl:text disable-output-escaping="yes">&gt;</xsl:text>");
				}
				if (document.querySelectorAll('.W1016').length != 0)
				{
					document.getElementById("WarnungsListe").insertAdjacentHTML('beforeend', document.querySelectorAll('.W1016').length + " mal W1016: Baukastenelemente im Status 'inaktiv' sollten nur in Ausnahmefällen verwendet werden." + "<xsl:text disable-output-escaping="yes">&lt;</xsl:text>br/<xsl:text disable-output-escaping="yes">&gt;</xsl:text>");
				}
			</xsl:if>
			}

		</script>
		</xsl:if>
	</xsl:template>
	<!-- ############################################################################################################# -->
	<!-- ################O#####O#O#OO################################################################################# -->
	<!-- #################O#O#O##O#OOO################################################################################ -->
	<!-- ##################O#O###O#O################################################################################## -->
	<!-- ############################################################################################################# -->
	<!-- ############################################################################################################# -->
	<!-- ############################################################################################################# -->
	<!-- ############################################################################################################# -->
	<xsl:template name="elementlisteauszug">
		<xsl:param name="StammformularID"/>
		<xsl:param name="StammformularVersion"/>
		<xsl:variable name="UnterelementIDsGesamtUnsortiert">
			<xsl:for-each select="$Daten/*/Stammformulare/Stammformular[Id = $StammformularID and Version=$StammformularVersion]">
				<xsl:call-template name="beinhalteteelemente">
					<xsl:with-param name="Element" select="."/>
				</xsl:call-template>
			</xsl:for-each>
		</xsl:variable>
		<span id="elementlisteauszugalpha">
			<h2>
				<a name="ElementListe"/>Übersicht der Elemente im Stammformular <xsl:value-of select="$StammformularID"/>&#160;Version&#160;<xsl:value-of select="$StammformularVersion"/>
			</h2>
			<table style="page-break-after:always">
				<thead>
					<tr>
						<th>ID&#160;<a href="#" onclick="ZeigeAuszugID(); return false;">&#8593;</a>
						</th>
						<th>Version</th>
						<th>Name</th>
						<th>Bezeichnung</th>
					</tr>
				</thead>
				<tbody>
					<xsl:for-each-group select="//$UnterelementIDsGesamtUnsortiert/*/xdf:id" group-by=".">
						<xsl:sort select=".././xdf:name"/>
						<xsl:variable name="ElementID">
							<xsl:value-of select="."/>
						</xsl:variable>
						<xsl:for-each select="$Daten/*/Formularfelder/Formularfeld[Id = $ElementID] | $Daten/*/Formularfeldgruppen/Formularfeldgruppe[Id = $ElementID] ">
							<tr>
								<td>
									<xsl:element name="a">
										<xsl:attribute name="href">#<xsl:value-of select="./xdf:id"/></xsl:attribute>
										<xsl:value-of select="./xdf:id"/>
									</xsl:element>
								</td>
								<td>
									<xsl:value-of select="./xdf:version"/>
								</td>
								<td>
									<xsl:value-of select="./xdf:name"/>
								</td>
								<td>
									<xsl:value-of select="./Bezeichnung"/>
								</td>
							</tr>
						</xsl:for-each>
					</xsl:for-each-group>
					<tr>
						<td colspan="4">
							<br/>
							<br/>
							<br/>
							<br/>
						</td>
					</tr>
				</tbody>
			</table>
		</span>
		<span id="elementlisteauszugid">
			<h2>
				<a name="ElementListe"/>Übersicht der Elemente im Stammformular <xsl:value-of select="$StammformularID"/>&#160;Version&#160;<xsl:value-of select="$StammformularVersion"/>
			</h2>
			<table style="page-break-after:always">
				<thead>
					<tr>
						<th>ID</th>
						<th>Version</th>
						<th>Name&#160;<a href="#" onclick="ZeigeAuszugAlpha(); return false;">&#8593;</a>
						</th>
						<th>Bezeichnung</th>
					</tr>
				</thead>
				<tbody>
					<xsl:for-each-group select="//$UnterelementIDsGesamtUnsortiert/*/xdf:id" group-by=".">
						<xsl:sort select=".././xdf:id"/>
						<xsl:variable name="ElementID">
							<xsl:value-of select="."/>
						</xsl:variable>
						<xsl:for-each select="$Daten/*/Formularfelder/Formularfeld[Id = $ElementID] | $Daten/*/Formularfeldgruppen/Formularfeldgruppe[Id = $ElementID] ">
							<tr>
								<td>
									<xsl:element name="a">
										<xsl:attribute name="href">#<xsl:value-of select="./xdf:id"/></xsl:attribute>
										<xsl:value-of select="./xdf:id"/>
									</xsl:element>
								</td>
								<td>
									<xsl:value-of select="./xdf:version"/>
								</td>
								<td>
									<xsl:value-of select="./xdf:name"/>
								</td>
								<td>
									<xsl:value-of select="./Bezeichnung"/>
								</td>
							</tr>
						</xsl:for-each>
					</xsl:for-each-group>
					<tr>
						<td colspan="4">
							<br/>
							<br/>
							<br/>
							<br/>
						</td>
					</tr>
				</tbody>
			</table>
		</span>
	</xsl:template>
	<!-- ############################################################################################################# -->
	<xsl:template name="beinhalteteelemente">
		<xsl:param name="Element"/>
		<xsl:for-each select="//$Element/xdf:regeln/xdf:regel">
			<xsl:variable name="ElementID" select="./xdf:id"/>
			<xsl:variable name="Element2">
				<xsl:copy-of select="$Daten/*/xdf:regeln/xdf:regel[Id = $ElementID]"/>
			</xsl:variable>
			<xsl:element name="KopfDaten">
				<xsl:copy-of select="$Element2/*/xdf:id"/>
				<xsl:element name="Name">
					<xsl:value-of select="$Element2/*/Bezeichnung"/>
				</xsl:element>
			</xsl:element>
		</xsl:for-each>
		<xsl:for-each select="//$Element/xdf:struktur/*">
			<xsl:variable name="ElementID" select="./xdf:id"/>
			<xsl:variable name="Element2">
				<xsl:copy-of select="$Daten/*/Formularfelder/Formularfeld[Id = $ElementID]"/>
				<xsl:copy-of select="$Daten/*/Formularfeldgruppen/Formularfeldgruppe[Id = $ElementID]"/>
			</xsl:variable>
			<xsl:element name="KopfDaten">
				<xsl:copy-of select="$Element2/*/xdf:id"/>
				<xsl:copy-of select="$Element2/*/xdf:name"/>
			</xsl:element>
			<xsl:call-template name="beinhalteteelemente">
				<xsl:with-param name="Element" select="$Element2/*"/>
			</xsl:call-template>
		</xsl:for-each>
	</xsl:template>
	<!-- ############################################################################################################# -->
</xsl:stylesheet>
