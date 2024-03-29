<?xml version="1.0" encoding="iso-8859-1"?>
<xsl:stylesheet version="2.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:html="http://www.w3.org/1999/xhtml" xmlns="http://www.w3.org/1999/xhtml" xmlns:fn="http://www.w3.org/2005/xpath-functions" xmlns:xdf3="urn:xoev-de:fim:standard:xdatenfelder_3.0.0" xmlns:gc="http://docs.oasis-open.org/codelist/ns/genericode/1.0/" xmlns:ext="http://www.xoev.de/de/xrepository/framework/1/extrakte" xmlns:bdt="http://www.xoev.de/de/xrepository/framework/1/basisdatentypen" xmlns:dat="http://www.xoev.de/de/xrepository/framework/1/datenbereitstellung" xmlns:svrl="http://purl.oclc.org/dsdl/svrl" xmlns:xs="http://www.w3.org/2001/XMLSchema" exclude-result-prefixes="html xs">
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
	<xsl:variable name="StyleSheetName" select="'QS-DF_0_991_xdf3.xsl'"/>
	<!-- BackUp, falls fn:static-base-uri() leer -->
	<xsl:output method="xhtml" doctype-system="http://www.w3.org/TR/xhtml11/DTD/xhtml11.dtd" doctype-public="-//W3C//DTD XHTML 1.1//EN" omit-xml-declaration="yes"/>
	<xsl:strip-space elements="*"/>
	<xsl:param name="DateiOutput" select="'0'"/>
	<xsl:param name="JavaScript" select="'1'"/>
	<xsl:param name="Navigation" select="'1'"/>
	<xsl:param name="InterneLinks" select="'1'"/>
	<xsl:param name="HandlungsgrundlagenLinks" select="'1'"/>
	<xsl:param name="Meldungen" select="'1'"/>
	<xsl:param name="AbstraktWarnung" select="'1'"/>
	<xsl:param name="VersionsHinweise" select="'0'"/>
	<xsl:param name="MeldungsFazit" select="'1'"/>
	<xsl:param name="CodelistenInhalt" select="'0'"/>
	<xsl:param name="ToolAufruf" select="'1'"/>
	<xsl:param name="ToolPfadPrefix" select="'https://www.fim-formular.niedersachsen.de/fim/portal/fim/9/editor/'"/>
	<xsl:param name="ToolPfadPostfix" select="'/view'"/>
	<xsl:param name="XRepoAufruf" select="'1'"/>
	<xsl:param name="DocXRepoOhneVersionPfadPrefix" select="'https://www.xrepository.de/details/'"/>
	<xsl:param name="DocXRepoOhneVersionPfadPostfix" select="''"/>
	<xsl:param name="DocXRepoMitVersionPfadPrefix" select="'https://www.xrepository.de/details/'"/>
	<xsl:param name="DocXRepoMitVersionPfadPostfix" select="'#version'"/>
	<xsl:param name="XMLXRepoOhneVersionPfadPrefix" select="'https://www.xrepository.de/api/codeliste/'"/>
	<xsl:param name="XMLXRepoOhneVersionPfadPostfix" select="'/gueltigeVersion'"/>
	<xsl:param name="XMLXRepoMitVersionPfadPrefix" select="'https://www.xrepository.de/api/version_codeliste/'"/>
	<xsl:param name="XMLXRepoMitVersionPfadPostfix" select="'/genericode'"/>
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
				HandlungsgrundlagenLinks: <xsl:value-of select="$HandlungsgrundlagenLinks"/>				
				ToolAufruf: <xsl:value-of select="$ToolAufruf"/>
				ToolPfadPrefix: <xsl:value-of select="$ToolPfadPrefix"/>
				ToolPfadPostfix: <xsl:value-of select="$ToolPfadPostfix"/>
				Meldungen: <xsl:value-of select="$Meldungen"/>
				AbstraktWarnung: <xsl:value-of select="$AbstraktWarnung"/>
				VersionsHinweise: <xsl:value-of select="$VersionsHinweise"/>
				MeldungsFazit: <xsl:value-of select="$MeldungsFazit"/>
				CodelistenInhalt: <xsl:value-of select="$CodelistenInhalt"/>
				XRepoAufruf: <xsl:value-of select="$XRepoAufruf"/>
				DocXRepoOhneVersionPfadPrefix: <xsl:value-of select="$DocXRepoOhneVersionPfadPrefix"/>
				DocXRepoOhneVersionPfadPostfix: <xsl:value-of select="$DocXRepoOhneVersionPfadPostfix"/>
				DocXRepoMitVersionPfadPrefix: <xsl:value-of select="$DocXRepoMitVersionPfadPrefix"/>
				DocXRepoMitVersionPfadPostfix: <xsl:value-of select="$DocXRepoMitVersionPfadPostfix"/>
				XMLXRepoOhneVersionPfadPrefix: <xsl:value-of select="$XMLXRepoOhneVersionPfadPrefix"/>
				XMLXRepoOhneVersionPfadPostfix: <xsl:value-of select="$XMLXRepoOhneVersionPfadPostfix"/>
				XMLXRepoMitVersionPfadPrefix: <xsl:value-of select="$XMLXRepoMitVersionPfadPrefix"/>
				XMLXRepoMitVersionPfadPostfix: <xsl:value-of select="$XMLXRepoMitVersionPfadPostfix"/>
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
						<xsl:when test="name(/*) ='xdf3:xdatenfelder.stammdatenschema.0102'">Bericht_<xsl:value-of select="fn:substring-before($InputDateiname,'.xml')"/>.html</xsl:when>
						<xsl:when test="name(/*) ='xdf3:xdatenfelder.datenfeldgruppe.0103'">Bericht_<xsl:value-of select="fn:substring-before($InputDateiname,'.xml')"/>.html</xsl:when>
						<xsl:when test="name(/*) ='xdf3:xdatenfelder.dokumentsteckbrief.0101'">Bericht_<xsl:value-of select="fn:substring-before($InputDateiname,'.xml')"/>.html</xsl:when>
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
					<xsl:when test="name(/*) ='xdf3:xdatenfelder.stammdatenschema.0102'">
						<title>Details zum Datenschema <xsl:value-of select="/*/xdf3:stammdatenschema/xdf3:identifikation/xdf3:id"/>
							<xsl:if test="/*/xdf3:stammdatenschema/xdf3:identifikation/xdf3:version"> Version <xsl:value-of select="/*/xdf3:stammdatenschema/xdf3:identifikation/xdf3:version"/>
							</xsl:if>
						</title>
					</xsl:when>
					<xsl:when test="name(/*) ='xdf3:xdatenfelder.datenfeldgruppe.0103'">
						<title>Details zum Datenfeldgruppe <xsl:value-of select="/*/xdf3:datenfeldgruppe/xdf3:identifikation/xdf3:id"/>
							<xsl:if test="/*/xdf3:datenfeldgruppe/xdf3:identifikation/xdf3:version"> Version <xsl:value-of select="/*/xdf3:datenfeldgruppe/xdf3:identifikation/xdf3:version"/>
							</xsl:if>
						</title>
					</xsl:when>
					<xsl:when test="name(/*) ='xdf3:xdatenfelder.dokumentsteckbrief.0101'">
						<title>Details zum Datenfeldgruppe <xsl:value-of select="/*/xdf3:dokumentsteckbrief/xdf3:identifikation/xdf3:id"/>
							<xsl:if test="/*/xdf3:dokumentsteckbrief/xdf3:identifikation/xdf3:version"> Version <xsl:value-of select="/*/xdf3:dokumentsteckbrief/xdf3:identifikation/xdf3:version"/>
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
				<xsl:if test="$Navigation = '1' and $Statistik !='2' and name(/*) !='xdf3:xdatenfelder.dokumentsteckbrief.0101'">
					<div id="fixiert" class="Navigation">
						<xsl:if test="$JavaScript = '1'">
							<p align="right">
								<a href="#" title="Schlie�e das Navigationsfenster" onclick="VersteckeNavigation(); return false;">&#10006;</a>
							</p>
						</xsl:if>
						<h2>Navigation</h2>
						<xsl:choose>
							<xsl:when test="name(/*) ='xdf3:xdatenfelder.stammdatenschema.0102'">
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
							<xsl:when test="name(/*) ='xdf3:xdatenfelder.datenfeldgruppe.0103'">
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
						<xsl:when test="name(/*) ='xdf3:xdatenfelder.stammdatenschema.0102'">
							<h1>
								<xsl:choose>
									<xsl:when test="$Meldungen = '1'">
											Qualit�tsbericht Datenschema <xsl:value-of select="/*/xdf3:stammdatenschema/xdf3:identifikation/xdf3:id"/>
										<xsl:if test="/*/xdf3:stammdatenschema/xdf3:identifikation/xdf3:version">&#160;Version&#160;<xsl:value-of select="/*/xdf3:stammdatenschema/xdf3:identifikation/xdf3:version"/>
										</xsl:if>
									</xsl:when>
									<xsl:otherwise>
											�bersicht Datenschema <xsl:value-of select="/*/xdf3:stammdatenschema/xdf3:identifikation/xdf3:id"/>
										<xsl:if test="/*/xdf3:stammdatenschema/xdf3:identifikation/xdf3:version">&#160;Version&#160;<xsl:value-of select="/*/xdf3:stammdatenschema/xdf3:identifikation/xdf3:version"/>
										</xsl:if>
									</xsl:otherwise>
								</xsl:choose>
							</h1>
							<xsl:if test="$Statistik != '2'">
								<div id="Zusammenfassungsbereich">
									<xsl:if test="$MeldungsFazit = '1' and $Meldungen = '1' and $JavaScript = '1'">
										<h2>
											<a name="Zusammenfassung"/>QS-Zusammenfassung des Datenschemas <xsl:value-of select="/*/xdf3:stammdatenschema/xdf3:identifikation/xdf3:id"/>
											<xsl:if test="/*/xdf3:stammdatenschema/xdf3:identifikation/xdf3:version">&#160;Version&#160;<xsl:value-of select="/*/xdf3:stammdatenschema/xdf3:identifikation/xdf3:version"/>
											</xsl:if>
										</h2>
										<p class="Zusammenfassung" id="AnzahlFehler"/>
										<p id="FehlerListe"/>
										<p class="Zusammenfassung" id="AnzahlWarnungen"/>
										<p id="WarnungsListe"/>
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
							<p>XSLT: <xsl:choose>
									<xsl:when test="empty($StyleSheetURI)">
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
						</xsl:when>
						<xsl:when test="name(/*) ='xdf3:xdatenfelder.datenfeldgruppe.0103'">
							<h1>
								<xsl:choose>
									<xsl:when test="$Meldungen = '1'">
											Qualit�tsbericht Datenfeldgruppe <xsl:value-of select="/*/xdf3:datenfeldgruppe/xdf3:identifikation/xdf3:id"/>
										<xsl:if test="/*/xdf3:datenfeldgruppe/xdf3:identifikation/xdf3:version">&#160;Version&#160;<xsl:value-of select="/*/xdf3:datenfeldgruppe/xdf3:identifikation/xdf3:version"/>
										</xsl:if>
									</xsl:when>
									<xsl:otherwise>
											�bersicht Datenfeldgruppe <xsl:value-of select="/*/xdf3:datenfeldgruppe/xdf3:identifikation/xdf3:id"/>
										<xsl:if test="/*/xdf3:datenfeldgruppe/xdf3:identifikation/xdf3:version">&#160;Version&#160;<xsl:value-of select="/*/xdf3:datenfeldgruppe/xdf3:identifikation/xdf3:version"/>
										</xsl:if>
									</xsl:otherwise>
								</xsl:choose>
							</h1>
							<xsl:if test="$Statistik != '2'">
								<div id="Zusammenfassungsbereich">
									<xsl:if test="$MeldungsFazit = '1' and $Meldungen = '1' and $JavaScript = '1'">
										<h2>
											<a name="Zusammenfassung"/>QS-Zusammenfassung der Datenfeldgruppe <xsl:value-of select="/*/xdf3:datenfeldgruppe/xdf3:identifikation/xdf3:id"/>
											<xsl:if test="/*/xdf3:datenfeldgruppe/xdf3:identifikation/xdf3:version">&#160;Version&#160;<xsl:value-of select="/*/xdf3:datenfeldgruppe/xdf3:identifikation/xdf3:version"/>
											</xsl:if>
										</h2>
										<p class="Zusammenfassung" id="AnzahlFehler"/>
										<p id="FehlerListe"/>
										<p class="Zusammenfassung" id="AnzahlWarnungen"/>
										<p id="WarnungsListe"/>
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
									<xsl:when test="empty($StyleSheetURI)">
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
						</xsl:when>
						<xsl:when test="name(/*) ='xdf3:xdatenfelder.dokumentsteckbrief.0101'">
							<h1>
								<xsl:choose>
									<xsl:when test="$Meldungen = '1'">
											Qualit�tsbericht Dokumentsteckbrief <xsl:value-of select="/*/xdf3:dokumentsteckbrief/xdf3:identifikation/xdf3:id"/>
										<xsl:if test="/*/xdf3:dokumentsteckbrief/xdf3:identifikation/xdf3:version">&#160;Version&#160;<xsl:value-of select="/*/xdf3:dokumentsteckbrief/xdf3:identifikation/xdf3:version"/>
										</xsl:if>
									</xsl:when>
									<xsl:otherwise>
											�bersicht Dokumentsteckbrief <xsl:value-of select="/*/xdf3:dokumentsteckbrief/xdf3:identifikation/xdf3:id"/>
										<xsl:if test="/*/xdf3:dokumentsteckbrief/xdf3:identifikation/xdf3:version">&#160;Version&#160;<xsl:value-of select="/*/xdf3:dokumentsteckbrief/xdf3:identifikation/xdf3:version"/>
										</xsl:if>
									</xsl:otherwise>
								</xsl:choose>
							</h1>
							<div id="Zusammenfassungsbereich">
								<xsl:if test="$MeldungsFazit = '1' and $Meldungen = '1' and $JavaScript = '1'">
									<h2>
										<a name="Zusammenfassung"/>QS-Zusammenfassung des Dokumentsteckbriefs <xsl:value-of select="/*/xdf3:dokumentsteckbrief/xdf3:identifikation/xdf3:id"/>
										<xsl:if test="/*/xdf3:dokumentsteckbrief/xdf3:identifikation/xdf3:version">&#160;Version&#160;<xsl:value-of select="/*/xdf3:dokumentsteckbrief/xdf3:identifikation/xdf3:version"/>
										</xsl:if>
									</h2>
									<p class="Zusammenfassung" id="AnzahlFehler"/>
									<p id="FehlerListe"/>
									<p class="Zusammenfassung" id="AnzahlWarnungen"/>
									<p id="WarnungsListe"/>
								</xsl:if>
							</div>
							<xsl:call-template name="dokumentsteckbriefeinzeln"/>
							<p>Erstellt am: <xsl:value-of select="format-date(fn:current-date(),'[D01].[M01].[Y0001]')"/> um <xsl:value-of select="format-time(fn:current-time(),'[H01]:[m01]')"/> Uhr</p>
							<p>XSLT: <xsl:choose>
									<xsl:when test="empty($StyleSheetURI)">
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
					<a name="Statistik"/>Statistik zum Datenschema <xsl:value-of select="/*/xdf3:stammdatenschema/xdf3:identifikation/xdf3:id"/>
					<xsl:if test="/*/xdf3:stammdatenschema/xdf3:identifikation/xdf3:version">&#160;Version&#160;<xsl:value-of select="/*/xdf3:stammdatenschema/xdf3:identifikation/xdf3:version"/>
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
					<a name="Statistik"/>Statistik zum Datenschema <xsl:value-of select="/*/xdf3:stammdatenschema/xdf3:identifikation/xdf3:id"/>
					<xsl:if test="/*/xdf3:stammdatenschema/xdf3:identifikation/xdf3:version">&#160;Version&#160;<xsl:value-of select="/*/xdf3:stammdatenschema/xdf3:identifikation/xdf3:version"/>
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
			<a name="StatistikKennzahlen"/>�bersicht der Kennzahlen<br/>
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
					<xsl:for-each-group select="//xdf3:datenfeldgruppe" group-by="concat(xdf3:identifikation/xdf3:id,xdf3:identifikation/xdf3:version)">
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
					<xsl:for-each-group select="//xdf3:datenfeldgruppe[xdf3:schemaelementart/code/text() = 'ABS']" group-by="concat(xdf3:identifikation/xdf3:id,xdf3:identifikation/xdf3:version)">
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
					<xsl:for-each-group select="//xdf3:datenfeldgruppe[xdf3:schemaelementart/code/text() = 'HAR']" group-by="concat(xdf3:identifikation/xdf3:id,xdf3:identifikation/xdf3:version)">
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
					<xsl:for-each-group select="//xdf3:datenfeldgruppe[xdf3:schemaelementart/code/text() = 'RNG']" group-by="concat(xdf3:identifikation/xdf3:id,xdf3:identifikation/xdf3:version)">
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
					<xsl:for-each-group select="//xdf3:datenfeld" group-by="concat(xdf3:identifikation/xdf3:id,xdf3:identifikation/xdf3:version)">
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
					<xsl:for-each-group select="//xdf3:datenfeld[xdf3:schemaelementart/code/text() = 'ABS']" group-by="concat(xdf3:identifikation/xdf3:id,xdf3:identifikation/xdf3:version)">
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
					<xsl:for-each-group select="//xdf3:datenfeld[xdf3:schemaelementart/code/text() = 'HAR']" group-by="concat(xdf3:identifikation/xdf3:id,xdf3:identifikation/xdf3:version)">
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
					<xsl:for-each-group select="//xdf3:datenfeld[xdf3:schemaelementart/code/text() = 'RNG']" group-by="concat(xdf3:identifikation/xdf3:id,xdf3:identifikation/xdf3:version)">
						<xsl:if test="fn:position() = 1">
							<xsl:value-of select="fn:last()"/>
						</xsl:if>
					</xsl:for-each-group>
				</xsl:variable>
				<xsl:variable name="AnzahlFelderRechtsnormgebunden">
					<xsl:choose>
						<xsl:when test="empty($AnzahlFelderRechtsnormgebundenString/text())">0</xsl:when>
						<xsl:otherwise>
							<xsl:value-of select="$AnzahlFelderRechtsnormgebundenString"/>
						</xsl:otherwise>
					</xsl:choose>
				</xsl:variable>
				<xsl:variable name="AnzahlRegelnString">
					<xsl:for-each-group select="//xdf3:regel" group-by="xdf3:identifikation/xdf3:id">
						<xsl:if test="fn:position() = 1">
							<xsl:value-of select="fn:last()"/>
						</xsl:if>
					</xsl:for-each-group>
				</xsl:variable>
				<xsl:variable name="AnzahlRegeln">
					<xsl:choose>
						<xsl:when test="empty($AnzahlRegelnString/text())">0</xsl:when>
						<xsl:otherwise>
							<xsl:value-of select="$AnzahlRegelnString"/>
						</xsl:otherwise>
					</xsl:choose>
				</xsl:variable>
				<xsl:variable name="AnzahlCodelistenString">
					<xsl:for-each-group select="//xdf3:codelisteReferenz" group-by="concat(xdf3:canonicalIdentification,xdf3:version)">
						<xsl:sort select="concat(xdf3:canonicalIdentification,xdf3:version)"/>
						<xsl:if test="fn:position() = 1">
							<xsl:value-of select="fn:last()"/>
						</xsl:if>
					</xsl:for-each-group>
				</xsl:variable>
				<xsl:variable name="AnzahlCodelisten">
					<xsl:choose>
						<xsl:when test="empty($AnzahlCodelistenString/text())">0</xsl:when>
						<xsl:otherwise>
							<xsl:value-of select="$AnzahlCodelistenString"/>
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
					<xsl:for-each-group select="//xdf3:datenfeld | //xdf3:datenfeldgruppe" group-by="concat(xdf3:identifikation/xdf3:id,xdf3:identifikation/xdf3:version)">
						<xsl:sort select="count(fn:current-group())" order="descending"/>
						<xsl:sort select="xdf3:identifikation/xdf3:id"/>
						<xsl:sort select="xdf3:identifikation/xdf3:version"/>
						<xsl:if test="$DebugMode = '3' or $DebugMode = '4'">
							<xsl:message>
								-------- <xsl:value-of select="./xdf3:identifikation/xdf3:id"/>
								<xsl:if test="./xdf3:identifikation/xdf3:version">V<xsl:value-of select="./xdf3:identifikation/xdf3:version"/>
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
										<xsl:value-of select="./xdf3:identifikation/xdf3:id"/>
										<xsl:if test="$ToolAufruf = '1'">
											&#160;&#160;
											<xsl:element name="a">
												<xsl:attribute name="href"><xsl:value-of select="$ToolPfadPrefix"/><xsl:value-of select="./xdf3:identifikation/xdf3:id"/><xsl:if test="./xdf3:identifikation/xdf3:version">V<xsl:value-of select="./xdf3:identifikation/xdf3:version"/></xsl:if><xsl:value-of select="$ToolPfadPostfix"/></xsl:attribute>
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
													<xsl:attribute name="href">#<xsl:value-of select="./xdf3:identifikation/xdf3:id"/><xsl:if test="./xdf3:identifikation/xdf3:version">V<xsl:value-of select="./xdf3:identifikation/xdf3:version"/></xsl:if></xsl:attribute>
													<xsl:value-of select="./xdf3:identifikation/xdf3:id"/>
												</xsl:element>
											</xsl:when>
											<xsl:otherwise>
												<xsl:value-of select="./xdf3:identifikation/xdf3:id"/>
											</xsl:otherwise>
										</xsl:choose>
									</xsl:otherwise>
								</xsl:choose>
							</td>
							<td>
								<xsl:value-of select="./xdf3:identifikation/xdf3:version"/>
							</td>
							<td>
								<xsl:value-of select="./xdf3:name"/>
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
					<xsl:for-each-group select="//xdf3:datenfeldgruppe[xdf3:schemaelementart/code='ABS'] | //xdf3:datenfeld[xdf3:schemaelementart/code='ABS']" group-by="xdf3:identifikation/xdf3:id">
						<xsl:sort select="./xdf3:name"/>
						<xsl:sort select="./xdf3:identifikation/xdf3:id"/>
						<xsl:for-each-group select="fn:current-group()" group-by="string(xdf3:identifikation/xdf3:version)">
							<xsl:sort select="./xdf3:identifikation/xdf3:version"/>
							<xsl:if test="$DebugMode = '3' or $DebugMode = '4'">
								<xsl:message>
									-------- <xsl:value-of select="./xdf3:identifikation/xdf3:id"/>
									<xsl:if test="./xdf3:identifikation/xdf3:version">V<xsl:value-of select="./xdf3:identifikation/xdf3:version"/>
									</xsl:if> --------
								</xsl:message>
							</xsl:if>
							<tr>
								<td>
									<xsl:choose>
										<xsl:when test="$Statistik = '2' or empty(./xdf3:identifikation/xdf3:id)">
											<xsl:value-of select="./xdf3:identifikation/xdf3:id"/>
											<xsl:if test="$ToolAufruf = '1'">&#160;&#160;<xsl:element name="a">
													<xsl:attribute name="href"><xsl:value-of select="$ToolPfadPrefix"/><xsl:value-of select="./xdf3:identifikation/xdf3:id"/><xsl:if test="./xdf3:identifikation/xdf3:version">V<xsl:value-of select="./xdf3:identifikation/xdf3:version"/></xsl:if><xsl:value-of select="$ToolPfadPostfix"/></xsl:attribute>
													<xsl:attribute name="target">FIMTool</xsl:attribute>
													<xsl:attribute name="title">Springe in den Datenfeldeditor (man muss vorher angemeldet sein).</xsl:attribute>&#8658;</xsl:element>&#160;&#160;&#160;&#160;</xsl:if>
										</xsl:when>
										<xsl:otherwise>
											<xsl:choose>
												<xsl:when test="$InterneLinks = '1'">
													<xsl:element name="a">
														<xsl:attribute name="href">#<xsl:value-of select="./xdf3:identifikation/xdf3:id"/><xsl:if test="./xdf3:identifikation/xdf3:version">V<xsl:value-of select="./xdf3:identifikation/xdf3:version"/></xsl:if></xsl:attribute>
														<xsl:value-of select="./xdf3:identifikation/xdf3:id"/>
													</xsl:element>
												</xsl:when>
												<xsl:otherwise>
													<xsl:value-of select="./xdf3:identifikation/xdf3:id"/>
												</xsl:otherwise>
											</xsl:choose>
										</xsl:otherwise>
									</xsl:choose>
								</td>
								<td>
									<xsl:value-of select="./xdf3:identifikation/xdf3:version"/>
								</td>
								<td>
									<xsl:value-of select="./xdf3:name"/>
								</td>
								<td>
									<xsl:for-each select="./xdf3:bezug">
										<xsl:choose>
											<xsl:when test="./@link and not(./@link='')">
												<xsl:choose>
													<xsl:when test="$HandlungsgrundlagenLinks = '1'">
														<xsl:element name="a">
															<xsl:attribute name="href"><xsl:value-of select="./@link"/></xsl:attribute>
															<xsl:attribute name="target">Handlungsgrundlage</xsl:attribute>
															<xsl:attribute name="title">Springe zum Text der Handlungsgrundlage.</xsl:attribute>
															<xsl:value-of select="."/>
														</xsl:element>
													</xsl:when>
													<xsl:otherwise>
														<xsl:value-of select="."/>
													</xsl:otherwise>
												</xsl:choose>
											</xsl:when>
											<xsl:otherwise>
												<xsl:value-of select="."/>
											</xsl:otherwise>
										</xsl:choose>
										<xsl:if test="fn:position() != fn:last()">
											<xsl:text>; </xsl:text>
										</xsl:if>
									</xsl:for-each>
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
					<xsl:for-each-group select="//xdf3:datenfeldgruppe[xdf3:schemaelementart/code='HAR'] | //xdf3:datenfeld[xdf3:schemaelementart/code='HAR']" group-by="xdf3:identifikation/xdf3:id">
						<xsl:sort select="./xdf3:name"/>
						<xsl:sort select="./xdf3:identifikation/xdf3:id"/>
						<xsl:for-each-group select="fn:current-group()" group-by="string(xdf3:identifikation/xdf3:version)">
							<xsl:sort select="./xdf3:identifikation/xdf3:version"/>
							<xsl:if test="$DebugMode = '3' or $DebugMode = '4'">
								<xsl:message>
									-------- <xsl:value-of select="./xdf3:identifikation/xdf3:id"/>
									<xsl:if test="./xdf3:identifikation/xdf3:version">V<xsl:value-of select="./xdf3:identifikation/xdf3:version"/>
									</xsl:if> --------
								</xsl:message>
							</xsl:if>
							<tr>
								<td>
									<xsl:choose>
										<xsl:when test="$Statistik = '2' or empty(./xdf3:identifikation/xdf3:id)">
											<xsl:value-of select="./xdf3:identifikation/xdf3:id"/>
											<xsl:if test="$ToolAufruf = '1'">&#160;&#160;<xsl:element name="a">
													<xsl:attribute name="href"><xsl:value-of select="$ToolPfadPrefix"/><xsl:value-of select="./xdf3:identifikation/xdf3:id"/><xsl:if test="./xdf3:identifikation/xdf3:version">V<xsl:value-of select="./xdf3:identifikation/xdf3:version"/></xsl:if><xsl:value-of select="$ToolPfadPostfix"/></xsl:attribute>
													<xsl:attribute name="target">FIMTool</xsl:attribute>
													<xsl:attribute name="title">Springe in den Datenfeldeditor (man muss vorher angemeldet sein).</xsl:attribute>&#8658;</xsl:element>&#160;&#160;&#160;&#160;</xsl:if>
										</xsl:when>
										<xsl:otherwise>
											<xsl:choose>
												<xsl:when test="$InterneLinks = '1'">
													<xsl:element name="a">
														<xsl:attribute name="href">#<xsl:value-of select="./xdf3:identifikation/xdf3:id"/><xsl:if test="./xdf3:identifikation/xdf3:version">V<xsl:value-of select="./xdf3:identifikation/xdf3:version"/></xsl:if></xsl:attribute>
														<xsl:value-of select="./xdf3:identifikation/xdf3:id"/>
													</xsl:element>
												</xsl:when>
												<xsl:otherwise>
													<xsl:value-of select="./xdf3:identifikation/xdf3:id"/>
												</xsl:otherwise>
											</xsl:choose>
										</xsl:otherwise>
									</xsl:choose>
								</td>
								<td>
									<xsl:value-of select="./xdf3:identifikation/xdf3:version"/>
								</td>
								<td>
									<xsl:value-of select="./xdf3:name"/>
								</td>
								<td>
									<xsl:for-each select="./xdf3:bezug">
										<xsl:choose>
											<xsl:when test="./@link and not(./@link='')">
												<xsl:choose>
													<xsl:when test="$HandlungsgrundlagenLinks = '1'">
														<xsl:element name="a">
															<xsl:attribute name="href"><xsl:value-of select="./@link"/></xsl:attribute>
															<xsl:attribute name="target">Handlungsgrundlage</xsl:attribute>
															<xsl:attribute name="title">Springe zum Text der Handlungsgrundlage.</xsl:attribute>
															<xsl:value-of select="."/>
														</xsl:element>
													</xsl:when>
													<xsl:otherwise>
														<xsl:value-of select="."/>
													</xsl:otherwise>
												</xsl:choose>
											</xsl:when>
											<xsl:otherwise>
												<xsl:value-of select="."/>
											</xsl:otherwise>
										</xsl:choose>
										<xsl:if test="fn:position() != fn:last()">
											<xsl:text>; </xsl:text>
										</xsl:if>
									</xsl:for-each>
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
					<xsl:for-each-group select="//xdf3:datenfeldgruppe[xdf3:schemaelementart/code='RNG'] | //xdf3:datenfeld[xdf3:schemaelementart/code='RNG']" group-by="xdf3:identifikation/xdf3:id">
						<xsl:sort select="./xdf3:name"/>
						<xsl:sort select="./xdf3:identifikation/xdf3:id"/>
						<xsl:for-each-group select="fn:current-group()" group-by="string(xdf3:identifikation/xdf3:version)">
							<xsl:sort select="./xdf3:identifikation/xdf3:version"/>
							<xsl:if test="$DebugMode = '3' or $DebugMode = '4'">
								<xsl:message>
									-------- <xsl:value-of select="./xdf3:identifikation/xdf3:id"/>
									<xsl:if test="./xdf3:identifikation/xdf3:version">V<xsl:value-of select="./xdf3:identifikation/xdf3:version"/>
									</xsl:if> --------
								</xsl:message>
							</xsl:if>
							<tr>
								<td>
									<xsl:choose>
										<xsl:when test="$Statistik = '2' or empty(./xdf3:identifikation/xdf3:id)">
											<xsl:value-of select="./xdf3:identifikation/xdf3:id"/>
											<xsl:if test="$ToolAufruf = '1'">&#160;&#160;<xsl:element name="a">
													<xsl:attribute name="href"><xsl:value-of select="$ToolPfadPrefix"/><xsl:value-of select="./xdf3:identifikation/xdf3:id"/><xsl:if test="./xdf3:identifikation/xdf3:version">V<xsl:value-of select="./xdf3:identifikation/xdf3:version"/></xsl:if><xsl:value-of select="$ToolPfadPostfix"/></xsl:attribute>
													<xsl:attribute name="target">FIMTool</xsl:attribute>
													<xsl:attribute name="title">Springe in den Datenfeldeditor (man muss vorher angemeldet sein).</xsl:attribute>&#8658;</xsl:element>&#160;&#160;&#160;&#160;</xsl:if>
										</xsl:when>
										<xsl:otherwise>
											<xsl:choose>
												<xsl:when test="$InterneLinks = '1'">
													<xsl:element name="a">
														<xsl:attribute name="href">#<xsl:value-of select="./xdf3:identifikation/xdf3:id"/><xsl:if test="./xdf3:identifikation/xdf3:version">V<xsl:value-of select="./xdf3:identifikation/xdf3:version"/></xsl:if></xsl:attribute>
														<xsl:value-of select="./xdf3:identifikation/xdf3:id"/>
													</xsl:element>
												</xsl:when>
												<xsl:otherwise>
													<xsl:value-of select="./xdf3:identifikation/xdf3:id"/>
												</xsl:otherwise>
											</xsl:choose>
										</xsl:otherwise>
									</xsl:choose>
								</td>
								<td>
									<xsl:value-of select="./xdf3:identifikation/xdf3:version"/>
								</td>
								<td>
									<xsl:value-of select="./xdf3:name"/>
								</td>
								<td>
									<xsl:for-each select="./xdf3:bezug">
										<xsl:choose>
											<xsl:when test="./@link and not(./@link='')">
												<xsl:choose>
													<xsl:when test="$HandlungsgrundlagenLinks = '1'">
														<xsl:element name="a">
															<xsl:attribute name="href"><xsl:value-of select="./@link"/></xsl:attribute>
															<xsl:attribute name="target">Handlungsgrundlage</xsl:attribute>
															<xsl:attribute name="title">Springe zum Text der Handlungsgrundlage.</xsl:attribute>
															<xsl:value-of select="."/>
														</xsl:element>
													</xsl:when>
													<xsl:otherwise>
														<xsl:value-of select="."/>
													</xsl:otherwise>
												</xsl:choose>
											</xsl:when>
											<xsl:otherwise>
												<xsl:value-of select="."/>
											</xsl:otherwise>
										</xsl:choose>
										<xsl:if test="fn:position() != fn:last()">
											<xsl:text>; </xsl:text>
										</xsl:if>
									</xsl:for-each>
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
						<a name="StatistikZustandsinfos"/>Baukastenelemente ohne Statussetzenden oder Status inaktiv&#160;<a href="#Statistik" title="nach oben">&#8593;</a>
						<br/>
					</h3>
				</xsl:when>
				<xsl:otherwise>
					<h3>
						<a name="StatistikZustandsinfos"/>Baukastenelemente ohne Statussetzenden oder Status inaktiv<br/>
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
					<xsl:for-each-group select="//xdf3:datenfeldgruppe[empty(xdf3:statusGesetztDurch) or xdf3:freigabestatus/code='7'] | //xdf3:datenfeld[empty(xdf3:statusGesetztDurch) or xdf3:freigabestatus/code='7']" group-by="xdf3:identifikation/xdf3:id">
						<xsl:sort select="./xdf3:name"/>
						<xsl:sort select="./xdf3:identifikation/xdf3:id"/>
						<xsl:for-each-group select="fn:current-group()" group-by="string(xdf3:identifikation/xdf3:version)">
							<xsl:sort select="./xdf3:identifikation/xdf3:version"/>
							<xsl:if test="$DebugMode = '3' or $DebugMode = '4'">
								<xsl:message>
									-------- <xsl:value-of select="./xdf3:identifikation/xdf3:id"/>
									<xsl:if test="./xdf3:identifikation/xdf3:version">V<xsl:value-of select="./xdf3:identifikation/xdf3:version"/>
									</xsl:if> --------
								</xsl:message>
							</xsl:if>
							<tr>
								<td>
									<xsl:choose>
										<xsl:when test="$Statistik = '2' or empty(./xdf3:identifikation/xdf3:id)">
											<xsl:value-of select="./xdf3:identifikation/xdf3:id"/>
											<xsl:if test="$ToolAufruf = '1'">
												&#160;&#160;
												<xsl:element name="a">
													<xsl:attribute name="href"><xsl:value-of select="$ToolPfadPrefix"/><xsl:value-of select="./xdf3:identifikation/xdf3:id"/><xsl:if test="./xdf3:identifikation/xdf3:version">V<xsl:value-of select="./xdf3:identifikation/xdf3:version"/></xsl:if><xsl:value-of select="$ToolPfadPostfix"/></xsl:attribute>
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
														<xsl:attribute name="href">#<xsl:value-of select="./xdf3:identifikation/xdf3:id"/><xsl:if test="./xdf3:identifikation/xdf3:version">V<xsl:value-of select="./xdf3:identifikation/xdf3:version"/></xsl:if></xsl:attribute>
														<xsl:value-of select="./xdf3:identifikation/xdf3:id"/>
													</xsl:element>
												</xsl:when>
												<xsl:otherwise>
													<xsl:value-of select="./xdf3:identifikation/xdf3:id"/>
												</xsl:otherwise>
											</xsl:choose>
										</xsl:otherwise>
									</xsl:choose>
								</td>
								<td>
									<xsl:value-of select="./xdf3:identifikation/xdf3:version"/>
								</td>
								<td>
									<xsl:value-of select="./xdf3:name"/>
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
			<a name="SchemaDetails"/>Details zum Datenschema <xsl:value-of select="/*/xdf3:stammdatenschema/xdf3:identifikation/xdf3:id"/>
			<xsl:if test="/*/xdf3:stammdatenschema/xdf3:identifikation/xdf3:version">&#160;Version&#160;<xsl:value-of select="/*/xdf3:stammdatenschema/xdf3:identifikation/xdf3:version"/>
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
					<xsl:with-param name="Element" select="/*/xdf3:stammdatenschema"/>
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
			<a name="SchemaDetails"/>Details zur Datenfeldgruppe <xsl:value-of select="/*/xdf3:datenfeldgruppe/xdf3:identifikation/xdf3:id"/>
			<xsl:if test="/*/xdf3:datenfeldgruppe/xdf3:identifikation/xdf3:version">&#160;Version&#160;<xsl:value-of select="/*/xdf3:datenfeldgruppe/xdf3:identifikation/xdf3:version"/>
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
					<xsl:with-param name="Element" select="/*/xdf3:datenfeldgruppe"/>
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
			<a name="SchemaDetails"/>Details zum Dokumentsteckbrief <xsl:value-of select="/*/xdf3:dokumentsteckbrief/xdf3:identifikation/xdf3:id"/>
			<xsl:if test="/*/xdf3:dokumentsteckbrief/xdf3:identifikation/xdf3:version">&#160;Version&#160;<xsl:value-of select="/*/xdf3:dokumentsteckbrief/xdf3:identifikation/xdf3:version"/>
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
					<xsl:with-param name="Element" select="/*/xdf3:dokumentsteckbrief"/>
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
				-------- <xsl:value-of select="$Element/xdf3:identifikation/xdf3:id"/>
				<xsl:if test="$Element/xdf3:identifikation/xdf3:version">V<xsl:value-of select="$Element/xdf3:identifikation/xdf3:version"/>
				</xsl:if> --------
			</xsl:message>
		</xsl:if>
		<tr>
			<td>
				<xsl:element name="a">
					<xsl:attribute name="name"><xsl:value-of select="$Element/xdf3:identifikation/xdf3:id"/><xsl:if test="$Element/xdf3:identifikation/xdf3:version">V<xsl:value-of select="$Element/xdf3:identifikation/xdf3:version"/></xsl:if></xsl:attribute>
				</xsl:element>
												ID
											</td>
			<td>
				<xsl:value-of select="$Element/xdf3:identifikation/xdf3:id"/>
				<xsl:analyze-string regex="^S\d{{11}}$" select="$Element/xdf3:identifikation/xdf3:id">
					<xsl:matching-substring>
						<xsl:if test="$ToolAufruf = '1'">
														&#160;&#160;
														<xsl:element name="a">
								<xsl:attribute name="href"><xsl:value-of select="$ToolPfadPrefix"/><xsl:value-of select="$Element/xdf3:identifikation/xdf3:id"/><xsl:if test="$Element/xdf3:identifikation/xdf3:version">V<xsl:value-of select="$Element/xdf3:identifikation/xdf3:version"/></xsl:if><xsl:value-of select="$ToolPfadPostfix"/></xsl:attribute>
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
				<xsl:value-of select="$Element/xdf3:identifikation/xdf3:version"/>
			</td>
		</tr>
		<tr>
			<td>Versionshinweis</td>
			<td>
				<xsl:value-of select="fn:replace($Element/xdf3:versionshinweis,'\n','&lt;br/&gt;')" disable-output-escaping="yes"/>
			</td>
		</tr>
		<tr>
			<td>Name</td>
			<xsl:choose>
				<xsl:when test="empty($Element/xdf3:name/text())">
					<td class="SDSName">
						<xsl:if test="$Meldungen = '1'">
							<div class="Fehler E1002">Fehler!! E1002: Der Name eines Elements ist nicht gesetzt.</div>
						</xsl:if>
					</td>
				</xsl:when>
				<xsl:otherwise>
					<td class="ElementName">
						<xsl:value-of select="$Element/xdf3:name"/>
					</td>
				</xsl:otherwise>
			</xsl:choose>
		</tr>
		<tr>
			<td>Stichworte</td>
			<td>
				<ul>
					<xsl:for-each select="$Element/xdf3:stichwort">
						<li>
							<xsl:value-of select="."/>
							<xsl:if test="./@uri">
																(<xsl:value-of select="./@uri"/>)
																<xsl:if test="$XRepoAufruf = '1' and substring(./@uri,1,4) = 'urn:'">
									<xsl:choose>
										<xsl:when test="fn:contains(./@uri, '_')">
																			&#160;&#160;
																			<xsl:element name="a">
												<xsl:attribute name="href"><xsl:value-of select="$DocXRepoMitVersionPfadPrefix"/><xsl:value-of select="./@uri"/><xsl:value-of select="$DocXRepoMitVersionPfadPostfix"/></xsl:attribute>
												<xsl:attribute name="target">XRepo</xsl:attribute>
												<xsl:attribute name="title">Springe in das XRepository.</xsl:attribute>
																				&#8658;
																			</xsl:element>
										</xsl:when>
										<xsl:otherwise>
																			&#160;&#160;
																			<xsl:element name="a">
												<xsl:attribute name="href"><xsl:value-of select="$DocXRepoOhneVersionPfadPrefix"/><xsl:value-of select="./@uri"/><xsl:value-of select="$DocXRepoOhneVersionPfadPostfix"/></xsl:attribute>
												<xsl:attribute name="target">XRepo</xsl:attribute>
												<xsl:attribute name="title">Springe in das XRepository.</xsl:attribute>
																				&#8658;
																			</xsl:element>
										</xsl:otherwise>
									</xsl:choose>
																	&#160;
																</xsl:if>
							</xsl:if>
						</li>
					</xsl:for-each>
				</ul>
			</td>
		</tr>
		<tr>
			<td>Bezeichnung</td>
			<xsl:choose>
				<xsl:when test="empty($Element/xdf3:bezeichnung/text())">
					<td>
						<xsl:if test="$Meldungen = '1'">
							<div class="Fehler E1050">Fehler!! E1050: Die Bezeichnung muss bef�llt sein.</div>
						</xsl:if>
					</td>
				</xsl:when>
				<xsl:otherwise>
					<td>
						<xsl:value-of select="$Element/xdf3:bezeichnung"/>
					</td>
				</xsl:otherwise>
			</xsl:choose>
		</tr>
		<tr>
			<td>Hilfetext</td>
			<td>
				<xsl:value-of select="fn:replace($Element/xdf3:hilfetext,'\n','&lt;br/&gt;')" disable-output-escaping="yes"/>
			</td>
		</tr>
		<tr>
			<td>Handlungsgrundlagen</td>
			<td>
				<xsl:choose>
					<xsl:when test="fn:count($Element/xdf3:bezug) = 0">
						<xsl:if test="$Meldungen = '1'">
							<div class="Fehler E1051">Fehler!! E1051: Der Bezug zur Handlungsgrundlage darf nicht leer sein.</div>
						</xsl:if>
					</xsl:when>
					<xsl:when test="fn:count($Element/xdf3:bezug) = 1">
						<xsl:choose>
							<xsl:when test="$Element/xdf3:bezug/@link and not($Element/xdf3:bezug/@link='')">
								<xsl:choose>
									<xsl:when test="$HandlungsgrundlagenLinks = '1'">
										<xsl:element name="a">
											<xsl:attribute name="href"><xsl:value-of select="$Element/xdf3:bezug/@link"/></xsl:attribute>
											<xsl:attribute name="target">Handlungsgrundlage</xsl:attribute>
											<xsl:attribute name="title">Springe zum Text der Handlungsgrundlage.</xsl:attribute>
											<xsl:value-of select="$Element/xdf3:bezug"/>
										</xsl:element>
									</xsl:when>
									<xsl:otherwise>
										<xsl:value-of select="$Element/xdf3:bezug"/>
									</xsl:otherwise>
								</xsl:choose>
							</xsl:when>
							<xsl:otherwise>
								<xsl:value-of select="$Element/xdf3:bezug"/>
							</xsl:otherwise>
						</xsl:choose>
					</xsl:when>
					<xsl:otherwise>
						<ul>
							<xsl:for-each select="$Element/xdf3:bezug">
								<li>
									<xsl:choose>
										<xsl:when test="./@link and not(./@link='')">
											<xsl:choose>
												<xsl:when test="$HandlungsgrundlagenLinks = '1'">
													<xsl:element name="a">
														<xsl:attribute name="href"><xsl:value-of select="./@link"/></xsl:attribute>
														<xsl:attribute name="target">Handlungsgrundlage</xsl:attribute>
														<xsl:attribute name="title">Springe zum Text der Handlungsgrundlage.</xsl:attribute>
														<xsl:value-of select="."/>
													</xsl:element>
												</xsl:when>
												<xsl:otherwise>
													<xsl:value-of select="."/>
												</xsl:otherwise>
											</xsl:choose>
										</xsl:when>
										<xsl:otherwise>
											<xsl:value-of select="."/>
										</xsl:otherwise>
									</xsl:choose>
								</li>
							</xsl:for-each>
						</ul>
					</xsl:otherwise>
				</xsl:choose>
			</td>
		</tr>
		<tr>
			<td>Beschreibung</td>
			<td>
				<xsl:value-of select="fn:replace($Element/xdf3:beschreibung,'\n','&lt;br/&gt;')" disable-output-escaping="yes"/>
			</td>
		</tr>
		<tr>
			<td>Definition</td>
			<td>
				<xsl:value-of select="fn:replace($Element/xdf3:definition,'\n','&lt;br/&gt;')" disable-output-escaping="yes"/>
			</td>
		</tr>
		<tr>
			<td>�nderbarkeit Struktur</td>
			<td>
				<xsl:apply-templates select="$Element/xdf3:ableitungsmodifikationenStruktur"/>
			</td>
		</tr>
		<tr>
			<td>�nderbarkeit Repr�sentation</td>
			<td>
				<xsl:apply-templates select="$Element/xdf3:ableitungsmodifikationenRepraesentation"/>
			</td>
		</tr>
		<tr>
			<td>G�ltig ab</td>
			<td>
				<xsl:value-of select="$Element/xdf3:gueltigAb"/>
			</td>
		</tr>
		<tr>
			<td>G�ltig bis</td>
			<td>
				<xsl:value-of select="$Element/xdf3:gueltigBis"/>
			</td>
		</tr>
		<tr>
			<td>Fachlicher Ersteller</td>
			<xsl:choose>
				<xsl:when test="empty($Element/xdf3:statusGesetztDurch/text()) and $VersionsHinweise ='1'">
					<td>
						<xsl:value-of select="$Element/xdf3:statusGesetztDurch"/>
						<xsl:if test="$Meldungen = '1'">
							<div class="Hinweis">Hinweis!! Das Feld 'Fachlicher Ersteller' darf zur Versionierung oder Ver�ffentlichung nicht leer sein.</div>
						</xsl:if>
					</td>
				</xsl:when>
				<xsl:otherwise>
					<td>
						<xsl:value-of select="$Element/xdf3:statusGesetztDurch"/>
					</td>
				</xsl:otherwise>
			</xsl:choose>
		</tr>
		<tr>
			<td>Status</td>
			<td>
				<xsl:apply-templates select="$Element/xdf3:freigabestatus"/>
			</td>
		</tr>
		<tr>
			<td>Status gesetzt am</td>
			<td>
				<xsl:value-of select="$Element/xdf3:statusGesetztAm"/>
			</td>
		</tr>
		<tr>
			<td>Ver�ffentlichungsdatum</td>
			<td>
				<xsl:value-of select="$Element/xdf3:veroeffentlichungsdatum"/>
			</td>
		</tr>
		<tr>
			<td>Letzte �nderung</td>
			<td>
				<xsl:value-of select="fn:format-dateTime($Element/xdf3:letzteAenderung,'[D01].[M01].[Y0001] um [H01]:[m01] Uhr')"/>
			</td>
		</tr>
		<tr>
			<td colspan="2">
				<h2/>
			</td>
		</tr>
		<tr>
			<td>
				<b>Dokumentsteckbrief</b>
			</td>
			<td>
				<xsl:choose>
					<xsl:when test="not(fn:empty($Element/xdf3:dokumentsteckbrief/xdf3:id/text()))">
						<xsl:value-of select="$Element/xdf3:dokumentsteckbrief/xdf3:id"/>
						<xsl:analyze-string regex="^D\d{{11}}$" select="$Element/xdf3:dokumentsteckbrief/xdf3:id">
							<xsl:matching-substring>
								<xsl:if test="$ToolAufruf = '1'">
																&#160;&#160;
																<xsl:element name="a">
										<xsl:attribute name="href"><xsl:value-of select="$ToolPfadPrefix"/><xsl:value-of select="$Element/xdf3:dokumentsteckbrief/xdf3:id"/><xsl:value-of select="$ToolPfadPostfix"/></xsl:attribute>
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
					</xsl:when>
					<xsl:otherwise>
						<xsl:if test="$Meldungen = '1'">
							<div class="Fehler E1007">Fehler!! E1007: Es ist kein Dokumentsteckbrief zugeordnet.</div>
						</xsl:if>
					</xsl:otherwise>
				</xsl:choose>
			</td>
		</tr>
		<tr>
			<td colspan="2">
				<h2/>
			</td>
		</tr>
		<xsl:if test="count($Element/xdf3:relation)">
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
							<xsl:for-each select="$Element/xdf3:relation">
								<tr>
									<td>
										<xsl:variable name="objID" select="./xdf3:objekt/xdf3:id"/>
										<xsl:variable name="objVersion" select="./xdf3:objekt/xdf3:version"/>
										<xsl:value-of select="./xdf3:objekt/xdf3:id"/>
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
												<xsl:if test="$Meldungen = '1' and fn:substring($objID,1,1) != 'S'">
													<div class="Fehler E1087">Fehler!! E1087: Relation zu einem unzul�ssigen Objekt.</div>
												</xsl:if>
											</xsl:matching-substring>
											<xsl:non-matching-substring>
												<xsl:if test="$Meldungen = '1'">
													<div class="Fehler E1039">Fehler!! E1039: Die ID entspricht nicht den Formatvorgaben.</div>
												</xsl:if>
											</xsl:non-matching-substring>
										</xsl:analyze-string>
									</td>
									<td>
										<xsl:value-of select="./xdf3:objekt/xdf3:version"/>
									</td>
									<td>
										<xsl:apply-templates select="./xdf3:praedikat"/>
										<xsl:if test="$Meldungen = '1' and ./xdf3:praedikat = 'VKN'">
											<div class="Fehler E1088">Fehler!! E1088: Diese Relation darf in diesem Objekt nicht verwendet werden.</div>
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
									</xsl:if>
-->
		<xsl:if test="count($Element/xdf3:struktur) + count($Element/xdf3:regel)">
			<tr>
				<td>
					<b>Unterelemente</b>
					<xsl:if test="$Element/xdf3:art/code = 'X'">
						<br/>
						<b>Auswahlgruppe</b>
					</xsl:if>
					<xsl:if test="$Meldungen = '1' and (count($Element/xdf3:struktur) &lt; 1)">
						<div class="Fehler E1078">Fehler!! E1078: Ein Datenschema muss mindestens ein Unterlement enthalten.</div>
					</xsl:if>
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
								<th>Multiplizit�t</th>
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
				</td>
			</tr>
		</xsl:if>
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
				-------- <xsl:value-of select="$Element/xdf3:identifikation/xdf3:id"/>
				<xsl:if test="$Element/xdf3:identifikation/xdf3:version">V<xsl:value-of select="$Element/xdf3:identifikation/xdf3:version"/>
				</xsl:if> --------
			</xsl:message>
		</xsl:if>
		<tr>
			<td>
				<xsl:element name="a">
					<xsl:attribute name="name"><xsl:value-of select="$Element/xdf3:identifikation/xdf3:id"/><xsl:if test="$Element/xdf3:identifikation/xdf3:version">V<xsl:value-of select="$Element/xdf3:identifikation/xdf3:version"/></xsl:if></xsl:attribute>
				</xsl:element>
											ID
										</td>
			<xsl:choose>
				<xsl:when test="empty($Element/xdf3:identifikation/xdf3:id/text())">
					<td class="ElementID">
						<xsl:if test="$Meldungen = '1'">
							<div class="Fehler E1038">Fehler!! E1038: Die ID muss bef�llt werden.</div>
						</xsl:if>
					</td>
				</xsl:when>
				<xsl:otherwise>
					<td class="ElementID">
						<xsl:value-of select="$Element/xdf3:identifikation/xdf3:id"/>
						<xsl:analyze-string regex="^G\d{{11}}$" select="$Element/xdf3:identifikation/xdf3:id">
							<xsl:matching-substring>
								<xsl:if test="$ToolAufruf = '1'">
																&#160;&#160;
																<xsl:element name="a">
										<xsl:attribute name="href"><xsl:value-of select="$ToolPfadPrefix"/><xsl:value-of select="$Element/xdf3:identifikation/xdf3:id"/><xsl:if test="$Element/xdf3:identifikation/xdf3:version">V<xsl:value-of select="$Element/xdf3:identifikation/xdf3:version"/></xsl:if><xsl:value-of select="$ToolPfadPostfix"/></xsl:attribute>
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
				<xsl:value-of select="$Element/xdf3:identifikation/xdf3:version"/>
			</td>
		</tr>
		<tr>
			<td>Versionshinweis</td>
			<td>
				<xsl:value-of select="fn:replace($Element/xdf3:versionshinweis,'\n','&lt;br/&gt;')" disable-output-escaping="yes"/>
			</td>
		</tr>
		<tr>
			<td>Name</td>
			<xsl:choose>
				<xsl:when test="empty($Element/xdf3:name/text())">
					<td class="ElementName">
						<xsl:if test="$Meldungen = '1'">
							<div class="Fehler E1002">Fehler!! E1002: Der Name eines Elements ist nicht gesetzt.</div>
						</xsl:if>
					</td>
				</xsl:when>
				<xsl:otherwise>
					<td class="ElementName">
						<xsl:value-of select="$Element/xdf3:name"/>
					</td>
				</xsl:otherwise>
			</xsl:choose>
		</tr>
		<tr>
			<td>Stichworte</td>
			<td>
				<ul>
					<xsl:for-each select="$Element/xdf3:stichwort">
						<li>
							<xsl:value-of select="."/>
							<xsl:if test="./@uri">
															(<xsl:value-of select="./@uri"/>)
															<xsl:if test="$XRepoAufruf = '1' and substring(./@uri,1,4) = 'urn:'">
									<xsl:choose>
										<xsl:when test="fn:contains(./@uri, '_')">
																		&#160;&#160;
																		<xsl:element name="a">
												<xsl:attribute name="href"><xsl:value-of select="$DocXRepoMitVersionPfadPrefix"/><xsl:value-of select="./@uri"/><xsl:value-of select="$DocXRepoMitVersionPfadPostfix"/></xsl:attribute>
												<xsl:attribute name="target">XRepo</xsl:attribute>
												<xsl:attribute name="title">Springe in das XRepository.</xsl:attribute>
																			&#8658;
																		</xsl:element>
										</xsl:when>
										<xsl:otherwise>
																		&#160;&#160;
																		<xsl:element name="a">
												<xsl:attribute name="href"><xsl:value-of select="$DocXRepoOhneVersionPfadPrefix"/><xsl:value-of select="./@uri"/><xsl:value-of select="$DocXRepoOhneVersionPfadPostfix"/></xsl:attribute>
												<xsl:attribute name="target">XRepo</xsl:attribute>
												<xsl:attribute name="title">Springe in das XRepository.</xsl:attribute>
																			&#8658;
																		</xsl:element>
										</xsl:otherwise>
									</xsl:choose>
																&#160;
															</xsl:if>
							</xsl:if>
						</li>
					</xsl:for-each>
				</ul>
			</td>
		</tr>
		<tr>
			<td>Definition</td>
			<td>
				<xsl:value-of select="fn:replace($Element/xdf3:definition,'\n','&lt;br/&gt;')" disable-output-escaping="yes"/>
			</td>
		</tr>
		<tr>
			<td>Strukturelementart</td>
			<td>
				<xsl:apply-templates select="$Element/xdf3:schemaelementart"/>
			</td>
		</tr>
		<tr>
			<td>Gruppenart</td>
			<td>
				<xsl:apply-templates select="$Element/xdf3:art"/>
			</td>
		</tr>
		<tr>
			<td>Handlungsgrundlagen</td>
			<td>
				<xsl:choose>
					<xsl:when test="fn:count($Element/xdf3:bezug) = 0">
						<xsl:choose>
							<xsl:when test="$Element/xdf3:schemaelementart/code/text() = 'RNG'">
								<xsl:if test="$Meldungen = '1'">
									<div class="Fehler E1006">Fehler!! E1006: Der Bezug zur Handlungsgrundlage darf bei Elementen mit der Strukturelementart 'rechtsnormgebunden' nicht leer sein.</div>
								</xsl:if>
							</xsl:when>
							<xsl:when test="$Element/xdf3:schemaelementart/code/text() = 'HAR'">
								<xsl:if test="$Meldungen = '1'">
									<div class="Warnung W1001">Warnung!! W1001: Der Bezug zur Handlungsgrundlage sollte bei Elementen mit der Strukturelementart 'harmonisiert' m�glichst nicht leer sein.</div>
								</xsl:if>
							</xsl:when>
							<xsl:otherwise>
														</xsl:otherwise>
						</xsl:choose>
					</xsl:when>
					<xsl:when test="fn:count($Element/xdf3:bezug) = 1">
						<xsl:choose>
							<xsl:when test="$Element/xdf3:bezug/@link and not($Element/xdf3:bezug/@link='')">
								<xsl:choose>
									<xsl:when test="$HandlungsgrundlagenLinks = '1'">
										<xsl:element name="a">
											<xsl:attribute name="href"><xsl:value-of select="$Element/xdf3:bezug/@link"/></xsl:attribute>
											<xsl:attribute name="target">Handlungsgrundlage</xsl:attribute>
											<xsl:attribute name="title">Springe zum Text der Handlungsgrundlage.</xsl:attribute>
											<xsl:value-of select="$Element/xdf3:bezug"/>
										</xsl:element>
									</xsl:when>
									<xsl:otherwise>
										<xsl:value-of select="$Element/xdf3:bezug"/>
									</xsl:otherwise>
								</xsl:choose>
							</xsl:when>
							<xsl:otherwise>
								<xsl:value-of select="$Element/xdf3:bezug"/>
							</xsl:otherwise>
						</xsl:choose>
					</xsl:when>
					<xsl:otherwise>
						<ul>
							<xsl:for-each select="$Element/xdf3:bezug">
								<li>
									<xsl:choose>
										<xsl:when test="./@link and not(./@link='')">
											<xsl:choose>
												<xsl:when test="$HandlungsgrundlagenLinks = '1'">
													<xsl:element name="a">
														<xsl:attribute name="href"><xsl:value-of select="./@link"/></xsl:attribute>
														<xsl:attribute name="target">Handlungsgrundlage</xsl:attribute>
														<xsl:attribute name="title">Springe zum Text der Handlungsgrundlage.</xsl:attribute>
														<xsl:value-of select="."/>
													</xsl:element>
												</xsl:when>
												<xsl:otherwise>
													<xsl:value-of select="."/>
												</xsl:otherwise>
											</xsl:choose>
										</xsl:when>
										<xsl:otherwise>
											<xsl:value-of select="."/>
										</xsl:otherwise>
									</xsl:choose>
								</li>
							</xsl:for-each>
						</ul>
					</xsl:otherwise>
				</xsl:choose>
			</td>
		</tr>
		<tr>
			<td>Beschreibung</td>
			<td>
				<xsl:value-of select="fn:replace($Element/xdf3:beschreibung,'\n','&lt;br/&gt;')" disable-output-escaping="yes"/>
			</td>
		</tr>
		<tr>
			<td>Bezeichnung Eingabe</td>
			<xsl:choose>
				<xsl:when test="empty($Element/xdf3:bezeichnungEingabe/text())">
					<td>
						<xsl:if test="$Meldungen = '1'">
							<div class="Fehler E1009">Fehler!! E1009: Die Bezeichnung Eingabe muss bef�llt werden.</div>
						</xsl:if>
					</td>
				</xsl:when>
				<xsl:otherwise>
					<td>
						<xsl:value-of select="$Element/xdf3:bezeichnungEingabe"/>
					</td>
				</xsl:otherwise>
			</xsl:choose>
		</tr>
		<tr>
			<td>Bezeichnung Ausgabe</td>
			<xsl:choose>
				<xsl:when test="empty($Element/xdf3:bezeichnungAusgabe/text())">
					<td>
						<xsl:if test="$Meldungen = '1'">
							<div class="Fehler E1010">Fehler!! E1010: Die Bezeichnung Ausgabe muss bef�llt werden.</div>
						</xsl:if>
					</td>
				</xsl:when>
				<xsl:otherwise>
					<td>
						<xsl:value-of select="$Element/xdf3:bezeichnungAusgabe"/>
					</td>
				</xsl:otherwise>
			</xsl:choose>
		</tr>
		<tr>
			<td>Hilfetext Eingabe</td>
			<td>
				<xsl:value-of select="fn:replace($Element/xdf3:hilfetextEingabe,'\n','&lt;br/&gt;')" disable-output-escaping="yes"/>
			</td>
		</tr>
		<tr>
			<td>Hilfetext Ausgabe</td>
			<td>
				<xsl:value-of select="fn:replace($Element/xdf3:hilfetextAusgabe,'\n','&lt;br/&gt;')" disable-output-escaping="yes"/>
			</td>
		</tr>
		<tr>
			<td>G�ltig ab</td>
			<td>
				<xsl:value-of select="$Element/xdf3:gueltigAb"/>
			</td>
		</tr>
		<tr>
			<td>G�ltig bis</td>
			<td>
				<xsl:value-of select="$Element/xdf3:gueltigBis"/>
			</td>
		</tr>
		<tr>
			<td>Fachlicher Ersteller</td>
			<xsl:choose>
				<xsl:when test="empty($Element/xdf3:statusGesetztDurch/text()) and $VersionsHinweise ='1'">
					<td>
						<xsl:value-of select="$Element/xdf3:statusGesetztDurch"/>
						<xsl:if test="$Meldungen = '1'">
							<div class="Hinweis">Hinweis!! Das Feld 'Fachlicher Ersteller' darf zur Versionierung oder Ver�ffentlichung nicht leer sein.</div>
						</xsl:if>
					</td>
				</xsl:when>
				<xsl:otherwise>
					<td>
						<xsl:value-of select="$Element/xdf3:statusGesetztDurch"/>
					</td>
				</xsl:otherwise>
			</xsl:choose>
		</tr>
		<tr>
			<td>Status</td>
			<td>
				<xsl:apply-templates select="$Element/xdf3:freigabestatus"/>
			</td>
		</tr>
		<tr>
			<td>Status gesetzt am</td>
			<td>
				<xsl:value-of select="$Element/xdf3:statusGesetztAm"/>
			</td>
		</tr>
		<tr>
			<td>Ver�ffentlichungsdatum</td>
			<td>
				<xsl:value-of select="$Element/xdf3:veroeffentlichungsdatum"/>
			</td>
		</tr>
		<tr>
			<td>Letzte �nderung</td>
			<td>
				<xsl:value-of select="fn:format-dateTime($Element/xdf3:letzteAenderung,'[D01].[M01].[Y0001] um [H01]:[m01] Uhr')"/>
			</td>
		</tr>
		<tr>
			<td colspan="2">
				<h2/>
			</td>
		</tr>
		<xsl:if test="count($Element/xdf3:relation)">
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
							<xsl:for-each select="$Element/xdf3:relation">
								<tr>
									<td>
										<xsl:variable name="objID" select="./xdf3:objekt/xdf3:id"/>
										<xsl:variable name="objVersion" select="./xdf3:objekt/xdf3:version"/>
										<xsl:value-of select="./xdf3:objekt/xdf3:id"/>
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
													<div class="Fehler E1087">Fehler!! E1087: Relation zu einem unzul�ssigen Objekt.</div>
												</xsl:if>
											</xsl:matching-substring>
											<xsl:non-matching-substring>
												<xsl:if test="$Meldungen = '1'">
													<div class="Fehler E1039">Fehler!! E1039: Die ID entspricht nicht den Formatvorgaben.</div>
												</xsl:if>
											</xsl:non-matching-substring>
										</xsl:analyze-string>
									</td>
									<td>
										<xsl:value-of select="./xdf3:objekt/xdf3:version"/>
									</td>
									<td>
										<xsl:apply-templates select="./xdf3:praedikat"/>
										<xsl:if test="$Meldungen = '1' and ./xdf3:praedikat = 'VKN'">
											<div class="Fehler E1088">Fehler!! E1088: Diese Relation darf in diesem Objekt nicht verwendet werden.</div>
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
		<xsl:if test="count($Element/xdf3:struktur) + count($Element/xdf3:regel)">
			<tr>
				<td>
					<b>Unterelemente</b>
					<xsl:if test="$Element/xdf3:art/code = 'X'">
						<br/>
						<b>Auswahlgruppe</b>
					</xsl:if>
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
								<th>Multiplizit�t</th>
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
				</td>
			</tr>
		</xsl:if>
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
				-------- <xsl:value-of select="$Element/xdf3:identifikation/xdf3:id"/>
				<xsl:if test="$Element/xdf3:identifikation/xdf3:version">V<xsl:value-of select="$Element/xdf3:identifikation/xdf3:version"/>
				</xsl:if> --------
			</xsl:message>
		</xsl:if>
		<tr>
			<td>
				<xsl:element name="a">
					<xsl:attribute name="name"><xsl:value-of select="$Element/xdf3:identifikation/xdf3:id"/><xsl:if test="$Element/xdf3:identifikation/xdf3:version">V<xsl:value-of select="$Element/xdf3:identifikation/xdf3:version"/></xsl:if></xsl:attribute>
				</xsl:element>
											ID
										</td>
			<xsl:choose>
				<xsl:when test="empty($Element/xdf3:identifikation/xdf3:id/text())">
					<td class="ElementID">
						<xsl:if test="$Meldungen = '1'">
							<div class="Fehler E1038">Fehler!! E1038: Die ID muss bef�llt werden.</div>
						</xsl:if>
					</td>
				</xsl:when>
				<xsl:otherwise>
					<td class="ElementID">
						<xsl:value-of select="$Element/xdf3:identifikation/xdf3:id"/>
						<xsl:analyze-string regex="^D\d{{11}}$" select="$Element/xdf3:identifikation/xdf3:id">
							<xsl:matching-substring>
								<xsl:if test="$ToolAufruf = '1'">
																&#160;&#160;
																<xsl:element name="a">
										<xsl:attribute name="href"><xsl:value-of select="$ToolPfadPrefix"/><xsl:value-of select="$Element/xdf3:identifikation/xdf3:id"/><xsl:if test="$Element/xdf3:identifikation/xdf3:version">V<xsl:value-of select="$Element/xdf3:identifikation/xdf3:version"/></xsl:if><xsl:value-of select="$ToolPfadPostfix"/></xsl:attribute>
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
				<xsl:value-of select="$Element/xdf3:identifikation/xdf3:version"/>
			</td>
		</tr>
		<tr>
			<td>Versionshinweis</td>
			<td>
				<xsl:value-of select="fn:replace($Element/xdf3:versionshinweis,'\n','&lt;br/&gt;')" disable-output-escaping="yes"/>
			</td>
		</tr>
		<tr>
			<td>Name</td>
			<xsl:choose>
				<xsl:when test="empty($Element/xdf3:name/text())">
					<td class="ElementName">
						<xsl:if test="$Meldungen = '1'">
							<div class="Fehler E1002">Fehler!! E1002: Der Name eines Elements ist nicht gesetzt.</div>
						</xsl:if>
					</td>
				</xsl:when>
				<xsl:otherwise>
					<td class="ElementName">
						<xsl:value-of select="$Element/xdf3:name"/>
					</td>
				</xsl:otherwise>
			</xsl:choose>
		</tr>
		<tr>
			<td>Stichworte</td>
			<td>
				<ul>
					<xsl:for-each select="$Element/xdf3:stichwort">
						<li>
							<xsl:value-of select="."/>
							<xsl:if test="./@uri">
															(<xsl:value-of select="./@uri"/>)
															<xsl:if test="$XRepoAufruf = '1' and substring(./@uri,1,4) = 'urn:'">
									<xsl:choose>
										<xsl:when test="fn:contains(./@uri, '_')">
																		&#160;&#160;
																		<xsl:element name="a">
												<xsl:attribute name="href"><xsl:value-of select="$DocXRepoMitVersionPfadPrefix"/><xsl:value-of select="./@uri"/><xsl:value-of select="$DocXRepoMitVersionPfadPostfix"/></xsl:attribute>
												<xsl:attribute name="target">XRepo</xsl:attribute>
												<xsl:attribute name="title">Springe in das XRepository.</xsl:attribute>
																			&#8658;
																		</xsl:element>
										</xsl:when>
										<xsl:otherwise>
																		&#160;&#160;
																		<xsl:element name="a">
												<xsl:attribute name="href"><xsl:value-of select="$DocXRepoOhneVersionPfadPrefix"/><xsl:value-of select="./@uri"/><xsl:value-of select="$DocXRepoOhneVersionPfadPostfix"/></xsl:attribute>
												<xsl:attribute name="target">XRepo</xsl:attribute>
												<xsl:attribute name="title">Springe in das XRepository.</xsl:attribute>
																			&#8658;
																		</xsl:element>
										</xsl:otherwise>
									</xsl:choose>
																&#160;
															</xsl:if>
							</xsl:if>
						</li>
					</xsl:for-each>
				</ul>
			</td>
		</tr>
		<tr>
			<td>Definition</td>
			<xsl:choose>
				<xsl:when test="empty($Element/xdf3:definition/text())">
					<td>
						<xsl:if test="$Meldungen = '1'">
							<div class="Fehler E1049">Fehler!! E1049: Die Definition eines Dokumentsteckbriefs muss bef�llt sein.</div>
						</xsl:if>
					</td>
				</xsl:when>
				<xsl:otherwise>
					<td>
						<xsl:value-of select="fn:replace($Element/xdf3:definition,'\n','&lt;br/&gt;')" disable-output-escaping="yes"/>
					</td>
				</xsl:otherwise>
			</xsl:choose>
		</tr>
		<tr>
			<td>Handlungsgrundlagen</td>
			<td>
				<xsl:choose>
					<xsl:when test="fn:count($Element/xdf3:bezug) = 0">
						<xsl:if test="$Meldungen = '1' and $Element/xdf3:istAbstrakt = 'true'">
							<div class="Fehler E1052">Fehler!! E1052: Der Bezug zur Handlungsgrundlage darf nur bei abstrakten Dokumentsteckbriefen leer sein.</div>
						</xsl:if>
					</xsl:when>
					<xsl:when test="fn:count($Element/xdf3:bezug) = 1">
						<xsl:choose>
							<xsl:when test="$Element/xdf3:bezug/@link and not($Element/xdf3:bezug/@link='')">
								<xsl:choose>
									<xsl:when test="$HandlungsgrundlagenLinks = '1'">
										<xsl:element name="a">
											<xsl:attribute name="href"><xsl:value-of select="$Element/xdf3:bezug/@link"/></xsl:attribute>
											<xsl:attribute name="target">Handlungsgrundlage</xsl:attribute>
											<xsl:attribute name="title">Springe zum Text der Handlungsgrundlage.</xsl:attribute>
											<xsl:value-of select="$Element/xdf3:bezug"/>
										</xsl:element>
									</xsl:when>
									<xsl:otherwise>
										<xsl:value-of select="$Element/xdf3:bezug"/>
									</xsl:otherwise>
								</xsl:choose>
							</xsl:when>
							<xsl:otherwise>
								<xsl:value-of select="$Element/xdf3:bezug"/>
							</xsl:otherwise>
						</xsl:choose>
					</xsl:when>
					<xsl:otherwise>
						<ul>
							<xsl:for-each select="$Element/xdf3:bezug">
								<li>
									<xsl:choose>
										<xsl:when test="./@link and not(./@link='')">
											<xsl:choose>
												<xsl:when test="$HandlungsgrundlagenLinks = '1'">
													<xsl:element name="a">
														<xsl:attribute name="href"><xsl:value-of select="./@link"/></xsl:attribute>
														<xsl:attribute name="target">Handlungsgrundlage</xsl:attribute>
														<xsl:attribute name="title">Springe zum Text der Handlungsgrundlage.</xsl:attribute>
														<xsl:value-of select="."/>
													</xsl:element>
												</xsl:when>
												<xsl:otherwise>
													<xsl:value-of select="."/>
												</xsl:otherwise>
											</xsl:choose>
										</xsl:when>
										<xsl:otherwise>
											<xsl:value-of select="."/>
										</xsl:otherwise>
									</xsl:choose>
								</li>
							</xsl:for-each>
						</ul>
					</xsl:otherwise>
				</xsl:choose>
			</td>
		</tr>
		<tr>
			<td>Art</td>
			<td>
				<xsl:choose>
					<xsl:when test="$Element/xdf3:istAbstrakt = 'true'">
						abstrakter Dokumentsteckbrief
					</xsl:when>
					<xsl:otherwise>
						konkreter Dokumentsteckbrief
					</xsl:otherwise>
				</xsl:choose>
			</td>
		</tr>
		<xsl:if test="($Element/xdf3:istAbstrakt = 'true' and $Meldungen = '1') or count($Element/xdf3:relation[xdf3:praedikat/code = 'VKN'])">
			<tr>
				<td>
					<b>Zugeordnete<br/>Dokumentsteckbriefe</b>
					<!-- TODO Fehlermeldungen -->
				</td>
				<td>
					<table>
						<thead>
							<tr>
								<th>ID</th>
							</tr>
						</thead>
						<tbody>
							<xsl:for-each select="$Element/xdf3:relation[xdf3:praedikat/code = 'VKN']">
								<tr>
									<td>
										<xsl:variable name="objID" select="./xdf3:objekt/xdf3:id"/>
										<xsl:variable name="objVersion" select="./xdf3:objekt/xdf3:version"/>
										<xsl:value-of select="./xdf3:objekt/xdf3:id"/>
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
												<xsl:if test="$Meldungen = '1' and fn:substring($objID,1,1) != 'D'">
													<div class="Fehler E1087">Fehler!! E1087: Relation zu einem unzul�ssigen Objekt.</div>
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
							</xsl:for-each>
							<xsl:if test="$Meldungen = '1'">
								<xsl:choose>
									<xsl:when test="$Element/xdf3:istAbstrakt = 'false'">
										<tr>
											<td>
												<div class="Fehler E1053">Fehler!! E1053: Zu einem konkreten Dokumentsteckbrief d�rfen keine Dokumentsteckbriefe zugeordnet werden.</div>
											</td>
										</tr>
									</xsl:when>
									<xsl:when test="$Element/xdf3:istAbstrakt = 'true' and count($Element/xdf3:relation[xdf3:praedikat/code = 'VKN']) &lt; 2">
										<tr>
											<td>
												<div class="Fehler E1054">Fehler!! E1054: Zu einem abstrakten Dokumentsteckbrief m�ssen mindestens zwei Dokumentsteckbriefe zugeordnet werden.</div>
											</td>
										</tr>
									</xsl:when>
								</xsl:choose>
							</xsl:if>
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
			<td>Dokumentart</td>
			<td>
				<xsl:apply-templates select="$Element/xdf3:dokumentart"/>
			</td>
		</tr>
		<tr>
			<td>Beschreibung</td>
			<td>
				<xsl:value-of select="fn:replace($Element/xdf3:beschreibung,'\n','&lt;br/&gt;')" disable-output-escaping="yes"/>
			</td>
		</tr>
		<tr>
			<td>Bezeichnung</td>
			<xsl:choose>
				<xsl:when test="empty($Element/xdf3:bezeichnung/text())">
					<td>
						<xsl:if test="$Meldungen = '1'">
							<div class="Fehler E1050">Fehler!! E1050: Die Bezeichnung muss bef�llt sein.</div>
						</xsl:if>
					</td>
				</xsl:when>
				<xsl:otherwise>
					<td>
						<xsl:value-of select="$Element/xdf3:bezeichnung"/>
					</td>
				</xsl:otherwise>
			</xsl:choose>
		</tr>
		<tr>
			<td>Hilfetext</td>
			<xsl:choose>
				<xsl:when test="empty($Element/xdf3:hilfetext/text())">
					<td>
						<xsl:if test="$Meldungen = '1'">
							<div class="Warnung W1007">Warnung!! W1007: Der Hilfetext eines Dokumentsteckbriefs sollte bef�llt werden.</div>
						</xsl:if>
					</td>
				</xsl:when>
				<xsl:otherwise>
					<td>
						<xsl:value-of select="fn:replace($Element/xdf3:hilfetext,'\n','&lt;br/&gt;')" disable-output-escaping="yes"/>
					</td>
				</xsl:otherwise>
			</xsl:choose>
		</tr>
		<tr>
			<td>G�ltig ab</td>
			<td>
				<xsl:value-of select="$Element/xdf3:gueltigAb"/>
			</td>
		</tr>
		<tr>
			<td>G�ltig bis</td>
			<td>
				<xsl:value-of select="$Element/xdf3:gueltigBis"/>
			</td>
		</tr>
		<tr>
			<td>Fachlicher Ersteller</td>
			<xsl:choose>
				<xsl:when test="empty($Element/xdf3:statusGesetztDurch/text()) and $VersionsHinweise ='1'">
					<td>
						<xsl:value-of select="$Element/xdf3:statusGesetztDurch"/>
						<xsl:if test="$Meldungen = '1'">
							<div class="Hinweis">Hinweis!! Das Feld 'Fachlicher Ersteller' darf zur Versionierung oder Ver�ffentlichung nicht leer sein.</div>
						</xsl:if>
					</td>
				</xsl:when>
				<xsl:otherwise>
					<td>
						<xsl:value-of select="$Element/xdf3:statusGesetztDurch"/>
					</td>
				</xsl:otherwise>
			</xsl:choose>
		</tr>
		<tr>
			<td>Status</td>
			<td>
				<xsl:apply-templates select="$Element/xdf3:freigabestatus"/>
			</td>
		</tr>
		<tr>
			<td>Status gesetzt am</td>
			<td>
				<xsl:value-of select="$Element/xdf3:statusGesetztAm"/>
			</td>
		</tr>
		<tr>
			<td>Ver�ffentlichungsdatum</td>
			<td>
				<xsl:value-of select="$Element/xdf3:veroeffentlichungsdatum"/>
			</td>
		</tr>
		<tr>
			<td>Letzte �nderung</td>
			<td>
				<xsl:value-of select="fn:format-dateTime($Element/xdf3:letzteAenderung,'[D01].[M01].[Y0001] um [H01]:[m01] Uhr')"/>
			</td>
		</tr>
		<tr>
			<td colspan="2">
				<h2/>
			</td>
		</tr>
		<xsl:if test="count($Element/xdf3:relation[xdf3:praedikat/code != 'VKN'])">
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
							<xsl:for-each select="$Element/xdf3:relation[xdf3:praedikat/code != 'VKN']">
								<tr>
									<td>
										<xsl:variable name="objID" select="./xdf3:objekt/xdf3:id"/>
										<xsl:variable name="objVersion" select="./xdf3:objekt/xdf3:version"/>
										<xsl:value-of select="./xdf3:objekt/xdf3:id"/>
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
												<xsl:if test="$Meldungen = '1' and fn:substring($objID,1,1) != 'D'">
													<div class="Fehler E1087">Fehler!! E1087: Relation zu einem unzul�ssigen Objekt.</div>
												</xsl:if>
											</xsl:matching-substring>
											<xsl:non-matching-substring>
												<xsl:if test="$Meldungen = '1'">
													<div class="Fehler E1039">Fehler!! E1039: Die ID entspricht nicht den Formatvorgaben.</div>
												</xsl:if>
											</xsl:non-matching-substring>
										</xsl:analyze-string>
									</td>
									<td>
										<xsl:value-of select="./xdf3:objekt/xdf3:version"/>
									</td>
									<td>
										<xsl:apply-templates select="./xdf3:praedikat"/>
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
			<xsl:choose>
				<xsl:when test="name(/*) ='xdf3:xdatenfelder.stammdatenschema.0102'">
					<a name="ElementDetails"/>Details zu den Baukastenelementen des Datenschemas <xsl:value-of select="/*/xdf3:stammdatenschema/xdf3:identifikation/xdf3:id"/>
					<xsl:if test="/*/xdf3:stammdatenschema/xdf3:identifikation/xdf3:version"> Version <xsl:value-of select="/*/xdf3:stammdatenschema/xdf3:identifikation/xdf3:version"/>
					</xsl:if>
				</xsl:when>
				<xsl:when test="name(/*) ='xdf3:xdatenfelder.datenfeldgruppe.0103'">
					<a name="ElementDetails"/>Details zu den Baukastenelementen der Datenfeldgruppe <xsl:value-of select="/*/xdf3:datenfeldgruppe/xdf3:identifikation/xdf3:id"/>
					<xsl:if test="/*/xdf3:datenfeldgruppe/xdf3:identifikation/xdf3:version"> Version <xsl:value-of select="/*/xdf3:datenfeldgruppe/xdf3:identifikation/xdf3:version"/>
					</xsl:if>
				</xsl:when>
			</xsl:choose>
		</h2>
		<xsl:variable name="CompareID" select="/*/*/xdf3:identifikation/xdf3:id"/>
		<xsl:variable name="CompareVersion" select="/*/*/xdf3:identifikation/xdf3:version/text()"/>
		<table style="page-break-after:always">
			<thead>
				<tr>
					<th>Metadatum</th>
					<th>Inhalt</th>
				</tr>
			</thead>
			<tbody>
				<xsl:for-each-group select="//xdf3:datenfeldgruppe | //xdf3:datenfeld" group-by="xdf3:identifikation/xdf3:id">
					<xsl:sort select="./xdf3:identifikation/xdf3:id"/>
					<xsl:for-each-group select="fn:current-group()" group-by="string(xdf3:identifikation/xdf3:version)">
						<xsl:sort select="./xdf3:identifikation/xdf3:version"/>
						<xsl:if test="not($CompareID = ./xdf3:identifikation/xdf3:id and ($CompareVersion = ./xdf3:identifikation/xdf3:version or (empty($CompareVersion) and empty(./xdf3:identifikation/xdf3:version) )))">
							<xsl:call-template name="elementdetails">
								<xsl:with-param name="Element" select="."/>
								<xsl:with-param name="VersionsAnzahl" select="fn:last()"/>
							</xsl:call-template>
						</xsl:if>
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
				-------- <xsl:value-of select="$Element/xdf3:identifikation/xdf3:id"/>
				<xsl:if test="$Element/xdf3:identifikation/xdf3:version">V<xsl:value-of select="$Element/xdf3:identifikation/xdf3:version"/>
				</xsl:if> --------
			</xsl:message>
		</xsl:if>
		<xsl:choose>
			<xsl:when test="$Element/name() = 'xdf3:datenfeld'">
				<tr>
					<td>
						<xsl:element name="a">
							<xsl:attribute name="name"><xsl:value-of select="$Element/xdf3:identifikation/xdf3:id"/><xsl:if test="$Element/xdf3:identifikation/xdf3:version">V<xsl:value-of select="$Element/xdf3:identifikation/xdf3:version"/></xsl:if></xsl:attribute>
						</xsl:element>
													ID
												</td>
					<xsl:choose>
						<xsl:when test="empty($Element/xdf3:identifikation/xdf3:id/text())">
							<td class="ElementID">
								<xsl:if test="$Meldungen = '1'">
									<div class="Fehler E1038">Fehler!! E1038: Die ID muss bef�llt werden.</div>
								</xsl:if>
							</td>
						</xsl:when>
						<xsl:otherwise>
							<td class="ElementID">
								<xsl:value-of select="$Element/xdf3:identifikation/xdf3:id"/>
								<xsl:analyze-string regex="^F\d{{11}}$" select="$Element/xdf3:identifikation/xdf3:id">
									<xsl:matching-substring>
										<xsl:if test="$ToolAufruf = '1'">
																		&#160;&#160;
																		<xsl:element name="a">
												<xsl:attribute name="href"><xsl:value-of select="$ToolPfadPrefix"/><xsl:value-of select="$Element/xdf3:identifikation/xdf3:id"/><xsl:if test="$Element/xdf3:identifikation/xdf3:version">V<xsl:value-of select="$Element/xdf3:identifikation/xdf3:version"/></xsl:if><xsl:value-of select="$ToolPfadPostfix"/></xsl:attribute>
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
								<xsl:value-of select="$Element/xdf3:identifikation/xdf3:version"/>
								<xsl:if test="$Meldungen = '1'">
									<div class="Fehler E1003">Fehler!! E1003: In einem Datenschema darf ein Baukastenelement nicht mehrfach in unterschiedlichen Versionen enthalten sein.</div>
								</xsl:if>
							</td>
						</xsl:when>
						<xsl:otherwise>
							<td>
								<xsl:value-of select="$Element/xdf3:identifikation/xdf3:version"/>
							</td>
						</xsl:otherwise>
					</xsl:choose>
				</tr>
				<tr>
					<td>Versionshinweis</td>
					<td>
						<xsl:value-of select="fn:replace($Element/xdf3:versionshinweis,'\n','&lt;br/&gt;')" disable-output-escaping="yes"/>
					</td>
				</tr>
				<tr>
					<td>Name</td>
					<xsl:choose>
						<xsl:when test="empty($Element/xdf3:name/text())">
							<td class="ElementName">
								<xsl:if test="$Meldungen = '1'">
									<div class="Fehler E1002">Fehler!! E1002: Der Name eines Elements ist nicht gesetzt.</div>
								</xsl:if>
							</td>
						</xsl:when>
						<xsl:otherwise>
							<td class="ElementName">
								<xsl:value-of select="$Element/xdf3:name"/>
							</td>
						</xsl:otherwise>
					</xsl:choose>
				</tr>
				<tr>
					<td>Stichworte</td>
					<td>
						<ul>
							<xsl:for-each select="$Element/xdf3:stichwort">
								<li>
									<xsl:value-of select="."/>
									<xsl:if test="./@uri">
																	(<xsl:value-of select="./@uri"/>)
																	<xsl:if test="$XRepoAufruf = '1' and substring(./@uri,1,4) = 'urn:'">
											<xsl:choose>
												<xsl:when test="fn:contains(./@uri, '_')">
																				&#160;&#160;
																				<xsl:element name="a">
														<xsl:attribute name="href"><xsl:value-of select="$DocXRepoMitVersionPfadPrefix"/><xsl:value-of select="./@uri"/><xsl:value-of select="$DocXRepoMitVersionPfadPostfix"/></xsl:attribute>
														<xsl:attribute name="target">XRepo</xsl:attribute>
														<xsl:attribute name="title">Springe in das XRepository.</xsl:attribute>
																					&#8658;
																				</xsl:element>
												</xsl:when>
												<xsl:otherwise>
																				&#160;&#160;
																				<xsl:element name="a">
														<xsl:attribute name="href"><xsl:value-of select="$DocXRepoOhneVersionPfadPrefix"/><xsl:value-of select="./@uri"/><xsl:value-of select="$DocXRepoOhneVersionPfadPostfix"/></xsl:attribute>
														<xsl:attribute name="target">XRepo</xsl:attribute>
														<xsl:attribute name="title">Springe in das XRepository.</xsl:attribute>
																					&#8658;
																				</xsl:element>
												</xsl:otherwise>
											</xsl:choose>
																		&#160;
																	</xsl:if>
									</xsl:if>
								</li>
							</xsl:for-each>
						</ul>
					</td>
				</tr>
				<tr>
					<td>Definition</td>
					<td>
						<xsl:value-of select="fn:replace($Element/xdf3:definition,'\n','&lt;br/&gt;')" disable-output-escaping="yes"/>
					</td>
				</tr>
				<tr>
					<td>Strukturelementart</td>
					<xsl:choose>
						<xsl:when test="$Element/xdf3:schemaelementart/code/text() = 'ABS' and $AbstraktWarnung ='1'">
							<td>
								<xsl:apply-templates select="$Element/xdf3:schemaelementart"/>
								<xsl:if test="$Meldungen = '1'">
									<div class="Fehler E1014">Fehler!! E1014: Datenfelder d�rfen nicht die Strukturelementart "abstrakt" haben.</div>
								</xsl:if>
							</td>
						</xsl:when>
						<xsl:otherwise>
							<td>
								<xsl:apply-templates select="$Element/xdf3:schemaelementart"/>
							</td>
						</xsl:otherwise>
					</xsl:choose>
				</tr>
				<tr>
					<td>Handlungsgrundlagen</td>
					<td>
						<xsl:choose>
							<xsl:when test="fn:count($Element/xdf3:bezug) = 0">
								<xsl:choose>
									<xsl:when test="$Element/xdf3:schemaelementart/code/text() = 'RNG'">
										<xsl:if test="$Meldungen = '1'">
											<div class="Fehler E1006">Fehler!! E1006: Der Bezug zur Handlungsgrundlage darf bei Elementen mit der Strukturelementart 'rechtsnormgebunden' nicht leer sein.</div>
										</xsl:if>
									</xsl:when>
									<xsl:when test="$Element/xdf3:schemaelementart/code/text() = 'HAR'">
										<xsl:if test="$Meldungen = '1'">
											<div class="Warnung W1001">Warnung!! W1001: Der Bezug zur Handlungsgrundlage sollte bei Elementen mit der Strukturelementart 'harmonisiert' m�glichst nicht leer sein.</div>
										</xsl:if>
									</xsl:when>
									<xsl:otherwise>
																</xsl:otherwise>
								</xsl:choose>
							</xsl:when>
							<xsl:when test="fn:count($Element/xdf3:bezug) = 1">
								<xsl:choose>
									<xsl:when test="$Element/xdf3:bezug/@link and not($Element/xdf3:bezug/@link='')">
										<xsl:choose>
											<xsl:when test="$HandlungsgrundlagenLinks = '1'">
												<xsl:element name="a">
													<xsl:attribute name="href"><xsl:value-of select="$Element/xdf3:bezug/@link"/></xsl:attribute>
													<xsl:attribute name="target">Handlungsgrundlage</xsl:attribute>
													<xsl:attribute name="title">Springe zum Text der Handlungsgrundlage.</xsl:attribute>
													<xsl:value-of select="$Element/xdf3:bezug"/>
												</xsl:element>
											</xsl:when>
											<xsl:otherwise>
												<xsl:value-of select="$Element/xdf3:bezug"/>
											</xsl:otherwise>
										</xsl:choose>
									</xsl:when>
									<xsl:otherwise>
										<xsl:value-of select="$Element/xdf3:bezug"/>
									</xsl:otherwise>
								</xsl:choose>
							</xsl:when>
							<xsl:otherwise>
								<ul>
									<xsl:for-each select="$Element/xdf3:bezug">
										<li>
											<xsl:choose>
												<xsl:when test="./@link and not(./@link='')">
													<xsl:choose>
														<xsl:when test="$HandlungsgrundlagenLinks = '1'">
															<xsl:element name="a">
																<xsl:attribute name="href"><xsl:value-of select="./@link"/></xsl:attribute>
																<xsl:attribute name="target">Handlungsgrundlage</xsl:attribute>
																<xsl:attribute name="title">Springe zum Text der Handlungsgrundlage.</xsl:attribute>
																<xsl:value-of select="."/>
															</xsl:element>
														</xsl:when>
														<xsl:otherwise>
															<xsl:value-of select="."/>
														</xsl:otherwise>
													</xsl:choose>
												</xsl:when>
												<xsl:otherwise>
													<xsl:value-of select="."/>
												</xsl:otherwise>
											</xsl:choose>
										</li>
									</xsl:for-each>
								</ul>
							</xsl:otherwise>
						</xsl:choose>
					</td>
				</tr>
				<tr>
					<td>Feldart</td>
					<td>
						<xsl:apply-templates select="$Element/xdf3:feldart"/>
					</td>
				</tr>
				<tr>
					<td>Datentyp</td>
					<xsl:choose>
						<xsl:when test="$Element/xdf3:feldart/code/text() = 'select'">
							<td>
								<xsl:apply-templates select="$Element/xdf3:datentyp"/>
								<xsl:choose>
									<xsl:when test="$Element/xdf3:datentyp/code/text() = 'text' or $Element/xdf3:datentyp/code/text() = 'text_latin'">
									</xsl:when>
									<xsl:when test="$Element/xdf3:datentyp/code/text() = 'int'">
										<xsl:if test="$Meldungen = '1'">
											<div class="Warnung W1008">Warnung!! W1008: Wenn ein Datenfeld die Feldart 'Auswahl' hat, sollte der Datentyp i. d. R. vom Typ 'Text' sein.</div>
										</xsl:if>
									</xsl:when>
									<xsl:otherwise>
										<xsl:if test="$Meldungen = '1'">
											<div class="Fehler E1011">Fehler!! E1011: Bei Datenfeldern mit der Feldart 'Auswahl' sollte der Datentyp 'Text' sein - in seltenen F�llen 'Ganzzahl'.</div>
										</xsl:if>
									</xsl:otherwise>
								</xsl:choose>
							</td>
						</xsl:when>
						<xsl:otherwise>
							<td>
								<xsl:apply-templates select="$Element/xdf3:datentyp"/>
							</td>
						</xsl:otherwise>
					</xsl:choose>
				</tr>
				<tr>
					<td>Feldl�nge</td>
					<xsl:choose>
						<xsl:when test="$Element/xdf3:praezisierung">
							<xsl:variable name="minLength">
								<xsl:value-of select="$Element/xdf3:praezisierung/@minLength"/>
							</xsl:variable>
							<xsl:variable name="maxLength">
								<xsl:value-of select="$Element/xdf3:praezisierung/@maxLength"/>
							</xsl:variable>
							<xsl:choose>
								<xsl:when test="$Element/xdf3:datentyp/code/text() = 'text' or $Element/xdf3:datentyp/code/text() = 'text_latin'">
									<xsl:choose>
										<xsl:when test="$Element/xdf3:feldart/code/text() = 'select' or $Element/xdf3:feldart/code/text() = 'label'">
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
															<div class="Fehler E1012">Fehler!! E1012: Bei Datenfeldern mit der Feldart 'Auswahlfeld' oder 'Statisches, read-only Feld' d�rfen weder die minimale noch die maximale Feldl�nge angegeben werden.</div>
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
															<div class="Fehler E1059">Fehler!! E1059: Die minimale Feldl�nge muss eine ganze Zahl gr��er oder gleich Null sein.</div>
														</xsl:if>
														<xsl:if test="$Meldungen = '1' and not($maxLength castable as xs:positiveInteger)">
															<div class="Fehler E1060">Fehler!! E1060: Die maximale Feldl�nge muss eine ganze Zahl gr��er Null sein.</div>
														</xsl:if>
														<xsl:if test="$Meldungen = '1' and ($minLength castable as xs:nonNegativeInteger) and ($maxLength castable as xs:positiveInteger) and ($minLength cast as xs:nonNegativeInteger &gt; $maxLength cast as xs:positiveInteger)">
															<div class="Fehler E1061">Fehler!! E1061: Die minimale Feldl�nge darf nicht gr��er sein als die maximale Feldl�nge.</div>
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
															<div class="Fehler E1059">Fehler!! E1059: Die minimale Feldl�nge muss eine ganze Zahl gr��er oder gleich Null sein.</div>
														</xsl:if>
														<xsl:if test="$Meldungen = '1' and $maxLength != '' and not($maxLength castable as xs:positiveInteger)">
															<div class="Fehler E1060">Fehler!! E1060: Die maximale Feldl�nge muss eine ganze Zahl gr��er Null sein.</div>
														</xsl:if>
														<xsl:if test="$Meldungen = '1'">
															<div class="Warnung W1002">Warnung!! W1002: Bei Eingabedatenfeldern mit dem Datentyp 'Text' oder 'String.Latin+' sollten, wenn m�glich, die minimale und maximale Feldl�nge angegeben werden.</div>
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
											<div class="Fehler E1015">Fehler!! E1015: Eine Feldl�nge darf nur bei einem Datenfeld mit dem Datentyp 'Text' oder 'String.Latin+' angegeben werden.</div>
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
								<xsl:when test="($Element/xdf3:datentyp/code/text() = 'text' or $Element/xdf3:datentyp/code/text() = 'text_latin') and $Element/xdf3:feldart/code/text() = 'input'">
									<td>
										<xsl:if test="$Meldungen = '1'">
											<div class="Warnung W1002">Warnung!! W1002: Bei Eingabedatenfeldern mit dem Datentyp 'Text' oder 'String.Latin+' sollten, wenn m�glich, die minimale und maximale Feldl�nge angegeben werden.</div>
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
						<xsl:when test="$Element/xdf3:praezisierung">
							<xsl:variable name="minValue">
								<xsl:value-of select="$Element/xdf3:praezisierung/@minValue"/>
							</xsl:variable>
							<xsl:variable name="maxValue">
								<xsl:value-of select="$Element/xdf3:praezisierung/@maxValue"/>
							</xsl:variable>
							<xsl:choose>
								<xsl:when test="$Element/xdf3:datentyp/code/text() = 'num' or $Element/xdf3:datentyp/code/text() = 'num_currency'">
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
											<div class="Fehler E1064">Fehler!! E1064: Die untere Wertgrenze darf nicht gr��er sein als die obere Wertgrenze.</div>
										</xsl:if>
									</td>
								</xsl:when>
								<xsl:when test="$Element/xdf3:datentyp/code/text() = 'num_int'">
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
											<div class="Fehler E1064">Fehler!! E1064: Die untere Wertgrenze darf nicht gr��er sein als die obere Wertgrenze.</div>
										</xsl:if>
									</td>
								</xsl:when>
								<xsl:when test="$Element/xdf3:datentyp/code/text() = 'date'">
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
											<div class="Fehler E1064">Fehler!! E1064: Die untere Wertgrenze darf nicht gr��er sein als die obere Wertgrenze.</div>
										</xsl:if>
									</td>
								</xsl:when>
								<xsl:when test="$Element/xdf3:datentyp/code/text() = 'datetime'">
									<td>
										<xsl:if test="$minValue != ''">
											von <xsl:value-of select="$minValue"/>
										</xsl:if>
										<xsl:if test="$maxValue != ''">
											bis <xsl:value-of select="$maxValue"/>
										</xsl:if>
										<xsl:if test="$Meldungen = '1' and $minValue != '' and not($minValue castable as xs:dateTime)">
											<div class="Fehler E1079">Fehler!! E1079: Die untere Wertgrenze muss ein Zeitpunkt sein.</div>
										</xsl:if>
										<xsl:if test="$Meldungen = '1' and $maxValue != '' and not($maxValue castable as xs:dateTime)">
											<div class="Fehler E1080">Fehler!! E1080: Die obere Wertgrenze muss ein Zeitpunkt sein.</div>
										</xsl:if>
										<xsl:if test="$Meldungen = '1' and $minValue != '' and $maxValue != '' and ($minValue castable as xs:dateTime) and ($maxValue castable as xs:dateTime) and ($minValue cast as xs:dateTime &gt; $maxValue cast as xs:dateTime)">
											<div class="Fehler E1064">Fehler!! E1064: Die untere Wertgrenze darf nicht gr��er sein als die obere Wertgrenze.</div>
										</xsl:if>
									</td>
								</xsl:when>
								<xsl:when test="$Element/xdf3:datentyp/code/text() = 'time'">
									<td>
										<xsl:if test="$minValue != ''">
											von <xsl:value-of select="$minValue"/>
										</xsl:if>
										<xsl:if test="$maxValue != ''">
											bis <xsl:value-of select="$maxValue"/>
										</xsl:if>
										<xsl:if test="$Meldungen = '1' and $minValue != '' and not($minValue castable as xs:time)">
											<div class="Fehler E1081">Fehler!! E1081: Die untere Wertgrenze muss eine Uhrzeit sein.</div>
										</xsl:if>
										<xsl:if test="$Meldungen = '1' and $maxValue != '' and not($maxValue castable as xs:time)">
											<div class="Fehler E1082">Fehler!! E1082: Die obere Wertgrenze muss eine Uhrzeit sein.</div>
										</xsl:if>
										<xsl:if test="$Meldungen = '1' and $minValue != '' and $maxValue != '' and ($minValue castable as xs:time) and ($maxValue castable as xs:time) and ($minValue cast as xs:time &gt; $maxValue cast as xs:time)">
											<div class="Fehler E1064">Fehler!! E1064: Die untere Wertgrenze darf nicht gr��er sein als die obere Wertgrenze.</div>
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
													<div class="Fehler E1016">Fehler!! E1016: Ein Wertebereich darf nur bei einem Datenfeld mit einem nummerischen Datentyp (Nummer, Ganzzahl, Geldbetrag) oder einem Zeitdatentyp (Uhrzeit, Datum, Zeitpunkt) angegeben werden.</div>
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
								<xsl:when test="$Element/xdf3:datentyp/code/text() = 'num' or $Element/xdf3:datentyp/code/text() = 'num_int' or $Element/xdf3:datentyp/code/text() = 'num_currency'">
									<td>
										<xsl:if test="$Meldungen = '1'">
											<div class="Warnung W1003">Warnung!! W1003: Bei Datenfeldern mit dem Datentyp 'Nummer', 'Ganzzahl' oder 'Geldbetrag' sollte, wenn m�glich, ein Wertebereich angegeben werden.</div>
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
						<xsl:value-of select="$Element/xdf3:praezisierung/@pattern"/>
					</td>
				</tr>
				<tr>
					<xsl:if test="$Element/xdf3:werte">
						<td>Werteliste</td>
						<td>
							<table>
								<tbody>
									<tr>
										<th>Code</th>
										<th>Name</th>
										<th>Hilfe</th>
									</tr>
									<xsl:for-each select="$Element/xdf3:werte/xdf3:wert">
										<tr>
											<td>
												<xsl:value-of select="./xdf3:code"/>
											</td>
											<td>
												<xsl:value-of select="./xdf3:name"/>
											</td>
											<td>
												<xsl:value-of select="./xdf3:hilfe"/>
											</td>
										</tr>
									</xsl:for-each>
								</tbody>
							</table>
							<xsl:if test="$Meldungen = '1'">
								<xsl:if test="$Element/xdf3:feldart/code/text() != 'select'">
									<div class="Fehler E1017">Fehler!! E1017: Ist eine Code- oder Werteliste zugeordnet, muss die Feldart 'Auswahl' sein.</div>
								</xsl:if>
								<xsl:if test="$Meldungen = '1'and $Element/xdf3:feldart/code/text() = 'select' and $Element/xdf3:codelisteReferenz">
									<div class="Fehler E1018">Fehler!! E1018: Wenn ein Datenfeld die Feldart 'Auswahl' hat, muss entweder eine Code- oder eine Werteliste zugeordnet sein.</div>
								</xsl:if>
								<xsl:if test="count($Element/xdf3:werte/xdf3:wert) &lt; 2">
									<div class="Fehler E1044">Fehler!! E1044: Eine Werteliste muss mindestens zwei Eintr�ge haben.</div>
								</xsl:if>
								<xsl:if test="count(distinct-values($Element/xdf3:werte/xdf3:wert/xdf3:code)) &lt; count($Element/xdf3:werte/xdf3:wert/xdf3:code)">
									<div class="Fehler E1045">Fehler!! E1045: Innerhalb einer Werteliste d�rfen Codes (Schl�ssel) nicht doppelt verwendet werden.</div>
								</xsl:if>
							</xsl:if>
						</td>
					</xsl:if>
				</tr>
				<tr>
					<xsl:if test="$Element/xdf3:codelisteReferenz">
						<td>Referenzierte Codeliste</td>
						<td>
							<xsl:choose>
								<xsl:when test="$InterneLinks = '1'">
									<xsl:element name="a">
										<xsl:attribute name="href">#<xsl:value-of select="$Element/xdf3:codelisteReferenz/xdf3:canonicalIdentification"/><xsl:if test="$Element/xdf3:codelisteReferenz/xdf3:version">_<xsl:value-of select="$Element/xdf3:codelisteReferenz/xdf3:version"/></xsl:if></xsl:attribute>
										<xsl:value-of select="$Element/xdf3:codelisteReferenz/xdf3:canonicalIdentification"/>
										<xsl:if test="$Element/xdf3:codelisteReferenz/xdf3:version">_<xsl:value-of select="$Element/xdf3:codelisteReferenz/xdf3:version"/>
										</xsl:if>
									</xsl:element>
								</xsl:when>
								<xsl:otherwise>
									<xsl:value-of select="$Element/xdf3:codelisteReferenz/xdf3:canonicalIdentification"/>
									<xsl:if test="$Element/xdf3:codelisteReferenz/xdf3:version">_<xsl:value-of select="$Element/xdf3:codelisteReferenz/xdf3:version"/>
									</xsl:if>
								</xsl:otherwise>
							</xsl:choose>
							<xsl:if test="$Meldungen = '1'and $Element/xdf3:feldart/code/text() != 'select'">
								<div class="Fehler E1017">Fehler!! E1017: Ist eine Code- oder Werteliste zugeordnet, muss die Feldart 'Auswahl' sein.</div>
							</xsl:if>
							<xsl:if test="$Meldungen = '1'and $Element/xdf3:feldart/code/text() = 'select' and $Element/xdf3:werte">
								<div class="Fehler E1018">Fehler!! E1018: Wenn ein Datenfeld die Feldart 'Auswahl' hat, muss entweder eine Code- oder eine Werteliste zugeordnet sein.</div>
							</xsl:if>
						</td>
					</xsl:if>
				</tr>
				<tr>
					<xsl:if test="$Element/xdf3:feldart/code/text() = 'select' and not($Element/xdf3:codelisteReferenz or $Element/xdf3:werte)">
						<td>Werteliste /<br/>Referenzierte Codeliste</td>
						<td>
							<xsl:if test="$Meldungen = '1'">
								<div class="Fehler E1018">Fehler!! E1018: Wenn ein Datenfeld die Feldart 'Auswahl' hat, muss entweder eine Code- oder eine Werteliste zugeordnet sein.</div>
							</xsl:if>
						</td>
					</xsl:if>
				</tr>
				<tr>
					<td>Spaltendefinitionen zur referenzierten Codeliste</td>
					<td>
						<xsl:if test="$Element/xdf3:codeKey/text() !='' or $Element/xdf3:nameKey/text() !='' or $Element/xdf3:helpKey/text() !=''">
							<table>
								<tbody>
									<tr>
										<th>Spaltentyp</th>
										<th>Spalte in der referenzierten Codeliste</th>
									</tr>
									<tr>
										<td>
											Code
										</td>
										<td>
											<xsl:value-of select="$Element/xdf3:codeKey"/>
										</td>
									</tr>
									<tr>
										<td>
											Name
										</td>
										<td>
											<xsl:value-of select="$Element/xdf3:nameKey"/>
										</td>
									</tr>
									<tr>
										<td>
											Hilfetext
										</td>
										<td>
											<xsl:value-of select="$Element/xdf3:helpKey"/>
										</td>
									</tr>
								</tbody>
							</table>
							<xsl:if test="$Meldungen = '1' and not($Element/xdf3:codelisteReferenz)">
								<div class="Fehler E1058">Fehler!! E1058: Spaltendefinitionen d�rfen nur angegeben werden, wenn im Datenfeld eine referenzierte Codeliste enthalten ist.</div>
							</xsl:if>
						</xsl:if>
					</td>
				</tr>
				<tr>
					<td>Inhalt</td>
					<xsl:choose>
						<xsl:when test="$Element/xdf3:feldart/code/text() = 'label' and empty($Element/xdf3:inhalt/text())">
							<td>
								<xsl:if test="$Meldungen = '1'">
									<div class="Warnung W1009">Warnung!! W1009: Bei einem Feld mit nur lesendem Zugriff, der Feldart 'Statisch' wird i. d. R. der Inhalt mit einem Text bef�llt.</div>
								</xsl:if>
							</td>
						</xsl:when>
						<xsl:otherwise>
							<td>
								<xsl:value-of select="fn:replace($Element/xdf3:inhalt,'\n','&lt;br/&gt;')" disable-output-escaping="yes"/>
								<xsl:if test="$Meldungen = '1' and not(fn:empty($Element/xdf3:inhalt/text()))">
									<xsl:variable name="Inhalt">
										<xsl:value-of select="$Element/xdf3:inhalt"/>
									</xsl:variable>
									<xsl:variable name="minValue">
										<xsl:value-of select="$Element/xdf3:praezisierung/@minValue"/>
									</xsl:variable>
									<xsl:variable name="maxValue">
										<xsl:value-of select="$Element/xdf3:praezisierung/@maxValue"/>
									</xsl:variable>
									<xsl:variable name="minLength">
										<xsl:value-of select="$Element/xdf3:praezisierung/@minLength"/>
									</xsl:variable>
									<xsl:variable name="maxLength">
										<xsl:value-of select="$Element/xdf3:praezisierung/@maxLength"/>
									</xsl:variable>
									<xsl:choose>
										<xsl:when test="$Element/xdf3:datentyp/code/text() = 'num' or $Element/xdf3:datentyp/code/text() = 'num_currency'">
											<xsl:if test="$Inhalt != '' and not($Inhalt castable as xs:double)">
												<div class="Fehler E1069">Fehler!! E1069: Der Inhalt muss eine Zahl sein.</div>
											</xsl:if>
											<xsl:if test="$Inhalt != '' and $minValue != '' and ($Inhalt castable as xs:double) and ($minValue castable as xs:double) and ($minValue cast as xs:double &gt; $Inhalt cast as xs:double)">
												<div class="Fehler E1072">Fehler!! E1072: Der Inhalt unterschreitet die untere Wertgrenze.</div>
											</xsl:if>
											<xsl:if test="$Inhalt != '' and $maxValue != '' and ($Inhalt castable as xs:double) and ($maxValue castable as xs:double) and ($maxValue cast as xs:double &lt; $Inhalt cast as xs:double)">
												<div class="Fehler E1073">Fehler!! E1073: Der Inhalt �berschreitet die obere Wertgrenze.</div>
											</xsl:if>
										</xsl:when>
										<xsl:when test="$Element/xdf3:datentyp/code/text() = 'num_int'">
											<xsl:if test="$Inhalt != '' and not($Inhalt castable as xs:integer)">
												<div class="Fehler E1070">Fehler!! E1070: Der Inhalt muss eine ganze Zahl sein.</div>
											</xsl:if>
											<xsl:if test="$Inhalt != '' and $minValue != '' and ($Inhalt castable as xs:integer) and ($minValue castable as xs:integer) and ($minValue cast as xs:integer &gt; $Inhalt cast as xs:integer)">
												<div class="Fehler E1072">Fehler!! E1072: Der Inhalt unterschreitet die untere Wertgrenze.</div>
											</xsl:if>
											<xsl:if test="$Inhalt != '' and $maxValue != '' and ($Inhalt castable as xs:integer) and ($maxValue castable as xs:integer) and ($maxValue cast as xs:integer &lt; $Inhalt cast as xs:integer)">
												<div class="Fehler E1073">Fehler!! E1073: Der Inhalt �berschreitet die obere Wertgrenze.</div>
											</xsl:if>
										</xsl:when>
										<xsl:when test="$Element/xdf3:datentyp/code/text() = 'date'">
											<xsl:if test="$Inhalt != '' and not($Inhalt castable as xs:date)">
												<div class="Fehler E1071">Fehler!! E1071: Der Inhalt muss ein Datum sein.</div>
											</xsl:if>
											<xsl:if test="$Inhalt != '' and $minValue != '' and ($Inhalt castable as xs:date) and ($minValue castable as xs:date) and ($minValue cast as xs:date &gt; $Inhalt cast as xs:date)">
												<div class="Fehler E1072">Fehler!! E1072: Der Inhalt unterschreitet die untere Wertgrenze.</div>
											</xsl:if>
											<xsl:if test="$Inhalt != '' and $maxValue != '' and ($Inhalt castable as xs:date) and ($maxValue castable as xs:date) and ($maxValue cast as xs:date &lt; $Inhalt cast as xs:date)">
												<div class="Fehler E1073">Fehler!! E1073: Der Inhalt �berschreitet die obere Wertgrenze.</div>
											</xsl:if>
										</xsl:when>
										<xsl:when test="$Element/xdf3:datentyp/code/text() = 'datetime'">
											<xsl:if test="$Inhalt != '' and not($Inhalt castable as xs:dateTime)">
												<div class="Fehler E1083">Fehler!! E1083: Der Inhalt muss ein Zeitpunkt (Datum und Uhrzeit) sein.</div>
											</xsl:if>
											<xsl:if test="$Inhalt != '' and $minValue != '' and ($Inhalt castable as xs:dateTime) and ($minValue castable as xs:dateTime) and ($minValue cast as xs:dateTime &gt; $Inhalt cast as xs:dateTime)">
												<div class="Fehler E1072">Fehler!! E1072: Der Inhalt unterschreitet die untere Wertgrenze.</div>
											</xsl:if>
											<xsl:if test="$Inhalt != '' and $maxValue != '' and ($Inhalt castable as xs:dateTime) and ($maxValue castable as xs:dateTime) and ($maxValue cast as xs:dateTime &lt; $Inhalt cast as xs:dateTime)">
												<div class="Fehler E1073">Fehler!! E1073: Der Inhalt �berschreitet die obere Wertgrenze.</div>
											</xsl:if>
										</xsl:when>
										<xsl:when test="$Element/xdf3:datentyp/code/text() = 'time'">
											<xsl:if test="$Inhalt != '' and not($Inhalt castable as xs:time)">
												<div class="Fehler E1084">Fehler!! E1084: Der Inhalt muss eine Uhrzeit sein.</div>
											</xsl:if>
											<xsl:if test="$Inhalt != '' and $minValue != '' and ($Inhalt castable as xs:time) and ($minValue castable as xs:time) and ($minValue cast as xs:time &gt; $Inhalt cast as xs:time)">
												<div class="Fehler E1072">Fehler!! E1072: Der Inhalt unterschreitet die untere Wertgrenze.</div>
											</xsl:if>
											<xsl:if test="$Inhalt != '' and $maxValue != '' and ($Inhalt castable as xs:time) and ($maxValue castable as xs:time) and ($maxValue cast as xs:time &lt; $Inhalt cast as xs:time)">
												<div class="Fehler E1073">Fehler!! E1073: Der Inhalt �berschreitet die obere Wertgrenze.</div>
											</xsl:if>
										</xsl:when>
										<xsl:when test="$Element/xdf3:datentyp/code/text() = 'text' or $Element/xdf3:datentyp/code/text() = 'text_latin'">
											<xsl:if test="$Inhalt != '' and ($minLength castable as xs:integer) and (fn:string-length($Inhalt) &lt; $minLength)">
												<div class="Fehler E1074">Fehler!! E1074: Der Inhalt unterschreitet die Minimall�nge.</div>
											</xsl:if>
											<xsl:if test="$Inhalt != '' and ($maxLength castable as xs:integer) and (fn:string-length($Inhalt) &gt; $maxLength)">
												<div class="Fehler E1075">Fehler!! E1075: Der Inhalt �berschreitet die Maximall�nge.</div>
											</xsl:if>
										</xsl:when>
										<xsl:when test="$Element/xdf3:datentyp/code/text() = 'bool'">
											<xsl:if test="$Inhalt != '' and not($Inhalt castable as xs:boolean)">
												<div class="Fehler E1077">Fehler!! E1077: Der Inhalt muss ein Wahrheitswert sein (true oder false).</div>
											</xsl:if>
										</xsl:when>
									</xsl:choose>
									<xsl:choose>
										<xsl:when test="$Element/xdf3:feldart/code/text() = 'select' and $Element/xdf3:werte">
											<xsl:if test="count($Element/xdf3:werte/xdf3:wert[xdf3:code = $Inhalt]) = 0">
												<div class="Fehler E1085">Fehler!! E1085: Der Inhalt muss ein Code-Wert der Werteliste sein.</div>
											</xsl:if>
										</xsl:when>
									</xsl:choose>
								</xsl:if>
							</td>
						</xsl:otherwise>
					</xsl:choose>
				</tr>
				<tr>
					<td>Maximale Dateigr��e</td>
					<xsl:choose>
						<xsl:when test="empty($Element/xdf3:maxSize/text())">
							<td>
							</td>
						</xsl:when>
						<xsl:otherwise>
							<td>
								<xsl:value-of select="number($Element/xdf3:maxSize) div 1000000"/> MB
								<xsl:if test="$Meldungen = '1' and $Element/xdf3:datentyp/code/text() != 'file'">
									<div class="Fehler E1056">Fehler!! E1056: Die Dateigr��e darf nur bef�llt sein, wenn der Datentyp des Datenfeldes den Wert 'Anlage (Datei)' hat.</div>
								</xsl:if>
							</td>
						</xsl:otherwise>
					</xsl:choose>
				</tr>
				<tr>
					<td>Erlaubte Dateitypen</td>
					<xsl:choose>
						<xsl:when test="fn:not(empty($Element/xdf3:mediaType[1]/text()))">
							<td>
								<xsl:for-each select="$Element/xdf3:mediaType">
									<xsl:value-of select="."/>
									<xsl:if test="fn:position() != fn:last()">, </xsl:if>
								</xsl:for-each>
								<xsl:if test="$Meldungen = '1' and $Element/xdf3:datentyp/code/text() != 'file'">
									<div class="Fehler E1057">Fehler!! E1057: Erlaubte Datentypen d�rfen nur angegeben werden, wenn der Datentyp des Datenfeldes den Wert 'Anlage (Datei)' hat.</div>
								</xsl:if>
							</td>
						</xsl:when>
						<xsl:otherwise>
							<td>
								<xsl:for-each select="$Element/xdf3:mediaType">
									<xsl:value-of select="."/>
									<xsl:if test="fn:position() != fn:last()">, </xsl:if>
								</xsl:for-each>
							</td>
						</xsl:otherwise>
					</xsl:choose>
				</tr>
				<tr>
					<td>Vorbef�llung</td>
					<td>
						<xsl:apply-templates select="$Element/xdf3:vorbefuellung"/>
					</td>
				</tr>
				<tr>
					<td>Beschreibung</td>
					<td>
						<xsl:value-of select="fn:replace($Element/xdf3:beschreibung,'\n','&lt;br/&gt;')" disable-output-escaping="yes"/>
					</td>
				</tr>
				<tr>
					<td>Bezeichnung Eingabe</td>
					<xsl:choose>
						<xsl:when test="empty($Element/xdf3:bezeichnungEingabe/text())">
							<td>
								<xsl:if test="$Meldungen = '1'">
									<div class="Fehler E1009">Fehler!! E1009: Die Bezeichnung Eingabe muss bef�llt werden.</div>
								</xsl:if>
							</td>
						</xsl:when>
						<xsl:otherwise>
							<td>
								<xsl:value-of select="$Element/xdf3:bezeichnungEingabe"/>
							</td>
						</xsl:otherwise>
					</xsl:choose>
				</tr>
				<tr>
					<td>Bezeichnung Ausgabe</td>
					<xsl:choose>
						<xsl:when test="empty($Element/xdf3:bezeichnungAusgabe/text())">
							<td>
								<xsl:if test="$Meldungen = '1'">
									<div class="Fehler E1010">Fehler!! E1010: Die Bezeichnung Ausgabe muss bef�llt werden.</div>
								</xsl:if>
							</td>
						</xsl:when>
						<xsl:otherwise>
							<td>
								<xsl:value-of select="$Element/xdf3:bezeichnungAusgabe"/>
							</td>
						</xsl:otherwise>
					</xsl:choose>
				</tr>
				<tr>
					<td>Hilfetext Eingabe</td>
					<td>
						<xsl:value-of select="fn:replace($Element/xdf3:hilfetextEingabe,'\n','&lt;br/&gt;')" disable-output-escaping="yes"/>
					</td>
				</tr>
				<tr>
					<td>Hilfetext Ausgabe</td>
					<td>
						<xsl:value-of select="fn:replace($Element/xdf3:hilfetextAusgabe,'\n','&lt;br/&gt;')" disable-output-escaping="yes"/>
					</td>
				</tr>
				<tr>
					<td>G�ltig ab</td>
					<td>
						<xsl:value-of select="$Element/xdf3:gueltigAb"/>
					</td>
				</tr>
				<tr>
					<td>G�ltig bis</td>
					<td>
						<xsl:value-of select="$Element/xdf3:gueltigBis"/>
					</td>
				</tr>
				<tr>
					<td>Fachlicher Ersteller</td>
					<xsl:choose>
						<xsl:when test="empty($Element/xdf3:statusGesetztDurch/text()) and $VersionsHinweise ='1'">
							<td>
								<xsl:value-of select="$Element/xdf3:statusGesetztDurch"/>
								<xsl:if test="$Meldungen = '1'">
									<div class="Hinweis">Hinweis!! Das Feld 'Fachlicher Ersteller' darf zur Versionierung oder Ver�ffentlichung nicht leer sein.</div>
								</xsl:if>
							</td>
						</xsl:when>
						<xsl:otherwise>
							<td>
								<xsl:value-of select="$Element/xdf3:statusGesetztDurch"/>
							</td>
						</xsl:otherwise>
					</xsl:choose>
				</tr>
				<tr>
					<td>Status</td>
					<td>
						<xsl:apply-templates select="$Element/xdf3:freigabestatus"/>
					</td>
				</tr>
				<tr>
					<td>Status gesetzt am</td>
					<td>
						<xsl:value-of select="$Element/xdf3:statusGesetztAm"/>
					</td>
				</tr>
				<tr>
					<td>Ver�ffentlichungsdatum</td>
					<td>
						<xsl:value-of select="$Element/xdf3:veroeffentlichungsdatum"/>
					</td>
				</tr>
				<tr>
					<td>Letzte �nderung</td>
					<td>
						<xsl:value-of select="fn:format-dateTime($Element/xdf3:letzteAenderung,'[D01].[M01].[Y0001] um [H01]:[m01] Uhr')"/>
					</td>
				</tr>
				<tr>
					<td colspan="2">
						<h2/>
					</td>
				</tr>
				<xsl:if test="count($Element/xdf3:relation)">
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
									<xsl:for-each select="$Element/xdf3:relation">
										<tr>
											<td>
												<xsl:variable name="objID" select="./xdf3:objekt/xdf3:id"/>
												<xsl:variable name="objVersion" select="./xdf3:objekt/xdf3:version"/>
												<xsl:value-of select="./xdf3:objekt/xdf3:id"/>
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
															<div class="Fehler E1087">Fehler!! E1087: Relation zu einem unzul�ssigen Objekt.</div>
														</xsl:if>
													</xsl:matching-substring>
													<xsl:non-matching-substring>
														<xsl:if test="$Meldungen = '1'">
															<div class="Fehler E1039">Fehler!! E1039: Die ID entspricht nicht den Formatvorgaben.</div>
														</xsl:if>
													</xsl:non-matching-substring>
												</xsl:analyze-string>
											</td>
											<td>
												<xsl:value-of select="./xdf3:objekt/xdf3:version"/>
											</td>
											<td>
												<xsl:apply-templates select="./xdf3:praedikat"/>
												<xsl:if test="$Meldungen = '1' and ./xdf3:praedikat = 'VKN'">
													<div class="Fehler E1088">Fehler!! E1088: Diese Relation darf in diesem Objekt nicht verwendet werden.</div>
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
												<td>Zeitpunkt der letzten �nderung</td>
												<td>
													<xsl:value-of select="./LetztesAenderungsdatum"/>
												</td>
											</tr>
										</xsl:if>
-->
				<xsl:if test="count($Element/xdf3:regel)">
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
										<th>Freitextregel</th>
									</tr>
								</thead>
								<tbody>
									<xsl:for-each select="$Element/xdf3:regel">
										<tr>
											<td>
												<xsl:choose>
													<xsl:when test="$InterneLinks = '1'">
														<xsl:element name="a">
															<xsl:attribute name="href">#<xsl:value-of select="./xdf3:identifikation/xdf3:id"/><xsl:if test="./xdf3:identifikation/xdf3:version">V<xsl:value-of select="./xdf3:identifikation/xdf3:version"/></xsl:if></xsl:attribute>
															<xsl:value-of select="./xdf3:identifikation/xdf3:id"/>
														</xsl:element>
													</xsl:when>
													<xsl:otherwise>
														<xsl:value-of select="./xdf3:identifikation/xdf3:id"/>
													</xsl:otherwise>
												</xsl:choose>
											</td>
											<td>
												<xsl:value-of select="./xdf3:identifikation/xdf3:version"/>
											</td>
											<td>
												<xsl:value-of select="./xdf3:name"/>
											</td>
											<td>
												<xsl:value-of select="fn:replace(./xdf3:freitextRegel,'\n','&lt;br/&gt;')" disable-output-escaping="yes"/>
												<xsl:if test="$Meldungen = '1'">
													<xsl:variable name="regellistedoppelte">
														<xdf3:enthaltenebaukastenelemente>
															<xsl:analyze-string regex="[F|G]\d{{11}}" select="./xdf3:freitextRegel">
																<xsl:matching-substring>
																	<xdf3:elementid>
																		<xsl:value-of select="."/>
																	</xdf3:elementid>
																</xsl:matching-substring>
																<xsl:non-matching-substring>
																							</xsl:non-matching-substring>
															</xsl:analyze-string>
														</xdf3:enthaltenebaukastenelemente>
													</xsl:variable>
													<xsl:for-each-group select="$regellistedoppelte/*/xdf3:elementid" group-by=".">
														<xsl:sort/>
														<xsl:variable name="TestElement">
															<xsl:value-of select="."/>
														</xsl:variable>
														<xsl:if test="fn:not($Element//xdf3:identifikation[xdf3:id/text() = $TestElement])">
															<div class="Fehler E1001">Fehler!! E1001: Die Regel kann auf kein Baukastenelement mit der ID <xsl:value-of select="$TestElement"/> zugreifen.</div>
														</xsl:if>
													</xsl:for-each-group>
													<xsl:variable name="regellisteversionen">
														<xdf3:enthaltenebaukastenelemente>
															<xsl:analyze-string regex="[F|G]\d{{11}}V\d*\.\d*" select="./xdf3:freitextRegel">
																<xsl:matching-substring>
																	<xdf3:elementid>
																		<xsl:value-of select="."/>
																	</xdf3:elementid>
																</xsl:matching-substring>
																<xsl:non-matching-substring>
																							</xsl:non-matching-substring>
															</xsl:analyze-string>
														</xdf3:enthaltenebaukastenelemente>
													</xsl:variable>
													<xsl:for-each-group select="$regellisteversionen/*/xdf3:elementid" group-by=".">
														<xsl:sort/>
														<div class="Fehler E1019">Fehler!! E1019: Baukastenelemente, die in Regeln referenziert werden, d�rfen keine Versionsangaben beinhalten: <xsl:value-of select="."/>.</div>
													</xsl:for-each-group>
													<xsl:variable name="regellistealtesformat">
														<xdf3:enthaltenebaukastenelemente>
															<xsl:analyze-string regex="[F|G]\d{{8}}[^\d]" select="./xdf3:freitextRegel">
																<xsl:matching-substring>
																	<xdf3:elementid>
																		<xsl:value-of select="."/>
																	</xdf3:elementid>
																</xsl:matching-substring>
																<xsl:non-matching-substring>
																							</xsl:non-matching-substring>
															</xsl:analyze-string>
														</xdf3:enthaltenebaukastenelemente>
													</xsl:variable>
													<xsl:for-each-group select="$regellistealtesformat/*/xdf3:elementid" group-by=".">
														<xsl:sort/>
														<div class="Fehler E1041">Fehler!! E1041: Baukastenelemente, die in Regeln referenziert werden, verwenden noch die alte, verk�rzte Element-ID: <xsl:value-of select="fn:substring(.,1,9)"/>.</div>
													</xsl:for-each-group>
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
						<b>Verwendet in</b>
					</td>
					<xsl:variable name="FeldID" select="$Element/xdf3:identifikation/xdf3:id"/>
					<xsl:variable name="FeldVersion" select="$Element/xdf3:identifikation/xdf3:version"/>
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
									<xsl:when test="not($Element/xdf3:identifikation/xdf3:version)">
										<xsl:for-each-group select="//xdf3:datenfeldgruppe[xdf3:struktur/xdf3:enthaelt/xdf3:datenfeld/xdf3:identifikation/xdf3:id = $FeldID]" group-by="concat(xdf3:identifikation/xdf3:id,xdf3:identifikation/xdf3:version)">
											<xsl:sort select="./xdf3:identifikation/xdf3:id"/>
											<xsl:sort select="./xdf3:identifikation/xdf3:version"/>
											<xsl:variable name="Elternelement" select="."/>
											<xsl:for-each-group select="fn:current-group()/xdf3:struktur/xdf3:enthaelt/xdf3:datenfeld/xdf3:identifikation[xdf3:id = $FeldID and not(xdf3:version)]" group-by="string(xdf3:identifikation/xdf3:version)">
												<xsl:sort select="./xdf3:identifikation/xdf3:version"/>
												<xsl:call-template name="minielementcore">
													<xsl:with-param name="Element" select="$Elternelement"/>
												</xsl:call-template>
											</xsl:for-each-group>
										</xsl:for-each-group>
										<xsl:for-each-group select="//xdf3:stammdatenschema[xdf3:struktur/xdf3:enthaelt/xdf3:datenfeld/xdf3:identifikation/xdf3:id = $FeldID]" group-by="concat(xdf3:identifikation/xdf3:id,xdf3:identifikation/xdf3:version)">
											<xsl:sort select="./xdf3:identifikation/xdf3:id"/>
											<xsl:sort select="./xdf3:identifikation/xdf3:version"/>
											<xsl:variable name="Elternelement" select="."/>
											<xsl:for-each-group select="fn:current-group()/xdf3:struktur/xdf3:enthaelt/xdf3:datenfeld/xdf3:identifikation[xdf3:id = $FeldID and not(xdf3:version)]" group-by="string(xdf3:identifikation/xdf3:version)">
												<xsl:sort select="./xdf3:identifikation/xdf3:version"/>
												<xsl:call-template name="minielementcore">
													<xsl:with-param name="Element" select="$Elternelement"/>
												</xsl:call-template>
											</xsl:for-each-group>
										</xsl:for-each-group>
									</xsl:when>
									<xsl:otherwise>
										<xsl:for-each-group select="//xdf3:datenfeldgruppe[xdf3:struktur/xdf3:enthaelt/xdf3:datenfeld/xdf3:identifikation/xdf3:id = $FeldID]" group-by="concat(xdf3:identifikation/xdf3:id,xdf3:identifikation/xdf3:version)">
											<xsl:sort select="./xdf3:identifikation/xdf3:id"/>
											<xsl:sort select="./xdf3:identifikation/xdf3:version"/>
											<xsl:variable name="Elternelement" select="."/>
											<xsl:for-each-group select="fn:current-group()/xdf3:struktur/xdf3:enthaelt/xdf3:datenfeld/xdf3:identifikation[xdf3:id = $FeldID and xdf3:version = $FeldVersion]" group-by="string(xdf3:identifikation/xdf3:version)">
												<xsl:sort select="./xdf3:identifikation/xdf3:version"/>
												<xsl:call-template name="minielementcore">
													<xsl:with-param name="Element" select="$Elternelement"/>
												</xsl:call-template>
											</xsl:for-each-group>
										</xsl:for-each-group>
										<xsl:for-each-group select="//xdf3:stammdatenschema[xdf3:struktur/xdf3:enthaelt/xdf3:datenfeld/xdf3:identifikation/xdf3:id = $FeldID]" group-by="concat(xdf3:identifikation/xdf3:id,xdf3:identifikation/xdf3:version)">
											<xsl:sort select="./xdf3:identifikation/xdf3:id"/>
											<xsl:sort select="./xdf3:identifikation/xdf3:version"/>
											<xsl:variable name="Elternelement" select="."/>
											<xsl:for-each-group select="fn:current-group()/xdf3:struktur/xdf3:enthaelt/xdf3:datenfeld/xdf3:identifikation[xdf3:id = $FeldID and xdf3:version = $FeldVersion]" group-by="string(xdf3:identifikation/xdf3:version)">
												<xsl:sort select="./xdf3:identifikation/xdf3:version"/>
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
			<xsl:when test="$Element/name() = 'xdf3:datenfeldgruppe'">
				<tr>
					<td>
						<xsl:element name="a">
							<xsl:attribute name="name"><xsl:value-of select="$Element/xdf3:identifikation/xdf3:id"/><xsl:if test="$Element/xdf3:identifikation/xdf3:version">V<xsl:value-of select="$Element/xdf3:identifikation/xdf3:version"/></xsl:if></xsl:attribute>
						</xsl:element>
													ID
												</td>
					<xsl:choose>
						<xsl:when test="empty($Element/xdf3:identifikation/xdf3:id/text())">
							<td class="ElementID">
								<xsl:if test="$Meldungen = '1'">
									<div class="Fehler E1038">Fehler!! E1038: Die ID muss bef�llt werden.</div>
								</xsl:if>
							</td>
						</xsl:when>
						<xsl:otherwise>
							<td class="ElementID">
								<xsl:value-of select="$Element/xdf3:identifikation/xdf3:id"/>
								<xsl:analyze-string regex="^G\d{{11}}$" select="$Element/xdf3:identifikation/xdf3:id">
									<xsl:matching-substring>
										<xsl:if test="$ToolAufruf = '1'">
																		&#160;&#160;
																		<xsl:element name="a">
												<xsl:attribute name="href"><xsl:value-of select="$ToolPfadPrefix"/><xsl:value-of select="$Element/xdf3:identifikation/xdf3:id"/><xsl:if test="$Element/xdf3:identifikation/xdf3:version">V<xsl:value-of select="$Element/xdf3:identifikation/xdf3:version"/></xsl:if><xsl:value-of select="$ToolPfadPostfix"/></xsl:attribute>
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
								<xsl:value-of select="$Element/xdf3:identifikation/xdf3:version"/>
								<xsl:if test="$Meldungen = '1'">
									<div class="Fehler E1003">Fehler!! E1003: In einem Datenschema darf ein Baukastenelement nicht mehrfach in unterschiedlichen Versionen enthalten sein.</div>
								</xsl:if>
							</td>
						</xsl:when>
						<xsl:otherwise>
							<td>
								<xsl:value-of select="$Element/xdf3:identifikation/xdf3:version"/>
							</td>
						</xsl:otherwise>
					</xsl:choose>
				</tr>
				<tr>
					<td>Versionshinweis</td>
					<td>
						<xsl:value-of select="fn:replace($Element/xdf3:versionshinweis,'\n','&lt;br/&gt;')" disable-output-escaping="yes"/>
					</td>
				</tr>
				<tr>
					<td>Name</td>
					<xsl:choose>
						<xsl:when test="empty($Element/xdf3:name/text())">
							<td class="ElementName">
								<xsl:if test="$Meldungen = '1'">
									<div class="Fehler E1002">Fehler!! E1002: Der Name eines Elements ist nicht gesetzt.</div>
								</xsl:if>
							</td>
						</xsl:when>
						<xsl:otherwise>
							<td class="ElementName">
								<xsl:value-of select="$Element/xdf3:name"/>
							</td>
						</xsl:otherwise>
					</xsl:choose>
				</tr>
				<tr>
					<td>Stichworte</td>
					<td>
						<ul>
							<xsl:for-each select="$Element/xdf3:stichwort">
								<li>
									<xsl:value-of select="."/>
									<xsl:if test="./@uri">
																	(<xsl:value-of select="./@uri"/>)
																	<xsl:if test="$XRepoAufruf = '1' and substring(./@uri,1,4) = 'urn:'">
											<xsl:choose>
												<xsl:when test="fn:contains(./@uri, '_')">
																				&#160;&#160;
																				<xsl:element name="a">
														<xsl:attribute name="href"><xsl:value-of select="$DocXRepoMitVersionPfadPrefix"/><xsl:value-of select="./@uri"/><xsl:value-of select="$DocXRepoMitVersionPfadPostfix"/></xsl:attribute>
														<xsl:attribute name="target">XRepo</xsl:attribute>
														<xsl:attribute name="title">Springe in das XRepository.</xsl:attribute>
																					&#8658;
																				</xsl:element>
												</xsl:when>
												<xsl:otherwise>
																				&#160;&#160;
																				<xsl:element name="a">
														<xsl:attribute name="href"><xsl:value-of select="$DocXRepoOhneVersionPfadPrefix"/><xsl:value-of select="./@uri"/><xsl:value-of select="$DocXRepoOhneVersionPfadPostfix"/></xsl:attribute>
														<xsl:attribute name="target">XRepo</xsl:attribute>
														<xsl:attribute name="title">Springe in das XRepository.</xsl:attribute>
																					&#8658;
																				</xsl:element>
												</xsl:otherwise>
											</xsl:choose>
																		&#160;
																	</xsl:if>
									</xsl:if>
								</li>
							</xsl:for-each>
						</ul>
					</td>
				</tr>
				<tr>
					<td>Definition</td>
					<td>
						<xsl:value-of select="fn:replace($Element/xdf3:definition,'\n','&lt;br/&gt;')" disable-output-escaping="yes"/>
					</td>
				</tr>
				<tr>
					<td>Strukturelementart</td>
					<td>
						<xsl:apply-templates select="$Element/xdf3:schemaelementart"/>
					</td>
				</tr>
				<tr>
					<td>Gruppenart</td>
					<td>
						<xsl:apply-templates select="$Element/xdf3:art"/>
					</td>
				</tr>
				<tr>
					<td>Handlungsgrundlagen</td>
					<td>
						<xsl:choose>
							<xsl:when test="fn:count($Element/xdf3:bezug) = 0">
								<xsl:choose>
									<xsl:when test="$Element/xdf3:schemaelementart/code/text() = 'RNG'">
										<xsl:if test="$Meldungen = '1'">
											<div class="Fehler E1006">Fehler!! E1006: Der Bezug zur Handlungsgrundlage darf bei Elementen mit der Strukturelementart 'rechtsnormgebunden' nicht leer sein.</div>
										</xsl:if>
									</xsl:when>
									<xsl:when test="$Element/xdf3:schemaelementart/code/text() = 'HAR'">
										<xsl:if test="$Meldungen = '1'">
											<div class="Warnung W1001">Warnung!! W1001: Der Bezug zur Handlungsgrundlage sollte bei Elementen mit der Strukturelementart 'harmonisiert' m�glichst nicht leer sein.</div>
										</xsl:if>
									</xsl:when>
									<xsl:otherwise>
																</xsl:otherwise>
								</xsl:choose>
							</xsl:when>
							<xsl:when test="fn:count($Element/xdf3:bezug) = 1">
								<xsl:choose>
									<xsl:when test="$Element/xdf3:bezug/@link and not($Element/xdf3:bezug/@link='')">
										<xsl:choose>
											<xsl:when test="$HandlungsgrundlagenLinks = '1'">
												<xsl:element name="a">
													<xsl:attribute name="href"><xsl:value-of select="$Element/xdf3:bezug/@link"/></xsl:attribute>
													<xsl:attribute name="target">Handlungsgrundlage</xsl:attribute>
													<xsl:attribute name="title">Springe zum Text der Handlungsgrundlage.</xsl:attribute>
													<xsl:value-of select="$Element/xdf3:bezug"/>
												</xsl:element>
											</xsl:when>
											<xsl:otherwise>
												<xsl:value-of select="$Element/xdf3:bezug"/>
											</xsl:otherwise>
										</xsl:choose>
									</xsl:when>
									<xsl:otherwise>
										<xsl:value-of select="$Element/xdf3:bezug"/>
									</xsl:otherwise>
								</xsl:choose>
							</xsl:when>
							<xsl:otherwise>
								<ul>
									<xsl:for-each select="$Element/xdf3:bezug">
										<li>
											<xsl:choose>
												<xsl:when test="./@link and not(./@link='')">
													<xsl:choose>
														<xsl:when test="$HandlungsgrundlagenLinks = '1'">
															<xsl:element name="a">
																<xsl:attribute name="href"><xsl:value-of select="./@link"/></xsl:attribute>
																<xsl:attribute name="target">Handlungsgrundlage</xsl:attribute>
																<xsl:attribute name="title">Springe zum Text der Handlungsgrundlage.</xsl:attribute>
																<xsl:value-of select="."/>
															</xsl:element>
														</xsl:when>
														<xsl:otherwise>
															<xsl:value-of select="."/>
														</xsl:otherwise>
													</xsl:choose>
												</xsl:when>
												<xsl:otherwise>
													<xsl:value-of select="."/>
												</xsl:otherwise>
											</xsl:choose>
										</li>
									</xsl:for-each>
								</ul>
							</xsl:otherwise>
						</xsl:choose>
					</td>
				</tr>
				<tr>
					<td>Beschreibung</td>
					<td>
						<xsl:value-of select="fn:replace($Element/xdf3:beschreibung,'\n','&lt;br/&gt;')" disable-output-escaping="yes"/>
					</td>
				</tr>
				<tr>
					<td>Bezeichnung Eingabe</td>
					<xsl:choose>
						<xsl:when test="empty($Element/xdf3:bezeichnungEingabe/text())">
							<td>
								<xsl:if test="$Meldungen = '1'">
									<div class="Fehler E1009">Fehler!! E1009: Die Bezeichnung Eingabe muss bef�llt werden.</div>
								</xsl:if>
							</td>
						</xsl:when>
						<xsl:otherwise>
							<td>
								<xsl:value-of select="$Element/xdf3:bezeichnungEingabe"/>
							</td>
						</xsl:otherwise>
					</xsl:choose>
				</tr>
				<tr>
					<td>Bezeichnung Ausgabe</td>
					<xsl:choose>
						<xsl:when test="empty($Element/xdf3:bezeichnungAusgabe/text())">
							<td>
								<xsl:if test="$Meldungen = '1'">
									<div class="Fehler E1010">Fehler!! E1010: Die Bezeichnung Ausgabe muss bef�llt werden.</div>
								</xsl:if>
							</td>
						</xsl:when>
						<xsl:otherwise>
							<td>
								<xsl:value-of select="$Element/xdf3:bezeichnungAusgabe"/>
							</td>
						</xsl:otherwise>
					</xsl:choose>
				</tr>
				<tr>
					<td>Hilfetext Eingabe</td>
					<td>
						<xsl:value-of select="fn:replace($Element/xdf3:hilfetextEingabe,'\n','&lt;br/&gt;')" disable-output-escaping="yes"/>
					</td>
				</tr>
				<tr>
					<td>Hilfetext Ausgabe</td>
					<td>
						<xsl:value-of select="fn:replace($Element/xdf3:hilfetextAusgabe,'\n','&lt;br/&gt;')" disable-output-escaping="yes"/>
					</td>
				</tr>
				<tr>
					<td>G�ltig ab</td>
					<td>
						<xsl:value-of select="$Element/xdf3:gueltigAb"/>
					</td>
				</tr>
				<tr>
					<td>G�ltig bis</td>
					<td>
						<xsl:value-of select="$Element/xdf3:gueltigBis"/>
					</td>
				</tr>
				<tr>
					<td>Fachlicher Ersteller</td>
					<xsl:choose>
						<xsl:when test="empty($Element/xdf3:statusGesetztDurch/text()) and $VersionsHinweise ='1'">
							<td>
								<xsl:value-of select="$Element/xdf3:statusGesetztDurch"/>
								<xsl:if test="$Meldungen = '1'">
									<div class="Hinweis">Hinweis!! Das Feld 'Fachlicher Ersteller' darf zur Versionierung oder Ver�ffentlichung nicht leer sein.</div>
								</xsl:if>
							</td>
						</xsl:when>
						<xsl:otherwise>
							<td>
								<xsl:value-of select="$Element/xdf3:statusGesetztDurch"/>
							</td>
						</xsl:otherwise>
					</xsl:choose>
				</tr>
				<tr>
					<td>Status</td>
					<td>
						<xsl:apply-templates select="$Element/xdf3:freigabestatus"/>
					</td>
				</tr>
				<tr>
					<td>Status gesetzt am</td>
					<td>
						<xsl:value-of select="$Element/xdf3:statusGesetztAm"/>
					</td>
				</tr>
				<tr>
					<td>Ver�ffentlichungsdatum</td>
					<td>
						<xsl:value-of select="$Element/xdf3:veroeffentlichungsdatum"/>
					</td>
				</tr>
				<tr>
					<td>Letzte �nderung</td>
					<td>
						<xsl:value-of select="fn:format-dateTime($Element/xdf3:letzteAenderung,'[D01].[M01].[Y0001] um [H01]:[m01] Uhr')"/>
					</td>
				</tr>
				<tr>
					<td colspan="2">
						<h2/>
					</td>
				</tr>
				<xsl:if test="count($Element/xdf3:relation)">
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
									<xsl:for-each select="$Element/xdf3:relation">
										<tr>
											<td>
												<xsl:variable name="objID" select="./xdf3:objekt/xdf3:id"/>
												<xsl:variable name="objVersion" select="./xdf3:objekt/xdf3:version"/>
												<xsl:value-of select="./xdf3:objekt/xdf3:id"/>
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
															<div class="Fehler E1087">Fehler!! E1087: Relation zu einem unzul�ssigen Objekt.</div>
														</xsl:if>
													</xsl:matching-substring>
													<xsl:non-matching-substring>
														<xsl:if test="$Meldungen = '1'">
															<div class="Fehler E1039">Fehler!! E1039: Die ID entspricht nicht den Formatvorgaben.</div>
														</xsl:if>
													</xsl:non-matching-substring>
												</xsl:analyze-string>
											</td>
											<td>
												<xsl:value-of select="./xdf3:objekt/xdf3:version"/>
											</td>
											<td>
												<xsl:apply-templates select="./xdf3:praedikat"/>
												<xsl:if test="$Meldungen = '1' and ./xdf3:praedikat = 'VKN'">
													<div class="Fehler E1088">Fehler!! E1088: Diese Relation darf in diesem Objekt nicht verwendet werden.</div>
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
					<xsl:variable name="AnzahlUnterelemente" select="count($Element/xdf3:struktur)"/>
					<td>
						<b>Unterelemente</b>
						<xsl:choose>
							<xsl:when test="$Element/xdf3:art/code = 'X'">
								<br/>in <b>Auswahlgruppe</b>
								<xsl:if test="$AnzahlUnterelemente = 1 and $Meldungen = '1'">
									<div class="Fehler E1043">Fehler!! E1043: Eine Auswahlgruppe muss mindestens zwei Unterelemente haben.</div>
								</xsl:if>
							</xsl:when>
							<xsl:otherwise>
								<xsl:if test="$AnzahlUnterelemente = 1 and $Meldungen = '1'">
									<div class="Warnung W1006">Warnung!! W1006: Eine Datenfeldgruppe sollte mehr als ein Unterelement haben.</div>
								</xsl:if>
							</xsl:otherwise>
						</xsl:choose>
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
											<th>Multiplizit�t</th>
											<th>Handlungsgrundlagen</th>
										</tr>
									</thead>
									<tbody>
										<xsl:variable name="Strukturelementart">
											<xsl:value-of select="./xdf3:schemaelementart/code"/>
										</xsl:variable>
										<xsl:for-each select="$Element/xdf3:struktur">
											<xsl:variable name="VergleichsElement">
												<xsl:value-of select="./xdf3:enthaelt/*/xdf3:identifikation/xdf3:id"/>
											</xsl:variable>
											<xsl:variable name="VergleichsVersion">
												<xsl:value-of select="./xdf3:enthaelt/*/xdf3:identifikation/xdf3:version"/>
											</xsl:variable>
											<tr>
												<td>
													<xsl:choose>
														<xsl:when test="empty(./xdf3:enthaelt/*/xdf3:identifikation/xdf3:id/text())">
															<xsl:if test="$Meldungen = '1'">
																<div class="Fehler E1038">Fehler!! E1038: Die ID muss bef�llt werden.</div>
															</xsl:if>
														</xsl:when>
														<xsl:otherwise>
															<xsl:choose>
																<xsl:when test="$InterneLinks = '1'">
																	<xsl:element name="a">
																		<xsl:attribute name="href">#<xsl:value-of select="./xdf3:enthaelt/*/xdf3:identifikation/xdf3:id"/><xsl:if test="./xdf3:enthaelt/*/xdf3:identifikation/xdf3:version">V<xsl:value-of select="./xdf3:enthaelt/*/xdf3:identifikation/xdf3:version"/></xsl:if></xsl:attribute>
																		<xsl:value-of select="./xdf3:enthaelt/*/xdf3:identifikation/xdf3:id"/>
																	</xsl:element>
																</xsl:when>
																<xsl:otherwise>
																	<xsl:value-of select="./xdf3:enthaelt/*/xdf3:identifikation/xdf3:id"/>
																</xsl:otherwise>
															</xsl:choose>
														</xsl:otherwise>
													</xsl:choose>
													<xsl:choose>
														<xsl:when test="$VergleichsVersion = ''">
															<xsl:if test="count($Element/xdf3:struktur/./xdf3:enthaelt/*/xdf3:identifikation[xdf3:id=$VergleichsElement and not(xdf3:version)]) &gt; 1">
																<xsl:if test="$Meldungen = '1'">
																	<div class="Fehler E1004">Fehler!! E1004: In einer Datenfeldgruppe darf ein Baukastenelement nicht mehrfach in derselben Version enthalten sein.</div>
																</xsl:if>
															</xsl:if>
														</xsl:when>
														<xsl:otherwise>
															<xsl:if test="count($Element/xdf3:struktur/./xdf3:enthaelt/*/xdf3:identifikation[xdf3:id=$VergleichsElement and xdf3:version=$VergleichsVersion]) &gt; 1">
																<xsl:if test="$Meldungen = '1'">
																	<div class="Fehler E1004">Fehler!! E1004: In einer Datenfeldgruppe darf ein Baukastenelement nicht mehrfach in derselben Version enthalten sein.</div>
																</xsl:if>
															</xsl:if>
														</xsl:otherwise>
													</xsl:choose>
													<xsl:if test="$Meldungen = '1' and ./xdf3:enthaelt/*/name() = 'xdf3:datenfeldgruppe'">
														<!-- Zirkelbezug E1026 -->
														<xsl:if test="count(.//xdf3:enthaelt/xdf3:datenfeldgruppe[xdf3:identifikation/xdf3:id = $Element/xdf3:identifikation/xdf3:id and xdf3:identifikation/xdf3:version = $Element/xdf3:identifikation/xdf3:version]) &gt; 0">
															<xsl:if test="$Meldungen = '1'">
																<div class="Fehler E1026">Fehler!! E1026: Zirkelbezug</div>
															</xsl:if>
														</xsl:if>
													</xsl:if>
												</td>
												<td>
													<xsl:choose>
														<xsl:when test="empty(./xdf3:enthaelt/*/xdf3:identifikation/xdf3:version/text()) and $VersionsHinweise ='1'">
															<xsl:value-of select="./xdf3:enthaelt/*/xdf3:identifikation/xdf3:version"/>
															<xsl:if test="$Meldungen = '1'">
																<div class="Hinweis">Hinweis!! Zur Versionierung und Ver�ffentlichung m�ssen alle verwendete Unterelemente versioniert sein.</div>
															</xsl:if>
														</xsl:when>
														<xsl:otherwise>
															<xsl:value-of select="./xdf3:enthaelt/*/xdf3:identifikation/xdf3:version"/>
														</xsl:otherwise>
													</xsl:choose>
												</td>
												<td>
													<xsl:value-of select="./xdf3:enthaelt/*/xdf3:name"/>
												</td>
												<td>
													<xsl:value-of select="./xdf3:enthaelt/*/xdf3:bezeichnungEingabe"/>
												</td>
												<td>
													<xsl:choose>
														<xsl:when test="./xdf3:enthaelt/*/xdf3:schemaelementart/code/text() = 'ABS' and $AbstraktWarnung = '1'">
															<xsl:apply-templates select="./xdf3:enthaelt/*/xdf3:schemaelementart"/>
															<xsl:if test="$Meldungen = '1'">
																<div class="Fehler E1013">Fehler!! E1013: Innerhalb von Datenschemata und Datenfeldgruppen d�rfen nur Elemente mit der Strukturelementart 'harmonisiert' oder 'rechtnormgebunden' verwendet werden.</div>
															</xsl:if>
														</xsl:when>
														<xsl:otherwise>
															<xsl:apply-templates select="./xdf3:enthaelt/*/xdf3:schemaelementart"/>
														</xsl:otherwise>
													</xsl:choose>
												</td>
												<td>
													<xsl:choose>
														<xsl:when test="./xdf3:enthaelt/*/xdf3:freigabestatus/code/text() = '7'">
															<xsl:apply-templates select="./xdf3:enthaelt/*/xdf3:freigabestatus"/>
															<xsl:if test="$Meldungen = '1'">
																<div class="Warnung W1016">Warnung!! W1016: Baukastenelemente im Status 'inaktiv' sollten nur in Ausnahmef�llen verwendet werden.</div>
															</xsl:if>
														</xsl:when>
														<xsl:otherwise>
															<xsl:apply-templates select="./xdf3:enthaelt/*/xdf3:freigabestatus"/>
														</xsl:otherwise>
													</xsl:choose>
												</td>
												<td>
													<xsl:choose>
														<xsl:when test="$Meldungen = '1'">
															<xsl:value-of select="./xdf3:anzahl"/>
															<xsl:variable name="AnzahlText" select="./xdf3:anzahl/text()"/>
															<xsl:variable name="minCount" select="fn:substring-before(./xdf3:anzahl/text(),':')"/>
															<xsl:variable name="maxCount" select="fn:substring-after(./xdf3:anzahl/text(),':')"/>
															<xsl:analyze-string regex="^\d{{1,}}:[\d{{1,}}|*]$" select="./xdf3:anzahl">
																<xsl:matching-substring>
																	<xsl:if test="$AnzahlText = '0:0'">
																		<div class="Fehler E1021">Fehler!! E1021: Es ist keine Multiplizit�t angegeben.</div>
																	</xsl:if>
																	<xsl:if test="(fn:number($minCount) &gt; fn:number($maxCount)) and $maxCount != '*'">
																		<div class="Fehler E1047">Fehler!! E1047: In der Multiplizit�t muss die minimale Anzahl kleiner oder gleich der maximalen Anzahl sein.</div>
																	</xsl:if>
																</xsl:matching-substring>
																<xsl:non-matching-substring>
																	<xsl:if test="$Meldungen = '1'">
																		<div class="Fehler E1046">Fehler!! E1046: Die Multiplizit�t entspricht nicht den Formatvorgaben.</div>
																	</xsl:if>
																</xsl:non-matching-substring>
															</xsl:analyze-string>
														</xsl:when>
														<xsl:otherwise>
															<xsl:value-of select="./xdf3:anzahl"/>
														</xsl:otherwise>
													</xsl:choose>
												</td>
												<td>
													<xsl:choose>
														<xsl:when test="empty(./xdf3:bezug/text())">
															<xsl:choose>
																<xsl:when test="$Strukturelementart ='RNG' and (./xdf3:enthaelt/*/xdf3:schemaelementart/code/text() = 'ABS' or ./xdf3:enthaelt/*/xdf3:schemaelementart/code/text() = 'HAR')">
																	<xsl:if test="$Meldungen = '1'">
																		<div class="Fehler E1022">Fehler!! E1022: Bei Verwendung von Elementen mit der Strukturelementart 'harmonisiert' innerhalb von Datenfeldgruppen mit der Strukturelementart 'rechtsnormgebunden' muss zur Multiplizit�t ein Bezug zu einer Handlungsgrundlage angegeben werden.</div>
																	</xsl:if>
																</xsl:when>
																<xsl:otherwise>
																</xsl:otherwise>
															</xsl:choose>
														</xsl:when>
														<xsl:when test="fn:count(./xdf3:bezug) = 1">
															<xsl:choose>
																<xsl:when test="./xdf3:bezug/@link and not(./xdf3:bezug/@link='')">
																	<xsl:choose>
																		<xsl:when test="$HandlungsgrundlagenLinks = '1'">
																			<xsl:element name="a">
																				<xsl:attribute name="href"><xsl:value-of select="./xdf3:bezug/@link"/></xsl:attribute>
																				<xsl:attribute name="target">Handlungsgrundlage</xsl:attribute>
																				<xsl:attribute name="title">Springe zum Text der Handlungsgrundlage.</xsl:attribute>
																				<xsl:value-of select="./xdf3:bezug"/>
																			</xsl:element>
																		</xsl:when>
																		<xsl:otherwise>
																			<xsl:value-of select="./xdf3:bezug"/>
																		</xsl:otherwise>
																	</xsl:choose>
																</xsl:when>
																<xsl:otherwise>
																	<xsl:value-of select="./xdf3:bezug"/>
																</xsl:otherwise>
															</xsl:choose>
														</xsl:when>
														<xsl:otherwise>
															<xsl:for-each select="./xdf3:bezug">
																<xsl:choose>
																	<xsl:when test="./@link and not(./@link='')">
																		<xsl:choose>
																			<xsl:when test="$HandlungsgrundlagenLinks = '1'">
																				<xsl:element name="a">
																					<xsl:attribute name="href"><xsl:value-of select="./@link"/></xsl:attribute>
																					<xsl:attribute name="target">Handlungsgrundlage</xsl:attribute>
																					<xsl:attribute name="title">Springe zum Text der Handlungsgrundlage.</xsl:attribute>
																					<xsl:value-of select="."/>
																				</xsl:element>
																			</xsl:when>
																			<xsl:otherwise>
																				<xsl:value-of select="."/>
																			</xsl:otherwise>
																		</xsl:choose>
																	</xsl:when>
																	<xsl:otherwise>
																		<xsl:value-of select="."/>
																	</xsl:otherwise>
																</xsl:choose>
																<xsl:if test="fn:position() != fn:last()">
																	<xsl:text>; </xsl:text>
																</xsl:if>
															</xsl:for-each>
														</xsl:otherwise>
													</xsl:choose>
												</td>
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
				<tr>
					<td colspan="2">
						<h2/>
					</td>
				</tr>
				<xsl:if test="count($Element/xdf3:regel)">
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
										<th>Freitextregel</th>
									</tr>
								</thead>
								<tbody>
									<xsl:for-each select="$Element/xdf3:regel">
										<tr>
											<td>
												<xsl:choose>
													<xsl:when test="$InterneLinks = '1'">
														<xsl:element name="a">
															<xsl:attribute name="href">#<xsl:value-of select="./xdf3:identifikation/xdf3:id"/><xsl:if test="./xdf3:identifikation/xdf3:version">V<xsl:value-of select="./xdf3:identifikation/xdf3:version"/></xsl:if></xsl:attribute>
															<xsl:value-of select="./xdf3:identifikation/xdf3:id"/>
														</xsl:element>
													</xsl:when>
													<xsl:otherwise>
														<xsl:value-of select="./xdf3:identifikation/xdf3:id"/>
													</xsl:otherwise>
												</xsl:choose>
											</td>
											<td>
												<xsl:value-of select="./xdf3:identifikation/xdf3:version"/>
											</td>
											<td>
												<xsl:value-of select="./xdf3:name"/>
											</td>
											<td>
												<xsl:value-of select="fn:replace(./xdf3:freitextRegel,'\n','&lt;br/&gt;')" disable-output-escaping="yes"/>
												<xsl:if test="$Meldungen = '1'">
													<xsl:variable name="regellistedoppelte">
														<xdf3:enthaltenebaukastenelemente>
															<xsl:analyze-string regex="[F|G]\d{{11}}" select="./xdf3:freitextRegel">
																<xsl:matching-substring>
																	<xdf3:elementid>
																		<xsl:value-of select="."/>
																	</xdf3:elementid>
																</xsl:matching-substring>
																<xsl:non-matching-substring>
																							</xsl:non-matching-substring>
															</xsl:analyze-string>
														</xdf3:enthaltenebaukastenelemente>
													</xsl:variable>
													<xsl:for-each-group select="$regellistedoppelte/*/xdf3:elementid" group-by=".">
														<xsl:sort/>
														<xsl:variable name="TestElement">
															<xsl:value-of select="."/>
														</xsl:variable>
														<xsl:if test="fn:not($Element//xdf3:identifikation[xdf3:id/text() = $TestElement])">
															<div class="Fehler E1001">Fehler!! E1001: Die Regel kann auf kein Baukastenelement mit der ID <xsl:value-of select="$TestElement"/> zugreifen.</div>
														</xsl:if>
													</xsl:for-each-group>
													<xsl:variable name="regellisteversionen">
														<xdf3:enthaltenebaukastenelemente>
															<xsl:analyze-string regex="[F|G]\d{{11}}V\d*\.\d*" select="./xdf3:freitextRegel">
																<xsl:matching-substring>
																	<xdf3:elementid>
																		<xsl:value-of select="."/>
																	</xdf3:elementid>
																</xsl:matching-substring>
																<xsl:non-matching-substring>
																							</xsl:non-matching-substring>
															</xsl:analyze-string>
														</xdf3:enthaltenebaukastenelemente>
													</xsl:variable>
													<xsl:for-each-group select="$regellisteversionen/*/xdf3:elementid" group-by=".">
														<xsl:sort/>
														<div class="Fehler E1019">Fehler!! E1019: Baukastenelemente, die in Regeln referenziert werden, d�rfen keine Versionsangaben beinhalten: <xsl:value-of select="."/>.</div>
													</xsl:for-each-group>
													<xsl:variable name="regellistealtesformat">
														<xdf3:enthaltenebaukastenelemente>
															<xsl:analyze-string regex="[F|G]\d{{8}}[^\d]" select="./xdf3:freitextRegel">
																<xsl:matching-substring>
																	<xdf3:elementid>
																		<xsl:value-of select="."/>
																	</xdf3:elementid>
																</xsl:matching-substring>
																<xsl:non-matching-substring>
																</xsl:non-matching-substring>
															</xsl:analyze-string>
														</xdf3:enthaltenebaukastenelemente>
													</xsl:variable>
													<xsl:for-each-group select="$regellistealtesformat/*/xdf3:elementid" group-by=".">
														<xsl:sort/>
														<div class="Fehler E1041">Fehler!! E1041: Baukastenelemente, die in Regeln referenziert werden, verwenden noch die alte, verk�rzte Element-ID: <xsl:value-of select="fn:substring(.,1,9)"/>.</div>
													</xsl:for-each-group>
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
																	<xsl:variable name="RelationID" select="./xdf3:id"/>
																	<xsl:variable name="Element">
																		<xsl:copy-of select="$Daten/*/Formularfelder/Formularfeld[Id = $RelationID]"/>
																		<xsl:copy-of select="$Daten/*/Formularfeldgruppen/Formularfeldgruppe[Id = $RelationID]"/>
																	</xsl:variable>
																	<tr>
																		<td>
																			<xsl:element name="a">
																				<xsl:attribute name="href">#<xsl:value-of select="./xdf3:id"/></xsl:attribute>
																				<xsl:value-of select="./xdf3:id"/>
																			</xsl:element>
																		</td>
																		<td>
																			<xsl:value-of select="$Element/*/xdf3:version"/>
																		</td>
																		<td>
																			<xsl:value-of select="$Element/*/xdf3:name"/>
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
					<xsl:variable name="FeldgruppenID" select="$Element/xdf3:identifikation/xdf3:id"/>
					<xsl:variable name="FeldgruppenVersion" select="$Element/xdf3:identifikation/xdf3:version"/>
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
									<xsl:when test="not($Element/xdf3:identifikation/xdf3:version)">
										<xsl:for-each-group select="//xdf3:datenfeldgruppe[xdf3:struktur/xdf3:enthaelt/xdf3:datenfeldgruppe/xdf3:identifikation/xdf3:id = $FeldgruppenID]" group-by="concat(xdf3:identifikation/xdf3:id,xdf3:identifikation/xdf3:version)">
											<xsl:sort select="./xdf3:identifikation/xdf3:id"/>
											<xsl:sort select="./xdf3:identifikation/xdf3:version"/>
											<xsl:variable name="Elternelement" select="."/>
											<xsl:for-each-group select="fn:current-group()/xdf3:struktur/xdf3:enthaelt/xdf3:datenfeldgruppe/xdf3:identifikation[xdf3:id = $FeldgruppenID and not(xdf3:version)]" group-by="string(xdf3:identifikation/xdf3:version)">
												<xsl:sort select="./xdf3:identifikation/xdf3:version"/>
												<xsl:if test="current-grouping-key()=''">
													<xsl:call-template name="minielementcore">
														<xsl:with-param name="Element" select="$Elternelement"/>
													</xsl:call-template>
												</xsl:if>
											</xsl:for-each-group>
										</xsl:for-each-group>
										<xsl:for-each-group select="//xdf3:stammdatenschema[xdf3:struktur/xdf3:enthaelt/xdf3:datenfeldgruppe/xdf3:identifikation/xdf3:id = $FeldgruppenID]" group-by="concat(xdf3:identifikation/xdf3:id,xdf3:identifikation/xdf3:version)">
											<xsl:sort select="./xdf3:identifikation/xdf3:id"/>
											<xsl:sort select="./xdf3:identifikation/xdf3:version"/>
											<xsl:variable name="Elternelement" select="."/>
											<xsl:for-each-group select="fn:current-group()/xdf3:struktur/xdf3:enthaelt/xdf3:datenfeldgruppe/xdf3:identifikation[xdf3:id = $FeldgruppenID and not(xdf3:version)]" group-by="string(xdf3:identifikation/xdf3:version)">
												<xsl:sort select="./xdf3:identifikation/xdf3:version"/>
												<xsl:if test="current-grouping-key()=''">
													<xsl:call-template name="minielementcore">
														<xsl:with-param name="Element" select="$Elternelement"/>
													</xsl:call-template>
												</xsl:if>
											</xsl:for-each-group>
										</xsl:for-each-group>
									</xsl:when>
									<xsl:otherwise>
										<xsl:for-each-group select="//xdf3:datenfeldgruppe[xdf3:struktur/xdf3:enthaelt/xdf3:datenfeldgruppe/xdf3:identifikation/xdf3:id = $FeldgruppenID]" group-by="concat(xdf3:identifikation/xdf3:id,xdf3:identifikation/xdf3:version)">
											<xsl:sort select="./xdf3:identifikation/xdf3:id"/>
											<xsl:sort select="./xdf3:identifikation/xdf3:version"/>
											<xsl:variable name="Elternelement" select="."/>
											<xsl:for-each-group select="fn:current-group()/xdf3:struktur/xdf3:enthaelt/xdf3:datenfeldgruppe/xdf3:identifikation[xdf3:id = $FeldgruppenID and xdf3:version=$FeldgruppenVersion]" group-by="string(xdf3:identifikation/xdf3:version)">
												<xsl:sort select="./xdf3:identifikation/xdf3:version"/>
												<xsl:call-template name="minielementcore">
													<xsl:with-param name="Element" select="$Elternelement"/>
												</xsl:call-template>
											</xsl:for-each-group>
										</xsl:for-each-group>
										<xsl:for-each-group select="//xdf3:stammdatenschema[xdf3:struktur/xdf3:enthaelt/xdf3:datenfeldgruppe/xdf3:identifikation/xdf3:id = $FeldgruppenID]" group-by="concat(xdf3:identifikation/xdf3:id,xdf3:identifikation/xdf3:version)">
											<xsl:sort select="./xdf3:identifikation/xdf3:id"/>
											<xsl:sort select="./xdf3:identifikation/xdf3:version"/>
											<xsl:variable name="Elternelement" select="."/>
											<xsl:for-each-group select="fn:current-group()/xdf3:struktur/xdf3:enthaelt/xdf3:datenfeldgruppe/xdf3:identifikation[xdf3:id = $FeldgruppenID and xdf3:version=$FeldgruppenVersion]" group-by="string(xdf3:identifikation/xdf3:version)">
												<xsl:sort select="./xdf3:identifikation/xdf3:version"/>
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
			<a name="RegelDetails"/>Details zu den Regeln des Datenschemas <xsl:value-of select="/*/xdf3:stammdatenschema/xdf3:identifikation/xdf3:id"/>
			<xsl:if test="/*/xdf3:stammdatenschema/xdf3:identifikation/xdf3:version"> Version <xsl:value-of select="/*/xdf3:stammdatenschema/xdf3:identifikation/xdf3:version"/>
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
				<xsl:for-each-group select="//xdf3:regel" group-by="xdf3:identifikation/xdf3:id">
					<xsl:sort select="./xdf3:identifikation/xdf3:id"/>
					<xsl:for-each-group select="fn:current-group()" group-by="string(xdf3:identifikation/xdf3:version)">
						<xsl:sort select="./xdf3:identifikation/xdf3:version"/>
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
				-------- <xsl:value-of select="$Element/xdf3:identifikation/xdf3:id"/>
				<xsl:if test="$Element/xdf3:identifikation/xdf3:version">V<xsl:value-of select="$Element/xdf3:identifikation/xdf3:version"/>
				</xsl:if> --------
			</xsl:message>
		</xsl:if>
		<tr>
			<td>
				<xsl:element name="a">
					<xsl:attribute name="name"><xsl:value-of select="$Element/xdf3:identifikation/xdf3:id"/><xsl:if test="$Element/xdf3:identifikation/xdf3:version">V<xsl:value-of select="$Element/xdf3:identifikation/xdf3:version"/></xsl:if></xsl:attribute>
				</xsl:element>
										ID
									</td>
			<xsl:choose>
				<xsl:when test="empty($Element/xdf3:identifikation/xdf3:id/text())">
					<td class="RegelID">
						<xsl:if test="$Meldungen = '1'">
							<div class="Fehler E1038">Fehler!! E1038: Die ID muss bef�llt werden.</div>
						</xsl:if>
					</td>
				</xsl:when>
				<xsl:otherwise>
					<td class="RegelID">
						<xsl:value-of select="$Element/xdf3:identifikation/xdf3:id"/>
						<xsl:analyze-string regex="^R\d{{11}}$" select="$Element/xdf3:identifikation/xdf3:id">
							<xsl:matching-substring>
								<xsl:if test="$ToolAufruf = '1'">
															&#160;&#160;
															<xsl:element name="a">
										<xsl:attribute name="href"><xsl:value-of select="$ToolPfadPrefix"/><xsl:value-of select="$Element/xdf3:identifikation/xdf3:id"/><xsl:if test="$Element/xdf3:identifikation/xdf3:version">V<xsl:value-of select="$Element/xdf3:identifikation/xdf3:version"/></xsl:if><xsl:value-of select="$ToolPfadPostfix"/></xsl:attribute>
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
		<!--
								<tr>
									<td>Version</td>
									<td>
										<xsl:value-of select="$Element/xdf3:identifikation/xdf3:version"/>
									</td>
								</tr>
								-->
		<tr>
			<td>Name</td>
			<xsl:choose>
				<xsl:when test="empty($Element/xdf3:name/text())">
					<td>
						<xsl:if test="$Meldungen = '1'">
							<div class="Fehler E1002">Fehler!! E1002: Der Name eines Elements ist nicht gesetzt.</div>
						</xsl:if>
					</td>
				</xsl:when>
				<xsl:otherwise>
					<td class="RegelName">
						<xsl:value-of select="$Element/xdf3:name"/>
					</td>
				</xsl:otherwise>
			</xsl:choose>
		</tr>
		<tr>
			<td>Stichworte</td>
			<td>
				<ul>
					<xsl:for-each select="$Element/xdf3:stichwort">
						<li>
							<xsl:value-of select="."/>
							<xsl:if test="./@uri">
															(<xsl:value-of select="./@uri"/>)
															<xsl:if test="$XRepoAufruf = '1' and substring(./@uri,1,4) = 'urn:'">
									<xsl:choose>
										<xsl:when test="fn:contains(./@uri, '_')">
																		&#160;&#160;
																		<xsl:element name="a">
												<xsl:attribute name="href"><xsl:value-of select="$DocXRepoMitVersionPfadPrefix"/><xsl:value-of select="./@uri"/><xsl:value-of select="$DocXRepoMitVersionPfadPostfix"/></xsl:attribute>
												<xsl:attribute name="target">XRepo</xsl:attribute>
												<xsl:attribute name="title">Springe in das XRepository.</xsl:attribute>
																			&#8658;
																		</xsl:element>
										</xsl:when>
										<xsl:otherwise>
																		&#160;&#160;
																		<xsl:element name="a">
												<xsl:attribute name="href"><xsl:value-of select="$DocXRepoOhneVersionPfadPrefix"/><xsl:value-of select="./@uri"/><xsl:value-of select="$DocXRepoOhneVersionPfadPostfix"/></xsl:attribute>
												<xsl:attribute name="target">XRepo</xsl:attribute>
												<xsl:attribute name="title">Springe in das XRepository.</xsl:attribute>
																			&#8658;
																		</xsl:element>
										</xsl:otherwise>
									</xsl:choose>
																&#160;
															</xsl:if>
							</xsl:if>
						</li>
					</xsl:for-each>
				</ul>
			</td>
		</tr>
		<tr>
			<td>Freitextregel</td>
			<xsl:choose>
				<xsl:when test="empty($Element/xdf3:freitextRegel/text())">
					<td>
						<xsl:if test="$Meldungen = '1'">
							<div class="Fehler E1024">Fehler!! E1024: Die Freitextregel muss bef�llt sein.</div>
						</xsl:if>
					</td>
				</xsl:when>
				<xsl:otherwise>
					<td>
						<xsl:value-of select="fn:replace($Element/xdf3:freitextRegel,'\n','&lt;br/&gt;')" disable-output-escaping="yes"/>
					</td>
				</xsl:otherwise>
			</xsl:choose>
		</tr>
		<tr>
			<td>Script</td>
			<xsl:choose>
				<xsl:when test="string-length($Element/xdf3:script) &lt; 25">
					<td>
						<xsl:value-of select="$Element/xdf3:script"/>
						<!-- <xsl:if test="$Meldungen = '1'"><div class="Warnung W1004">Warnung!! W1004: Script nicht definiert</div></xsl:if> -->
					</td>
				</xsl:when>
				<xsl:otherwise>
					<td>
						<xsl:value-of select="$Element/xdf3:script"/>
					</td>
				</xsl:otherwise>
			</xsl:choose>
		</tr>
		<tr>
			<td>Beschreibung</td>
			<td>
				<xsl:value-of select="fn:replace($Element/xdf3:beschreibung,'\n','&lt;br/&gt;')" disable-output-escaping="yes"/>
			</td>
		</tr>
		<tr>
			<td>Handlungsgrundlagen</td>
			<td>
				<xsl:choose>
					<xsl:when test="fn:count($Element/xdf3:bezug) = 0">
											</xsl:when>
					<xsl:when test="fn:count($Element/xdf3:bezug) = 1">
						<xsl:choose>
							<xsl:when test="$Element/xdf3:bezug/@link and not($Element/xdf3:bezug/@link='')">
								<xsl:choose>
									<xsl:when test="$HandlungsgrundlagenLinks = '1'">
										<xsl:element name="a">
											<xsl:attribute name="href"><xsl:value-of select="$Element/xdf3:bezug/@link"/></xsl:attribute>
											<xsl:attribute name="target">Handlungsgrundlage</xsl:attribute>
											<xsl:attribute name="title">Springe zum Text der Handlungsgrundlage.</xsl:attribute>
											<xsl:value-of select="$Element/xdf3:bezug"/>
										</xsl:element>
									</xsl:when>
									<xsl:otherwise>
										<xsl:value-of select="$Element/xdf3:bezug"/>
									</xsl:otherwise>
								</xsl:choose>
							</xsl:when>
							<xsl:otherwise>
								<xsl:value-of select="$Element/xdf3:bezug"/>
							</xsl:otherwise>
						</xsl:choose>
					</xsl:when>
					<xsl:otherwise>
						<ul>
							<xsl:for-each select="$Element/xdf3:bezug">
								<li>
									<xsl:choose>
										<xsl:when test="./@link and not(./@link='')">
											<xsl:choose>
												<xsl:when test="$HandlungsgrundlagenLinks = '1'">
													<xsl:element name="a">
														<xsl:attribute name="href"><xsl:value-of select="./@link"/></xsl:attribute>
														<xsl:attribute name="target">Handlungsgrundlage</xsl:attribute>
														<xsl:attribute name="title">Springe zum Text der Handlungsgrundlage.</xsl:attribute>
														<xsl:value-of select="."/>
													</xsl:element>
												</xsl:when>
												<xsl:otherwise>
													<xsl:value-of select="."/>
												</xsl:otherwise>
											</xsl:choose>
										</xsl:when>
										<xsl:otherwise>
											<xsl:value-of select="."/>
										</xsl:otherwise>
									</xsl:choose>
								</li>
							</xsl:for-each>
						</ul>
					</xsl:otherwise>
				</xsl:choose>
			</td>
		</tr>
		<tr>
			<td>Fachlicher Ersteller</td>
			<xsl:choose>
				<xsl:when test="empty($Element/xdf3:fachlicherErsteller/text()) and $VersionsHinweise ='1'">
					<td>
						<xsl:value-of select="$Element/xdf3:fachlicherErsteller"/>
						<xsl:if test="$Meldungen = '1'">
							<div class="Hinweis">Hinweis!! Das Feld 'Fachlicher Ersteller' darf zur Versionierung oder Ver�ffentlichung nicht leer sein.</div>
						</xsl:if>
					</td>
				</xsl:when>
				<xsl:otherwise>
					<td>
						<xsl:value-of select="$Element/xdf3:fachlicherErsteller"/>
					</td>
				</xsl:otherwise>
			</xsl:choose>
		</tr>
		<tr>
			<td>Letzte �nderung</td>
			<td>
				<xsl:value-of select="fn:format-dateTime($Element/xdf3:letzteAenderung,'[D01].[M01].[Y0001] um [H01]:[m01] Uhr')"/>
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
									<td>Zeitpunkt der letzten �nderung</td>
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
			<xsl:variable name="RegelID" select="$Element/xdf3:identifikation/xdf3:id"/>
			<xsl:variable name="RegelVersion" select="$Element/xdf3:identifikation/xdf3:version"/>
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
							<xsl:when test="not($Element/xdf3:identifikation/xdf3:version)">
								<xsl:for-each-group select="//xdf3:datenfeld[xdf3:regel/xdf3:identifikation/xdf3:id = $RegelID]" group-by="xdf3:identifikation/xdf3:id">
									<xsl:sort select="./xdf3:identifikation/xdf3:id"/>
									<xsl:for-each-group select="fn:current-group()" group-by="string(xdf3:identifikation/xdf3:version)">
										<xsl:sort select="./xdf3:identifikation/xdf3:version"/>
										<xsl:if test="current-grouping-key()=''">
											<xsl:call-template name="minielementcore">
												<xsl:with-param name="Element" select="."/>
											</xsl:call-template>
										</xsl:if>
									</xsl:for-each-group>
								</xsl:for-each-group>
								<xsl:for-each-group select="//xdf3:datenfeldgruppe[xdf3:regel/xdf3:identifikation/xdf3:id = $RegelID]" group-by="xdf3:identifikation/xdf3:id">
									<xsl:sort select="./xdf3:identifikation/xdf3:id"/>
									<xsl:for-each-group select="fn:current-group()" group-by="string(xdf3:identifikation/xdf3:version)">
										<xsl:sort select="./xdf3:identifikation/xdf3:version"/>
										<xsl:if test="current-grouping-key()=''">
											<xsl:call-template name="minielementcore">
												<xsl:with-param name="Element" select="."/>
											</xsl:call-template>
										</xsl:if>
									</xsl:for-each-group>
								</xsl:for-each-group>
								<xsl:for-each-group select="//xdf3:stammdatenschema[xdf3:regel/xdf3:identifikation/xdf3:id = $RegelID]" group-by="xdf3:identifikation/xdf3:id">
									<xsl:sort select="./xdf3:identifikation/xdf3:id"/>
									<xsl:for-each-group select="fn:current-group()" group-by="string(xdf3:identifikation/xdf3:version)">
										<xsl:sort select="./xdf3:identifikation/xdf3:version"/>
										<xsl:if test="current-grouping-key()=''">
											<xsl:call-template name="minielementcore">
												<xsl:with-param name="Element" select="."/>
											</xsl:call-template>
										</xsl:if>
									</xsl:for-each-group>
								</xsl:for-each-group>
							</xsl:when>
							<xsl:otherwise>
								<xsl:for-each-group select="//xdf3:datenfeld[xdf3:regel/xdf3:identifikation/xdf3:id = $RegelID and xdf3:regel/xdf3:identifikation/xdf3:version = $RegelVersion]" group-by="xdf3:identifikation/xdf3:id">
									<xsl:sort select="./xdf3:identifikation/xdf3:id"/>
									<xsl:for-each-group select="fn:current-group()" group-by="string(xdf3:identifikation/xdf3:version)">
										<xsl:sort select="./xdf3:identifikation/xdf3:version"/>
										<xsl:call-template name="minielementcore">
											<xsl:with-param name="Element" select="."/>
										</xsl:call-template>
									</xsl:for-each-group>
								</xsl:for-each-group>
								<xsl:for-each-group select="//xdf3:datenfeldgruppe[xdf3:regel/xdf3:identifikation/xdf3:id = $RegelID and xdf3:regel/xdf3:identifikation/xdf3:version = $RegelVersion]" group-by="xdf3:identifikation/xdf3:id">
									<xsl:sort select="./xdf3:identifikation/xdf3:id"/>
									<xsl:for-each-group select="fn:current-group()" group-by="string(xdf3:identifikation/xdf3:version)">
										<xsl:sort select="./xdf3:identifikation/xdf3:version"/>
										<xsl:call-template name="minielementcore">
											<xsl:with-param name="Element" select="."/>
										</xsl:call-template>
									</xsl:for-each-group>
								</xsl:for-each-group>
								<xsl:for-each-group select="//xdf3:stammdatenschema[xdf3:regel/xdf3:identifikation/xdf3:id = $RegelID and xdf3:regel/xdf3:identifikation/xdf3:version = $RegelVersion]" group-by="xdf3:identifikation/xdf3:id">
									<xsl:sort select="./xdf3:identifikation/xdf3:id"/>
									<xsl:for-each-group select="fn:current-group()" group-by="string(xdf3:identifikation/xdf3:version)">
										<xsl:sort select="./xdf3:identifikation/xdf3:version"/>
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
			<a name="CodelisteDetails"/>Details zu den Codelisten des Datenschemas <xsl:value-of select="/*/xdf3:stammdatenschema/xdf3:identifikation/xdf3:id"/>
			<xsl:if test="/*/xdf3:stammdatenschema/xdf3:identifikation/xdf3:version"> Version <xsl:value-of select="/*/xdf3:stammdatenschema/xdf3:identifikation/xdf3:version"/>
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
				<xsl:for-each-group select="//xdf3:codelisteReferenz" group-by="concat(xdf3:canonicalIdentification,xdf3:version)">
					<xsl:sort select="concat(xdf3:canonicalIdentification,xdf3:version)"/>
					<xsl:call-template name="codelistedetails">
						<xsl:with-param name="Element" select="."/>
					</xsl:call-template>
				</xsl:for-each-group>
			</tbody>
		</table>
	</xsl:template>
	<!-- ############################################################################################################# -->
	<xsl:template name="codelistedetails">
		<xsl:param name="Element"/>
		<xsl:if test="$DebugMode = '2' or $DebugMode = '3' or $DebugMode = '4'">
			<xsl:message>
				++++++++ codelistedetails ++++++++
			</xsl:message>
		</xsl:if>
		<xsl:if test="$DebugMode = '3' or $DebugMode = '4'">
			<xsl:message>
				-------- <xsl:value-of select="$Element/xdf3:identifikation/xdf3:id"/> --------
			</xsl:message>
		</xsl:if>
		<tr>
			<xsl:variable name="CodelisteURN">
				<xsl:value-of select="$Element/xdf3:canonicalIdentification"/>
				<xsl:if test="$Element/xdf3:version">_<xsl:value-of select="$Element/xdf3:version"/>
				</xsl:if>
			</xsl:variable>
			<xsl:variable name="XMLCodelisteURL">
				<xsl:choose>
					<xsl:when test="fn:empty($Element/xdf3:version/text())">
						<xsl:value-of select="fn:concat($XMLXRepoOhneVersionPfadPrefix,$CodelisteURN,$XMLXRepoOhneVersionPfadPostfix)"/>
					</xsl:when>
					<xsl:otherwise>
						<xsl:value-of select="fn:concat($XMLXRepoMitVersionPfadPrefix,$CodelisteURN,$XMLXRepoMitVersionPfadPostfix)"/>
					</xsl:otherwise>
				</xsl:choose>
			</xsl:variable>
			<xsl:variable name="DocCodelisteURL">
				<xsl:choose>
					<xsl:when test="fn:empty($Element/xdf3:version/text())">
						<xsl:value-of select="fn:concat($DocXRepoOhneVersionPfadPrefix,$CodelisteURN,$DocXRepoOhneVersionPfadPostfix)"/>
					</xsl:when>
					<xsl:otherwise>
						<xsl:value-of select="fn:concat($DocXRepoMitVersionPfadPrefix,$CodelisteURN,$DocXRepoMitVersionPfadPostfix)"/>
					</xsl:otherwise>
				</xsl:choose>
			</xsl:variable>
			<xsl:variable name="CodelisteInhalt">
				<xsl:if test="fn:doc-available($XMLCodelisteURL)">
					<xsl:copy-of select="fn:document($XMLCodelisteURL)"/>
				</xsl:if>
			</xsl:variable>
			<td>
				<xsl:element name="a">
					<xsl:attribute name="name"><xsl:value-of select="$CodelisteURN"/></xsl:attribute>
				</xsl:element>
				ID (CanonicalUri)
			</td>
			<td>
				<xsl:value-of select="$Element/xdf3:canonicalIdentification"/>
				<xsl:if test="$Meldungen = '1'">
					<xsl:analyze-string regex="^urn:[A-Za-z0-9][A-Za-z0-9-]{{0,31}}:([A-Za-z0-9()+,\-.:=@;\$_!*&apos;]|%[0-9A-Fa-f]{{2}})+$" select="$Element/xdf3:canonicalIdentification">
						<xsl:matching-substring>
							<xsl:if test="$XRepoAufruf = '1'">
								&#160;&#160;
								<xsl:element name="a">
									<xsl:attribute name="href"><xsl:value-of select="$DocCodelisteURL"/></xsl:attribute>
									<xsl:attribute name="target">XRepo</xsl:attribute>
									<xsl:attribute name="title">Springe in das XRepository.</xsl:attribute>
									&#8658;
								</xsl:element>
							</xsl:if>
							<xsl:if test="$Meldungen = '1' and $CodelisteInhalt = ''">
								<div class="Warnung W1017">Warnung!! W1017: Auf die Codeliste kann nicht im XRepository zugegriffen werden. Dies k�nnte auf einen Fehler in der URN oder der Version der Codeliste zur�ckzuf�hren sein.</div>
							</xsl:if>
						</xsl:matching-substring>
						<xsl:non-matching-substring>
							<xsl:if test="$Meldungen = '1'">
								<xsl:choose>
									<xsl:when test="empty($Element/xdf3:canonicalIdentification/text())">
										<div class="Fehler E1040">Fehler!! E1040: Die Kennung ist leer.</div>
									</xsl:when>
									<xsl:when test="substring($Element/xdf3:canonicalIdentification/text(),1,4) != 'urn:'">
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
		<!-- ggfs. noch Abfrage der aktuellsten Version einbauen: https://www.xrepository.de/api/codeliste/urn:de:xoev:codeliste:erreichbarkeit/gueltigeVersion -->
		<tr>
			<td>Version</td>
			<td>
				<xsl:choose>
					<xsl:when test="not(empty($Element/xdf3:version/text()))">
						<xsl:value-of select="$Element/xdf3:version"/>
					</xsl:when>
					<xsl:otherwise>
						Da die Version der Codeliste nicht vorgegeben ist, sollte in der Regel immer die aktuellste Version der Codeliste verwendet werden.
					</xsl:otherwise>
				</xsl:choose>
				<xsl:if test="$Meldungen = '1' and (count(//xdf3:codelisteReferenz[xdf3:canonicalIdentification = $Element/xdf3:canonicalIdentification and xdf3:version != $Element/xdf3:version]) &gt; 0)">
					<div class="Fehler E1037">Fehler!! E1037: In einem Datenschema darf eine Codeliste nicht in mehreren Versionen verwendet werden.</div>
				</xsl:if>
			</td>
		</tr>
		<tr>
			<td>CanonicalVersionUri</td>
			<td>
				<xsl:value-of select="$Element/xdf3:canonicalVersionUri"/>
				<xsl:if test="$Meldungen = '1' and $Element/xdf3:canonicalVersionUri/text()">
					<xsl:analyze-string regex="^urn:[A-Za-z0-9][A-Za-z0-9-]{{0,31}}:([A-Za-z0-9()+,\-.:=@;\$_!*&apos;]|%[0-9A-Fa-f]{{2}})+$" select="$Element/xdf3:canonicalIdentification">
						<xsl:matching-substring>
						</xsl:matching-substring>
						<xsl:non-matching-substring>
							<xsl:choose>
								<xsl:when test="substring($Element/xdf3:canonicalIdentification/text(),1,4) != 'urn:'">
									<div class="Fehler E1005">Fehler!! E1005: Die Kennung einer Codeliste ist nicht als URN formuliert, z. B. urn:de:fim:codeliste:dokumenttyp.</div>
								</xsl:when>
								<xsl:otherwise>
									<div class="Fehler E1048">Fehler!! E1048: Die URN-Kennung einer Codeliste entspricht nicht den Formatvorgaben, z. B. urn:de:fim:codeliste:dokumenttyp (Umlaute sind nicht erlaubt!).</div>
								</xsl:otherwise>
							</xsl:choose>
						</xsl:non-matching-substring>
					</xsl:analyze-string>
				</xsl:if>
			</td>
		</tr>
		<xsl:if test="$CodelistenInhalt = '1' and $Element/xdf3:version and substring($Element/xdf3:canonicalIdentification/text(),1,4) = 'urn:'">
			<xsl:variable name="NormalisierteURN" select="fn:replace($Element/xdf3:canonicalIdentification,':','.')"/>
			<xsl:variable name="NormalisierteVersion">
				<xsl:if test="$Element/xdf3:version">_<xsl:value-of select="$Element/xdf3:version"/>
				</xsl:if>
			</xsl:variable>
			<xsl:variable name="CodelisteDatei" select="fn:concat($InputPfad,$NormalisierteURN,$NormalisierteVersion,'.xml')"/>
			<xsl:variable name="CodelisteURL" select="fn:concat($XMLXRepoMitVersionPfadPrefix,$Element/xdf3:canonicalIdentification,'_',$Element/xdf3:version,$XMLXRepoMitVersionPfadPostfix)"/>
			<xsl:variable name="CodelisteInhalt">
				<xsl:choose>
					<xsl:when test="fn:doc-available($CodelisteURL)">
						<xsl:copy-of select="fn:document($CodelisteURL)"/>
						<xsl:if test="$DebugMode = '4'">
							<xsl:message>                                  URL</xsl:message>
						</xsl:if>
					</xsl:when>
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
						<td>Kurzname</td>
						<td>
							<b>
								<xsl:value-of select="$CodelisteInhalt/*/gc:Identification/gc:ShortName"/>
								<xsl:value-of select="$CodelisteInhalt/*/Identification/ShortName"/>
							</b>
						</td>
					</tr>
					<tr>
						<td>Langname</td>
						<td>
							<xsl:value-of select="$CodelisteInhalt/*/gc:Identification/gc:LongName"/>
							<xsl:value-of select="$CodelisteInhalt/*/Identification/LongName"/>
						</td>
					</tr>
					<tr>
						<tr>
							<td>Herausgeber</td>
							<td>
								<xsl:value-of select="$CodelisteInhalt/*/gc:Identification/gc:Agency/gc:LongName"/>
								<xsl:value-of select="$CodelisteInhalt/*/Identification/Agency/LongName"/>
							</td>
						</tr>
						<td colspan="2">
							<h2/>
						</td>
					</tr>
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
			<tr>
				<td colspan="2">
					<h2/>
				</td>
			</tr>
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
									<td>Zeitpunkt der letzten �nderung</td>
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
			<xsl:variable name="CodelisteID" select="$Element/xdf3:identifikation/xdf3:id"/>
			<xsl:choose>
				<xsl:when test="count(//xdf3:datenfeld[fn:concat(xdf3:codelisteReferenz/xdf3:canonicalIdentification,xdf3:codelisteReferenz/xdf3:version) = concat($Element/xdf3:canonicalIdentification,$Element/xdf3:version)])">
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
								<xsl:for-each-group select="//xdf3:datenfeld[fn:concat(xdf3:codelisteReferenz/xdf3:canonicalIdentification,xdf3:codelisteReferenz/xdf3:version) = concat($Element/xdf3:canonicalIdentification,$Element/xdf3:version)]" group-by="fn:concat(xdf3:codelisteReferenz/xdf3:canonicalIdentification,xdf3:codelisteReferenz/xdf3:version)">
									<xsl:sort select="fn:concat(xdf3:codelisteReferenz/xdf3:canonicalIdentification,xdf3:codelisteReferenz/xdf3:version)"/>
									<xsl:for-each-group select="fn:current-group()" group-by="concat(xdf3:identifikation/xdf3:id,xdf3:identifikation/xdf3:version)">
										<xsl:sort select="concat(xdf3:identifikation/xdf3:id,xdf3:identifikation/xdf3:version)"/>
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
							<!-- ToDo: checken -->
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
	<xsl:template name="unterelemente">
		<xsl:param name="Element"/>
		<xsl:param name="Tiefe"/>
		<xsl:param name="Strukturelementart"/>
		<xsl:if test="$DebugMode = '4'">
			<xsl:message>
				++++++++++++++++ unterelemente ++++++++++++++++
			</xsl:message>
		</xsl:if>
		<xsl:for-each select="$Element/xdf3:regel">
			<tr class="Regel">
				<td>
					<span class="Einrueckung">
						<xsl:call-template name="einrueckung">
							<xsl:with-param name="Tiefe" select="$Tiefe"/>
							<xsl:with-param name="Zaehler" select="0"/>
							<xsl:with-param name="Text"/>
							<xsl:with-param name="XORGruppe" select="0"/>
						</xsl:call-template>
					</span>
					<xsl:choose>
						<xsl:when test="empty(./xdf3:identifikation/xdf3:id/text())">
							<xsl:if test="$Meldungen = '1'">
								<div class="Fehler E1038">Fehler!! E1038: Die ID muss bef�llt werden.</div>
							</xsl:if>
						</xsl:when>
						<xsl:otherwise>
							<xsl:choose>
								<xsl:when test="$InterneLinks = '1'">
									<xsl:element name="a">
										<xsl:attribute name="href">#<xsl:value-of select="./xdf3:identifikation/xdf3:id"/><xsl:if test="./xdf3:identifikation/xdf3:version">V<xsl:value-of select="./xdf3:identifikation/xdf3:version"/></xsl:if></xsl:attribute>
										<xsl:value-of select="./xdf3:identifikation/xdf3:id"/>
									</xsl:element>
								</xsl:when>
								<xsl:otherwise>
									<xsl:value-of select="./xdf3:identifikation/xdf3:id"/>
								</xsl:otherwise>
							</xsl:choose>
						</xsl:otherwise>
					</xsl:choose>
				</td>
				<td>
					<!--	<xsl:value-of select="./xdf3:identifikation/xdf3:version"/>   -->
				</td>
				<td>
					<xsl:value-of select="./xdf3:name"/>
				</td>
				<td colspan="4">
					<xsl:value-of select="fn:replace(./xdf3:freitextRegel,'\n','&lt;br/&gt;')" disable-output-escaping="yes"/>
					<xsl:if test="$Tiefe = 1">
						<xsl:variable name="regellistedoppelte">
							<xdf3:enthaltenebaukastenelemente>
								<xsl:analyze-string regex="[F|G]\d{{11}}" select="./xdf3:freitextRegel">
									<xsl:matching-substring>
										<xdf3:elementid>
											<xsl:value-of select="."/>
										</xdf3:elementid>
									</xsl:matching-substring>
									<xsl:non-matching-substring>
									</xsl:non-matching-substring>
								</xsl:analyze-string>
							</xdf3:enthaltenebaukastenelemente>
						</xsl:variable>
						<xsl:for-each-group select="$regellistedoppelte/*/xdf3:elementid" group-by=".">
							<xsl:sort/>
							<xsl:variable name="TestElement">
								<xsl:value-of select="."/>
							</xsl:variable>
							<xsl:if test="fn:not($Element//xdf3:identifikation[xdf3:id/text() = $TestElement])">
								<xsl:if test="$Meldungen = '1'">
									<div class="Fehler E1001">Fehler!! E1001: Die Regel kann auf kein Baukastenelement mit der ID <xsl:value-of select="$TestElement"/> zugreifen.</div>
								</xsl:if>
							</xsl:if>
						</xsl:for-each-group>
						<xsl:variable name="regellisteversionen">
							<xdf3:enthaltenebaukastenelemente>
								<xsl:analyze-string regex="[F|G]\d{{11}}V\d*\.\d*" select="./xdf3:freitextRegel">
									<xsl:matching-substring>
										<xdf3:elementid>
											<xsl:value-of select="."/>
										</xdf3:elementid>
									</xsl:matching-substring>
									<xsl:non-matching-substring>
									</xsl:non-matching-substring>
								</xsl:analyze-string>
							</xdf3:enthaltenebaukastenelemente>
						</xsl:variable>
						<xsl:for-each-group select="$regellisteversionen/*/xdf3:elementid" group-by=".">
							<xsl:sort/>
							<div class="Fehler E1019">Fehler!! E1019: Baukastenelemente, die in Regeln referenziert werden, d�rfen keine Versionsangaben beinhalten: <xsl:value-of select="."/>.</div>
						</xsl:for-each-group>
						<xsl:variable name="regellistealtesformat">
							<xdf3:enthaltenebaukastenelemente>
								<xsl:analyze-string regex="[F|G]\d{{8}}[^\d]" select="./xdf3:freitextRegel">
									<xsl:matching-substring>
										<xdf3:elementid>
											<xsl:value-of select="."/>
										</xdf3:elementid>
									</xsl:matching-substring>
									<xsl:non-matching-substring>
									</xsl:non-matching-substring>
								</xsl:analyze-string>
							</xdf3:enthaltenebaukastenelemente>
						</xsl:variable>
						<xsl:for-each-group select="$regellistealtesformat/*/xdf3:elementid" group-by=".">
							<xsl:sort/>
							<div class="Fehler E1041">Fehler!! E1041: Baukastenelemente, die in Regeln referenziert werden, verwenden noch die alte, verk�rzte Element-ID: <xsl:value-of select="fn:substring(.,1,9)"/>.</div>
						</xsl:for-each-group>
					</xsl:if>
				</td>
			</tr>
		</xsl:for-each>
		<xsl:variable name="XORGruppe">
			<xsl:choose>
				<xsl:when test="$Element/xdf3:art/code = 'X'">1</xsl:when>
				<xsl:otherwise>0</xsl:otherwise>
			</xsl:choose>
		</xsl:variable>
		<xsl:for-each select="$Element/xdf3:struktur">
			<xsl:variable name="VergleichsElement">
				<xsl:value-of select="./xdf3:enthaelt/*/xdf3:identifikation/xdf3:id"/>
			</xsl:variable>
			<xsl:variable name="VergleichsVersion">
				<xsl:value-of select="./xdf3:enthaelt/*/xdf3:identifikation/xdf3:version"/>
			</xsl:variable>
			<tr>
				<td>
					<xsl:call-template name="einrueckung">
						<xsl:with-param name="Tiefe" select="$Tiefe"/>
						<xsl:with-param name="Zaehler" select="0"/>
						<xsl:with-param name="Text"/>
						<xsl:with-param name="XORGruppe" select="$XORGruppe"/>
					</xsl:call-template>
					<xsl:choose>
						<xsl:when test="empty(./xdf3:enthaelt/*/xdf3:identifikation/xdf3:id/text())">
							<xsl:if test="$Meldungen = '1'">
								<div class="Fehler E1038">Fehler!! E1038: Die ID muss bef�llt werden.</div>
							</xsl:if>
						</xsl:when>
						<xsl:otherwise>
							<xsl:choose>
								<xsl:when test="$InterneLinks = '1'">
									<xsl:element name="a">
										<xsl:attribute name="href">#<xsl:value-of select="./xdf3:enthaelt/*/xdf3:identifikation/xdf3:id"/><xsl:if test="./xdf3:enthaelt/*/xdf3:identifikation/xdf3:version">V<xsl:value-of select="./xdf3:enthaelt/*/xdf3:identifikation/xdf3:version"/></xsl:if></xsl:attribute>
										<xsl:value-of select="./xdf3:enthaelt/*/xdf3:identifikation/xdf3:id"/>
									</xsl:element>
								</xsl:when>
								<xsl:otherwise>
									<xsl:value-of select="./xdf3:enthaelt/*/xdf3:identifikation/xdf3:id"/>
								</xsl:otherwise>
							</xsl:choose>
						</xsl:otherwise>
					</xsl:choose>
					<xsl:if test="count(.//xdf3:enthaelt/xdf3:datenfeldgruppe[xdf3:identifikation/xdf3:id = $Element/xdf3:identifikation/xdf3:id and xdf3:identifikation/xdf3:version = $Element/xdf3:identifikation/xdf3:version]) &gt; 0">
						<xsl:if test="$Meldungen = '1'">
							<div class="Fehler E1026">Fehler!! E1026: Zirkelbezug</div>
						</xsl:if>
					</xsl:if>
					<xsl:choose>
						<xsl:when test="$VergleichsVersion = ''">
							<xsl:if test="$Tiefe = 1 and count($Element/xdf3:struktur/./xdf3:enthaelt/*/xdf3:identifikation[xdf3:id=$VergleichsElement and not(xdf3:version)]) &gt; 1">
								<xsl:if test="$Meldungen = '1'">
									<div class="Fehler E1025">Fehler!! E1025: In einem Datenschema d�rfen Baukastenelement auf oberster Ebene nicht mehrfach in derselben Version enthalten sein.</div>
								</xsl:if>
							</xsl:if>
						</xsl:when>
						<xsl:otherwise>
							<xsl:if test="$Tiefe = 1 and count($Element/xdf3:struktur/./xdf3:enthaelt/*/xdf3:identifikation[xdf3:id=$VergleichsElement and xdf3:version=$VergleichsVersion]) &gt; 1">
								<xsl:if test="$Meldungen = '1'">
									<div class="Fehler E1025">Fehler!! E1025: In einem Datenschema d�rfen Baukastenelement auf oberster Ebene nicht mehrfach in derselben Version enthalten sein.</div>
								</xsl:if>
							</xsl:if>
						</xsl:otherwise>
					</xsl:choose>
				</td>
				<xsl:choose>
					<xsl:when test="$Tiefe = 1 and empty(./xdf3:enthaelt/*/xdf3:identifikation/xdf3:version/text()) and $VersionsHinweise ='1'">
						<td>
							<xsl:value-of select="./xdf3:enthaelt/*/xdf3:identifikation/xdf3:version"/>
							<xsl:if test="$Meldungen = '1'">
								<div class="Hinweis">Hinweis!! Zur Versionierung und Ver�ffentlichung m�ssen alle verwendete Unterelemente versioniert sein.</div>
							</xsl:if>
						</td>
					</xsl:when>
					<xsl:otherwise>
						<td>
							<xsl:value-of select="./xdf3:enthaelt/*/xdf3:identifikation/xdf3:version"/>
						</td>
					</xsl:otherwise>
				</xsl:choose>
				<td>
					<xsl:value-of select="./xdf3:enthaelt/*/xdf3:name"/>
				</td>
				<td>
					<xsl:value-of select="./xdf3:enthaelt/*/xdf3:bezeichnungEingabe"/>
				</td>
				<td>
					<xsl:choose>
						<xsl:when test="./xdf3:enthaelt/*/xdf3:schemaelementart/code/text() = 'ABS' and $Tiefe = 1 and$AbstraktWarnung ='1'">
							<xsl:apply-templates select="./xdf3:enthaelt/*/xdf3:schemaelementart"/>
							<xsl:if test="$Meldungen = '1'">
								<div class="Fehler E1013">Fehler!! E1013: Innerhalb von Datenschemata und Datenfeldgruppen d�rfen nur Elemente mit der Strukturelementart harmonisiert oder rechtnormgebunden verwendet werden.</div>
							</xsl:if>
						</xsl:when>
						<xsl:otherwise>
							<xsl:apply-templates select="./xdf3:enthaelt/*/xdf3:schemaelementart"/>
						</xsl:otherwise>
					</xsl:choose>
				</td>
				<td>
					<xsl:choose>
						<xsl:when test="./xdf3:enthaelt/*/xdf3:freigabestatus/code/text() = '7'and $Tiefe = 1">
							<xsl:apply-templates select="./xdf3:enthaelt/*/xdf3:freigabestatus"/>
							<xsl:if test="$Meldungen = '1'">
								<div class="Warnung W1016">Warnung!! W1016: Baukastenelemente im Status 'inaktiv' sollten nur in Ausnahmef�llen verwendet werden.</div>
							</xsl:if>
						</xsl:when>
						<xsl:otherwise>
							<xsl:apply-templates select="./xdf3:enthaelt/*/xdf3:freigabestatus"/>
						</xsl:otherwise>
					</xsl:choose>
				</td>
				<td>
					<xsl:choose>
						<xsl:when test="$Tiefe = 1 and $Meldungen = '1'">
							<xsl:value-of select="./xdf3:anzahl"/>
							<xsl:variable name="AnzahlText" select="./xdf3:anzahl/text()"/>
							<xsl:variable name="minCount" select="fn:substring-before(./xdf3:anzahl/text(),':')"/>
							<xsl:variable name="maxCount" select="fn:substring-after(./xdf3:anzahl/text(),':')"/>
							<xsl:analyze-string regex="^\d{{1,}}:[\d{{1,}}|*]$" select="./xdf3:anzahl">
								<xsl:matching-substring>
									<xsl:if test="$AnzahlText = '0:0'">
										<div class="Fehler E1021">Fehler!! E1021: Es ist keine Multiplizit�t angegeben.</div>
									</xsl:if>
									<xsl:if test="(fn:number($minCount) &gt; fn:number($maxCount)) and $maxCount != '*'">
										<div class="Fehler E1047">Fehler!! E1047: In der Multiplizit�t muss die minimale Anzahl kleiner oder gleich der maximalen Anzahl sein.</div>
									</xsl:if>
								</xsl:matching-substring>
								<xsl:non-matching-substring>
									<xsl:if test="$Meldungen = '1'">
										<div class="Fehler E1046">Fehler!! E1046: Die Multiplizit�t entspricht nicht den Formatvorgaben.</div>
									</xsl:if>
								</xsl:non-matching-substring>
							</xsl:analyze-string>
						</xsl:when>
						<xsl:otherwise>
							<xsl:value-of select="./xdf3:anzahl"/>
						</xsl:otherwise>
					</xsl:choose>
				</td>
				<td>
					<xsl:choose>
						<xsl:when test="$Strukturelementart ='RNG' and (./xdf3:enthaelt/*/xdf3:schemaelementart/code/text() = 'ABS' or ./xdf3:enthaelt/*/xdf3:schemaelementart/code/text() = 'HAR') and empty(./xdf3:bezug/text())and $Tiefe = 1">
							<xsl:if test="$Meldungen = '1'">
								<div class="Fehler E1022">Fehler!! E1022: Bei Verwendung von Elementen mit der Strukturelementart 'abstrakt' oder 'harmonisiert' innerhalb von Datenfeldgruppen mit der Strukturelementart 'rechtsnormgebunden' muss zur Multiplizit�t ein Bezug zu einer Handlungsgrundlage angegeben werden.</div>
							</xsl:if>
						</xsl:when>
						<xsl:when test="$Strukturelementart ='SDS' and (./xdf3:enthaelt/*/xdf3:schemaelementart/code/text() = 'ABS' or ./xdf3:enthaelt/*/xdf3:schemaelementart/code/text() = 'HAR') and empty(./xdf3:bezug/text())and $Tiefe = 1">
							<xsl:if test="$Meldungen = '1'">
								<div class="Fehler E1022">Fehler!! E1022: Bei Verwendung von Elementen mit der Strukturelementart 'abstrakt' oder 'harmonisiert' auf oberster Ebene eines Datenschemas muss zur Multiplizit�t ein Bezug zu einer Handlungsgrundlage angegeben werden.</div>
							</xsl:if>
						</xsl:when>
						<xsl:otherwise>
							<xsl:choose>
								<xsl:when test="fn:count(./xdf3:bezug) = 1">
									<xsl:choose>
										<xsl:when test="./xdf3:bezug/@link and not(./xdf3:bezug/@link='')">
											<xsl:choose>
												<xsl:when test="$HandlungsgrundlagenLinks = '1'">
													<xsl:element name="a">
														<xsl:attribute name="href"><xsl:value-of select="./xdf3:bezug/@link"/></xsl:attribute>
														<xsl:attribute name="target">Handlungsgrundlage</xsl:attribute>
														<xsl:attribute name="title">Springe zum Text der Handlungsgrundlage.</xsl:attribute>
														<xsl:value-of select="./xdf3:bezug"/>
													</xsl:element>
												</xsl:when>
												<xsl:otherwise>
													<xsl:value-of select="./xdf3:bezug"/>
												</xsl:otherwise>
											</xsl:choose>
										</xsl:when>
										<xsl:otherwise>
											<xsl:value-of select="./xdf3:bezug"/>
										</xsl:otherwise>
									</xsl:choose>
								</xsl:when>
								<xsl:otherwise>
									<xsl:for-each select="./xdf3:bezug">
										<xsl:choose>
											<xsl:when test="./@link and not(./@link='')">
												<xsl:choose>
													<xsl:when test="$HandlungsgrundlagenLinks = '1'">
														<xsl:element name="a">
															<xsl:attribute name="href"><xsl:value-of select="./@link"/></xsl:attribute>
															<xsl:attribute name="target">Handlungsgrundlage</xsl:attribute>
															<xsl:attribute name="title">Springe zum Text der Handlungsgrundlage.</xsl:attribute>
															<xsl:value-of select="."/>
														</xsl:element>
													</xsl:when>
													<xsl:otherwise>
														<xsl:value-of select="."/>
													</xsl:otherwise>
												</xsl:choose>
											</xsl:when>
											<xsl:otherwise>
												<xsl:value-of select="."/>
											</xsl:otherwise>
										</xsl:choose>
										<xsl:if test="fn:position() != fn:last()">
											<xsl:text>; </xsl:text>
										</xsl:if>
									</xsl:for-each>
								</xsl:otherwise>
							</xsl:choose>
						</xsl:otherwise>
					</xsl:choose>
				</td>
			</tr>
			<!-- Test auf Zirkelbezug E1026 -->
			<xsl:if test="count(.//xdf3:enthaelt/xdf3:datenfeldgruppe[xdf3:identifikation/xdf3:id = $Element/xdf3:identifikation/xdf3:id and xdf3:identifikation/xdf3:version = $Element/xdf3:identifikation/xdf3:version]) = 0">
				<xsl:call-template name="unterelemente">
					<xsl:with-param name="Element" select="./xdf3:enthaelt/xdf3:datenfeldgruppe"/>
					<xsl:with-param name="Tiefe" select="$Tiefe + 1"/>
					<xsl:with-param name="Strukturelementart" select="./xdf3:enthaelt/*/xdf3:schemaelementart/code"/>
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
							<xsl:attribute name="href">#<xsl:value-of select="$Element/xdf3:identifikation/xdf3:id"/><xsl:if test="$Element/xdf3:identifikation/xdf3:version">V<xsl:value-of select="$Element/xdf3:identifikation/xdf3:version"/></xsl:if></xsl:attribute>
							<xsl:value-of select="$Element/xdf3:identifikation/xdf3:id"/>
						</xsl:element>
					</xsl:when>
					<xsl:otherwise>
						<xsl:value-of select="$Element/xdf3:identifikation/xdf3:id"/>
					</xsl:otherwise>
				</xsl:choose>
			</td>
			<td>
				<xsl:value-of select="$Element/xdf3:identifikation/xdf3:version"/>
			</td>
			<td>
				<xsl:value-of select="$Element/xdf3:name"/>
			</td>
			<td>
				<xsl:value-of select="$Element/xdf3:bezeichnungEingabe"/>
			</td>
		</tr>
	</xsl:template>
	<!-- ############################################################################################################# -->
	<xsl:template match="xdf3:feldart">
		<xsl:choose>
			<xsl:when test="./code/text() = 'input'">Eingabefeld</xsl:when>
			<xsl:when test="./code/text() = 'select'">Auswahlfeld</xsl:when>
			<xsl:when test="./code/text() = 'label'">Statisches, read-only Feld</xsl:when>
			<xsl:when test="./code/text() = 'hidden'">verstecktes Feld</xsl:when>
			<xsl:when test="./code/text() = 'locked'">gesperrtes Feld</xsl:when>
			<xsl:otherwise>
				<xsl:if test="$Meldungen = '1'">
					<div class="Fehler E1027">Fehler!! E1027: Unbekannte Feldart</div>
				</xsl:if>
			</xsl:otherwise>
		</xsl:choose>
	</xsl:template>
	<xsl:template match="xdf3:datentyp">
		<xsl:choose>
			<xsl:when test="./code/text() = 'text'">Text</xsl:when>
			<xsl:when test="./code/text() = 'text_latin'">Text (String.Latin+ 1.2 -DIN Spec 91379 - Datentyp C)</xsl:when>
			<xsl:when test="./code/text() = 'date'">Datum</xsl:when>
			<xsl:when test="./code/text() = 'time'">Uhrzeit (Stunde und Minute)</xsl:when>
			<xsl:when test="./code/text() = 'datetime'">Zeitpunkt (Datum und Zeit)</xsl:when>
			<xsl:when test="./code/text() = 'bool'">Wahrheitswert</xsl:when>
			<xsl:when test="./code/text() = 'num'">Nummer (Flie�kommazahl)</xsl:when>
			<xsl:when test="./code/text() = 'num_int'">Ganzzahl</xsl:when>
			<xsl:when test="./code/text() = 'num_currency'">Geldbetrag</xsl:when>
			<xsl:when test="./code/text() = 'file'">Anlage (Datei)</xsl:when>
			<xsl:when test="./code/text() = 'obj'">Statisches Objekt</xsl:when>
			<xsl:otherwise>
				<xsl:if test="$Meldungen = '1'">
					<div class="Fehler E1028">Fehler!! E1028: Unbekannter Datentyp</div>
				</xsl:if>
			</xsl:otherwise>
		</xsl:choose>
	</xsl:template>
	<xsl:template match="xdf3:praedikat">
		<xsl:choose>
			<xsl:when test="./code/text() = 'ABL'">ist abgeleitet von</xsl:when>
			<xsl:when test="./code/text() = 'ERS'">ersetzt</xsl:when>
			<xsl:when test="./code/text() = 'EQU'">ist �quivalent zu</xsl:when>
			<xsl:when test="./code/text() = 'VKN'">ist verkn�pft mit</xsl:when>
			<xsl:otherwise>
				<xsl:if test="$Meldungen = '1'">
					<div class="Fehler E1029">Fehler!! E1029: Unbekannte Relationsart</div>
				</xsl:if>
			</xsl:otherwise>
		</xsl:choose>
	</xsl:template>
	<xsl:template match="xdf3:vorbefuellung">
		<xsl:choose>
			<xsl:when test="./code/text() = 'keine'">keine Vorbef�llung</xsl:when>
			<xsl:when test="./code/text() = 'optional'">optionale Vorbef�llung</xsl:when>
			<xsl:when test="./code/text() = 'verpflichtend'">verpflichtende Vorbef�llung</xsl:when>
			<xsl:otherwise>
				<xsl:if test="$Meldungen = '1'">
					<div class="Fehler E1030">Fehler!! E1030: Unbekannte Vorbef�llungsart</div>
				</xsl:if>
			</xsl:otherwise>
		</xsl:choose>
	</xsl:template>
	<xsl:template match="xdf3:schemaelementart">
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
	<xsl:template match="xdf3:freigabestatus">
		<xsl:choose>
			<xsl:when test="./code/text() = '1'">in&#160;Planung</xsl:when>
			<xsl:when test="./code/text() = '2'">in&#160;Bearbeitung</xsl:when>
			<xsl:when test="./code/text() = '3'">Entwurf</xsl:when>
			<xsl:when test="./code/text() = '4'">methodisch&#160;freigegeben</xsl:when>
			<xsl:when test="./code/text() = '5'">fachlich&#160;freigegeben (silber)</xsl:when>
			<xsl:when test="./code/text() = '6'">fachlich&#160;freigegeben (gold)</xsl:when>
			<xsl:when test="./code/text() = '7'">inaktiv</xsl:when>
			<xsl:otherwise>
				<xsl:if test="$Meldungen = '1'">
					<div class="Fehler E1032">Fehler!! E1032: Unbekannter Status</div>
				</xsl:if>
			</xsl:otherwise>
		</xsl:choose>
	</xsl:template>
	<xsl:template match="xdf3:ableitungsmodifikationenStruktur">
		<xsl:choose>
			<xsl:when test="./code/text() = '0'">nicht modifizierbar</xsl:when>
			<xsl:when test="./code/text() = '1'">nur einschr�nkbar</xsl:when>
			<xsl:when test="./code/text() = '2'">nur erweiterbar</xsl:when>
			<xsl:when test="./code/text() = '3'">alles modifizierbar</xsl:when>
			<xsl:otherwise>
				<xsl:if test="$Meldungen = '1'">
					<div class="Fehler E1033">Fehler!! E1033: Unbekannte �nderbarkeit der Struktur</div>
				</xsl:if>
			</xsl:otherwise>
		</xsl:choose>
	</xsl:template>
	<xsl:template match="xdf3:ableitungsmodifikationenRepraesentation">
		<xsl:choose>
			<xsl:when test="./code/text() = '0'">nicht modifizierbar</xsl:when>
			<xsl:when test="./code/text() = '1'">modifizierbar</xsl:when>
			<xsl:otherwise>
				<xsl:if test="$Meldungen = '1'">
					<div class="Fehler E1034">Fehler!! E1034: Unbekannte �nderbarkeit der Repr�sentation</div>
				</xsl:if>
			</xsl:otherwise>
		</xsl:choose>
	</xsl:template>
	<xsl:template match="xdf3:art">
		<xsl:choose>
			<xsl:when test="./code/text() = 'X'">Auswahlgruppe</xsl:when>
			<xsl:otherwise>
				<xsl:if test="$Meldungen = '1'">
					<div class="Fehler E1042">Fehler!! E1042: Unbekannte Gruppenart</div>
				</xsl:if>
			</xsl:otherwise>
		</xsl:choose>
	</xsl:template>
	<xsl:template match="xdf3:dokumentart">
		<xsl:choose>
			<xsl:when test="./code/text() = '001'">Antrag</xsl:when>
			<xsl:when test="./code/text() = '002'">Anzeige</xsl:when>
			<xsl:when test="./code/text() = '003'">Bericht</xsl:when>
			<xsl:when test="./code/text() = '004'">Bescheid</xsl:when>
			<xsl:when test="./code/text() = '005'">Erkl�rung</xsl:when>
			<xsl:when test="./code/text() = '006'">Kartenmaterial</xsl:when>
			<xsl:when test="./code/text() = '007'">Mitteilung</xsl:when>
			<xsl:when test="./code/text() = '008'">Multimedia</xsl:when>
			<xsl:when test="./code/text() = '009'">Registeranfrage</xsl:when>
			<xsl:when test="./code/text() = '010'">Registerantwort</xsl:when>
			<xsl:when test="./code/text() = '011'">Urkunde</xsl:when>
			<xsl:when test="./code/text() = '012'">Vertrag</xsl:when>
			<xsl:when test="./code/text() = '013'">Vollmacht</xsl:when>
			<xsl:when test="./code/text() = '014'">Willenserkl�rung</xsl:when>
			<xsl:when test="./code/text() = '999'">unbestimmt</xsl:when>
			<xsl:otherwise>
				<xsl:if test="$Meldungen = '1'">
					<div class="Fehler E1055">Fehler!! E1055: Unbekannte Dokumentart</div>
				</xsl:if>
			</xsl:otherwise>
		</xsl:choose>
	</xsl:template>
	<!-- ############################################################################################################# -->
	<xsl:template name="einrueckung">
		<xsl:param name="Tiefe"/>
		<xsl:param name="Zaehler"/>
		<xsl:param name="Text"/>
		<xsl:param name="XORGruppe"/>
		<xsl:choose>
			<xsl:when test="$Zaehler = 0">
				<xsl:variable name="Text2">&#8970;</xsl:variable>
				<xsl:call-template name="einrueckung">
					<xsl:with-param name="Tiefe" select="$Tiefe"/>
					<xsl:with-param name="Zaehler" select="$Zaehler + 1"/>
					<xsl:with-param name="Text" select="$Text2"/>
					<xsl:with-param name="XORGruppe" select="$XORGruppe"/>
				</xsl:call-template>
			</xsl:when>
			<xsl:when test="$Zaehler = 1 and $XORGruppe = 1">
				<xsl:variable name="Text2">
					<xsl:value-of select="concat($Text, 'x_')"/>
				</xsl:variable>
				<xsl:call-template name="einrueckung">
					<xsl:with-param name="Tiefe" select="$Tiefe"/>
					<xsl:with-param name="Zaehler" select="$Zaehler + 1"/>
					<xsl:with-param name="Text" select="$Text2"/>
					<xsl:with-param name="XORGruppe" select="$XORGruppe"/>
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
					<xsl:with-param name="XORGruppe" select="$XORGruppe"/>
				</xsl:call-template>
			</xsl:when>
			<xsl:when test="$Zaehler = $Tiefe">
				<xsl:value-of select="$Text"/>
			</xsl:when>
		</xsl:choose>
	</xsl:template>
	<!-- ############################################################################################################# -->
	<xsl:template name="fileName">
		<xsl:param name="path"/>
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
										<a href="#ElementListe">�bersicht der Elemente</a> - <a href="#ElementDetails">Details zu den Baukastenelementen</a> - <a href="#RegelListe">�bersicht der Regeln</a> - <a href="#RegelDetails">Details zu den Regeln</a> - <a href="#FormularListe">�bersicht der Formularsteckbriefe</a> - <a href="#FormularDetails">Details zu den Formularsteckbriefen</a>- <a href="#StammListe">�bersicht der Stammformulare</a> - <a  style="page-break-after:always" href="#StammDetails">Details zu den Stammformularen</a>
	-->
		<xsl:choose>
			<xsl:when test="$Navigation = '1' and $Statistik != '2'">
				<br/>
				<span class="TrennerNavi">
					<a style="text-decoration:none;" href="#" title="�ffne das Navigationsfenster" onclick="ZeigeNavigation(); return false;">.</a>
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
				if (document.querySelectorAll('.E1007').length != 0)
				{
					document.getElementById("FehlerListe").insertAdjacentHTML('beforeend', document.querySelectorAll('.E1007').length + " mal E1007: Es ist kein Dokumentsteckbrief zugeordnet." + "<xsl:text disable-output-escaping="yes">&lt;</xsl:text>br/<xsl:text disable-output-escaping="yes">&gt;</xsl:text>");
				}
				if (document.querySelectorAll('.E1009').length != 0)
				{
					document.getElementById("FehlerListe").insertAdjacentHTML('beforeend', document.querySelectorAll('.E1009').length + " mal E1009: Die 'Bezeichnung Eingabe' muss bef�llt werden." + "<xsl:text disable-output-escaping="yes">&lt;</xsl:text>br/<xsl:text disable-output-escaping="yes">&gt;</xsl:text>");
				}
				if (document.querySelectorAll('.E1010').length != 0)
				{
					document.getElementById("FehlerListe").insertAdjacentHTML('beforeend', document.querySelectorAll('.E1010').length + " mal E1010: Die 'Bezeichnung Ausgabe' muss bef�llt werden." + "<xsl:text disable-output-escaping="yes">&lt;</xsl:text>br/<xsl:text disable-output-escaping="yes">&gt;</xsl:text>");
				}
				if (document.querySelectorAll('.E1011').length != 0)
				{
					document.getElementById("FehlerListe").insertAdjacentHTML('beforeend', document.querySelectorAll('.E1011').length + " mal E1011: Bei Datenfeldern mit der Feldart 'Auswahl' sollte der Datentyp 'Text' sein - in seltenen F�llen 'Ganzzahl'." + "<xsl:text disable-output-escaping="yes">&lt;</xsl:text>br/<xsl:text disable-output-escaping="yes">&gt;</xsl:text>");
				}
				if (document.querySelectorAll('.E1012').length != 0)
				{
					document.getElementById("FehlerListe").insertAdjacentHTML('beforeend', document.querySelectorAll('.E1012').length + " mal E1012: Bei Datenfeldern mit der Feldart 'Auswahlfeld' oder 'Statisches, read-only Feld' d�rfen weder die minimale noch die maximale Feldl�nge angegeben werden." + "<xsl:text disable-output-escaping="yes">&lt;</xsl:text>br/<xsl:text disable-output-escaping="yes">&gt;</xsl:text>");
				}
				if (document.querySelectorAll('.E1013').length != 0)
				{
					document.getElementById("FehlerListe").insertAdjacentHTML('beforeend', document.querySelectorAll('.E1013').length + " mal E1013: Innerhalb von Datenschemata und Datenfeldgruppen d�rfen nur Elemente mit der Strukturelementart harmonisiert oder rechtnormgebunden verwendet werden." + "<xsl:text disable-output-escaping="yes">&lt;</xsl:text>br/<xsl:text disable-output-escaping="yes">&gt;</xsl:text>");
				}
				if (document.querySelectorAll('.E1014').length != 0)
				{
					document.getElementById("FehlerListe").insertAdjacentHTML('beforeend', document.querySelectorAll('.E1014').length + " mal E1014: Datenfelder d�rfen nicht die Strukturelementart 'abstrakt' haben." + "<xsl:text disable-output-escaping="yes">&lt;</xsl:text>br/<xsl:text disable-output-escaping="yes">&gt;</xsl:text>");
				}
				if (document.querySelectorAll('.E1015').length != 0)
				{
					document.getElementById("FehlerListe").insertAdjacentHTML('beforeend', document.querySelectorAll('.E1015').length + " mal E1015: Eine Feldl�nge darf nur bei einem Datenfeld mit dem Datentyp 'Text' angegeben werden." + "<xsl:text disable-output-escaping="yes">&lt;</xsl:text>br/<xsl:text disable-output-escaping="yes">&gt;</xsl:text>");
				}
				if (document.querySelectorAll('.E1016').length != 0)
				{
					document.getElementById("FehlerListe").insertAdjacentHTML('beforeend', document.querySelectorAll('.E1016').length + " mal E1016: Ein Wertebereich darf nur bei einem Datenfeld mit einem nummerischen Datentyp (Nummer, Ganzzahl, Geldbetrag) oder einem Zeitdatentyp (Uhrzeit, Datum, Zeitpunkt) angegeben werden." + "<xsl:text disable-output-escaping="yes">&lt;</xsl:text>br/<xsl:text disable-output-escaping="yes">&gt;</xsl:text>");
				}
				if (document.querySelectorAll('.E1017').length != 0)
				{
					document.getElementById("FehlerListe").insertAdjacentHTML('beforeend', document.querySelectorAll('.E1017').length + " mal E1017: Ist eine Code- oder Werteliste zugeordnet, muss die Feldart 'Auswahl' sein." + "<xsl:text disable-output-escaping="yes">&lt;</xsl:text>br/<xsl:text disable-output-escaping="yes">&gt;</xsl:text>");
				}
				if (document.querySelectorAll('.E1018').length != 0)
				{
					document.getElementById("FehlerListe").insertAdjacentHTML('beforeend', document.querySelectorAll('.E1018').length + " mal E1018: Wenn ein Datenfeld die Feldart 'Auswahl' hat, muss entweder eine Code- oder eine Werteliste zugeordnet sein." + "<xsl:text disable-output-escaping="yes">&lt;</xsl:text>br/<xsl:text disable-output-escaping="yes">&gt;</xsl:text>");
				}
				if (document.querySelectorAll('.E1019').length != 0)
				{
					document.getElementById("FehlerListe").insertAdjacentHTML('beforeend', document.querySelectorAll('.E1019').length + " mal E1019: Baukastenelemente, die in Regeln referenziert werden, d�rfen keine Versionsangaben beinhalten" + "<xsl:text disable-output-escaping="yes">&lt;</xsl:text>br/<xsl:text disable-output-escaping="yes">&gt;</xsl:text>");
				}
				if (document.querySelectorAll('.E1021').length != 0)
				{
					document.getElementById("FehlerListe").insertAdjacentHTML('beforeend', document.querySelectorAll('.E1021').length + " mal E1021: Es ist keine Multiplizit�t angegeben." + "<xsl:text disable-output-escaping="yes">&lt;</xsl:text>br/<xsl:text disable-output-escaping="yes">&gt;</xsl:text>");
				}
				if (document.querySelectorAll('.E1022').length != 0)
				{
					document.getElementById("FehlerListe").insertAdjacentHTML('beforeend', document.querySelectorAll('.E1022').length + " mal E1022: Bei Verwendung von Elementen mit der Strukturelementart 'abstrakt' oder 'harmonisiert' innerhalb von Datenfeldgruppen mit der Strukturelementart 'rechtsnormgebunden' muss zur Multiplizit�t ein Bezug zu einer Handlungsgrundlage angegeben werden." + "<xsl:text disable-output-escaping="yes">&lt;</xsl:text>br/<xsl:text disable-output-escaping="yes">&gt;</xsl:text>");
				}
				if (document.querySelectorAll('.E1023').length != 0)
				{
					document.getElementById("FehlerListe").insertAdjacentHTML('beforeend', document.querySelectorAll('.E1023').length + " mal E1023: Datenfeldgruppe hat keine Unterelemente." + "<xsl:text disable-output-escaping="yes">&lt;</xsl:text>br/<xsl:text disable-output-escaping="yes">&gt;</xsl:text>");
				}
				if (document.querySelectorAll('.E1024').length != 0)
				{
					document.getElementById("FehlerListe").insertAdjacentHTML('beforeend', document.querySelectorAll('.E1024').length + " mal E1024: Die Freitextregel muss bef�llt sein." + "<xsl:text disable-output-escaping="yes">&lt;</xsl:text>br/<xsl:text disable-output-escaping="yes">&gt;</xsl:text>");
				}
				if (document.querySelectorAll('.E1025').length != 0)
				{
					document.getElementById("FehlerListe").insertAdjacentHTML('beforeend', document.querySelectorAll('.E1025').length + " mal E1025: In einem Datenschema d�rfen Baukastenelement auf oberster Ebene nicht mehrfach in derselben Version enthalten sein." + "<xsl:text disable-output-escaping="yes">&lt;</xsl:text>br/<xsl:text disable-output-escaping="yes">&gt;</xsl:text>");
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
				if (document.querySelectorAll('.E1029').length != 0)
				{
					document.getElementById("FehlerListe").insertAdjacentHTML('beforeend', document.querySelectorAll('.E1029').length + " mal E1029: Unbekannte Relationsart." + "<xsl:text disable-output-escaping="yes">&lt;</xsl:text>br/<xsl:text disable-output-escaping="yes">&gt;</xsl:text>");
				}
				if (document.querySelectorAll('.E1030').length != 0)
				{
					document.getElementById("FehlerListe").insertAdjacentHTML('beforeend', document.querySelectorAll('.E1030').length + " mal E1030: Unbekannte Vorbef�llungsart." + "<xsl:text disable-output-escaping="yes">&lt;</xsl:text>br/<xsl:text disable-output-escaping="yes">&gt;</xsl:text>");
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
					document.getElementById("FehlerListe").insertAdjacentHTML('beforeend', document.querySelectorAll('.E1033').length + " mal E1033: Unbekannte �nderbarkeit der Struktur." + "<xsl:text disable-output-escaping="yes">&lt;</xsl:text>br/<xsl:text disable-output-escaping="yes">&gt;</xsl:text>");
				}
				if (document.querySelectorAll('.E1034').length != 0)
				{
					document.getElementById("FehlerListe").insertAdjacentHTML('beforeend', document.querySelectorAll('.E1034').length + " mal E1034: Unbekannte �nderbarkeit der Repr�sentation." + "<xsl:text disable-output-escaping="yes">&lt;</xsl:text>br/<xsl:text disable-output-escaping="yes">&gt;</xsl:text>");
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
				if (document.querySelectorAll('.E1041').length != 0)
				{
					document.getElementById("FehlerListe").insertAdjacentHTML('beforeend', document.querySelectorAll('.E1041').length + " mal E1041: Baukastenelemente, die in Regeln referenziert werden, verwenden noch die alte, verk�rzte Element-ID." + "<xsl:text disable-output-escaping="yes">&lt;</xsl:text>br/<xsl:text disable-output-escaping="yes">&gt;</xsl:text>");
				}
				if (document.querySelectorAll('.E1042').length != 0)
				{
					document.getElementById("FehlerListe").insertAdjacentHTML('beforeend', document.querySelectorAll('.E1042').length + " mal E1042: Unbekannte Gruppenart." + "<xsl:text disable-output-escaping="yes">&lt;</xsl:text>br/<xsl:text disable-output-escaping="yes">&gt;</xsl:text>");
				}
				if (document.querySelectorAll('.E1043').length != 0)
				{
					document.getElementById("FehlerListe").insertAdjacentHTML('beforeend', document.querySelectorAll('.E1043').length + " mal E1043: Eine Auswahlgruppe muss mindestens zwei Unterelemente haben." + "<xsl:text disable-output-escaping="yes">&lt;</xsl:text>br/<xsl:text disable-output-escaping="yes">&gt;</xsl:text>");
				}
				if (document.querySelectorAll('.E1044').length != 0)
				{
					document.getElementById("FehlerListe").insertAdjacentHTML('beforeend', document.querySelectorAll('.E1044').length + " mal E1044: Eine Werteliste muss mindestens zwei Eintr�ge haben." + "<xsl:text disable-output-escaping="yes">&lt;</xsl:text>br/<xsl:text disable-output-escaping="yes">&gt;</xsl:text>");
				}
				if (document.querySelectorAll('.E1045').length != 0)
				{
					document.getElementById("FehlerListe").insertAdjacentHTML('beforeend', document.querySelectorAll('.E1045').length + " mal E1045: Innerhalb einer Werteliste d�rfen Codes (Schl�ssel) nicht doppelt verwendet werden." + "<xsl:text disable-output-escaping="yes">&lt;</xsl:text>br/<xsl:text disable-output-escaping="yes">&gt;</xsl:text>");
				}
				if (document.querySelectorAll('.E1046').length != 0)
				{
					document.getElementById("FehlerListe").insertAdjacentHTML('beforeend', document.querySelectorAll('.E1046').length + " mal E1046: Die Multiplizit�t entspricht nicht den Formatvorgaben." + "<xsl:text disable-output-escaping="yes">&lt;</xsl:text>br/<xsl:text disable-output-escaping="yes">&gt;</xsl:text>");
				}
				if (document.querySelectorAll('.E1047').length != 0)
				{
					document.getElementById("FehlerListe").insertAdjacentHTML('beforeend', document.querySelectorAll('.E1047').length + " mal E1047: In der Multiplizit�t muss die minimale Anzahl kleiner oder gleich der maximalen Anzahl sein." + "<xsl:text disable-output-escaping="yes">&lt;</xsl:text>br/<xsl:text disable-output-escaping="yes">&gt;</xsl:text>");
				}
				if (document.querySelectorAll('.E1048').length != 0)
				{
					document.getElementById("FehlerListe").insertAdjacentHTML('beforeend', document.querySelectorAll('.E1048').length + " mal E1048: Die URN-Kennung einer Codeliste entspricht nicht den Formatvorgaben, z. B. urn:de:fim:codeliste:dokumenttyp (Umlaute sind nicht erlaubt!)." + "<xsl:text disable-output-escaping="yes">&lt;</xsl:text>br/<xsl:text disable-output-escaping="yes">&gt;</xsl:text>");
				}
				if (document.querySelectorAll('.E1049').length != 0)
				{
					document.getElementById("FehlerListe").insertAdjacentHTML('beforeend', document.querySelectorAll('.E1049').length + " mal E1049: Die Definition eines Dokumentsteckbriefs muss bef�llt sein." + "<xsl:text disable-output-escaping="yes">&lt;</xsl:text>br/<xsl:text disable-output-escaping="yes">&gt;</xsl:text>");
				}
				if (document.querySelectorAll('.E1050').length != 0)
				{
					document.getElementById("FehlerListe").insertAdjacentHTML('beforeend', document.querySelectorAll('.E1050').length + " mal E1050: Die Bezeichnung muss bef�llt sein." + "<xsl:text disable-output-escaping="yes">&lt;</xsl:text>br/<xsl:text disable-output-escaping="yes">&gt;</xsl:text>");
				}
				if (document.querySelectorAll('.E1051').length != 0)
				{
					document.getElementById("FehlerListe").insertAdjacentHTML('beforeend', document.querySelectorAll('.E1051').length + " mal E1051: Der Bezug zur Handlungsgrundlage darf nicht leer sein." + "<xsl:text disable-output-escaping="yes">&lt;</xsl:text>br/<xsl:text disable-output-escaping="yes">&gt;</xsl:text>");
				}
				if (document.querySelectorAll('.E1052').length != 0)
				{
					document.getElementById("FehlerListe").insertAdjacentHTML('beforeend', document.querySelectorAll('.E1052').length + " mal E1052: Der Bezug zur Handlungsgrundlage darf nur bei abstrakten Dokumentsteckbriefen leer sein." + "<xsl:text disable-output-escaping="yes">&lt;</xsl:text>br/<xsl:text disable-output-escaping="yes">&gt;</xsl:text>");
				}
				if (document.querySelectorAll('.E1053').length != 0)
				{
					document.getElementById("FehlerListe").insertAdjacentHTML('beforeend', document.querySelectorAll('.E1053').length + " mal E1053: Zu einem konkreten Dokumentsteckbrief d�rfen keine Dokumentsteckbriefe zugeordnet werden." + "<xsl:text disable-output-escaping="yes">&lt;</xsl:text>br/<xsl:text disable-output-escaping="yes">&gt;</xsl:text>");
				}
				if (document.querySelectorAll('.E1054').length != 0)
				{
					document.getElementById("FehlerListe").insertAdjacentHTML('beforeend', document.querySelectorAll('.E1054').length + " mal E1054: Zu einem abstrakten Dokumentsteckbrief m�ssen mindestens zwei Dokumentsteckbriefe zugeordnet werden." + "<xsl:text disable-output-escaping="yes">&lt;</xsl:text>br/<xsl:text disable-output-escaping="yes">&gt;</xsl:text>");
				}
				if (document.querySelectorAll('.E1055').length != 0)
				{
					document.getElementById("FehlerListe").insertAdjacentHTML('beforeend', document.querySelectorAll('.E1055').length + " mal E1055: Unbekannte Dokumentart." + "<xsl:text disable-output-escaping="yes">&lt;</xsl:text>br/<xsl:text disable-output-escaping="yes">&gt;</xsl:text>");
				}
				if (document.querySelectorAll('.E1056').length != 0)
				{
					document.getElementById("FehlerListe").insertAdjacentHTML('beforeend', document.querySelectorAll('.E1056').length + " mal E1056: Die Dateigr��e darf nur bef�llt sein, wenn der Datentyp des Datenfeldes den Wert 'Anlage (Datei)' hat." + "<xsl:text disable-output-escaping="yes">&lt;</xsl:text>br/<xsl:text disable-output-escaping="yes">&gt;</xsl:text>");
				}
				if (document.querySelectorAll('.E1057').length != 0)
				{
					document.getElementById("FehlerListe").insertAdjacentHTML('beforeend', document.querySelectorAll('.E1057').length + " mal E1057: Erlaubte Datentypen d�rfen nur angegeben werden, wenn der Datentyp des Datenfeldes den Wert 'Anlage (Datei)' hat." + "<xsl:text disable-output-escaping="yes">&lt;</xsl:text>br/<xsl:text disable-output-escaping="yes">&gt;</xsl:text>");
				}
				if (document.querySelectorAll('.E1058').length != 0)
				{
					document.getElementById("FehlerListe").insertAdjacentHTML('beforeend', document.querySelectorAll('.E1058').length + " mal E1058: Spaltendefinitionen d�rfen nur angegeben werden, wenn im Datenfeld eine referenzierte Codeliste enthalten ist." + "<xsl:text disable-output-escaping="yes">&lt;</xsl:text>br/<xsl:text disable-output-escaping="yes">&gt;</xsl:text>");
				}
				if (document.querySelectorAll('.E1059').length != 0)
				{
					document.getElementById("FehlerListe").insertAdjacentHTML('beforeend', document.querySelectorAll('.E1059').length + " mal E1059: Die minimale Feldl�nge muss eine ganze Zahl gr��er oder gleich Null sein." + "<xsl:text disable-output-escaping="yes">&lt;</xsl:text>br/<xsl:text disable-output-escaping="yes">&gt;</xsl:text>");
				}
				if (document.querySelectorAll('.E1060').length != 0)
				{
					document.getElementById("FehlerListe").insertAdjacentHTML('beforeend', document.querySelectorAll('.E1060').length + " mal E1060: Die maximale Feldl�nge muss eine ganze Zahl gr��er Null sein." + "<xsl:text disable-output-escaping="yes">&lt;</xsl:text>br/<xsl:text disable-output-escaping="yes">&gt;</xsl:text>");
				}
				if (document.querySelectorAll('.E1061').length != 0)
				{
					document.getElementById("FehlerListe").insertAdjacentHTML('beforeend', document.querySelectorAll('.E1061').length + " mal E1061: Die minimale Feldl�nge darf nicht gr��er sein als die maximale Feldl�nge." + "<xsl:text disable-output-escaping="yes">&lt;</xsl:text>br/<xsl:text disable-output-escaping="yes">&gt;</xsl:text>");
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
					document.getElementById("FehlerListe").insertAdjacentHTML('beforeend', document.querySelectorAll('.E1064').length + " mal E1064: Die untere Wertgrenze darf nicht gr��er sein als die obere Wertgrenze." + "<xsl:text disable-output-escaping="yes">&lt;</xsl:text>br/<xsl:text disable-output-escaping="yes">&gt;</xsl:text>");
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
					document.getElementById("FehlerListe").insertAdjacentHTML('beforeend', document.querySelectorAll('.E1073').length + " mal E1073: Der Inhalt �berschreitet die obere Wertgrenze." + "<xsl:text disable-output-escaping="yes">&lt;</xsl:text>br/<xsl:text disable-output-escaping="yes">&gt;</xsl:text>");
				}
				if (document.querySelectorAll('.E1074').length != 0)
				{
					document.getElementById("FehlerListe").insertAdjacentHTML('beforeend', document.querySelectorAll('.E1074').length + " mal E1074: Der Inhalt unterschreitet die Minimall�nge." + "<xsl:text disable-output-escaping="yes">&lt;</xsl:text>br/<xsl:text disable-output-escaping="yes">&gt;</xsl:text>");
				}
				if (document.querySelectorAll('.E1075').length != 0)
				{
					document.getElementById("FehlerListe").insertAdjacentHTML('beforeend', document.querySelectorAll('.E1075').length + " mal E1075: Der Inhalt �berschreitet die Maximall�nge." + "<xsl:text disable-output-escaping="yes">&lt;</xsl:text>br/<xsl:text disable-output-escaping="yes">&gt;</xsl:text>");
				}
				if (document.querySelectorAll('.E1077').length != 0)
				{
					document.getElementById("FehlerListe").insertAdjacentHTML('beforeend', document.querySelectorAll('.E1077').length + " mal E1077: Der Inhalt muss ein Wahrheitswert sein (true oder false)." + "<xsl:text disable-output-escaping="yes">&lt;</xsl:text>br/<xsl:text disable-output-escaping="yes">&gt;</xsl:text>");
				}
				if (document.querySelectorAll('.E1078').length != 0)
				{
					document.getElementById("FehlerListe").insertAdjacentHTML('beforeend', document.querySelectorAll('.E1078').length + " mal E1078: Ein Datenschema muss mindestens ein Unterlement enthalten." + "<xsl:text disable-output-escaping="yes">&lt;</xsl:text>br/<xsl:text disable-output-escaping="yes">&gt;</xsl:text>");
				}
				if (document.querySelectorAll('.E1079').length != 0)
				{
					document.getElementById("FehlerListe").insertAdjacentHTML('beforeend', document.querySelectorAll('.E1079').length + " mal E1079: Die untere Wertgrenze muss ein Zeitpunkt (Datum und Uhrzeit) sein." + "<xsl:text disable-output-escaping="yes">&lt;</xsl:text>br/<xsl:text disable-output-escaping="yes">&gt;</xsl:text>");
				}
				if (document.querySelectorAll('.E1080').length != 0)
				{
					document.getElementById("FehlerListe").insertAdjacentHTML('beforeend', document.querySelectorAll('.E1080').length + " mal E1080: Die obere Wertgrenze muss ein Zeitpunkt (Datum und Uhrzeit) sein." + "<xsl:text disable-output-escaping="yes">&lt;</xsl:text>br/<xsl:text disable-output-escaping="yes">&gt;</xsl:text>");
				}
				if (document.querySelectorAll('.E1081').length != 0)
				{
					document.getElementById("FehlerListe").insertAdjacentHTML('beforeend', document.querySelectorAll('.E1081').length + " mal E1081: Die untere Wertgrenze muss eine Uhrzeit sein." + "<xsl:text disable-output-escaping="yes">&lt;</xsl:text>br/<xsl:text disable-output-escaping="yes">&gt;</xsl:text>");
				}
				if (document.querySelectorAll('.E1082').length != 0)
				{
					document.getElementById("FehlerListe").insertAdjacentHTML('beforeend', document.querySelectorAll('.E1082').length + " mal E1082: Die obere Wertgrenze muss eine Uhrzeit sein." + "<xsl:text disable-output-escaping="yes">&lt;</xsl:text>br/<xsl:text disable-output-escaping="yes">&gt;</xsl:text>");
				}
				if (document.querySelectorAll('.E1083').length != 0)
				{
					document.getElementById("FehlerListe").insertAdjacentHTML('beforeend', document.querySelectorAll('.E1083').length + " mal E1083: Der Inhalt muss ein Zeitpunkt (Datum und Uhrzeit) sein." + "<xsl:text disable-output-escaping="yes">&lt;</xsl:text>br/<xsl:text disable-output-escaping="yes">&gt;</xsl:text>");
				}
				if (document.querySelectorAll('.E1084').length != 0)
				{
					document.getElementById("FehlerListe").insertAdjacentHTML('beforeend', document.querySelectorAll('.E1084').length + " mal E1084: Der Inhalt muss eine Uhrzeit sein." + "<xsl:text disable-output-escaping="yes">&lt;</xsl:text>br/<xsl:text disable-output-escaping="yes">&gt;</xsl:text>");
				}
				if (document.querySelectorAll('.E1085').length != 0)
				{
					document.getElementById("FehlerListe").insertAdjacentHTML('beforeend', document.querySelectorAll('.E1085').length + " mal E1085: Der Inhalt muss ein Code-Wert der Werteliste sein." + "<xsl:text disable-output-escaping="yes">&lt;</xsl:text>br/<xsl:text disable-output-escaping="yes">&gt;</xsl:text>");
				}
<!-- offen
				if (document.querySelectorAll('.E1086').length != 0)
				{
					document.getElementById("FehlerListe").insertAdjacentHTML('beforeend', document.querySelectorAll('.E1086').length + " mal E1086: Der Inhalt muss ein Code-Wert der referenzierten Codeliste sein." + "<xsl:text disable-output-escaping="yes">&lt;</xsl:text>br/<xsl:text disable-output-escaping="yes">&gt;</xsl:text>");
				}
-->
				if (document.querySelectorAll('.E1087').length != 0)
				{
					document.getElementById("FehlerListe").insertAdjacentHTML('beforeend', document.querySelectorAll('.E1087').length + " mal E1087: Relation zu einem unzul�ssigen Objekt." + "<xsl:text disable-output-escaping="yes">&lt;</xsl:text>br/<xsl:text disable-output-escaping="yes">&gt;</xsl:text>");
				}
				if (document.querySelectorAll('.E1088').length != 0)
				{
					document.getElementById("FehlerListe").insertAdjacentHTML('beforeend', document.querySelectorAll('.E1088').length + " mal E1088: Diese Relation darf in diesem Objekt nicht verwendet werden." + "<xsl:text disable-output-escaping="yes">&lt;</xsl:text>br/<xsl:text disable-output-escaping="yes">&gt;</xsl:text>");
				}

				if (document.querySelectorAll('.W1001').length != 0)
				{
					document.getElementById("WarnungsListe").insertAdjacentHTML('beforeend', document.querySelectorAll('.W1001').length + " mal W1001: Der Bezug zur Handlungsgrundlage sollte bei Elementen mit der Strukturelementart 'harmonisiert' m�glichst nicht leer sein." + "<xsl:text disable-output-escaping="yes">&lt;</xsl:text>br/<xsl:text disable-output-escaping="yes">&gt;</xsl:text>");
				}
				if (document.querySelectorAll('.W1002').length != 0)
				{
					document.getElementById("WarnungsListe").insertAdjacentHTML('beforeend', document.querySelectorAll('.W1002').length + " mal W1002: Bei Eingabedatenfeldern mit dem Datentyp 'Text' oder 'String.Latin+' sollten, wenn m�glich, die minimale und maximale Feldl�nge angegeben werden." + "<xsl:text disable-output-escaping="yes">&lt;</xsl:text>br/<xsl:text disable-output-escaping="yes">&gt;</xsl:text>");
				}
				if (document.querySelectorAll('.W1003').length != 0)
				{
					document.getElementById("WarnungsListe").insertAdjacentHTML('beforeend', document.querySelectorAll('.W1003').length + " mal W1003: Bei Datenfeldern mit dem Datentyp 'Nummer', 'Ganzzahl' oder 'Geldbetrag' sollte, wenn m�glich, ein Wertebereich angegeben werden." + "<xsl:text disable-output-escaping="yes">&lt;</xsl:text>br/<xsl:text disable-output-escaping="yes">&gt;</xsl:text>");
				}

<!--				
				if (document.querySelectorAll('.W1004').length != 0)
				{
					document.getElementById("WarnungsListe").insertAdjacentHTML('beforeend', document.querySelectorAll('.W1004').length + " mal W1004: Zu einer Regel ist kein Script definiert" + "<xsl:text disable-output-escaping="yes">&lt;</xsl:text>br/<xsl:text disable-output-escaping="yes">&gt;</xsl:text>");
				}
-->

				if (document.querySelectorAll('.W1006').length != 0)
				{
					document.getElementById("WarnungsListe").insertAdjacentHTML('beforeend', document.querySelectorAll('.W1006').length + " mal W1006: Eine Datenfeldgruppe sollte mehr als ein Unterelement haben." + "<xsl:text disable-output-escaping="yes">&lt;</xsl:text>br/<xsl:text disable-output-escaping="yes">&gt;</xsl:text>");
				}
				if (document.querySelectorAll('.W1007').length != 0)
				{
					document.getElementById("WarnungsListe").insertAdjacentHTML('beforeend', document.querySelectorAll('.W1007').length + " mal W1007: Der Hilfetext eines Dokumentsteckbriefs sollte bef�llt werden." + "<xsl:text disable-output-escaping="yes">&lt;</xsl:text>br/<xsl:text disable-output-escaping="yes">&gt;</xsl:text>");
				}
				if (document.querySelectorAll('.W1008').length != 0)
				{
					document.getElementById("WarnungsListe").insertAdjacentHTML('beforeend', document.querySelectorAll('.W1008').length + " mal W1008: Wenn ein Datenfeld die Feldart 'Auswahl' hat, sollte der Datentyp i. d. R. vom Typ 'Text' sein." + "<xsl:text disable-output-escaping="yes">&lt;</xsl:text>br/<xsl:text disable-output-escaping="yes">&gt;</xsl:text>");
				}
				if (document.querySelectorAll('.W1009').length != 0)
				{
					document.getElementById("WarnungsListe").insertAdjacentHTML('beforeend', document.querySelectorAll('.W1009').length + " mal W1009: Bei einem Feld mit nur lesendem Zugriff, der Feldart 'Statisch' wird i. d. R. der Inhalt mit einem Text bef�llt." + "<xsl:text disable-output-escaping="yes">&lt;</xsl:text>br/<xsl:text disable-output-escaping="yes">&gt;</xsl:text>");
				}
				if (document.querySelectorAll('.W1011').length != 0)
				{
					document.getElementById("WarnungsListe").insertAdjacentHTML('beforeend', document.querySelectorAll('.W1011').length + " mal W1011: Codeliste wird nicht verwendet." + "<xsl:text disable-output-escaping="yes">&lt;</xsl:text>br/<xsl:text disable-output-escaping="yes">&gt;</xsl:text>");
				}
				if (document.querySelectorAll('.W1015').length != 0)
				{
					document.getElementById("WarnungsListe").insertAdjacentHTML('beforeend', document.querySelectorAll('.W1015').length + " mal W1015: Die Codeliste konnte nicht geladen werden." + "<xsl:text disable-output-escaping="yes">&lt;</xsl:text>br/<xsl:text disable-output-escaping="yes">&gt;</xsl:text>");
				}
				if (document.querySelectorAll('.W1016').length != 0)
				{
					document.getElementById("WarnungsListe").insertAdjacentHTML('beforeend', document.querySelectorAll('.W1016').length + " mal W1016: Baukastenelemente im Status 'inaktiv' sollten nur in Ausnahmef�llen verwendet werden." + "<xsl:text disable-output-escaping="yes">&lt;</xsl:text>br/<xsl:text disable-output-escaping="yes">&gt;</xsl:text>");
				}
			</xsl:if>
			}

		</script>
		</xsl:if>
	</xsl:template>
</xsl:stylesheet>
