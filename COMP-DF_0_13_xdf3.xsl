<?xml version="1.0" encoding="iso-8859-1"?>
<xsl:stylesheet
	version="2.0"
	xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
	xmlns:html="http://www.w3.org/1999/xhtml"
	xmlns="http://www.w3.org/1999/xhtml"
	xmlns:fn="http://www.w3.org/2005/xpath-functions"
	xmlns:xdf3="urn:xoev-de:fim:standard:xdatenfelder_3.0.0" 
	xmlns:gc="http://docs.oasis-open.org/codelist/ns/genericode/1.0/" 
	xmlns:ext="http://www.xoev.de/de/xrepository/framework/1/extrakte" 
	xmlns:bdt="http://www.xoev.de/de/xrepository/framework/1/basisdatentypen" 
	xmlns:dat="http://www.xoev.de/de/xrepository/framework/1/datenbereitstellung" 
	xmlns:xs="http://www.w3.org/2001/XMLSchema" 
	exclude-result-prefixes="html xs xsl fn xdf3 gc ext bdt dat">
	<!--
	Copyright 2025 Volker Schmitz
	
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
	 
	<xsl:variable name="StyleSheetName" select="'COMP-DF_0_13_xdf3.xsl'"/> <!-- BackUp, falls fn:static-base-uri() leer -->

	<xsl:output
		method="xhtml"
		doctype-system="http://www.w3.org/TR/xhtml11/DTD/xhtml11.dtd"
		doctype-public="-//W3C//DTD XHTML 1.1//EN"
		omit-xml-declaration="yes"
	/>

	<xsl:strip-space elements="*"/>
		
	<xsl:decimal-format name="european" decimal-separator="," grouping-separator="."/>

	<xsl:param name="DateiOutput" select="'0'"/>
	<xsl:param name="VergleichsDateiName"/>

	<xsl:param name="Navigation" select="'1'"/>
	<xsl:param name="HandlungsgrundlagenLinks" select="'1'"/>
	<xsl:param name="XRepoAufruf" select="'1'"/>
	<xsl:param name="JavaScript" select="'1'"/>

	<xsl:param name="CodelistenInhalt" select="'1'"/>
	<xsl:param name="AktuelleCodelisteLaden" select="'1'"/>

	<xsl:param name="AenderungsFazit" select="'1'"/>
	<xsl:param name="RegelDetails" select="'1'"/>

	<xsl:param name="ToolAufruf" select="'1'"/>
	<xsl:param name="ToolPfadPrefix" select="'https://www.fim-formular.niedersachsen.de/fim/portal/fim/9/editor/'"/>
	<xsl:param name="ToolPfadPostfix" select="'/view'"/>

	<xsl:param name="DebugMode" select="'3'"/>

	<xsl:variable name="DocXRepoOhneVersionPfadPrefix" select="'https://www.xrepository.de/details/'"/>
	<xsl:variable name="DocXRepoOhneVersionPfadPostfix" select="''"/>
	<xsl:variable name="DocXRepoMitVersionPfadPrefix" select="'https://www.xrepository.de/details/'"/>
	<xsl:variable name="DocXRepoMitVersionPfadPostfix" select="'#version'"/>
	<xsl:variable name="XMLXRepoOhneVersionPfadPrefix" select="'https://www.xrepository.de/api/codeliste/'"/>
	<xsl:variable name="XMLXRepoOhneVersionPfadPostfix" select="'/gueltigeVersion'"/>
	<xsl:variable name="XMLXRepoMitVersionPfadPrefix" select="'https://www.xrepository.de/api/version_codeliste/'"/>
	<xsl:variable name="XMLXRepoMitVersionPfadPostfix" select="'/genericode'"/>

	<xsl:variable name="InputDateiname" select="(tokenize($DocumentURI,'/'))[last()]"/>
	<xsl:variable name="InputPfad" select="fn:substring-before($DocumentURI, $InputDateiname)"/>
	<xsl:variable name="InputDateinameOhneExt" select="(tokenize($InputDateiname,'\.'))[1]"/>
	<xsl:variable name="InputDatei" select="concat($InputPfad,$InputDateiname)"/>
	
	<xsl:variable name="Daten" select="/"/>
	
	<xsl:variable name="VergleichsDatei" select="concat($InputPfad,$VergleichsDateiName)"/>
	<xsl:variable name="VergleichsDaten" select="document($VergleichsDatei)"/>
	<xsl:variable name="VergleichsDateinameOhneExt" select="(tokenize($VergleichsDateiName,'\.'))[1]"/>
	
	<xsl:variable name="NameSDSA"><xsl:value-of select="/*/*/xdf3:identifikation/xdf3:id"/><xsl:if test="/*/*/xdf3:identifikation/xdf3:version"> Version <xsl:value-of select="/*/*/xdf3:identifikation/xdf3:version"/></xsl:if></xsl:variable>
	<xsl:variable name="NameSDSO"><xsl:value-of select="$VergleichsDaten/*/*/xdf3:identifikation/xdf3:id"/><xsl:if test="$VergleichsDaten/*/*/xdf3:identifikation/xdf3:version"> Version <xsl:value-of select="$VergleichsDaten/*/*/xdf3:identifikation/xdf3:version"/></xsl:if></xsl:variable>
	<xsl:variable name="KurznameSDSA"><xsl:value-of select="/*/*/xdf3:identifikation/xdf3:id"/><xsl:if test="/*/*/xdf3:identifikation/xdf3:version">V<xsl:value-of select="/*/*/xdf3:identifikation/xdf3:version"/></xsl:if></xsl:variable>
	<xsl:variable name="KurznameSDSO"><xsl:value-of select="$VergleichsDaten/*/*/xdf3:identifikation/xdf3:id"/><xsl:if test="$VergleichsDaten/*/*/xdf3:identifikation/xdf3:version">V<xsl:value-of select="$VergleichsDaten/*/*/xdf3:identifikation/xdf3:version"/></xsl:if></xsl:variable>
	
	<xsl:template match="/">

		<xsl:if test="$DebugMode = '1' or $DebugMode = '2' or $DebugMode = '3' or $DebugMode = '4'">
			<xsl:message>
				Start
				Input: <xsl:value-of select="$InputDateiname"/>
				VergleichsDateiName: <xsl:value-of select="$VergleichsDateiName"/>
			</xsl:message>
		</xsl:if>

		<xsl:if test="fn:string-length($VergleichsDateiName) &lt; 1">
			<xsl:message>
				FEHLER: es muss ein Parameter mit dem Namen der Vergleichsdatei angegeben werden, z.B. VergleichsDateiName=beispiel.xml
			</xsl:message>
		</xsl:if>

		<xsl:if test="$DebugMode = '4'">
			<xsl:message>
				Parameter
				DateiOutput: <xsl:value-of select="$DateiOutput"/>
				VergleichsDateiName: <xsl:value-of select="$VergleichsDateiName"/>
				CodelistenInhalt: <xsl:value-of select="$CodelistenInhalt"/>
				AktuelleCodelisteLaden: <xsl:value-of select="$AktuelleCodelisteLaden"/>
				AenderungsFazit: <xsl:value-of select="$AenderungsFazit"/>
				RegelDetails: <xsl:value-of select="$RegelDetails"/>
				Navigation: <xsl:value-of select="$Navigation"/>
				JavaScript: <xsl:value-of select="$JavaScript"/>
				HandlungsgrundlagenLinks: <xsl:value-of select="$HandlungsgrundlagenLinks"/>				
				ToolAufruf: <xsl:value-of select="$ToolAufruf"/>
				ToolPfadPrefix: <xsl:value-of select="$ToolPfadPrefix"/>
				ToolPfadPostfix: <xsl:value-of select="$ToolPfadPostfix"/>
				XRepoAufruf: <xsl:value-of select="$XRepoAufruf"/>				
				DebugMode: <xsl:value-of select="$DebugMode"/>
				<!-- Vergleichsdaten: <xsl:copy-of select="$VergleichsDaten"/> -->
			</xsl:message>
		</xsl:if>

		<xsl:choose>
			<xsl:when test="$DateiOutput ='1'">

				<xsl:variable name="OutputDateiname">
					<xsl:choose>
						<xsl:when test="name(/*) ='xdf3:xdatenfelder.stammdatenschema.0102'">Vergleich_<xsl:value-of select="$KurznameSDSA"/>_<xsl:value-of select="$KurznameSDSO"/>.html</xsl:when>
						<xsl:when test="name(/*) ='xdf3:xdatenfelder.datenfeldgruppe.0103'">Vergleich_<xsl:value-of select="$KurznameSDSA"/>_<xsl:value-of select="$KurznameSDSO"/>.html</xsl:when>
						<xsl:when test="name(/*) ='CodeList'">Vergleich_<xsl:value-of select="$InputDateinameOhneExt"/>_<xsl:value-of select="$VergleichsDateinameOhneExt"/>.html</xsl:when>
						<xsl:when test="name(/*) ='gc:CodeList'">Vergleich_<xsl:value-of select="$InputDateinameOhneExt"/>_<xsl:value-of select="$VergleichsDateinameOhneExt"/>.html</xsl:when>
						<xsl:otherwise>QS-Bericht_FEHLER.html</xsl:otherwise>
					</xsl:choose>
				</xsl:variable>
				
				<xsl:message>
					<xsl:value-of select="name(/*)"/>
				</xsl:message>
		
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
							<title>Vergleich von Datenschema <xsl:value-of select="$NameSDSA"/> mit Datenschema <xsl:value-of select="$NameSDSO"/></title>
						</xsl:when>
						<xsl:when test="name(/*) ='xdf3:xdatenfelder.datenfeldgruppe.0103'">
							<title>Vergleich von Datenfeldgruppe <xsl:value-of select="$NameSDSA"/> mit Datenfeldgruppe <xsl:value-of select="$NameSDSO"/></title>
						</xsl:when>
						<xsl:when test="name(/*) ='CodeList'">
							<title>Vergleich von Codeliste <xsl:value-of select="$InputDateinameOhneExt"/> mit Codeliste <xsl:value-of select="$VergleichsDateinameOhneExt"/></title>
						</xsl:when>
						<xsl:when test="name(/*) ='gc:CodeList'">
							<title>Vergleich von Codeliste <xsl:value-of select="$InputDateinameOhneExt"/> mit Codeliste <xsl:value-of select="$VergleichsDateinameOhneExt"/></title>
						</xsl:when>
						<xsl:otherwise>
							<title>Unbekanntes Dateiformat</title>
						</xsl:otherwise>
					</xsl:choose>
					<meta name="author" content="Volker Schmitz"/>
				</head>
				 <xsl:call-template name="styleandscript"/>
				<body onload="ZaehleAenderungen()">
					<xsl:choose>
						<xsl:when test="name(/*) ='xdf3:xdatenfelder.stammdatenschema.0102'">
							<xsl:if test="$Navigation = '1'">
								<div id="fixiert" class="Navigation">
									<xsl:if test="$JavaScript = '1'">
										<p align="right"><a href="#" title="Schließe das Navigationsfenster" onclick="VersteckeNavigation(); return false;">&#10006;</a></p>
									</xsl:if>
									<h2>Navigation</h2>
									<xsl:choose>
										<xsl:when test="name(/*) ='xdf3:xdatenfelder.stammdatenschema.0102'">
											<xsl:if test="$AenderungsFazit = '1' and $JavaScript = '1'">
												<p id="ZusammenfassungLink"><a href="#Zusammenfassung">Zusammenfassung der Änderungen</a></p>
											</xsl:if>
											<p><a href="#StammDetails">Details zu den Datenschemata</a></p>
											<p><a href="#ElementDetails">Details zu den Baukastenelementen</a></p>
											<xsl:if test="$RegelDetails = '1'">
												<p><a href="#RegelDetails">Details zu den Regeln</a></p>
											</xsl:if>
											<p><a href="#CodelisteDetails">Details zu den Codelisten</a></p>
										</xsl:when>
										<xsl:otherwise>
											<p>Unbekanntes Dateiformat</p>
										</xsl:otherwise>
									</xsl:choose>
								</div>
							</xsl:if>					
						
							<div id="Inhalt">
								<div id="Zusammenfassungsbereich">
									<xsl:if test="$AenderungsFazit = '1' and $JavaScript = '1'">
										<h2><a name="Zusammenfassung"/>Zusammenfassung der Änderung des Datenschemas <xsl:value-of select="/*/xdf3:stammdatenschema/xdf3:identifikation/xdf3:id"/><xsl:if test="/*/xdf3:stammdatenschema/xdf3:identifikation/xdf3:version">&#160;Version&#160;<xsl:value-of select="/*/xdf3:stammdatenschema/xdf3:identifikation/xdf3:version"/></xsl:if></h2>
										<p class="Zusammenfassung">Änderungen der Baukastenelementen</p>
										<p>
											<span id="AnzahlAenderungBaukasten"/><br/>
											<span id="AnzahlNeuBaukasten"/><br/>
											<span id="AnzahlGeloeschtBaukasten"/><br/>
										</p>
										<p class="Zusammenfassung">Änderungen der Codelisten</p>
										<p>
											<span id="AnzahlAenderungCodelisten"/><br/>
											<span id="AnzahlNeuCodelisten"/><br/>
											<span id="AnzahlGeloeschtCodelisten"/><br/>
										</p>
									</xsl:if>
								</div>
								
								<xsl:call-template name="datenschemaeinzeln"/>
	
								<xsl:call-template name="listeelementedetail"/>
	
								<xsl:if test="$RegelDetails = '1'">
									<xsl:call-template name="listeregeldetails"/>
								</xsl:if>

								<xsl:call-template name="listecodelistendetails"/>
	
								<p>Erstellt am: <xsl:value-of select="format-date(fn:current-date(),'[D01].[M01].[Y0001]')"/> um <xsl:value-of select="format-time(fn:current-time(),'[H01]:[m01]')"/> Uhr</p>
								<p>XSLT: <xsl:choose><xsl:when test="empty($StyleSheetURI)"><xsl:value-of select="$StyleSheetName"/></xsl:when><xsl:otherwise><xsl:call-template name="fileName"><xsl:with-param name="path" select="$StyleSheetURI"/></xsl:call-template></xsl:otherwise></xsl:choose></p>
								<p>
									<xsl:if test="not(empty($DocumentURI))">
										XML-Original: <xsl:call-template name="fileName"><xsl:with-param name="path" select="$DocumentURI"/></xsl:call-template><br/>
									</xsl:if>
									XML-Vergleich: <xsl:value-of select="$VergleichsDateiName"/>
								</p>

							</div>
						</xsl:when>
						<xsl:when test="name(/*) ='xdf3:xdatenfelder.datenfeldgruppe.0103'">
							<xsl:if test="$Navigation = '1'">
								<div id="fixiert" class="Navigation">
									<xsl:if test="$JavaScript = '1'">
										<p align="right"><a href="#" title="Schließe das Navigationsfenster" onclick="VersteckeNavigation(); return false;">&#10006;</a></p>
									</xsl:if>
									<h2>Navigation</h2>
									<xsl:choose>
										<xsl:when test="name(/*) ='xdf3:xdatenfelder.datenfeldgruppe.0103'">
											<xsl:if test="$AenderungsFazit = '1' and $JavaScript = '1'">
												<p id="ZusammenfassungLink"><a href="#Zusammenfassung">Zusammenfassung der Änderungen</a></p>
											</xsl:if>
											<p><a href="#StammDetails">Details zu den Datenfeldgruppen</a></p>
											<p><a href="#ElementDetails">Details zu den Baukastenelementen</a></p>
											<xsl:if test="$RegelDetails = '1'">
												<p><a href="#RegelDetails">Details zu den Regeln</a></p>
											</xsl:if>
											<p><a href="#CodelisteDetails">Details zu den Codelisten</a></p>
										</xsl:when>
										<xsl:otherwise>
											<p>Unbekanntes Dateiformat</p>
										</xsl:otherwise>
									</xsl:choose>
								</div>
							</xsl:if>					
						
							<div id="Inhalt">
								<div id="Zusammenfassungsbereich">
									<xsl:if test="$AenderungsFazit = '1' and $JavaScript = '1'">
										<h2><a name="Zusammenfassung"/>Zusammenfassung der Änderung der Datenfeldgruppe <xsl:value-of select="/*/xdf3:datenfeldgruppe/xdf3:identifikation/xdf3:id"/><xsl:if test="/*/xdf3:datenfeldgruppe/xdf3:identifikation/xdf3:version">&#160;Version&#160;<xsl:value-of select="/*/xdf3:datenfeldgruppe/xdf3:identifikation/xdf3:version"/></xsl:if></h2>
										<p class="Zusammenfassung">Änderungen der Baukastenelementen</p>
										<p>
											<span id="AnzahlAenderungBaukasten"/><br/>
											<span id="AnzahlNeuBaukasten"/><br/>
											<span id="AnzahlGeloeschtBaukasten"/><br/>
										</p>
										<p class="Zusammenfassung">Änderungen der Codelisten</p>
										<p>
											<span id="AnzahlAenderungCodelisten"/><br/>
											<span id="AnzahlNeuCodelisten"/><br/>
											<span id="AnzahlGeloeschtCodelisten"/><br/>
										</p>
									</xsl:if>
								</div>
								
								<xsl:call-template name="datenfeldgruppeeinzeln"/>
	
								<xsl:call-template name="listeelementedetail"/>
	
								<xsl:if test="$RegelDetails = '1'">
									<xsl:call-template name="listeregeldetails"/>
								</xsl:if>

								<xsl:call-template name="listecodelistendetails"/>
	
								<p>Erstellt am: <xsl:value-of select="format-date(fn:current-date(),'[D01].[M01].[Y0001]')"/> um <xsl:value-of select="format-time(fn:current-time(),'[H01]:[m01]')"/> Uhr</p>
								<p>XSLT: <xsl:choose><xsl:when test="empty($StyleSheetURI)"><xsl:value-of select="$StyleSheetName"/></xsl:when><xsl:otherwise><xsl:call-template name="fileName"><xsl:with-param name="path" select="$StyleSheetURI"/></xsl:call-template></xsl:otherwise></xsl:choose></p>
								<p>
									<xsl:if test="not(empty($DocumentURI))">
										XML-Original: <xsl:call-template name="fileName"><xsl:with-param name="path" select="$DocumentURI"/></xsl:call-template><br/>
									</xsl:if>
									XML-Vergleich: <xsl:value-of select="$VergleichsDateiName"/>
								</p>

							</div>
						</xsl:when>
						<xsl:when test="name(/*) ='CodeList'">
							<div id="Inhalt">
							
										
								<xsl:call-template name="codelistendetails"/>
	
								<p>Erstellt am: <xsl:value-of select="format-date(fn:current-date(),'[D01].[M01].[Y0001]')"/> um <xsl:value-of select="format-time(fn:current-time(),'[H01]:[m01]')"/> Uhr</p>
	
								<p>XSLT: <xsl:value-of select="tokenize($StyleSheetURI, '/')[last()]"/></p>
	
								<p>
									XML-Original: <xsl:value-of select="tokenize($DocumentURI, '/')[last()]"/><br/>
									XML-Vergleich: <xsl:value-of select="$VergleichsDateiName"/>
								</p>
		
							</div>
						</xsl:when>
						<xsl:when test="name(/*) ='gc:CodeList'">
							<div id="Inhalt">
							
										
								<xsl:call-template name="codelistendetails"/>
	
								<p>Erstellt am: <xsl:value-of select="format-date(fn:current-date(),'[D01].[M01].[Y0001]')"/> um <xsl:value-of select="format-time(fn:current-time(),'[H01]:[m01]')"/> Uhr</p>
								<p>XSLT: <xsl:choose><xsl:when test="empty($StyleSheetURI)"><xsl:value-of select="$StyleSheetName"/></xsl:when><xsl:otherwise><xsl:call-template name="fileName"><xsl:with-param name="path" select="$StyleSheetURI"/></xsl:call-template></xsl:otherwise></xsl:choose></p>
								<p>
									<xsl:if test="not(empty($DocumentURI))">
										XML-Original: <xsl:call-template name="fileName"><xsl:with-param name="path" select="$DocumentURI"/></xsl:call-template><br/>
									</xsl:if>
									XML-Vergleich: <xsl:value-of select="$VergleichsDateiName"/>
								</p>
		
							</div>
						</xsl:when>
						<xsl:otherwise>
							<p>Unbekanntes Dateiformat</p>

								<p>Erstellt am: <xsl:value-of select="format-date(fn:current-date(),'[D01].[M01].[Y0001]')"/> um <xsl:value-of select="format-time(fn:current-time(),'[H01]:[m01]')"/> Uhr</p>
								<p>XSLT: <xsl:choose><xsl:when test="empty($StyleSheetURI)"><xsl:value-of select="$StyleSheetName"/></xsl:when><xsl:otherwise><xsl:call-template name="fileName"><xsl:with-param name="path" select="$StyleSheetURI"/></xsl:call-template></xsl:otherwise></xsl:choose></p>
								<p>
									<xsl:if test="not(empty($DocumentURI))">
										XML-Original: <xsl:call-template name="fileName"><xsl:with-param name="path" select="$DocumentURI"/></xsl:call-template><br/>
									</xsl:if>
									XML-Vergleich: <xsl:value-of select="$VergleichsDateiName"/>
								</p>

						</xsl:otherwise>
					</xsl:choose>

				</body>
			</html>
	
	</xsl:template>

	<!-- ############################################################################################################# -->

	<xsl:template name="datenschemaeinzeln">

		<xsl:if test="$DebugMode = '1' or $DebugMode = '2' or $DebugMode = '3' or $DebugMode = '4'">
			<xsl:message>
				++++ datenschemaeinzeln ++++
			</xsl:message>
		</xsl:if>

					<h2>
						<a name="StammDetails"/>Vergleich von Datenschema <xsl:value-of select="$NameSDSA"/> mit Datenschema <xsl:value-of select="$NameSDSO"/>
					</h2>
					<table style="page-break-after:always">
						<thead>
							<tr>
								<th width="10%">Metadatum</th>
								<th width="45%">Inhalt Datenschema <xsl:value-of select="$NameSDSA"/></th>
								<th width="45%">Inhalt Datenschema <xsl:value-of select="$NameSDSO"/></th>
							</tr>
						</thead>
						<tbody>

							<xsl:call-template name="datenschemadetails">
								<xsl:with-param name="Element" select="/*/xdf3:stammdatenschema"/>
								<xsl:with-param name="VergleichsElement" select="$VergleichsDaten/*/xdf3:stammdatenschema"/>
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
						<a name="StammDetails"/>Vergleich von Datenfeldgruppe <xsl:value-of select="$NameSDSA"/> mit Datenfeldgruppe <xsl:value-of select="$NameSDSO"/>
					</h2>
					<table style="page-break-after:always">
						<thead>
							<tr>
								<th width="10%">Metadatum</th>
								<th width="45%">Inhalt Datenfeldgruppe <xsl:value-of select="$NameSDSA"/></th>
								<th width="45%">Inhalt Datenfeldgruppe <xsl:value-of select="$NameSDSO"/></th>
							</tr>
						</thead>
						<tbody>

							<xsl:call-template name="datenfeldgruppedetails">
								<xsl:with-param name="Element" select="/*/xdf3:datenfeldgruppe"/>
								<xsl:with-param name="VergleichsElement" select="$VergleichsDaten/*/xdf3:datenfeldgruppe"/>
							</xsl:call-template>
		
						</tbody>
					</table>
	</xsl:template>

	<!-- ############################################################################################################# -->

	<xsl:template name="datenschemadetails">
		<xsl:param name="Element"/>
		<xsl:param name="VergleichsElement"/>

		<xsl:if test="$DebugMode = '2' or $DebugMode = '3' or $DebugMode = '4'">
			<xsl:message>
				++++++++ datenschemadetails ++++++++
			</xsl:message>
		</xsl:if>
		<xsl:if test="$DebugMode = '3' or $DebugMode = '4'">
			<xsl:message>
				-------- <xsl:value-of select="$Element/xdf3:identifikation/xdf3:id"/><xsl:if test="$Element/xdf3:identifikation/xdf3:version">V<xsl:value-of select="$Element/xdf3:identifikation/xdf3:version"/></xsl:if> --------
			</xsl:message>
		</xsl:if>
		
										<tr>
											<td>
												<xsl:element name="a">
													<xsl:attribute name="name"><xsl:value-of select="$Element/xdf3:identifikation/xdf3:id"/><xsl:if test="$Element/xdf3:identifikation/xdf3:version">V<xsl:value-of select="$Element/xdf3:identifikation/xdf3:version"/></xsl:if></xsl:attribute>
												</xsl:element>
												<xsl:element name="a">
													<xsl:attribute name="name">X<xsl:value-of select="$VergleichsElement/xdf3:identifikation/xdf3:id"/><xsl:if test="$VergleichsElement/xdf3:identifikation/xdf3:version">V<xsl:value-of select="$VergleichsElement/xdf3:identifikation/xdf3:version"/></xsl:if></xsl:attribute>
												</xsl:element>
												ID
											</td>
											<td>
												<xsl:value-of select="$Element/xdf3:identifikation/xdf3:id"/>
												<xsl:if test="$ToolAufruf = '1'">
													&#160;&#160;
													<xsl:element name="a">
														<xsl:attribute name="href"><xsl:value-of select="$ToolPfadPrefix"/><xsl:value-of select="$Element/xdf3:identifikation/xdf3:id"/><xsl:if test="$Element/xdf3:identifikation/xdf3:version">V<xsl:value-of select="$Element/xdf3:identifikation/xdf3:version"/></xsl:if><xsl:value-of select="$ToolPfadPostfix"/></xsl:attribute>
														<xsl:attribute name="target">FIMTool</xsl:attribute>
														<xsl:attribute name="title">Springe in den Datenfeldeditor (man muss vorher angemeldet sein).</xsl:attribute>
														&#8658;
													</xsl:element>
												</xsl:if>
											</td>
											<td>
												<xsl:value-of select="$VergleichsElement/xdf3:identifikation/xdf3:id"/>
												<xsl:if test="$ToolAufruf = '1'">
													&#160;&#160;
													<xsl:element name="a">
														<xsl:attribute name="href"><xsl:value-of select="$ToolPfadPrefix"/><xsl:value-of select="$VergleichsElement/xdf3:identifikation/xdf3:id"/><xsl:if test="$VergleichsElement/xdf3:identifikation/xdf3:version">V<xsl:value-of select="$VergleichsElement/xdf3:identifikation/xdf3:version"/></xsl:if><xsl:value-of select="$ToolPfadPostfix"/></xsl:attribute>
														<xsl:attribute name="target">FIMTool</xsl:attribute>
														<xsl:attribute name="title">Springe in den Datenfeldeditor (man muss vorher angemeldet sein).</xsl:attribute>
														&#8658;
													</xsl:element>
												</xsl:if>
											</td>
										</tr>
										<tr>
											<td>Version <xsl:if test="fn:not(empty($VergleichsElement)) and (fn:not((empty($Element/xdf3:identifikation/xdf3:version) and empty($VergleichsElement/xdf3:identifikation/xdf3:version)) or ($Element/xdf3:identifikation/xdf3:version = $VergleichsElement/xdf3:identifikation/xdf3:version)))">##</xsl:if></td>
											<td>
												<xsl:value-of select="$Element/xdf3:identifikation/xdf3:version"/>
											</td>
											<xsl:choose>
												<xsl:when test="empty($VergleichsElement) or (empty($Element/xdf3:identifikation/xdf3:version) and empty($VergleichsElement/xdf3:identifikation/xdf3:version)) or ($Element/xdf3:identifikation/xdf3:version = $VergleichsElement/xdf3:identifikation/xdf3:version)">
													<td class="Gleich">
														<xsl:value-of select="$VergleichsElement/xdf3:identifikation/xdf3:version"/>
													</td>
												</xsl:when>
												<xsl:otherwise>
													<td class="Ungleich AenderungBaukasten">
														<xsl:value-of select="$VergleichsElement/xdf3:identifikation/xdf3:version"/>
													</td>
												</xsl:otherwise>
											</xsl:choose>
										</tr>
										<tr>
											<td>Versionshinweis <xsl:if test="fn:not((empty($Element/xdf3:versionshinweis) and empty($VergleichsElement/xdf3:versionshinweis)) or ($Element/xdf3:versionshinweis = $VergleichsElement/xdf3:versionshinweis))">##</xsl:if></td>
											<td>
												<xsl:value-of select="fn:replace($Element/xdf3:versionshinweis,'\n','&lt;br/&gt;')" disable-output-escaping="yes"/>
											</td>
											<xsl:choose>
												<xsl:when test="(empty($Element/xdf3:versionshinweis) and empty($VergleichsElement/xdf3:versionshinweis)) or ($Element/xdf3:versionshinweis = $VergleichsElement/xdf3:versionshinweis)">
													<td class="Gleich">
														<xsl:value-of select="fn:replace($VergleichsElement/xdf3:versionshinweis,'\n','&lt;br/&gt;')" disable-output-escaping="yes"/>
													</td>
												</xsl:when>
												<xsl:otherwise>
													<td class="Ungleich">
														<xsl:value-of select="fn:replace($VergleichsElement/xdf3:versionshinweis,'\n','&lt;br/&gt;')" disable-output-escaping="yes"/>
													</td>
												</xsl:otherwise>
											</xsl:choose>
										</tr>
										<tr>
											<td>Name <xsl:if test="fn:not((empty($Element/xdf3:name) and empty($VergleichsElement/xdf3:name)) or ($Element/xdf3:name = $VergleichsElement/xdf3:name))">##</xsl:if></td>
											<xsl:choose>
												<xsl:when test="empty($Element/xdf3:name/text())">
												<td class="SDSName">
												</td>
												</xsl:when>
												<xsl:otherwise>
													<td class="ElementName">
														<xsl:value-of select="$Element/xdf3:name"/>
													</td>
												</xsl:otherwise>
											</xsl:choose>
											<xsl:choose>
												<xsl:when test="(empty($Element/xdf3:name) and empty($VergleichsElement/xdf3:name)) or ($Element/xdf3:name = $VergleichsElement/xdf3:name)">
													<td class="ElementName Gleich">
														<xsl:value-of select="$VergleichsElement/xdf3:name"/>
													</td>
												</xsl:when>
												<xsl:otherwise>
													<td class="ElementName Ungleich">
														<xsl:value-of select="$VergleichsElement/xdf3:name"/>
													</td>
												</xsl:otherwise>
											</xsl:choose>
										</tr>
										<xsl:if test="count($Element/xdf3:stichwort) = 0 and count($VergleichsElement/xdf3:stichwort) = 0">
											<tr>
												<td>Stichwörter</td>
												<td></td>
												<td></td>
											</tr>
										</xsl:if>
										<xsl:for-each select="$Element/xdf3:stichwort">
											<xsl:variable name="stichwort" select="./text()"/>
											<xsl:variable name="uri"><xsl:value-of select="./@uri"/></xsl:variable>
											<xsl:variable name="VergleichsStichwort" select="$VergleichsElement/xdf3:stichwort[./text() = $stichwort]"/>
											<xsl:variable name="VergleichsURI"><xsl:value-of select="$VergleichsElement/xdf3:stichwort[./text() = $stichwort]/@uri"/></xsl:variable>
											
											<tr>
												<xsl:choose>
													<xsl:when test="fn:position() = 1"><td>Stichwörter</td></xsl:when>
													<xsl:otherwise><td></td></xsl:otherwise>
												</xsl:choose>
												<td>
													<ul class="hangrun">
														<li>
															<xsl:value-of select="."/><xsl:if test="@uri and ./@uri != ''"> (<xsl:value-of select="./@uri"/>)</xsl:if>
														</li>
													</ul>
												</td>
												<xsl:choose>
													<xsl:when test="empty($VergleichsStichwort)">
														<td class="Ungleich">
															<ul class="hangrun">
																<li><i>Nicht vorhanden</i> ##</li>
															</ul>
														</td>
													</xsl:when>
													<xsl:when test="$uri != $VergleichsURI">
														<td class="Ungleich">
															<ul class="hangrun">
																<li>
																	<xsl:value-of select="$VergleichsElement/xdf3:stichwort[./text() = $stichwort]/text()"/><xsl:if test="$VergleichsElement/xdf3:stichwort[./text() = $stichwort]/@uri and $VergleichsElement/xdf3:stichwort[./text() = $stichwort]/@uri != ''"> (<xsl:value-of select="$VergleichsElement/xdf3:stichwort[./text() = $stichwort]/@uri"/>)</xsl:if> ##
																</li>
															</ul>
														</td>
													</xsl:when>
													<xsl:otherwise>
														<td class="Gleich">
															<ul class="hangrun">
																<li>
																	<xsl:value-of select="$VergleichsElement/xdf3:stichwort[./text() = $stichwort]/text()"/><xsl:if test="$VergleichsElement/xdf3:stichwort[./text() = $stichwort]/@uri and $VergleichsElement/xdf3:stichwort[./text() = $stichwort]/@uri != ''"> (<xsl:value-of select="$VergleichsElement/xdf3:stichwort[./text() = $stichwort]/@uri"/>)</xsl:if>
																</li>
															</ul>
														</td>
													</xsl:otherwise>
												</xsl:choose>
											</tr>
										</xsl:for-each>
										<xsl:for-each select="$VergleichsElement/xdf3:stichwort">
											<xsl:variable name="stichwort" select="./text()"/>
											<xsl:variable name="uri"><xsl:value-of select="./@link"/></xsl:variable>
											<xsl:variable name="OriginalStichwort" select="$Element/xdf3:stichwort[./text() = $stichwort]"/>
											<xsl:variable name="OriginalURI"><xsl:value-of select="$Element/xdf3:stichwort[./text() = $stichwort]/@link"/></xsl:variable>
											
											<xsl:if test="not($Element/xdf3:stichwort[./text() = $stichwort])">
												<tr>
													<xsl:choose>
														<xsl:when test="count($Element/xdf3:stichwort) = 0 and fn:position() = 1"><td>Stichwörter</td></xsl:when>
														<xsl:otherwise><td></td></xsl:otherwise>
													</xsl:choose>
													<td>
														<ul class="hangrun">
															<li>
																<i>Nicht vorhanden</i>
															</li>
														</ul>
													</td>
													<td class="Ungleich">
														<ul class="hangrun">
															<li>
																<xsl:value-of select="./text()"/><xsl:if test="./@uri and ./@uri != ''"> (<xsl:value-of select="./@uri"/>)</xsl:if> ##
															</li>
														</ul>

													</td>
												</tr>
											</xsl:if>
										</xsl:for-each>
										<tr>
											<td>Bezeichnung <xsl:if test="fn:not((empty($Element/xdf3:bezeichnung) and empty($VergleichsElement/xdf3:bezeichnung)) or ($Element/xdf3:bezeichnung = $VergleichsElement/xdf3:bezeichnung))">##</xsl:if></td>
											<td>
												<xsl:value-of select="$Element/xdf3:bezeichnung"/>
											</td>
											<xsl:choose>
												<xsl:when test="(empty($Element/xdf3:bezeichnung) and empty($VergleichsElement/xdf3:bezeichnung)) or ($Element/xdf3:bezeichnung = $VergleichsElement/xdf3:bezeichnung)">
													<td class="Gleich">
														<xsl:value-of select="$VergleichsElement/xdf3:bezeichnung"/>
													</td>
												</xsl:when>
												<xsl:otherwise>
													<td class="Ungleich">
														<xsl:value-of select="$VergleichsElement/xdf3:bezeichnung"/>
													</td>
												</xsl:otherwise>
											</xsl:choose>
										</tr>
										<tr>
											<td>Hilfetext <xsl:if test="fn:not((empty($Element/xdf3:hilfetext) and empty($VergleichsElement/xdf3:hilfetext)) or ($Element/xdf3:hilfetext = $VergleichsElement/xdf3:hilfetext))">##</xsl:if></td>
											<td>
												<xsl:value-of select="fn:replace($Element/xdf3:hilfetext,'\n','&lt;br/&gt;')" disable-output-escaping="yes"/>
											</td>
											<xsl:choose>
												<xsl:when test="(empty($Element/xdf3:hilfetext) and empty($VergleichsElement/xdf3:hilfetext)) or ($Element/xdf3:hilfetext = $VergleichsElement/xdf3:hilfetext)">
													<td class="Gleich">
														<xsl:value-of select="fn:replace($VergleichsElement/xdf3:hilfetext,'\n','&lt;br/&gt;')" disable-output-escaping="yes"/>
													</td>
												</xsl:when>
												<xsl:otherwise>
													<td class="Ungleich">
														<xsl:value-of select="fn:replace($VergleichsElement/xdf3:hilfetext,'\n','&lt;br/&gt;')" disable-output-escaping="yes"/>
													</td>
												</xsl:otherwise>
											</xsl:choose>
										</tr>
										<xsl:if test="count($Element/xdf3:bezug) = 0 and count($VergleichsElement/xdf3:bezug) = 0">
											<tr>
												<td>Handlungsgrundlagen</td>
												<td></td>
												<td></td>
											</tr>
										</xsl:if>
										<xsl:for-each select="$Element/xdf3:bezug">
											<xsl:variable name="bezug" select="./text()"/>
											<xsl:variable name="link"><xsl:value-of select="./@link"/></xsl:variable>
											<xsl:variable name="VergleichsBezug" select="$VergleichsElement/xdf3:bezug[./text() = $bezug]"/>
											<xsl:variable name="VergleichsLink"><xsl:value-of select="$VergleichsElement/xdf3:bezug[./text() = $bezug]/@link"/></xsl:variable>
											
											<tr>
												<xsl:choose>
													<xsl:when test="fn:position() = 1"><td>Handlungsgrundlagen</td></xsl:when>
													<xsl:otherwise><td></td></xsl:otherwise>
												</xsl:choose>
												<td>
													<ul class="hangrun">
														<li>
															<xsl:value-of select="."/>
															<xsl:choose>
																<xsl:when test="not(@link) or ./@link=''"></xsl:when>
																<xsl:when test="$HandlungsgrundlagenLinks = '1'">
																	- <xsl:element name="a">
																		<xsl:attribute name="href"><xsl:value-of select="./@link"/></xsl:attribute>
																		<xsl:attribute name="target">Handlungsgrundlage</xsl:attribute>
																		<xsl:attribute name="title">Springe zum Text der Handlungsgrundlage.</xsl:attribute>
																		<xsl:value-of select="./@link"/>
																	</xsl:element>
																</xsl:when>
																<xsl:otherwise>
																	- <xsl:value-of select="./@link"/>
																</xsl:otherwise>
															</xsl:choose>
														</li>
													</ul>
												</td>
												<xsl:choose>
													<xsl:when test="empty($VergleichsBezug)">
														<td class="Ungleich">
															<ul class="hangrun">
																<li><i>Nicht vorhanden</i> ##</li>
															</ul>
														</td>
													</xsl:when>
													<xsl:when test="$link != $VergleichsLink">
														<td class="Ungleich">
															<ul class="hangrun">
																<li>
																	<xsl:value-of select="$VergleichsElement/xdf3:bezug[./text() = $bezug]/text()"/>
																	<xsl:choose>
																		<xsl:when test="not($VergleichsElement/xdf3:bezug[./text() = $bezug]/@link) or $VergleichsElement/xdf3:bezug[./text() = $bezug]/@link=''"></xsl:when>
																		<xsl:when test="$HandlungsgrundlagenLinks = '1'">
																			- <xsl:element name="a">
																				<xsl:attribute name="href"><xsl:value-of select="./@link"/></xsl:attribute>
																				<xsl:attribute name="target">Handlungsgrundlage</xsl:attribute>
																				<xsl:attribute name="title">Springe zum Text der Handlungsgrundlage.</xsl:attribute>
																				<xsl:value-of select="$VergleichsElement/xdf3:bezug[./text() = $bezug]/@link"/>
																			</xsl:element> ##
																		</xsl:when>
																		<xsl:otherwise>
																			- <xsl:value-of select="$VergleichsElement/xdf3:bezug[./text() = $bezug]/@link"/> ##
																		</xsl:otherwise>
																	</xsl:choose>
																</li>
															</ul>
														</td>
													</xsl:when>
													<xsl:otherwise>
														<td class="Gleich">
															<ul class="hangrun">
																<li>
																	<xsl:value-of select="$VergleichsElement/xdf3:bezug[./text() = $bezug]/text()"/>
																	<xsl:choose>
																		<xsl:when test="not($VergleichsElement/xdf3:bezug[./text() = $bezug]/@link) or $VergleichsElement/xdf3:bezug[./text() = $bezug]/@link=''"></xsl:when>
																		<xsl:when test="$HandlungsgrundlagenLinks = '1'">
																			- <xsl:element name="a">
																				<xsl:attribute name="href"><xsl:value-of select="./@link"/></xsl:attribute>
																				<xsl:attribute name="target">Handlungsgrundlage</xsl:attribute>
																				<xsl:attribute name="title">Springe zum Text der Handlungsgrundlage.</xsl:attribute>
																				<xsl:value-of select="$VergleichsElement/xdf3:bezug[./text() = $bezug]/@link"/>
																			</xsl:element>
																		</xsl:when>
																		<xsl:otherwise>
																			- <xsl:value-of select="$VergleichsElement/xdf3:bezug[./text() = $bezug]/@link"/>
																		</xsl:otherwise>
																	</xsl:choose>
																</li>
															</ul>
														</td>
													</xsl:otherwise>
												</xsl:choose>
											</tr>
										</xsl:for-each>
										<xsl:for-each select="$VergleichsElement/xdf3:bezug">
											<xsl:variable name="bezug" select="./text()"/>
											<xsl:variable name="link"><xsl:value-of select="./@link"/></xsl:variable>
											<xsl:variable name="OriginalBezug" select="$Element/xdf3:bezug[./text() = $bezug]"/>
											<xsl:variable name="OriginalLink"><xsl:value-of select="$Element/xdf3:bezug[./text() = $bezug]/@link"/></xsl:variable>
											
											<xsl:if test="not($Element/xdf3:bezug[./text() = $bezug])">
												<tr>
													<xsl:choose>
														<xsl:when test="count($Element/xdf3:bezug) = 0 and fn:position() = 1"><td>Handlungsgrundlagen</td></xsl:when>
														<xsl:otherwise><td></td></xsl:otherwise>
													</xsl:choose>
													<td>
														<ul class="hangrun">
															<li>
																<i>Nicht vorhanden</i>
															</li>
														</ul>
													</td>
													<td class="Ungleich">
														<ul class="hangrun">
															<li>
																<xsl:value-of select="./text()"/><xsl:if test="not(./@link) or ./@link=''"> ##</xsl:if>
																<xsl:choose>
																	<xsl:when test="not(./@link) or ./@link=''"></xsl:when>
																	<xsl:when test="$HandlungsgrundlagenLinks = '1'">
																		- <xsl:element name="a">
																			<xsl:attribute name="href"><xsl:value-of select="./@link"/></xsl:attribute>
																			<xsl:attribute name="target">Handlungsgrundlage</xsl:attribute>
																			<xsl:attribute name="title">Springe zum Text der Handlungsgrundlage.</xsl:attribute>
																			<xsl:value-of select="./@link"/>
																		</xsl:element> ##
																	</xsl:when>
																	<xsl:otherwise>
																		- <xsl:value-of select="./@link"/> ##
																	</xsl:otherwise>
																</xsl:choose>
															</li>
														</ul>

													</td>
												</tr>
											</xsl:if>
										</xsl:for-each>
										<tr>
											<td>Beschreibung <xsl:if test="fn:not((empty($Element/xdf3:beschreibung) and empty($VergleichsElement/xdf3:beschreibung)) or ($Element/xdf3:beschreibung = $VergleichsElement/xdf3:beschreibung))">##</xsl:if></td>
											<td>
												<xsl:value-of select="fn:replace($Element/xdf3:beschreibung,'\n','&lt;br/&gt;')" disable-output-escaping="yes"/>
											</td>
											<xsl:choose>
												<xsl:when test="(empty($Element/xdf3:beschreibung) and empty($VergleichsElement/xdf3:beschreibung)) or ($Element/xdf3:beschreibung = $VergleichsElement/xdf3:beschreibung)">
													<td class="Gleich">
														<xsl:value-of select="fn:replace($VergleichsElement/xdf3:beschreibung,'\n','&lt;br/&gt;')" disable-output-escaping="yes"/>
													</td>
												</xsl:when>
												<xsl:otherwise>
													<td class="Ungleich">
														<xsl:value-of select="fn:replace($VergleichsElement/xdf3:beschreibung,'\n','&lt;br/&gt;')" disable-output-escaping="yes"/>
													</td>
												</xsl:otherwise>
											</xsl:choose>
										</tr>
										<tr>
											<td>Definition <xsl:if test="fn:not((empty($Element/xdf3:definition) and empty($VergleichsElement/xdf3:definition)) or ($Element/xdf3:definition = $VergleichsElement/xdf3:definition))">##</xsl:if></td>
											<td>
												<xsl:value-of select="fn:replace($Element/xdf3:definition,'\n','&lt;br/&gt;')" disable-output-escaping="yes"/>
											</td>
											<xsl:choose>
												<xsl:when test="(empty($Element/xdf3:definition) and empty($VergleichsElement/xdf3:definition)) or ($Element/xdf3:definition = $VergleichsElement/xdf3:definition)">
													<td class="Gleich">
														<xsl:value-of select="fn:replace($VergleichsElement/xdf3:definition,'\n','&lt;br/&gt;')" disable-output-escaping="yes"/>
													</td>
												</xsl:when>
												<xsl:otherwise>
													<td class="Ungleich">
														<xsl:value-of select="fn:replace($VergleichsElement/xdf3:definition,'\n','&lt;br/&gt;')" disable-output-escaping="yes"/>
													</td>
												</xsl:otherwise>
											</xsl:choose>
										</tr>
										<tr>
											<td>Änderbarkeit Struktur <xsl:if test="fn:not((empty($Element/xdf3:ableitungsmodifikationenStruktur) and empty($VergleichsElement/xdf3:ableitungsmodifikationenStruktur)) or ($Element/xdf3:ableitungsmodifikationenStruktur = $VergleichsElement/xdf3:ableitungsmodifikationenStruktur))">##</xsl:if></td>
											<td>
												<xsl:apply-templates select="$Element/xdf3:ableitungsmodifikationenStruktur"/>
											</td>
											<xsl:choose>
												<xsl:when test="(empty($Element/xdf3:ableitungsmodifikationenStruktur) and empty($VergleichsElement/xdf3:ableitungsmodifikationenStruktur)) or ($Element/xdf3:ableitungsmodifikationenStruktur = $VergleichsElement/xdf3:ableitungsmodifikationenStruktur)">
													<td class="Gleich">
														<xsl:apply-templates select="$VergleichsElement/xdf3:ableitungsmodifikationenStruktur"/>
													</td>
												</xsl:when>
												<xsl:otherwise>
													<td class="Ungleich">
														<xsl:apply-templates select="$VergleichsElement/xdf3:ableitungsmodifikationenStruktur"/>
													</td>
												</xsl:otherwise>
											</xsl:choose>
										</tr>
										<tr>
											<td>Änderbarkeit Repräsentation <xsl:if test="fn:not((empty($Element/xdf3:ableitungsmodifikationenRepraesentation) and empty($VergleichsElement/xdf3:ableitungsmodifikationenRepraesentation)) or ($Element/xdf3:ableitungsmodifikationenRepraesentation = $VergleichsElement/xdf3:ableitungsmodifikationenRepraesentation))">##</xsl:if></td>
											<td>
												<xsl:apply-templates select="$Element/xdf3:ableitungsmodifikationenRepraesentation"/>
											</td>
											<xsl:choose>
												<xsl:when test="(empty($Element/xdf3:ableitungsmodifikationenRepraesentation) and empty($VergleichsElement/xdf3:ableitungsmodifikationenRepraesentation)) or ($Element/xdf3:ableitungsmodifikationenRepraesentation = $VergleichsElement/xdf3:ableitungsmodifikationenRepraesentation)">
													<td class="Gleich">
														<xsl:apply-templates select="$VergleichsElement/xdf3:ableitungsmodifikationenRepraesentation"/>
													</td>
												</xsl:when>
												<xsl:otherwise>
													<td class="Ungleich">
														<xsl:apply-templates select="$VergleichsElement/xdf3:ableitungsmodifikationenRepraesentation"/>
													</td>
												</xsl:otherwise>
											</xsl:choose>
										</tr>
										<tr>
											<td>Gültig ab <xsl:if test="fn:not((empty($Element/xdf3:gueltigAb) and empty($VergleichsElement/xdf3:gueltigAb)) or ($Element/xdf3:gueltigAb = $VergleichsElement/xdf3:gueltigAb))">##</xsl:if></td>
											<td>
												<xsl:value-of select="fn:format-date($Element/xdf3:gueltigAb,'[D01].[M01].[Y0001]')"/>
											</td>
											<xsl:choose>
												<xsl:when test="(empty($Element/xdf3:gueltigAb) and empty($VergleichsElement/xdf3:gueltigAb)) or ($Element/xdf3:gueltigAb = $VergleichsElement/xdf3:gueltigAb)">
													<td class="Gleich">
														<xsl:value-of select="fn:format-date($VergleichsElement/xdf3:gueltigAb,'[D01].[M01].[Y0001]')"/>
													</td>
												</xsl:when>
												<xsl:otherwise>
													<td class="Ungleich">
														<xsl:value-of select="fn:format-date($VergleichsElement/xdf3:gueltigAb,'[D01].[M01].[Y0001]')"/>
													</td>
												</xsl:otherwise>
											</xsl:choose>
										</tr>
										<tr>
											<td>Gültig bis <xsl:if test="fn:not((empty($Element/xdf3:gueltigBis) and empty($VergleichsElement/xdf3:gueltigBis)) or ($Element/xdf3:gueltigBis = $VergleichsElement/xdf3:gueltigBis))">##</xsl:if></td>
											<td>
												<xsl:value-of select="fn:format-date($Element/xdf3:gueltigBis,'[D01].[M01].[Y0001]')"/>
											</td>
											<xsl:choose>
												<xsl:when test="(empty($Element/xdf3:gueltigBis) and empty($VergleichsElement/xdf3:gueltigBis)) or ($Element/xdf3:gueltigBis = $VergleichsElement/xdf3:gueltigBis)">
													<td class="Gleich">
														<xsl:value-of select="fn:format-date($VergleichsElement/xdf3:gueltigBis,'[D01].[M01].[Y0001]')"/>
													</td>
												</xsl:when>
												<xsl:otherwise>
													<td class="Ungleich">
														<xsl:value-of select="fn:format-date($VergleichsElement/xdf3:gueltigBis,'[D01].[M01].[Y0001]')"/>
													</td>
												</xsl:otherwise>
											</xsl:choose>
										</tr>
										<tr>
											<td>Fachlicher Ersteller <xsl:if test="fn:not((empty($Element/xdf3:statusGesetztDurch) and empty($VergleichsElement/xdf3:statusGesetztDurch)) or ($Element/xdf3:statusGesetztDurch = $VergleichsElement/xdf3:statusGesetztDurch))">##</xsl:if></td>
											<td>
												<xsl:value-of select="$Element/xdf3:statusGesetztDurch"/>
											</td>
											<xsl:choose>
												<xsl:when test="(empty($Element/xdf3:statusGesetztDurch) and empty($VergleichsElement/xdf3:statusGesetztDurch)) or ($Element/xdf3:statusGesetztDurch = $VergleichsElement/xdf3:statusGesetztDurch)">
													<td class="Gleich">
														<xsl:value-of select="$VergleichsElement/xdf3:statusGesetztDurch"/>
													</td>
												</xsl:when>
												<xsl:otherwise>
													<td class="Ungleich">
														<xsl:value-of select="$VergleichsElement/xdf3:statusGesetztDurch"/>
													</td>
												</xsl:otherwise>
											</xsl:choose>
										</tr>
										<tr>
											<td>Status <xsl:if test="fn:not((empty($Element/xdf3:freigabestatus) and empty($VergleichsElement/xdf3:freigabestatus)) or ($Element/xdf3:freigabestatus = $VergleichsElement/xdf3:freigabestatus))">##</xsl:if></td>
											<td>
												<xsl:apply-templates select="$Element/xdf3:freigabestatus"/>
											</td>
											<xsl:choose>
												<xsl:when test="(empty($Element/xdf3:freigabestatus) and empty($VergleichsElement/xdf3:freigabestatus)) or ($Element/xdf3:freigabestatus = $VergleichsElement/xdf3:freigabestatus)">
													<td class="Gleich">
														<xsl:apply-templates select="$VergleichsElement/xdf3:freigabestatus"/>
													</td>
												</xsl:when>
												<xsl:otherwise>
													<td class="Ungleich">
														<xsl:apply-templates select="$VergleichsElement/xdf3:freigabestatus"/>
													</td>
												</xsl:otherwise>
											</xsl:choose>
										</tr>
										<tr>
											<td>Status gesetzt am <xsl:if test="fn:not((empty($Element/xdf3:statusGesetztAm) and empty($VergleichsElement/xdf3:statusGesetztAm)) or ($Element/xdf3:statusGesetztAm = $VergleichsElement/xdf3:statusGesetztAm))">##</xsl:if></td>
											<td>
												<xsl:value-of select="fn:format-date($Element/xdf3:statusGesetztAm,'[D01].[M01].[Y0001]')"/>
											</td>
											<xsl:choose>
												<xsl:when test="(empty($Element/xdf3:statusGesetztAm) and empty($VergleichsElement/xdf3:statusGesetztAm)) or ($Element/xdf3:statusGesetztAm = $VergleichsElement/xdf3:statusGesetztAm)">
													<td class="Gleich">
														<xsl:value-of select="fn:format-date($VergleichsElement/xdf3:statusGesetztAm,'[D01].[M01].[Y0001]')"/>
													</td>
												</xsl:when>
												<xsl:otherwise>
													<td class="Ungleich">
														<xsl:value-of select="fn:format-date($VergleichsElement/xdf3:statusGesetztAm,'[D01].[M01].[Y0001]')"/>
													</td>
												</xsl:otherwise>
											</xsl:choose>
										</tr>
										<tr>
											<td>Veröffentlichungsdatum <xsl:if test="fn:not((empty($Element/xdf3:veroeffentlichungsdatum) and empty($VergleichsElement/xdf3:veroeffentlichungsdatum)) or ($Element/xdf3:veroeffentlichungsdatum = $VergleichsElement/xdf3:veroeffentlichungsdatum))">##</xsl:if></td>
											<td>
												<xsl:value-of select="fn:format-date($Element/xdf3:veroeffentlichungsdatum,'[D01].[M01].[Y0001]')"/>
											</td>
											<xsl:choose>
												<xsl:when test="(empty($Element/xdf3:veroeffentlichungsdatum) and empty($VergleichsElement/xdf3:veroeffentlichungsdatum)) or ($Element/xdf3:veroeffentlichungsdatum = $VergleichsElement/xdf3:veroeffentlichungsdatum)">
													<td class="Gleich">
														<xsl:value-of select="fn:format-date($VergleichsElement/xdf3:veroeffentlichungsdatum,'[D01].[M01].[Y0001]')"/>
													</td>
												</xsl:when>
												<xsl:otherwise>
													<td class="Ungleich">
														<xsl:value-of select="fn:format-date($VergleichsElement/xdf3:veroeffentlichungsdatum,'[D01].[M01].[Y0001]')"/>
													</td>
												</xsl:otherwise>
											</xsl:choose>
										</tr>
										<tr>
											<td>Letzte Änderung <xsl:if test="fn:not((empty($Element/xdf3:letzteAenderung) and empty($VergleichsElement/xdf3:letzteAenderung)) or ($Element/xdf3:letzteAenderung = $VergleichsElement/xdf3:letzteAenderung))">##</xsl:if></td>
											<td>
												<xsl:value-of select="fn:format-dateTime($Element/xdf3:letzteAenderung,'[D01].[M01].[Y0001] um [H01]:[m01] Uhr')"/>
											</td>
											<xsl:choose>
												<xsl:when test="(empty($Element/xdf3:letzteAenderung) and empty($VergleichsElement/xdf3:letzteAenderung)) or ($Element/xdf3:letzteAenderung = $VergleichsElement/xdf3:letzteAenderung)">
													<td class="Gleich">
														<xsl:value-of select="fn:format-dateTime($VergleichsElement/xdf3:letzteAenderung,'[D01].[M01].[Y0001] um [H01]:[m01] Uhr')"/>
													</td>
												</xsl:when>
												<xsl:otherwise>
													<td class="Ungleich">
														<xsl:value-of select="fn:format-dateTime($VergleichsElement/xdf3:letzteAenderung,'[D01].[M01].[Y0001] um [H01]:[m01] Uhr')"/>
													</td>
												</xsl:otherwise>
											</xsl:choose>
										</tr>
										<tr>
											<td colspan="3"><h2/></td>
										</tr>
										<tr>
											<td><b>Dokumentsteckbrief</b> <xsl:if test="fn:not((empty($Element/xdf3:dokumentsteckbrief/xdf3:id) and empty($VergleichsElement/xdf3:dokumentsteckbrief/xdf3:id)) or ($Element/xdf3:dokumentsteckbrief/xdf3:id = $VergleichsElement/xdf3:dokumentsteckbrief/xdf3:id))">##</xsl:if></td>
											<td>
												<xsl:value-of select="$Element/xdf3:dokumentsteckbrief/xdf3:id"/>
											</td>
											<xsl:choose>
												<xsl:when test="(empty($Element/xdf3:dokumentsteckbrief/xdf3:id) and empty($VergleichsElement/xdf3:dokumentsteckbrief/xdf3:id)) or ($Element/xdf3:dokumentsteckbrief/xdf3:id = $VergleichsElement/xdf3:dokumentsteckbrief/xdf3:id)">
													<td class="Gleich">
														<xsl:value-of select="$VergleichsElement/xdf3:dokumentsteckbrief/xdf3:id"/>
													</td>
												</xsl:when>
												<xsl:otherwise>
													<td class="Ungleich">
														<xsl:value-of select="$VergleichsElement/xdf3:dokumentsteckbrief/xdf3:id"/>
													</td>
												</xsl:otherwise>
											</xsl:choose>
										</tr>
										<tr>
											<td colspan="3"><h2/></td>
										</tr>
										<tr>
											<xsl:variable name="AnzahlUnterelemente" select="count($Element/xdf3:struktur)"/>

											<td>
												<b>Unterelemente</b>
											</td>
											<xsl:choose>
												<xsl:when test="($AnzahlUnterelemente &gt; 0) or count($VergleichsElement/xdf3:struktur)">
													<td colspan="2">
														<table width="100%">
															<thead>
																<tr>
																	<th width="5%">ID</th>
																	<th width="5%">Version</th>
																	<th width="17%">Name</th>
																	<th width="5%">Kardinalität</th>
																	<th width="18%">Bezug zu</th>
																	<th width="5%">ID</th>
																	<th width="5%">Version</th>
																	<th width="17%">Name</th>
																	<th width="5%">Kardinalität</th>
																	<th width="18%">Bezug zu</th>
																</tr>
															</thead>
															<tbody>
																<xsl:variable name="Strukturelementart"><xsl:value-of select="./xdf3:schemaelementart/code"/></xsl:variable>
															
																<xsl:for-each select="$Element/xdf3:struktur">
																
																	<xsl:variable name="VergleichsElement2"><xsl:value-of select="./xdf3:enthaelt/*/xdf3:identifikation/xdf3:id"/></xsl:variable>
																	<xsl:variable name="VergleichsVersion"><xsl:value-of select="./xdf3:enthaelt/*/xdf3:identifikation/xdf3:version"/></xsl:variable>

																	<xsl:variable name="UnterelementA" select="."/>
																	<xsl:variable name="UnterelementO" select="$VergleichsElement/xdf3:struktur[xdf3:enthaelt/*/xdf3:identifikation/xdf3:id = $UnterelementA/xdf3:enthaelt/*/xdf3:identifikation/xdf3:id]"/>
																	
																	<xsl:variable name="BezugA">
																		<xsl:for-each select="$UnterelementA/xdf3:bezug">
																			<xsl:value-of select="."/><xsl:if test="fn:not(empty(./@link))"> (<xsl:value-of select="./@link"/>)</xsl:if>
																			<xsl:if test="fn:position() != fn:last()">
																				<xsl:text>; </xsl:text>
																			</xsl:if>
																		</xsl:for-each>
																	</xsl:variable>
																	<xsl:variable name="BezugO">
																		<xsl:for-each select="$UnterelementO/xdf3:bezug">
																			<xsl:value-of select="."/><xsl:if test="fn:not(empty(./@link))"> (<xsl:value-of select="./@link"/>)</xsl:if>
																			<xsl:if test="fn:position() != fn:last()">
																				<xsl:text>; </xsl:text>
																			</xsl:if>
																		</xsl:for-each>
																	</xsl:variable>
																	
																	<tr>
																		<td>
																			<xsl:element name="a">
																				<xsl:attribute name="href">#<xsl:value-of select="./xdf3:enthaelt/*/xdf3:identifikation/xdf3:id"/><xsl:if test="./xdf3:enthaelt/*/xdf3:identifikation/xdf3:version">V<xsl:value-of select="./xdf3:enthaelt/*/xdf3:identifikation/xdf3:version"/></xsl:if></xsl:attribute>
																				<xsl:value-of select="./xdf3:enthaelt/*/xdf3:identifikation/xdf3:id"/>
																			</xsl:element>
																			<xsl:choose>
																				<xsl:when test="$VergleichsVersion = ''">
																					<xsl:if test="count($Element/xdf3:struktur/./xdf3:enthaelt/*/xdf3:identifikation[xdf3:id=$VergleichsElement2 and not(xdf3:version)]) &gt; 1">
																					</xsl:if>
																				</xsl:when>
																				<xsl:otherwise>
																					<xsl:if test="count($Element/xdf3:struktur/./xdf3:enthaelt/*/xdf3:identifikation[xdf3:id=$VergleichsElement2 and xdf3:version=$VergleichsVersion]) &gt; 1">
																					</xsl:if>
																				</xsl:otherwise>
																			</xsl:choose>

																		</td>
																		<td>
																			<xsl:value-of select="./xdf3:enthaelt/*/xdf3:identifikation/xdf3:version"/>
																		</td>
																		<td>
																			<xsl:value-of select="./xdf3:enthaelt/*/xdf3:name"/>
																		</td>
																		<td>
																			<xsl:value-of select="./xdf3:anzahl"/>
																		</td>
																		<td>
																			<xsl:value-of select="$BezugA"/>
																		</td>
																		<xsl:choose>
																			<xsl:when test="empty($UnterelementO)">
																				<td colspan="5" class="Ungleich">
																					<i>Nicht vorhanden</i> ##
																				</td>
																			</xsl:when>
																			<xsl:otherwise>
																				<td>
																					<xsl:element name="a">
																						<xsl:attribute name="href">#X<xsl:value-of select="$UnterelementO/xdf3:enthaelt/*/xdf3:identifikation/xdf3:id"/><xsl:if test="$UnterelementO/xdf3:enthaelt/*/xdf3:identifikation/xdf3:version">V<xsl:value-of select="$UnterelementO/xdf3:enthaelt/*/xdf3:identifikation/xdf3:version"/></xsl:if></xsl:attribute>
																						<xsl:value-of select="$UnterelementO/xdf3:enthaelt/*/xdf3:identifikation/xdf3:id"/>
																					</xsl:element>
																				</td>
																				<xsl:choose>
																					<xsl:when test="(empty($UnterelementO/xdf3:enthaelt/*/xdf3:identifikation/xdf3:version) and empty($UnterelementA/xdf3:enthaelt/*/xdf3:identifikation/xdf3:version)) or ($UnterelementO/xdf3:enthaelt/*/xdf3:identifikation/xdf3:version = $UnterelementA/xdf3:enthaelt/*/xdf3:identifikation/xdf3:version)">
																						<td class="Gleich">
																							<xsl:value-of select="$UnterelementO/xdf3:enthaelt/*/xdf3:identifikation/xdf3:version"/>
																						</td>
																					</xsl:when>
																					<xsl:otherwise>
																						<td class="Ungleich">
																							<xsl:value-of select="$UnterelementO/xdf3:enthaelt/*/xdf3:identifikation/xdf3:version"/>
																						</td>
																					</xsl:otherwise>
																				</xsl:choose>
																				<xsl:choose>
																					<xsl:when test="(empty($UnterelementO/xdf3:enthaelt/*/xdf3:name) and empty($UnterelementA/xdf3:enthaelt/*/xdf3:name)) or ($UnterelementO/xdf3:enthaelt/*/xdf3:name = $UnterelementA/xdf3:enthaelt/*/xdf3:name)">
																						<td class="Gleich">
																							<xsl:value-of select="$UnterelementO/xdf3:enthaelt/*/xdf3:name"/><xsl:if test="($UnterelementO/xdf3:enthaelt/*/xdf3:identifikation/xdf3:version != $UnterelementA/xdf3:enthaelt/*/xdf3:identifikation/xdf3:version) or ($UnterelementO/xdf3:enthaelt/*/xdf3:name != $UnterelementA/xdf3:enthaelt/*/xdf3:name) or ($UnterelementO/xdf3:anzahl != $UnterelementA/xdf3:anzahl) or ($UnterelementO/xdf3:bezug != $UnterelementA/xdf3:bezug)"> ##</xsl:if>
																						</td>
																					</xsl:when>
																					<xsl:otherwise>
																						<td class="Ungleich">
																							<xsl:value-of select="$UnterelementO/xdf3:enthaelt/*/xdf3:name"/><xsl:if test="($UnterelementO/xdf3:enthaelt/*/xdf3:identifikation/xdf3:version != $UnterelementA/xdf3:enthaelt/*/xdf3:identifikation/xdf3:version) or ($UnterelementO/xdf3:enthaelt/*/xdf3:name != $UnterelementA/xdf3:enthaelt/*/xdf3:name) or ($UnterelementO/xdf3:anzahl != $UnterelementA/xdf3:anzahl) or ($UnterelementO/xdf3:bezug != $UnterelementA/xdf3:bezug)"> ##</xsl:if>
																						</td>
																					</xsl:otherwise>
																				</xsl:choose>
																				<xsl:choose>
																					<xsl:when test="(empty($UnterelementO/xdf3:anzahl) and empty($UnterelementA/xdf3:anzahl)) or ($UnterelementO/xdf3:anzahl = $UnterelementA/xdf3:anzahl)">
																						<td class="Gleich">
																							<xsl:value-of select="$UnterelementO/xdf3:anzahl"/>
																						</td>
																					</xsl:when>
																					<xsl:otherwise>
																						<td class="Ungleich">
																							<xsl:value-of select="$UnterelementO/xdf3:anzahl"/>
																						</td>
																					</xsl:otherwise>
																				</xsl:choose>
																				<xsl:choose>
																					<xsl:when test="(empty($UnterelementO/xdf3:bezug) and empty($UnterelementA/xdf3:bezug)) or ($BezugO = $BezugA)">
																						<td class="Gleich">
																							<xsl:value-of select="$BezugO"/>
																						</td>
																					</xsl:when>
																					<xsl:otherwise>
																						<td class="Ungleich">
																							<xsl:value-of select="$BezugO"/> ##
																						</td>
																					</xsl:otherwise>
																				</xsl:choose>
																			</xsl:otherwise>
																		</xsl:choose>
																	</tr>
																</xsl:for-each>

																<xsl:for-each select="$VergleichsElement/xdf3:struktur">
																	<xsl:variable name="UnterelementO" select="."/>
																	<xsl:variable name="UnterelementA" select="$Element/xdf3:struktur[xdf3:enthaelt/*/xdf3:identifikation/xdf3:id = $UnterelementO/xdf3:enthaelt/*/xdf3:identifikation/xdf3:id]"/>
																	<xsl:choose>
																		<xsl:when test="empty($UnterelementA)">
																			<tr>
																				<td colspan="2"><i>Nicht vorhanden</i></td>
																				<td></td>
																				<td></td>
																				<td></td>
																				<td class="Ungleich">
																					<xsl:element name="a">
																						<xsl:attribute name="href">#X<xsl:value-of select="$UnterelementO/xdf3:enthaelt/*/xdf3:identifikation/xdf3:id"/><xsl:if test="$UnterelementO/xdf3:enthaelt/*/xdf3:identifikation/xdf3:version">V<xsl:value-of select="$UnterelementO/xdf3:enthaelt/*/xdf3:identifikation/xdf3:version"/></xsl:if></xsl:attribute>
																						<xsl:value-of select="$UnterelementO/xdf3:enthaelt/*/xdf3:identifikation/xdf3:id"/>
																					</xsl:element>
																				</td>
																				<td class="Ungleich">
																					<xsl:value-of select="$UnterelementO/xdf3:enthaelt/*/xdf3:identifikation/xdf3:version"/>
																				</td>
																				<td class="Ungleich">
																					<xsl:value-of select="$UnterelementO/xdf3:enthaelt/*/xdf3:name"/> ##
																				</td>
																				<td class="Ungleich">
																					<xsl:value-of select="$UnterelementO/xdf3:anzahl"/>
																				</td>
																				<td class="Ungleich">
																					<xsl:value-of select="$UnterelementO/xdf3:bezug"/>
																				</td>
																			</tr>
																		</xsl:when>
																		<xsl:otherwise>
																		</xsl:otherwise>
																	</xsl:choose>
																</xsl:for-each>
															</tbody>
														</table>
													</td>
												</xsl:when>
												<xsl:otherwise>
													<td colspan="2">
													</td>
												</xsl:otherwise>
											</xsl:choose>
										</tr>
									<xsl:if test="count($Element/xdf3:regel) or count($VergleichsElement/xdf3:regel)">
										<tr>
											<td>
												<b>Regeln</b>
											</td>
											<td colspan="2">
												<table width="100%">
													<thead>
														<tr>
															<th width="5%">ID</th>
															<th width="5%">Version</th>
															<th width="18%">Name</th>
															<th width="22%">Freitextregel</th>
															<th width="5%">ID</th>
															<th width="5%">Version</th>
															<th width="18%">Name</th>
															<th width="22%">Freitextregel</th>
														</tr>
													</thead>
													<tbody>
														<xsl:for-each select="$Element/xdf3:regel">

															<xsl:variable name="UnterelementA" select="."/>
															<xsl:variable name="UnterelementO" select="$VergleichsElement/xdf3:regel[xdf3:identifikation/xdf3:id = $UnterelementA/xdf3:identifikation/xdf3:id]"/>

															<tr>
																<td>
																	<xsl:choose>
																		<xsl:when test="$RegelDetails = '1'">
																			<xsl:element name="a">
																				<xsl:attribute name="href">#<xsl:value-of select="./xdf3:identifikation/xdf3:id"/></xsl:attribute>
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
																	<xsl:value-of select="./xdf3:freitextRegel"/>
																</td>
																<xsl:choose>
																	<xsl:when test="empty($VergleichsElement)">
																		<td colspan="4">
																		</td>
																	</xsl:when>
																	<xsl:when test="empty($UnterelementO)">
																		<td colspan="4" class="Ungleich">
																			<i>Nicht vorhanden</i> ##
																		</td>
																	</xsl:when>
																	<xsl:otherwise>
																		<td>
																			<xsl:choose>
																				<xsl:when test="$RegelDetails = '1'">
																					<xsl:element name="a">
																						<xsl:attribute name="href">#X<xsl:value-of select="$UnterelementO/xdf3:identifikation/xdf3:id"/></xsl:attribute>
																						<xsl:value-of select="$UnterelementO/xdf3:identifikation/xdf3:id"/>
																					</xsl:element>
																				</xsl:when>
																				<xsl:otherwise>
																					<xsl:value-of select="$UnterelementO/xdf3:identifikation/xdf3:id"/>
																				</xsl:otherwise>
																			</xsl:choose>
																		</td>
																		<xsl:choose>
																			<xsl:when test="(empty($UnterelementO/xdf3:identifikation/xdf3:version) and empty($UnterelementA/xdf3:identifikation/xdf3:version)) or ($UnterelementO/xdf3:identifikation/xdf3:version = $UnterelementA/xdf3:identifikation/xdf3:version)">
																				<td class="Gleich">
																					<xsl:value-of select="$UnterelementO/xdf3:identifikation/xdf3:version"/>
																				</td>
																			</xsl:when>
																			<xsl:otherwise>
																				<td class="Ungleich">
																					<xsl:value-of select="$UnterelementO/xdf3:identifikation/xdf3:version"/>
																				</td>
																			</xsl:otherwise>
																		</xsl:choose>
																		<xsl:choose>
																			<xsl:when test="(empty($UnterelementO/xdf3:name) and empty($UnterelementA/xdf3:name)) or ($UnterelementO/xdf3:name = $UnterelementA/xdf3:name)">
																				<td class="Gleich">
																					<xsl:value-of select="$UnterelementO/xdf3:name"/><xsl:if test="($UnterelementO/xdf3:identifikation/xdf3:version != $UnterelementA/xdf3:identifikation/xdf3:version) or ($UnterelementO/xdf3:name != $UnterelementA/xdf3:name) or ($UnterelementO/xdf3:definition != $UnterelementA/xdf3:definition)"> ##</xsl:if>
																				</td>
																			</xsl:when>
																			<xsl:otherwise>
																				<td class="Ungleich">
																					<xsl:value-of select="$UnterelementO/xdf3:name"/><xsl:if test="($UnterelementO/xdf3:identifikation/xdf3:version != $UnterelementA/xdf3:identifikation/xdf3:version) or ($UnterelementO/xdf3:name != $UnterelementA/xdf3:name) or ($UnterelementO/xdf3:definition != $UnterelementA/xdf3:definition)"> ##</xsl:if>
																				</td>
																			</xsl:otherwise>
																		</xsl:choose>
																		<xsl:choose>
																			<xsl:when test="(empty($UnterelementO/xdf3:freitextRegel) and empty($UnterelementA/xdf3:freitextRegel)) or ($UnterelementO/xdf3:freitextRegel = $UnterelementA/xdf3:freitextRegel)">
																				<td class="Gleich">
																					<xsl:value-of select="$UnterelementO/xdf3:freitextRegel"/>
																				</td>
																			</xsl:when>
																			<xsl:otherwise>
																				<td class="Ungleich">
																					<xsl:value-of select="$UnterelementO/xdf3:freitextRegel"/>
																				</td>
																			</xsl:otherwise>
																		</xsl:choose>
																	</xsl:otherwise>
																</xsl:choose>
															</tr>
														</xsl:for-each>
														<xsl:for-each select="$VergleichsElement/xdf3:regel">
															<xsl:variable name="UnterelementO" select="."/>
															<xsl:variable name="UnterelementA" select="$Element/xdf3:regel[xdf3:identifikation/xdf3:id = $UnterelementO/xdf3:identifikation/xdf3:id]"/>
															<xsl:choose>
																<xsl:when test="empty($UnterelementA)">
																	<tr>
																		<td colspan="2"><i>Nicht vorhanden</i></td>
																		<td></td>
																		<td></td>
																		<td></td>
																		<td class="Ungleich">
																			<xsl:choose>
																				<xsl:when test="$RegelDetails = '1'">
																					<xsl:element name="a">
																						<xsl:attribute name="href">#X<xsl:value-of select="$UnterelementO/xdf3:identifikation/xdf3:id"/></xsl:attribute>
																						<xsl:value-of select="$UnterelementO/xdf3:identifikation/xdf3:id"/>
																					</xsl:element>
																				</xsl:when>
																				<xsl:otherwise>
																					<xsl:value-of select="$UnterelementO/xdf3:identifikation/xdf3:id"/>
																				</xsl:otherwise>
																			</xsl:choose>
																		</td>
																		<td class="Ungleich">
																			<xsl:value-of select="$UnterelementO/xdf3:identifikation/xdf3:version"/>
																		</td>
																		<td class="Ungleich">
																			<xsl:value-of select="$UnterelementO/xdf3:name"/> ##
																		</td>
																		<td class="Ungleich">
																			<xsl:value-of select="$UnterelementO/xdf3:freitextRegel"/>
																		</td>
																	</tr>
																</xsl:when>
																<xsl:otherwise>
																</xsl:otherwise>
															</xsl:choose>
														</xsl:for-each>
													</tbody>
												</table>
											</td>
										</tr>
									</xsl:if>

								<tr style="page-break-after:always">
									<td colspan="3" class="Navigation">
										<xsl:call-template name="navigationszeile"/>
									</td>
								</tr>
		
	</xsl:template>

	<!-- ############################################################################################################# -->

	<xsl:template name="datenfeldgruppedetails">
		<xsl:param name="Element"/>
		<xsl:param name="VergleichsElement"/>

		<xsl:if test="$DebugMode = '2' or $DebugMode = '3' or $DebugMode = '4'">
			<xsl:message>
				++++++++ datenfeldgruppedetails ++++++++
			</xsl:message>
		</xsl:if>
		<xsl:if test="$DebugMode = '3' or $DebugMode = '4'">
			<xsl:message>
				-------- <xsl:value-of select="$Element/xdf3:identifikation/xdf3:id"/><xsl:if test="$Element/xdf3:identifikation/xdf3:version">V<xsl:value-of select="$Element/xdf3:identifikation/xdf3:version"/></xsl:if> --------
			</xsl:message>
		</xsl:if>
		
										<tr>
											<td>
												<xsl:element name="a">
													<xsl:attribute name="name"><xsl:value-of select="$Element/xdf3:identifikation/xdf3:id"/><xsl:if test="$Element/xdf3:identifikation/xdf3:version">V<xsl:value-of select="$Element/xdf3:identifikation/xdf3:version"/></xsl:if></xsl:attribute>
												</xsl:element>
												<xsl:element name="a">
													<xsl:attribute name="name">X<xsl:value-of select="$VergleichsElement/xdf3:identifikation/xdf3:id"/><xsl:if test="$VergleichsElement/xdf3:identifikation/xdf3:version">V<xsl:value-of select="$VergleichsElement/xdf3:identifikation/xdf3:version"/></xsl:if></xsl:attribute>
												</xsl:element>
												ID
											</td>
											<td>
												<xsl:value-of select="$Element/xdf3:identifikation/xdf3:id"/>
												<xsl:if test="$ToolAufruf = '1'">
													&#160;&#160;
													<xsl:element name="a">
														<xsl:attribute name="href"><xsl:value-of select="$ToolPfadPrefix"/><xsl:value-of select="$Element/xdf3:identifikation/xdf3:id"/><xsl:if test="$Element/xdf3:identifikation/xdf3:version">V<xsl:value-of select="$Element/xdf3:identifikation/xdf3:version"/></xsl:if><xsl:value-of select="$ToolPfadPostfix"/></xsl:attribute>
														<xsl:attribute name="target">FIMTool</xsl:attribute>
														<xsl:attribute name="title">Springe in den Datenfeldeditor (man muss vorher angemeldet sein).</xsl:attribute>
														&#8658;
													</xsl:element>
												</xsl:if>
											</td>
											<td>
												<xsl:value-of select="$VergleichsElement/xdf3:identifikation/xdf3:id"/>
												<xsl:if test="$ToolAufruf = '1'">
													&#160;&#160;
													<xsl:element name="a">
														<xsl:attribute name="href"><xsl:value-of select="$ToolPfadPrefix"/><xsl:value-of select="$VergleichsElement/xdf3:identifikation/xdf3:id"/><xsl:if test="$VergleichsElement/xdf3:identifikation/xdf3:version">V<xsl:value-of select="$VergleichsElement/xdf3:identifikation/xdf3:version"/></xsl:if><xsl:value-of select="$ToolPfadPostfix"/></xsl:attribute>
														<xsl:attribute name="target">FIMTool</xsl:attribute>
														<xsl:attribute name="title">Springe in den Datenfeldeditor (man muss vorher angemeldet sein).</xsl:attribute>
														&#8658;
													</xsl:element>
												</xsl:if>
											</td>
										</tr>
										<tr>
											<td>Version <xsl:if test="fn:not(empty($VergleichsElement)) and (fn:not((empty($Element/xdf3:identifikation/xdf3:version) and empty($VergleichsElement/xdf3:identifikation/xdf3:version)) or ($Element/xdf3:identifikation/xdf3:version = $VergleichsElement/xdf3:identifikation/xdf3:version)))">##</xsl:if></td>
											<td>
												<xsl:value-of select="$Element/xdf3:identifikation/xdf3:version"/>
											</td>
											<xsl:choose>
												<xsl:when test="empty($VergleichsElement) or (empty($Element/xdf3:identifikation/xdf3:version) and empty($VergleichsElement/xdf3:identifikation/xdf3:version)) or ($Element/xdf3:identifikation/xdf3:version = $VergleichsElement/xdf3:identifikation/xdf3:version)">
													<td class="Gleich">
														<xsl:value-of select="$VergleichsElement/xdf3:identifikation/xdf3:version"/>
													</td>
												</xsl:when>
												<xsl:otherwise>
													<td class="Ungleich AenderungBaukasten">
														<xsl:value-of select="$VergleichsElement/xdf3:identifikation/xdf3:version"/>
													</td>
												</xsl:otherwise>
											</xsl:choose>
										</tr>
										<tr>
											<td>Versionshinweis <xsl:if test="fn:not((empty($Element/xdf3:versionshinweis) and empty($VergleichsElement/xdf3:versionshinweis)) or ($Element/xdf3:versionshinweis = $VergleichsElement/xdf3:versionshinweis))">##</xsl:if></td>
											<td>
												<xsl:value-of select="fn:replace($Element/xdf3:versionshinweis,'\n','&lt;br/&gt;')" disable-output-escaping="yes"/>
											</td>
											<xsl:choose>
												<xsl:when test="(empty($Element/xdf3:versionshinweis) and empty($VergleichsElement/xdf3:versionshinweis)) or ($Element/xdf3:versionshinweis = $VergleichsElement/xdf3:versionshinweis)">
													<td class="Gleich">
														<xsl:value-of select="fn:replace($VergleichsElement/xdf3:versionshinweis,'\n','&lt;br/&gt;')" disable-output-escaping="yes"/>
													</td>
												</xsl:when>
												<xsl:otherwise>
													<td class="Ungleich">
														<xsl:value-of select="fn:replace($VergleichsElement/xdf3:versionshinweis,'\n','&lt;br/&gt;')" disable-output-escaping="yes"/>
													</td>
												</xsl:otherwise>
											</xsl:choose>
										</tr>
										<tr>
											<td>Name <xsl:if test="fn:not((empty($Element/xdf3:name) and empty($VergleichsElement/xdf3:name)) or ($Element/xdf3:name = $VergleichsElement/xdf3:name))">##</xsl:if></td>
											<xsl:choose>
												<xsl:when test="empty($Element/xdf3:name/text())">
												<td class="SDSName">
												</td>
												</xsl:when>
												<xsl:otherwise>
													<td class="ElementName">
														<xsl:value-of select="$Element/xdf3:name"/>
													</td>
												</xsl:otherwise>
											</xsl:choose>
											<xsl:choose>
												<xsl:when test="(empty($Element/xdf3:name) and empty($VergleichsElement/xdf3:name)) or ($Element/xdf3:name = $VergleichsElement/xdf3:name)">
													<td class="ElementName Gleich">
														<xsl:value-of select="$VergleichsElement/xdf3:name"/>
													</td>
												</xsl:when>
												<xsl:otherwise>
													<td class="ElementName Ungleich">
														<xsl:value-of select="$VergleichsElement/xdf3:name"/>
													</td>
												</xsl:otherwise>
											</xsl:choose>
										</tr>
										<xsl:if test="count($Element/xdf3:stichwort) = 0 and count($VergleichsElement/xdf3:stichwort) = 0">
											<tr>
												<td>Stichwörter</td>
												<td></td>
												<td></td>
											</tr>
										</xsl:if>
										<xsl:for-each select="$Element/xdf3:stichwort">
											<xsl:variable name="stichwort" select="./text()"/>
											<xsl:variable name="uri"><xsl:value-of select="./@uri"/></xsl:variable>
											<xsl:variable name="VergleichsStichwort" select="$VergleichsElement/xdf3:stichwort[./text() = $stichwort]"/>
											<xsl:variable name="VergleichsURI"><xsl:value-of select="$VergleichsElement/xdf3:stichwort[./text() = $stichwort]/@uri"/></xsl:variable>
											
											<tr>
												<xsl:choose>
													<xsl:when test="fn:position() = 1"><td>Stichwörter</td></xsl:when>
													<xsl:otherwise><td></td></xsl:otherwise>
												</xsl:choose>
												<td>
													<ul class="hangrun">
														<li>
															<xsl:value-of select="."/><xsl:if test="@uri and ./@uri != ''"> (<xsl:value-of select="./@uri"/>)</xsl:if>
														</li>
													</ul>
												</td>
												<xsl:choose>
													<xsl:when test="empty($VergleichsStichwort)">
														<td class="Ungleich">
															<ul class="hangrun">
																<li><i>Nicht vorhanden</i> ##</li>
															</ul>
														</td>
													</xsl:when>
													<xsl:when test="$uri != $VergleichsURI">
														<td class="Ungleich">
															<ul class="hangrun">
																<li>
																	<xsl:value-of select="$VergleichsElement/xdf3:stichwort[./text() = $stichwort]/text()"/><xsl:if test="$VergleichsElement/xdf3:stichwort[./text() = $stichwort]/@uri and $VergleichsElement/xdf3:stichwort[./text() = $stichwort]/@uri != ''"> (<xsl:value-of select="$VergleichsElement/xdf3:stichwort[./text() = $stichwort]/@uri"/>)</xsl:if> ##
																</li>
															</ul>
														</td>
													</xsl:when>
													<xsl:otherwise>
														<td class="Gleich">
															<ul class="hangrun">
																<li>
																	<xsl:value-of select="$VergleichsElement/xdf3:stichwort[./text() = $stichwort]/text()"/><xsl:if test="$VergleichsElement/xdf3:stichwort[./text() = $stichwort]/@uri and $VergleichsElement/xdf3:stichwort[./text() = $stichwort]/@uri != ''"> (<xsl:value-of select="$VergleichsElement/xdf3:stichwort[./text() = $stichwort]/@uri"/>)</xsl:if>
																</li>
															</ul>
														</td>
													</xsl:otherwise>
												</xsl:choose>
											</tr>
										</xsl:for-each>
										<xsl:for-each select="$VergleichsElement/xdf3:stichwort">
											<xsl:variable name="stichwort" select="./text()"/>
											<xsl:variable name="uri"><xsl:value-of select="./@link"/></xsl:variable>
											<xsl:variable name="OriginalStichwort" select="$Element/xdf3:stichwort[./text() = $stichwort]"/>
											<xsl:variable name="OriginalURI"><xsl:value-of select="$Element/xdf3:stichwort[./text() = $stichwort]/@link"/></xsl:variable>
											
											<xsl:if test="not($Element/xdf3:stichwort[./text() = $stichwort])">
												<tr>
													<xsl:choose>
														<xsl:when test="count($Element/xdf3:stichwort) = 0 and fn:position() = 1"><td>Stichwörter</td></xsl:when>
														<xsl:otherwise><td></td></xsl:otherwise>
													</xsl:choose>
													<td>
														<ul class="hangrun">
															<li>
																<i>Nicht vorhanden</i>
															</li>
														</ul>
													</td>
													<td class="Ungleich">
														<ul class="hangrun">
															<li>
																<xsl:value-of select="./text()"/><xsl:if test="./@uri and ./@uri != ''"> (<xsl:value-of select="./@uri"/>)</xsl:if> ##
															</li>
														</ul>

													</td>
												</tr>
											</xsl:if>
										</xsl:for-each>
										<tr>
											<td>Definition <xsl:if test="fn:not((empty($Element/xdf3:definition) and empty($VergleichsElement/xdf3:definition)) or ($Element/xdf3:definition = $VergleichsElement/xdf3:definition))">##</xsl:if></td>
											<td>
												<xsl:value-of select="fn:replace($Element/xdf3:definition,'\n','&lt;br/&gt;')" disable-output-escaping="yes"/>
											</td>
											<xsl:choose>
												<xsl:when test="(empty($Element/xdf3:definition) and empty($VergleichsElement/xdf3:definition)) or ($Element/xdf3:definition = $VergleichsElement/xdf3:definition)">
													<td class="Gleich">
														<xsl:value-of select="fn:replace($VergleichsElement/xdf3:definition,'\n','&lt;br/&gt;')" disable-output-escaping="yes"/>
													</td>
												</xsl:when>
												<xsl:otherwise>
													<td class="Ungleich">
														<xsl:value-of select="fn:replace($VergleichsElement/xdf3:definition,'\n','&lt;br/&gt;')" disable-output-escaping="yes"/>
													</td>
												</xsl:otherwise>
											</xsl:choose>
										</tr>
										<tr>
											<td>Strukturelementart <xsl:if test="fn:not((empty($Element/xdf3:schemaelementart) and empty($VergleichsElement/xdf3:schemaelementart)) or ($Element/xdf3:schemaelementart = $VergleichsElement/xdf3:schemaelementart))">##</xsl:if></td>
											<td>
												<xsl:apply-templates select="$Element/xdf3:schemaelementart"/>
											</td>
											<xsl:choose>
												<xsl:when test="(empty($Element/xdf3:schemaelementart) and empty($VergleichsElement/xdf3:schemaelementart)) or ($Element/xdf3:schemaelementart = $VergleichsElement/xdf3:schemaelementart)">
													<td class="Gleich">
														<xsl:apply-templates select="$VergleichsElement/xdf3:schemaelementart"/>
													</td>
												</xsl:when>
												<xsl:otherwise>
													<td class="Ungleich">
														<xsl:apply-templates select="$VergleichsElement/xdf3:schemaelementart"/>
													</td>
												</xsl:otherwise>
											</xsl:choose>
										</tr>
										<tr>
											<td>Gruppenart <xsl:if test="fn:not((empty($Element/xdf3:art) and empty($VergleichsElement/xdf3:art)) or ($Element/xdf3:art = $VergleichsElement/xdf3:art))">##</xsl:if></td>
											<td>
												<xsl:apply-templates select="$Element/xdf3:art"/>
											</td>
											<xsl:choose>
												<xsl:when test="(empty($Element/xdf3:art) and empty($VergleichsElement/xdf3:art)) or ($Element/xdf3:art = $VergleichsElement/xdf3:art)">
													<td class="Gleich">
														<xsl:apply-templates select="$VergleichsElement/xdf3:art"/>
													</td>
												</xsl:when>
												<xsl:otherwise>
													<td class="Ungleich">
														<xsl:apply-templates select="$VergleichsElement/xdf3:art"/>
													</td>
												</xsl:otherwise>
											</xsl:choose>
										</tr>
										<xsl:if test="count($Element/xdf3:bezug) = 0 and count($VergleichsElement/xdf3:bezug) = 0">
											<tr>
												<td>Handlungsgrundlagen</td>
												<td></td>
												<td></td>
											</tr>
										</xsl:if>
										<xsl:for-each select="$Element/xdf3:bezug">
											<xsl:variable name="bezug" select="./text()"/>
											<xsl:variable name="link"><xsl:value-of select="./@link"/></xsl:variable>
											<xsl:variable name="VergleichsBezug" select="$VergleichsElement/xdf3:bezug[./text() = $bezug]"/>
											<xsl:variable name="VergleichsLink"><xsl:value-of select="$VergleichsElement/xdf3:bezug[./text() = $bezug]/@link"/></xsl:variable>
											
											<tr>
												<xsl:choose>
													<xsl:when test="fn:position() = 1"><td>Handlungsgrundlagen</td></xsl:when>
													<xsl:otherwise><td></td></xsl:otherwise>
												</xsl:choose>
												<td>
													<ul class="hangrun">
														<li>
															<xsl:value-of select="."/>
															<xsl:choose>
																<xsl:when test="not(@link) or ./@link=''"></xsl:when>
																<xsl:when test="$HandlungsgrundlagenLinks = '1'">
																	- <xsl:element name="a">
																		<xsl:attribute name="href"><xsl:value-of select="./@link"/></xsl:attribute>
																		<xsl:attribute name="target">Handlungsgrundlage</xsl:attribute>
																		<xsl:attribute name="title">Springe zum Text der Handlungsgrundlage.</xsl:attribute>
																		<xsl:value-of select="./@link"/>
																	</xsl:element>
																</xsl:when>
																<xsl:otherwise>
																	- <xsl:value-of select="./@link"/>
																</xsl:otherwise>
															</xsl:choose>
														</li>
													</ul>
												</td>
												<xsl:choose>
													<xsl:when test="empty($VergleichsBezug)">
														<td class="Ungleich">
															<ul class="hangrun">
																<li><i>Nicht vorhanden</i> ##</li>
															</ul>
														</td>
													</xsl:when>
													<xsl:when test="$link != $VergleichsLink">
														<td class="Ungleich">
															<ul class="hangrun">
																<li>
																	<xsl:value-of select="$VergleichsElement/xdf3:bezug[./text() = $bezug]/text()"/>
																	<xsl:choose>
																		<xsl:when test="not($VergleichsElement/xdf3:bezug[./text() = $bezug]/@link) or $VergleichsElement/xdf3:bezug[./text() = $bezug]/@link=''"></xsl:when>
																		<xsl:when test="$HandlungsgrundlagenLinks = '1'">
																			- <xsl:element name="a">
																				<xsl:attribute name="href"><xsl:value-of select="./@link"/></xsl:attribute>
																				<xsl:attribute name="target">Handlungsgrundlage</xsl:attribute>
																				<xsl:attribute name="title">Springe zum Text der Handlungsgrundlage.</xsl:attribute>
																				<xsl:value-of select="$VergleichsElement/xdf3:bezug[./text() = $bezug]/@link"/>
																			</xsl:element> ##
																		</xsl:when>
																		<xsl:otherwise>
																			- <xsl:value-of select="$VergleichsElement/xdf3:bezug[./text() = $bezug]/@link"/> ##
																		</xsl:otherwise>
																	</xsl:choose>
																</li>
															</ul>
														</td>
													</xsl:when>
													<xsl:otherwise>
														<td class="Gleich">
															<ul class="hangrun">
																<li>
																	<xsl:value-of select="$VergleichsElement/xdf3:bezug[./text() = $bezug]/text()"/>
																	<xsl:choose>
																		<xsl:when test="not($VergleichsElement/xdf3:bezug[./text() = $bezug]/@link) or $VergleichsElement/xdf3:bezug[./text() = $bezug]/@link=''"></xsl:when>
																		<xsl:when test="$HandlungsgrundlagenLinks = '1'">
																			- <xsl:element name="a">
																				<xsl:attribute name="href"><xsl:value-of select="./@link"/></xsl:attribute>
																				<xsl:attribute name="target">Handlungsgrundlage</xsl:attribute>
																				<xsl:attribute name="title">Springe zum Text der Handlungsgrundlage.</xsl:attribute>
																				<xsl:value-of select="$VergleichsElement/xdf3:bezug[./text() = $bezug]/@link"/>
																			</xsl:element>
																		</xsl:when>
																		<xsl:otherwise>
																			- <xsl:value-of select="$VergleichsElement/xdf3:bezug[./text() = $bezug]/@link"/>
																		</xsl:otherwise>
																	</xsl:choose>
																</li>
															</ul>
														</td>
													</xsl:otherwise>
												</xsl:choose>
											</tr>
										</xsl:for-each>
										<xsl:for-each select="$VergleichsElement/xdf3:bezug">
											<xsl:variable name="bezug" select="./text()"/>
											<xsl:variable name="link"><xsl:value-of select="./@link"/></xsl:variable>
											<xsl:variable name="OriginalBezug" select="$Element/xdf3:bezug[./text() = $bezug]"/>
											<xsl:variable name="OriginalLink"><xsl:value-of select="$Element/xdf3:bezug[./text() = $bezug]/@link"/></xsl:variable>
											
											<xsl:if test="not($Element/xdf3:bezug[./text() = $bezug])">
												<tr>
													<xsl:choose>
														<xsl:when test="count($Element/xdf3:bezug) = 0 and fn:position() = 1"><td>Handlungsgrundlagen</td></xsl:when>
														<xsl:otherwise><td></td></xsl:otherwise>
													</xsl:choose>
													<td>
														<ul class="hangrun">
															<li>
																<i>Nicht vorhanden</i>
															</li>
														</ul>
													</td>
													<td class="Ungleich">
														<ul class="hangrun">
															<li>
																<xsl:value-of select="./text()"/><xsl:if test="not(./@link) or ./@link=''"> ##</xsl:if>
																<xsl:choose>
																	<xsl:when test="not(./@link) or ./@link=''"></xsl:when>
																	<xsl:when test="$HandlungsgrundlagenLinks = '1'">
																		- <xsl:element name="a">
																			<xsl:attribute name="href"><xsl:value-of select="./@link"/></xsl:attribute>
																			<xsl:attribute name="target">Handlungsgrundlage</xsl:attribute>
																			<xsl:attribute name="title">Springe zum Text der Handlungsgrundlage.</xsl:attribute>
																			<xsl:value-of select="./@link"/>
																		</xsl:element> ##
																	</xsl:when>
																	<xsl:otherwise>
																		- <xsl:value-of select="./@link"/> ##
																	</xsl:otherwise>
																</xsl:choose>
															</li>
														</ul>

													</td>
												</tr>
											</xsl:if>
										</xsl:for-each>
										<tr>
											<td>Beschreibung <xsl:if test="fn:not((empty($Element/xdf3:beschreibung) and empty($VergleichsElement/xdf3:beschreibung)) or ($Element/xdf3:beschreibung = $VergleichsElement/xdf3:beschreibung))">##</xsl:if></td>
											<td>
												<xsl:value-of select="fn:replace($Element/xdf3:beschreibung,'\n','&lt;br/&gt;')" disable-output-escaping="yes"/>
											</td>
											<xsl:choose>
												<xsl:when test="(empty($Element/xdf3:beschreibung) and empty($VergleichsElement/xdf3:beschreibung)) or ($Element/xdf3:beschreibung = $VergleichsElement/xdf3:beschreibung)">
													<td class="Gleich">
														<xsl:value-of select="fn:replace($VergleichsElement/xdf3:beschreibung,'\n','&lt;br/&gt;')" disable-output-escaping="yes"/>
													</td>
												</xsl:when>
												<xsl:otherwise>
													<td class="Ungleich">
														<xsl:value-of select="fn:replace($VergleichsElement/xdf3:beschreibung,'\n','&lt;br/&gt;')" disable-output-escaping="yes"/>
													</td>
												</xsl:otherwise>
											</xsl:choose>
										</tr>
										<tr>
											<td>Bezeichnung Eingabe <xsl:if test="fn:not((empty($Element/xdf3:bezeichnungEingabe) and empty($VergleichsElement/xdf3:bezeichnungEingabe)) or ($Element/xdf3:bezeichnungEingabe = $VergleichsElement/xdf3:bezeichnungEingabe))">##</xsl:if></td>
											<td>
												<xsl:value-of select="$Element/xdf3:bezeichnungEingabe"/>
											</td>
											<xsl:choose>
												<xsl:when test="(empty($Element/xdf3:bezeichnungEingabe) and empty($VergleichsElement/xdf3:bezeichnungEingabe)) or ($Element/xdf3:bezeichnungEingabe = $VergleichsElement/xdf3:bezeichnungEingabe)">
													<td class="Gleich">
														<xsl:value-of select="$VergleichsElement/xdf3:bezeichnungEingabe"/>
													</td>
												</xsl:when>
												<xsl:otherwise>
													<td class="Ungleich">
														<xsl:value-of select="$VergleichsElement/xdf3:bezeichnungEingabe"/>
													</td>
												</xsl:otherwise>
											</xsl:choose>
										</tr>
										<tr>
											<td>Bezeichnung Ausgabe <xsl:if test="fn:not((empty($Element/xdf3:bezeichnungAusgabe) and empty($VergleichsElement/xdf3:bezeichnungAusgabe)) or ($Element/xdf3:bezeichnungAusgabe = $VergleichsElement/xdf3:bezeichnungAusgabe))">##</xsl:if></td>
											<td>
												<xsl:value-of select="$Element/xdf3:bezeichnungAusgabe"/>
											</td>
											<xsl:choose>
												<xsl:when test="(empty($Element/xdf3:bezeichnungAusgabe) and empty($VergleichsElement/xdf3:bezeichnungAusgabe)) or ($Element/xdf3:bezeichnungAusgabe = $VergleichsElement/xdf3:bezeichnungAusgabe)">
													<td class="Gleich">
														<xsl:value-of select="$VergleichsElement/xdf3:bezeichnungAusgabe"/>
													</td>
												</xsl:when>
												<xsl:otherwise>
													<td class="Ungleich">
														<xsl:value-of select="$VergleichsElement/xdf3:bezeichnung"/>
													</td>
												</xsl:otherwise>
											</xsl:choose>
										</tr>
										<tr>
											<td>Hilfetext Eingabe <xsl:if test="fn:not((empty($Element/xdf3:hilfetextEingabe) and empty($VergleichsElement/xdf3:hilfetextEingabe)) or ($Element/xdf3:hilfetextEingabe = $VergleichsElement/xdf3:hilfetextEingabe))">##</xsl:if></td>
											<td>
												<xsl:value-of select="fn:replace($Element/xdf3:hilfetextEingabe,'\n','&lt;br/&gt;')" disable-output-escaping="yes"/>
											</td>
											<xsl:choose>
												<xsl:when test="(empty($Element/xdf3:hilfetextEingabe) and empty($VergleichsElement/xdf3:hilfetextEingabe)) or ($Element/xdf3:hilfetextEingabe = $VergleichsElement/xdf3:hilfetextEingabe)">
													<td class="Gleich">
														<xsl:value-of select="fn:replace($VergleichsElement/xdf3:hilfetextEingabe,'\n','&lt;br/&gt;')" disable-output-escaping="yes"/>
													</td>
												</xsl:when>
												<xsl:otherwise>
													<td class="Ungleich">
														<xsl:value-of select="fn:replace($VergleichsElement/xdf3:hilfetextEingabe,'\n','&lt;br/&gt;')" disable-output-escaping="yes"/>
													</td>
												</xsl:otherwise>
											</xsl:choose>
										</tr>
										<tr>
											<td>Hilfetext Ausgabe <xsl:if test="fn:not((empty($Element/xdf3:hilfetextAusgabe) and empty($VergleichsElement/xdf3:hilfetextAusgabe)) or ($Element/xdf3:hilfetextAusgabe = $VergleichsElement/xdf3:hilfetextAusgabe))">##</xsl:if></td>
											<td>
												<xsl:value-of select="fn:replace($Element/xdf3:hilfetextAusgabe,'\n','&lt;br/&gt;')" disable-output-escaping="yes"/>
											</td>
											<xsl:choose>
												<xsl:when test="(empty($Element/xdf3:hilfetextAusgabe) and empty($VergleichsElement/xdf3:hilfetextAusgabe)) or ($Element/xdf3:hilfetextAusgabe = $VergleichsElement/xdf3:hilfetextAusgabe)">
													<td class="Gleich">
														<xsl:value-of select="fn:replace($VergleichsElement/xdf3:hilfetextAusgabe,'\n','&lt;br/&gt;')" disable-output-escaping="yes"/>
													</td>
												</xsl:when>
												<xsl:otherwise>
													<td class="Ungleich">
														<xsl:value-of select="fn:replace($VergleichsElement/xdf3:hilfetextAusgabe,'\n','&lt;br/&gt;')" disable-output-escaping="yes"/>
													</td>
												</xsl:otherwise>
											</xsl:choose>
										</tr>
										<tr>
											<td>Gültig ab <xsl:if test="fn:not((empty($Element/xdf3:gueltigAb) and empty($VergleichsElement/xdf3:gueltigAb)) or ($Element/xdf3:gueltigAb = $VergleichsElement/xdf3:gueltigAb))">##</xsl:if></td>
											<td>
												<xsl:value-of select="fn:format-date($Element/xdf3:gueltigAb,'[D01].[M01].[Y0001]')"/>
											</td>
											<xsl:choose>
												<xsl:when test="(empty($Element/xdf3:gueltigAb) and empty($VergleichsElement/xdf3:gueltigAb)) or ($Element/xdf3:gueltigAb = $VergleichsElement/xdf3:gueltigAb)">
													<td class="Gleich">
														<xsl:value-of select="fn:format-date($VergleichsElement/xdf3:gueltigAb,'[D01].[M01].[Y0001]')"/>
													</td>
												</xsl:when>
												<xsl:otherwise>
													<td class="Ungleich">
														<xsl:value-of select="fn:format-date($VergleichsElement/xdf3:gueltigAb,'[D01].[M01].[Y0001]')"/>
													</td>
												</xsl:otherwise>
											</xsl:choose>
										</tr>
										<tr>
											<td>Gültig bis <xsl:if test="fn:not((empty($Element/xdf3:gueltigBis) and empty($VergleichsElement/xdf3:gueltigBis)) or ($Element/xdf3:gueltigBis = $VergleichsElement/xdf3:gueltigBis))">##</xsl:if></td>
											<td>
												<xsl:value-of select="fn:format-date($Element/xdf3:gueltigBis,'[D01].[M01].[Y0001]')"/>
											</td>
											<xsl:choose>
												<xsl:when test="(empty($Element/xdf3:gueltigBis) and empty($VergleichsElement/xdf3:gueltigBis)) or ($Element/xdf3:gueltigBis = $VergleichsElement/xdf3:gueltigBis)">
													<td class="Gleich">
														<xsl:value-of select="fn:format-date($VergleichsElement/xdf3:gueltigBis,'[D01].[M01].[Y0001]')"/>
													</td>
												</xsl:when>
												<xsl:otherwise>
													<td class="Ungleich">
														<xsl:value-of select="fn:format-date($VergleichsElement/xdf3:gueltigBis,'[D01].[M01].[Y0001]')"/>
													</td>
												</xsl:otherwise>
											</xsl:choose>
										</tr>
										<tr>
											<td>Fachlicher Ersteller <xsl:if test="fn:not((empty($Element/xdf3:statusGesetztDurch) and empty($VergleichsElement/xdf3:statusGesetztDurch)) or ($Element/xdf3:statusGesetztDurch = $VergleichsElement/xdf3:statusGesetztDurch))">##</xsl:if></td>
											<td>
												<xsl:value-of select="$Element/xdf3:statusGesetztDurch"/>
											</td>
											<xsl:choose>
												<xsl:when test="(empty($Element/xdf3:statusGesetztDurch) and empty($VergleichsElement/xdf3:statusGesetztDurch)) or ($Element/xdf3:statusGesetztDurch = $VergleichsElement/xdf3:statusGesetztDurch)">
													<td class="Gleich">
														<xsl:value-of select="$VergleichsElement/xdf3:statusGesetztDurch"/>
													</td>
												</xsl:when>
												<xsl:otherwise>
													<td class="Ungleich">
														<xsl:value-of select="$VergleichsElement/xdf3:statusGesetztDurch"/>
													</td>
												</xsl:otherwise>
											</xsl:choose>
										</tr>
										<tr>
											<td>Status <xsl:if test="fn:not((empty($Element/xdf3:freigabestatus) and empty($VergleichsElement/xdf3:freigabestatus)) or ($Element/xdf3:freigabestatus = $VergleichsElement/xdf3:freigabestatus))">##</xsl:if></td>
											<td>
												<xsl:apply-templates select="$Element/xdf3:freigabestatus"/>
											</td>
											<xsl:choose>
												<xsl:when test="(empty($Element/xdf3:freigabestatus) and empty($VergleichsElement/xdf3:freigabestatus)) or ($Element/xdf3:freigabestatus = $VergleichsElement/xdf3:freigabestatus)">
													<td class="Gleich">
														<xsl:apply-templates select="$VergleichsElement/xdf3:freigabestatus"/>
													</td>
												</xsl:when>
												<xsl:otherwise>
													<td class="Ungleich">
														<xsl:apply-templates select="$VergleichsElement/xdf3:freigabestatus"/>
													</td>
												</xsl:otherwise>
											</xsl:choose>
										</tr>
										<tr>
											<td>Status gesetzt am <xsl:if test="fn:not((empty($Element/xdf3:statusGesetztAm) and empty($VergleichsElement/xdf3:statusGesetztAm)) or ($Element/xdf3:statusGesetztAm = $VergleichsElement/xdf3:statusGesetztAm))">##</xsl:if></td>
											<td>
												<xsl:value-of select="fn:format-date($Element/xdf3:statusGesetztAm,'[D01].[M01].[Y0001]')"/>
											</td>
											<xsl:choose>
												<xsl:when test="(empty($Element/xdf3:statusGesetztAm) and empty($VergleichsElement/xdf3:statusGesetztAm)) or ($Element/xdf3:statusGesetztAm = $VergleichsElement/xdf3:statusGesetztAm)">
													<td class="Gleich">
														<xsl:value-of select="fn:format-date($VergleichsElement/xdf3:statusGesetztAm,'[D01].[M01].[Y0001]')"/>
													</td>
												</xsl:when>
												<xsl:otherwise>
													<td class="Ungleich">
														<xsl:value-of select="fn:format-date($VergleichsElement/xdf3:statusGesetztAm,'[D01].[M01].[Y0001]')"/>
													</td>
												</xsl:otherwise>
											</xsl:choose>
										</tr>
										<tr>
											<td>Veröffentlichungsdatum <xsl:if test="fn:not((empty($Element/xdf3:veroeffentlichungsdatum) and empty($VergleichsElement/xdf3:veroeffentlichungsdatum)) or ($Element/xdf3:veroeffentlichungsdatum = $VergleichsElement/xdf3:veroeffentlichungsdatum))">##</xsl:if></td>
											<td>
												<xsl:value-of select="fn:format-date($Element/xdf3:veroeffentlichungsdatum,'[D01].[M01].[Y0001]')"/>
											</td>
											<xsl:choose>
												<xsl:when test="(empty($Element/xdf3:veroeffentlichungsdatum) and empty($VergleichsElement/xdf3:veroeffentlichungsdatum)) or ($Element/xdf3:veroeffentlichungsdatum = $VergleichsElement/xdf3:veroeffentlichungsdatum)">
													<td class="Gleich">
														<xsl:value-of select="fn:format-date($VergleichsElement/xdf3:veroeffentlichungsdatum,'[D01].[M01].[Y0001]')"/>
													</td>
												</xsl:when>
												<xsl:otherwise>
													<td class="Ungleich">
														<xsl:value-of select="fn:format-date($VergleichsElement/xdf3:veroeffentlichungsdatum,'[D01].[M01].[Y0001]')"/>
													</td>
												</xsl:otherwise>
											</xsl:choose>
										</tr>
										<tr>
											<td>Letzte Änderung <xsl:if test="fn:not((empty($Element/xdf3:letzteAenderung) and empty($VergleichsElement/xdf3:letzteAenderung)) or ($Element/xdf3:letzteAenderung = $VergleichsElement/xdf3:letzteAenderung))">##</xsl:if></td>
											<td>
												<xsl:value-of select="fn:format-dateTime($Element/xdf3:letzteAenderung,'[D01].[M01].[Y0001] um [H01]:[m01] Uhr')"/>
											</td>
											<xsl:choose>
												<xsl:when test="(empty($Element/xdf3:letzteAenderung) and empty($VergleichsElement/xdf3:letzteAenderung)) or ($Element/xdf3:letzteAenderung = $VergleichsElement/xdf3:letzteAenderung)">
													<td class="Gleich">
														<xsl:value-of select="fn:format-dateTime($VergleichsElement/xdf3:letzteAenderung,'[D01].[M01].[Y0001] um [H01]:[m01] Uhr')"/>
													</td>
												</xsl:when>
												<xsl:otherwise>
													<td class="Ungleich">
														<xsl:value-of select="fn:format-dateTime($VergleichsElement/xdf3:letzteAenderung,'[D01].[M01].[Y0001] um [H01]:[m01] Uhr')"/>
													</td>
												</xsl:otherwise>
											</xsl:choose>
										</tr>
										<tr>
											<td colspan="3"><h2/></td>
										</tr>
										<tr>
											<xsl:variable name="AnzahlUnterelemente" select="count($Element/xdf3:struktur)"/>

											<td>
												<b>Unterelemente</b>
											</td>
											<xsl:choose>
												<xsl:when test="($AnzahlUnterelemente &gt; 0) or count($VergleichsElement/xdf3:struktur)">
													<td colspan="2">
														<table width="100%">
															<thead>
																<tr>
																	<th width="5%">ID</th>
																	<th width="5%">Version</th>
																	<th width="17%">Name</th>
																	<th width="5%">Kardinalität</th>
																	<th width="18%">Bezug zu</th>
																	<th width="5%">ID</th>
																	<th width="5%">Version</th>
																	<th width="17%">Name</th>
																	<th width="5%">Kardinalität</th>
																	<th width="18%">Bezug zu</th>
																</tr>
															</thead>
															<tbody>
																<xsl:variable name="Strukturelementart"><xsl:value-of select="./xdf3:schemaelementart/code"/></xsl:variable>
															
																<xsl:for-each select="$Element/xdf3:struktur">
																
																	<xsl:variable name="VergleichsElement2"><xsl:value-of select="./xdf3:enthaelt/*/xdf3:identifikation/xdf3:id"/></xsl:variable>
																	<xsl:variable name="VergleichsVersion"><xsl:value-of select="./xdf3:enthaelt/*/xdf3:identifikation/xdf3:version"/></xsl:variable>

																	<xsl:variable name="UnterelementA" select="."/>
																	<xsl:variable name="UnterelementO" select="$VergleichsElement/xdf3:struktur[xdf3:enthaelt/*/xdf3:identifikation/xdf3:id = $UnterelementA/xdf3:enthaelt/*/xdf3:identifikation/xdf3:id]"/>
																	
																	<xsl:variable name="BezugA">
																		<xsl:for-each select="$UnterelementA/xdf3:bezug">
																			<xsl:value-of select="."/><xsl:if test="fn:not(empty(./@link))"> (<xsl:value-of select="./@link"/>)</xsl:if>
																			<xsl:if test="fn:position() != fn:last()">
																				<xsl:text>; </xsl:text>
																			</xsl:if>
																		</xsl:for-each>
																	</xsl:variable>
																	<xsl:variable name="BezugO">
																		<xsl:for-each select="$UnterelementO/xdf3:bezug">
																			<xsl:value-of select="."/><xsl:if test="fn:not(empty(./@link))"> (<xsl:value-of select="./@link"/>)</xsl:if>
																			<xsl:if test="fn:position() != fn:last()">
																				<xsl:text>; </xsl:text>
																			</xsl:if>
																		</xsl:for-each>
																	</xsl:variable>
																	
																	<tr>
																		<td>
																			<xsl:element name="a">
																				<xsl:attribute name="href">#<xsl:value-of select="./xdf3:enthaelt/*/xdf3:identifikation/xdf3:id"/><xsl:if test="./xdf3:enthaelt/*/xdf3:identifikation/xdf3:version">V<xsl:value-of select="./xdf3:enthaelt/*/xdf3:identifikation/xdf3:version"/></xsl:if></xsl:attribute>
																				<xsl:value-of select="./xdf3:enthaelt/*/xdf3:identifikation/xdf3:id"/>
																			</xsl:element>
																			<xsl:choose>
																				<xsl:when test="$VergleichsVersion = ''">
																					<xsl:if test="count($Element/xdf3:struktur/./xdf3:enthaelt/*/xdf3:identifikation[xdf3:id=$VergleichsElement2 and not(xdf3:version)]) &gt; 1">
																					</xsl:if>
																				</xsl:when>
																				<xsl:otherwise>
																					<xsl:if test="count($Element/xdf3:struktur/./xdf3:enthaelt/*/xdf3:identifikation[xdf3:id=$VergleichsElement2 and xdf3:version=$VergleichsVersion]) &gt; 1">
																					</xsl:if>
																				</xsl:otherwise>
																			</xsl:choose>

																		</td>
																		<td>
																			<xsl:value-of select="./xdf3:enthaelt/*/xdf3:identifikation/xdf3:version"/>
																		</td>
																		<td>
																			<xsl:value-of select="./xdf3:enthaelt/*/xdf3:name"/>
																		</td>
																		<td>
																			<xsl:value-of select="./xdf3:anzahl"/>
																		</td>
																		<td>
																			<xsl:value-of select="$BezugA"/>
																		</td>
																		<xsl:choose>
																			<xsl:when test="empty($UnterelementO)">
																				<td colspan="5" class="Ungleich">
																					<i>Nicht vorhanden</i> ##
																				</td>
																			</xsl:when>
																			<xsl:otherwise>
																				<td>
																					<xsl:element name="a">
																						<xsl:attribute name="href">#X<xsl:value-of select="$UnterelementO/xdf3:enthaelt/*/xdf3:identifikation/xdf3:id"/><xsl:if test="$UnterelementO/xdf3:enthaelt/*/xdf3:identifikation/xdf3:version">V<xsl:value-of select="$UnterelementO/xdf3:enthaelt/*/xdf3:identifikation/xdf3:version"/></xsl:if></xsl:attribute>
																						<xsl:value-of select="$UnterelementO/xdf3:enthaelt/*/xdf3:identifikation/xdf3:id"/>
																					</xsl:element>
																				</td>
																				<xsl:choose>
																					<xsl:when test="(empty($UnterelementO/xdf3:enthaelt/*/xdf3:identifikation/xdf3:version) and empty($UnterelementA/xdf3:enthaelt/*/xdf3:identifikation/xdf3:version)) or ($UnterelementO/xdf3:enthaelt/*/xdf3:identifikation/xdf3:version = $UnterelementA/xdf3:enthaelt/*/xdf3:identifikation/xdf3:version)">
																						<td class="Gleich">
																							<xsl:value-of select="$UnterelementO/xdf3:enthaelt/*/xdf3:identifikation/xdf3:version"/>
																						</td>
																					</xsl:when>
																					<xsl:otherwise>
																						<td class="Ungleich">
																							<xsl:value-of select="$UnterelementO/xdf3:enthaelt/*/xdf3:identifikation/xdf3:version"/>
																						</td>
																					</xsl:otherwise>
																				</xsl:choose>
																				<xsl:choose>
																					<xsl:when test="(empty($UnterelementO/xdf3:enthaelt/*/xdf3:name) and empty($UnterelementA/xdf3:enthaelt/*/xdf3:name)) or ($UnterelementO/xdf3:enthaelt/*/xdf3:name = $UnterelementA/xdf3:enthaelt/*/xdf3:name)">
																						<td class="Gleich">
																							<xsl:value-of select="$UnterelementO/xdf3:enthaelt/*/xdf3:name"/><xsl:if test="($UnterelementO/xdf3:enthaelt/*/xdf3:identifikation/xdf3:version != $UnterelementA/xdf3:enthaelt/*/xdf3:identifikation/xdf3:version) or ($UnterelementO/xdf3:enthaelt/*/xdf3:name != $UnterelementA/xdf3:enthaelt/*/xdf3:name) or ($UnterelementO/xdf3:anzahl != $UnterelementA/xdf3:anzahl) or ($UnterelementO/xdf3:bezug != $UnterelementA/xdf3:bezug)"> ##</xsl:if>
																						</td>
																					</xsl:when>
																					<xsl:otherwise>
																						<td class="Ungleich">
																							<xsl:value-of select="$UnterelementO/xdf3:enthaelt/*/xdf3:name"/><xsl:if test="($UnterelementO/xdf3:enthaelt/*/xdf3:identifikation/xdf3:version != $UnterelementA/xdf3:enthaelt/*/xdf3:identifikation/xdf3:version) or ($UnterelementO/xdf3:enthaelt/*/xdf3:name != $UnterelementA/xdf3:enthaelt/*/xdf3:name) or ($UnterelementO/xdf3:anzahl != $UnterelementA/xdf3:anzahl) or ($UnterelementO/xdf3:bezug != $UnterelementA/xdf3:bezug)"> ##</xsl:if>
																						</td>
																					</xsl:otherwise>
																				</xsl:choose>
																				<xsl:choose>
																					<xsl:when test="(empty($UnterelementO/xdf3:anzahl) and empty($UnterelementA/xdf3:anzahl)) or ($UnterelementO/xdf3:anzahl = $UnterelementA/xdf3:anzahl)">
																						<td class="Gleich">
																							<xsl:value-of select="$UnterelementO/xdf3:anzahl"/>
																						</td>
																					</xsl:when>
																					<xsl:otherwise>
																						<td class="Ungleich">
																							<xsl:value-of select="$UnterelementO/xdf3:anzahl"/>
																						</td>
																					</xsl:otherwise>
																				</xsl:choose>
																				<xsl:choose>
																					<xsl:when test="(empty($UnterelementO/xdf3:bezug) and empty($UnterelementA/xdf3:bezug)) or ($BezugO = $BezugA)">
																						<td class="Gleich">
																							<xsl:value-of select="$BezugO"/>
																						</td>
																					</xsl:when>
																					<xsl:otherwise>
																						<td class="Ungleich">
																							<xsl:value-of select="$BezugO"/> ##
																						</td>
																					</xsl:otherwise>
																				</xsl:choose>
																			</xsl:otherwise>
																		</xsl:choose>
																	</tr>
																</xsl:for-each>

																<xsl:for-each select="$VergleichsElement/xdf3:struktur">
																	<xsl:variable name="UnterelementO" select="."/>
																	<xsl:variable name="UnterelementA" select="$Element/xdf3:struktur[xdf3:enthaelt/*/xdf3:identifikation/xdf3:id = $UnterelementO/xdf3:enthaelt/*/xdf3:identifikation/xdf3:id]"/>
																	<xsl:choose>
																		<xsl:when test="empty($UnterelementA)">
																			<tr>
																				<td colspan="2"><i>Nicht vorhanden</i></td>
																				<td></td>
																				<td></td>
																				<td></td>
																				<td class="Ungleich">
																					<xsl:element name="a">
																						<xsl:attribute name="href">#X<xsl:value-of select="$UnterelementO/xdf3:enthaelt/*/xdf3:identifikation/xdf3:id"/><xsl:if test="$UnterelementO/xdf3:enthaelt/*/xdf3:identifikation/xdf3:version">V<xsl:value-of select="$UnterelementO/xdf3:enthaelt/*/xdf3:identifikation/xdf3:version"/></xsl:if></xsl:attribute>
																						<xsl:value-of select="$UnterelementO/xdf3:enthaelt/*/xdf3:identifikation/xdf3:id"/>
																					</xsl:element>
																				</td>
																				<td class="Ungleich">
																					<xsl:value-of select="$UnterelementO/xdf3:enthaelt/*/xdf3:identifikation/xdf3:version"/>
																				</td>
																				<td class="Ungleich">
																					<xsl:value-of select="$UnterelementO/xdf3:enthaelt/*/xdf3:name"/> ##
																				</td>
																				<td class="Ungleich">
																					<xsl:value-of select="$UnterelementO/xdf3:anzahl"/>
																				</td>
																				<td class="Ungleich">
																					<xsl:value-of select="$UnterelementO/xdf3:bezug"/>
																				</td>
																			</tr>
																		</xsl:when>
																		<xsl:otherwise>
																		</xsl:otherwise>
																	</xsl:choose>
																</xsl:for-each>
															</tbody>
														</table>
													</td>
												</xsl:when>
												<xsl:otherwise>
													<td colspan="2">
													</td>
												</xsl:otherwise>
											</xsl:choose>
										</tr>
									<xsl:if test="count($Element/xdf3:regel) or count($VergleichsElement/xdf3:regel)">
										<tr>
											<td>
												<b>Regeln</b>
											</td>
											<td colspan="2">
												<table width="100%">
													<thead>
														<tr>
															<th width="5%">ID</th>
															<th width="5%">Version</th>
															<th width="18%">Name</th>
															<th width="22%">Freitextregel</th>
															<th width="5%">ID</th>
															<th width="5%">Version</th>
															<th width="18%">Name</th>
															<th width="22%">Freitextregel</th>
														</tr>
													</thead>
													<tbody>
														<xsl:for-each select="$Element/xdf3:regel">

															<xsl:variable name="UnterelementA" select="."/>
															<xsl:variable name="UnterelementO" select="$VergleichsElement/xdf3:regel[xdf3:identifikation/xdf3:id = $UnterelementA/xdf3:identifikation/xdf3:id]"/>

															<tr>
																<td>
																	<xsl:choose>
																		<xsl:when test="$RegelDetails = '1'">
																			<xsl:element name="a">
																				<xsl:attribute name="href">#<xsl:value-of select="./xdf3:identifikation/xdf3:id"/></xsl:attribute>
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
																	<xsl:value-of select="./xdf3:freitextRegel"/>
																</td>
																<xsl:choose>
																	<xsl:when test="empty($VergleichsElement)">
																		<td colspan="4">
																		</td>
																	</xsl:when>
																	<xsl:when test="empty($UnterelementO)">
																		<td colspan="4" class="Ungleich">
																			<i>Nicht vorhanden</i> ##
																		</td>
																	</xsl:when>
																	<xsl:otherwise>
																		<td>
																			<xsl:choose>
																				<xsl:when test="$RegelDetails = '1'">
																					<xsl:element name="a">
																						<xsl:attribute name="href">#X<xsl:value-of select="$UnterelementO/xdf3:identifikation/xdf3:id"/></xsl:attribute>
																						<xsl:value-of select="$UnterelementO/xdf3:identifikation/xdf3:id"/>
																					</xsl:element>
																				</xsl:when>
																				<xsl:otherwise>
																					<xsl:value-of select="$UnterelementO/xdf3:identifikation/xdf3:id"/>
																				</xsl:otherwise>
																			</xsl:choose>
																		</td>
																		<xsl:choose>
																			<xsl:when test="(empty($UnterelementO/xdf3:identifikation/xdf3:version) and empty($UnterelementA/xdf3:identifikation/xdf3:version)) or ($UnterelementO/xdf3:identifikation/xdf3:version = $UnterelementA/xdf3:identifikation/xdf3:version)">
																				<td class="Gleich">
																					<xsl:value-of select="$UnterelementO/xdf3:identifikation/xdf3:version"/>
																				</td>
																			</xsl:when>
																			<xsl:otherwise>
																				<td class="Ungleich">
																					<xsl:value-of select="$UnterelementO/xdf3:identifikation/xdf3:version"/>
																				</td>
																			</xsl:otherwise>
																		</xsl:choose>
																		<xsl:choose>
																			<xsl:when test="(empty($UnterelementO/xdf3:name) and empty($UnterelementA/xdf3:name)) or ($UnterelementO/xdf3:name = $UnterelementA/xdf3:name)">
																				<td class="Gleich">
																					<xsl:value-of select="$UnterelementO/xdf3:name"/><xsl:if test="($UnterelementO/xdf3:identifikation/xdf3:version != $UnterelementA/xdf3:identifikation/xdf3:version) or ($UnterelementO/xdf3:name != $UnterelementA/xdf3:name) or ($UnterelementO/xdf3:definition != $UnterelementA/xdf3:definition)"> ##</xsl:if>
																				</td>
																			</xsl:when>
																			<xsl:otherwise>
																				<td class="Ungleich">
																					<xsl:value-of select="$UnterelementO/xdf3:name"/><xsl:if test="($UnterelementO/xdf3:identifikation/xdf3:version != $UnterelementA/xdf3:identifikation/xdf3:version) or ($UnterelementO/xdf3:name != $UnterelementA/xdf3:name) or ($UnterelementO/xdf3:definition != $UnterelementA/xdf3:definition)"> ##</xsl:if>
																				</td>
																			</xsl:otherwise>
																		</xsl:choose>
																		<xsl:choose>
																			<xsl:when test="(empty($UnterelementO/xdf3:freitextRegel) and empty($UnterelementA/xdf3:freitextRegel)) or ($UnterelementO/xdf3:freitextRegel = $UnterelementA/xdf3:freitextRegel)">
																				<td class="Gleich">
																					<xsl:value-of select="$UnterelementO/xdf3:freitextRegel"/>
																				</td>
																			</xsl:when>
																			<xsl:otherwise>
																				<td class="Ungleich">
																					<xsl:value-of select="$UnterelementO/xdf3:freitextRegel"/>
																				</td>
																			</xsl:otherwise>
																		</xsl:choose>
																	</xsl:otherwise>
																</xsl:choose>
															</tr>
														</xsl:for-each>
														<xsl:for-each select="$VergleichsElement/xdf3:regel">
															<xsl:variable name="UnterelementO" select="."/>
															<xsl:variable name="UnterelementA" select="$Element/xdf3:regel[xdf3:identifikation/xdf3:id = $UnterelementO/xdf3:identifikation/xdf3:id]"/>
															<xsl:choose>
																<xsl:when test="empty($UnterelementA)">
																	<tr>
																		<td colspan="2"><i>Nicht vorhanden</i></td>
																		<td></td>
																		<td></td>
																		<td></td>
																		<td class="Ungleich">
																			<xsl:choose>
																				<xsl:when test="$RegelDetails = '1'">
																					<xsl:element name="a">
																						<xsl:attribute name="href">#X<xsl:value-of select="$UnterelementO/xdf3:identifikation/xdf3:id"/></xsl:attribute>
																						<xsl:value-of select="$UnterelementO/xdf3:identifikation/xdf3:id"/>
																					</xsl:element>
																				</xsl:when>
																				<xsl:otherwise>
																					<xsl:value-of select="$UnterelementO/xdf3:identifikation/xdf3:id"/>
																				</xsl:otherwise>
																			</xsl:choose>
																		</td>
																		<td class="Ungleich">
																			<xsl:value-of select="$UnterelementO/xdf3:identifikation/xdf3:version"/>
																		</td>
																		<td class="Ungleich">
																			<xsl:value-of select="$UnterelementO/xdf3:name"/> ##
																		</td>
																		<td class="Ungleich">
																			<xsl:value-of select="$UnterelementO/xdf3:freitextRegel"/>
																		</td>
																	</tr>
																</xsl:when>
																<xsl:otherwise>
																</xsl:otherwise>
															</xsl:choose>
														</xsl:for-each>
													</tbody>
												</table>
											</td>
										</tr>
									</xsl:if>

								<tr style="page-break-after:always">
									<td colspan="3" class="Navigation">
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
	
					<h2><br/></h2>
					<h2>
						<xsl:choose>
							<xsl:when test="name(/*) ='xdf3:xdatenfelder.stammdatenschema.0102'">
								<a name="ElementDetails"/>Details zu den Baukastenelementen des Datenschemas <xsl:value-of select="$NameSDSA"/> im Vergleich mit Datenschema <xsl:value-of select="$NameSDSO"/>
							</xsl:when>
							<xsl:when test="name(/*) ='xdf3:xdatenfelder.datenfeldgruppe.0103'">
								<a name="ElementDetails"/>Details zu den Baukastenelementen der Datenfeldgruppe <xsl:value-of select="$NameSDSA"/> im Vergleich mit Datenfeldgruppe <xsl:value-of select="$NameSDSO"/>
							</xsl:when>
						</xsl:choose>
					</h2>

					<xsl:variable name="CompareIDE" select="/*/*/xdf3:identifikation/xdf3:id"/>
					<xsl:variable name="CompareVersionE" select="/*/*/xdf3:identifikation/xdf3:version/text()"/>

					<xsl:variable name="CompareIDV" select="$VergleichsDaten/*/*/xdf3:identifikation/xdf3:id"/>
					<xsl:variable name="CompareVersionV" select="$VergleichsDaten/*/*/xdf3:identifikation/xdf3:version/text()"/>

					<table style="page-break-after:always">
						<thead>
							<xsl:choose>
								<xsl:when test="name(/*) ='xdf3:xdatenfelder.stammdatenschema.0102'">
									<tr>
										<th width="10%">Metadatum</th>
										<th width="45%">Inhalt Datenschema <xsl:value-of select="$NameSDSA"/></th>
										<th width="45%">Inhalt Datenschema <xsl:value-of select="$NameSDSO"/></th>
									</tr>
								</xsl:when>
								<xsl:when test="name(/*) ='xdf3:xdatenfelder.datenfeldgruppe.0103'">
									<tr>
										<th width="10%">Metadatum</th>
										<th width="45%">Inhalt Datenfeldgruppe <xsl:value-of select="$NameSDSA"/></th>
										<th width="45%">Inhalt Datenfeldgruppe <xsl:value-of select="$NameSDSO"/></th>
									</tr>
								</xsl:when>
							</xsl:choose>
						</thead>
						<tbody>
							<xsl:for-each-group select="//xdf3:datenfeldgruppe | //xdf3:datenfeld" group-by="xdf3:identifikation/xdf3:id">
								<xsl:sort select="./xdf3:identifikation/xdf3:id"/>
									
								<xsl:for-each-group select="fn:current-group()" group-by="string(xdf3:identifikation/xdf3:version)">
									<xsl:sort select="./xdf3:identifikation/xdf3:version"/>
									
									<xsl:if test="not($CompareIDE = ./xdf3:identifikation/xdf3:id and ($CompareVersionE = ./xdf3:identifikation/xdf3:version or (empty($CompareVersionE) and empty(./xdf3:identifikation/xdf3:version) )))">
										<xsl:call-template name="elementdetails">
											<xsl:with-param name="Element" select="."/>
											<xsl:with-param name="VersionsAnzahl" select="fn:last()"/>
										</xsl:call-template>
									</xsl:if>

								</xsl:for-each-group>
				
							</xsl:for-each-group>

							<xsl:for-each-group select="$VergleichsDaten//xdf3:datenfeldgruppe | $VergleichsDaten//xdf3:datenfeld" group-by="xdf3:identifikation/xdf3:id">
								<xsl:sort select="./xdf3:identifikation/xdf3:id"/>
									
								<xsl:for-each-group select="fn:current-group()" group-by="string(xdf3:identifikation/xdf3:version)">
									<xsl:sort select="./xdf3:identifikation/xdf3:version"/>
									
									<xsl:variable name="CheckId" select="./xdf3:identifikation/xdf3:id"/>

									<xsl:if test="empty($Daten//xdf3:identifikation[xdf3:id = $CheckId])">

										<xsl:if test="not($CompareIDV = ./xdf3:identifikation/xdf3:id and ($CompareVersionV = ./xdf3:identifikation/xdf3:version or (empty($CompareVersionV) and empty(./xdf3:identifikation/xdf3:version) )))">
											<xsl:call-template name="elementdetailsvergleich">
												<xsl:with-param name="Element" select="."/>
												<xsl:with-param name="VersionsAnzahl" select="fn:last()"/>
											</xsl:call-template>
										</xsl:if>
									
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

		
		<xsl:variable name="Temp" select="$VergleichsDaten//*[xdf3:identifikation/xdf3:id = $Element/xdf3:identifikation/xdf3:id]"/>
		<xsl:variable name="VergleichsElement" select="$Temp[1]"/>
		
		<xsl:if test="$DebugMode = '2' or $DebugMode = '3' or $DebugMode = '4'">
			<xsl:message>
				++++++++ elementdetails ++++++++
			</xsl:message>
		</xsl:if>
		<xsl:if test="$DebugMode = '3' or $DebugMode = '4'">
			<xsl:message>
				-------- <xsl:value-of select="$Element/xdf3:identifikation/xdf3:id"/><xsl:if test="$Element/xdf3:identifikation/xdf3:version">V<xsl:value-of select="$Element/xdf3:identifikation/xdf3:version"/></xsl:if> --------
			</xsl:message>
		</xsl:if>

									<xsl:choose>
										<xsl:when test="$Element/name() = 'xdf3:datenfeld'">
											<tr>
												<td>
													<xsl:element name="a">
														<xsl:attribute name="name"><xsl:value-of select="$Element/xdf3:identifikation/xdf3:id"/><xsl:if test="$Element/xdf3:identifikation/xdf3:version">V<xsl:value-of select="$Element/xdf3:identifikation/xdf3:version"/></xsl:if></xsl:attribute>
													</xsl:element>
													ID <xsl:if test="empty($VergleichsElement)">##</xsl:if>
												</td>
												<td class="ElementID">
													<xsl:value-of select="$Element/xdf3:identifikation/xdf3:id"/>
													<xsl:if test="$ToolAufruf = '1'">
														&#160;&#160;
														<xsl:element name="a">
															<xsl:attribute name="href"><xsl:value-of select="$ToolPfadPrefix"/><xsl:value-of select="$Element/xdf3:identifikation/xdf3:id"/><xsl:if test="$Element/xdf3:identifikation/xdf3:version">V<xsl:value-of select="$Element/xdf3:identifikation/xdf3:version"/></xsl:if><xsl:value-of select="$ToolPfadPostfix"/></xsl:attribute>
															<xsl:attribute name="target">FIMTool</xsl:attribute>
															<xsl:attribute name="title">Springe in den Datenfeldeditor (man muss vorher angemeldet sein).</xsl:attribute>
															&#8658;
														</xsl:element>
													</xsl:if>
												</td>
												<xsl:choose>
													<xsl:when test="empty($VergleichsElement)">
														<td class="Ungleich NeuBaukasten"><i>Nicht vorhanden</i></td>
													</xsl:when>
													<xsl:otherwise>
														<td class="ElementID">
															<xsl:element name="a">
																<xsl:attribute name="name">X<xsl:value-of select="$VergleichsElement/xdf3:identifikation/xdf3:id"/><xsl:if test="$VergleichsElement/xdf3:identifikation/xdf3:version">V<xsl:value-of select="$VergleichsElement/xdf3:identifikation/xdf3:version"/></xsl:if></xsl:attribute>
															</xsl:element>
															<xsl:value-of select="$VergleichsElement/xdf3:identifikation/xdf3:id"/>
															<xsl:if test="$ToolAufruf = '1'">
																&#160;&#160;
																<xsl:element name="a">
																	<xsl:attribute name="href"><xsl:value-of select="$ToolPfadPrefix"/><xsl:value-of select="$VergleichsElement/xdf3:identifikation/xdf3:id"/><xsl:if test="$VergleichsElement/xdf3:identifikation/xdf3:version">V<xsl:value-of select="$VergleichsElement/xdf3:identifikation/xdf3:version"/></xsl:if><xsl:value-of select="$ToolPfadPostfix"/></xsl:attribute>
																	<xsl:attribute name="target">FIMTool</xsl:attribute>
																	<xsl:attribute name="title">Springe in den Datenfeldeditor (man muss vorher angemeldet sein).</xsl:attribute>
																	&#8658;
																</xsl:element>
															</xsl:if>
														</td>
													</xsl:otherwise>
												</xsl:choose>
											</tr>
											<tr>
												<td>Version <xsl:if test="fn:not(empty($VergleichsElement)) and (fn:not((empty($Element/xdf3:identifikation/xdf3:version) and empty($VergleichsElement/xdf3:identifikation/xdf3:version)) or ($Element/xdf3:identifikation/xdf3:version = $VergleichsElement/xdf3:identifikation/xdf3:version)))">##</xsl:if></td>
												<xsl:choose>
													<xsl:when test="$VersionsAnzahl &gt; 1">
														<td>
															<xsl:value-of select="$Element/xdf3:identifikation/xdf3:version"/>
														</td>
													</xsl:when>
													<xsl:otherwise>
														<td>
															<xsl:value-of select="$Element/xdf3:identifikation/xdf3:version"/>
														</td>
													</xsl:otherwise>
												</xsl:choose>
												<xsl:choose>
													<xsl:when test="empty($VergleichsElement) or (empty($Element/xdf3:identifikation/xdf3:version) and empty($VergleichsElement/xdf3:identifikation/xdf3:version)) or ($Element/xdf3:identifikation/xdf3:version = $VergleichsElement/xdf3:identifikation/xdf3:version)">
														<td class="Gleich">
															<xsl:value-of select="$VergleichsElement/xdf3:identifikation/xdf3:version"/>
														</td>
													</xsl:when>
													<xsl:otherwise>
														<td class="Ungleich AenderungBaukasten">
															<xsl:value-of select="$VergleichsElement/xdf3:identifikation/xdf3:version"/>
														</td>
													</xsl:otherwise>
												</xsl:choose>
											</tr>
											<tr>
												<td>Versionshinweis <xsl:if test="fn:not((empty($Element/xdf3:versionshinweis) and empty($VergleichsElement/xdf3:versionshinweis)) or ($Element/xdf3:versionshinweis = $VergleichsElement/xdf3:versionshinweis))">##</xsl:if></td>
												<td>
													<xsl:value-of select="fn:replace($Element/xdf3:versionshinweis,'\n','&lt;br/&gt;')" disable-output-escaping="yes"/>
												</td>
												<xsl:choose>
													<xsl:when test="empty($VergleichsElement) or (empty($Element/xdf3:versionshinweis) and empty($VergleichsElement/xdf3:versionshinweis)) or ($Element/xdf3:versionshinweis = $VergleichsElement/xdf3:versionshinweis)">
														<td class="Gleich">
															<xsl:value-of select="fn:replace($VergleichsElement/xdf3:versionshinweis,'\n','&lt;br/&gt;')" disable-output-escaping="yes"/>
														</td>
													</xsl:when>
													<xsl:otherwise>
														<td class="Ungleich">
															<xsl:value-of select="fn:replace($VergleichsElement/xdf3:versionshinweis,'\n','&lt;br/&gt;')" disable-output-escaping="yes"/>
														</td>
													</xsl:otherwise>
												</xsl:choose>
											</tr>
											<tr>
												<td>Name <xsl:if test="fn:not(empty($VergleichsElement)) and (fn:not((empty($Element/xdf3:name) and empty($VergleichsElement/xdf3:name)) or ($Element/xdf3:name = $VergleichsElement/xdf3:name)))">##</xsl:if></td>
												<xsl:choose>
													<xsl:when test="empty($Element/xdf3:name/text())">
													<td class="ElementName">
														</td>
													</xsl:when>
													<xsl:otherwise>
														<td class="ElementName">
															<xsl:value-of select="$Element/xdf3:name"/>
														</td>
													</xsl:otherwise>
												</xsl:choose>
												<xsl:choose>
													<xsl:when test="empty($VergleichsElement) or (empty($Element/xdf3:name) and empty($VergleichsElement/xdf3:name)) or ($Element/xdf3:name = $VergleichsElement/xdf3:name)">
														<td class="ElementName Gleich">
															<xsl:value-of select="$VergleichsElement/xdf3:name"/>
														</td>
													</xsl:when>
													<xsl:otherwise>
														<td class="ElementName Ungleich">
															<xsl:value-of select="$VergleichsElement/xdf3:name"/>
														</td>
													</xsl:otherwise>
												</xsl:choose>
											</tr>
											<xsl:if test="count($Element/xdf3:stichwort) = 0 and count($VergleichsElement/xdf3:stichwort) = 0">
												<tr>
													<td>Stichwörter</td>
													<td></td>
													<td></td>
												</tr>
											</xsl:if>
											<xsl:for-each select="$Element/xdf3:stichwort">
												<xsl:variable name="stichwort" select="./text()"/>
												<xsl:variable name="uri"><xsl:value-of select="./@uri"/></xsl:variable>
												<xsl:variable name="VergleichsStichwort" select="$VergleichsElement/xdf3:stichwort[./text() = $stichwort]"/>
												<xsl:variable name="VergleichsURI"><xsl:value-of select="$VergleichsElement/xdf3:stichwort[./text() = $stichwort]/@uri"/></xsl:variable>
												
												<tr>
													<xsl:choose>
														<xsl:when test="fn:position() = 1"><td>Stichwörter</td></xsl:when>
														<xsl:otherwise><td></td></xsl:otherwise>
													</xsl:choose>
													<td>
														<ul class="hangrun">
															<li>
																<xsl:value-of select="."/><xsl:if test="@uri and ./@uri != ''"> (<xsl:value-of select="./@uri"/>)</xsl:if>
															</li>
														</ul>
													</td>
													<xsl:choose>
														<xsl:when test="empty($VergleichsElement)">
															<td class="Gleich">
																<ul class="hangrun">
																</ul>
															</td>
														</xsl:when>
														<xsl:when test="empty($VergleichsStichwort)">
															<td class="Ungleich">
																<ul class="hangrun">
																	<li><i>Nicht vorhanden</i> ##</li>
																</ul>
															</td>
														</xsl:when>
														<xsl:when test="$uri != $VergleichsURI">
															<td class="Ungleich">
																<ul class="hangrun">
																	<li>
																		<xsl:value-of select="$VergleichsElement/xdf3:stichwort[./text() = $stichwort]/text()"/><xsl:if test="$VergleichsElement/xdf3:stichwort[./text() = $stichwort]/@uri and $VergleichsElement/xdf3:stichwort[./text() = $stichwort]/@uri != ''"> (<xsl:value-of select="$VergleichsElement/xdf3:stichwort[./text() = $stichwort]/@uri"/>)</xsl:if> ##
																	</li>
																</ul>
															</td>
														</xsl:when>
														<xsl:otherwise>
															<td class="Gleich">
																<ul class="hangrun">
																	<li>
																		<xsl:value-of select="$VergleichsElement/xdf3:stichwort[./text() = $stichwort]/text()"/><xsl:if test="$VergleichsElement/xdf3:stichwort[./text() = $stichwort]/@uri and $VergleichsElement/xdf3:stichwort[./text() = $stichwort]/@uri != ''"> (<xsl:value-of select="$VergleichsElement/xdf3:stichwort[./text() = $stichwort]/@uri"/>)</xsl:if>
																	</li>
																</ul>
															</td>
														</xsl:otherwise>
													</xsl:choose>
												</tr>
											</xsl:for-each>
											<xsl:for-each select="$VergleichsElement/xdf3:stichwort">
												<xsl:variable name="stichwort" select="./text()"/>
												<xsl:variable name="uri"><xsl:value-of select="./@link"/></xsl:variable>
												<xsl:variable name="OriginalStichwort" select="$Element/xdf3:stichwort[./text() = $stichwort]"/>
												<xsl:variable name="OriginalURI"><xsl:value-of select="$Element/xdf3:stichwort[./text() = $stichwort]/@link"/></xsl:variable>
												
												<xsl:if test="not($Element/xdf3:stichwort[./text() = $stichwort])">
													<tr>
														<xsl:choose>
															<xsl:when test="count($Element/xdf3:stichwort) = 0 and fn:position() = 1"><td>Stichwörter</td></xsl:when>
															<xsl:otherwise><td></td></xsl:otherwise>
														</xsl:choose>
														<td>
															<ul class="hangrun">
																<li>
																	<i>Nicht vorhanden</i>
																</li>
															</ul>
														</td>
														<td class="Ungleich">
															<ul class="hangrun">
																<li>
																	<xsl:value-of select="./text()"/><xsl:if test="./@uri and ./@uri != ''"> (<xsl:value-of select="./@uri"/>)</xsl:if> ##
																</li>
															</ul>
	
														</td>
													</tr>
												</xsl:if>
											</xsl:for-each>
											<tr>
												<td>Definition <xsl:if test="fn:not(empty($VergleichsElement)) and (fn:not((empty($Element/xdf3:definition) and empty($VergleichsElement/xdf3:definition)) or ($Element/xdf3:definition = $VergleichsElement/xdf3:definition)))">##</xsl:if></td>
												<td>
													<xsl:value-of select="fn:replace($Element/xdf3:definition,'\n','&lt;br/&gt;')" disable-output-escaping="yes"/>
												</td>
												<xsl:choose>
													<xsl:when test="empty($VergleichsElement) or (empty($Element/xdf3:definition) and empty($VergleichsElement/xdf3:definition)) or ($Element/xdf3:definition = $VergleichsElement/xdf3:definition)">
														<td class="Gleich">
															<xsl:value-of select="fn:replace($VergleichsElement/xdf3:definition,'\n','&lt;br/&gt;')" disable-output-escaping="yes"/>
														</td>
													</xsl:when>
													<xsl:otherwise>
														<td class="Ungleich">
															<xsl:value-of select="fn:replace($VergleichsElement/xdf3:definition,'\n','&lt;br/&gt;')" disable-output-escaping="yes"/>
														</td>
													</xsl:otherwise>
												</xsl:choose>
											</tr>
											<tr>
												<td>Strukturelementart <xsl:if test="fn:not(empty($VergleichsElement)) and (fn:not((empty($Element/xdf3:schemaelementart) and empty($VergleichsElement/xdf3:schemaelementart)) or ($Element/xdf3:schemaelementart = $VergleichsElement/xdf3:schemaelementart)))">##</xsl:if></td>
												<td>
													<xsl:apply-templates select="$Element/xdf3:schemaelementart"/>
												</td>
												<xsl:choose>
													<xsl:when test="empty($VergleichsElement) or (empty($Element/xdf3:schemaelementart) and empty($VergleichsElement/xdf3:schemaelementart)) or ($Element/xdf3:schemaelementart = $VergleichsElement/xdf3:schemaelementart)">
														<td class="Gleich">
															<xsl:apply-templates select="$VergleichsElement/xdf3:schemaelementart"/>
														</td>
													</xsl:when>
													<xsl:otherwise>
														<td class="Ungleich">
															<xsl:apply-templates select="$VergleichsElement/xdf3:schemaelementart"/>
														</td>
													</xsl:otherwise>
												</xsl:choose>
											</tr>
											<xsl:if test="count($Element/xdf3:bezug) = 0 and count($VergleichsElement/xdf3:bezug) = 0">
												<tr>
													<td>Handlungsgrundlagen</td>
													<td></td>
													<td></td>
												</tr>
											</xsl:if>
											<xsl:for-each select="$Element/xdf3:bezug">
												<xsl:variable name="bezug" select="./text()"/>
												<xsl:variable name="link"><xsl:value-of select="./@link"/></xsl:variable>
												<xsl:variable name="VergleichsBezug" select="$VergleichsElement/xdf3:bezug[./text() = $bezug]"/>
												<xsl:variable name="VergleichsLink"><xsl:value-of select="$VergleichsElement/xdf3:bezug[./text() = $bezug]/@link"/></xsl:variable>
												
												<tr>
													<xsl:choose>
														<xsl:when test="fn:position() = 1"><td>Handlungsgrundlagen</td></xsl:when>
														<xsl:otherwise><td></td></xsl:otherwise>
													</xsl:choose>
													<td>
														<ul class="hangrun">
															<li>
																<xsl:value-of select="."/>
																<xsl:choose>
																	<xsl:when test="not(@link) or ./@link=''"></xsl:when>
																	<xsl:when test="$HandlungsgrundlagenLinks = '1'">
																		- <xsl:element name="a">
																			<xsl:attribute name="href"><xsl:value-of select="./@link"/></xsl:attribute>
																			<xsl:attribute name="target">Handlungsgrundlage</xsl:attribute>
																			<xsl:attribute name="title">Springe zum Text der Handlungsgrundlage.</xsl:attribute>
																			<xsl:value-of select="./@link"/>
																		</xsl:element>
																	</xsl:when>
																	<xsl:otherwise>
																		- <xsl:value-of select="./@link"/>
																	</xsl:otherwise>
																</xsl:choose>
															</li>
														</ul>
													</td>
													<xsl:choose>
														<xsl:when test="empty($VergleichsElement)">
															<td class="Gleich">
																<ul class="hangrun">
																</ul>
															</td>
														</xsl:when>
														<xsl:when test="empty($VergleichsBezug)">
															<td class="Ungleich">
																<ul class="hangrun">
																	<li><i>Nicht vorhanden</i> ##</li>
																</ul>
															</td>
														</xsl:when>
														<xsl:when test="$link != $VergleichsLink">
															<td class="Ungleich">
																<ul class="hangrun">
																	<li>
																		<xsl:value-of select="$VergleichsElement/xdf3:bezug[./text() = $bezug]/text()"/>
																		<xsl:choose>
																			<xsl:when test="not($VergleichsElement/xdf3:bezug[./text() = $bezug]/@link) or $VergleichsElement/xdf3:bezug[./text() = $bezug]/@link=''"></xsl:when>
																			<xsl:when test="$HandlungsgrundlagenLinks = '1'">
																				- <xsl:element name="a">
																					<xsl:attribute name="href"><xsl:value-of select="./@link"/></xsl:attribute>
																					<xsl:attribute name="target">Handlungsgrundlage</xsl:attribute>
																					<xsl:attribute name="title">Springe zum Text der Handlungsgrundlage.</xsl:attribute>
																					<xsl:value-of select="$VergleichsElement/xdf3:bezug[./text() = $bezug]/@link"/>
																				</xsl:element> ##
																			</xsl:when>
																			<xsl:otherwise>
																				- <xsl:value-of select="$VergleichsElement/xdf3:bezug[./text() = $bezug]/@link"/> ##
																			</xsl:otherwise>
																		</xsl:choose>
																	</li>
																</ul>
															</td>
														</xsl:when>
														<xsl:otherwise>
															<td class="Gleich">
																<ul class="hangrun">
																	<li>
																		<xsl:value-of select="$VergleichsElement/xdf3:bezug[./text() = $bezug]/text()"/>
																		<xsl:choose>
																			<xsl:when test="not($VergleichsElement/xdf3:bezug[./text() = $bezug]/@link) or $VergleichsElement/xdf3:bezug[./text() = $bezug]/@link=''"></xsl:when>
																			<xsl:when test="$HandlungsgrundlagenLinks = '1'">
																				- <xsl:element name="a">
																					<xsl:attribute name="href"><xsl:value-of select="./@link"/></xsl:attribute>
																					<xsl:attribute name="target">Handlungsgrundlage</xsl:attribute>
																					<xsl:attribute name="title">Springe zum Text der Handlungsgrundlage.</xsl:attribute>
																					<xsl:value-of select="$VergleichsElement/xdf3:bezug[./text() = $bezug]/@link"/>
																				</xsl:element>
																			</xsl:when>
																			<xsl:otherwise>
																				- <xsl:value-of select="$VergleichsElement/xdf3:bezug[./text() = $bezug]/@link"/>
																			</xsl:otherwise>
																		</xsl:choose>
																	</li>
																</ul>
															</td>
														</xsl:otherwise>
													</xsl:choose>
												</tr>
											</xsl:for-each>
											<xsl:for-each select="$VergleichsElement/xdf3:bezug">
												<xsl:variable name="bezug" select="./text()"/>
												<xsl:variable name="link"><xsl:value-of select="./@link"/></xsl:variable>
												<xsl:variable name="OriginalBezug" select="$Element/xdf3:bezug[./text() = $bezug]"/>
												<xsl:variable name="OriginalLink"><xsl:value-of select="$Element/xdf3:bezug[./text() = $bezug]/@link"/></xsl:variable>
												
												<xsl:if test="not($Element/xdf3:bezug[./text() = $bezug])">
													<tr>
														<xsl:choose>
															<xsl:when test="count($Element/xdf3:bezug) = 0 and fn:position() = 1"><td>Handlungsgrundlagen</td></xsl:when>
															<xsl:otherwise><td></td></xsl:otherwise>
														</xsl:choose>
														<td>
															<ul class="hangrun">
																<li>
																	<i>Nicht vorhanden</i>
																</li>
															</ul>
														</td>
														<td class="Ungleich">
															<ul class="hangrun">
																<li>
																	<xsl:value-of select="./text()"/><xsl:if test="not(./@link) or ./@link=''"> ##</xsl:if>
																	<xsl:choose>
																		<xsl:when test="not(./@link) or ./@link=''"></xsl:when>
																		<xsl:when test="$HandlungsgrundlagenLinks = '1'">
																			- <xsl:element name="a">
																				<xsl:attribute name="href"><xsl:value-of select="./@link"/></xsl:attribute>
																				<xsl:attribute name="target">Handlungsgrundlage</xsl:attribute>
																				<xsl:attribute name="title">Springe zum Text der Handlungsgrundlage.</xsl:attribute>
																				<xsl:value-of select="./@link"/>
																			</xsl:element> ##
																		</xsl:when>
																		<xsl:otherwise>
																			- <xsl:value-of select="./@link"/> ##
																		</xsl:otherwise>
																	</xsl:choose>
																</li>
															</ul>
	
														</td>
													</tr>
												</xsl:if>
											</xsl:for-each>

											<tr>
												<td>Feldart <xsl:if test="fn:not(empty($VergleichsElement)) and (fn:not((empty($Element/xdf3:feldart) and empty($VergleichsElement/xdf3:feldart)) or ($Element/xdf3:feldart = $VergleichsElement/xdf3:feldart)))">##</xsl:if></td>
												<td>
													<xsl:apply-templates select="$Element/xdf3:feldart"/>													
												</td>
												<xsl:choose>
													<xsl:when test="empty($VergleichsElement) or (empty($Element/xdf3:feldart) and empty($VergleichsElement/xdf3:feldart)) or ($Element/xdf3:feldart = $VergleichsElement/xdf3:feldart)">
														<td class="Gleich">
															<xsl:apply-templates select="$VergleichsElement/xdf3:feldart"/>
														</td>
													</xsl:when>
													<xsl:otherwise>
														<td class="Ungleich">
															<xsl:apply-templates select="$VergleichsElement/xdf3:feldart"/>
														</td>
													</xsl:otherwise>
												</xsl:choose>
											</tr>
											<tr>
												<td>Datentyp <xsl:if test="fn:not(empty($VergleichsElement)) and (fn:not((empty($Element/xdf3:datentyp) and empty($VergleichsElement/xdf3:datentyp)) or ($Element/xdf3:datentyp = $VergleichsElement/xdf3:datentyp)))">##</xsl:if></td>
												<td>
													<xsl:apply-templates select="$Element/xdf3:datentyp"/>
												</td>
												<xsl:choose>
													<xsl:when test="empty($VergleichsElement) or (empty($Element/xdf3:datentyp) and empty($VergleichsElement/xdf3:datentyp)) or ($Element/xdf3:datentyp = $VergleichsElement/xdf3:datentyp)">
														<td class="Gleich">
															<xsl:apply-templates select="$VergleichsElement/xdf3:datentyp"/>
														</td>
													</xsl:when>
													<xsl:otherwise>
														<td class="Ungleich">
															<xsl:apply-templates select="$VergleichsElement/xdf3:datentyp"/>
														</td>
													</xsl:otherwise>
												</xsl:choose>
											</tr>
											<tr>
												<td>Feldlänge <xsl:if test="fn:not(empty($VergleichsElement)) and fn:concat($Element/xdf3:praezisierung/@minLength,'-',$Element/xdf3:praezisierung/@maxLength) != fn:concat($VergleichsElement/xdf3:praezisierung/@minLength,'-',$VergleichsElement/xdf3:praezisierung/@maxLength)">##</xsl:if></td>
												<td>
													<xsl:if test="$Element/xdf3:praezisierung/@minLength != ''">von <xsl:value-of select="$Element/xdf3:praezisierung/@minLength"/></xsl:if>
													<xsl:if test="$Element/xdf3:praezisierung/@maxLength != ''"> bis <xsl:value-of select="$Element/xdf3:praezisierung/@maxLength"/></xsl:if>
												</td>
												<xsl:choose>
													<xsl:when test="fn:not(empty($VergleichsElement)) and fn:concat($Element/xdf3:praezisierung/@minLength,'-',$Element/xdf3:praezisierung/@maxLength) != fn:concat($VergleichsElement/xdf3:praezisierung/@minLength,'-',$VergleichsElement/xdf3:praezisierung/@maxLength)">
														<td class="Ungleich">
															<xsl:if test="$VergleichsElement/xdf3:praezisierung/@minLength != ''">von <xsl:value-of select="$VergleichsElement/xdf3:praezisierung/@minLength"/></xsl:if>
															<xsl:if test="$VergleichsElement/xdf3:praezisierung/@maxLength != ''"> bis <xsl:value-of select="$VergleichsElement/xdf3:praezisierung/@maxLength"/></xsl:if>
														</td>
													</xsl:when>
													<xsl:otherwise>
														<td class="Gleich">
															<xsl:if test="$VergleichsElement/xdf3:praezisierung/@minLength != ''">von <xsl:value-of select="$VergleichsElement/xdf3:praezisierung/@minLength"/></xsl:if>
															<xsl:if test="$VergleichsElement/xdf3:praezisierung/@maxLength != ''"> bis <xsl:value-of select="$VergleichsElement/xdf3:praezisierung/@maxLength"/></xsl:if>
														</td>
													</xsl:otherwise>
												</xsl:choose>
											</tr>
											<tr>
												<td>Wertebereich <xsl:if test="fn:not(empty($VergleichsElement)) and fn:concat($Element/xdf3:praezisierung/@minValue,'-',$Element/xdf3:praezisierung/@maxValue) != fn:concat($VergleichsElement/xdf3:praezisierung/@minValue,'-',$VergleichsElement/xdf3:praezisierung/@maxValue)">##</xsl:if></td>
												<td>
													<xsl:if test="$Element/xdf3:praezisierung/@minValue != ''">von <xsl:value-of select="$Element/xdf3:praezisierung/@minValue"/></xsl:if>
													<xsl:if test="$Element/xdf3:praezisierung/@maxValue != ''"> bis <xsl:value-of select="$Element/xdf3:praezisierung/@maxValue"/></xsl:if>
												</td>
												<xsl:choose>
													<xsl:when test="fn:not(empty($VergleichsElement)) and fn:concat($Element/xdf3:praezisierung/@minValue,'-',$Element/xdf3:praezisierung/@maxValue) != fn:concat($VergleichsElement/xdf3:praezisierung/@minValue,'-',$VergleichsElement/xdf3:praezisierung/@maxValue)">
														<td class="Ungleich">
															<xsl:if test="$VergleichsElement/xdf3:praezisierung/@minValue != ''">von <xsl:value-of select="$VergleichsElement/xdf3:praezisierung/@minValue"/></xsl:if>
															<xsl:if test="$VergleichsElement/xdf3:praezisierung/@maxValue != ''"> bis <xsl:value-of select="$VergleichsElement/xdf3:praezisierung/@maxValue"/></xsl:if>
														</td>
													</xsl:when>
													<xsl:otherwise>
														<td class="Gleich">
															<xsl:if test="$VergleichsElement/xdf3:praezisierung/@minValue != ''">von <xsl:value-of select="$VergleichsElement/xdf3:praezisierung/@minValue"/></xsl:if>
															<xsl:if test="$VergleichsElement/xdf3:praezisierung/@maxValue != ''"> bis <xsl:value-of select="$VergleichsElement/xdf3:praezisierung/@maxValue"/></xsl:if>
														</td>
													</xsl:otherwise>
												</xsl:choose>
											</tr>
											<tr>
												<td>Pattern <xsl:if test="fn:not(empty($VergleichsElement)) and ($Element/xdf3:praezisierung/@pattern != $VergleichsElement/xdf3:praezisierung/@pattern)">##</xsl:if></td>
												<td><xsl:value-of select="$Element/xdf3:praezisierung/@pattern"/></td>
												<xsl:choose>
													<xsl:when test="fn:not(empty($VergleichsElement)) and ($Element/xdf3:praezisierung/@pattern != $VergleichsElement/xdf3:praezisierung/@pattern)">
														<td class="Ungleich">
															<xsl:value-of select="$VergleichsElement/xdf3:praezisierung/@pattern"/>
														</td>
													</xsl:when>
													<xsl:otherwise>
														<td class="Gleich">
															<xsl:value-of select="$VergleichsElement/xdf3:praezisierung/@pattern"/>
														</td>
													</xsl:otherwise>
												</xsl:choose>
											</tr>
											<xsl:if test="$Element/xdf3:werte">
												<tr>
													<td>Werteliste</td>
													<td colspan="2">
														<table width="100%">
															<tbody>
																<tr>
																	<th width="10%">Code</th>
																	<th width="20%">Name</th>
																	<th width="20%">Hilfe</th>
																	<xsl:choose>
																		<xsl:when test="empty($VergleichsElement)">
																			<th width="10%"></th>
																			<th width="20%"></th>
																			<th width="20%"></th>
																		</xsl:when>
																		<xsl:otherwise>
																			<th width="10%">Code</th>
																			<th width="20%">Name</th>
																			<th width="20%">Hilfe</th>
																		</xsl:otherwise>
																	</xsl:choose>
																</tr>
																<xsl:for-each select="$Element/xdf3:werte/xdf3:wert">
																	<xsl:variable name="codeE" select="./xdf3:code"/>
																	<xsl:variable name="nameE" select="./xdf3:name"/>
																	<xsl:variable name="hilfeE" select="./xdf3:hilfe"/>
																	<xsl:variable name="codeV" select="$VergleichsElement/xdf3:werte/xdf3:wert[./xdf3:code = $codeE]/xdf3:code"/>
																	<xsl:variable name="nameV" select="$VergleichsElement/xdf3:werte/xdf3:wert[./xdf3:code = $codeE]/xdf3:name"/>
																	<xsl:variable name="hilfeV" select="$VergleichsElement/xdf3:werte/xdf3:wert[./xdf3:code = $codeE]/xdf3:hilfe"/>
																	<tr>
																		<td><xsl:value-of select="$codeE"/></td>
																		<td><xsl:value-of select="$nameE"/></td>
																		<td><xsl:value-of select="$hilfeE"/></td>
																		<xsl:choose>
																			<xsl:when test="empty($VergleichsElement)">
																				<td class="Gleich"></td>
																			</xsl:when>
																			<xsl:when test="empty($VergleichsElement/xdf3:werte/xdf3:wert[./xdf3:code = $codeE])">
																				<td class="Ungleich"><i>Nicht vorhanden</i> ##</td>
																			</xsl:when>
																			<xsl:otherwise>
																				<td class="Gleich"><xsl:value-of select="$codeV"/></td>
																			</xsl:otherwise>
																		</xsl:choose>
																		<xsl:choose>
																			<xsl:when test="fn:not(empty($VergleichsElement)) and fn:not(empty($VergleichsElement/xdf3:werte/xdf3:wert[./xdf3:code = $codeE])) and ($nameE != $nameV)">
																				<td class="Ungleich"><xsl:value-of select="$nameV"/> ##</td>
																			</xsl:when>
																			<xsl:otherwise>
																				<td class="Gleich"><xsl:value-of select="$nameV"/></td>
																			</xsl:otherwise>
																		</xsl:choose>
																		<xsl:choose>
																			<xsl:when test="fn:not(empty($VergleichsElement)) and fn:not(empty($VergleichsElement/xdf3:werte/xdf3:wert[./xdf3:code = $codeE])) and ($hilfeE != $hilfeV)">
																				<td class="Ungleich"><xsl:value-of select="$hilfeV"/> ##</td>
																			</xsl:when>
																			<xsl:otherwise>
																				<td class="Gleich"><xsl:value-of select="$hilfeV"/></td>
																			</xsl:otherwise>
																		</xsl:choose>
																	</tr>
																</xsl:for-each>
																<xsl:for-each select="$VergleichsElement/xdf3:werte/xdf3:wert[./xdf3:code != $Element/xdf3:werte/xdf3:wert/xdf3:code]">
																	<xsl:variable name="codeV" select="./xdf3:code"/>
																	<xsl:if test="fn:not($Element/xdf3:werte/xdf3:wert[./xdf3:code = $codeV])">
																		<tr>
																			<td><i>Nicht vorhanden</i></td>
																			<td></td>
																			<td></td>
																			<td class="Ungleich"><xsl:value-of select="./xdf3:code"/> ##</td>
																			<td><xsl:value-of select="./xdf3:name"/></td>
																			<td><xsl:value-of select="./xdf3:hilfe"/></td>
																		</tr>
																	</xsl:if>
																</xsl:for-each>
															</tbody>
														</table>
													</td>
												</tr>
											</xsl:if>
											<xsl:if test="$Element/xdf3:codelisteReferenz">
												<tr>
													<td>Referenzierte Codeliste <xsl:if test="fn:not(empty($VergleichsElement)) and (fn:concat($Element/xdf3:codelisteReferenz/xdf3:canonicalIdentification,'-',$Element/xdf3:codelisteReferenz/xdf3:version) != fn:concat($VergleichsElement/xdf3:codelisteReferenz/xdf3:canonicalIdentification,'-',$VergleichsElement/xdf3:codelisteReferenz/xdf3:version))">##</xsl:if></td>
													<td>
														<xsl:element name="a">
															<xsl:attribute name="href">#<xsl:value-of select="$Element/xdf3:codelisteReferenz/xdf3:canonicalIdentification"/><xsl:if test="$Element/xdf3:codelisteReferenz/xdf3:version">_<xsl:value-of select="$Element/xdf3:codelisteReferenz/xdf3:version"/></xsl:if></xsl:attribute>
															<xsl:value-of select="$Element/xdf3:codelisteReferenz/xdf3:canonicalIdentification"/>
															<xsl:if test="$Element/xdf3:codelisteReferenz/xdf3:version">_<xsl:value-of select="$Element/xdf3:codelisteReferenz/xdf3:version"/>
															</xsl:if>
														</xsl:element>
													</td>
													<xsl:choose>
														<xsl:when test="fn:not(empty($VergleichsElement)) and (fn:concat($Element/xdf3:codelisteReferenz/xdf3:canonicalIdentification,'-',$Element/xdf3:codelisteReferenz/xdf3:version) != fn:concat($VergleichsElement/xdf3:codelisteReferenz/xdf3:canonicalIdentification,'-',$VergleichsElement/xdf3:codelisteReferenz/xdf3:version))">
															<td class="Ungleich">
																<xsl:element name="a">
																	<xsl:attribute name="href">#<xsl:value-of select="$VergleichsElement/xdf3:codelisteReferenz/xdf3:canonicalIdentification"/><xsl:if test="$VergleichsElement/xdf3:codelisteReferenz/xdf3:version">_<xsl:value-of select="$VergleichsElement/xdf3:codelisteReferenz/xdf3:version"/></xsl:if></xsl:attribute>
																	<xsl:value-of select="$VergleichsElement/xdf3:codelisteReferenz/xdf3:canonicalIdentification"/>
																	<xsl:if test="$VergleichsElement/xdf3:codelisteReferenz/xdf3:version">_<xsl:value-of select="$VergleichsElement/xdf3:codelisteReferenz/xdf3:version"/>
																	</xsl:if>
																</xsl:element>
															</td>
														</xsl:when>
														<xsl:otherwise>
															<td class="Gleich">
																<xsl:element name="a">
																	<xsl:attribute name="href">#<xsl:value-of select="$VergleichsElement/xdf3:codelisteReferenz/xdf3:canonicalIdentification"/><xsl:if test="$VergleichsElement/xdf3:codelisteReferenz/xdf3:version">_<xsl:value-of select="$Element/xdf3:codelisteReferenz/xdf3:version"/></xsl:if></xsl:attribute>
																	<xsl:value-of select="$VergleichsElement/xdf3:codelisteReferenz/xdf3:canonicalIdentification"/>
																	<xsl:if test="$VergleichsElement/xdf3:codelisteReferenz/xdf3:version">_<xsl:value-of select="$VergleichsElement/xdf3:codelisteReferenz/xdf3:version"/>
																	</xsl:if>
																</xsl:element>
															</td>
														</xsl:otherwise>
													</xsl:choose>
												</tr>
												<tr>
													<td>Spaltendefinitionen zur referenzierten Codeliste</td>
													<td colspan="2">
														<xsl:if test="$Element/xdf3:codeKey/text() !='' or $Element/xdf3:nameKey/text() !='' or $Element/xdf3:helpKey/text() !=''">
															<table width="100%">
																<tbody>
																	<tr>
																		<th width="25%">Spaltentyp</th>
																		<th width="25%">Spalte in der referenzierten Codeliste</th>
																		<xsl:choose>
																			<xsl:when test="empty($VergleichsElement)">
																				<th width="25%"></th>
																				<th width="25%"></th>
																			</xsl:when>
																			<xsl:otherwise>
																				<th width="25%">Spaltentyp</th>
																				<th width="25%">Spalte in der referenzierten Codeliste</th>
																			</xsl:otherwise>
																		</xsl:choose>
																	</tr>
																	<tr>
																		<td>Code</td>
																		<xsl:choose>
																			<xsl:when test="(fn:not($Element/xdf3:codeKey) or $Element/xdf3:codeKey = '') and ($VergleichsElement/xdf3:codeKey and $VergleichsElement/xdf3:codeKey != '')">
																				<td><i>Nicht vorhanden</i></td>
																			</xsl:when>
																			<xsl:otherwise>
																				<td><xsl:value-of select="$Element/xdf3:codeKey"/></td>
																			</xsl:otherwise>
																		</xsl:choose>
																		<xsl:if test="fn:not(empty($VergleichsElement))">
																			<td>Code</td>
																		</xsl:if>
																		<xsl:choose>
																			<xsl:when test="$Element/xdf3:codeKey = $VergleichsElement/xdf3:codeKey">
																				<td class="Gleich"><xsl:value-of select="$VergleichsElement/xdf3:codeKey"/></td>
																			</xsl:when>
																			<xsl:when test="empty($VergleichsElement) or ((fn:not($Element/xdf3:codeKey) or $Element/xdf3:codeKey = '') and (fn:not($VergleichsElement/xdf3:codeKey) or $VergleichsElement/xdf3:codeKey = ''))">
																				<td class="Gleich"></td>
																			</xsl:when>
																			<xsl:when test="($Element/xdf3:codeKey and $Element/xdf3:codeKey != '') and (fn:not($VergleichsElement/xdf3:codeKey) or $VergleichsElement/xdf3:codeKey = '')">
																				<td class="Ungleich"><i>Nicht vorhanden</i> ##</td>
																			</xsl:when>
																			<xsl:otherwise>
																				<td class="Ungleich"><xsl:value-of select="$VergleichsElement/xdf3:codeKey"/> ##</td>
																			</xsl:otherwise>
																		</xsl:choose>
																	</tr>
																	<tr>
																		<td>Name</td>
																		<xsl:choose>
																			<xsl:when test="(fn:not($Element/xdf3:nameKey) or $Element/xdf3:nameKey = '') and ($VergleichsElement/xdf3:nameKey and $VergleichsElement/xdf3:nameKey != '')">
																				<td><i>Nicht vorhanden</i></td>
																			</xsl:when>
																			<xsl:otherwise>
																				<td><xsl:value-of select="$Element/xdf3:nameKey"/></td>
																			</xsl:otherwise>
																		</xsl:choose>
																		<xsl:if test="fn:not(empty($VergleichsElement))">
																			<td>Name</td>
																		</xsl:if>
																		<xsl:choose>
																			<xsl:when test="$Element/xdf3:nameKey = $VergleichsElement/xdf3:nameKey">
																				<td class="Gleich"><xsl:value-of select="$VergleichsElement/xdf3:nameKey"/></td>
																			</xsl:when>
																			<xsl:when test="empty($VergleichsElement) or ((fn:not($Element/xdf3:nameKey) or $Element/xdf3:nameKey = '') and (fn:not($VergleichsElement/xdf3:nameKey) or $VergleichsElement/xdf3:nameKey = ''))">
																				<td class="Gleich"></td>
																			</xsl:when>
																			<xsl:when test="($Element/xdf3:nameKey and $Element/xdf3:nameKey != '') and (fn:not($VergleichsElement/xdf3:nameKey) or $VergleichsElement/xdf3:nameKey = '')">
																				<td class="Ungleich"><i>Nicht vorhanden</i> ##</td>
																			</xsl:when>
																			<xsl:otherwise>
																				<td class="Ungleich"><xsl:value-of select="$VergleichsElement/xdf3:nameKey"/> ##</td>
																			</xsl:otherwise>
																		</xsl:choose>
																	</tr>
																	<tr>
																		<td>Hilfetext</td>
																		<xsl:choose>
																			<xsl:when test="(fn:not($Element/xdf3:helpKey) or $Element/xdf3:helpKey = '') and ($VergleichsElement/xdf3:helpKey and $VergleichsElement/xdf3:helpKey != '')">
																				<td><i>Nicht vorhanden</i></td>
																			</xsl:when>
																			<xsl:otherwise>
																				<td><xsl:value-of select="$Element/xdf3:helpKey"/></td>
																			</xsl:otherwise>
																		</xsl:choose>
																		<xsl:if test="not(empty($VergleichsElement))">
																			<td>Hilfetext</td>
																		</xsl:if>
																		<xsl:choose>
																			<xsl:when test="$Element/xdf3:helpKey = $VergleichsElement/xdf3:helpKey">
																				<td class="Gleich"><xsl:value-of select="$VergleichsElement/xdf3:helpKey"/></td>
																			</xsl:when>
																			<xsl:when test="empty($VergleichsElement) or ((fn:not($Element/xdf3:helpKey) or $Element/xdf3:helpKey = '') and (fn:not($VergleichsElement/xdf3:helpKey) or $VergleichsElement/xdf3:helpKey = ''))">
																				<td class="Gleich"></td>
																			</xsl:when>
																			<xsl:when test="($Element/xdf3:helpKey and $Element/xdf3:helpKey != '') and (fn:not($VergleichsElement/xdf3:helpKey) or $VergleichsElement/xdf3:helpKey = '')">
																				<td class="Ungleich"><i>Nicht vorhanden</i> ##</td>
																			</xsl:when>
																			<xsl:otherwise>
																				<td class="Ungleich"><xsl:value-of select="$VergleichsElement/xdf3:helpKey"/> ##</td>
																			</xsl:otherwise>
																		</xsl:choose>
																	</tr>
																</tbody>
															</table>
														</xsl:if>
													</td>
												</tr>
											</xsl:if>
											<tr>
												<td>Inhalt <xsl:if test="fn:not(empty($VergleichsElement)) and (fn:not((empty($Element/xdf3:inhalt) and empty($VergleichsElement/xdf3:inhalt)) or ($Element/xdf3:inhalt = $VergleichsElement/xdf3:inhalt)))">##</xsl:if></td>
												<td>
													<xsl:value-of select="fn:replace($Element/xdf3:inhalt,'\n','&lt;br/&gt;')" disable-output-escaping="yes"/>
												</td>
												<xsl:choose>
													<xsl:when test="empty($VergleichsElement) or (empty($Element/xdf3:inhalt) and empty($VergleichsElement/xdf3:inhalt)) or ($Element/xdf3:inhalt = $VergleichsElement/xdf3:inhalt)">
														<td class="Gleich">
															<xsl:value-of select="fn:replace($VergleichsElement/xdf3:inhalt,'\n','&lt;br/&gt;')" disable-output-escaping="yes"/>
														</td>
													</xsl:when>
													<xsl:otherwise>
														<td class="Ungleich">
															<xsl:value-of select="fn:replace($VergleichsElement/xdf3:inhalt,'\n','&lt;br/&gt;')" disable-output-escaping="yes"/>
														</td>
													</xsl:otherwise>
												</xsl:choose>
											</tr>
											<tr>
												<td>Maximale Dateigröße <xsl:if test="fn:not(empty($VergleichsElement)) and (fn:not((empty($Element/xdf3:maxSize) and empty($VergleichsElement/xdf3:maxSize)) or ($Element/xdf3:maxSize = $VergleichsElement/xdf3:maxSize)))">##</xsl:if></td>
												<xsl:choose>
													<xsl:when test="empty($Element/xdf3:maxSize/text())">
														<td>
														</td>
													</xsl:when>
													<xsl:otherwise>
														<td>
															<xsl:value-of select="fn:format-number(number($Element/xdf3:maxSize) div 1000000,'###.###,00', 'european')"/> MB
														</td>
													</xsl:otherwise>
												</xsl:choose>
												<xsl:choose>
													<xsl:when test="empty($VergleichsElement)">
														<td class="Gleich">
														</td>
													</xsl:when>
													<xsl:when test="fn:not(empty($Element/xdf3:maxSize)) and empty($VergleichsElement/xdf3:maxSize)">
														<td class="Ungleich">
														</td>
													</xsl:when>
													<xsl:when test="empty($Element/xdf3:maxSize) and empty($VergleichsElement/xdf3:maxSize)">
														<td class="Gleich">
														</td>
													</xsl:when>
													<xsl:when test="($Element/xdf3:maxSize = $VergleichsElement/xdf3:maxSize)">
														<td class="Gleich">
															<xsl:value-of select="fn:format-number(number($VergleichsElement/xdf3:maxSize) div 1000000,'###.###,00', 'european')"/> MB
														</td>
													</xsl:when>
													<xsl:otherwise>
														<td class="Ungleich">
															<xsl:value-of select="fn:format-number(number($VergleichsElement/xdf3:maxSize) div 1000000,'###.###,00', 'european')"/> MB
														</td>
													</xsl:otherwise>
												</xsl:choose>
											</tr>
											<xsl:if test="count($Element/xdf3:mediaType) = 0 and count($VergleichsElement/xdf3:mediaType) = 0">
												<tr>
													<td>Erlaubte Dateitypen</td>
													<td></td>
													<td></td>
												</tr>
											</xsl:if>
											<xsl:for-each select="$Element/xdf3:mediaType">
												<xsl:variable name="mediaType" select="."/>
												
												<tr>
													<xsl:choose>
														<xsl:when test="fn:position() = 1"><td>Erlaubte Dateitypen</td></xsl:when>
														<xsl:otherwise><td></td></xsl:otherwise>
													</xsl:choose>
													<td>
														<ul class="hangrun">
															<li>
																<xsl:value-of select="."/>
															</li>
														</ul>
													</td>
													<xsl:choose>
														<xsl:when test="empty($VergleichsElement)">
															<td class="Gleich">
																<ul class="hangrun">
																</ul>
															</td>
														</xsl:when>
														<xsl:when test="empty($VergleichsElement/xdf3:mediaType[. = $mediaType])">
															<td class="Ungleich">
																<ul class="hangrun">
																	<li><i>Nicht vorhanden</i> ##</li>
																</ul>
															</td>
														</xsl:when>
														<xsl:otherwise>
															<td class="Gleich">
																<ul class="hangrun">
																	<li>
																		<xsl:value-of select="$VergleichsElement/xdf3:mediaType[. = $mediaType]"/>
																	</li>
																</ul>
															</td>
														</xsl:otherwise>
													</xsl:choose>
												</tr>
											</xsl:for-each>
											<xsl:for-each select="$VergleichsElement/xdf3:mediaType">
												<xsl:variable name="mediaType" select="."/>
												<xsl:if test="empty($Element/xdf3:mediaType[. = $mediaType])">
													<tr>
														<xsl:choose>
															<xsl:when test="count($Element/xdf3:mediaType) = 0 and fn:position() = 1"><td>Erlaubte Dateitypen</td></xsl:when>
															<xsl:otherwise><td></td></xsl:otherwise>
														</xsl:choose>
														<td>
															<ul class="hangrun">
																<li>
																	<i>Nicht vorhanden</i>
																</li>
															</ul>
														</td>
														<td class="Ungleich">
															<ul class="hangrun">
																<li>
																	<xsl:value-of select="./text()"/> ##
																</li>
															</ul>
	
														</td>
													</tr>
												</xsl:if>
											</xsl:for-each>
											<tr>
												<td>Vorbefüllung <xsl:if test="fn:not(empty($VergleichsElement)) and (fn:not((empty($Element/xdf3:vorbefuellung) and empty($VergleichsElement/xdf3:vorbefuellung)) or ($Element/xdf3:vorbefuellung = $VergleichsElement/xdf3:vorbefuellung)))">##</xsl:if></td>
												<td>
													<xsl:apply-templates select="$Element/xdf3:vorbefuellung"/>
												</td>
												<xsl:choose>
													<xsl:when test="empty($VergleichsElement) or (empty($Element/xdf3:vorbefuellung) and empty($VergleichsElement/xdf3:vorbefuellung)) or ($Element/xdf3:vorbefuellung = $VergleichsElement/xdf3:vorbefuellung)">
														<td class="Gleich">
															<xsl:apply-templates select="$VergleichsElement/xdf3:vorbefuellung"/>
														</td>
													</xsl:when>
													<xsl:otherwise>
														<td class="Ungleich">
															<xsl:apply-templates select="$VergleichsElement/xdf3:vorbefuellung"/>
														</td>
													</xsl:otherwise>
												</xsl:choose>
											</tr>
											<tr>
												<td>Beschreibung <xsl:if test="fn:not(empty($VergleichsElement)) and (fn:not((empty($Element/xdf3:beschreibung) and empty($VergleichsElement/xdf3:beschreibung)) or ($Element/xdf3:beschreibung = $VergleichsElement/xdf3:beschreibung)))">##</xsl:if></td>
												<td>
													<xsl:value-of select="fn:replace($Element/xdf3:beschreibung,'\n','&lt;br/&gt;')" disable-output-escaping="yes"/>
												</td>
												<xsl:choose>
													<xsl:when test="empty($VergleichsElement) or (empty($Element/xdf3:beschreibung) and empty($VergleichsElement/xdf3:beschreibung)) or ($Element/xdf3:beschreibung = $VergleichsElement/xdf3:beschreibung)">
														<td class="Gleich">
															<xsl:value-of select="fn:replace($VergleichsElement/xdf3:beschreibung,'\n','&lt;br/&gt;')" disable-output-escaping="yes"/>
														</td>
													</xsl:when>
													<xsl:otherwise>
														<td class="Ungleich">
															<xsl:value-of select="fn:replace($VergleichsElement/xdf3:beschreibung,'\n','&lt;br/&gt;')" disable-output-escaping="yes"/>
														</td>
													</xsl:otherwise>
												</xsl:choose>
											</tr>
											<tr>
												<td>Bezeichnung Eingabe <xsl:if test="fn:not(empty($VergleichsElement)) and (fn:not((empty($Element/xdf3:bezeichnungEingabe) and empty($VergleichsElement/xdf3:bezeichnungEingabe)) or ($Element/xdf3:bezeichnungEingabe = $VergleichsElement/xdf3:bezeichnungEingabe)))">##</xsl:if></td>
												<xsl:choose>
													<xsl:when test="empty($Element/xdf3:bezeichnungEingabe/text())">
														<td>
														</td>
													</xsl:when>
													<xsl:otherwise>
														<td>
															<xsl:value-of select="$Element/xdf3:bezeichnungEingabe"/>
														</td>
													</xsl:otherwise>
												</xsl:choose>
												<xsl:choose>
													<xsl:when test="empty($VergleichsElement) or (empty($Element/xdf3:bezeichnungEingabe) and empty($VergleichsElement/xdf3:bezeichnungEingabe)) or ($Element/xdf3:bezeichnungEingabe = $VergleichsElement/xdf3:bezeichnungEingabe)">
														<td class="Gleich">
															<xsl:value-of select="$VergleichsElement/xdf3:bezeichnungEingabe"/>
														</td>
													</xsl:when>
													<xsl:otherwise>
														<td class="Ungleich">
															<xsl:value-of select="$VergleichsElement/xdf3:bezeichnungEingabe"/>
														</td>
													</xsl:otherwise>
												</xsl:choose>
											</tr>
											<tr>
												<td>Bezeichnung Ausgabe <xsl:if test="fn:not(empty($VergleichsElement)) and (fn:not((empty($Element/xdf3:bezeichnungAusgabe) and empty($VergleichsElement/xdf3:bezeichnungAusgabe)) or ($Element/xdf3:bezeichnungAusgabe = $VergleichsElement/xdf3:bezeichnungAusgabe)))">##</xsl:if></td>
												<xsl:choose>
													<xsl:when test="empty($Element/xdf3:bezeichnungAusgabe/text())">
														<td>
														</td>
													</xsl:when>
													<xsl:otherwise>
														<td>
															<xsl:value-of select="$Element/xdf3:bezeichnungAusgabe"/>
														</td>
													</xsl:otherwise>
												</xsl:choose>
												<xsl:choose>
													<xsl:when test="empty($VergleichsElement) or (empty($Element/xdf3:bezeichnungAusgabe) and empty($VergleichsElement/xdf3:bezeichnungAusgabe)) or ($Element/xdf3:bezeichnungAusgabe = $VergleichsElement/xdf3:bezeichnungAusgabe)">
														<td class="Gleich">
															<xsl:value-of select="$VergleichsElement/xdf3:bezeichnungAusgabe"/>
														</td>
													</xsl:when>
													<xsl:otherwise>
														<td class="Ungleich">
															<xsl:value-of select="$VergleichsElement/xdf3:bezeichnungAusgabe"/>
														</td>
													</xsl:otherwise>
												</xsl:choose>
											</tr>
											<tr>
												<td>Hilfetext Eingabe <xsl:if test="fn:not(empty($VergleichsElement)) and (fn:not((empty($Element/xdf3:hilfetextEingabe) and empty($VergleichsElement/xdf3:hilfetextEingabe)) or ($Element/xdf3:hilfetextEingabe = $VergleichsElement/xdf3:hilfetextEingabe)))">##</xsl:if></td>
												<td>
													<xsl:value-of select="fn:replace($Element/xdf3:hilfetextEingabe,'\n','&lt;br/&gt;')" disable-output-escaping="yes"/>
												</td>
												<xsl:choose>
													<xsl:when test="empty($VergleichsElement) or (empty($Element/xdf3:hilfetextEingabe) and empty($VergleichsElement/xdf3:hilfetextEingabe)) or ($Element/xdf3:hilfetextEingabe = $VergleichsElement/xdf3:hilfetextEingabe)">
														<td class="Gleich">
															<xsl:value-of select="fn:replace($VergleichsElement/xdf3:hilfetextEingabe,'\n','&lt;br/&gt;')" disable-output-escaping="yes"/>
														</td>
													</xsl:when>
													<xsl:otherwise>
														<td class="Ungleich">
															<xsl:value-of select="fn:replace($VergleichsElement/xdf3:hilfetextEingabe,'\n','&lt;br/&gt;')" disable-output-escaping="yes"/>
														</td>
													</xsl:otherwise>
												</xsl:choose>
											</tr>
											<tr>
												<td>Hilfetext Ausgabe <xsl:if test="fn:not(empty($VergleichsElement)) and (fn:not((empty($Element/xdf3:hilfetextAusgabe) and empty($VergleichsElement/xdf3:hilfetextAusgabe)) or ($Element/xdf3:hilfetextAusgabe = $VergleichsElement/xdf3:hilfetextAusgabe)))">##</xsl:if></td>
												<td>
													<xsl:value-of select="fn:replace($Element/xdf3:hilfetextAusgabe,'\n','&lt;br/&gt;')" disable-output-escaping="yes"/>
												</td>
												<xsl:choose>
													<xsl:when test="empty($VergleichsElement) or (empty($Element/xdf3:hilfetextAusgabe) and empty($VergleichsElement/xdf3:hilfetextAusgabe)) or ($Element/xdf3:hilfetextAusgabe = $VergleichsElement/xdf3:hilfetextAusgabe)">
														<td class="Gleich">
															<xsl:value-of select="fn:replace($VergleichsElement/xdf3:hilfetextAusgabe,'\n','&lt;br/&gt;')" disable-output-escaping="yes"/>
														</td>
													</xsl:when>
													<xsl:otherwise>
														<td class="Ungleich">
															<xsl:value-of select="fn:replace($VergleichsElement/xdf3:hilfetextAusgabe,'\n','&lt;br/&gt;')" disable-output-escaping="yes"/>
														</td>
													</xsl:otherwise>
												</xsl:choose>
											</tr>

											<tr>
												<td>Gültig ab <xsl:if test="fn:not(empty($VergleichsElement)) and fn:not((empty($Element/xdf3:gueltigAb) and empty($VergleichsElement/xdf3:gueltigAb)) or ($Element/xdf3:gueltigAb = $VergleichsElement/xdf3:gueltigAb))">##</xsl:if></td>
												<td>
													<xsl:value-of select="fn:format-date($Element/xdf3:gueltigAb,'[D01].[M01].[Y0001]')"/>
												</td>
												<xsl:choose>
													<xsl:when test="empty($VergleichsElement) or (empty($Element/xdf3:gueltigAb) and empty($VergleichsElement/xdf3:gueltigAb)) or ($Element/xdf3:gueltigAb = $VergleichsElement/xdf3:gueltigAb)">
														<td class="Gleich">
															<xsl:value-of select="fn:format-date($VergleichsElement/xdf3:gueltigAb,'[D01].[M01].[Y0001]')"/>
														</td>
													</xsl:when>
													<xsl:otherwise>
														<td class="Ungleich">
															<xsl:value-of select="fn:format-date($VergleichsElement/xdf3:gueltigAb,'[D01].[M01].[Y0001]')"/>
														</td>
													</xsl:otherwise>
												</xsl:choose>
											</tr>
											<tr>
												<td>Gültig bis <xsl:if test="fn:not(empty($VergleichsElement)) and fn:not((empty($Element/xdf3:gueltigBis) and empty($VergleichsElement/xdf3:gueltigBis)) or ($Element/xdf3:gueltigBis = $VergleichsElement/xdf3:gueltigBis))">##</xsl:if></td>
												<td>
													<xsl:value-of select="fn:format-date($Element/xdf3:gueltigBis,'[D01].[M01].[Y0001]')"/>
												</td>
												<xsl:choose>
													<xsl:when test="empty($VergleichsElement) or (empty($Element/xdf3:gueltigBis) and empty($VergleichsElement/xdf3:gueltigBis)) or ($Element/xdf3:gueltigBis = $VergleichsElement/xdf3:gueltigBis)">
														<td class="Gleich">
															<xsl:value-of select="fn:format-date($VergleichsElement/xdf3:gueltigBis,'[D01].[M01].[Y0001]')"/>
														</td>
													</xsl:when>
													<xsl:otherwise>
														<td class="Ungleich">
															<xsl:value-of select="fn:format-date($VergleichsElement/xdf3:gueltigBis,'[D01].[M01].[Y0001]')"/>
														</td>
													</xsl:otherwise>
												</xsl:choose>
											</tr>
											<tr>
												<td>Fachlicher Ersteller <xsl:if test="fn:not(empty($VergleichsElement)) and fn:not((empty($Element/xdf3:statusGesetztDurch) and empty($VergleichsElement/xdf3:statusGesetztDurch)) or ($Element/xdf3:statusGesetztDurch = $VergleichsElement/xdf3:statusGesetztDurch))">##</xsl:if></td>
												<td>
													<xsl:value-of select="$Element/xdf3:statusGesetztDurch"/>
												</td>
												<xsl:choose>
													<xsl:when test="empty($VergleichsElement) or (empty($Element/xdf3:statusGesetztDurch) and empty($VergleichsElement/xdf3:statusGesetztDurch)) or ($Element/xdf3:statusGesetztDurch = $VergleichsElement/xdf3:statusGesetztDurch)">
														<td class="Gleich">
															<xsl:value-of select="$VergleichsElement/xdf3:statusGesetztDurch"/>
														</td>
													</xsl:when>
													<xsl:otherwise>
														<td class="Ungleich">
															<xsl:value-of select="$VergleichsElement/xdf3:statusGesetztDurch"/>
														</td>
													</xsl:otherwise>
												</xsl:choose>
											</tr>
											<tr>
												<td>Status <xsl:if test="fn:not(empty($VergleichsElement)) and fn:not((empty($Element/xdf3:freigabestatus) and empty($VergleichsElement/xdf3:freigabestatus)) or ($Element/xdf3:freigabestatus = $VergleichsElement/xdf3:freigabestatus))">##</xsl:if></td>
												<td>
													<xsl:apply-templates select="$Element/xdf3:freigabestatus"/>
												</td>
												<xsl:choose>
													<xsl:when test="empty($VergleichsElement) or (empty($Element/xdf3:freigabestatus) and empty($VergleichsElement/xdf3:freigabestatus)) or ($Element/xdf3:freigabestatus = $VergleichsElement/xdf3:freigabestatus)">
														<td class="Gleich">
															<xsl:apply-templates select="$VergleichsElement/xdf3:freigabestatus"/>
														</td>
													</xsl:when>
													<xsl:otherwise>
														<td class="Ungleich">
															<xsl:apply-templates select="$VergleichsElement/xdf3:freigabestatus"/>
														</td>
													</xsl:otherwise>
												</xsl:choose>
											</tr>
											<tr>
												<td>Status gesetzt am <xsl:if test="fn:not(empty($VergleichsElement)) and fn:not((empty($Element/xdf3:statusGesetztAm) and empty($VergleichsElement/xdf3:statusGesetztAm)) or ($Element/xdf3:statusGesetztAm = $VergleichsElement/xdf3:statusGesetztAm))">##</xsl:if></td>
												<td>
													<xsl:value-of select="fn:format-date($Element/xdf3:statusGesetztAm,'[D01].[M01].[Y0001]')"/>
												</td>
												<xsl:choose>
													<xsl:when test="empty($VergleichsElement) or (empty($Element/xdf3:statusGesetztAm) and empty($VergleichsElement/xdf3:statusGesetztAm)) or ($Element/xdf3:statusGesetztAm = $VergleichsElement/xdf3:statusGesetztAm)">
														<td class="Gleich">
															<xsl:value-of select="fn:format-date($VergleichsElement/xdf3:statusGesetztAm,'[D01].[M01].[Y0001]')"/>
														</td>
													</xsl:when>
													<xsl:otherwise>
														<td class="Ungleich">
															<xsl:value-of select="fn:format-date($VergleichsElement/xdf3:statusGesetztAm,'[D01].[M01].[Y0001]')"/>
														</td>
													</xsl:otherwise>
												</xsl:choose>
											</tr>
											<tr>
												<td>Veröffentlichungsdatum <xsl:if test="fn:not(empty($VergleichsElement)) and fn:not((empty($Element/xdf3:veroeffentlichungsdatum) and empty($VergleichsElement/xdf3:veroeffentlichungsdatum)) or ($Element/xdf3:veroeffentlichungsdatum = $VergleichsElement/xdf3:veroeffentlichungsdatum))">##</xsl:if></td>
												<td>
													<xsl:value-of select="fn:format-date($Element/xdf3:veroeffentlichungsdatum,'[D01].[M01].[Y0001]')"/>
												</td>
												<xsl:choose>
													<xsl:when test="empty($VergleichsElement) or (empty($Element/xdf3:veroeffentlichungsdatum) and empty($VergleichsElement/xdf3:veroeffentlichungsdatum)) or ($Element/xdf3:veroeffentlichungsdatum = $VergleichsElement/xdf3:veroeffentlichungsdatum)">
														<td class="Gleich">
															<xsl:value-of select="fn:format-date($VergleichsElement/xdf3:veroeffentlichungsdatum,'[D01].[M01].[Y0001]')"/>
														</td>
													</xsl:when>
													<xsl:otherwise>
														<td class="Ungleich">
															<xsl:value-of select="fn:format-date($VergleichsElement/xdf3:veroeffentlichungsdatum,'[D01].[M01].[Y0001]')"/>
														</td>
													</xsl:otherwise>
												</xsl:choose>
											</tr>
											<tr>
												<td>Letzte Änderung <xsl:if test="fn:not(empty($VergleichsElement)) and fn:not((empty($Element/xdf3:letzteAenderung) and empty($VergleichsElement/xdf3:letzteAenderung)) or ($Element/xdf3:letzteAenderung = $VergleichsElement/xdf3:letzteAenderung))">##</xsl:if></td>
												<td>
													<xsl:value-of select="fn:format-dateTime($Element/xdf3:letzteAenderung,'[D01].[M01].[Y0001] um [H01]:[m01] Uhr')"/>
												</td>
												<xsl:choose>
													<xsl:when test="empty($VergleichsElement) or (empty($Element/xdf3:letzteAenderung) and empty($VergleichsElement/xdf3:letzteAenderung)) or ($Element/xdf3:letzteAenderung = $VergleichsElement/xdf3:letzteAenderung)">
														<td class="Gleich">
															<xsl:value-of select="fn:format-dateTime($VergleichsElement/xdf3:letzteAenderung,'[D01].[M01].[Y0001] um [H01]:[m01] Uhr')"/>
														</td>
													</xsl:when>
													<xsl:otherwise>
														<td class="Ungleich">
															<xsl:value-of select="fn:format-dateTime($VergleichsElement/xdf3:letzteAenderung,'[D01].[M01].[Y0001] um [H01]:[m01] Uhr')"/>
														</td>
													</xsl:otherwise>
												</xsl:choose>
											</tr>

											<xsl:if test="count($Element/xdf3:regel) or count($VergleichsElement/xdf3:regel)">
												<tr>
													<td>
														<b>Regeln</b>
													</td>
													<td colspan="2">
														<table width="100%">
															<thead>
																<tr>
																	<th width="5%">ID</th>
																	<th width="5%">Version</th>
																	<th width="18%">Name</th>
																	<th width="22%">Freitextregel</th>
																	<xsl:choose>
																		<xsl:when test="empty($VergleichsElement)">
																			<th width="5%"></th>
																			<th width="5%"></th>
																			<th width="18%"></th>
																			<th width="22%"></th>
																		</xsl:when>
																		<xsl:otherwise>
																			<th width="5%">ID</th>
																			<th width="5%">Version</th>
																			<th width="18%">Name</th>
																			<th width="22%">Freitextregel</th>
																		</xsl:otherwise>
																	</xsl:choose>
																</tr>
															</thead>
															<tbody>
																<xsl:for-each select="$Element/xdf3:regel">

																	<xsl:variable name="UnterelementA" select="."/>
																	<xsl:variable name="UnterelementO" select="$VergleichsElement/xdf3:regel[xdf3:identifikation/xdf3:id = $UnterelementA/xdf3:identifikation/xdf3:id]"/>

																	<tr>
																		<td>
																			<xsl:choose>
																				<xsl:when test="$RegelDetails = '1'">
																					<xsl:element name="a">
																						<xsl:attribute name="href">#<xsl:value-of select="./xdf3:identifikation/xdf3:id"/></xsl:attribute>
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
																			<xsl:value-of select="./xdf3:freitextRegel"/>
																		</td>
																		<xsl:choose>
																			<xsl:when test="empty($VergleichsElement)">
																				<td colspan="4">
																				</td>
																			</xsl:when>
																			<xsl:when test="empty($UnterelementO)">
																				<td colspan="4" class="Ungleich">
																					<i>Nicht vorhanden</i> ##
																				</td>
																			</xsl:when>
																			<xsl:otherwise>
																				<td>
																					<xsl:choose>
																						<xsl:when test="$RegelDetails = '1'">
																							<xsl:element name="a">
																								<xsl:attribute name="href">#X<xsl:value-of select="$UnterelementO/xdf3:identifikation/xdf3:id"/></xsl:attribute>
																								<xsl:value-of select="$UnterelementO/xdf3:identifikation/xdf3:id"/>
																							</xsl:element>
																						</xsl:when>
																						<xsl:otherwise>
																							<xsl:value-of select="$UnterelementO/xdf3:identifikation/xdf3:id"/>
																						</xsl:otherwise>
																					</xsl:choose>
																				</td>
																				<xsl:choose>
																					<xsl:when test="(empty($UnterelementO/xdf3:identifikation/xdf3:version) and empty($UnterelementA/xdf3:identifikation/xdf3:version)) or ($UnterelementO/xdf3:identifikation/xdf3:version = $UnterelementA/xdf3:identifikation/xdf3:version)">
																						<td class="Gleich">
																							<xsl:value-of select="$UnterelementO/xdf3:identifikation/xdf3:version"/>
																						</td>
																					</xsl:when>
																					<xsl:otherwise>
																						<td class="Ungleich">
																							<xsl:value-of select="$UnterelementO/xdf3:identifikation/xdf3:version"/>
																						</td>
																					</xsl:otherwise>
																				</xsl:choose>
																				<xsl:choose>
																					<xsl:when test="(empty($UnterelementO/xdf3:name) and empty($UnterelementA/xdf3:name)) or ($UnterelementO/xdf3:name = $UnterelementA/xdf3:name)">
																						<td class="Gleich">
																							<xsl:value-of select="$UnterelementO/xdf3:name"/><xsl:if test="($UnterelementO/xdf3:identifikation/xdf3:version != $UnterelementA/xdf3:identifikation/xdf3:version) or ($UnterelementO/xdf3:name != $UnterelementA/xdf3:name) or ($UnterelementO/xdf3:definition != $UnterelementA/xdf3:definition)"> ##</xsl:if>
																						</td>
																					</xsl:when>
																					<xsl:otherwise>
																						<td class="Ungleich">
																							<xsl:value-of select="$UnterelementO/xdf3:name"/><xsl:if test="($UnterelementO/xdf3:identifikation/xdf3:version != $UnterelementA/xdf3:identifikation/xdf3:version) or ($UnterelementO/xdf3:name != $UnterelementA/xdf3:name) or ($UnterelementO/xdf3:definition != $UnterelementA/xdf3:definition)"> ##</xsl:if>
																						</td>
																					</xsl:otherwise>
																				</xsl:choose>
																				<xsl:choose>
																					<xsl:when test="(empty($UnterelementO/xdf3:freitextRegel) and empty($UnterelementA/xdf3:freitextRegel)) or ($UnterelementO/xdf3:freitextRegel = $UnterelementA/xdf3:freitextRegel)">
																						<td class="Gleich">
																							<xsl:value-of select="$UnterelementO/xdf3:freitextRegel"/>
																						</td>
																					</xsl:when>
																					<xsl:otherwise>
																						<td class="Ungleich">
																							<xsl:value-of select="$UnterelementO/xdf3:freitextRegel"/>
																						</td>
																					</xsl:otherwise>
																				</xsl:choose>
																			</xsl:otherwise>
																		</xsl:choose>
																	</tr>
																</xsl:for-each>
																<xsl:for-each select="$VergleichsElement/xdf3:regel">
																	<xsl:variable name="UnterelementO" select="."/>
																	<xsl:variable name="UnterelementA" select="$Element/xdf3:regel[xdf3:identifikation/xdf3:id = $UnterelementO/xdf3:identifikation/xdf3:id]"/>
																	<xsl:choose>
																		<xsl:when test="empty($UnterelementA)">
																			<tr>
																				<td colspan="4"/>
																				<td class="Ungleich">
																					<xsl:choose>
																						<xsl:when test="$RegelDetails = '1'">
																							<xsl:element name="a">
																								<xsl:attribute name="href">#X<xsl:value-of select="$UnterelementO/xdf3:identifikation/xdf3:id"/></xsl:attribute>
																								<xsl:value-of select="$UnterelementO/xdf3:identifikation/xdf3:id"/>
																							</xsl:element>
																						</xsl:when>
																						<xsl:otherwise>
																							<xsl:value-of select="$UnterelementO/xdf3:identifikation/xdf3:id"/>
																						</xsl:otherwise>
																					</xsl:choose>
																				</td>
																				<td class="Ungleich">
																					<xsl:value-of select="$UnterelementO/xdf3:identifikation/xdf3:version"/>
																				</td>
																				<td class="Ungleich">
																					<xsl:value-of select="$UnterelementO/xdf3:name"/> ##
																				</td>
																				<td class="Ungleich">
																					<xsl:value-of select="$UnterelementO/xdf3:freitextRegel"/>
																				</td>
																			</tr>
																		</xsl:when>
																		<xsl:otherwise>
																		</xsl:otherwise>
																	</xsl:choose>
																</xsl:for-each>
															</tbody>
														</table>
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
													<table width="100%">
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
																
																		<xsl:for-each-group select="//xdf3:datenfeldgruppe[xdf3:struktur/xdf3:enthaelt/xdf3:datenfeld/xdf3:identifikation/xdf3:id = $FeldID]" group-by="xdf3:identifikation/xdf3:id">
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
			
																		<xsl:for-each-group select="//xdf3:stammdatenschema[xdf3:struktur/xdf3:enthaelt/xdf3:datenfeld/xdf3:identifikation/xdf3:id = $FeldID]" group-by="xdf3:identifikation/xdf3:id">
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
																		<xsl:for-each-group select="//xdf3:datenfeldgruppe[xdf3:struktur/xdf3:enthaelt/xdf3:datenfeld/xdf3:identifikation/xdf3:id = $FeldID and xdf3:struktur/xdf3:enthaelt/xdf3:datenfeld/xdf3:identifikation/xdf3:version = $FeldVersion]" group-by="xdf3:identifikation/xdf3:id">
																			<xsl:sort select="./xdf3:identifikation/xdf3:id"/>
																			
																			<xsl:for-each-group select="fn:current-group()" group-by="string(xdf3:identifikation/xdf3:version)">
																				<xsl:sort select="./xdf3:identifikation/xdf3:version"/>
																			
																				<xsl:call-template name="minielementcore">
																					<xsl:with-param name="Element" select="."/>
																				</xsl:call-template>
																			
																			</xsl:for-each-group>
																		</xsl:for-each-group>
			
																		<xsl:for-each-group select="//xdf3:stammdatenschema[xdf3:struktur/xdf3:enthaelt/xdf3:datenfeld/xdf3:identifikation/xdf3:id = $FeldID and xdf3:struktur/xdf3:enthaelt/xdf3:datenfeld/xdf3:identifikation/xdf3:version = $FeldVersion]" group-by="./xdf3:identifikation/xdf3:id">
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
												<td></td>
											</tr>
										</xsl:when>
										<xsl:when test="$Element/name() = 'xdf3:datenfeldgruppe'">
											<tr>
												<td>
													<xsl:element name="a">
														<xsl:attribute name="name"><xsl:value-of select="$Element/xdf3:identifikation/xdf3:id"/><xsl:if test="$Element/xdf3:identifikation/xdf3:version">V<xsl:value-of select="$Element/xdf3:identifikation/xdf3:version"/></xsl:if></xsl:attribute>
													</xsl:element>
													ID <xsl:if test="empty($VergleichsElement)">##</xsl:if>
												</td>
												<td class="ElementID">
													<xsl:value-of select="$Element/xdf3:identifikation/xdf3:id"/>
													<xsl:if test="$ToolAufruf = '1'">
														&#160;&#160;
														<xsl:element name="a">
															<xsl:attribute name="href"><xsl:value-of select="$ToolPfadPrefix"/><xsl:value-of select="$Element/xdf3:identifikation/xdf3:id"/><xsl:if test="$Element/xdf3:identifikation/xdf3:version">V<xsl:value-of select="$Element/xdf3:identifikation/xdf3:version"/></xsl:if><xsl:value-of select="$ToolPfadPostfix"/></xsl:attribute>
															<xsl:attribute name="target">FIMTool</xsl:attribute>
															<xsl:attribute name="title">Springe in den Datenfeldeditor (man muss vorher angemeldet sein).</xsl:attribute>
															&#8658;
														</xsl:element>
													</xsl:if>
												</td>
												<xsl:choose>
													<xsl:when test="empty($VergleichsElement)">
														<td class="Ungleich NeuBaukasten"><i>Nicht vorhanden</i></td>
													</xsl:when>
													<xsl:otherwise>
														<td class="ElementID">
															<xsl:element name="a">
																<xsl:attribute name="name">X<xsl:value-of select="$VergleichsElement/xdf3:identifikation/xdf3:id"/><xsl:if test="$VergleichsElement/xdf3:identifikation/xdf3:version">V<xsl:value-of select="$VergleichsElement/xdf3:identifikation/xdf3:version"/></xsl:if></xsl:attribute>
															</xsl:element>
															<xsl:value-of select="$VergleichsElement/xdf3:identifikation/xdf3:id"/>
															<xsl:if test="$ToolAufruf = '1'">
																&#160;&#160;
																<xsl:element name="a">
																	<xsl:attribute name="href"><xsl:value-of select="$ToolPfadPrefix"/><xsl:value-of select="$VergleichsElement/xdf3:identifikation/xdf3:id"/><xsl:if test="$VergleichsElement/xdf3:identifikation/xdf3:version">V<xsl:value-of select="$VergleichsElement/xdf3:identifikation/xdf3:version"/></xsl:if><xsl:value-of select="$ToolPfadPostfix"/></xsl:attribute>
																	<xsl:attribute name="target">FIMTool</xsl:attribute>
																	<xsl:attribute name="title">Springe in den Datenfeldeditor (man muss vorher angemeldet sein).</xsl:attribute>
																	&#8658;
																</xsl:element>
															</xsl:if>
														</td>
													</xsl:otherwise>
												</xsl:choose>
											</tr>	
											<tr>
												<td>Version <xsl:if test="fn:not(empty($VergleichsElement)) and (fn:not((empty($Element/xdf3:identifikation/xdf3:version) and empty($VergleichsElement/xdf3:identifikation/xdf3:version)) or ($Element/xdf3:identifikation/xdf3:version = $VergleichsElement/xdf3:identifikation/xdf3:version)))">##</xsl:if></td>
												<xsl:choose>
													<xsl:when test="$VersionsAnzahl &gt; 1">
														<td>
															<xsl:value-of select="$Element/xdf3:identifikation/xdf3:version"/>
														</td>
													</xsl:when>
													<xsl:otherwise>
														<td>
															<xsl:value-of select="$Element/xdf3:identifikation/xdf3:version"/>
														</td>
													</xsl:otherwise>
												</xsl:choose>
												<xsl:choose>
													<xsl:when test="empty($VergleichsElement) or (empty($Element/xdf3:identifikation/xdf3:version) and empty($VergleichsElement/xdf3:identifikation/xdf3:version)) or ($Element/xdf3:identifikation/xdf3:version = $VergleichsElement/xdf3:identifikation/xdf3:version)">
														<td class="Gleich">
															<xsl:value-of select="$VergleichsElement/xdf3:identifikation/xdf3:version"/>
														</td>
													</xsl:when>
													<xsl:otherwise>
														<td class="Ungleich AenderungBaukasten">
															<xsl:value-of select="$VergleichsElement/xdf3:identifikation/xdf3:version"/>
														</td>
													</xsl:otherwise>
												</xsl:choose>
											</tr>
											<tr>
												<td>Versionshinweis <xsl:if test="fn:not((empty($Element/xdf3:versionshinweis) and empty($VergleichsElement/xdf3:versionshinweis)) or ($Element/xdf3:versionshinweis = $VergleichsElement/xdf3:versionshinweis))">##</xsl:if></td>
												<td>
													<xsl:value-of select="fn:replace($Element/xdf3:versionshinweis,'\n','&lt;br/&gt;')" disable-output-escaping="yes"/>
												</td>
												<xsl:choose>
													<xsl:when test="empty($VergleichsElement) or (empty($Element/xdf3:versionshinweis) and empty($VergleichsElement/xdf3:versionshinweis)) or ($Element/xdf3:versionshinweis = $VergleichsElement/xdf3:versionshinweis)">
														<td class="Gleich">
															<xsl:value-of select="fn:replace($VergleichsElement/xdf3:versionshinweis,'\n','&lt;br/&gt;')" disable-output-escaping="yes"/>
														</td>
													</xsl:when>
													<xsl:otherwise>
														<td class="Ungleich">
															<xsl:value-of select="fn:replace($VergleichsElement/xdf3:versionshinweis,'\n','&lt;br/&gt;')" disable-output-escaping="yes"/>
														</td>
													</xsl:otherwise>
												</xsl:choose>
											</tr>
											<tr>
												<td>Name <xsl:if test="fn:not(empty($VergleichsElement)) and (fn:not((empty($Element/xdf3:name) and empty($VergleichsElement/xdf3:name)) or ($Element/xdf3:name = $VergleichsElement/xdf3:name)))">##</xsl:if></td>
												<xsl:choose>
													<xsl:when test="empty($Element/xdf3:name/text())">
													<td class="ElementName">
														</td>
													</xsl:when>
													<xsl:otherwise>
														<td class="ElementName">
															<xsl:value-of select="$Element/xdf3:name"/>
														</td>
													</xsl:otherwise>
												</xsl:choose>
												<xsl:choose>
													<xsl:when test="empty($VergleichsElement) or (empty($Element/xdf3:name) and empty($VergleichsElement/xdf3:name)) or ($Element/xdf3:name = $VergleichsElement/xdf3:name)">
														<td class="ElementName Gleich">
															<xsl:value-of select="$VergleichsElement/xdf3:name"/>
														</td>
													</xsl:when>
													<xsl:otherwise>
														<td class="ElementName Ungleich">
															<xsl:value-of select="$VergleichsElement/xdf3:name"/>
														</td>
													</xsl:otherwise>
												</xsl:choose>
											</tr>
											<xsl:if test="count($Element/xdf3:stichwort) = 0 and count($VergleichsElement/xdf3:stichwort) = 0">
												<tr>
													<td>Stichwörter</td>
													<td></td>
													<td></td>
												</tr>
											</xsl:if>
											<xsl:for-each select="$Element/xdf3:stichwort">
												<xsl:variable name="stichwort" select="./text()"/>
												<xsl:variable name="uri"><xsl:value-of select="./@uri"/></xsl:variable>
												<xsl:variable name="VergleichsStichwort" select="$VergleichsElement/xdf3:stichwort[./text() = $stichwort]"/>
												<xsl:variable name="VergleichsURI"><xsl:value-of select="$VergleichsElement/xdf3:stichwort[./text() = $stichwort]/@uri"/></xsl:variable>
												
												<tr>
													<xsl:choose>
														<xsl:when test="fn:position() = 1"><td>Stichwörter</td></xsl:when>
														<xsl:otherwise><td></td></xsl:otherwise>
													</xsl:choose>
													<td>
														<ul class="hangrun">
															<li>
																<xsl:value-of select="."/><xsl:if test="@uri and ./@uri != ''"> (<xsl:value-of select="./@uri"/>)</xsl:if>
															</li>
														</ul>
													</td>
													<xsl:choose>
														<xsl:when test="empty($VergleichsStichwort)">
															<td class="Ungleich">
																<ul class="hangrun">
																	<li><i>Nicht vorhanden</i> ##</li>
																</ul>
															</td>
														</xsl:when>
														<xsl:when test="$uri != $VergleichsURI">
															<td class="Ungleich">
																<ul class="hangrun">
																	<li>
																		<xsl:value-of select="$VergleichsElement/xdf3:stichwort[./text() = $stichwort]/text()"/><xsl:if test="$VergleichsElement/xdf3:stichwort[./text() = $stichwort]/@uri and $VergleichsElement/xdf3:stichwort[./text() = $stichwort]/@uri != ''"> (<xsl:value-of select="$VergleichsElement/xdf3:stichwort[./text() = $stichwort]/@uri"/>)</xsl:if> ##
																	</li>
																</ul>
															</td>
														</xsl:when>
														<xsl:otherwise>
															<td class="Gleich">
																<ul class="hangrun">
																	<li>
																		<xsl:value-of select="$VergleichsElement/xdf3:stichwort[./text() = $stichwort]/text()"/><xsl:if test="$VergleichsElement/xdf3:stichwort[./text() = $stichwort]/@uri and $VergleichsElement/xdf3:stichwort[./text() = $stichwort]/@uri != ''"> (<xsl:value-of select="$VergleichsElement/xdf3:stichwort[./text() = $stichwort]/@uri"/>)</xsl:if>
																	</li>
																</ul>
															</td>
														</xsl:otherwise>
													</xsl:choose>
												</tr>
											</xsl:for-each>
											<xsl:for-each select="$VergleichsElement/xdf3:stichwort">
												<xsl:variable name="stichwort" select="./text()"/>
												<xsl:variable name="uri"><xsl:value-of select="./@link"/></xsl:variable>
												<xsl:variable name="OriginalStichwort" select="$Element/xdf3:stichwort[./text() = $stichwort]"/>
												<xsl:variable name="OriginalURI"><xsl:value-of select="$Element/xdf3:stichwort[./text() = $stichwort]/@link"/></xsl:variable>
												
												<xsl:if test="not($Element/xdf3:stichwort[./text() = $stichwort])">
													<tr>
														<xsl:choose>
															<xsl:when test="count($Element/xdf3:stichwort) = 0 and fn:position() = 1"><td>Stichwörter</td></xsl:when>
															<xsl:otherwise><td></td></xsl:otherwise>
														</xsl:choose>
														<td>
															<ul class="hangrun">
																<li>
																	<i>Nicht vorhanden</i>
																</li>
															</ul>
														</td>
														<td class="Ungleich">
															<ul class="hangrun">
																<li>
																	<xsl:value-of select="./text()"/><xsl:if test="./@uri and ./@uri != ''"> (<xsl:value-of select="./@uri"/>)</xsl:if> ##
																</li>
															</ul>
	
														</td>
													</tr>
												</xsl:if>
											</xsl:for-each>
											<tr>
												<td>Definition <xsl:if test="fn:not(empty($VergleichsElement)) and (fn:not((empty($Element/xdf3:definition) and empty($VergleichsElement/xdf3:definition)) or ($Element/xdf3:definition = $VergleichsElement/xdf3:definition)))">##</xsl:if></td>
												<td>
													<xsl:value-of select="fn:replace($Element/xdf3:definition,'\n','&lt;br/&gt;')" disable-output-escaping="yes"/>
												</td>
												<xsl:choose>
													<xsl:when test="empty($VergleichsElement) or (empty($Element/xdf3:definition) and empty($VergleichsElement/xdf3:definition)) or ($Element/xdf3:definition = $VergleichsElement/xdf3:definition)">
														<td class="Gleich">
															<xsl:value-of select="fn:replace($VergleichsElement/xdf3:definition,'\n','&lt;br/&gt;')" disable-output-escaping="yes"/>
														</td>
													</xsl:when>
													<xsl:otherwise>
														<td class="Ungleich">
															<xsl:value-of select="fn:replace($VergleichsElement/xdf3:definition,'\n','&lt;br/&gt;')" disable-output-escaping="yes"/>
														</td>
													</xsl:otherwise>
												</xsl:choose>
											</tr>
											<tr>
												<td>Strukturelementart <xsl:if test="fn:not(empty($VergleichsElement)) and (fn:not((empty($Element/xdf3:schemaelementart) and empty($VergleichsElement/xdf3:schemaelementart)) or ($Element/xdf3:schemaelementart = $VergleichsElement/xdf3:schemaelementart)))">##</xsl:if></td>
												<td>
													<xsl:apply-templates select="$Element/xdf3:schemaelementart"/>
												</td>
												<xsl:choose>
													<xsl:when test="empty($VergleichsElement) or (empty($Element/xdf3:schemaelementart) and empty($VergleichsElement/xdf3:schemaelementart)) or ($Element/xdf3:schemaelementart = $VergleichsElement/xdf3:schemaelementart)">
														<td class="Gleich">
															<xsl:apply-templates select="$VergleichsElement/xdf3:schemaelementart"/>
														</td>
													</xsl:when>
													<xsl:otherwise>
														<td class="Ungleich">
															<xsl:apply-templates select="$VergleichsElement/xdf3:schemaelementart"/>
														</td>
													</xsl:otherwise>
												</xsl:choose>
											</tr>
											<tr>
												<td>Gruppenart <xsl:if test="fn:not(empty($VergleichsElement)) and (fn:not((empty($Element/xdf3:art) and empty($VergleichsElement/xdf3:art)) or ($Element/xdf3:art = $VergleichsElement/xdf3:art)))">##</xsl:if></td>
												<td>
													<xsl:apply-templates select="$Element/xdf3:art"/>
												</td>
												<xsl:choose>
													<xsl:when test="empty($VergleichsElement) or (empty($Element/xdf3:art) and empty($VergleichsElement/xdf3:art)) or ($Element/xdf3:art = $VergleichsElement/xdf3:art)">
														<td class="Gleich">
															<xsl:apply-templates select="$VergleichsElement/xdf3:art"/>
														</td>
													</xsl:when>
													<xsl:otherwise>
														<td class="Ungleich">
															<xsl:apply-templates select="$VergleichsElement/xdf3:art"/>
														</td>
													</xsl:otherwise>
												</xsl:choose>
											</tr>
											<xsl:if test="count($Element/xdf3:bezug) = 0 and count($VergleichsElement/xdf3:bezug) = 0">
												<tr>
													<td>Handlungsgrundlagen</td>
													<td></td>
													<td></td>
												</tr>
											</xsl:if>
											<xsl:for-each select="$Element/xdf3:bezug">
												<xsl:variable name="bezug" select="./text()"/>
												<xsl:variable name="link"><xsl:value-of select="./@link"/></xsl:variable>
												<xsl:variable name="VergleichsBezug" select="$VergleichsElement/xdf3:bezug[./text() = $bezug]"/>
												<xsl:variable name="VergleichsLink"><xsl:value-of select="$VergleichsElement/xdf3:bezug[./text() = $bezug]/@link"/></xsl:variable>
												
												<tr>
													<xsl:choose>
														<xsl:when test="fn:position() = 1"><td>Handlungsgrundlagen</td></xsl:when>
														<xsl:otherwise><td></td></xsl:otherwise>
													</xsl:choose>
													<td>
														<ul class="hangrun">
															<li>
																<xsl:value-of select="."/>
																<xsl:choose>
																	<xsl:when test="not(@link) or ./@link=''"></xsl:when>
																	<xsl:when test="$HandlungsgrundlagenLinks = '1'">
																		- <xsl:element name="a">
																			<xsl:attribute name="href"><xsl:value-of select="./@link"/></xsl:attribute>
																			<xsl:attribute name="target">Handlungsgrundlage</xsl:attribute>
																			<xsl:attribute name="title">Springe zum Text der Handlungsgrundlage.</xsl:attribute>
																			<xsl:value-of select="./@link"/>
																		</xsl:element>
																	</xsl:when>
																	<xsl:otherwise>
																		- <xsl:value-of select="./@link"/>
																	</xsl:otherwise>
																</xsl:choose>
															</li>
														</ul>
													</td>
													<xsl:choose>
														<xsl:when test="empty($VergleichsElement)">
															<td class="Gleich">
															</td>
														</xsl:when>
														<xsl:when test="empty($VergleichsBezug)">
															<td class="Ungleich">
																<ul class="hangrun">
																	<li><i>Nicht vorhanden</i> ##</li>
																</ul>
															</td>
														</xsl:when>
														<xsl:when test="$link != $VergleichsLink">
															<td class="Ungleich">
																<ul class="hangrun">
																	<li>
																		<xsl:value-of select="$VergleichsElement/xdf3:bezug[./text() = $bezug]/text()"/>
																		<xsl:choose>
																			<xsl:when test="not($VergleichsElement/xdf3:bezug[./text() = $bezug]/@link) or $VergleichsElement/xdf3:bezug[./text() = $bezug]/@link=''"></xsl:when>
																			<xsl:when test="$HandlungsgrundlagenLinks = '1'">
																				- <xsl:element name="a">
																					<xsl:attribute name="href"><xsl:value-of select="./@link"/></xsl:attribute>
																					<xsl:attribute name="target">Handlungsgrundlage</xsl:attribute>
																					<xsl:attribute name="title">Springe zum Text der Handlungsgrundlage.</xsl:attribute>
																					<xsl:value-of select="$VergleichsElement/xdf3:bezug[./text() = $bezug]/@link"/>
																				</xsl:element> ##
																			</xsl:when>
																			<xsl:otherwise>
																				- <xsl:value-of select="$VergleichsElement/xdf3:bezug[./text() = $bezug]/@link"/> ##
																			</xsl:otherwise>
																		</xsl:choose>
																	</li>
																</ul>
															</td>
														</xsl:when>
														<xsl:otherwise>
															<td class="Gleich">
																<ul class="hangrun">
																	<li>
																		<xsl:value-of select="$VergleichsElement/xdf3:bezug[./text() = $bezug]/text()"/>
																		<xsl:choose>
																			<xsl:when test="not($VergleichsElement/xdf3:bezug[./text() = $bezug]/@link) or $VergleichsElement/xdf3:bezug[./text() = $bezug]/@link=''"></xsl:when>
																			<xsl:when test="$HandlungsgrundlagenLinks = '1'">
																				- <xsl:element name="a">
																					<xsl:attribute name="href"><xsl:value-of select="./@link"/></xsl:attribute>
																					<xsl:attribute name="target">Handlungsgrundlage</xsl:attribute>
																					<xsl:attribute name="title">Springe zum Text der Handlungsgrundlage.</xsl:attribute>
																					<xsl:value-of select="$VergleichsElement/xdf3:bezug[./text() = $bezug]/@link"/>
																				</xsl:element>
																			</xsl:when>
																			<xsl:otherwise>
																				- <xsl:value-of select="$VergleichsElement/xdf3:bezug[./text() = $bezug]/@link"/>
																			</xsl:otherwise>
																		</xsl:choose>
																	</li>
																</ul>
															</td>
														</xsl:otherwise>
													</xsl:choose>
												</tr>
											</xsl:for-each>
											<xsl:for-each select="$VergleichsElement/xdf3:bezug">
												<xsl:variable name="bezug" select="./text()"/>
												<xsl:variable name="link"><xsl:value-of select="./@link"/></xsl:variable>
												<xsl:variable name="OriginalBezug" select="$Element/xdf3:bezug[./text() = $bezug]"/>
												<xsl:variable name="OriginalLink"><xsl:value-of select="$Element/xdf3:bezug[./text() = $bezug]/@link"/></xsl:variable>
												
												<xsl:if test="not($Element/xdf3:bezug[./text() = $bezug])">
													<tr>
														<xsl:choose>
															<xsl:when test="count($Element/xdf3:bezug) = 0 and fn:position() = 1"><td>Handlungsgrundlagen</td></xsl:when>
															<xsl:otherwise><td></td></xsl:otherwise>
														</xsl:choose>
														<td>
															<ul class="hangrun">
																<li>
																	<i>Nicht vorhanden</i>
																</li>
															</ul>
														</td>
														<td class="Ungleich">
															<ul class="hangrun">
																<li>
																	<xsl:value-of select="./text()"/><xsl:if test="not(./@link) or ./@link=''"> ##</xsl:if>
																	<xsl:choose>
																		<xsl:when test="not(./@link) or ./@link=''"></xsl:when>
																		<xsl:when test="$HandlungsgrundlagenLinks = '1'">
																			- <xsl:element name="a">
																				<xsl:attribute name="href"><xsl:value-of select="./@link"/></xsl:attribute>
																				<xsl:attribute name="target">Handlungsgrundlage</xsl:attribute>
																				<xsl:attribute name="title">Springe zum Text der Handlungsgrundlage.</xsl:attribute>
																				<xsl:value-of select="./@link"/>
																			</xsl:element> ##
																		</xsl:when>
																		<xsl:otherwise>
																			- <xsl:value-of select="./@link"/> ##
																		</xsl:otherwise>
																	</xsl:choose>
																</li>
															</ul>
	
														</td>
													</tr>
												</xsl:if>
											</xsl:for-each>
											<tr>
												<td>Beschreibung <xsl:if test="fn:not(empty($VergleichsElement)) and (fn:not((empty($Element/xdf3:beschreibung) and empty($VergleichsElement/xdf3:beschreibung)) or ($Element/xdf3:beschreibung = $VergleichsElement/xdf3:beschreibung)))">##</xsl:if></td>
												<td>
													<xsl:value-of select="fn:replace($Element/xdf3:beschreibung,'\n','&lt;br/&gt;')" disable-output-escaping="yes"/>
												</td>
												<xsl:choose>
													<xsl:when test="empty($VergleichsElement) or (empty($Element/xdf3:beschreibung) and empty($VergleichsElement/xdf3:beschreibung)) or ($Element/xdf3:beschreibung = $VergleichsElement/xdf3:beschreibung)">
														<td class="Gleich">
															<xsl:value-of select="fn:replace($VergleichsElement/xdf3:beschreibung,'\n','&lt;br/&gt;')" disable-output-escaping="yes"/>
														</td>
													</xsl:when>
													<xsl:otherwise>
														<td class="Ungleich">
															<xsl:value-of select="fn:replace($VergleichsElement/xdf3:beschreibung,'\n','&lt;br/&gt;')" disable-output-escaping="yes"/>
														</td>
													</xsl:otherwise>
												</xsl:choose>
											</tr>
											<tr>
												<td>Bezeichnung Eingabe <xsl:if test="fn:not(empty($VergleichsElement)) and (fn:not((empty($Element/xdf3:bezeichnungEingabe) and empty($VergleichsElement/xdf3:bezeichnungEingabe)) or ($Element/xdf3:bezeichnungEingabe = $VergleichsElement/xdf3:bezeichnungEingabe)))">##</xsl:if></td>
												<xsl:choose>
													<xsl:when test="empty($Element/xdf3:bezeichnungEingabe/text())">
														<td>
														</td>
													</xsl:when>
													<xsl:otherwise>
														<td>
															<xsl:value-of select="$Element/xdf3:bezeichnungEingabe"/>
														</td>
													</xsl:otherwise>
												</xsl:choose>
												<xsl:choose>
													<xsl:when test="empty($VergleichsElement) or (empty($Element/xdf3:bezeichnungEingabe) and empty($VergleichsElement/xdf3:bezeichnungEingabe)) or ($Element/xdf3:bezeichnungEingabe = $VergleichsElement/xdf3:bezeichnungEingabe)">
														<td class="Gleich">
															<xsl:value-of select="$VergleichsElement/xdf3:bezeichnungEingabe"/>
														</td>
													</xsl:when>
													<xsl:otherwise>
														<td class="Ungleich">
															<xsl:value-of select="$VergleichsElement/xdf3:bezeichnungEingabe"/>
														</td>
													</xsl:otherwise>
												</xsl:choose>
											</tr>
											<tr>
												<td>Bezeichnung Ausgabe <xsl:if test="fn:not(empty($VergleichsElement)) and (fn:not((empty($Element/xdf3:bezeichnungAusgabe) and empty($VergleichsElement/xdf3:bezeichnungAusgabe)) or ($Element/xdf3:bezeichnungAusgabe = $VergleichsElement/xdf3:bezeichnungAusgabe)))">##</xsl:if></td>
												<xsl:choose>
													<xsl:when test="empty($Element/xdf3:bezeichnungAusgabe/text())">
														<td>
														</td>
													</xsl:when>
													<xsl:otherwise>
														<td>
															<xsl:value-of select="$Element/xdf3:bezeichnungAusgabe"/>
														</td>
													</xsl:otherwise>
												</xsl:choose>
												<xsl:choose>
													<xsl:when test="empty($VergleichsElement) or (empty($Element/xdf3:bezeichnungAusgabe) and empty($VergleichsElement/xdf3:bezeichnungAusgabe)) or ($Element/xdf3:bezeichnungAusgabe = $VergleichsElement/xdf3:bezeichnungAusgabe)">
														<td class="Gleich">
															<xsl:value-of select="$VergleichsElement/xdf3:bezeichnungAusgabe"/>
														</td>
													</xsl:when>
													<xsl:otherwise>
														<td class="Ungleich">
															<xsl:value-of select="$VergleichsElement/xdf3:bezeichnungAusgabe"/>
														</td>
													</xsl:otherwise>
												</xsl:choose>
											</tr>
											<tr>
												<td>Hilfetext Eingabe <xsl:if test="fn:not(empty($VergleichsElement)) and (fn:not((empty($Element/xdf3:hilfetextEingabe) and empty($VergleichsElement/xdf3:hilfetextEingabe)) or ($Element/xdf3:hilfetextEingabe = $VergleichsElement/xdf3:hilfetextEingabe)))">##</xsl:if></td>
												<td>
													<xsl:value-of select="fn:replace($Element/xdf3:hilfetextEingabe,'\n','&lt;br/&gt;')" disable-output-escaping="yes"/>
												</td>
												<xsl:choose>
													<xsl:when test="empty($VergleichsElement) or (empty($Element/xdf3:hilfetextEingabe) and empty($VergleichsElement/xdf3:hilfetextEingabe)) or ($Element/xdf3:hilfetextEingabe = $VergleichsElement/xdf3:hilfetextEingabe)">
														<td class="Gleich">
															<xsl:value-of select="fn:replace($VergleichsElement/xdf3:hilfetextEingabe,'\n','&lt;br/&gt;')" disable-output-escaping="yes"/>
														</td>
													</xsl:when>
													<xsl:otherwise>
														<td class="Ungleich">
															<xsl:value-of select="fn:replace($VergleichsElement/xdf3:hilfetextEingabe,'\n','&lt;br/&gt;')" disable-output-escaping="yes"/>
														</td>
													</xsl:otherwise>
												</xsl:choose>
											</tr>
											<tr>
												<td>Hilfetext Ausgabe <xsl:if test="fn:not(empty($VergleichsElement)) and (fn:not((empty($Element/xdf3:hilfetextAusgabe) and empty($VergleichsElement/xdf3:hilfetextAusgabe)) or ($Element/xdf3:hilfetextAusgabe = $VergleichsElement/xdf3:hilfetextAusgabe)))">##</xsl:if></td>
												<td>
													<xsl:value-of select="fn:replace($Element/xdf3:hilfetextAusgabe,'\n','&lt;br/&gt;')" disable-output-escaping="yes"/>
												</td>
												<xsl:choose>
													<xsl:when test="empty($VergleichsElement) or (empty($Element/xdf3:hilfetextAusgabe) and empty($VergleichsElement/xdf3:hilfetextAusgabe)) or ($Element/xdf3:hilfetextAusgabe = $VergleichsElement/xdf3:hilfetextAusgabe)">
														<td class="Gleich">
															<xsl:value-of select="fn:replace($VergleichsElement/xdf3:hilfetextAusgabe,'\n','&lt;br/&gt;')" disable-output-escaping="yes"/>
														</td>
													</xsl:when>
													<xsl:otherwise>
														<td class="Ungleich">
															<xsl:value-of select="fn:replace($VergleichsElement/xdf3:hilfetextAusgabe,'\n','&lt;br/&gt;')" disable-output-escaping="yes"/>
														</td>
													</xsl:otherwise>
												</xsl:choose>
											</tr>

											<tr>
												<td>Gültig ab <xsl:if test="fn:not(empty($VergleichsElement)) and fn:not((empty($Element/xdf3:gueltigAb) and empty($VergleichsElement/xdf3:gueltigAb)) or ($Element/xdf3:gueltigAb = $VergleichsElement/xdf3:gueltigAb))">##</xsl:if></td>
												<td>
													<xsl:value-of select="fn:format-date($Element/xdf3:gueltigAb,'[D01].[M01].[Y0001]')"/>
												</td>
												<xsl:choose>
													<xsl:when test="empty($VergleichsElement) or (empty($Element/xdf3:gueltigAb) and empty($VergleichsElement/xdf3:gueltigAb)) or ($Element/xdf3:gueltigAb = $VergleichsElement/xdf3:gueltigAb)">
														<td class="Gleich">
															<xsl:value-of select="fn:format-date($VergleichsElement/xdf3:gueltigAb,'[D01].[M01].[Y0001]')"/>
														</td>
													</xsl:when>
													<xsl:otherwise>
														<td class="Ungleich">
															<xsl:value-of select="fn:format-date($VergleichsElement/xdf3:gueltigAb,'[D01].[M01].[Y0001]')"/>
														</td>
													</xsl:otherwise>
												</xsl:choose>
											</tr>
											<tr>
												<td>Gültig bis <xsl:if test="fn:not(empty($VergleichsElement)) and fn:not((empty($Element/xdf3:gueltigBis) and empty($VergleichsElement/xdf3:gueltigBis)) or ($Element/xdf3:gueltigBis = $VergleichsElement/xdf3:gueltigBis))">##</xsl:if></td>
												<td>
													<xsl:value-of select="fn:format-date($Element/xdf3:gueltigBis,'[D01].[M01].[Y0001]')"/>
												</td>
												<xsl:choose>
													<xsl:when test="empty($VergleichsElement) or (empty($Element/xdf3:gueltigBis) and empty($VergleichsElement/xdf3:gueltigBis)) or ($Element/xdf3:gueltigBis = $VergleichsElement/xdf3:gueltigBis)">
														<td class="Gleich">
															<xsl:value-of select="fn:format-date($VergleichsElement/xdf3:gueltigBis,'[D01].[M01].[Y0001]')"/>
														</td>
													</xsl:when>
													<xsl:otherwise>
														<td class="Ungleich">
															<xsl:value-of select="fn:format-date($VergleichsElement/xdf3:gueltigBis,'[D01].[M01].[Y0001]')"/>
														</td>
													</xsl:otherwise>
												</xsl:choose>
											</tr>
											<tr>
												<td>Fachlicher Ersteller <xsl:if test="fn:not(empty($VergleichsElement)) and fn:not((empty($Element/xdf3:statusGesetztDurch) and empty($VergleichsElement/xdf3:statusGesetztDurch)) or ($Element/xdf3:statusGesetztDurch = $VergleichsElement/xdf3:statusGesetztDurch))">##</xsl:if></td>
												<td>
													<xsl:value-of select="$Element/xdf3:statusGesetztDurch"/>
												</td>
												<xsl:choose>
													<xsl:when test="empty($VergleichsElement) or (empty($Element/xdf3:statusGesetztDurch) and empty($VergleichsElement/xdf3:statusGesetztDurch)) or ($Element/xdf3:statusGesetztDurch = $VergleichsElement/xdf3:statusGesetztDurch)">
														<td class="Gleich">
															<xsl:value-of select="$VergleichsElement/xdf3:statusGesetztDurch"/>
														</td>
													</xsl:when>
													<xsl:otherwise>
														<td class="Ungleich">
															<xsl:value-of select="$VergleichsElement/xdf3:statusGesetztDurch"/>
														</td>
													</xsl:otherwise>
												</xsl:choose>
											</tr>
											<tr>
												<td>Status <xsl:if test="fn:not(empty($VergleichsElement)) and fn:not((empty($Element/xdf3:freigabestatus) and empty($VergleichsElement/xdf3:freigabestatus)) or ($Element/xdf3:freigabestatus = $VergleichsElement/xdf3:freigabestatus))">##</xsl:if></td>
												<td>
													<xsl:apply-templates select="$Element/xdf3:freigabestatus"/>
												</td>
												<xsl:choose>
													<xsl:when test="empty($VergleichsElement) or (empty($Element/xdf3:freigabestatus) and empty($VergleichsElement/xdf3:freigabestatus)) or ($Element/xdf3:freigabestatus = $VergleichsElement/xdf3:freigabestatus)">
														<td class="Gleich">
															<xsl:apply-templates select="$VergleichsElement/xdf3:freigabestatus"/>
														</td>
													</xsl:when>
													<xsl:otherwise>
														<td class="Ungleich">
															<xsl:apply-templates select="$VergleichsElement/xdf3:freigabestatus"/>
														</td>
													</xsl:otherwise>
												</xsl:choose>
											</tr>
											<tr>
												<td>Status gesetzt am <xsl:if test="fn:not(empty($VergleichsElement)) and fn:not((empty($Element/xdf3:statusGesetztAm) and empty($VergleichsElement/xdf3:statusGesetztAm)) or ($Element/xdf3:statusGesetztAm = $VergleichsElement/xdf3:statusGesetztAm))">##</xsl:if></td>
												<td>
													<xsl:value-of select="fn:format-date($Element/xdf3:statusGesetztAm,'[D01].[M01].[Y0001]')"/>
												</td>
												<xsl:choose>
													<xsl:when test="empty($VergleichsElement) or (empty($Element/xdf3:statusGesetztAm) and empty($VergleichsElement/xdf3:statusGesetztAm)) or ($Element/xdf3:statusGesetztAm = $VergleichsElement/xdf3:statusGesetztAm)">
														<td class="Gleich">
															<xsl:value-of select="fn:format-date($VergleichsElement/xdf3:statusGesetztAm,'[D01].[M01].[Y0001]')"/>
														</td>
													</xsl:when>
													<xsl:otherwise>
														<td class="Ungleich">
															<xsl:value-of select="fn:format-date($VergleichsElement/xdf3:statusGesetztAm,'[D01].[M01].[Y0001]')"/>
														</td>
													</xsl:otherwise>
												</xsl:choose>
											</tr>
											<tr>
												<td>Veröffentlichungsdatum <xsl:if test="fn:not(empty($VergleichsElement)) and fn:not((empty($Element/xdf3:veroeffentlichungsdatum) and empty($VergleichsElement/xdf3:veroeffentlichungsdatum)) or ($Element/xdf3:veroeffentlichungsdatum = $VergleichsElement/xdf3:veroeffentlichungsdatum))">##</xsl:if></td>
												<td>
													<xsl:value-of select="fn:format-date($Element/xdf3:veroeffentlichungsdatum,'[D01].[M01].[Y0001]')"/>
												</td>
												<xsl:choose>
													<xsl:when test="empty($VergleichsElement) or (empty($Element/xdf3:veroeffentlichungsdatum) and empty($VergleichsElement/xdf3:veroeffentlichungsdatum)) or ($Element/xdf3:veroeffentlichungsdatum = $VergleichsElement/xdf3:veroeffentlichungsdatum)">
														<td class="Gleich">
															<xsl:value-of select="fn:format-date($VergleichsElement/xdf3:veroeffentlichungsdatum,'[D01].[M01].[Y0001]')"/>
														</td>
													</xsl:when>
													<xsl:otherwise>
														<td class="Ungleich">
															<xsl:value-of select="fn:format-date($VergleichsElement/xdf3:veroeffentlichungsdatum,'[D01].[M01].[Y0001]')"/>
														</td>
													</xsl:otherwise>
												</xsl:choose>
											</tr>
											<tr>
												<td>Letzte Änderung <xsl:if test="fn:not(empty($VergleichsElement)) and fn:not((empty($Element/xdf3:letzteAenderung) and empty($VergleichsElement/xdf3:letzteAenderung)) or ($Element/xdf3:letzteAenderung = $VergleichsElement/xdf3:letzteAenderung))">##</xsl:if></td>
												<td>
													<xsl:value-of select="fn:format-dateTime($Element/xdf3:letzteAenderung,'[D01].[M01].[Y0001] um [H01]:[m01] Uhr')"/>
												</td>
												<xsl:choose>
													<xsl:when test="empty($VergleichsElement) or (empty($Element/xdf3:letzteAenderung) and empty($VergleichsElement/xdf3:letzteAenderung)) or ($Element/xdf3:letzteAenderung = $VergleichsElement/xdf3:letzteAenderung)">
														<td class="Gleich">
															<xsl:value-of select="fn:format-dateTime($VergleichsElement/xdf3:letzteAenderung,'[D01].[M01].[Y0001] um [H01]:[m01] Uhr')"/>
														</td>
													</xsl:when>
													<xsl:otherwise>
														<td class="Ungleich">
															<xsl:value-of select="fn:format-dateTime($VergleichsElement/xdf3:letzteAenderung,'[D01].[M01].[Y0001] um [H01]:[m01] Uhr')"/>
														</td>
													</xsl:otherwise>
												</xsl:choose>
											</tr>

												<tr>
													<xsl:variable name="AnzahlUnterelemente" select="count($Element/xdf3:struktur)"/>

													<td>
														<b>Unterelemente</b>
													</td>
													<xsl:choose>
														<xsl:when test="($AnzahlUnterelemente &gt; 0) or count($VergleichsElement/xdf3:struktur)">
															<td colspan="2">
																<table width="100%">
																	<thead>
																		<tr>
																			<th width="5%">ID</th>
																			<th width="5%">Version</th>
																			<th width="17%">Name</th>
																			<th width="5%">Kardinalität</th>
																			<th width="18%">Bezug zu</th>
																			<xsl:choose>
																				<xsl:when test="empty($VergleichsElement)">
																					<th width="5%"></th>
																					<th width="5%"></th>
																					<th width="17%"></th>
																					<th width="5%"></th>
																					<th width="18%"></th>
																				</xsl:when>
																				<xsl:otherwise>
																					<th width="5%">ID</th>
																					<th width="5%">Version</th>
																					<th width="17%">Name</th>
																					<th width="5%">Kardinalität</th>
																					<th width="18%">Bezug zu</th>
																				</xsl:otherwise>
																			</xsl:choose>
																		</tr>
																	</thead>
																	<tbody>
																		<xsl:variable name="Strukturelementart"><xsl:value-of select="./xdf3:schemaelementart/code"/></xsl:variable>
																	
																		<xsl:for-each select="$Element/xdf3:struktur">
																		
																			<xsl:variable name="VergleichsElement2"><xsl:value-of select="./xdf3:enthaelt/*/xdf3:identifikation/xdf3:id"/></xsl:variable>
																			<xsl:variable name="VergleichsVersion2"><xsl:value-of select="./xdf3:enthaelt/*/xdf3:identifikation/xdf3:version"/></xsl:variable>
																		
																			<xsl:variable name="UnterelementA" select="."/>
																			<xsl:variable name="UnterelementO" select="$VergleichsElement/xdf3:struktur[xdf3:enthaelt/*/xdf3:identifikation/xdf3:id = $UnterelementA/xdf3:enthaelt/*/xdf3:identifikation/xdf3:id]"/>

																			<tr>
																				<td>
																					<xsl:element name="a">
																						<xsl:attribute name="href">#<xsl:value-of select="./xdf3:enthaelt/*/xdf3:identifikation/xdf3:id"/><xsl:if test="./xdf3:enthaelt/*/xdf3:identifikation/xdf3:version">V<xsl:value-of select="./xdf3:enthaelt/*/xdf3:identifikation/xdf3:version"/></xsl:if></xsl:attribute>
																						<xsl:value-of select="./xdf3:enthaelt/*/xdf3:identifikation/xdf3:id"/>
																					</xsl:element>
																					<xsl:choose>
																						<xsl:when test="$VergleichsVersion2 = ''">
																							<xsl:if test="count($Element/xdf3:struktur/./xdf3:enthaelt/*/xdf3:identifikation[xdf3:id=$VergleichsElement and not(xdf3:version)]) &gt; 1">
																							</xsl:if>
																						</xsl:when>
																						<xsl:otherwise>
																							<xsl:if test="count($Element/xdf3:struktur/./xdf3:enthaelt/*/xdf3:identifikation[xdf3:id=$VergleichsElement and xdf3:version=$VergleichsVersion2]) &gt; 1">
																							</xsl:if>
																						</xsl:otherwise>
																					</xsl:choose>

																				</td>
																				<td>
																					<xsl:value-of select="./xdf3:enthaelt/*/xdf3:identifikation/xdf3:version"/>
																				</td>
																				<td>
																					<xsl:value-of select="./xdf3:enthaelt/*/xdf3:name"/>
																				</td>
																				<xsl:choose>
																					<xsl:when test="./xdf3:anzahl='0:0'">
																						<td>
																							<xsl:value-of select="./xdf3:anzahl"/>
																						</td>
																					</xsl:when>
																					<xsl:otherwise>
																						<td>
																							<xsl:value-of select="./xdf3:anzahl"/>
																						</td>
																					</xsl:otherwise>
																				</xsl:choose>
																				<xsl:choose>
																					<xsl:when test="$Strukturelementart ='RNG' and (./xdf3:enthaelt/*/xdf3:schemaelementart/code/text() = 'ABS' or ./xdf3:enthaelt/*/xdf3:schemaelementart/code/text() = 'HAR') and empty(./xdf3:bezug/text())">
																						<td>
																						</td>
																					</xsl:when>
																					<xsl:otherwise>
																						<td>
																							<xsl:value-of select="./xdf3:bezug"/>
																						</td>
																					</xsl:otherwise>
																				</xsl:choose>

																				<xsl:choose>
																					<xsl:when test="empty($VergleichsElement)">
																						<td colspan="5">
																						</td>
																					</xsl:when>
																					<xsl:when test="empty($UnterelementO)">
																						<td colspan="5" class="Ungleich">
																							<i>Nicht vorhanden</i> ##
																						</td>
																					</xsl:when>
																					<xsl:otherwise>
																						<td>
																							<xsl:element name="a">
																								<xsl:attribute name="href">#X<xsl:value-of select="$UnterelementO/xdf3:enthaelt/*/xdf3:identifikation/xdf3:id"/><xsl:if test="$UnterelementO/xdf3:enthaelt/*/xdf3:identifikation/xdf3:version">V<xsl:value-of select="$UnterelementO/xdf3:enthaelt/*/xdf3:identifikation/xdf3:version"/></xsl:if></xsl:attribute>
																								<xsl:value-of select="$UnterelementO/xdf3:enthaelt/*/xdf3:identifikation/xdf3:id"/>
																							</xsl:element>
																						</td>
																						<xsl:choose>
																							<xsl:when test="(empty($UnterelementO/xdf3:enthaelt/*/xdf3:identifikation/xdf3:version) and empty($UnterelementA/xdf3:enthaelt/*/xdf3:identifikation/xdf3:version)) or ($UnterelementO/xdf3:enthaelt/*/xdf3:identifikation/xdf3:version = $UnterelementA/xdf3:enthaelt/*/xdf3:identifikation/xdf3:version)">
																								<td class="Gleich">
																									<xsl:value-of select="$UnterelementO/xdf3:enthaelt/*/xdf3:identifikation/xdf3:version"/>
																								</td>
																							</xsl:when>
																							<xsl:otherwise>
																								<td class="Ungleich">
																									<xsl:value-of select="$UnterelementO/xdf3:enthaelt/*/xdf3:identifikation/xdf3:version"/>
																								</td>
																							</xsl:otherwise>
																						</xsl:choose>
																						<xsl:choose>
																							<xsl:when test="(empty($UnterelementO/xdf3:enthaelt/*/xdf3:name) and empty($UnterelementA/xdf3:enthaelt/*/xdf3:name)) or ($UnterelementO/xdf3:enthaelt/*/xdf3:name = $UnterelementA/xdf3:enthaelt/*/xdf3:name)">
																								<td class="Gleich">
																									<xsl:value-of select="$UnterelementO/xdf3:enthaelt/*/xdf3:name"/><xsl:if test="($UnterelementO/xdf3:enthaelt/*/xdf3:identifikation/xdf3:version != $UnterelementA/xdf3:enthaelt/*/xdf3:identifikation/xdf3:version) or ($UnterelementO/xdf3:enthaelt/*/xdf3:name != $UnterelementA/xdf3:enthaelt/*/xdf3:name) or ($UnterelementO/xdf3:anzahl != $UnterelementA/xdf3:anzahl) or ($UnterelementO/xdf3:bezug != $UnterelementA/xdf3:bezug)"> ##</xsl:if>
																								</td>
																							</xsl:when>
																							<xsl:otherwise>
																								<td class="Ungleich">
																									<xsl:value-of select="$UnterelementO/xdf3:enthaelt/*/xdf3:name"/><xsl:if test="($UnterelementO/xdf3:enthaelt/*/xdf3:identifikation/xdf3:version != $UnterelementA/xdf3:enthaelt/*/xdf3:identifikation/xdf3:version) or ($UnterelementO/xdf3:enthaelt/*/xdf3:name != $UnterelementA/xdf3:enthaelt/*/xdf3:name) or ($UnterelementO/xdf3:anzahl != $UnterelementA/xdf3:anzahl) or ($UnterelementO/xdf3:bezug != $UnterelementA/xdf3:bezug)"> ##</xsl:if>
																								</td>
																							</xsl:otherwise>
																						</xsl:choose>
																						<xsl:choose>
																							<xsl:when test="(empty($UnterelementO/xdf3:anzahl) and empty($UnterelementA/xdf3:anzahl)) or ($UnterelementO/xdf3:anzahl = $UnterelementA/xdf3:anzahl)">
																								<td class="Gleich">
																									<xsl:value-of select="$UnterelementO/xdf3:anzahl"/>
																								</td>
																							</xsl:when>
																							<xsl:otherwise>
																								<td class="Ungleich">
																									<xsl:value-of select="$UnterelementO/xdf3:anzahl"/>
																								</td>
																							</xsl:otherwise>
																						</xsl:choose>
																						<xsl:choose>
																							<xsl:when test="(empty($UnterelementO/xdf3:bezug) and empty($UnterelementA/xdf3:bezug)) or ($UnterelementO/xdf3:bezug = $UnterelementA/xdf3:bezug)">
																								<td class="Gleich">
																									<xsl:value-of select="$UnterelementO/xdf3:bezug"/>
																								</td>
																							</xsl:when>
																							<xsl:otherwise>
																								<td class="Ungleich">
																									<xsl:value-of select="$UnterelementO/xdf3:bezug"/>
																								</td>
																							</xsl:otherwise>
																						</xsl:choose>
																					</xsl:otherwise>
																				</xsl:choose>
																			</tr>
																		</xsl:for-each>

																		<xsl:for-each select="$VergleichsElement/xdf3:struktur">
																			<xsl:variable name="UnterelementO" select="."/>
																			<xsl:variable name="UnterelementA" select="$Element/xdf3:struktur[xdf3:enthaelt/*/xdf3:identifikation/xdf3:id = $UnterelementO/xdf3:enthaelt/*/xdf3:identifikation/xdf3:id]"/>
																			<xsl:choose>
																				<xsl:when test="empty($UnterelementA)">
																					<tr>
																						<td colspan="2"><i>Nicht vorhanden</i></td>
																						<td></td>
																						<td></td>
																						<td></td>
																						<td class="Ungleich">
																							<xsl:element name="a">
																								<xsl:attribute name="href">#X<xsl:value-of select="$UnterelementO/xdf3:enthaelt/*/xdf3:identifikation/xdf3:id"/><xsl:if test="$UnterelementO/xdf3:enthaelt/*/xdf3:identifikation/xdf3:version">V<xsl:value-of select="$UnterelementO/xdf3:enthaelt/*/xdf3:identifikation/xdf3:version"/></xsl:if></xsl:attribute>
																								<xsl:value-of select="$UnterelementO/xdf3:enthaelt/*/xdf3:identifikation/xdf3:id"/>
																							</xsl:element>
																						</td>
																						<td class="Ungleich">
																							<xsl:value-of select="$UnterelementO/xdf3:enthaelt/*/xdf3:identifikation/xdf3:version"/>
																						</td>
																						<td class="Ungleich">
																							<xsl:value-of select="$UnterelementO/xdf3:enthaelt/*/xdf3:name"/> ##
																						</td>
																						<td class="Ungleich">
																							<xsl:value-of select="$UnterelementO/xdf3:anzahl"/>
																						</td>
																						<td class="Ungleich">
																							<xsl:value-of select="$UnterelementO/xdf3:bezug"/>
																						</td>
																					</tr>
																				</xsl:when>
																				<xsl:otherwise>
																				</xsl:otherwise>
																			</xsl:choose>
																		</xsl:for-each>
																	</tbody>
																</table>
															</td>
														</xsl:when>
														<xsl:otherwise>
															<td colspan="2">
															</td>
														</xsl:otherwise>
													</xsl:choose>
												</tr>
											<xsl:if test="count($Element/xdf3:regel) or count($VergleichsElement/xdf3:regel)">
												<tr>
													<td>
														<b>Regeln</b>
													</td>
													<td colspan="2">
														<table width="100%">
															<thead>
																<tr>
																	<th width="5%">ID</th>
																	<th width="5%">Version</th>
																	<th width="18%">Name</th>
																	<th width="22%">Freitextregel</th>
																	<xsl:choose>
																		<xsl:when test="empty($VergleichsElement)">
																			<th width="5%"></th>
																			<th width="5%"></th>
																			<th width="18%"></th>
																			<th width="22%"></th>
																		</xsl:when>
																		<xsl:otherwise>
																			<th width="5%">ID</th>
																			<th width="5%">Version</th>
																			<th width="18%">Name</th>
																			<th width="22%">Freitextregel</th>
																		</xsl:otherwise>
																	</xsl:choose>
																</tr>
															</thead>
															<tbody>
																<xsl:for-each select="$Element/xdf3:regel">

																	<xsl:variable name="UnterelementA" select="."/>
																	<xsl:variable name="UnterelementO" select="$VergleichsElement/xdf3:regel[xdf3:identifikation/xdf3:id = $UnterelementA/xdf3:identifikation/xdf3:id]"/>

																	<tr>
																		<td>
																			<xsl:choose>
																				<xsl:when test="$RegelDetails = '1'">
																					<xsl:element name="a">
																						<xsl:attribute name="href">#<xsl:value-of select="./xdf3:identifikation/xdf3:id"/></xsl:attribute>
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
																			<xsl:value-of select="./xdf3:freitextRegel"/>
																		</td>
																		<xsl:choose>
																			<xsl:when test="empty($VergleichsElement)">
																				<td colspan="4">
																				</td>
																			</xsl:when>
																			<xsl:when test="empty($UnterelementO)">
																				<td colspan="4" class="Ungleich">
																					<i>Nicht vorhanden</i> ##
																				</td>
																			</xsl:when>
																			<xsl:otherwise>
																				<td>
																					<xsl:choose>
																						<xsl:when test="$RegelDetails = '1'">
																							<xsl:element name="a">
																								<xsl:attribute name="href">#X<xsl:value-of select="$UnterelementO/xdf3:identifikation/xdf3:id"/></xsl:attribute>
																								<xsl:value-of select="$UnterelementO/xdf3:identifikation/xdf3:id"/>
																							</xsl:element>
																						</xsl:when>
																						<xsl:otherwise>
																							<xsl:value-of select="$UnterelementO/xdf3:identifikation/xdf3:id"/>
																						</xsl:otherwise>
																					</xsl:choose>
																				</td>
																				<xsl:choose>
																					<xsl:when test="(empty($UnterelementO/xdf3:identifikation/xdf3:version) and empty($UnterelementA/xdf3:identifikation/xdf3:version)) or ($UnterelementO/xdf3:identifikation/xdf3:version = $UnterelementA/xdf3:identifikation/xdf3:version)">
																						<td class="Gleich">
																							<xsl:value-of select="$UnterelementO/xdf3:identifikation/xdf3:version"/>
																						</td>
																					</xsl:when>
																					<xsl:otherwise>
																						<td class="Ungleich">
																							<xsl:value-of select="$UnterelementO/xdf3:identifikation/xdf3:version"/>
																						</td>
																					</xsl:otherwise>
																				</xsl:choose>
																				<xsl:choose>
																					<xsl:when test="(empty($UnterelementO/xdf3:name) and empty($UnterelementA/xdf3:name)) or ($UnterelementO/xdf3:name = $UnterelementA/xdf3:name)">
																						<td class="Gleich">
																							<xsl:value-of select="$UnterelementO/xdf3:name"/><xsl:if test="($UnterelementO/xdf3:identifikation/xdf3:version != $UnterelementA/xdf3:identifikation/xdf3:version) or ($UnterelementO/xdf3:name != $UnterelementA/xdf3:name) or ($UnterelementO/xdf3:definition != $UnterelementA/xdf3:definition)"> ##</xsl:if>
																						</td>
																					</xsl:when>
																					<xsl:otherwise>
																						<td class="Ungleich">
																							<xsl:value-of select="$UnterelementO/xdf3:name"/><xsl:if test="($UnterelementO/xdf3:identifikation/xdf3:version != $UnterelementA/xdf3:identifikation/xdf3:version) or ($UnterelementO/xdf3:name != $UnterelementA/xdf3:name) or ($UnterelementO/xdf3:definition != $UnterelementA/xdf3:definition)"> ##</xsl:if>
																						</td>
																					</xsl:otherwise>
																				</xsl:choose>
																				<xsl:choose>
																					<xsl:when test="(empty($UnterelementO/xdf3:freitextRegel) and empty($UnterelementA/xdf3:freitextRegel)) or ($UnterelementO/xdf3:freitextRegel = $UnterelementA/xdf3:freitextRegel)">
																						<td class="Gleich">
																							<xsl:value-of select="$UnterelementO/xdf3:freitextRegel"/>
																						</td>
																					</xsl:when>
																					<xsl:otherwise>
																						<td class="Ungleich">
																							<xsl:value-of select="$UnterelementO/xdf3:freitextRegel"/>
																						</td>
																					</xsl:otherwise>
																				</xsl:choose>
																			</xsl:otherwise>
																		</xsl:choose>
																	</tr>
																</xsl:for-each>
																<xsl:for-each select="$VergleichsElement/xdf3:regel">
																	<xsl:variable name="UnterelementO" select="."/>
																	<xsl:variable name="UnterelementA" select="$Element/xdf3:regel[xdf3:identifikation/xdf3:id = $UnterelementO/xdf3:identifikation/xdf3:id]"/>
																	<xsl:choose>
																		<xsl:when test="empty($UnterelementA)">
																			<tr>
																				<td colspan="4"/>
																				<td class="Ungleich">
																					<xsl:choose>
																						<xsl:when test="$RegelDetails = '1'">
																							<xsl:element name="a">
																								<xsl:attribute name="href">#X<xsl:value-of select="$UnterelementO/xdf3:identifikation/xdf3:id"/></xsl:attribute>
																								<xsl:value-of select="$UnterelementO/xdf3:identifikation/xdf3:id"/>
																							</xsl:element>
																						</xsl:when>
																						<xsl:otherwise>
																							<xsl:value-of select="$UnterelementO/xdf3:identifikation/xdf3:id"/>
																						</xsl:otherwise>
																					</xsl:choose>
																				</td>
																				<td class="Ungleich">
																					<xsl:value-of select="$UnterelementO/xdf3:identifikation/xdf3:version"/>
																				</td>
																				<td class="Ungleich">
																					<xsl:value-of select="$UnterelementO/xdf3:name"/> ##
																				</td>
																				<td class="Ungleich">
																					<xsl:value-of select="$UnterelementO/xdf3:freitextRegel"/>
																				</td>
																			</tr>
																		</xsl:when>
																		<xsl:otherwise>
																		</xsl:otherwise>
																	</xsl:choose>
																</xsl:for-each>
															</tbody>
														</table>
													</td>
												</tr>
											</xsl:if>
											<tr>
												<td>
													<b>Verwendet in</b>
												</td>
												<xsl:variable name="FeldgruppenID" select="$Element/xdf3:identifikation/xdf3:id"/>
												<xsl:variable name="FeldgruppenVersion" select="$Element/xdf3:identifikation/xdf3:version"/>
												
												<td>
													<table width="100%">
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
															
																	<xsl:for-each-group select="//xdf3:datenfeldgruppe[xdf3:struktur/xdf3:enthaelt/xdf3:datenfeldgruppe/xdf3:identifikation/xdf3:id = $FeldgruppenID]" group-by="xdf3:identifikation/xdf3:id">
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
		
																	<xsl:for-each-group select="//xdf3:stammdatenschema[xdf3:struktur/xdf3:enthaelt/xdf3:datenfeldgruppe/xdf3:identifikation/xdf3:id = $FeldgruppenID]" group-by="xdf3:identifikation/xdf3:id">
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
																	<xsl:for-each-group select="//xdf3:datenfeldgruppe[xdf3:struktur/xdf3:enthaelt/xdf3:datenfeldgruppe/xdf3:identifikation/xdf3:id = $FeldgruppenID and xdf3:struktur/xdf3:enthaelt/xdf3:datenfeldgruppe/xdf3:identifikation/xdf3:version = $FeldgruppenVersion]" group-by="xdf3:identifikation/xdf3:id">
																		<xsl:sort select="./xdf3:identifikation/xdf3:id"/>
																		
																		<xsl:for-each-group select="fn:current-group()" group-by="string(xdf3:identifikation/xdf3:version)">
																			<xsl:sort select="./xdf3:identifikation/xdf3:version"/>
																		
																			<xsl:call-template name="minielementcore">
																				<xsl:with-param name="Element" select="."/>
																			</xsl:call-template>
																		
																		</xsl:for-each-group>
																	</xsl:for-each-group>
		
																	<xsl:for-each-group select="//xdf3:stammdatenschema[xdf3:struktur/xdf3:enthaelt/xdf3:datenfeldgruppe/xdf3:identifikation/xdf3:id = $FeldgruppenID and xdf3:struktur/xdf3:enthaelt/xdf3:datenfeldgruppe/xdf3:identifikation/xdf3:version = $FeldgruppenVersion]" group-by="./xdf3:identifikation/xdf3:id">
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
												<td></td>
											</tr>
										</xsl:when>
									</xsl:choose>
	
									<tr style="page-break-after:always">
										<td colspan="3" class="Navigation">
											<xsl:call-template name="navigationszeile"/>
										</td>
									</tr>
		
		
	</xsl:template>

	<!-- ############################################################################################################# -->

	<xsl:template name="elementdetailsvergleich">
		<xsl:param name="Element"/>
		<xsl:param name="VersionsAnzahl"/>

		
		<xsl:if test="$DebugMode = '2' or $DebugMode = '3' or $DebugMode = '4'">
			<xsl:message>
				++++++++ elementdetailsvergleich ++++++++
			</xsl:message>
		</xsl:if>
		<xsl:if test="$DebugMode = '3' or $DebugMode = '4'">
			<xsl:message>
				-------- <xsl:value-of select="$Element/xdf3:identifikation/xdf3:id"/><xsl:if test="$Element/xdf3:identifikation/xdf3:version">V<xsl:value-of select="$Element/xdf3:identifikation/xdf3:version"/></xsl:if> --------
			</xsl:message>
		</xsl:if>

									<xsl:choose>
										<xsl:when test="$Element/name() = 'xdf3:datenfeld'">
											<tr>
												<td>
													<xsl:element name="a">
														<xsl:attribute name="name">X<xsl:value-of select="$Element/xdf3:identifikation/xdf3:id"/><xsl:if test="$Element/xdf3:identifikation/xdf3:version">V<xsl:value-of select="$Element/xdf3:identifikation/xdf3:version"/></xsl:if></xsl:attribute>
													</xsl:element>
													ID ##
												</td>
												<td><i>Nicht vorhanden</i></td>
												<td class="ElementID Ungleich GeloeschtBaukasten">
													<xsl:value-of select="$Element/xdf3:identifikation/xdf3:id"/>
													<xsl:if test="$ToolAufruf = '1'">
														&#160;&#160;
														<xsl:element name="a">
															<xsl:attribute name="href"><xsl:value-of select="$ToolPfadPrefix"/><xsl:value-of select="$Element/xdf3:identifikation/xdf3:id"/><xsl:if test="$Element/xdf3:identifikation/xdf3:version">V<xsl:value-of select="$Element/xdf3:identifikation/xdf3:version"/></xsl:if><xsl:value-of select="$ToolPfadPostfix"/></xsl:attribute>
															<xsl:attribute name="target">FIMTool</xsl:attribute>
															<xsl:attribute name="title">Springe in den Datenfeldeditor (man muss vorher angemeldet sein).</xsl:attribute>
															&#8658;
														</xsl:element>
													</xsl:if>
												</td>
											</tr>
											<tr>
												<td>Version</td>
												<td></td>
												<td><xsl:value-of select="$Element/xdf3:identifikation/xdf3:version"/></td>
											</tr>
											<tr>
												<td>Versionshinweis</td>
												<td></td>
												<td><xsl:value-of select="fn:replace($Element/xdf3:versionshinweis,'\n','&lt;br/&gt;')" disable-output-escaping="yes"/></td>
											</tr>
											<tr>
												<td>Name</td>
												<td></td>
												<xsl:choose>
													<xsl:when test="empty($Element/xdf3:name/text())">
														<td class="ElementName">
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
												<td>Stichwörter</td>
												<td></td>
												<td>
													<ul class="hangrun">
														<xsl:for-each select="$Element/xdf3:stichwort">
															<li>
																<xsl:value-of select="."/><xsl:if test="./@uri"> (<xsl:value-of select="./@uri"/>)</xsl:if>
															</li>
														</xsl:for-each>
													</ul>
												</td>
											</tr>
											<tr>
												<td>Definition</td>
												<td></td>
												<td><xsl:value-of select="$Element/xdf3:definition"/></td>
											</tr>
											<tr>
												<td>Strukturelementart</td>
												<td></td>
												<td><xsl:apply-templates select="$Element/xdf3:schemaelementart"/></td>
											</tr>
											<tr>
												<td>Handlungsgrundlagen</td>
												<td></td>
												<td>
													<ul class="hangrun">
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
												</td>
											</tr>
											<tr>
												<td>Feldart</td>
												<td></td>
												<td><xsl:apply-templates select="$Element/xdf3:feldart"/></td>
											</tr>
											<tr>
												<td>Datentyp</td>
												<td></td>
												<td><xsl:apply-templates select="$Element/xdf3:datentyp"/></td>
											</tr>
											<tr>
												<td>Feldlänge</td>
												<td></td>
												<xsl:choose>
													<xsl:when test="$Element/xdf3:praezisierung">
														<td>
															<xsl:if test="$Element/xdf3:praezisierung/@minLength != ''">von <xsl:value-of select="$Element/xdf3:praezisierung/@minLength"/></xsl:if>
															<xsl:if test="$Element/xdf3:praezisierung/@maxLength != ''"> bis <xsl:value-of select="$Element/xdf3:praezisierung/@maxLength"/></xsl:if>
														</td>
													</xsl:when>
													<xsl:otherwise>
														<td></td>
													</xsl:otherwise>
												</xsl:choose>
											</tr>
											<tr>
												<td>Wertebereich</td>
												<td></td>
												<xsl:choose>
													<xsl:when test="$Element/xdf3:praezisierung">
														<td>
															<xsl:if test="$Element/xdf3:praezisierung/@minValue != ''">von <xsl:value-of select="$Element/xdf3:praezisierung/@minValue"/></xsl:if>
															<xsl:if test="$Element/xdf3:praezisierung/@maxValue != ''"> bis <xsl:value-of select="$Element/xdf3:praezisierung/@maxValue"/></xsl:if>
														</td>
													</xsl:when>
													<xsl:otherwise>
														<td></td>
													</xsl:otherwise>
												</xsl:choose>
											</tr>
											<tr>
												<td>Pattern</td>
												<td></td>
												<td><xsl:value-of select="$Element/xdf3:praezisierung/@pattern"/></td>
											</tr>
											<xsl:if test="$Element/xdf3:werte">
												<tr>
													<td>Werteliste</td>
													<td></td>
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
																		<td><xsl:value-of select="./xdf3:code"/></td>
																		<td><xsl:value-of select="./xdf3:name"/></td>
																		<td><xsl:value-of select="./xdf3:hilfe"/></td>
																	</tr>
																</xsl:for-each>
															</tbody>
														</table>
													</td>
												</tr>
											</xsl:if>
											<xsl:if test="$Element/xdf3:codelisteReferenz">
												<tr>
													<td>Referenzierte Codeliste</td>
													<td></td>
													<td>
														<xsl:element name="a">
															<xsl:attribute name="href">#<xsl:value-of select="$Element/xdf3:codelisteReferenz/xdf3:canonicalIdentification"/><xsl:if test="$Element/xdf3:codelisteReferenz/xdf3:version">_<xsl:value-of select="$Element/xdf3:codelisteReferenz/xdf3:version"/></xsl:if></xsl:attribute>
															<xsl:value-of select="$Element/xdf3:codelisteReferenz/xdf3:canonicalIdentification"/>
															<xsl:if test="$Element/xdf3:codelisteReferenz/xdf3:version">_<xsl:value-of select="$Element/xdf3:codelisteReferenz/xdf3:version"/>
															</xsl:if>
														</xsl:element>
													</td>
												</tr>
												<tr>
													<td>Spaltendefinitionen zur referenzierten Codeliste</td>
													<td></td>
													<td>
														<xsl:if test="$Element/xdf3:codeKey/text() !='' or $Element/xdf3:nameKey/text() !='' or $Element/xdf3:helpKey/text() !=''">
															<table>
																<tbody>
																	<tr>
																		<th>Spaltentyp</th>
																		<th>Spalte in der referenzierten Codeliste</th>
																	</tr>
																	<tr>
																		<td>Code</td>
																		<td><xsl:value-of select="$Element/xdf3:codeKey"/></td>
																	</tr>
																	<tr>
																		<td>Name</td>
																		<td><xsl:value-of select="$Element/xdf3:nameKey"/></td>
																	</tr>
																	<tr>
																		<td>Hilfetext</td>
																		<td><xsl:value-of select="$Element/xdf3:helpKey"/></td>
																	</tr>
																</tbody>
															</table>
														</xsl:if>
													</td>
												</tr>
											</xsl:if>
											<tr>
												<td>Inhalt</td>
												<td></td>
												<td><xsl:value-of select="fn:replace($Element/xdf3:inhalt,'\n','&lt;br/&gt;')" disable-output-escaping="yes"/></td>
											</tr>
											<tr>
												<td>Maximale Dateigröße</td>
												<td></td>
												<xsl:choose>
													<xsl:when test="empty($Element/xdf3:maxSize/text())">
														<td></td>
													</xsl:when>
													<xsl:otherwise>
														<td><xsl:value-of select="fn:format-number(number($Element/xdf3:maxSize) div 1000000,'###.###,00', 'european')"/> MB</td>
													</xsl:otherwise>
												</xsl:choose>
											</tr>
											<tr>
												<td>Erlaubte Dateitypen</td>
												<td></td>
												<td>
													<ul class="hangrun">
														<xsl:for-each select="$Element/xdf3:mediaType">
															<li><xsl:value-of select="."/></li>
														</xsl:for-each>
													</ul>
												</td>
											</tr>
											<tr>
												<td>Vorbefüllung</td>
												<td></td>
												<td><xsl:apply-templates select="$Element/xdf3:vorbefuellung"/></td>
											</tr>
											<tr>
												<td>Beschreibung</td>
												<td></td>
												<td><xsl:value-of select="fn:replace($Element/xdf3:beschreibung,'\n','&lt;br/&gt;')" disable-output-escaping="yes"/></td>
											</tr>
											<tr>
												<td>Bezeichnung Eingabe</td>
												<td></td>
												<td><xsl:value-of select="$Element/xdf3:bezeichnungEingabe"/></td>
											</tr>
											<tr>
												<td>Bezeichnung Ausgabe</td>
												<td></td>
												<td><xsl:value-of select="$Element/xdf3:bezeichnungAusgabe"/></td>
											</tr>
											<tr>
												<td>Hilfetext Eingabe</td>
												<td></td>
												<td><xsl:value-of select="fn:replace($Element/xdf3:hilfetextEingabe,'\n','&lt;br/&gt;')" disable-output-escaping="yes"/></td>
											</tr>
											<tr>
												<td>Hilfetext Ausgabe</td>
												<td></td>
												<td><xsl:value-of select="fn:replace($Element/xdf3:hilfetextAusgabe,'\n','&lt;br/&gt;')" disable-output-escaping="yes"/></td>
											</tr>
											<tr>
												<td>Gültig ab</td>
												<td></td>
												<td><xsl:value-of select="$Element/xdf3:gueltigAb"/></td>
											</tr>
											<tr>
												<td>Gültig bis</td>
												<td></td>
												<td><xsl:value-of select="$Element/xdf3:gueltigBis"/></td>
											</tr>
											<tr>
												<td>Fachlicher Ersteller</td>
												<td></td>
												<td><xsl:value-of select="$Element/xdf3:statusGesetztDurch"/></td>
											</tr>
											<tr>
												<td>Status</td>
												<td></td>
												<td><xsl:apply-templates select="$Element/xdf3:freigabestatus"/></td>
											</tr>
											<tr>
												<td>Status gesetzt am</td>
												<td></td>
												<td><xsl:value-of select="fn:format-date($Element/xdf3:statusGesetztAm,'[D01].[M01].[Y0001]')"/></td>
											</tr>
											<tr>
												<td>Veröffentlichungsdatum</td>
												<td></td>
												<td><xsl:value-of select="fn:format-date($Element/xdf3:veroeffentlichungsdatum,'[D01].[M01].[Y0001]')"/></td>
											</tr>
											<tr>
												<td>Letzte Änderung</td>
												<td></td>
												<td><xsl:value-of select="fn:format-dateTime($Element/xdf3:letzteAenderung,'[D01].[M01].[Y0001] um [H01]:[m01] Uhr')"/></td>
											</tr>
											<xsl:if test="count($Element/xdf3:regel)">
												<tr>
													<td>
														<b>Regeln</b>
													</td>
													<td colspan="2">
														<table width="100%">
															<thead>
																<tr>
																	<th width="5%"></th>
																	<th width="5%"></th>
																	<th width="18%"></th>
																	<th width="22%"></th>
																	<th width="5%">ID</th>
																	<th width="5%">Version</th>
																	<th width="18%">Name</th>
																	<th width="22%">Freitextregel</th>
																</tr>
															</thead>
															<tbody>
																<xsl:for-each select="$Element/xdf3:regel">

																	<tr>
																		<td colspan="4"></td>
																		<td>
																			<xsl:choose>
																				<xsl:when test="$RegelDetails = '1'">
																					<xsl:element name="a">
																						<xsl:attribute name="href">#X<xsl:value-of select="./xdf3:identifikation/xdf3:id"/></xsl:attribute>
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
																			<xsl:value-of select="./xdf3:freitextRegel"/>
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
													<b>Verwendet in</b>
												</td>
												<td></td>

												<xsl:variable name="FeldID" select="$Element/xdf3:identifikation/xdf3:id"/>
												<xsl:variable name="FeldVersion" select="$Element/xdf3:identifikation/xdf3:version"/>
												
												<td>
													<table width="100%">
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
																
																		<xsl:for-each-group select="//xdf3:datenfeldgruppe[xdf3:struktur/xdf3:enthaelt/xdf3:datenfeld/xdf3:identifikation/xdf3:id = $FeldID]" group-by="xdf3:identifikation/xdf3:id">
																			<xsl:sort select="./xdf3:identifikation/xdf3:id"/>
																			
																			<xsl:for-each-group select="fn:current-group()" group-by="string(xdf3:identifikation/xdf3:version)">
																				<xsl:sort select="./xdf3:identifikation/xdf3:version"/>
																			
																			<xsl:if test="current-grouping-key()=''">
																			
																				<xsl:call-template name="minielementcorevergleich">
																					<xsl:with-param name="Element" select="."/>
																				</xsl:call-template>
																			</xsl:if>
																			
																			</xsl:for-each-group>

																		</xsl:for-each-group>
			
																		<xsl:for-each-group select="//xdf3:stammdatenschema[xdf3:struktur/xdf3:enthaelt/xdf3:datenfeld/xdf3:identifikation/xdf3:id = $FeldID]" group-by="xdf3:identifikation/xdf3:id">
																			<xsl:sort select="./xdf3:identifikation/xdf3:id"/>
																			
																			<xsl:for-each-group select="fn:current-group()" group-by="string(xdf3:identifikation/xdf3:version)">
																				<xsl:sort select="./xdf3:identifikation/xdf3:version"/>
																			
																			<xsl:if test="current-grouping-key()=''">
																			
																				<xsl:call-template name="minielementcorevergleich">
																					<xsl:with-param name="Element" select="."/>
																				</xsl:call-template>
																			</xsl:if>
																			
																			</xsl:for-each-group>

																		</xsl:for-each-group>
			
																</xsl:when>
																<xsl:otherwise>
																		<xsl:for-each-group select="//xdf3:datenfeldgruppe[xdf3:struktur/xdf3:enthaelt/xdf3:datenfeld/xdf3:identifikation/xdf3:id = $FeldID and xdf3:struktur/xdf3:enthaelt/xdf3:datenfeld/xdf3:identifikation/xdf3:version = $FeldVersion]" group-by="xdf3:identifikation/xdf3:id">
																			<xsl:sort select="./xdf3:identifikation/xdf3:id"/>
																			
																			<xsl:for-each-group select="fn:current-group()" group-by="string(xdf3:identifikation/xdf3:version)">
																				<xsl:sort select="./xdf3:identifikation/xdf3:version"/>
																			
																				<xsl:call-template name="minielementcorevergleich">
																					<xsl:with-param name="Element" select="."/>
																				</xsl:call-template>
																			
																			</xsl:for-each-group>
																		</xsl:for-each-group>
			
																		<xsl:for-each-group select="//xdf3:stammdatenschema[xdf3:struktur/xdf3:enthaelt/xdf3:datenfeld/xdf3:identifikation/xdf3:id = $FeldID and xdf3:struktur/xdf3:enthaelt/xdf3:datenfeld/xdf3:identifikation/xdf3:version = $FeldVersion]" group-by="./xdf3:identifikation/xdf3:id">
																			<xsl:sort select="./xdf3:identifikation/xdf3:id"/>
																			
																			<xsl:for-each-group select="fn:current-group()" group-by="string(xdf3:identifikation/xdf3:version)">
																				<xsl:sort select="./xdf3:identifikation/xdf3:version"/>
																			
																				<xsl:call-template name="minielementcorevergleich">
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
										</xsl:when>
										<xsl:when test="$Element/name() = 'xdf3:datenfeldgruppe'">
											<tr>
												<td>
													<xsl:element name="a">
														<xsl:attribute name="name">X<xsl:value-of select="$Element/xdf3:identifikation/xdf3:id"/><xsl:if test="$Element/xdf3:identifikation/xdf3:version">V<xsl:value-of select="$Element/xdf3:identifikation/xdf3:version"/></xsl:if></xsl:attribute>
													</xsl:element>
													ID ##
												</td>
												<td><i>Nicht vorhanden</i></td>
												<td class="ElementID Ungleich GeloeschtBaukasten">
													<xsl:value-of select="$Element/xdf3:identifikation/xdf3:id"/>
													<xsl:if test="$ToolAufruf = '1'">
														&#160;&#160;
														<xsl:element name="a">
															<xsl:attribute name="href"><xsl:value-of select="$ToolPfadPrefix"/><xsl:value-of select="$Element/xdf3:identifikation/xdf3:id"/><xsl:if test="$Element/xdf3:identifikation/xdf3:version">V<xsl:value-of select="$Element/xdf3:identifikation/xdf3:version"/></xsl:if><xsl:value-of select="$ToolPfadPostfix"/></xsl:attribute>
															<xsl:attribute name="target">FIMTool</xsl:attribute>
															<xsl:attribute name="title">Springe in den Datenfeldeditor (man muss vorher angemeldet sein).</xsl:attribute>
															&#8658;
														</xsl:element>
													</xsl:if>
												</td>
											</tr>	
											<tr>
												<td>Version</td>
												<td></td>
												<td><xsl:value-of select="$Element/xdf3:identifikation/xdf3:version"/></td>
											</tr>
											<tr>
												<td>Versionshinweis</td>
												<td></td>
												<td><xsl:value-of select="fn:replace($Element/xdf3:versionshinweis,'\n','&lt;br/&gt;')" disable-output-escaping="yes"/></td>
											</tr>
											<tr>
												<td>Name</td>
												<td></td>
												<td class="ElementName"><xsl:value-of select="$Element/xdf3:name"/></td>
											</tr>
											<tr>
												<td>Stichwörter</td>
												<td></td>
												<td>
													<ul class="hangrun">
														<xsl:for-each select="$Element/xdf3:stichwort">
															<li>
																<xsl:value-of select="."/><xsl:if test="./@uri"> (<xsl:value-of select="./@uri"/>)</xsl:if>
															</li>
														</xsl:for-each>
													</ul>
												</td>
											</tr>
											<tr>
												<td>Definition</td>
												<td></td>
												<td><xsl:value-of select="fn:replace($Element/xdf3:definition,'\n','&lt;br/&gt;')" disable-output-escaping="yes"/></td>
											</tr>
											<tr>
												<td>Strukturelementart</td>
												<td></td>
												<td><xsl:apply-templates select="$Element/xdf3:schemaelementart"/></td>
											</tr>
											<tr>
												<td>Gruppenart</td>
												<td></td>
												<td><xsl:apply-templates select="$Element/xdf3:art"/></td>
											</tr>
											<tr>
												<td>Handlungsgrundlagen</td>
												<td></td>
												<td>
													<ul class="hangrun">
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
												</td>
											</tr>
											<tr>
												<td>Beschreibung</td>
												<td></td>
												<td><xsl:value-of select="fn:replace($Element/xdf3:beschreibung,'\n','&lt;br/&gt;')" disable-output-escaping="yes"/></td>
											</tr>
											<tr>
												<td>Bezeichnung Eingabe</td>
												<td></td>
												<td><xsl:value-of select="$Element/xdf3:bezeichnungEingabe"/></td>
											</tr>
											<tr>
												<td>Bezeichnung Ausgabe</td>
												<td></td>
												<td><xsl:value-of select="$Element/xdf3:bezeichnungAusgabe"/></td>
											</tr>
											<tr>
												<td>Hilfetext Eingabe</td>
												<td></td>
												<td><xsl:value-of select="fn:replace($Element/xdf3:hilfetextEingabe,'\n','&lt;br/&gt;')" disable-output-escaping="yes"/></td>
											</tr>
											<tr>
												<td>Hilfetext Ausgabe</td>
												<td></td>
												<td><xsl:value-of select="fn:replace($Element/xdf3:hilfetextAusgabe,'\n','&lt;br/&gt;')" disable-output-escaping="yes"/></td>
											</tr>
											<tr>
												<td>Gültig ab</td>
												<td></td>
												<td><xsl:value-of select="$Element/xdf3:gueltigAb"/></td>
											</tr>
											<tr>
												<td>Gültig bis</td>
												<td></td>
												<td><xsl:value-of select="$Element/xdf3:gueltigBis"/></td>
											</tr>
											<tr>
												<td>Fachlicher Ersteller</td>
												<td></td>
												<td><xsl:value-of select="$Element/xdf3:statusGesetztDurch"/></td>
											</tr>
											<tr>
												<td>Status</td>
												<td></td>
												<td><xsl:apply-templates select="$Element/xdf3:freigabestatus"/></td>
											</tr>
											<tr>
												<td>Status gesetzt am</td>
												<td></td>
												<td><xsl:value-of select="fn:format-date($Element/xdf3:statusGesetztAm,'[D01].[M01].[Y0001]')"/></td>
											</tr>
											<tr>
												<td>Veröffentlichungsdatum</td>
												<td></td>
												<td><xsl:value-of select="fn:format-date($Element/xdf3:veroeffentlichungsdatum,'[D01].[M01].[Y0001]')"/></td>
											</tr>
											<tr>
												<td>Letzte Änderung</td>
												<td></td>
												<td><xsl:value-of select="fn:format-dateTime($Element/xdf3:letzteAenderung,'[D01].[M01].[Y0001] um [H01]:[m01] Uhr')"/></td>
											</tr>
											<tr>
												<xsl:variable name="AnzahlUnterelemente" select="count($Element/xdf3:struktur)"/>

												<td>
													<b>Unterelemente</b>
												</td>
												<xsl:choose>
													<xsl:when test="($AnzahlUnterelemente &gt; 0)">
														<td colspan="2">
															<table width="100%">
																<thead>
																	<tr>
																		<th width="5%"></th>
																		<th width="5%"></th>
																		<th width="17%"></th>
																		<th width="5%"></th>
																		<th width="18%"></th>
																		<th width="5%">ID</th>
																		<th width="5%">Version</th>
																		<th width="17%">Name</th>
																		<th width="5%">Kardinalität</th>
																		<th width="18%">Bezug zu</th>
																	</tr>
																</thead>
																<tbody>
																	<xsl:variable name="Strukturelementart"><xsl:value-of select="./xdf3:schemaelementart/code"/></xsl:variable>
																
																	<xsl:for-each select="$Element/xdf3:struktur">
																	
																		<tr>
																			<td colspan="2"><i>Nicht vorhanden</i></td>
																			<td></td>
																			<td></td>
																			<td></td>
																			<td>
																				<xsl:element name="a">
																					<xsl:attribute name="href">#X<xsl:value-of select="./xdf3:enthaelt/*/xdf3:identifikation/xdf3:id"/><xsl:if test="./xdf3:enthaelt/*/xdf3:identifikation/xdf3:version">V<xsl:value-of select="./xdf3:enthaelt/*/xdf3:identifikation/xdf3:version"/></xsl:if></xsl:attribute>
																					<xsl:value-of select="./xdf3:enthaelt/*/xdf3:identifikation/xdf3:id"/>
																				</xsl:element>
																			</td>
																			<td>
																				<xsl:value-of select="./xdf3:enthaelt/*/xdf3:identifikation/xdf3:version"/>
																			</td>
																			<td>
																				<xsl:value-of select="./xdf3:enthaelt/*/xdf3:name"/>
																			</td>
																			<xsl:choose>
																				<xsl:when test="./xdf3:anzahl='0:0'">
																					<td>
																						<xsl:value-of select="./xdf3:anzahl"/>
																					</td>
																				</xsl:when>
																				<xsl:otherwise>
																					<td>
																						<xsl:value-of select="./xdf3:anzahl"/>
																					</td>
																				</xsl:otherwise>
																			</xsl:choose>
																			<xsl:choose>
																				<xsl:when test="$Strukturelementart ='RNG' and (./xdf3:enthaelt/*/xdf3:schemaelementart/code/text() = 'ABS' or ./xdf3:enthaelt/*/xdf3:schemaelementart/code/text() = 'HAR') and empty(./xdf3:bezug/text())">
																					<td>
																					</td>
																				</xsl:when>
																				<xsl:otherwise>
																					<td>
																						<xsl:value-of select="./xdf3:bezug"/>
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
														<td colspan="2">
														</td>
													</xsl:otherwise>
												</xsl:choose>
											</tr>
											<xsl:if test="count($Element/xdf3:regel)">
												<tr>
													<td>
														<b>Regeln</b>
													</td>
													<td colspan="2">
														<table width="100%">
															<thead>
																<tr>
																	<th width="5%"></th>
																	<th width="5%"></th>
																	<th width="18%"></th>
																	<th width="22%"></th>
																	<th width="5%">ID</th>
																	<th width="5%">Version</th>
																	<th width="18%">Name</th>
																	<th width="22%">Freitextregel</th>
																</tr>
															</thead>
															<tbody>
																<xsl:for-each select="$Element/xdf3:regel">

																	<tr>
																		<td colspan="4"></td>
																		<td>
																			<xsl:choose>
																				<xsl:when test="$RegelDetails = '1'">
																					<xsl:element name="a">
																						<xsl:attribute name="href">#X<xsl:value-of select="./xdf3:identifikation/xdf3:id"/></xsl:attribute>
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
																			<xsl:value-of select="./xdf3:freitextRegel"/>
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
													<b>Verwendet in</b>
												</td>
												<xsl:variable name="FeldgruppenID" select="$Element/xdf3:identifikation/xdf3:id"/>
												<xsl:variable name="FeldgruppenVersion" select="$Element/xdf3:identifikation/xdf3:version"/>
												<td></td>
												<td>
													<table width="100%">
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
															
																	<xsl:for-each-group select="$VergleichsDaten//xdf3:datenfeldgruppe[xdf3:struktur/xdf3:enthaelt/xdf3:datenfeldgruppe/xdf3:identifikation/xdf3:id = $FeldgruppenID]" group-by="xdf3:identifikation/xdf3:id">
																		<xsl:sort select="./xdf3:identifikation/xdf3:id"/>
																		
																		<xsl:for-each-group select="fn:current-group()" group-by="string(xdf3:identifikation/xdf3:version)">
																			<xsl:sort select="./xdf3:identifikation/xdf3:version"/>
																		
																		<xsl:if test="current-grouping-key()=''">
																		
																			<xsl:call-template name="minielementcorevergleich">
																				<xsl:with-param name="Element" select="."/>
																			</xsl:call-template>
																		</xsl:if>
																		
																		</xsl:for-each-group>

																	</xsl:for-each-group>
		
																	<xsl:for-each-group select="$VergleichsDaten//xdf3:stammdatenschema[xdf3:struktur/xdf3:enthaelt/xdf3:datenfeldgruppe/xdf3:identifikation/xdf3:id = $FeldgruppenID]" group-by="xdf3:identifikation/xdf3:id">
																		<xsl:sort select="./xdf3:identifikation/xdf3:id"/>
																		
																		<xsl:for-each-group select="fn:current-group()" group-by="string(xdf3:identifikation/xdf3:version)">
																			<xsl:sort select="./xdf3:identifikation/xdf3:version"/>
																		
																		<xsl:if test="current-grouping-key()=''">
																		
																			<xsl:call-template name="minielementcorevergleich">
																				<xsl:with-param name="Element" select="."/>
																			</xsl:call-template>
																		</xsl:if>
																		
																		</xsl:for-each-group>

																	</xsl:for-each-group>
		
															</xsl:when>
															<xsl:otherwise>
																	<xsl:for-each-group select="$VergleichsDaten//xdf3:datenfeldgruppe[xdf3:struktur/xdf3:enthaelt/xdf3:datenfeldgruppe/xdf3:identifikation/xdf3:id = $FeldgruppenID and xdf3:struktur/xdf3:enthaelt/xdf3:datenfeldgruppe/xdf3:identifikation/xdf3:version = $FeldgruppenVersion]" group-by="xdf3:identifikation/xdf3:id">
																		<xsl:sort select="./xdf3:identifikation/xdf3:id"/>
																		
																		<xsl:for-each-group select="fn:current-group()" group-by="string(xdf3:identifikation/xdf3:version)">
																			<xsl:sort select="./xdf3:identifikation/xdf3:version"/>
																		
																			<xsl:call-template name="minielementcorevergleich">
																				<xsl:with-param name="Element" select="."/>
																			</xsl:call-template>
																		
																		</xsl:for-each-group>
																	</xsl:for-each-group>
		
																	<xsl:for-each-group select="$VergleichsDaten//xdf3:stammdatenschema[xdf3:struktur/xdf3:enthaelt/xdf3:datenfeldgruppe/xdf3:identifikation/xdf3:id = $FeldgruppenID and xdf3:struktur/xdf3:enthaelt/xdf3:datenfeldgruppe/xdf3:identifikation/xdf3:version = $FeldgruppenVersion]" group-by="./xdf3:identifikation/xdf3:id">
																		<xsl:sort select="./xdf3:identifikation/xdf3:id"/>
																		
																		<xsl:for-each-group select="fn:current-group()" group-by="string(xdf3:identifikation/xdf3:version)">
																			<xsl:sort select="./xdf3:identifikation/xdf3:version"/>
																		
																			<xsl:call-template name="minielementcorevergleich">
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
										</xsl:when>
									</xsl:choose>
	
									<tr style="page-break-after:always">
										<td colspan="3" class="Navigation">
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

					<h2><br/></h2>
					<h2>
						<xsl:choose>
							<xsl:when test="name(/*) ='xdf3:xdatenfelder.stammdatenschema.0102'">
								<a name="RegelDetails"/>Details zu den Regeln des Datenschemas <xsl:value-of select="$NameSDSA"/> im Vergleich mit Datenschema <xsl:value-of select="$NameSDSO"/>
							</xsl:when>
							<xsl:when test="name(/*) ='xdf3:xdatenfelder.datenfeldgruppe.0103'">
								<a name="RegelDetails"/>Details zu den Regeln der Datenfeldgruppe <xsl:value-of select="$NameSDSA"/> im Vergleich mit Datenfeldgruppe <xsl:value-of select="$NameSDSO"/>
							</xsl:when>
						</xsl:choose>
					</h2>
					<table style="page-break-after:always">
						<thead>
							<xsl:choose>
								<xsl:when test="name(/*) ='xdf3:xdatenfelder.stammdatenschema.0102'">
									<tr>
										<th width="10%">Metadatum</th>
										<th width="45%">Inhalt Datenschema <xsl:value-of select="$NameSDSA"/></th>
										<th width="45%">Inhalt Datenschema <xsl:value-of select="$NameSDSO"/></th>
									</tr>
								</xsl:when>
								<xsl:when test="name(/*) ='xdf3:xdatenfelder.datenfeldgruppe.0103'">
									<tr>
										<th width="10%">Metadatum</th>
										<th width="45%">Inhalt Datenfeldgruppe <xsl:value-of select="$NameSDSA"/></th>
										<th width="45%">Inhalt Datenfeldgruppe <xsl:value-of select="$NameSDSO"/></th>
									</tr>
								</xsl:when>
							</xsl:choose>
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

							<xsl:for-each-group select="$VergleichsDaten//xdf3:regel" group-by="xdf3:identifikation/xdf3:id">
								<xsl:sort select="./xdf3:identifikation/xdf3:id"/>
									
								<xsl:for-each-group select="fn:current-group()" group-by="string(xdf3:identifikation/xdf3:version)">
									<xsl:sort select="./xdf3:identifikation/xdf3:version"/>
									
									<xsl:variable name="CheckId" select="./xdf3:identifikation/xdf3:id"/>

									<xsl:if test="empty($Daten//xdf3:identifikation[xdf3:id = $CheckId])">

										<xsl:call-template name="regeldetailsvergleich">
											<xsl:with-param name="Element" select="."/>
										</xsl:call-template>
									
									</xsl:if>

									
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

		<xsl:variable name="Temp" select="$VergleichsDaten//*[xdf3:identifikation/xdf3:id = $Element/xdf3:identifikation/xdf3:id]"/>
		<xsl:variable name="VergleichsElement" select="$Temp[1]"/>
		
		<xsl:if test="$DebugMode = '3' or $DebugMode = '4'">
			<xsl:message>
				-------- <xsl:value-of select="$Element/xdf3:identifikation/xdf3:id"/><xsl:if test="$Element/xdf3:identifikation/xdf3:version">V<xsl:value-of select="$Element/xdf3:identifikation/xdf3:version"/></xsl:if> --------
			</xsl:message>
		</xsl:if>

								<tr>
									<td>
										<xsl:element name="a">
											<xsl:attribute name="name"><xsl:value-of select="$Element/xdf3:identifikation/xdf3:id"/></xsl:attribute>
										</xsl:element>
										ID <xsl:if test="empty($VergleichsElement)">##</xsl:if>
									</td>
									<td class="RegelID">
										<xsl:value-of select="$Element/xdf3:identifikation/xdf3:id"/>
										<xsl:if test="$ToolAufruf = '1'">
											&#160;&#160;
											<xsl:element name="a">
												<xsl:attribute name="href"><xsl:value-of select="$ToolPfadPrefix"/><xsl:value-of select="$Element/xdf3:identifikation/xdf3:id"/><xsl:if test="$Element/xdf3:identifikation/xdf3:version">V<xsl:value-of select="$Element/xdf3:identifikation/xdf3:version"/></xsl:if><xsl:value-of select="$ToolPfadPostfix"/></xsl:attribute>
												<xsl:attribute name="target">FIMTool</xsl:attribute>
												<xsl:attribute name="title">Springe in den Datenfeldeditor (man muss vorher angemeldet sein).</xsl:attribute>
												&#8658;
											</xsl:element>
										</xsl:if>
									</td>
									<xsl:choose>
										<xsl:when test="empty($VergleichsElement)">
											<td class="Ungleich"><i>Nicht vorhanden</i></td>
										</xsl:when>
										<xsl:otherwise>
											<td class="RegelID">
												<xsl:element name="a">
													<xsl:attribute name="name">X<xsl:value-of select="$VergleichsElement/xdf3:identifikation/xdf3:id"/></xsl:attribute>
												</xsl:element>
												<xsl:value-of select="$VergleichsElement/xdf3:identifikation/xdf3:id"/>
												<xsl:if test="$ToolAufruf = '1'">
													&#160;&#160;
													<xsl:element name="a">
														<xsl:attribute name="href"><xsl:value-of select="$ToolPfadPrefix"/><xsl:value-of select="$VergleichsElement/xdf3:identifikation/xdf3:id"/><xsl:if test="$VergleichsElement/xdf3:identifikation/xdf3:version">V<xsl:value-of select="$VergleichsElement/xdf3:identifikation/xdf3:version"/></xsl:if><xsl:value-of select="$ToolPfadPostfix"/></xsl:attribute>
														<xsl:attribute name="target">FIMTool</xsl:attribute>
														<xsl:attribute name="title">Springe in den Datenfeldeditor (man muss vorher angemeldet sein).</xsl:attribute>
														&#8658;
													</xsl:element>
												</xsl:if>
											</td>
										</xsl:otherwise>
									</xsl:choose>
								</tr>
								<tr>
									<td>Name <xsl:if test="fn:not(empty($VergleichsElement)) and (fn:not((empty($Element/xdf3:name) and empty($VergleichsElement/xdf3:name)) or ($Element/xdf3:name = $VergleichsElement/xdf3:name)))">##</xsl:if></td>
									<xsl:choose>
										<xsl:when test="empty($Element/xdf3:name/text())">
											<td class="ElementName">
											</td>
										</xsl:when>
										<xsl:otherwise>
											<td class="ElementName">
												<xsl:value-of select="$Element/xdf3:name"/>
											</td>
										</xsl:otherwise>
									</xsl:choose>
									<xsl:choose>
										<xsl:when test="empty($VergleichsElement) or (empty($Element/xdf3:name) and empty($VergleichsElement/xdf3:name)) or ($Element/xdf3:name = $VergleichsElement/xdf3:name)">
											<td class="ElementName Gleich">
												<xsl:value-of select="$VergleichsElement/xdf3:name"/>
											</td>
										</xsl:when>
										<xsl:otherwise>
											<td class="ElementName Ungleich">
												<xsl:value-of select="$VergleichsElement/xdf3:name"/>
											</td>
										</xsl:otherwise>
									</xsl:choose>
								</tr>
								<xsl:if test="count($Element/xdf3:stichwort) = 0 and count($VergleichsElement/xdf3:stichwort) = 0">
									<tr>
										<td>Stichwörter</td>
										<td></td>
										<td></td>
									</tr>
								</xsl:if>
								<xsl:for-each select="$Element/xdf3:stichwort">
									<xsl:variable name="stichwort" select="./text()"/>
									<xsl:variable name="uri"><xsl:value-of select="./@uri"/></xsl:variable>
									<xsl:variable name="VergleichsStichwort" select="$VergleichsElement/xdf3:stichwort[./text() = $stichwort]"/>
									<xsl:variable name="VergleichsURI"><xsl:value-of select="$VergleichsElement/xdf3:stichwort[./text() = $stichwort]/@uri"/></xsl:variable>
									
									<tr>
										<xsl:choose>
											<xsl:when test="fn:position() = 1"><td>Stichwörter</td></xsl:when>
											<xsl:otherwise><td></td></xsl:otherwise>
										</xsl:choose>
										<td>
											<ul class="hangrun">
												<li>
													<xsl:value-of select="."/><xsl:if test="@uri and ./@uri != ''"> (<xsl:value-of select="./@uri"/>)</xsl:if>
												</li>
											</ul>
										</td>
										<xsl:choose>
											<xsl:when test="empty($VergleichsElement)">
												<td class="Gleich">
													<ul class="hangrun">
													</ul>
												</td>
											</xsl:when>
											<xsl:when test="empty($VergleichsStichwort)">
												<td class="Ungleich">
													<ul class="hangrun">
														<li><i>Nicht vorhanden</i> ##</li>
													</ul>
												</td>
											</xsl:when>
											<xsl:when test="$uri != $VergleichsURI">
												<td class="Ungleich">
													<ul class="hangrun">
														<li>
															<xsl:value-of select="$VergleichsElement/xdf3:stichwort[./text() = $stichwort]/text()"/><xsl:if test="$VergleichsElement/xdf3:stichwort[./text() = $stichwort]/@uri and $VergleichsElement/xdf3:stichwort[./text() = $stichwort]/@uri != ''"> (<xsl:value-of select="$VergleichsElement/xdf3:stichwort[./text() = $stichwort]/@uri"/>)</xsl:if> ##
														</li>
													</ul>
												</td>
											</xsl:when>
											<xsl:otherwise>
												<td class="Gleich">
													<ul class="hangrun">
														<li>
															<xsl:value-of select="$VergleichsElement/xdf3:stichwort[./text() = $stichwort]/text()"/><xsl:if test="$VergleichsElement/xdf3:stichwort[./text() = $stichwort]/@uri and $VergleichsElement/xdf3:stichwort[./text() = $stichwort]/@uri != ''"> (<xsl:value-of select="$VergleichsElement/xdf3:stichwort[./text() = $stichwort]/@uri"/>)</xsl:if>
														</li>
													</ul>
												</td>
											</xsl:otherwise>
										</xsl:choose>
									</tr>
								</xsl:for-each>
								<xsl:for-each select="$VergleichsElement/xdf3:stichwort">
									<xsl:variable name="stichwort" select="./text()"/>
									<xsl:variable name="uri"><xsl:value-of select="./@link"/></xsl:variable>
									<xsl:variable name="OriginalStichwort" select="$Element/xdf3:stichwort[./text() = $stichwort]"/>
									<xsl:variable name="OriginalURI"><xsl:value-of select="$Element/xdf3:stichwort[./text() = $stichwort]/@link"/></xsl:variable>
									
									<xsl:if test="not($Element/xdf3:stichwort[./text() = $stichwort])">
										<tr>
											<xsl:choose>
												<xsl:when test="count($Element/xdf3:stichwort) = 0 and fn:position() = 1"><td>Stichwörter</td></xsl:when>
												<xsl:otherwise><td></td></xsl:otherwise>
											</xsl:choose>
											<td>
												<ul class="hangrun">
													<li>
														<i>Nicht vorhanden</i>
													</li>
												</ul>
											</td>
											<td class="Ungleich">
												<ul class="hangrun">
													<li>
														<xsl:value-of select="./text()"/><xsl:if test="./@uri and ./@uri != ''"> (<xsl:value-of select="./@uri"/>)</xsl:if> ##
													</li>
												</ul>
											</td>
										</tr>
									</xsl:if>
								</xsl:for-each>
								<tr>
									<td>Freitextregel <xsl:if test="fn:not(empty($VergleichsElement)) and (fn:not((empty($Element/xdf3:freitextRegel) and empty($VergleichsElement/xdf3:freitextRegel)) or ($Element/xdf3:freitextRegel = $VergleichsElement/xdf3:freitextRegel)))">##</xsl:if></td>
									<td>
										<xsl:value-of select="fn:replace($Element/xdf3:freitextRegel,'\n','&lt;br/&gt;')" disable-output-escaping="yes"/>
									</td>
									<xsl:choose>
										<xsl:when test="empty($VergleichsElement) or (empty($Element/xdf3:freitextRegel) and empty($VergleichsElement/xdf3:freitextRegel)) or ($Element/xdf3:freitextRegel = $VergleichsElement/xdf3:freitextRegel)">
											<td class="Gleich">
												<xsl:value-of select="fn:replace($VergleichsElement/xdf3:freitextRegel,'\n','&lt;br/&gt;')" disable-output-escaping="yes"/>
											</td>
										</xsl:when>
										<xsl:otherwise>
											<td class="Ungleich">
												<xsl:value-of select="fn:replace($VergleichsElement/xdf3:freitextRegel,'\n','&lt;br/&gt;')" disable-output-escaping="yes"/>
											</td>
										</xsl:otherwise>
									</xsl:choose>
								</tr>
								<tr>
									<td>Beschreibung <xsl:if test="fn:not(empty($VergleichsElement)) and (fn:not((empty($Element/xdf3:beschreibung) and empty($VergleichsElement/xdf3:beschreibung)) or ($Element/xdf3:beschreibung = $VergleichsElement/xdf3:beschreibung)))">##</xsl:if></td>
									<td>
										<xsl:value-of select="fn:replace($Element/xdf3:beschreibung,'\n','&lt;br/&gt;')" disable-output-escaping="yes"/>
									</td>
									<xsl:choose>
										<xsl:when test="empty($VergleichsElement) or (empty($Element/xdf3:beschreibung) and empty($VergleichsElement/xdf3:beschreibung)) or ($Element/xdf3:beschreibung = $VergleichsElement/xdf3:beschreibung)">
											<td class="Gleich">
												<xsl:value-of select="fn:replace($VergleichsElement/xdf3:beschreibung,'\n','&lt;br/&gt;')" disable-output-escaping="yes"/>
											</td>
										</xsl:when>
										<xsl:otherwise>
											<td class="Ungleich">
												<xsl:value-of select="fn:replace($VergleichsElement/xdf3:beschreibung,'\n','&lt;br/&gt;')" disable-output-escaping="yes"/>
											</td>
										</xsl:otherwise>
									</xsl:choose>
								</tr>
								<xsl:if test="count($Element/xdf3:bezug) = 0 and count($VergleichsElement/xdf3:bezug) = 0">
									<tr>
										<td>Handlungsgrundlagen</td>
										<td></td>
										<td></td>
									</tr>
								</xsl:if>
								<xsl:for-each select="$Element/xdf3:bezug">
									<xsl:variable name="bezug" select="./text()"/>
									<xsl:variable name="link"><xsl:value-of select="./@link"/></xsl:variable>
									<xsl:variable name="VergleichsBezug" select="$VergleichsElement/xdf3:bezug[./text() = $bezug]"/>
									<xsl:variable name="VergleichsLink"><xsl:value-of select="$VergleichsElement/xdf3:bezug[./text() = $bezug]/@link"/></xsl:variable>
									
									<tr>
										<xsl:choose>
											<xsl:when test="fn:position() = 1"><td>Handlungsgrundlagen</td></xsl:when>
											<xsl:otherwise><td></td></xsl:otherwise>
										</xsl:choose>
										<td>
											<ul class="hangrun">
												<li>
													<xsl:value-of select="."/>
													<xsl:choose>
														<xsl:when test="not(@link) or ./@link=''"></xsl:when>
														<xsl:when test="$HandlungsgrundlagenLinks = '1'">
															- <xsl:element name="a">
																<xsl:attribute name="href"><xsl:value-of select="./@link"/></xsl:attribute>
																<xsl:attribute name="target">Handlungsgrundlage</xsl:attribute>
																<xsl:attribute name="title">Springe zum Text der Handlungsgrundlage.</xsl:attribute>
																<xsl:value-of select="./@link"/>
															</xsl:element>
														</xsl:when>
														<xsl:otherwise>
															- <xsl:value-of select="./@link"/>
														</xsl:otherwise>
													</xsl:choose>
												</li>
											</ul>
										</td>
										<xsl:choose>
											<xsl:when test="empty($VergleichsElement)">
												<td class="Gleich">
													<ul class="hangrun">
													</ul>
												</td>
											</xsl:when>
											<xsl:when test="empty($VergleichsBezug)">
												<td class="Ungleich">
													<ul class="hangrun">
														<li><i>Nicht vorhanden</i> ##</li>
													</ul>
												</td>
											</xsl:when>
											<xsl:when test="$link != $VergleichsLink">
												<td class="Ungleich">
													<ul class="hangrun">
														<li>
															<xsl:value-of select="$VergleichsElement/xdf3:bezug[./text() = $bezug]/text()"/>
															<xsl:choose>
																<xsl:when test="not($VergleichsElement/xdf3:bezug[./text() = $bezug]/@link) or $VergleichsElement/xdf3:bezug[./text() = $bezug]/@link=''"></xsl:when>
																<xsl:when test="$HandlungsgrundlagenLinks = '1'">
																	- <xsl:element name="a">
																		<xsl:attribute name="href"><xsl:value-of select="./@link"/></xsl:attribute>
																		<xsl:attribute name="target">Handlungsgrundlage</xsl:attribute>
																		<xsl:attribute name="title">Springe zum Text der Handlungsgrundlage.</xsl:attribute>
																		<xsl:value-of select="$VergleichsElement/xdf3:bezug[./text() = $bezug]/@link"/>
																	</xsl:element> ##
																</xsl:when>
																<xsl:otherwise>
																	- <xsl:value-of select="$VergleichsElement/xdf3:bezug[./text() = $bezug]/@link"/> ##
																</xsl:otherwise>
															</xsl:choose>
														</li>
													</ul>
												</td>
											</xsl:when>
											<xsl:otherwise>
												<td class="Gleich">
													<ul class="hangrun">
														<li>
															<xsl:value-of select="$VergleichsElement/xdf3:bezug[./text() = $bezug]/text()"/>
															<xsl:choose>
																<xsl:when test="not($VergleichsElement/xdf3:bezug[./text() = $bezug]/@link) or $VergleichsElement/xdf3:bezug[./text() = $bezug]/@link=''"></xsl:when>
																<xsl:when test="$HandlungsgrundlagenLinks = '1'">
																	- <xsl:element name="a">
																		<xsl:attribute name="href"><xsl:value-of select="./@link"/></xsl:attribute>
																		<xsl:attribute name="target">Handlungsgrundlage</xsl:attribute>
																		<xsl:attribute name="title">Springe zum Text der Handlungsgrundlage.</xsl:attribute>
																		<xsl:value-of select="$VergleichsElement/xdf3:bezug[./text() = $bezug]/@link"/>
																	</xsl:element>
																</xsl:when>
																<xsl:otherwise>
																	- <xsl:value-of select="$VergleichsElement/xdf3:bezug[./text() = $bezug]/@link"/>
																</xsl:otherwise>
															</xsl:choose>
														</li>
													</ul>
												</td>
											</xsl:otherwise>
										</xsl:choose>
									</tr>
								</xsl:for-each>
								<xsl:for-each select="$VergleichsElement/xdf3:bezug">
									<xsl:variable name="bezug" select="./text()"/>
									<xsl:variable name="link"><xsl:value-of select="./@link"/></xsl:variable>
									<xsl:variable name="OriginalBezug" select="$Element/xdf3:bezug[./text() = $bezug]"/>
									<xsl:variable name="OriginalLink"><xsl:value-of select="$Element/xdf3:bezug[./text() = $bezug]/@link"/></xsl:variable>
									
									<xsl:if test="not($Element/xdf3:bezug[./text() = $bezug])">
										<tr>
											<xsl:choose>
												<xsl:when test="count($Element/xdf3:bezug) = 0 and fn:position() = 1"><td>Handlungsgrundlagen</td></xsl:when>
												<xsl:otherwise><td></td></xsl:otherwise>
											</xsl:choose>
											<td>
												<ul class="hangrun">
													<li>
														<i>Nicht vorhanden</i>
													</li>
												</ul>
											</td>
											<td class="Ungleich">
												<ul class="hangrun">
													<li>
														<xsl:value-of select="./text()"/><xsl:if test="not(./@link) or ./@link=''"> ##</xsl:if>
														<xsl:choose>
															<xsl:when test="not(./@link) or ./@link=''"></xsl:when>
															<xsl:when test="$HandlungsgrundlagenLinks = '1'">
																- <xsl:element name="a">
																	<xsl:attribute name="href"><xsl:value-of select="./@link"/></xsl:attribute>
																	<xsl:attribute name="target">Handlungsgrundlage</xsl:attribute>
																	<xsl:attribute name="title">Springe zum Text der Handlungsgrundlage.</xsl:attribute>
																	<xsl:value-of select="./@link"/>
																</xsl:element> ##
															</xsl:when>
															<xsl:otherwise>
																- <xsl:value-of select="./@link"/> ##
															</xsl:otherwise>
														</xsl:choose>
													</li>
												</ul>

											</td>
										</tr>
									</xsl:if>
								</xsl:for-each>
								<tr>
									<td>Fachlicher Ersteller <xsl:if test="fn:not(empty($VergleichsElement)) and fn:not((empty($Element/xdf3:statusGesetztDurch) and empty($VergleichsElement/xdf3:statusGesetztDurch)) or ($Element/xdf3:statusGesetztDurch = $VergleichsElement/xdf3:statusGesetztDurch))">##</xsl:if></td>
									<td>
										<xsl:value-of select="$Element/xdf3:statusGesetztDurch"/>
									</td>
									<xsl:choose>
										<xsl:when test="empty($VergleichsElement) or (empty($Element/xdf3:statusGesetztDurch) and empty($VergleichsElement/xdf3:statusGesetztDurch)) or ($Element/xdf3:statusGesetztDurch = $VergleichsElement/xdf3:statusGesetztDurch)">
											<td class="Gleich">
												<xsl:value-of select="$VergleichsElement/xdf3:statusGesetztDurch"/>
											</td>
										</xsl:when>
										<xsl:otherwise>
											<td class="Ungleich">
												<xsl:value-of select="$VergleichsElement/xdf3:statusGesetztDurch"/>
											</td>
										</xsl:otherwise>
									</xsl:choose>
								</tr>
								<tr>
									<td>Letzte Änderung <xsl:if test="fn:not(empty($VergleichsElement)) and fn:not((empty($Element/xdf3:letzteAenderung) and empty($VergleichsElement/xdf3:letzteAenderung)) or ($Element/xdf3:letzteAenderung = $VergleichsElement/xdf3:letzteAenderung))">##</xsl:if></td>
									<td>
										<xsl:value-of select="fn:format-dateTime($Element/xdf3:letzteAenderung,'[D01].[M01].[Y0001] um [H01]:[m01] Uhr')"/>
									</td>
									<xsl:choose>
										<xsl:when test="empty($VergleichsElement) or (empty($Element/xdf3:letzteAenderung) and empty($VergleichsElement/xdf3:letzteAenderung)) or ($Element/xdf3:letzteAenderung = $VergleichsElement/xdf3:letzteAenderung)">
											<td class="Gleich">
												<xsl:value-of select="fn:format-dateTime($VergleichsElement/xdf3:letzteAenderung,'[D01].[M01].[Y0001] um [H01]:[m01] Uhr')"/>
											</td>
										</xsl:when>
										<xsl:otherwise>
											<td class="Ungleich">
												<xsl:value-of select="fn:format-dateTime($VergleichsElement/xdf3:letzteAenderung,'[D01].[M01].[Y0001] um [H01]:[m01] Uhr')"/>
											</td>
										</xsl:otherwise>
									</xsl:choose>
								</tr>
								<tr>
									<td>
										<b>Verwendet in</b>
									</td>
									
									<td>
										<xsl:variable name="RegelID" select="$Element/xdf3:identifikation/xdf3:id"/>
										<xsl:variable name="RegelVersion" select="$Element/xdf3:identifikation/xdf3:version"/>
													
										<table width="100%">
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
									<td></td>
								</tr>
								<tr style="page-break-after:always">
									<td colspan="3" class="Navigation">
										<xsl:call-template name="navigationszeile"/>
									</td>
								</tr>
	</xsl:template>

	<!-- ############################################################################################################# -->

	<xsl:template name="regeldetailsvergleich">
		<xsl:param name="Element"/>
		
		<xsl:if test="$DebugMode = '2' or $DebugMode = '3' or $DebugMode = '4'">
			<xsl:message>
				++++++++ regeldetailsvergleich ++++++++
			</xsl:message>
		</xsl:if>

		<xsl:variable name="Temp" select="$VergleichsDaten//*[xdf3:identifikation/xdf3:id = $Element/xdf3:identifikation/xdf3:id]"/>
		<xsl:variable name="VergleichsElement" select="$Temp[1]"/>
		
		<xsl:if test="$DebugMode = '3' or $DebugMode = '4'">
			<xsl:message>
				-------- <xsl:value-of select="$Element/xdf3:identifikation/xdf3:id"/><xsl:if test="$Element/xdf3:identifikation/xdf3:version">V<xsl:value-of select="$Element/xdf3:identifikation/xdf3:version"/></xsl:if> --------
			</xsl:message>
		</xsl:if>

								<tr>
									<td>
										<xsl:element name="a">
											<xsl:attribute name="name">X<xsl:value-of select="$Element/xdf3:identifikation/xdf3:id"/></xsl:attribute>
										</xsl:element>
										ID ##
									</td>
									<td><i>Nicht vorhanden</i></td>
									<td class="RegelID Ungleich">
										<xsl:value-of select="$Element/xdf3:identifikation/xdf3:id"/>
										<xsl:if test="$ToolAufruf = '1'">
											&#160;&#160;
											<xsl:element name="a">
												<xsl:attribute name="href"><xsl:value-of select="$ToolPfadPrefix"/><xsl:value-of select="$Element/xdf3:identifikation/xdf3:id"/><xsl:if test="$Element/xdf3:identifikation/xdf3:version">V<xsl:value-of select="$Element/xdf3:identifikation/xdf3:version"/></xsl:if><xsl:value-of select="$ToolPfadPostfix"/></xsl:attribute>
												<xsl:attribute name="target">FIMTool</xsl:attribute>
												<xsl:attribute name="title">Springe in den Datenfeldeditor (man muss vorher angemeldet sein).</xsl:attribute>
												&#8658;
											</xsl:element>
										</xsl:if>
									</td>
								</tr>
								<tr>
									<td>Name</td>
									<td></td>
									<xsl:choose>
										<xsl:when test="empty($Element/xdf3:name/text())">
											<td class="ElementName">
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
									<td>Stichwörter</td>
									<td></td>
									<td>
										<ul class="hangrun">
											<xsl:for-each select="$Element/xdf3:stichwort">
												<li>
													<xsl:value-of select="."/><xsl:if test="./@uri"> (<xsl:value-of select="./@uri"/>)</xsl:if>
												</li>
											</xsl:for-each>
										</ul>
									</td>
								</tr>
								<tr>
									<td>Freitextregel</td>
									<td></td>
									<td><xsl:value-of select="fn:replace($Element/xdf3:freitextRegel,'\n','&lt;br/&gt;')" disable-output-escaping="yes"/></td>
								</tr>
								<tr>
									<td>Beschreibung</td>
									<td></td>
									<td><xsl:value-of select="fn:replace($Element/xdf3:beschreibung,'\n','&lt;br/&gt;')" disable-output-escaping="yes"/></td>
								</tr>
								<tr>
									<td>Handlungsgrundlagen</td>
									<td></td>
									<td>
										<ul class="hangrun">
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
									</td>
								</tr>
								<tr>
									<td>Fachlicher Ersteller</td>
									<td></td>
									<td><xsl:value-of select="$Element/xdf3:statusGesetztDurch"/></td>
								</tr>
								<tr>
									<td>Letzte Änderung</td>
									<td></td>
									<td><xsl:value-of select="fn:format-dateTime($Element/xdf3:letzteAenderung,'[D01].[M01].[Y0001] um [H01]:[m01] Uhr')"/></td>
								</tr>


								<tr>
									<td>
										<b>Verwendet in</b>
									</td>
									<td></td>
									
									<td>
										<xsl:variable name="RegelID" select="$Element/xdf3:identifikation/xdf3:id"/>
										<xsl:variable name="RegelVersion" select="$Element/xdf3:identifikation/xdf3:version"/>

										<table width="100%">
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
															
																<xsl:call-template name="minielementcorevergleich">
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
															
																<xsl:call-template name="minielementcorevergleich">
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
															
																<xsl:call-template name="minielementcorevergleich">
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
															
																<xsl:call-template name="minielementcorevergleich">
																	<xsl:with-param name="Element" select="."/>
																</xsl:call-template>
															
															</xsl:for-each-group>
														</xsl:for-each-group>

														<xsl:for-each-group select="//xdf3:datenfeldgruppe[xdf3:regel/xdf3:identifikation/xdf3:id = $RegelID and xdf3:regel/xdf3:identifikation/xdf3:version = $RegelVersion]" group-by="xdf3:identifikation/xdf3:id">
															<xsl:sort select="./xdf3:identifikation/xdf3:id"/>
															
															<xsl:for-each-group select="fn:current-group()" group-by="string(xdf3:identifikation/xdf3:version)">
																<xsl:sort select="./xdf3:identifikation/xdf3:version"/>
															
																<xsl:call-template name="minielementcorevergleich">
																	<xsl:with-param name="Element" select="."/>
																</xsl:call-template>
															
															</xsl:for-each-group>
														</xsl:for-each-group>

														<xsl:for-each-group select="//xdf3:stammdatenschema[xdf3:regel/xdf3:identifikation/xdf3:id = $RegelID and xdf3:regel/xdf3:identifikation/xdf3:version = $RegelVersion]" group-by="xdf3:identifikation/xdf3:id">
															<xsl:sort select="./xdf3:identifikation/xdf3:id"/>
															
															<xsl:for-each-group select="fn:current-group()" group-by="string(xdf3:identifikation/xdf3:version)">
																<xsl:sort select="./xdf3:identifikation/xdf3:version"/>
															
																<xsl:call-template name="minielementcorevergleich">
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
									<td colspan="3" class="Navigation">
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

					<h2><br/></h2>
					<h2>
						<xsl:choose>
							<xsl:when test="name(/*) ='xdf3:xdatenfelder.stammdatenschema.0102'">
								<a name="CodelisteDetails"/>Details zu den Codelisten des Datenschemas <xsl:value-of select="$NameSDSA"/> im Vergleich mit Datenschema <xsl:value-of select="$NameSDSO"/>
							</xsl:when>
							<xsl:when test="name(/*) ='xdf3:xdatenfelder.datenfeldgruppe.0103'">
								<a name="CodelisteDetails"/>Details zu den Codelisten der Datenfeldgruppe <xsl:value-of select="$NameSDSA"/> im Vergleich mit Datenfeldgruppe <xsl:value-of select="$NameSDSO"/>
							</xsl:when>
						</xsl:choose>
					</h2>
					<table style="page-break-after:always">
						<thead>
							<xsl:choose>
								<xsl:when test="name(/*) ='xdf3:xdatenfelder.stammdatenschema.0102'">
									<tr>
										<th width="10%">Metadatum</th>
										<th width="45%">Inhalt Datenschema <xsl:value-of select="$NameSDSA"/></th>
										<th width="45%">Inhalt Datenschema <xsl:value-of select="$NameSDSO"/></th>
									</tr>
								</xsl:when>
								<xsl:when test="name(/*) ='xdf3:xdatenfelder.datenfeldgruppe.0103'">
									<tr>
										<th width="10%">Metadatum</th>
										<th width="45%">Inhalt Datenfeldgruppe <xsl:value-of select="$NameSDSA"/></th>
										<th width="45%">Inhalt Datenfeldgruppe <xsl:value-of select="$NameSDSO"/></th>
									</tr>
								</xsl:when>
							</xsl:choose>
						</thead>
						<tbody>
							<xsl:for-each-group select="//xdf3:codelisteReferenz" group-by="concat(xdf3:canonicalIdentification,xdf3:version)">
								<xsl:sort select="concat(xdf3:canonicalIdentification,xdf3:version)"/>

									<xsl:call-template name="codelistedetails">
										<xsl:with-param name="Element" select="."/>
									</xsl:call-template>

							</xsl:for-each-group>
							<xsl:for-each-group select="$VergleichsDaten//xdf3:codelisteReferenz" group-by="concat(xdf3:canonicalIdentification,xdf3:version)">
								<xsl:sort select="concat(xdf3:canonicalIdentification,xdf3:version)"/>

									<xsl:variable name="CheckId" select="./xdf3:canonicalIdentification"/>

									<xsl:if test="empty($Daten//xdf3:codelisteReferenz[xdf3:canonicalIdentification = $CheckId])">

										<xsl:call-template name="codelistedetailsvergleich">
											<xsl:with-param name="Element" select="."/>
										</xsl:call-template>
									
									</xsl:if>

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
				-------- <xsl:value-of select="$Element/xdf3:canonicalVersionUri"/> --------
			</xsl:message>
		</xsl:if>

		<xsl:variable name="Temp" select="$VergleichsDaten//*/xdf3:codelisteReferenz[xdf3:canonicalVersionUri = $Element/xdf3:canonicalVersionUri]|$VergleichsDaten//*/xdf3:codelisteReferenz[(xdf3:canonicalIdentification = $Element/xdf3:canonicalIdentification)]"/>

		<xsl:variable name="VergleichsElement" select="$Temp[1]"/>
		
		<xsl:if test="$DebugMode = '4'">
			<xsl:message>
				-------- <xsl:value-of select="$VergleichsElement/xdf3:canonicalVersionUri"/> --------
			</xsl:message>
		</xsl:if>

		<xsl:variable name="CodelisteURNE">
			<xsl:value-of select="$Element/xdf3:canonicalIdentification"/><xsl:if test="$Element/xdf3:version">_<xsl:value-of select="$Element/xdf3:version"/></xsl:if>
		</xsl:variable>

		<xsl:variable name="CodelisteURNV">
			<xsl:value-of select="$VergleichsElement/xdf3:canonicalIdentification"/><xsl:if test="$VergleichsElement/xdf3:version">_<xsl:value-of select="$VergleichsElement/xdf3:version"/></xsl:if>
		</xsl:variable>

		<xsl:variable name="RichtigeVersion">
			<xsl:choose>
				<xsl:when test="not($Element/xdf3:version)">
					<xsl:variable name="CodelisteAbfrageURL" select="fn:concat($XMLXRepoOhneVersionPfadPrefix,$Element/xdf3:canonicalIdentification,$XMLXRepoOhneVersionPfadPostfix)"/>
					<xsl:variable name="CodelisteAbfrageInhalt">
						<xsl:choose>
							<xsl:when test="fn:doc-available($CodelisteAbfrageURL)">
								<xsl:copy-of select="fn:document($CodelisteAbfrageURL)"/>
								<xsl:if test="$DebugMode = '4'">
									<xsl:message>                                  URL</xsl:message>
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
						<xsl:when test="(fn:string-length($CodelisteAbfrageInhalt) &lt; 10) or ($AktuelleCodelisteLaden = '0')">unbestimmt</xsl:when>
						<xsl:otherwise><xsl:value-of select="$CodelisteAbfrageInhalt/dat:VersionCodeliste/dat:version"/></xsl:otherwise>
					</xsl:choose>
				</xsl:when>
				<xsl:otherwise><xsl:value-of select="$Element/xdf3:codelisteReferenz/xdf3:version"/></xsl:otherwise>
			</xsl:choose>
		</xsl:variable>

		<xsl:variable name="DocCodelisteURLE">
			<xsl:choose>
				<xsl:when test="fn:empty($Element/xdf3:version/text())">
					<xsl:value-of select="fn:concat($DocXRepoOhneVersionPfadPrefix,$CodelisteURNE,$DocXRepoOhneVersionPfadPostfix)"/>
				</xsl:when>
				<xsl:otherwise>
					<xsl:value-of select="fn:concat($DocXRepoMitVersionPfadPrefix,$CodelisteURNE,$DocXRepoMitVersionPfadPostfix)"/>
				</xsl:otherwise>
			</xsl:choose>
		</xsl:variable>
		<xsl:variable name="DocCodelisteURLV">
			<xsl:choose>
				<xsl:when test="fn:empty($VergleichsElement/xdf3:version/text())">
					<xsl:value-of select="fn:concat($DocXRepoOhneVersionPfadPrefix,$CodelisteURNV,$DocXRepoOhneVersionPfadPostfix)"/>
				</xsl:when>
				<xsl:otherwise>
					<xsl:value-of select="fn:concat($DocXRepoMitVersionPfadPrefix,$CodelisteURNV,$DocXRepoMitVersionPfadPostfix)"/>
				</xsl:otherwise>
			</xsl:choose>
		</xsl:variable>
		
		
		<tr>
			<td>
				<xsl:element name="a">
					<xsl:attribute name="id"><xsl:value-of select="$Element/xdf3:canonicalIdentification"/><xsl:if test="$Element/xdf3:version">_<xsl:value-of select="$Element/xdf3:version"/></xsl:if></xsl:attribute>
				</xsl:element>
				ID (CanonicalUri) <xsl:if test="empty($VergleichsElement)">##</xsl:if>
			</td>
			<td>
				<xsl:value-of select="$Element/xdf3:canonicalIdentification"/>
				<xsl:if test="$XRepoAufruf = '1'">
					<xsl:analyze-string regex="^urn:[A-Za-z0-9][A-Za-z0-9-]{{0,31}}:([A-Za-z0-9()+,\-.:=@;\$_!*&apos;]|%[0-9A-Fa-f]{{2}})+$" select="$Element/xdf3:canonicalIdentification">
						<xsl:matching-substring>
							&#160;&#160;
							<xsl:element name="a">
								<xsl:attribute name="href"><xsl:value-of select="$DocCodelisteURLE"/></xsl:attribute>
								<xsl:attribute name="target">XRepo</xsl:attribute>
								<xsl:attribute name="title">Springe in das XRepository.</xsl:attribute>
								&#8658;
							</xsl:element>
						</xsl:matching-substring>
						<xsl:non-matching-substring>
						</xsl:non-matching-substring>
					</xsl:analyze-string>
				</xsl:if>
			</td>
			<xsl:choose>
				<xsl:when test="empty($VergleichsElement)">
					<td class="Ungleich NeuCodelisten">
						<i>Nicht vorhanden</i> 
					</td>
				</xsl:when>
				<xsl:when test="$Element/xdf3:version != $VergleichsElement/xdf3:version">
					<td class="Gleich AenderungCodelisten">
						<xsl:element name="a">
							<xsl:attribute name="id"><xsl:value-of select="$VergleichsElement/xdf3:canonicalIdentification"/><xsl:if test="$VergleichsElement/xdf3:version">_<xsl:value-of select="$VergleichsElement/xdf3:version"/></xsl:if></xsl:attribute>
						</xsl:element>
						<xsl:value-of select="$VergleichsElement/xdf3:canonicalIdentification"/>
						<xsl:if test="$XRepoAufruf = '1'">
							<xsl:analyze-string regex="^urn:[A-Za-z0-9][A-Za-z0-9-]{{0,31}}:([A-Za-z0-9()+,\-.:=@;\$_!*&apos;]|%[0-9A-Fa-f]{{2}})+$" select="$VergleichsElement/xdf3:canonicalIdentification">
								<xsl:matching-substring>
									&#160;&#160;
									<xsl:element name="a">
										<xsl:attribute name="href"><xsl:value-of select="$DocCodelisteURLV"/></xsl:attribute>
										<xsl:attribute name="target">XRepo</xsl:attribute>
										<xsl:attribute name="title">Springe in das XRepository.</xsl:attribute>
										&#8658;
									</xsl:element>
								</xsl:matching-substring>
								<xsl:non-matching-substring>
								</xsl:non-matching-substring>
							</xsl:analyze-string>
						</xsl:if>
					</td>
				</xsl:when>
				<xsl:otherwise>
					<td class="Gleich">
						<xsl:value-of select="$VergleichsElement/xdf3:canonicalIdentification"/>
						<xsl:analyze-string regex="^urn:[A-Za-z0-9][A-Za-z0-9-]{{0,31}}:([A-Za-z0-9()+,\-.:=@;\$_!*&apos;]|%[0-9A-Fa-f]{{2}})+$" select="$VergleichsElement/xdf3:canonicalIdentification">
							<xsl:matching-substring>
								<xsl:if test="$XRepoAufruf = '1'">
									&#160;&#160;
									<xsl:element name="a">
										<xsl:attribute name="href"><xsl:value-of select="$DocCodelisteURLV"/></xsl:attribute>
										<xsl:attribute name="target">XRepo</xsl:attribute>
										<xsl:attribute name="title">Springe in das XRepository.</xsl:attribute>
										&#8658;
									</xsl:element>
								</xsl:if>
							</xsl:matching-substring>
							<xsl:non-matching-substring>
							</xsl:non-matching-substring>
						</xsl:analyze-string>
					</td>
				</xsl:otherwise>
			</xsl:choose>
		</tr>

		<tr>
			<xsl:choose>
				<xsl:when test="empty($VergleichsElement)">
					<td>Version</td>
					<td>
						<xsl:choose>
							<xsl:when test="not($Element/xdf3:version)">
								Da die Version der Codeliste nicht vorgegeben ist, sollte in der Regel immer die aktuellste Version <xsl:if test="$RichtigeVersion != 'unbestimmt'">(derzeit <xsl:value-of select="$RichtigeVersion"/>) </xsl:if>der Codeliste verwendet werden.
							</xsl:when>
							<xsl:otherwise>
								<xsl:value-of select="$Element/xdf3:version"/>
							</xsl:otherwise>
						</xsl:choose>
					</td>
					<td class="Gleich"></td>
				</xsl:when>
				<xsl:when test="not($Element/xdf3:version) and $VergleichsElement/xdf3:version">
					<td>Version ##</td>
					<td>Da die Version der Codeliste nicht vorgegeben ist, sollte in der Regel immer die aktuellste Version <xsl:if test="$RichtigeVersion != 'unbestimmt'">(derzeit <xsl:value-of select="$RichtigeVersion"/>) </xsl:if>der Codeliste verwendet werden.</td>
					<td class="Ungleich">
						<xsl:value-of select="$VergleichsElement/xdf3:version"/>
					</td>
				</xsl:when>
				<xsl:when test="$Element/xdf3:version != $VergleichsElement/xdf3:version">
					<td>Version ##</td>
					<td><xsl:value-of select="$Element/xdf3:version"/></td>
					<td class="Ungleich">
						<xsl:value-of select="$VergleichsElement/xdf3:version"/>
					</td>
				</xsl:when>
				<xsl:when test="not($Element/xdf3:version) and not($VergleichsElement/xdf3:version)">
					<td>Version ##</td>
					<td colspan="2">Da die Versionen beider Codeliste nicht vorgegeben ist, sollten in der Regel immer die aktuellsten Versionen <xsl:if test="$RichtigeVersion != 'unbestimmt'">(derzeit <xsl:value-of select="$RichtigeVersion"/>) </xsl:if>der Codelisten verwendet werden.</td>
				</xsl:when>
				<xsl:otherwise>
					<td>Version</td>
					<td><xsl:value-of select="$Element/xdf3:version"/></td>
					<td class="Gleich">
						<xsl:value-of select="$VergleichsElement/xdf3:version"/>
					</td>
				</xsl:otherwise>
			</xsl:choose>
		</tr>
		<tr>
			<xsl:choose>
				<xsl:when test="empty($VergleichsElement)">
					<td>CanonicalVersionUri</td>
					<td><xsl:value-of select="$Element/xdf3:canonicalVersionUri"/></td>
					<td class="Gleich"></td>
				</xsl:when>
				<xsl:when test="$Element/xdf3:canonicalVersionUri != $VergleichsElement/xdf3:canonicalVersionUri">
					<td>CanonicalVersionUri ##</td>
					<td><xsl:value-of select="$Element/xdf3:canonicalVersionUri"/></td>
					<td class="Ungleich AenderungCodelisten">
						<xsl:element name="a">
							<xsl:attribute name="name">X<xsl:value-of select="$VergleichsElement/canonicalVersionUri"/></xsl:attribute>
						</xsl:element>
						<xsl:value-of select="$VergleichsElement/xdf3:canonicalVersionUri"/>
					</td>
				</xsl:when>
				<xsl:otherwise>
					<td>CanonicalVersionUri</td>
					<td><xsl:value-of select="$Element/xdf3:canonicalVersionUri"/></td>
					<td class="Gleich">
						<xsl:value-of select="$VergleichsElement/xdf3:canonicalVersionUri"/>
					</td>
				</xsl:otherwise>
			</xsl:choose>
		</tr>

<!--
								<xsl:if test="$CodelistenInhalt = '1' and not(empty($VergleichsElement))">
-->
		<xsl:if test="$CodelistenInhalt = '1'">
			<xsl:variable name="XMLCodelisteURLE">
				<xsl:choose>
					<xsl:when test="$RichtigeVersion = 'unbestimmt'">
					</xsl:when>
					<xsl:otherwise>
						<xsl:value-of select="fn:concat($XMLXRepoMitVersionPfadPrefix,$Element/xdf3:canonicalIdentification,'_',$RichtigeVersion,$XMLXRepoMitVersionPfadPostfix)"/>
					</xsl:otherwise>
				</xsl:choose>
			</xsl:variable>
	
			<xsl:variable name="XMLCodelisteURLV">
				<xsl:choose>
					<xsl:when test="$VergleichsElement/xdf3:version">
						<xsl:value-of select="fn:concat($XMLXRepoMitVersionPfadPrefix,$CodelisteURNV,$XMLXRepoMitVersionPfadPostfix)"/>
					</xsl:when>
					<xsl:when test="$RichtigeVersion != 'unbestimmt'">
						<xsl:value-of select="fn:concat($XMLXRepoMitVersionPfadPrefix,$VergleichsElement/xdf3:canonicalIdentification,'_',$RichtigeVersion,$XMLXRepoMitVersionPfadPostfix)"/>
					</xsl:when>
					<xsl:otherwise>
					</xsl:otherwise>
				</xsl:choose>
			</xsl:variable>
	
			<xsl:variable name="CodelisteInhaltE">
				<xsl:choose>
					<xsl:when test="fn:doc-available($XMLCodelisteURLE)">
						<xsl:copy-of select="fn:document($XMLCodelisteURLE)"/>
						<xsl:if test="$DebugMode = '4'">
							<xsl:message>                                  URL</xsl:message>
						</xsl:if>
					</xsl:when>
					<xsl:otherwise>
						<xsl:if test="$DebugMode = '4'">
							<xsl:message>                                  LEER</xsl:message>
						</xsl:if>
					</xsl:otherwise>
				</xsl:choose>
			</xsl:variable>

			<xsl:variable name="CodelisteInhaltV">
				<xsl:choose>
					<xsl:when test="fn:doc-available($XMLCodelisteURLV)">
						<xsl:copy-of select="fn:document($XMLCodelisteURLV)"/>
						<xsl:if test="$DebugMode = '4'">
							<xsl:message>                                  URL</xsl:message>
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
				<xsl:when test="fn:string-length($CodelisteInhaltE) &lt; 10">
					<tr>
						<td>Inhalt ##</td>
						<td class="Ungleich" colspan="2">
							Codeliste <xsl:value-of select="$Element/xdf3:canonicalIdentification"/><xsl:if test="$Element/xdf3:version">_<xsl:value-of select="$Element/xdf3:version"/></xsl:if> konnte nicht geöffnet werden.
						</td>
					</tr>
				</xsl:when> 
				<xsl:when test="fn:not(fn:empty($VergleichsElement)) and fn:string-length($CodelisteInhaltV) &lt; 10">
					<tr>
						<td>Inhalt ##</td>
						<td class="Ungleich" colspan="2">
							Codeliste <xsl:value-of select="$VergleichsElement/xdf3:canonicalIdentification"/><xsl:if test="$VergleichsElement/xdf3:version">_<xsl:value-of select="$VergleichsElement/xdf3:version"/></xsl:if> konnte nicht geöffnet werden.
						</td>
					</tr>
					<tr>
						<td></td>
						<td colspan="2">
							<xsl:call-template name="codelisteinhalt">
								<xsl:with-param name="CodelisteInhalt" select="$CodelisteInhaltE"/>
								<xsl:with-param name="CodelisteInhaltVergleich" select="$CodelisteInhaltV"/>
								<xsl:with-param name="NameInhalt" select="$KurznameSDSA"/>
								<xsl:with-param name="NameInhaltVergleich" select="$KurznameSDSO"/>
							</xsl:call-template>
						</td>
					</tr>
				</xsl:when> 
				<xsl:otherwise>
					<tr>
						<td>Inhalt</td>
						<td colspan="2">
							<xsl:call-template name="codelisteinhalt">
								<xsl:with-param name="CodelisteInhalt" select="$CodelisteInhaltE"/>
								<xsl:with-param name="CodelisteInhaltVergleich" select="$CodelisteInhaltV"/>
								<xsl:with-param name="NameInhalt" select="$KurznameSDSA"/>
								<xsl:with-param name="NameInhaltVergleich" select="$KurznameSDSO"/>
							</xsl:call-template>
						</td>
					</tr>
				</xsl:otherwise>
			</xsl:choose>
		</xsl:if>
		<tr>
			<td>
				<b>Verwendet in</b>
			</td>
			
			<xsl:variable name="CodelisteIDE" select="$Element/xdf3:canonicalVersionUri"/>
			
			<td>
				<table width="100%">
					<thead>
						<tr>
							<th>ID</th>
							<th>Version</th>
							<th>Name</th>
							<th>Bezeichnung Eingabe</th>
						</tr>
					</thead>
					<tbody>
						<xsl:for-each-group select="//xdf3:datenfeld[xdf3:codelisteReferenz/xdf3:canonicalVersionUri = $CodelisteIDE]" group-by="xdf3:identifikation/xdf3:id">
							<xsl:sort select="./xdf3:identifikation/xdf3:id"/>

							<xsl:for-each-group select="fn:current-group()" group-by="string(xdf3:identifikation/xdf3:version)">
								<xsl:sort select="./xdf3:identifikation/xdf3:version"/>

								<xsl:call-template name="minielementcore">
									<xsl:with-param name="Element" select="."/>
								</xsl:call-template>

							</xsl:for-each-group>

						</xsl:for-each-group>
					</tbody>
				</table>
			</td>
			<td>
				<table width="100%">
					<thead>
						<tr>
							<xsl:choose>
								<xsl:when test="empty($VergleichsElement)">
									<th></th>
									<th></th>
									<th></th>
									<th></th>
								</xsl:when>
								<xsl:otherwise>
									<th>ID</th>
									<th>Version</th>
									<th>Name</th>
									<th>Bezeichnung Eingabe</th>
								</xsl:otherwise>
							</xsl:choose>
						</tr>
					</thead>
					<tbody>
						<xsl:choose>
							<xsl:when test="empty($VergleichsElement)">
								<tr>
									<td></td>
									<td></td>
									<td></td>
									<td></td>
								</tr>
							</xsl:when>
							<xsl:otherwise>
								<xsl:variable name="CodelisteIDV" select="$VergleichsElement/xdf3:canonicalVersionUri"/>
							
								<xsl:for-each-group select="$VergleichsDaten//xdf3:datenfeld[xdf3:codelisteReferenz/xdf3:canonicalVersionUri = $CodelisteIDV]" group-by="xdf3:identifikation/xdf3:id">
									<xsl:sort select="./xdf3:identifikation/xdf3:id"/>
		
									<xsl:for-each-group select="fn:current-group()" group-by="string(xdf3:identifikation/xdf3:version)">
										<xsl:sort select="./xdf3:identifikation/xdf3:version"/>
		
										<xsl:call-template name="minielementcorevergleich">
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
			<td colspan="3" class="Navigation">
				<xsl:call-template name="navigationszeile"/>
			</td>
		</tr>
	</xsl:template>

	<!-- ############################################################################################################# -->

	<xsl:template name="codelistedetailsvergleich">
		<xsl:param name="Element"/>
		
		<xsl:if test="$DebugMode = '2' or $DebugMode = '3' or $DebugMode = '4'">
			<xsl:message>
				++++++++ codelistedetailsvergleich ++++++++
			</xsl:message>
		</xsl:if>
		<xsl:if test="$DebugMode = '3' or $DebugMode = '4'">
			<xsl:message>
				-------- <xsl:value-of select="concat($Element/xdf3:canonicalIdentification,'_',$Element/xdf3:version)"/> --------
			</xsl:message>
		</xsl:if>

		<xsl:variable name="Temp" select="$VergleichsDaten//*/xdf3:codelisteReferenz[concat(xdf3:canonicalIdentification,xdf3:version) = concat($Element/xdf3:canonicalIdentification,$Element/xdf3:version)]|$VergleichsDaten//*/xdf3:codelisteReferenz[(xdf3:canonicalIdentification = $Element/xdf3:canonicalIdentification) and (xdf3:version != $Element/xdf3:version)]"/>

		<xsl:variable name="VergleichsElement" select="$Temp[1]"/>

		<xsl:if test="$DebugMode = '4'">
			<xsl:message>
					-------- <xsl:value-of select="concat($VergleichsElement/xdf3:canonicalIdentification,'_',$VergleichsElement/xdf3:version)"/> --------
			</xsl:message>
		</xsl:if>

		<xsl:variable name="CodelisteURNE">
			<xsl:value-of select="$Element/xdf3:canonicalIdentification"/><xsl:if test="$Element/xdf3:version">_<xsl:value-of select="$Element/xdf3:version"/></xsl:if>
		</xsl:variable>
		<xsl:variable name="CodelisteURNV">
			<xsl:value-of select="$VergleichsElement/xdf3:canonicalIdentification"/><xsl:if test="$VergleichsElement/xdf3:version">_<xsl:value-of select="$VergleichsElement/xdf3:version"/></xsl:if>
		</xsl:variable>
		<xsl:variable name="XMLCodelisteURLE">
			<xsl:choose>
				<xsl:when test="fn:empty($Element/xdf3:version/text())">
					<xsl:value-of select="fn:concat($XMLXRepoOhneVersionPfadPrefix,$CodelisteURNE,$XMLXRepoOhneVersionPfadPostfix)"/>
				</xsl:when>
				<xsl:otherwise>
					<xsl:value-of select="fn:concat($XMLXRepoMitVersionPfadPrefix,$CodelisteURNE,$XMLXRepoMitVersionPfadPostfix)"/>
				</xsl:otherwise>
			</xsl:choose>
		</xsl:variable>
		<xsl:variable name="XMLCodelisteURLV">
			<xsl:choose>
				<xsl:when test="fn:empty($VergleichsElement/xdf3:version/text())">
					<xsl:value-of select="fn:concat($XMLXRepoOhneVersionPfadPrefix,$CodelisteURNV,$XMLXRepoOhneVersionPfadPostfix)"/>
				</xsl:when>
				<xsl:otherwise>
					<xsl:value-of select="fn:concat($XMLXRepoMitVersionPfadPrefix,$CodelisteURNV,$XMLXRepoMitVersionPfadPostfix)"/>
				</xsl:otherwise>
			</xsl:choose>
		</xsl:variable>
		<xsl:variable name="DocCodelisteURLE">
			<xsl:choose>
				<xsl:when test="fn:empty($Element/xdf3:version/text())">
					<xsl:value-of select="fn:concat($DocXRepoOhneVersionPfadPrefix,$CodelisteURNE,$DocXRepoOhneVersionPfadPostfix)"/>
				</xsl:when>
				<xsl:otherwise>
					<xsl:value-of select="fn:concat($DocXRepoMitVersionPfadPrefix,$CodelisteURNE,$DocXRepoMitVersionPfadPostfix)"/>
				</xsl:otherwise>
			</xsl:choose>
		</xsl:variable>
		<xsl:variable name="DocCodelisteURLV">
			<xsl:choose>
				<xsl:when test="fn:empty($VergleichsElement/xdf3:version/text())">
					<xsl:value-of select="fn:concat($DocXRepoOhneVersionPfadPrefix,$CodelisteURNV,$DocXRepoOhneVersionPfadPostfix)"/>
				</xsl:when>
				<xsl:otherwise>
					<xsl:value-of select="fn:concat($DocXRepoMitVersionPfadPrefix,$CodelisteURNV,$DocXRepoMitVersionPfadPostfix)"/>
				</xsl:otherwise>
			</xsl:choose>
		</xsl:variable>
		
		
		<tr>
			<td>ID (CanonicalUri) ##</td>
			<td><i>Nicht vorhanden</i></td>
			<td class="Ungleich GeloeschtCodelisten">
				<xsl:element name="a">
					<xsl:attribute name="id"><xsl:value-of select="$VergleichsElement/xdf3:canonicalIdentification"/><xsl:if test="$VergleichsElement/xdf3:version">_<xsl:value-of select="$VergleichsElement/xdf3:version"/></xsl:if></xsl:attribute>
				</xsl:element>
				<xsl:value-of select="$VergleichsElement/xdf3:canonicalIdentification"/>
				<xsl:if test="$XRepoAufruf = '1'">
					<xsl:analyze-string regex="^urn:[A-Za-z0-9][A-Za-z0-9-]{{0,31}}:([A-Za-z0-9()+,\-.:=@;\$_!*&apos;]|%[0-9A-Fa-f]{{2}})+$" select="$Element/xdf3:canonicalIdentification">
						<xsl:matching-substring>
							&#160;&#160;
							<xsl:element name="a">
								<xsl:attribute name="href"><xsl:value-of select="$DocCodelisteURLV"/></xsl:attribute>
								<xsl:attribute name="target">XRepo</xsl:attribute>
								<xsl:attribute name="title">Springe in das XRepository.</xsl:attribute>
								&#8658;
							</xsl:element>
						</xsl:matching-substring>
						<xsl:non-matching-substring>
						</xsl:non-matching-substring>
					</xsl:analyze-string>
				</xsl:if>
			</td>
		</tr>
		<tr>
			<td>Version</td>
			<td></td>
			<td class="Gleich"><xsl:value-of select="$VergleichsElement/xdf3:version"/></td>
		</tr>
		<tr>
			<td>CanonicalVersionUri</td>
			<td></td>
			<td class="Gleich"><xsl:value-of select="$VergleichsElement/xdf3:canonicalVersionUri"/></td>
		</tr>

<!--
								<xsl:if test="$CodelistenInhalt = '1' and not(empty($VergleichsElement))">
-->
		<xsl:if test="$CodelistenInhalt = '1'">

			<xsl:variable name="CodelisteInhaltV">
				<xsl:if test="fn:doc-available($XMLCodelisteURLV)">
					<xsl:copy-of select="fn:document($XMLCodelisteURLV)"/>
				</xsl:if>
			</xsl:variable>
			
			<tr>
				<td>Inhalt</td>
				<td></td>
				<xsl:choose>
					<xsl:when test="fn:string-length($CodelisteInhaltV) &lt; 10">
						<td class="Ungleich">
							Codeliste <xsl:value-of select="$VergleichsElement/xdf3:canonicalIdentification"/><xsl:if test="$VergleichsElement/xdf3:version">_<xsl:value-of select="$VergleichsElement/xdf3:version"/></xsl:if> konnte nicht geöffnet werden.
						</td>
					</xsl:when>
					<xsl:otherwise>
						<td>
							<xsl:call-template name="codelisteinhaltvergleich">
								<xsl:with-param name="CodelisteInhalt" select="$CodelisteInhaltV"/>
							</xsl:call-template>
						</td>
					</xsl:otherwise>
				</xsl:choose>
			</tr>
		</xsl:if>
		<tr>
			<td>
				<b>Verwendet in</b>
			</td>
			
			<xsl:variable name="CodelisteIDE" select="$Element/xdf3:canonicalVersionUri"/>
			
			<td>
			</td>
			<td>
				<table width="100%">
					<thead>
						<tr>
							<th>ID</th>
							<th>Version</th>
							<th>Name</th>
							<th>Bezeichnung Eingabe</th>
						</tr>
					</thead>
					<tbody>
						<xsl:variable name="CodelisteIDV" select="$VergleichsElement/xdf3:canonicalVersionUri"/>
					
						<xsl:for-each-group select="$VergleichsDaten//xdf3:datenfeld[xdf3:codelisteReferenz/xdf3:canonicalVersionUri = $CodelisteIDV]" group-by="xdf3:identifikation/xdf3:id">
							<xsl:sort select="./xdf3:identifikation/xdf3:id"/>

							<xsl:for-each-group select="fn:current-group()" group-by="string(xdf3:identifikation/xdf3:version)">
								<xsl:sort select="./xdf3:identifikation/xdf3:version"/>

								<xsl:call-template name="minielementcorevergleich">
									<xsl:with-param name="Element" select="."/>
								</xsl:call-template>

							</xsl:for-each-group>

						</xsl:for-each-group>
					</tbody>
				</table>
			</td>
		</tr>
		<tr style="page-break-after:always">
			<td colspan="3" class="Navigation">
				<xsl:call-template name="navigationszeile"/>
			</td>
		</tr>
	</xsl:template>

	<!-- ############################################################################################################# -->

	<xsl:template name="codelistendetails">
	
		<xsl:if test="$DebugMode = '1' or $DebugMode = '2' or $DebugMode = '3' or $DebugMode = '4'">
			<xsl:message>
				++++ codelistendetails ++++
			</xsl:message>
		</xsl:if>

		<h2>Vergleich von Codeliste <xsl:value-of select="$InputDateinameOhneExt"/> mit Codeliste <xsl:value-of select="$VergleichsDateinameOhneExt"/></h2>

		<table style="page-break-after:always">
			<thead>
				<tr>
					<th width="10%">Metadatum</th>
					<th width="45%">Inhalt Codeliste <xsl:value-of select="$InputDateinameOhneExt"/></th>
					<th width="45%">Inhalt Codeliste <xsl:value-of select="$VergleichsDateinameOhneExt"/></th>
				</tr>
			</thead>
			<tbody>

				<tr>
					<td>Kurzname</td>
					<td>
						<xsl:value-of select="$Daten/*/gc:Identification/gc:ShortName"/><xsl:value-of select="$Daten/*/Identification/ShortName"/>
					</td>
					<xsl:choose>
						<xsl:when test="$Daten/*/gc:Identification/gc:ShortName">
							<xsl:choose>
								<xsl:when test="fn:string($Daten/*/gc:Identification/gc:ShortName) = fn:string($VergleichsDaten/*/gc:Identification/gc:ShortName)">
									<td>
										<xsl:value-of select="$VergleichsDaten/*/gc:Identification/gc:ShortName"/>
									</td>
								</xsl:when>
								<xsl:otherwise>
									<td class="Ungleich">
										<xsl:value-of select="$VergleichsDaten/*/gc:Identification/gc:ShortName"/> ##
									</td>
								</xsl:otherwise>
							</xsl:choose>
						</xsl:when>
						<xsl:otherwise>
							<xsl:choose>
								<xsl:when test="fn:string($Daten/*/Identification/ShortName) = fn:string($VergleichsDaten/*/Identification/ShortName)">
									<td>
										<xsl:value-of select="$VergleichsDaten/*/Identification/ShortName"/>
									</td>
								</xsl:when>
								<xsl:otherwise>
									<td class="Ungleich">
										<xsl:value-of select="$VergleichsDaten/*/Identification/ShortName"/> ##
									</td>
								</xsl:otherwise>
							</xsl:choose>
						</xsl:otherwise>
					</xsl:choose>
				</tr>
				<tr>
					<td>Langname</td>
					<td>
						<xsl:value-of select="$Daten/*/gc:Identification/gc:LongName"/><xsl:value-of select="$Daten/*/Identification/LongName"/>
					</td>
					<xsl:choose>
						<xsl:when test="$Daten/*/gc:Identification/gc:LongName">
							<xsl:choose>
								<xsl:when test="fn:string($Daten/*/gc:Identification/gc:LongName) = fn:string($VergleichsDaten/*/gc:Identification/gc:LongName)">
									<td>
										<xsl:value-of select="$VergleichsDaten/*/gc:Identification/gc:LongName"/>
									</td>
								</xsl:when>
								<xsl:otherwise>
									<td class="Ungleich">
										<xsl:value-of select="$VergleichsDaten/*/gc:Identification/gc:LongName"/> ##
									</td>
								</xsl:otherwise>
							</xsl:choose>
						</xsl:when>
						<xsl:otherwise>
							<xsl:choose>
								<xsl:when test="fn:string($Daten/*/Identification/LongName) = fn:string($VergleichsDaten/*/Identification/LongName)">
									<td>
										<xsl:value-of select="$VergleichsDaten/*/Identification/LongName"/>
									</td>
								</xsl:when>
								<xsl:otherwise>
									<td class="Ungleich">
										<xsl:value-of select="$VergleichsDaten/*/Identification/LongName"/> ##
									</td>
								</xsl:otherwise>
							</xsl:choose>
						</xsl:otherwise>
					</xsl:choose>
				</tr>
				<tr>
					<td>Version</td>
					<td>
						<xsl:value-of select="$Daten/*/gc:Identification/gc:Version"/><xsl:value-of select="$Daten/*/Identification/Version"/>
					</td>
					<xsl:choose>
						<xsl:when test="$Daten/*/gc:Identification/gc:Version">
							<xsl:choose>
								<xsl:when test="fn:string($Daten/*/gc:Identification/gc:Version) = fn:string($VergleichsDaten/*/gc:Identification/gc:Version)">
									<td>
										<xsl:value-of select="$VergleichsDaten/*/gc:Identification/gc:Version"/>
									</td>
								</xsl:when>
								<xsl:otherwise>
									<td class="Ungleich">
										<xsl:value-of select="$VergleichsDaten/*/gc:Identification/gc:Version"/> ##
									</td>
								</xsl:otherwise>
							</xsl:choose>
						</xsl:when>
						<xsl:otherwise>
							<xsl:choose>
								<xsl:when test="fn:string($Daten/*/Identification/Version) = fn:string($VergleichsDaten/*/Identification/Version)">
									<td>
										<xsl:value-of select="$VergleichsDaten/*/Identification/Version"/>
									</td>
								</xsl:when>
								<xsl:otherwise>
									<td class="Ungleich">
										<xsl:value-of select="$VergleichsDaten/*/Identification/Version"/> ##
									</td>
								</xsl:otherwise>
							</xsl:choose>
						</xsl:otherwise>
					</xsl:choose>
				</tr>
				<tr>
					<td>Kennung</td>
					<td>
						<xsl:value-of select="$Daten/*/gc:Identification/gc:CanonicalUri"/><xsl:value-of select="$Daten/*/Identification/CanonicalUri"/>
					</td>
					<xsl:choose>
						<xsl:when test="$Daten/*/gc:Identification/gcCanonicalUri">
							<xsl:choose>
								<xsl:when test="fn:string($Daten/*/gc:Identification/gc:CanonicalUri) = fn:string($VergleichsDaten/*/gc:Identification/gc:CanonicalUri)">
									<td>
										<xsl:value-of select="$VergleichsDaten/*/gc:Identification/gc:CanonicalUri"/>
									</td>
								</xsl:when>
								<xsl:otherwise>
									<td class="Ungleich">
										<xsl:value-of select="$VergleichsDaten/*/gc:Identification/gc:CanonicalUri"/> ##
									</td>
								</xsl:otherwise>
							</xsl:choose>
						</xsl:when>
						<xsl:otherwise>
							<xsl:choose>
								<xsl:when test="fn:string($Daten/*/Identification/CanonicalUri) = fn:string($VergleichsDaten/*/Identification/CanonicalUri)">
									<td>
										<xsl:value-of select="$VergleichsDaten/*/Identification/CanonicalUri"/>
									</td>
								</xsl:when>
								<xsl:otherwise>
									<td class="Ungleich">
										<xsl:value-of select="$VergleichsDaten/*/Identification/CanonicalUri"/> ##
									</td>
								</xsl:otherwise>
							</xsl:choose>
						</xsl:otherwise>
					</xsl:choose>
				</tr>
				<tr>
					<td>Versionskennung</td>
					<td>
						<xsl:value-of select="$Daten/*/gc:Identification/gc:CanonicalVersionUri"/><xsl:value-of select="$Daten/*/Identification/CanonicalVersionUri"/>
					</td>
					<xsl:choose>
						<xsl:when test="$Daten/*/gc:Identification/CanonicalVersionUri">
							<xsl:choose>
								<xsl:when test="fn:string($Daten/*/gc:Identification/gc:CanonicalVersionUri) = fn:string($VergleichsDaten/*/gc:Identification/gc:CanonicalVersionUri)">
									<td>
										<xsl:value-of select="$VergleichsDaten/*/gc:Identification/gc:CanonicalVersionUri"/>
									</td>
								</xsl:when>
								<xsl:otherwise>
									<td class="Ungleich">
										<xsl:value-of select="$VergleichsDaten/*/gc:Identification/gc:CanonicalVersionUri"/> ##
									</td>
								</xsl:otherwise>
							</xsl:choose>
						</xsl:when>
						<xsl:otherwise>
							<xsl:choose>
								<xsl:when test="fn:string($Daten/*/Identification/CanonicalVersionUri) = fn:string($VergleichsDaten/*/Identification/CanonicalVersionUri)">
									<td>
										<xsl:value-of select="$VergleichsDaten/*/Identification/CanonicalVersionUri"/>
									</td>
								</xsl:when>
								<xsl:otherwise>
									<td class="Ungleich">
										<xsl:value-of select="$VergleichsDaten/*/Identification/CanonicalVersionUri"/> ##
									</td>
								</xsl:otherwise>
							</xsl:choose>
						</xsl:otherwise>
					</xsl:choose>
				</tr>
	
				<xsl:if test="$CodelistenInhalt = '1'">

					<tr>
						<td>Inhalt</td>
						<td colspan="2">
							<xsl:call-template name="codelisteinhalt">
								<xsl:with-param name="CodelisteInhalt" select="$Daten"/>
								<xsl:with-param name="CodelisteInhaltVergleich" select="$VergleichsDaten"/>
								<xsl:with-param name="NameInhalt" select="$InputDateinameOhneExt"/>
								<xsl:with-param name="NameInhaltVergleich" select="$VergleichsDateinameOhneExt"/>
							</xsl:call-template>
						</td>
					</tr>
				</xsl:if>

				<tr style="page-break-after:always">
					<td colspan="2" class="Navigation">
						<xsl:call-template name="navigationszeile"/>
					</td>
				</tr>
			</tbody>

		</table>
	</xsl:template>

	<!-- ############################################################################################################# -->

	<xsl:template name="codelisteinhalt">
		<xsl:param name="CodelisteInhalt"/>
		<xsl:param name="CodelisteInhaltVergleich"/>
		<xsl:param name="NameInhalt"/>
		<xsl:param name="NameInhaltVergleich"/>
		
		<xsl:if test="$DebugMode = '2' or $DebugMode = '3' or $DebugMode = '4'">
			<xsl:message>
				++++++++ codelisteinhalt ++++++++
			</xsl:message>
		</xsl:if>

					<xsl:variable name="NameKeySpalte">
						<xsl:value-of select="$CodelisteInhalt/*/gc:ColumnSet/gc:Key[1]/gc:ColumnRef/@Ref"/><xsl:value-of select="$CodelisteInhalt/*/ColumnSet/Key[1]/ColumnRef/@Ref"/>
					</xsl:variable> 
					<xsl:variable name="NameKeySpalteVergleich">
						<xsl:value-of select="$CodelisteInhaltVergleich/*/gc:ColumnSet/gc:Key[1]/gc:ColumnRef/@Ref"/><xsl:value-of select="$CodelisteInhaltVergleich/*/ColumnSet/Key[1]/ColumnRef/@Ref"/>
					</xsl:variable> 
							
							<table width="100%">
								<thead>
									<tr>
										<th colspan="2">Key</th>
										<xsl:for-each select="$CodelisteInhalt/*/gc:ColumnSet/gc:Column[@Id != $NameKeySpalte]">
											<th colspan="2">ID: <xsl:value-of select="./@Id"/></th>
										</xsl:for-each>
										<xsl:for-each select="$CodelisteInhalt/*/ColumnSet/Column[@Id != $NameKeySpalte]">
											<th colspan="2">ID: <xsl:value-of select="./@Id"/></th>
										</xsl:for-each>
										<xsl:for-each select="$CodelisteInhaltVergleich/*/gc:ColumnSet/gc:Column[@Id != $NameKeySpalteVergleich]">
											<xsl:variable name="thisKey">
												<xsl:value-of select="./@Id"/>
											</xsl:variable>
											<xsl:if test="fn:empty($CodelisteInhalt/*/gc:ColumnSet/gc:Column[@Id = $thisKey])">
												<th colspan="2">ID: <xsl:value-of select="./@Id"/></th>
											</xsl:if>
										</xsl:for-each>
										<xsl:for-each select="$CodelisteInhaltVergleich/*/ColumnSet/Column[@Id != $NameKeySpalteVergleich]">
											<xsl:variable name="thisKey">
												<xsl:value-of select="./@Id"/>
											</xsl:variable>
											<xsl:if test="fn:empty($CodelisteInhalt/*/ColumnSet/Column[@Id = $thisKey])">
												<th colspan="2">ID: <xsl:value-of select="./@Id"/></th>
											</xsl:if>
										</xsl:for-each>
									</tr>
								</thead>
								<tbody>
									<tr>
										<td><span class="SehrKlein"><xsl:value-of select="$NameInhalt"/></span></td>
										<td><span class="SehrKlein"><xsl:value-of select="$NameInhaltVergleich"/></span></td>
										<xsl:for-each select="$CodelisteInhalt/*/gc:ColumnSet/gc:Column[@Id != $NameKeySpalte]">
											<td><span class="SehrKlein"><xsl:value-of select="$NameInhalt"/></span></td>
											<td><span class="SehrKlein"><xsl:value-of select="$NameInhaltVergleich"/></span></td>
										</xsl:for-each>
										<xsl:for-each select="$CodelisteInhalt/*/ColumnSet/Column[@Id != $NameKeySpalte]">
											<td><span class="SehrKlein"><xsl:value-of select="$NameInhalt"/></span></td>
											<td><span class="SehrKlein"><xsl:value-of select="$NameInhaltVergleich"/></span></td>
										</xsl:for-each>
										<xsl:for-each select="$CodelisteInhaltVergleich/*/gc:ColumnSet/gc:Column[@Id != $NameKeySpalteVergleich]">
											<xsl:variable name="thisKey">
												<xsl:value-of select="./@Id"/>
											</xsl:variable>
											<xsl:if test="fn:empty($CodelisteInhalt/*/gc:ColumnSet/gc:Column[@Id = $thisKey])">
												<td><span class="SehrKlein"><xsl:value-of select="$NameInhalt"/></span></td>
												<td><span class="SehrKlein"><xsl:value-of select="$NameInhaltVergleich"/></span></td>
											</xsl:if>
										</xsl:for-each>
										<xsl:for-each select="$CodelisteInhaltVergleich/*/ColumnSet/Column[@Id != $NameKeySpalteVergleich]">
											<xsl:variable name="thisKey">
												<xsl:value-of select="./@Id"/>
											</xsl:variable>
											<xsl:if test="fn:empty($CodelisteInhalt/*/ColumnSet/Column[@Id = $thisKey])">
												<td><span class="SehrKlein"><xsl:value-of select="$NameInhalt"/></span></td>
												<td><span class="SehrKlein"><xsl:value-of select="$NameInhaltVergleich"/></span></td>
											</xsl:if>
										</xsl:for-each>
									</tr>
									<tr>
										<xsl:choose>
											<xsl:when test="$CodelisteInhalt/*/gc:ColumnSet/gc:Column[@Id = $NameKeySpalte]">
												<xsl:choose>
													<xsl:when test="$CodelisteInhalt/*/gc:ColumnSet/gc:Column[@Id = $NameKeySpalte]/gc:ShortName = $CodelisteInhaltVergleich/*/gc:ColumnSet/gc:Column[@Id = $NameKeySpalteVergleich]/gc:ShortName">
														<td class="subth"><xsl:value-of select="$CodelisteInhalt/*/gc:ColumnSet/gc:Column[@Id = $NameKeySpalte]/gc:ShortName"/></td>
														<td class="subth"><xsl:value-of select="$CodelisteInhaltVergleich/*/gc:ColumnSet/gc:Column[@Id = $NameKeySpalteVergleich]/gc:ShortName"/></td>
													</xsl:when>
													<xsl:otherwise>
														<td class="subth"><xsl:value-of select="$CodelisteInhalt/*/gc:ColumnSet/gc:Column[@Id = $NameKeySpalte]/gc:ShortName"/></td>
														<td class="subth Ungleich"><xsl:value-of select="$CodelisteInhaltVergleich/*/gc:ColumnSet/gc:Column[@Id = $NameKeySpalteVergleich]/gc:ShortName"/> ##</td>
													</xsl:otherwise>
												</xsl:choose>
											</xsl:when>
											<xsl:otherwise>
												<xsl:choose>
													<xsl:when test="$CodelisteInhalt/*/ColumnSet/Column[@Id = $NameKeySpalte]/ShortName = $CodelisteInhaltVergleich/*/ColumnSet/Column[@Id = $NameKeySpalteVergleich]/ShortName">
														<td class="subth"><xsl:value-of select="$CodelisteInhalt/*/ColumnSet/Column[@Id = $NameKeySpalte]/ShortName"/></td>
														<td class="subth"><xsl:value-of select="$CodelisteInhaltVergleich/*/ColumnSet/Column[@Id = $NameKeySpalteVergleich]/ShortName"/></td>
													</xsl:when>
													<xsl:otherwise>
														<td class="subth"><xsl:value-of select="$CodelisteInhalt/*/ColumnSet/Column[@Id = $NameKeySpalte]/ShortName"/></td>
														<td class="subth Ungleich"><xsl:value-of select="$CodelisteInhaltVergleich/*/ColumnSet/Column[@Id = $NameKeySpalteVergleich]/ShortName"/> ##</td>
													</xsl:otherwise>
												</xsl:choose>
											</xsl:otherwise>
										</xsl:choose>
										<xsl:for-each select="$CodelisteInhalt/*/gc:ColumnSet/gc:Column[@Id != $NameKeySpalte]">
											<xsl:variable name="thisKey">
												<xsl:value-of select="./@Id"/>
											</xsl:variable>
											<xsl:choose>
												<xsl:when test="./gc:ShortName = $CodelisteInhaltVergleich/*/gc:ColumnSet/gc:Column[@Id = $thisKey]/gc:ShortName">
													<td class="subth"><xsl:value-of select="./gc:ShortName"/></td>
													<td class="subth"><xsl:value-of select="$CodelisteInhaltVergleich/*/gc:ColumnSet/gc:Column[@Id = $thisKey]/gc:ShortName"/></td>
												</xsl:when>
												<xsl:otherwise>
													<td class="subth"><xsl:value-of select="./gc:ShortName"/></td>
													<td class="subth Ungleich"><xsl:value-of select="$CodelisteInhaltVergleich/*/gc:ColumnSet/gc:Column[@Id = $thisKey]/gc:ShortName"/> ##</td>
												</xsl:otherwise>
											</xsl:choose>
										</xsl:for-each>
										<xsl:for-each select="$CodelisteInhalt/*/ColumnSet/Column[@Id != $NameKeySpalte]">
											<xsl:variable name="thisKey">
												<xsl:value-of select="./@Id"/>
											</xsl:variable>
											<xsl:choose>
												<xsl:when test="./ShortName = $CodelisteInhaltVergleich/*/ColumnSet/Column[@Id = $thisKey]/ShortName">
													<td class="subth"><xsl:value-of select="./ShortName"/></td>
													<td class="subth"><xsl:value-of select="$CodelisteInhaltVergleich/*/ColumnSet/Column[@Id = $thisKey]/ShortName"/></td>
												</xsl:when>
												<xsl:otherwise>
													<td class="subth"><xsl:value-of select="./ShortName"/></td>
													<td class="subth Ungleich"><xsl:value-of select="$CodelisteInhaltVergleich/*/ColumnSet/Column[@Id = $thisKey]/ShortName"/> ##</td>
												</xsl:otherwise>
											</xsl:choose>
										</xsl:for-each>

										<xsl:for-each select="$CodelisteInhaltVergleich/*/gc:ColumnSet/gc:Column[@Id != $NameKeySpalteVergleich]">
											<xsl:variable name="thisKey">
												<xsl:value-of select="./@Id"/>
											</xsl:variable>
											<xsl:if test="fn:empty($CodelisteInhalt/*/gc:ColumnSet/gc:Column[@Id = $thisKey])">
												<td class="subth"></td>
												<td class="subth Ungleich"><xsl:value-of select="./gc:ShortName"/> ##</td>
											</xsl:if>
										</xsl:for-each>
										<xsl:for-each select="$CodelisteInhaltVergleich/*/ColumnSet/Column[@Id != $NameKeySpalteVergleich]">
											<xsl:variable name="thisKey">
												<xsl:value-of select="./@Id"/>
											</xsl:variable>
											<xsl:if test="fn:empty($CodelisteInhalt/*/ColumnSet/Column[@Id = $thisKey])">
												<td class="subth"></td>
												<td class="subth Ungleich"><xsl:value-of select="./ShortName"/> ##</td>
											</xsl:if>
										</xsl:for-each>

									</tr>

									<xsl:for-each select="$CodelisteInhalt/*/gc:SimpleCodeList/gc:Row">
										<xsl:variable name="thisRow" select="."/>
										<xsl:variable name="thisKey" select="./gc:Value[@ColumnRef=$NameKeySpalte]"/>
										<xsl:variable name="InhaltKeyVergleich" select="$CodelisteInhaltVergleich/*/gc:SimpleCodeList/gc:Row/gc:Value[gc:SimpleValue = $thisKey and @ColumnRef=$NameKeySpalteVergleich]/../gc:Value[@ColumnRef=$NameKeySpalteVergleich]/gc:SimpleValue"/>
										<tr>
											<xsl:choose>
												<xsl:when test="$thisKey = $InhaltKeyVergleich">
													<td>
														<xsl:value-of select="$thisKey"/>
													</td>
													<td>
														<xsl:value-of select="$InhaltKeyVergleich"/>
													</td>
												</xsl:when>
												<xsl:otherwise>
													<td>
														<xsl:value-of select="$thisKey"/>
													</td>
													<td class="Ungleich">
														<xsl:value-of select="$InhaltKeyVergleich"/> ##
													</td>
												</xsl:otherwise>
											</xsl:choose>
											
											<xsl:for-each select="$CodelisteInhalt/*/gc:ColumnSet/gc:Column[@Id != $NameKeySpalte]/@Id">
												<xsl:variable name="SpaltenId" select="."/>
												<xsl:variable name="InhaltZelle">
													<xsl:value-of select="$thisRow/gc:Value[@ColumnRef=current()]"/>
												</xsl:variable>
												<xsl:variable name="InhaltZelleVergleich">
													<xsl:value-of select="$CodelisteInhaltVergleich/*/gc:SimpleCodeList/gc:Row/gc:Value[gc:SimpleValue = $thisKey and @ColumnRef=$NameKeySpalteVergleich]/../gc:Value[@ColumnRef=$SpaltenId]/gc:SimpleValue"/>
												</xsl:variable> 
												
												<xsl:choose>
													<xsl:when test="$InhaltZelle = $InhaltZelleVergleich">
														<td>
															<xsl:value-of select="$InhaltZelle"/>
														</td>
														<td>
															<xsl:value-of select="$InhaltZelleVergleich"/>
														</td>
													</xsl:when>
													<xsl:otherwise>
														<td>
															<xsl:value-of select="$InhaltZelle"/>
														</td>
														<td class="Ungleich">
															<xsl:value-of select="$InhaltZelleVergleich"/> ##
														</td>
													</xsl:otherwise>
												</xsl:choose>
											</xsl:for-each>

											<xsl:for-each select="$CodelisteInhaltVergleich/*/gc:ColumnSet/gc:Column[@Id != $NameKeySpalteVergleich]">
												<xsl:variable name="SpaltenId">
													<xsl:value-of select="./@Id"/>
												</xsl:variable>
												<xsl:if test="fn:empty($CodelisteInhalt/*/gc:ColumnSet/gc:Column[@Id = $SpaltenId])">
													<xsl:variable name="InhaltZelleVergleich"><xsl:value-of select="$CodelisteInhaltVergleich/*/gc:SimpleCodeList/gc:Row/gc:Value[gc:SimpleValue = $thisKey and @ColumnRef=$NameKeySpalteVergleich]/../gc:Value[@ColumnRef=$SpaltenId]/gc:SimpleValue"/></xsl:variable> 
													<xsl:choose>
														<xsl:when test="fn:string-length($InhaltZelleVergleich) &lt; 1">
															<td></td>
															<td></td>
														</xsl:when>
														<xsl:otherwise>
															<td></td>
															<td class="Ungleich">
																<xsl:value-of select="$InhaltZelleVergleich"/> ##
															</td>
														</xsl:otherwise>
													</xsl:choose>
												</xsl:if>
											</xsl:for-each>
										</tr>
									</xsl:for-each>

									<xsl:for-each select="$CodelisteInhalt/*/SimpleCodeList/Row">
										<xsl:variable name="thisRow" select="."/>
										<xsl:variable name="thisKey" select="./Value[@ColumnRef=$NameKeySpalte]"/>
										<xsl:variable name="InhaltKeyVergleich" select="$CodelisteInhaltVergleich/*/SimpleCodeList/Row/Value[SimpleValue = $thisKey and @ColumnRef=$NameKeySpalteVergleich]/../Value[@ColumnRef=$NameKeySpalteVergleich]/SimpleValue"/>
										<tr>
											<xsl:choose>
												<xsl:when test="$thisKey = $InhaltKeyVergleich">
													<td>
														<xsl:value-of select="$thisKey"/>
													</td>
													<td>
														<xsl:value-of select="$InhaltKeyVergleich"/>
													</td>
												</xsl:when>
												<xsl:otherwise>
													<td>
														<xsl:value-of select="$thisKey"/>
													</td>
													<td class="Ungleich">
														<xsl:value-of select="$InhaltKeyVergleich"/> ##
													</td>
												</xsl:otherwise>
											</xsl:choose>
											
											<xsl:for-each select="$CodelisteInhalt/*/ColumnSet/Column[@Id != $NameKeySpalte]/@Id">
												<xsl:variable name="SpaltenId" select="."/>
												<xsl:variable name="InhaltZelle">
													<xsl:value-of select="$thisRow/Value[@ColumnRef=current()]"/>
												</xsl:variable>
												<xsl:variable name="InhaltZelleVergleich">
													<xsl:value-of select="$CodelisteInhaltVergleich/*/SimpleCodeList/Row/Value[SimpleValue = $thisKey and @ColumnRef=$NameKeySpalteVergleich]/../Value[@ColumnRef=$SpaltenId]/SimpleValue"/>
												</xsl:variable> 
												
												<xsl:choose>
													<xsl:when test="$InhaltZelle = $InhaltZelleVergleich">
														<td>
															<xsl:value-of select="$InhaltZelle"/>
														</td>
														<td>
															<xsl:value-of select="$InhaltZelleVergleich"/>
														</td>
													</xsl:when>
													<xsl:otherwise>
														<td>
															<xsl:value-of select="$InhaltZelle"/>
														</td>
														<td class="Ungleich">
															<xsl:value-of select="$InhaltZelleVergleich"/> ##
														</td>
													</xsl:otherwise>
												</xsl:choose>
											</xsl:for-each>

											<xsl:for-each select="$CodelisteInhaltVergleich/*/ColumnSet/Column[@Id != $NameKeySpalteVergleich]">
												<xsl:variable name="SpaltenId">
													<xsl:value-of select="./@Id"/>
												</xsl:variable>
												<xsl:if test="fn:empty($CodelisteInhalt/*/ColumnSet/Column[@Id = $SpaltenId])">
													<xsl:variable name="InhaltZelleVergleich"><xsl:value-of select="$CodelisteInhaltVergleich/*/SimpleCodeList/Row/Value[SimpleValue = $thisKey and @ColumnRef=$NameKeySpalteVergleich]/../Value[@ColumnRef=$SpaltenId]/SimpleValue"/></xsl:variable> 
													<xsl:choose>
														<xsl:when test="fn:string-length($InhaltZelleVergleich) &lt; 1">
															<td></td>
															<td></td>
														</xsl:when>
														<xsl:otherwise>
															<td></td>
															<td class="Ungleich">
																<xsl:value-of select="$InhaltZelleVergleich"/> ##
															</td>
														</xsl:otherwise>
													</xsl:choose>
												</xsl:if>
											</xsl:for-each>
										</tr>
									</xsl:for-each>

									<xsl:for-each select="$CodelisteInhaltVergleich/*/gc:SimpleCodeList/gc:Row">
										<xsl:variable name="thisRow" select="."/>
										<xsl:variable name="thisKey" select="./gc:Value[@ColumnRef=$NameKeySpalteVergleich]"/>
										<xsl:variable name="InhaltKeyVergleich" select="$CodelisteInhalt/*/gc:SimpleCodeList/gc:Row/gc:Value[gc:SimpleValue = $thisKey and @ColumnRef=$NameKeySpalte]/../gc:Value[@ColumnRef=$NameKeySpalte]/gc:SimpleValue"/>
										<xsl:if test="fn:string-length($InhaltKeyVergleich) &lt; 1">
											<tr>
												<td>
												</td>
												<td class="Ungleich">
													<xsl:value-of select="$thisKey"/> ##
												</td>
												
												<xsl:for-each select="$CodelisteInhalt/*/gc:ColumnSet/gc:Column[@Id != $NameKeySpalte]/@Id">
													<xsl:variable name="SpaltenId" select="."/>
													<xsl:variable name="InhaltZelle">
														<xsl:value-of select="$thisRow/gc:Value[@ColumnRef=current()]"/>
													</xsl:variable>
													
													<xsl:choose>
														<xsl:when test="fn:string-length($InhaltZelle) &lt; 1">
															<td></td>
															<td></td>
														</xsl:when>
														<xsl:otherwise>
															<td></td>
															<td class="Ungleich">
																<xsl:value-of select="$InhaltZelle"/> ##
															</td>
														</xsl:otherwise>
													</xsl:choose>
												</xsl:for-each>

												<xsl:for-each select="$CodelisteInhaltVergleich/*/gc:ColumnSet/gc:Column[@Id != $NameKeySpalteVergleich]">
													<xsl:variable name="SpaltenId">
														<xsl:value-of select="./@Id"/>
													</xsl:variable>
													<xsl:if test="fn:empty($CodelisteInhalt/*/gc:ColumnSet/gc:Column[@Id = $SpaltenId])">
														<xsl:variable name="InhaltZelleVergleich"><xsl:value-of select="$CodelisteInhaltVergleich/*/gc:SimpleCodeList/gc:Row/gc:Value[gc:SimpleValue = $thisKey and @ColumnRef=$NameKeySpalteVergleich]/../gc:Value[@ColumnRef=$SpaltenId]/gc:SimpleValue"/></xsl:variable> 
														<xsl:choose>
															<xsl:when test="fn:string-length($InhaltZelleVergleich) &lt; 1">
																<td></td>
																<td></td>
															</xsl:when>
															<xsl:otherwise>
																<td></td>
																<td class="Ungleich">
																	<xsl:value-of select="$InhaltZelleVergleich"/> ##
																</td>
															</xsl:otherwise>
														</xsl:choose>
													</xsl:if>
												</xsl:for-each>
											</tr>
										</xsl:if>
									</xsl:for-each>

									<xsl:for-each select="$CodelisteInhaltVergleich/*/SimpleCodeList/Row">
										<xsl:variable name="thisRow" select="."/>
										<xsl:variable name="thisKey" select="./Value[@ColumnRef=$NameKeySpalteVergleich]"/>
										<xsl:variable name="InhaltKeyVergleich" select="$CodelisteInhalt/*/SimpleCodeList/Row/Value[SimpleValue = $thisKey and @ColumnRef=$NameKeySpalte]/../Value[@ColumnRef=$NameKeySpalte]/SimpleValue"/>
										<xsl:if test="fn:string-length($InhaltKeyVergleich) &lt; 1">
											<tr>
												<td>
												</td>
												<td class="Ungleich">
													<xsl:value-of select="$thisKey"/> ##
												</td>
												
												<xsl:for-each select="$CodelisteInhalt/*/ColumnSet/Column[@Id != $NameKeySpalte]/@Id">
													<xsl:variable name="SpaltenId" select="."/>
													<xsl:variable name="InhaltZelle">
														<xsl:value-of select="$thisRow/Value[@ColumnRef=current()]"/>
													</xsl:variable>
													
													<xsl:choose>
														<xsl:when test="fn:string-length($InhaltZelle) &lt; 1">
															<td></td>
															<td></td>
														</xsl:when>
														<xsl:otherwise>
															<td></td>
															<td class="Ungleich">
																<xsl:value-of select="$InhaltZelle"/> ##
															</td>
														</xsl:otherwise>
													</xsl:choose>
												</xsl:for-each>

												<xsl:for-each select="$CodelisteInhaltVergleich/*/ColumnSet/Column[@Id != $NameKeySpalteVergleich]">
													<xsl:variable name="SpaltenId">
														<xsl:value-of select="./@Id"/>
													</xsl:variable>
													<xsl:if test="fn:empty($CodelisteInhalt/*/ColumnSet/Column[@Id = $SpaltenId])">
														<xsl:variable name="InhaltZelleVergleich"><xsl:value-of select="$CodelisteInhaltVergleich/*/SimpleCodeList/Row/Value[SimpleValue = $thisKey and @ColumnRef=$NameKeySpalteVergleich]/../Value[@ColumnRef=$SpaltenId]/SimpleValue"/></xsl:variable> 
														<xsl:choose>
															<xsl:when test="fn:string-length($InhaltZelleVergleich) &lt; 1">
																<td></td>
																<td></td>
															</xsl:when>
															<xsl:otherwise>
																<td></td>
																<td class="Ungleich">
																	<xsl:value-of select="$InhaltZelleVergleich"/> ##
																</td>
															</xsl:otherwise>
														</xsl:choose>
													</xsl:if>
												</xsl:for-each>
											</tr>
										</xsl:if>
									</xsl:for-each>
								</tbody>
							</table>


	</xsl:template>

	<!-- ############################################################################################################# -->

	<xsl:template name="codelisteinhaltvergleich">
		<xsl:param name="CodelisteInhalt"/>
		
		<xsl:if test="$DebugMode = '2' or $DebugMode = '3' or $DebugMode = '4'">
			<xsl:message>
				++++++++ codelisteinhaltvergleich ++++++++
			</xsl:message>
		</xsl:if>

					<xsl:variable name="NameKeySpalte">
						<xsl:value-of select="$CodelisteInhalt/*/gc:ColumnSet/gc:Key[1]/gc:ColumnRef/@Ref"/><xsl:value-of select="$CodelisteInhalt/*/ColumnSet/Key[1]/ColumnRef/@Ref"/>
					</xsl:variable> 
							
							<table width="100%">
								<thead>
									<tr>
										<th colspan="2">Key</th>
										<xsl:for-each select="$CodelisteInhalt/*/gc:ColumnSet/gc:Column[@Id != $NameKeySpalte]">
											<th colspan="2">ID: <xsl:value-of select="./@Id"/></th>
										</xsl:for-each>
										<xsl:for-each select="$CodelisteInhalt/*/ColumnSet/Column[@Id != $NameKeySpalte]">
											<th colspan="2">ID: <xsl:value-of select="./@Id"/></th>
										</xsl:for-each>
									</tr>
								</thead>
								<tbody>
									<tr>
										<td class="subth"><xsl:value-of select="$CodelisteInhalt/*/gc:ColumnSet/gc:Column[@Id = $NameKeySpalte]/gc:ShortName"/><xsl:value-of select="$CodelisteInhalt/*/ColumnSet/Column[@Id = $NameKeySpalte]/ShortName"/></td>
										<xsl:for-each select="$CodelisteInhalt/*/gc:ColumnSet/gc:Column[@Id != $NameKeySpalte]">
											<td class="subth"><xsl:value-of select="./gc:ShortName"/></td>
										</xsl:for-each>
										<xsl:for-each select="$CodelisteInhalt/*/ColumnSet/Column[@Id != $NameKeySpalte]">
											<td class="subth"><xsl:value-of select="./ShortName"/></td>
										</xsl:for-each>
									</tr>

									<xsl:for-each select="$CodelisteInhalt/*/gc:SimpleCodeList/gc:Row">
										<xsl:variable name="thisRow" select="."/>
										<xsl:variable name="thisKey" select="./gc:Value[@ColumnRef=$NameKeySpalte]"/>
										<tr>
											<td>
												<xsl:value-of select="$thisKey"/>
											</td>
											
											<xsl:for-each select="$CodelisteInhalt/*/gc:ColumnSet/gc:Column[@Id != $NameKeySpalte]/@Id">
												<xsl:variable name="SpaltenId" select="."/>
												<xsl:variable name="InhaltZelle">
													<xsl:value-of select="$thisRow/gc:Value[@ColumnRef=current()]"/>
												</xsl:variable>
												
												<td>
													<xsl:value-of select="$InhaltZelle"/>
												</td>
											</xsl:for-each>

										</tr>
									</xsl:for-each>
									<xsl:for-each select="$CodelisteInhalt/*/SimpleCodeList/Row">
										<xsl:variable name="thisRow" select="."/>
										<xsl:variable name="thisKey" select="./Value[@ColumnRef=$NameKeySpalte]"/>
										<tr>
											<td>
												<xsl:value-of select="$thisKey"/>
											</td>
											
											<xsl:for-each select="$CodelisteInhalt/*/ColumnSet/Column[@Id != $NameKeySpalte]/@Id">
												<xsl:variable name="SpaltenId" select="."/>
												<xsl:variable name="InhaltZelle">
													<xsl:value-of select="$thisRow/Value[@ColumnRef=current()]"/>
												</xsl:variable>
												
												<td>
													<xsl:value-of select="$InhaltZelle"/>
												</td>
											</xsl:for-each>

										</tr>
									</xsl:for-each>
								</tbody>
							</table>


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
																				<xsl:element name="a">
																					<xsl:attribute name="href">#<xsl:value-of select="$Element/xdf3:identifikation/xdf3:id"/><xsl:if test="$Element/xdf3:identifikation/xdf3:version">V<xsl:value-of select="$Element/xdf3:identifikation/xdf3:version"/></xsl:if></xsl:attribute>
																					<xsl:value-of select="$Element/xdf3:identifikation/xdf3:id"/>
																				</xsl:element>
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

	<xsl:template name="minielementcorevergleich">
		<xsl:param name="Element"/>

		<xsl:if test="$DebugMode = '4'">
			<xsl:message>
				++++++++++++++++ minielementcore ++++++++++++++++
			</xsl:message>
		</xsl:if>

																		<tr>
																			<td>
																				<xsl:element name="a">
																					<xsl:attribute name="href">#X<xsl:value-of select="$Element/xdf3:identifikation/xdf3:id"/><xsl:if test="$Element/xdf3:identifikation/xdf3:version">V<xsl:value-of select="$Element/xdf3:identifikation/xdf3:version"/></xsl:if></xsl:attribute>
																					<xsl:value-of select="$Element/xdf3:identifikation/xdf3:id"/>
																				</xsl:element>
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
				<xsl:value-of select="./code/text()"/> 
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
			<xsl:when test="./code/text() = 'num'">Nummer (Fließkommazahl)</xsl:when>
			<xsl:when test="./code/text() = 'num_int'">Ganzzahl</xsl:when>
			<xsl:when test="./code/text() = 'num_currency'">Geldbetrag</xsl:when>
			<xsl:when test="./code/text() = 'file'">Anlage (Datei)</xsl:when>
			<xsl:when test="./code/text() = 'obj'">Statisches Objekt</xsl:when>
			<xsl:otherwise>
				<xsl:value-of select="./code/text()"/> 
			</xsl:otherwise>
		</xsl:choose>
	</xsl:template>
	<xsl:template match="xdf3:praedikat">
		<xsl:choose>
			<xsl:when test="./code/text() = 'ABL'">ist abgeleitet von</xsl:when>
			<xsl:when test="./code/text() = 'ERS'">ersetzt</xsl:when>
			<xsl:when test="./code/text() = 'EQU'">ist äquivalent zu</xsl:when>
			<xsl:when test="./code/text() = 'VKN'">ist verknüpft mit</xsl:when>
			<xsl:otherwise>
				<xsl:value-of select="./code/text()"/> 
			</xsl:otherwise>
		</xsl:choose>
	</xsl:template>
	<xsl:template match="xdf3:vorbefuellung">
		<xsl:choose>
			<xsl:when test="./code/text() = 'keine'">keine Vorbefüllung</xsl:when>
			<xsl:when test="./code/text() = 'optional'">optionale Vorbefüllung</xsl:when>
			<xsl:when test="./code/text() = 'verpflichtend'">verpflichtende Vorbefüllung</xsl:when>
			<xsl:otherwise>
				<xsl:value-of select="./code/text()"/> 
			</xsl:otherwise>
		</xsl:choose>
	</xsl:template>
	<xsl:template match="xdf3:schemaelementart">
		<xsl:choose>
			<xsl:when test="./code/text() = 'ABS'">abstrakt</xsl:when>
			<xsl:when test="./code/text() = 'HAR'">harmonisiert</xsl:when>
			<xsl:when test="./code/text() = 'RNG'">rechtsnormgebunden</xsl:when>
			<xsl:otherwise>
				<xsl:value-of select="./code/text()"/> 
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
				<xsl:value-of select="./code/text()"/> 
			</xsl:otherwise>
		</xsl:choose>
	</xsl:template>
	<xsl:template match="xdf3:ableitungsmodifikationenStruktur">
		<xsl:choose>
			<xsl:when test="./code/text() = '0'">nicht modifizierbar</xsl:when>
			<xsl:when test="./code/text() = '1'">nur einschränkbar</xsl:when>
			<xsl:when test="./code/text() = '2'">nur erweiterbar</xsl:when>
			<xsl:when test="./code/text() = '3'">alles modifizierbar</xsl:when>
			<xsl:otherwise>
				<xsl:value-of select="./code/text()"/> 
			</xsl:otherwise>
		</xsl:choose>
	</xsl:template>
	<xsl:template match="xdf3:ableitungsmodifikationenRepraesentation">
		<xsl:choose>
			<xsl:when test="./code/text() = '0'">nicht modifizierbar</xsl:when>
			<xsl:when test="./code/text() = '1'">modifizierbar</xsl:when>
			<xsl:otherwise>
				<xsl:value-of select="./code/text()"/> 
			</xsl:otherwise>
		</xsl:choose>
	</xsl:template>
	<xsl:template match="xdf3:art">
		<xsl:choose>
			<xsl:when test="./code/text() = 'X'">Auswahlgruppe</xsl:when>
			<xsl:otherwise>
				<xsl:value-of select="./code/text()"/> 
			</xsl:otherwise>
		</xsl:choose>
	</xsl:template>
	<xsl:template match="xdf3:dokumentart">
		<xsl:choose>
			<xsl:when test="./code/text() = '001'">Antrag</xsl:when>
			<xsl:when test="./code/text() = '002'">Anzeige</xsl:when>
			<xsl:when test="./code/text() = '003'">Bericht</xsl:when>
			<xsl:when test="./code/text() = '004'">Bescheid</xsl:when>
			<xsl:when test="./code/text() = '005'">Erklärung</xsl:when>
			<xsl:when test="./code/text() = '006'">Kartenmaterial</xsl:when>
			<xsl:when test="./code/text() = '007'">Mitteilung</xsl:when>
			<xsl:when test="./code/text() = '008'">Multimedia</xsl:when>
			<xsl:when test="./code/text() = '009'">Registeranfrage</xsl:when>
			<xsl:when test="./code/text() = '010'">Registerantwort</xsl:when>
			<xsl:when test="./code/text() = '011'">Urkunde</xsl:when>
			<xsl:when test="./code/text() = '012'">Vertrag</xsl:when>
			<xsl:when test="./code/text() = '013'">Vollmacht</xsl:when>
			<xsl:when test="./code/text() = '014'">Willenserklärung</xsl:when>
			<xsl:when test="./code/text() = '999'">unbestimmt</xsl:when>
			<xsl:otherwise>
				<xsl:value-of select="./code/text()"/> 
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
					<xsl:variable name="Text2"><xsl:value-of select="concat($Text, '__')"/></xsl:variable>
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

	<br/><hr/><br/>
	
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
			<xsl:if test="$Navigation = '0'">
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
				<xsl:when test="$Navigation = '0' or name(/*) ='CodeList' or name(/*) ='gc:CodeList'">
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
			
			.SehrKlein
			{
				font-weight: lighter;
				font-size: 70%;
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
			
			.Zusammenfassung
			{
				font-weight: bold;
				font-size: 100%;
			}

			.Gleich
			{
			}
			
			.Ungleich
			{
				background-color: #ffebe6;
			}
			.hangrun
			{
				margin: 0 0 0 0;
			}
			.subth
			{
				font-weight: bold;
			}
			
		</style>
	<xsl:if test="$JavaScript = '1'">

		<script type="text/javascript">
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
			
			function ZaehleAenderungen() {
			<xsl:if test="$AenderungsFazit = '1' and $JavaScript = '1'">
				const AnzahlAenderungBaukasten = document.querySelectorAll('.AenderungBaukasten').length;
				document.getElementById("AnzahlAenderungBaukasten").innerHTML = "Anzahl geänderter Baukastenelemente: " + AnzahlAenderungBaukasten;

				const AnzahlNeuBaukasten = document.querySelectorAll('.NeuBaukasten').length;
				document.getElementById("AnzahlNeuBaukasten").innerHTML = "Anzahl neu hinzugefügter Baukastenelemente: " + AnzahlNeuBaukasten;

				const AnzahlGeloeschtBaukasten = document.querySelectorAll('.GeloeschtBaukasten').length;
				document.getElementById("AnzahlGeloeschtBaukasten").innerHTML = "Anzahl gelöschter Baukastenelemente: " + AnzahlGeloeschtBaukasten;

				const AnzahlAenderungCodelisten = document.querySelectorAll('.AenderungCodelisten').length;
				document.getElementById("AnzahlAenderungCodelisten").innerHTML = "Anzahl geänderter Codelisten: " + AnzahlAenderungCodelisten;

				const AnzahlNeuCodelisten = document.querySelectorAll('.NeuCodelisten').length;
				document.getElementById("AnzahlNeuCodelisten").innerHTML = "Anzahl neu hinzugefügter Codelisten: " + AnzahlNeuCodelisten;

				const AnzahlGeloeschtCodelisten = document.querySelectorAll('.GeloeschtCodelisten').length;
				document.getElementById("AnzahlGeloeschtCodelisten").innerHTML = "Anzahl gelöschter Codelisten: " + AnzahlGeloeschtCodelisten;

			</xsl:if>
			}
			
		</script>				
	</xsl:if>

	</xsl:template>
	
	<!-- ############################################################################################################# -->

</xsl:stylesheet>
