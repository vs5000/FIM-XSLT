<?xml version="1.0" encoding="iso-8859-1"?>
<xsl:stylesheet
	version="2.0"
	xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
	xmlns:html="http://www.w3.org/1999/xhtml"
	xmlns="http://www.w3.org/1999/xhtml"
	xmlns:fn="http://www.w3.org/2005/xpath-functions"
	xmlns:xdf="urn:xoev-de:fim:standard:xdatenfelder_2" 
	xmlns:gc="http://docs.oasis-open.org/codelist/ns/genericode/1.0/" 
	exclude-result-prefixes="html"
>

	<xsl:variable name="StyleSheetURI" select="fn:static-base-uri()"/>
	<xsl:variable name="DocumentURI" select="fn:document-uri(.)"/>
	 
	<xsl:variable name="StyleSheetName" select="'COMP-DF_0_11_xdf2.xsl'"/> <!-- BackUp, falls fn:static-base-uri() leer -->

	<xsl:output
		method="xhtml"
		doctype-system="http://www.w3.org/TR/xhtml11/DTD/xhtml11.dtd"
		doctype-public="-//W3C//DTD XHTML 1.1//EN"
		omit-xml-declaration="yes"
	/>

	<xsl:strip-space elements="*"/>
		
	<xsl:param name="DateiOutput" select="'0'"/>
	<xsl:param name="VergleichsDateiName"/>

	<xsl:param name="Navigation" select="'1'"/>
	<xsl:param name="JavaScript" select="'1'"/>

	<xsl:param name="CodelistenInhalt" select="'1'"/>
	<xsl:param name="AenderungsFazit" select="'1'"/>
	<xsl:param name="RegelDetails" select="'1'"/>

	<xsl:param name="ToolAufruf" select="'1'"/>
	<xsl:param name="ToolPfadPrefix" select="'https://www.fim-formular.niedersachsen.de/fim/portal/fim/9/editor/'"/>
	<xsl:param name="ToolPfadPostfix" select="'/view'"/>

	<xsl:param name="DebugMode" select="'3'"/>
	<xsl:param name="TestMode"/>

	<xsl:variable name="InputDateiname" select="(tokenize($DocumentURI,'/'))[last()]"/>
	<xsl:variable name="InputPfad" select="fn:substring-before($DocumentURI, $InputDateiname)"/>
	<xsl:variable name="InputDateinameOhneExt" select="(tokenize($InputDateiname,'\.'))[1]"/>
	<xsl:variable name="InputDatei" select="concat($InputPfad,$InputDateiname)"/>
	
	<xsl:variable name="Daten" select="/"/>
	
	<xsl:variable name="VergleichsDatei" select="concat($InputPfad,$VergleichsDateiName)"/>
	<xsl:variable name="VergleichsDaten" select="document($VergleichsDatei)"/>
	<xsl:variable name="VergleichsDateinameOhneExt" select="(tokenize($VergleichsDateiName,'\.'))[1]"/>
	
	<xsl:variable name="NameSDSA"><xsl:value-of select="/*/xdf:stammdatenschema/xdf:identifikation/xdf:id"/><xsl:if test="/*/xdf:stammdatenschema/xdf:identifikation/xdf:version"> Version <xsl:value-of select="/*/xdf:stammdatenschema/xdf:identifikation/xdf:version"/></xsl:if></xsl:variable>
	<xsl:variable name="NameSDSO"><xsl:value-of select="$VergleichsDaten/*/xdf:stammdatenschema/xdf:identifikation/xdf:id"/><xsl:if test="$VergleichsDaten/*/xdf:stammdatenschema/xdf:identifikation/xdf:version"> Version <xsl:value-of select="$VergleichsDaten/*/xdf:stammdatenschema/xdf:identifikation/xdf:version"/></xsl:if></xsl:variable>
	<xsl:variable name="KurznameSDSA"><xsl:value-of select="/*/xdf:stammdatenschema/xdf:identifikation/xdf:id"/><xsl:if test="/*/xdf:stammdatenschema/xdf:identifikation/xdf:version">V<xsl:value-of select="/*/xdf:stammdatenschema/xdf:identifikation/xdf:version"/></xsl:if></xsl:variable>
	<xsl:variable name="KurznameSDSO"><xsl:value-of select="$VergleichsDaten/*/xdf:stammdatenschema/xdf:identifikation/xdf:id"/><xsl:if test="$VergleichsDaten/*/xdf:stammdatenschema/xdf:identifikation/xdf:version">V<xsl:value-of select="$VergleichsDaten/*/xdf:stammdatenschema/xdf:identifikation/xdf:version"/></xsl:if></xsl:variable>
	
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
				AenderungsFazit: <xsl:value-of select="$AenderungsFazit"/>
				Navigation: <xsl:value-of select="$Navigation"/>
				JavaScript: <xsl:value-of select="$JavaScript"/>
				ToolAufruf: <xsl:value-of select="$ToolAufruf"/>
				ToolPfadPrefix: <xsl:value-of select="$ToolPfadPrefix"/>
				ToolPfadPostfix: <xsl:value-of select="$ToolPfadPostfix"/>
				DebugMode: <xsl:value-of select="$DebugMode"/>
				<!-- Vergleichsdaten: <xsl:copy-of select="$VergleichsDaten"/> -->
			</xsl:message>
		</xsl:if>

		<xsl:choose>
			<xsl:when test="$DateiOutput ='1'">

				<xsl:variable name="OutputDateiname">
					<xsl:choose>
						<xsl:when test="name(/*) ='xdf:xdatenfelder.stammdatenschema.0102'">Vergleich_<xsl:value-of select="$KurznameSDSA"/>_<xsl:value-of select="$KurznameSDSO"/>.html</xsl:when>
						<xsl:when test="name(/*) ='CodeList'">Vergleich_<xsl:value-of select="$InputDateinameOhneExt"/>_<xsl:value-of select="$VergleichsDateinameOhneExt"/>.html</xsl:when>
						<xsl:when test="name(/*) ='gc:CodeList'">Vergleich_<xsl:value-of select="$InputDateinameOhneExt"/>_<xsl:value-of select="$VergleichsDateinameOhneExt"/>.html</xsl:when>
						<xsl:otherwise>QS-Bericht_FEHLER.html</xsl:otherwise>
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
							<title>Vergleich von Stammdatenschema <xsl:value-of select="$NameSDSA"/> mit Stammdatenschema <xsl:value-of select="$NameSDSO"/></title>
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
						<xsl:when test="name(/*) ='xdf:xdatenfelder.stammdatenschema.0102'">
							<xsl:if test="$Navigation = '1'">
								<div id="fixiert" class="Navigation">
									<xsl:if test="$JavaScript = '1'">
										<p align="right"><a href="#" title="Schließe das Navigationsfenster" onclick="VersteckeNavigation(); return false;">&#10006;</a></p>
									</xsl:if>
									<h2>Navigation</h2>
									<xsl:choose>
										<xsl:when test="name(/*) ='xdf:xdatenfelder.stammdatenschema.0102'">
											<xsl:if test="$AenderungsFazit = '1' and $JavaScript = '1'">
												<p id="ZusammenfassungLink"><a href="#Zusammenfassung">Zusammenfassung der Änderungen</a></p>
											</xsl:if>
											<p><a href="#StammDetails">Details zu den Stammdatenschemata</a></p>
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
										<h2><a name="Zusammenfassung"/>Zusammenfassung der Änderung des Stammdatenschemas <xsl:value-of select="/*/xdf:stammdatenschema/xdf:identifikation/xdf:id"/><xsl:if test="/*/xdf:stammdatenschema/xdf:identifikation/xdf:version">&#160;Version&#160;<xsl:value-of select="/*/xdf:stammdatenschema/xdf:identifikation/xdf:version"/></xsl:if></h2>
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
								
								<xsl:call-template name="stammdatenschemaeinzeln"/>
	
								<xsl:call-template name="listeelementedetailzustammdatenschema"/>
	
								<xsl:if test="$RegelDetails = '1'">
									<xsl:call-template name="listeregeldetailszustammdatenschema"/>
								</xsl:if>

								<xsl:call-template name="listecodelistendetailszustammdatenschema"/>
	
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

	<xsl:template name="stammdatenschemaeinzeln">

		<xsl:if test="$DebugMode = '1' or $DebugMode = '2' or $DebugMode = '3' or $DebugMode = '4'">
			<xsl:message>
				++++ stammdatenschemaeinzeln ++++
			</xsl:message>
		</xsl:if>

					<h2>
						<a name="StammDetails"/>Vergleich von Stammdatenschema <xsl:value-of select="$NameSDSA"/> mit Stammdatenschema <xsl:value-of select="$NameSDSO"/>
					</h2>
					<table style="page-break-after:always">
						<thead>
							<tr>
								<th width="10%">Metadatum</th>
								<th width="45%">Inhalt Stammdatenschema <xsl:value-of select="$NameSDSA"/></th>
								<th width="45%">Inhalt Stammdatenschema <xsl:value-of select="$NameSDSO"/></th>
							</tr>
						</thead>
						<tbody>

							<xsl:call-template name="stammdatenschemadetailszustammdatenschema">
								<xsl:with-param name="Element" select="/*/xdf:stammdatenschema"/>
								<xsl:with-param name="VergleichsElement" select="$VergleichsDaten/*/xdf:stammdatenschema"/>
							</xsl:call-template>
		
						</tbody>
					</table>
	</xsl:template>

	<!-- ############################################################################################################# -->

	<xsl:template name="stammdatenschemadetailszustammdatenschema">
		<xsl:param name="Element"/>
		<xsl:param name="VergleichsElement"/>

		<xsl:if test="$DebugMode = '2' or $DebugMode = '3' or $DebugMode = '4'">
			<xsl:message>
				++++++++ stammdatenschemadetailszustammdatenschema ++++++++
			</xsl:message>
		</xsl:if>
		<xsl:if test="$DebugMode = '3' or $DebugMode = '4'">
			<xsl:message>
				-------- <xsl:value-of select="$Element/xdf:identifikation/xdf:id"/><xsl:if test="$Element/xdf:identifikation/xdf:version">V<xsl:value-of select="$Element/xdf:identifikation/xdf:version"/></xsl:if> --------
			</xsl:message>
		</xsl:if>
		
										<tr>
											<td>
												<xsl:element name="a">
													<xsl:attribute name="name"><xsl:value-of select="$Element/xdf:identifikation/xdf:id"/><xsl:if test="$Element/xdf:identifikation/xdf:version">V<xsl:value-of select="$Element/xdf:identifikation/xdf:version"/></xsl:if></xsl:attribute>
												</xsl:element>
												<xsl:element name="a">
													<xsl:attribute name="name">X<xsl:value-of select="$VergleichsElement/xdf:identifikation/xdf:id"/><xsl:if test="$VergleichsElement/xdf:identifikation/xdf:version">V<xsl:value-of select="$VergleichsElement/xdf:identifikation/xdf:version"/></xsl:if></xsl:attribute>
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
											<td>
												<xsl:value-of select="$VergleichsElement/xdf:identifikation/xdf:id"/>
												<xsl:if test="$ToolAufruf = '1'">
													&#160;&#160;
													<xsl:element name="a">
														<xsl:attribute name="href"><xsl:value-of select="$ToolPfadPrefix"/><xsl:value-of select="$VergleichsElement/xdf:identifikation/xdf:id"/><xsl:if test="$VergleichsElement/xdf:identifikation/xdf:version">V<xsl:value-of select="$VergleichsElement/xdf:identifikation/xdf:version"/></xsl:if><xsl:value-of select="$ToolPfadPostfix"/></xsl:attribute>
														<xsl:attribute name="target">FIMTool</xsl:attribute>
														<xsl:attribute name="title">Springe in den Datenfeldeditor (man muss vorher angemeldet sein).</xsl:attribute>
														&#8658;
													</xsl:element>
												</xsl:if>
											</td>
										</tr>
										<tr>
											<td>Version <xsl:if test="fn:not((empty($Element/xdf:identifikation/xdf:version) and empty($VergleichsElement/xdf:identifikation/xdf:version)) or ($Element/xdf:identifikation/xdf:version = $VergleichsElement/xdf:identifikation/xdf:version))">##</xsl:if></td>
											<td>
												<xsl:value-of select="$Element/xdf:identifikation/xdf:version"/>
											</td>
											<xsl:choose>
												<xsl:when test="(empty($Element/xdf:identifikation/xdf:version) and empty($VergleichsElement/xdf:identifikation/xdf:version)) or ($Element/xdf:identifikation/xdf:version = $VergleichsElement/xdf:identifikation/xdf:version)">
													<td class="Gleich">
														<xsl:value-of select="$VergleichsElement/xdf:identifikation/xdf:version"/>
													</td>
												</xsl:when>
												<xsl:otherwise>
													<td class="Ungleich">
														<xsl:value-of select="$VergleichsElement/xdf:identifikation/xdf:version"/>
													</td>
												</xsl:otherwise>
											</xsl:choose>
										</tr>
										<tr>
											<td>Name <xsl:if test="fn:not((empty($Element/xdf:name) and empty($VergleichsElement/xdf:name)) or ($Element/xdf:name = $VergleichsElement/xdf:name))">##</xsl:if></td>
											<xsl:choose>
												<xsl:when test="empty($Element/xdf:name/text())">
												<td class="SDSName">
												</td>
												</xsl:when>
												<xsl:otherwise>
													<td class="ElementName">
														<xsl:value-of select="$Element/xdf:name"/>
													</td>
												</xsl:otherwise>
											</xsl:choose>
											<xsl:choose>
												<xsl:when test="(empty($Element/xdf:name) and empty($VergleichsElement/xdf:name)) or ($Element/xdf:name = $VergleichsElement/xdf:name)">
													<td class="ElementName Gleich">
														<xsl:value-of select="$VergleichsElement/xdf:name"/>
													</td>
												</xsl:when>
												<xsl:otherwise>
													<td class="ElementName Ungleich">
														<xsl:value-of select="$VergleichsElement/xdf:name"/>
													</td>
												</xsl:otherwise>
											</xsl:choose>
										</tr>
										<tr>
											<td>Bezeichnung Eingabe <xsl:if test="fn:not((empty($Element/xdf:bezeichnungEingabe) and empty($VergleichsElement/xdf:bezeichnungEingabe)) or ($Element/xdf:bezeichnungEingabe = $VergleichsElement/xdf:bezeichnungEingabe))">##</xsl:if></td>
											<td>
												<xsl:value-of select="$Element/xdf:bezeichnungEingabe"/>
											</td>
											<xsl:choose>
												<xsl:when test="(empty($Element/xdf:bezeichnungEingabe) and empty($VergleichsElement/xdf:bezeichnungEingabe)) or ($Element/xdf:bezeichnungEingabe = $VergleichsElement/xdf:bezeichnungEingabe)">
													<td class="Gleich">
														<xsl:value-of select="$VergleichsElement/xdf:bezeichnungEingabe"/>
													</td>
												</xsl:when>
												<xsl:otherwise>
													<td class="Ungleich">
														<xsl:value-of select="$VergleichsElement/xdf:bezeichnungEingabe"/>
													</td>
												</xsl:otherwise>
											</xsl:choose>
										</tr>
										<tr>
											<td>Hilfetext <xsl:if test="fn:not((empty($Element/xdf:hilfetext) and empty($VergleichsElement/xdf:hilfetext)) or ($Element/xdf:hilfetext = $VergleichsElement/xdf:hilfetext))">##</xsl:if></td>
											<td>
												<xsl:value-of select="$Element/xdf:hilfetext"/>
											</td>
											<xsl:choose>
												<xsl:when test="(empty($Element/xdf:hilfetext) and empty($VergleichsElement/xdf:hilfetext)) or ($Element/xdf:hilfetext = $VergleichsElement/xdf:hilfetext)">
													<td class="Gleich">
														<xsl:value-of select="$VergleichsElement/xdf:hilfetext"/>
													</td>
												</xsl:when>
												<xsl:otherwise>
													<td class="Ungleich">
														<xsl:value-of select="$VergleichsElement/xdf:hilfetext"/>
													</td>
												</xsl:otherwise>
											</xsl:choose>
										</tr>
										<tr>
											<td>Bezeichnung Ausgabe <xsl:if test="fn:not((empty($Element/xdf:bezeichnungAusgabe) and empty($VergleichsElement/xdf:bezeichnungAusgabe)) or ($Element/xdf:bezeichnungAusgabe = $VergleichsElement/xdf:bezeichnungAusgabe))">##</xsl:if></td>
											<td>
												<xsl:value-of select="$Element/xdf:bezeichnungAusgabe"/>
											</td>
											<xsl:choose>
												<xsl:when test="(empty($Element/xdf:bezeichnungAusgabe) and empty($VergleichsElement/xdf:bezeichnungAusgabe)) or ($Element/xdf:bezeichnungAusgabe = $VergleichsElement/xdf:bezeichnungAusgabe)">
													<td class="Gleich">
														<xsl:value-of select="$VergleichsElement/xdf:bezeichnungAusgabe"/>
													</td>
												</xsl:when>
												<xsl:otherwise>
													<td class="Ungleich">
														<xsl:value-of select="$VergleichsElement/xdf:bezeichnungAusgabe"/>
													</td>
												</xsl:otherwise>
											</xsl:choose>
										</tr>
										<tr>
											<td>Bezug zu Rechtsnorm oder Standardisierungsvorhaben <xsl:if test="fn:not((empty($Element/xdf:bezug) and empty($VergleichsElement/xdf:bezug)) or ($Element/xdf:bezug = $VergleichsElement/xdf:bezug))">##</xsl:if></td>
											<xsl:choose>
												<xsl:when test="$Element/xdf:schemaelementart/code/text() = 'RNG' and empty($Element/xdf:bezug/text())">
													<td>
													</td>
												</xsl:when>
												<xsl:when test="$Element/xdf:schemaelementart/code/text() = 'HAR' and empty($Element/xdf:bezug/text())">
													<td>
													</td>
												</xsl:when>
												<xsl:otherwise>
													<td>
														<xsl:value-of select="$Element/xdf:bezug"/>
													</td>
												</xsl:otherwise>
											</xsl:choose>
											<xsl:choose>
												<xsl:when test="(empty($Element/xdf:bezug) and empty($VergleichsElement/xdf:bezug)) or ($Element/xdf:bezug = $VergleichsElement/xdf:bezug)">
													<td class="Gleich">
														<xsl:value-of select="$VergleichsElement/xdf:bezug"/>
													</td>
												</xsl:when>
												<xsl:otherwise>
													<td class="Ungleich">
														<xsl:value-of select="$VergleichsElement/xdf:bezug"/>
													</td>
												</xsl:otherwise>
											</xsl:choose>
										</tr>
										<tr>
											<td>Beschreibung <xsl:if test="fn:not((empty($Element/xdf:beschreibung) and empty($VergleichsElement/xdf:beschreibung)) or ($Element/xdf:beschreibung = $VergleichsElement/xdf:beschreibung))">##</xsl:if></td>
											<td>
												<xsl:value-of select="$Element/xdf:beschreibung"/>
											</td>
											<xsl:choose>
												<xsl:when test="(empty($Element/xdf:beschreibung) and empty($VergleichsElement/xdf:beschreibung)) or ($Element/xdf:beschreibung = $VergleichsElement/xdf:beschreibung)">
													<td class="Gleich">
														<xsl:value-of select="$VergleichsElement/xdf:beschreibung"/>
													</td>
												</xsl:when>
												<xsl:otherwise>
													<td class="Ungleich">
														<xsl:value-of select="$VergleichsElement/xdf:beschreibung"/>
													</td>
												</xsl:otherwise>
											</xsl:choose>
										</tr>
										<tr>
											<td>Definition <xsl:if test="fn:not((empty($Element/xdf:definition) and empty($VergleichsElement/xdf:definition)) or ($Element/xdf:definition = $VergleichsElement/xdf:definition))">##</xsl:if></td>
											<td>
												<xsl:value-of select="$Element/xdf:definition"/>
											</td>
											<xsl:choose>
												<xsl:when test="(empty($Element/xdf:definition) and empty($VergleichsElement/xdf:definition)) or ($Element/xdf:definition = $VergleichsElement/xdf:definition)">
													<td class="Gleich">
														<xsl:value-of select="$VergleichsElement/xdf:definition"/>
													</td>
												</xsl:when>
												<xsl:otherwise>
													<td class="Ungleich">
														<xsl:value-of select="$VergleichsElement/xdf:definition"/>
													</td>
												</xsl:otherwise>
											</xsl:choose>
										</tr>
										<tr>
											<td>Änderbarkeit Struktur <xsl:if test="fn:not((empty($Element/xdf:ableitungsmodifikationenStruktur) and empty($VergleichsElement/xdf:ableitungsmodifikationenStruktur)) or ($Element/xdf:ableitungsmodifikationenStruktur = $VergleichsElement/xdf:ableitungsmodifikationenStruktur))">##</xsl:if></td>
											<td>
												<xsl:apply-templates select="$Element/xdf:ableitungsmodifikationenStruktur"/>
											</td>
											<xsl:choose>
												<xsl:when test="(empty($Element/xdf:ableitungsmodifikationenStruktur) and empty($VergleichsElement/xdf:ableitungsmodifikationenStruktur)) or ($Element/xdf:ableitungsmodifikationenStruktur = $VergleichsElement/xdf:ableitungsmodifikationenStruktur)">
													<td class="Gleich">
														<xsl:apply-templates select="$VergleichsElement/xdf:ableitungsmodifikationenStruktur"/>
													</td>
												</xsl:when>
												<xsl:otherwise>
													<td class="Ungleich">
														<xsl:apply-templates select="$VergleichsElement/xdf:ableitungsmodifikationenStruktur"/>
													</td>
												</xsl:otherwise>
											</xsl:choose>
										</tr>
										<tr>
											<td>Änderbarkeit Repräsentation <xsl:if test="fn:not((empty($Element/xdf:ableitungsmodifikationenRepraesentation) and empty($VergleichsElement/xdf:ableitungsmodifikationenRepraesentation)) or ($Element/xdf:ableitungsmodifikationenRepraesentation = $VergleichsElement/xdf:ableitungsmodifikationenRepraesentation))">##</xsl:if></td>
											<td>
												<xsl:apply-templates select="$Element/xdf:ableitungsmodifikationenRepraesentation"/>
											</td>
											<xsl:choose>
												<xsl:when test="(empty($Element/xdf:ableitungsmodifikationenRepraesentation) and empty($VergleichsElement/xdf:ableitungsmodifikationenRepraesentation)) or ($Element/xdf:ableitungsmodifikationenRepraesentation = $VergleichsElement/xdf:ableitungsmodifikationenRepraesentation)">
													<td class="Gleich">
														<xsl:apply-templates select="$VergleichsElement/xdf:ableitungsmodifikationenRepraesentation"/>
													</td>
												</xsl:when>
												<xsl:otherwise>
													<td class="Ungleich">
														<xsl:apply-templates select="$VergleichsElement/xdf:ableitungsmodifikationenRepraesentation"/>
													</td>
												</xsl:otherwise>
											</xsl:choose>
										</tr>
										<tr>
											<td>Status <xsl:if test="fn:not((empty($Element/xdf:status) and empty($VergleichsElement/xdf:status)) or ($Element/xdf:status = $VergleichsElement/xdf:status))">##</xsl:if></td>
											<td>
												<xsl:apply-templates select="$Element/xdf:status"/>
											</td>
											<xsl:choose>
												<xsl:when test="(empty($Element/xdf:status) and empty($VergleichsElement/xdf:status)) or ($Element/xdf:status = $VergleichsElement/xdf:status)">
													<td class="Gleich">
														<xsl:value-of select="$VergleichsElement/xdf:status"/>
													</td>
												</xsl:when>
												<xsl:otherwise>
													<td class="Ungleich">
														<xsl:value-of select="$VergleichsElement/xdf:status"/>
													</td>
												</xsl:otherwise>
											</xsl:choose>
										</tr>
										<tr>
											<td>Gültig ab <xsl:if test="fn:not((empty($Element/xdf:gueltigAb) and empty($VergleichsElement/xdf:gueltigAb)) or ($Element/xdf:gueltigAb = $VergleichsElement/xdf:gueltigAb))">##</xsl:if></td>
											<td>
												<xsl:value-of select="$Element/xdf:gueltigAb"/>
											</td>
											<xsl:choose>
												<xsl:when test="(empty($Element/xdf:gueltigAb) and empty($VergleichsElement/xdf:gueltigAb)) or ($Element/xdf:gueltigAb = $VergleichsElement/xdf:gueltigAb)">
													<td class="Gleich">
														<xsl:value-of select="$VergleichsElement/xdf:gueltigAb"/>
													</td>
												</xsl:when>
												<xsl:otherwise>
													<td class="Ungleich">
														<xsl:value-of select="$VergleichsElement/xdf:gueltigAb"/>
													</td>
												</xsl:otherwise>
											</xsl:choose>
										</tr>
										<tr>
											<td>Gültig bis <xsl:if test="fn:not((empty($Element/xdf:gueltigBis) and empty($VergleichsElement/xdf:gueltigBis)) or ($Element/xdf:gueltigBis = $VergleichsElement/xdf:gueltigBis))">##</xsl:if></td>
											<td>
												<xsl:value-of select="$Element/xdf:gueltigBis"/>
											</td>
											<xsl:choose>
												<xsl:when test="(empty($Element/xdf:gueltigBis) and empty($VergleichsElement/xdf:gueltigBis)) or ($Element/xdf:gueltigBis = $VergleichsElement/xdf:gueltigBis)">
													<td class="Gleich">
														<xsl:value-of select="$VergleichsElement/xdf:gueltigBis"/>
													</td>
												</xsl:when>
												<xsl:otherwise>
													<td class="Ungleich">
														<xsl:value-of select="$VergleichsElement/xdf:gueltigBis"/>
													</td>
												</xsl:otherwise>
											</xsl:choose>
										</tr>
										<tr>
											<td>Fachlicher Ersteller <xsl:if test="fn:not((empty($Element/xdf:fachlicherErsteller) and empty($VergleichsElement/xdf:fachlicherErsteller)) or ($Element/xdf:fachlicherErsteller = $VergleichsElement/xdf:fachlicherErsteller))">##</xsl:if></td>
											<td>
												<xsl:value-of select="$Element/xdf:fachlicherErsteller"/>
											</td>
											<xsl:choose>
												<xsl:when test="(empty($Element/xdf:fachlicherErsteller) and empty($VergleichsElement/xdf:fachlicherErsteller)) or ($Element/xdf:fachlicherErsteller = $VergleichsElement/xdf:fachlicherErsteller)">
													<td class="Gleich">
														<xsl:value-of select="$VergleichsElement/xdf:fachlicherErsteller"/>
													</td>
												</xsl:when>
												<xsl:otherwise>
													<td class="Ungleich">
														<xsl:value-of select="$VergleichsElement/xdf:fachlicherErsteller"/>
													</td>
												</xsl:otherwise>
											</xsl:choose>
										</tr>
										<tr>
											<td>Freigabedatum <xsl:if test="fn:not((empty($Element/xdf:freigabedatum) and empty($VergleichsElement/xdf:freigabedatum)) or ($Element/xdf:freigabedatum = $VergleichsElement/xdf:freigabedatum))">##</xsl:if></td>
											<td>
												<xsl:value-of select="$Element/xdf:freigabedatum"/>
											</td>
											<xsl:choose>
												<xsl:when test="(empty($Element/xdf:freigabedatum) and empty($VergleichsElement/xdf:freigabedatum)) or ($Element/xdf:freigabedatum = $VergleichsElement/xdf:freigabedatum)">
													<td class="Gleich">
														<xsl:value-of select="$VergleichsElement/xdf:freigabedatum"/>
													</td>
												</xsl:when>
												<xsl:otherwise>
													<td class="Ungleich">
														<xsl:value-of select="$VergleichsElement/xdf:freigabedatum"/>
													</td>
												</xsl:otherwise>
											</xsl:choose>
										</tr>
										<tr>
											<td>Veröffentlichungsdatum <xsl:if test="fn:not((empty($Element/xdf:veroeffentlichungsdatum) and empty($VergleichsElement/xdf:veroeffentlichungsdatum)) or ($Element/xdf:veroeffentlichungsdatum = $VergleichsElement/xdf:veroeffentlichungsdatum))">##</xsl:if></td>
											<td>
												<xsl:value-of select="$Element/xdf:veroeffentlichungsdatum"/>
											</td>
											<xsl:choose>
												<xsl:when test="(empty($Element/xdf:veroeffentlichungsdatum) and empty($VergleichsElement/xdf:veroeffentlichungsdatum)) or ($Element/xdf:veroeffentlichungsdatum = $VergleichsElement/xdf:veroeffentlichungsdatum)">
													<td class="Gleich">
														<xsl:value-of select="$VergleichsElement/xdf:veroeffentlichungsdatum"/>
													</td>
												</xsl:when>
												<xsl:otherwise>
													<td class="Ungleich">
														<xsl:value-of select="$VergleichsElement/xdf:veroeffentlichungsdatum"/>
													</td>
												</xsl:otherwise>
											</xsl:choose>
										</tr>
										<tr>
											<xsl:variable name="AnzahlUnterelemente" select="count($Element/xdf:struktur)"/>

											<td>
												<b>Unterelemente</b>
											</td>
											<xsl:choose>
												<xsl:when test="($AnzahlUnterelemente &gt; 0) or count($VergleichsElement/xdf:struktur)">
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
																<xsl:variable name="Strukturelementart"><xsl:value-of select="./xdf:schemaelementart/code"/></xsl:variable>
															
																<xsl:for-each select="$Element/xdf:struktur">
																
																	<xsl:variable name="VergleichsElement2"><xsl:value-of select="./xdf:enthaelt/*/xdf:identifikation/xdf:id"/></xsl:variable>
																	<xsl:variable name="VergleichsVersion"><xsl:value-of select="./xdf:enthaelt/*/xdf:identifikation/xdf:version"/></xsl:variable>

																	<xsl:variable name="UnterelementA" select="."/>
																	<xsl:variable name="UnterelementO" select="$VergleichsElement/xdf:struktur[xdf:enthaelt/*/xdf:identifikation/xdf:id = $UnterelementA/xdf:enthaelt/*/xdf:identifikation/xdf:id]"/>
																
																	<tr>
																		<td>
																			<xsl:element name="a">
																				<xsl:attribute name="href">#<xsl:value-of select="./xdf:enthaelt/*/xdf:identifikation/xdf:id"/><xsl:if test="./xdf:enthaelt/*/xdf:identifikation/xdf:version">V<xsl:value-of select="./xdf:enthaelt/*/xdf:identifikation/xdf:version"/></xsl:if></xsl:attribute>
																				<xsl:value-of select="./xdf:enthaelt/*/xdf:identifikation/xdf:id"/>
																			</xsl:element>
																			<xsl:choose>
																				<xsl:when test="$VergleichsVersion = ''">
																					<xsl:if test="count($Element/xdf:struktur/./xdf:enthaelt/*/xdf:identifikation[xdf:id=$VergleichsElement2 and not(xdf:version)]) &gt; 1">
																					</xsl:if>
																				</xsl:when>
																				<xsl:otherwise>
																					<xsl:if test="count($Element/xdf:struktur/./xdf:enthaelt/*/xdf:identifikation[xdf:id=$VergleichsElement2 and xdf:version=$VergleichsVersion]) &gt; 1">
																					</xsl:if>
																				</xsl:otherwise>
																			</xsl:choose>

																		</td>
																		<td>
																			<xsl:value-of select="./xdf:enthaelt/*/xdf:identifikation/xdf:version"/>
																		</td>
																		<td>
																			<xsl:value-of select="./xdf:enthaelt/*/xdf:name"/>
																		</td>
																		<xsl:choose>
																			<xsl:when test="./xdf:anzahl='0:0'">
																				<td>
																					<xsl:value-of select="./xdf:anzahl"/>
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
																				</td>
																			</xsl:when>
																			<xsl:otherwise>
																				<td>
																					<xsl:value-of select="./xdf:bezug"/>
																				</td>
																			</xsl:otherwise>
																		</xsl:choose>
																		<xsl:choose>
																			<xsl:when test="empty($UnterelementO)">
																				<td colspan="5" class="Ungleich">
																					Nicht vorhanden ##
																				</td>
																			</xsl:when>
																			<xsl:otherwise>
																				<td>
																					<xsl:element name="a">
																						<xsl:attribute name="href">#X<xsl:value-of select="$UnterelementO/xdf:enthaelt/*/xdf:identifikation/xdf:id"/><xsl:if test="$UnterelementO/xdf:enthaelt/*/xdf:identifikation/xdf:version">V<xsl:value-of select="$UnterelementO/xdf:enthaelt/*/xdf:identifikation/xdf:version"/></xsl:if></xsl:attribute>
																						<xsl:value-of select="$UnterelementO/xdf:enthaelt/*/xdf:identifikation/xdf:id"/>
																					</xsl:element>
																				</td>
																				<xsl:choose>
																					<xsl:when test="(empty($UnterelementO/xdf:enthaelt/*/xdf:identifikation/xdf:version) and empty($UnterelementA/xdf:enthaelt/*/xdf:identifikation/xdf:version)) or ($UnterelementO/xdf:enthaelt/*/xdf:identifikation/xdf:version = $UnterelementA/xdf:enthaelt/*/xdf:identifikation/xdf:version)">
																						<td class="Gleich">
																							<xsl:value-of select="$UnterelementO/xdf:enthaelt/*/xdf:identifikation/xdf:version"/>
																						</td>
																					</xsl:when>
																					<xsl:otherwise>
																						<td class="Ungleich">
																							<xsl:value-of select="$UnterelementO/xdf:enthaelt/*/xdf:identifikation/xdf:version"/>
																						</td>
																					</xsl:otherwise>
																				</xsl:choose>
																				<xsl:choose>
																					<xsl:when test="(empty($UnterelementO/xdf:enthaelt/*/xdf:name) and empty($UnterelementA/xdf:enthaelt/*/xdf:name)) or ($UnterelementO/xdf:enthaelt/*/xdf:name = $UnterelementA/xdf:enthaelt/*/xdf:name)">
																						<td class="Gleich">
																							<xsl:value-of select="$UnterelementO/xdf:enthaelt/*/xdf:name"/><xsl:if test="($UnterelementO/xdf:enthaelt/*/xdf:identifikation/xdf:version != $UnterelementA/xdf:enthaelt/*/xdf:identifikation/xdf:version) or ($UnterelementO/xdf:enthaelt/*/xdf:name != $UnterelementA/xdf:enthaelt/*/xdf:name) or ($UnterelementO/xdf:anzahl != $UnterelementA/xdf:anzahl) or ($UnterelementO/xdf:bezug != $UnterelementA/xdf:bezug)"> ##</xsl:if>
																						</td>
																					</xsl:when>
																					<xsl:otherwise>
																						<td class="Ungleich">
																							<xsl:value-of select="$UnterelementO/xdf:enthaelt/*/xdf:name"/><xsl:if test="($UnterelementO/xdf:enthaelt/*/xdf:identifikation/xdf:version != $UnterelementA/xdf:enthaelt/*/xdf:identifikation/xdf:version) or ($UnterelementO/xdf:enthaelt/*/xdf:name != $UnterelementA/xdf:enthaelt/*/xdf:name) or ($UnterelementO/xdf:anzahl != $UnterelementA/xdf:anzahl) or ($UnterelementO/xdf:bezug != $UnterelementA/xdf:bezug)"> ##</xsl:if>
																						</td>
																					</xsl:otherwise>
																				</xsl:choose>
																				<xsl:choose>
																					<xsl:when test="(empty($UnterelementO/xdf:anzahl) and empty($UnterelementA/xdf:anzahl)) or ($UnterelementO/xdf:anzahl = $UnterelementA/xdf:anzahl)">
																						<td class="Gleich">
																							<xsl:value-of select="$UnterelementO/xdf:anzahl"/>
																						</td>
																					</xsl:when>
																					<xsl:otherwise>
																						<td class="Ungleich">
																							<xsl:value-of select="$UnterelementO/xdf:anzahl"/>
																						</td>
																					</xsl:otherwise>
																				</xsl:choose>
																				<xsl:choose>
																					<xsl:when test="(empty($UnterelementO/xdf:bezug) and empty($UnterelementA/xdf:bezug)) or ($UnterelementO/xdf:bezug = $UnterelementA/xdf:bezug)">
																						<td class="Gleich">
																							<xsl:value-of select="$UnterelementO/xdf:bezug"/>
																						</td>
																					</xsl:when>
																					<xsl:otherwise>
																						<td class="Ungleich">
																							<xsl:value-of select="$UnterelementO/xdf:bezug"/>
																						</td>
																					</xsl:otherwise>
																				</xsl:choose>
																			</xsl:otherwise>
																		</xsl:choose>
																	</tr>
																</xsl:for-each>

																<xsl:for-each select="$VergleichsElement/xdf:struktur">
																	<xsl:variable name="UnterelementO" select="."/>
																	<xsl:variable name="UnterelementA" select="$Element/xdf:struktur[xdf:enthaelt/*/xdf:identifikation/xdf:id = $UnterelementO/xdf:enthaelt/*/xdf:identifikation/xdf:id]"/>
																	<xsl:choose>
																		<xsl:when test="empty($UnterelementA)">
																			<tr>
																				<td colspan="2">
																				</td>
																				<td>Nicht vorhanden
																				</td>
																				<td colspan="2">
																				</td>
																				<td class="Ungleich">
																					<xsl:element name="a">
																						<xsl:attribute name="href">#X<xsl:value-of select="$UnterelementO/xdf:enthaelt/*/xdf:identifikation/xdf:id"/><xsl:if test="$UnterelementO/xdf:enthaelt/*/xdf:identifikation/xdf:version">V<xsl:value-of select="$UnterelementO/xdf:enthaelt/*/xdf:identifikation/xdf:version"/></xsl:if></xsl:attribute>
																						<xsl:value-of select="$UnterelementO/xdf:enthaelt/*/xdf:identifikation/xdf:id"/>
																					</xsl:element>
																				</td>
																				<td class="Ungleich">
																					<xsl:value-of select="$UnterelementO/xdf:enthaelt/*/xdf:identifikation/xdf:version"/>
																				</td>
																				<td class="Ungleich">
																					<xsl:value-of select="$UnterelementO/xdf:enthaelt/*/xdf:name"/> ##
																				</td>
																				<td class="Ungleich">
																					<xsl:value-of select="$UnterelementO/xdf:anzahl"/>
																				</td>
																				<td class="Ungleich">
																					<xsl:value-of select="$UnterelementO/xdf:bezug"/>
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
									<xsl:if test="count($Element/xdf:regel) or count($VergleichsElement/xdf:regel)">
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
															<th width="22%">Definition</th>
															<th width="5%">ID</th>
															<th width="5%">Version</th>
															<th width="18%">Name</th>
															<th width="22%">Definition</th>
														</tr>
													</thead>
													<tbody>
														<xsl:for-each select="$Element/xdf:regel">

															<xsl:variable name="UnterelementA" select="."/>
															<xsl:variable name="UnterelementO" select="$VergleichsElement/xdf:regel[xdf:identifikation/xdf:id = $UnterelementA/xdf:identifikation/xdf:id]"/>

															<tr>
																<td>
																	<xsl:choose>
																		<xsl:when test="$RegelDetails = '1'">
																			<xsl:element name="a">
																				<xsl:attribute name="href">#<xsl:value-of select="./xdf:identifikation/xdf:id"/></xsl:attribute>
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
																	<xsl:value-of select="./xdf:definition"/>
																</td>
																<xsl:choose>
																	<xsl:when test="empty($VergleichsElement)">
																		<td colspan="4">
																		</td>
																	</xsl:when>
																	<xsl:when test="empty($UnterelementO)">
																		<td colspan="4" class="Ungleich">
																			Nicht vorhanden ##
																		</td>
																	</xsl:when>
																	<xsl:otherwise>
																		<td>
																			<xsl:choose>
																				<xsl:when test="$RegelDetails = '1'">
																					<xsl:element name="a">
																						<xsl:attribute name="href">#X<xsl:value-of select="$UnterelementO/xdf:identifikation/xdf:id"/></xsl:attribute>
																						<xsl:value-of select="$UnterelementO/xdf:identifikation/xdf:id"/>
																					</xsl:element>
																				</xsl:when>
																				<xsl:otherwise>
																					<xsl:value-of select="$UnterelementO/xdf:identifikation/xdf:id"/>
																				</xsl:otherwise>
																			</xsl:choose>
																		</td>
																		<xsl:choose>
																			<xsl:when test="(empty($UnterelementO/xdf:identifikation/xdf:version) and empty($UnterelementA/xdf:identifikation/xdf:version)) or ($UnterelementO/xdf:identifikation/xdf:version = $UnterelementA/xdf:identifikation/xdf:version)">
																				<td class="Gleich">
																					<xsl:value-of select="$UnterelementO/xdf:identifikation/xdf:version"/>
																				</td>
																			</xsl:when>
																			<xsl:otherwise>
																				<td class="Ungleich">
																					<xsl:value-of select="$UnterelementO/xdf:identifikation/xdf:version"/>
																				</td>
																			</xsl:otherwise>
																		</xsl:choose>
																		<xsl:choose>
																			<xsl:when test="(empty($UnterelementO/xdf:name) and empty($UnterelementA/xdf:name)) or ($UnterelementO/xdf:name = $UnterelementA/xdf:name)">
																				<td class="Gleich">
																					<xsl:value-of select="$UnterelementO/xdf:name"/><xsl:if test="($UnterelementO/xdf:identifikation/xdf:version != $UnterelementA/xdf:identifikation/xdf:version) or ($UnterelementO/xdf:name != $UnterelementA/xdf:name) or ($UnterelementO/xdf:definition != $UnterelementA/xdf:definition)"> ##</xsl:if>
																				</td>
																			</xsl:when>
																			<xsl:otherwise>
																				<td class="Ungleich">
																					<xsl:value-of select="$UnterelementO/xdf:name"/><xsl:if test="($UnterelementO/xdf:identifikation/xdf:version != $UnterelementA/xdf:identifikation/xdf:version) or ($UnterelementO/xdf:name != $UnterelementA/xdf:name) or ($UnterelementO/xdf:definition != $UnterelementA/xdf:definition)"> ##</xsl:if>
																				</td>
																			</xsl:otherwise>
																		</xsl:choose>
																		<xsl:choose>
																			<xsl:when test="(empty($UnterelementO/xdf:definition) and empty($UnterelementA/xdf:definition)) or ($UnterelementO/xdf:definition = $UnterelementA/xdf:definition)">
																				<td class="Gleich">
																					<xsl:value-of select="$UnterelementO/xdf:definition"/>
																				</td>
																			</xsl:when>
																			<xsl:otherwise>
																				<td class="Ungleich">
																					<xsl:value-of select="$UnterelementO/xdf:definition"/>
																				</td>
																			</xsl:otherwise>
																		</xsl:choose>
																	</xsl:otherwise>
																</xsl:choose>
															</tr>
														</xsl:for-each>
														<xsl:for-each select="$VergleichsElement/xdf:regel">
															<xsl:variable name="UnterelementO" select="."/>
															<xsl:variable name="UnterelementA" select="$Element/xdf:regel[xdf:identifikation/xdf:id = $UnterelementO/xdf:identifikation/xdf:id]"/>
															<xsl:choose>
																<xsl:when test="empty($UnterelementA)">
																	<tr>
																		<td colspan="2">
																		</td>
																		<td>Nicht vorhanden
																		</td>
																		<td>
																		</td>
																		<td class="Ungleich">
																			<xsl:choose>
																				<xsl:when test="$RegelDetails = '1'">
																					<xsl:element name="a">
																						<xsl:attribute name="href">#X<xsl:value-of select="$UnterelementO/xdf:identifikation/xdf:id"/></xsl:attribute>
																						<xsl:value-of select="$UnterelementO/xdf:identifikation/xdf:id"/>
																					</xsl:element>
																				</xsl:when>
																				<xsl:otherwise>
																					<xsl:value-of select="$UnterelementO/xdf:identifikation/xdf:id"/>
																				</xsl:otherwise>
																			</xsl:choose>
																		</td>
																		<td class="Ungleich">
																			<xsl:value-of select="$UnterelementO/xdf:identifikation/xdf:version"/>
																		</td>
																		<td class="Ungleich">
																			<xsl:value-of select="$UnterelementO/xdf:name"/> ##
																		</td>
																		<td class="Ungleich">
																			<xsl:value-of select="$UnterelementO/xdf:definition"/>
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

	<xsl:template name="listeelementedetailzustammdatenschema">

		<xsl:if test="$DebugMode = '1' or $DebugMode = '2' or $DebugMode = '3' or $DebugMode = '4'">
			<xsl:message>
				++++ listeelementedetailzustammdatenschema ++++
			</xsl:message>
		</xsl:if>
	
					<h2><br/></h2>
					<h2>
						<a name="ElementDetails"/>Details zu den Baukastenelementen des Stammdatenschemas <xsl:value-of select="$NameSDSA"/> im Vergleich mit Stammdatenschema <xsl:value-of select="$NameSDSO"/>
					</h2>
					<table style="page-break-after:always">
						<thead>
							<tr>
								<th width="10%">Metadatum</th>
								<th width="45%">Inhalt Stammdatenschema <xsl:value-of select="$NameSDSA"/></th>
								<th width="45%">Inhalt Stammdatenschema <xsl:value-of select="$NameSDSO"/></th>
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

							<xsl:for-each-group select="$VergleichsDaten//xdf:datenfeldgruppe | $VergleichsDaten//xdf:datenfeld" group-by="xdf:identifikation/xdf:id">
								<xsl:sort select="./xdf:identifikation/xdf:id"/>
									
								<xsl:for-each-group select="fn:current-group()" group-by="string(xdf:identifikation/xdf:version)">
									<xsl:sort select="./xdf:identifikation/xdf:version"/>
									
									<xsl:variable name="CheckId" select="./xdf:identifikation/xdf:id"/>

									<xsl:if test="empty($Daten//xdf:identifikation[xdf:id = $CheckId])">

										<xsl:call-template name="elementdetailszustammdatenschemavergleich">
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

	<xsl:template name="elementdetailszustammdatenschema">
		<xsl:param name="Element"/>
		<xsl:param name="VersionsAnzahl"/>

		
		<xsl:variable name="Temp" select="$VergleichsDaten//*[xdf:identifikation/xdf:id = $Element/xdf:identifikation/xdf:id]"/>
		<xsl:variable name="VergleichsElement" select="$Temp[1]"/>
		
		<xsl:if test="$DebugMode = '2' or $DebugMode = '3' or $DebugMode = '4'">
			<xsl:message>
				++++++++ elementdetailszustammdatenschema ++++++++
			</xsl:message>
		</xsl:if>
		<xsl:if test="$DebugMode = '3' or $DebugMode = '4'">
			<xsl:message>
				-------- <xsl:value-of select="$Element/xdf:identifikation/xdf:id"/><xsl:if test="$Element/xdf:identifikation/xdf:version">V<xsl:value-of select="$Element/xdf:identifikation/xdf:version"/></xsl:if> --------
			</xsl:message>
		</xsl:if>

									<xsl:choose>
										<xsl:when test="$Element/name() = 'xdf:datenfeld'">
											<tr>
												<td>
													<xsl:element name="a">
														<xsl:attribute name="name"><xsl:value-of select="$Element/xdf:identifikation/xdf:id"/><xsl:if test="$Element/xdf:identifikation/xdf:version">V<xsl:value-of select="$Element/xdf:identifikation/xdf:version"/></xsl:if></xsl:attribute>
													</xsl:element>
													ID <xsl:if test="empty($VergleichsElement)">##</xsl:if>
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
												<xsl:choose>
													<xsl:when test="empty($VergleichsElement)">
														<td class="Ungleich NeuBaukasten">Nicht vorhanden</td>
													</xsl:when>
													<xsl:otherwise>
														<td class="ElementID">
															<xsl:element name="a">
																<xsl:attribute name="name">X<xsl:value-of select="$VergleichsElement/xdf:identifikation/xdf:id"/><xsl:if test="$VergleichsElement/xdf:identifikation/xdf:version">V<xsl:value-of select="$VergleichsElement/xdf:identifikation/xdf:version"/></xsl:if></xsl:attribute>
															</xsl:element>
															<xsl:value-of select="$VergleichsElement/xdf:identifikation/xdf:id"/>
															<xsl:if test="$ToolAufruf = '1'">
																&#160;&#160;
																<xsl:element name="a">
																	<xsl:attribute name="href"><xsl:value-of select="$ToolPfadPrefix"/><xsl:value-of select="$VergleichsElement/xdf:identifikation/xdf:id"/><xsl:if test="$VergleichsElement/xdf:identifikation/xdf:version">V<xsl:value-of select="$VergleichsElement/xdf:identifikation/xdf:version"/></xsl:if><xsl:value-of select="$ToolPfadPostfix"/></xsl:attribute>
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
												<td>Version <xsl:if test="fn:not(empty($VergleichsElement)) and (fn:not((empty($Element/xdf:identifikation/xdf:version) and empty($VergleichsElement/xdf:identifikation/xdf:version)) or ($Element/xdf:identifikation/xdf:version = $VergleichsElement/xdf:identifikation/xdf:version)))">##</xsl:if></td>
												<xsl:choose>
													<xsl:when test="$VersionsAnzahl &gt; 1">
														<td>
															<xsl:value-of select="$Element/xdf:identifikation/xdf:version"/>
														</td>
													</xsl:when>
													<xsl:otherwise>
														<td>
															<xsl:value-of select="$Element/xdf:identifikation/xdf:version"/>
														</td>
													</xsl:otherwise>
												</xsl:choose>
												<xsl:choose>
													<xsl:when test="empty($VergleichsElement) or (empty($Element/xdf:identifikation/xdf:version) and empty($VergleichsElement/xdf:identifikation/xdf:version)) or ($Element/xdf:identifikation/xdf:version = $VergleichsElement/xdf:identifikation/xdf:version)">
														<td class="Gleich">
															<xsl:value-of select="$VergleichsElement/xdf:identifikation/xdf:version"/>
														</td>
													</xsl:when>
													<xsl:otherwise>
														<td class="Ungleich AenderungBaukasten">
															<xsl:value-of select="$VergleichsElement/xdf:identifikation/xdf:version"/>
														</td>
													</xsl:otherwise>
												</xsl:choose>
											</tr>
											<tr>
												<td>Name <xsl:if test="fn:not(empty($VergleichsElement)) and (fn:not((empty($Element/xdf:name) and empty($VergleichsElement/xdf:name)) or ($Element/xdf:name = $VergleichsElement/xdf:name)))">##</xsl:if></td>
												<xsl:choose>
													<xsl:when test="empty($Element/xdf:name/text())">
													<td class="ElementName">
														</td>
													</xsl:when>
													<xsl:otherwise>
														<td class="ElementName">
															<xsl:value-of select="$Element/xdf:name"/>
														</td>
													</xsl:otherwise>
												</xsl:choose>
												<xsl:choose>
													<xsl:when test="empty($VergleichsElement) or (empty($Element/xdf:name) and empty($VergleichsElement/xdf:name)) or ($Element/xdf:name = $VergleichsElement/xdf:name)">
														<td class="ElementName Gleich">
															<xsl:value-of select="$VergleichsElement/xdf:name"/>
														</td>
													</xsl:when>
													<xsl:otherwise>
														<td class="ElementName Ungleich">
															<xsl:value-of select="$VergleichsElement/xdf:name"/>
														</td>
													</xsl:otherwise>
												</xsl:choose>
											</tr>
											<tr>
												<td>Definition <xsl:if test="fn:not(empty($VergleichsElement)) and (fn:not((empty($Element/xdf:definition) and empty($VergleichsElement/xdf:definition)) or ($Element/xdf:definition = $VergleichsElement/xdf:definition)))">##</xsl:if></td>
												<td>
													<xsl:value-of select="$Element/xdf:definition"/>
												</td>
												<xsl:choose>
													<xsl:when test="empty($VergleichsElement) or (empty($Element/xdf:definition) and empty($VergleichsElement/xdf:definition)) or ($Element/xdf:definition = $VergleichsElement/xdf:definition)">
														<td class="Gleich">
															<xsl:value-of select="$VergleichsElement/xdf:definition"/>
														</td>
													</xsl:when>
													<xsl:otherwise>
														<td class="Ungleich">
															<xsl:value-of select="$VergleichsElement/xdf:definition"/>
														</td>
													</xsl:otherwise>
												</xsl:choose>
											</tr>
											<tr>
												<td>Strukturelementart <xsl:if test="fn:not(empty($VergleichsElement)) and (fn:not((empty($Element/xdf:schemaelementart) and empty($VergleichsElement/xdf:schemaelementart)) or ($Element/xdf:schemaelementart = $VergleichsElement/xdf:schemaelementart)))">##</xsl:if></td>
												<td>
													<xsl:apply-templates select="$Element/xdf:schemaelementart"/>
												</td>
												<xsl:choose>
													<xsl:when test="empty($VergleichsElement) or (empty($Element/xdf:schemaelementart) and empty($VergleichsElement/xdf:schemaelementart)) or ($Element/xdf:schemaelementart = $VergleichsElement/xdf:schemaelementart)">
														<td class="Gleich">
															<xsl:apply-templates select="$VergleichsElement/xdf:schemaelementart"/>
														</td>
													</xsl:when>
													<xsl:otherwise>
														<td class="Ungleich">
															<xsl:apply-templates select="$VergleichsElement/xdf:schemaelementart"/>
														</td>
													</xsl:otherwise>
												</xsl:choose>
											</tr>
											<tr>
												<td>Bezug zu Rechtsnorm oder Standardisierungsvorhaben <xsl:if test="fn:not(empty($VergleichsElement)) and (fn:not((empty($Element/xdf:bezug) and empty($VergleichsElement/xdf:bezug)) or ($Element/xdf:bezug = $VergleichsElement/xdf:bezug)))">##</xsl:if></td>
												<xsl:choose>
													<xsl:when test="$Element/xdf:schemaelementart/code/text() = 'RNG' and empty($Element/xdf:bezug/text())">
														<td>
														</td>
													</xsl:when>
													<xsl:when test="$Element/xdf:schemaelementart/code/text() = 'HAR' and empty($Element/xdf:bezug/text())">
														<td>
														</td>
													</xsl:when>
													<xsl:otherwise>
														<td>
															<xsl:value-of select="$Element/xdf:bezug"/>
														</td>
													</xsl:otherwise>
												</xsl:choose>
												<xsl:choose>
													<xsl:when test="empty($VergleichsElement) or (empty($Element/xdf:bezug) and empty($VergleichsElement/xdf:bezug)) or ($Element/xdf:bezug = $VergleichsElement/xdf:bezug)">
														<td class="Gleich">
															<xsl:value-of select="$VergleichsElement/xdf:bezug"/>
														</td>
													</xsl:when>
													<xsl:otherwise>
														<td class="Ungleich">
															<xsl:value-of select="$VergleichsElement/xdf:bezug"/>
														</td>
													</xsl:otherwise>
												</xsl:choose>
											</tr>
											<tr>
												<td>Feldart <xsl:if test="fn:not(empty($VergleichsElement)) and (fn:not((empty($Element/xdf:feldart) and empty($VergleichsElement/xdf:feldart)) or ($Element/xdf:feldart = $VergleichsElement/xdf:feldart)))">##</xsl:if></td>
												<td>
													<xsl:apply-templates select="$Element/xdf:feldart"/>													
												</td>
												<xsl:choose>
													<xsl:when test="empty($VergleichsElement) or (empty($Element/xdf:feldart) and empty($VergleichsElement/xdf:feldart)) or ($Element/xdf:feldart = $VergleichsElement/xdf:feldart)">
														<td class="Gleich">
															<xsl:apply-templates select="$VergleichsElement/xdf:feldart"/>
														</td>
													</xsl:when>
													<xsl:otherwise>
														<td class="Ungleich">
															<xsl:apply-templates select="$VergleichsElement/xdf:feldart"/>
														</td>
													</xsl:otherwise>
												</xsl:choose>
											</tr>
											<tr>
												<td>Datentyp <xsl:if test="fn:not(empty($VergleichsElement)) and (fn:not((empty($Element/xdf:datentyp) and empty($VergleichsElement/xdf:datentyp)) or ($Element/xdf:datentyp = $VergleichsElement/xdf:datentyp)))">##</xsl:if></td>
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
																</td>
															</xsl:when>
															<xsl:otherwise>
																<td>
																	<xsl:apply-templates select="$Element/xdf:datentyp"/>
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
												<xsl:choose>
													<xsl:when test="empty($VergleichsElement) or (empty($Element/xdf:datentyp) and empty($VergleichsElement/xdf:datentyp)) or ($Element/xdf:datentyp = $VergleichsElement/xdf:datentyp)">
														<td class="Gleich">
															<xsl:apply-templates select="$VergleichsElement/xdf:datentyp"/>
														</td>
													</xsl:when>
													<xsl:otherwise>
														<td class="Ungleich">
															<xsl:apply-templates select="$VergleichsElement/xdf:datentyp"/>
														</td>
													</xsl:otherwise>
												</xsl:choose>
											</tr>
											<tr>
												<xsl:variable name="minLengthA"><xsl:if test="substring-before(substring-after($Element/xdf:praezisierung,'minLength&quot;:&quot;'),'&quot;') != ''"><xsl:value-of select="substring-before(substring-after($Element/xdf:praezisierung,'minLength&quot;:&quot;'),'&quot;')"/></xsl:if></xsl:variable>
												<xsl:variable name="maxLengthA"><xsl:if test="substring-before(substring-after($Element/xdf:praezisierung,'maxLength&quot;:&quot;'),'&quot;') != ''"><xsl:value-of select="substring-before(substring-after($Element/xdf:praezisierung,'maxLength&quot;:&quot;'),'&quot;')"/></xsl:if></xsl:variable>
												<xsl:variable name="LengthTextA">
													<xsl:if test="$minLengthA != ''">
														von <xsl:value-of select="$minLengthA"/> 
													</xsl:if>
													<xsl:if test="$maxLengthA != ''">
														bis <xsl:value-of select="$maxLengthA"/>
													</xsl:if>
												</xsl:variable>
												<xsl:variable name="minLengthO"><xsl:if test="substring-before(substring-after($VergleichsElement/xdf:praezisierung,'minLength&quot;:&quot;'),'&quot;') != ''"><xsl:value-of select="substring-before(substring-after($VergleichsElement/xdf:praezisierung,'minLength&quot;:&quot;'),'&quot;')"/></xsl:if></xsl:variable>
												<xsl:variable name="maxLengthO"><xsl:if test="substring-before(substring-after($VergleichsElement/xdf:praezisierung,'maxLength&quot;:&quot;'),'&quot;') != ''"><xsl:value-of select="substring-before(substring-after($VergleichsElement/xdf:praezisierung,'maxLength&quot;:&quot;'),'&quot;')"/></xsl:if></xsl:variable>
												<xsl:variable name="LengthTextO">
													<xsl:if test="$minLengthO != ''">
														von <xsl:value-of select="$minLengthO"/> 
													</xsl:if>
													<xsl:if test="$maxLengthO != ''">
														bis <xsl:value-of select="$maxLengthO"/>
													</xsl:if>
												</xsl:variable>
											
												<td>Feldlänge <xsl:if test="fn:not(empty($VergleichsElement)) and (fn:not((empty($LengthTextA) and empty($LengthTextO)) or ($LengthTextA = $LengthTextO)))">##</xsl:if></td>
												<xsl:choose>
													<xsl:when test="$Element/xdf:praezisierung/text() != ''">
													
														<xsl:choose>
															<xsl:when test="$Element/xdf:datentyp/code/text() = 'text'">
																<xsl:choose>
																	<xsl:when test="$Element/xdf:feldart/code/text() = 'select'">
																		<xsl:choose>
																			<xsl:when test="$minLengthA != '' or $maxLengthA != ''">
																				<td>
																					<xsl:value-of select="$LengthTextA"/>
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
																			<xsl:when test="$minLengthA != '' and $maxLengthA != ''">
																				<td>
																					<xsl:value-of select="$LengthTextA"/>
																				</td>
																			</xsl:when>
																			<xsl:otherwise>
																				<td>
																					<xsl:value-of select="$LengthTextA"/>
																				</td>
																			</xsl:otherwise>
																		</xsl:choose>
																	
																	</xsl:otherwise>
																</xsl:choose>
															</xsl:when>
															<xsl:when test="$minLengthA != '' or $maxLengthA != ''">
																<td>
																	<xsl:value-of select="$LengthTextA"/>
																</td>
															</xsl:when>
															<xsl:otherwise>
																<td></td>
															</xsl:otherwise>
														</xsl:choose>

													</xsl:when>
													<xsl:otherwise>
														<xsl:choose>
															<xsl:when test="$Element/xdf:datentyp/code/text() = 'text' and $Element/xdf:feldart/code/text() != 'select'">
																<td>
																</td>
															</xsl:when>
															<xsl:otherwise>
																<td></td>
															</xsl:otherwise>
														</xsl:choose>
													</xsl:otherwise>
												</xsl:choose>
												<xsl:choose>
													<xsl:when test="empty($VergleichsElement) or (empty($LengthTextA) and empty($LengthTextO)) or ($LengthTextA = $LengthTextO)">
														<td class="Gleich">
															<xsl:value-of select="$LengthTextO"/>
														</td>
													</xsl:when>
													<xsl:otherwise>
														<td class="Ungleich">
															<xsl:value-of select="$LengthTextO"/>
														</td>
													</xsl:otherwise>
												</xsl:choose>
											</tr>
											<tr>
												<xsl:variable name="minValueA"><xsl:if test="substring-before(substring-after($Element/xdf:praezisierung,'minValue&quot;:&quot;'),'&quot;') != ''"><xsl:value-of select="substring-before(substring-after($Element/xdf:praezisierung,'minValue&quot;:&quot;'),'&quot;')"/></xsl:if></xsl:variable>
												<xsl:variable name="maxValueA"><xsl:if test="substring-before(substring-after($Element/xdf:praezisierung,'maxValue&quot;:&quot;'),'&quot;') != ''"><xsl:value-of select="substring-before(substring-after($Element/xdf:praezisierung,'maxValue&quot;:&quot;'),'&quot;')"/></xsl:if></xsl:variable>
												<xsl:variable name="ValueTextA">
													<xsl:if test="$minValueA != ''">
														von <xsl:value-of select="$minValueA"/> 
													</xsl:if>
													<xsl:if test="$maxValueA != ''">
														bis <xsl:value-of select="$maxValueA"/>
													</xsl:if>
												</xsl:variable>
												<xsl:variable name="minValueO"><xsl:if test="substring-before(substring-after($VergleichsElement/xdf:praezisierung,'minValue&quot;:&quot;'),'&quot;') != ''"><xsl:value-of select="substring-before(substring-after($VergleichsElement/xdf:praezisierung,'minValue&quot;:&quot;'),'&quot;')"/></xsl:if></xsl:variable>
												<xsl:variable name="maxValueO"><xsl:if test="substring-before(substring-after($VergleichsElement/xdf:praezisierung,'maxValue&quot;:&quot;'),'&quot;') != ''"><xsl:value-of select="substring-before(substring-after($VergleichsElement/xdf:praezisierung,'maxValue&quot;:&quot;'),'&quot;')"/></xsl:if></xsl:variable>
												<xsl:variable name="ValueTextO">
													<xsl:if test="$minValueO != ''">
														von <xsl:value-of select="$minValueO"/> 
													</xsl:if>
													<xsl:if test="$maxValueO != ''">
														bis <xsl:value-of select="$maxValueO"/>
													</xsl:if>
												</xsl:variable>
											
												<td>Wertebereich <xsl:if test="fn:not(empty($VergleichsElement)) and (fn:not((empty($ValueTextA) and empty($ValueTextO)) or ($ValueTextA = $ValueTextO)))">##</xsl:if></td>
												<xsl:choose>
													<xsl:when test="$Element/xdf:praezisierung/text() != ''">

														<xsl:choose>
															<xsl:when test="$Element/xdf:datentyp/code/text() = 'num' or $Element/xdf:datentyp/code/text() = 'num_int' or $Element/xdf:datentyp/code/text() = 'num_currency'">
																<td>
																	<xsl:value-of select="$ValueTextA"/> 
																</td>
															</xsl:when>
															<xsl:otherwise>
																<xsl:choose>
																	<xsl:when test="$minValueA != '' or $maxValueA != ''">
																		<td>
																			<xsl:value-of select="$ValueTextA"/> 
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
																</td>
															</xsl:when>
															<xsl:otherwise>
																<td></td>
															</xsl:otherwise>
														</xsl:choose>
													</xsl:otherwise>
												</xsl:choose>
												<xsl:choose>
													<xsl:when test="empty($VergleichsElement) or (empty($ValueTextA) and empty($ValueTextO)) or ($ValueTextA = $ValueTextO)">
														<td class="Gleich">
															<xsl:value-of select="$ValueTextO"/>
														</td>
													</xsl:when>
													<xsl:otherwise>
														<td class="Ungleich">
															<xsl:value-of select="$ValueTextO"/>
														</td>
													</xsl:otherwise>
												</xsl:choose>
											</tr>
											<tr>
												<xsl:variable name="PatternTextA">
													<xsl:if test="$Element/xdf:praezisierung/text() != ''">
														<xsl:if test="substring-before(substring-after($Element/xdf:praezisierung,'pattern&quot;:&quot;'),'&quot;') != ''">
															<xsl:value-of select="substring-before(substring-after($Element/xdf:praezisierung,'pattern&quot;:&quot;'),'&quot;')"/>
														</xsl:if>
													</xsl:if>
												</xsl:variable>
												<xsl:variable name="PatternTextO">
													<xsl:if test="$VergleichsElement/xdf:praezisierung/text() != ''">
														<xsl:if test="substring-before(substring-after($VergleichsElement/xdf:praezisierung,'pattern&quot;:&quot;'),'&quot;') != ''">
															<xsl:value-of select="substring-before(substring-after($VergleichsElement/xdf:praezisierung,'pattern&quot;:&quot;'),'&quot;')"/>
														</xsl:if>
													</xsl:if>
												</xsl:variable>

												<td>Pattern <xsl:if test="fn:not(empty($VergleichsElement)) and (fn:not((empty($PatternTextA) and empty($PatternTextO)) or ($PatternTextA = $PatternTextO)))">##</xsl:if></td>
												<td>
													<xsl:value-of select="$PatternTextA"/>
												</td>
												<xsl:choose>
													<xsl:when test="empty($VergleichsElement) or (empty($PatternTextA) and empty($PatternTextO)) or ($PatternTextA = $PatternTextO)">
														<td class="Gleich">
															<xsl:value-of select="$PatternTextO"/>
														</td>
													</xsl:when>
													<xsl:otherwise>
														<td class="Ungleich">
															<xsl:value-of select="$PatternTextO"/>
														</td>
													</xsl:otherwise>
												</xsl:choose>
											</tr>
											<tr>
												<td>Zugeordnete Codeliste <xsl:if test="fn:not(empty($VergleichsElement)) and (fn:not((empty($Element/xdf:codelisteReferenz/xdf:identifikation/xdf:id) and empty($VergleichsElement/xdf:codelisteReferenz/xdf:identifikation/xdf:id)) or ($Element/xdf:codelisteReferenz/xdf:identifikation/xdf:id = $VergleichsElement/xdf:codelisteReferenz/xdf:identifikation/xdf:id)))">##</xsl:if></td>
												<xsl:choose>
													<xsl:when test="$Element/xdf:feldart/code/text() != 'select' and $Element/xdf:codelisteReferenz">
														<td>
															<xsl:element name="a">
																<xsl:attribute name="href">#<xsl:value-of select="$Element/xdf:codelisteReferenz/xdf:identifikation/xdf:id"/></xsl:attribute>
																<xsl:value-of select="$Element/xdf:codelisteReferenz/xdf:identifikation/xdf:id"/>
															</xsl:element>
															<xsl:if test="($ToolAufruf = '1') and fn:not(empty($Element/xdf:codelisteReferenz/xdf:identifikation/xdf:id))">
																&#160;&#160;
																<xsl:element name="a">
																	<xsl:attribute name="href"><xsl:value-of select="$ToolPfadPrefix"/><xsl:value-of select="$Element/xdf:codelisteReferenz/xdf:identifikation/xdf:id"/><xsl:value-of select="$ToolPfadPostfix"/></xsl:attribute>
																	<xsl:attribute name="target">FIMTool</xsl:attribute>
																	<xsl:attribute name="title">Springe in den Datenfeldeditor (man muss vorher angemeldet sein).</xsl:attribute>
																	&#8658;
																</xsl:element>
															</xsl:if>
														</td>
													</xsl:when>
													<xsl:when test="$Element/xdf:feldart/code/text() = 'select' and not($Element/xdf:codelisteReferenz)">
														<td>
														</td>
													</xsl:when>
													<xsl:otherwise>
														<td>
															<xsl:element name="a">
																<xsl:attribute name="href">#<xsl:value-of select="$Element/xdf:codelisteReferenz/xdf:identifikation/xdf:id"/></xsl:attribute>
																<xsl:value-of select="$Element/xdf:codelisteReferenz/xdf:identifikation/xdf:id"/>
															</xsl:element>
															<xsl:if test="($ToolAufruf = '1') and fn:not(empty($Element/xdf:codelisteReferenz/xdf:identifikation/xdf:id))">
																&#160;&#160;
																<xsl:element name="a">
																	<xsl:attribute name="href"><xsl:value-of select="$ToolPfadPrefix"/><xsl:value-of select="$Element/xdf:codelisteReferenz/xdf:identifikation/xdf:id"/><xsl:value-of select="$ToolPfadPostfix"/></xsl:attribute>
																	<xsl:attribute name="target">FIMTool</xsl:attribute>
																	<xsl:attribute name="title">Springe in den Datenfeldeditor (man muss vorher angemeldet sein).</xsl:attribute>
																	&#8658;
																</xsl:element>
															</xsl:if>
														</td>
													</xsl:otherwise>
												</xsl:choose>
												<xsl:choose>
													<xsl:when test="empty($VergleichsElement) or (empty($Element/xdf:codelisteReferenz/xdf:identifikation/xdf:id) and empty($VergleichsElement/xdf:codelisteReferenz/xdf:identifikation/xdf:id)) or ($Element/xdf:codelisteReferenz/xdf:identifikation/xdf:id = $VergleichsElement/xdf:codelisteReferenz/xdf:identifikation/xdf:id)">
														<td class="Gleich">
															<xsl:element name="a">
																<xsl:attribute name="href">#X<xsl:value-of select="$VergleichsElement/xdf:codelisteReferenz/xdf:identifikation/xdf:id"/></xsl:attribute>
																<xsl:value-of select="$VergleichsElement/xdf:codelisteReferenz/xdf:identifikation/xdf:id"/>
															</xsl:element>
															<xsl:if test="($ToolAufruf = '1') and fn:not(empty($VergleichsElement/xdf:codelisteReferenz/xdf:identifikation/xdf:id))">
																&#160;&#160;
																<xsl:element name="a">
																	<xsl:attribute name="href"><xsl:value-of select="$ToolPfadPrefix"/><xsl:value-of select="$VergleichsElement/xdf:codelisteReferenz/xdf:identifikation/xdf:id"/><xsl:value-of select="$ToolPfadPostfix"/></xsl:attribute>
																	<xsl:attribute name="target">FIMTool</xsl:attribute>
																	<xsl:attribute name="title">Springe in den Datenfeldeditor (man muss vorher angemeldet sein).</xsl:attribute>
																	&#8658;
																</xsl:element>
															</xsl:if>
														</td>
													</xsl:when>
													<xsl:otherwise>
														<td class="Ungleich">
															<xsl:element name="a">
																<xsl:attribute name="href">#X<xsl:value-of select="$VergleichsElement/xdf:codelisteReferenz/xdf:identifikation/xdf:id"/></xsl:attribute>
																<xsl:value-of select="$VergleichsElement/xdf:codelisteReferenz/xdf:identifikation/xdf:id"/>
															</xsl:element>
															<xsl:if test="($ToolAufruf = '1') and fn:not(empty($VergleichsElement/xdf:codelisteReferenz/xdf:identifikation/xdf:id))">
																&#160;&#160;
																<xsl:element name="a">
																	<xsl:attribute name="href"><xsl:value-of select="$ToolPfadPrefix"/><xsl:value-of select="$VergleichsElement/xdf:codelisteReferenz/xdf:identifikation/xdf:id"/><xsl:value-of select="$ToolPfadPostfix"/></xsl:attribute>
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
												<xsl:variable name="HinweisTextA">
													<xsl:if test="$Element/xdf:praezisierung/text() != ''">
														<xsl:choose>
															<xsl:when test="substring($Element/xdf:praezisierung/text(),1,1) = '{'">
																<xsl:if test="substring-before(substring-after($Element/xdf:praezisierung,'note&quot;:&quot;'),'&quot;') != ''">
																	<xsl:value-of select="substring-before(substring-after($Element/xdf:praezisierung,'note&quot;:&quot;'),'&quot;')"/>
																</xsl:if>
															</xsl:when>
															<xsl:otherwise>
																<xsl:value-of select="$Element/xdf:praezisierung"/>
															</xsl:otherwise>
														</xsl:choose>
													</xsl:if>
												</xsl:variable>
												<xsl:variable name="HinweisTextO">
													<xsl:if test="$Element/xdf:praezisierung/text() != ''">
														<xsl:choose>
															<xsl:when test="substring($VergleichsElement/xdf:praezisierung/text(),1,1) = '{'">
																<xsl:if test="substring-before(substring-after($VergleichsElement/xdf:praezisierung,'note&quot;:&quot;'),'&quot;') != ''">
																	<xsl:value-of select="substring-before(substring-after($VergleichsElement/xdf:praezisierung,'note&quot;:&quot;'),'&quot;')"/>
																</xsl:if>
															</xsl:when>
															<xsl:otherwise>
																<xsl:value-of select="$VergleichsElement/xdf:praezisierung"/>
															</xsl:otherwise>
														</xsl:choose>
													</xsl:if>
												</xsl:variable>
												
												<td>Hinweis <xsl:if test="fn:not(empty($VergleichsElement)) and (fn:not((empty($HinweisTextA) and empty($HinweisTextO)) or ($HinweisTextA = $HinweisTextO)))">##</xsl:if></td>
												<xsl:if test="$Element/xdf:praezisierung/text() != ''">
													<xsl:choose>
														<xsl:when test="substring($Element/xdf:praezisierung/text(),1,1) = '{'">
															<td>
																<xsl:value-of select="$HinweisTextA"/>
															</td>
														</xsl:when>
														<xsl:otherwise>
															<td>
																<xsl:value-of select="$HinweisTextA"/>
															</td>
														</xsl:otherwise>
													</xsl:choose>
												
												</xsl:if>
												<xsl:choose>
													<xsl:when test="empty($VergleichsElement) or (empty($HinweisTextA) and empty($HinweisTextO)) or ($HinweisTextA = $HinweisTextO)">
														<td class="Gleich">
															<xsl:value-of select="$HinweisTextO"/>
														</td>
													</xsl:when>
													<xsl:otherwise>
														<td class="Ungleich">
															<xsl:value-of select="$HinweisTextO"/>
														</td>
													</xsl:otherwise>
												</xsl:choose>
											</tr>
											<tr>
												<td>Inhalt <xsl:if test="fn:not(empty($VergleichsElement)) and (fn:not((empty($Element/xdf:inhalt) and empty($VergleichsElement/xdf:inhalt)) or ($Element/xdf:inhalt = $VergleichsElement/xdf:inhalt)))">##</xsl:if></td>
												<xsl:choose>
													<xsl:when test="$Element/xdf:feldart/code/text() = 'label' and empty($Element/xdf:inhalt/text())">
														<td>
														</td>
													</xsl:when>
													<xsl:otherwise>
														<td>
															<xsl:value-of select="$Element/xdf:inhalt"/>
														</td>
													</xsl:otherwise>
												</xsl:choose>
												<xsl:choose>
													<xsl:when test="empty($VergleichsElement) or (empty($Element/xdf:inhalt) and empty($VergleichsElement/xdf:inhalt)) or ($Element/xdf:inhalt = $VergleichsElement/xdf:inhalt)">
														<td class="Gleich">
															<xsl:value-of select="$VergleichsElement/xdf:inhalt"/>
														</td>
													</xsl:when>
													<xsl:otherwise>
														<td class="Ungleich">
															<xsl:value-of select="$VergleichsElement/xdf:inhalt"/>
														</td>
													</xsl:otherwise>
												</xsl:choose>
											</tr>
											<tr>
												<td>Beschreibung <xsl:if test="fn:not(empty($VergleichsElement)) and (fn:not((empty($Element/xdf:beschreibung) and empty($VergleichsElement/xdf:beschreibung)) or ($Element/xdf:beschreibung = $VergleichsElement/xdf:beschreibung)))">##</xsl:if></td>
												<td>
													<xsl:value-of select="$Element/xdf:beschreibung"/>
												</td>
												<xsl:choose>
													<xsl:when test="empty($VergleichsElement) or (empty($Element/xdf:beschreibung) and empty($VergleichsElement/xdf:beschreibung)) or ($Element/xdf:beschreibung = $VergleichsElement/xdf:beschreibung)">
														<td class="Gleich">
															<xsl:value-of select="$VergleichsElement/xdf:beschreibung"/>
														</td>
													</xsl:when>
													<xsl:otherwise>
														<td class="Ungleich">
															<xsl:value-of select="$VergleichsElement/xdf:beschreibung"/>
														</td>
													</xsl:otherwise>
												</xsl:choose>
											</tr>
											<tr>
												<td>Bezeichnung Eingabe <xsl:if test="fn:not(empty($VergleichsElement)) and (fn:not((empty($Element/xdf:bezeichnungEingabe) and empty($VergleichsElement/xdf:bezeichnungEingabe)) or ($Element/xdf:bezeichnungEingabe = $VergleichsElement/xdf:bezeichnungEingabe)))">##</xsl:if></td>
												<xsl:choose>
													<xsl:when test="empty($Element/xdf:bezeichnungEingabe/text())">
														<td>
														</td>
													</xsl:when>
													<xsl:otherwise>
														<td>
															<xsl:value-of select="$Element/xdf:bezeichnungEingabe"/>
														</td>
													</xsl:otherwise>
												</xsl:choose>
												<xsl:choose>
													<xsl:when test="empty($VergleichsElement) or (empty($Element/xdf:bezeichnungEingabe) and empty($VergleichsElement/xdf:bezeichnungEingabe)) or ($Element/xdf:bezeichnungEingabe = $VergleichsElement/xdf:bezeichnungEingabe)">
														<td class="Gleich">
															<xsl:value-of select="$VergleichsElement/xdf:bezeichnungEingabe"/>
														</td>
													</xsl:when>
													<xsl:otherwise>
														<td class="Ungleich">
															<xsl:value-of select="$VergleichsElement/xdf:bezeichnungEingabe"/>
														</td>
													</xsl:otherwise>
												</xsl:choose>
											</tr>
											<tr>
												<td>Bezeichnung Ausgabe <xsl:if test="fn:not(empty($VergleichsElement)) and (fn:not((empty($Element/xdf:bezeichnungAusgabe) and empty($VergleichsElement/xdf:bezeichnungAusgabe)) or ($Element/xdf:bezeichnungAusgabe = $VergleichsElement/xdf:bezeichnungAusgabe)))">##</xsl:if></td>
												<xsl:choose>
													<xsl:when test="empty($Element/xdf:bezeichnungAusgabe/text())">
														<td>
														</td>
													</xsl:when>
													<xsl:otherwise>
														<td>
															<xsl:value-of select="$Element/xdf:bezeichnungAusgabe"/>
														</td>
													</xsl:otherwise>
												</xsl:choose>
												<xsl:choose>
													<xsl:when test="empty($VergleichsElement) or (empty($Element/xdf:bezeichnungAusgabe) and empty($VergleichsElement/xdf:bezeichnungAusgabe)) or ($Element/xdf:bezeichnungAusgabe = $VergleichsElement/xdf:bezeichnungAusgabe)">
														<td class="Gleich">
															<xsl:value-of select="$VergleichsElement/xdf:bezeichnungAusgabe"/>
														</td>
													</xsl:when>
													<xsl:otherwise>
														<td class="Ungleich">
															<xsl:value-of select="$VergleichsElement/xdf:bezeichnungAusgabe"/>
														</td>
													</xsl:otherwise>
												</xsl:choose>
											</tr>
											<tr>
												<td>Hilfetext Eingabe <xsl:if test="fn:not(empty($VergleichsElement)) and (fn:not((empty($Element/xdf:hilfetextEingabe) and empty($VergleichsElement/xdf:hilfetextEingabe)) or ($Element/xdf:hilfetextEingabe = $VergleichsElement/xdf:hilfetextEingabe)))">##</xsl:if></td>
												<td>
													<xsl:value-of select="$Element/xdf:hilfetextEingabe"/>
												</td>
												<xsl:choose>
													<xsl:when test="empty($VergleichsElement) or (empty($Element/xdf:hilfetextEingabe) and empty($VergleichsElement/xdf:hilfetextEingabe)) or ($Element/xdf:hilfetextEingabe = $VergleichsElement/xdf:hilfetextEingabe)">
														<td class="Gleich">
															<xsl:value-of select="$VergleichsElement/xdf:hilfetextEingabe"/>
														</td>
													</xsl:when>
													<xsl:otherwise>
														<td class="Ungleich">
															<xsl:value-of select="$VergleichsElement/xdf:hilfetextEingabe"/>
														</td>
													</xsl:otherwise>
												</xsl:choose>
											</tr>
											<tr>
												<td>Hilfetext Ausgabe <xsl:if test="fn:not(empty($VergleichsElement)) and (fn:not((empty($Element/xdf:hilfetextAusgabe) and empty($VergleichsElement/xdf:hilfetextAusgabe)) or ($Element/xdf:hilfetextAusgabe = $VergleichsElement/xdf:hilfetextAusgabe)))">##</xsl:if></td>
												<td>
													<xsl:value-of select="$Element/xdf:hilfetextAusgabe"/>
												</td>
												<xsl:choose>
													<xsl:when test="empty($VergleichsElement) or (empty($Element/xdf:hilfetextAusgabe) and empty($VergleichsElement/xdf:hilfetextAusgabe)) or ($Element/xdf:hilfetextAusgabe = $VergleichsElement/xdf:hilfetextAusgabe)">
														<td class="Gleich">
															<xsl:value-of select="$VergleichsElement/xdf:hilfetextAusgabe"/>
														</td>
													</xsl:when>
													<xsl:otherwise>
														<td class="Ungleich">
															<xsl:value-of select="$VergleichsElement/xdf:hilfetextAusgabe"/>
														</td>
													</xsl:otherwise>
												</xsl:choose>
											</tr>
											<tr>
												<td>Fachlicher Ersteller <xsl:if test="fn:not(empty($VergleichsElement)) and (fn:not((empty($Element/xdf:fachlicherErsteller) and empty($VergleichsElement/xdf:fachlicherErsteller)) or ($Element/xdf:fachlicherErsteller = $VergleichsElement/xdf:fachlicherErsteller)))">##</xsl:if></td>
												<td>
													<xsl:value-of select="$Element/xdf:fachlicherErsteller"/>
												</td>
												<xsl:choose>
													<xsl:when test="empty($VergleichsElement) or (empty($Element/xdf:fachlicherErsteller) and empty($VergleichsElement/xdf:fachlicherErsteller)) or ($Element/xdf:fachlicherErsteller = $VergleichsElement/xdf:fachlicherErsteller)">
														<td class="Gleich">
															<xsl:value-of select="$VergleichsElement/xdf:fachlicherErsteller"/>
														</td>
													</xsl:when>
													<xsl:otherwise>
														<td class="Ungleich">
															<xsl:value-of select="$VergleichsElement/xdf:fachlicherErsteller"/>
														</td>
													</xsl:otherwise>
												</xsl:choose>
											</tr>
											<tr>
												<td>Status <xsl:if test="fn:not(empty($VergleichsElement)) and (fn:not((empty($Element/xdf:status) and empty($VergleichsElement/xdf:status)) or ($Element/xdf:status = $VergleichsElement/xdf:status)))">##</xsl:if></td>
												<td>
													<xsl:apply-templates select="$Element/xdf:status"/>
												</td>
												<xsl:choose>
													<xsl:when test="empty($VergleichsElement) or (empty($Element/xdf:status) and empty($VergleichsElement/xdf:status)) or ($Element/xdf:status = $VergleichsElement/xdf:status)">
														<td class="Gleich">
															<xsl:apply-templates select="$VergleichsElement/xdf:status"/>
														</td>
													</xsl:when>
													<xsl:otherwise>
														<td class="Ungleich">
															<xsl:apply-templates select="$VergleichsElement/xdf:status"/>
														</td>
													</xsl:otherwise>
												</xsl:choose>
											</tr>
											<tr>
												<td>Gültig ab <xsl:if test="fn:not(empty($VergleichsElement)) and (fn:not((empty($Element/xdf:gueltigAb) and empty($VergleichsElement/xdf:gueltigAb)) or ($Element/xdf:gueltigAb = $VergleichsElement/xdf:gueltigAb)))">##</xsl:if></td>
												<td>
													<xsl:value-of select="$Element/xdf:gueltigAb"/>
												</td>
												<xsl:choose>
													<xsl:when test="empty($VergleichsElement) or (empty($Element/xdf:gueltigAb) and empty($VergleichsElement/xdf:gueltigAb)) or ($Element/xdf:gueltigAb = $VergleichsElement/xdf:gueltigAb)">
														<td class="Gleich">
															<xsl:value-of select="$VergleichsElement/xdf:gueltigAb"/>
														</td>
													</xsl:when>
													<xsl:otherwise>
														<td class="Ungleich">
															<xsl:value-of select="$VergleichsElement/xdf:gueltigAb"/>
														</td>
													</xsl:otherwise>
												</xsl:choose>
											</tr>
											<tr>
												<td>Gültig bis <xsl:if test="fn:not(empty($VergleichsElement)) and (fn:not((empty($Element/xdf:gueltigBis) and empty($VergleichsElement/xdf:gueltigBis)) or ($Element/xdf:gueltigBis = $VergleichsElement/xdf:gueltigBis)))">##</xsl:if></td>
												<td>
													<xsl:value-of select="$Element/xdf:gueltigBis"/>
												</td>
												<xsl:choose>
													<xsl:when test="empty($VergleichsElement) or (empty($Element/xdf:gueltigBis) and empty($VergleichsElement/xdf:gueltigBis)) or ($Element/xdf:gueltigBis = $VergleichsElement/xdf:gueltigBis)">
														<td class="Gleich">
															<xsl:value-of select="$VergleichsElement/xdf:gueltigBis"/>
														</td>
													</xsl:when>
													<xsl:otherwise>
														<td class="Ungleich">
															<xsl:value-of select="$VergleichsElement/xdf:gueltigBis"/>
														</td>
													</xsl:otherwise>
												</xsl:choose>
											</tr>
											<tr>
												<td>Freigabedatum <xsl:if test="fn:not(empty($VergleichsElement)) and (fn:not((empty($Element/xdf:freigabedatum) and empty($VergleichsElement/xdf:freigabedatum)) or ($Element/xdf:freigabedatum = $VergleichsElement/xdf:freigabedatum)))">##</xsl:if></td>
												<td>
													<xsl:value-of select="$Element/xdf:freigabedatum"/>
												</td>
												<xsl:choose>
													<xsl:when test="empty($VergleichsElement) or (empty($Element/xdf:freigabedatum) and empty($VergleichsElement/xdf:freigabedatum)) or ($Element/xdf:freigabedatum = $VergleichsElement/xdf:freigabedatum)">
														<td class="Gleich">
															<xsl:value-of select="$VergleichsElement/xdf:freigabedatum"/>
														</td>
													</xsl:when>
													<xsl:otherwise>
														<td class="Ungleich">
															<xsl:value-of select="$VergleichsElement/xdf:freigabedatum"/>
														</td>
													</xsl:otherwise>
												</xsl:choose>
											</tr>
											<tr>
												<td>Veröffentlichungsdatum <xsl:if test="fn:not(empty($VergleichsElement)) and (fn:not((empty($Element/xdf:veroeffentlichungsdatum) and empty($VergleichsElement/xdf:veroeffentlichungsdatum)) or ($Element/xdf:veroeffentlichungsdatum = $VergleichsElement/xdf:veroeffentlichungsdatum)))">##</xsl:if></td>
												<td>
													<xsl:value-of select="$Element/xdf:veroeffentlichungsdatum"/>
												</td>
												<xsl:choose>
													<xsl:when test="empty($VergleichsElement) or (empty($Element/xdf:veroeffentlichungsdatum) and empty($VergleichsElement/xdf:veroeffentlichungsdatum)) or ($Element/xdf:veroeffentlichungsdatum = $VergleichsElement/xdf:veroeffentlichungsdatum)">
														<td class="Gleich">
															<xsl:value-of select="$VergleichsElement/xdf:veroeffentlichungsdatum"/>
														</td>
													</xsl:when>
													<xsl:otherwise>
														<td class="Ungleich">
															<xsl:value-of select="$VergleichsElement/xdf:veroeffentlichungsdatum"/>
														</td>
													</xsl:otherwise>
												</xsl:choose>
											</tr>

											<xsl:if test="count($Element/xdf:regel) or count($VergleichsElement/xdf:regel)">
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
																	<th width="22%">Definition</th>
																	<th width="5%">ID</th>
																	<th width="5%">Version</th>
																	<th width="18%">Name</th>
																	<th width="22%">Definition</th>
																</tr>
															</thead>
															<tbody>
																<xsl:for-each select="$Element/xdf:regel">

																	<xsl:variable name="UnterelementA" select="."/>
																	<xsl:variable name="UnterelementO" select="$VergleichsElement/xdf:regel[xdf:identifikation/xdf:id = $UnterelementA/xdf:identifikation/xdf:id]"/>

																	<tr>
																		<td>
																			<xsl:choose>
																				<xsl:when test="$RegelDetails = '1'">
																					<xsl:element name="a">
																						<xsl:attribute name="href">#<xsl:value-of select="./xdf:identifikation/xdf:id"/></xsl:attribute>
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
																			<xsl:value-of select="./xdf:definition"/>
																		</td>
																		<xsl:choose>
																			<xsl:when test="empty($VergleichsElement)">
																				<td colspan="4">
																				</td>
																			</xsl:when>
																			<xsl:when test="empty($UnterelementO)">
																				<td colspan="4" class="Ungleich">
																					Nicht vorhanden ##
																				</td>
																			</xsl:when>
																			<xsl:otherwise>
																				<td>
																					<xsl:choose>
																						<xsl:when test="$RegelDetails = '1'">
																							<xsl:element name="a">
																								<xsl:attribute name="href">#X<xsl:value-of select="$UnterelementO/xdf:identifikation/xdf:id"/></xsl:attribute>
																								<xsl:value-of select="$UnterelementO/xdf:identifikation/xdf:id"/>
																							</xsl:element>
																						</xsl:when>
																						<xsl:otherwise>
																							<xsl:value-of select="$UnterelementO/xdf:identifikation/xdf:id"/>
																						</xsl:otherwise>
																					</xsl:choose>
																				</td>
																				<xsl:choose>
																					<xsl:when test="(empty($UnterelementO/xdf:identifikation/xdf:version) and empty($UnterelementA/xdf:identifikation/xdf:version)) or ($UnterelementO/xdf:identifikation/xdf:version = $UnterelementA/xdf:identifikation/xdf:version)">
																						<td class="Gleich">
																							<xsl:value-of select="$UnterelementO/xdf:identifikation/xdf:version"/>
																						</td>
																					</xsl:when>
																					<xsl:otherwise>
																						<td class="Ungleich">
																							<xsl:value-of select="$UnterelementO/xdf:identifikation/xdf:version"/>
																						</td>
																					</xsl:otherwise>
																				</xsl:choose>
																				<xsl:choose>
																					<xsl:when test="(empty($UnterelementO/xdf:name) and empty($UnterelementA/xdf:name)) or ($UnterelementO/xdf:name = $UnterelementA/xdf:name)">
																						<td class="Gleich">
																							<xsl:value-of select="$UnterelementO/xdf:name"/><xsl:if test="($UnterelementO/xdf:identifikation/xdf:version != $UnterelementA/xdf:identifikation/xdf:version) or ($UnterelementO/xdf:name != $UnterelementA/xdf:name) or ($UnterelementO/xdf:definition != $UnterelementA/xdf:definition)"> ##</xsl:if>
																						</td>
																					</xsl:when>
																					<xsl:otherwise>
																						<td class="Ungleich">
																							<xsl:value-of select="$UnterelementO/xdf:name"/><xsl:if test="($UnterelementO/xdf:identifikation/xdf:version != $UnterelementA/xdf:identifikation/xdf:version) or ($UnterelementO/xdf:name != $UnterelementA/xdf:name) or ($UnterelementO/xdf:definition != $UnterelementA/xdf:definition)"> ##</xsl:if>
																						</td>
																					</xsl:otherwise>
																				</xsl:choose>
																				<xsl:choose>
																					<xsl:when test="(empty($UnterelementO/xdf:definition) and empty($UnterelementA/xdf:definition)) or ($UnterelementO/xdf:definition = $UnterelementA/xdf:definition)">
																						<td class="Gleich">
																							<xsl:value-of select="$UnterelementO/xdf:definition"/>
																						</td>
																					</xsl:when>
																					<xsl:otherwise>
																						<td class="Ungleich">
																							<xsl:value-of select="$UnterelementO/xdf:definition"/>
																						</td>
																					</xsl:otherwise>
																				</xsl:choose>
																			</xsl:otherwise>
																		</xsl:choose>
																	</tr>
																</xsl:for-each>
																<xsl:for-each select="$VergleichsElement/xdf:regel">
																	<xsl:variable name="UnterelementO" select="."/>
																	<xsl:variable name="UnterelementA" select="$Element/xdf:regel[xdf:identifikation/xdf:id = $UnterelementO/xdf:identifikation/xdf:id]"/>
																	<xsl:choose>
																		<xsl:when test="empty($UnterelementA)">
																			<tr>
																				<td colspan="4"/>
																				<td class="Ungleich">
																					<xsl:choose>
																						<xsl:when test="$RegelDetails = '1'">
																							<xsl:element name="a">
																								<xsl:attribute name="href">#X<xsl:value-of select="$UnterelementO/xdf:identifikation/xdf:id"/></xsl:attribute>
																								<xsl:value-of select="$UnterelementO/xdf:identifikation/xdf:id"/>
																							</xsl:element>
																						</xsl:when>
																						<xsl:otherwise>
																							<xsl:value-of select="$UnterelementO/xdf:identifikation/xdf:id"/>
																						</xsl:otherwise>
																					</xsl:choose>
																				</td>
																				<td class="Ungleich">
																					<xsl:value-of select="$UnterelementO/xdf:identifikation/xdf:version"/>
																				</td>
																				<td class="Ungleich">
																					<xsl:value-of select="$UnterelementO/xdf:name"/> ##
																				</td>
																				<td class="Ungleich">
																					<xsl:value-of select="$UnterelementO/xdf:definition"/>
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

												<xsl:variable name="FeldID" select="$Element/xdf:identifikation/xdf:id"/>
												<xsl:variable name="FeldVersion" select="$Element/xdf:identifikation/xdf:version"/>
												
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
																<xsl:when test="not($Element/xdf:identifikation/xdf:version)">
																
																		<xsl:for-each-group select="//xdf:datenfeldgruppe[xdf:struktur/xdf:enthaelt/xdf:datenfeld/xdf:identifikation/xdf:id = $FeldID]" group-by="xdf:identifikation/xdf:id">
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
			
																		<xsl:for-each-group select="//xdf:stammdatenschema[xdf:struktur/xdf:enthaelt/xdf:datenfeld/xdf:identifikation/xdf:id = $FeldID]" group-by="xdf:identifikation/xdf:id">
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
																		<xsl:for-each-group select="//xdf:datenfeldgruppe[xdf:struktur/xdf:enthaelt/xdf:datenfeld/xdf:identifikation/xdf:id = $FeldID and xdf:struktur/xdf:enthaelt/xdf:datenfeld/xdf:identifikation/xdf:version = $FeldVersion]" group-by="xdf:identifikation/xdf:id">
																			<xsl:sort select="./xdf:identifikation/xdf:id"/>
																			
																			<xsl:for-each-group select="fn:current-group()" group-by="string(xdf:identifikation/xdf:version)">
																				<xsl:sort select="./xdf:identifikation/xdf:version"/>
																			
																				<xsl:call-template name="minielementcore">
																					<xsl:with-param name="Element" select="."/>
																				</xsl:call-template>
																			
																			</xsl:for-each-group>
																		</xsl:for-each-group>
			
																		<xsl:for-each-group select="//xdf:stammdatenschema[xdf:struktur/xdf:enthaelt/xdf:datenfeld/xdf:identifikation/xdf:id = $FeldID and xdf:struktur/xdf:enthaelt/xdf:datenfeld/xdf:identifikation/xdf:version = $FeldVersion]" group-by="./xdf:identifikation/xdf:id">
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
										</xsl:when>
										<xsl:when test="$Element/name() = 'xdf:datenfeldgruppe'">
											<tr>
												<td>
													<xsl:element name="a">
														<xsl:attribute name="name"><xsl:value-of select="$Element/xdf:identifikation/xdf:id"/><xsl:if test="$Element/xdf:identifikation/xdf:version">V<xsl:value-of select="$Element/xdf:identifikation/xdf:version"/></xsl:if></xsl:attribute>
													</xsl:element>
													ID <xsl:if test="empty($VergleichsElement)">##</xsl:if>
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
												<xsl:choose>
													<xsl:when test="empty($VergleichsElement)">
														<td class="Ungleich NeuBaukasten">Nicht vorhanden</td>
													</xsl:when>
													<xsl:otherwise>
														<td class="ElementID">
															<xsl:element name="a">
																<xsl:attribute name="name">X<xsl:value-of select="$VergleichsElement/xdf:identifikation/xdf:id"/><xsl:if test="$VergleichsElement/xdf:identifikation/xdf:version">V<xsl:value-of select="$VergleichsElement/xdf:identifikation/xdf:version"/></xsl:if></xsl:attribute>
															</xsl:element>
															<xsl:value-of select="$VergleichsElement/xdf:identifikation/xdf:id"/>
															<xsl:if test="$ToolAufruf = '1'">
																&#160;&#160;
																<xsl:element name="a">
																	<xsl:attribute name="href"><xsl:value-of select="$ToolPfadPrefix"/><xsl:value-of select="$VergleichsElement/xdf:identifikation/xdf:id"/><xsl:if test="$VergleichsElement/xdf:identifikation/xdf:version">V<xsl:value-of select="$VergleichsElement/xdf:identifikation/xdf:version"/></xsl:if><xsl:value-of select="$ToolPfadPostfix"/></xsl:attribute>
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
												<td>Version <xsl:if test="fn:not(empty($VergleichsElement)) and (fn:not((empty($Element/xdf:identifikation/xdf:version) and empty($VergleichsElement/xdf:identifikation/xdf:version)) or ($Element/xdf:identifikation/xdf:version = $VergleichsElement/xdf:identifikation/xdf:version)))">##</xsl:if></td>
												<xsl:choose>
													<xsl:when test="$VersionsAnzahl &gt; 1">
														<td>
															<xsl:value-of select="$Element/xdf:identifikation/xdf:version"/>
														</td>
													</xsl:when>
													<xsl:otherwise>
														<td>
															<xsl:value-of select="$Element/xdf:identifikation/xdf:version"/>
														</td>
													</xsl:otherwise>
												</xsl:choose>
												<xsl:choose>
													<xsl:when test="empty($VergleichsElement) or (empty($Element/xdf:identifikation/xdf:version) and empty($VergleichsElement/xdf:identifikation/xdf:version)) or ($Element/xdf:identifikation/xdf:version = $VergleichsElement/xdf:identifikation/xdf:version)">
														<td class="Gleich">
															<xsl:value-of select="$VergleichsElement/xdf:identifikation/xdf:version"/>
														</td>
													</xsl:when>
													<xsl:otherwise>
														<td class="Ungleich AenderungBaukasten">
															<xsl:value-of select="$VergleichsElement/xdf:identifikation/xdf:version"/>
														</td>
													</xsl:otherwise>
												</xsl:choose>
											</tr>
											<tr>
												<td>Name <xsl:if test="fn:not(empty($VergleichsElement)) and (fn:not((empty($Element/xdf:name) and empty($VergleichsElement/xdf:name)) or ($Element/xdf:name = $VergleichsElement/xdf:name)))">##</xsl:if></td>
												<xsl:choose>
													<xsl:when test="empty($Element/xdf:name/text())">
													<td class="ElementName">
														</td>
													</xsl:when>
													<xsl:otherwise>
														<td class="ElementName">
															<xsl:value-of select="$Element/xdf:name"/>
														</td>
													</xsl:otherwise>
												</xsl:choose>
												<xsl:choose>
													<xsl:when test="empty($VergleichsElement) or (empty($Element/xdf:name) and empty($VergleichsElement/xdf:name)) or ($Element/xdf:name = $VergleichsElement/xdf:name)">
														<td class="ElementName Gleich">
															<xsl:value-of select="$VergleichsElement/xdf:name"/>
														</td>
													</xsl:when>
													<xsl:otherwise>
														<td class="ElementName Ungleich">
															<xsl:value-of select="$VergleichsElement/xdf:name"/>
														</td>
													</xsl:otherwise>
												</xsl:choose>
											</tr>
											<tr>
												<td>Definition <xsl:if test="fn:not(empty($VergleichsElement)) and (fn:not((empty($Element/xdf:definition) and empty($VergleichsElement/xdf:definition)) or ($Element/xdf:definition = $VergleichsElement/xdf:definition)))">##</xsl:if></td>
												<td>
													<xsl:value-of select="$Element/xdf:definition"/>
												</td>
												<xsl:choose>
													<xsl:when test="empty($VergleichsElement) or (empty($Element/xdf:definition) and empty($VergleichsElement/xdf:definition)) or ($Element/xdf:definition = $VergleichsElement/xdf:definition)">
														<td class="Gleich">
															<xsl:value-of select="$VergleichsElement/xdf:definition"/>
														</td>
													</xsl:when>
													<xsl:otherwise>
														<td class="Ungleich">
															<xsl:value-of select="$VergleichsElement/xdf:definition"/>
														</td>
													</xsl:otherwise>
												</xsl:choose>
											</tr>
											<tr>
												<td>Strukturelementart <xsl:if test="fn:not(empty($VergleichsElement)) and (fn:not((empty($Element/xdf:schemaelementart) and empty($VergleichsElement/xdf:schemaelementart)) or ($Element/xdf:schemaelementart = $VergleichsElement/xdf:schemaelementart)))">##</xsl:if></td>
												<td>
													<xsl:apply-templates select="$Element/xdf:schemaelementart"/>
												</td>
												<xsl:choose>
													<xsl:when test="empty($VergleichsElement) or (empty($Element/xdf:schemaelementart) and empty($VergleichsElement/xdf:schemaelementart)) or ($Element/xdf:schemaelementart = $VergleichsElement/xdf:schemaelementart)">
														<td class="Gleich">
															<xsl:apply-templates select="$VergleichsElement/xdf:schemaelementart"/>
														</td>
													</xsl:when>
													<xsl:otherwise>
														<td class="Ungleich">
															<xsl:apply-templates select="$VergleichsElement/xdf:schemaelementart"/>
														</td>
													</xsl:otherwise>
												</xsl:choose>
											</tr>
											<tr>
												<td>Bezug zu Rechtsnorm oder Standardisierungsvorhaben <xsl:if test="fn:not(empty($VergleichsElement)) and (fn:not((empty($Element/xdf:bezug) and empty($VergleichsElement/xdf:bezug)) or ($Element/xdf:bezug = $VergleichsElement/xdf:bezug)))">##</xsl:if></td>
												<xsl:choose>
													<xsl:when test="$Element/xdf:schemaelementart/code/text() = 'RNG' and empty($Element/xdf:bezug/text())">
														<td>
														</td>
													</xsl:when>
													<xsl:when test="$Element/xdf:schemaelementart/code/text() = 'HAR' and empty($Element/xdf:bezug/text())">
														<td>
														</td>
													</xsl:when>
													<xsl:otherwise>
														<td>
															<xsl:value-of select="$Element/xdf:bezug"/>
														</td>
													</xsl:otherwise>
												</xsl:choose>
												<xsl:choose>
													<xsl:when test="empty($VergleichsElement) or (empty($Element/xdf:bezug) and empty($VergleichsElement/xdf:bezug)) or ($Element/xdf:bezug = $VergleichsElement/xdf:bezug)">
														<td class="Gleich">
															<xsl:value-of select="$VergleichsElement/xdf:bezug"/>
														</td>
													</xsl:when>
													<xsl:otherwise>
														<td class="Ungleich">
															<xsl:value-of select="$VergleichsElement/xdf:bezug"/>
														</td>
													</xsl:otherwise>
												</xsl:choose>
											</tr>
											<tr>
												<td>Beschreibung <xsl:if test="fn:not(empty($VergleichsElement)) and (fn:not((empty($Element/xdf:beschreibung) and empty($VergleichsElement/xdf:beschreibung)) or ($Element/xdf:beschreibung = $VergleichsElement/xdf:beschreibung)))">##</xsl:if></td>
												<td>
													<xsl:value-of select="$Element/xdf:beschreibung"/>
												</td>
												<xsl:choose>
													<xsl:when test="empty($VergleichsElement) or (empty($Element/xdf:beschreibung) and empty($VergleichsElement/xdf:beschreibung)) or ($Element/xdf:beschreibung = $VergleichsElement/xdf:beschreibung)">
														<td class="Gleich">
															<xsl:value-of select="$VergleichsElement/xdf:beschreibung"/>
														</td>
													</xsl:when>
													<xsl:otherwise>
														<td class="Ungleich">
															<xsl:value-of select="$VergleichsElement/xdf:beschreibung"/>
														</td>
													</xsl:otherwise>
												</xsl:choose>
											</tr>
											<tr>
												<td>Bezeichnung Eingabe <xsl:if test="fn:not(empty($VergleichsElement)) and (fn:not((empty($Element/xdf:bezeichnungEingabe) and empty($VergleichsElement/xdf:bezeichnungEingabe)) or ($Element/xdf:bezeichnungEingabe = $VergleichsElement/xdf:bezeichnungEingabe)))">##</xsl:if></td>
												<xsl:choose>
													<xsl:when test="empty($Element/xdf:bezeichnungEingabe/text())">
														<td>
														</td>
													</xsl:when>
													<xsl:otherwise>
														<td>
															<xsl:value-of select="$Element/xdf:bezeichnungEingabe"/>
														</td>
													</xsl:otherwise>
												</xsl:choose>
												<xsl:choose>
													<xsl:when test="empty($VergleichsElement) or (empty($Element/xdf:bezeichnungEingabe) and empty($VergleichsElement/xdf:bezeichnungEingabe)) or ($Element/xdf:bezeichnungEingabe = $VergleichsElement/xdf:bezeichnungEingabe)">
														<td class="Gleich">
															<xsl:value-of select="$VergleichsElement/xdf:bezeichnungEingabe"/>
														</td>
													</xsl:when>
													<xsl:otherwise>
														<td class="Ungleich">
															<xsl:value-of select="$VergleichsElement/xdf:bezeichnungEingabe"/>
														</td>
													</xsl:otherwise>
												</xsl:choose>
											</tr>
											<tr>
												<td>Bezeichnung Ausgabe <xsl:if test="fn:not(empty($VergleichsElement)) and (fn:not((empty($Element/xdf:bezeichnungAusgabe) and empty($VergleichsElement/xdf:bezeichnungAusgabe)) or ($Element/xdf:bezeichnungAusgabe = $VergleichsElement/xdf:bezeichnungAusgabe)))">##</xsl:if></td>
												<xsl:choose>
													<xsl:when test="empty($Element/xdf:bezeichnungAusgabe/text())">
														<td>
														</td>
													</xsl:when>
													<xsl:otherwise>
														<td>
															<xsl:value-of select="$Element/xdf:bezeichnungAusgabe"/>
														</td>
													</xsl:otherwise>
												</xsl:choose>
												<xsl:choose>
													<xsl:when test="empty($VergleichsElement) or (empty($Element/xdf:bezeichnungAusgabe) and empty($VergleichsElement/xdf:bezeichnungAusgabe)) or ($Element/xdf:bezeichnungAusgabe = $VergleichsElement/xdf:bezeichnungAusgabe)">
														<td class="Gleich">
															<xsl:value-of select="$VergleichsElement/xdf:bezeichnungAusgabe"/>
														</td>
													</xsl:when>
													<xsl:otherwise>
														<td class="Ungleich">
															<xsl:value-of select="$VergleichsElement/xdf:bezeichnungAusgabe"/>
														</td>
													</xsl:otherwise>
												</xsl:choose>
											</tr>
											<tr>
												<td>Hilfetext Eingabe <xsl:if test="fn:not(empty($VergleichsElement)) and (fn:not((empty($Element/xdf:hilfetextEingabe) and empty($VergleichsElement/xdf:hilfetextEingabe)) or ($Element/xdf:hilfetextEingabe = $VergleichsElement/xdf:hilfetextEingabe)))">##</xsl:if></td>
												<td>
													<xsl:value-of select="$Element/xdf:hilfetextEingabe"/>
												</td>
												<xsl:choose>
													<xsl:when test="empty($VergleichsElement) or (empty($Element/xdf:hilfetextEingabe) and empty($VergleichsElement/xdf:hilfetextEingabe)) or ($Element/xdf:hilfetextEingabe = $VergleichsElement/xdf:hilfetextEingabe)">
														<td class="Gleich">
															<xsl:value-of select="$VergleichsElement/xdf:hilfetextEingabe"/>
														</td>
													</xsl:when>
													<xsl:otherwise>
														<td class="Ungleich">
															<xsl:value-of select="$VergleichsElement/xdf:hilfetextEingabe"/>
														</td>
													</xsl:otherwise>
												</xsl:choose>
											</tr>
											<tr>
												<td>Hilfetext Ausgabe <xsl:if test="fn:not(empty($VergleichsElement)) and (fn:not((empty($Element/xdf:hilfetextAusgabe) and empty($VergleichsElement/xdf:hilfetextAusgabe)) or ($Element/xdf:hilfetextAusgabe = $VergleichsElement/xdf:hilfetextAusgabe)))">##</xsl:if></td>
												<td>
													<xsl:value-of select="$Element/xdf:hilfetextAusgabe"/>
												</td>
												<xsl:choose>
													<xsl:when test="empty($VergleichsElement) or (empty($Element/xdf:hilfetextAusgabe) and empty($VergleichsElement/xdf:hilfetextAusgabe)) or ($Element/xdf:hilfetextAusgabe = $VergleichsElement/xdf:hilfetextAusgabe)">
														<td class="Gleich">
															<xsl:value-of select="$VergleichsElement/xdf:hilfetextAusgabe"/>
														</td>
													</xsl:when>
													<xsl:otherwise>
														<td class="Ungleich">
															<xsl:value-of select="$VergleichsElement/xdf:hilfetextAusgabe"/>
														</td>
													</xsl:otherwise>
												</xsl:choose>
											</tr>
											<tr>
												<td>Fachlicher Ersteller <xsl:if test="fn:not(empty($VergleichsElement)) and (fn:not((empty($Element/xdf:fachlicherErsteller) and empty($VergleichsElement/xdf:fachlicherErsteller)) or ($Element/xdf:fachlicherErsteller = $VergleichsElement/xdf:fachlicherErsteller)))">##</xsl:if></td>
												<td>
													<xsl:value-of select="$Element/xdf:fachlicherErsteller"/>
												</td>
												<xsl:choose>
													<xsl:when test="empty($VergleichsElement) or (empty($Element/xdf:fachlicherErsteller) and empty($VergleichsElement/xdf:fachlicherErsteller)) or ($Element/xdf:fachlicherErsteller = $VergleichsElement/xdf:fachlicherErsteller)">
														<td class="Gleich">
															<xsl:value-of select="$VergleichsElement/xdf:fachlicherErsteller"/>
														</td>
													</xsl:when>
													<xsl:otherwise>
														<td class="Ungleich">
															<xsl:value-of select="$VergleichsElement/xdf:fachlicherErsteller"/>
														</td>
													</xsl:otherwise>
												</xsl:choose>
											</tr>
											<tr>
												<td>Status <xsl:if test="fn:not(empty($VergleichsElement)) and (fn:not((empty($Element/xdf:status) and empty($VergleichsElement/xdf:status)) or ($Element/xdf:status = $VergleichsElement/xdf:status)))">##</xsl:if></td>
												<td>
													<xsl:apply-templates select="$Element/xdf:status"/>
												</td>
												<xsl:choose>
													<xsl:when test="empty($VergleichsElement) or (empty($Element/xdf:status) and empty($VergleichsElement/xdf:status)) or ($Element/xdf:status = $VergleichsElement/xdf:status)">
														<td class="Gleich">
															<xsl:apply-templates select="$VergleichsElement/xdf:status"/>
														</td>
													</xsl:when>
													<xsl:otherwise>
														<td class="Ungleich">
															<xsl:apply-templates select="$VergleichsElement/xdf:status"/>
														</td>
													</xsl:otherwise>
												</xsl:choose>
											</tr>
											<tr>
												<td>Gültig ab <xsl:if test="fn:not(empty($VergleichsElement)) and (fn:not((empty($Element/xdf:gueltigAb) and empty($VergleichsElement/xdf:gueltigAb)) or ($Element/xdf:gueltigAb = $VergleichsElement/xdf:gueltigAb)))">##</xsl:if></td>
												<td>
													<xsl:value-of select="$Element/xdf:gueltigAb"/>
												</td>
												<xsl:choose>
													<xsl:when test="empty($VergleichsElement) or (empty($Element/xdf:gueltigAb) and empty($VergleichsElement/xdf:gueltigAb)) or ($Element/xdf:gueltigAb = $VergleichsElement/xdf:gueltigAb)">
														<td class="Gleich">
															<xsl:value-of select="$VergleichsElement/xdf:gueltigAb"/>
														</td>
													</xsl:when>
													<xsl:otherwise>
														<td class="Ungleich">
															<xsl:value-of select="$VergleichsElement/xdf:gueltigAb"/>
														</td>
													</xsl:otherwise>
												</xsl:choose>
											</tr>
											<tr>
												<td>Gültig bis <xsl:if test="fn:not(empty($VergleichsElement)) and (fn:not((empty($Element/xdf:gueltigBis) and empty($VergleichsElement/xdf:gueltigBis)) or ($Element/xdf:gueltigBis = $VergleichsElement/xdf:gueltigBis)))">##</xsl:if></td>
												<td>
													<xsl:value-of select="$Element/xdf:gueltigBis"/>
												</td>
												<xsl:choose>
													<xsl:when test="empty($VergleichsElement) or (empty($Element/xdf:gueltigBis) and empty($VergleichsElement/xdf:gueltigBis)) or ($Element/xdf:gueltigBis = $VergleichsElement/xdf:gueltigBis)">
														<td class="Gleich">
															<xsl:value-of select="$VergleichsElement/xdf:gueltigBis"/>
														</td>
													</xsl:when>
													<xsl:otherwise>
														<td class="Ungleich">
															<xsl:value-of select="$VergleichsElement/xdf:gueltigBis"/>
														</td>
													</xsl:otherwise>
												</xsl:choose>
											</tr>
											<tr>
												<td>Freigabedatum <xsl:if test="fn:not(empty($VergleichsElement)) and (fn:not((empty($Element/xdf:freigabedatum) and empty($VergleichsElement/xdf:freigabedatum)) or ($Element/xdf:freigabedatum = $VergleichsElement/xdf:freigabedatum)))">##</xsl:if></td>
												<td>
													<xsl:value-of select="$Element/xdf:freigabedatum"/>
												</td>
												<xsl:choose>
													<xsl:when test="empty($VergleichsElement) or (empty($Element/xdf:freigabedatum) and empty($VergleichsElement/xdf:freigabedatum)) or ($Element/xdf:freigabedatum = $VergleichsElement/xdf:freigabedatum)">
														<td class="Gleich">
															<xsl:value-of select="$VergleichsElement/xdf:freigabedatum"/>
														</td>
													</xsl:when>
													<xsl:otherwise>
														<td class="Ungleich">
															<xsl:value-of select="$VergleichsElement/xdf:freigabedatum"/>
														</td>
													</xsl:otherwise>
												</xsl:choose>
											</tr>
											<tr>
												<td>Veröffentlichungsdatum <xsl:if test="fn:not(empty($VergleichsElement)) and (fn:not((empty($Element/xdf:veroeffentlichungsdatum) and empty($VergleichsElement/xdf:veroeffentlichungsdatum)) or ($Element/xdf:veroeffentlichungsdatum = $VergleichsElement/xdf:veroeffentlichungsdatum)))">##</xsl:if></td>
												<td>
													<xsl:value-of select="$Element/xdf:veroeffentlichungsdatum"/>
												</td>
												<xsl:choose>
													<xsl:when test="empty($VergleichsElement) or (empty($Element/xdf:veroeffentlichungsdatum) and empty($VergleichsElement/xdf:veroeffentlichungsdatum)) or ($Element/xdf:veroeffentlichungsdatum = $VergleichsElement/xdf:veroeffentlichungsdatum)">
														<td class="Gleich">
															<xsl:value-of select="$VergleichsElement/xdf:veroeffentlichungsdatum"/>
														</td>
													</xsl:when>
													<xsl:otherwise>
														<td class="Ungleich">
															<xsl:value-of select="$VergleichsElement/xdf:veroeffentlichungsdatum"/>
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
													<xsl:variable name="AnzahlUnterelemente" select="count($Element/xdf:struktur)"/>

													<td>
														<b>Unterelemente</b>
													</td>
													<xsl:choose>
														<xsl:when test="($AnzahlUnterelemente &gt; 0) or count($VergleichsElement/xdf:struktur)">
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
																		<xsl:variable name="Strukturelementart"><xsl:value-of select="./xdf:schemaelementart/code"/></xsl:variable>
																	
																		<xsl:for-each select="$Element/xdf:struktur">
																		
																			<xsl:variable name="VergleichsElement2"><xsl:value-of select="./xdf:enthaelt/*/xdf:identifikation/xdf:id"/></xsl:variable>
																			<xsl:variable name="VergleichsVersion2"><xsl:value-of select="./xdf:enthaelt/*/xdf:identifikation/xdf:version"/></xsl:variable>
																		
																			<xsl:variable name="UnterelementA" select="."/>
																			<xsl:variable name="UnterelementO" select="$VergleichsElement/xdf:struktur[xdf:enthaelt/*/xdf:identifikation/xdf:id = $UnterelementA/xdf:enthaelt/*/xdf:identifikation/xdf:id]"/>

																			<tr>
																				<td>
																					<xsl:element name="a">
																						<xsl:attribute name="href">#<xsl:value-of select="./xdf:enthaelt/*/xdf:identifikation/xdf:id"/><xsl:if test="./xdf:enthaelt/*/xdf:identifikation/xdf:version">V<xsl:value-of select="./xdf:enthaelt/*/xdf:identifikation/xdf:version"/></xsl:if></xsl:attribute>
																						<xsl:value-of select="./xdf:enthaelt/*/xdf:identifikation/xdf:id"/>
																					</xsl:element>
																					<xsl:choose>
																						<xsl:when test="$VergleichsVersion2 = ''">
																							<xsl:if test="count($Element/xdf:struktur/./xdf:enthaelt/*/xdf:identifikation[xdf:id=$VergleichsElement and not(xdf:version)]) &gt; 1">
																							</xsl:if>
																						</xsl:when>
																						<xsl:otherwise>
																							<xsl:if test="count($Element/xdf:struktur/./xdf:enthaelt/*/xdf:identifikation[xdf:id=$VergleichsElement and xdf:version=$VergleichsVersion2]) &gt; 1">
																							</xsl:if>
																						</xsl:otherwise>
																					</xsl:choose>

																				</td>
																				<td>
																					<xsl:value-of select="./xdf:enthaelt/*/xdf:identifikation/xdf:version"/>
																				</td>
																				<td>
																					<xsl:value-of select="./xdf:enthaelt/*/xdf:name"/>
																				</td>
																				<xsl:choose>
																					<xsl:when test="./xdf:anzahl='0:0'">
																						<td>
																							<xsl:value-of select="./xdf:anzahl"/>
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
																						</td>
																					</xsl:when>
																					<xsl:otherwise>
																						<td>
																							<xsl:value-of select="./xdf:bezug"/>
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
																							Nicht vorhanden ##
																						</td>
																					</xsl:when>
																					<xsl:otherwise>
																						<td>
																							<xsl:element name="a">
																								<xsl:attribute name="href">#X<xsl:value-of select="$UnterelementO/xdf:enthaelt/*/xdf:identifikation/xdf:id"/><xsl:if test="$UnterelementO/xdf:enthaelt/*/xdf:identifikation/xdf:version">V<xsl:value-of select="$UnterelementO/xdf:enthaelt/*/xdf:identifikation/xdf:version"/></xsl:if></xsl:attribute>
																								<xsl:value-of select="$UnterelementO/xdf:enthaelt/*/xdf:identifikation/xdf:id"/>
																							</xsl:element>
																						</td>
																						<xsl:choose>
																							<xsl:when test="(empty($UnterelementO/xdf:enthaelt/*/xdf:identifikation/xdf:version) and empty($UnterelementA/xdf:enthaelt/*/xdf:identifikation/xdf:version)) or ($UnterelementO/xdf:enthaelt/*/xdf:identifikation/xdf:version = $UnterelementA/xdf:enthaelt/*/xdf:identifikation/xdf:version)">
																								<td class="Gleich">
																									<xsl:value-of select="$UnterelementO/xdf:enthaelt/*/xdf:identifikation/xdf:version"/>
																								</td>
																							</xsl:when>
																							<xsl:otherwise>
																								<td class="Ungleich">
																									<xsl:value-of select="$UnterelementO/xdf:enthaelt/*/xdf:identifikation/xdf:version"/>
																								</td>
																							</xsl:otherwise>
																						</xsl:choose>
																						<xsl:choose>
																							<xsl:when test="(empty($UnterelementO/xdf:enthaelt/*/xdf:name) and empty($UnterelementA/xdf:enthaelt/*/xdf:name)) or ($UnterelementO/xdf:enthaelt/*/xdf:name = $UnterelementA/xdf:enthaelt/*/xdf:name)">
																								<td class="Gleich">
																									<xsl:value-of select="$UnterelementO/xdf:enthaelt/*/xdf:name"/><xsl:if test="($UnterelementO/xdf:enthaelt/*/xdf:identifikation/xdf:version != $UnterelementA/xdf:enthaelt/*/xdf:identifikation/xdf:version) or ($UnterelementO/xdf:enthaelt/*/xdf:name != $UnterelementA/xdf:enthaelt/*/xdf:name) or ($UnterelementO/xdf:anzahl != $UnterelementA/xdf:anzahl) or ($UnterelementO/xdf:bezug != $UnterelementA/xdf:bezug)"> ##</xsl:if>
																								</td>
																							</xsl:when>
																							<xsl:otherwise>
																								<td class="Ungleich">
																									<xsl:value-of select="$UnterelementO/xdf:enthaelt/*/xdf:name"/><xsl:if test="($UnterelementO/xdf:enthaelt/*/xdf:identifikation/xdf:version != $UnterelementA/xdf:enthaelt/*/xdf:identifikation/xdf:version) or ($UnterelementO/xdf:enthaelt/*/xdf:name != $UnterelementA/xdf:enthaelt/*/xdf:name) or ($UnterelementO/xdf:anzahl != $UnterelementA/xdf:anzahl) or ($UnterelementO/xdf:bezug != $UnterelementA/xdf:bezug)"> ##</xsl:if>
																								</td>
																							</xsl:otherwise>
																						</xsl:choose>
																						<xsl:choose>
																							<xsl:when test="(empty($UnterelementO/xdf:anzahl) and empty($UnterelementA/xdf:anzahl)) or ($UnterelementO/xdf:anzahl = $UnterelementA/xdf:anzahl)">
																								<td class="Gleich">
																									<xsl:value-of select="$UnterelementO/xdf:anzahl"/>
																								</td>
																							</xsl:when>
																							<xsl:otherwise>
																								<td class="Ungleich">
																									<xsl:value-of select="$UnterelementO/xdf:anzahl"/>
																								</td>
																							</xsl:otherwise>
																						</xsl:choose>
																						<xsl:choose>
																							<xsl:when test="(empty($UnterelementO/xdf:bezug) and empty($UnterelementA/xdf:bezug)) or ($UnterelementO/xdf:bezug = $UnterelementA/xdf:bezug)">
																								<td class="Gleich">
																									<xsl:value-of select="$UnterelementO/xdf:bezug"/>
																								</td>
																							</xsl:when>
																							<xsl:otherwise>
																								<td class="Ungleich">
																									<xsl:value-of select="$UnterelementO/xdf:bezug"/>
																								</td>
																							</xsl:otherwise>
																						</xsl:choose>
																					</xsl:otherwise>
																				</xsl:choose>
																			</tr>
																		</xsl:for-each>

																		<xsl:for-each select="$VergleichsElement/xdf:struktur">
																			<xsl:variable name="UnterelementO" select="."/>
																			<xsl:variable name="UnterelementA" select="$Element/xdf:struktur[xdf:enthaelt/*/xdf:identifikation/xdf:id = $UnterelementO/xdf:enthaelt/*/xdf:identifikation/xdf:id]"/>
																			<xsl:choose>
																				<xsl:when test="empty($UnterelementA)">
																					<tr>
																						<td colspan="2">
																						</td>
																						<td>Nicht vorhanden
																						</td>
																						<td colspan="2">
																						</td>
																						<td class="Ungleich">
																							<xsl:element name="a">
																								<xsl:attribute name="href">#X<xsl:value-of select="$UnterelementO/xdf:enthaelt/*/xdf:identifikation/xdf:id"/><xsl:if test="$UnterelementO/xdf:enthaelt/*/xdf:identifikation/xdf:version">V<xsl:value-of select="$UnterelementO/xdf:enthaelt/*/xdf:identifikation/xdf:version"/></xsl:if></xsl:attribute>
																								<xsl:value-of select="$UnterelementO/xdf:enthaelt/*/xdf:identifikation/xdf:id"/>
																							</xsl:element>
																						</td>
																						<td class="Ungleich">
																							<xsl:value-of select="$UnterelementO/xdf:enthaelt/*/xdf:identifikation/xdf:version"/>
																						</td>
																						<td class="Ungleich">
																							<xsl:value-of select="$UnterelementO/xdf:enthaelt/*/xdf:name"/> ##
																						</td>
																						<td class="Ungleich">
																							<xsl:value-of select="$UnterelementO/xdf:anzahl"/>
																						</td>
																						<td class="Ungleich">
																							<xsl:value-of select="$UnterelementO/xdf:bezug"/>
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
											<xsl:if test="count($Element/xdf:regel) or count($VergleichsElement/xdf:regel)">
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
																	<th width="22%">Definition</th>
																	<th width="5%">ID</th>
																	<th width="5%">Version</th>
																	<th width="18%">Name</th>
																	<th width="22%">Definition</th>
																</tr>
															</thead>
															<tbody>
																<xsl:for-each select="$Element/xdf:regel">

																	<xsl:variable name="UnterelementA" select="."/>
																	<xsl:variable name="UnterelementO" select="$VergleichsElement/xdf:regel[xdf:identifikation/xdf:id = $UnterelementA/xdf:identifikation/xdf:id]"/>

																	<tr>
																		<td>
																			<xsl:choose>
																				<xsl:when test="$RegelDetails = '1'">
																					<xsl:element name="a">
																						<xsl:attribute name="href">#<xsl:value-of select="./xdf:identifikation/xdf:id"/></xsl:attribute>
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
																			<xsl:value-of select="./xdf:definition"/>
																		</td>
																		<xsl:choose>
																			<xsl:when test="empty($VergleichsElement)">
																				<td colspan="4">
																				</td>
																			</xsl:when>
																			<xsl:when test="empty($UnterelementO)">
																				<td colspan="4" class="Ungleich">
																					Nicht vorhanden ##
																				</td>
																			</xsl:when>
																			<xsl:otherwise>
																				<td>
																					<xsl:choose>
																						<xsl:when test="$RegelDetails = '1'">
																							<xsl:element name="a">
																								<xsl:attribute name="href">#X<xsl:value-of select="$UnterelementO/xdf:identifikation/xdf:id"/></xsl:attribute>
																								<xsl:value-of select="$UnterelementO/xdf:identifikation/xdf:id"/>
																							</xsl:element>
																						</xsl:when>
																						<xsl:otherwise>
																							<xsl:value-of select="$UnterelementO/xdf:identifikation/xdf:id"/>
																						</xsl:otherwise>
																					</xsl:choose>
																				</td>
																				<xsl:choose>
																					<xsl:when test="(empty($UnterelementO/xdf:identifikation/xdf:version) and empty($UnterelementA/xdf:identifikation/xdf:version)) or ($UnterelementO/xdf:identifikation/xdf:version = $UnterelementA/xdf:identifikation/xdf:version)">
																						<td class="Gleich">
																							<xsl:value-of select="$UnterelementO/xdf:identifikation/xdf:version"/>
																						</td>
																					</xsl:when>
																					<xsl:otherwise>
																						<td class="Ungleich">
																							<xsl:value-of select="$UnterelementO/xdf:identifikation/xdf:version"/>
																						</td>
																					</xsl:otherwise>
																				</xsl:choose>
																				<xsl:choose>
																					<xsl:when test="(empty($UnterelementO/xdf:name) and empty($UnterelementA/xdf:name)) or ($UnterelementO/xdf:name = $UnterelementA/xdf:name)">
																						<td class="Gleich">
																							<xsl:value-of select="$UnterelementO/xdf:name"/><xsl:if test="($UnterelementO/xdf:identifikation/xdf:version != $UnterelementA/xdf:identifikation/xdf:version) or ($UnterelementO/xdf:name != $UnterelementA/xdf:name) or ($UnterelementO/xdf:definition != $UnterelementA/xdf:definition)"> ##</xsl:if>
																						</td>
																					</xsl:when>
																					<xsl:otherwise>
																						<td class="Ungleich">
																							<xsl:value-of select="$UnterelementO/xdf:name"/><xsl:if test="($UnterelementO/xdf:identifikation/xdf:version != $UnterelementA/xdf:identifikation/xdf:version) or ($UnterelementO/xdf:name != $UnterelementA/xdf:name) or ($UnterelementO/xdf:definition != $UnterelementA/xdf:definition)"> ##</xsl:if>
																						</td>
																					</xsl:otherwise>
																				</xsl:choose>
																				<xsl:choose>
																					<xsl:when test="(empty($UnterelementO/xdf:definition) and empty($UnterelementA/xdf:definition)) or ($UnterelementO/xdf:definition = $UnterelementA/xdf:definition)">
																						<td class="Gleich">
																							<xsl:value-of select="$UnterelementO/xdf:definition"/>
																						</td>
																					</xsl:when>
																					<xsl:otherwise>
																						<td class="Ungleich">
																							<xsl:value-of select="$UnterelementO/xdf:definition"/>
																						</td>
																					</xsl:otherwise>
																				</xsl:choose>
																			</xsl:otherwise>
																		</xsl:choose>
																	</tr>
																</xsl:for-each>
																<xsl:for-each select="$VergleichsElement/xdf:regel">
																	<xsl:variable name="UnterelementO" select="."/>
																	<xsl:variable name="UnterelementA" select="$Element/xdf:regel[xdf:identifikation/xdf:id = $UnterelementO/xdf:identifikation/xdf:id]"/>
																	<xsl:choose>
																		<xsl:when test="empty($UnterelementA)">
																			<tr>
																				<td colspan="4"/>
																				<td class="Ungleich">
																					<xsl:choose>
																						<xsl:when test="$RegelDetails = '1'">
																							<xsl:element name="a">
																								<xsl:attribute name="href">#X<xsl:value-of select="$UnterelementO/xdf:identifikation/xdf:id"/></xsl:attribute>
																								<xsl:value-of select="$UnterelementO/xdf:identifikation/xdf:id"/>
																							</xsl:element>
																						</xsl:when>
																						<xsl:otherwise>
																							<xsl:value-of select="$UnterelementO/xdf:identifikation/xdf:id"/>
																						</xsl:otherwise>
																					</xsl:choose>
																				</td>
																				<td class="Ungleich">
																					<xsl:value-of select="$UnterelementO/xdf:identifikation/xdf:version"/>
																				</td>
																				<td class="Ungleich">
																					<xsl:value-of select="$UnterelementO/xdf:name"/> ##
																				</td>
																				<td class="Ungleich">
																					<xsl:value-of select="$UnterelementO/xdf:definition"/>
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
												<xsl:variable name="FeldgruppenID" select="$Element/xdf:identifikation/xdf:id"/>
												<xsl:variable name="FeldgruppenVersion" select="$Element/xdf:identifikation/xdf:version"/>
												
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
															<xsl:when test="not($Element/xdf:identifikation/xdf:version)">
															
																	<xsl:for-each-group select="//xdf:datenfeldgruppe[xdf:struktur/xdf:enthaelt/xdf:datenfeldgruppe/xdf:identifikation/xdf:id = $FeldgruppenID]" group-by="xdf:identifikation/xdf:id">
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
		
																	<xsl:for-each-group select="//xdf:stammdatenschema[xdf:struktur/xdf:enthaelt/xdf:datenfeldgruppe/xdf:identifikation/xdf:id = $FeldgruppenID]" group-by="xdf:identifikation/xdf:id">
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
																	<xsl:for-each-group select="//xdf:datenfeldgruppe[xdf:struktur/xdf:enthaelt/xdf:datenfeldgruppe/xdf:identifikation/xdf:id = $FeldgruppenID and xdf:struktur/xdf:enthaelt/xdf:datenfeldgruppe/xdf:identifikation/xdf:version = $FeldgruppenVersion]" group-by="xdf:identifikation/xdf:id">
																		<xsl:sort select="./xdf:identifikation/xdf:id"/>
																		
																		<xsl:for-each-group select="fn:current-group()" group-by="string(xdf:identifikation/xdf:version)">
																			<xsl:sort select="./xdf:identifikation/xdf:version"/>
																		
																			<xsl:call-template name="minielementcore">
																				<xsl:with-param name="Element" select="."/>
																			</xsl:call-template>
																		
																		</xsl:for-each-group>
																	</xsl:for-each-group>
		
																	<xsl:for-each-group select="//xdf:stammdatenschema[xdf:struktur/xdf:enthaelt/xdf:datenfeldgruppe/xdf:identifikation/xdf:id = $FeldgruppenID and xdf:struktur/xdf:enthaelt/xdf:datenfeldgruppe/xdf:identifikation/xdf:version = $FeldgruppenVersion]" group-by="./xdf:identifikation/xdf:id">
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

	<xsl:template name="elementdetailszustammdatenschemavergleich">
		<xsl:param name="Element"/>
		<xsl:param name="VersionsAnzahl"/>

		
		<xsl:if test="$DebugMode = '2' or $DebugMode = '3' or $DebugMode = '4'">
			<xsl:message>
				++++++++ elementdetailszustammdatenschema ++++++++
			</xsl:message>
		</xsl:if>
		<xsl:if test="$DebugMode = '3' or $DebugMode = '4'">
			<xsl:message>
				-------- <xsl:value-of select="$Element/xdf:identifikation/xdf:id"/><xsl:if test="$Element/xdf:identifikation/xdf:version">V<xsl:value-of select="$Element/xdf:identifikation/xdf:version"/></xsl:if> --------
			</xsl:message>
		</xsl:if>

									<xsl:choose>
										<xsl:when test="$Element/name() = 'xdf:datenfeld'">
											<tr>
												<td>
													<xsl:element name="a">
														<xsl:attribute name="name">X<xsl:value-of select="$Element/xdf:identifikation/xdf:id"/><xsl:if test="$Element/xdf:identifikation/xdf:version">V<xsl:value-of select="$Element/xdf:identifikation/xdf:version"/></xsl:if></xsl:attribute>
													</xsl:element>
													ID ##
												</td>
												<td>Nicht vorhanden</td>
												<td class="ElementID Ungleich GeloeschtBaukasten">
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
												<td></td>
												<td>
													<xsl:value-of select="$Element/xdf:identifikation/xdf:version"/>
												</td>
											</tr>
											<tr>
												<td>Name</td>
												<td></td>
												<xsl:choose>
													<xsl:when test="empty($Element/xdf:name/text())">
														<td class="ElementName">
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
												<td></td>
												<td>
													<xsl:value-of select="$Element/xdf:definition"/>
												</td>
											</tr>
											<tr>
												<td>Strukturelementart</td>
												<td></td>
												<td>
													<xsl:apply-templates select="$Element/xdf:schemaelementart"/>
												</td>
											</tr>
											<tr>
												<td>Bezug zu Rechtsnorm oder Standardisierungsvorhaben</td>
												<td></td>
												<xsl:choose>
													<xsl:when test="$Element/xdf:schemaelementart/code/text() = 'RNG' and empty($Element/xdf:bezug/text())">
														<td>
														</td>
													</xsl:when>
													<xsl:when test="$Element/xdf:schemaelementart/code/text() = 'HAR' and empty($Element/xdf:bezug/text())">
														<td>
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
												<td></td>
												<td>
													<xsl:apply-templates select="$Element/xdf:feldart"/>													
												</td>
											</tr>
											<tr>
												<td>Datentyp</td>
												<td></td>
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
																</td>
															</xsl:when>
															<xsl:otherwise>
																<td>
																	<xsl:apply-templates select="$Element/xdf:datentyp"/>
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
												<xsl:variable name="minLengthA"><xsl:if test="substring-before(substring-after($Element/xdf:praezisierung,'minLength&quot;:&quot;'),'&quot;') != ''"><xsl:value-of select="substring-before(substring-after($Element/xdf:praezisierung,'minLength&quot;:&quot;'),'&quot;')"/></xsl:if></xsl:variable>
												<xsl:variable name="maxLengthA"><xsl:if test="substring-before(substring-after($Element/xdf:praezisierung,'maxLength&quot;:&quot;'),'&quot;') != ''"><xsl:value-of select="substring-before(substring-after($Element/xdf:praezisierung,'maxLength&quot;:&quot;'),'&quot;')"/></xsl:if></xsl:variable>
												<xsl:variable name="LengthTextA">
													<xsl:if test="$minLengthA != ''">
														von <xsl:value-of select="$minLengthA"/> 
													</xsl:if>
													<xsl:if test="$maxLengthA != ''">
														bis <xsl:value-of select="$maxLengthA"/>
													</xsl:if>
												</xsl:variable>
											
												<td>Feldlänge</td>
												<td></td>
												<xsl:choose>
													<xsl:when test="$Element/xdf:praezisierung/text() != ''">
													
														<xsl:choose>
															<xsl:when test="$Element/xdf:datentyp/code/text() = 'text'">
																<xsl:choose>
																	<xsl:when test="$Element/xdf:feldart/code/text() = 'select'">
																		<xsl:choose>
																			<xsl:when test="$minLengthA != '' or $maxLengthA != ''">
																				<td>
																					<xsl:value-of select="$LengthTextA"/>
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
																			<xsl:when test="$minLengthA != '' and $maxLengthA != ''">
																				<td>
																					<xsl:value-of select="$LengthTextA"/>
																				</td>
																			</xsl:when>
																			<xsl:otherwise>
																				<td>
																					<xsl:value-of select="$LengthTextA"/>
																				</td>
																			</xsl:otherwise>
																		</xsl:choose>
																	
																	</xsl:otherwise>
																</xsl:choose>
															</xsl:when>
															<xsl:when test="$minLengthA != '' or $maxLengthA != ''">
																<td>
																	<xsl:value-of select="$LengthTextA"/>
																</td>
															</xsl:when>
															<xsl:otherwise>
																<td></td>
															</xsl:otherwise>
														</xsl:choose>

													</xsl:when>
													<xsl:otherwise>
														<xsl:choose>
															<xsl:when test="$Element/xdf:datentyp/code/text() = 'text' and $Element/xdf:feldart/code/text() != 'select'">
																<td>
																</td>
															</xsl:when>
															<xsl:otherwise>
																<td></td>
															</xsl:otherwise>
														</xsl:choose>
													</xsl:otherwise>
												</xsl:choose>
											</tr>
											<tr>
												<xsl:variable name="minValueA"><xsl:if test="substring-before(substring-after($Element/xdf:praezisierung,'minValue&quot;:&quot;'),'&quot;') != ''"><xsl:value-of select="substring-before(substring-after($Element/xdf:praezisierung,'minValue&quot;:&quot;'),'&quot;')"/></xsl:if></xsl:variable>
												<xsl:variable name="maxValueA"><xsl:if test="substring-before(substring-after($Element/xdf:praezisierung,'maxValue&quot;:&quot;'),'&quot;') != ''"><xsl:value-of select="substring-before(substring-after($Element/xdf:praezisierung,'maxValue&quot;:&quot;'),'&quot;')"/></xsl:if></xsl:variable>
												<xsl:variable name="ValueTextA">
													<xsl:if test="$minValueA != ''">
														von <xsl:value-of select="$minValueA"/> 
													</xsl:if>
													<xsl:if test="$maxValueA != ''">
														bis <xsl:value-of select="$maxValueA"/>
													</xsl:if>
												</xsl:variable>
											
												<td>Wertebereich</td>
												<td></td>
												<xsl:choose>
													<xsl:when test="$Element/xdf:praezisierung/text() != ''">

														<xsl:choose>
															<xsl:when test="$Element/xdf:datentyp/code/text() = 'num' or $Element/xdf:datentyp/code/text() = 'num_int' or $Element/xdf:datentyp/code/text() = 'num_currency'">
																<td>
																	<xsl:value-of select="$ValueTextA"/> 
																</td>
															</xsl:when>
															<xsl:otherwise>
																<xsl:choose>
																	<xsl:when test="$minValueA != '' or $maxValueA != ''">
																		<td>
																			<xsl:value-of select="$ValueTextA"/> 
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
																</td>
															</xsl:when>
															<xsl:otherwise>
																<td></td>
															</xsl:otherwise>
														</xsl:choose>
													</xsl:otherwise>
												</xsl:choose>
											</tr>
											<tr>
												<xsl:variable name="PatternTextA">
													<xsl:if test="$Element/xdf:praezisierung/text() != ''">
														<xsl:if test="substring-before(substring-after($Element/xdf:praezisierung,'pattern&quot;:&quot;'),'&quot;') != ''">
															<xsl:value-of select="substring-before(substring-after($Element/xdf:praezisierung,'pattern&quot;:&quot;'),'&quot;')"/>
														</xsl:if>
													</xsl:if>
												</xsl:variable>

												<td>Pattern</td>
												<td></td>
												<td>
													<xsl:value-of select="$PatternTextA"/>
												</td>
											</tr>
											<tr>
												<td>Zugeordnete Codeliste</td>
												<td></td>
												<xsl:choose>
													<xsl:when test="$Element/xdf:feldart/code/text() != 'select' and $Element/xdf:codelisteReferenz">
														<td>
															<xsl:element name="a">
																<xsl:attribute name="href">#X<xsl:value-of select="$Element/xdf:codelisteReferenz/xdf:identifikation/xdf:id"/></xsl:attribute>
																<xsl:value-of select="$Element/xdf:codelisteReferenz/xdf:identifikation/xdf:id"/>
															</xsl:element>
															<xsl:if test="($ToolAufruf = '1') and fn:not(empty($Element/xdf:codelisteReferenz/xdf:identifikation/xdf:id))">
																&#160;&#160;
																<xsl:element name="a">
																	<xsl:attribute name="href"><xsl:value-of select="$ToolPfadPrefix"/><xsl:value-of select="$Element/xdf:codelisteReferenz/xdf:identifikation/xdf:id"/><xsl:value-of select="$ToolPfadPostfix"/></xsl:attribute>
																	<xsl:attribute name="target">FIMTool</xsl:attribute>
																	<xsl:attribute name="title">Springe in den Datenfeldeditor (man muss vorher angemeldet sein).</xsl:attribute>
																	&#8658;
																</xsl:element>
															</xsl:if>
														</td>
													</xsl:when>
													<xsl:when test="$Element/xdf:feldart/code/text() = 'select' and not($Element/xdf:codelisteReferenz)">
														<td>
														</td>
													</xsl:when>
													<xsl:otherwise>
														<td>
															<xsl:element name="a">
																<xsl:attribute name="href">#X<xsl:value-of select="$Element/xdf:codelisteReferenz/xdf:identifikation/xdf:id"/></xsl:attribute>
																<xsl:value-of select="$Element/xdf:codelisteReferenz/xdf:identifikation/xdf:id"/>
															</xsl:element>
															<xsl:if test="($ToolAufruf = '1') and fn:not(empty($Element/xdf:codelisteReferenz/xdf:identifikation/xdf:id))">
																&#160;&#160;
																<xsl:element name="a">
																	<xsl:attribute name="href"><xsl:value-of select="$ToolPfadPrefix"/><xsl:value-of select="$Element/xdf:codelisteReferenz/xdf:identifikation/xdf:id"/><xsl:value-of select="$ToolPfadPostfix"/></xsl:attribute>
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
												<xsl:variable name="HinweisTextA">
													<xsl:if test="$Element/xdf:praezisierung/text() != ''">
														<xsl:choose>
															<xsl:when test="substring($Element/xdf:praezisierung/text(),1,1) = '{'">
																<xsl:if test="substring-before(substring-after($Element/xdf:praezisierung,'note&quot;:&quot;'),'&quot;') != ''">
																	<xsl:value-of select="substring-before(substring-after($Element/xdf:praezisierung,'note&quot;:&quot;'),'&quot;')"/>
																</xsl:if>
															</xsl:when>
															<xsl:otherwise>
																<xsl:value-of select="$Element/xdf:praezisierung"/>
															</xsl:otherwise>
														</xsl:choose>
													</xsl:if>
												</xsl:variable>
												
												<td>Hinweis</td>
												<td></td>
												<xsl:if test="$Element/xdf:praezisierung/text() != ''">
													<xsl:choose>
														<xsl:when test="substring($Element/xdf:praezisierung/text(),1,1) = '{'">
															<td>
																<xsl:value-of select="$HinweisTextA"/>
															</td>
														</xsl:when>
														<xsl:otherwise>
															<td>
																<xsl:value-of select="$HinweisTextA"/>
															</td>
														</xsl:otherwise>
													</xsl:choose>
												
												</xsl:if>
											</tr>
											<tr>
												<td>Inhalt</td>
												<td></td>
												<xsl:choose>
													<xsl:when test="$Element/xdf:feldart/code/text() = 'label' and empty($Element/xdf:inhalt/text())">
														<td>
														</td>
													</xsl:when>
													<xsl:otherwise>
														<td>
															<xsl:value-of select="$Element/xdf:inhalt"/>
														</td>
													</xsl:otherwise>
												</xsl:choose>
											</tr>
											<tr>
												<td>Beschreibung</td>
												<td></td>
												<td>
													<xsl:value-of select="$Element/xdf:beschreibung"/>
												</td>
											</tr>
											<tr>
												<td>Bezeichnung Eingabe</td>
												<td></td>
												<xsl:choose>
													<xsl:when test="empty($Element/xdf:bezeichnungEingabe/text())">
														<td>
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
												<td></td>
												<xsl:choose>
													<xsl:when test="empty($Element/xdf:bezeichnungAusgabe/text())">
														<td>
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
												<td></td>
												<td>
													<xsl:value-of select="$Element/xdf:hilfetextEingabe"/>
												</td>
											</tr>
											<tr>
												<td>Hilfetext Ausgabe</td>
												<td></td>
												<td>
													<xsl:value-of select="$Element/xdf:hilfetextAusgabe"/>
												</td>
											</tr>
											<tr>
												<td>Fachlicher Ersteller</td>
												<td></td>
												<td>
													<xsl:value-of select="$Element/xdf:fachlicherErsteller"/>
												</td>
											</tr>
											<tr>
												<td>Status</td>
												<td></td>
												<td>
													<xsl:apply-templates select="$Element/xdf:status"/>
												</td>
											</tr>
											<tr>
												<td>Gültig ab</td>
												<td></td>
												<td>
													<xsl:value-of select="$Element/xdf:gueltigAb"/>
												</td>
											</tr>
											<tr>
												<td>Gültig bis</td>
												<td></td>
												<td>
													<xsl:value-of select="$Element/xdf:gueltigBis"/>
												</td>
											</tr>
											<tr>
												<td>Freigabedatum</td>
												<td></td>
												<td>
													<xsl:value-of select="$Element/xdf:freigabedatum"/>
												</td>
											</tr>
											<tr>
												<td>Veröffentlichungsdatum</td>
												<td></td>
												<td>
													<xsl:value-of select="$Element/xdf:veroeffentlichungsdatum"/>
												</td>
											</tr>
											<xsl:if test="count($Element/xdf:regel)">
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
																	<th width="22%">Definition</th>
																</tr>
															</thead>
															<tbody>
																<xsl:for-each select="$Element/xdf:regel">

																	<tr>
																		<td colspan="4"></td>
																		<td>
																			<xsl:choose>
																				<xsl:when test="$RegelDetails = '1'">
																					<xsl:element name="a">
																						<xsl:attribute name="href">#X<xsl:value-of select="./xdf:identifikation/xdf:id"/></xsl:attribute>
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
																			<xsl:value-of select="./xdf:definition"/>
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

												<xsl:variable name="FeldID" select="$Element/xdf:identifikation/xdf:id"/>
												<xsl:variable name="FeldVersion" select="$Element/xdf:identifikation/xdf:version"/>
												
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
																<xsl:when test="not($Element/xdf:identifikation/xdf:version)">
																
																		<xsl:for-each-group select="//xdf:datenfeldgruppe[xdf:struktur/xdf:enthaelt/xdf:datenfeld/xdf:identifikation/xdf:id = $FeldID]" group-by="xdf:identifikation/xdf:id">
																			<xsl:sort select="./xdf:identifikation/xdf:id"/>
																			
																			<xsl:for-each-group select="fn:current-group()" group-by="string(xdf:identifikation/xdf:version)">
																				<xsl:sort select="./xdf:identifikation/xdf:version"/>
																			
																			<xsl:if test="current-grouping-key()=''">
																			
																				<xsl:call-template name="minielementcorevergleich">
																					<xsl:with-param name="Element" select="."/>
																				</xsl:call-template>
																			</xsl:if>
																			
																			</xsl:for-each-group>

																		</xsl:for-each-group>
			
																		<xsl:for-each-group select="//xdf:stammdatenschema[xdf:struktur/xdf:enthaelt/xdf:datenfeld/xdf:identifikation/xdf:id = $FeldID]" group-by="xdf:identifikation/xdf:id">
																			<xsl:sort select="./xdf:identifikation/xdf:id"/>
																			
																			<xsl:for-each-group select="fn:current-group()" group-by="string(xdf:identifikation/xdf:version)">
																				<xsl:sort select="./xdf:identifikation/xdf:version"/>
																			
																			<xsl:if test="current-grouping-key()=''">
																			
																				<xsl:call-template name="minielementcorevergleich">
																					<xsl:with-param name="Element" select="."/>
																				</xsl:call-template>
																			</xsl:if>
																			
																			</xsl:for-each-group>

																		</xsl:for-each-group>
			
																</xsl:when>
																<xsl:otherwise>
																		<xsl:for-each-group select="//xdf:datenfeldgruppe[xdf:struktur/xdf:enthaelt/xdf:datenfeld/xdf:identifikation/xdf:id = $FeldID and xdf:struktur/xdf:enthaelt/xdf:datenfeld/xdf:identifikation/xdf:version = $FeldVersion]" group-by="xdf:identifikation/xdf:id">
																			<xsl:sort select="./xdf:identifikation/xdf:id"/>
																			
																			<xsl:for-each-group select="fn:current-group()" group-by="string(xdf:identifikation/xdf:version)">
																				<xsl:sort select="./xdf:identifikation/xdf:version"/>
																			
																				<xsl:call-template name="minielementcorevergleich">
																					<xsl:with-param name="Element" select="."/>
																				</xsl:call-template>
																			
																			</xsl:for-each-group>
																		</xsl:for-each-group>
			
																		<xsl:for-each-group select="//xdf:stammdatenschema[xdf:struktur/xdf:enthaelt/xdf:datenfeld/xdf:identifikation/xdf:id = $FeldID and xdf:struktur/xdf:enthaelt/xdf:datenfeld/xdf:identifikation/xdf:version = $FeldVersion]" group-by="./xdf:identifikation/xdf:id">
																			<xsl:sort select="./xdf:identifikation/xdf:id"/>
																			
																			<xsl:for-each-group select="fn:current-group()" group-by="string(xdf:identifikation/xdf:version)">
																				<xsl:sort select="./xdf:identifikation/xdf:version"/>
																			
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
										<xsl:when test="$Element/name() = 'xdf:datenfeldgruppe'">
											<tr>
												<td>
													<xsl:element name="a">
														<xsl:attribute name="name">X<xsl:value-of select="$Element/xdf:identifikation/xdf:id"/><xsl:if test="$Element/xdf:identifikation/xdf:version">V<xsl:value-of select="$Element/xdf:identifikation/xdf:version"/></xsl:if></xsl:attribute>
													</xsl:element>
													ID ##
												</td>
												<td>Nicht Vorhanden</td>
												<td class="ElementID Ungleich GeloeschtBaukasten">
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
												<td></td>
												<xsl:choose>
													<xsl:when test="$VersionsAnzahl &gt; 1">
														<td>
															<xsl:value-of select="$Element/xdf:identifikation/xdf:version"/>
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
												<td></td>
												<xsl:choose>
													<xsl:when test="empty($Element/xdf:name/text())">
													<td class="ElementName">
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
												<td></td>
												<td>
													<xsl:value-of select="$Element/xdf:definition"/>
												</td>
											</tr>
											<tr>
												<td>Strukturelementart</td>
												<td></td>
												<td>
													<xsl:apply-templates select="$Element/xdf:schemaelementart"/>
												</td>
											</tr>
											<tr>
												<td>Bezug zu Rechtsnorm oder Standardisierungsvorhaben</td>
												<td></td>
												<xsl:choose>
													<xsl:when test="$Element/xdf:schemaelementart/code/text() = 'RNG' and empty($Element/xdf:bezug/text())">
														<td>
														</td>
													</xsl:when>
													<xsl:when test="$Element/xdf:schemaelementart/code/text() = 'HAR' and empty($Element/xdf:bezug/text())">
														<td>
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
												<td></td>
												<td>
													<xsl:value-of select="$Element/xdf:beschreibung"/>
												</td>
											</tr>
											<tr>
												<td>Bezeichnung Eingabe</td>
												<td></td>
												<xsl:choose>
													<xsl:when test="empty($Element/xdf:bezeichnungEingabe/text())">
														<td>
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
												<td></td>
												<xsl:choose>
													<xsl:when test="empty($Element/xdf:bezeichnungAusgabe/text())">
														<td>
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
												<td></td>
												<td>
													<xsl:value-of select="$Element/xdf:hilfetextEingabe"/>
												</td>
											</tr>
											<tr>
												<td>Hilfetext Ausgabe></td>
												<td></td>
												<td>
													<xsl:value-of select="$Element/xdf:hilfetextAusgabe"/>
												</td>
											</tr>
											<tr>
												<td>Fachlicher Ersteller</td>
												<td></td>
												<td>
													<xsl:value-of select="$Element/xdf:fachlicherErsteller"/>
												</td>
											</tr>
											<tr>
												<td>Status</td>
												<td></td>
												<td>
													<xsl:apply-templates select="$Element/xdf:status"/>
												</td>
											</tr>
											<tr>
												<td>Gültig ab</td>
												<td></td>
												<td>
													<xsl:value-of select="$Element/xdf:gueltigAb"/>
												</td>
											</tr>
											<tr>
												<td>Gültig bis</td>
												<td></td>
												<td>
													<xsl:value-of select="$Element/xdf:gueltigBis"/>
												</td>
											</tr>
											<tr>
												<td>Freigabedatum</td>
												<td></td>
												<td>
													<xsl:value-of select="$Element/xdf:freigabedatum"/>
												</td>
											</tr>
											<tr>
												<td>Veröffentlichungsdatum</td>
												<td></td>
												<td>
													<xsl:value-of select="$Element/xdf:veroeffentlichungsdatum"/>
												</td>
											</tr>
											<tr>
												<xsl:variable name="AnzahlUnterelemente" select="count($Element/xdf:struktur)"/>

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
																	<xsl:variable name="Strukturelementart"><xsl:value-of select="./xdf:schemaelementart/code"/></xsl:variable>
																
																	<xsl:for-each select="$Element/xdf:struktur">
																	
																		<tr>
																			<td colspan="2">
																			</td>
																			<td>Nicht vorhanden
																			</td>
																			<td colspan="2">
																			</td>
																			<td>
																				<xsl:element name="a">
																					<xsl:attribute name="href">#X<xsl:value-of select="./xdf:enthaelt/*/xdf:identifikation/xdf:id"/><xsl:if test="./xdf:enthaelt/*/xdf:identifikation/xdf:version">V<xsl:value-of select="./xdf:enthaelt/*/xdf:identifikation/xdf:version"/></xsl:if></xsl:attribute>
																					<xsl:value-of select="./xdf:enthaelt/*/xdf:identifikation/xdf:id"/>
																				</xsl:element>
																			</td>
																			<td>
																				<xsl:value-of select="./xdf:enthaelt/*/xdf:identifikation/xdf:version"/>
																			</td>
																			<td>
																				<xsl:value-of select="./xdf:enthaelt/*/xdf:name"/>
																			</td>
																			<xsl:choose>
																				<xsl:when test="./xdf:anzahl='0:0'">
																					<td>
																						<xsl:value-of select="./xdf:anzahl"/>
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
														<td colspan="2">
														</td>
													</xsl:otherwise>
												</xsl:choose>
											</tr>
											<xsl:if test="count($Element/xdf:regel)">
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
																	<th width="22%">Definition</th>
																</tr>
															</thead>
															<tbody>
																<xsl:for-each select="$Element/xdf:regel">

																	<tr>
																		<td colspan="4"></td>
																		<td>
																			<xsl:choose>
																				<xsl:when test="$RegelDetails = '1'">
																					<xsl:element name="a">
																						<xsl:attribute name="href">#X<xsl:value-of select="./xdf:identifikation/xdf:id"/></xsl:attribute>
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
																			<xsl:value-of select="./xdf:definition"/>
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
												<xsl:variable name="FeldgruppenID" select="$Element/xdf:identifikation/xdf:id"/>
												<xsl:variable name="FeldgruppenVersion" select="$Element/xdf:identifikation/xdf:version"/>
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
															<xsl:when test="not($Element/xdf:identifikation/xdf:version)">
															
																	<xsl:for-each-group select="$VergleichsDaten//xdf:datenfeldgruppe[xdf:struktur/xdf:enthaelt/xdf:datenfeldgruppe/xdf:identifikation/xdf:id = $FeldgruppenID]" group-by="xdf:identifikation/xdf:id">
																		<xsl:sort select="./xdf:identifikation/xdf:id"/>
																		
																		<xsl:for-each-group select="fn:current-group()" group-by="string(xdf:identifikation/xdf:version)">
																			<xsl:sort select="./xdf:identifikation/xdf:version"/>
																		
																		<xsl:if test="current-grouping-key()=''">
																		
																			<xsl:call-template name="minielementcorevergleich">
																				<xsl:with-param name="Element" select="."/>
																			</xsl:call-template>
																		</xsl:if>
																		
																		</xsl:for-each-group>

																	</xsl:for-each-group>
		
																	<xsl:for-each-group select="$VergleichsDaten//xdf:stammdatenschema[xdf:struktur/xdf:enthaelt/xdf:datenfeldgruppe/xdf:identifikation/xdf:id = $FeldgruppenID]" group-by="xdf:identifikation/xdf:id">
																		<xsl:sort select="./xdf:identifikation/xdf:id"/>
																		
																		<xsl:for-each-group select="fn:current-group()" group-by="string(xdf:identifikation/xdf:version)">
																			<xsl:sort select="./xdf:identifikation/xdf:version"/>
																		
																		<xsl:if test="current-grouping-key()=''">
																		
																			<xsl:call-template name="minielementcorevergleich">
																				<xsl:with-param name="Element" select="."/>
																			</xsl:call-template>
																		</xsl:if>
																		
																		</xsl:for-each-group>

																	</xsl:for-each-group>
		
															</xsl:when>
															<xsl:otherwise>
																	<xsl:for-each-group select="$VergleichsDaten//xdf:datenfeldgruppe[xdf:struktur/xdf:enthaelt/xdf:datenfeldgruppe/xdf:identifikation/xdf:id = $FeldgruppenID and xdf:struktur/xdf:enthaelt/xdf:datenfeldgruppe/xdf:identifikation/xdf:version = $FeldgruppenVersion]" group-by="xdf:identifikation/xdf:id">
																		<xsl:sort select="./xdf:identifikation/xdf:id"/>
																		
																		<xsl:for-each-group select="fn:current-group()" group-by="string(xdf:identifikation/xdf:version)">
																			<xsl:sort select="./xdf:identifikation/xdf:version"/>
																		
																			<xsl:call-template name="minielementcorevergleich">
																				<xsl:with-param name="Element" select="."/>
																			</xsl:call-template>
																		
																		</xsl:for-each-group>
																	</xsl:for-each-group>
		
																	<xsl:for-each-group select="$VergleichsDaten//xdf:stammdatenschema[xdf:struktur/xdf:enthaelt/xdf:datenfeldgruppe/xdf:identifikation/xdf:id = $FeldgruppenID and xdf:struktur/xdf:enthaelt/xdf:datenfeldgruppe/xdf:identifikation/xdf:version = $FeldgruppenVersion]" group-by="./xdf:identifikation/xdf:id">
																		<xsl:sort select="./xdf:identifikation/xdf:id"/>
																		
																		<xsl:for-each-group select="fn:current-group()" group-by="string(xdf:identifikation/xdf:version)">
																			<xsl:sort select="./xdf:identifikation/xdf:version"/>
																		
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

	<xsl:template name="listeregeldetailszustammdatenschema">
	
		<xsl:if test="$DebugMode = '1' or $DebugMode = '2' or $DebugMode = '3' or $DebugMode = '4'">
			<xsl:message>
				++++ listeregeldetailszustammdatenschema ++++
			</xsl:message>
		</xsl:if>

					<h2><br/></h2>
					<h2>
						<a name="RegelDetails"/>Details zu den Regeln des Stammdatenschemas <xsl:value-of select="/*/xdf:stammdatenschema/xdf:identifikation/xdf:id"/><xsl:if test="/*/xdf:stammdatenschema/xdf:identifikation/xdf:version"> Version <xsl:value-of select="/*/xdf:stammdatenschema/xdf:identifikation/xdf:version"/></xsl:if>
					</h2>
					<table style="page-break-after:always">
						<thead>
							<tr>
							<tr>
								<th width="10%">Metadatum</th>
								<th width="45%">Inhalt Stammdatenschema <xsl:value-of select="$NameSDSA"/></th>
								<th width="45%">Inhalt Stammdatenschema <xsl:value-of select="$NameSDSO"/></th>
							</tr>
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

		<xsl:variable name="Temp" select="$VergleichsDaten//*[xdf:identifikation/xdf:id = $Element/xdf:identifikation/xdf:id]"/>
		<xsl:variable name="VergleichsElement" select="$Temp[1]"/>
		
		<xsl:if test="$DebugMode = '3' or $DebugMode = '4'">
			<xsl:message>
				-------- <xsl:value-of select="$Element/xdf:identifikation/xdf:id"/><xsl:if test="$Element/xdf:identifikation/xdf:version">V<xsl:value-of select="$Element/xdf:identifikation/xdf:version"/></xsl:if> --------
			</xsl:message>
		</xsl:if>

								<tr>
									<td>
										<xsl:element name="a">
											<xsl:attribute name="name"><xsl:value-of select="$Element/xdf:identifikation/xdf:id"/></xsl:attribute>
										</xsl:element>
										ID <xsl:if test="empty($VergleichsElement)">##</xsl:if>
									</td>
									<td class="RegelID">
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
									<xsl:choose>
										<xsl:when test="empty($VergleichsElement)">
											<td class="Ungleich">Nicht vorhanden</td>
										</xsl:when>
										<xsl:otherwise>
											<td class="RegelID">
												<xsl:element name="a">
													<xsl:attribute name="name">X<xsl:value-of select="$VergleichsElement/xdf:identifikation/xdf:id"/></xsl:attribute>
												</xsl:element>
												<xsl:value-of select="$VergleichsElement/xdf:identifikation/xdf:id"/>
												<xsl:if test="$ToolAufruf = '1'">
													&#160;&#160;
													<xsl:element name="a">
														<xsl:attribute name="href"><xsl:value-of select="$ToolPfadPrefix"/><xsl:value-of select="$VergleichsElement/xdf:identifikation/xdf:id"/><xsl:if test="$VergleichsElement/xdf:identifikation/xdf:version">V<xsl:value-of select="$VergleichsElement/xdf:identifikation/xdf:version"/></xsl:if><xsl:value-of select="$ToolPfadPostfix"/></xsl:attribute>
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
									<td>Version <xsl:if test="fn:not(empty($VergleichsElement)) and (fn:not((empty($Element/xdf:identifikation/xdf:version) and empty($VergleichsElement/xdf:identifikation/xdf:version)) or ($Element/xdf:identifikation/xdf:version = $VergleichsElement/xdf:identifikation/xdf:version)))">##</xsl:if></td>
									<td>
										<xsl:value-of select="$Element/xdf:identifikation/xdf:version"/>
									</td>
									<xsl:choose>
										<xsl:when test="empty($VergleichsElement) or (empty($Element/xdf:identifikation/xdf:version) and empty($VergleichsElement/xdf:identifikation/xdf:version)) or ($Element/xdf:identifikation/xdf:version = $VergleichsElement/xdf:identifikation/xdf:version)">
											<td class="Gleich">
												<xsl:value-of select="$VergleichsElement/xdf:identifikation/xdf:version"/>
											</td>
										</xsl:when>
										<xsl:otherwise>
											<td class="Ungleich">
												<xsl:value-of select="$VergleichsElement/xdf:identifikation/xdf:version"/>
											</td>
										</xsl:otherwise>
									</xsl:choose>
								</tr>
								<tr>
									<td>Name <xsl:if test="fn:not(empty($VergleichsElement)) and (fn:not((empty($Element/xdf:name) and empty($VergleichsElement/xdf:name)) or ($Element/xdf:name = $VergleichsElement/xdf:name)))">##</xsl:if></td>
									<xsl:choose>
										<xsl:when test="empty($Element/xdf:name/text())">
											<td class="ElementName">
											</td>
										</xsl:when>
										<xsl:otherwise>
											<td class="ElementName">
												<xsl:value-of select="$Element/xdf:name"/>
											</td>
										</xsl:otherwise>
									</xsl:choose>
									<xsl:choose>
										<xsl:when test="empty($VergleichsElement) or (empty($Element/xdf:name) and empty($VergleichsElement/xdf:name)) or ($Element/xdf:name = $VergleichsElement/xdf:name)">
											<td class="ElementName Gleich">
												<xsl:value-of select="$VergleichsElement/xdf:name"/>
											</td>
										</xsl:when>
										<xsl:otherwise>
											<td class="ElementName Ungleich">
												<xsl:value-of select="$VergleichsElement/xdf:name"/>
											</td>
										</xsl:otherwise>
									</xsl:choose>
								</tr>
								<tr>
									<td>Definition <xsl:if test="fn:not(empty($VergleichsElement)) and (fn:not((empty($Element/xdf:definition) and empty($VergleichsElement/xdf:definition)) or ($Element/xdf:definition = $VergleichsElement/xdf:definition)))">##</xsl:if></td>
									<td>
										<xsl:value-of select="$Element/xdf:definition"/>
									</td>
									<xsl:choose>
										<xsl:when test="empty($VergleichsElement) or (empty($Element/xdf:definition) and empty($VergleichsElement/xdf:definition)) or ($Element/xdf:definition = $VergleichsElement/xdf:definition)">
											<td class="Gleich">
												<xsl:value-of select="$VergleichsElement/xdf:definition"/>
											</td>
										</xsl:when>
										<xsl:otherwise>
											<td class="Ungleich">
												<xsl:value-of select="$VergleichsElement/xdf:definition"/>
											</td>
										</xsl:otherwise>
									</xsl:choose>
								</tr>
								<tr>
									<td>Script <xsl:if test="fn:not(empty($VergleichsElement)) and (fn:not((empty($Element/xdf:script) and empty($VergleichsElement/xdf:script)) or ($Element/xdf:script = $VergleichsElement/xdf:script)))">##</xsl:if></td>
									<td>
										<xsl:value-of select="$Element/xdf:script"/>
									</td>
									<xsl:choose>
										<xsl:when test="empty($VergleichsElement) or (empty($Element/xdf:script) and empty($VergleichsElement/xdf:script)) or ($Element/xdf:script = $VergleichsElement/xdf:script)">
											<td class="Gleich">
												<xsl:value-of select="$VergleichsElement/xdf:script"/>
											</td>
										</xsl:when>
										<xsl:otherwise>
											<td class="Ungleich">
												<xsl:value-of select="$VergleichsElement/xdf:script"/>
											</td>
										</xsl:otherwise>
									</xsl:choose>
								</tr>
								<tr>
									<td>Beschreibung <xsl:if test="fn:not(empty($VergleichsElement)) and (fn:not((empty($Element/xdf:beschreibung) and empty($VergleichsElement/xdf:beschreibung)) or ($Element/xdf:beschreibung = $VergleichsElement/xdf:beschreibung)))">##</xsl:if></td>
									<td>
										<xsl:value-of select="$Element/xdf:beschreibung"/>
									</td>
									<xsl:choose>
										<xsl:when test="empty($VergleichsElement) or (empty($Element/xdf:beschreibung) and empty($VergleichsElement/xdf:beschreibung)) or ($Element/xdf:beschreibung = $VergleichsElement/xdf:beschreibung)">
											<td class="Gleich">
												<xsl:value-of select="$VergleichsElement/xdf:beschreibung"/>
											</td>
										</xsl:when>
										<xsl:otherwise>
											<td class="Ungleich">
												<xsl:value-of select="$VergleichsElement/xdf:beschreibung"/>
											</td>
										</xsl:otherwise>
									</xsl:choose>
								</tr>
								<tr>
									<td>Bezug zu Rechtsnorm oder Standardisierungsvorhaben <xsl:if test="fn:not(empty($VergleichsElement)) and (fn:not((empty($Element/xdf:bezug) and empty($VergleichsElement/xdf:bezug)) or ($Element/xdf:bezug = $VergleichsElement/xdf:bezug)))">##</xsl:if></td>
									<xsl:choose>
										<xsl:when test="$Element/xdf:schemaelementart/code/text() = 'RNG' and empty($Element/xdf:bezug/text())">
											<td>
											</td>
										</xsl:when>
										<xsl:when test="$Element/xdf:schemaelementart/code/text() = 'HAR' and empty($Element/xdf:bezug/text())">
											<td>
											</td>
										</xsl:when>
										<xsl:otherwise>
											<td>
												<xsl:value-of select="$Element/xdf:bezug"/>
											</td>
										</xsl:otherwise>
									</xsl:choose>
									<xsl:choose>
										<xsl:when test="empty($VergleichsElement) or (empty($Element/xdf:bezug) and empty($VergleichsElement/xdf:bezug)) or ($Element/xdf:bezug = $VergleichsElement/xdf:bezug)">
											<td class="Gleich">
												<xsl:value-of select="$VergleichsElement/xdf:bezug"/>
											</td>
										</xsl:when>
										<xsl:otherwise>
											<td class="Ungleich">
												<xsl:value-of select="$VergleichsElement/xdf:bezug"/>
											</td>
										</xsl:otherwise>
									</xsl:choose>
								</tr>
								<tr>
									<td>Status <xsl:if test="fn:not(empty($VergleichsElement)) and (fn:not((empty($Element/xdf:status) and empty($VergleichsElement/xdf:status)) or ($Element/xdf:status = $VergleichsElement/xdf:status)))">##</xsl:if></td>
									<td>
										<xsl:apply-templates select="$Element/xdf:status"/>
									</td>
									<xsl:choose>
										<xsl:when test="empty($VergleichsElement) or (empty($Element/xdf:status) and empty($VergleichsElement/xdf:status)) or ($Element/xdf:status = $VergleichsElement/xdf:status)">
											<td class="Gleich">
												<xsl:apply-templates select="$VergleichsElement/xdf:status"/>
											</td>
										</xsl:when>
										<xsl:otherwise>
											<td class="Ungleich">
												<xsl:apply-templates select="$VergleichsElement/xdf:status"/>
											</td>
										</xsl:otherwise>
									</xsl:choose>
								</tr>
								<tr>
									<td>Gültig ab <xsl:if test="fn:not(empty($VergleichsElement)) and (fn:not((empty($Element/xdf:gueltigAb) and empty($VergleichsElement/xdf:gueltigAb)) or ($Element/xdf:gueltigAb = $VergleichsElement/xdf:gueltigAb)))">##</xsl:if></td>
									<td>
										<xsl:value-of select="$Element/xdf:gueltigAb"/>
									</td>
									<xsl:choose>
										<xsl:when test="empty($VergleichsElement) or (empty($Element/xdf:gueltigAb) and empty($VergleichsElement/xdf:gueltigAb)) or ($Element/xdf:gueltigAb = $VergleichsElement/xdf:gueltigAb)">
											<td class="Gleich">
												<xsl:value-of select="$VergleichsElement/xdf:gueltigAb"/>
											</td>
										</xsl:when>
										<xsl:otherwise>
											<td class="Ungleich">
												<xsl:value-of select="$VergleichsElement/xdf:gueltigAb"/>
											</td>
										</xsl:otherwise>
									</xsl:choose>
								</tr>
								<tr>
									<td>Gültig bis <xsl:if test="fn:not(empty($VergleichsElement)) and (fn:not((empty($Element/xdf:gueltigBis) and empty($VergleichsElement/xdf:gueltigBis)) or ($Element/xdf:gueltigBis = $VergleichsElement/xdf:gueltigBis)))">##</xsl:if></td>
									<td>
										<xsl:value-of select="$Element/xdf:gueltigBis"/>
									</td>
									<xsl:choose>
										<xsl:when test="empty($VergleichsElement) or (empty($Element/xdf:gueltigBis) and empty($VergleichsElement/xdf:gueltigBis)) or ($Element/xdf:gueltigBis = $VergleichsElement/xdf:gueltigBis)">
											<td class="Gleich">
												<xsl:value-of select="$VergleichsElement/xdf:gueltigBis"/>
											</td>
										</xsl:when>
										<xsl:otherwise>
											<td class="Ungleich">
												<xsl:value-of select="$VergleichsElement/xdf:gueltigBis"/>
											</td>
										</xsl:otherwise>
									</xsl:choose>
								</tr>
								<tr>
									<td>Fachlicher Ersteller <xsl:if test="fn:not(empty($VergleichsElement)) and (fn:not((empty($Element/xdf:fachlicherErsteller) and empty($VergleichsElement/xdf:fachlicherErsteller)) or ($Element/xdf:fachlicherErsteller = $VergleichsElement/xdf:fachlicherErsteller)))">##</xsl:if></td>
									<td>
										<xsl:value-of select="$Element/xdf:fachlicherErsteller"/>
									</td>
									<xsl:choose>
										<xsl:when test="empty($VergleichsElement) or (empty($Element/xdf:fachlicherErsteller) and empty($VergleichsElement/xdf:fachlicherErsteller)) or ($Element/xdf:fachlicherErsteller = $VergleichsElement/xdf:fachlicherErsteller)">
											<td class="Gleich">
												<xsl:value-of select="$VergleichsElement/xdf:fachlicherErsteller"/>
											</td>
										</xsl:when>
										<xsl:otherwise>
											<td class="Ungleich">
												<xsl:value-of select="$VergleichsElement/xdf:fachlicherErsteller"/>
											</td>
										</xsl:otherwise>
									</xsl:choose>
								</tr>
								<tr>
									<td>
										<b>Verwendet in</b>
									</td>
									
									<xsl:variable name="RegelID" select="$Element/xdf:identifikation/xdf:id"/>
									<xsl:variable name="RegelVersion" select="$Element/xdf:identifikation/xdf:version"/>
												
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
									<td colspan="3" class="Navigation">
										<xsl:call-template name="navigationszeile"/>
									</td>
								</tr>
	</xsl:template>

	<!-- ############################################################################################################# -->

	<xsl:template name="listecodelistendetailszustammdatenschema">
	
		<xsl:if test="$DebugMode = '1' or $DebugMode = '2' or $DebugMode = '3' or $DebugMode = '4'">
			<xsl:message>
				++++ listecodelistendetailszustammdatenschema ++++
			</xsl:message>
		</xsl:if>

					<h2><br/></h2>
					<h2>
						<a name="CodelisteDetails"/>Details zu den Codelisten des Stammdatenschemas <xsl:value-of select="/*/xdf:stammdatenschema/xdf:identifikation/xdf:id"/><xsl:if test="/*/xdf:stammdatenschema/xdf:identifikation/xdf:version"> Version <xsl:value-of select="/*/xdf:stammdatenschema/xdf:identifikation/xdf:version"/></xsl:if>
					</h2>
					<table style="page-break-after:always">
						<thead>
							<tr>
								<th width="10%">Metadatum</th>
								<th width="45%">Inhalt Stammdatenschema <xsl:value-of select="$NameSDSA"/></th>
								<th width="45%">Inhalt Stammdatenschema <xsl:value-of select="$NameSDSO"/></th>
							</tr>
						</thead>
						<tbody>
							<xsl:for-each-group select="//xdf:codelisteReferenz" group-by="xdf:identifikation/xdf:id">
								<xsl:sort select="./xdf:identifikation/xdf:id"/>

									<xsl:call-template name="codelistedetailszustammdatenschema">
										<xsl:with-param name="Element" select="."/>
									</xsl:call-template>

							</xsl:for-each-group>
							<xsl:for-each-group select="$VergleichsDaten//xdf:codelisteReferenz" group-by="xdf:identifikation/xdf:id">
								<xsl:sort select="./xdf:identifikation/xdf:id"/>

									<xsl:variable name="CheckId" select="./xdf:genericodeIdentification/xdf:canonicalIdentification"/>

									<xsl:if test="empty($Daten//xdf:genericodeIdentification[xdf:canonicalIdentification = $CheckId])">

										<xsl:call-template name="codelistedetailszustammdatenschemavergleich">
											<xsl:with-param name="Element" select="."/>
										</xsl:call-template>
									
									</xsl:if>

							</xsl:for-each-group>
						</tbody>

					</table>
	</xsl:template>

	<!-- ############################################################################################################# -->

	<xsl:template name="codelistedetailszustammdatenschema">
		<xsl:param name="Element"/>
		
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

		<xsl:variable name="Temp" select="$VergleichsDaten//*[xdf:genericodeIdentification/xdf:canonicalIdentification = $Element/xdf:genericodeIdentification/xdf:canonicalIdentification]"/>
		<xsl:variable name="VergleichsElement" select="$Temp[1]"/>

								<tr>
									<td>
										<xsl:element name="a">
											<xsl:attribute name="name"><xsl:value-of select="$Element/xdf:identifikation/xdf:id"/></xsl:attribute>
										</xsl:element>
										ID <xsl:if test="fn:not(empty($VergleichsElement)) and (fn:not((empty($Element/xdf:identifikation/xdf:id) and empty($VergleichsElement/xdf:identifikation/xdf:id)) or ($Element/xdf:identifikation/xdf:id = $VergleichsElement/xdf:identifikation/xdf:id)))">##</xsl:if>
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
									</td>
									<xsl:choose>
										<xsl:when test="empty($VergleichsElement)">
											<td class="Ungleich NeuCodelisten">Nicht vorhanden ##</td>
										</xsl:when>
										<xsl:when test="($Element/xdf:identifikation/xdf:id = $VergleichsElement/xdf:identifikation/xdf:id)">
											<td class="Gleich">
												<xsl:element name="a">
													<xsl:attribute name="name">X<xsl:value-of select="$VergleichsElement/xdf:identifikation/xdf:id"/></xsl:attribute>
												</xsl:element>
												<xsl:value-of select="$VergleichsElement/xdf:identifikation/xdf:id"/>
												<xsl:if test="$ToolAufruf = '1'">
													&#160;&#160;
													<xsl:element name="a">
														<xsl:attribute name="href"><xsl:value-of select="$ToolPfadPrefix"/><xsl:value-of select="$VergleichsElement/xdf:identifikation/xdf:id"/><xsl:value-of select="$ToolPfadPostfix"/></xsl:attribute>
														<xsl:attribute name="target">FIMTool</xsl:attribute>
														<xsl:attribute name="title">Springe in den Datenfeldeditor (man muss vorher angemeldet sein).</xsl:attribute>
														&#8658;
													</xsl:element>
												</xsl:if>
											</td>
										</xsl:when>
										<xsl:otherwise>
											<td class="Ungleich AenderungCodelisten">
												<xsl:element name="a">
													<xsl:attribute name="name">X<xsl:value-of select="$VergleichsElement/xdf:identifikation/xdf:id"/></xsl:attribute>
												</xsl:element>
												<xsl:value-of select="$VergleichsElement/xdf:identifikation/xdf:id"/>
												<xsl:if test="$ToolAufruf = '1'">
													&#160;&#160;
													<xsl:element name="a">
														<xsl:attribute name="href"><xsl:value-of select="$ToolPfadPrefix"/><xsl:value-of select="$VergleichsElement/xdf:identifikation/xdf:id"/><xsl:value-of select="$ToolPfadPostfix"/></xsl:attribute>
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
									<td>Version <xsl:if test="fn:not(empty($VergleichsElement)) and (fn:not((empty($Element/xdf:genericodeIdentification/xdf:version) and empty($VergleichsElement/xdf:genericodeIdentification/xdf:version)) or ($Element/xdf:genericodeIdentification/xdf:version = $VergleichsElement/xdf:genericodeIdentification/xdf:version)))">##</xsl:if></td>
									<td>
										<xsl:value-of select="$Element/xdf:genericodeIdentification/xdf:version"/>
									</td>
									<xsl:choose>
										<xsl:when test="empty($VergleichsElement)">
											<td class="Gleich">
											</td>
										</xsl:when>
										<xsl:when test="$Element/xdf:genericodeIdentification/xdf:version = $VergleichsElement/xdf:genericodeIdentification/xdf:version">
											<td class="Gleich">
												<xsl:value-of select="$VergleichsElement/xdf:genericodeIdentification/xdf:version"/>
											</td>
										</xsl:when>
										<xsl:otherwise>
											<td class="Ungleich">
												<xsl:value-of select="$VergleichsElement/xdf:genericodeIdentification/xdf:version"/>
											</td>
										</xsl:otherwise>
									</xsl:choose>
								</tr>
								<tr>
									<td>Kennung</td>
									<xsl:choose>
										<xsl:when test="substring($Element/xdf:genericodeIdentification/xdf:canonicalIdentification/text(),1,4) != 'urn:'">
											<td>
												<xsl:value-of select="$Element/xdf:genericodeIdentification/xdf:canonicalIdentification"/>
											</td>
										</xsl:when>
										<xsl:otherwise>
											<td>
												<xsl:value-of select="$Element/xdf:genericodeIdentification/xdf:canonicalIdentification"/>
											</td>
										</xsl:otherwise>
									</xsl:choose>
									<xsl:choose>
										<xsl:when test="empty($VergleichsElement)">
											<td class="Gleich">
											</td>
										</xsl:when>
										<xsl:when test="substring($Element/xdf:genericodeIdentification/xdf:canonicalIdentification/text(),1,4) != 'urn:'">
											<td>
												<xsl:value-of select="$Element/xdf:genericodeIdentification/xdf:canonicalIdentification"/>
											</td>
										</xsl:when>
										<xsl:otherwise>
											<td>
												<xsl:value-of select="$Element/xdf:genericodeIdentification/xdf:canonicalIdentification"/>
											</td>
										</xsl:otherwise>
									</xsl:choose>
								</tr>

<!--
								<xsl:if test="$CodelistenInhalt = '1' and not(empty($VergleichsElement))">
-->
								<xsl:if test="$CodelistenInhalt = '1'">
									<xsl:variable name="CodelisteDatei" select="concat($InputPfad,$Element/xdf:identifikation/xdf:id, '_genericode.xml')"/>

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

									<xsl:variable name="CodelisteDateiVergleich" select="concat($InputPfad,$VergleichsElement/xdf:identifikation/xdf:id, '_genericode.xml')"/>

									<xsl:variable name="CodelisteInhaltVergleich">
										<xsl:choose>
											<xsl:when test="fn:doc-available($CodelisteDateiVergleich)">
												<xsl:copy-of select="fn:document($CodelisteDateiVergleich)"/>
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
											<tr>
												<td>Inhalt ##</td>
												<td class="Ungleich" colspan="2">
													Codeliste <xsl:value-of select="concat($Element/xdf:identifikation/xdf:id, '_genericode.xml')"/> konnte nicht geöffnet werden.
												</td>
											</tr>
										</xsl:when> 
										<xsl:when test="fn:not(fn:empty($VergleichsElement)) and fn:string-length($CodelisteInhaltVergleich) &lt; 10">
											<tr>
												<td>Inhalt ##</td>
												<td class="Ungleich" colspan="2">
													Codeliste <xsl:value-of select="concat($VergleichsElement/xdf:identifikation/xdf:id, '_genericode.xml')"/> konnte nicht geöffnet werden.
												</td>
											</tr>
											<tr>
												<td></td>
												<td colspan="2">
													<xsl:call-template name="codelisteinhalt">
														<xsl:with-param name="CodelisteInhalt" select="$CodelisteInhalt"/>
														<xsl:with-param name="CodelisteInhaltVergleich" select="$CodelisteInhaltVergleich"/>
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
														<xsl:with-param name="CodelisteInhalt" select="$CodelisteInhalt"/>
														<xsl:with-param name="CodelisteInhaltVergleich" select="$CodelisteInhaltVergleich"/>
														<xsl:with-param name="NameInhalt" select="$KurznameSDSA"/>
														<xsl:with-param name="NameInhaltVergleich" select="$KurznameSDSO"/>
													</xsl:call-template>
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
									<td colspan="3" class="Navigation">
										<xsl:call-template name="navigationszeile"/>
									</td>
								</tr>
	</xsl:template>

	<!-- ############################################################################################################# -->

	<xsl:template name="codelistedetailszustammdatenschemavergleich">
		<xsl:param name="Element"/>
		
		<xsl:if test="$DebugMode = '2' or $DebugMode = '3' or $DebugMode = '4'">
			<xsl:message>
				++++++++ codelistedetailszustammdatenschemavergleich ++++++++
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
											<xsl:attribute name="name">X<xsl:value-of select="$Element/xdf:identifikation/xdf:id"/></xsl:attribute>
										</xsl:element>
										ID ##
									</td>
									<td>Nicht vorhanden</td>
									<td class="Ungleich GeloeschtCodelisten">
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
									</td>
								</tr>
								<tr>
									<td>Version</td>
									<td></td>
									<td>
										<xsl:value-of select="$Element/xdf:genericodeIdentification/xdf:version"/>
									</td>
								</tr>
								<tr>
									<td>Kennung</td>
									<td></td>
									<xsl:choose>
										<xsl:when test="substring($Element/xdf:genericodeIdentification/xdf:canonicalIdentification/text(),1,4) != 'urn:'">
											<td>
												<xsl:value-of select="$Element/xdf:genericodeIdentification/xdf:canonicalIdentification"/>
											</td>
										</xsl:when>
										<xsl:otherwise>
											<td>
												<xsl:value-of select="$Element/xdf:genericodeIdentification/xdf:canonicalIdentification"/>
											</td>
										</xsl:otherwise>
									</xsl:choose>
								</tr>

<!--
								<xsl:if test="$CodelistenInhalt = '1' and not(empty($VergleichsElement))">
-->
								<xsl:if test="$CodelistenInhalt = '1'">
									<xsl:variable name="CodelisteDatei" select="concat($InputPfad,$Element/xdf:identifikation/xdf:id, '_genericode.xml')"/>

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
											<tr>
												<td>Inhalt ##</td>
												<td></td>
												<td class="Ungleich">
													Codeliste <xsl:value-of select="concat($Element/xdf:identifikation/xdf:id, '_genericode.xml')"/> konnte nicht geöffnet werden.
												</td>
											</tr>
										</xsl:when> 
										<xsl:otherwise>
											<tr>
												<td>Inhalt</td>
												<td></td>
												<td>
													<xsl:call-template name="codelisteinhaltvergleich">
														<xsl:with-param name="CodelisteInhalt" select="$CodelisteInhalt"/>
													</xsl:call-template>
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
														<xsl:for-each-group select="//xdf:datenfeld[xdf:codelisteReferenz/xdf:identifikation/xdf:id = $CodelisteID]" group-by="xdf:identifikation/xdf:id">
															<xsl:sort select="./xdf:identifikation/xdf:id"/>

															<xsl:for-each-group select="fn:current-group()" group-by="string(xdf:identifikation/xdf:version)">
																<xsl:sort select="./xdf:identifikation/xdf:version"/>

																<xsl:call-template name="minielementcorevergleich">
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
							
							<table>
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
							
							<table>
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
																					<xsl:attribute name="href">#<xsl:value-of select="$Element/xdf:identifikation/xdf:id"/><xsl:if test="$Element/xdf:identifikation/xdf:version">V<xsl:value-of select="$Element/xdf:identifikation/xdf:version"/></xsl:if></xsl:attribute>
																					<xsl:value-of select="$Element/xdf:identifikation/xdf:id"/>
																				</xsl:element>
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
																					<xsl:attribute name="href">#X<xsl:value-of select="$Element/xdf:identifikation/xdf:id"/><xsl:if test="$Element/xdf:identifikation/xdf:version">V<xsl:value-of select="$Element/xdf:identifikation/xdf:version"/></xsl:if></xsl:attribute>
																					<xsl:value-of select="$Element/xdf:identifikation/xdf:id"/>
																				</xsl:element>
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
			<xsl:otherwise></xsl:otherwise>
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
			<xsl:otherwise></xsl:otherwise>
		</xsl:choose>
	</xsl:template>
	
	<xsl:template match="xdf:schemaelementart">
		<xsl:choose>
			<xsl:when test="./code/text() = 'ABS'">abstrakt</xsl:when>
			<xsl:when test="./code/text() = 'HAR'">harmonisiert</xsl:when>
			<xsl:when test="./code/text() = 'RNG'">rechtsnormgebunden</xsl:when>
			<xsl:otherwise></xsl:otherwise>
		</xsl:choose>
	</xsl:template>
	
	<xsl:template match="xdf:status">
		<xsl:choose>
			<xsl:when test="./code/text() = 'inVorbereitung'">in Vorbereitung</xsl:when>
			<xsl:when test="./code/text() = 'aktiv'">aktiv</xsl:when>
			<xsl:when test="./code/text() = 'inaktiv'">inaktiv</xsl:when>
			<xsl:otherwise></xsl:otherwise>
		</xsl:choose>
	</xsl:template>
	
	<xsl:template match="xdf:ableitungsmodifikationenStruktur">
		<xsl:choose>
			<xsl:when test="./code/text() = '0'">nicht modifizierbar</xsl:when>
			<xsl:when test="./code/text() = '1'">nur einschränkbar</xsl:when>
			<xsl:when test="./code/text() = '2'">nur erweiterbar</xsl:when>
			<xsl:when test="./code/text() = '3'">alles modifizierbar</xsl:when>
			<xsl:otherwise></xsl:otherwise>
		</xsl:choose>
	</xsl:template>
	
	<xsl:template match="xdf:ableitungsmodifikationenRepraesentation">
		<xsl:choose>
			<xsl:when test="./code/text() = '0'">nicht modifizierbar</xsl:when>
			<xsl:when test="./code/text() = '1'">modifizierbar</xsl:when>
			<xsl:otherwise></xsl:otherwise>
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
