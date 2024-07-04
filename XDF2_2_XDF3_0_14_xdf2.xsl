<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet version="2.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:xdf3="urn:xoev-de:fim:standard:xdatenfelder_3.0.0" xmlns:html="http://www.w3.org/1999/xhtml" xmlns:fn="http://www.w3.org/2005/xpath-functions" xmlns:xdf="urn:xoev-de:fim:standard:xdatenfelder_2" xmlns:gc="http://docs.oasis-open.org/codelist/ns/genericode/1.0/"  xmlns:ext="http://www.xoev.de/de/xrepository/framework/1/extrakte" xmlns:bdt="http://www.xoev.de/de/xrepository/framework/1/basisdatentypen" xmlns:dat="http://www.xoev.de/de/xrepository/framework/1/datenbereitstellung" xmlns:svrl="http://purl.oclc.org/dsdl/svrl" xmlns:xs="http://www.w3.org/2001/XMLSchema" exclude-result-prefixes="html xsl fn xdf3 gc ext bdt dat svrl xdf xs">

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
	
	<xsl:character-map name="xdf2">
	  <xsl:output-character character="≤" string="&amp;lt;="/>
	  <xsl:output-character character="≥" string="&amp;gt;="/>
	  <xsl:output-character character="≠" string="&amp;lt;&amp;gt;"/>
	  <xsl:output-character character="„" string="'"/>
	  <xsl:output-character character="“" string="'"/>
	  <xsl:output-character character="”" string="'"/>
	  <xsl:output-character character="″" string="''"/>
	  <xsl:output-character character="‘" string="'"/>
	  <xsl:output-character character="’" string="'"/>
	  <xsl:output-character character="′" string="'"/>
	  <xsl:output-character character="‚" string="'"/>
	  <xsl:output-character character="—" string="-"/>
	  <xsl:output-character character="‐" string="-"/>
	  <xsl:output-character character="−" string="-"/>
	  <xsl:output-character character="‑" string="-"/>
	  <xsl:output-character character="•" string="*"/>
	  <xsl:output-character character="…" string="..."/>
	  <xsl:output-character character="⅔" string="2/3"/>
	  <xsl:output-character character="→" string="->"/>
	  <xsl:output-character character="ﬂ" string="fl"/>
	  <xsl:output-character character="☐" string=""/>
	  <xsl:output-character character="α" string="alpha"/>
	  <xsl:output-character character="‰" string="0/00"/>
	  <xsl:output-character character="́" string=""/>
	  <xsl:output-character character="&#x80;" string="€"/>
	  <xsl:output-character character="&#x2013;" string="-"/>
	  <xsl:output-character character="&#xa0;" string=" "/> <!-- NO-BREAK SPACE -->
	  <xsl:output-character character="&#x202f;" string=" "/> <!-- NARROW NO-BREAK SPACE -->
	  <xsl:output-character character="&#xD;" string=""/> <!-- CARRIAGE RETURN -->
	  <xsl:output-character character="&#x308;" string="e"/> <!-- COMBINING DIAERESIS -->
	  <xsl:output-character character="&#xdf;" string="ß"/>
	  <xsl:output-character character="&#x200b;" string=""/> <!-- ZERO WIDTH SPACE -->
	  <xsl:output-character character="&#x2009;" string=" "/> <!-- THIN SPACE -->
	</xsl:character-map>

	<xsl:variable name="StyleSheetURI" select="fn:static-base-uri()"/>
	<xsl:variable name="DocumentURI" select="fn:document-uri(.)"/>

	<xsl:variable name="StyleSheetName" select="'XDF2_2_XDF3_0_14_xdf2.xsl'"/> <!-- BackUp, falls fn:static-base-uri() leer -->

	<xsl:output method="xml" omit-xml-declaration="no" use-character-maps="xdf2"/>
	<xsl:strip-space elements="*"/>

	<xsl:param name="DateiOutput" select="'1'"/>

	<xsl:param name="Unternummernkreis" select="'000'"/>

	<xsl:param name="BezuegeAufteilen" select="'1'"/>
	<xsl:param name="DokumentsteckbriefID" select="'D99000000001'"/>
	<xsl:param name="Codelisten2Wertelisten" select="'1'"/>
	<xsl:param name="CodelistenInternIdentifier" select="'urn:de:fim:;urn:xoev-de:fim:'"/>
	<xsl:param name="PruefeCodelistenErreichbarkeit" select="'1'"/>
	<xsl:param name="FreitextRegelKorrektur" select="'1'"/>
	<xsl:param name="OriginalwerteDoku" select="'1'"/>
	
	<xsl:param name="SubstitutionS" select="''"/>
	<xsl:param name="SubstitutionB" select="''"/>
	<xsl:param name="Mapping" select="''"/>
	<xsl:param name="ZwingeStatus" select="''"/>

	<xsl:param name="DebugMode" select="'4'"/>
	
	<xsl:variable name="XMLXRepoMitVersionPfadPrefix" select="'https://www.xrepository.de/api/version_codeliste/'"/>
	<xsl:variable name="XMLXRepoMitVersionPfadPostfix" select="'/genericode'"/>
	<xsl:variable name="XMLXRepoOhneVersionPfadPrefix" select="'https://www.xrepository.de/api/codeliste/'"/>
	<xsl:variable name="XMLXRepoOhneVersionPfadPostfix" select="'/gueltigeVersion'"/>

	<xsl:variable name="InputDateiname" select="(tokenize($DocumentURI,'/'))[last()]"/>
	<xsl:variable name="InputPfad" select="fn:substring-before($DocumentURI, $InputDateiname)"/>

	<xsl:variable name="MappingDatei">
		<xsl:choose>
			<xsl:when test="$Mapping != ''"><xsl:value-of select="concat($InputPfad,$Mapping)"/></xsl:when>
			<xsl:otherwise>kjhlkhlkjhk.xml</xsl:otherwise>
		</xsl:choose>
	</xsl:variable>

	<xsl:variable name="MappingInhalt">
		<xsl:choose>
			<xsl:when test="fn:doc-available($MappingDatei)">
				<xsl:copy-of select="fn:document($MappingDatei)"/>
				<xsl:if test="$DebugMode = '4'">
				<xsl:message>FILE2</xsl:message>
				</xsl:if>
			</xsl:when>
			<xsl:otherwise>
				<xsl:if test="$DebugMode = '4'">
				<xsl:message>LEER</xsl:message>
				</xsl:if>
			</xsl:otherwise>
		</xsl:choose>
	</xsl:variable>

	<xsl:variable name="SIDAlt"><xsl:copy-of select="/*/*/xdf:identifikation/xdf:id"/></xsl:variable>
	<xsl:variable name="SIDTemp">
		<xsl:for-each select="tokenize($SubstitutionS, ';')">
			<xsl:if test="$DebugMode = '3' or $DebugMode = '4'">
				<xsl:message>
			SubstitutionS: <xsl:value-of select="."/>
				</xsl:message>
			</xsl:if>
			<xsl:if test="tokenize(., ',')[1] = fn:substring($SIDAlt,2,2)">
				<xsl:variable name="SIDTemp2"><xsl:value-of select="fn:concat(fn:substring($SIDAlt,1,1),tokenize(., ',')[2],fn:substring($SIDAlt,4))"/></xsl:variable>
				<xsl:choose>
					<xsl:when test="tokenize(., ',')[3]"><xsl:value-of select=" fn:concat( fn:substring($SIDAlt,1,1) ,  fn:substring(       fn:string (          fn:format-number( fn:number(          fn:concat('1', fn:substring($SIDTemp2,2))        ) + fn:number(tokenize(., ',')[3]), '########')    )   ,2  )   )     "/></xsl:when>
					<xsl:otherwise><xsl:value-of select="$SIDTemp2"/></xsl:otherwise>
				</xsl:choose>
			</xsl:if>
		</xsl:for-each>
	</xsl:variable>
	<xsl:variable name="SIDNeu">
		<xsl:message>
			aaaaa<xsl:copy-of select="$SIDTemp"/>bbbbb
		</xsl:message>
		<xsl:choose>
			<xsl:when test="fn:string-length($MappingInhalt) &gt; 9">
				<xsl:choose>
					<xsl:when test="$MappingInhalt/*/SimpleCodeList/Row[./Value/SimpleValue=$SIDAlt]"><xsl:value-of select="$MappingInhalt/*/SimpleCodeList/Row[./Value/SimpleValue=$SIDAlt]/Value[./@ColumnRef='IDNeu']/SimpleValue"/></xsl:when>
					<xsl:otherwise>
						<xsl:choose>
							<xsl:when test="$SIDTemp = ''"><xsl:value-of select="$SIDAlt"/></xsl:when>
							<xsl:otherwise><xsl:value-of select="$SIDTemp"/></xsl:otherwise>
						</xsl:choose>
					</xsl:otherwise>
				</xsl:choose>
			</xsl:when>
			<xsl:otherwise>
				<xsl:choose>
					<xsl:when test="$SIDTemp = ''"><xsl:value-of select="$SIDAlt"/></xsl:when>
					<xsl:otherwise><xsl:value-of select="$SIDTemp"/></xsl:otherwise>
				</xsl:choose>
			</xsl:otherwise>
		</xsl:choose>
	</xsl:variable>
	<xsl:variable name="NameNeu"><xsl:call-template name="FILEsonderzeichenraus"><xsl:with-param name="OriginalText" select="/*/*/xdf:name"/></xsl:call-template></xsl:variable>
	<xsl:variable name="OutputDateiname">
		<xsl:message>
			cccc<xsl:copy-of select="$SIDNeu"/>dddd
		</xsl:message>
		<xsl:choose>
			<xsl:when test="name(/*) ='xdf:xdatenfelder.stammdatenschema.0102'">
				<xsl:choose>
					<xsl:when test="empty(//xdf:stammdatenschema/xdf:identifikation/xdf:version/text())"><xsl:value-of select="fn:substring($SIDNeu,1,3)"/><xsl:value-of select="$Unternummernkreis"/><xsl:value-of select="fn:substring($SIDNeu,4)"/>_<xsl:value-of select="fn:substring($NameNeu,1,50)"/>_xdf3.xml</xsl:when>
					<xsl:otherwise><xsl:value-of select="fn:substring($SIDNeu,1,3)"/><xsl:value-of select="$Unternummernkreis"/><xsl:value-of select="fn:substring($SIDNeu,4)"/>V<xsl:value-of select="//xdf:stammdatenschema/xdf:identifikation/xdf:version"/>.0_<xsl:value-of select="fn:substring($NameNeu,1,50)"/>_xdf3.xml</xsl:otherwise>
				</xsl:choose>
			</xsl:when>
			<xsl:when test="name(/*) ='xdf:xdatenfelder.datenfeldgruppe.0103'">
				<xsl:choose>
					<xsl:when test="empty(//xdf:datenfeldgruppe/xdf:identifikation/xdf:version/text())"><xsl:value-of select="fn:substring($SIDNeu,1,3)"/><xsl:value-of select="$Unternummernkreis"/><xsl:value-of select="fn:substring($SIDNeu,4)"/>_xdf3.xml</xsl:when>
					<xsl:otherwise><xsl:value-of select="fn:substring($SIDNeu,1,3)"/><xsl:value-of select="$Unternummernkreis"/><xsl:value-of select="fn:substring($SIDNeu,4)"/>V<xsl:value-of select="//xdf:datenfeldgruppe/xdf:identifikation/xdf:version"/>.0_xdf3.xml</xsl:otherwise>
				</xsl:choose>
			</xsl:when>
			<xsl:when test="name(/*) ='xdf:xdatenfelder.datenfeld.0104'">
				<xsl:choose>
					<xsl:when test="empty(//xdf:datenfeld/xdf:identifikation/xdf:version/text())"><xsl:value-of select="fn:substring($SIDNeu,1,3)"/><xsl:value-of select="$Unternummernkreis"/><xsl:value-of select="fn:substring($SIDNeu,4)"/>_xdf3.xml</xsl:when>
					<xsl:otherwise><xsl:value-of select="fn:substring($SIDNeu,1,3)"/><xsl:value-of select="$Unternummernkreis"/><xsl:value-of select="fn:substring($SIDNeu,4)"/>V<xsl:value-of select="//xdf:datenfeld/xdf:identifikation/xdf:version"/>.0_xdf3.xml</xsl:otherwise>
				</xsl:choose>
			</xsl:when>
			<xsl:when test="name(/*) ='xdf:xdatenfelder.dokumentsteckbrief.0101'">
				<xsl:choose>
					<xsl:when test="empty(//xdf:dokumentensteckbrief/xdf:identifikation/xdf:version/text())"><xsl:value-of select="fn:substring($SIDNeu,1,3)"/><xsl:value-of select="$Unternummernkreis"/><xsl:value-of select="fn:substring($SIDNeu,4)"/>_xdf3.xml</xsl:when>
					<xsl:otherwise><xsl:value-of select="fn:substring($SIDNeu,1,3)"/><xsl:value-of select="$Unternummernkreis"/><xsl:value-of select="fn:substring($SIDNeu,4)"/>V<xsl:value-of select="//xdf:dokumentensteckbrief/xdf:identifikation/xdf:version"/>.0_xdf3.xml</xsl:otherwise>
				</xsl:choose>
			</xsl:when>
			<xsl:otherwise>
				<title>Unbekanntes Dateiformat</title>
			</xsl:otherwise>
		</xsl:choose>


	</xsl:variable>


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
				Unternummernkreis: <xsl:value-of select="$Unternummernkreis"/>
				SubstitutionS: <xsl:value-of select="$SubstitutionS"/>
				SubstitutionB: <xsl:value-of select="$SubstitutionB"/>				
				BezuegeAufteilen: <xsl:value-of select="$BezuegeAufteilen"/>
				DokumentsteckbriefID: <xsl:value-of select="$DokumentsteckbriefID"/>
				Codelisten2Wertelisten: <xsl:value-of select="$Codelisten2Wertelisten"/>
				CodelistenInternIdentifier: <xsl:value-of select="$CodelistenInternIdentifier"/>
				PruefeCodelistenErreichbarkeit: <xsl:value-of select="$PruefeCodelistenErreichbarkeit"/>
				OriginalwerteDoku: <xsl:value-of select="$OriginalwerteDoku"/>
				DebugMode: <xsl:value-of select="$DebugMode"/>
			</xsl:message>
		</xsl:if>

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
			<xsl:when test="name(/*) ='xdf:xdatenfelder.stammdatenschema.0102'">
				<xdf3:xdatenfelder.stammdatenschema.0102 xmlns:xdf3="urn:xoev-de:fim:standard:xdatenfelder_3.0.0">

					<xsl:comment><xsl:text>           </xsl:text>Erstellt am: <xsl:value-of select="format-date(fn:current-date(),'[D01].[M01].[Y0001]')"/> um <xsl:value-of select="format-time(fn:current-time(),'[H01]:[m01]')"/> Uhr<xsl:text>           </xsl:text>XSLT: <xsl:choose><xsl:when test="$StyleSheetURI = ''"><xsl:value-of select="$StyleSheetName"/></xsl:when><xsl:otherwise><xsl:call-template name="fileName"><xsl:with-param name="path" select="$StyleSheetURI"/></xsl:call-template></xsl:otherwise></xsl:choose><xsl:if test="not(empty($DocumentURI))"><xsl:text>           </xsl:text>XML: <xsl:call-template name="fileName"><xsl:with-param name="path" select="$DocumentURI"/></xsl:call-template></xsl:if><xsl:text>           </xsl:text></xsl:comment>

					<xsl:apply-templates select="./*/xdf:header"/>

					<xsl:apply-templates select="./*/xdf:stammdatenschema"/>
	
				</xdf3:xdatenfelder.stammdatenschema.0102>
			</xsl:when>
			<xsl:when test="name(/*) ='xdf:xdatenfelder.datenfeldgruppe.0103'">
				<xdf3:xdatenfelder.datenfeldgruppe.0103 xmlns:xdf3="urn:xoev-de:fim:standard:xdatenfelder_3.0.0">
	
					<xsl:comment><xsl:text>           </xsl:text>Erstellt am: <xsl:value-of select="format-date(fn:current-date(),'[D01].[M01].[Y0001]')"/> um <xsl:value-of select="format-time(fn:current-time(),'[H01]:[m01]')"/> Uhr<xsl:text>           </xsl:text>XSLT: <xsl:value-of select="tokenize($StyleSheetURI, '/')[last()]"/><xsl:text>           </xsl:text>XML: <xsl:value-of select="tokenize($DocumentURI, '/')[last()]"/><xsl:text>           </xsl:text></xsl:comment>

					<xsl:apply-templates select="./*/xdf:header"/>

					<xsl:apply-templates select="./*/xdf:datenfeldgruppe"/>
	
				</xdf3:xdatenfelder.datenfeldgruppe.0103>
			</xsl:when>
			<xsl:when test="name(/*) ='xdf:xdatenfelder.datenfeld.0104'">
				<xdf3:xdatenfelder.datenfeld.0104 xmlns:xdf3="urn:xoev-de:fim:standard:xdatenfelder_3.0.0">
	
					<xsl:comment><xsl:text>           </xsl:text>Erstellt am: <xsl:value-of select="format-date(fn:current-date(),'[D01].[M01].[Y0001]')"/> um <xsl:value-of select="format-time(fn:current-time(),'[H01]:[m01]')"/> Uhr<xsl:text>           </xsl:text>XSLT: <xsl:value-of select="tokenize($StyleSheetURI, '/')[last()]"/><xsl:text>           </xsl:text>XML: <xsl:value-of select="tokenize($DocumentURI, '/')[last()]"/><xsl:text>           </xsl:text></xsl:comment>

					<xsl:apply-templates select="./*/xdf:header"/>

					<xsl:apply-templates select="./*/xdf:datenfeld"/>
	
				</xdf3:xdatenfelder.datenfeld.0104>
			</xsl:when>
			<xsl:when test="name(/*) ='xdf:xdatenfelder.dokumentsteckbrief.0101'">
				<xdf3:xdatenfelder.dokumentsteckbrief.0101 xmlns:xdf3="urn:xoev-de:fim:standard:xdatenfelder_3.0.0">
	
					<xsl:comment><xsl:text>           </xsl:text>Erstellt am: <xsl:value-of select="format-date(fn:current-date(),'[D01].[M01].[Y0001]')"/> um <xsl:value-of select="format-time(fn:current-time(),'[H01]:[m01]')"/> Uhr<xsl:text>           </xsl:text>XSLT: <xsl:value-of select="tokenize($StyleSheetURI, '/')[last()]"/><xsl:text>           </xsl:text>XML: <xsl:value-of select="tokenize($DocumentURI, '/')[last()]"/><xsl:text>           </xsl:text></xsl:comment>

					<xsl:apply-templates select="./*/xdf:header"/>

					<xsl:apply-templates select="./*/xdf:dokumentensteckbrief"/>
	
				</xdf3:xdatenfelder.dokumentsteckbrief.0101>
			</xsl:when>
			<xsl:otherwise>
				<title>Unbekanntes Dateiformat</title>
			</xsl:otherwise>
		</xsl:choose>
	
	</xsl:template>

	<!-- ############################################################################################################# -->
	
	<xsl:template match="xdf:stammdatenschema">
		
		<xsl:if test="$DebugMode = '2' or $DebugMode = '3' or $DebugMode = '4'">
			<xsl:message>
		++++ stammdatenschema ++++
		Datenschema: <xsl:value-of select="./xdf:identifikation/xdf:id"/>
			</xsl:message>
		</xsl:if>

		<xdf3:stammdatenschema>

			<xsl:variable name="UebergabeText">
				<xsl:value-of select="fn:substring-before(fn:substring-after(./xdf:beschreibung/text(),'+++'),'---')"/>
			</xsl:variable>

			<xsl:if test="$DebugMode = '4'">
				<xsl:message>
					UebergabeText:<xsl:value-of select="$UebergabeText"/>$$$
				</xsl:message>
			</xsl:if>


			<xsl:variable name="Aktualisierungsdatum">
				<xsl:for-each select="tokenize($UebergabeText, ';')">
					<xsl:if test="fn:contains(.,'letztes Änderungsdatum:')">
						<xsl:variable name="Datum">
							<xsl:value-of select="fn:substring-before(fn:substring-after(.,'letztes Änderungsdatum:'),' ')"/>
						</xsl:variable>
						<xsl:variable name="Uhrzeit">
							<xsl:value-of select="fn:substring-after(fn:substring-after(.,'letztes Änderungsdatum:'),' ')"/>
						</xsl:variable>
						<xsl:value-of select="fn:dateTime(    xs:date(concat(substring($Datum,7,4),'-',substring($Datum,4,2),'-',substring($Datum,1,2))) ,xs:time(fn:concat($Uhrzeit,'+01:00')))"/>
					</xsl:if>
				</xsl:for-each>
			</xsl:variable>

			<xsl:variable name="Dokumentsteckbrief">
				<xsl:for-each select="tokenize($UebergabeText, ';')">
					<xsl:if test="fn:contains(.,'Dokumentsteckbrief:')">
						<xsl:value-of select="fn:substring-after(.,'Dokumentsteckbrief:')"/>
					</xsl:if>
				</xsl:for-each>
			</xsl:variable>

			<xsl:variable name="DokumentsteckbriefName">
				<xsl:for-each select="tokenize($UebergabeText, ';')">
					<xsl:if test="fn:contains(.,'Name:')">
						<xsl:value-of select="fn:substring-after(.,'Name:')"/>
					</xsl:if>
				</xsl:for-each>
			</xsl:variable>

			<xsl:variable name="LetzteVersion">
				<xsl:for-each select="tokenize($UebergabeText, ';')">
					<xsl:if test="fn:contains(.,'letzte Version:')">
						<xsl:value-of select="fn:substring-after(.,'letzte Version:')"/>
					</xsl:if>
				</xsl:for-each>
			</xsl:variable>

			<xsl:message>
			</xsl:message>

			<xsl:if test="$DebugMode = '4'">
				<xsl:message>
				++++ intern übergebene Werte
				Aktualisierungsdatum:<xsl:value-of select="$Aktualisierungsdatum"/>+++
				Dokumentsteckbrief:<xsl:value-of select="$Dokumentsteckbrief"/>+++
				DokumentsteckbriefName:<xsl:value-of select="$DokumentsteckbriefName"/>+++
				LetzteVersion:<xsl:value-of select="$LetzteVersion"/>+++
				</xsl:message>
			</xsl:if>
	
			<xsl:variable name="BeschreibungNeu">
				Originalwerte der XDF2-Datei:
				ID: <xsl:value-of select="./xdf:identifikation/xdf:id"/><xsl:if test="not(empty(./xdf:identifikation/xdf:version/text()))">
				Version: <xsl:value-of select="./xdf:identifikation/xdf:version"/></xsl:if><xsl:if test="not(empty(./xdf:status/code/text()))">
				Status: <xsl:value-of select="./xdf:status/code"/></xsl:if><xsl:if test="$Dokumentsteckbrief != '' or $DokumentsteckbriefName != '' or $LetzteVersion != ''">
				Zusätzliche intern übergebene Werte:</xsl:if><xsl:if test="$Dokumentsteckbrief != ''">
				Zugeordneter Dokumentsteckbrief: <xsl:value-of select="$Dokumentsteckbrief"/></xsl:if><xsl:if test="$DokumentsteckbriefName != ''"> <xsl:value-of select="$DokumentsteckbriefName"/></xsl:if><xsl:if test="$LetzteVersion != ''">
				Letzte Version: <xsl:value-of select="$LetzteVersion"/></xsl:if><xsl:if test="fn:count(./xdf:struktur) = 0">
				ACHTUNG: Ein Stammdatenschema muss in XDF3 Unterelemente haben, deshalb wurde das BOB-Feld F60000000001 'Default-Datenfeld' eingefügt, um Schemakonformität sicherzustellen.</xsl:if></xsl:variable>

			<xsl:if test="$OriginalwerteDoku = '2' or $OriginalwerteDoku = '3'">
				<xsl:comment>
					<xsl:value-of select="$BeschreibungNeu"/>
				</xsl:comment>
			</xsl:if>

			<xsl:apply-templates select="./xdf:identifikation"/>

			<xdf3:name><xsl:value-of select="./xdf:name"/></xdf3:name>

			<xsl:variable name="BeschreibungAlt"><xsl:choose><xsl:when test="fn:contains(./xdf:beschreibung/text(), 'Originalwerte der XDF3-Datei:')"><xsl:value-of select="fn:substring-before(./xdf:beschreibung/text(), 'Originalwerte der XDF3-Datei:')"/></xsl:when><xsl:when test="fn:contains(./xdf:beschreibung/text(), '+++') and fn:contains(./xdf:beschreibung/text(), '---')"><xsl:value-of select="fn:substring-after(./xdf:beschreibung/text(), '--- ')"/></xsl:when><xsl:otherwise><xsl:value-of select="./xdf:beschreibung"/></xsl:otherwise></xsl:choose></xsl:variable>

			<xsl:choose>
				<xsl:when test="$OriginalwerteDoku = '1' or $OriginalwerteDoku = '3'">
					<xdf3:beschreibung><xsl:if test="not(empty($BeschreibungAlt))"><xsl:value-of select="$BeschreibungAlt"/><xsl:text>
					</xsl:text></xsl:if><xsl:value-of select="$BeschreibungNeu"/></xdf3:beschreibung>
				</xsl:when>
				<xsl:otherwise>
					<xsl:if test="not(empty($BeschreibungAlt))"><xdf3:beschreibung><xsl:value-of select="$BeschreibungAlt"/></xdf3:beschreibung></xsl:if>
				</xsl:otherwise>
			</xsl:choose>

			<xsl:if test="not(empty(./xdf:definition/text()))">
				<xdf3:definition><xsl:value-of select="./xdf:definition"/></xdf3:definition>
			</xsl:if>

			<xsl:apply-templates select="./xdf:bezug"/>

			<xsl:apply-templates select="./xdf:status"/>

			<xsl:if test="not(empty(./xdf:freigabedatum/text()))">
				<xdf3:statusGesetztAm><xsl:value-of select="./xdf:freigabedatum"/></xdf3:statusGesetztAm>
			</xsl:if>

			<xsl:if test="not(empty(./xdf:fachlicherErsteller/text()))">
				<xdf3:statusGesetztDurch><xsl:value-of select="./xdf:fachlicherErsteller"/></xdf3:statusGesetztDurch>
			</xsl:if>

			<xsl:if test="not(empty(./xdf:gueltigAb/text()))">
				<xdf3:gueltigAb><xsl:value-of select="./xdf:gueltigAb"/></xdf3:gueltigAb>
			</xsl:if>

			<xsl:if test="not(empty(./xdf:gueltigBis/text()))">
				<xdf3:gueltigBis><xsl:value-of select="./xdf:gueltigBis"/></xdf3:gueltigBis>
			</xsl:if>

			<xsl:if test="not(empty(./xdf:versionshinweis/text()))">
				<xdf3:versionshinweis><xsl:value-of select="./xdf:versionshinweis"/></xdf3:versionshinweis>
			</xsl:if>

			<xsl:if test="not(empty(./xdf:veroeffentlichungsdatum/text()))">
				<xdf3:veroeffentlichungsdatum><xsl:value-of select="./xdf:veroeffentlichungsdatum"/></xdf3:veroeffentlichungsdatum>
			</xsl:if>

			<xsl:choose>
				<xsl:when test="$Aktualisierungsdatum castable as xs:dateTime">
					<xdf3:letzteAenderung><xsl:value-of select="$Aktualisierungsdatum cast as xs:dateTime"/></xdf3:letzteAenderung>
				</xsl:when>
				<xsl:otherwise>
					<xdf3:letzteAenderung><xsl:value-of select="//*/xdf:header/xdf:erstellungszeitpunkt"/></xdf3:letzteAenderung>
				</xsl:otherwise>
			</xsl:choose>
			

			<xdf3:bezeichnung><xsl:value-of select="./xdf:bezeichnungEingabe"/></xdf3:bezeichnung>

			<xsl:if test="not(empty(./xdf:hilfetext/text()))">
				<xdf3:hilfetext><xsl:value-of select="./xdf:hilfetext"/></xdf3:hilfetext>
			</xsl:if>

			<xdf3:ableitungsmodifikationenStruktur listURI="urn:xoev-de:fim:codeliste:xdatenfelder.ableitungsmodifikationenStruktur" listVersionID="1.0">
				<code><xsl:value-of select="./xdf:ableitungsmodifikationenStruktur/code"/></code>
			</xdf3:ableitungsmodifikationenStruktur>

			<xdf3:ableitungsmodifikationenRepraesentation listURI="urn:xoev-de:fim:codeliste:xdatenfelder.ableitungsmodifikationenRepraesentation" listVersionID="1.0">
				<code><xsl:value-of select="./xdf:ableitungsmodifikationenRepraesentation/code"/></code>
			</xdf3:ableitungsmodifikationenRepraesentation>

			<xdf3:dokumentsteckbrief>
				<xdf3:id><xsl:value-of select="$DokumentsteckbriefID"/></xdf3:id>
			</xdf3:dokumentsteckbrief>
			
			<xsl:for-each select="./xdf:regel">
				<xsl:apply-templates select="."/>
			</xsl:for-each>

			<xsl:call-template name="strukturstart">
				<xsl:with-param name="Element" select="."/>
				<xsl:with-param name="freigabedatumeltern" select="./xdf:freigabedatum/text()"/>
				<xsl:with-param name="veroeffentlichungsdatumeltern" select="./xdf:veroeffentlichungsdatum/text()"/>
			</xsl:call-template>

		</xdf3:stammdatenschema>
	</xsl:template>
	
	<!-- ############################################################################################################# -->
	
	<xsl:template match="xdf:dokumentensteckbrief">
		
		<xsl:if test="$DebugMode = '2' or $DebugMode = '3' or $DebugMode = '4'">
			<xsl:message>
		++++ dokumentensteckbrief ++++
		Dokumentensteckbrief: <xsl:value-of select="./xdf:identifikation/xdf:id"/>
			</xsl:message>
		</xsl:if>

		<xdf3:dokumentsteckbrief>

			<xsl:variable name="BeschreibungNeu">
				Originalwerte der XDF2-Datei:
				ID: <xsl:value-of select="./xdf:identifikation/xdf:id"/><xsl:if test="not(empty(./xdf:identifikation/xdf:version/text()))">
				Version: <xsl:value-of select="./xdf:identifikation/xdf:version"/></xsl:if><xsl:if test="not(empty(./xdf:status/code/text()))">
				Status: <xsl:value-of select="./xdf:status/code"/></xsl:if></xsl:variable>
				
			<xsl:if test="$OriginalwerteDoku = '2' or $OriginalwerteDoku = '3'">
				<xsl:comment>
					<xsl:value-of select="$BeschreibungNeu"/>
				</xsl:comment>
			</xsl:if>

			<xsl:apply-templates select="./xdf:identifikation"/>

			<xdf3:name><xsl:value-of select="./xdf:name"/></xdf3:name>

			<xsl:variable name="BeschreibungAlt"><xsl:choose><xsl:when test="fn:contains(./xdf:beschreibung/text(), 'Originalwerte der XDF3-Datei:')"><xsl:value-of select="fn:substring-before(./xdf:beschreibung/text(), 'Originalwerte der XDF3-Datei:')"/></xsl:when><xsl:otherwise><xsl:value-of select="./xdf:beschreibung"/></xsl:otherwise></xsl:choose></xsl:variable>

			<xsl:choose>
				<xsl:when test="$OriginalwerteDoku = '1' or $OriginalwerteDoku = '3'">
					<xdf3:beschreibung><xsl:if test="not(empty($BeschreibungAlt/text()))"><xsl:value-of select="$BeschreibungAlt"/><xsl:text>
					</xsl:text></xsl:if><xsl:value-of select="$BeschreibungNeu"/></xdf3:beschreibung>
				</xsl:when>
				<xsl:otherwise>
					<xsl:if test="not(empty($BeschreibungAlt/text()))"><xdf3:beschreibung><xsl:value-of select="$BeschreibungAlt"/></xdf3:beschreibung></xsl:if>
				</xsl:otherwise>
			</xsl:choose>

			<xsl:if test="not(empty(./xdf:definition/text()))">
				<xdf3:definition><xsl:value-of select="./xdf:definition"/></xdf3:definition>
			</xsl:if>

			<xsl:apply-templates select="./xdf:bezug"/>

			<xsl:apply-templates select="./xdf:status"/>

			<xsl:if test="not(empty(./xdf:freigabedatum/text()))">
				<xdf3:statusGesetztAm><xsl:value-of select="./xdf:freigabedatum"/></xdf3:statusGesetztAm>
			</xsl:if>

			<xsl:if test="not(empty(./xdf:fachlicherErsteller/text()))">
				<xdf3:statusGesetztDurch><xsl:value-of select="./xdf:fachlicherErsteller"/></xdf3:statusGesetztDurch>
			</xsl:if>

			<xsl:if test="not(empty(./xdf:gueltigAb/text()))">
				<xdf3:gueltigAb><xsl:value-of select="./xdf:gueltigAb"/></xdf3:gueltigAb>
			</xsl:if>

			<xsl:if test="not(empty(./xdf:gueltigBis/text()))">
				<xdf3:gueltigBis><xsl:value-of select="./xdf:gueltigBis"/></xdf3:gueltigBis>
			</xsl:if>

			<xsl:if test="not(empty(./xdf:versionshinweis/text()))">
				<xdf3:versionshinweis><xsl:value-of select="./xdf:versionshinweis"/></xdf3:versionshinweis>
			</xsl:if>

			<xsl:if test="not(empty(./xdf:veroeffentlichungsdatum/text()))">
				<xdf3:veroeffentlichungsdatum><xsl:value-of select="./xdf:veroeffentlichungsdatum"/></xdf3:veroeffentlichungsdatum>
			</xsl:if>

			<xdf3:letzteAenderung><xsl:value-of select="//*/xdf:header/xdf:erstellungszeitpunkt"/></xdf3:letzteAenderung>

			<xdf3:istAbstrakt><xsl:value-of select="./xdf:isReferenz"/></xdf3:istAbstrakt>

			<xsl:apply-templates select="./xdf:dokumentart"/>
		
			<xdf3:bezeichnung><xsl:value-of select="./xdf:bezeichnungEingabe"/></xdf3:bezeichnung>

			<xsl:if test="not(empty(./xdf:hilfetext/text()))">
				<xdf3:hilfetext><xsl:value-of select="./xdf:hilfetext"/></xdf3:hilfetext>
			</xsl:if>

		</xdf3:dokumentsteckbrief>
	</xsl:template>
	
	<!-- ############################################################################################################# -->
	
	<xsl:template match="xdf:regel">

		<xsl:if test="$DebugMode = '3' or $DebugMode = '4'">
			<xsl:message>
			++++ regel ++++
			Regel: <xsl:value-of select="./xdf:identifikation/xdf:id"/>
			</xsl:message>
		</xsl:if>

		<xdf3:regel>

			<xsl:variable name="BeschreibungNeu">
				Originalwerte der XDF2-Datei:
				ID: <xsl:value-of select="./xdf:identifikation/xdf:id"/><xsl:if test="not(empty(./xdf:identifikation/xdf:version/text()))">
				Version: <xsl:value-of select="./xdf:identifikation/xdf:version"/></xsl:if><xsl:if test="not(empty(./xdf:status/code/text()))">
				Status: <xsl:value-of select="./xdf:status/code"/></xsl:if><xsl:if test="fn:string-length(./xdf:script) &gt; 24">
				Skript: <xsl:value-of select="./xdf:script"/></xsl:if></xsl:variable>

			<xsl:if test="$OriginalwerteDoku = '2' or $OriginalwerteDoku = '3'">
				<xsl:comment>
					<xsl:value-of select="$BeschreibungNeu"/>
				</xsl:comment>
			</xsl:if>

			<xsl:apply-templates select="./xdf:identifikation"/>

			<xdf3:name><xsl:value-of select="./xdf:name"/></xdf3:name>

			<xsl:variable name="BeschreibungAlt"><xsl:choose><xsl:when test="fn:contains(./xdf:beschreibung/text(), 'Originalwerte der XDF3-Datei:')"><xsl:value-of select="fn:substring-before(./xdf:beschreibung/text(), 'Originalwerte der XDF3-Datei:')"/></xsl:when><xsl:otherwise><xsl:value-of select="./xdf:beschreibung"/></xsl:otherwise></xsl:choose></xsl:variable>

			<xsl:choose>
				<xsl:when test="$OriginalwerteDoku = '1' or $OriginalwerteDoku = '3'">
					<xdf3:beschreibung><xsl:if test="not(empty($BeschreibungAlt/text()))"><xsl:value-of select="$BeschreibungAlt"/><xsl:text>
					</xsl:text></xsl:if><xsl:value-of select="$BeschreibungNeu"/></xdf3:beschreibung>
				</xsl:when>
				<xsl:otherwise>
					<xsl:if test="not(empty($BeschreibungAlt/text()))"><xdf3:beschreibung><xsl:value-of select="$BeschreibungAlt"/></xdf3:beschreibung></xsl:if>
				</xsl:otherwise>
			</xsl:choose>

			<xsl:if test="not(empty(./xdf:definition/text()))">
				<xsl:choose>
					<xsl:when test="$FreitextRegelKorrektur ='1'">
<!--						<xsl:variable name="regellistealtesformat">
							<xdf:enthaltenebaukastenelemente>
								<xsl:analyze-string regex="[F|G]\d{{8}}" select="./xdf:definition">
									<xsl:matching-substring>
										<xdf:elementid><xsl:value-of select="."/></xdf:elementid>
									</xsl:matching-substring>
									<xsl:non-matching-substring>
									</xsl:non-matching-substring>
								</xsl:analyze-string>
							</xdf:enthaltenebaukastenelemente>
						</xsl:variable>
						<xsl:for-each-group select="$regellistealtesformat/*/xdf:elementid" group-by=".">
							<xsl:sort/>
							<div class="Fehler E1041">Fehler!! E1041: Baukastenelemente, die in Regeln referenziert werden, verwenden noch die alte, verkürzte Element-ID: <xsl:value-of select="."/>.</div> 
						</xsl:for-each-group>-->

						<xdf3:freitextRegel>
							<xsl:analyze-string regex="[F|G]\d{{8}}" select="./xdf:definition">
								<xsl:matching-substring>
									<xsl:variable name="IDAlt"><xsl:value-of select="."/></xsl:variable>
							
									<xsl:variable name="IDTemp">
										<xsl:for-each select="tokenize($SubstitutionB, ';')">
											<xsl:if test="$DebugMode = '4'">
												<xsl:message>
				SubstitutionB: <xsl:value-of select="."/>
												</xsl:message>
											</xsl:if>
											<xsl:if test="tokenize(., ',')[1] = fn:substring($IDAlt,2,2)">
												<xsl:variable name="IDTemp2"><xsl:value-of select="fn:concat(fn:substring($IDAlt,1,1),tokenize(., ',')[2],fn:substring($IDAlt,4))"/></xsl:variable>
												<xsl:choose>
													<xsl:when test="tokenize(., ',')[3]"><xsl:value-of select=" fn:concat( fn:substring($IDAlt,1,1) ,  fn:substring(       fn:string (          fn:format-number( fn:number(          fn:concat('1', fn:substring($IDTemp2,2))        ) + fn:number(tokenize(., ',')[3]), '########')    )   ,2  )   )     "/></xsl:when>
													<xsl:otherwise><xsl:value-of select="$IDTemp2"/></xsl:otherwise>
												</xsl:choose>
											</xsl:if>
										</xsl:for-each>
									</xsl:variable>
									
									<xsl:variable name="IDNeu">
										<xsl:choose>
											<xsl:when test="$IDTemp = ''"><xsl:value-of select="$IDAlt"/></xsl:when>
											<xsl:otherwise><xsl:value-of select="$IDTemp"/></xsl:otherwise>
										</xsl:choose>
									</xsl:variable>
									<xsl:value-of select="fn:substring($IDNeu,1,3)"/><xsl:value-of select="$Unternummernkreis"/><xsl:value-of select="fn:substring($IDNeu,4)"/>
								</xsl:matching-substring>
								<xsl:non-matching-substring>
									<xsl:value-of select="."/>
								</xsl:non-matching-substring>
							</xsl:analyze-string>
						</xdf3:freitextRegel>



<!--						<xdf3:freitextRegel><xsl:value-of select="fn:replace(./xdf:definition,'([F|G]\d\d)(\d{6})','$1000$2')"/></xdf3:freitextRegel>  -->


					</xsl:when>
					<xsl:otherwise>
						<xdf3:freitextRegel><xsl:value-of select="./xdf:definition"/></xdf3:freitextRegel>
					</xsl:otherwise>
				</xsl:choose>
			</xsl:if>

			<xsl:apply-templates select="./xdf:bezug"/>

			<xsl:if test="not(empty(./xdf:fachlicherErsteller/text()))">
				<xdf3:fachlicherErsteller><xsl:value-of select="./xdf:fachlicherErsteller"/></xdf3:fachlicherErsteller>
			</xsl:if>

			<xdf3:letzteAenderung><xsl:value-of select="//*/xdf:header/xdf:erstellungszeitpunkt"/></xdf3:letzteAenderung>

			<xdf3:typ listURI="urn:xoev-de:fim:codeliste:xdatenfelder.regeltyp" listVersionID="1.0">
				<code>K</code>
			</xdf3:typ>
		</xdf3:regel>
	</xsl:template>

	<!-- ############################################################################################################# -->
	
	<xsl:template name="strukturstart">
		<xsl:param name="Element"/>
		<xsl:param name="freigabedatumeltern"/>
		<xsl:param name="veroeffentlichungsdatumeltern"/>

		<xsl:if test="$DebugMode = '3' or $DebugMode = '4'">
			<xsl:message>
			++++ struktur ++++
			</xsl:message>
		</xsl:if>

		<xsl:choose>
			<xsl:when test="fn:count($Element/xdf:struktur) &gt; 0">
				<xsl:for-each select="$Element/xdf:struktur">
					<xsl:apply-templates select=".">
						<xsl:with-param name="freigabedatumeltern" select="$freigabedatumeltern"/>
						<xsl:with-param name="veroeffentlichungsdatumeltern" select="$veroeffentlichungsdatumeltern"/>
					</xsl:apply-templates>
				</xsl:for-each>
			</xsl:when>
			<xsl:otherwise>
					<xdf3:struktur>
						<xdf3:anzahl>1:1</xdf3:anzahl>
						<xdf3:enthaelt>
							<xdf3:datenfeld>
								<xdf3:identifikation>
									<xdf3:id>F60000000001</xdf3:id>
									<xdf3:version>1.0.0</xdf3:version>
								</xdf3:identifikation>
								<xdf3:name>Default-Datenfeld</xdf3:name>
								<xdf3:beschreibung>Dieses Feld darf nicht in Datenschemata oder Feldgruppen enthalten sein, welche die Status 'fachlich freigegeben (silber)' oder 'fachlich freigegeben (gold)' haben.</xdf3:beschreibung>
								<xdf3:definition>Da Datenschemata und Feldgruppen nicht leer sein dürfen, wird dieses Feld genutzt, wenn ein noch nicht spezifiziertes, ansonsten leeres Datenschema oder eine noch nicht spezifizierte, ansonsten leere Feldgruppe angelegt werden sollen.</xdf3:definition>
								<xdf3:freigabestatus listURI="urn:xoev-de:xprozess:codeliste:status" listVersionID="2020-03-19">
									<code>6</code>
								</xdf3:freigabestatus>
								<xdf3:statusGesetztAm>2024-03-21</xdf3:statusGesetztAm>
								<xdf3:statusGesetztDurch>FIM-Baustein Datenfelder</xdf3:statusGesetztDurch>
								<xdf3:versionshinweis>Beschreibung ergänzt</xdf3:versionshinweis>
								<xdf3:veroeffentlichungsdatum>2024-03-21</xdf3:veroeffentlichungsdatum>
								<xdf3:letzteAenderung>2024-03-21T13:14:56.226717Z</xdf3:letzteAenderung>
								<xdf3:bezeichnungEingabe>Default-Datenfeld</xdf3:bezeichnungEingabe>
								<xdf3:bezeichnungAusgabe>Default-Datenfeld</xdf3:bezeichnungAusgabe>
								<xdf3:schemaelementart listURI="urn:xoev-de:fim:codeliste:xdatenfelder.schemaelementart" listVersionID="1.0">
									<code>HAR</code>
								</xdf3:schemaelementart>
								<xdf3:hilfetextEingabe>Dies ist ein Platzhalter.</xdf3:hilfetextEingabe>
								<xdf3:hilfetextAusgabe>Dies ist ein Platzhalter.</xdf3:hilfetextAusgabe>
								<xdf3:feldart listURI="urn:xoev-de:fim:codeliste:xdatenfelder.feldart" listVersionID="2.0">
									<code>hidden</code>
								</xdf3:feldart>
								<xdf3:datentyp listURI="urn:xoev-de:fim:codeliste:xdatenfelder.datentyp" listVersionID="2.0">
									<code>text</code>
								</xdf3:datentyp>
								<xdf3:vorbefuellung listURI="urn:xoev-de:fim:codeliste:xdatenfelder.vorbefuellung" listVersionID="1.0">
									<code>keine</code>
								</xdf3:vorbefuellung>
							</xdf3:datenfeld>
						</xdf3:enthaelt>
					</xdf3:struktur>
			
			</xsl:otherwise>
		</xsl:choose>


		
	</xsl:template>

	<!-- ############################################################################################################# -->
	
	<xsl:template match="xdf:struktur">
		<xsl:param name="freigabedatumeltern"/>
		<xsl:param name="veroeffentlichungsdatumeltern"/>

		<xsl:if test="$DebugMode = '3' or $DebugMode = '4'">
			<xsl:message>
			++++ struktur ++++
			</xsl:message>
		</xsl:if>

		<xdf3:struktur>
			<xdf3:anzahl><xsl:value-of select="./xdf:anzahl"/></xdf3:anzahl>
			<xsl:apply-templates select="./xdf:bezug"/>
			<xdf3:enthaelt>
				<xsl:apply-templates select="./xdf:enthaelt/xdf:datenfeld | ./xdf:enthaelt/xdf:datenfeldgruppe">
					<xsl:with-param name="freigabedatumeltern" select="$freigabedatumeltern"/>
					<xsl:with-param name="veroeffentlichungsdatumeltern" select="$veroeffentlichungsdatumeltern"/>
				</xsl:apply-templates>
			</xdf3:enthaelt>
			
		</xdf3:struktur>
	</xsl:template>

	<!-- ############################################################################################################# -->
	
	<xsl:template match="xdf:datenfeld">
		<xsl:param name="freigabedatumeltern"/>
		<xsl:param name="veroeffentlichungsdatumeltern"/>

		<xsl:if test="$DebugMode = '2' or $DebugMode = '3' or $DebugMode = '4'">
			<xsl:message>
				++++ datenfeld ++++
				Datenfeld: <xsl:value-of select="./xdf:identifikation/xdf:id"/>
			</xsl:message>
		</xsl:if>

		<xdf3:datenfeld>

			<xsl:variable name="BeschreibungNeu">
				Originalwerte der XDF2-Datei:
				ID: <xsl:value-of select="./xdf:identifikation/xdf:id"/><xsl:if test="not(empty(./xdf:identifikation/xdf:version/text()))">
				Version: <xsl:value-of select="./xdf:identifikation/xdf:version"/></xsl:if><xsl:if test="not(empty(./xdf:status/code/text()))">
				Status: <xsl:value-of select="./xdf:status/code"/></xsl:if><xsl:if test="./xdf:codelisteReferenz">
				Codeliste: <xsl:value-of select="./xdf:codelisteReferenz/xdf:identifikation/xdf:id"/>
				<xsl:call-template name="codelistenInhalte"><xsl:with-param name="Element" select="./xdf:codelisteReferenz"/></xsl:call-template>
				Codeliste-Canonical-Identification: <xsl:value-of select="./xdf:codelisteReferenz/xdf:genericodeIdentification/xdf:canonicalIdentification"/>
				Codeliste-Version: <xsl:value-of select="./xdf:codelisteReferenz/xdf:genericodeIdentification/xdf:version"/></xsl:if></xsl:variable>

			<xsl:if test="$OriginalwerteDoku = '2' or $OriginalwerteDoku = '3'">
				<xsl:comment>
					<xsl:value-of select="$BeschreibungNeu"/>
				</xsl:comment>
			</xsl:if>

			<xsl:apply-templates select="./xdf:identifikation"/>

			<xdf3:name><xsl:value-of select="./xdf:name"/></xdf3:name>

			<xsl:variable name="BeschreibungAlt"><xsl:choose><xsl:when test="fn:contains(./xdf:beschreibung/text(), 'Originalwerte der XDF3-Datei:')"><xsl:value-of select="fn:substring-before(./xdf:beschreibung/text(), 'Originalwerte der XDF3-Datei:')"/></xsl:when><xsl:otherwise><xsl:value-of select="./xdf:beschreibung"/></xsl:otherwise></xsl:choose></xsl:variable>

			<xsl:choose>
				<xsl:when test="$OriginalwerteDoku = '1' or $OriginalwerteDoku = '3'">
					<xdf3:beschreibung><xsl:if test="not(empty($BeschreibungAlt/text()))"><xsl:value-of select="$BeschreibungAlt"/><xsl:text>
					</xsl:text></xsl:if><xsl:value-of select="$BeschreibungNeu"/></xdf3:beschreibung>
				</xsl:when>
				<xsl:otherwise>
					<xsl:if test="not(empty($BeschreibungAlt/text()))"><xdf3:beschreibung><xsl:value-of select="$BeschreibungAlt"/></xdf3:beschreibung></xsl:if>
				</xsl:otherwise>
			</xsl:choose>

			<xsl:if test="not(empty(./xdf:definition/text()))">
				<xdf3:definition><xsl:value-of select="./xdf:definition"/></xdf3:definition>
			</xsl:if>

			<xsl:apply-templates select="./xdf:bezug"/>

			<xsl:apply-templates select="./xdf:status"/>

			<xsl:variable name="freigabedatum">
				<xsl:choose>
					<xsl:when test="not(empty(./xdf:freigabedatum/text()))">
						<xsl:value-of select="./xdf:freigabedatum/text()"/>
					</xsl:when>
					<xsl:otherwise>
						<xsl:value-of select="$freigabedatumeltern"/>
					</xsl:otherwise>
				</xsl:choose>
			</xsl:variable>

			<xsl:if test="not(empty($freigabedatum/text()))">
				<xdf3:statusGesetztAm><xsl:value-of select="$freigabedatum"/></xdf3:statusGesetztAm>
			</xsl:if>

			<xsl:if test="not(empty(./xdf:fachlicherErsteller/text()))">
				<xdf3:statusGesetztDurch><xsl:value-of select="./xdf:fachlicherErsteller"/></xdf3:statusGesetztDurch>
			</xsl:if>

			<xsl:if test="not(empty(./xdf:gueltigAb/text()))">
				<xdf3:gueltigAb><xsl:value-of select="./xdf:gueltigAb"/></xdf3:gueltigAb>
			</xsl:if>

			<xsl:if test="not(empty(./xdf:gueltigBis/text()))">
				<xdf3:gueltigBis><xsl:value-of select="./xdf:gueltigBis"/></xdf3:gueltigBis>
			</xsl:if>

			<xsl:if test="not(empty(./xdf:versionshinweis/text()))">
				<xdf3:versionshinweis><xsl:value-of select="./xdf:versionshinweis"/></xdf3:versionshinweis>
			</xsl:if>

			<xsl:variable name="veroeffentlichungsdatum">
				<xsl:choose>
					<xsl:when test="not(empty(./xdf:veroeffentlichungsdatum/text()))">
						<xsl:value-of select="./xdf:veroeffentlichungsdatum/text()"/>
					</xsl:when>
					<xsl:otherwise>
						<xsl:value-of select="$veroeffentlichungsdatumeltern"/>
					</xsl:otherwise>
				</xsl:choose>
			</xsl:variable>

			<xsl:if test="not(empty($veroeffentlichungsdatum/text()))">
				<xdf3:veroeffentlichungsdatum><xsl:value-of select="$veroeffentlichungsdatum"/></xdf3:veroeffentlichungsdatum>
			</xsl:if>

			<xdf3:letzteAenderung><xsl:value-of select="//*/xdf:header/xdf:erstellungszeitpunkt"/></xdf3:letzteAenderung>

			<xdf3:bezeichnungEingabe><xsl:value-of select="./xdf:bezeichnungEingabe"/></xdf3:bezeichnungEingabe>

			<xsl:if test="not(empty(./xdf:bezeichnungAusgabe/text()))">
				<xdf3:bezeichnungAusgabe><xsl:value-of select="./xdf:bezeichnungAusgabe"/></xdf3:bezeichnungAusgabe>
			</xsl:if>

			<xdf3:schemaelementart listURI="urn:xoev-de:fim:codeliste:xdatenfelder.schemaelementart" listVersionID="1.0">
				<code><xsl:value-of select="./xdf:schemaelementart/code"/></code>
			</xdf3:schemaelementart>

			<xsl:if test="not(empty(./xdf:hilfetextEingabe/text()))">
				<xdf3:hilfetextEingabe><xsl:value-of select="./xdf:hilfetextEingabe"/></xdf3:hilfetextEingabe>
			</xsl:if>

			<xsl:if test="not(empty(./xdf:hilfetextAusgabe/text()))">
				<xdf3:hilfetextAusgabe><xsl:value-of select="./xdf:hilfetextAusgabe"/></xdf3:hilfetextAusgabe>
			</xsl:if>

			<xdf3:feldart listURI="urn:xoev-de:fim:codeliste:xdatenfelder.feldart" listVersionID="2.0">
				<code><xsl:value-of select="./xdf:feldart/code"/></code>
			</xdf3:feldart>

			<xdf3:datentyp listURI="urn:xoev-de:fim:codeliste:xdatenfelder.datentyp" listVersionID="2.0">
				<code><xsl:value-of select="./xdf:datentyp/code"/></code>
			</xdf3:datentyp>

			<xsl:apply-templates select="./xdf:praezisierung"/>

			<xsl:if test="not(empty(./xdf:inhalt/text()))">
				<xdf3:inhalt><xsl:value-of select="./xdf:inhalt"/></xdf3:inhalt>
			</xsl:if>

			<xdf3:vorbefuellung listURI="urn:xoev-de:fim:codeliste:xdatenfelder.vorbefuellung" listVersionID="1.0">
				<code>keine</code>
			</xdf3:vorbefuellung>

			<xsl:apply-templates select="./xdf:codelisteReferenz"/>

			<xsl:for-each select="./xdf:regel">
				<xsl:apply-templates select="."/>
			</xsl:for-each>

		</xdf3:datenfeld>
	</xsl:template>

	<!-- ############################################################################################################# -->
	
	<xsl:template match="xdf:datenfeldgruppe">
		<xsl:param name="freigabedatumeltern"/>
		<xsl:param name="veroeffentlichungsdatumeltern"/>

		<xsl:if test="$DebugMode = '2' or $DebugMode = '3' or $DebugMode = '4'">
			<xsl:message>
		++++ datenfeldgruppe ++++
		Datenfeldgruppe: <xsl:value-of select="./xdf:identifikation/xdf:id"/>
			</xsl:message>
		</xsl:if>

		<xdf3:datenfeldgruppe>

			<xsl:variable name="BeschreibungNeu">
				Originalwerte der XDF2-Datei:
				ID: <xsl:value-of select="./xdf:identifikation/xdf:id"/><xsl:if test="not(empty(./xdf:identifikation/xdf:version/text()))">
				Version: <xsl:value-of select="./xdf:identifikation/xdf:version"/></xsl:if><xsl:if test="not(empty(./xdf:status/code/text()))">
				Status: <xsl:value-of select="./xdf:status/code"/></xsl:if><xsl:if test="fn:count(./xdf:struktur) = 0">
				ACHTUNG: Eine Datenfeldgruppe muss in XDF3 Unterelemente haben, deshalb wurde das BOB-Feld F60000000001 'Default-Datenfeld' eingefügt, um Schemakonformität sicherzustellen.</xsl:if></xsl:variable>

			<xsl:if test="$OriginalwerteDoku = '2' or $OriginalwerteDoku = '3'">
				<xsl:comment>
					<xsl:value-of select="$BeschreibungNeu"/>
				</xsl:comment>
			</xsl:if>

			<xsl:apply-templates select="./xdf:identifikation"/>

			<xdf3:name><xsl:value-of select="./xdf:name"/></xdf3:name>

			<xsl:variable name="BeschreibungAlt"><xsl:choose><xsl:when test="fn:contains(./xdf:beschreibung/text(), 'Originalwerte der XDF3-Datei:')"><xsl:value-of select="fn:substring-before(./xdf:beschreibung/text(), 'Originalwerte der XDF3-Datei:')"/></xsl:when><xsl:otherwise><xsl:value-of select="./xdf:beschreibung"/></xsl:otherwise></xsl:choose></xsl:variable>

			<xsl:choose>
				<xsl:when test="$OriginalwerteDoku = '1' or $OriginalwerteDoku = '3'">
					<xdf3:beschreibung><xsl:if test="not(empty($BeschreibungAlt/text()))"><xsl:value-of select="$BeschreibungAlt"/><xsl:text>
					</xsl:text></xsl:if><xsl:value-of select="$BeschreibungNeu"/></xdf3:beschreibung>
				</xsl:when>
				<xsl:otherwise>
					<xsl:if test="not(empty($BeschreibungAlt/text()))"><xdf3:beschreibung><xsl:value-of select="$BeschreibungAlt"/></xdf3:beschreibung></xsl:if>
				</xsl:otherwise>
			</xsl:choose>

			<xsl:if test="not(empty(./xdf:definition/text()))">
				<xdf3:definition><xsl:value-of select="./xdf:definition"/></xdf3:definition>
			</xsl:if>

			<xsl:apply-templates select="./xdf:bezug"/>

			<xsl:apply-templates select="./xdf:status"/>

			<xsl:variable name="freigabedatum">
				<xsl:choose>
					<xsl:when test="not(empty(./xdf:freigabedatum/text()))">
						<xsl:value-of select="./xdf:freigabedatum/text()"/>
					</xsl:when>
					<xsl:otherwise>
						<xsl:value-of select="$freigabedatumeltern"/>
					</xsl:otherwise>
				</xsl:choose>
			</xsl:variable>

			<xsl:if test="not(empty($freigabedatum/text()))">
				<xdf3:statusGesetztAm><xsl:value-of select="$freigabedatum"/></xdf3:statusGesetztAm>
			</xsl:if>

			<xsl:if test="not(empty(./xdf:fachlicherErsteller/text()))">
				<xdf3:statusGesetztDurch><xsl:value-of select="./xdf:fachlicherErsteller"/></xdf3:statusGesetztDurch>
			</xsl:if>

			<xsl:if test="not(empty(./xdf:gueltigAb/text()))">
				<xdf3:gueltigAb><xsl:value-of select="./xdf:gueltigAb"/></xdf3:gueltigAb>
			</xsl:if>

			<xsl:if test="not(empty(./xdf:gueltigBis/text()))">
				<xdf3:gueltigBis><xsl:value-of select="./xdf:gueltigBis"/></xdf3:gueltigBis>
			</xsl:if>

			<xsl:if test="not(empty(./xdf:versionshinweis/text()))">
				<xdf3:versionshinweis><xsl:value-of select="./xdf:versionshinweis"/></xdf3:versionshinweis>
			</xsl:if>

			<xsl:variable name="veroeffentlichungsdatum">
				<xsl:choose>
					<xsl:when test="not(empty(./xdf:veroeffentlichungsdatum/text()))">
						<xsl:value-of select="./xdf:veroeffentlichungsdatum/text()"/>
					</xsl:when>
					<xsl:otherwise>
						<xsl:value-of select="$veroeffentlichungsdatumeltern"/>
					</xsl:otherwise>
				</xsl:choose>
			</xsl:variable>

			<xsl:if test="not(empty($veroeffentlichungsdatum/text()))">
				<xdf3:veroeffentlichungsdatum><xsl:value-of select="$veroeffentlichungsdatum"/></xdf3:veroeffentlichungsdatum>
			</xsl:if>

			<xdf3:letzteAenderung><xsl:value-of select="//*/xdf:header/xdf:erstellungszeitpunkt"/></xdf3:letzteAenderung>

			<xdf3:bezeichnungEingabe><xsl:value-of select="./xdf:bezeichnungEingabe"/></xdf3:bezeichnungEingabe>

			<xsl:if test="not(empty(./xdf:bezeichnungAusgabe/text()))">
				<xdf3:bezeichnungAusgabe><xsl:value-of select="./xdf:bezeichnungAusgabe"/></xdf3:bezeichnungAusgabe>
			</xsl:if>

			<xdf3:schemaelementart listURI="urn:xoev-de:fim:codeliste:xdatenfelder.schemaelementart" listVersionID="1.0">
				<code><xsl:value-of select="./xdf:schemaelementart/code"/></code>
			</xdf3:schemaelementart>

			<xsl:if test="not(empty(./xdf:hilfetextEingabe/text()))">
				<xdf3:hilfetextEingabe><xsl:value-of select="./xdf:hilfetextEingabe"/></xdf3:hilfetextEingabe>
			</xsl:if>

			<xsl:if test="not(empty(./xdf:hilfetextAusgabe/text()))">
				<xdf3:hilfetextAusgabe><xsl:value-of select="./xdf:hilfetextAusgabe"/></xdf3:hilfetextAusgabe>
			</xsl:if>

			<xsl:for-each select="./xdf:regel">
				<xsl:apply-templates select="."/>
			</xsl:for-each>

			<xsl:call-template name="strukturstart">
				<xsl:with-param name="Element" select="."/>
				<xsl:with-param name="freigabedatumeltern" select="$freigabedatum"/>
				<xsl:with-param name="veroeffentlichungsdatumeltern" select="$veroeffentlichungsdatum"/>
			</xsl:call-template>

		</xdf3:datenfeldgruppe>
	</xsl:template>

	<!-- ############################################################################################################# -->
	
	<xsl:template match="xdf:identifikation">

		<xsl:if test="$DebugMode = '3' or $DebugMode = '4'">
			<xsl:message>
			++++ identifikation ++++
			</xsl:message>
		</xsl:if>
		<xsl:variable name="IDAlt"><xsl:value-of select="./xdf:id"/></xsl:variable>

		<xsl:variable name="IDTemp">
			<xsl:choose>
				<xsl:when test="fn:string-length($MappingInhalt) &gt; 9">
					<xsl:choose>
						<xsl:when test="$MappingInhalt/*/SimpleCodeList/Row[./Value/SimpleValue=$IDAlt]"><xsl:value-of select="$MappingInhalt/*/SimpleCodeList/Row[./Value/SimpleValue=$IDAlt]/Value[./@ColumnRef='IDNeu']/SimpleValue"/></xsl:when>
						<xsl:otherwise><xsl:value-of select="$IDAlt"/></xsl:otherwise>
					</xsl:choose>
				</xsl:when>
				<xsl:when test="fn:substring(./xdf:id,1,1) = 'S' or fn:substring(./xdf:id,1,1) = 'D'">
					<xsl:for-each select="tokenize($SubstitutionS, ';')">
						<xsl:if test="$DebugMode = '4'">
							<xsl:message>
				SubstitutionS: <xsl:value-of select="."/>
							</xsl:message>
						</xsl:if>
						<xsl:if test="tokenize(., ',')[1] = fn:substring($IDAlt,2,2)">
							<xsl:variable name="IDTemp2"><xsl:value-of select="fn:concat(fn:substring($IDAlt,1,1),tokenize(., ',')[2],fn:substring($IDAlt,4))"/></xsl:variable>
							<xsl:choose>
								<xsl:when test="tokenize(., ',')[3]"><xsl:value-of select=" fn:concat( fn:substring($IDAlt,1,1) ,  fn:substring(       fn:string (          fn:format-number( fn:number(          fn:concat('1', fn:substring($IDTemp2,2))        ) + fn:number(tokenize(., ',')[3]), '########')    )   ,2  )   )     "/></xsl:when>
								<xsl:otherwise><xsl:value-of select="$IDTemp2"/></xsl:otherwise>
							</xsl:choose>
						</xsl:if>
					</xsl:for-each>
				</xsl:when>
				<xsl:otherwise>
					<xsl:for-each select="tokenize($SubstitutionB, ';')">
						<xsl:if test="$DebugMode = '4'">
							<xsl:message>
				SubstitutionB: <xsl:value-of select="."/>
							</xsl:message>
						</xsl:if>
						<xsl:if test="tokenize(., ',')[1] = fn:substring($IDAlt,2,2)">
							<xsl:variable name="IDTemp2"><xsl:value-of select="fn:concat(fn:substring($IDAlt,1,1),tokenize(., ',')[2],fn:substring($IDAlt,4))"/></xsl:variable>
							<xsl:choose>
								<xsl:when test="tokenize(., ',')[3]"><xsl:value-of select=" fn:concat( fn:substring($IDAlt,1,1) ,  fn:substring(       fn:string (          fn:format-number( fn:number(          fn:concat('1', fn:substring($IDTemp2,2))        ) + fn:number(tokenize(., ',')[3]), '########')    )   ,2  )   )     "/></xsl:when>
								<xsl:otherwise><xsl:value-of select="$IDTemp2"/></xsl:otherwise>
							</xsl:choose>
						</xsl:if>
					</xsl:for-each>
				</xsl:otherwise>
			</xsl:choose>
		</xsl:variable>
		
		<xsl:variable name="IDNeu">
			<xsl:choose>
				<xsl:when test="$IDTemp = ''"><xsl:value-of select="$IDAlt"/></xsl:when>
				<xsl:otherwise><xsl:value-of select="$IDTemp"/></xsl:otherwise>
			</xsl:choose>
		</xsl:variable>

		<xdf3:identifikation>
			<xsl:choose>
				<xsl:when test="empty(./xdf:version/text())">
						<xdf3:id><xsl:value-of select="fn:substring($IDNeu,1,3)"/><xsl:value-of select="$Unternummernkreis"/><xsl:value-of select="fn:substring($IDNeu,4)"/></xdf3:id>
				</xsl:when>
				<xsl:otherwise>
						<xdf3:id><xsl:value-of select="fn:substring($IDNeu,1,3)"/><xsl:value-of select="$Unternummernkreis"/><xsl:value-of select="fn:substring($IDNeu,4)"/></xdf3:id>
						<xdf3:version><xsl:value-of select="./xdf:version"/>.0</xdf3:version>
				</xsl:otherwise>
			</xsl:choose>
		</xdf3:identifikation>
	</xsl:template>

	<!-- ############################################################################################################# -->
	
	<xsl:template match="xdf:bezug">

		<xsl:if test="$DebugMode = '3' or $DebugMode = '4'">
			<xsl:message>
			++++ bezug ++++
			</xsl:message>
		</xsl:if>

		<xsl:choose>
			<xsl:when test="$BezuegeAufteilen = '1'">
				<xsl:if test="$DebugMode = '4'">
						<xsl:message>
				++++ Bezüge ++++
						</xsl:message>
				</xsl:if>

				<xsl:for-each select="tokenize(., ';')">
					<xsl:if test="$DebugMode = '4'">
						<xsl:message>
				Bezug: --<xsl:value-of select="."/>++
						</xsl:message>
					</xsl:if>
			
					<xsl:if test="fn:string-length(fn:normalize-space(.)) &gt; 0">
						<xdf3:bezug><xsl:value-of select="fn:normalize-space(.)"/></xdf3:bezug>
					</xsl:if>
				</xsl:for-each>
			</xsl:when>
			<xsl:otherwise>
				<xsl:if test="fn:string-length(fn:normalize-space(.)) &gt; 0">
					<xdf3:bezug><xsl:value-of select="fn:normalize-space(.)"/></xdf3:bezug>
				</xsl:if>
			</xsl:otherwise>
		</xsl:choose>
	</xsl:template>

	<!-- ############################################################################################################# -->
	
	<xsl:template match="xdf:dokumentart">

		<xsl:if test="$DebugMode = '3' or $DebugMode = '4'">
			<xsl:message>
				++++ dokumentart ++++
			</xsl:message>
		</xsl:if>

		<xsl:variable name="CodelisteAbfrageURL" select="fn:concat($XMLXRepoMitVersionPfadPrefix,'urn:xoev-de:fim-datenfelder:codeliste:dokumentart_2022-01-01',$XMLXRepoMitVersionPfadPostfix)"/>
		<xsl:variable name="CodelisteAbfrageInhalt">
			<xsl:choose>
				<xsl:when test="fn:doc-available($CodelisteAbfrageURL)">
					<xsl:copy-of select="fn:document($CodelisteAbfrageURL)"/>
					<xsl:if test="$DebugMode = '4'">
						<xsl:message>
				URL
						</xsl:message>
					</xsl:if>
				</xsl:when>
				<xsl:otherwise>
					<xsl:if test="$DebugMode = '4'">
						<xsl:message>
				LEER
						</xsl:message>
					</xsl:if>
				</xsl:otherwise>
			</xsl:choose>
		</xsl:variable>
		<xdf3:dokumentart listURI="urn:xoev-de:fim-datenfelder:codeliste:dokumentart" listVersionID="2022-01-01">
			<code>
				<xsl:choose>
					<xsl:when test="fn:string-length($CodelisteAbfrageInhalt) &lt; 10">999</xsl:when>
					<xsl:otherwise>
						<xsl:variable name="CodelisteURL" select="fn:concat($XMLXRepoMitVersionPfadPrefix,$CodelisteAbfrageInhalt/dat:VersionCodeliste/dat:kennung,$XMLXRepoMitVersionPfadPostfix)"/>
						<xsl:variable name="CodelisteInhalt">
							<xsl:choose>
								<xsl:when test="fn:doc-available($CodelisteURL)">
									<xsl:copy-of select="fn:document($CodelisteURL)"/>
									<xsl:if test="$DebugMode = '4'">
										<xsl:message>
				URL
										</xsl:message>
									</xsl:if>
								</xsl:when>
								<xsl:otherwise>
									<xsl:if test="$DebugMode = '4'">
										<xsl:message>
				LEER
										</xsl:message>
									</xsl:if>
								</xsl:otherwise>
							</xsl:choose>
						</xsl:variable>
						<xsl:message>
							<xsl:copy-of select="$CodelisteInhalt"/>
						</xsl:message>
						<xsl:choose>
							<xsl:when test="fn:string-length($CodelisteInhalt) &lt; 10">999</xsl:when>
							<xsl:otherwise><xsl:variable name="Name" select="."/><xsl:value-of select="$CodelisteInhalt/*/gc:SimpleCodeList/gc:Row[./gc:Value/gc:SimpleValue=$Name]/gc:Value[./@ColumnRef='Code']/gc:SimpleValue"/><xsl:value-of select="$CodelisteInhalt/*/SimpleCodeList/Row[./Value/SimpleValue=$Name]/Value[./@ColumnRef='Code']/SimpleValue"/></xsl:otherwise>
						</xsl:choose>
					</xsl:otherwise>
				</xsl:choose>
			</code>
		</xdf3:dokumentart>

	</xsl:template>

	<!-- ############################################################################################################# -->
	
	<xsl:template match="xdf:status">

		<xsl:if test="$DebugMode = '3' or $DebugMode = '4'">
			<xsl:message>
			++++ status ++++
			</xsl:message>
		</xsl:if>

		<xsl:variable name="Status">
			<xsl:value-of select="./code"/>
		</xsl:variable>

		<xsl:variable name="Fixierungsgrad">
			<xsl:choose>
				<xsl:when test="empty(../xdf:identifikation/xdf:version/text())">Arbeitskopie</xsl:when>
				<xsl:otherwise>Version</xsl:otherwise>
			</xsl:choose>
		</xsl:variable>
		
		<xsl:variable name="Freigabe">
			<xsl:choose>
				<xsl:when test="empty(../xdf:freigabedatum/text())">Nein</xsl:when>
				<xsl:otherwise>Ja</xsl:otherwise>
			</xsl:choose>
		</xsl:variable>
		
		<xsl:variable name="Veroeffentlichung">
			<xsl:choose>
				<xsl:when test="empty(../xdf:veroeffentlichungsdatum/text())">Nein</xsl:when>
				<xsl:otherwise>Ja</xsl:otherwise>
			</xsl:choose>
		</xsl:variable>
		
		<xsl:if test="$DebugMode = '4'">
			<xsl:message>
				++++ Statuswerte ++++
				Status: <xsl:value-of select="$Status"/>
				Fixierungsgrad: <xsl:value-of select="$Fixierungsgrad"/>
				Freigabe: <xsl:value-of select="$Freigabe"/>
				Veroeffentlichung: <xsl:value-of select="$Veroeffentlichung"/>
			</xsl:message>
		</xsl:if>

		<xsl:choose>
			<xsl:when test="$ZwingeStatus != ''">
				<xdf3:freigabestatus listURI="urn:xoev-de:xprozess:codeliste:status" listVersionID="2020-03-19">
					<code><xsl:value-of select="$ZwingeStatus"/></code>
				</xdf3:freigabestatus>
			</xsl:when>
			<xsl:when test="$Status = 'inaktiv'">
				<xdf3:freigabestatus listURI="urn:xoev-de:xprozess:codeliste:status" listVersionID="2020-03-19">
					<code>7</code>
				</xdf3:freigabestatus>
			</xsl:when>
			<xsl:otherwise>
				<xsl:choose>
					<xsl:when test="$Fixierungsgrad = 'Arbeitskopie'">
						<xdf3:freigabestatus listURI="urn:xoev-de:xprozess:codeliste:status" listVersionID="2020-03-19">
							<code>2</code>
						</xdf3:freigabestatus>
					</xsl:when>
					<xsl:otherwise>
						<xsl:choose>
							<xsl:when test="$Freigabe = 'Nein'">
								<xdf3:freigabestatus listURI="urn:xoev-de:xprozess:codeliste:status" listVersionID="2020-03-19">
									<code>2</code>
								</xdf3:freigabestatus>
							</xsl:when>
							<xsl:otherwise>
								<xdf3:freigabestatus listURI="urn:xoev-de:xprozess:codeliste:status" listVersionID="2020-03-19">
									<code>6</code>
								</xdf3:freigabestatus>
							</xsl:otherwise>
						</xsl:choose>
					</xsl:otherwise>
				</xsl:choose>
			</xsl:otherwise>
		</xsl:choose>
	</xsl:template>

	<!-- ############################################################################################################# -->
	
	<xsl:template match="xdf:praezisierung">

		<xsl:if test="$DebugMode = '3' or $DebugMode = '4'">
			<xsl:message>
			++++ praezisierung ++++
			</xsl:message>
		</xsl:if>

		<xsl:if test="not(empty(./text()))">
			<xsl:variable name="minValue">
				<xsl:if test="./text() != ''">
					<xsl:if test="substring-before(substring-after(.,'minValue&quot;:&quot;'),'&quot;') != ''">
						<xsl:value-of select="substring-before(substring-after(.,'minValue&quot;:&quot;'),'&quot;')"/>
					</xsl:if>
				</xsl:if>
			</xsl:variable>
			<xsl:variable name="maxValue">
				<xsl:if test="./text() != ''">
					<xsl:if test="substring-before(substring-after(.,'maxValue&quot;:&quot;'),'&quot;') != ''">
						<xsl:value-of select="substring-before(substring-after(.,'maxValue&quot;:&quot;'),'&quot;')"/>
					</xsl:if>
				</xsl:if>
			</xsl:variable>
			<xsl:variable name="minLength">
				<xsl:if test="./text() != ''">
					<xsl:if test="substring-before(substring-after(.,'minLength&quot;:&quot;'),'&quot;') != ''">
						<xsl:value-of select="substring-before(substring-after(.,'minLength&quot;:&quot;'),'&quot;')"/>
					</xsl:if>
				</xsl:if>
			</xsl:variable>
			<xsl:variable name="maxLength">
				<xsl:if test="./text() != ''">
					<xsl:if test="substring-before(substring-after(.,'maxLength&quot;:&quot;'),'&quot;') != ''">
						<xsl:value-of select="substring-before(substring-after(.,'maxLength&quot;:&quot;'),'&quot;')"/>
					</xsl:if>
				</xsl:if>
			</xsl:variable>
			<xsl:variable name="Pattern">
				<xsl:if test="./text() != ''">
					<xsl:if test="substring-before(substring-after(.,'pattern&quot;:&quot;'),'&quot;') != ''">
						<xsl:value-of select="substring-before(substring-after(.,'pattern&quot;:&quot;'),'&quot;')"/>
					</xsl:if>
				</xsl:if>
			</xsl:variable>
			
			<xsl:if test="$DebugMode = '4'">
				<xsl:message>
				++++ Präzisierungswerte ++++
				minValue: <xsl:value-of select="$minValue"/>
				maxValue: <xsl:value-of select="$maxValue"/>
				minLength: <xsl:value-of select="$minLength"/>
				maxLength: <xsl:value-of select="$maxLength"/>
				Pattern: <xsl:value-of select="$Pattern"/>
				</xsl:message>
			</xsl:if>
	
			<xsl:element name="xdf3:praezisierung">
				<xsl:if test="$minValue != ''">
					<xsl:attribute name="minValue"><xsl:value-of select="$minValue"/></xsl:attribute>
				</xsl:if>
				<xsl:if test="$maxValue != ''">
					<xsl:attribute name="maxValue"><xsl:value-of select="$maxValue"/></xsl:attribute>
				</xsl:if>
				<xsl:if test="$minLength != '' and ($minLength castable as xs:nonNegativeInteger)">
					<xsl:attribute name="minLength"><xsl:value-of select="$minLength"/></xsl:attribute>
				</xsl:if>
				<xsl:if test="$maxLength != '' and ($maxLength castable as xs:positiveInteger)">
					<xsl:attribute name="maxLength"><xsl:value-of select="$maxLength"/></xsl:attribute>
				</xsl:if>
				<xsl:if test="$Pattern != ''">
					<xsl:attribute name="pattern"><xsl:value-of select="$Pattern"/></xsl:attribute>
				</xsl:if>
			</xsl:element>
		</xsl:if>
	</xsl:template>

	<!-- ############################################################################################################# -->
	
	<xsl:template match="xdf:codelisteReferenz">

		<xsl:if test="$DebugMode = '3' or $DebugMode = '4'">
			<xsl:message>
			++++ codelisteReferenz ++++
			Codeliste: <xsl:value-of select="./xdf:genericodeIdentification/xdf:canonicalVersionUri"/>
			</xsl:message>
		</xsl:if>
		
		<xsl:variable name="InterneCodeliste">
			<xsl:if test="$Codelisten2Wertelisten ='1'">
				<xsl:variable name="Kennung"><xsl:value-of select="./xdf:genericodeIdentification/xdf:canonicalIdentification"/></xsl:variable>
				<xsl:for-each select="fn:tokenize($CodelistenInternIdentifier,';')">
					<xsl:if test="fn:contains($Kennung,.)">
						enthalten
					</xsl:if>
				</xsl:for-each>
			</xsl:if>
		</xsl:variable>
		
		<xsl:variable name="ExterneCodelisteErreichbar">
			<xsl:if test="$PruefeCodelistenErreichbarkeit ='1'">
				<xsl:variable name="CodelisteURL" select="fn:concat($XMLXRepoMitVersionPfadPrefix,./xdf:genericodeIdentification/xdf:canonicalVersionUri,$XMLXRepoMitVersionPfadPostfix)"/> 
				<xsl:if test="not(fn:doc-available($CodelisteURL))">
					nicht erreichbar
				</xsl:if>
			</xsl:if>
		</xsl:variable>
		
		<xsl:choose>
			<xsl:when test="$InterneCodeliste='' and $ExterneCodelisteErreichbar=''">
				<xdf3:codelisteReferenz>
					<xdf3:canonicalIdentification><xsl:value-of select="./xdf:genericodeIdentification/xdf:canonicalIdentification"/></xdf3:canonicalIdentification>
					<xdf3:version><xsl:value-of select="./xdf:genericodeIdentification/xdf:version"/></xdf3:version>
					<xdf3:canonicalVersionUri><xsl:value-of select="./xdf:genericodeIdentification/xdf:canonicalVersionUri"/></xdf3:canonicalVersionUri>
				</xdf3:codelisteReferenz>
			</xsl:when>
			<xsl:otherwise>
				<xsl:variable name="CodelisteDatei" select="concat($InputPfad,./xdf:identifikation/xdf:id, '_genericode.xml')"/>

				<xsl:variable name="CodelisteInhalt">
					<xsl:choose>
						<xsl:when test="fn:doc-available($CodelisteDatei)">
							<xsl:copy-of select="fn:document($CodelisteDatei)"/>
							<xsl:if test="$DebugMode = '4'">
				<xsl:message>FILE2</xsl:message>
							</xsl:if>
						</xsl:when>
						<xsl:otherwise>
								<xsl:if test="$DebugMode = '4'">
				<xsl:message>LEER</xsl:message>
								</xsl:if>
						</xsl:otherwise>
					</xsl:choose>
				</xsl:variable>

				<xsl:choose>
					<xsl:when test="fn:string-length($CodelisteInhalt) &lt; 10">
						<xdf3:werte>
								<xdf3:wert>
									<xdf3:code>xxx</xdf3:code>
									<xdf3:name>ACHTUNG!! Die Codeliste <xsl:value-of select="$CodelisteDatei"/> konnte nicht geladen umd somit nicht in eine Werteliste umgewandelt werden!</xdf3:name>
								</xdf3:wert>
						</xdf3:werte>
						<xsl:if test="$DebugMode = '2'">
							<xsl:message>
		Fehler!! Die Codeliste <xsl:value-of select="$CodelisteDatei"/> konnte nicht geladen umd somit nicht in eine Werteliste umgewandelt werden!
							</xsl:message>
						</xsl:if>
					</xsl:when> 
					<xsl:otherwise>
						<xdf3:werte>
							<xsl:choose>
								<xsl:when test="count($CodelisteInhalt/*/gc:SimpleCodeList/gc:Row) = 0 and count($CodelisteInhalt/*/SimpleCodeList/Row) = 0">
									<xdf3:wert>
										<xdf3:code>xxx</xdf3:code>
										<xdf3:name>ACHTUNG!! Der Inhalt der Codeliste <xsl:value-of select="$CodelisteDatei"/> konnte nicht geladen umd somit nicht in eine Werteliste umgewandelt werden!</xdf3:name>
									</xdf3:wert>
								</xsl:when>
								<xsl:otherwise>
									
									<xsl:variable name="CodeKeySpalte">
										<xsl:value-of select="$CodelisteInhalt/*/gc:ColumnSet/gc:Key[@Id='codeKey']/gc:ColumnRef/@Ref"/><xsl:value-of select="$CodelisteInhalt/*/ColumnSet/Key[@Id='codeKey']/ColumnRef/@Ref"/>
									</xsl:variable> 
									<xsl:variable name="CodenameKeySpalte">
										<xsl:value-of select="$CodelisteInhalt/*/gc:ColumnSet/gc:Key[@Id='codenameKey']/gc:ColumnRef/@Ref"/><xsl:value-of select="$CodelisteInhalt/*/ColumnSet/Key[@Id='codenameKey']/ColumnRef/@Ref"/>
									</xsl:variable> 

									<xsl:if test="$DebugMode = '4'">
										<xsl:message>+++<xsl:value-of select="$CodeKeySpalte"/>---</xsl:message>
										<xsl:message>+++<xsl:value-of select="$CodenameKeySpalte"/>---</xsl:message>
									</xsl:if>
									
									<xsl:for-each select="$CodelisteInhalt/*/gc:SimpleCodeList/gc:Row">
										<xsl:variable name="thisRow" select="."/>
										<xdf3:wert>
											<xsl:for-each select="../../gc:ColumnSet/gc:Column/@Id[. = $CodeKeySpalte]">
												<xdf3:code><xsl:value-of select="$thisRow/gc:Value[@ColumnRef=current()]"/></xdf3:code>
											</xsl:for-each>
											<xsl:for-each select="../../gc:ColumnSet/gc:Column/@Id[. = $CodenameKeySpalte]">
												<xdf3:name><xsl:value-of select="$thisRow/gc:Value[@ColumnRef=current()]"/></xdf3:name>
											</xsl:for-each>
											<xsl:for-each select="../../gc:ColumnSet/gc:Column/@Id[. != $CodeKeySpalte and . != $CodenameKeySpalte]">
												<xsl:choose>
													<xsl:when test="fn:position()=1">
														<xdf3:hilfe><xsl:value-of select="$thisRow/gc:Value[@ColumnRef=current()]"/></xdf3:hilfe>
													</xsl:when>
													<xsl:otherwise>
													</xsl:otherwise>
												</xsl:choose>
											</xsl:for-each>
										</xdf3:wert>
									</xsl:for-each>
									<xsl:for-each select="$CodelisteInhalt/*/SimpleCodeList/Row">
										<xsl:variable name="thisRow" select="."/>
										<xdf3:wert>
											<xsl:for-each select="../../ColumnSet/Column/@Id[. = $CodeKeySpalte]">
												<xdf3:code><xsl:value-of select="$thisRow/Value[@ColumnRef=current()]"/></xdf3:code>
											</xsl:for-each>
											<xsl:for-each select="../../ColumnSet/Column/@Id[. = $CodenameKeySpalte]">
												<xdf3:name><xsl:value-of select="$thisRow/Value[@ColumnRef=current()]"/></xdf3:name>
											</xsl:for-each>
											<xsl:for-each select="../../ColumnSet/Column/@Id[. != $CodeKeySpalte and . != $CodenameKeySpalte]">
												<xsl:choose>
													<xsl:when test="fn:position()=1">
														<xdf3:hilfe><xsl:value-of select="$thisRow/Value[@ColumnRef=current()]"/></xdf3:hilfe>
													</xsl:when>
													<xsl:otherwise>
													</xsl:otherwise>
												</xsl:choose>
											</xsl:for-each>
										</xdf3:wert>
									</xsl:for-each>
								</xsl:otherwise>
							</xsl:choose>
						</xdf3:werte>
					</xsl:otherwise>
				</xsl:choose>
			</xsl:otherwise>
			
		</xsl:choose>

	</xsl:template>

	<!-- ############################################################################################################# -->
	
	<xsl:template name="codelistenInhalte">
		<xsl:param name="Element"/>

		<xsl:if test="$DebugMode = '3' or $DebugMode = '4'">
			<xsl:message>
			++++ codelistenInhalte ++++
			Codeliste: <xsl:value-of select="$Element/xdf:genericodeIdentification/xdf:canonicalVersionUri"/>
			</xsl:message>
		</xsl:if>
		
		<xsl:variable name="InterneCodeliste">
			<xsl:if test="$Codelisten2Wertelisten ='1'">
				<xsl:variable name="Kennung"><xsl:value-of select="$Element/xdf:genericodeIdentification/xdf:canonicalIdentification"/></xsl:variable>
				<xsl:for-each select="fn:tokenize($CodelistenInternIdentifier,';')">
					<xsl:if test="fn:contains($Kennung,.)">
						enthalten
					</xsl:if>
				</xsl:for-each>
			</xsl:if>
		</xsl:variable>
		
		<xsl:variable name="ExterneCodelisteErreichbar">
			<xsl:if test="$PruefeCodelistenErreichbarkeit ='1'">
				<xsl:variable name="CodelisteURL" select="fn:concat($XMLXRepoMitVersionPfadPrefix,$Element/xdf:genericodeIdentification/xdf:canonicalVersionUri,$XMLXRepoMitVersionPfadPostfix)"/> 
				<xsl:if test="not(fn:doc-available($CodelisteURL))">
					nicht erreichbar
				</xsl:if>
			</xsl:if>
		</xsl:variable>
		
		<xsl:if test="$InterneCodeliste!='' or $ExterneCodelisteErreichbar!=''">
			<xsl:variable name="CodelisteDatei" select="concat($InputPfad,$Element/xdf:identifikation/xdf:id, '_genericode.xml')"/>

			<xsl:variable name="CodelisteInhalt">
				<xsl:choose>
					<xsl:when test="fn:doc-available($CodelisteDatei)">
						<xsl:copy-of select="fn:document($CodelisteDatei)"/>
						<xsl:if test="$DebugMode = '4'">
							<xsl:message>
				FILE1
							</xsl:message>
						</xsl:if>
					</xsl:when>
					<xsl:otherwise>
							<xsl:if test="$DebugMode = '4'">
								<xsl:message>
				LEER
								</xsl:message>
							</xsl:if>
					</xsl:otherwise>
				</xsl:choose>
			</xsl:variable>

			<xsl:if test="fn:string-length($CodelisteInhalt) &gt; 9">
				<xsl:if test="not(empty($CodelisteInhalt/*/gc:Identification/gc:ShortName/text())) or not(empty($CodelisteInhalt/*/Identification/ShortName/text()))"><xsl:text>
				</xsl:text>Kurzname: <xsl:value-of select="$CodelisteInhalt/*/gc:Identification/gc:ShortName"/><xsl:value-of select="$CodelisteInhalt/*/Identification/ShortName"/></xsl:if><xsl:if test="not(empty($CodelisteInhalt/*/gc:Identification/gc:LongName/text())) or not(empty($CodelisteInhalt/*/Identification/LongName/text()))"><xsl:text>
				</xsl:text>Langname: <xsl:value-of select="$CodelisteInhalt/*/gc:Identification/gc:LongName"/><xsl:value-of select="$CodelisteInhalt/*/Identification/LongName"/>
				</xsl:if>
			</xsl:if>
		</xsl:if>

	</xsl:template>

	<!-- ############################################################################################################# -->
	
	<xsl:template match="xdf:header">

		<xsl:if test="$DebugMode = '3' or $DebugMode = '4'">
			<xsl:message>
			++++ header ++++
			</xsl:message>
		</xsl:if>

		<xdf3:header>
			<xdf3:nachrichtID><xsl:value-of select="./xdf:nachrichtID"/></xdf3:nachrichtID>
			<xdf3:erstellungszeitpunkt><xsl:value-of select="./xdf:erstellungszeitpunkt"/></xdf3:erstellungszeitpunkt>
			<xsl:if test="not(empty(./xdf:referenzID/text()))">
				<xdf3:referenzID><xsl:value-of select="./xdf:referenzID"/></xdf3:referenzID>
			</xsl:if>
		</xdf3:header>
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

	<xsl:template name="FILEsonderzeichenraus">
	  <xsl:param name="OriginalText" />

		<xsl:variable name="Temp1" select="fn:replace($OriginalText, '\s', '_')"/>
		<xsl:variable name="Temp2" select="replace(replace(replace(replace($Temp1,'ß','ss'),'ü','ue'),'ö','oe'),'ä','ae')"/>
		<xsl:variable name="Temp3" select="replace(replace(replace($Temp2,'Ü','U e'),'Ö','Oe'),'Ä','Ae')"/>
		<xsl:variable name="Temp4" select="replace($Temp3,'[^A-Z()_-]','','i')"/>
		<xsl:value-of select="$Temp4"/>
	</xsl:template>

</xsl:stylesheet>
