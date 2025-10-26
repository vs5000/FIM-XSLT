<?xml version="1.0" encoding="iso-8859-1"?>
<xsl:stylesheet 
	version="2.0" 
	xmlns:xsl="http://www.w3.org/1999/XSL/Transform" 
	xmlns:html="http://www.w3.org/1999/xhtml" 
	xmlns="http://www.w3.org/1999/xhtml" 
	xmlns:fn="http://www.w3.org/2005/xpath-functions" 
	xmlns:xdf="urn:xoev-de:fim:standard:xdatenfelder_2" 
	xmlns:gc="http://docs.oasis-open.org/codelist/ns/genericode/1.0/" 
	exclude-result-prefixes="html">
	
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
	<xsl:output method="xhtml" doctype-system="http://www.w3.org/TR/xhtml11/DTD/xhtml11.dtd" doctype-public="-//W3C//DTD XHTML 1.1//EN" omit-xml-declaration="yes"/>

	<xsl:strip-space elements="*"/>

	<xsl:param name="DateiOutput" select="'0'"/>

	<xsl:param name="Navigation" select="'1'"/>
	<xsl:param name="Infobox" select="'1'"/>
	<xsl:param name="Copybutton" select="'1'"/>

	<xsl:param name="ZeigeDaten" select="'0'"/>

	<xsl:param name="ToolAufruf" select="'0'"/>
	<xsl:param name="ToolPfadPrefix" select="'https://www.fim-formular.niedersachsen.de/fim/portal/fim/9/client/index.html#/datenmodellierung/'"/>
	<xsl:param name="ToolPfadPostfix" select="''"/>

	<xsl:param name="DebugMode" select="'3'"/>

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
				DateiOutput: <xsl:value-of select="$DateiOutput"/>
				Navigation: <xsl:value-of select="$Navigation"/>
				Infobox: <xsl:value-of select="$Infobox"/>
				Copybutton: <xsl:value-of select="$Copybutton"/>
				ToolAufruf: <xsl:value-of select="$ToolAufruf"/>
				ToolPfadPrefix: <xsl:value-of select="$ToolPfadPrefix"/>
				ToolPfadPostfix: <xsl:value-of select="$ToolPfadPostfix"/>
				DebugMode: <xsl:value-of select="$DebugMode"/>
			</xsl:message>
		</xsl:if>
		<xsl:choose>
			<xsl:when test="$DateiOutput ='1'">
				<xsl:variable name="OutputDateiname">
					<xsl:choose>
						<xsl:when test="name(/*) ='xdf:xdatenfelder.stammdatenschema.0102'">Visualisierung_<xsl:value-of select="/*/xdf:stammdatenschema/xdf:identifikation/xdf:id"/>
							<xsl:if test="/*/xdf:stammdatenschema/xdf:identifikation/xdf:version">V<xsl:value-of select="/*/xdf:stammdatenschema/xdf:identifikation/xdf:version"/>
							</xsl:if>.html</xsl:when>
						<xsl:when test="name(/*) ='xdf:xdatenfelder.datenfeldgruppe.0103'">Visualisierung_<xsl:value-of select="//xdf:xdatenfelder.datenfeldgruppe.0103/xdf:datenfeldgruppe/xdf:identifikation/xdf:id"/>
								<xsl:if test="//xdf:xdatenfelder.datenfeldgruppe.0103/xdf:datenfeldgruppe/xdf:identifikation/xdf:version">V<xsl:value-of select="//xdf:xdatenfelder.datenfeldgruppe.0103/xdf:datenfeldgruppe/xdf:identifikation/xdf:version"/></xsl:if>.html</xsl:when>
						<xsl:otherwise>Visualisierung_FEHLER.html</xsl:otherwise>
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
						<title>Visualisierung des Stammdatenschemas <xsl:value-of select="/*/xdf:stammdatenschema/xdf:identifikation/xdf:id"/>
							<xsl:if test="/*/xdf:stammdatenschema/xdf:identifikation/xdf:version"> Version <xsl:value-of select="/*/xdf:stammdatenschema/xdf:identifikation/xdf:version"/>
							</xsl:if>
						</title>
					</xsl:when>
					<xsl:when test="name(/*) ='xdf:xdatenfelder.datenfeldgruppe.0103'">
						<title>Visualisierung der Datenfeldgruppe <xsl:value-of select="//xdf:xdatenfelder.datenfeldgruppe.0103/xdf:datenfeldgruppe/xdf:identifikation/xdf:id"/>
							<xsl:if test="//xdf:xdatenfelder.datenfeldgruppe.0103/xdf:datenfeldgruppe/xdf:identifikation/xdf:version"> Version <xsl:value-of select="//xdf:xdatenfelder.datenfeldgruppe.0103/xdf:datenfeldgruppe/xdf:identifikation/xdf:version"/>
							</xsl:if>
						</title>
					</xsl:when>
					<xsl:otherwise>
						<title>Unbekanntes Dateiformat</title>
					</xsl:otherwise>
				</xsl:choose>
				<meta name="author" content="Volker Schmitz"/>
				<xsl:call-template name="style"/>
			</head>
			<body onload="onloadFunktion()">
				<xsl:variable name="Hinweistext">
					<p><b>Hilfe</b></p>
					<ul>
						<li>kursiv = optional</li>
						<li>mit +/- = mehrfach angebbar</li>
						<li>Klick auf Feldgruppennamen = Feldgruppe auf-/zuklappen</li>
						<li>Klick auf ein <span class="HilfeHilfetext">?</span> = Hilfetext auf-/zuklappen</li>
						<xsl:if test="$Infobox = '1'">
							<li>Klick auf ein <span class="InfoboxHilfetext">i</span> = interne Infos auf-/zuklappen</li>
						</xsl:if>
						<xsl:if test="$Copybutton = '1'">
							<li>Klick auf ein <span class="ClippbuttonHilfetext">k</span> = ID des Elements in Zwischenablage kopieren</li>
						</xsl:if>
						<xsl:if test="$ToolAufruf = '1'">
							<li>Klick auf einen &#8658; = öffnet den hinterlegten Editor mit dem Element</li>
						</xsl:if>
					</ul>
					<div class="Hinweisklein">
						<p><b>Hinweis</b></p>
						<p>Diese Ansicht ist eine mögliche, limitierte Visualisierung der Umsetzung des Stammdatenschemas. Sie dient dazu die Inhalte des Stammdatenschemas leichter einzuschätzen und qualitätszusichern.</p>
						<p>Die gewählte Visualisierung hat keinerlei normativen Charakter und stellt somit keinerlei Empfehlung für die Umsetzung dar.</p>
						<p>Es werden keine Regeln des Stammdatenschemas umgesetzt. Dies hat zur Folge, dass im Vergleich zu einer realen Implementierung deutlich mehr alternative, optionale Felder und Feldgruppen angezeigt werden.</p>
						<p>Bei Nutzung der Browser Edge, Firefox oder Opera in einer aktuellen Version sollte der intendierte Funktionsumfang erreicht werden.</p>
					</div>
					</xsl:variable>
				<xsl:if test="$Navigation = '1'">
					<div id="fixiert" class="Navigation">
						<p align="right">
							<a href="#" title="Schließe das Navigationsfenster" onclick="VersteckeNavigation(); return false;">&#10006;</a>
						</p>
						<h2>Funktionen</h2>
						<xsl:choose>
							<xsl:when test="name(/*) ='xdf:xdatenfelder.stammdatenschema.0102'">
								<p id="alleZuklappen">
									<a href="#" onclick="Zuklappen(); return false;">Klappe alle Feldgruppen zu</a>
								</p>
								<p id="alleAufklappen">
									<a href="#" onclick="Aufklappen(); return false;">Klappe alle Feldgruppen auf</a>
								</p>
								<xsl:if test="$Infobox = '1' or $Copybutton = '1'">
									<p>
										<br/>
									</p>
								</xsl:if>
								<xsl:if test="$Infobox = '1'">
									<p id="versteckeLinkInfoboxen">
										<a href="#" onclick="VersteckeInfoboxen(); return false;">Blende Infos aus</a>
									</p>
									<p id="zeigeLinkInfoboxen">
										<a href="#" onclick="ZeigeInfoboxen(); return false;">Zeige Infos an</a>
									</p>
								</xsl:if>
								<xsl:if test="$Copybutton = '1'">
									<p id="versteckeLinkCopy">
										<a href="#" onclick="VersteckeCopybutton(); return false;">Blende Kopierknopf aus</a>
									</p>
									<p id="zeigeLinkCopy">
										<a href="#" onclick="ZeigeCopybutton(); return false;">Zeige Kopierknopf an</a>
									</p>
								</xsl:if>
								<xsl:if test="$ToolAufruf = '1'">
									<p id="versteckeLinkTool">
										<a href="#" onclick="VersteckeToolbutton(); return false;">Blende Toolaufruf aus</a>
									</p>
									<p id="zeigeLinkTool">
										<a href="#" onclick="ZeigeToolbutton(); return false;">Zeige Toolaufruf an</a>
									</p>
								</xsl:if>
								<p>
									<br/>
								</p>
								<xsl:copy-of select="$Hinweistext"/>
							</xsl:when>
							<xsl:when test="name(/*) ='xdf:xdatenfelder.datenfeldgruppe.0103'">
								<p id="alleZuklappen">
									<a href="#" onclick="Zuklappen(); return false;">Klappe alle Feldgruppen zu</a>
								</p>
								<p id="alleAufklappen">
									<a href="#" onclick="Aufklappen(); return false;">Klappe alle Feldgruppen auf</a>
								</p>
								<xsl:if test="$Infobox = '1' or $Copybutton = '1'">
									<p>
										<br/>
									</p>
								</xsl:if>
								<xsl:if test="$Infobox = '1'">
									<p id="versteckeLinkInfoboxen">
										<a href="#" onclick="VersteckeInfoboxen(); return false;">Blende Infos aus</a>
									</p>
									<p id="zeigeLinkInfoboxen">
										<a href="#" onclick="ZeigeInfoboxen(); return false;">Zeige Infos an</a>
									</p>
								</xsl:if>
								<xsl:if test="$Copybutton = '1'">
									<p id="versteckeLinkCopy">
										<a href="#" onclick="VersteckeCopybutton(); return false;">Blende Kopierknopf aus</a>
									</p>
									<p id="zeigeLinkCopy">
										<a href="#" onclick="ZeigeCopybutton(); return false;">Zeige Kopierknopf an</a>
									</p>
								</xsl:if>
								<xsl:if test="$ToolAufruf = '1'">
									<p id="versteckeLinkTool">
										<a href="#" onclick="VersteckeToolbutton(); return false;">Blende Toolaufruf aus</a>
									</p>
									<p id="zeigeLinkTool">
										<a href="#" onclick="ZeigeToolbutton(); return false;">Zeige Toolaufruf an</a>
									</p>
								</xsl:if>
								<p>
									<br/>
								</p>
								<xsl:copy-of select="$Hinweistext"/>
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
							<form name="SDSForm" class="SDSForm">
								<xsl:call-template name="stammdatenschemaeinzeln"/>
								
								<xsl:choose>
									<xsl:when test="$Navigation = '1'">
										<div id="Hinweis" style="display: none">
											<xsl:copy-of select="$Hinweistext"/>
										</div>
									</xsl:when>
									<xsl:otherwise>
										<div id="Hinweis" style="display: block">
											<xsl:copy-of select="$Hinweistext"/>
										</div>
									</xsl:otherwise>
								</xsl:choose>
							</form>
							
							<xsl:if test="$ZeigeDaten = '1'">
								<p><button type="button" id="zeigeDaten" class="button" onclick="zeigeDaten()">Daten anzeigen</button>       <button type="button" id="versteckeDaten" class="button buttonunsichtbar" onclick="versteckeDaten()">Daten nicht anzeigen</button></p>
								<p id="DatenListe"></p>
							</xsl:if>
							
							<p>Erstellt am: <xsl:value-of select="format-date(fn:current-date(),'[D01].[M01].[Y0001]')"/> um <xsl:value-of select="format-time(fn:current-time(),'[H01]:[m01]')"/> Uhr</p>
							<p>XSLT: <xsl:value-of select="tokenize($StyleSheetURI, '/')[last()]"/>
							</p>
							<p>XML: <xsl:value-of select="tokenize($DocumentURI, '/')[last()]"/>
							</p>
						</xsl:when>
						<xsl:when test="name(/*) ='xdf:xdatenfelder.datenfeldgruppe.0103'">
							<xsl:call-template name="datenfeldgruppeeinzeln"/>
							
							<xsl:choose>
								<xsl:when test="$Navigation = '1'">
									<div id="Hinweis" style="display: none">
										<xsl:copy-of select="$Hinweistext"/>
									</div>
								</xsl:when>
								<xsl:otherwise>
									<div id="Hinweis" style="display: block">
										<xsl:copy-of select="$Hinweistext"/>
									</div>
								</xsl:otherwise>
							</xsl:choose>
							
							
							<p>Erstellt am: <xsl:value-of select="format-date(fn:current-date(),'[D01].[M01].[Y0001]')"/> um <xsl:value-of select="format-time(fn:current-time(),'[H01]:[m01]')"/> Uhr</p>
							<p>XSLT: <xsl:value-of select="tokenize($StyleSheetURI, '/')[last()]"/>
							</p>
							<p>XML: <xsl:value-of select="tokenize($DocumentURI, '/')[last()]"/>
							</p>
						</xsl:when>
						<xsl:otherwise>
							<p>Unbekanntes Dateiformat</p>
						</xsl:otherwise>
					</xsl:choose>
				</div>
				<xsl:call-template name="script"/>
			</body>
		</html>
	</xsl:template>
	<!-- ############################################################################################################# -->
	<xsl:template name="stammdatenschemaeinzeln">
		<xsl:if test="$DebugMode = '1' or $DebugMode = '2' or $DebugMode = '3' or $DebugMode = '4'">
			<xsl:message>
				++++ stammdatenschemaeinzeln ++++
			</xsl:message>
		</xsl:if>
		<xsl:variable name="AktuellerBaum"><xsl:value-of select="/*/xdf:stammdatenschema/xdf:identifikation/xdf:id"/>.</xsl:variable>
		
		<xsl:variable name="IDVersion"><xsl:value-of select="/*/xdf:stammdatenschema/xdf:identifikation/xdf:id"/><xsl:if test="/*/xdf:stammdatenschema/xdf:identifikation/xdf:version">V<xsl:value-of select="/*/xdf:stammdatenschema/xdf:identifikation/xdf:version"/></xsl:if></xsl:variable>

		<div class="SDS">
			<div class="SDSBezeichnung">
				<xsl:element name="input">
					<xsl:attribute name="type">hidden</xsl:attribute>
					<xsl:attribute name="id">minCount</xsl:attribute>
					<xsl:attribute name="name">minCount</xsl:attribute>
					<xsl:attribute name="value">1</xsl:attribute>						
				</xsl:element>
				<xsl:element name="input">
					<xsl:attribute name="type">hidden</xsl:attribute>
					<xsl:attribute name="id">maxCount</xsl:attribute>
					<xsl:attribute name="name">maxCount</xsl:attribute>
					<xsl:attribute name="value">1</xsl:attribute>						
				</xsl:element>
				<xsl:element name="input">
					<xsl:attribute name="type">hidden</xsl:attribute>
					<xsl:attribute name="id">ID</xsl:attribute>
					<xsl:attribute name="name">ID</xsl:attribute>
					<xsl:attribute name="value"><xsl:value-of select="/*/xdf:stammdatenschema/xdf:identifikation/xdf:id"/></xsl:attribute>
				</xsl:element>
				<xsl:value-of select="/*/xdf:stammdatenschema/xdf:bezeichnungEingabe"/>
				<xsl:if test="fn:not(empty(/*/xdf:stammdatenschema/xdf:hilfetextEingabe/text()))">
					&#160;&#160;
					<div class="Hilfe" onclick="ZeigeBox(this)">?
						<div class="Popuptext"><xsl:value-of select="/*/xdf:stammdatenschema/xdf:hilfetextEingabe"/></div>
					</div>
				</xsl:if>

				<xsl:if test="$Infobox = '1'">

					<xsl:variable name="Infoboxinhalt">
						<b>Stammdatenschema-ID:&#160;&#160;</b><xsl:value-of select="$IDVersion"/><br/>
						<b>Name:&#160;&#160;</b><xsl:value-of select="/*/xdf:stammdatenschema/xdf:name"/><br/><br/>
					</xsl:variable>

					<xsl:variable name="Infoboxinhalt2">
						<xsl:for-each select="/*/xdf:stammdatenschema/xdf:regel">
							<b>Regel-ID:&#160;&#160;</b><xsl:value-of select="./xdf:identifikation/xdf:id"/><xsl:if test="./xdf:identifikation/xdf:version">V<xsl:value-of select="./xdf:identifikation/xdf:version"/></xsl:if><br/>
							<b>Name:&#160;&#160;</b><xsl:value-of select="./xdf:name"/><br/>
							<b>Definition:&#160;&#160;</b><xsl:value-of select="./xdf:definition"/><br/><br/>
						</xsl:for-each>
					</xsl:variable>

					<xsl:variable name="Infoboxinhalt3">
						<b>Bezug zur Handlungsgrundlage:&#160;&#160;</b><xsl:value-of select="/*/xdf:stammdatenschema/xdf:bezug"/><br/><br/>
					</xsl:variable>

					&#160;&#160;&#160;&#160;
					<div class="Infobox" onclick="ZeigeBox(this)">i
						<div class="Popuptext"><xsl:copy-of select="$Infoboxinhalt"/><xsl:copy-of select="$Infoboxinhalt3"/><xsl:copy-of select="$Infoboxinhalt2"/></div>
					</div>
				</xsl:if>

				<xsl:if test="$Copybutton = '1'">
					&#160;&#160;
					<xsl:element name="span">
						<xsl:attribute name="class">Clipbutton</xsl:attribute>
						<xsl:attribute name="onclick">copyStringToClipboard(this,"<xsl:value-of select="$IDVersion"/>")</xsl:attribute>
						k
					</xsl:element>
				</xsl:if>
		
				<xsl:if test="$ToolAufruf = '1'">
					&#160;&#160;
					<xsl:element name="a">
						<xsl:attribute name="href"><xsl:value-of select="$ToolPfadPrefix"/><xsl:value-of select="$IDVersion"/><xsl:value-of select="$ToolPfadPostfix"/></xsl:attribute>
						<xsl:attribute name="target">FIMTool</xsl:attribute>
						<xsl:attribute name="title">Springe in den Datenfeldeditor (man muss vorher angemeldet sein).</xsl:attribute>
						<xsl:attribute name="class">Toolbutton</xsl:attribute>
						&#8658;
					</xsl:element>
				</xsl:if>
				
			</div>
			<xsl:call-template name="stammdatenschemadetailszustammdatenschema">
				<xsl:with-param name="Element" select="/*/xdf:stammdatenschema"/>
				<xsl:with-param name="ElternBaum" select="$AktuellerBaum"/>
			</xsl:call-template>
			<xsl:if test="$ZeigeDaten = '1'">
				<p><button type="reset" id="reset" class="button">Daten zurücksetzen</button></p>
			</xsl:if>
		</div>
	</xsl:template>

	<!-- ############################################################################################################# -->
	<xsl:template name="datenfeldgruppeeinzeln">
		<xsl:if test="$DebugMode = '1' or $DebugMode = '2' or $DebugMode = '3' or $DebugMode = '4'">
			<xsl:message>
				++++ stammdatenschemaeinzeln ++++
			</xsl:message>
		</xsl:if>
		<xsl:variable name="AktuellerBaum"><xsl:value-of select="//xdf:xdatenfelder.datenfeldgruppe.0103/xdf:datenfeldgruppe/xdf:identifikation/xdf:id"/>.</xsl:variable>

		<xsl:variable name="IDVersion"><xsl:value-of select="//xdf:xdatenfelder.datenfeldgruppe.0103/xdf:datenfeldgruppe/xdf:identifikation/xdf:id"/><xsl:if test="//xdf:xdatenfelder.datenfeldgruppe.0103/xdf:datenfeldgruppe/xdf:identifikation/xdf:version">V<xsl:value-of select="//xdf:xdatenfelder.datenfeldgruppe.0103/xdf:datenfeldgruppe/xdf:identifikation/xdf:version"/></xsl:if></xsl:variable>

		<div class="SDS">
			<div class="SDSBezeichnung">
				<xsl:element name="input">
					<xsl:attribute name="type">hidden</xsl:attribute>
					<xsl:attribute name="id">minCount</xsl:attribute>
					<xsl:attribute name="name">minCount</xsl:attribute>
					<xsl:attribute name="value">1</xsl:attribute>						
				</xsl:element>
				<xsl:element name="input">
					<xsl:attribute name="type">hidden</xsl:attribute>
					<xsl:attribute name="id">maxCount</xsl:attribute>
					<xsl:attribute name="name">maxCount</xsl:attribute>
					<xsl:attribute name="value">1</xsl:attribute>						
				</xsl:element>
				<xsl:element name="input">
					<xsl:attribute name="type">hidden</xsl:attribute>
					<xsl:attribute name="id">ID</xsl:attribute>
					<xsl:attribute name="name">ID</xsl:attribute>
					<xsl:attribute name="value"><xsl:value-of select="//xdf:xdatenfelder.datenfeldgruppe.0103/xdf:datenfeldgruppe/xdf:identifikation/xdf:id"/></xsl:attribute>
				</xsl:element>
				<xsl:value-of select="//xdf:xdatenfelder.datenfeldgruppe.0103/xdf:datenfeldgruppe/xdf:bezeichnungEingabe"/>
				<xsl:if test="fn:not(empty(//xdf:xdatenfelder.datenfeldgruppe.0103/xdf:datenfeldgruppe/xdf:hilfetextEingabe/text()))">
					&#160;&#160;
					<div class="Hilfe" onclick="ZeigeBox(this)">?
						<div class="Popuptext"><xsl:value-of select="//xdf:xdatenfelder.datenfeldgruppe.0103/xdf:datenfeldgruppe/xdf:hilfetextEingabe"/></div>
					</div>
				</xsl:if>

				<xsl:if test="$Infobox = '1'">

					<xsl:variable name="Infoboxinhalt">
						<b>Datenfeldgruppen-ID:&#160;&#160;</b><xsl:value-of select="$IDVersion"/><br/>
						<b>Name:&#160;&#160;</b><xsl:value-of select="//xdf:xdatenfelder.datenfeldgruppe.0103/xdf:datenfeldgruppe/xdf:name"/><br/><br/>
					</xsl:variable>

					<xsl:variable name="Infoboxinhalt2">
						<xsl:for-each select="//xdf:xdatenfelder.datenfeldgruppe.0103/xdf:datenfeldgruppe/xdf:regel">
							<b>Regel-ID:&#160;&#160;</b><xsl:value-of select="./xdf:identifikation/xdf:id"/><xsl:if test="./xdf:identifikation/xdf:version">V<xsl:value-of select="./xdf:identifikation/xdf:version"/></xsl:if><br/>
							<b>Name:&#160;&#160;</b><xsl:value-of select="./xdf:name"/><br/>
							<b>Definition:&#160;&#160;</b><xsl:value-of select="./xdf:definition"/><br/><br/>
						</xsl:for-each>
					</xsl:variable>

					<xsl:variable name="Infoboxinhalt3">
						<b>Bezug zur Handlungsgrundlage:&#160;&#160;</b><xsl:value-of select="//xdf:xdatenfelder.datenfeldgruppe.0103/xdf:datenfeldgruppe/xdf:bezug"/><br/><br/>
					</xsl:variable>

					&#160;&#160;&#160;&#160;
					<div class="Infobox" onclick="ZeigeBox(this)">i
						<div class="Popuptext"><xsl:copy-of select="$Infoboxinhalt"/><xsl:copy-of select="$Infoboxinhalt3"/><xsl:copy-of select="$Infoboxinhalt2"/></div>
					</div>
				</xsl:if>
				
				<xsl:if test="$Copybutton = '1'">
					&#160;&#160;
					<xsl:element name="span">
						<xsl:attribute name="class">Clipbutton</xsl:attribute>
						<xsl:attribute name="onclick">copyStringToClipboard(this,"<xsl:value-of select="$IDVersion"/>")</xsl:attribute>
						k
					</xsl:element>
				</xsl:if>
		
				<xsl:if test="$ToolAufruf = '1'">
					&#160;&#160;
					<xsl:element name="a">
						<xsl:attribute name="href"><xsl:value-of select="$ToolPfadPrefix"/><xsl:value-of select="$IDVersion"/><xsl:value-of select="$ToolPfadPostfix"/></xsl:attribute>
						<xsl:attribute name="target">FIMTool</xsl:attribute>
						<xsl:attribute name="title">Springe in den Datenfeldeditor (man muss vorher angemeldet sein).</xsl:attribute>
						<xsl:attribute name="class">Toolbutton</xsl:attribute>
						&#8658;
					</xsl:element>
				</xsl:if>
				
			</div>
			<xsl:if test="count(//xdf:xdatenfelder.datenfeldgruppe.0103/xdf:datenfeldgruppe/xdf:struktur)">
				<xsl:call-template name="unterelementezustammdatenschema">
					<xsl:with-param name="Element" select="//xdf:xdatenfelder.datenfeldgruppe.0103/xdf:datenfeldgruppe"/>
					<xsl:with-param name="Tiefe" select="1"/>
					<xsl:with-param name="ElternBaum" select="$AktuellerBaum"/>
				</xsl:call-template>
			</xsl:if>
		</div>
	</xsl:template>

	<!-- ############################################################################################################# -->

	<xsl:template name="stammdatenschemadetailszustammdatenschema">
		<xsl:param name="Element"/>
		<xsl:param name="ElternBaum"/>
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
		<xsl:if test="count($Element/xdf:struktur)">
			<xsl:call-template name="unterelementezustammdatenschema">
				<xsl:with-param name="Element" select="$Element"/>
				<xsl:with-param name="Tiefe" select="1"/>
				<xsl:with-param name="ElternBaum" select="$ElternBaum"/>
			</xsl:call-template>
		</xsl:if>
	</xsl:template>

	<!-- ############################################################################################################# -->

	<xsl:template name="unterelementezustammdatenschema">
		<xsl:param name="Element"/>
		<xsl:param name="Tiefe"/>
		<xsl:param name="ElternBaum"/>
		<xsl:if test="$DebugMode = '4'">
			<xsl:message>
				++++++++++++++++ unterelementezustammdatenschema ++++++++++++++++
			</xsl:message>
		</xsl:if>
		<xsl:for-each select="$Element/xdf:struktur">
			<xsl:variable name="minCount">
				<xsl:value-of select="fn:substring-before(./xdf:anzahl/text(),':')"/>
			</xsl:variable>
			<xsl:variable name="Anzahl"><xsl:choose><xsl:when test="$minCount = '0'">1</xsl:when><xsl:otherwise><xsl:value-of select="$minCount"/></xsl:otherwise></xsl:choose></xsl:variable>

			<xsl:call-template name="unterelementeKardinalitaet">
				<xsl:with-param name="Element" select="."/>
				<xsl:with-param name="Anzahl" select="fn:number($Anzahl)"/>
				<xsl:with-param name="ElternBaum" select="$ElternBaum"/>
			</xsl:call-template>
		</xsl:for-each>
	</xsl:template>

	<!-- ############################################################################################################# -->

	<xsl:template name="unterelementeKardinalitaet">
		<xsl:param name="Element"/>
		<xsl:param name="Anzahl"/>
		<xsl:param name="ElternBaum"/>

		<xsl:if test="$DebugMode = '4'">
			<xsl:message>
				++++++++++++++++ unterelementeKardinalitaet ++++++++++++++++
			</xsl:message>
		</xsl:if>

		<xsl:variable name="IDVersion"><xsl:value-of select="$Element/xdf:enthaelt/*/xdf:identifikation/xdf:id"/><xsl:if test="$Element/xdf:enthaelt/*/xdf:identifikation/xdf:version">V<xsl:value-of select="$Element/xdf:enthaelt/*/xdf:identifikation/xdf:version" /></xsl:if></xsl:variable>

		<xsl:variable name="RestAnzahl" select="$Anzahl - 1"/>
		
		<xsl:variable name="minCount">
			<xsl:value-of select="fn:substring-before($Element/xdf:anzahl/text(),':')"/>
		</xsl:variable>
		<xsl:variable name="maxCount">
			<xsl:value-of select="fn:substring-after($Element/xdf:anzahl/text(),':')"/>
		</xsl:variable>
		<xsl:variable name="minValue">
			<xsl:if test="$Element/xdf:enthaelt/*/xdf:praezisierung/text() != ''">
				<xsl:if test="substring-before(substring-after($Element/xdf:enthaelt/*/xdf:praezisierung,'minValue&quot;:&quot;'),'&quot;') != ''">
					<xsl:value-of select="substring-before(substring-after($Element/xdf:enthaelt/*/xdf:praezisierung,'minValue&quot;:&quot;'),'&quot;')"/>
				</xsl:if>
			</xsl:if>
		</xsl:variable>
		<xsl:variable name="maxValue">
			<xsl:if test="$Element/xdf:enthaelt/*/xdf:praezisierung/text() != ''">
				<xsl:if test="substring-before(substring-after($Element/xdf:enthaelt/*/xdf:praezisierung,'maxValue&quot;:&quot;'),'&quot;') != ''">
					<xsl:value-of select="substring-before(substring-after($Element/xdf:enthaelt/*/xdf:praezisierung,'maxValue&quot;:&quot;'),'&quot;')"/>
				</xsl:if>
			</xsl:if>
		</xsl:variable>
		<xsl:variable name="minLength">
			<xsl:if test="$Element/xdf:enthaelt/*/xdf:praezisierung/text() != ''">
				<xsl:if test="substring-before(substring-after($Element/xdf:enthaelt/*/xdf:praezisierung,'minLength&quot;:&quot;'),'&quot;') != ''">
					<xsl:value-of select="substring-before(substring-after($Element/xdf:enthaelt/*/xdf:praezisierung,'minLength&quot;:&quot;'),'&quot;')"/>
				</xsl:if>
			</xsl:if>
		</xsl:variable>
		<xsl:variable name="maxLength">
			<xsl:if test="$Element/xdf:enthaelt/*/xdf:praezisierung/text() != ''">
				<xsl:if test="substring-before(substring-after($Element/xdf:enthaelt/*/xdf:praezisierung,'maxLength&quot;:&quot;'),'&quot;') != ''">
					<xsl:value-of select="substring-before(substring-after($Element/xdf:enthaelt/*/xdf:praezisierung,'maxLength&quot;:&quot;'),'&quot;')"/>
				</xsl:if>
			</xsl:if>
		</xsl:variable>
		<xsl:variable name="Pattern">
			<xsl:if test="$Element/xdf:enthaelt/*/xdf:praezisierung/text() != ''">
				<xsl:if test="substring-before(substring-after($Element/xdf:enthaelt/*/xdf:praezisierung,'pattern&quot;:&quot;'),'&quot;') != ''">
					<xsl:value-of select="substring-before(substring-after($Element/xdf:enthaelt/*/xdf:praezisierung,'pattern&quot;:&quot;'),'&quot;')"/>
				</xsl:if>
			</xsl:if>
		</xsl:variable>
		<xsl:choose>
			<xsl:when test="$Element/xdf:enthaelt/*/name() = 'xdf:datenfeld'">
				<div class="FE">
					<xsl:element name="input">
						<xsl:attribute name="type">hidden</xsl:attribute>
						<xsl:attribute name="id">minCount</xsl:attribute>
						<xsl:attribute name="name">minCount</xsl:attribute>
						<xsl:choose>
							<xsl:when test="$minCount ='0'"><xsl:attribute name="value">1</xsl:attribute></xsl:when>
							<xsl:otherwise><xsl:attribute name="value"><xsl:value-of select="$minCount"/></xsl:attribute></xsl:otherwise>
						</xsl:choose>
					</xsl:element>
					<xsl:element name="input">
						<xsl:attribute name="type">hidden</xsl:attribute>
						<xsl:attribute name="id">maxCount</xsl:attribute>
						<xsl:attribute name="name">maxCount</xsl:attribute>
						<xsl:choose>
							<xsl:when test="$maxCount ='*'"><xsl:attribute name="value">100</xsl:attribute></xsl:when>
							<xsl:otherwise><xsl:attribute name="value"><xsl:value-of select="$maxCount"/></xsl:attribute></xsl:otherwise>
						</xsl:choose>
					</xsl:element>
					<xsl:element name="input">
						<xsl:attribute name="type">hidden</xsl:attribute>
						<xsl:attribute name="id">ID</xsl:attribute>
						<xsl:attribute name="name">ID</xsl:attribute>
						<xsl:attribute name="value"><xsl:value-of select="$Element/xdf:enthaelt/*/xdf:identifikation/xdf:id"/></xsl:attribute>
					</xsl:element>
					<xsl:choose>
						<xsl:when test="$minCount = $maxCount and $maxCount != '1'">
							<span class="FEBezeichnung FEMuss FEMehrfach">
								<xsl:value-of select="$Element/xdf:enthaelt/*/xdf:bezeichnungEingabe"/>&#160;&#160;
							</span>
						</xsl:when>
						<xsl:when test="$minCount != '0' and $maxCount != '1'">
							<button type="button" class="Plus" title="Element hinzufügen" onclick="FEDuplizieren(this)">&#43;</button><button type="button" class="Minus" title="Element entfernen" onclick="FEEntfernen(this)" disabled="true">&#8722;</button>&#160;&#160;
							<span class="FEBezeichnung FEMuss FEMehrfach">
								<xsl:value-of select="$Element/xdf:enthaelt/*/xdf:bezeichnungEingabe"/>&#160;&#160;
							</span>
						</xsl:when>
						<xsl:when test="$minCount = '0' and $maxCount != '1'">
							<button type="button" class="Plus" title="Element hinzufügen" onclick="FEDuplizieren(this)">&#43;</button><button type="button" class="Minus" title="Element entfernen" onclick="FEEntfernen(this)" disabled="true">&#8722;</button>&#160;&#160;
							<span class="FEBezeichnung FEKann FEMehrfach">
								<xsl:value-of select="$Element/xdf:enthaelt/*/xdf:bezeichnungEingabe"/>&#160;&#160;
							</span>
						</xsl:when>
						<xsl:when test="$minCount = '0' and $maxCount = '1'">
							<span class="FEBezeichnung FEKann FEEinfach">
								<xsl:value-of select="$Element/xdf:enthaelt/*/xdf:bezeichnungEingabe"/>&#160;&#160;
							</span>
						</xsl:when>
						<xsl:otherwise>
							<span class="FEBezeichnung FEMuss FEEinfach">
								<xsl:value-of select="$Element/xdf:enthaelt/*/xdf:bezeichnungEingabe"/>&#160;&#160;
							</span>
						</xsl:otherwise>
					</xsl:choose>
					<span class="FEInhalt">
						<xsl:choose>
							<xsl:when test="$Element/xdf:enthaelt/*/xdf:feldart = 'input'">
								<xsl:choose>
									<xsl:when test="$Element/xdf:enthaelt/*/xdf:datentyp/code/text() = 'text'">
										<xsl:choose>
											<xsl:when test="fn:number($maxLength) &gt; 150">
												<xsl:element name="textarea">
													<xsl:attribute name="class">Eingabe</xsl:attribute>
													<xsl:attribute name="id"><xsl:value-of select="$ElternBaum"/><xsl:value-of select="$Element/xdf:enthaelt/*/xdf:identifikation/xdf:id"/></xsl:attribute>
													<xsl:attribute name="name"><xsl:value-of select="$ElternBaum"/><xsl:value-of select="$Element/xdf:enthaelt/*/xdf:identifikation/xdf:id"/></xsl:attribute>
													<xsl:if test="$minLength != ''">
														<xsl:attribute name="minlength"><xsl:value-of select="$minLength"/></xsl:attribute>
													</xsl:if>
													<xsl:attribute name="maxlength"><xsl:value-of select="$maxLength"/></xsl:attribute>
													<xsl:attribute name="rows">1</xsl:attribute>
													<xsl:attribute name="cols">100</xsl:attribute>
													<xsl:if test="$minCount != 0"><xsl:attribute name="required"/></xsl:if>
													<xsl:value-of select="$Element/xdf:enthaelt/*/xdf:inhalt"/>
												</xsl:element>
											</xsl:when>
											<xsl:otherwise>
												<xsl:element name="input">
													<xsl:attribute name="class">Eingabe</xsl:attribute>
													<xsl:attribute name="type">text</xsl:attribute>
													<xsl:attribute name="id"><xsl:value-of select="$ElternBaum"/><xsl:value-of select="$Element/xdf:enthaelt/*/xdf:identifikation/xdf:id"/></xsl:attribute>
													<xsl:attribute name="name"><xsl:value-of select="$ElternBaum"/><xsl:value-of select="$Element/xdf:enthaelt/*/xdf:identifikation/xdf:id"/></xsl:attribute>
													<xsl:if test="$minLength != ''">
														<xsl:attribute name="minlength"><xsl:value-of select="$minLength"/></xsl:attribute>
													</xsl:if>
													<xsl:if test="$maxLength != ''">
														<xsl:attribute name="maxlength"><xsl:value-of select="$maxLength"/></xsl:attribute>
														<xsl:attribute name="size"><xsl:value-of select="$maxLength"/></xsl:attribute>
													</xsl:if>
													<xsl:if test="$Pattern != ''">
														<xsl:attribute name="pattern"><xsl:value-of select="$Pattern"/></xsl:attribute>
													</xsl:if>
													<xsl:attribute name="value"><xsl:value-of select="$Element/xdf:enthaelt/*/xdf:inhalt"/></xsl:attribute>
													<xsl:if test="$minCount != 0"><xsl:attribute name="required"/></xsl:if>
												</xsl:element>
											</xsl:otherwise>
										</xsl:choose>
									</xsl:when>
									<xsl:when test="$Element/xdf:enthaelt/*/xdf:datentyp/code/text() = 'date'">
										<xsl:element name="input">
											<xsl:attribute name="class">Eingabe</xsl:attribute>
											<xsl:attribute name="type">date</xsl:attribute>
											<xsl:attribute name="id"><xsl:value-of select="$ElternBaum"/><xsl:value-of select="$Element/xdf:enthaelt/*/xdf:identifikation/xdf:id"/></xsl:attribute>
											<xsl:attribute name="name"><xsl:value-of select="$ElternBaum"/><xsl:value-of select="$Element/xdf:enthaelt/*/xdf:identifikation/xdf:id"/></xsl:attribute>
											<xsl:if test="$Pattern != ''">
												<xsl:attribute name="pattern"><xsl:value-of select="$Pattern"/></xsl:attribute>
											</xsl:if>
											<xsl:attribute name="value"><xsl:value-of select="fn:concat(fn:substring($Element/xdf:enthaelt/*/xdf:inhalt,7,4),'-',fn:substring($Element/xdf:enthaelt/*/xdf:inhalt,4,2),'-',fn:substring($Element/xdf:enthaelt/*/xdf:inhalt,1,2))"/></xsl:attribute>
											<xsl:if test="$minCount != 0"><xsl:attribute name="required"/></xsl:if>
										</xsl:element>  
									</xsl:when>
									<xsl:when test="$Element/xdf:enthaelt/*/xdf:datentyp/code/text() = 'bool'">
										<label>
											<xsl:element name="input">
												<xsl:attribute name="class">Eingabe</xsl:attribute>
												<xsl:attribute name="type">radio</xsl:attribute>
												<xsl:attribute name="id"><xsl:value-of select="$ElternBaum"/><xsl:value-of select="$Element/xdf:enthaelt/*/xdf:identifikation/xdf:id"/>.wahr</xsl:attribute>
												<xsl:attribute name="name"><xsl:value-of select="$ElternBaum"/><xsl:value-of select="$Element/xdf:enthaelt/*/xdf:identifikation/xdf:id"/></xsl:attribute>
												<xsl:attribute name="value">wahr</xsl:attribute>
												<xsl:if test="$Element/xdf:enthaelt/*/xdf:inhalt = 'wahr'"><xsl:attribute name="checked">true</xsl:attribute></xsl:if>
												<xsl:if test="$minCount != 0"><xsl:attribute name="required"/></xsl:if>
											</xsl:element>
											ja
										</label>&#160;&#160;&#160;
										<label>
											<xsl:element name="input">
												<xsl:attribute name="class">Eingabe</xsl:attribute>
												<xsl:attribute name="type">radio</xsl:attribute>
												<xsl:attribute name="id"><xsl:value-of select="$ElternBaum"/><xsl:value-of select="$Element/xdf:enthaelt/*/xdf:identifikation/xdf:id"/>.falsch</xsl:attribute>
												<xsl:attribute name="name"><xsl:value-of select="$ElternBaum"/><xsl:value-of select="$Element/xdf:enthaelt/*/xdf:identifikation/xdf:id"/></xsl:attribute>
												<xsl:attribute name="value">falsch</xsl:attribute>
												<xsl:if test="$Element/xdf:enthaelt/*/xdf:inhalt = 'falsch'"><xsl:attribute name="checked">true</xsl:attribute></xsl:if>
												<xsl:if test="$minCount != 0"><xsl:attribute name="required"/></xsl:if>
											</xsl:element>
											nein
										</label>
									</xsl:when>
									<xsl:when test="$Element/xdf:enthaelt/*/xdf:datentyp/code/text() = 'num'">
										<xsl:element name="input">
											<xsl:attribute name="class">Eingabe</xsl:attribute>
											<xsl:attribute name="type">number</xsl:attribute>
											<xsl:attribute name="step">0.01</xsl:attribute>
											<xsl:attribute name="id"><xsl:value-of select="$ElternBaum"/><xsl:value-of select="$Element/xdf:enthaelt/*/xdf:identifikation/xdf:id"/></xsl:attribute>
											<xsl:attribute name="name"><xsl:value-of select="$ElternBaum"/><xsl:value-of select="$Element/xdf:enthaelt/*/xdf:identifikation/xdf:id"/></xsl:attribute>
											<xsl:if test="$minValue != ''">
												<xsl:attribute name="min"><xsl:value-of select="$minValue"/></xsl:attribute>
											</xsl:if>
											<xsl:if test="$maxValue != ''">
												<xsl:attribute name="max"><xsl:value-of select="$maxValue"/></xsl:attribute>
											</xsl:if>
											<xsl:attribute name="value"><xsl:value-of select="$Element/xdf:enthaelt/*/xdf:inhalt"/></xsl:attribute>
											<xsl:if test="$minCount != 0"><xsl:attribute name="required"/></xsl:if>
										</xsl:element>
									</xsl:when>
									<xsl:when test="$Element/xdf:enthaelt/*/xdf:datentyp/code/text() = 'num_int'">
										<xsl:element name="input">
											<xsl:attribute name="class">Eingabe</xsl:attribute>
											<xsl:attribute name="type">number</xsl:attribute>
											<xsl:attribute name="step">1</xsl:attribute>
											<xsl:attribute name="id"><xsl:value-of select="$ElternBaum"/><xsl:value-of select="$Element/xdf:enthaelt/*/xdf:identifikation/xdf:id"/></xsl:attribute>
											<xsl:attribute name="name"><xsl:value-of select="$ElternBaum"/><xsl:value-of select="$Element/xdf:enthaelt/*/xdf:identifikation/xdf:id"/></xsl:attribute>
											<xsl:if test="$minValue != ''">
												<xsl:attribute name="min"><xsl:value-of select="$minValue"/></xsl:attribute>
											</xsl:if>
											<xsl:if test="$maxValue != ''">
												<xsl:attribute name="max"><xsl:value-of select="$maxValue"/></xsl:attribute>
											</xsl:if>
											<xsl:attribute name="value"><xsl:value-of select="$Element/xdf:enthaelt/*/xdf:inhalt"/></xsl:attribute>
											<xsl:if test="$minCount != 0"><xsl:attribute name="required"/></xsl:if>
										</xsl:element>
									</xsl:when>
									<xsl:when test="$Element/xdf:enthaelt/*/xdf:datentyp/code/text() = 'num_currency'">
										<xsl:element name="input">
											<xsl:attribute name="class">Eingabe</xsl:attribute>
											<xsl:attribute name="type">number</xsl:attribute>
											<xsl:attribute name="step">0.01</xsl:attribute>
											<xsl:attribute name="min">0</xsl:attribute>
											<xsl:attribute name="id"><xsl:value-of select="$ElternBaum"/><xsl:value-of select="$Element/xdf:enthaelt/*/xdf:identifikation/xdf:id"/></xsl:attribute>
											<xsl:attribute name="name"><xsl:value-of select="$ElternBaum"/><xsl:value-of select="$Element/xdf:enthaelt/*/xdf:identifikation/xdf:id"/></xsl:attribute>
											<xsl:attribute name="value"><xsl:value-of select="$Element/xdf:enthaelt/*/xdf:inhalt"/></xsl:attribute>
											<xsl:if test="$minCount != 0"><xsl:attribute name="required"/></xsl:if>
										</xsl:element>&#160;&#8364;
									</xsl:when>
									<xsl:when test="$Element/xdf:enthaelt/*/xdf:datentyp/code/text() = 'file'">
										<xsl:element name="input">
											<xsl:attribute name="class">Eingabe</xsl:attribute>
											<xsl:attribute name="type">file</xsl:attribute>
											<xsl:attribute name="id"><xsl:value-of select="$ElternBaum"/><xsl:value-of select="$Element/xdf:enthaelt/*/xdf:identifikation/xdf:id"/></xsl:attribute>
											<xsl:attribute name="name"><xsl:value-of select="$ElternBaum"/><xsl:value-of select="$Element/xdf:enthaelt/*/xdf:identifikation/xdf:id"/></xsl:attribute>
											<xsl:attribute name="onchange">aktiviereLeerenButton(this)</xsl:attribute>
											<xsl:if test="$minCount != 0"><xsl:attribute name="required"/></xsl:if>
										</xsl:element>
										&#160;&#160;<button type="button" class="Empty" title="Datei entfernen" onclick="DateiLeeren(this)" disabled="true">&#216;</button>
									</xsl:when>
									<xsl:when test="$Element/xdf:enthaelt/*/xdf:datentyp/code/text() = 'obj'">
										Statisches Objekt
									</xsl:when>
								</xsl:choose>
							</xsl:when>
							<xsl:when test="$Element/xdf:enthaelt/*/xdf:feldart = 'select'">
								<xsl:element name="select">
									<xsl:attribute name="class">Eingabe</xsl:attribute>
									<xsl:if test="$minCount != 0"><xsl:attribute name="required"/></xsl:if>
									<xsl:attribute name="id"><xsl:value-of select="$ElternBaum"/><xsl:value-of select="$Element/xdf:enthaelt/*/xdf:identifikation/xdf:id"/></xsl:attribute>
									<xsl:attribute name="name"><xsl:value-of select="$ElternBaum"/><xsl:value-of select="$Element/xdf:enthaelt/*/xdf:identifikation/xdf:id"/></xsl:attribute>

									<xsl:if test="$Element/xdf:enthaelt/*/xdf:codelisteReferenz/xdf:identifikation/xdf:id or fn:not(fn:empty($Element/xdf:enthaelt/*/xdf:codelisteReferenz/xdf:identifikation/xdf:id/text()))">
										<xsl:variable name="CodelisteDatei" select="concat($InputPfad,$Element/xdf:enthaelt/*/xdf:codelisteReferenz/xdf:identifikation/xdf:id, '_genericode.xml')"/>
										
										
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

										<xsl:if test="fn:not($Element/xdf:enthaelt/*/xdf:inhalt) or fn:empty($Element/xdf:enthaelt/*/xdf:inhalt/text())">
											<xsl:element name="option">
												<xsl:attribute name="value"/>
												<xsl:attribute name="hidden"/>
												<xsl:attribute name="selected"/>
											</xsl:element>
										</xsl:if>
										<xsl:choose>
											<xsl:when test="fn:string-length($CodelisteInhalt) &lt; 10">
											</xsl:when>
											<xsl:otherwise>
												<xsl:variable name="NameCodeKey"><xsl:value-of  select="$CodelisteInhalt/*/gc:ColumnSet/gc:Key[@Id='codeKey']/gc:ColumnRef/@Ref"/><xsl:value-of  select="$CodelisteInhalt/*/ColumnSet/Key[@Id='codeKey']/ColumnRef/@Ref"/></xsl:variable>
												<xsl:variable name="NameCodenameKey"><xsl:value-of  select="$CodelisteInhalt/*/gc:ColumnSet/gc:Key[@Id='codenameKey']/gc:ColumnRef/@Ref"/><xsl:value-of  select="$CodelisteInhalt/*/ColumnSet/Key[@Id='codenameKey']/ColumnRef/@Ref"/></xsl:variable>
												
												<xsl:for-each-group select="$CodelisteInhalt/*/gc:SimpleCodeList/gc:Row" group-by="gc:Value[@ColumnRef=$NameCodenameKey]">
													<xsl:element name="option">
														<xsl:attribute name="value"><xsl:value-of select="./gc:Value[@ColumnRef=$NameCodeKey]"/></xsl:attribute>
														<xsl:if test="$Element/xdf:enthaelt/*/xdf:inhalt = ./gc:Value[@ColumnRef=$NameCodeKey]">
															<xsl:attribute name="selected">true</xsl:attribute>
														</xsl:if>
														<xsl:value-of select="./gc:Value[@ColumnRef=$NameCodenameKey]"/>
													</xsl:element>
												</xsl:for-each-group>
												<xsl:for-each-group select="$CodelisteInhalt/*/SimpleCodeList/Row" group-by="Value[@ColumnRef=$NameCodenameKey]">
													<xsl:element name="option">
														<xsl:attribute name="value"><xsl:value-of select="./Value[@ColumnRef=$NameCodeKey]"/></xsl:attribute>
														<xsl:if test="$Element/xdf:enthaelt/*/xdf:inhalt = ./Value[@ColumnRef=$NameCodeKey]">
															<xsl:attribute name="selected">true</xsl:attribute>
														</xsl:if>
														<xsl:value-of select="./Value[@ColumnRef=$NameCodenameKey]"/>
													</xsl:element>
												</xsl:for-each-group>
											</xsl:otherwise>
										</xsl:choose>
									</xsl:if>
								</xsl:element>
							</xsl:when>
							<xsl:when test="$Element/xdf:enthaelt/*/xdf:feldart = 'label'">
								<div>
									<xsl:value-of select="$Element/xdf:enthaelt/*/xdf:inhalt"/>
								</div>
							</xsl:when>
						</xsl:choose>
					</span>
					<span class="Bezeichnung">
						<xsl:if test="fn:not(empty($Element/xdf:enthaelt/*/xdf:hilfetextEingabe/text()))">
							&#160;&#160;
							<div class="Hilfe" onclick="ZeigeBox(this)">?
								<div class="Popuptext"><xsl:value-of select="$Element/xdf:enthaelt/*/xdf:hilfetextEingabe"/></div>
							</div>
						</xsl:if>
					</span>
					<span class="Bezeichnung">

						<xsl:if test="$Infobox = '1'">
							<xsl:variable name="Infoboxinhalt">
								<b>Feld-ID:</b>&#160;&#160;<xsl:value-of select="$IDVersion"/><br/>
								<b>Name:&#160;&#160;</b><xsl:value-of select="$Element/xdf:enthaelt/*/xdf:name" /><br/><br/>
								<b>Anzahl:</b>&#160;&#160;<xsl:value-of select="$Element/xdf:anzahl" /><br/>
								<b>Feldart:</b>&#160;&#160;<xsl:apply-templates select="$Element/xdf:enthaelt/*/xdf:feldart" /><br/>
								<b>Datentyp:</b>&#160;&#160;<xsl:apply-templates select="$Element/xdf:enthaelt/*/xdf:datentyp" /><br/>
								<xsl:choose>
									<xsl:when test="$Element/xdf:enthaelt/*/xdf:feldart = 'input'">
										<xsl:choose>
											<xsl:when test="$Element/xdf:enthaelt/*/xdf:datentyp/code/text() = 'text'">
												<xsl:if test="$minLength != ''"><b>Minimallänge:</b>&#160;&#160;<xsl:value-of select="$minLength"/><br/></xsl:if>
												<xsl:if test="$maxLength != ''"><b>Maximallänge:</b>&#160;&#160;<xsl:value-of select="$maxLength"/><br/></xsl:if>
												<xsl:if test="$Pattern != ''"><b>Pattern:</b>&#160;&#160;<xsl:value-of select="$Pattern"/><br/></xsl:if>
											</xsl:when>
											<xsl:when test="$Element/xdf:enthaelt/*/xdf:datentyp/code/text() = 'date'">
												<xsl:if test="$minValue != ''"><b>Mindestwert:</b>&#160;&#160;<xsl:value-of select="$minValue" /><br/></xsl:if>
												<xsl:if test="$maxValue != ''"><b>Maximalwert:</b>&#160;&#160;<xsl:value-of select="$maxValue" /><br/></xsl:if>
												<xsl:if test="$Pattern != ''"><b>Pattern:</b>&#160;&#160;<xsl:value-of select="$Pattern" /><br/></xsl:if>
											</xsl:when>
											<xsl:when test="$Element/xdf:enthaelt/*/xdf:datentyp/code/text() = 'num'">
												<xsl:if test="$minValue != ''"><b>Mindestwert:</b>&#160;&#160;<xsl:value-of select="$minValue" /><br/></xsl:if>
												<xsl:if test="$maxValue != ''"><b>Maximalwert:</b>&#160;&#160;<xsl:value-of select="$maxValue" /><br/></xsl:if>
											</xsl:when>
											<xsl:when test="$Element/xdf:enthaelt/*/xdf:datentyp/code/text() = 'num_int'">
												<xsl:if test="$minValue != ''"><b>Mindestwert:</b>&#160;&#160;<xsl:value-of select="$minValue" /><br/></xsl:if>
												<xsl:if test="$maxValue != ''"><b>Maximalwert:</b>&#160;&#160;<xsl:value-of select="$maxValue" /><br/></xsl:if>
											</xsl:when>
											<xsl:when test="$Element/xdf:enthaelt/*/xdf:datentyp/code/text() = 'num_currency'">
												<xsl:if test="$minValue != ''"><b>Mindestwert:</b>&#160;&#160;<xsl:value-of select="$minValue" /><br/></xsl:if>
												<xsl:if test="$maxValue != ''"><b>Maximalwert:</b>&#160;&#160;<xsl:value-of select="$maxValue" /><br/></xsl:if>
											</xsl:when>
										</xsl:choose>
									</xsl:when>
									<xsl:when test="$Element/xdf:enthaelt/*/xdf:feldart = 'select'">
										<b>Codeliste:</b>&#160;&#160;<xsl:value-of select="$Element/xdf:enthaelt/*/xdf:codelisteReferenz/xdf:identifikation/xdf:id"/><br/>
									</xsl:when>
								</xsl:choose>
								<br/>
							</xsl:variable>

							<xsl:variable name="Infoboxinhalt2">
								<xsl:for-each select="$Element/xdf:enthaelt/*/xdf:regel">
									<b>Regel-ID:</b>&#160;&#160;<xsl:value-of select="./xdf:identifikation/xdf:id"/><xsl:if test="./xdf:identifikation/xdf:version">V<xsl:value-of select="./xdf:identifikation/xdf:version"/></xsl:if><br/>
									<b>Name:</b>&#160;&#160;<xsl:value-of select="./xdf:name"/><br/>
									<b>Definition:</b>&#160;&#160;<xsl:value-of select="./xdf:definition"/><br/><br/>
								</xsl:for-each>
							</xsl:variable>

							<xsl:variable name="Infoboxinhalt3">
								<b>Bezug zur Handlungsgrundlage:</b>&#160;&#160;<xsl:value-of select="$Element/xdf:bezug"/><xsl:if test="fn:not(empty($Element/xdf:bezug/text())) and fn:not(empty($Element/xdf:enthaelt/*/xdf:bezug/text()))">;&#160;</xsl:if><xsl:value-of select="$Element/xdf:enthaelt/*/xdf:bezug"/><br/><br/>
							</xsl:variable>

							&#160;&#160;&#160;&#160;
							<div class="Infobox" onclick="ZeigeBox(this)">i
								<div class="Popuptext"><xsl:copy-of select="$Infoboxinhalt"/><xsl:copy-of select="$Infoboxinhalt3"/><xsl:copy-of select="$Infoboxinhalt2"/></div>
							</div>
						</xsl:if>

						<xsl:if test="$Copybutton = '1'">
							&#160;&#160;&#160;&#160;
							<xsl:element name="span">
								<xsl:attribute name="class">Clipbutton</xsl:attribute>
								<xsl:attribute name="onclick">copyStringToClipboard(this,"<xsl:value-of select="$IDVersion"/>")</xsl:attribute>
								k
							</xsl:element>
						</xsl:if>
				
						<xsl:if test="$ToolAufruf = '1'">
							&#160;&#160;&#160;&#160;
							<xsl:element name="a">
								<xsl:attribute name="href"><xsl:value-of select="$ToolPfadPrefix"/><xsl:value-of select="$IDVersion"/><xsl:value-of select="$ToolPfadPostfix"/></xsl:attribute>
								<xsl:attribute name="target">FIMTool</xsl:attribute>
								<xsl:attribute name="title">Springe in den Datenfeldeditor (man muss vorher angemeldet sein).</xsl:attribute>
								<xsl:attribute name="class">Toolbutton</xsl:attribute>
								&#8658;
							</xsl:element>
						</xsl:if>

					</span>
				</div>
			</xsl:when>
			<xsl:otherwise>
				<xsl:variable name="AktuellerBaum"><xsl:value-of select="$ElternBaum"/><xsl:value-of select="$Element/xdf:enthaelt/*/xdf:identifikation/xdf:id"/>.</xsl:variable>

				<div class="FG">
					<xsl:element name="input">
						<xsl:attribute name="type">hidden</xsl:attribute>
						<xsl:attribute name="id">minCount</xsl:attribute>
						<xsl:attribute name="name">minCount</xsl:attribute>
						<xsl:choose>
							<xsl:when test="$minCount ='0'"><xsl:attribute name="value">1</xsl:attribute></xsl:when>
							<xsl:otherwise><xsl:attribute name="value"><xsl:value-of select="$minCount"/></xsl:attribute></xsl:otherwise>
						</xsl:choose>
					</xsl:element>
					<xsl:element name="input">
						<xsl:attribute name="type">hidden</xsl:attribute>
						<xsl:attribute name="id">maxCount</xsl:attribute>
						<xsl:attribute name="name">maxCount</xsl:attribute>
						<xsl:choose>
							<xsl:when test="$maxCount ='*'"><xsl:attribute name="value">100</xsl:attribute></xsl:when>
							<xsl:otherwise><xsl:attribute name="value"><xsl:value-of select="$maxCount"/></xsl:attribute></xsl:otherwise>
						</xsl:choose>
					</xsl:element>
					<xsl:element name="input">
						<xsl:attribute name="type">hidden</xsl:attribute>
						<xsl:attribute name="id">ID</xsl:attribute>
						<xsl:attribute name="name">ID</xsl:attribute>
						<xsl:attribute name="value"><xsl:value-of select="$Element/xdf:enthaelt/*/xdf:identifikation/xdf:id"/></xsl:attribute>
					</xsl:element>

					<xsl:variable name="Infoboxinhalt">
						<b>Feldgruppen-ID:</b>&#160;&#160;<xsl:value-of select="$IDVersion"/><br/>
						<b>Anzahl:</b>&#160;&#160;<xsl:value-of select="$Element/xdf:anzahl"/><br/>
						<b>Name:</b>&#160;&#160;<xsl:value-of select="$Element/xdf:enthaelt/*/xdf:name"/><br/><br/>
					</xsl:variable>

					<xsl:variable name="Infoboxinhalt2">
						<xsl:for-each select="$Element/xdf:enthaelt/*/xdf:regel">
							<b>Regel-ID:</b>&#160;&#160;<xsl:value-of select="./xdf:identifikation/xdf:id"/><xsl:if test="./xdf:identifikation/xdf:version">V<xsl:value-of select="./xdf:identifikation/xdf:version"/></xsl:if><br/>
							<b>Name:</b>&#160;&#160;<xsl:value-of select="./xdf:name"/><br/>
							<b>Definition:</b>&#160;&#160;<xsl:value-of select="./xdf:definition"/><br/><br/>
						</xsl:for-each>
					</xsl:variable>

					<xsl:variable name="Infoboxinhalt3">
						<b>Bezug zur Handlungsgrundlage:</b>&#160;&#160;<xsl:value-of select="$Element/xdf:bezug"/><xsl:if test="fn:not(empty($Element/xdf:bezug/text())) and fn:not(empty($Element/xdf:enthaelt/*/xdf:bezug/text()))">;&#160;</xsl:if><xsl:value-of select="$Element/xdf:enthaelt/*/xdf:bezug"/><br/><br/>
					</xsl:variable>

					<xsl:choose>
						<xsl:when test="$minCount = $maxCount and $maxCount != '1'">
							<button type="button" class="FGBezeichnung FGKann FGEinfachh">
								<xsl:value-of select="$Element/xdf:enthaelt/*/xdf:bezeichnungEingabe"/>
							</button>
							<span>
								<xsl:if test="fn:not(empty($Element/xdf:enthaelt/*/xdf:hilfetextEingabe/text()))">
									&#160;&#160;
									<div class="Hilfe" onclick="ZeigeBox(this)">?
										<div class="Popuptext"><xsl:value-of select="$Element/xdf:enthaelt/*/xdf:hilfetextEingabe"/></div>
									</div>
								</xsl:if>
								<xsl:if test="$Infobox = '1'">
									&#160;&#160;
									<div class="Infobox" onclick="ZeigeBox(this)">i
										<div class="Popuptext"><xsl:copy-of select="$Infoboxinhalt"/><xsl:copy-of select="$Infoboxinhalt3"/><xsl:copy-of select="$Infoboxinhalt2"/></div>
									</div>
								</xsl:if>

								<xsl:if test="$Copybutton = '1'">
									&#160;&#160;
									<xsl:element name="span">
										<xsl:attribute name="class">Clipbutton</xsl:attribute>
										<xsl:attribute name="onclick">copyStringToClipboard(this,"<xsl:value-of select="$IDVersion"/>")</xsl:attribute>
										k
									</xsl:element>
								</xsl:if>
						
								<xsl:if test="$ToolAufruf = '1'">
									&#160;&#160;
									<xsl:element name="a">
										<xsl:attribute name="href"><xsl:value-of select="$ToolPfadPrefix"/><xsl:value-of select="$IDVersion"/><xsl:value-of select="$ToolPfadPostfix"/></xsl:attribute>
										<xsl:attribute name="target">FIMTool</xsl:attribute>
										<xsl:attribute name="title">Springe in den Datenfeldeditor (man muss vorher angemeldet sein).</xsl:attribute>
										<xsl:attribute name="class">Toolbutton</xsl:attribute>
										&#8658;
									</xsl:element>
								</xsl:if>

							</span>
						</xsl:when>
						<xsl:when test="$minCount != '0' and $maxCount != '1'">
							<button type="button" class="Plus" title="Element hinzufügen" onclick="FGDuplizieren(this)">&#43;</button><button type="button" class="Minus" title="Element entfernen" onclick="FGEntfernen(this)" disabled="true">&#8722;</button>
							<button type="button" class="FGBezeichnung FGMuss FGMehrfach">
								<xsl:value-of select="$Element/xdf:enthaelt/*/xdf:bezeichnungEingabe"/>
							</button>
							<span>
								<xsl:if test="fn:not(empty($Element/xdf:enthaelt/*/xdf:hilfetextEingabe/text()))">
									&#160;&#160;
									<div class="Hilfe" onclick="ZeigeBox(this)">?
										<div class="Popuptext"><xsl:value-of select="$Element/xdf:enthaelt/*/xdf:hilfetextEingabe"/></div>
									</div>
								</xsl:if>
								<xsl:if test="$Infobox = '1'">
									&#160;&#160;
									<div class="Infobox" onclick="ZeigeBox(this)">i
										<div class="Popuptext"><xsl:copy-of select="$Infoboxinhalt"/><xsl:copy-of select="$Infoboxinhalt3"/><xsl:copy-of select="$Infoboxinhalt2"/></div>
									</div>
								</xsl:if>

								<xsl:if test="$Copybutton = '1'">
									&#160;&#160;
									<xsl:element name="span">
										<xsl:attribute name="class">Clipbutton</xsl:attribute>
										<xsl:attribute name="onclick">copyStringToClipboard(this,"<xsl:value-of select="$IDVersion"/>")</xsl:attribute>
										k
									</xsl:element>
								</xsl:if>
						
								<xsl:if test="$ToolAufruf = '1'">
									&#160;&#160;
									<xsl:element name="a">
										<xsl:attribute name="href"><xsl:value-of select="$ToolPfadPrefix"/><xsl:value-of select="$IDVersion"/><xsl:value-of select="$ToolPfadPostfix"/></xsl:attribute>
										<xsl:attribute name="target">FIMTool</xsl:attribute>
										<xsl:attribute name="title">Springe in den Datenfeldeditor (man muss vorher angemeldet sein).</xsl:attribute>
										<xsl:attribute name="class">Toolbutton</xsl:attribute>
										&#8658;
									</xsl:element>
								</xsl:if>

							</span>
						</xsl:when>
						<xsl:when test="$minCount = '0' and $maxCount != '1'">
							<button type="button" class="Plus" title="Element hinzufügen" onclick="FGDuplizieren(this)">&#43;</button><button type="button" class="Minus" title="Element entfernen" onclick="FGEntfernen(this)" disabled="true">&#8722;</button>
							<button type="button" class="FGBezeichnung FGKann FGMehrfach">
								<xsl:value-of select="$Element/xdf:enthaelt/*/xdf:bezeichnungEingabe"/>
							</button>
							<span>
								<xsl:if test="fn:not(empty($Element/xdf:enthaelt/*/xdf:hilfetextEingabe/text()))">
									&#160;&#160;
									<div class="Hilfe" onclick="ZeigeBox(this)">?
										<div class="Popuptext"><xsl:value-of select="$Element/xdf:enthaelt/*/xdf:hilfetextEingabe"/></div>
									</div>
								</xsl:if>
								<xsl:if test="$Infobox = '1'">
									&#160;&#160;
									<div class="Infobox" onclick="ZeigeBox(this)">i
										<div class="Popuptext"><xsl:copy-of select="$Infoboxinhalt"/><xsl:copy-of select="$Infoboxinhalt3"/><xsl:copy-of select="$Infoboxinhalt2"/></div>
									</div>
								</xsl:if>

								<xsl:if test="$Copybutton = '1'">
									&#160;&#160;
									<xsl:element name="span">
										<xsl:attribute name="class">Clipbutton</xsl:attribute>
										<xsl:attribute name="onclick">copyStringToClipboard(this,"<xsl:value-of select="$IDVersion"/>")</xsl:attribute>
										k
									</xsl:element>
								</xsl:if>
						
								<xsl:if test="$ToolAufruf = '1'">
									&#160;&#160;
									<xsl:element name="a">
										<xsl:attribute name="href"><xsl:value-of select="$ToolPfadPrefix"/><xsl:value-of select="$IDVersion"/><xsl:value-of select="$ToolPfadPostfix"/></xsl:attribute>
										<xsl:attribute name="target">FIMTool</xsl:attribute>
										<xsl:attribute name="title">Springe in den Datenfeldeditor (man muss vorher angemeldet sein).</xsl:attribute>
										<xsl:attribute name="class">Toolbutton</xsl:attribute>
										&#8658;
									</xsl:element>
								</xsl:if>

							</span>
						</xsl:when>
						<xsl:when test="$minCount = '0' and $maxCount = '1'">
							<button type="button" class="FGBezeichnung FGKann FGEinfachh">
								<xsl:value-of select="$Element/xdf:enthaelt/*/xdf:bezeichnungEingabe"/>
							</button>
							<span>
								<xsl:if test="fn:not(empty($Element/xdf:enthaelt/*/xdf:hilfetextEingabe/text()))">
									&#160;&#160;
									<div class="Hilfe" onclick="ZeigeBox(this)">?
										<div class="Popuptext"><xsl:value-of select="$Element/xdf:enthaelt/*/xdf:hilfetextEingabe"/></div>
									</div>
								</xsl:if>
								<xsl:if test="$Infobox = '1'">
									&#160;&#160;
									<div class="Infobox" onclick="ZeigeBox(this)">i
										<div class="Popuptext"><xsl:copy-of select="$Infoboxinhalt"/><xsl:copy-of select="$Infoboxinhalt3"/><xsl:copy-of select="$Infoboxinhalt2"/></div>
									</div>
								</xsl:if>

								<xsl:if test="$Copybutton = '1'">
									&#160;&#160;
									<xsl:element name="span">
										<xsl:attribute name="class">Clipbutton</xsl:attribute>
										<xsl:attribute name="onclick">copyStringToClipboard(this,"<xsl:value-of select="$IDVersion"/>")</xsl:attribute>
										k
									</xsl:element>
								</xsl:if>
						
								<xsl:if test="$ToolAufruf = '1'">
									&#160;&#160;
									<xsl:element name="a">
										<xsl:attribute name="href"><xsl:value-of select="$ToolPfadPrefix"/><xsl:value-of select="$IDVersion"/><xsl:value-of select="$ToolPfadPostfix"/></xsl:attribute>
										<xsl:attribute name="target">FIMTool</xsl:attribute>
										<xsl:attribute name="title">Springe in den Datenfeldeditor (man muss vorher angemeldet sein).</xsl:attribute>
										<xsl:attribute name="class">Toolbutton</xsl:attribute>
										&#8658;
									</xsl:element>
								</xsl:if>

							</span>
						</xsl:when>
						<xsl:otherwise>
							<button type="button" class="FGBezeichnung FGMuss FGEinfachh">
								<xsl:value-of select="$Element/xdf:enthaelt/*/xdf:bezeichnungEingabe"/>
							</button>
							<span>
								<xsl:if test="fn:not(empty($Element/xdf:enthaelt/*/xdf:hilfetextEingabe/text()))">
									&#160;&#160;
									<div class="Hilfe" onclick="ZeigeBox(this)">?
										<div class="Popuptext"><xsl:value-of select="$Element/xdf:enthaelt/*/xdf:hilfetextEingabe"/></div>
									</div>
								</xsl:if>

								<xsl:if test="$Infobox = '1'">
									&#160;&#160;
									<div class="Infobox" onclick="ZeigeBox(this)">i
										<div class="Popuptext"><xsl:copy-of select="$Infoboxinhalt"/><xsl:copy-of select="$Infoboxinhalt3"/><xsl:copy-of select="$Infoboxinhalt2"/></div>
									</div>
								</xsl:if>

								<xsl:if test="$Copybutton = '1'">
									&#160;&#160;
									<xsl:element name="span">
										<xsl:attribute name="class">Clipbutton</xsl:attribute>
										<xsl:attribute name="onclick">copyStringToClipboard(this,"<xsl:value-of select="$IDVersion"/>")</xsl:attribute>
										k
									</xsl:element>
								</xsl:if>
						
								<xsl:if test="$ToolAufruf = '1'">
									&#160;&#160;
									<xsl:element name="a">
										<xsl:attribute name="href"><xsl:value-of select="$ToolPfadPrefix"/><xsl:value-of select="$IDVersion"/><xsl:value-of select="$ToolPfadPostfix"/></xsl:attribute>
										<xsl:attribute name="target">FIMTool</xsl:attribute>
										<xsl:attribute name="title">Springe in den Datenfeldeditor (man muss vorher angemeldet sein).</xsl:attribute>
										<xsl:attribute name="class">Toolbutton</xsl:attribute>
										&#8658;
									</xsl:element>
								</xsl:if>

							</span>
						</xsl:otherwise>
					</xsl:choose>
					<xsl:choose>
						<xsl:when test="$minCount = '0'">
							<div class="FGInhalt" style="display: none">
								<xsl:if test="$Element/xdf:enthaelt/xdf:datenfeldgruppe">
									<xsl:call-template name="unterelementezustammdatenschema">
										<xsl:with-param name="Element" select="$Element/xdf:enthaelt/xdf:datenfeldgruppe"/>
										<xsl:with-param name="ElternBaum" select="$AktuellerBaum"/>
									</xsl:call-template>
								</xsl:if>
							</div>
						</xsl:when>
						<xsl:otherwise>
							<div class="FGInhalt" style="display: block">
								<xsl:if test="$Element/xdf:enthaelt/xdf:datenfeldgruppe">
									<xsl:call-template name="unterelementezustammdatenschema">
										<xsl:with-param name="Element" select="$Element/xdf:enthaelt/xdf:datenfeldgruppe"/>
										<xsl:with-param name="ElternBaum" select="$AktuellerBaum"/>
									</xsl:call-template>
								</xsl:if>
							</div>
						</xsl:otherwise>
					</xsl:choose>
				</div>
			</xsl:otherwise>
		</xsl:choose>

		<xsl:if test="$RestAnzahl &gt; 0">
			
			<xsl:call-template name="unterelementeKardinalitaet">
				<xsl:with-param name="Element" select="$Element"/>
				<xsl:with-param name="Anzahl" select="$RestAnzahl"/>
				<xsl:with-param name="ElternBaum" select="$ElternBaum"/>
			</xsl:call-template>

		</xsl:if>

	</xsl:template>

	<!-- ############################################################################################################# -->

	<xsl:template match="xdf:feldart">
		<xsl:choose>
			<xsl:when test="./code/text() = 'input'">Eingabefeld</xsl:when>
			<xsl:when test="./code/text() = 'select'">Auswahlfeld</xsl:when>
			<xsl:when test="./code/text() = 'label'">Statisches, read-only Feld</xsl:when>
			<xsl:otherwise>
			</xsl:otherwise>
		</xsl:choose>
	</xsl:template>

	<xsl:template match="xdf:datentyp">
		<xsl:choose>
			<xsl:when test="./code/text() = 'text'">Text</xsl:when>
			<xsl:when test="./code/text() = 'date'">Datum</xsl:when>
			<xsl:when test="./code/text() = 'bool'">Wahrheitswert</xsl:when>
			<xsl:when test="./code/text() = 'num'">Fließkommazahl</xsl:when>
			<xsl:when test="./code/text() = 'num_int'">Ganzzahl</xsl:when>
			<xsl:when test="./code/text() = 'num_currency'">Währungswert</xsl:when>
			<xsl:when test="./code/text() = 'file'">Anlage</xsl:when>
			<xsl:when test="./code/text() = 'obj'">Statisches Objekt</xsl:when>
			<xsl:otherwise>
			</xsl:otherwise>
		</xsl:choose>
	</xsl:template>

	<xsl:template match="xdf:schemaelementart">
		<xsl:choose>
			<xsl:when test="./code/text() = 'ABS'">abstrakt</xsl:when>
			<xsl:when test="./code/text() = 'HAR'">harmonisiert</xsl:when>
			<xsl:when test="./code/text() = 'RNG'">rechtsnormgebunden</xsl:when>
			<xsl:otherwise>
			</xsl:otherwise>
		</xsl:choose>
	</xsl:template>

	<xsl:template match="xdf:status">
		<xsl:choose>
			<xsl:when test="./code/text() = 'inVorbereitung'">in Vorbereitung</xsl:when>
			<xsl:when test="./code/text() = 'aktiv'">aktiv</xsl:when>
			<xsl:when test="./code/text() = 'inaktiv'">inaktiv</xsl:when>
			<xsl:otherwise>
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
			</xsl:otherwise>
		</xsl:choose>
	</xsl:template>

	<xsl:template match="xdf:ableitungsmodifikationenRepraesentation">
		<xsl:choose>
			<xsl:when test="./code/text() = '0'">nicht modifizierbar</xsl:when>
			<xsl:when test="./code/text() = '1'">modifizierbar</xsl:when>
			<xsl:otherwise>
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
			<xsl:when test="$Navigation = '1'">
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

	<xsl:template name="style">
		<xsl:if test="$DebugMode = '1' or $DebugMode = '2' or $DebugMode = '3' or $DebugMode = '4'">
			<xsl:message>
				++++ style ++++
			</xsl:message>
		</xsl:if>
		<!--
		<style type="text/css">
-->
		<style>
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
			<xsl:if test="$Navigation = '0'">
				display:none;
			</xsl:if>
			  }

			  #fixiert img {
				height: 6.8em; float: right;
			  }
			
			  #Inhalt {
			 <xsl:choose>
				<xsl:when test="$Navigation = '0'">
				margin-left: 0.5em; 
				</xsl:when>
				<xsl:otherwise>
				margin-left: 20em; 
				</xsl:otherwise>
			</xsl:choose>
				padding: 0 1em;
			  }

			  #FussStand {
			 <xsl:choose>
				<xsl:when test="$Navigation = '0'">
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
			
			.Hinweisklein
			{
				font-size: 80%;
			}
			
			.SDSName
			{
				font-weight: bold;
				font-size: 100%;
			}
			
			.SDS
			{
				font-weight: bold;
				font-size: 24px;
				border: 6px solid #333;
				box-shadow: 8px 8px 5px #444;
				padding: 8px;
			}
			
			.SDSBezeichnung
			{
				margin-bottom: 8px;
			}
			
			.FGBezeichnung
			{
				font-weight: bold;
				font-size: 14px;
				background-color: #eafaf1;
				color: black;
				cursor: pointer;
				border: none;
				text-align: left;
				outline: none;
				margin-bottom: 8px;
			}
			
			.FGMuss
			{
			}
			
			.FGKann
			{
				font-style: italic;
			}
			
			.FGInhaltMuss
			{
			  display: block;
			}
			
			.FGInhaltKann
			{
				display: none;
			}
			
			.FGMehrfach
			{
			}
			
			.FGEinfach
			{
			}
			
			.FEBezeichnung
			{
				margin-bottom: 8px;
				vertical-align: middle;
			}

			.FEMuss
			{
			}

			.FEKann
			{
				font-style: italic;
			}

			.FEMehrfach
			{
			}

			.FEEinfach
			{
			}

			.FGInhalt 
			{
			}

			.Plus 
			{
			}

			.Minus 
			{
			}

			.Hilfe, .HilfeHilfetext
			{
				position: relative;
				-webkit-user-select: none;
				-moz-user-select: none;
				-ms-user-select: none;
				user-select: none;
				
				background: gold;
				color: black;
				cursor: pointer;
				font-family: Arial, Helvetica, sans-serif;
				font-size: 12px;
				font-style: normal;
				font-weight: bold;
				text-shadow: none;
				text-align: center;
				height: 16px;
				width: 16px;
				border-radius: 50%;
				display: inline-block;
			}
			
			.Hilfe .Popuptext
			{
				display: none;
				width: 400px;
				height: 60px;

				background-color: #ffc;
				color: #000;
				border: 1px solid #333;
				box-shadow: 2px 2px 2px #444;
				font-weight: normal;
				text-align: left;
				border-radius: 6px;
				padding: 5px 15px;
				position: absolute;
				z-index: 1000;
				top: -5px;
				left: 140%;
				overflow-y: auto; 
				overflow-x: hidden; 
			}
			
			<xsl:if test="$Infobox = '1'">
				.Infobox, .InfoboxHilfetext
				{
					position: relative;
					-webkit-user-select: none;
					-moz-user-select: none;
					-ms-user-select: none;
					user-select: none;
					
					background: blue;
					color: white;
					cursor: pointer;
					font-family: Arial, Helvetica, sans-serif;
					font-size: 12px;
					font-style: normal;
					font-weight: bold;
					text-shadow: none;
					text-align: center;
					height: 16px;
					width: 16px;
					border-radius: 50%;
					display: inline-block;
				}
				
				.Infobox .Popuptext
				{
					display: none;
					width: 400px;
					height: 200px;
	
					background-color: #cff;
					color: #000;
					border: 1px solid #333;
					box-shadow: 2px 2px 2px #444;
					font-weight: normal;
					text-align: left;
					border-radius: 6px;
					padding: 5px 15px;
					position: absolute;
					z-index: 1000;
					top: -5px;
					left: 140%;
					overflow-y: auto; 
					overflow-x: hidden; 
				}

				#zeigeLinkInfoboxen {
					display:none;
				}
	
				#versteckeLinkInfoboxen {
					display:inherit;
				}
			</xsl:if>

			<xsl:if test="$Copybutton = '1'">
				.Clipbutton, .ClippbuttonHilfetext
				{
					position: relative;
					-webkit-user-select: none;
					-moz-user-select: none;
					-ms-user-select: none;
					user-select: none;
					
					background: red;
					color: white;
					cursor: pointer;
					font-family: Arial, Helvetica, sans-serif;
					font-size: 12px;
					font-style: normal;
					font-weight: bold;
					text-shadow: none;
					text-align: center;
					height: 16px;
					width: 16px;
					border-radius: 50%;
					display: inline-block;
				}

				#zeigeLinkCopy {
					display:none;
				}

				#versteckeLinkCopy {
					display:inherit;
				}

				@keyframes KopierAni
				{
				  0%	{font-size: 12px;height: 16px;width: 16px;}
				  50%	{font-size: 16px;height: 20px;width: 20px;}
				  100%	{font-size: 12px;height: 16px;width: 16px;}
				}
			</xsl:if>

			<xsl:if test="$ToolAufruf = '1'">
				#zeigeLinkTool {
					display:none;
				}

				#versteckeLinkTool {
					display:inherit;
				}
			</xsl:if>

			.FG
			{
				border: 3px solid #333;
				box-shadow: 6px 6px 5px #444;
				padding: 8px;
				margin-bottom: 16px;
				margin-top: 16px;
				vertical-align: top;
				background: #eafaf1;
			}
			
			.FE
			{
				font-weight: normal;
				font-size: 12px;
				border: 1px solid #333;
				padding: 8px;
				margin-bottom: 8px;
				vertical-align: top;
				background: #eafaf1;
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
			
			<xsl:if test="$ZeigeDaten = '1'">
				.button
				{
					box-shadow: 0 8px 16px 0 rgba(0,0,0,0.2), 0 6px 20px 0 rgba(0,0,0,0.19);
					background-color: black;
					color: white;
					border: 2px solid black;
					padding: 15px 32px;
					text-align: center;
					text-decoration: none;
					display: inline-block;
					font-size: 16px;
					margin: 4px 2px;
					cursor: pointer;
					border-radius: 8px;
				}
				
				.buttonunsichtbar
				{
					display: none;
				}
				
				.button:hover
				{
					background-color: white;
					color: black;
				}

				@keyframes DatenAni
				{
				  0%	{box-shadow: 0 0 3px 3px blue;}
				  10%	{box-shadow: inherit;}
				  20%	{box-shadow: 0 0 3px 3px blue;}
				  30%	{box-shadow: inherit;}
				  40%	{box-shadow: 0 0 3px 3px blue;}
				  50%	{box-shadow: inherit;}
				  60%	{box-shadow: 0 0 3px 3px blue;}
				  70%	{box-shadow: inherit;}
				  80%	{box-shadow: 0 0 3px 3px blue;}
				  90%	{box-shadow: inherit;}
				  100%	{box-shadow: 0 0 3px 3px Blue;}
				}
	
				@keyframes FehlerAni
				{
				  0%	{box-shadow: 0 0 3px 3px red;}
				  10%	{box-shadow: inherit;}
				  20%	{box-shadow: 0 0 3px 3px red;}
				  30%	{box-shadow: inherit;}
				  40%	{box-shadow: 0 0 3px 3px red;}
				  50%	{box-shadow: inherit;}
				  60%	{box-shadow: 0 0 3px 3px red;}
				  70%	{box-shadow: inherit;}
				  80%	{box-shadow: 0 0 3px 3px red;}
				  90%	{box-shadow: inherit;}
				  100%	{box-shadow: 0 0 3px 3px red;}
				}

			</xsl:if>
			
			:invalid
			{
				background-color: #fadbd8; 
			}

			.SDSForm:invalid
			{
				background-color: white;
			}

			:valid
			{
				background-color: white;
			}

			input[type="radio"]:invalid
			{
				box-shadow: 0 0 1px 1px red;
			}

			input[type="radio"]:valid
			{
				box-shadow: 0 0 0 0;
			}

		</style>
			<script>
				<xsl:if test="$Navigation = '1'">
					function VersteckeNavigation() {
						const trennerClass = document.getElementsByClassName('TrennerNavi');
		
						document.getElementById('fixiert').style.display='none';
						document.getElementById('Inhalt').style.marginLeft='0.5em';
						document.getElementById('Inhalt').style.borderLeftStyle='none';
						document.getElementById('Inhalt').style.borderTopStyle='none';
		
						for (i = 0; i <xsl:text disable-output-escaping="yes">&lt;</xsl:text> trennerClass.length; i++) {
						  trennerClass[i].style.display='initial';
						}
						
						document.getElementById('Hinweis').style.display='block';
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

				function Zuklappen() {
					const fginhaltClass = document.getElementsByClassName('FGInhalt');
					
					for (i = 0; i <xsl:text disable-output-escaping="yes">&lt;</xsl:text> fginhaltClass.length; i++) {
					  fginhaltClass[i].style.display='none';
					}
				}
	
				function Aufklappen() {
					const fginhaltClass = document.getElementsByClassName('FGInhalt');
					
					for (i = 0; i <xsl:text disable-output-escaping="yes">&lt;</xsl:text> fginhaltClass.length; i++) {
					  fginhaltClass[i].style.display='block';
					}
				}
	
				function FGDuplizieren(Feld) {
				
					var Vater = Feld.parentNode;
					var Opa = Vater.parentNode;
					var NeuesElement;
					var KopieVater = Vater.cloneNode(true);
					var minCount = 0;
					var maxCount = 0;
					var currentCount;
					var ElementID;
					var i;
					var coll;
					var coll2;
					var coll3;
	
	
					Vater.insertAdjacentElement("afterend",KopieVater);
					
					NeuesElement = Vater.nextElementSibling;
					
					coll = NeuesElement.getElementsByClassName("FGBezeichnung");
					
					for (i = 0; i <xsl:text disable-output-escaping="yes">&lt;</xsl:text> coll.length; i++) {
					  coll[i].addEventListener("click", function() {
						this.classList.toggle("active");
						var content = this.nextElementSibling.nextElementSibling;
						if (content.style.display === "none") {
						  content.style.display = "block";
						} else {
						  content.style.display = "none";
						}
					  });
					}
	
					coll3 = NeuesElement.getElementsByClassName("Eingabe");
	
					for (i = 0; i <xsl:text disable-output-escaping="yes">&lt;</xsl:text> coll3.length; i++) {
	
						coll3[i].value = '';
						}
	
					minCount = Vater.children[0].value;
					maxCount = Vater.children[1].value;
					ElementID = Vater.children[2].value;
	
					currentCount = 0;
	
					coll2 = Opa.children;
					
					for (i = 0; i <xsl:text disable-output-escaping="yes">&lt;</xsl:text> coll2.length; i++) {
	
						if (coll2[i].children[2].value === ElementID) {
							  currentCount++;
							}
						}
	
					for (i = 0; i <xsl:text disable-output-escaping="yes">&lt;</xsl:text> coll2.length; i++) {
	
						if (coll2[i].children[2].value === ElementID) {
	
							if (Number(currentCount) === Number(maxCount)) {
			
								coll2[i].getElementsByClassName("Plus")[0].disabled = true;
				
								} else {
								
								coll2[i].getElementsByClassName("Plus")[0].disabled = false;
				
								}
		
							if (Number(currentCount) === Number(minCount)) {
			
								coll2[i].getElementsByClassName("Minus")[0].disabled = true;
				
								} else {
								
								coll2[i].getElementsByClassName("Minus")[0].disabled = false;
				
								}
						}
					}
	
				}
	
				function FGEntfernen(Feld) {
				
					var Vater = Feld.parentNode;
					var Opa = Vater.parentNode;
					var minCount = 0;
					var maxCount = 0;
					var currentCount;
					var ElementID;
					var i;
					var coll;
	
					minCount = Vater.children[0].value;
					maxCount = Vater.children[1].value;
					ElementID = Vater.children[2].value;
					
					Vater.remove();
	
					currentCount = 0;
	
					coll = Opa.children;
					
					for (i = 0; i <xsl:text disable-output-escaping="yes">&lt;</xsl:text> coll.length; i++) {
	
						if (coll[i].children[2].value === ElementID) {
							  currentCount++;
							}
						}
					
					for (i = 0; i <xsl:text disable-output-escaping="yes">&lt;</xsl:text> coll.length; i++) {
	
						if (coll[i].children[2].value === ElementID) {
	
							if (Number(currentCount) === Number(maxCount)) {
			
								coll[i].getElementsByClassName("Plus")[0].disabled = true;
				
								} else {
								
								coll[i].getElementsByClassName("Plus")[0].disabled = false;
				
								}
		
							if (Number(currentCount) === Number(minCount)) {
			
								coll[i].getElementsByClassName("Minus")[0].disabled = true;
				
								} else {
								
								coll[i].getElementsByClassName("Minus")[0].disabled = false;
				
								}
						}
					}
					
				}
	
				function FEDuplizieren(Feld) {
				
					var Vater = Feld.parentNode;
					var Opa = Vater.parentNode;
					var NeuesElement;
					var KopieVater = Vater.cloneNode(true);
					var minCount = 0;
					var maxCount = 0;
					var currentCount;
					var ElementID;
					var i;
					var coll;
					var coll2;
	
					Vater.insertAdjacentElement("afterend",KopieVater);
	
					NeuesElement = Vater.nextElementSibling;
					
					coll2 = NeuesElement.getElementsByClassName("Eingabe");
	
					for (i = 0; i <xsl:text disable-output-escaping="yes">&lt;</xsl:text> coll2.length; i++) {
	
						coll2[i].value = '';
						}
	
					minCount = Vater.children[0].value;
					maxCount = Vater.children[1].value;
					ElementID = Vater.children[2].value;
					
					currentCount = 0;
	
					coll = Opa.children;
					
					for (i = 0; i <xsl:text disable-output-escaping="yes">&lt;</xsl:text> coll.length; i++) {
	
						if (coll[i].children[2].value === ElementID) {
							  currentCount++;
							}
						}
	
	<!--					
					confirm("minCount: " + minCount + " maxCount: " + maxCount + " ElementID: " + ElementID + " currentCount: " + currentCount);
	-->
					
					for (i = 0; i <xsl:text disable-output-escaping="yes">&lt;</xsl:text> coll.length; i++) {
	
						if (coll[i].children[2].value === ElementID) {
	
							if (Number(currentCount) === Number(maxCount)) {
			
								coll[i].getElementsByClassName("Plus")[0].disabled = true;
				
								} else {
								
								coll[i].getElementsByClassName("Plus")[0].disabled = false;
				
								}
		
							if (Number(currentCount) === Number(minCount)) {
			
								coll[i].getElementsByClassName("Minus")[0].disabled = true;
				
								} else {
								
								coll[i].getElementsByClassName("Minus")[0].disabled = false;
				
								}
						}
					}
					
				}
	
				function FEEntfernen(Feld) {
				
					var Vater = Feld.parentNode;
					var Opa = Vater.parentNode;
					var minCount = 0;
					var maxCount = 0;
					var currentCount;
					var ElementID;
					var i;
					var coll;
	
					minCount = Vater.children[0].value;
					maxCount = Vater.children[1].value;
					ElementID = Vater.children[2].value;
					
					Vater.remove();
	
					currentCount = 0;
	
					coll = Opa.children;
					
					for (i = 0; i <xsl:text disable-output-escaping="yes">&lt;</xsl:text> coll.length; i++) {
	
						if (coll[i].children[2].value === ElementID) {
							  currentCount++;
							}
						}
					
					for (i = 0; i <xsl:text disable-output-escaping="yes">&lt;</xsl:text> coll.length; i++) {
	
						if (coll[i].children[2].value === ElementID) {
	
							if (Number(currentCount) === Number(maxCount)) {
			
								coll[i].getElementsByClassName("Plus")[0].disabled = true;
				
								} else {
								
								coll[i].getElementsByClassName("Plus")[0].disabled = false;
				
								}
		
							if (Number(currentCount) === Number(minCount)) {
			
								coll[i].getElementsByClassName("Minus")[0].disabled = true;
				
								} else {
								
								coll[i].getElementsByClassName("Minus")[0].disabled = false;
				
								}
						}
					}
					
				}
	
				function aktiviereLeerenButton(Feld) {
	
					var ButtonElement = Feld.nextElementSibling;
	
					ButtonElement.disabled = false;
	
				}
	
				function DateiLeeren(Feld) {
				
					var DateiElement = Feld.previousElementSibling;
					
					DateiElement.value ='';
	
					Feld.disabled = true;
				}
	
				function ZeigeBox(Feld) {
					var popup = Feld.children[0];

					var popuplist = document.getElementsByClassName("Popuptext");
					var i;
					var b = (popup.style.display === 'none');
					
					for (i = 0; i <xsl:text disable-output-escaping="yes">&lt;</xsl:text>popuplist.length; i++) {
						popuplist[i].style.display ='none';
					}  

					if (b) {
						popup.style.display = 'block';
					} else {
						popup.style.display = 'none';
					}
				}
									
				<xsl:if test="$Infobox = '1'">
	
					function VersteckeInfoboxen() {
						const infoboxClass = document.getElementsByClassName('Infobox');
						
						for (i = 0; i <xsl:text disable-output-escaping="yes">&lt;</xsl:text> infoboxClass.length; i++) {
						  infoboxClass[i].style.display='none';
						}
						document.getElementById('versteckeLinkInfoboxen').style.display='none';
						document.getElementById('zeigeLinkInfoboxen').style.display='inherit';
					}
		
					function ZeigeInfoboxen() {
						const infoboxClass = document.getElementsByClassName('Infobox');
						
						for (i = 0; i <xsl:text disable-output-escaping="yes">&lt;</xsl:text> infoboxClass.length; i++) {
						  infoboxClass[i].style.display='inline-block';
						}
						document.getElementById('versteckeLinkInfoboxen').style.display='none';
						document.getElementById('versteckeLinkInfoboxen').style.display='inherit';
						document.getElementById('zeigeLinkInfoboxen').style.display='none';
					}
					
				</xsl:if>
				
				<xsl:if test="$Copybutton = '1'">
				
					function VersteckeCopybutton() {
						const copybuttonClass = document.getElementsByClassName('Clipbutton');
						
						for (i = 0; i <xsl:text disable-output-escaping="yes">&lt;</xsl:text> copybuttonClass.length; i++) {
						  copybuttonClass[i].style.display='none';
						}
						document.getElementById('versteckeLinkCopy').style.display='none';
						document.getElementById('zeigeLinkCopy').style.display='inherit';
					}
		
					function ZeigeCopybutton() {
						const copybuttonClass = document.getElementsByClassName('Clipbutton');
						
						for (i = 0; i <xsl:text disable-output-escaping="yes">&lt;</xsl:text> copybuttonClass.length; i++) {
						  copybuttonClass[i].style.display='inline-block';
						}
						document.getElementById('versteckeLinkCopy').style.display='none';
						document.getElementById('versteckeLinkCopy').style.display='inherit';
						document.getElementById('zeigeLinkCopy').style.display='none';
					}
					
					function copyStringToClipboard (clicked, str) {
	
						var el = document.createElement('textarea');
	
						el.value = str;
						el.setAttribute('readonly', '');
						el.style = {position: 'absolute', left: '-9999px'};
						document.body.appendChild(el);
						el.select();
						document.execCommand('copy');
						document.body.removeChild(el);
	
	
						clicked.style.animation = "";
						
						setTimeout(function ()
									{
										clicked.style.animation = "KopierAni 0.5s ease 1";
									}
								, 0);
					}
				
				</xsl:if>

				<xsl:if test="$ToolAufruf = '1'">

					function VersteckeToolbutton() {
						const toolbuttonClass = document.getElementsByClassName('Toolbutton');
						
						for (i = 0; i <xsl:text disable-output-escaping="yes">&lt;</xsl:text> toolbuttonClass.length; i++) {
						  toolbuttonClass[i].style.display='none';
						}
						document.getElementById('versteckeLinkTool').style.display='none';
						document.getElementById('zeigeLinkTool').style.display='inherit';
					}
		
					function ZeigeToolbutton() {
						const toolbuttonClass = document.getElementsByClassName('Toolbutton');
						
						for (i = 0; i <xsl:text disable-output-escaping="yes">&lt;</xsl:text> toolbuttonClass.length; i++) {
						  toolbuttonClass[i].style.display='inline-block';
						}
						document.getElementById('versteckeLinkTool').style.display='none';
						document.getElementById('versteckeLinkTool').style.display='inherit';
						document.getElementById('zeigeLinkTool').style.display='none';
					}
					
				</xsl:if>

				<xsl:if test="$ZeigeDaten = '1'">
					function zeigeDaten() 
					{
					
						var EingabeClass = document.getElementsByClassName('Eingabe');
						
						var FehlerElement = document.querySelectorAll(":invalid");
						
						document.getElementById("versteckeDaten").style.display = 'inline-block';
						
						document.getElementById("DatenListe").innerHTML = '';
						
						document.getElementById("DatenListe").insertAdjacentHTML('beforeend', "<xsl:text disable-output-escaping="yes">&lt;</xsl:text>b<xsl:text disable-output-escaping="yes">&gt;</xsl:text>Daten: <xsl:text disable-output-escaping="yes">&lt;</xsl:text>/b<xsl:text disable-output-escaping="yes">&gt;</xsl:text><xsl:text disable-output-escaping="yes">&lt;</xsl:text>br/<xsl:text disable-output-escaping="yes">&gt;</xsl:text><xsl:text disable-output-escaping="yes">&lt;</xsl:text>br/<xsl:text disable-output-escaping="yes">&gt;</xsl:text>");
						
						for (i = 0; i <xsl:text disable-output-escaping="yes">&lt;</xsl:text> EingabeClass.length; i++) 
						{
							if (EingabeClass[i].tagName == 'INPUT') 
							{
								if (EingabeClass[i].type == 'radio') 
								{
									if (EingabeClass[i].checked) 
									{
										document.getElementById("DatenListe").insertAdjacentHTML('beforeend', '<xsl:text disable-output-escaping="yes">&lt;a href=\"#</xsl:text>' + EingabeClass[i].id + '<xsl:text disable-output-escaping="yes">\" onclick=\"blinkDaten(\'</xsl:text>'+EingabeClass[i].id+'<xsl:text disable-output-escaping="yes">\')\"&gt;&#8593;&lt;/a&gt; </xsl:text>');

										document.getElementById("DatenListe").insertAdjacentHTML('beforeend', EingabeClass[i].name + ':    '+ EingabeClass[i].value + "<xsl:text disable-output-escaping="yes">&lt;br/&gt;</xsl:text>");
									}
								}
								else
								{
									if (EingabeClass[i].value != '')
									{
										document.getElementById("DatenListe").insertAdjacentHTML('beforeend', '<xsl:text disable-output-escaping="yes">&lt;a href=\"#</xsl:text>' + EingabeClass[i].id + '<xsl:text disable-output-escaping="yes">\" onclick=\"blinkDaten(\'</xsl:text>'+EingabeClass[i].id+'<xsl:text disable-output-escaping="yes">\')\"&gt;&#8593;&lt;/a&gt; </xsl:text>');

										document.getElementById("DatenListe").insertAdjacentHTML('beforeend', EingabeClass[i].name + ':    '+ EingabeClass[i].value + "<xsl:text disable-output-escaping="yes">&lt;br/&gt;</xsl:text>");
									}
								}
							}
	
							if (EingabeClass[i].tagName == 'TEXTAREA') 
							{
								if (EingabeClass[i].value != '') 
								{
									document.getElementById("DatenListe").insertAdjacentHTML('beforeend', '<xsl:text disable-output-escaping="yes">&lt;a href=\"#</xsl:text>' + EingabeClass[i].id + '<xsl:text disable-output-escaping="yes">\" onclick=\"blinkDaten(\'</xsl:text>'+EingabeClass[i].id+'<xsl:text disable-output-escaping="yes">\')\"&gt;&#8593;&lt;/a&gt; </xsl:text>');

									document.getElementById("DatenListe").insertAdjacentHTML('beforeend', EingabeClass[i].name + ':    '+ EingabeClass[i].value + "<xsl:text disable-output-escaping="yes">&lt;br/&gt;</xsl:text>");
								}
							}
	
							if (EingabeClass[i].tagName == 'SELECT') 
							{
								if (EingabeClass[i].value != '') 
								{
									document.getElementById("DatenListe").insertAdjacentHTML('beforeend', '<xsl:text disable-output-escaping="yes">&lt;a href=\"#</xsl:text>' + EingabeClass[i].id + '<xsl:text disable-output-escaping="yes">\" onclick=\"blinkDaten(\'</xsl:text>'+EingabeClass[i].id+'<xsl:text disable-output-escaping="yes">\')\"&gt;&#8593;&lt;/a&gt; </xsl:text>');

									document.getElementById("DatenListe").insertAdjacentHTML('beforeend', EingabeClass[i].name + ':    '+ EingabeClass[i].value + "<xsl:text disable-output-escaping="yes">&lt;br/&gt;</xsl:text>");
								}
							}
	
							if (EingabeClass[i].tagName == 'SPAN') 
							{
								if (EingabeClass[i].innerHTML != '')
								{
									document.getElementById("DatenListe").insertAdjacentHTML('beforeend', '<xsl:text disable-output-escaping="yes">&lt;a href=\"#</xsl:text>' + EingabeClass[i].id + '<xsl:text disable-output-escaping="yes">\" onclick=\"blinkDaten(\'</xsl:text>'+EingabeClass[i].id+'<xsl:text disable-output-escaping="yes">\')\"&gt;&#8593;&lt;/a&gt; </xsl:text>');
	
									document.getElementById("DatenListe").insertAdjacentHTML('beforeend', EingabeClass[i].id + ':    '+ EingabeClass[i].innerHTML + "<xsl:text disable-output-escaping="yes">&lt;br/&gt;</xsl:text>");
								} 
							}
						}

						document.getElementById("DatenListe").insertAdjacentHTML('beforeend', "<xsl:text disable-output-escaping="yes">&lt;br/&gt;&lt;b&gt;Fehler: &lt;/b&gt;&lt;br/&gt;&lt;br/&gt;</xsl:text>");

						for (i = 0; i <xsl:text disable-output-escaping="yes">&lt;</xsl:text> FehlerElement.length; i++) 
						{
							if (FehlerElement[i].tagName == 'INPUT' || FehlerElement[i].tagName == 'TEXTAREA' || FehlerElement[i].tagName == 'SELECT') 
							{
								document.getElementById("DatenListe").insertAdjacentHTML('beforeend', '<xsl:text disable-output-escaping="yes">&lt;a href=\"#</xsl:text>' + FehlerElement[i].id + '<xsl:text disable-output-escaping="yes">\" onclick=\"blinkFehler(\'</xsl:text>'+FehlerElement[i].id+'<xsl:text disable-output-escaping="yes">\')\"&gt;&#8593;&lt;/a&gt; </xsl:text>');

								document.getElementById("DatenListe").insertAdjacentHTML('beforeend', FehlerElement[i].name + ':    '+ FehlerElement[i].value + "<xsl:text disable-output-escaping="yes">&lt;br/&gt;</xsl:text>");
							}

						}
					}

					function versteckeDaten() 
					{
						document.getElementById("DatenListe").innerHTML = '';

						document.getElementById("versteckeDaten").style.display = 'none';
					}

					function blinkDaten(FeldID)
					{
					
						document.getElementById(FeldID).style.animation = "";
						
						setTimeout(function ()
									{
										document.getElementById(FeldID).style.animation = "DatenAni 8s ease 1";
									}
								, 0);
						
					}

					function blinkFehler(FeldID)
					{
					
						document.getElementById(FeldID).style.animation = "";
						
						setTimeout(function ()
									{
										document.getElementById(FeldID).style.animation = "FehlerAni 8s ease 1";
									}
								, 0);
						
					}

				</xsl:if>
	
				function onloadFunktion()
				{
					<xsl:if test="$Copybutton = '1'">
						VersteckeCopybutton();
					</xsl:if>
				}

			</script>
	</xsl:template>

	<!-- ############################################################################################################# -->

	<xsl:template name="script">
		<xsl:if test="$DebugMode = '1' or $DebugMode = '2' or $DebugMode = '3' or $DebugMode = '4'">
			<xsl:message>
				++++ script ++++
			</xsl:message>
		</xsl:if>
		<script>
			var coll = document.getElementsByClassName("FGBezeichnung");
			var i;
			var popuplist = document.getElementsByClassName("Popuptext");
			
			for (i = 0; i <xsl:text disable-output-escaping="yes">&lt;</xsl:text>popuplist.length; i++) {
				popuplist[i].style.display ='none';
			}  

			for (i = 0; i <xsl:text disable-output-escaping="yes">&lt;</xsl:text> coll.length; i++) {
			  coll[i].addEventListener("click", function() {
				this.classList.toggle("active");
				var content = this.nextElementSibling.nextElementSibling;
				if (content.style.display === "none") {
				  content.style.display = "block";
				} else {
				  content.style.display = "none";
				}
			  });
			}
		</script>
	</xsl:template>

	<!-- ############################################################################################################# -->

</xsl:stylesheet>
