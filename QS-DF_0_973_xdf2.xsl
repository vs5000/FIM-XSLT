<?xml version="1.0" encoding="iso-8859-1"?>
<xsl:stylesheet version="2.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:html="http://www.w3.org/1999/xhtml" xmlns="http://www.w3.org/1999/xhtml" xmlns:fn="http://www.w3.org/2005/xpath-functions" xmlns:xdf="urn:xoev-de:fim:standard:xdatenfelder_2" xmlns:gc="http://docs.oasis-open.org/codelist/ns/genericode/1.0/" xmlns:xs="http://www.w3.org/2001/XMLSchema" exclude-result-prefixes="html xs">
	<!--
	Copyright 2024 Volker Schmitz
	
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

	<xsl:variable name="StyleSheetName" select="'QS-DF_0_973_xdf2.xsl'"/> <!-- BackUp, falls fn:static-base-uri() leer -->
	
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
	<xsl:param name="QSHilfeAufruf" select="'1'"/>
	<xsl:param name="QSHilfePfadPrefix" select="'https://docs.fitko.de/fim/docs/datenfelder/QS_Bericht#'"/>
	<xsl:param name="QSHilfePfadPostfix" select="''"/>
	<xsl:param name="Statistik" select="'0'"/>
	<xsl:param name="StatistikVerwendung" select="'1'"/>
	<xsl:param name="StatistikStrukturart" select="'1'"/>
	<xsl:param name="StatistikZustandsinfos" select="'1'"/>
	<xsl:param name="StatistikFehlendeArbeitskopien" select="'0'"/>
	<xsl:param name="DebugMode" select="'3'"/>
	<xsl:param name="TestMode"/>
	<xsl:variable name="InputDateiname" select="(tokenize($DocumentURI,'/'))[last()]"/>
	<xsl:variable name="InputPfad" select="fn:substring-before($DocumentURI, $InputDateiname)"/>

	<xsl:variable name="MeldungenInhaltDateiname">
		<xsl:choose>
			<xsl:when test="$StyleSheetURI = ''">Meldungen.xml</xsl:when>
			<xsl:otherwise><xsl:value-of select="fn:concat(fn:substring-before($StyleSheetURI, (tokenize($StyleSheetURI,'/'))[last()]),'Meldungen.xml')"/></xsl:otherwise>
		</xsl:choose>
	</xsl:variable>

	<xsl:variable name="MeldungenInhalt">
		<xsl:if test="fn:doc-available($MeldungenInhaltDateiname)">
			<xsl:copy-of select="fn:document($MeldungenInhaltDateiname)"/>
			<xsl:if test="$DebugMode = '4'">
				<xsl:message>                                  Meldung OK</xsl:message>
			</xsl:if>
		</xsl:if>
	</xsl:variable>
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
						<xsl:when test="name(/*) ='xdf:xdatenfelder.stammdatenschema.0102'">Bericht_<xsl:value-of select="fn:substring-before($InputDateiname,'.xml')"/>.html</xsl:when>
						<xsl:when test="name(/*) ='xdf:xdatenfelder.datenfeldgruppe.0103'">Bericht_<xsl:value-of select="fn:substring-before($InputDateiname,'.xml')"/>.html</xsl:when>
						<xsl:when test="name(/*) ='xdf:xdatenfelder.dokumentsteckbrief.0101'">Bericht_<xsl:value-of select="fn:substring-before($InputDateiname,'.xml')"/>.html</xsl:when>
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
					<xsl:when test="name(/*) ='xdf:xdatenfelder.datenfeldgruppe.0103'">
						<title>Details zur Datenfeldgruppe <xsl:value-of select="/*/xdf:datenfeldgruppe/xdf:identifikation/xdf:id"/>
							<xsl:if test="/*/xdf:datenfeldgruppe/xdf:identifikation/xdf:version"> Version <xsl:value-of select="/*/xdf:datenfeldgruppe/xdf:identifikation/xdf:version"/>
							</xsl:if>
						</title>
					</xsl:when>
					<xsl:when test="name(/*) ='xdf:xdatenfelder.dokumentsteckbrief.0101'">
						<title>Details zum Dokumentsteckbrief <xsl:value-of select="/*/xdf:dokumentensteckbrief/xdf:identifikation/xdf:id"/>
							<xsl:if test="/*/xdf:dokumentensteckbrief/xdf:identifikation/xdf:version"> Version <xsl:value-of select="/*/xdf:dokumentensteckbrief/xdf:identifikation/xdf:version"/>
							</xsl:if>
						</title>
					</xsl:when>
					<xsl:otherwise>
						<title>Unbekanntes Dateiformat</title>
					</xsl:otherwise>
				</xsl:choose>
				<meta name="author" content="Volker Schmitz"/>
				<xsl:call-template name="styleandscript"/>
			</head>
			<body onload="ZaehleMeldungen()">
				<xsl:if test="$Navigation = '1' and $Statistik !='2' and name(/*) !='xdf:xdatenfelder.dokumentsteckbrief.0101'">
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
									<a href="#SchemaDetails">Details zum Datenschemata</a>
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
							<xsl:when test="name(/*) ='xdf:xdatenfelder.datenfeldgruppe.0103'">
								<xsl:if test="$MeldungsFazit = '1' and $Meldungen = '1' and $JavaScript = '1'">
									<p id="ZusammenfassungLink">
										<a href="#Zusammenfassung">QS-Zusammenfassung</a>
									</p>
								</xsl:if>
								<p>
									<a href="#SchemaDetails">Details zur Datenfeldgruppe</a>
								</p>
								<p>
									<a href="#ElementDetails">Details zu den enthaltenen Baukastenelementen</a>
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
										<p class="Zusammenfassung" id="AnzahlFehlerKritisch"/>
										<p id="ListeFehlerKritisch"/>
										<p class="Zusammenfassung" id="AnzahlFehlerMethodisch"/>
										<p id="ListeFehlerMethodisch"/>
										<p class="Zusammenfassung" id="AnzahlWarnungen"/>
										<p id="ListeWarnungen"/>
										<p class="Zusammenfassung" id="AnzahlHinweise"/>
										<p id="ListeHinweise"/>
									</xsl:if>
								</div>
								<xsl:call-template name="stammdatenschemaeinzeln"/>
								<xsl:call-template name="listeelementedetail"/>
								<xsl:call-template name="listeregeldetails"/>
								<xsl:call-template name="listecodelistendetails"/>
							</xsl:if>
							<xsl:if test="$Statistik = '1' or $Statistik = '2'">
								<xsl:call-template name="statistik"/>
							</xsl:if>

							<p>Erstellt am: <xsl:value-of select="format-date(fn:current-date(),'[D01].[M01].[Y0001]')"/> um <xsl:value-of select="format-time(fn:current-time(),'[H01]:[m01]')"/> Uhr</p>
							<p>XSLT: <xsl:choose><xsl:when test="$StyleSheetURI = ''"><xsl:value-of select="$StyleSheetName"/></xsl:when><xsl:otherwise><xsl:call-template name="fileName"><xsl:with-param name="path" select="$StyleSheetURI"/></xsl:call-template></xsl:otherwise></xsl:choose></p>
							<xsl:if test="not(empty($DocumentURI))">
								<p>XML: <xsl:call-template name="fileName"><xsl:with-param name="path" select="$DocumentURI"/></xsl:call-template></p>
							</xsl:if>
							<p>MeldungsVersion: <xsl:value-of select="$MeldungenInhalt/gc:CodeList/Identification/CanonicalVersionUri"/></p>
						</xsl:when>
						<xsl:when test="name(/*) ='xdf:xdatenfelder.datenfeldgruppe.0103'">
							<h1>
								<xsl:choose>
									<xsl:when test="$Meldungen = '1'">
											Qualitätsbericht Datenfeldgruppe <xsl:value-of select="/*/xdf:datenfeldgruppe/xdf:identifikation/xdf:id"/>
										<xsl:if test="/*/xdf:datenfeldgruppe/xdf:identifikation/xdf:version">&#160;Version&#160;<xsl:value-of select="/*/xdf:datenfeldgruppe/xdf:identifikation/xdf:version"/>
										</xsl:if>
									</xsl:when>
									<xsl:otherwise>
											Übersicht Datenfeldgruppe <xsl:value-of select="/*/xdf:datenfeldgruppe/xdf:identifikation/xdf:id"/>
										<xsl:if test="/*/xdf:datenfeldgruppe/xdf:identifikation/xdf:version">&#160;Version&#160;<xsl:value-of select="/*/xdf:datenfeldgruppe/xdf:identifikation/xdf:version"/>
										</xsl:if>
									</xsl:otherwise>
								</xsl:choose>
							</h1>
							<xsl:if test="$Statistik != '2'">
								<div id="Zusammenfassungsbereich">
									<xsl:if test="$MeldungsFazit = '1' and $Meldungen = '1' and $JavaScript = '1'">
										<h2>
											<a name="Zusammenfassung"/>QS-Zusammenfassung der Datenfeldgruppe <xsl:value-of select="/*/xdf:datenfeldgruppe/xdf:identifikation/xdf:id"/>
											<xsl:if test="/*/xdf:datenfeldgruppe/xdf:identifikation/xdf:version">&#160;Version&#160;<xsl:value-of select="/*/xdf:datenfeldgruppe/xdf:identifikation/xdf:version"/>
											</xsl:if>
										</h2>
										<p class="Zusammenfassung" id="AnzahlFehlerKritisch"/>
										<p id="ListeFehlerKritisch"/>
										<p class="Zusammenfassung" id="AnzahlFehlerMethodisch"/>
										<p id="ListeFehlerMethodisch"/>
										<p class="Zusammenfassung" id="AnzahlWarnungen"/>
										<p id="ListeWarnungen"/>
										<p class="Zusammenfassung" id="AnzahlHinweise"/>
										<p id="ListeHinweise"/>
									</xsl:if>
								</div>
								<xsl:call-template name="datenfeldgruppeeinzeln"/>
								<xsl:call-template name="listeelementedetail"/>
								<xsl:call-template name="listeregeldetails"/>
								<xsl:call-template name="listecodelistendetails"/>
							</xsl:if>
							<xsl:if test="$Statistik = '1' or $Statistik = '2'">
								<xsl:call-template name="statistik"/>
							</xsl:if>
							<p>Erstellt am: <xsl:value-of select="format-date(fn:current-date(),'[D01].[M01].[Y0001]')"/> um <xsl:value-of select="format-time(fn:current-time(),'[H01]:[m01]')"/> Uhr</p>
							<p>XSLT: <xsl:choose>
									<xsl:when test="$StyleSheetURI = ''">
										<xsl:value-of select="$StyleSheetName"/>
									</xsl:when>
									<xsl:otherwise>
										<xsl:call-template name="fileName">
											<xsl:with-param name="path" select="$StyleSheetURI"/>
										</xsl:call-template>
									</xsl:otherwise>
								</xsl:choose>
							</p>
							<xsl:if test="not(empty($DocumentURI))">
								<p>XML: <xsl:call-template name="fileName">
										<xsl:with-param name="path" select="$DocumentURI"/>
									</xsl:call-template>
								</p>
							</xsl:if>
							<p>MeldungsVersion: <xsl:value-of select="$MeldungenInhalt/gc:CodeList/Identification/CanonicalVersionUri"/></p>
						</xsl:when>
						<xsl:when test="name(/*) ='xdf:xdatenfelder.dokumentsteckbrief.0101'">
							<h1>
								<xsl:choose>
									<xsl:when test="$Meldungen = '1'">
											Qualitätsbericht Dokumentsteckbrief <xsl:value-of select="/*/xdf:dokumentensteckbrief/xdf:identifikation/xdf:id"/>
										<xsl:if test="/*/xdf:dokumentensteckbrief/xdf:identifikation/xdf:version">&#160;Version&#160;<xsl:value-of select="/*/xdf:dokumentensteckbrief/xdf:identifikation/xdf:version"/>
										</xsl:if>
									</xsl:when>
									<xsl:otherwise>
											Übersicht Dokumentsteckbrief <xsl:value-of select="/*/xdf:dokumentensteckbrief/xdf:identifikation/xdf:id"/>
										<xsl:if test="/*/xdf:dokumentensteckbrief/xdf:identifikation/xdf:version">&#160;Version&#160;<xsl:value-of select="/*/xdf:dokumentensteckbrief/xdf:identifikation/xdf:version"/>
										</xsl:if>
									</xsl:otherwise>
								</xsl:choose>
							</h1>
							<div id="Zusammenfassungsbereich">
								<xsl:if test="$MeldungsFazit = '1' and $Meldungen = '1' and $JavaScript = '1'">
									<h2>
										<a name="Zusammenfassung"/>QS-Zusammenfassung des Dokumentsteckbriefs <xsl:value-of select="/*/xdf:dokumentensteckbrief/xdf:identifikation/xdf:id"/>
										<xsl:if test="/*/xdf:dokumentensteckbrief/xdf:identifikation/xdf:version">&#160;Version&#160;<xsl:value-of select="/*/xdf:dokumentensteckbrief/xdf:identifikation/xdf:version"/>
										</xsl:if>
									</h2>
									<p class="Zusammenfassung" id="AnzahlFehlerKritisch"/>
									<p id="ListeFehlerKritisch"/>
									<p class="Zusammenfassung" id="AnzahlFehlerMethodisch"/>
									<p id="ListeFehlerMethodisch"/>
									<p class="Zusammenfassung" id="AnzahlWarnungen"/>
									<p id="ListeWarnungen"/>
									<p class="Zusammenfassung" id="AnzahlHinweise"/>
									<p id="ListeHinweise"/>
								</xsl:if>
							</div>
							<xsl:call-template name="dokumentsteckbriefeinzeln"/>
							<p>Erstellt am: <xsl:value-of select="format-date(fn:current-date(),'[D01].[M01].[Y0001]')"/> um <xsl:value-of select="format-time(fn:current-time(),'[H01]:[m01]')"/> Uhr</p>
							<p>XSLT: <xsl:choose>
									<xsl:when test="$StyleSheetURI = ''">
										<xsl:value-of select="$StyleSheetName"/>
									</xsl:when>
									<xsl:otherwise>
										<xsl:call-template name="fileName">
											<xsl:with-param name="path" select="$StyleSheetURI"/>
										</xsl:call-template>
									</xsl:otherwise>
								</xsl:choose>
							</p>
							<xsl:if test="not(empty($DocumentURI))">
								<p>XML: <xsl:call-template name="fileName">
										<xsl:with-param name="path" select="$DocumentURI"/>
									</xsl:call-template>
								</p>
							</xsl:if>
							<p>MeldungsVersion: <xsl:value-of select="$MeldungenInhalt/gc:CodeList/Identification/CanonicalVersionUri"/></p>
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
	<xsl:template name="statistik">
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
						<a href="#StatistikZustandsinfos">Liste der Elemente ohne Statussetzenden oder mit Status inaktiv</a>
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
	<xsl:template name="stammdatenschemaeinzeln">
		<xsl:if test="$DebugMode = '1' or $DebugMode = '2' or $DebugMode = '3' or $DebugMode = '4'">
			<xsl:message>
				++++ stammdatenschemaeinzeln ++++
			</xsl:message>
		</xsl:if>
		<h2>
			<a name="SchemaDetails"/>Details zum Datenschema <xsl:value-of select="/*/xdf:stammdatenschema/xdf:identifikation/xdf:id"/>
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
				<xsl:call-template name="stammdatenschemadetails">
					<xsl:with-param name="Element" select="/*/xdf:stammdatenschema"/>
				</xsl:call-template>
			</tbody>
		</table>
	</xsl:template>
	<!-- ############################################################################################################# -->
	<xsl:template name="datenfeldgruppeeinzeln">
		<xsl:if test="$DebugMode = '1' or $DebugMode = '2' or $DebugMode = '3' or $DebugMode = '4'">
			<xsl:message>
				++++ datenfeldgruppeeinzeln ++++
			</xsl:message>
		</xsl:if>
		<h2>
			<a name="SchemaDetails"/>Details zur Datenfeldgruppe <xsl:value-of select="/*/xdf:datenfeldgruppe/xdf:identifikation/xdf:id"/>
			<xsl:if test="/*/xdf:datenfeldgruppe/xdf:identifikation/xdf:version">&#160;Version&#160;<xsl:value-of select="/*/xdf:datenfeldgruppe/xdf:identifikation/xdf:version"/>
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
				<xsl:call-template name="datenfeldgruppedetails">
					<xsl:with-param name="Element" select="/*/xdf:datenfeldgruppe"/>
				</xsl:call-template>
			</tbody>
		</table>
	</xsl:template>
	<!-- ############################################################################################################# -->
	<xsl:template name="dokumentsteckbriefeinzeln">
		<xsl:if test="$DebugMode = '1' or $DebugMode = '2' or $DebugMode = '3' or $DebugMode = '4'">
			<xsl:message>
				++++ dokumentsteckbriefeinzeln ++++
			</xsl:message>
		</xsl:if>
		<h2>
			<a name="SchemaDetails"/>Details zum Dokumentsteckbrief <xsl:value-of select="/*/xdf:dokumentensteckbrief/xdf:identifikation/xdf:id"/>
			<xsl:if test="/*/xdf:dokumentensteckbrief/xdf:identifikation/xdf:version">&#160;Version&#160;<xsl:value-of select="/*/xdf:dokumentensteckbrief/xdf:identifikation/xdf:version"/>
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
				<xsl:call-template name="dokumentsteckbriefdetails">
					<xsl:with-param name="Element" select="/*/xdf:dokumentensteckbrief"/>
				</xsl:call-template>
			</tbody>
		</table>
	</xsl:template>
	<!-- ############################################################################################################# -->
	<xsl:template name="stammdatenschemadetails">
		<xsl:param name="Element"/>
		<xsl:if test="$DebugMode = '2' or $DebugMode = '3' or $DebugMode = '4'">
			<xsl:message>
				++++++++ stammdatenschemadetails ++++++++
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
							<xsl:call-template name="meldung">
								<xsl:with-param name="nummer">1039</xsl:with-param>
							</xsl:call-template>
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
							<xsl:call-template name="meldung">
								<xsl:with-param name="nummer">1002</xsl:with-param>
							</xsl:call-template>
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
			<xsl:choose>
				<xsl:when test="empty($Element/xdf:bezeichnungEingabe/text())">
					<td>
						<xsl:if test="$Meldungen = '1'">
							<xsl:call-template name="meldung">
								<xsl:with-param name="nummer">1009</xsl:with-param>
							</xsl:call-template>
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
					<xsl:when test="empty($Element/xdf:bezug/text())">
						<td>
							<xsl:if test="$Meldungen = '1'">
								<xsl:call-template name="meldung">
									<xsl:with-param name="nummer">1051</xsl:with-param>
								</xsl:call-template>
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
							<xsl:call-template name="meldung">
								<xsl:with-param name="nummer">1119</xsl:with-param>
							</xsl:call-template>
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
							<xsl:call-template name="meldung">
								<xsl:with-param name="nummer">1117</xsl:with-param>
							</xsl:call-template>
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
		<tr>
			<td>
				<b>Unterelemente</b>
				<xsl:if test="$Meldungen = '1' and (count($Element/xdf:struktur) &lt; 1)">
					<xsl:call-template name="meldung">
						<xsl:with-param name="nummer">1078</xsl:with-param>
					</xsl:call-template>
				</xsl:if>
			</td>
			<td>
				<xsl:if test="count($Element/xdf:struktur) + count($Element/xdf:regel)">
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
							<xsl:call-template name="unterelemente">
								<xsl:with-param name="Element" select="$Element"/>
								<xsl:with-param name="Tiefe" select="1"/>
								<xsl:with-param name="Strukturelementart" select="'SDS'"/>
							</xsl:call-template>
						</tbody>
					</table>
				</xsl:if>
			</td>
		</tr>
		<tr style="page-break-after:always">
			<td colspan="2" class="Navigation">
				<xsl:call-template name="navigationszeile"/>
			</td>
		</tr>
	</xsl:template>
	<!-- ############################################################################################################# -->
	<xsl:template name="datenfeldgruppedetails">
		<xsl:param name="Element"/>
		<xsl:if test="$DebugMode = '2' or $DebugMode = '3' or $DebugMode = '4'">
			<xsl:message>
				++++++++ datenfeldgruppedetails ++++++++
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
					<td class="ElementID">
						<xsl:if test="$Meldungen = '1'">
							<xsl:call-template name="meldung">
								<xsl:with-param name="nummer">1038</xsl:with-param>
							</xsl:call-template>
						</xsl:if>
					</td>
				</xsl:when>
				<xsl:otherwise>
					<td class="ElementID">
						<xsl:value-of select="$Element/xdf:identifikation/xdf:id"/>
						<xsl:analyze-string regex="^G\d{{11}}$" select="$Element/xdf:identifikation/xdf:id">
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
									<xsl:call-template name="meldung">
										<xsl:with-param name="nummer">1039</xsl:with-param>
									</xsl:call-template>
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
			<td>Versionshinweis</td>
			<td>
				<xsl:value-of select="fn:replace($Element/xdf:versionshinweis,'\n','&lt;br/&gt;')" disable-output-escaping="yes"/>
			</td>
		</tr>
		<tr>
			<td>Name</td>
			<xsl:choose>
				<xsl:when test="empty($Element/xdf:name/text())">
					<td class="ElementName">
						<xsl:if test="$Meldungen = '1'">
							<xsl:call-template name="meldung">
								<xsl:with-param name="nummer">1002</xsl:with-param>
							</xsl:call-template>
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
							<xsl:call-template name="meldung">
								<xsl:with-param name="nummer">1006</xsl:with-param>
							</xsl:call-template>
						</xsl:if>
					</td>
				</xsl:when>
				<xsl:when test="$Element/xdf:schemaelementart/code/text() = 'HAR' and empty($Element/xdf:bezug/text())">
					<td>
						<xsl:if test="$Meldungen = '1'">
							<xsl:call-template name="meldung">
								<xsl:with-param name="nummer">1101</xsl:with-param>
							</xsl:call-template>
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
							<xsl:call-template name="meldung">
								<xsl:with-param name="nummer">1009</xsl:with-param>
							</xsl:call-template>
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
							<xsl:call-template name="meldung">
								<xsl:with-param name="nummer">1010</xsl:with-param>
							</xsl:call-template>
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
			<td>Gültig ab</td>
			<td>
				<xsl:value-of select="fn:format-date($Element/xdf:gueltigAb,'[D01].[M01].[Y0001]')"/>
			</td>
		</tr>
		<tr>
			<td>Gültig bis</td>
			<td>
				<xsl:value-of select="fn:format-date($Element/xdf:gueltigBis,'[D01].[M01].[Y0001]')"/>
			</td>
		</tr>
		<tr>
			<td>Fachlicher Ersteller</td>
			<xsl:choose>
				<xsl:when test="empty($Element/xdf:statusGesetztDurch/text()) and $VersionsHinweise ='1'">
					<td>
						<xsl:value-of select="$Element/xdf:statusGesetztDurch"/>
						<xsl:if test="$Meldungen = '1'">
							<xsl:call-template name="meldung">
								<xsl:with-param name="nummer">1117</xsl:with-param>
							</xsl:call-template>
						</xsl:if>
					</td>
				</xsl:when>
				<xsl:otherwise>
					<td>
						<xsl:value-of select="$Element/xdf:statusGesetztDurch"/>
					</td>
				</xsl:otherwise>
			</xsl:choose>
		</tr>
		<tr>
			<td>Status</td>
			<td>
				<xsl:apply-templates select="$Element/xdf:freigabestatus"/>
			</td>
		</tr>
		<tr>
			<td>Status gesetzt am</td>
			<td>
				<xsl:value-of select="fn:format-date($Element/xdf:statusGesetztAm,'[D01].[M01].[Y0001]')"/>
			</td>
		</tr>
		<tr>
			<td>Veröffentlichungsdatum</td>
			<td>
				<xsl:value-of select="fn:format-date($Element/xdf:veroeffentlichungsdatum,'[D01].[M01].[Y0001]')"/>
			</td>
		</tr>
		<tr>
			<td>Letzte Änderung</td>
			<td>
				<xsl:value-of select="fn:format-dateTime($Element/xdf:letzteAenderung,'[D01].[M01].[Y0001] um [H01]:[m01] Uhr')"/>
			</td>
		</tr>
		<tr>
			<td colspan="2">
				<h2/>
			</td>
		</tr>
		<xsl:if test="count($Element/xdf:relation)">
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
								<th>Art der Relation</th>
							</tr>
						</thead>
						<tbody>
							<xsl:for-each select="$Element/xdf:relation">
								<tr>
									<td>
										<xsl:variable name="objID" select="./xdf:objekt/xdf:id"/>
										<xsl:variable name="objVersion" select="./xdf:objekt/xdf:version"/>
										<xsl:value-of select="./xdf:objekt/xdf:id"/>
										<xsl:analyze-string regex="^(S|F|G|D)\d{{11}}$" select="$objID">
											<xsl:matching-substring>
												<xsl:if test="$ToolAufruf = '1'">
																				&#160;&#160;
																				<xsl:element name="a">
														<xsl:attribute name="href"><xsl:value-of select="$ToolPfadPrefix"/><xsl:value-of select="$objID"/><xsl:if test="$objVersion">V<xsl:value-of select="$objVersion"/></xsl:if><xsl:value-of select="$ToolPfadPostfix"/></xsl:attribute>
														<xsl:attribute name="target">FIMTool</xsl:attribute>
														<xsl:attribute name="title">Springe in den Datenfeldeditor (man muss vorher angemeldet sein).</xsl:attribute>
																					&#8658;
																				</xsl:element>
												</xsl:if>
												<xsl:if test="$Meldungen = '1' and (fn:substring($objID,1,1) != 'G' and fn:substring($objID,1,1) != 'F')">
													<xsl:call-template name="meldung">
														<xsl:with-param name="nummer">1087</xsl:with-param>
													</xsl:call-template>
												</xsl:if>
											</xsl:matching-substring>
											<xsl:non-matching-substring>
												<xsl:if test="$Meldungen = '1'">
													<xsl:call-template name="meldung">
														<xsl:with-param name="nummer">1039</xsl:with-param>
													</xsl:call-template>
												</xsl:if>
											</xsl:non-matching-substring>
										</xsl:analyze-string>
									</td>
									<td>
										<xsl:value-of select="./xdf:objekt/xdf:version"/>
									</td>
									<td>
										<xsl:apply-templates select="./xdf:praedikat"/>
										<xsl:if test="$Meldungen = '1' and ./xdf:praedikat = 'VKN'">
											<xsl:call-template name="meldung">
												<xsl:with-param name="nummer">1088</xsl:with-param>
											</xsl:call-template>
										</xsl:if>
									</td>
								</tr>
							</xsl:for-each>
						</tbody>
					</table>
				</td>
			</tr>
			<tr>
				<td colspan="2">
					<h2/>
				</td>
			</tr>
		</xsl:if>
		<tr>
			<td>
				<b>Unterelemente</b>
				<xsl:if test="$Meldungen = '1'">
					<xsl:choose>
						<xsl:when test="count($Element/xdf:struktur) &lt; 1">
							<xsl:call-template name="meldung">
								<xsl:with-param name="nummer">1023</xsl:with-param>
							</xsl:call-template>
						</xsl:when>
						<xsl:when test="count($Element/xdf:struktur) = 1">
							<xsl:call-template name="meldung">
								<xsl:with-param name="nummer">1106</xsl:with-param>
							</xsl:call-template>
						</xsl:when>
					</xsl:choose>
				</xsl:if>
			</td>
			<td>
				<xsl:if test="count($Element/xdf:struktur) + count($Element/xdf:regel)">
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
							<xsl:call-template name="unterelemente">
								<xsl:with-param name="Element" select="$Element"/>
								<xsl:with-param name="Tiefe" select="1"/>
								<xsl:with-param name="Strukturelementart" select="'SDS'"/>
							</xsl:call-template>
						</tbody>
					</table>
				</xsl:if>
			</td>
		</tr>
		<tr style="page-break-after:always">
			<td colspan="2" class="Navigation">
				<xsl:call-template name="navigationszeile"/>
			</td>
		</tr>
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
			<xsl:choose>
				<xsl:when test="empty($Element/xdf:identifikation/xdf:id/text())">
					<td class="SteckbriefID">
						<xsl:if test="$Meldungen = '1'">
							<xsl:call-template name="meldung">
								<xsl:with-param name="nummer">1038</xsl:with-param>
							</xsl:call-template>
						</xsl:if>
					</td>
				</xsl:when>
				<xsl:otherwise>
					<td class="ElementID">
						<xsl:value-of select="$Element/xdf:identifikation/xdf:id"/>
						<xsl:analyze-string regex="^D\d{{8}}$" select="$Element/xdf:identifikation/xdf:id">
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
									<xsl:call-template name="meldung">
										<xsl:with-param name="nummer">1039</xsl:with-param>
									</xsl:call-template>
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
					<td class="SteckbriefName">
						<xsl:if test="$Meldungen = '1'">
							<xsl:call-template name="meldung">
								<xsl:with-param name="nummer">1002</xsl:with-param>
							</xsl:call-template>
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
			<xsl:choose>
				<xsl:when test="empty($Element/xdf:definition/text())">
					<td>
						<xsl:if test="$Meldungen = '1'">
							<xsl:call-template name="meldung">
								<xsl:with-param name="nummer">1049</xsl:with-param>
							</xsl:call-template>
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
			<td>Handlungsgrundlagen</td>
			<xsl:choose>
				<xsl:when test="empty($Element/xdf:bezug/text())">
					<td>
						<xsl:if test="$Meldungen = '1'">
							<xsl:call-template name="meldung">
								<xsl:with-param name="nummer">1008</xsl:with-param>
							</xsl:call-template>
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
							<xsl:call-template name="meldung">
								<xsl:with-param name="nummer">1009</xsl:with-param>
							</xsl:call-template>
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
							<xsl:call-template name="meldung">
								<xsl:with-param name="nummer">1107</xsl:with-param>
							</xsl:call-template>
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
							<xsl:call-template name="meldung">
								<xsl:with-param name="nummer">1117</xsl:with-param>
							</xsl:call-template>
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
							<xsl:call-template name="meldung">
								<xsl:with-param name="nummer">1119</xsl:with-param>
							</xsl:call-template>
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
		<tr style="page-break-after:always">
			<td colspan="2" class="Navigation">
				<xsl:call-template name="navigationszeile"/>
			</td>
		</tr>
	</xsl:template>
	<!-- ############################################################################################################# -->
	<xsl:template name="listeelementedetail">
		<xsl:if test="$DebugMode = '1' or $DebugMode = '2' or $DebugMode = '3' or $DebugMode = '4'">
			<xsl:message>
				++++ listeelementedetail ++++
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
						<xsl:call-template name="elementdetails">
							<xsl:with-param name="Element" select="."/>
							<xsl:with-param name="VersionsAnzahl" select="fn:last()"/>
						</xsl:call-template>
					</xsl:for-each-group>
				</xsl:for-each-group>
			</tbody>
		</table>
	</xsl:template>
	<!-- ############################################################################################################# -->
	<xsl:template name="elementdetails">
		<xsl:param name="Element"/>
		<xsl:param name="VersionsAnzahl"/>
		<xsl:if test="$DebugMode = '2' or $DebugMode = '3' or $DebugMode = '4'">
			<xsl:message>
				++++++++ elementdetails ++++++++
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
									<xsl:call-template name="meldung">
										<xsl:with-param name="nummer">1038</xsl:with-param>
									</xsl:call-template>
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
											<xsl:call-template name="meldung">
												<xsl:with-param name="nummer">1039</xsl:with-param>
											</xsl:call-template>
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
									<xsl:call-template name="meldung">
										<xsl:with-param name="nummer">1003</xsl:with-param>
									</xsl:call-template>
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
									<xsl:call-template name="meldung">
										<xsl:with-param name="nummer">1002</xsl:with-param>
									</xsl:call-template>
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
									<xsl:call-template name="meldung">
										<xsl:with-param name="nummer">1014</xsl:with-param>
									</xsl:call-template>
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
									<xsl:call-template name="meldung">
										<xsl:with-param name="nummer">1006</xsl:with-param>
									</xsl:call-template>
								</xsl:if>
							</td>
						</xsl:when>
						<xsl:when test="$Element/xdf:schemaelementart/code/text() = 'HAR' and empty($Element/xdf:bezug/text())">
							<td>
								<xsl:if test="$Meldungen = '1'">
									<xsl:call-template name="meldung">
										<xsl:with-param name="nummer">1101</xsl:with-param>
									</xsl:call-template>
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
											<xsl:call-template name="meldung">
												<xsl:with-param name="nummer">1108</xsl:with-param>
											</xsl:call-template>
										</xsl:if>
									</td>
								</xsl:when>
								<xsl:otherwise>
									<td>
										<xsl:apply-templates select="$Element/xdf:datentyp"/>
										<xsl:if test="$Meldungen = '1'">
											<xsl:call-template name="meldung">
												<xsl:with-param name="nummer">1011</xsl:with-param>
											</xsl:call-template>
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
															<xsl:call-template name="meldung">
																<xsl:with-param name="nummer">1012</xsl:with-param>
															</xsl:call-template>
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
															<xsl:call-template name="meldung">
																<xsl:with-param name="nummer">1059</xsl:with-param>
															</xsl:call-template>
														</xsl:if>
														<xsl:if test="$Meldungen = '1' and not($maxLength castable as xs:positiveInteger)">
															<xsl:call-template name="meldung">
																<xsl:with-param name="nummer">1060</xsl:with-param>
															</xsl:call-template>
														</xsl:if>
														<xsl:if test="$Meldungen = '1' and ($minLength castable as xs:nonNegativeInteger) and ($maxLength castable as xs:positiveInteger) and ($minLength cast as xs:nonNegativeInteger &gt; $maxLength cast as xs:positiveInteger)">
															<xsl:call-template name="meldung">
																<xsl:with-param name="nummer">1061</xsl:with-param>
															</xsl:call-template>
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
															<xsl:call-template name="meldung">
																<xsl:with-param name="nummer">1059</xsl:with-param>
															</xsl:call-template>
														</xsl:if>
														<xsl:if test="$Meldungen = '1' and $maxLength != '' and not($maxLength castable as xs:positiveInteger)">
															<xsl:call-template name="meldung">
																<xsl:with-param name="nummer">1060</xsl:with-param>
															</xsl:call-template>
														</xsl:if>
														<xsl:if test="$Meldungen = '1'">
															<xsl:call-template name="meldung">
																<xsl:with-param name="nummer">1102</xsl:with-param>
															</xsl:call-template>
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
											<xsl:call-template name="meldung">
												<xsl:with-param name="nummer">1015</xsl:with-param>
											</xsl:call-template>
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
											<xsl:call-template name="meldung">
												<xsl:with-param name="nummer">1102</xsl:with-param>
											</xsl:call-template>
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
											<xsl:call-template name="meldung">
												<xsl:with-param name="nummer">1062</xsl:with-param>
											</xsl:call-template>
										</xsl:if>
										<xsl:if test="$Meldungen = '1' and $maxValue != '' and not($maxValue castable as xs:double)">
											<xsl:call-template name="meldung">
												<xsl:with-param name="nummer">1063</xsl:with-param>
											</xsl:call-template>
										</xsl:if>
										<xsl:if test="$Meldungen = '1' and $minValue != '' and $maxValue != '' and ($minValue castable as xs:double) and ($maxValue castable as xs:double) and ($minValue cast as xs:double &gt; $maxValue cast as xs:double)">
											<xsl:call-template name="meldung">
												<xsl:with-param name="nummer">1064</xsl:with-param>
											</xsl:call-template>
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
											<xsl:call-template name="meldung">
												<xsl:with-param name="nummer">1065</xsl:with-param>
											</xsl:call-template>
										</xsl:if>
										<xsl:if test="$Meldungen = '1' and $maxValue != '' and not($maxValue castable as xs:integer)">
											<xsl:call-template name="meldung">
												<xsl:with-param name="nummer">1066</xsl:with-param>
											</xsl:call-template>
										</xsl:if>
										<xsl:if test="$Meldungen = '1' and $minValue != '' and $maxValue != '' and ($minValue castable as xs:integer) and ($maxValue castable as xs:integer) and ($minValue cast as xs:integer &gt; $maxValue cast as xs:integer)">
											<xsl:call-template name="meldung">
												<xsl:with-param name="nummer">1064</xsl:with-param>
											</xsl:call-template>
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
											<xsl:call-template name="meldung">
												<xsl:with-param name="nummer">1067</xsl:with-param>
											</xsl:call-template>
										</xsl:if>
										<xsl:if test="$Meldungen = '1' and $maxValue != '' and not($maxValue castable as xs:date)">
											<xsl:call-template name="meldung">
												<xsl:with-param name="nummer">1068</xsl:with-param>
											</xsl:call-template>
										</xsl:if>
										<xsl:if test="$Meldungen = '1' and $minValue != '' and $maxValue != '' and ($minValue castable as xs:date) and ($maxValue castable as xs:date) and ($minValue cast as xs:date &gt; $maxValue cast as xs:date)">
											<xsl:call-template name="meldung">
												<xsl:with-param name="nummer">1064</xsl:with-param>
											</xsl:call-template>
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
													<xsl:call-template name="meldung">
														<xsl:with-param name="nummer">1016</xsl:with-param>
													</xsl:call-template>
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
											<xsl:call-template name="meldung">
												<xsl:with-param name="nummer">1103</xsl:with-param>
											</xsl:call-template>
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
									<xsl:call-template name="meldung">
										<xsl:with-param name="nummer">1017</xsl:with-param>
									</xsl:call-template>
								</xsl:if>
							</td>
						</xsl:when>
						<xsl:when test="$Element/xdf:feldart/code/text() = 'select' and not($Element/xdf:codelisteReferenz)">
							<td>
								<xsl:if test="$Meldungen = '1'">
									<xsl:call-template name="meldung">
										<xsl:with-param name="nummer">1018</xsl:with-param>
									</xsl:call-template>
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
										<xsl:call-template name="meldung">
											<xsl:with-param name="nummer">1035</xsl:with-param>
										</xsl:call-template>
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
									<xsl:call-template name="meldung">
										<xsl:with-param name="nummer">1109</xsl:with-param>
									</xsl:call-template>
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
												<xsl:call-template name="meldung">
													<xsl:with-param name="nummer">1069</xsl:with-param>
												</xsl:call-template>
											</xsl:if>
											<xsl:if test="$Inhalt != '' and $minValue != '' and ($Inhalt castable as xs:double) and ($minValue castable as xs:double) and ($minValue cast as xs:double &gt; $Inhalt cast as xs:double)">
												<xsl:call-template name="meldung">
													<xsl:with-param name="nummer">1072</xsl:with-param>
												</xsl:call-template>
											</xsl:if>
											<xsl:if test="$Inhalt != '' and $maxValue != '' and ($Inhalt castable as xs:double) and ($maxValue castable as xs:double) and ($maxValue cast as xs:double &lt; $Inhalt cast as xs:double)">
												<xsl:call-template name="meldung">
													<xsl:with-param name="nummer">1073</xsl:with-param>
												</xsl:call-template>
											</xsl:if>
										</xsl:when>
										<xsl:when test="$Element/xdf:datentyp/code/text() = 'num_int'">
											<xsl:if test="$Inhalt != '' and not($Inhalt castable as xs:integer)">
												<xsl:call-template name="meldung">
													<xsl:with-param name="nummer">1070</xsl:with-param>
												</xsl:call-template>
											</xsl:if>
											<xsl:if test="$Inhalt != '' and $minValue != '' and ($Inhalt castable as xs:integer) and ($minValue castable as xs:integer) and ($minValue cast as xs:integer &gt; $Inhalt cast as xs:integer)">
												<xsl:call-template name="meldung">
													<xsl:with-param name="nummer">1072</xsl:with-param>
												</xsl:call-template>
											</xsl:if>
											<xsl:if test="$Inhalt != '' and $maxValue != '' and ($Inhalt castable as xs:integer) and ($maxValue castable as xs:integer) and ($maxValue cast as xs:integer &lt; $Inhalt cast as xs:integer)">
												<xsl:call-template name="meldung">
													<xsl:with-param name="nummer">1073</xsl:with-param>
												</xsl:call-template>
											</xsl:if>
										</xsl:when>
										<xsl:when test="$Element/xdf:datentyp/code/text() = 'date'">
											<xsl:if test="$Inhalt != '' and not($Inhalt castable as xs:date)">
												<xsl:call-template name="meldung">
													<xsl:with-param name="nummer">1071</xsl:with-param>
												</xsl:call-template>
											</xsl:if>
											<xsl:if test="$Inhalt != '' and $minValue != '' and ($Inhalt castable as xs:date) and ($minValue castable as xs:date) and ($minValue cast as xs:date &gt; $Inhalt cast as xs:date)">
												<xsl:call-template name="meldung">
													<xsl:with-param name="nummer">1072</xsl:with-param>
												</xsl:call-template>
											</xsl:if>
											<xsl:if test="$Inhalt != '' and $maxValue != '' and ($Inhalt castable as xs:date) and ($maxValue castable as xs:date) and ($maxValue cast as xs:date &lt; $Inhalt cast as xs:date)">
												<xsl:call-template name="meldung">
													<xsl:with-param name="nummer">1073</xsl:with-param>
												</xsl:call-template>
											</xsl:if>
										</xsl:when>
										<xsl:when test="$Element/xdf:datentyp/code/text() = 'text'">
											<xsl:if test="$Inhalt != '' and ($minLength castable as xs:integer) and (fn:string-length($Inhalt) &lt; $minLength)">
												<xsl:call-template name="meldung">
													<xsl:with-param name="nummer">1074</xsl:with-param>
												</xsl:call-template>
											</xsl:if>
											<xsl:if test="$Inhalt != '' and ($maxLength castable as xs:integer) and (fn:string-length($Inhalt) &gt; $maxLength)">
												<xsl:call-template name="meldung">
													<xsl:with-param name="nummer">1075</xsl:with-param>
												</xsl:call-template>
											</xsl:if>
										</xsl:when>
										<xsl:when test="$Element/xdf:datentyp/code/text() = 'bool'">
											<xsl:if test="$Inhalt != '' and not($Inhalt castable as xs:boolean)">
												<xsl:call-template name="meldung">
													<xsl:with-param name="nummer">1077</xsl:with-param>
												</xsl:call-template>
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
									<xsl:call-template name="meldung">
										<xsl:with-param name="nummer">1009</xsl:with-param>
									</xsl:call-template>
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
									<xsl:call-template name="meldung">
										<xsl:with-param name="nummer">1010</xsl:with-param>
									</xsl:call-template>
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
									<xsl:call-template name="meldung">
										<xsl:with-param name="nummer">1117</xsl:with-param>
									</xsl:call-template>
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
									<xsl:call-template name="meldung">
										<xsl:with-param name="nummer">1119</xsl:with-param>
									</xsl:call-template>
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
															<xsl:for-each select="$MeldungenInhalt/gc:CodeList/SimpleCodeList/Row[Value/@ColumnRef ='Code' and Value/SimpleValue = '1001']">
																<xsl:choose>
																	<xsl:when test="./Value[@ColumnRef ='Typ']/SimpleValue = 'FehlerKritisch'">
																		<div class="FehlerKritisch M1001">
																			FehlerKritisch!! 1001: <xsl:value-of select="./Value[@ColumnRef ='Meldungstext']/SimpleValue"/> Nicht-erreichbares Element: <xsl:value-of select="$TestElement"/>
																			<xsl:if test="$QSHilfeAufruf = '1'">
																				&#160;&#160;
																				<xsl:element name="a">
																					<xsl:attribute name="href"><xsl:value-of select="$QSHilfePfadPrefix"/>1001<xsl:value-of select="$QSHilfePfadPostfix"/></xsl:attribute>
																					<xsl:attribute name="target">MeldungsHilfe</xsl:attribute>
																					<xsl:attribute name="title">Springe zu den Erläuterungen der Meldungscodes in die Qualitätskriterien.</xsl:attribute>
																					&#8658;
																				</xsl:element>&#160;&#160;&#160;&#160;
																			</xsl:if>
																		</div>
																	</xsl:when>
																	<xsl:when test="./Value[@ColumnRef ='Typ']/SimpleValue = 'FehlerMethodisch'">
																		<div class="FehlerMethodisch M1001">
																			FehlerMethodisch!! 1001: <xsl:value-of select="./Value[@ColumnRef ='Meldungstext']/SimpleValue"/> Nicht-erreichbares Element: <xsl:value-of select="$TestElement"/>
																			<xsl:if test="$QSHilfeAufruf = '1'">
																				&#160;&#160;
																				<xsl:element name="a">
																					<xsl:attribute name="href"><xsl:value-of select="$QSHilfePfadPrefix"/>1001<xsl:value-of select="$QSHilfePfadPostfix"/></xsl:attribute>
																					<xsl:attribute name="target">MeldungsHilfe</xsl:attribute>
																					<xsl:attribute name="title">Springe zu den Erläuterungen der Meldungscodes in die Qualitätskriterien.</xsl:attribute>
																					&#8658;
																				</xsl:element>&#160;&#160;&#160;&#160;
																			</xsl:if>
																		</div>
																	</xsl:when>
																	<xsl:when test="./Value[@ColumnRef ='Typ']/SimpleValue = 'Warnung'">
																		<div class="Warnung 1001">
																			Warnung!! M1001: <xsl:value-of select="./Value[@ColumnRef ='Meldungstext']/SimpleValue"/> Nicht-erreichbares Element: <xsl:value-of select="$TestElement"/>
																			<xsl:if test="$QSHilfeAufruf = '1'">
																				&#160;&#160;
																				<xsl:element name="a">
																					<xsl:attribute name="href"><xsl:value-of select="$QSHilfePfadPrefix"/>1001<xsl:value-of select="$QSHilfePfadPostfix"/></xsl:attribute>
																					<xsl:attribute name="target">MeldungsHilfe</xsl:attribute>
																					<xsl:attribute name="title">Springe zu den Erläuterungen der Meldungscodes in die Qualitätskriterien.</xsl:attribute>
																					&#8658;
																				</xsl:element>&#160;&#160;&#160;&#160;
																			</xsl:if>
																		</div>
																	</xsl:when>
																	<xsl:when test="./Value[@ColumnRef ='Typ']/SimpleValue = 'Hinweis'">
																		<div class="Hinweis M1001">
																			Hinweis!! 1001: <xsl:value-of select="./Value[@ColumnRef ='Meldungstext']/SimpleValue"/> Nicht-erreichbares Element: <xsl:value-of select="$TestElement"/>
																			<xsl:if test="$QSHilfeAufruf = '1'">
																				&#160;&#160;
																				<xsl:element name="a">
																					<xsl:attribute name="href"><xsl:value-of select="$QSHilfePfadPrefix"/>1001<xsl:value-of select="$QSHilfePfadPostfix"/></xsl:attribute>
																					<xsl:attribute name="target">MeldungsHilfe</xsl:attribute>
																					<xsl:attribute name="title">Springe zu den Erläuterungen der Meldungscodes in die Qualitätskriterien.</xsl:attribute>
																					&#8658;
																				</xsl:element>&#160;&#160;&#160;&#160;
																			</xsl:if>
																		</div>
																	</xsl:when>
																	<xsl:when test="./Value[@ColumnRef ='Typ']/SimpleValue = 'Deaktiviert'">
																	</xsl:when>
																	<xsl:otherwise>
																		<div class="Hinweis M1001">Hinweis!! 1001: Unbekannte Meldung!</div>
																	</xsl:otherwise>
																</xsl:choose>
															</xsl:for-each>
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
														<xsl:call-template name="meldung">
															<xsl:with-param name="nummer">1019</xsl:with-param>
														</xsl:call-template>
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
									<xsl:call-template name="meldung">
										<xsl:with-param name="nummer">1038</xsl:with-param>
									</xsl:call-template>
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
											<xsl:call-template name="meldung">
												<xsl:with-param name="nummer">1039</xsl:with-param>
											</xsl:call-template>
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
									<xsl:call-template name="meldung">
										<xsl:with-param name="nummer">1003</xsl:with-param>
									</xsl:call-template>
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
									<xsl:call-template name="meldung">
										<xsl:with-param name="nummer">1002</xsl:with-param>
									</xsl:call-template>
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
									<xsl:call-template name="meldung">
										<xsl:with-param name="nummer">1006</xsl:with-param>
									</xsl:call-template>
								</xsl:if>
							</td>
						</xsl:when>
						<xsl:when test="$Element/xdf:schemaelementart/code/text() = 'HAR' and empty($Element/xdf:bezug/text())">
							<td>
								<xsl:if test="$Meldungen = '1'">
									<xsl:call-template name="meldung">
										<xsl:with-param name="nummer">1101</xsl:with-param>
									</xsl:call-template>
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
									<xsl:call-template name="meldung">
										<xsl:with-param name="nummer">1009</xsl:with-param>
									</xsl:call-template>
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
									<xsl:call-template name="meldung">
										<xsl:with-param name="nummer">1010</xsl:with-param>
									</xsl:call-template>
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
									<xsl:call-template name="meldung">
										<xsl:with-param name="nummer">1117</xsl:with-param>
									</xsl:call-template>
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
									<xsl:call-template name="meldung">
										<xsl:with-param name="nummer">1119</xsl:with-param>
									</xsl:call-template>
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
						<xsl:if test="$Meldungen = '1'">
							<xsl:choose>
								<xsl:when test="count($Element/xdf:struktur) &lt; 1">
									<xsl:call-template name="meldung">
										<xsl:with-param name="nummer">1023</xsl:with-param>
									</xsl:call-template>
								</xsl:when>
								<xsl:when test="count($Element/xdf:struktur) = 1">
									<xsl:call-template name="meldung">
										<xsl:with-param name="nummer">1106</xsl:with-param>
									</xsl:call-template>
								</xsl:when>
							</xsl:choose>
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
																<xsl:call-template name="meldung">
																	<xsl:with-param name="nummer">1038</xsl:with-param>
																</xsl:call-template>
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
																	<xsl:call-template name="meldung">
																		<xsl:with-param name="nummer">1004</xsl:with-param>
																	</xsl:call-template>
																</xsl:if>
															</xsl:if>
														</xsl:when>
														<xsl:otherwise>
															<xsl:if test="count($Element/xdf:struktur/./xdf:enthaelt/*/xdf:identifikation[xdf:id=$VergleichsElement and xdf:version=$VergleichsVersion]) &gt; 1">
																<xsl:if test="$Meldungen = '1'">
																	<xsl:call-template name="meldung">
																		<xsl:with-param name="nummer">1004</xsl:with-param>
																	</xsl:call-template>
																</xsl:if>
															</xsl:if>
														</xsl:otherwise>
													</xsl:choose>
													<xsl:if test="$Meldungen = '1' and ./xdf:enthaelt/*/name() = 'xdf:datenfeldgruppe'">
														<!-- Zirkelbezug E1026 -->
														<xsl:if test="count(.//xdf:enthaelt/xdf:datenfeldgruppe[xdf:identifikation/xdf:id = $Element/xdf:identifikation/xdf:id and xdf:identifikation/xdf:version = $Element/xdf:identifikation/xdf:version]) &gt; 0">
															<xsl:if test="$Meldungen = '1'">
																<xsl:call-template name="meldung">
																	<xsl:with-param name="nummer">1026</xsl:with-param>
																</xsl:call-template>
															</xsl:if>
														</xsl:if>
													</xsl:if>
												</td>
												<xsl:choose>
													<xsl:when test="empty(./xdf:enthaelt/*/xdf:identifikation/xdf:version/text()) and $VersionsHinweise ='1'">
														<td>
															<xsl:value-of select="./xdf:enthaelt/*/xdf:identifikation/xdf:version"/>
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
																<xsl:call-template name="meldung">
																	<xsl:with-param name="nummer">1013</xsl:with-param>
																</xsl:call-template>
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
																<xsl:call-template name="meldung">
																	<xsl:with-param name="nummer">1116</xsl:with-param>
																</xsl:call-template>
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
															<xsl:analyze-string regex="^\d+:(\d+|\*)$" select="./xdf:anzahl">
																<xsl:matching-substring>
																	<xsl:if test="$AnzahlText = '0:0'">
																		<xsl:call-template name="meldung">
																			<xsl:with-param name="nummer">1021</xsl:with-param>
																		</xsl:call-template>
																	</xsl:if>
																	<xsl:if test="(fn:number($minCount) &gt; fn:number($maxCount)) and $maxCount != '*'">
																		<xsl:call-template name="meldung">
																			<xsl:with-param name="nummer">1047</xsl:with-param>
																		</xsl:call-template>
																	</xsl:if>
																</xsl:matching-substring>
																<xsl:non-matching-substring>
																	<xsl:if test="$Meldungen = '1'">
																		<xsl:call-template name="meldung">
																			<xsl:with-param name="nummer">1046</xsl:with-param>
																		</xsl:call-template>
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
																<xsl:call-template name="meldung">
																	<xsl:with-param name="nummer">1022</xsl:with-param>
																</xsl:call-template>
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
									<xsl:call-template name="meldung">
										<xsl:with-param name="nummer">1023</xsl:with-param>
									</xsl:call-template>
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
															<xsl:for-each select="$MeldungenInhalt/gc:CodeList/SimpleCodeList/Row[Value/@ColumnRef ='Code' and Value/SimpleValue = '1001']">
																<xsl:choose>
																	<xsl:when test="./Value[@ColumnRef ='Typ']/SimpleValue = 'FehlerKritisch'">
																		<div class="FehlerKritisch M1001">
																			FehlerKritisch!! 1001: <xsl:value-of select="./Value[@ColumnRef ='Meldungstext']/SimpleValue"/> Nicht-erreichbares Element: <xsl:value-of select="$TestElement"/>
																			<xsl:if test="$QSHilfeAufruf = '1'">
																				&#160;&#160;
																				<xsl:element name="a">
																					<xsl:attribute name="href"><xsl:value-of select="$QSHilfePfadPrefix"/>1001<xsl:value-of select="$QSHilfePfadPostfix"/></xsl:attribute>
																					<xsl:attribute name="target">MeldungsHilfe</xsl:attribute>
																					<xsl:attribute name="title">Springe zu den Erläuterungen der Meldungscodes in die Qualitätskriterien.</xsl:attribute>
																					&#8658;
																				</xsl:element>&#160;&#160;&#160;&#160;
																			</xsl:if>
																		</div>
																	</xsl:when>
																	<xsl:when test="./Value[@ColumnRef ='Typ']/SimpleValue = 'FehlerMethodisch'">
																		<div class="FehlerMethodisch M1001">
																			FehlerMethodisch!! 1001: <xsl:value-of select="./Value[@ColumnRef ='Meldungstext']/SimpleValue"/> Nicht-erreichbares Element: <xsl:value-of select="$TestElement"/>
																			<xsl:if test="$QSHilfeAufruf = '1'">
																				&#160;&#160;
																				<xsl:element name="a">
																					<xsl:attribute name="href"><xsl:value-of select="$QSHilfePfadPrefix"/>1001<xsl:value-of select="$QSHilfePfadPostfix"/></xsl:attribute>
																					<xsl:attribute name="target">MeldungsHilfe</xsl:attribute>
																					<xsl:attribute name="title">Springe zu den Erläuterungen der Meldungscodes in die Qualitätskriterien.</xsl:attribute>
																					&#8658;
																				</xsl:element>&#160;&#160;&#160;&#160;
																			</xsl:if>
																		</div>
																	</xsl:when>
																	<xsl:when test="./Value[@ColumnRef ='Typ']/SimpleValue = 'Warnung'">
																		<div class="Warnung 1001">
																			Warnung!! M1001: <xsl:value-of select="./Value[@ColumnRef ='Meldungstext']/SimpleValue"/> Nicht-erreichbares Element: <xsl:value-of select="$TestElement"/>
																			<xsl:if test="$QSHilfeAufruf = '1'">
																				&#160;&#160;
																				<xsl:element name="a">
																					<xsl:attribute name="href"><xsl:value-of select="$QSHilfePfadPrefix"/>1001<xsl:value-of select="$QSHilfePfadPostfix"/></xsl:attribute>
																					<xsl:attribute name="target">MeldungsHilfe</xsl:attribute>
																					<xsl:attribute name="title">Springe zu den Erläuterungen der Meldungscodes in die Qualitätskriterien.</xsl:attribute>
																					&#8658;
																				</xsl:element>&#160;&#160;&#160;&#160;
																			</xsl:if>
																		</div>
																	</xsl:when>
																	<xsl:when test="./Value[@ColumnRef ='Typ']/SimpleValue = 'Hinweis'">
																		<div class="Hinweis M1001">
																			Hinweis!! 1001: <xsl:value-of select="./Value[@ColumnRef ='Meldungstext']/SimpleValue"/> Nicht-erreichbares Element: <xsl:value-of select="$TestElement"/>
																			<xsl:if test="$QSHilfeAufruf = '1'">
																				&#160;&#160;
																				<xsl:element name="a">
																					<xsl:attribute name="href"><xsl:value-of select="$QSHilfePfadPrefix"/>1001<xsl:value-of select="$QSHilfePfadPostfix"/></xsl:attribute>
																					<xsl:attribute name="target">MeldungsHilfe</xsl:attribute>
																					<xsl:attribute name="title">Springe zu den Erläuterungen der Meldungscodes in die Qualitätskriterien.</xsl:attribute>
																					&#8658;
																				</xsl:element>&#160;&#160;&#160;&#160;
																			</xsl:if>
																		</div>
																	</xsl:when>
																	<xsl:when test="./Value[@ColumnRef ='Typ']/SimpleValue = 'Deaktiviert'">
																	</xsl:when>
																	<xsl:otherwise>
																		<div class="Hinweis M1001">Hinweis!! 1001: Unbekannte Meldung!</div>
																	</xsl:otherwise>
																</xsl:choose>
															</xsl:for-each>
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
														<xsl:call-template name="meldung">
															<xsl:with-param name="nummer">1019</xsl:with-param>
														</xsl:call-template>
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
	<xsl:template name="listeregeldetails">
		<xsl:if test="$DebugMode = '1' or $DebugMode = '2' or $DebugMode = '3' or $DebugMode = '4'">
			<xsl:message>
				++++ listeregeldetails ++++
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
							<xsl:call-template name="meldung">
								<xsl:with-param name="nummer">1038</xsl:with-param>
							</xsl:call-template>
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
									<xsl:call-template name="meldung">
										<xsl:with-param name="nummer">1039</xsl:with-param>
									</xsl:call-template>
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
							<xsl:call-template name="meldung">
								<xsl:with-param name="nummer">1002</xsl:with-param>
							</xsl:call-template>
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
							<xsl:call-template name="meldung">
								<xsl:with-param name="nummer">1024</xsl:with-param>
							</xsl:call-template>
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
						<xsl:call-template name="meldung">
							<xsl:with-param name="nummer">1104</xsl:with-param>
						</xsl:call-template>
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
							<xsl:call-template name="meldung">
								<xsl:with-param name="nummer">1119</xsl:with-param>
							</xsl:call-template>
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
							<xsl:call-template name="meldung">
								<xsl:with-param name="nummer">1117</xsl:with-param>
							</xsl:call-template>
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
	<xsl:template name="listecodelistendetails">
		<xsl:if test="$DebugMode = '1' or $DebugMode = '2' or $DebugMode = '3' or $DebugMode = '4'">
			<xsl:message>
				++++ listecodelistendetails ++++
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
					<xsl:call-template name="codelistedetails">
						<xsl:with-param name="Element" select="."/>
						<xsl:with-param name="ListeDoppelteCodelisten" select="$ListeDoppelteCodelisten"/>
						<xsl:with-param name="ListeMehrereCodelistenVersionen" select="$ListeMehrereCodelistenVersionen"/>
					</xsl:call-template>
				</xsl:for-each-group>
			</tbody>
		</table>
	</xsl:template>
	<!-- ############################################################################################################# -->
	<xsl:template name="codelistedetails">
		<xsl:param name="Element"/>
		<xsl:param name="ListeDoppelteCodelisten"/>
		<xsl:param name="ListeMehrereCodelistenVersionen"/>
		<xsl:if test="$DebugMode = '2' or $DebugMode = '3' or $DebugMode = '4'">
			<xsl:message>
				++++++++ codelistedetails ++++++++
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
							<xsl:call-template name="meldung">
								<xsl:with-param name="nummer">1039</xsl:with-param>
							</xsl:call-template>
						</xsl:if>
					</xsl:non-matching-substring>
				</xsl:analyze-string>
				<xsl:if test="count($ListeDoppelteCodelisten/*/xdf:codeliste) &gt; 0">
					<xsl:if test="$Meldungen = '1'">
						<xsl:for-each select="$MeldungenInhalt/gc:CodeList/SimpleCodeList/Row[Value/@ColumnRef ='Code' and Value/SimpleValue = '1036']">
							<xsl:choose>
								<xsl:when test="./Value[@ColumnRef ='Typ']/SimpleValue = 'FehlerKritisch'">
									<div class="FehlerKritisch M1036">
										FehlerKritisch!! 1036: <xsl:value-of select="./Value[@ColumnRef ='Meldungstext']/SimpleValue"/>
										<xsl:if test="$QSHilfeAufruf = '1'">
											&#160;&#160;
											<xsl:element name="a">
												<xsl:attribute name="href"><xsl:value-of select="$QSHilfePfadPrefix"/>1001<xsl:value-of select="$QSHilfePfadPostfix"/></xsl:attribute>
												<xsl:attribute name="target">MeldungsHilfe</xsl:attribute>
												<xsl:attribute name="title">Springe zu den Erläuterungen der Meldungscodes in die Qualitätskriterien.</xsl:attribute>
												&#8658;
											</xsl:element>&#160;&#160;&#160;&#160;
										</xsl:if>
										<br/>Dies betrifft Codeliste(n) 
										<xsl:for-each select="$ListeDoppelteCodelisten/*/xdf:codeliste">
											<xsl:element name="a">
												<xsl:attribute name="href">#<xsl:value-of select="."/></xsl:attribute>
												<xsl:value-of select="."/>
											</xsl:element>
											<xsl:if test="fn:position() != fn:last()">,&#160;</xsl:if>
										</xsl:for-each>
									</div>
								</xsl:when>
								<xsl:when test="./Value[@ColumnRef ='Typ']/SimpleValue = 'FehlerMethodisch'">
									<div class="FehlerMethodisch M1036">
										FehlerMethodisch!! 1036: <xsl:value-of select="./Value[@ColumnRef ='Meldungstext']/SimpleValue"/>
										<xsl:if test="$QSHilfeAufruf = '1'">
											&#160;&#160;
											<xsl:element name="a">
												<xsl:attribute name="href"><xsl:value-of select="$QSHilfePfadPrefix"/>1001<xsl:value-of select="$QSHilfePfadPostfix"/></xsl:attribute>
												<xsl:attribute name="target">MeldungsHilfe</xsl:attribute>
												<xsl:attribute name="title">Springe zu den Erläuterungen der Meldungscodes in die Qualitätskriterien.</xsl:attribute>
												&#8658;
											</xsl:element>&#160;&#160;&#160;&#160;
										</xsl:if>
										<br/>Dies betrifft Codeliste(n) 
										<xsl:for-each select="$ListeDoppelteCodelisten/*/xdf:codeliste">
											<xsl:element name="a">
												<xsl:attribute name="href">#<xsl:value-of select="."/></xsl:attribute>
												<xsl:value-of select="."/>
											</xsl:element>
											<xsl:if test="fn:position() != fn:last()">,&#160;</xsl:if>
										</xsl:for-each>
									</div>
								</xsl:when>
								<xsl:when test="./Value[@ColumnRef ='Typ']/SimpleValue = 'Warnung'">
									<div class="Warnung M1036">
										Warnung!! 1036: <xsl:value-of select="./Value[@ColumnRef ='Meldungstext']/SimpleValue"/>
										<xsl:if test="$QSHilfeAufruf = '1'">
											&#160;&#160;
											<xsl:element name="a">
												<xsl:attribute name="href"><xsl:value-of select="$QSHilfePfadPrefix"/>1001<xsl:value-of select="$QSHilfePfadPostfix"/></xsl:attribute>
												<xsl:attribute name="target">MeldungsHilfe</xsl:attribute>
												<xsl:attribute name="title">Springe zu den Erläuterungen der Meldungscodes in die Qualitätskriterien.</xsl:attribute>
												&#8658;
											</xsl:element>&#160;&#160;&#160;&#160;
										</xsl:if>
										<br/>Dies betrifft Codeliste(n) 
										<xsl:for-each select="$ListeDoppelteCodelisten/*/xdf:codeliste">
											<xsl:element name="a">
												<xsl:attribute name="href">#<xsl:value-of select="."/></xsl:attribute>
												<xsl:value-of select="."/>
											</xsl:element>
											<xsl:if test="fn:position() != fn:last()">,&#160;</xsl:if>
										</xsl:for-each>
									</div>
								</xsl:when>
								<xsl:when test="./Value[@ColumnRef ='Typ']/SimpleValue = 'Hinweis'">
									<div class="Hinweis M1036">
										Hinweis!! 1036: <xsl:value-of select="./Value[@ColumnRef ='Meldungstext']/SimpleValue"/>
										<xsl:if test="$QSHilfeAufruf = '1'">
											&#160;&#160;
											<xsl:element name="a">
												<xsl:attribute name="href"><xsl:value-of select="$QSHilfePfadPrefix"/>1001<xsl:value-of select="$QSHilfePfadPostfix"/></xsl:attribute>
												<xsl:attribute name="target">MeldungsHilfe</xsl:attribute>
												<xsl:attribute name="title">Springe zu den Erläuterungen der Meldungscodes in die Qualitätskriterien.</xsl:attribute>
												&#8658;
											</xsl:element>&#160;&#160;&#160;&#160;
										</xsl:if>
										<br/>Dies betrifft Codeliste(n) 
										<xsl:for-each select="$ListeDoppelteCodelisten/*/xdf:codeliste">
											<xsl:element name="a">
												<xsl:attribute name="href">#<xsl:value-of select="."/></xsl:attribute>
												<xsl:value-of select="."/>
											</xsl:element>
											<xsl:if test="fn:position() != fn:last()">,&#160;</xsl:if>
										</xsl:for-each>
									</div>
								</xsl:when>
								<xsl:when test="./Value[@ColumnRef ='Typ']/SimpleValue = 'Deaktiviert'">
								</xsl:when>
								<xsl:otherwise>
									<div class="Hinweis M1036">Hinweis!! 1036: Unbekannte Meldung!</div>
								</xsl:otherwise>
							</xsl:choose>
						</xsl:for-each>
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
					<xsl:choose>
						<xsl:when test="empty($Element/xdf:genericodeIdentification/xdf:canonicalIdentification/text())">
							<xsl:call-template name="meldung">
								<xsl:with-param name="nummer">1040</xsl:with-param>
							</xsl:call-template>
						</xsl:when>
						<xsl:otherwise>
							<xsl:analyze-string regex="^urn:[A-Za-z0-9][A-Za-z0-9-]{{0,31}}:([A-Za-z0-9()+,\-.:=@;\$_!*&apos;]|%[0-9A-Fa-f]{{2}})+$" select="$Element/xdf:genericodeIdentification/xdf:canonicalIdentification">
								<xsl:matching-substring>
								</xsl:matching-substring>
								<xsl:non-matching-substring>
									<xsl:if test="$Meldungen = '1'">
										<xsl:choose>
											<xsl:when test="substring($Element/xdf:genericodeIdentification/xdf:canonicalIdentification/text(),1,4) != 'urn:'">
												<xsl:call-template name="meldung">
													<xsl:with-param name="nummer">1005</xsl:with-param>
												</xsl:call-template>
											</xsl:when>
											<xsl:otherwise>
												<xsl:call-template name="meldung">
													<xsl:with-param name="nummer">1048</xsl:with-param>
												</xsl:call-template>
											</xsl:otherwise>
										</xsl:choose>
									</xsl:if>
								</xsl:non-matching-substring>
							</xsl:analyze-string>
						</xsl:otherwise>
					</xsl:choose>
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
							<xsl:for-each select="$MeldungenInhalt/gc:CodeList/SimpleCodeList/Row[Value/@ColumnRef ='Code' and Value/SimpleValue = '1037']">
								<xsl:choose>
									<xsl:when test="./Value[@ColumnRef ='Typ']/SimpleValue = 'FehlerKritisch'">
										<div class="FehlerKritisch M1037">
											FehlerKritisch!! 1037: <xsl:value-of select="./Value[@ColumnRef ='Meldungstext']/SimpleValue"/>
											<xsl:if test="$QSHilfeAufruf = '1'">
												&#160;&#160;
												<xsl:element name="a">
													<xsl:attribute name="href"><xsl:value-of select="$QSHilfePfadPrefix"/>1001<xsl:value-of select="$QSHilfePfadPostfix"/></xsl:attribute>
													<xsl:attribute name="target">MeldungsHilfe</xsl:attribute>
													<xsl:attribute name="title">Springe zu den Erläuterungen der Meldungscodes in die Qualitätskriterien.</xsl:attribute>
													&#8658;
												</xsl:element>&#160;&#160;&#160;&#160;
											</xsl:if>
											<br/>Dies betrifft Codeliste(n) 
											<xsl:for-each select="$ListeMehrereCodelistenVersionen/*/xdf:codeliste">
												<xsl:element name="a">
													<xsl:attribute name="href">#<xsl:value-of select="."/></xsl:attribute>
													<xsl:value-of select="."/>
												</xsl:element>
												<xsl:if test="fn:position() != fn:last()">,&#160;</xsl:if>
											</xsl:for-each>
										</div>
									</xsl:when>
									<xsl:when test="./Value[@ColumnRef ='Typ']/SimpleValue = 'FehlerMethodisch'">
										<div class="FehlerMethodisch M1037">
											FehlerMethodisch!! 1037: <xsl:value-of select="./Value[@ColumnRef ='Meldungstext']/SimpleValue"/>
											<xsl:if test="$QSHilfeAufruf = '1'">
												&#160;&#160;
												<xsl:element name="a">
													<xsl:attribute name="href"><xsl:value-of select="$QSHilfePfadPrefix"/>1001<xsl:value-of select="$QSHilfePfadPostfix"/></xsl:attribute>
													<xsl:attribute name="target">MeldungsHilfe</xsl:attribute>
													<xsl:attribute name="title">Springe zu den Erläuterungen der Meldungscodes in die Qualitätskriterien.</xsl:attribute>
													&#8658;
												</xsl:element>&#160;&#160;&#160;&#160;
											</xsl:if>
											<br/>Dies betrifft Codeliste(n) 
											<xsl:for-each select="$ListeMehrereCodelistenVersionen/*/xdf:codeliste">
												<xsl:element name="a">
													<xsl:attribute name="href">#<xsl:value-of select="."/></xsl:attribute>
													<xsl:value-of select="."/>
												</xsl:element>
												<xsl:if test="fn:position() != fn:last()">,&#160;</xsl:if>
											</xsl:for-each>
										</div>
									</xsl:when>
									<xsl:when test="./Value[@ColumnRef ='Typ']/SimpleValue = 'Warnung'">
										<div class="Warnung M1037">
											Warnung!! 1037: <xsl:value-of select="./Value[@ColumnRef ='Meldungstext']/SimpleValue"/>
											<xsl:if test="$QSHilfeAufruf = '1'">
												&#160;&#160;
												<xsl:element name="a">
													<xsl:attribute name="href"><xsl:value-of select="$QSHilfePfadPrefix"/>1001<xsl:value-of select="$QSHilfePfadPostfix"/></xsl:attribute>
													<xsl:attribute name="target">MeldungsHilfe</xsl:attribute>
													<xsl:attribute name="title">Springe zu den Erläuterungen der Meldungscodes in die Qualitätskriterien.</xsl:attribute>
													&#8658;
												</xsl:element>&#160;&#160;&#160;&#160;
											</xsl:if>
											<br/>Dies betrifft Codeliste(n) 
											<xsl:for-each select="$ListeMehrereCodelistenVersionen/*/xdf:codeliste">
												<xsl:element name="a">
													<xsl:attribute name="href">#<xsl:value-of select="."/></xsl:attribute>
													<xsl:value-of select="."/>
												</xsl:element>
												<xsl:if test="fn:position() != fn:last()">,&#160;</xsl:if>
											</xsl:for-each>
										</div>
									</xsl:when>
									<xsl:when test="./Value[@ColumnRef ='Typ']/SimpleValue = 'Hinweis'">
										<div class="Hinweis M1037">
											Hinweis!! 1037: <xsl:value-of select="./Value[@ColumnRef ='Meldungstext']/SimpleValue"/>
											<xsl:if test="$QSHilfeAufruf = '1'">
												&#160;&#160;
												<xsl:element name="a">
													<xsl:attribute name="href"><xsl:value-of select="$QSHilfePfadPrefix"/>1001<xsl:value-of select="$QSHilfePfadPostfix"/></xsl:attribute>
													<xsl:attribute name="target">MeldungsHilfe</xsl:attribute>
													<xsl:attribute name="title">Springe zu den Erläuterungen der Meldungscodes in die Qualitätskriterien.</xsl:attribute>
													&#8658;
												</xsl:element>&#160;&#160;&#160;&#160;
											</xsl:if>
											<br/>Dies betrifft Codeliste(n) 
											<xsl:for-each select="$ListeMehrereCodelistenVersionen/*/xdf:codeliste">
												<xsl:element name="a">
													<xsl:attribute name="href">#<xsl:value-of select="."/></xsl:attribute>
													<xsl:value-of select="."/>
												</xsl:element>
												<xsl:if test="fn:position() != fn:last()">,&#160;</xsl:if>
											</xsl:for-each>
										</div>
									</xsl:when>
									<xsl:when test="./Value[@ColumnRef ='Typ']/SimpleValue = 'Deaktiviert'">
									</xsl:when>
									<xsl:otherwise>
										<div class="Hinweis M1037">Hinweis!! 1037: Unbekannte Meldung!</div>
									</xsl:otherwise>
								</xsl:choose>
							</xsl:for-each>
						</xsl:if>
					</td>
				</xsl:when>
				<xsl:when test="substring($Element/xdf:genericodeIdentification/xdf:version/text(),5,1) != '-' or substring($Element/xdf:genericodeIdentification/xdf:version/text(),8,1) != '-'">
					<td>
						<xsl:value-of select="$Element/xdf:genericodeIdentification/xdf:version"/>
						<xsl:if test="$Meldungen = '1'">
							<xsl:call-template name="meldung">
								<xsl:with-param name="nummer">1105</xsl:with-param>
							</xsl:call-template>
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
								<xsl:call-template name="meldung">
									<xsl:with-param name="nummer">1115</xsl:with-param>
								</xsl:call-template>
							</td>
						</tr>
					</xsl:if>
				</xsl:when>
				<xsl:otherwise>

					<xsl:variable name="CodeKeySpalteV1">
						<xsl:value-of select="$CodelisteInhalt/*/gc:ColumnSet/gc:Key[@Id='codeKey']/gc:ColumnRef/@Ref"/><xsl:value-of select="$CodelisteInhalt/*/ColumnSet/Key[@Id='codeKey']/ColumnRef/@Ref"/>
					</xsl:variable> 
					<xsl:variable name="CodeKeySpalteV2">
						<xsl:value-of select="$CodelisteInhalt/*/gc:ColumnSet/gc:Key[1]/gc:ColumnRef/@Ref"/><xsl:value-of select="$CodelisteInhalt/*/ColumnSet/Key[1]/ColumnRef/@Ref"/>
					</xsl:variable> 
					<xsl:variable name="CodeKeySpalte">
						<xsl:choose>
							<xsl:when test="empty($CodeKeySpalteV1/text())"><xsl:value-of select="$CodeKeySpalteV2"/></xsl:when>
							<xsl:otherwise><xsl:value-of select="$CodeKeySpalteV1"/></xsl:otherwise>
						</xsl:choose>
					</xsl:variable> 

					<tr>
						<td>Inhalt</td>
						<td>
							<table>
								<thead>
									<tr>
										<xsl:if test="$Meldungen = '1' and fn:count($CodelisteInhalt/*/gc:SimpleCodeList/gc:Row) &lt; 2">
											<xsl:call-template name="meldung">
												<xsl:with-param name="nummer">1044</xsl:with-param>
											</xsl:call-template>
										</xsl:if>
										<xsl:for-each select="$CodelisteInhalt/*/gc:ColumnSet/gc:Column">
											<th>
												<xsl:value-of select="./gc:ShortName"/>
												
												<xsl:if test="$Meldungen = '1' and ./@Id = $CodeKeySpalte">
													<xsl:if test="count(distinct-values($CodelisteInhalt/*/gc:SimpleCodeList/gc:Row/gc:Value[@ColumnRef=$CodeKeySpalte])) &lt; count($CodelisteInhalt/*/gc:SimpleCodeList/gc:Row/gc:Value[@ColumnRef=$CodeKeySpalte])">
														<xsl:call-template name="meldung">
															<xsl:with-param name="nummer">1045</xsl:with-param>
														</xsl:call-template>
													</xsl:if>
												</xsl:if>
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
	<xsl:template name="unterelemente">
		<xsl:param name="Element"/>
		<xsl:param name="Tiefe"/>
		<xsl:param name="Strukturelementart"/>
		<xsl:if test="$DebugMode = '4'">
			<xsl:message>
				++++++++++++++++ unterelemente ++++++++++++++++
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
								<xsl:call-template name="meldung">
									<xsl:with-param name="nummer">1038</xsl:with-param>
								</xsl:call-template>
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
									<xsl:for-each select="$MeldungenInhalt/gc:CodeList/SimpleCodeList/Row[Value/@ColumnRef ='Code' and Value/SimpleValue = '1001']">
										<xsl:choose>
											<xsl:when test="./Value[@ColumnRef ='Typ']/SimpleValue = 'FehlerKritisch'">
												<div class="FehlerKritisch M1001">
													FehlerKritisch!! 1001: <xsl:value-of select="./Value[@ColumnRef ='Meldungstext']/SimpleValue"/> Nicht-erreichbares Element: <xsl:value-of select="$TestElement"/>
													<xsl:if test="$QSHilfeAufruf = '1'">
														&#160;&#160;
														<xsl:element name="a">
															<xsl:attribute name="href"><xsl:value-of select="$QSHilfePfadPrefix"/>1001<xsl:value-of select="$QSHilfePfadPostfix"/></xsl:attribute>
															<xsl:attribute name="target">MeldungsHilfe</xsl:attribute>
															<xsl:attribute name="title">Springe zu den Erläuterungen der Meldungscodes in die Qualitätskriterien.</xsl:attribute>
															&#8658;
														</xsl:element>&#160;&#160;&#160;&#160;
													</xsl:if>
												</div>
											</xsl:when>
											<xsl:when test="./Value[@ColumnRef ='Typ']/SimpleValue = 'FehlerMethodisch'">
												<div class="FehlerMethodisch M1001">
													FehlerMethodisch!! 1001: <xsl:value-of select="./Value[@ColumnRef ='Meldungstext']/SimpleValue"/> Nicht-erreichbares Element: <xsl:value-of select="$TestElement"/>
													<xsl:if test="$QSHilfeAufruf = '1'">
														&#160;&#160;
														<xsl:element name="a">
															<xsl:attribute name="href"><xsl:value-of select="$QSHilfePfadPrefix"/>1001<xsl:value-of select="$QSHilfePfadPostfix"/></xsl:attribute>
															<xsl:attribute name="target">MeldungsHilfe</xsl:attribute>
															<xsl:attribute name="title">Springe zu den Erläuterungen der Meldungscodes in die Qualitätskriterien.</xsl:attribute>
															&#8658;
														</xsl:element>&#160;&#160;&#160;&#160;
													</xsl:if>
												</div>
											</xsl:when>
											<xsl:when test="./Value[@ColumnRef ='Typ']/SimpleValue = 'Warnung'">
												<div class="Warnung 1001">
													Warnung!! M1001: <xsl:value-of select="./Value[@ColumnRef ='Meldungstext']/SimpleValue"/> Nicht-erreichbares Element: <xsl:value-of select="$TestElement"/>
													<xsl:if test="$QSHilfeAufruf = '1'">
														&#160;&#160;
														<xsl:element name="a">
															<xsl:attribute name="href"><xsl:value-of select="$QSHilfePfadPrefix"/>1001<xsl:value-of select="$QSHilfePfadPostfix"/></xsl:attribute>
															<xsl:attribute name="target">MeldungsHilfe</xsl:attribute>
															<xsl:attribute name="title">Springe zu den Erläuterungen der Meldungscodes in die Qualitätskriterien.</xsl:attribute>
															&#8658;
														</xsl:element>&#160;&#160;&#160;&#160;
													</xsl:if>
												</div>
											</xsl:when>
											<xsl:when test="./Value[@ColumnRef ='Typ']/SimpleValue = 'Hinweis'">
												<div class="Hinweis M1001">
													Hinweis!! 1001: <xsl:value-of select="./Value[@ColumnRef ='Meldungstext']/SimpleValue"/> Nicht-erreichbares Element: <xsl:value-of select="$TestElement"/>
													<xsl:if test="$QSHilfeAufruf = '1'">
														&#160;&#160;
														<xsl:element name="a">
															<xsl:attribute name="href"><xsl:value-of select="$QSHilfePfadPrefix"/>1001<xsl:value-of select="$QSHilfePfadPostfix"/></xsl:attribute>
															<xsl:attribute name="target">MeldungsHilfe</xsl:attribute>
															<xsl:attribute name="title">Springe zu den Erläuterungen der Meldungscodes in die Qualitätskriterien.</xsl:attribute>
															&#8658;
														</xsl:element>&#160;&#160;&#160;&#160;
													</xsl:if>
												</div>
											</xsl:when>
											<xsl:when test="./Value[@ColumnRef ='Typ']/SimpleValue = 'Deaktiviert'">
											</xsl:when>
											<xsl:otherwise>
												<div class="Hinweis M1001">Hinweis!! 1001: Unbekannte Meldung!</div>
											</xsl:otherwise>
										</xsl:choose>
									</xsl:for-each>
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
							<xsl:call-template name="meldung">
								<xsl:with-param name="nummer">1019</xsl:with-param>
							</xsl:call-template>
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
								<xsl:call-template name="meldung">
									<xsl:with-param name="nummer">1038</xsl:with-param>
								</xsl:call-template>
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
					<xsl:if test="count(.//xdf:enthaelt/xdf:datenfeldgruppe[xdf:identifikation/xdf:id = $Element/xdf:identifikation/xdf:id and xdf:identifikation/xdf:version = $Element/xdf:identifikation/xdf:version]) &gt; 0">
						<xsl:if test="$Meldungen = '1'">
							<xsl:call-template name="meldung">
								<xsl:with-param name="nummer">1026</xsl:with-param>
							</xsl:call-template>
						</xsl:if>
					</xsl:if>
					<xsl:choose>
						<xsl:when test="$VergleichsVersion = ''">
							<xsl:if test="$Tiefe = 1 and count($Element/xdf:struktur/./xdf:enthaelt/*/xdf:identifikation[xdf:id=$VergleichsElement and not(xdf:version)]) &gt; 1">
								<xsl:if test="$Meldungen = '1'">
									<xsl:call-template name="meldung">
										<xsl:with-param name="nummer">1025</xsl:with-param>
									</xsl:call-template>
								</xsl:if>
							</xsl:if>
						</xsl:when>
						<xsl:otherwise>
							<xsl:if test="$Tiefe = 1 and count($Element/xdf:struktur/./xdf:enthaelt/*/xdf:identifikation[xdf:id=$VergleichsElement and xdf:version=$VergleichsVersion]) &gt; 1">
								<xsl:if test="$Meldungen = '1'">
									<xsl:call-template name="meldung">
										<xsl:with-param name="nummer">1025</xsl:with-param>
									</xsl:call-template>
								</xsl:if>
							</xsl:if>
						</xsl:otherwise>
					</xsl:choose>
				</td>
				<xsl:choose>
					<xsl:when test="$Tiefe = 1 and empty(./xdf:enthaelt/*/xdf:identifikation/xdf:version/text()) and $VersionsHinweise ='1'">
						<td>
							<xsl:value-of select="./xdf:enthaelt/*/xdf:identifikation/xdf:version"/>
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
								<xsl:call-template name="meldung">
									<xsl:with-param name="nummer">1013</xsl:with-param>
								</xsl:call-template>
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
								<xsl:call-template name="meldung">
									<xsl:with-param name="nummer">1116</xsl:with-param>
								</xsl:call-template>
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
							<xsl:analyze-string regex="^\d+:(\d+|\*)$" select="./xdf:anzahl">
								<xsl:matching-substring>
									<xsl:if test="$AnzahlText = '0:0'">
										<xsl:call-template name="meldung">
											<xsl:with-param name="nummer">1021</xsl:with-param>
										</xsl:call-template>
									</xsl:if>
									<xsl:if test="(fn:number($minCount) &gt; fn:number($maxCount)) and $maxCount != '*'">
										<xsl:call-template name="meldung">
											<xsl:with-param name="nummer">1047</xsl:with-param>
										</xsl:call-template>
									</xsl:if>
								</xsl:matching-substring>
								<xsl:non-matching-substring>
									<xsl:if test="$Meldungen = '1'">
										<xsl:call-template name="meldung">
											<xsl:with-param name="nummer">1046</xsl:with-param>
										</xsl:call-template>
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
								<xsl:call-template name="meldung">
									<xsl:with-param name="nummer">1022</xsl:with-param>
								</xsl:call-template>
							</xsl:if>
						</td>
					</xsl:when>
					<xsl:when test="$Strukturelementart ='SDS' and (./xdf:enthaelt/*/xdf:schemaelementart/code/text() = 'ABS' or ./xdf:enthaelt/*/xdf:schemaelementart/code/text() = 'HAR') and empty(./xdf:bezug/text())and $Tiefe = 1">
						<td>
							<xsl:if test="$Meldungen = '1'">
								<xsl:call-template name="meldung">
									<xsl:with-param name="nummer">1022</xsl:with-param>
								</xsl:call-template>
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
				<xsl:call-template name="unterelemente">
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
					<xsl:call-template name="meldung">
						<xsl:with-param name="nummer">1027</xsl:with-param>
					</xsl:call-template>
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
					<xsl:call-template name="meldung">
						<xsl:with-param name="nummer">1028</xsl:with-param>
					</xsl:call-template>
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
					<xsl:call-template name="meldung">
						<xsl:with-param name="nummer">1031</xsl:with-param>
					</xsl:call-template>
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
					<xsl:call-template name="meldung">
						<xsl:with-param name="nummer">1032</xsl:with-param>
					</xsl:call-template>
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
					<xsl:call-template name="meldung">
						<xsl:with-param name="nummer">1033</xsl:with-param>
					</xsl:call-template>
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
					<xsl:call-template name="meldung">
						<xsl:with-param name="nummer">1034</xsl:with-param>
					</xsl:call-template>
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
	<xsl:template name="meldung">
		<xsl:param name="nummer"/>
		
		<xsl:for-each select="$MeldungenInhalt/gc:CodeList/SimpleCodeList/Row[Value/@ColumnRef ='Code' and Value/SimpleValue = $nummer]">
			<xsl:choose>
				<xsl:when test="./Value[@ColumnRef ='Typ']/SimpleValue = 'FehlerKritisch'">
					<div class="FehlerKritisch M{$nummer}">
						FehlerKritisch!! <xsl:value-of select="$nummer"/>: <xsl:value-of select="./Value[@ColumnRef ='Meldungstext']/SimpleValue"/>
						<xsl:if test="$QSHilfeAufruf = '1'">
							&#160;&#160;
							<xsl:element name="a">
								<xsl:attribute name="href"><xsl:value-of select="$QSHilfePfadPrefix"/><xsl:value-of select="$nummer"/><xsl:value-of select="$QSHilfePfadPostfix"/></xsl:attribute>
								<xsl:attribute name="target">MeldungsHilfe</xsl:attribute>
								<xsl:attribute name="title">Springe zu den Erläuterungen der Meldungscodes in die Qualitätskriterien.</xsl:attribute>
								&#8658;
							</xsl:element>&#160;&#160;&#160;&#160;
						</xsl:if>
					</div>
				</xsl:when>
				<xsl:when test="./Value[@ColumnRef ='Typ']/SimpleValue = 'FehlerMethodisch'">
					<div class="FehlerMethodisch M{$nummer}">
						FehlerMethodisch!! <xsl:value-of select="$nummer"/>: <xsl:value-of select="./Value[@ColumnRef ='Meldungstext']/SimpleValue"/>
						<xsl:if test="$QSHilfeAufruf = '1'">
							&#160;&#160;
							<xsl:element name="a">
								<xsl:attribute name="href"><xsl:value-of select="$QSHilfePfadPrefix"/><xsl:value-of select="$nummer"/><xsl:value-of select="$QSHilfePfadPostfix"/></xsl:attribute>
								<xsl:attribute name="target">MeldungsHilfe</xsl:attribute>
								<xsl:attribute name="title">Springe zu den Erläuterungen der Meldungscodes in die Qualitätskriterien.</xsl:attribute>
								&#8658;
							</xsl:element>&#160;&#160;&#160;&#160;
						</xsl:if>
					</div>
				</xsl:when>
				<xsl:when test="./Value[@ColumnRef ='Typ']/SimpleValue = 'Warnung'">
					<div class="Warnung M{$nummer}">
						Warnung!! <xsl:value-of select="$nummer"/>: <xsl:value-of select="./Value[@ColumnRef ='Meldungstext']/SimpleValue"/>
						<xsl:if test="$QSHilfeAufruf = '1'">
							&#160;&#160;
							<xsl:element name="a">
								<xsl:attribute name="href"><xsl:value-of select="$QSHilfePfadPrefix"/><xsl:value-of select="$nummer"/><xsl:value-of select="$QSHilfePfadPostfix"/></xsl:attribute>
								<xsl:attribute name="target">MeldungsHilfe</xsl:attribute>
								<xsl:attribute name="title">Springe zu den Erläuterungen der Meldungscodes in die Qualitätskriterien.</xsl:attribute>
								&#8658;
							</xsl:element>&#160;&#160;&#160;&#160;
						</xsl:if>
					</div>
				</xsl:when>
				<xsl:when test="./Value[@ColumnRef ='Typ']/SimpleValue = 'Hinweis'">
					<div class="Hinweis M{$nummer}">
						Hinweis!! <xsl:value-of select="$nummer"/>: <xsl:value-of select="./Value[@ColumnRef ='Meldungstext']/SimpleValue"/>
						<xsl:if test="$QSHilfeAufruf = '1'">
							&#160;&#160;
							<xsl:element name="a">
								<xsl:attribute name="href"><xsl:value-of select="$QSHilfePfadPrefix"/><xsl:value-of select="$nummer"/><xsl:value-of select="$QSHilfePfadPostfix"/></xsl:attribute>
								<xsl:attribute name="target">MeldungsHilfe</xsl:attribute>
								<xsl:attribute name="title">Springe zu den Erläuterungen der Meldungscodes in die Qualitätskriterien.</xsl:attribute>
								&#8658;
							</xsl:element>&#160;&#160;&#160;&#160;
						</xsl:if>
					</div>
				</xsl:when>
				<xsl:when test="./Value[@ColumnRef ='Typ']/SimpleValue = 'Deaktiviert'">
				</xsl:when>
				<xsl:otherwise>
					<div class="Hinweis M{$nummer}">Hinweis!! <xsl:value-of select="$nummer"/>: Unbekannte Meldung!</div>
				</xsl:otherwise>
			</xsl:choose>
		</xsl:for-each>
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
				color:green;
			}
			
			.Warnung
			{
				font-weight: bold;
				color:blue;
			}
			
			.FehlerMethodisch
			{
				font-weight: bold;
				color:orange;
			}

			.FehlerKritisch
			{
				font-weight: bold;
				color:red;
			}

			.Zusammenfassung
			{
				font-weight: bold;
				font-size: 110%;
			}
			
			.ZusammenfassungHilfe
			{
				font-weight: normal;
				font-size: 80%;
				color: black;
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

				const AnzahlFehlerKritisch = document.querySelectorAll('.FehlerKritisch').length;

				const AnzahlFehlerMethodisch = document.querySelectorAll('.FehlerMethodisch').length;

				const AnzahlWarnungen = document.querySelectorAll('.Warnung').length;

				const AnzahlHinweise = document.querySelectorAll('.Hinweis').length;

				if (AnzahlFehlerKritisch != 0)
				{
					document.getElementById("AnzahlFehlerKritisch").style.color = "red";
					document.getElementById("AnzahlFehlerKritisch").innerHTML = "Anzahl kritischer Fehler: " + AnzahlFehlerKritisch + "<xsl:text disable-output-escaping="yes">&lt;</xsl:text>br/<xsl:text disable-output-escaping="yes">&gt;</xsl:text><xsl:text disable-output-escaping="yes">&lt;</xsl:text>span class='ZusammenfassungHilfe'<xsl:text disable-output-escaping="yes">&gt;</xsl:text>(verhindern den Austausch zwischen Editoren und die Migration)<xsl:text disable-output-escaping="yes">&lt;</xsl:text>/span<xsl:text disable-output-escaping="yes">&gt;</xsl:text>";
				}

				if (AnzahlFehlerMethodisch != 0)
				{
					document.getElementById("AnzahlFehlerMethodisch").style.color = "orange";
					document.getElementById("AnzahlFehlerMethodisch").innerHTML = "Anzahl methodischer Fehler: " + AnzahlFehlerMethodisch + "<xsl:text disable-output-escaping="yes">&lt;</xsl:text>br/<xsl:text disable-output-escaping="yes">&gt;</xsl:text><xsl:text disable-output-escaping="yes">&lt;</xsl:text>span class='ZusammenfassungHilfe'<xsl:text disable-output-escaping="yes">&gt;</xsl:text>(verhindern methodische Freigabe)<xsl:text disable-output-escaping="yes">&lt;</xsl:text>/span<xsl:text disable-output-escaping="yes">&gt;</xsl:text>";
				}

				if (AnzahlWarnungen != 0)
				{
					document.getElementById("AnzahlWarnungen").style.color = "blue";
					document.getElementById("AnzahlWarnungen").innerHTML = "Anzahl Warnungen: " + AnzahlWarnungen + "<xsl:text disable-output-escaping="yes">&lt;</xsl:text>br/<xsl:text disable-output-escaping="yes">&gt;</xsl:text><xsl:text disable-output-escaping="yes">&lt;</xsl:text>span class='ZusammenfassungHilfe'<xsl:text disable-output-escaping="yes">&gt;</xsl:text>(potentielle methodische Fehler)<xsl:text disable-output-escaping="yes">&lt;</xsl:text>/span<xsl:text disable-output-escaping="yes">&gt;</xsl:text>";
				}

				if (AnzahlHinweise != 0)
				{
					document.getElementById("AnzahlHinweise").style.color = "green";
					document.getElementById("AnzahlHinweise").innerHTML = "Anzahl Hinweise: " + AnzahlHinweise;
				}


				<xsl:for-each select="$MeldungenInhalt/gc:CodeList/SimpleCodeList/Row">
					<xsl:choose>
						<xsl:when test="./Value[@ColumnRef ='Typ']/SimpleValue = 'FehlerKritisch'">

							if (document.querySelectorAll('.M<xsl:value-of select="./Value[@ColumnRef ='Code']/SimpleValue"/>').length != 0)
							{
								document.getElementById("ListeFehlerKritisch").insertAdjacentHTML('beforeend', document.querySelectorAll('.M<xsl:value-of select="./Value[@ColumnRef ='Code']/SimpleValue"/>').length + " mal <xsl:value-of select="./Value[@ColumnRef ='Code']/SimpleValue"/>: <xsl:value-of select="./Value[@ColumnRef ='Meldungstext']/SimpleValue"/>" + <xsl:if test="$QSHilfeAufruf = '1'">"&#160;&#160;<xsl:text disable-output-escaping="yes">&lt;</xsl:text>a href='<xsl:value-of select="$QSHilfePfadPrefix"/><xsl:value-of select="./Value[@ColumnRef ='Code']/SimpleValue"/><xsl:value-of select="$QSHilfePfadPostfix"/>' target='MeldungsHilfe' title='Springe zu den Erläuterungen der Meldungscodes in die Qualitätskriterien.'<xsl:text disable-output-escaping="yes">&gt;</xsl:text>&#8658;<xsl:text disable-output-escaping="yes">&lt;</xsl:text>/a<xsl:text disable-output-escaping="yes">&gt;</xsl:text>"</xsl:if> + "<xsl:text disable-output-escaping="yes">&lt;</xsl:text>br/<xsl:text disable-output-escaping="yes">&gt;</xsl:text>" );
							}

						</xsl:when>

						<xsl:when test="./Value[@ColumnRef ='Typ']/SimpleValue = 'FehlerMethodisch'">

							if (document.querySelectorAll('.M<xsl:value-of select="./Value[@ColumnRef ='Code']/SimpleValue"/>').length != 0)
							{
								document.getElementById("ListeFehlerMethodisch").insertAdjacentHTML('beforeend', document.querySelectorAll('.M<xsl:value-of select="./Value[@ColumnRef ='Code']/SimpleValue"/>').length + " mal <xsl:value-of select="./Value[@ColumnRef ='Code']/SimpleValue"/>: <xsl:value-of select="./Value[@ColumnRef ='Meldungstext']/SimpleValue"/>" + <xsl:if test="$QSHilfeAufruf = '1'">"&#160;&#160;<xsl:text disable-output-escaping="yes">&lt;</xsl:text>a href='<xsl:value-of select="$QSHilfePfadPrefix"/><xsl:value-of select="./Value[@ColumnRef ='Code']/SimpleValue"/><xsl:value-of select="$QSHilfePfadPostfix"/>' target='MeldungsHilfe' title='Springe zu den Erläuterungen der Meldungscodes in die Qualitätskriterien.'<xsl:text disable-output-escaping="yes">&gt;</xsl:text>&#8658;<xsl:text disable-output-escaping="yes">&lt;</xsl:text>/a<xsl:text disable-output-escaping="yes">&gt;</xsl:text>"</xsl:if> + "<xsl:text disable-output-escaping="yes">&lt;</xsl:text>br/<xsl:text disable-output-escaping="yes">&gt;</xsl:text>");
							}

						</xsl:when>

						<xsl:when test="./Value[@ColumnRef ='Typ']/SimpleValue = 'Warnung'">

							if (document.querySelectorAll('.M<xsl:value-of select="./Value[@ColumnRef ='Code']/SimpleValue"/>').length != 0)
							{
								document.getElementById("ListeWarnungen").insertAdjacentHTML('beforeend', document.querySelectorAll('.M<xsl:value-of select="./Value[@ColumnRef ='Code']/SimpleValue"/>').length + " mal <xsl:value-of select="./Value[@ColumnRef ='Code']/SimpleValue"/>: <xsl:value-of select="./Value[@ColumnRef ='Meldungstext']/SimpleValue"/>" + <xsl:if test="$QSHilfeAufruf = '1'">"&#160;&#160;<xsl:text disable-output-escaping="yes">&lt;</xsl:text>a href='<xsl:value-of select="$QSHilfePfadPrefix"/><xsl:value-of select="./Value[@ColumnRef ='Code']/SimpleValue"/><xsl:value-of select="$QSHilfePfadPostfix"/>' target='MeldungsHilfe' title='Springe zu den Erläuterungen der Meldungscodes in die Qualitätskriterien.'<xsl:text disable-output-escaping="yes">&gt;</xsl:text>&#8658;<xsl:text disable-output-escaping="yes">&lt;</xsl:text>/a<xsl:text disable-output-escaping="yes">&gt;</xsl:text>"</xsl:if> + "<xsl:text disable-output-escaping="yes">&lt;</xsl:text>br/<xsl:text disable-output-escaping="yes">&gt;</xsl:text>");
							}

						</xsl:when>

						<xsl:when test="./Value[@ColumnRef ='Typ']/SimpleValue = 'Hinweis'">

							if (document.querySelectorAll('.M<xsl:value-of select="./Value[@ColumnRef ='Code']/SimpleValue"/>').length != 0)
							{
								document.getElementById("ListeHinweise").insertAdjacentHTML('beforeend', document.querySelectorAll('.M<xsl:value-of select="./Value[@ColumnRef ='Code']/SimpleValue"/>').length + " mal <xsl:value-of select="./Value[@ColumnRef ='Code']/SimpleValue"/>: <xsl:value-of select="./Value[@ColumnRef ='Meldungstext']/SimpleValue"/>" + <xsl:if test="$QSHilfeAufruf = '1'">"&#160;&#160;<xsl:text disable-output-escaping="yes">&lt;</xsl:text>a href='<xsl:value-of select="$QSHilfePfadPrefix"/><xsl:value-of select="./Value[@ColumnRef ='Code']/SimpleValue"/><xsl:value-of select="$QSHilfePfadPostfix"/>' target='MeldungsHilfe' title='Springe zu den Erläuterungen der Meldungscodes in die Qualitätskriterien.'<xsl:text disable-output-escaping="yes">&gt;</xsl:text>&#8658;<xsl:text disable-output-escaping="yes">&lt;</xsl:text>/a<xsl:text disable-output-escaping="yes">&gt;</xsl:text>"</xsl:if> + "<xsl:text disable-output-escaping="yes">&lt;</xsl:text>br/<xsl:text disable-output-escaping="yes">&gt;</xsl:text>");
							}

						</xsl:when>

					</xsl:choose>
				</xsl:for-each>

			</xsl:if>
			}

		</script>
		</xsl:if>
	</xsl:template>
</xsl:stylesheet>
