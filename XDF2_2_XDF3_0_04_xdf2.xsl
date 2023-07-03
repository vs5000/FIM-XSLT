<?xml version="1.0" encoding="iso-8859-1"?>
<xsl:stylesheet version="2.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:xdf3="urn:xoev-de:fim:standard:xdatenfelder_3.0.0" xmlns:html="http://www.w3.org/1999/xhtml" xmlns:fn="http://www.w3.org/2005/xpath-functions" xmlns:xdf="urn:xoev-de:fim:standard:xdatenfelder_2" xmlns:gc="http://docs.oasis-open.org/codelist/ns/genericode/1.0/" exclude-result-prefixes="html xsl fn xdf gc">

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
	<xsl:output method="xml" omit-xml-declaration="no"/>
	<xsl:strip-space elements="*"/>

	<xsl:param name="DateiOutput" select="'0'"/>
	<xsl:param name="Unternummernkreis" select="'000'"/>
	<xsl:param name="BezuegeAufteilen" select="'1'"/>
	<xsl:param name="DokumentsteckbriefID" select="'D00000000001'"/>
	<xsl:param name="Codelisten2Wertelisten" select="'1'"/>
	<xsl:param name="CodelistenInternIdentifier" select="'urn:de:fim:'"/>
	<xsl:param name="FreitextRegelKorrektur" select="'1'"/>

	<xsl:param name="DebugMode" select="'3'"/>

	<xsl:variable name="InputDateiname" select="(tokenize($DocumentURI,'/'))[last()]"/>
	<xsl:variable name="InputPfad" select="fn:substring-before($DocumentURI, $InputDateiname)"/>
	<xsl:variable name="OutputDateiname">
		<xsl:choose>
			<xsl:when test="name(/*) ='xdf:xdatenfelder.stammdatenschema.0102'">
				<xsl:choose>
					<xsl:when test="empty(//xdf:stammdatenschema/xdf:identifikation/xdf:version/text())"><xsl:value-of select="fn:substring(//xdf:stammdatenschema/xdf:identifikation/xdf:id,1,3)"/><xsl:value-of select="$Unternummernkreis"/><xsl:value-of select="fn:substring(//xdf:stammdatenschema/xdf:identifikation/xdf:id,4)"/>_xdf3.xml</xsl:when>
					<xsl:otherwise><xsl:value-of select="fn:substring(//xdf:stammdatenschema/xdf:identifikation/xdf:id,1,3)"/><xsl:value-of select="$Unternummernkreis"/><xsl:value-of select="fn:substring(//xdf:stammdatenschema/xdf:identifikation/xdf:id,4)"/>V<xsl:value-of select="//xdf:stammdatenschema/xdf:identifikation/xdf:version"/>.0_xdf3.xml</xsl:otherwise>
				</xsl:choose>
			</xsl:when>
			<xsl:when test="name(/*) ='xdf:xdatenfelder.datenfeldgruppe.0103'">
				<xsl:choose>
					<xsl:when test="empty(//xdf:datenfeldgruppe/xdf:identifikation/xdf:version/text())"><xsl:value-of select="fn:substring(//xdf:datenfeldgruppe/xdf:identifikation/xdf:id,1,3)"/><xsl:value-of select="$Unternummernkreis"/><xsl:value-of select="fn:substring(//xdf:datenfeldgruppe/xdf:identifikation/xdf:id,4)"/>_xdf3.xml</xsl:when>
					<xsl:otherwise><xsl:value-of select="fn:substring(//xdf:datenfeldgruppe/xdf:identifikation/xdf:id,1,3)"/><xsl:value-of select="$Unternummernkreis"/><xsl:value-of select="fn:substring(//xdf:datenfeldgruppe/xdf:identifikation/xdf:id,4)"/>V<xsl:value-of select="//xdf:datenfeldgruppe/xdf:identifikation/xdf:version"/>.0_xdf3.xml</xsl:otherwise>
				</xsl:choose>
			</xsl:when>
			<xsl:when test="name(/*) ='xdf:xdatenfelder.datenfeld.0104'">
				<xsl:choose>
					<xsl:when test="empty(//xdf:datenfeld/xdf:identifikation/xdf:version/text())"><xsl:value-of select="fn:substring(//xdf:datenfeld/xdf:identifikation/xdf:id,1,3)"/><xsl:value-of select="$Unternummernkreis"/><xsl:value-of select="fn:substring(//xdf:datenfeld/xdf:identifikation/xdf:id,4)"/>_xdf3.xml</xsl:when>
					<xsl:otherwise><xsl:value-of select="fn:substring(//xdf:datenfeld/xdf:identifikation/xdf:id,1,3)"/><xsl:value-of select="$Unternummernkreis"/><xsl:value-of select="fn:substring(//xdf:datenfeld/xdf:identifikation/xdf:id,4)"/>V<xsl:value-of select="//xdf:datenfeld/xdf:identifikation/xdf:version"/>.0_xdf3.xml</xsl:otherwise>
				</xsl:choose>
			</xsl:when>
			<xsl:when test="name(/*) ='xdf:xdatenfelder.dokumentsteckbrief.0101'">
				<xsl:choose>
					<xsl:when test="empty(//xdf:dokumentensteckbrief/xdf:identifikation/xdf:version/text())"><xsl:value-of select="fn:substring(//xdf:dokumentensteckbrief/xdf:identifikation/xdf:id,1,3)"/><xsl:value-of select="$Unternummernkreis"/><xsl:value-of select="fn:substring(//xdf:dokumentensteckbrief/xdf:identifikation/xdf:id,4)"/>_xdf3.xml</xsl:when>
					<xsl:otherwise><xsl:value-of select="fn:substring(//xdf:dokumentensteckbrief/xdf:identifikation/xdf:id,1,3)"/><xsl:value-of select="$Unternummernkreis"/><xsl:value-of select="fn:substring(//xdf:dokumentensteckbrief/xdf:identifikation/xdf:id,4)"/>V<xsl:value-of select="//xdf:dokumentensteckbrief/xdf:identifikation/xdf:version"/>.0_xdf3.xml</xsl:otherwise>
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
				BezuegeAufteilen: <xsl:value-of select="$BezuegeAufteilen"/>
				DokumentsteckbriefID: <xsl:value-of select="$DokumentsteckbriefID"/>
				Codelisten2Wertelisten: <xsl:value-of select="$Codelisten2Wertelisten"/>
				CodelistenInternIdentifier: <xsl:value-of select="$CodelistenInternIdentifier"/>
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

					<xsl:comment><xsl:text>           </xsl:text>Erstellt am: <xsl:value-of select="format-date(fn:current-date(),'[D01].[M01].[Y0001]')"/> um <xsl:value-of select="format-time(fn:current-time(),'[H01]:[m01]')"/> Uhr<xsl:text>           </xsl:text>XSLT: <xsl:value-of select="tokenize($StyleSheetURI, '/')[last()]"/><xsl:text>           </xsl:text>XML: <xsl:value-of select="tokenize($DocumentURI, '/')[last()]"/><xsl:text>           </xsl:text></xsl:comment>

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
			<xsl:apply-templates select="./xdf:identifikation"/>

			<xdf3:name><xsl:value-of select="./xdf:name"/></xdf3:name>

			<xsl:if test="not(empty(./xdf:beschreibung/text()))">
				<xdf3:beschreibung><xsl:value-of select="./xdf:beschreibung"/></xdf3:beschreibung>
			</xsl:if>

			<xsl:if test="not(empty(./xdf:definition/text()))">
				<xdf3:definition><xsl:value-of select="./xdf:definition"/></xdf3:definition>
			</xsl:if>

			<xsl:apply-templates select="./xdf:bezug"/>

			<xsl:variable name="Status">
				<xsl:value-of select="./xdf:status/code"/>
			</xsl:variable>
	
			<xsl:variable name="Fixierungsgrad">
				<xsl:choose>
					<xsl:when test="empty(./xdf:identifikation/xdf:version/text())">Arbeitskopie</xsl:when>
					<xsl:otherwise>Version</xsl:otherwise>
				</xsl:choose>
			</xsl:variable>
			
			<xsl:variable name="Freigabe">
				<xsl:choose>
					<xsl:when test="empty(./xdf:freigabedatum/text())">Nein</xsl:when>
					<xsl:otherwise>Ja</xsl:otherwise>
				</xsl:choose>
			</xsl:variable>
			
			<xsl:variable name="Veroeffentlichung">
				<xsl:choose>
					<xsl:when test="empty(./xdf:veroeffentlichungsdatum/text())">Nein</xsl:when>
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

			<xsl:for-each select="./xdf:struktur">
				<xsl:apply-templates select="."/>
			</xsl:for-each>
			
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
			<xsl:apply-templates select="./xdf:identifikation"/>

			<xdf3:name><xsl:value-of select="./xdf:name"/></xdf3:name>

			<xsl:if test="not(empty(./xdf:beschreibung/text()))">
				<xdf3:beschreibung><xsl:value-of select="./xdf:beschreibung"/></xdf3:beschreibung>
			</xsl:if>

			<xsl:if test="not(empty(./xdf:definition/text()))">
				<xdf3:definition><xsl:value-of select="./xdf:definition"/></xdf3:definition>
			</xsl:if>

			<xsl:apply-templates select="./xdf:bezug"/>

			<xsl:variable name="Status">
				<xsl:value-of select="./xdf:status/code"/>
			</xsl:variable>
	
			<xsl:variable name="Fixierungsgrad">
				<xsl:choose>
					<xsl:when test="empty(./xdf:identifikation/xdf:version/text())">Arbeitskopie</xsl:when>
					<xsl:otherwise>Version</xsl:otherwise>
				</xsl:choose>
			</xsl:variable>
			
			<xsl:variable name="Freigabe">
				<xsl:choose>
					<xsl:when test="empty(./xdf:freigabedatum/text())">Nein</xsl:when>
					<xsl:otherwise>Ja</xsl:otherwise>
				</xsl:choose>
			</xsl:variable>
			
			<xsl:variable name="Veroeffentlichung">
				<xsl:choose>
					<xsl:when test="empty(./xdf:veroeffentlichungsdatum/text())">Nein</xsl:when>
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

			<xdf3:istAbstrakt>false</xdf3:istAbstrakt>

			<xdf3:dokumentart listURI="urn:xoev-de:fim-datenfelder:codeliste:dokumentart" listVersionID="2022-01-01">
				<code>999</code>
			</xdf3:dokumentart>
		
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
			<xsl:apply-templates select="./xdf:identifikation"/>
			<xdf3:name><xsl:value-of select="./xdf:name"/></xdf3:name>
			<xsl:if test="not(empty(./xdf:beschreibung/text()))">
				<xdf3:beschreibung><xsl:value-of select="./xdf:beschreibung"/></xdf3:beschreibung>
			</xsl:if>
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
									<xsl:value-of select="fn:substring(.,1,3)"/><xsl:value-of select="$Unternummernkreis"/><xsl:value-of select="fn:substring(.,4,6)"/>
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
	
	<xsl:template match="xdf:struktur">

		<xsl:if test="$DebugMode = '3' or $DebugMode = '4'">
			<xsl:message>
				++++ struktur ++++
			</xsl:message>
		</xsl:if>

		<xdf3:struktur>
			<xdf3:anzahl><xsl:value-of select="./xdf:anzahl"/></xdf3:anzahl>
			<xsl:apply-templates select="./xdf:bezug"/>
			<xdf3:enthaelt>
				<xsl:apply-templates select="./xdf:enthaelt/xdf:datenfeld | ./xdf:enthaelt/xdf:datenfeldgruppe"/>
			</xdf3:enthaelt>
			
		</xdf3:struktur>
	</xsl:template>

	<!-- ############################################################################################################# -->
	
	<xsl:template match="xdf:datenfeld">

		<xsl:if test="$DebugMode = '2' or $DebugMode = '3' or $DebugMode = '4'">
			<xsl:message>
				++++ datenfeld ++++
				Datenfeld: <xsl:value-of select="./xdf:identifikation/xdf:id"/>
			</xsl:message>
		</xsl:if>

		<xdf3:datenfeld>
			<xsl:apply-templates select="./xdf:identifikation"/>

			<xdf3:name><xsl:value-of select="./xdf:name"/></xdf3:name>

			<xsl:if test="not(empty(./xdf:beschreibung/text()))">
				<xdf3:beschreibung><xsl:value-of select="./xdf:beschreibung"/></xdf3:beschreibung>
			</xsl:if>

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

		<xsl:if test="$DebugMode = '2' or $DebugMode = '3' or $DebugMode = '4'">
			<xsl:message>
				++++ datenfeldgruppe ++++
				Datenfeldgruppe: <xsl:value-of select="./xdf:identifikation/xdf:id"/>
			</xsl:message>
		</xsl:if>

		<xdf3:datenfeldgruppe>

			<xsl:apply-templates select="./xdf:identifikation"/>

			<xdf3:name><xsl:value-of select="./xdf:name"/></xdf3:name>

			<xsl:if test="not(empty(./xdf:beschreibung/text()))">
				<xdf3:beschreibung><xsl:value-of select="./xdf:beschreibung"/></xdf3:beschreibung>
			</xsl:if>

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

			<xsl:for-each select="./xdf:struktur">
				<xsl:apply-templates select="."/>
			</xsl:for-each>

		</xdf3:datenfeldgruppe>
	</xsl:template>

	<!-- ############################################################################################################# -->
	
	<xsl:template match="xdf:identifikation">

		<xsl:if test="$DebugMode = '3' or $DebugMode = '4'">
			<xsl:message>
				++++ identifikation ++++
			</xsl:message>
		</xsl:if>

		<xdf3:identifikation>
			<xsl:choose>
				<xsl:when test="empty(./xdf:version/text())">
						<xdf3:id><xsl:value-of select="fn:substring(./xdf:id,1,3)"/><xsl:value-of select="$Unternummernkreis"/><xsl:value-of select="fn:substring(./xdf:id,4)"/></xdf3:id>
				</xsl:when>
				<xsl:otherwise>
						<xdf3:id><xsl:value-of select="fn:substring(./xdf:id,1,3)"/><xsl:value-of select="$Unternummernkreis"/><xsl:value-of select="fn:substring(./xdf:id,4)"/></xdf3:id>
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
				<xsl:if test="$DebugMode = '3' or $DebugMode = '4'">
						<xsl:message>
							++++ Bezüge ++++
						</xsl:message>
				</xsl:if>

				<xsl:for-each select="tokenize(., ';')">
					<xsl:if test="$DebugMode = '3' or $DebugMode = '4'">
						<xsl:message>
							Bezug: <xsl:value-of select="."/>
						</xsl:message>
					</xsl:if>
			
					<xdf3:bezug><xsl:value-of select="fn:normalize-space(.)"/></xdf3:bezug>
				</xsl:for-each>
			</xsl:when>
			<xsl:otherwise>
				<xsl:if test="not(empty(./text()))">
					<xdf3:bezug><xsl:value-of select="."/></xdf3:bezug>
				</xsl:if>
			</xsl:otherwise>
		</xsl:choose>
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
				<xsl:if test="$minLength != ''">
					<xsl:attribute name="minLength"><xsl:value-of select="$minLength"/></xsl:attribute>
				</xsl:if>
				<xsl:if test="$maxLength != ''">
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
		
		<xsl:choose>
			<xsl:when test="$InterneCodeliste=''">
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
						<xdf3:werte>
								<xdf3:wert>
									<xdf3:code>xxx</xdf3:code>
									<xdf3:name>ACHTUNG!! Die Codeliste <xsl:value-of select="$CodelisteDatei"/> konnte nicht geladen umd somit nicht in eine Werteliste umgewandelt werden!</xdf3:name>
								</xdf3:wert>
						</xdf3:werte>
						<xsl:if test="$DebugMode = '2'">
							<xsl:message> Fehler!! Die Codeliste <xsl:value-of select="$CodelisteDatei"/> konnte nicht geladen umd somit nicht in eine Werteliste umgewandelt werden!</xsl:message>
						</xsl:if>
					</xsl:when> 
					<xsl:otherwise>
						<xdf3:werte>
							<xsl:for-each select="$CodelisteInhalt/*/gc:SimpleCodeList/gc:Row">
								<xsl:variable name="thisRow" select="."/>
								<xdf3:wert>
									<xsl:for-each select="../../gc:ColumnSet/gc:Column/@Id">
										<xsl:choose>
											<xsl:when test="fn:position()=1">
												<xdf3:code><xsl:value-of select="$thisRow/gc:Value[@ColumnRef=current()]"/></xdf3:code>
											</xsl:when>
											<xsl:when test="fn:position()=2">
												<xdf3:name><xsl:value-of select="$thisRow/gc:Value[@ColumnRef=current()]"/></xdf3:name>
											</xsl:when>
											<xsl:when test="fn:position()=3">
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
									<xsl:for-each select="../../ColumnSet/Column/@Id">
										<xsl:choose>
											<xsl:when test="fn:position()=1">
												<xdf3:code><xsl:value-of select="$thisRow/Value[@ColumnRef=current()]"/></xdf3:code>
											</xsl:when>
											<xsl:when test="fn:position()=2">
												<xdf3:name><xsl:value-of select="$thisRow/Value[@ColumnRef=current()]"/></xdf3:name>
											</xsl:when>
											<xsl:when test="fn:position()=3">
												<xdf3:hilfe><xsl:value-of select="$thisRow/Value[@ColumnRef=current()]"/></xdf3:hilfe>
											</xsl:when>
											<xsl:otherwise>
											</xsl:otherwise>
										</xsl:choose>
									</xsl:for-each>
								</xdf3:wert>
							</xsl:for-each>
						</xdf3:werte>
					</xsl:otherwise>
				</xsl:choose>
			</xsl:otherwise>
			
		</xsl:choose>

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


</xsl:stylesheet>
