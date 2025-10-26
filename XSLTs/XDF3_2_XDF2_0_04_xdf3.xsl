<?xml version="1.0" encoding="iso-8859-1"?>
<xsl:stylesheet version="2.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:xdf3="urn:xoev-de:fim:standard:xdatenfelder_3.0.0" xmlns:html="http://www.w3.org/1999/xhtml" xmlns:fn="http://www.w3.org/2005/xpath-functions" xmlns:xdf="urn:xoev-de:fim:standard:xdatenfelder_2" xmlns:gc="http://docs.oasis-open.org/codelist/ns/genericode/1.0/"  xmlns:ext="http://www.xoev.de/de/xrepository/framework/1/extrakte" xmlns:bdt="http://www.xoev.de/de/xrepository/framework/1/basisdatentypen" xmlns:dat="http://www.xoev.de/de/xrepository/framework/1/datenbereitstellung" xmlns:svrl="http://purl.oclc.org/dsdl/svrl" exclude-result-prefixes="html xsl fn xdf3 gc ext bdt dat svrl xdf">

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

	<xsl:variable name="StyleSheetName" select="'XDF3_2_XDF2_0_04_xdf3.xsl'"/> <!-- BackUp, falls fn:static-base-uri() leer -->

	<xsl:output method="xml" omit-xml-declaration="no"/>
	<xsl:strip-space elements="*"/>

	<xsl:param name="DateiOutput" select="'0'"/>
	<xsl:param name="HiddenWeglassen" select="'1'"/>
	<xsl:param name="FreitextRegelKorrektur" select="'1'"/>
	<xsl:param name="CodelistenInternIdentifier" select="'urn:de:fim:codeliste:'"/>
	<xsl:param name="CodelistendateienErzeugen" select="'1'"/>
	<xsl:param name="OriginalwerteDoku" select="'2'"/>
	<xsl:param name="XDF2WerteErhalten" select="'0'"/>
	<xsl:param name="DebugMode" select="'3'"/>
	<xsl:param name="XMLXRepoMitVersionPfadPrefix" select="'https://www.xrepository.de/api/version_codeliste/'"/>
	<xsl:param name="XMLXRepoMitVersionPfadPostfix" select="'/genericode'"/>
	<xsl:param name="XMLXRepoOhneVersionPfadPrefix" select="'https://www.xrepository.de/api/codeliste/'"/>
	<xsl:param name="XMLXRepoOhneVersionPfadPostfix" select="'/gueltigeVersion'"/>

	<xsl:variable name="InputDateiname" select="(tokenize($DocumentURI,'/'))[last()]"/>
	<xsl:variable name="InputPfad" select="fn:substring-before($DocumentURI, $InputDateiname)"/>

	<!-- ############################################################################################################# -->
	
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
				HiddenWeglassen: <xsl:value-of select="$HiddenWeglassen"/>
				CodelistenInternIdentifier: <xsl:value-of select="$CodelistenInternIdentifier"/>
				CodelistendateienErzeugen: <xsl:value-of select="$CodelistendateienErzeugen"/>
				DebugMode: <xsl:value-of select="$DebugMode"/>
			</xsl:message>
		</xsl:if>

		<xsl:variable name="RootID"><xsl:apply-templates select="/*/*/xdf3:identifikation/xdf3:id"/></xsl:variable>
		<xsl:variable name="RootVersion"><xsl:apply-templates select="/*/*/xdf3:identifikation/xdf3:version"/></xsl:variable>
		<xsl:variable name="OutputDateiname"><xsl:value-of select="$RootID"/><xsl:if test="not(empty($RootVersion/text()))">V<xsl:value-of select="$RootVersion"/></xsl:if>_xdf2.xml</xsl:variable>

		<xsl:choose>
			<xsl:when test="$DateiOutput ='1'">
				<xsl:result-document href="{$OutputDateiname}">
					<xsl:call-template name="hauptfunktion"/>
				</xsl:result-document>

				<xsl:if test="$DebugMode = '1' or $DebugMode = '2' or $DebugMode = '3' or $DebugMode = '4'">
					<xsl:message>
	Ende
	Output: <xsl:value-of select="$OutputDateiname"/>
	XSLT: <xsl:value-of select="tokenize($StyleSheetURI, '/')[last()]"/>
					</xsl:message>
				</xsl:if>
			</xsl:when>
			<xsl:otherwise>
				<xsl:call-template name="hauptfunktion"/>

				<xsl:if test="$DebugMode = '1' or $DebugMode = '2' or $DebugMode = '3' or $DebugMode = '4'">
					<xsl:message>
	Ende
	XSLT: <xsl:value-of select="tokenize($StyleSheetURI, '/')[last()]"/>
					</xsl:message>
				</xsl:if>
			</xsl:otherwise>
		</xsl:choose>

	</xsl:template>

	<!-- ############################################################################################################# -->

	<xsl:template name="hauptfunktion">
	
		<xsl:choose>
			<xsl:when test="name(/*) ='xdf3:xdatenfelder.stammdatenschema.0102'">
				<xdf:xdatenfelder.stammdatenschema.0102 xmlns:xdf="urn:xoev-de:fim:standard:xdatenfelder_2">

					<xsl:comment><xsl:text>           </xsl:text>Erstellt am: <xsl:value-of select="format-date(fn:current-date(),'[D01].[M01].[Y0001]')"/> um <xsl:value-of select="format-time(fn:current-time(),'[H01]:[m01]')"/> Uhr<xsl:text>           </xsl:text>XSLT: <xsl:choose><xsl:when test="empty($StyleSheetURI)"><xsl:value-of select="$StyleSheetName"/></xsl:when><xsl:otherwise><xsl:call-template name="fileName"><xsl:with-param name="path" select="$StyleSheetURI"/></xsl:call-template></xsl:otherwise></xsl:choose><xsl:if test="not(empty($DocumentURI))"><xsl:text>           </xsl:text>XML: <xsl:call-template name="fileName"><xsl:with-param name="path" select="$DocumentURI"/></xsl:call-template></xsl:if><xsl:text>           </xsl:text></xsl:comment>

					<xsl:apply-templates select="./*/xdf3:header"/>

					<xsl:apply-templates select="./*/xdf3:stammdatenschema"/>
					
					<xsl:call-template name="createcodelists"/>
	
				</xdf:xdatenfelder.stammdatenschema.0102>
			</xsl:when>
			<xsl:when test="name(/*) ='xdf3:xdatenfelder.datenfeldgruppe.0103'">
				<xdf:xdatenfelder.datenfeldgruppe.0103 xmlns:xdf="urn:xoev-de:fim:standard:xdatenfelder_2">
	
					<xsl:comment><xsl:text>           </xsl:text>Erstellt am: <xsl:value-of select="format-date(fn:current-date(),'[D01].[M01].[Y0001]')"/> um <xsl:value-of select="format-time(fn:current-time(),'[H01]:[m01]')"/> Uhr<xsl:text>           </xsl:text>XSLT: <xsl:choose><xsl:when test="empty($StyleSheetURI)"><xsl:value-of select="$StyleSheetName"/></xsl:when><xsl:otherwise><xsl:call-template name="fileName"><xsl:with-param name="path" select="$StyleSheetURI"/></xsl:call-template></xsl:otherwise></xsl:choose><xsl:if test="not(empty($DocumentURI))"><xsl:text>           </xsl:text>XML: <xsl:call-template name="fileName"><xsl:with-param name="path" select="$DocumentURI"/></xsl:call-template></xsl:if><xsl:text>           </xsl:text></xsl:comment>

					<xsl:apply-templates select="./*/xdf3:header"/>

					<xsl:apply-templates select="./*/xdf3:datenfeldgruppe"/>
	
				</xdf:xdatenfelder.datenfeldgruppe.0103>
			</xsl:when>
			<xsl:when test="name(/*) ='xdf3:xdatenfelder.datenfeld.0104'">
				<xdf:xdatenfelder.datenfeld.0104 xmlns:xdf="urn:xoev-de:fim:standard:xdatenfelder_2">
	
					<xsl:comment><xsl:text>           </xsl:text>Erstellt am: <xsl:value-of select="format-date(fn:current-date(),'[D01].[M01].[Y0001]')"/> um <xsl:value-of select="format-time(fn:current-time(),'[H01]:[m01]')"/> Uhr<xsl:text>           </xsl:text>XSLT: <xsl:choose><xsl:when test="empty($StyleSheetURI)"><xsl:value-of select="$StyleSheetName"/></xsl:when><xsl:otherwise><xsl:call-template name="fileName"><xsl:with-param name="path" select="$StyleSheetURI"/></xsl:call-template></xsl:otherwise></xsl:choose><xsl:if test="not(empty($DocumentURI))"><xsl:text>           </xsl:text>XML: <xsl:call-template name="fileName"><xsl:with-param name="path" select="$DocumentURI"/></xsl:call-template></xsl:if><xsl:text>           </xsl:text></xsl:comment>

					<xsl:apply-templates select="./*/xdf3:header"/>

					<xsl:apply-templates select="./*/xdf3:datenfeld"/>
	
				</xdf:xdatenfelder.datenfeld.0104>
			</xsl:when>
			<xsl:when test="name(/*) ='xdf3:xdatenfelder.dokumentsteckbrief.0101'">
				<xdf:xdatenfelder.dokumentsteckbrief.0101 xmlns:xdf="urn:xoev-de:fim:standard:xdatenfelder_2">
	
					<xsl:comment><xsl:text>           </xsl:text>Erstellt am: <xsl:value-of select="format-date(fn:current-date(),'[D01].[M01].[Y0001]')"/> um <xsl:value-of select="format-time(fn:current-time(),'[H01]:[m01]')"/> Uhr<xsl:text>           </xsl:text>XSLT: <xsl:choose><xsl:when test="empty($StyleSheetURI)"><xsl:value-of select="$StyleSheetName"/></xsl:when><xsl:otherwise><xsl:call-template name="fileName"><xsl:with-param name="path" select="$StyleSheetURI"/></xsl:call-template></xsl:otherwise></xsl:choose><xsl:if test="not(empty($DocumentURI))"><xsl:text>           </xsl:text>XML: <xsl:call-template name="fileName"><xsl:with-param name="path" select="$DocumentURI"/></xsl:call-template></xsl:if><xsl:text>           </xsl:text></xsl:comment>

					<xsl:apply-templates select="./*/xdf3:header"/>

					<xsl:apply-templates select="./*/xdf3:dokumentsteckbrief"/>
	
				</xdf:xdatenfelder.dokumentsteckbrief.0101>
			</xsl:when>
			<xsl:otherwise>
				<title>Unbekanntes Dateiformat</title>
			</xsl:otherwise>
		</xsl:choose>
	
	</xsl:template>

	<!-- ############################################################################################################# -->
	
	<xsl:template name="createcodelists">

		<xsl:if test="$DebugMode = '3' or $DebugMode = '4'">
			<xsl:message>
				++++ createcodelists ++++
			</xsl:message>
		</xsl:if>

		<xsl:for-each-group select="//xdf3:datenfeld[xdf3:feldart/code ='select']" group-by="concat(xdf3:identifikation/xdf3:id,xdf3:identifikation/xdf3:version)">
			<xsl:sort select="xdf3:identifikation/xdf3:id"/>
			<xsl:sort select="xdf3:identifikation/xdf3:version"/>
			
			<xsl:variable name="InternalID"><xsl:call-template name="CodelistID"><xsl:with-param name="Identifikation" select="xdf3:identifikation"/></xsl:call-template></xsl:variable>
			
			<xsl:variable name="FileName"><xsl:value-of select="$InputPfad"/><xsl:value-of select="$InternalID"/>_genericode.xml</xsl:variable>
			
			<xsl:variable name="TempName"><xsl:call-template name="URNsonderzeichenraus"><xsl:with-param name="OriginalText" select="../xdf3:name"/></xsl:call-template></xsl:variable>
			
			<xsl:variable name="TempcanonicalIdentification"><xsl:value-of select="$TempName"/>_<xsl:value-of select="./xdf3:identifikation/xdf3:id"/><xsl:if test="./xdf3:identifikation/xdf3:version">V<xsl:value-of select="./xdf3:identifikation/xdf3:version"/></xsl:if></xsl:variable>
		
			<xsl:variable name="Tempversion"><xsl:value-of select="format-dateTime(./xdf3:letzteAenderung,'[Y0001]-[M01]-[D01]')"/></xsl:variable>
		
			<xsl:if test="$CodelistendateienErzeugen = '1' and not(fn:doc-available($FileName))">
			
				<xsl:choose>
					<xsl:when test="./xdf3:codelisteReferenz">

						<xsl:variable name="RichtigeVersion">
							<xsl:choose>
								<xsl:when test="empty(./xdf3:codelisteReferenz/xdf3:version/text())">
									<xsl:variable name="CodelisteAbfrageURL" select="fn:concat($XMLXRepoOhneVersionPfadPrefix,./xdf3:codelisteReferenz/xdf3:canonicalIdentification,$XMLXRepoOhneVersionPfadPostfix)"/>
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
										<xsl:when test="fn:string-length($CodelisteAbfrageInhalt) &lt; 10">unbestimmt</xsl:when>
										<xsl:otherwise><xsl:value-of select="$CodelisteAbfrageInhalt/dat:VersionCodeliste/dat:version"/></xsl:otherwise>
									</xsl:choose>
								</xsl:when>
								<xsl:otherwise><xsl:value-of select="./xdf3:codelisteReferenz/xdf3:version"/></xsl:otherwise>
							</xsl:choose>
						</xsl:variable>

						<xsl:variable name="NormalisierteURN" select="fn:replace(./xdf3:codelisteReferenz/xdf3:canonicalIdentification,':','.')"/>
						<xsl:variable name="CodelisteDatei" select="fn:concat($InputPfad,$NormalisierteURN,'_',$RichtigeVersion,'.xml')"/>
						<xsl:variable name="CodelisteURL" select="fn:concat($XMLXRepoMitVersionPfadPrefix,./xdf3:codelisteReferenz/xdf3:canonicalIdentification,'_',$RichtigeVersion,$XMLXRepoMitVersionPfadPostfix)"/>
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
							</xsl:when>
							<xsl:otherwise>
								<xsl:result-document href="{$FileName}" encoding="UTF-8" method="xml">
									
									<CodeList xmlns="http://docs.oasis-open.org/codelist/ns/genericode/1.0/">
										<Identification>
											<xsl:choose>
												<xsl:when test="empty(fn:concat($CodelisteInhalt/*/gc:Identification/gc:ShortName/text(), $CodelisteInhalt/*/Identification/ShortName/text()))">
													<ShortName><xsl:value-of select="./xdf3:name"/></ShortName>
												</xsl:when>
												<xsl:otherwise>
													<ShortName><xsl:value-of select="$CodelisteInhalt/*/gc:Identification/gc:ShortName"/><xsl:value-of select="$CodelisteInhalt/*/Identification/ShortName"/></ShortName>
												</xsl:otherwise>
											</xsl:choose>
											<xsl:if test="not(empty(fn:concat($CodelisteInhalt/*/gc:Identification/gc:ShortName/text(), $CodelisteInhalt/*/Identification/ShortName/text())))">
												<LongName><xsl:value-of select="$CodelisteInhalt/*/gc:Identification/gc:LongName"/><xsl:value-of select="$CodelisteInhalt/*/Identification/LongName"/></LongName>
											</xsl:if>
											<Version><xsl:value-of select="./xdf3:codelisteReferenz/xdf3:version"/></Version>
											<CanonicalUri><xsl:value-of select="./xdf3:codelisteReferenz/xdf3:canonicalIdentification"/></CanonicalUri>
											<CanonicalVersionUri><xsl:value-of select="./xdf3:codelisteReferenz/xdf3:canonicalVersionUri"/></CanonicalVersionUri>
										</Identification>
										<xsl:copy-of select="$CodelisteInhalt/*/gc:ColumnSet"/>
										<xsl:copy-of select="$CodelisteInhalt/*/gc:SimpleCodeList"/>
										<xsl:copy-of select="$CodelisteInhalt/*/ColumnSet"/>
										<xsl:copy-of select="$CodelisteInhalt/*/SimpleCodeList"/>
									</CodeList>
								
								</xsl:result-document>
							</xsl:otherwise>
						</xsl:choose>
					</xsl:when>
					<xsl:otherwise>
						<xsl:result-document href="{$FileName}" encoding="UTF-8" method="xml">
							
							<CodeList xmlns="http://docs.oasis-open.org/codelist/ns/genericode/1.0/">
							
								<Identification>
									<ShortName><xsl:value-of select="./xdf3:name"/></ShortName>
									<Version><xsl:value-of select="$Tempversion"/></Version>
									<CanonicalUri><xsl:value-of select="$CodelistenInternIdentifier"/><xsl:value-of select="$TempcanonicalIdentification"/></CanonicalUri>
									<CanonicalVersionUri><xsl:value-of select="$CodelistenInternIdentifier"/><xsl:value-of select="$TempcanonicalIdentification"/>_<xsl:value-of select="$Tempversion"/></CanonicalVersionUri>
								</Identification>
								<ColumnSet>
									<Column Id="code" Use="required">
										<ShortName>Code</ShortName>
										<Data Type="string"/>
									</Column>
									<Column Id="name" Use="required">
										<ShortName>Name</ShortName>
										<Data Type="string"/>
									</Column>
									<Column Id="Hilfetext">
										<ShortName>Hilfetext</ShortName>
										<Data Type="string"/>
									</Column>
									<Key Id="codeKey">
										<ShortName>CodeKey</ShortName>
										<ColumnRef Ref="code"/>
									</Key>
									<Key Id="codenameKey">
										<ShortName>CodenameKey</ShortName>
										<ColumnRef Ref="name"/>
									</Key>
								</ColumnSet>
								<SimpleCodeList>
									<xsl:for-each select="./xdf3:werte/xdf3:wert">
										<Row>
											<Value ColumnRef="code">
												<SimpleValue><xsl:value-of select="./xdf3:code"/></SimpleValue>
											</Value>
											<Value ColumnRef="name">
												<SimpleValue><xsl:value-of select="./xdf3:name"/></SimpleValue>
											</Value>
											<Value ColumnRef="Hilfetext">
												<SimpleValue><xsl:value-of select="./xdf3:hilfe"/></SimpleValue>
											</Value>
										</Row>
									</xsl:for-each>
								</SimpleCodeList>
							</CodeList>
						
						</xsl:result-document>
					</xsl:otherwise>
				</xsl:choose>
			</xsl:if>
			
		</xsl:for-each-group>


	</xsl:template>
	<!-- ############################################################################################################# -->
	
	<xsl:template match="xdf3:stammdatenschema">
		
		<xsl:if test="$DebugMode = '2' or $DebugMode = '3' or $DebugMode = '4'">
			<xsl:message>
				++++ stammdatenschema ++++
				Datenschema: <xsl:value-of select="./xdf3:identifikation/xdf3:id"/>
			</xsl:message>
		</xsl:if>

		<xdf:stammdatenschema>

			<xsl:variable name="BeschreibungNeu">
				Originalwerte der XDF3-Datei:
				ID: <xsl:value-of select="./xdf3:identifikation/xdf3:id"/><xsl:if test="not(empty(./xdf3:identifikation/xdf3:version/text()))">
				Version: <xsl:value-of select="./xdf3:identifikation/xdf3:version"/></xsl:if><xsl:if test="not(empty(./xdf3:freigabestatus/code/text()))">
				Status: <xsl:call-template name="freigabestatus"><xsl:with-param name="Element" select="./xdf3:freigabestatus"/></xsl:call-template></xsl:if><xsl:if test="not(empty(./xdf3:statusGesetztAm/text()))">
				Status gesetzt am: <xsl:value-of select="./xdf3:statusGesetztAm"/></xsl:if><xsl:if test="not(empty(./xdf3:letzteAenderung/text()))">
				Letzte Änderung: <xsl:value-of select="./xdf3:letzteAenderung"/></xsl:if><xsl:if test="not(empty(./xdf3:dokumentsteckbrief/xdf3:id/text()))">
				Zugeordneter Dokumentsteckbrief: <xsl:value-of select="./xdf3:dokumentsteckbrief/xdf3:id"/></xsl:if>
				<xsl:for-each select="./xdf3:stichwort">
				<xsl:if test="fn:position() = 1">
				Stichwörter:<xsl:text> 
				</xsl:text></xsl:if><xsl:value-of select="."/><xsl:if test="./@uri"> (<xsl:value-of select="./@uri"/>)</xsl:if><xsl:if test="fn:position() != fn:last()"><xsl:text>, </xsl:text></xsl:if>
				</xsl:for-each>
				<xsl:for-each select="./xdf3:relation[xdf3:praedikat/code != 'VKN']">
				<xsl:if test="fn:position() = 1">
				Relationen:<xsl:text> 
				</xsl:text></xsl:if><xsl:value-of select="./xdf3:objekt/xdf3:id"/> (<xsl:value-of select="./xdf3:praedikat/code"/>)<xsl:if test="fn:position() != fn:last()"><xsl:text>, </xsl:text></xsl:if>
				</xsl:for-each></xsl:variable>

			<xsl:if test="$OriginalwerteDoku = '2' or $OriginalwerteDoku = '3'">
				<xsl:comment>
					<xsl:value-of select="$BeschreibungNeu"/>
				</xsl:comment>
			</xsl:if>

			<xsl:apply-templates select="./xdf3:identifikation"/>

			<xdf:name><xsl:value-of select="./xdf3:name"/></xdf:name>

			<xdf:bezeichnungEingabe><xsl:value-of select="./xdf3:bezeichnung"/></xdf:bezeichnungEingabe>

			<xsl:variable name="BeschreibungAlt"><xsl:choose><xsl:when test="$XDF2WerteErhalten = '0' and fn:contains(./xdf3:beschreibung/text(), 'Originalwerte der XDF2-Datei:')"><xsl:value-of select="fn:substring-before(./xdf3:beschreibung/text(), 'Originalwerte der XDF2-Datei:')"/></xsl:when><xsl:otherwise><xsl:value-of select="./xdf3:beschreibung"/></xsl:otherwise></xsl:choose></xsl:variable>

			<xsl:choose>
				<xsl:when test="$OriginalwerteDoku = '1' or $OriginalwerteDoku = '3'">
					<xdf:beschreibung><xsl:if test="not(empty($BeschreibungAlt))"><xsl:value-of select="$BeschreibungAlt"/><xsl:text>
					</xsl:text></xsl:if><xsl:value-of select="$BeschreibungNeu"/></xdf:beschreibung>
				</xsl:when>
				<xsl:otherwise>
					<xsl:if test="not(empty($BeschreibungAlt))"><xdf:beschreibung><xsl:value-of select="$BeschreibungAlt"/></xdf:beschreibung></xsl:if>
				</xsl:otherwise>
			</xsl:choose>

			<xdf:definition><xsl:value-of select="./xdf3:definition"/></xdf:definition>

			<xsl:call-template name="bezug">
				<xsl:with-param name="Element" select="."/>
			</xsl:call-template>

			<xsl:apply-templates select="./xdf3:freigabestatus"/>
			
			<xsl:if test="not(empty(./xdf3:gueltigAb/text()))">
				<xdf:gueltigAb><xsl:value-of select="./xdf3:gueltigAb"/></xdf:gueltigAb>
			</xsl:if>

			<xsl:if test="not(empty(./xdf3:gueltigBis/text()))">
				<xdf:gueltigBis><xsl:value-of select="./xdf3:gueltigBis"/></xdf:gueltigBis>
			</xsl:if>

			<xsl:if test="not(empty(./xdf3:statusGesetztDurch/text()))">
				<xdf:fachlicherErsteller><xsl:value-of select="./xdf3:statusGesetztDurch"/></xdf:fachlicherErsteller>
			</xsl:if>

			<xsl:if test="not(empty(./xdf3:versionshinweis/text()))">
				<xdf:versionshinweis><xsl:value-of select="./xdf3:versionshinweis"/></xdf:versionshinweis>
			</xsl:if>

			<xsl:if test="not(empty(./xdf3:statusGesetztAm/text())) and (./xdf3:freigabestatus/code/text() = '6')">
				<xdf:freigabedatum><xsl:value-of select="./xdf3:statusGesetztAm"/></xdf:freigabedatum>
			</xsl:if>
			
			<xsl:if test="not(empty(./xdf3:veroeffentlichungsdatum/text()))">
				<xdf:veroeffentlichungsdatum><xsl:value-of select="./xdf3:veroeffentlichungsdatum"/></xdf:veroeffentlichungsdatum>
			</xsl:if>
			
			<xsl:if test="not(empty(./xdf3:hilfetext/text()))">
				<xdf:hilfetext><xsl:value-of select="./xdf3:hilfetext"/></xdf:hilfetext>
			</xsl:if>

			<xdf:ableitungsmodifikationenStruktur listURI="urn:xoev-de:fim:codeliste:xdatenfelder.ableitungsmodifikationenStruktur" listVersionID="1.0">
				<code><xsl:value-of select="./xdf3:ableitungsmodifikationenStruktur/code"/></code>
			</xdf:ableitungsmodifikationenStruktur>

			<xdf:ableitungsmodifikationenRepraesentation listURI="urn:xoev-de:fim:codeliste:xdatenfelder.ableitungsmodifikationenRepraesentation" listVersionID="1.0">
				<code><xsl:value-of select="./xdf3:ableitungsmodifikationenRepraesentation/code"/></code>
			</xdf:ableitungsmodifikationenRepraesentation>
			
			<xsl:for-each select="./xdf3:regel">
				<xsl:apply-templates select="."/>
			</xsl:for-each>

			<xsl:for-each select="./xdf3:struktur">
				<xsl:apply-templates select="."/>
			</xsl:for-each>
			
		</xdf:stammdatenschema>
	</xsl:template>
	
	<!-- ############################################################################################################# -->
	
	<xsl:template match="xdf3:dokumentsteckbrief">
		
		<xsl:if test="$DebugMode = '2' or $DebugMode = '3' or $DebugMode = '4'">
			<xsl:message>
				++++ dokumentsteckbrief ++++
				Datenschema: <xsl:value-of select="./xdf3:identifikation/xdf3:id"/>
			</xsl:message>
		</xsl:if>

		<xdf:dokumentensteckbrief>

			<xsl:variable name="BeschreibungNeu">
				Originalwerte der XDF3-Datei:
				ID: <xsl:value-of select="./xdf3:identifikation/xdf3:id"/><xsl:if test="not(empty(./xdf3:identifikation/xdf3:version/text()))">
				Version: <xsl:value-of select="./xdf3:identifikation/xdf3:version"/></xsl:if><xsl:if test="not(empty(./xdf3:freigabestatus/code/text()))">
				Status: <xsl:call-template name="freigabestatus"><xsl:with-param name="Element" select="./xdf3:freigabestatus"/></xsl:call-template></xsl:if><xsl:if test="not(empty(./xdf3:statusGesetztAm/text()))">
				Status gesetzt am: <xsl:value-of select="./xdf3:statusGesetztAm"/></xsl:if><xsl:if test="not(empty(./xdf3:letzteAenderung/text()))">
				Letzte Änderung: <xsl:value-of select="./xdf3:letzteAenderung"/></xsl:if>							
				<xsl:for-each select="./xdf3:stichwort">
				<xsl:if test="fn:position() = 1">
				Stichwörter:<xsl:text> 
				</xsl:text></xsl:if><xsl:value-of select="."/><xsl:if test="./@uri"> (<xsl:value-of select="./@uri"/>)</xsl:if><xsl:if test="fn:position() != fn:last()"><xsl:text>, </xsl:text></xsl:if>
				</xsl:for-each>
				<xsl:for-each select="./xdf3:relation[xdf3:praedikat/code != 'VKN']">
				<xsl:if test="fn:position() = 1">
				Relationen:<xsl:text> 
				</xsl:text></xsl:if><xsl:value-of select="./xdf3:objekt/xdf3:id"/> (<xsl:value-of select="./xdf3:praedikat/code"/>)<xsl:if test="fn:position() != fn:last()"><xsl:text>, </xsl:text></xsl:if>
				</xsl:for-each>
				<xsl:for-each select="./xdf3:relation[xdf3:praedikat/code = 'VKN']">
				<xsl:if test="fn:position() = 1">
				Zugeordnete Dokumentsteckbriefe:<xsl:text> 
				</xsl:text></xsl:if><xsl:value-of select="./xdf3:objekt/xdf3:id"/><xsl:if test="fn:position() != fn:last()"><xsl:text>, </xsl:text></xsl:if>
				</xsl:for-each></xsl:variable>

			<xsl:if test="$OriginalwerteDoku = '2' or $OriginalwerteDoku = '3'">
				<xsl:comment>
					<xsl:value-of select="$BeschreibungNeu"/>
				</xsl:comment>
			</xsl:if>

			<xsl:apply-templates select="./xdf3:identifikation"/>

			<xdf:name><xsl:value-of select="./xdf3:name"/></xdf:name>

			<xdf:bezeichnungEingabe><xsl:value-of select="./xdf3:bezeichnung"/></xdf:bezeichnungEingabe>

			<xsl:variable name="BeschreibungAlt"><xsl:choose><xsl:when test="$XDF2WerteErhalten = '0' and fn:contains(./xdf3:beschreibung/text(), 'Originalwerte der XDF2-Datei:')"><xsl:value-of select="fn:substring-before(./xdf3:beschreibung/text(), 'Originalwerte der XDF2-Datei:')"/></xsl:when><xsl:otherwise><xsl:value-of select="./xdf3:beschreibung"/></xsl:otherwise></xsl:choose></xsl:variable>

			<xsl:choose>
				<xsl:when test="$OriginalwerteDoku = '1' or $OriginalwerteDoku = '3'">
					<xdf:beschreibung><xsl:if test="not(empty($BeschreibungAlt))"><xsl:value-of select="$BeschreibungAlt"/><xsl:text>
					</xsl:text></xsl:if><xsl:value-of select="$BeschreibungNeu"/></xdf:beschreibung>
				</xsl:when>
				<xsl:otherwise>
					<xsl:if test="not(empty($BeschreibungAlt))"><xdf:beschreibung><xsl:value-of select="$BeschreibungAlt"/></xdf:beschreibung></xsl:if>
				</xsl:otherwise>
			</xsl:choose>

			<xdf:definition><xsl:value-of select="./xdf3:definition"/></xdf:definition>

			<xsl:call-template name="bezug">
				<xsl:with-param name="Element" select="."/>
			</xsl:call-template>

			<xsl:apply-templates select="./xdf3:freigabestatus"/>
			
			<xsl:if test="not(empty(./xdf3:gueltigAb/text()))">
				<xdf:gueltigAb><xsl:value-of select="./xdf3:gueltigAb"/></xdf:gueltigAb>
			</xsl:if>

			<xsl:if test="not(empty(./xdf3:gueltigBis/text()))">
				<xdf:gueltigBis><xsl:value-of select="./xdf3:gueltigBis"/></xdf:gueltigBis>
			</xsl:if>

			<xsl:if test="not(empty(./xdf3:statusGesetztDurch/text()))">
				<xdf:fachlicherErsteller><xsl:value-of select="./xdf3:statusGesetztDurch"/></xdf:fachlicherErsteller>
			</xsl:if>

			<xsl:if test="not(empty(./xdf3:versionshinweis/text()))">
				<xdf:versionshinweis><xsl:value-of select="./xdf3:versionshinweis"/></xdf:versionshinweis>
			</xsl:if>

			<xsl:if test="not(empty(./xdf3:statusGesetztAm/text())) and (./xdf3:freigabestatus/code/text() = '6')">
				<xdf:freigabedatum><xsl:value-of select="./xdf3:statusGesetztAm"/></xdf:freigabedatum>
			</xsl:if>
			
			<xsl:if test="not(empty(./xdf3:veroeffentlichungsdatum/text()))">
				<xdf:veroeffentlichungsdatum><xsl:value-of select="./xdf3:veroeffentlichungsdatum"/></xdf:veroeffentlichungsdatum>
			</xsl:if>
			
			<xdf:isReferenz><xsl:value-of select="./xdf3:istAbstrakt"/></xdf:isReferenz>

			<xsl:apply-templates select="./xdf3:dokumentart"/>

			<xsl:if test="not(empty(./xdf3:hilfetext/text()))">
				<xdf:hilfetext><xsl:value-of select="./xdf3:hilfetext"/></xdf:hilfetext>
			</xsl:if>

		</xdf:dokumentensteckbrief>
	</xsl:template>
	
	<!-- ############################################################################################################# -->
	
	<xsl:template match="xdf3:regel">

		<xsl:if test="$DebugMode = '3' or $DebugMode = '4'">
			<xsl:message>
				++++ regel ++++
				Regel: <xsl:value-of select="./xdf3:identifikation/xdf3:id"/>
			</xsl:message>
		</xsl:if>

		<xdf:regel>
			<xsl:variable name="BeschreibungNeu">
				Originalwerte der XDF3-Datei:
				ID: <xsl:value-of select="./xdf3:identifikation/xdf3:id"/><xsl:if test="not(empty(./xdf3:identifikation/xdf3:version/text()))">
				Version: <xsl:value-of select="./xdf3:identifikation/xdf3:version"/></xsl:if><xsl:if test="not(empty(./xdf3:letzteAenderung/text()))">
				Letzte Änderung: <xsl:value-of select="./xdf3:letzteAenderung"/></xsl:if><xsl:if test="not(empty(./xdf3:skript/text()))"><xsl:text>
				</xsl:text>Skript:<xsl:text>
				</xsl:text><xsl:value-of select="./xdf3:skript"/></xsl:if><xsl:for-each select="./xdf3:stichwort">
				<xsl:if test="fn:position() = 1">
				Stichwörter:<xsl:text> 
				</xsl:text></xsl:if><xsl:value-of select="."/><xsl:if test="./@uri"> (<xsl:value-of select="./@uri"/>)</xsl:if><xsl:if test="fn:position() != fn:last()"><xsl:text>, </xsl:text></xsl:if>
				</xsl:for-each>
				<xsl:for-each select="./xdf3:relation[xdf3:praedikat/code != 'VKN']">
				<xsl:if test="fn:position() = 1">
				Relationen:<xsl:text> 
				</xsl:text></xsl:if><xsl:value-of select="./xdf3:objekt/xdf3:id"/> (<xsl:value-of select="./xdf3:praedikat/code"/>)<xsl:if test="fn:position() != fn:last()"><xsl:text>, </xsl:text></xsl:if>
				</xsl:for-each></xsl:variable>

			<xsl:if test="$OriginalwerteDoku = '2' or $OriginalwerteDoku = '3'">
				<xsl:comment>
					<xsl:value-of select="$BeschreibungNeu"/>
				</xsl:comment>
			</xsl:if>

			<xsl:apply-templates select="./xdf3:identifikation"/>

			<xdf:name><xsl:value-of select="./xdf3:name"/></xdf:name>

			<xdf:bezeichnungEingabe/>

			<xsl:variable name="BeschreibungAlt"><xsl:choose><xsl:when test="$XDF2WerteErhalten = '0' and fn:contains(./xdf3:beschreibung/text(), 'Originalwerte der XDF2-Datei:')"><xsl:value-of select="fn:substring-before(./xdf3:beschreibung/text(), 'Originalwerte der XDF2-Datei:')"/></xsl:when><xsl:otherwise><xsl:value-of select="./xdf3:beschreibung"/></xsl:otherwise></xsl:choose></xsl:variable>

			<xsl:choose>
				<xsl:when test="$OriginalwerteDoku = '1' or $OriginalwerteDoku = '3'">
					<xdf:beschreibung><xsl:if test="not(empty($BeschreibungAlt))"><xsl:value-of select="$BeschreibungAlt"/><xsl:text>
					</xsl:text></xsl:if><xsl:value-of select="$BeschreibungNeu"/></xdf:beschreibung>
				</xsl:when>
				<xsl:otherwise>
					<xsl:if test="not(empty($BeschreibungAlt))"><xdf:beschreibung><xsl:value-of select="$BeschreibungAlt"/></xdf:beschreibung></xsl:if>
				</xsl:otherwise>
			</xsl:choose>

			<xsl:if test="not(empty(./xdf3:freitextRegel/text()))">
				<xsl:choose>
					<xsl:when test="$FreitextRegelKorrektur ='1'">

						<xdf:definition>
							<xsl:analyze-string regex="[F|G]\d{{8}}" select="./xdf3:freitextRegel">
								<xsl:matching-substring>
									<xsl:value-of select="fn:substring(.,1,3)"/><xsl:value-of select="fn:substring(.,7,6)"/>
								</xsl:matching-substring>
								<xsl:non-matching-substring>
									<xsl:value-of select="."/>
								</xsl:non-matching-substring>
							</xsl:analyze-string>
						</xdf:definition>

					</xsl:when>
					<xsl:otherwise>
						<xdf:definition><xsl:value-of select="./xdf3:freitextRegel"/></xdf:definition>
					</xsl:otherwise>
				</xsl:choose>
			</xsl:if>

			<xsl:call-template name="bezug">
				<xsl:with-param name="Element" select="."/>
			</xsl:call-template>

			<xsl:apply-templates select="../xdf3:freigabestatus"/>

			<xsl:if test="not(empty(./xdf3:fachlicherErsteller/text()))">
				<xdf:fachlicherErsteller><xsl:value-of select="./xdf3:fachlicherErsteller"/></xdf:fachlicherErsteller>
			</xsl:if>

			<xdf:script>function script() {
			
			}</xdf:script>

		</xdf:regel>
	</xsl:template>

	<!-- ############################################################################################################# -->
	
	<xsl:template match="xdf3:struktur">

		<xsl:if test="$DebugMode = '3' or $DebugMode = '4'">
			<xsl:message>
				++++ struktur ++++
			</xsl:message>
		</xsl:if>

		<xdf:struktur>
			<xdf:anzahl><xsl:value-of select="./xdf3:anzahl"/></xdf:anzahl>

			<xsl:call-template name="bezug">
				<xsl:with-param name="Element" select="."/>
			</xsl:call-template>

			<xdf:enthaelt>
				<xsl:apply-templates select="./xdf3:enthaelt/xdf3:datenfeld | ./xdf3:enthaelt/xdf3:datenfeldgruppe"/>
			</xdf:enthaelt>
			
		</xdf:struktur>
	</xsl:template>

	<!-- ############################################################################################################# -->
	
	<xsl:template match="xdf3:datenfeld">

		<xsl:if test="$DebugMode = '2' or $DebugMode = '3' or $DebugMode = '4'">
			<xsl:message>
				++++ datenfeld ++++
				Datenfeld: <xsl:value-of select="./xdf3:identifikation/xdf3:id"/>
			</xsl:message>
		</xsl:if>

		<xsl:if test="$HiddenWeglassen = '1' or ./xdf3:feldart/code/text() != 'hidden'">
			<xdf:datenfeld>

				<xsl:variable name="RichtigeVersion">
					<xsl:choose>
						<xsl:when test="not(./xdf3:codelisteReferenz)">leer</xsl:when>
						<xsl:when test="empty(./xdf3:codelisteReferenz/xdf3:version/text())">
							<xsl:variable name="CodelisteAbfrageURL" select="fn:concat($XMLXRepoOhneVersionPfadPrefix,./xdf3:codelisteReferenz/xdf3:canonicalIdentification,$XMLXRepoOhneVersionPfadPostfix)"/>
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
								<xsl:when test="fn:string-length($CodelisteAbfrageInhalt) &lt; 10">leer</xsl:when>
								<xsl:otherwise><xsl:value-of select="$CodelisteAbfrageInhalt/dat:VersionCodeliste/dat:version"/></xsl:otherwise>
							</xsl:choose>
						</xsl:when>
						<xsl:otherwise><xsl:value-of select="./xdf3:codelisteReferenz/xdf3:version"/></xsl:otherwise>
					</xsl:choose>
				</xsl:variable>

				<xsl:variable name="InternalID"><xsl:call-template name="CodelistID"><xsl:with-param name="Identifikation" select="./xdf3:identifikation"/></xsl:call-template></xsl:variable>

				<xsl:variable name="BeschreibungNeu">
					Originalwerte der XDF3-Datei:
					ID: <xsl:value-of select="./xdf3:identifikation/xdf3:id"/><xsl:if test="not(empty(./xdf3:identifikation/xdf3:version/text()))">
					Version: <xsl:value-of select="./xdf3:identifikation/xdf3:version"/></xsl:if><xsl:if test="not(empty(./xdf3:freigabestatus/code/text()))">
					Status: <xsl:call-template name="freigabestatus"><xsl:with-param name="Element" select="./xdf3:freigabestatus"/></xsl:call-template></xsl:if><xsl:if test="not(empty(./xdf3:statusGesetztAm/text()))">
					Status gesetzt am: <xsl:value-of select="./xdf3:statusGesetztAm"/></xsl:if><xsl:if test="not(empty(./xdf3:letzteAenderung/text()))">
					Letzte Änderung: <xsl:value-of select="./xdf3:letzteAenderung"/></xsl:if>
					<xsl:for-each select="./xdf3:stichwort">
					<xsl:if test="fn:position() = 1">
					Stichwörter:<xsl:text> 
					</xsl:text></xsl:if><xsl:value-of select="."/><xsl:if test="./@uri"> (<xsl:value-of select="./@uri"/>)</xsl:if><xsl:if test="fn:position() != fn:last()"><xsl:text>, </xsl:text></xsl:if>
					</xsl:for-each>
					<xsl:for-each select="./xdf3:relation[xdf3:praedikat/code != 'VKN']">
					<xsl:if test="fn:position() = 1">
					Relationen:<xsl:text> 
					</xsl:text></xsl:if><xsl:value-of select="./xdf3:objekt/xdf3:id"/> (<xsl:value-of select="./xdf3:praedikat/code"/>)<xsl:if test="fn:position() != fn:last()"><xsl:text>, </xsl:text></xsl:if>
					</xsl:for-each><xsl:if test="./xdf3:feldart/code/text() = 'locked' or ./xdf3:feldart/code/text() = 'hidden'">
					Feldart: <xsl:apply-templates select="./xdf3:feldart"/></xsl:if><xsl:if test="./xdf3:datentyp/code/text() = 'text_latin' or ./xdf3:datentyp/code/text() = 'time' or ./xdf3:datentyp/code/text() = 'datetime'">
					Datentyp: <xsl:apply-templates select="./xdf3:datentyp"/></xsl:if><xsl:if test="not(empty(./xdf3:vorbefuellung/text()))">
					Vorbefüllungswert: <xsl:value-of select="./xdf3:vorbefuellung"/></xsl:if><xsl:if test="not(empty(./xdf3:maxSize/text()))">
					Maximale Dateigröße: <xsl:value-of select="number(./xdf3:maxSize) div 1000000"/> MB</xsl:if><xsl:if test="./xdf3:mediaType">
					Erlaubte Dateitypen: <xsl:for-each select="./xdf3:mediaType"><xsl:value-of select="."/><xsl:if test="fn:position() != fn:last()"><xsl:text>; </xsl:text></xsl:if></xsl:for-each></xsl:if><xsl:choose>
					<xsl:when test="./xdf3:codelisteReferenz"><xsl:text>
					</xsl:text><xsl:choose>
						<xsl:when test="$RichtigeVersion ='leer'">Codeliste <xsl:value-of select="$InternalID"/>: Die Inhalte werden über die externe Codeliste <xsl:value-of select="./xdf3:codelisteReferenz/xdf3:canonicalIdentification"/><xsl:if test="not(empty(./xdf3:codelisteReferenz/xdf3:version/text()))"> mit Version <xsl:value-of select="./xdf3:codelisteReferenz/xdf3:version"/></xsl:if> spezifiziert. ACHTUNG: Dazu konnte keine Codeliste geladen werden. Es wurde keine Genericode-Datei erzeugt!</xsl:when>
						<xsl:when test="empty(./xdf3:codelisteReferenz/xdf3:version/text())">Codeliste <xsl:value-of select="$InternalID"/>: Die Inhalte werden über die externe Codeliste <xsl:value-of select="./xdf3:codelisteReferenz/xdf3:canonicalIdentification"/> ohne Versionsangabe spezifiziert. Es wurde daher die aktuellste Version <xsl:value-of select="$RichtigeVersion"/> der Codeliste verwendet.</xsl:when>
						<xsl:otherwise>Codeliste <xsl:value-of select="$InternalID"/>: Die Inhalte werden über die externe Codeliste <xsl:value-of select="./xdf3:codelisteReferenz/xdf3:canonicalIdentification"/> mit Version <xsl:value-of select="./xdf3:codelisteReferenz/xdf3:version"/> spezifiziert.</xsl:otherwise>
					</xsl:choose></xsl:when><xsl:when test="./xdf3:werte"><xsl:text>
					</xsl:text>Codeliste <xsl:value-of select="$InternalID"/>: Die Inhalte wurden über eine interne Werteliste spezifiziert.</xsl:when>
					</xsl:choose></xsl:variable>

				<xsl:if test="$OriginalwerteDoku = '2' or $OriginalwerteDoku = '3'">
					<xsl:comment>
						<xsl:value-of select="$BeschreibungNeu"/>
					</xsl:comment>
				</xsl:if>

				<xsl:apply-templates select="./xdf3:identifikation"/>
	
				<xdf:name><xsl:value-of select="./xdf3:name"/></xdf:name>
	
				<xdf:bezeichnungEingabe><xsl:value-of select="./xdf3:bezeichnungEingabe"/></xdf:bezeichnungEingabe>
	
				<xsl:if test="not(empty(./xdf3:bezeichnungAusgabe/text()))">
					<xdf:bezeichnungAusgabe><xsl:value-of select="./xdf3:bezeichnungAusgabe"/></xdf:bezeichnungAusgabe>
				</xsl:if>
	
				<xsl:variable name="BeschreibungAlt"><xsl:choose><xsl:when test="$XDF2WerteErhalten = '0' and fn:contains(./xdf3:beschreibung/text(), 'Originalwerte der XDF2-Datei:')"><xsl:value-of select="fn:substring-before(./xdf3:beschreibung/text(), 'Originalwerte der XDF2-Datei:')"/></xsl:when><xsl:otherwise><xsl:value-of select="./xdf3:beschreibung"/></xsl:otherwise></xsl:choose></xsl:variable>
	
				<xsl:choose>
					<xsl:when test="$OriginalwerteDoku = '1' or $OriginalwerteDoku = '3'">
						<xdf:beschreibung><xsl:if test="not(empty($BeschreibungAlt))"><xsl:value-of select="$BeschreibungAlt"/><xsl:text>
						</xsl:text></xsl:if><xsl:value-of select="$BeschreibungNeu"/></xdf:beschreibung>
					</xsl:when>
					<xsl:otherwise>
						<xsl:if test="not(empty($BeschreibungAlt))"><xdf:beschreibung><xsl:value-of select="$BeschreibungAlt"/></xdf:beschreibung></xsl:if>
					</xsl:otherwise>
				</xsl:choose>
	
				<xdf:definition><xsl:value-of select="./xdf3:definition"/></xdf:definition>
	
				<xsl:call-template name="bezug">
					<xsl:with-param name="Element" select="."/>
				</xsl:call-template>
	
				<xsl:apply-templates select="./xdf3:freigabestatus"/>
	
				<xsl:if test="not(empty(./xdf3:gueltigAb/text()))">
					<xdf:gueltigAb><xsl:value-of select="./xdf3:gueltigAb"/></xdf:gueltigAb>
				</xsl:if>
	
				<xsl:if test="not(empty(./xdf3:gueltigBis/text()))">
					<xdf:gueltigBis><xsl:value-of select="./xdf3:gueltigBis"/></xdf:gueltigBis>
				</xsl:if>
	
				<xsl:if test="not(empty(./xdf3:statusGesetztDurch/text()))">
					<xdf:fachlicherErsteller><xsl:value-of select="./xdf3:statusGesetztDurch"/></xdf:fachlicherErsteller>
				</xsl:if>
	
				<xsl:if test="not(empty(./xdf3:versionshinweis/text()))">
					<xdf:versionshinweis><xsl:value-of select="./xdf3:versionshinweis"/></xdf:versionshinweis>
				</xsl:if>
	
				<xsl:if test="not(empty(./xdf3:statusGesetztAm/text())) and (./xdf3:freigabestatus/code/text() = '6')">
					<xdf:freigabedatum><xsl:value-of select="./xdf3:statusGesetztAm"/></xdf:freigabedatum>
				</xsl:if>
				
				<xsl:if test="not(empty(./xdf3:veroeffentlichungsdatum/text()))">
					<xdf:veroeffentlichungsdatum><xsl:value-of select="./xdf3:veroeffentlichungsdatum"/></xdf:veroeffentlichungsdatum>
				</xsl:if>
				
				<xdf:schemaelementart listURI="urn:xoev-de:fim:codeliste:xdatenfelder.schemaelementart" listVersionID="1.0">
					<code><xsl:value-of select="./xdf3:schemaelementart/code"/></code>
				</xdf:schemaelementart>
	
				<xdf:hilfetextEingabe><xsl:value-of select="./xdf3:hilfetextEingabe"/></xdf:hilfetextEingabe>
	
				<xdf:hilfetextAusgabe><xsl:value-of select="./xdf3:hilfetextAusgabe"/></xdf:hilfetextAusgabe>
	
				<xsl:choose>
					<xsl:when test="./xdf3:feldart/code/text() = 'locked' or ./xdf3:feldart/code/text() = 'hidden'">
						<xdf:feldart listURI="urn:xoev-de:fim:codeliste:xdatenfelder.feldart" listVersionID="1.0">
							<code>label</code>
						</xdf:feldart>
					</xsl:when>
					<xsl:otherwise>
						<xdf:feldart listURI="urn:xoev-de:fim:codeliste:xdatenfelder.feldart" listVersionID="1.0">
							<code><xsl:value-of select="./xdf3:feldart/code"/></code>
						</xdf:feldart>
					</xsl:otherwise>
				</xsl:choose>
	
				<xdf:datentyp listURI="urn:xoev-de:fim:codeliste:xdatenfelder.datentyp" listVersionID="1.0">
					<xsl:choose>
						<xsl:when test="./xdf3:datentyp/code/text() = 'text_latin' or ./xdf3:datentyp/code/text() = 'time' or ./xdf3:datentyp/code/text() = 'datetime'">
							<code>text</code>
						</xsl:when>
						<xsl:otherwise>
							<code><xsl:value-of select="./xdf3:datentyp/code"/></code>
						</xsl:otherwise>
					</xsl:choose>
				</xdf:datentyp>
				
				<xsl:call-template name="praezisierung">
					<xsl:with-param name="Element" select="./xdf3:praezisierung"/>
				</xsl:call-template>
	
				<xdf:inhalt><xsl:value-of select="./xdf3:inhalt"/></xdf:inhalt>

				<xsl:apply-templates select="./xdf3:codelisteReferenz"/>

				<xsl:apply-templates select="./xdf3:werte"/>

				<xsl:for-each select="./xdf3:regel">
					<xsl:apply-templates select="."/>
				</xsl:for-each>

			</xdf:datenfeld>
		</xsl:if>
		
	</xsl:template>

	<!-- ############################################################################################################# -->
	
	<xsl:template match="xdf3:datenfeldgruppe">

		<xsl:if test="$DebugMode = '2' or $DebugMode = '3' or $DebugMode = '4'">
			<xsl:message>
				++++ datenfeldgruppe ++++
				Datenfeldgruppe: <xsl:value-of select="./xdf3:identifikation/xdf3:id"/>
			</xsl:message>
		</xsl:if>

		<xdf:datenfeldgruppe>

			<xsl:variable name="BeschreibungNeu">
				Originalwerte der XDF3-Datei:
				ID: <xsl:value-of select="./xdf3:identifikation/xdf3:id"/><xsl:if test="not(empty(./xdf3:identifikation/xdf3:version/text()))">
				Version: <xsl:value-of select="./xdf3:identifikation/xdf3:version"/></xsl:if><xsl:if test="not(empty(./xdf3:freigabestatus/code/text()))">
				Status: <xsl:call-template name="freigabestatus"><xsl:with-param name="Element" select="./xdf3:freigabestatus"/></xsl:call-template></xsl:if><xsl:if test="not(empty(./xdf3:statusGesetztAm/text()))">
				Status gesetzt am: <xsl:value-of select="./xdf3:statusGesetztAm"/></xsl:if><xsl:if test="not(empty(./xdf3:letzteAenderung/text()))">
				Letzte Änderung: <xsl:value-of select="./xdf3:letzteAenderung"/></xsl:if>
				<xsl:for-each select="./xdf3:stichwort">
				<xsl:if test="fn:position() = 1">
				Stichwörter:<xsl:text> 
				</xsl:text></xsl:if><xsl:value-of select="."/><xsl:if test="./@uri"> (<xsl:value-of select="./@uri"/>)</xsl:if><xsl:if test="fn:position() != fn:last()"><xsl:text>, </xsl:text></xsl:if>
				</xsl:for-each>
				<xsl:for-each select="./xdf3:relation[xdf3:praedikat/code != 'VKN']">
				<xsl:if test="fn:position() = 1">
				Relationen:<xsl:text> 
				</xsl:text></xsl:if><xsl:value-of select="./xdf3:objekt/xdf3:id"/> (<xsl:value-of select="./xdf3:praedikat/code"/>)<xsl:if test="fn:position() != fn:last()"><xsl:text>, </xsl:text></xsl:if>
				</xsl:for-each><xsl:if test="./xdf3:art/code/text() ='X'"><xsl:text>
				</xsl:text>ACHTUNG: Die Feldgruppe ist als Auswahlgruppe definiert.</xsl:if></xsl:variable>

			<xsl:if test="$OriginalwerteDoku = '2' or $OriginalwerteDoku = '3'">
				<xsl:comment>
					<xsl:value-of select="$BeschreibungNeu"/>
				</xsl:comment>
			</xsl:if>

			<xsl:apply-templates select="./xdf3:identifikation"/>

			<xdf:name><xsl:value-of select="./xdf3:name"/></xdf:name>

			<xdf:bezeichnungEingabe><xsl:value-of select="./xdf3:bezeichnungEingabe"/></xdf:bezeichnungEingabe>

			<xsl:if test="not(empty(./xdf3:bezeichnungAusgabe/text()))">
				<xdf:bezeichnungAusgabe><xsl:value-of select="./xdf3:bezeichnungAusgabe"/></xdf:bezeichnungAusgabe>
			</xsl:if>

			<xsl:variable name="BeschreibungAlt"><xsl:choose><xsl:when test="$XDF2WerteErhalten = '0' and fn:contains(./xdf3:beschreibung/text(), 'Originalwerte der XDF2-Datei:')"><xsl:value-of select="fn:substring-before(./xdf3:beschreibung/text(), 'Originalwerte der XDF2-Datei:')"/></xsl:when><xsl:otherwise><xsl:value-of select="./xdf3:beschreibung"/></xsl:otherwise></xsl:choose></xsl:variable>

			<xsl:choose>
				<xsl:when test="$OriginalwerteDoku = '1' or $OriginalwerteDoku = '3'">
					<xdf:beschreibung><xsl:if test="not(empty($BeschreibungAlt))"><xsl:value-of select="$BeschreibungAlt"/><xsl:text>
					</xsl:text></xsl:if><xsl:value-of select="$BeschreibungNeu"/></xdf:beschreibung>
				</xsl:when>
				<xsl:otherwise>
					<xsl:if test="not(empty($BeschreibungAlt))"><xdf:beschreibung><xsl:value-of select="$BeschreibungAlt"/></xdf:beschreibung></xsl:if>
				</xsl:otherwise>
			</xsl:choose>

			<xdf:definition><xsl:value-of select="./xdf3:definition"/></xdf:definition>

			<xsl:call-template name="bezug">
				<xsl:with-param name="Element" select="."/>
			</xsl:call-template>

			<xsl:apply-templates select="./xdf3:freigabestatus"/>

			<xsl:if test="not(empty(./xdf3:gueltigAb/text()))">
				<xdf:gueltigAb><xsl:value-of select="./xdf3:gueltigAb"/></xdf:gueltigAb>
			</xsl:if>

			<xsl:if test="not(empty(./xdf3:gueltigBis/text()))">
				<xdf:gueltigBis><xsl:value-of select="./xdf3:gueltigBis"/></xdf:gueltigBis>
			</xsl:if>

			<xsl:if test="not(empty(./xdf3:statusGesetztDurch/text()))">
				<xdf:fachlicherErsteller><xsl:value-of select="./xdf3:statusGesetztDurch"/></xdf:fachlicherErsteller>
			</xsl:if>

			<xsl:if test="not(empty(./xdf3:versionshinweis/text()))">
				<xdf:versionshinweis><xsl:value-of select="./xdf3:versionshinweis"/></xdf:versionshinweis>
			</xsl:if>

			<xsl:if test="not(empty(./xdf3:statusGesetztAm/text())) and (./xdf3:freigabestatus/code/text() = '6')">
				<xdf:freigabedatum><xsl:value-of select="./xdf3:statusGesetztAm"/></xdf:freigabedatum>
			</xsl:if>
			
			<xsl:if test="not(empty(./xdf3:veroeffentlichungsdatum/text()))">
				<xdf:veroeffentlichungsdatum><xsl:value-of select="./xdf3:veroeffentlichungsdatum"/></xdf:veroeffentlichungsdatum>
			</xsl:if>
			
			<xdf:schemaelementart listURI="urn:xoev-de:fim:codeliste:xdatenfelder.schemaelementart" listVersionID="1.0">
				<code><xsl:value-of select="./xdf3:schemaelementart/code"/></code>
			</xdf:schemaelementart>

			<xdf:hilfetextEingabe><xsl:value-of select="./xdf3:hilfetextEingabe"/></xdf:hilfetextEingabe>

			<xdf:hilfetextAusgabe><xsl:value-of select="./xdf3:hilfetextAusgabe"/></xdf:hilfetextAusgabe>

			<xsl:for-each select="./xdf3:regel">
				<xsl:apply-templates select="."/>
			</xsl:for-each>

			<xsl:for-each select="./xdf3:struktur">
				<xsl:apply-templates select="."/>
			</xsl:for-each>

		</xdf:datenfeldgruppe>
	</xsl:template>

	<!-- ############################################################################################################# -->
	
	<xsl:template match="xdf3:identifikation">

		<xsl:if test="$DebugMode = '3' or $DebugMode = '4'">
			<xsl:message>
				++++ identifikation ++++
			</xsl:message>
		</xsl:if>

		<xdf:identifikation>
			<xdf:id><xsl:value-of select="fn:substring(./xdf3:id,1,3)"/><xsl:value-of select="fn:substring(./xdf3:id,7)"/></xdf:id>

			<xsl:if test="not(empty(./xdf3:version/text()))">
				<xsl:variable name="XDF3Version" select="./xdf3:version"/>
				
				<xsl:variable name="VersionMajor"><xsl:value-of select="(tokenize($XDF3Version,'\.'))[1]"/></xsl:variable>
				<xsl:variable name="VersionMinorAlt"><xsl:value-of select="(tokenize($XDF3Version,'\.'))[2]"/></xsl:variable>
				<xsl:variable name="VersionMicroAlt"><xsl:value-of select="(tokenize($XDF3Version,'\.'))[3]"/></xsl:variable>

				<xsl:variable name="VersionMinorNeu">
					<xsl:choose>
						<xsl:when test="fn:number($VersionMicroAlt) = 0">
							<xsl:value-of select="$VersionMinorAlt"/>
						</xsl:when>
						<xsl:otherwise>
							<xsl:choose>
								<xsl:when test="fn:number($VersionMinorAlt) &gt; 99"><xsl:value-of select="$VersionMinorAlt"/></xsl:when>
								<xsl:when test="fn:number($VersionMinorAlt) &gt; 9">0<xsl:value-of select="$VersionMinorAlt"/></xsl:when>
								<xsl:otherwise>00<xsl:value-of select="$VersionMinorAlt"/></xsl:otherwise>
							</xsl:choose>
							<xsl:choose>
								<xsl:when test="fn:number($VersionMicroAlt) &gt; 99"><xsl:value-of select="$VersionMicroAlt"/></xsl:when>
								<xsl:when test="fn:number($VersionMicroAlt) &gt; 9">0<xsl:value-of select="$VersionMicroAlt"/></xsl:when>
								<xsl:otherwise>00<xsl:value-of select="$VersionMicroAlt"/></xsl:otherwise>
							</xsl:choose>
						</xsl:otherwise>
					</xsl:choose>
				</xsl:variable>
				<xdf:version><xsl:value-of select="$VersionMajor"/>.<xsl:value-of select="$VersionMinorNeu"/></xdf:version>
			</xsl:if>

		</xdf:identifikation>
	</xsl:template>

	<!-- ############################################################################################################# -->
	
	<xsl:template name="CodelistID">
		<xsl:param name="Identifikation"/>
		<xsl:variable name="TempID"><xsl:apply-templates select="$Identifikation/xdf3:id"/></xsl:variable><xsl:variable name="TempVersion"><xsl:apply-templates select="$Identifikation/xdf3:version"/></xsl:variable>C<xsl:value-of select="fn:substring($TempID,2)"/><xsl:if test="not(empty($TempVersion/text()))">V<xsl:value-of select="$TempVersion"/></xsl:if>
	</xsl:template>

	<!-- ############################################################################################################# -->
	
	<xsl:template match="xdf3:id">

		<xsl:if test="$DebugMode = '3' or $DebugMode = '4'">
			<xsl:message>
				++++ id ++++
			</xsl:message>
		</xsl:if>

		<xsl:value-of select="fn:substring(.,1,3)"/><xsl:value-of select="fn:substring(.,7)"/>

	</xsl:template>

	<!-- ############################################################################################################# -->
	
	<xsl:template match="xdf3:version">

		<xsl:if test="$DebugMode = '3' or $DebugMode = '4'">
			<xsl:message>
				++++ version ++++
			</xsl:message>
		</xsl:if>

			<xsl:if test="not(empty(./text()))">
				<xsl:variable name="XDF3Version" select="."/>
				
				<xsl:variable name="VersionMajor"><xsl:value-of select="(tokenize($XDF3Version,'\.'))[1]"/></xsl:variable>
				<xsl:variable name="VersionMinorAlt"><xsl:value-of select="(tokenize($XDF3Version,'\.'))[2]"/></xsl:variable>
				<xsl:variable name="VersionMicroAlt"><xsl:value-of select="(tokenize($XDF3Version,'\.'))[3]"/></xsl:variable>

				<xsl:variable name="VersionMinorNeu">
					<xsl:choose>
						<xsl:when test="fn:number($VersionMicroAlt) = 0">
							<xsl:value-of select="$VersionMinorAlt"/>
						</xsl:when>
						<xsl:otherwise>
							<xsl:choose>
								<xsl:when test="fn:number($VersionMinorAlt) &gt; 99"><xsl:value-of select="$VersionMinorAlt"/></xsl:when>
								<xsl:when test="fn:number($VersionMinorAlt) &gt; 9">0<xsl:value-of select="$VersionMinorAlt"/></xsl:when>
								<xsl:otherwise>00<xsl:value-of select="$VersionMinorAlt"/></xsl:otherwise>
							</xsl:choose>
							<xsl:choose>
								<xsl:when test="fn:number($VersionMicroAlt) &gt; 99"><xsl:value-of select="$VersionMicroAlt"/></xsl:when>
								<xsl:when test="fn:number($VersionMicroAlt) &gt; 9">0<xsl:value-of select="$VersionMicroAlt"/></xsl:when>
								<xsl:otherwise>00<xsl:value-of select="$VersionMicroAlt"/></xsl:otherwise>
							</xsl:choose>
						</xsl:otherwise>
					</xsl:choose>
				</xsl:variable>
				<xsl:value-of select="$VersionMajor"/>.<xsl:value-of select="$VersionMinorNeu"/>
			</xsl:if>
	</xsl:template>

	<!-- ############################################################################################################# -->
	
	<xsl:template name="bezug">
		<xsl:param name="Element"/>

		<xsl:if test="$DebugMode = '3' or $DebugMode = '4'">
			<xsl:message>
				++++ bezug ++++
			</xsl:message>
		</xsl:if>

		<xdf:bezug>
			<xsl:if test="$Element/xdf3:bezug">
				<xsl:for-each select="$Element/xdf3:bezug">
					<xsl:if test="$DebugMode = '4'">
						<xsl:message>
							Bezug: <xsl:value-of select="."/>
						</xsl:message>
					</xsl:if>
					<xsl:value-of select="fn:normalize-space(.)"/><xsl:if test="./@link and not(./@link='')"> (<xsl:value-of select="./@link"/>)</xsl:if>
					<xsl:if test="fn:position() != fn:last()"><xsl:text>; </xsl:text></xsl:if>
				</xsl:for-each>
			</xsl:if>
		</xdf:bezug>

	</xsl:template>

	<!-- ############################################################################################################# -->
	
	<xsl:template match="xdf3:freigabestatus">

		<xsl:if test="$DebugMode = '3' or $DebugMode = '4'">
			<xsl:message>
				++++ status ++++
			</xsl:message>
		</xsl:if>

			<xsl:choose>
				<xsl:when test=". = '7'">
					<xdf:status listURI="urn:xoev-de:fim:codeliste:xdatenfelder.status" listVersionID="1.0">
						<code>inaktiv</code>
					</xdf:status>
				</xsl:when>
				<xsl:otherwise>
					<xdf:status listURI="urn:xoev-de:fim:codeliste:xdatenfelder.status" listVersionID="1.0">
						<code>aktiv</code>
					</xdf:status>
				</xsl:otherwise>
			</xsl:choose>
	</xsl:template>

	<!-- ############################################################################################################# -->
	
	<xsl:template name="praezisierung">
		<xsl:param name="Element"/>

		<xsl:if test="$DebugMode = '3' or $DebugMode = '4'">
			<xsl:message>
				++++ praezisierung ++++
			</xsl:message>
		</xsl:if>

			<xsl:variable name="minValue">
				<xsl:value-of select="$Element/@minValue"/>
			</xsl:variable>
			<xsl:variable name="maxValue">
				<xsl:value-of select="$Element/@maxValue"/>
			</xsl:variable>
			<xsl:variable name="minLength">
				<xsl:value-of select="$Element/@minLength"/>
			</xsl:variable>
			<xsl:variable name="maxLength">
				<xsl:value-of select="$Element/@maxLength"/>
			</xsl:variable>
			<xsl:variable name="pattern">
				<xsl:value-of select="$Element/@pattern"/>
			</xsl:variable>
			
			<xsl:if test="$DebugMode = '4'">
				<xsl:message>
					++++ Präzisierungswerte ++++
					minValue: <xsl:value-of select="$minValue"/>
					maxValue: <xsl:value-of select="$maxValue"/>
					minLength: <xsl:value-of select="$minLength"/>
					maxLength: <xsl:value-of select="$maxLength"/>
					pattern: <xsl:value-of select="$pattern"/>
				</xsl:message>
			</xsl:if>
	
			<xdf:praezisierung><xsl:if test="fn:concat($minValue,$maxValue,$minLength,$maxLength,$pattern) != ''">{<xsl:if test="$minValue != ''">"minValue":"<xsl:value-of select="$minValue"/>"<xsl:if test="fn:concat($maxValue,$minLength,$maxLength,$pattern) != ''">,</xsl:if></xsl:if><xsl:if test="$maxValue != ''">"maxValue":"<xsl:value-of select="$maxValue"/>"<xsl:if test="fn:concat($minLength,$maxLength,$pattern) != ''">,</xsl:if></xsl:if><xsl:if test="$minLength != ''">"minLength":"<xsl:value-of select="$minLength"/>"<xsl:if test="fn:concat($maxLength,$pattern) != ''">,</xsl:if></xsl:if><xsl:if test="$maxLength != ''">"maxLength":"<xsl:value-of select="$maxLength"/>"<xsl:if test="$pattern != ''">,</xsl:if></xsl:if><xsl:if test="$pattern != ''">"pattern":"<xsl:value-of select="$pattern"/>"</xsl:if>}</xsl:if></xdf:praezisierung>

	</xsl:template>

	<!-- ############################################################################################################# -->
	
	<xsl:template match="xdf3:codelisteReferenz">

		<xsl:variable name="InternalID"><xsl:call-template name="CodelistID"><xsl:with-param name="Identifikation" select="../xdf3:identifikation"/></xsl:call-template></xsl:variable>
		
		<xsl:variable name="RichtigeVersion">
			<xsl:choose>
				<xsl:when test="empty(./xdf3:version/text())">
					<xsl:variable name="CodelisteAbfrageURL" select="fn:concat($XMLXRepoOhneVersionPfadPrefix,./xdf3:canonicalIdentification,$XMLXRepoOhneVersionPfadPostfix)"/>
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
						<xsl:when test="fn:string-length($CodelisteAbfrageInhalt) &lt; 10"><xsl:value-of select="fn:format-dateTime(../xdf3:letzteAenderung ,'[Y0001]-[M01]-[D01]')"/></xsl:when>
						<xsl:otherwise><xsl:value-of select="$CodelisteAbfrageInhalt/dat:VersionCodeliste/dat:version"/></xsl:otherwise>
					</xsl:choose>
				</xsl:when>
				<xsl:otherwise><xsl:value-of select="./xdf3:version"/></xsl:otherwise>
			</xsl:choose>
		</xsl:variable>
		
		<xsl:if test="$DebugMode = '3' or $DebugMode = '4'">
			<xsl:message>
				++++ codelisteReferenz ++++
				Codeliste: <xsl:value-of select="./xdf3:canonicalIdentification"/>_<xsl:value-of select="$RichtigeVersion"/>
			</xsl:message>
		</xsl:if>

		<xsl:variable name="TempID"><xsl:apply-templates select="../xdf3:identifikation/xdf3:id"/></xsl:variable>
		<xsl:variable name="TempVersion"><xsl:apply-templates select="../xdf3:identifikation/xdf3:version"/></xsl:variable>
		
		<xdf:codelisteReferenz>
			<xdf:identifikation>
				<xdf:id><xsl:value-of select="fn:concat('C', fn:substring($TempID,2))"/></xdf:id>
				<xsl:if test="not(empty($TempVersion/text()))">
					<xdf:version><xsl:value-of select="$TempVersion"/></xdf:version>
				</xsl:if>
			</xdf:identifikation>
			<xdf:genericodeIdentification>
				<xdf:canonicalIdentification><xsl:value-of select="./xdf3:canonicalIdentification"/></xdf:canonicalIdentification>
				<xdf:version><xsl:value-of select="$RichtigeVersion"/></xdf:version>
				<xdf:canonicalVersionUri><xsl:value-of select="./xdf3:canonicalIdentification"/>_<xsl:value-of select="$RichtigeVersion"/></xdf:canonicalVersionUri>
			</xdf:genericodeIdentification>
		</xdf:codelisteReferenz>

	</xsl:template>

	<!-- ############################################################################################################# -->
	
	<xsl:template match="xdf3:werte">

		<xsl:variable name="InternalID"><xsl:call-template name="CodelistID"><xsl:with-param name="Identifikation" select="../xdf3:identifikation"/></xsl:call-template></xsl:variable>

		<xsl:variable name="TempName"><xsl:call-template name="URNsonderzeichenraus"><xsl:with-param name="OriginalText" select="../xdf3:name"/></xsl:call-template></xsl:variable>
		
		<xsl:variable name="TempcanonicalIdentification"><xsl:value-of select="$TempName"/>_<xsl:value-of select="../xdf3:identifikation/xdf3:id"/><xsl:if test="../xdf3:identifikation/xdf3:version">V<xsl:value-of select="../xdf3:identifikation/xdf3:version"/></xsl:if></xsl:variable>
		
		<xsl:variable name="Tempversion"><xsl:value-of select="format-dateTime(../xdf3:letzteAenderung,'[Y0001]-[M01]-[D01]')"/></xsl:variable>
		
		<xsl:if test="$DebugMode = '3' or $DebugMode = '4'">
			<xsl:message>
				++++ werte ++++
				Werteliste: <xsl:value-of select="$CodelistenInternIdentifier"/><xsl:value-of select="$TempcanonicalIdentification"/>_<xsl:value-of select="$Tempversion"/>
			</xsl:message>
		</xsl:if>
		
		<xsl:variable name="TempID"><xsl:apply-templates select="../xdf3:identifikation/xdf3:id"/></xsl:variable>
		<xsl:variable name="TempVersion"><xsl:apply-templates select="../xdf3:identifikation/xdf3:version"/></xsl:variable>
		
		<xdf:codelisteReferenz>
			<xdf:identifikation>
				<xdf:id><xsl:value-of select="fn:concat('C', fn:substring($TempID,2))"/></xdf:id>
				<xsl:if test="not(empty($TempVersion/text()))">
					<xdf:version><xsl:value-of select="$TempVersion"/></xdf:version>
				</xsl:if>
			</xdf:identifikation>
			<xdf:genericodeIdentification>
				<xdf:canonicalIdentification><xsl:value-of select="$CodelistenInternIdentifier"/><xsl:value-of select="$TempcanonicalIdentification"/></xdf:canonicalIdentification>
				<xdf:version><xsl:value-of select="$Tempversion"/></xdf:version>
				<xdf:canonicalVersionUri><xsl:value-of select="$CodelistenInternIdentifier"/><xsl:value-of select="$TempcanonicalIdentification"/>_<xsl:value-of select="$Tempversion"/></xdf:canonicalVersionUri>
			</xdf:genericodeIdentification>
		</xdf:codelisteReferenz>
		
		
	</xsl:template>

	<!-- ############################################################################################################# -->
	
	<xsl:template match="xdf3:header">

		<xsl:if test="$DebugMode = '3' or $DebugMode = '4'">
			<xsl:message>
				++++ header ++++
			</xsl:message>
		</xsl:if>

		<xdf:header>
			<xdf:nachrichtID><xsl:value-of select="./xdf3:nachrichtID"/></xdf:nachrichtID>
			<xdf:erstellungszeitpunkt><xsl:value-of select="./xdf3:erstellungszeitpunkt"/></xdf:erstellungszeitpunkt>
			<xsl:if test="not(empty(./xdf3:referenzID/text()))">
				<xdf:referenzID><xsl:value-of select="./xdf3:referenzID"/></xdf:referenzID>
			</xsl:if>
		</xdf:header>
	</xsl:template>

	<!-- ############################################################################################################# -->
	
	<xsl:template match="xdf3:dokumentart">

		<xsl:if test="$DebugMode = '3' or $DebugMode = '4'">
			<xsl:message>
				++++ dokumentart ++++
			</xsl:message>
		</xsl:if>

		<xsl:variable name="CodelisteAbfrageURL" select="fn:concat($XMLXRepoOhneVersionPfadPrefix,'urn:xoev-de:fim-datenfelder:codeliste:dokumentart',$XMLXRepoOhneVersionPfadPostfix)"/>
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
		<xdf:dokumentart>
			<xsl:choose>
				<xsl:when test="fn:string-length($CodelisteAbfrageInhalt) &lt; 10">unbestimmt</xsl:when>
				<xsl:otherwise>
					<xsl:variable name="CodelisteURL" select="fn:concat($XMLXRepoMitVersionPfadPrefix,$CodelisteAbfrageInhalt/dat:VersionCodeliste/dat:kennung,$XMLXRepoMitVersionPfadPostfix)"/>
					<xsl:variable name="CodelisteInhalt">
						<xsl:choose>
							<xsl:when test="fn:doc-available($CodelisteURL)">
								<xsl:copy-of select="fn:document($CodelisteURL)"/>
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
						<xsl:when test="fn:string-length($CodelisteInhalt) &lt; 10">unbestimmt</xsl:when>
						<xsl:otherwise><xsl:variable name="Code" select="."/><xsl:value-of select="$CodelisteInhalt/*/gc:SimpleCodeList/gc:Row[./gc:Value/gc:SimpleValue=$Code]/gc:Value[./@ColumnRef='Beschreibung']/gc:SimpleValue"/><xsl:value-of select="$CodelisteInhalt/*/SimpleCodeList/Row[./Value/SimpleValue=$Code]/Value[./@ColumnRef='Beschreibung']/SimpleValue"/></xsl:otherwise>
					</xsl:choose>
				</xsl:otherwise>
			</xsl:choose>
		</xdf:dokumentart>

	</xsl:template>

	<!-- ############################################################################################################# -->

	<xsl:template name="freigabestatus">
		<xsl:param name="Element"/>
		<xsl:choose>
			<xsl:when test="$Element/code/text() = '1'">in&#160;Planung</xsl:when>
			<xsl:when test="$Element/code/text() = '2'">in&#160;Bearbeitung</xsl:when>
			<xsl:when test="$Element/code/text() = '3'">Entwurf</xsl:when>
			<xsl:when test="$Element/code/text() = '4'">methodisch&#160;freigegeben</xsl:when>
			<xsl:when test="$Element/code/text() = '5'">fachlich&#160;freigegeben (silber)</xsl:when>
			<xsl:when test="$Element/code/text() = '6'">fachlich&#160;freigegeben (gold)</xsl:when>
			<xsl:when test="$Element/code/text() = '7'">inaktiv</xsl:when>
			<xsl:otherwise></xsl:otherwise>
		</xsl:choose>
	</xsl:template>
	
	<!-- ############################################################################################################# -->

	<xsl:template match="xdf3:feldart">
		<xsl:choose>
			<xsl:when test="./code/text() = 'input'">Eingabefeld</xsl:when>
			<xsl:when test="./code/text() = 'select'">Auswahlfeld</xsl:when>
			<xsl:when test="./code/text() = 'label'">Statisches, read-only Feld</xsl:when>
			<xsl:when test="./code/text() = 'hidden'">verstecktes Feld</xsl:when>
			<xsl:when test="./code/text() = 'locked'">gesperrtes Feld</xsl:when>
			<xsl:otherwise></xsl:otherwise>
		</xsl:choose>
	</xsl:template>

	<!-- ############################################################################################################# -->

	<xsl:template match="xdf3:datentyp">
		<xsl:choose>
			<xsl:when test="./code/text() = 'text'">Text</xsl:when>
			<xsl:when test="./code/text() = 'text_latin'">Text (String.Latin+ 1.2 -DIN Spec 91379 - Datentyp C)</xsl:when>
			<xsl:when test="./code/text() = 'date'">Datum</xsl:when>
			<xsl:when test="./code/text() = 'time'">Zeit (Stunde und Minute)</xsl:when>
			<xsl:when test="./code/text() = 'datetime'">Zeitpunkt (Datum und Zeit)</xsl:when>
			<xsl:when test="./code/text() = 'bool'">Wahrheitswert</xsl:when>
			<xsl:when test="./code/text() = 'num'">Nummer (Fließkommazahl)</xsl:when>
			<xsl:when test="./code/text() = 'num_int'">Ganzzahl</xsl:when>
			<xsl:when test="./code/text() = 'num_currency'">Geldbetrag</xsl:when>
			<xsl:when test="./code/text() = 'file'">Anlage (Datei)</xsl:when>
			<xsl:when test="./code/text() = 'obj'">Statisches Objekt</xsl:when>
			<xsl:otherwise></xsl:otherwise>
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

	<xsl:template name="URNsonderzeichenraus">
	  <xsl:param name="OriginalText" />

		<xsl:variable name="Temp1" select="fn:replace($OriginalText, '\s', '')"/>
		<xsl:variable name="Temp2" select="replace(replace(replace(replace($Temp1,'ß','ss'),'ü','ue'),'ö','oe'),'ä','ae')"/>
		<xsl:variable name="Temp3" select="replace(replace(replace($Temp2,'Ü','U e'),'Ö','Oe'),'Ä','Ae')"/>
		<xsl:variable name="Temp4" select="replace($Temp3,'[^A-Z]','','i')"/>
		<xsl:value-of select="$Temp4"/>
	</xsl:template>

</xsl:stylesheet>
