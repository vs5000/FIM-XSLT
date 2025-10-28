<?xml version="1.0" encoding="iso-8859-1"?>
<xsl:stylesheet 
	version="3.0" 
	xmlns:xsl="http://www.w3.org/1999/XSL/Transform" 
	xmlns:html="http://www.w3.org/1999/xhtml" 
	xmlns="http://www.w3.org/1999/xhtml" 
	xmlns:fn="http://www.w3.org/2005/xpath-functions" 
	xmlns:xdf3="urn:xoev-de:fim:standard:xdatenfelder_3.0.0" 
	xmlns:gc="http://docs.oasis-open.org/codelist/ns/genericode/1.0/" 
	xmlns:ext="http://www.xoev.de/de/xrepository/framework/1/extrakte" 
	xmlns:bdt="http://www.xoev.de/de/xrepository/framework/1/basisdatentypen" 
	xmlns:dat="http://www.xoev.de/de/xrepository/framework/1/datenbereitstellung" 
	xmlns:svrl="http://purl.oclc.org/dsdl/svrl" 
	xmlns:xs="http://www.w3.org/2001/XMLSchema" 
	exclude-result-prefixes="html xs xsl fn xdf3 gc ext bdt dat svrl">
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
	<xsl:variable name="StyleSheetName" select="'QS-DF_1_15_xdf3.xsl'"/>
	<!-- BackUp, falls fn:static-base-uri() leer -->
	<xsl:output method="xhtml" doctype-system="http://www.w3.org/TR/xhtml11/DTD/xhtml11.dtd" doctype-public="-//W3C//DTD XHTML 1.1//EN" omit-xml-declaration="yes"/>

	<xsl:strip-space elements="*"/>
	<xsl:decimal-format name="european" decimal-separator="," grouping-separator="."/>

	<xsl:param name="DateiOutput" select="'0'"/>
	<xsl:param name="JavaScript" select="'1'"/>
	<xsl:param name="Navigation" select="'1'"/>

	<xsl:param name="InterneLinks" select="'1'"/>
	<xsl:param name="HandlungsgrundlagenLinks" select="'1'"/>

	<xsl:param name="WurzelAlleUnterelemente" select="'0'"/>

	<xsl:param name="Meldungen" select="'1'"/>
	<xsl:param name="MeldungsFazit" select="'1'"/>
	<xsl:param name="VersionsHinweise" select="'0'"/>

	<xsl:param name="CodelistenInhalt" select="'0'"/>
	<xsl:param name="AktuelleCodelisteLaden" select="'1'"/>

	<xsl:param name="ToolAufruf" select="'1'"/>
	<xsl:param name="ToolPfadPrefix" select="'https://fred.niedersachsen.de/fim/portal/fim/16/client/index.html#/datenmodellierung/'"/>
	<xsl:param name="ToolPfadPostfix" select="''"/>

	<xsl:param name="QSHilfeAufruf" select="'1'"/>
	<xsl:param name="QSHilfePfadPrefix" select="'https://docs.fitko.de/fim/docs/datenfelder/QS_Bericht#'"/>
	<xsl:param name="QSHilfePfadPostfix" select="''"/>

	<xsl:param name="Statistik" select="'0'"/>
	<xsl:param name="StatistikKennzahlen" select="'1'"/>
	<xsl:param name="StatistikVerwendung" select="'1'"/>
	<xsl:param name="StatistikStrukturart" select="'1'"/>
	<xsl:param name="StatistikStatus" select="'1'"/>
	<xsl:param name="StatistikIDVersion" select="'1'"/>
	<xsl:param name="StatistikHandlungsgrundlage" select="'1'"/>
	<xsl:param name="StatistikAktualitaet" select="'1'"/>
	<xsl:param name="StatistikFachlicherErsteller" select="'1'"/>
	<xsl:param name="DebugMode" select="'3'"/>

	<xsl:param name="XRepoAufruf" select="'1'"/>
	<xsl:variable name="DocXRepoOhneVersionPfadPrefix" select="'https://www.xrepository.de/details/'"/>
	<xsl:variable name="DocXRepoOhneVersionPfadPostfix" select="''"/>
	<xsl:variable name="DocXRepoMitVersionPfadPrefix" select="'https://www.xrepository.de/details/'"/>
	<xsl:variable name="DocXRepoMitVersionPfadPostfix" select="'#version'"/>
	<xsl:variable name="XMLXRepoOhneVersionPfadPrefix" select="'https://www.xrepository.de/api/codeliste/'"/>
	<xsl:variable name="XMLXRepoOhneVersionPfadPostfix" select="'/gueltigeVersion'"/>
	<xsl:variable name="XMLXRepoMitVersionPfadPrefix" select="'https://www.xrepository.de/api/version_codeliste/'"/>
	<xsl:variable name="XMLXRepoMitVersionPfadPostfix" select="'/genericode'"/>

	<xsl:param name="SammelrepositoryCheck" select="'0'"/>
	<xsl:variable name="URLDSBList" select="'https://fimportal.de/api/v1/document-profiles/'"/> <!-- /api/v1/document-profiles/{fim_id}/latest -->
	<xsl:variable name="URLFeList" select="'https://fimportal.de/api/v1/fields/baukasten/'"/> <!-- /api/v1/fields/{fim_id}/latest -->
	<xsl:variable name="URLFGList" select="'https://fimportal.de/api/v1/groups/baukasten/'"/> <!-- /api/v1/groups/{fim_id}/latest -->

	<xsl:param name="QSAufruf" select="'0'"/>
	<xsl:param name="QSPfadPrefix" select="'https://fred.niedersachsen.de/fim/portal/fim/16/fimapi0/v2/stammdatenschemata/'"/>
	<xsl:param name="QSPfadPostfix" select="'/qsreport'"/>


	<xsl:variable name="InputDateiname" select="(tokenize($DocumentURI,'/'))[last()]"/>
	<xsl:variable name="InputPfad" select="fn:substring-before($DocumentURI, $InputDateiname)"/>

	<xsl:variable name="MeldungenInhaltDateiname">
		<xsl:choose>
			<xsl:when test="fn:not((fn:string($StyleSheetURI)))">
				<xsl:value-of select="fn:concat('/','Meldungen.xml')"/>
			</xsl:when>
			<xsl:otherwise>
				<xsl:value-of select="fn:concat(fn:substring-before($StyleSheetURI, (tokenize($StyleSheetURI,'/'))[last()]),'Meldungen.xml')"/>
			</xsl:otherwise>
		</xsl:choose>
	</xsl:variable>

	<xsl:variable name="MeldungenInhalt">
		<xsl:choose>
			<xsl:when test="fn:doc-available($MeldungenInhaltDateiname)">
				<xsl:copy-of select="fn:document($MeldungenInhaltDateiname)"/>
				<xsl:if test="$DebugMode = '4'">
					<xsl:message>                                  Meldung FILE</xsl:message>
				</xsl:if>
			</xsl:when>
			<xsl:otherwise>
				<!-- Backup, falls auf Meldungen.xml nicht zugegriffen werden kann -->
				<xsl:if test="$DebugMode = '4'">
					<xsl:message>                                  Meldung INTERNAL</xsl:message>
				</xsl:if>
				<gc:CodeList xmlns:gc="http://docs.oasis-open.org/codelist/ns/genericode/1.0/"
							 xmlns:xoev-cl-4="http://xoev.de/schemata/genericode/4"
							 xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance">
				   <Annotation>
					  <Description>
						 <xoev-cl-4:shortName xml:lang="de-DE">XDFM</xoev-cl-4:shortName>
						 <xoev-cl-4:codelistDescription xml:lang="de-DE">Meldungen zur Qualit�tsanalyse von FIM XDF3-Datenschemata</xoev-cl-4:codelistDescription>
						 <xoev-cl-4:agencyShortName xml:lang="de-DE">FIM Datenfelder</xoev-cl-4:agencyShortName>
						 <xoev-cl-4:versionHandbook>1.2</xoev-cl-4:versionHandbook>
					  </Description>
				   </Annotation>
				   <Identification>
					  <ShortName>XDFM</ShortName>
					  <LongName xml:lang="de-DE">Meldungen XDF-Qualit�t</LongName>
					  <Version>1.5intern</Version>
					  <CanonicalUri>urn:xoev-de:fim-datenfelder:codeliste:xdfm</CanonicalUri>
					  <CanonicalVersionUri>urn:xoev-de:fim-datenfelder:codeliste:xdfm_1.5intern</CanonicalVersionUri>
					  <Agency>
						 <LongName xml:lang="de-DE">FIM-Baustein Datenfelder</LongName>
					  </Agency>
				   </Identification>
				   <ColumnSet>
					  <Column Id="Code" Use="required">
						 <ShortName>Code</ShortName>
						 <LongName>Code</LongName>
						 <Data Type="string"/>
					  </Column>
					  <Column Id="Typ" Use="required">
						 <ShortName>Typ</ShortName>
						 <LongName>Typ</LongName>
						 <Data Type="string"/>
					  </Column>
					  <Column Id="Meldungstext" Use="required">
						 <ShortName>Meldungstext</ShortName>
						 <LongName>Meldungstext</LongName>
						 <Data Type="string"/>
					  </Column>
					  <Column Id="Meldungshilfe" Use="optional">
						 <ShortName>Meldungshilfe</ShortName>
						 <LongName>Meldungshilfe</LongName>
						 <Data Type="string"/>
					  </Column>
					  <Key Id="CodeKey">
						 <Annotation>
							<AppInfo>
							   <xoev-cl-4:recommendedKeyColumn/>
							</AppInfo>
						 </Annotation>
						 <ShortName>CodeKey</ShortName>
						 <ColumnRef Ref="Code"/>
					  </Key>
				   </ColumnSet>
				   <SimpleCodeList>
					  <Row>
						 <Value ColumnRef="Code">
							<SimpleValue>1001</SimpleValue>
						 </Value>
						 <Value ColumnRef="Typ">
							<SimpleValue>FehlerMethodisch</SimpleValue>
						 </Value>
						 <Value ColumnRef="Meldungstext">
							<SimpleValue>Eine Regel kann nicht auf ein referenziertes Baukastenelement zugreifen.</SimpleValue>
						 </Value>
						 <Value ColumnRef="Meldungshilfe"/>
					  </Row>
					  <Row>
						 <Value ColumnRef="Code">
							<SimpleValue>1002</SimpleValue>
						 </Value>
						 <Value ColumnRef="Typ">
							<SimpleValue>FehlerKritisch</SimpleValue>
						 </Value>
						 <Value ColumnRef="Meldungstext">
							<SimpleValue>Der Name eines Elements ist nicht gesetzt.</SimpleValue>
						 </Value>
						 <Value ColumnRef="Meldungshilfe"/>
					  </Row>
					  <Row>
						 <Value ColumnRef="Code">
							<SimpleValue>1003</SimpleValue>
						 </Value>
						 <Value ColumnRef="Typ">
							<SimpleValue>Warnung</SimpleValue>
						 </Value>
						 <Value ColumnRef="Meldungstext">
							<SimpleValue>In einem Datenschema sollte ein Baukastenelement i. d. R. nicht mehrfach in unterschiedlichen Versionen enthalten sein.</SimpleValue>
						 </Value>
						 <Value ColumnRef="Meldungshilfe"/>
					  </Row>
					  <Row>
						 <Value ColumnRef="Code">
							<SimpleValue>1004</SimpleValue>
						 </Value>
						 <Value ColumnRef="Typ">
							<SimpleValue>Warnung</SimpleValue>
						 </Value>
						 <Value ColumnRef="Meldungstext">
							<SimpleValue>In einer Datenfeldgruppe darf ein Baukastenelement nicht mehrfach in derselben Version enthalten sein. </SimpleValue>
						 </Value>
						 <Value ColumnRef="Meldungshilfe"/>
					  </Row>
					  <Row>
						 <Value ColumnRef="Code">
							<SimpleValue>1005</SimpleValue>
						 </Value>
						 <Value ColumnRef="Typ">
							<SimpleValue>FehlerKritisch</SimpleValue>
						 </Value>
						 <Value ColumnRef="Meldungstext">
							<SimpleValue>Die Kennung einer Codeliste ist nicht als URN formuliert, z. B. urn:de:fim:codeliste:dokumenttyp.</SimpleValue>
						 </Value>
						 <Value ColumnRef="Meldungshilfe"/>
					  </Row>
					  <Row>
						 <Value ColumnRef="Code">
							<SimpleValue>1006</SimpleValue>
						 </Value>
						 <Value ColumnRef="Typ">
							<SimpleValue>FehlerKritisch</SimpleValue>
						 </Value>
						 <Value ColumnRef="Meldungstext">
							<SimpleValue>Der Bezug zur Handlungsgrundlage darf bei Elementen mit der Strukturelementart 'rechtsnormgebunden' nicht leer sein.</SimpleValue>
						 </Value>
						 <Value ColumnRef="Meldungshilfe"/>
					  </Row>
					  <Row>
						 <Value ColumnRef="Code">
							<SimpleValue>1007</SimpleValue>
						 </Value>
						 <Value ColumnRef="Typ">
							<SimpleValue>FehlerKritisch</SimpleValue>
						 </Value>
						 <Value ColumnRef="Meldungstext">
							<SimpleValue>Es ist kein Dokumentsteckbrief zugeordnet.</SimpleValue>
						 </Value>
						 <Value ColumnRef="Meldungshilfe"/>
					  </Row>
					  <Row>
						 <Value ColumnRef="Code">
							<SimpleValue>1008</SimpleValue>
						 </Value>
						 <Value ColumnRef="Typ">
							<SimpleValue>FehlerKritisch</SimpleValue>
						 </Value>
						 <Value ColumnRef="Meldungstext">
							<SimpleValue>Der Bezug zur Handlungsgrundlage darf bei Dokumentsteckbriefen nicht leer sein.</SimpleValue>
						 </Value>
						 <Value ColumnRef="Meldungshilfe"/>
					  </Row>
					  <Row>
						 <Value ColumnRef="Code">
							<SimpleValue>1009</SimpleValue>
						 </Value>
						 <Value ColumnRef="Typ">
							<SimpleValue>FehlerKritisch</SimpleValue>
						 </Value>
						 <Value ColumnRef="Meldungstext">
							<SimpleValue>Die 'Bezeichnung Eingabe' muss bef�llt werden.</SimpleValue>
						 </Value>
						 <Value ColumnRef="Meldungshilfe"/>
					  </Row>
					  <Row>
						 <Value ColumnRef="Code">
							<SimpleValue>1010</SimpleValue>
						 </Value>
						 <Value ColumnRef="Typ">
							<SimpleValue>FehlerKritisch</SimpleValue>
						 </Value>
						 <Value ColumnRef="Meldungstext">
							<SimpleValue>Die 'Bezeichnung Ausgabe' muss bef�llt werden.</SimpleValue>
						 </Value>
						 <Value ColumnRef="Meldungshilfe"/>
					  </Row>
					  <Row>
						 <Value ColumnRef="Code">
							<SimpleValue>1011</SimpleValue>
						 </Value>
						 <Value ColumnRef="Typ">
							<SimpleValue>FehlerKritisch</SimpleValue>
						 </Value>
						 <Value ColumnRef="Meldungstext">
							<SimpleValue>Bei Datenfeldern mit der Feldart 'Auswahl' muss der Datentyp 'Text' sein.</SimpleValue>
						 </Value>
						 <Value ColumnRef="Meldungshilfe"/>
					  </Row>
					  <Row>
						 <Value ColumnRef="Code">
							<SimpleValue>1012</SimpleValue>
						 </Value>
						 <Value ColumnRef="Typ">
							<SimpleValue>FehlerMethodisch</SimpleValue>
						 </Value>
						 <Value ColumnRef="Meldungstext">
							<SimpleValue>Bei Datenfeldern mit der Feldart 'Auswahlfeld' oder 'Statisches, read-only Feld' d�rfen weder die minimale noch die maximale Feldl�nge angegeben werden.</SimpleValue>
						 </Value>
						 <Value ColumnRef="Meldungshilfe"/>
					  </Row>
					  <Row>
						 <Value ColumnRef="Code">
							<SimpleValue>1013</SimpleValue>
						 </Value>
						 <Value ColumnRef="Typ">
							<SimpleValue>FehlerMethodisch</SimpleValue>
						 </Value>
						 <Value ColumnRef="Meldungstext">
							<SimpleValue>Innerhalb von Datenschemata und Datenfeldgruppen d�rfen nur Elemente mit der Strukturelementart harmonisiert oder rechtsnormgebunden verwendet werden.</SimpleValue>
						 </Value>
						 <Value ColumnRef="Meldungshilfe"/>
					  </Row>
					  <Row>
						 <Value ColumnRef="Code">
							<SimpleValue>1014</SimpleValue>
						 </Value>
						 <Value ColumnRef="Typ">
							<SimpleValue>FehlerKritisch</SimpleValue>
						 </Value>
						 <Value ColumnRef="Meldungstext">
							<SimpleValue>Datenfelder d�rfen nicht die Strukturelementart 'abstrakt' haben.</SimpleValue>
						 </Value>
						 <Value ColumnRef="Meldungshilfe"/>
					  </Row>
					  <Row>
						 <Value ColumnRef="Code">
							<SimpleValue>1015</SimpleValue>
						 </Value>
						 <Value ColumnRef="Typ">
							<SimpleValue>FehlerKritisch</SimpleValue>
						 </Value>
						 <Value ColumnRef="Meldungstext">
							<SimpleValue>Eine Feldl�nge darf nur bei einem Datenfeld mit dem Datentyp 'Text' oder 'String.Latin+' angegeben werden.</SimpleValue>
						 </Value>
						 <Value ColumnRef="Meldungshilfe"/>
					  </Row>
					  <Row>
						 <Value ColumnRef="Code">
							<SimpleValue>1016</SimpleValue>
						 </Value>
						 <Value ColumnRef="Typ">
							<SimpleValue>FehlerKritisch</SimpleValue>
						 </Value>
						 <Value ColumnRef="Meldungstext">
							<SimpleValue>Ein Wertebereich darf nur bei einem Datenfeld mit einem nummerischen Datentyp (Nummer, Ganzzahl, Geldbetrag) oder einem Zeitdatentyp (Uhrzeit, Datum, Zeitpunkt) angegeben werden.</SimpleValue>
						 </Value>
						 <Value ColumnRef="Meldungshilfe"/>
					  </Row>
					  <Row>
						 <Value ColumnRef="Code">
							<SimpleValue>1017</SimpleValue>
						 </Value>
						 <Value ColumnRef="Typ">
							<SimpleValue>FehlerKritisch</SimpleValue>
						 </Value>
						 <Value ColumnRef="Meldungstext">
							<SimpleValue>Ist eine Code- oder Werteliste zugeordnet, muss die Feldart 'Auswahl' sein.</SimpleValue>
						 </Value>
						 <Value ColumnRef="Meldungshilfe"/>
					  </Row>
					  <Row>
						 <Value ColumnRef="Code">
							<SimpleValue>1018</SimpleValue>
						 </Value>
						 <Value ColumnRef="Typ">
							<SimpleValue>Warnung</SimpleValue>
						 </Value>
						 <Value ColumnRef="Meldungstext">
							<SimpleValue>Wenn ein Datenfeld die Feldart 'Auswahl' hat, muss entweder eine Code- oder eine Werteliste zugeordnet sein.</SimpleValue>
						 </Value>
						 <Value ColumnRef="Meldungshilfe"/>
					  </Row>
					  <Row>
						 <Value ColumnRef="Code">
							<SimpleValue>1019</SimpleValue>
						 </Value>
						 <Value ColumnRef="Typ">
							<SimpleValue>FehlerMethodisch</SimpleValue>
						 </Value>
						 <Value ColumnRef="Meldungstext">
							<SimpleValue>Baukastenelemente, die in Regeln referenziert werden, d�rfen keine Versionsangaben beinhalten.</SimpleValue>
						 </Value>
						 <Value ColumnRef="Meldungshilfe"/>
					  </Row>
					  <Row>
						 <Value ColumnRef="Code">
							<SimpleValue>1021</SimpleValue>
						 </Value>
						 <Value ColumnRef="Typ">
							<SimpleValue>FehlerKritisch</SimpleValue>
						 </Value>
						 <Value ColumnRef="Meldungstext">
							<SimpleValue>Es ist keine Multiplizit�t angegeben.</SimpleValue>
						 </Value>
						 <Value ColumnRef="Meldungshilfe"/>
					  </Row>
					  <Row>
						 <Value ColumnRef="Code">
							<SimpleValue>1022</SimpleValue>
						 </Value>
						 <Value ColumnRef="Typ">
							<SimpleValue>FehlerMethodisch</SimpleValue>
						 </Value>
						 <Value ColumnRef="Meldungstext">
							<SimpleValue>Bei Verwendung von Elementen mit der Strukturelementart 'abstrakt' oder 'harmonisiert' innerhalb von Datenfeldgruppen mit der Strukturelementart 'rechtsnormgebunden' muss zur Multiplizit�t ein Bezug zu einer Handlungsgrundlage angegeben werden.</SimpleValue>
						 </Value>
						 <Value ColumnRef="Meldungshilfe"/>
					  </Row>
					  <Row>
						 <Value ColumnRef="Code">
							<SimpleValue>1023</SimpleValue>
						 </Value>
						 <Value ColumnRef="Typ">
							<SimpleValue>FehlerKritisch</SimpleValue>
						 </Value>
						 <Value ColumnRef="Meldungstext">
							<SimpleValue>Eine Datenfeldgruppe muss mindestens ein Unterelement enthalten.</SimpleValue>
						 </Value>
						 <Value ColumnRef="Meldungshilfe"/>
					  </Row>
					  <Row>
						 <Value ColumnRef="Code">
							<SimpleValue>1024</SimpleValue>
						 </Value>
						 <Value ColumnRef="Typ">
							<SimpleValue>FehlerMethodisch</SimpleValue>
						 </Value>
						 <Value ColumnRef="Meldungstext">
							<SimpleValue>Die Freitextregel muss bef�llt sein.</SimpleValue>
						 </Value>
						 <Value ColumnRef="Meldungshilfe"/>
					  </Row>
					  <Row>
						 <Value ColumnRef="Code">
							<SimpleValue>1025</SimpleValue>
						 </Value>
						 <Value ColumnRef="Typ">
							<SimpleValue>FehlerMethodisch</SimpleValue>
						 </Value>
						 <Value ColumnRef="Meldungstext">
							<SimpleValue>In einem Datenschema d�rfen Baukastenelement auf oberster Ebene nicht mehrfach in derselben Version enthalten sein.</SimpleValue>
						 </Value>
						 <Value ColumnRef="Meldungshilfe"/>
					  </Row>
					  <Row>
						 <Value ColumnRef="Code">
							<SimpleValue>1026</SimpleValue>
						 </Value>
						 <Value ColumnRef="Typ">
							<SimpleValue>FehlerKritisch</SimpleValue>
						 </Value>
						 <Value ColumnRef="Meldungstext">
							<SimpleValue>Zirkelbezug</SimpleValue>
						 </Value>
						 <Value ColumnRef="Meldungshilfe"/>
					  </Row>
					  <Row>
						 <Value ColumnRef="Code">
							<SimpleValue>1027</SimpleValue>
						 </Value>
						 <Value ColumnRef="Typ">
							<SimpleValue>FehlerKritisch</SimpleValue>
						 </Value>
						 <Value ColumnRef="Meldungstext">
							<SimpleValue>Es ist keine oder eine unbekannte Feldart angegeben.</SimpleValue>
						 </Value>
						 <Value ColumnRef="Meldungshilfe"/>
					  </Row>
					  <Row>
						 <Value ColumnRef="Code">
							<SimpleValue>1028</SimpleValue>
						 </Value>
						 <Value ColumnRef="Typ">
							<SimpleValue>FehlerKritisch</SimpleValue>
						 </Value>
						 <Value ColumnRef="Meldungstext">
							<SimpleValue>Es ist kein oder ein unbekannter Datentyp angegeben.</SimpleValue>
						 </Value>
						 <Value ColumnRef="Meldungshilfe"/>
					  </Row>
					  <Row>
						 <Value ColumnRef="Code">
							<SimpleValue>1029</SimpleValue>
						 </Value>
						 <Value ColumnRef="Typ">
							<SimpleValue>FehlerKritisch</SimpleValue>
						 </Value>
						 <Value ColumnRef="Meldungstext">
							<SimpleValue>Es ist keine oder eine unbekannte Relationsart angegeben.</SimpleValue>
						 </Value>
						 <Value ColumnRef="Meldungshilfe"/>
					  </Row>
					  <Row>
						 <Value ColumnRef="Code">
							<SimpleValue>1030</SimpleValue>
						 </Value>
						 <Value ColumnRef="Typ">
							<SimpleValue>FehlerKritisch</SimpleValue>
						 </Value>
						 <Value ColumnRef="Meldungstext">
							<SimpleValue>Es ist keine oder eine unbekannte Vorbef�llungsart angegeben.</SimpleValue>
						 </Value>
						 <Value ColumnRef="Meldungshilfe"/>
					  </Row>
					  <Row>
						 <Value ColumnRef="Code">
							<SimpleValue>1031</SimpleValue>
						 </Value>
						 <Value ColumnRef="Typ">
							<SimpleValue>FehlerKritisch</SimpleValue>
						 </Value>
						 <Value ColumnRef="Meldungstext">
							<SimpleValue>Es ist keine oder eine unbekannte Strukturelementart angegeben.</SimpleValue>
						 </Value>
						 <Value ColumnRef="Meldungshilfe"/>
					  </Row>
					  <Row>
						 <Value ColumnRef="Code">
							<SimpleValue>1032</SimpleValue>
						 </Value>
						 <Value ColumnRef="Typ">
							<SimpleValue>FehlerKritisch</SimpleValue>
						 </Value>
						 <Value ColumnRef="Meldungstext">
							<SimpleValue>Es ist kein oder ein unbekannter Status angegeben.</SimpleValue>
						 </Value>
						 <Value ColumnRef="Meldungshilfe"/>
					  </Row>
					  <Row>
						 <Value ColumnRef="Code">
							<SimpleValue>1033</SimpleValue>
						 </Value>
						 <Value ColumnRef="Typ">
							<SimpleValue>FehlerKritisch</SimpleValue>
						 </Value>
						 <Value ColumnRef="Meldungstext">
							<SimpleValue>Es ist keine oder eine unbekannte �nderbarkeit der Struktur angegeben.</SimpleValue>
						 </Value>
						 <Value ColumnRef="Meldungshilfe"/>
					  </Row>
					  <Row>
						 <Value ColumnRef="Code">
							<SimpleValue>1034</SimpleValue>
						 </Value>
						 <Value ColumnRef="Typ">
							<SimpleValue>FehlerKritisch</SimpleValue>
						 </Value>
						 <Value ColumnRef="Meldungstext">
							<SimpleValue>Es ist keine oder eine unbekannte �nderbarkeit der Repr�sentation angegeben.</SimpleValue>
						 </Value>
						 <Value ColumnRef="Meldungshilfe"/>
					  </Row>
					  <Row>
						 <Value ColumnRef="Code">
							<SimpleValue>1035</SimpleValue>
						 </Value>
						 <Value ColumnRef="Typ">
							<SimpleValue>FehlerMethodisch</SimpleValue>
						 </Value>
						 <Value ColumnRef="Meldungstext">
							<SimpleValue>Hinweis noch im alten Format.</SimpleValue>
						 </Value>
						 <Value ColumnRef="Meldungshilfe"/>
					  </Row>
					  <Row>
						 <Value ColumnRef="Code">
							<SimpleValue>1036</SimpleValue>
						 </Value>
						 <Value ColumnRef="Typ">
							<SimpleValue>FehlerMethodisch</SimpleValue>
						 </Value>
						 <Value ColumnRef="Meldungstext">
							<SimpleValue>In einer Codeliste muss die Kombination aus Kennung und Version immer eindeutig sein.</SimpleValue>
						 </Value>
						 <Value ColumnRef="Meldungshilfe"/>
					  </Row>
					  <Row>
						 <Value ColumnRef="Code">
							<SimpleValue>1037</SimpleValue>
						 </Value>
						 <Value ColumnRef="Typ">
							<SimpleValue>Warnung</SimpleValue>
						 </Value>
						 <Value ColumnRef="Meldungstext">
							<SimpleValue>In einem Datenschema sollte eine Codeliste i. d. R. nicht in mehreren Versionen verwendet werden.</SimpleValue>
						 </Value>
						 <Value ColumnRef="Meldungshilfe"/>
					  </Row>
					  <Row>
						 <Value ColumnRef="Code">
							<SimpleValue>1038</SimpleValue>
						 </Value>
						 <Value ColumnRef="Typ">
							<SimpleValue>FehlerKritisch</SimpleValue>
						 </Value>
						 <Value ColumnRef="Meldungstext">
							<SimpleValue>Die ID eines Objektes ist nicht gesetzt.</SimpleValue>
						 </Value>
						 <Value ColumnRef="Meldungshilfe"/>
					  </Row>
					  <Row>
						 <Value ColumnRef="Code">
							<SimpleValue>1039</SimpleValue>
						 </Value>
						 <Value ColumnRef="Typ">
							<SimpleValue>FehlerKritisch</SimpleValue>
						 </Value>
						 <Value ColumnRef="Meldungstext">
							<SimpleValue>Das Format der ID entspricht nicht den Vorgaben.</SimpleValue>
						 </Value>
						 <Value ColumnRef="Meldungshilfe"/>
					  </Row>
					  <Row>
						 <Value ColumnRef="Code">
							<SimpleValue>1040</SimpleValue>
						 </Value>
						 <Value ColumnRef="Typ">
							<SimpleValue>FehlerKritisch</SimpleValue>
						 </Value>
						 <Value ColumnRef="Meldungstext">
							<SimpleValue>Die Kennung einer Codeliste ist leer.</SimpleValue>
						 </Value>
						 <Value ColumnRef="Meldungshilfe"/>
					  </Row>
					  <Row>
						 <Value ColumnRef="Code">
							<SimpleValue>1041</SimpleValue>
						 </Value>
						 <Value ColumnRef="Typ">
							<SimpleValue>FehlerMethodisch</SimpleValue>
						 </Value>
						 <Value ColumnRef="Meldungstext">
							<SimpleValue>Baukastenelemente, die in Regeln referenziert werden, verwenden noch die alte, verk�rzte Element-ID.</SimpleValue>
						 </Value>
						 <Value ColumnRef="Meldungshilfe"/>
					  </Row>
					  <Row>
						 <Value ColumnRef="Code">
							<SimpleValue>1042</SimpleValue>
						 </Value>
						 <Value ColumnRef="Typ">
							<SimpleValue>FehlerKritisch</SimpleValue>
						 </Value>
						 <Value ColumnRef="Meldungstext">
							<SimpleValue>Es ist keine oder eine unbekannte Gruppenart angegeben.</SimpleValue>
						 </Value>
						 <Value ColumnRef="Meldungshilfe"/>
					  </Row>
					  <Row>
						 <Value ColumnRef="Code">
							<SimpleValue>1043</SimpleValue>
						 </Value>
						 <Value ColumnRef="Typ">
							<SimpleValue>FehlerMethodisch</SimpleValue>
						 </Value>
						 <Value ColumnRef="Meldungstext">
							<SimpleValue>Eine Auswahlgruppe muss mindestens zwei Unterelemente haben.</SimpleValue>
						 </Value>
						 <Value ColumnRef="Meldungshilfe"/>
					  </Row>
					  <Row>
						 <Value ColumnRef="Code">
							<SimpleValue>1044</SimpleValue>
						 </Value>
						 <Value ColumnRef="Typ">
							<SimpleValue>FehlerMethodisch</SimpleValue>
						 </Value>
						 <Value ColumnRef="Meldungstext">
							<SimpleValue>Eine Code- oder Werteliste muss mindestens zwei Eintr�ge haben.</SimpleValue>
						 </Value>
						 <Value ColumnRef="Meldungshilfe"/>
					  </Row>
					  <Row>
						 <Value ColumnRef="Code">
							<SimpleValue>1045</SimpleValue>
						 </Value>
						 <Value ColumnRef="Typ">
							<SimpleValue>FehlerKritisch</SimpleValue>
						 </Value>
						 <Value ColumnRef="Meldungstext">
							<SimpleValue>Innerhalb einer Code- oder Werteliste d�rfen Codes (Schl�ssel) nicht doppelt verwendet werden.</SimpleValue>
						 </Value>
						 <Value ColumnRef="Meldungshilfe"/>
					  </Row>
					  <Row>
						 <Value ColumnRef="Code">
							<SimpleValue>1046</SimpleValue>
						 </Value>
						 <Value ColumnRef="Typ">
							<SimpleValue>FehlerKritisch</SimpleValue>
						 </Value>
						 <Value ColumnRef="Meldungstext">
							<SimpleValue>Die Multiplizit�t entspricht nicht den Formatvorgaben.</SimpleValue>
						 </Value>
						 <Value ColumnRef="Meldungshilfe"/>
					  </Row>
					  <Row>
						 <Value ColumnRef="Code">
							<SimpleValue>1047</SimpleValue>
						 </Value>
						 <Value ColumnRef="Typ">
							<SimpleValue>FehlerKritisch</SimpleValue>
						 </Value>
						 <Value ColumnRef="Meldungstext">
							<SimpleValue>In der Multiplizit�t muss die minimale Anzahl kleiner oder gleich der maximalen Anzahl sein.</SimpleValue>
						 </Value>
						 <Value ColumnRef="Meldungshilfe"/>
					  </Row>
					  <Row>
						 <Value ColumnRef="Code">
							<SimpleValue>1048</SimpleValue>
						 </Value>
						 <Value ColumnRef="Typ">
							<SimpleValue>FehlerMethodisch</SimpleValue>
						 </Value>
						 <Value ColumnRef="Meldungstext">
							<SimpleValue>Die URN-Kennung einer Codeliste entspricht nicht den Formatvorgaben, z. B. urn:xoev-de:fim-datenfelder:codeliste:dokumentart (Umlaute sind nicht erlaubt!).</SimpleValue>
						 </Value>
						 <Value ColumnRef="Meldungshilfe"/>
					  </Row>
					  <Row>
						 <Value ColumnRef="Code">
							<SimpleValue>1049</SimpleValue>
						 </Value>
						 <Value ColumnRef="Typ">
							<SimpleValue>FehlerKritisch</SimpleValue>
						 </Value>
						 <Value ColumnRef="Meldungstext">
							<SimpleValue>Die Definition eines Dokumentsteckbriefs muss bef�llt sein.</SimpleValue>
						 </Value>
						 <Value ColumnRef="Meldungshilfe"/>
					  </Row>
					  <Row>
						 <Value ColumnRef="Code">
							<SimpleValue>1050</SimpleValue>
						 </Value>
						 <Value ColumnRef="Typ">
							<SimpleValue>FehlerKritisch</SimpleValue>
						 </Value>
						 <Value ColumnRef="Meldungstext">
							<SimpleValue>Die Bezeichnung muss bef�llt sein.</SimpleValue>
						 </Value>
						 <Value ColumnRef="Meldungshilfe"/>
					  </Row>
					  <Row>
						 <Value ColumnRef="Code">
							<SimpleValue>1051</SimpleValue>
						 </Value>
						 <Value ColumnRef="Typ">
							<SimpleValue>FehlerKritisch</SimpleValue>
						 </Value>
						 <Value ColumnRef="Meldungstext">
							<SimpleValue>Der Bezug zur Handlungsgrundlage darf nicht leer sein.</SimpleValue>
						 </Value>
						 <Value ColumnRef="Meldungshilfe"/>
					  </Row>
					  <Row>
						 <Value ColumnRef="Code">
							<SimpleValue>1052</SimpleValue>
						 </Value>
						 <Value ColumnRef="Typ">
							<SimpleValue>FehlerKritisch</SimpleValue>
						 </Value>
						 <Value ColumnRef="Meldungstext">
							<SimpleValue>Der Bezug zur Handlungsgrundlage darf nur bei abstrakten Dokumentsteckbriefen leer sein.</SimpleValue>
						 </Value>
						 <Value ColumnRef="Meldungshilfe"/>
					  </Row>
					  <Row>
						 <Value ColumnRef="Code">
							<SimpleValue>1053</SimpleValue>
						 </Value>
						 <Value ColumnRef="Typ">
							<SimpleValue>FehlerKritisch</SimpleValue>
						 </Value>
						 <Value ColumnRef="Meldungstext">
							<SimpleValue>Zu einem konkreten Dokumentsteckbrief d�rfen keine Dokumentsteckbriefe zugeordnet werden.</SimpleValue>
						 </Value>
						 <Value ColumnRef="Meldungshilfe"/>
					  </Row>
					  <Row>
						 <Value ColumnRef="Code">
							<SimpleValue>1054</SimpleValue>
						 </Value>
						 <Value ColumnRef="Typ">
							<SimpleValue>FehlerKritisch</SimpleValue>
						 </Value>
						 <Value ColumnRef="Meldungstext">
							<SimpleValue>Zu einem abstrakten Dokumentsteckbrief m�ssen mindestens zwei Dokumentsteckbriefe zugeordnet werden.</SimpleValue>
						 </Value>
						 <Value ColumnRef="Meldungshilfe"/>
					  </Row>
					  <Row>
						 <Value ColumnRef="Code">
							<SimpleValue>1055</SimpleValue>
						 </Value>
						 <Value ColumnRef="Typ">
							<SimpleValue>FehlerKritisch</SimpleValue>
						 </Value>
						 <Value ColumnRef="Meldungstext">
							<SimpleValue>Es ist keine oder eine unbekannte Dokumentart angegeben.</SimpleValue>
						 </Value>
						 <Value ColumnRef="Meldungshilfe"/>
					  </Row>
					  <Row>
						 <Value ColumnRef="Code">
							<SimpleValue>1056</SimpleValue>
						 </Value>
						 <Value ColumnRef="Typ">
							<SimpleValue>FehlerKritisch</SimpleValue>
						 </Value>
						 <Value ColumnRef="Meldungstext">
							<SimpleValue>Die Dateigr��e darf nur bef�llt sein, wenn der Datentyp des Feldes den Wert 'Anlage (Datei)' hat.</SimpleValue>
						 </Value>
						 <Value ColumnRef="Meldungshilfe"/>
					  </Row>
					  <Row>
						 <Value ColumnRef="Code">
							<SimpleValue>1057</SimpleValue>
						 </Value>
						 <Value ColumnRef="Typ">
							<SimpleValue>FehlerKritisch</SimpleValue>
						 </Value>
						 <Value ColumnRef="Meldungstext">
							<SimpleValue>Erlaubte Datentypen d�rfen nur angegeben werden, wenn der Datentyp des Feldes den Wert 'Anlage (Datei)' hat.</SimpleValue>
						 </Value>
						 <Value ColumnRef="Meldungshilfe"/>
					  </Row>
					  <Row>
						 <Value ColumnRef="Code">
							<SimpleValue>1058</SimpleValue>
						 </Value>
						 <Value ColumnRef="Typ">
							<SimpleValue>FehlerMethodisch</SimpleValue>
						 </Value>
						 <Value ColumnRef="Meldungstext">
							<SimpleValue>Spaltendefinitionen d�rfen nur angegeben werden, wenn im Datenfeld eine referenzierte Codeliste enthalten ist.</SimpleValue>
						 </Value>
						 <Value ColumnRef="Meldungshilfe"/>
					  </Row>
					  <Row>
						 <Value ColumnRef="Code">
							<SimpleValue>1059</SimpleValue>
						 </Value>
						 <Value ColumnRef="Typ">
							<SimpleValue>FehlerKritisch</SimpleValue>
						 </Value>
						 <Value ColumnRef="Meldungstext">
							<SimpleValue>Die minimale Feldl�nge muss eine ganze Zahl gr��er oder gleich Null sein.</SimpleValue>
						 </Value>
						 <Value ColumnRef="Meldungshilfe"/>
					  </Row>
					  <Row>
						 <Value ColumnRef="Code">
							<SimpleValue>1060</SimpleValue>
						 </Value>
						 <Value ColumnRef="Typ">
							<SimpleValue>FehlerKritisch</SimpleValue>
						 </Value>
						 <Value ColumnRef="Meldungstext">
							<SimpleValue>Die maximale Feldl�nge muss eine ganze Zahl gr��er Null sein.</SimpleValue>
						 </Value>
						 <Value ColumnRef="Meldungshilfe"/>
					  </Row>
					  <Row>
						 <Value ColumnRef="Code">
							<SimpleValue>1061</SimpleValue>
						 </Value>
						 <Value ColumnRef="Typ">
							<SimpleValue>FehlerKritisch</SimpleValue>
						 </Value>
						 <Value ColumnRef="Meldungstext">
							<SimpleValue>Die minimale Feldl�nge darf nicht gr��er sein als die maximale Feldl�nge.</SimpleValue>
						 </Value>
						 <Value ColumnRef="Meldungshilfe"/>
					  </Row>
					  <Row>
						 <Value ColumnRef="Code">
							<SimpleValue>1062</SimpleValue>
						 </Value>
						 <Value ColumnRef="Typ">
							<SimpleValue>FehlerKritisch</SimpleValue>
						 </Value>
						 <Value ColumnRef="Meldungstext">
							<SimpleValue>Die untere Wertgrenze muss eine Zahl sein.</SimpleValue>
						 </Value>
						 <Value ColumnRef="Meldungshilfe"/>
					  </Row>
					  <Row>
						 <Value ColumnRef="Code">
							<SimpleValue>1063</SimpleValue>
						 </Value>
						 <Value ColumnRef="Typ">
							<SimpleValue>FehlerKritisch</SimpleValue>
						 </Value>
						 <Value ColumnRef="Meldungstext">
							<SimpleValue>Die obere Wertgrenze muss eine Zahl sein.</SimpleValue>
						 </Value>
						 <Value ColumnRef="Meldungshilfe"/>
					  </Row>
					  <Row>
						 <Value ColumnRef="Code">
							<SimpleValue>1064</SimpleValue>
						 </Value>
						 <Value ColumnRef="Typ">
							<SimpleValue>FehlerKritisch</SimpleValue>
						 </Value>
						 <Value ColumnRef="Meldungstext">
							<SimpleValue>Die untere Wertgrenze darf nicht gr��er sein als die obere Wertgrenze.</SimpleValue>
						 </Value>
						 <Value ColumnRef="Meldungshilfe"/>
					  </Row>
					  <Row>
						 <Value ColumnRef="Code">
							<SimpleValue>1065</SimpleValue>
						 </Value>
						 <Value ColumnRef="Typ">
							<SimpleValue>FehlerKritisch</SimpleValue>
						 </Value>
						 <Value ColumnRef="Meldungstext">
							<SimpleValue>Die untere Wertgrenze muss eine ganze Zahl sein.</SimpleValue>
						 </Value>
						 <Value ColumnRef="Meldungshilfe"/>
					  </Row>
					  <Row>
						 <Value ColumnRef="Code">
							<SimpleValue>1066</SimpleValue>
						 </Value>
						 <Value ColumnRef="Typ">
							<SimpleValue>FehlerKritisch</SimpleValue>
						 </Value>
						 <Value ColumnRef="Meldungstext">
							<SimpleValue>Die obere Wertgrenze muss eine ganze Zahl sein.</SimpleValue>
						 </Value>
						 <Value ColumnRef="Meldungshilfe"/>
					  </Row>
					  <Row>
						 <Value ColumnRef="Code">
							<SimpleValue>1067</SimpleValue>
						 </Value>
						 <Value ColumnRef="Typ">
							<SimpleValue>FehlerKritisch</SimpleValue>
						 </Value>
						 <Value ColumnRef="Meldungstext">
							<SimpleValue>Die untere Wertgrenze muss ein Datum sein.</SimpleValue>
						 </Value>
						 <Value ColumnRef="Meldungshilfe"/>
					  </Row>
					  <Row>
						 <Value ColumnRef="Code">
							<SimpleValue>1068</SimpleValue>
						 </Value>
						 <Value ColumnRef="Typ">
							<SimpleValue>FehlerKritisch</SimpleValue>
						 </Value>
						 <Value ColumnRef="Meldungstext">
							<SimpleValue>Die obere Wertgrenze muss ein Datum sein.</SimpleValue>
						 </Value>
						 <Value ColumnRef="Meldungshilfe"/>
					  </Row>
					  <Row>
						 <Value ColumnRef="Code">
							<SimpleValue>1069</SimpleValue>
						 </Value>
						 <Value ColumnRef="Typ">
							<SimpleValue>FehlerKritisch</SimpleValue>
						 </Value>
						 <Value ColumnRef="Meldungstext">
							<SimpleValue>Der Inhalt muss eine Zahl sein.</SimpleValue>
						 </Value>
						 <Value ColumnRef="Meldungshilfe"/>
					  </Row>
					  <Row>
						 <Value ColumnRef="Code">
							<SimpleValue>1070</SimpleValue>
						 </Value>
						 <Value ColumnRef="Typ">
							<SimpleValue>FehlerKritisch</SimpleValue>
						 </Value>
						 <Value ColumnRef="Meldungstext">
							<SimpleValue>Der Inhalt muss eine ganze Zahl sein.</SimpleValue>
						 </Value>
						 <Value ColumnRef="Meldungshilfe"/>
					  </Row>
					  <Row>
						 <Value ColumnRef="Code">
							<SimpleValue>1071</SimpleValue>
						 </Value>
						 <Value ColumnRef="Typ">
							<SimpleValue>FehlerKritisch</SimpleValue>
						 </Value>
						 <Value ColumnRef="Meldungstext">
							<SimpleValue>Der Inhalt muss ein Datum sein.</SimpleValue>
						 </Value>
						 <Value ColumnRef="Meldungshilfe"/>
					  </Row>
					  <Row>
						 <Value ColumnRef="Code">
							<SimpleValue>1072</SimpleValue>
						 </Value>
						 <Value ColumnRef="Typ">
							<SimpleValue>FehlerKritisch</SimpleValue>
						 </Value>
						 <Value ColumnRef="Meldungstext">
							<SimpleValue>Der Inhalt unterschreitet die untere Wertgrenze.</SimpleValue>
						 </Value>
						 <Value ColumnRef="Meldungshilfe"/>
					  </Row>
					  <Row>
						 <Value ColumnRef="Code">
							<SimpleValue>1073</SimpleValue>
						 </Value>
						 <Value ColumnRef="Typ">
							<SimpleValue>FehlerKritisch</SimpleValue>
						 </Value>
						 <Value ColumnRef="Meldungstext">
							<SimpleValue>Der Inhalt �berschreitet die obere Wertgrenze.</SimpleValue>
						 </Value>
						 <Value ColumnRef="Meldungshilfe"/>
					  </Row>
					  <Row>
						 <Value ColumnRef="Code">
							<SimpleValue>1074</SimpleValue>
						 </Value>
						 <Value ColumnRef="Typ">
							<SimpleValue>FehlerKritisch</SimpleValue>
						 </Value>
						 <Value ColumnRef="Meldungstext">
							<SimpleValue>Der Inhalt unterschreitet die Minimall�nge.</SimpleValue>
						 </Value>
						 <Value ColumnRef="Meldungshilfe"/>
					  </Row>
					  <Row>
						 <Value ColumnRef="Code">
							<SimpleValue>1075</SimpleValue>
						 </Value>
						 <Value ColumnRef="Typ">
							<SimpleValue>FehlerKritisch</SimpleValue>
						 </Value>
						 <Value ColumnRef="Meldungstext">
							<SimpleValue>Der Inhalt �berschreitet die Maximall�nge.</SimpleValue>
						 </Value>
						 <Value ColumnRef="Meldungshilfe"/>
					  </Row>
					  <Row>
						 <Value ColumnRef="Code">
							<SimpleValue>1076</SimpleValue>
						 </Value>
						 <Value ColumnRef="Typ">
							<SimpleValue>FehlerMethodisch</SimpleValue>
						 </Value>
						 <Value ColumnRef="Meldungstext">
							<SimpleValue>Der Inhalt stimmt nicht mit der zugeordneten Codeliste �berein.</SimpleValue>
						 </Value>
						 <Value ColumnRef="Meldungshilfe"/>
					  </Row>
					  <Row>
						 <Value ColumnRef="Code">
							<SimpleValue>1077</SimpleValue>
						 </Value>
						 <Value ColumnRef="Typ">
							<SimpleValue>FehlerKritisch</SimpleValue>
						 </Value>
						 <Value ColumnRef="Meldungstext">
							<SimpleValue>Der Inhalt muss ein Wahrheitswert sein (true oder false).</SimpleValue>
						 </Value>
						 <Value ColumnRef="Meldungshilfe"/>
					  </Row>
					  <Row>
						 <Value ColumnRef="Code">
							<SimpleValue>1078</SimpleValue>
						 </Value>
						 <Value ColumnRef="Typ">
							<SimpleValue>FehlerKritisch</SimpleValue>
						 </Value>
						 <Value ColumnRef="Meldungstext">
							<SimpleValue>Ein Datenschema muss mindestens ein Unterelement enthalten.</SimpleValue>
						 </Value>
						 <Value ColumnRef="Meldungshilfe"/>
					  </Row>
					  <Row>
						 <Value ColumnRef="Code">
							<SimpleValue>1079</SimpleValue>
						 </Value>
						 <Value ColumnRef="Typ">
							<SimpleValue>FehlerKritisch</SimpleValue>
						 </Value>
						 <Value ColumnRef="Meldungstext">
							<SimpleValue>Die untere Wertgrenze muss ein Zeitpunkt (Datum und Uhrzeit) sein.</SimpleValue>
						 </Value>
						 <Value ColumnRef="Meldungshilfe"/>
					  </Row>
					  <Row>
						 <Value ColumnRef="Code">
							<SimpleValue>1080</SimpleValue>
						 </Value>
						 <Value ColumnRef="Typ">
							<SimpleValue>FehlerKritisch</SimpleValue>
						 </Value>
						 <Value ColumnRef="Meldungstext">
							<SimpleValue>Die obere Wertgrenze muss ein Zeitpunkt (Datum und Uhrzeit) sein.</SimpleValue>
						 </Value>
						 <Value ColumnRef="Meldungshilfe"/>
					  </Row>
					  <Row>
						 <Value ColumnRef="Code">
							<SimpleValue>1081</SimpleValue>
						 </Value>
						 <Value ColumnRef="Typ">
							<SimpleValue>FehlerKritisch</SimpleValue>
						 </Value>
						 <Value ColumnRef="Meldungstext">
							<SimpleValue>Die untere Wertgrenze muss eine Uhrzeit sein.</SimpleValue>
						 </Value>
						 <Value ColumnRef="Meldungshilfe"/>
					  </Row>
					  <Row>
						 <Value ColumnRef="Code">
							<SimpleValue>1082</SimpleValue>
						 </Value>
						 <Value ColumnRef="Typ">
							<SimpleValue>FehlerKritisch</SimpleValue>
						 </Value>
						 <Value ColumnRef="Meldungstext">
							<SimpleValue>Die obere Wertgrenze muss eine Uhrzeit sein.</SimpleValue>
						 </Value>
						 <Value ColumnRef="Meldungshilfe"/>
					  </Row>
					  <Row>
						 <Value ColumnRef="Code">
							<SimpleValue>1083</SimpleValue>
						 </Value>
						 <Value ColumnRef="Typ">
							<SimpleValue>FehlerKritisch</SimpleValue>
						 </Value>
						 <Value ColumnRef="Meldungstext">
							<SimpleValue>Der Inhalt muss ein Zeitpunkt (Datum und Uhrzeit) sein.</SimpleValue>
						 </Value>
						 <Value ColumnRef="Meldungshilfe"/>
					  </Row>
					  <Row>
						 <Value ColumnRef="Code">
							<SimpleValue>1084</SimpleValue>
						 </Value>
						 <Value ColumnRef="Typ">
							<SimpleValue>FehlerKritisch</SimpleValue>
						 </Value>
						 <Value ColumnRef="Meldungstext">
							<SimpleValue>Der Inhalt muss eine Uhrzeit sein.</SimpleValue>
						 </Value>
						 <Value ColumnRef="Meldungshilfe"/>
					  </Row>
					  <Row>
						 <Value ColumnRef="Code">
							<SimpleValue>1085</SimpleValue>
						 </Value>
						 <Value ColumnRef="Typ">
							<SimpleValue>FehlerMethodisch</SimpleValue>
						 </Value>
						 <Value ColumnRef="Meldungstext">
							<SimpleValue>Der Inhalt muss ein Code-Wert der Werteliste sein.</SimpleValue>
						 </Value>
						 <Value ColumnRef="Meldungshilfe"/>
					  </Row>
					  <Row>
						 <Value ColumnRef="Code">
							<SimpleValue>1087</SimpleValue>
						 </Value>
						 <Value ColumnRef="Typ">
							<SimpleValue>FehlerKritisch</SimpleValue>
						 </Value>
						 <Value ColumnRef="Meldungstext">
							<SimpleValue>Relation zu einem unzul�ssigen Objekt.</SimpleValue>
						 </Value>
						 <Value ColumnRef="Meldungshilfe"/>
					  </Row>
					  <Row>
						 <Value ColumnRef="Code">
							<SimpleValue>1088</SimpleValue>
						 </Value>
						 <Value ColumnRef="Typ">
							<SimpleValue>FehlerMethodisch</SimpleValue>
						 </Value>
						 <Value ColumnRef="Meldungstext">
							<SimpleValue>Diese Relation darf in diesem Objekt nicht verwendet werden.</SimpleValue>
						 </Value>
						 <Value ColumnRef="Meldungshilfe"/>
					  </Row>
					  <Row>
						 <Value ColumnRef="Code">
							<SimpleValue>1089</SimpleValue>
						 </Value>
						 <Value ColumnRef="Typ">
							<SimpleValue>Deaktiviert</SimpleValue>
						 </Value>
						 <Value ColumnRef="Meldungstext">
							<SimpleValue>Bei Datenfeldern mit der Feldart 'Eingabe' darf der Datentyp nicht 'Statisches Objekt' sein.</SimpleValue>
						 </Value>
						 <Value ColumnRef="Meldungshilfe"/>
					  </Row>
					  <Row>
						 <Value ColumnRef="Code">
							<SimpleValue>1090</SimpleValue>
						 </Value>
						 <Value ColumnRef="Typ">
							<SimpleValue>FehlerKritisch</SimpleValue>
						 </Value>
						 <Value ColumnRef="Meldungstext">
							<SimpleValue>Bei Datenfeldern mit der Feldart 'Statisch' darf der Datentyp nur 'Statisches Objekt', 'Text' oder 'Text (String Latin)' sein.</SimpleValue>
						 </Value>
						 <Value ColumnRef="Meldungshilfe"/>
					  </Row>
					  <Row>
						 <Value ColumnRef="Code">
							<SimpleValue>1091</SimpleValue>
						 </Value>
						 <Value ColumnRef="Typ">
							<SimpleValue>FehlerKritisch</SimpleValue>
						 </Value>
						 <Value ColumnRef="Meldungstext">
							<SimpleValue>In der Relation ist kein Objekt angegeben.</SimpleValue>
						 </Value>
						 <Value ColumnRef="Meldungshilfe"/>
					  </Row>
					  <Row>
						 <Value ColumnRef="Code">
							<SimpleValue>1092</SimpleValue>
						 </Value>
						 <Value ColumnRef="Typ">
							<SimpleValue>FehlerKritisch</SimpleValue>
						 </Value>
						 <Value ColumnRef="Meldungstext">
							<SimpleValue>Die Angabe zu IstAbstrakt ist falsch oder leer.</SimpleValue>
						 </Value>
						 <Value ColumnRef="Meldungshilfe"/>
					  </Row>
					  <Row>
						 <Value ColumnRef="Code">
							<SimpleValue>1093</SimpleValue>
						 </Value>
						 <Value ColumnRef="Typ">
							<SimpleValue>Warnung</SimpleValue>
						 </Value>
						 <Value ColumnRef="Meldungstext">
							<SimpleValue>Innerhalb einer Code- oder Werteliste sollten Namen (Bezeichnungen) nicht doppelt verwendet werden.</SimpleValue>
						 </Value>
						 <Value ColumnRef="Meldungshilfe"/>
					  </Row>
					  <Row>
						 <Value ColumnRef="Code">
							<SimpleValue>1094</SimpleValue>
						 </Value>
						 <Value ColumnRef="Typ">
							<SimpleValue>FehlerMethodisch</SimpleValue>
						 </Value>
						 <Value ColumnRef="Meldungstext">
							<SimpleValue>Datenschemata oder Datenfeldgruppen mit mindestens einem weiteren Unterelement d�rfen das Element F60000000001 'Default-Datenfeld' nicht enthalten.</SimpleValue>
						 </Value>
						 <Value ColumnRef="Meldungshilfe"/>
					  </Row>
					  <Row>
						 <Value ColumnRef="Code">
							<SimpleValue>1095</SimpleValue>
						 </Value>
						 <Value ColumnRef="Typ">
							<SimpleValue>Warnung</SimpleValue>
						 </Value>
						 <Value ColumnRef="Meldungstext">
							<SimpleValue>Datenschemata oder Datenfeldgruppen sollten das Element F60000000001 'Default-Datenfeld' nur in Ausnahmef�llen beinhalten.</SimpleValue>
						 </Value>
						 <Value ColumnRef="Meldungshilfe"/>
					  </Row>
					  <Row>
						 <Value ColumnRef="Code">
							<SimpleValue>1096</SimpleValue>
						 </Value>
						 <Value ColumnRef="Typ">
							<SimpleValue>Warnung</SimpleValue>
						 </Value>
						 <Value ColumnRef="Meldungstext">
							<SimpleValue>Ein Datenschema sollte nur �bergangsweise dem Dokumentsteckbrief D99000000001 'Default-Dokumentsteckbrief' zugeordnet werden.</SimpleValue>
						 </Value>
						 <Value ColumnRef="Meldungshilfe"/>
					  </Row>
					  <Row>
						 <Value ColumnRef="Code">
							<SimpleValue>1097</SimpleValue>
						 </Value>
						 <Value ColumnRef="Typ">
							<SimpleValue>FehlerMethodisch</SimpleValue>
						 </Value>
						 <Value ColumnRef="Meldungstext">
							<SimpleValue>Ein methodisch oder fachlich freigegebenes Datenschema darf nicht dem Dokumentsteckbrief D99000000001 'Default-Dokumentsteckbrief' zugeordnet sein.</SimpleValue>
						 </Value>
						 <Value ColumnRef="Meldungshilfe"/>
					  </Row>
					  <Row>
						 <Value ColumnRef="Code">
							<SimpleValue>1098</SimpleValue>
						 </Value>
						 <Value ColumnRef="Typ">
							<SimpleValue>FehlerMethodisch</SimpleValue>
						 </Value>
						 <Value ColumnRef="Meldungstext">
							<SimpleValue>Bezeichnung und Hilfetext d�rfen nicht gleich sein.</SimpleValue>
						 </Value>
						 <Value ColumnRef="Meldungshilfe"/>
					  </Row>
					  <Row>
						 <Value ColumnRef="Code">
							<SimpleValue>1099</SimpleValue>
						 </Value>
						 <Value ColumnRef="Typ">
							<SimpleValue>FehlerMethodisch</SimpleValue>
						 </Value>
						 <Value ColumnRef="Meldungstext">
							<SimpleValue>Name und Hilfetext d�rfen nicht gleich sein.</SimpleValue>
						 </Value>
						 <Value ColumnRef="Meldungshilfe"/>
					  </Row>
					  <Row>
						 <Value ColumnRef="Code">
							<SimpleValue>1100</SimpleValue>
						 </Value>
						 <Value ColumnRef="Typ">
							<SimpleValue>FehlerKritisch</SimpleValue>
						 </Value>
						 <Value ColumnRef="Meldungstext">
							<SimpleValue>Bei Datenfeldern mit den Datentypen 'Anlage (Datei)' oder 'Statisches Objekt' darf der Inhalt nicht gef�llt sein.</SimpleValue>
						 </Value>
						 <Value ColumnRef="Meldungshilfe"/>
					  </Row>
					  <Row>
						 <Value ColumnRef="Code">
							<SimpleValue>1101</SimpleValue>
						 </Value>
						 <Value ColumnRef="Typ">
							<SimpleValue>Warnung</SimpleValue>
						 </Value>
						 <Value ColumnRef="Meldungstext">
							<SimpleValue>Der Bezug zur Handlungsgrundlage sollte bei Elementen mit der Strukturelementart 'harmonisiert' m�glichst nicht leer sein.</SimpleValue>
						 </Value>
						 <Value ColumnRef="Meldungshilfe"/>
					  </Row>
					  <Row>
						 <Value ColumnRef="Code">
							<SimpleValue>1102</SimpleValue>
						 </Value>
						 <Value ColumnRef="Typ">
							<SimpleValue>Warnung</SimpleValue>
						 </Value>
						 <Value ColumnRef="Meldungstext">
							<SimpleValue>Bei Eingabedatenfeldern mit dem Datentyp 'Text' oder 'String.Latin+' sollten, wenn m�glich, die minimale und maximale Feldl�nge angegeben werden.</SimpleValue>
						 </Value>
						 <Value ColumnRef="Meldungshilfe"/>
					  </Row>
					  <Row>
						 <Value ColumnRef="Code">
							<SimpleValue>1103</SimpleValue>
						 </Value>
						 <Value ColumnRef="Typ">
							<SimpleValue>Warnung</SimpleValue>
						 </Value>
						 <Value ColumnRef="Meldungstext">
							<SimpleValue>Bei Datenfeldern mit dem Datentyp 'Nummer', 'Ganzzahl', 'Geldbetrag' oder 'Datum' sollte, wenn m�glich, ein Wertebereich angegeben werden.</SimpleValue>
						 </Value>
						 <Value ColumnRef="Meldungshilfe"/>
					  </Row>
					  <Row>
						 <Value ColumnRef="Code">
							<SimpleValue>1104</SimpleValue>
						 </Value>
						 <Value ColumnRef="Typ">
							<SimpleValue>Deaktiviert</SimpleValue>
						 </Value>
						 <Value ColumnRef="Meldungstext">
							<SimpleValue>Zu einer Regel ist kein Script definiert.</SimpleValue>
						 </Value>
						 <Value ColumnRef="Meldungshilfe"/>
					  </Row>
					  <Row>
						 <Value ColumnRef="Code">
							<SimpleValue>1105</SimpleValue>
						 </Value>
						 <Value ColumnRef="Typ">
							<SimpleValue>Warnung</SimpleValue>
						 </Value>
						 <Value ColumnRef="Meldungstext">
							<SimpleValue>Die Version einer Codeliste sollte im Datumsformat in folgender Form angegeben werden, z. B. 2018-03-01.</SimpleValue>
						 </Value>
						 <Value ColumnRef="Meldungshilfe"/>
					  </Row>
					  <Row>
						 <Value ColumnRef="Code">
							<SimpleValue>1106</SimpleValue>
						 </Value>
						 <Value ColumnRef="Typ">
							<SimpleValue>Warnung</SimpleValue>
						 </Value>
						 <Value ColumnRef="Meldungstext">
							<SimpleValue>Eine Datenfeldgruppe sollte mehr als ein Unterelement haben.</SimpleValue>
						 </Value>
						 <Value ColumnRef="Meldungshilfe"/>
					  </Row>
					  <Row>
						 <Value ColumnRef="Code">
							<SimpleValue>1107</SimpleValue>
						 </Value>
						 <Value ColumnRef="Typ">
							<SimpleValue>Warnung</SimpleValue>
						 </Value>
						 <Value ColumnRef="Meldungstext">
							<SimpleValue>Der Hilfetext eines Dokumentsteckbriefs sollte bef�llt werden.</SimpleValue>
						 </Value>
						 <Value ColumnRef="Meldungshilfe"/>
					  </Row>
					  <Row>
						 <Value ColumnRef="Code">
							<SimpleValue>1108</SimpleValue>
						 </Value>
						 <Value ColumnRef="Typ">
							<SimpleValue>Deaktiviert</SimpleValue>
						 </Value>
						 <Value ColumnRef="Meldungstext">
							<SimpleValue>Wenn ein Datenfeld die Feldart 'Auswahl' hat, sollte der Datentyp i. d. R. vom Typ 'Text' sein.</SimpleValue>
						 </Value>
						 <Value ColumnRef="Meldungshilfe"/>
					  </Row>
					  <Row>
						 <Value ColumnRef="Code">
							<SimpleValue>1109</SimpleValue>
						 </Value>
						 <Value ColumnRef="Typ">
							<SimpleValue>Warnung</SimpleValue>
						 </Value>
						 <Value ColumnRef="Meldungstext">
							<SimpleValue>Bei einem Feld mit nur lesendem Zugriff, der Feldart 'Statisch' wird i. d. R. der Inhalt mit einem Text bef�llt.</SimpleValue>
						 </Value>
						 <Value ColumnRef="Meldungshilfe"/>
					  </Row>
					  <Row>
						 <Value ColumnRef="Code">
							<SimpleValue>1110</SimpleValue>
						 </Value>
						 <Value ColumnRef="Typ">
							<SimpleValue>Warnung</SimpleValue>
						 </Value>
						 <Value ColumnRef="Meldungstext">
							<SimpleValue>In Codelisten sollte der Bezug zur Handlungsgrundlage nicht leer sein.</SimpleValue>
						 </Value>
						 <Value ColumnRef="Meldungshilfe"/>
					  </Row>
					  <Row>
						 <Value ColumnRef="Code">
							<SimpleValue>1111</SimpleValue>
						 </Value>
						 <Value ColumnRef="Typ">
							<SimpleValue>Warnung</SimpleValue>
						 </Value>
						 <Value ColumnRef="Meldungstext">
							<SimpleValue>Codeliste wird nicht verwendet.</SimpleValue>
						 </Value>
						 <Value ColumnRef="Meldungshilfe"/>
					  </Row>
					  <Row>
						 <Value ColumnRef="Code">
							<SimpleValue>1112</SimpleValue>
						 </Value>
						 <Value ColumnRef="Typ">
							<SimpleValue>Warnung</SimpleValue>
						 </Value>
						 <Value ColumnRef="Meldungstext">
							<SimpleValue>Versionierte Baukastenelemente, die nicht verwendet werden, sollten gel�scht werden.</SimpleValue>
						 </Value>
						 <Value ColumnRef="Meldungshilfe"/>
					  </Row>
					  <Row>
						 <Value ColumnRef="Code">
							<SimpleValue>1113</SimpleValue>
						 </Value>
						 <Value ColumnRef="Typ">
							<SimpleValue>Warnung</SimpleValue>
						 </Value>
						 <Value ColumnRef="Meldungstext">
							<SimpleValue>Eine Arbeitsversion, die nicht verwendet wird und keine Versionen hat, sollte gel�scht werden.</SimpleValue>
						 </Value>
						 <Value ColumnRef="Meldungshilfe"/>
					  </Row>
					  <Row>
						 <Value ColumnRef="Code">
							<SimpleValue>1114</SimpleValue>
						 </Value>
						 <Value ColumnRef="Typ">
							<SimpleValue>Warnung</SimpleValue>
						 </Value>
						 <Value ColumnRef="Meldungstext">
							<SimpleValue>Element wird nicht verwendet.</SimpleValue>
						 </Value>
						 <Value ColumnRef="Meldungshilfe"/>
					  </Row>
					  <Row>
						 <Value ColumnRef="Code">
							<SimpleValue>1115</SimpleValue>
						 </Value>
						 <Value ColumnRef="Typ">
							<SimpleValue>Warnung</SimpleValue>
						 </Value>
						 <Value ColumnRef="Meldungstext">
							<SimpleValue>Auf die Codeliste kann nicht im XRepository zugegriffen werden. Dies k�nnte auf einen Fehler in der URN oder der Version der Codeliste zur�ckzuf�hren sein.</SimpleValue>
						 </Value>
						 <Value ColumnRef="Meldungshilfe"/>
					  </Row>
					  <Row>
						 <Value ColumnRef="Code">
							<SimpleValue>1116</SimpleValue>
						 </Value>
						 <Value ColumnRef="Typ">
							<SimpleValue>Warnung</SimpleValue>
						 </Value>
						 <Value ColumnRef="Meldungstext">
							<SimpleValue>Baukastenelemente im Status 'inaktiv' sollten nur in Ausnahmef�llen verwendet werden.</SimpleValue>
						 </Value>
						 <Value ColumnRef="Meldungshilfe"/>
					  </Row>
					  <Row>
						 <Value ColumnRef="Code">
							<SimpleValue>1117</SimpleValue>
						 </Value>
						 <Value ColumnRef="Typ">
							<SimpleValue>Hinweis</SimpleValue>
						 </Value>
						 <Value ColumnRef="Meldungstext">
							<SimpleValue>Das Feld 'Fachlicher Ersteller' darf zur Versionierung oder Ver�ffentlichung nicht leer sein.</SimpleValue>
						 </Value>
						 <Value ColumnRef="Meldungshilfe"/>
					  </Row>
					  <Row>
						 <Value ColumnRef="Code">
							<SimpleValue>1118</SimpleValue>
						 </Value>
						 <Value ColumnRef="Typ">
							<SimpleValue>FehlerKritisch</SimpleValue>
						 </Value>
						 <Value ColumnRef="Meldungstext">
							<SimpleValue>Ein Unterlement einer Auswahlgruppe muss immer die Multiplizit�t 0:1 haben.</SimpleValue>
						 </Value>
						 <Value ColumnRef="Meldungshilfe"/>
					  </Row>
					  <Row>
						 <Value ColumnRef="Code">
							<SimpleValue>1119</SimpleValue>
						 </Value>
						 <Value ColumnRef="Typ">
							<SimpleValue>Hinweis</SimpleValue>
						 </Value>
						 <Value ColumnRef="Meldungstext">
							<SimpleValue>Der Status muss zur Versionierung oder Ver�ffentlichung den Wert 'aktiv' haben.</SimpleValue>
						 </Value>
						 <Value ColumnRef="Meldungshilfe"/>
					  </Row>
					  <Row>
						 <Value ColumnRef="Code">
							<SimpleValue>1120</SimpleValue>
						 </Value>
						 <Value ColumnRef="Typ">
							<SimpleValue>FehlerMethodisch</SimpleValue>
						 </Value>
						 <Value ColumnRef="Meldungstext">
							<SimpleValue>Bei Datenfeldern mit den Datentypen 'Anlage (Datei)' oder 'Statisches Objekt' darf kein Pattern angegeben werden.</SimpleValue>
						 </Value>
						 <Value ColumnRef="Meldungshilfe"/>
					  </Row>
					  <Row>
						 <Value ColumnRef="Code">
							<SimpleValue>1121</SimpleValue>
						 </Value>
						 <Value ColumnRef="Typ">
							<SimpleValue>Warnung</SimpleValue>
						 </Value>
						 <Value ColumnRef="Meldungstext">
							<SimpleValue>Der Inhalt stimmt nicht mit der aktuellsten Version der zugeordneten Codeliste �berein.</SimpleValue>
						 </Value>
						 <Value ColumnRef="Meldungshilfe"/>
					  </Row>
					  <Row>
						 <Value ColumnRef="Code">
							<SimpleValue>1122</SimpleValue>
						 </Value>
						 <Value ColumnRef="Typ">
							<SimpleValue>FehlerMethodisch</SimpleValue>
						 </Value>
						 <Value ColumnRef="Meldungstext">
							<SimpleValue>Die referenzierte Spalte existiert nicht in der zugeordneten Codeliste.</SimpleValue>
						 </Value>
						 <Value ColumnRef="Meldungshilfe"/>
					  </Row>
					  <Row>
						 <Value ColumnRef="Code">
							<SimpleValue>1123</SimpleValue>
						 </Value>
						 <Value ColumnRef="Typ">
							<SimpleValue>Warnung</SimpleValue>
						 </Value>
						 <Value ColumnRef="Meldungstext">
							<SimpleValue>Die referenzierte Spalte existiert nicht in der aktuellsten Version der zugeordneten Codeliste.</SimpleValue>
						 </Value>
						 <Value ColumnRef="Meldungshilfe"/>
					  </Row>
					  <Row>
						 <Value ColumnRef="Code">
							<SimpleValue>1124</SimpleValue>
						 </Value>
						 <Value ColumnRef="Typ">
							<SimpleValue>FehlerMethodisch</SimpleValue>
						 </Value>
						 <Value ColumnRef="Meldungstext">
							<SimpleValue>Der zugeordnete Dokumentsteckbrief stammt nicht aus dem Datenfeldkatalog KATE.</SimpleValue>
						 </Value>
						 <Value ColumnRef="Meldungshilfe"/>
					  </Row>
					  <Row>
						 <Value ColumnRef="Code">
							<SimpleValue>1125</SimpleValue>
						 </Value>
						 <Value ColumnRef="Typ">
							<SimpleValue>Warnung</SimpleValue>
						 </Value>
						 <Value ColumnRef="Meldungstext">
							<SimpleValue>Auf den Dokumentsteckbrief kann nicht im Sammelrepsoitory zugegriffen werden.</SimpleValue>
						 </Value>
						 <Value ColumnRef="Meldungshilfe"/>
					  </Row>
					  <Row>
						 <Value ColumnRef="Code">
							<SimpleValue>1126</SimpleValue>
						 </Value>
						 <Value ColumnRef="Typ">
							<SimpleValue>Warnung</SimpleValue>
						 </Value>
						 <Value ColumnRef="Meldungstext">
							<SimpleValue>Zu dem Element existiert eine aktuellere Version.</SimpleValue>
						 </Value>
						 <Value ColumnRef="Meldungshilfe"/>
					  </Row>
					  <Row>
						 <Value ColumnRef="Code">
							<SimpleValue>1127</SimpleValue>
						 </Value>
						 <Value ColumnRef="Typ">
							<SimpleValue>Hinweis</SimpleValue>
						 </Value>
						 <Value ColumnRef="Meldungstext">
							<SimpleValue>Alle Unterelemente (Datenfelder und Datenfeldgruppen) eines ver�ffentlichen Datenschemas m�ssen auch ver�ffentlicht sein.</SimpleValue>
						 </Value>
						 <Value ColumnRef="Meldungshilfe"/>
					  </Row>
					  <Row>
						 <Value ColumnRef="Code">
							<SimpleValue>1128</SimpleValue>
						 </Value>
						 <Value ColumnRef="Typ">
							<SimpleValue>Hinweis</SimpleValue>
						 </Value>
						 <Value ColumnRef="Meldungstext">
							<SimpleValue>Alle Unterelemente (Datenfelder und Datenfeldgruppen) einer ver�ffentlichen Datenfeldgruppe m�ssen auch ver�ffentlicht sein.</SimpleValue>
						 </Value>
						 <Value ColumnRef="Meldungshilfe"/>
					  </Row>
					  <Row>
						 <Value ColumnRef="Code">
							<SimpleValue>1129</SimpleValue>
						 </Value>
						 <Value ColumnRef="Typ">
							<SimpleValue>Hinweis</SimpleValue>
						 </Value>
						 <Value ColumnRef="Meldungstext">
							<SimpleValue>Alle Unterelemente (Datenfelder und Datenfeldgruppen) eines ver�ffentlichen Datenschemas m�ssen mindestens den Status 'Entwurf' haben.</SimpleValue>
						 </Value>
						 <Value ColumnRef="Meldungshilfe"/>
					  </Row>
					  <Row>
						 <Value ColumnRef="Code">
							<SimpleValue>1130</SimpleValue>
						 </Value>
						 <Value ColumnRef="Typ">
							<SimpleValue>Hinweis</SimpleValue>
						 </Value>
						 <Value ColumnRef="Meldungstext">
							<SimpleValue>Alle Unterelemente (Datenfelder und Datenfeldgruppen) einer ver�ffentlichen Datenfeldgruppe m�ssen mindestens den Status 'Entwurf' haben.</SimpleValue>
						 </Value>
						 <Value ColumnRef="Meldungshilfe"/>
					  </Row>
						<Row>
							<Value ColumnRef="Code">
								<SimpleValue>1131</SimpleValue>
							</Value>
							<Value ColumnRef="Typ">
								<SimpleValue>FehlerKritisch</SimpleValue>
							</Value>
							<Value ColumnRef="Meldungstext">
								<SimpleValue>Der Inhalt des Elementes entspricht nicht dem Datentyp StringLatin.</SimpleValue>
							</Value>
							<Value ColumnRef="Meldungshilfe"/>
						</Row>
						<Row>
							<Value ColumnRef="Code">
								<SimpleValue>1132</SimpleValue>
							</Value>
							<Value ColumnRef="Typ">
								<SimpleValue>Warnung</SimpleValue>
							</Value>
							<Value ColumnRef="Meldungstext">
								<SimpleValue>Handlungsgrundlagen sollten m�glichst immer einzeln angegeben werden.</SimpleValue>
							</Value>
							<Value ColumnRef="Meldungshilfe"/>
						</Row>
						<Row>
							<Value ColumnRef="Code">
								<SimpleValue>1133</SimpleValue>
							</Value>
							<Value ColumnRef="Typ">
								<SimpleValue>Warnung</SimpleValue>
							</Value>
							<Value ColumnRef="Meldungstext">
								<SimpleValue>Die URL der Handlungsgrundlage ist nicht korrekt.</SimpleValue>
							</Value>
							<Value ColumnRef="Meldungshilfe"/>
						</Row>
						<Row>
							<Value ColumnRef="Code">
								<SimpleValue>1134</SimpleValue>
							</Value>
							<Value ColumnRef="Typ">
								<SimpleValue>Hinweis</SimpleValue>
							</Value>
							<Value ColumnRef="Meldungstext">
								<SimpleValue>In einer Arbeitskopie sollten i. d. R. keine Versionen von Baukastenelementen des eigenen Nummernkreises verwendet werden.</SimpleValue>
							</Value>
							<Value ColumnRef="Meldungshilfe"/>
						</Row>
						<Row>
							<Value ColumnRef="Code">
								<SimpleValue>1135</SimpleValue>
							</Value>
							<Value ColumnRef="Typ">
								<SimpleValue>FehlerKritisch</SimpleValue>
							</Value>
							<Value ColumnRef="Meldungstext">
								<SimpleValue>In einem versionierten Datenschema / einer versionierten Datenfeldgruppe darf kein unversioniertes Baukastenelement enthalten sein.</SimpleValue>
							</Value>
							<Value ColumnRef="Meldungshilfe"/>
						</Row>
				   </SimpleCodeList>
				</gc:CodeList>
			</xsl:otherwise>
		</xsl:choose>
	</xsl:variable>
	
	<xsl:variable name="Zeitzone"><xsl:if test="fn:substring(fn:format-dateTime(fn:current-dateTime(),'[Z]'),1,1) = '-'">-</xsl:if>PT<xsl:value-of select="fn:substring(fn:format-dateTime(fn:current-dateTime(),'[Z]'),2,2)"/>H</xsl:variable>
	
	<xsl:variable name="VoeDS">
		<xsl:choose>
			<xsl:when test="name(/*) ='xdf3:xdatenfelder.stammdatenschema.0102'"><xsl:value-of select="/*/xdf3:stammdatenschema/xdf3:veroeffentlichungsdatum"/></xsl:when>
			<xsl:otherwise></xsl:otherwise>
		</xsl:choose>
	</xsl:variable>

	<xsl:variable name="VoeFG">
		<xsl:choose>
			<xsl:when test="name(/*) ='xdf3:xdatenfelder.datenfeldgruppe.0103'"><xsl:value-of select="/*/xdf3:datenfeldgruppe/xdf3:veroeffentlichungsdatum"/></xsl:when>
			<xsl:otherwise></xsl:otherwise>
		</xsl:choose>
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
				Zeitzone: <xsl:value-of select="$Zeitzone"/>
				VoeDS: <xsl:value-of select="$VoeDS"/>
				VoeFG: <xsl:value-of select="$VoeFG"/>
				JavaScript: <xsl:value-of select="$JavaScript"/>
				Navigation: <xsl:value-of select="$Navigation"/>
				InterneLinks: <xsl:value-of select="$InterneLinks"/>				
				HandlungsgrundlagenLinks: <xsl:value-of select="$HandlungsgrundlagenLinks"/>				
				ToolAufruf: <xsl:value-of select="$ToolAufruf"/>
				ToolPfadPrefix: <xsl:value-of select="$ToolPfadPrefix"/>
				ToolPfadPostfix: <xsl:value-of select="$ToolPfadPostfix"/>
				WurzelAlleUnterelemente: <xsl:value-of select="$WurzelAlleUnterelemente"/>
				QSAufruf: <xsl:value-of select="$QSAufruf"/>
				QSPfadPrefix: <xsl:value-of select="$QSPfadPrefix"/>
				QSPfadPostfix: <xsl:value-of select="$QSPfadPostfix"/>
				QSHilfeAufruf: <xsl:value-of select="$QSHilfeAufruf"/>
				QSHilfePfadPrefix: <xsl:value-of select="$QSHilfePfadPrefix"/>
				QSHilfePfadPostfix: <xsl:value-of select="$QSHilfePfadPostfix"/>
				Meldungen: <xsl:value-of select="$Meldungen"/>
				MeldungenInhaltDateiname: <xsl:value-of select="$MeldungenInhaltDateiname"/>
				VersionsHinweise: <xsl:value-of select="$VersionsHinweise"/>
				MeldungsFazit: <xsl:value-of select="$MeldungsFazit"/>
				CodelistenInhalt: <xsl:value-of select="$CodelistenInhalt"/>
				AktuelleCodelisteLaden: <xsl:value-of select="$AktuelleCodelisteLaden"/>
				XRepoAufruf: <xsl:value-of select="$XRepoAufruf"/>
				DocXRepoOhneVersionPfadPrefix: <xsl:value-of select="$DocXRepoOhneVersionPfadPrefix"/>
				DocXRepoOhneVersionPfadPostfix: <xsl:value-of select="$DocXRepoOhneVersionPfadPostfix"/>
				DocXRepoMitVersionPfadPrefix: <xsl:value-of select="$DocXRepoMitVersionPfadPrefix"/>
				DocXRepoMitVersionPfadPostfix: <xsl:value-of select="$DocXRepoMitVersionPfadPostfix"/>
				XMLXRepoOhneVersionPfadPrefix: <xsl:value-of select="$XMLXRepoOhneVersionPfadPrefix"/>
				XMLXRepoOhneVersionPfadPostfix: <xsl:value-of select="$XMLXRepoOhneVersionPfadPostfix"/>
				XMLXRepoMitVersionPfadPrefix: <xsl:value-of select="$XMLXRepoMitVersionPfadPrefix"/>
				XMLXRepoMitVersionPfadPostfix: <xsl:value-of select="$XMLXRepoMitVersionPfadPostfix"/>
				SammelrepositoryCheck: <xsl:value-of select="$SammelrepositoryCheck"/>
				URLDSBList: <xsl:value-of select="$URLDSBList"/>
				URLFeList: <xsl:value-of select="$URLFeList"/>
				URLFGList: <xsl:value-of select="$URLFGList"/>
				Statistik: <xsl:value-of select="$Statistik"/>
				StatistikKennzahlen: <xsl:value-of select="$StatistikKennzahlen"/>
				StatistikVerwendung: <xsl:value-of select="$StatistikVerwendung"/>
				StatistikStrukturart: <xsl:value-of select="$StatistikStrukturart"/>
				StatistikStatus: <xsl:value-of select="$StatistikStatus"/>
				StatistikHandlungsgrundlage: <xsl:value-of select="$StatistikHandlungsgrundlage"/>
				StatistikIDVersion: <xsl:value-of select="$StatistikIDVersion"/>
				StatistikAktualitaet: <xsl:value-of select="$StatistikAktualitaet"/>
				StatistikFachlicherErsteller: <xsl:value-of select="$StatistikFachlicherErsteller"/>
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
				<xsl:variable name="OutputDateinameUndPfad" select="concat($InputPfad,$OutputDateiname)"/>

				<xsl:result-document href="{$OutputDateinameUndPfad}">
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
						<title>Details zur Datenfeldgruppe <xsl:value-of select="/*/xdf3:datenfeldgruppe/xdf3:identifikation/xdf3:id"/>
							<xsl:if test="/*/xdf3:datenfeldgruppe/xdf3:identifikation/xdf3:version"> Version <xsl:value-of select="/*/xdf3:datenfeldgruppe/xdf3:identifikation/xdf3:version"/>
							</xsl:if>
						</title>
					</xsl:when>
					<xsl:when test="name(/*) ='xdf3:xdatenfelder.dokumentsteckbrief.0101'">
						<title>Details zum Dokumentsteckbrief <xsl:value-of select="/*/xdf3:dokumentsteckbrief/xdf3:identifikation/xdf3:id"/>
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
				<xsl:if test="$Navigation = '1' and name(/*) !='xdf3:xdatenfelder.dokumentsteckbrief.0101'">
					<div id="fixiert" class="Navigation">
						<xsl:if test="$JavaScript = '1'">
							<p align="right">
								<a href="#" title="Schlie�e das Navigationsfenster" onclick="VersteckeNavigation(); return false;">&#10006;</a>
							</p>
						</xsl:if>
						<h2>Navigation</h2>
						<xsl:choose>
							<xsl:when test="name(/*) ='xdf3:xdatenfelder.stammdatenschema.0102'">
								<xsl:if test="$Statistik != '2'">
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
								</xsl:if>
								<xsl:if test="$Statistik != '0'">
									<p><a href="#Statistik">Statistik</a></p>
									<xsl:if test="$StatistikKennzahlen = '1'">
										<ul>
											<li><a href="#StatistikKennzahlen">Statistikkennzahlen</a></li>
										</ul>
									</xsl:if>
									<xsl:if test="$StatistikVerwendung = '1'">
										<ul>
											<li><a href="#StatistikVerwendung">Verwendung der Elemente</a></li>
										</ul>
									</xsl:if>
									<xsl:if test="$StatistikStrukturart = '1'">
										<ul>
											<li><a href="#StatistikAbstrakte">Abstrakte Elemente</a></li>
											<li><a href="#StatistikHarmonisierte">Harmonisierte Elemente</a></li>
											<li><a href="#StatistikRechtsnormgebundene">Rechtsnormgebundene Elemente</a></li>
										</ul>
									</xsl:if>
									<xsl:if test="$StatistikStatus = '1'">
										<ul>
											<li><a href="#StatistikStatus2">Status <i>in Bearbeitung</i></a></li>
											<li><a href="#StatistikStatus3">Status <i>Entwurf</i></a></li>
											<li><a href="#StatistikStatus4">Status <i>methodisch freigegeben</i></a></li>
											<li><a href="#StatistikStatus5">Status <i>fachlich freigegeben (silber)</i></a></li>
											<li><a href="#StatistikStatus6">Status <i>fachlich freigegeben (gold)</i></a></li>
											<li><a href="#StatistikStatus7">Status <i>inaktiv</i></a></li>
										</ul>
									</xsl:if>
									<xsl:if test="$StatistikHandlungsgrundlage = '1'">
										<ul>
											<li><a href="#StatistikHandlungsgrundlage">Elemente nach Nummernkreis und Handlungsgrundlage</a></li>
										</ul>
									</xsl:if>
									<xsl:if test="$StatistikIDVersion = '1'">
										<ul>
											<li><a href="#StatistikIDVersion">Elemente nach Nummernkreis, ID und Version</a></li>
										</ul>
									</xsl:if>
									<xsl:if test="$StatistikAktualitaet = '1'">
										<ul>
											<li><a href="#StatistikAktualitaet">Elemente nach Nummernkreis, ID, Version mit Aktualit�t</a></li>
										</ul>
									</xsl:if>
									<xsl:if test="$StatistikFachlicherErsteller = '1'">
										<ul>
											<li><a href="#StatistikFachlicherErsteller">Elemente nach Fachlichem Ersteller</a></li>
										</ul>
									</xsl:if>
								</xsl:if>
								<xsl:if test="$Statistik != '2'">
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
								</xsl:if>
							</xsl:when>
							<xsl:when test="name(/*) ='xdf3:xdatenfelder.datenfeldgruppe.0103'">
								<xsl:if test="$Statistik != '2'">
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
								</xsl:if>
								<xsl:if test="$Statistik != '0'">
									<p><a href="#Statistik">Statistik</a></p>
									<xsl:if test="$StatistikKennzahlen = '1'">
										<ul>
											<li><a href="#StatistikKennzahlen">Statistikkennzahlen</a></li>
										</ul>
									</xsl:if>
									<xsl:if test="$StatistikVerwendung = '1'">
										<ul>
											<li><a href="#StatistikVerwendung">Verwendung der Elemente</a></li>
										</ul>
									</xsl:if>
									<xsl:if test="$StatistikStrukturart = '1'">
										<ul>
											<li><a href="#StatistikAbstrakte">Abstrakte Elemente</a></li>
											<li><a href="#StatistikHarmonisierte">Harmonisierte Elemente</a></li>
											<li><a href="#StatistikRechtsnormgebundene">Rechtsnormgebundene Elemente</a></li>
										</ul>
									</xsl:if>
									<xsl:if test="$StatistikStatus = '1'">
										<ul>
											<li><a href="#StatistikStatus2">Status <i>in Bearbeitung</i></a></li>
											<li><a href="#StatistikStatus3">Status <i>Entwurf</i></a></li>
											<li><a href="#StatistikStatus4">Status <i>methodisch freigegeben</i></a></li>
											<li><a href="#StatistikStatus5">Status <i>fachlich freigegeben (silber)</i></a></li>
											<li><a href="#StatistikStatus6">Status <i>fachlich freigegeben (gold)</i></a></li>
											<li><a href="#StatistikStatus7">Status <i>inaktiv</i></a></li>
										</ul>
									</xsl:if>
									<xsl:if test="$StatistikHandlungsgrundlage = '1'">
										<ul>
											<li><a href="#StatistikHandlungsgrundlage">Elemente nach Nummernkreis und Handlungsgrundlage</a></li>
										</ul>
									</xsl:if>
									<xsl:if test="$StatistikIDVersion = '1'">
										<ul>
											<li><a href="#StatistikIDVersion">Elemente nach Nummernkreis, ID und Version</a></li>
										</ul>
									</xsl:if>
									<xsl:if test="$StatistikAktualitaet = '1'">
										<ul>
											<li><a href="#StatistikAktualitaet">Elemente nach Nummernkreis, ID, Version mit Aktualit�t</a></li>
										</ul>
									</xsl:if>
									<xsl:if test="$StatistikFachlicherErsteller = '1'">
										<ul>
											<li><a href="#StatistikFachlicherErsteller">Elemente nach Fachlichem Ersteller</a></li>
										</ul>
									</xsl:if>
								</xsl:if>
								<xsl:if test="$Statistik != '2'">
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
									<xsl:when test="$Meldungen = '1' and $Statistik !='2'">
											<a name="Bericht"/>Qualit�tsbericht Datenschema <xsl:value-of select="/*/xdf3:stammdatenschema/xdf3:identifikation/xdf3:id"/>
										<xsl:if test="/*/xdf3:stammdatenschema/xdf3:identifikation/xdf3:version">&#160;Version&#160;<xsl:value-of select="/*/xdf3:stammdatenschema/xdf3:identifikation/xdf3:version"/>
										</xsl:if>
									</xsl:when>
									<xsl:otherwise>
											<a name="Bericht"/>�bersicht Datenschema <xsl:value-of select="/*/xdf3:stammdatenschema/xdf3:identifikation/xdf3:id"/>
										<xsl:if test="/*/xdf3:stammdatenschema/xdf3:identifikation/xdf3:version">&#160;Version&#160;<xsl:value-of select="/*/xdf3:stammdatenschema/xdf3:identifikation/xdf3:version"/>
										</xsl:if>
									</xsl:otherwise>
								</xsl:choose>
							</h1>
							<xsl:if test="$Statistik != '2'">
								<xsl:if test="$Navigation = '2'">
									<p><a href="#SchemaDetails">Details zum Datenschema</a> - <a href="#ElementDetails">Details zu den enthaltenen Baukastenelementen</a> - <a href="#RegelDetails">Details zu den Regeln</a> - <a href="#CodelisteDetails">Details zu den Codelisten</a><xsl:if test="$Statistik != '0'"> - <a href="#Statistik">Statistik</a></xsl:if></p>
									<xsl:if test="$Meldungen = '1' and $JavaScript = '1'">
										<p id="versteckeLink">
											<a href="#" onclick="VersteckeMeldungen(); return false;">Blende Meldungen aus</a>
										</p>
										<p id="zeigeLink">
											<a href="#" onclick="ZeigeMeldungen(); return false;">Zeige Meldungen an</a>
										</p>
									</xsl:if>
								</xsl:if>
								<div id="Zusammenfassungsbereich">
									<xsl:if test="$MeldungsFazit = '1' and $Meldungen = '1' and $JavaScript = '1'">
										<h2>
											<a name="Zusammenfassung"/>QS-Zusammenfassung des Datenschemas <xsl:value-of select="/*/xdf3:stammdatenschema/xdf3:identifikation/xdf3:id"/>
											<xsl:if test="/*/xdf3:stammdatenschema/xdf3:identifikation/xdf3:version">&#160;Version&#160;<xsl:value-of select="/*/xdf3:stammdatenschema/xdf3:identifikation/xdf3:version"/>
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
								<xsl:call-template name="datenschemaeinzeln"/>
								<xsl:call-template name="listeelementedetail"/>
								<xsl:call-template name="listeregeldetails"/>
								<xsl:call-template name="listecodelistendetails"/>
							</xsl:if>
							<xsl:if test="$Statistik = '1' or $Statistik = '2'">
								<xsl:call-template name="statistik"/>
							</xsl:if>
							<p>Erstellt am: <xsl:value-of select="format-date(fn:current-date(),'[D01].[M01].[Y0001]')"/> um <xsl:value-of select="format-time(fn:current-time(),'[H01]:[m01]')"/> Uhr</p>
							<p>XSLT: <xsl:choose>
									<xsl:when test="fn:not(fn:string($StyleSheetURI))">
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
							<p>MeldungsVersion: <xsl:value-of select="$MeldungenInhalt/gc:CodeList/*:Identification/*:CanonicalVersionUri"/></p>
							<xsl:choose>
								<xsl:when test="$SammelrepositoryCheck ='1'">
									<p>Die Aktualit�t der Baukastenelemente wurde unter Zuhilfenahme des Sammelrepositorys gepr�ft.</p>
								</xsl:when>
								<xsl:otherwise>
									<p>Die Aktualit�t der Baukastenelemente wurde nicht zus�tzlich unter Zuhilfenahme des Sammelrepositorys gepr�ft.</p>
									<xsl:if test="$QSAufruf = '1'">
										<xsl:element name="a">
											<xsl:attribute name="href"><xsl:value-of select="$QSPfadPrefix"/><xsl:value-of select="/*/xdf3:stammdatenschema/xdf3:identifikation/xdf3:id"/><xsl:if test="/*/xdf3:stammdatenschema/xdf3:identifikation/xdf3:version">V<xsl:value-of select="/*/xdf3:stammdatenschema/xdf3:identifikation/xdf3:version"/></xsl:if><xsl:value-of select="$QSPfadPostfix"/></xsl:attribute>
											<xsl:attribute name="target">FIM-QS-Bericht</xsl:attribute>
											<xsl:attribute name="title">�ffne einen QS-Bericht (man muss vorher im Datenfeldeditor angemeldet sein).</xsl:attribute>
											�ffne einen QS-Bericht mit Aktualit�tspr�fung (man muss vorher im Datenfeldeditor angemeldet sein).
										</xsl:element>
									</xsl:if>
								</xsl:otherwise>
							</xsl:choose>
							<p class="SehrKlein">
								Meldungen: <xsl:value-of select="$Meldungen"/><br/>
								MeldungsFazit: <xsl:value-of select="$MeldungsFazit"/><br/>
								Statistik: <xsl:value-of select="$Statistik"/><br/>
								CodelistenInhalt: <xsl:value-of select="$CodelistenInhalt"/><br/>
								AktuelleCodelisteLaden: <xsl:value-of select="$AktuelleCodelisteLaden"/><br/>
								SammelrepositoryCheck: <xsl:value-of select="$SammelrepositoryCheck"/><br/>
								HandlungsgrundlagenLinks: <xsl:value-of select="$HandlungsgrundlagenLinks"/><br/>			
								ToolAufruf: <xsl:value-of select="$ToolAufruf"/>
							</p>
						</xsl:when>
						<xsl:when test="name(/*) ='xdf3:xdatenfelder.datenfeldgruppe.0103'">
							<h1>
								<xsl:choose>
									<xsl:when test="$Meldungen = '1' and $Statistik !='2'">
											<a name="Bericht"/>Qualit�tsbericht Datenfeldgruppe <xsl:value-of select="/*/xdf3:datenfeldgruppe/xdf3:identifikation/xdf3:id"/>
										<xsl:if test="/*/xdf3:datenfeldgruppe/xdf3:identifikation/xdf3:version">&#160;Version&#160;<xsl:value-of select="/*/xdf3:datenfeldgruppe/xdf3:identifikation/xdf3:version"/>
										</xsl:if>
									</xsl:when>
									<xsl:otherwise>
											<a name="Bericht"/>�bersicht Datenfeldgruppe <xsl:value-of select="/*/xdf3:datenfeldgruppe/xdf3:identifikation/xdf3:id"/>
										<xsl:if test="/*/xdf3:datenfeldgruppe/xdf3:identifikation/xdf3:version">&#160;Version&#160;<xsl:value-of select="/*/xdf3:datenfeldgruppe/xdf3:identifikation/xdf3:version"/>
										</xsl:if>
									</xsl:otherwise>
								</xsl:choose>
							</h1>
							<xsl:if test="$Statistik != '2'">
								<xsl:if test="$Navigation = '2'">
									<p><a href="#SchemaDetails">Details zur Datenfeldgruppe</a> - <a href="#ElementDetails">Details zu den enthaltenen Baukastenelementen</a> - <a href="#RegelDetails">Details zu den Regeln</a> - <a href="#CodelisteDetails">Details zu den Codelisten</a><xsl:if test="$Statistik != '0'"> - <a href="#Statistik">Statistik</a></xsl:if></p>
									<xsl:if test="$Meldungen = '1' and $JavaScript = '1'">
										<p id="versteckeLink">
											<a href="#" onclick="VersteckeMeldungen(); return false;">Blende Meldungen aus</a>
										</p>
										<p id="zeigeLink">
											<a href="#" onclick="ZeigeMeldungen(); return false;">Zeige Meldungen an</a>
										</p>
									</xsl:if>
								</xsl:if>
								
								<div id="Zusammenfassungsbereich">
									<xsl:if test="$MeldungsFazit = '1' and $Meldungen = '1' and $JavaScript = '1'">
										<h2>
											<a name="Zusammenfassung"/>QS-Zusammenfassung der Datenfeldgruppe <xsl:value-of select="/*/xdf3:datenfeldgruppe/xdf3:identifikation/xdf3:id"/>
											<xsl:if test="/*/xdf3:datenfeldgruppe/xdf3:identifikation/xdf3:version">&#160;Version&#160;<xsl:value-of select="/*/xdf3:datenfeldgruppe/xdf3:identifikation/xdf3:version"/>
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
									<xsl:when test="fn:not(fn:string($StyleSheetURI))">
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
							<p>MeldungsVersion: <xsl:value-of select="$MeldungenInhalt/gc:CodeList/*:Identification/*:CanonicalVersionUri"/></p>
							<xsl:choose>
								<xsl:when test="$SammelrepositoryCheck ='1'">
									<p>Die Aktualit�t der Baukastenelemente wurde unter Zuhilfenahme des Sammelrepositorys gepr�ft.</p>
								</xsl:when>
								<xsl:otherwise>
									<p>Die Aktualit�t der Baukastenelemente wurde nicht zus�tzlich unter Zuhilfenahme des Sammelrepositorys gepr�ft.</p>
								</xsl:otherwise>
							</xsl:choose>
							<p class="SehrKlein">
								CodelistenInhalt: <xsl:value-of select="$CodelistenInhalt"/><br/>
								AktuelleCodelisteLaden: <xsl:value-of select="$AktuelleCodelisteLaden"/><br/>
								HandlungsgrundlagenLinks: <xsl:value-of select="$HandlungsgrundlagenLinks"/><br/>			
								ToolAufruf: <xsl:value-of select="$ToolAufruf"/>
							</p>
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
									<xsl:when test="fn:not(fn:string($StyleSheetURI))">
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
							<p>MeldungsVersion: <xsl:value-of select="$MeldungenInhalt/gc:CodeList/*:Identification/*:CanonicalVersionUri"/></p>
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
		<h2>
			<xsl:choose>
				<xsl:when test="name(/*) ='xdf3:xdatenfelder.stammdatenschema.0102'">
					<a name="Statistik"/>Statistik zum Datenschema <xsl:value-of select="/*/xdf3:stammdatenschema/xdf3:identifikation/xdf3:id"/>
					<xsl:if test="/*/xdf3:stammdatenschema/xdf3:identifikation/xdf3:version">&#160;Version&#160;<xsl:value-of select="/*/xdf3:stammdatenschema/xdf3:identifikation/xdf3:version"/></xsl:if><xsl:if test="$Navigation = '2' and $Statistik != '2'">&#160;<a href="#Bericht" title="nach oben">&#8593;</a></xsl:if>
				</xsl:when>
				<xsl:when test="name(/*) ='xdf3:xdatenfelder.datenfeldgruppe.0103'">
					<a name="Statistik"/>Statistik zur Datenfeldgruppe <xsl:value-of select="/*/xdf3:datenfeldgruppe/xdf3:identifikation/xdf3:id"/>
					<xsl:if test="/*/xdf3:datenfeldgruppe/xdf3:identifikation/xdf3:version">&#160;Version&#160;<xsl:value-of select="/*/xdf3:datenfeldgruppe/xdf3:identifikation/xdf3:version"/></xsl:if><xsl:if test="$Navigation = '2' and $Statistik != '2'">&#160;<a href="#Bericht" title="nach oben">&#8593;</a></xsl:if>
				</xsl:when>
			</xsl:choose>
		</h2>
		<xsl:if test="$Navigation = '2' and ($StatistikKennzahlen = '1' or $StatistikVerwendung = '1' or $StatistikStrukturart = '1' or $StatistikStatus = '1' or $StatistikHandlungsgrundlage = '1' or $StatistikIDVersion = '1' or $StatistikAktualitaet = '1' or $StatistikFachlicherErsteller = '1')">
			<xsl:if test="$StatistikKennzahlen = '1'">
				<p>
					<a href="#StatistikKennzahlen">Statistikkennzahlen</a>
				</p>
			</xsl:if>
			<xsl:if test="$StatistikVerwendung = '1'">
				<p>
					<a href="#StatistikVerwendung">Verwendung der Elemente</a>
				</p>
			</xsl:if>
			<xsl:if test="$StatistikStrukturart = '1'">
				<p>Liste der Elemente nach Strukturelementart: <a href="#StatistikAbstrakte">Abstrakte</a> - <a href="#StatistikHarmonisierte">Harmonisierte</a> - <a href="#StatistikRechtsnormgebundene">Rechtsnormgebundene</a>
				</p>
			</xsl:if>
			<xsl:if test="$StatistikStatus = '1'">
				<p>Liste der Elemente nach Status: <a href="#StatistikStatus2">in Bearbeitung</a> - <a href="#StatistikStatus3">Entwurf</a> - <a href="#StatistikStatus4">methodisch freigegeben</a> - <a href="#StatistikStatus5">fachlich freigegeben (silber)</a> - <a href="#StatistikStatus6">fachlich freigegeben (gold)</a> - <a href="#StatistikStatus7">inaktiv</a>
				</p>
			</xsl:if>
			<xsl:if test="$StatistikHandlungsgrundlage = '1'">
				<p>
					<li><a href="#StatistikHandlungsgrundlage">Elemente nach Nummernkreis und Handlungsgrundlage</a></li>
				</p>
			</xsl:if>
			<xsl:if test="$StatistikIDVersion = '1'">
				<p>
					<a href="#StatistikIDVersion">Elemente nach Nummernkreis, ID und Version</a>
				</p>
			</xsl:if>
			<xsl:if test="$StatistikAktualitaet = '1'">
				<ul>
					<li><a href="#StatistikAktualitaet">Elemente nach Nummernkreis, ID, Version mit Aktualit�t</a></li>
				</ul>
			</xsl:if>
			<xsl:if test="$StatistikFachlicherErsteller = '1'">
				<p>
					<a href="#StatistikFachlicherErsteller">Liste der Elemente nach Fachlichem Ersteller</a>
				</p>
			</xsl:if>
		</xsl:if>
		
		<xsl:if test="$StatistikKennzahlen = '1'">
			<xsl:if test="$DebugMode = '2' or $DebugMode = '3' or $DebugMode = '4'">
				<xsl:message>
					++++++++ StatistikKennzahlen ++++++++
				</xsl:message>
			</xsl:if>
			<h3>
				<a name="StatistikKennzahlen"/>�bersicht der Kennzahlen<br/>
			</h3>
			<xsl:variable name="HeimNummernkreis"><xsl:value-of select="fn:substring(fn:concat(/*/xdf3:stammdatenschema/xdf3:identifikation/xdf3:id/text(),/*/xdf3:datenfeldgruppe/xdf3:identifikation/xdf3:id/text()),2,2)"/></xsl:variable>
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
			<xsl:variable name="AnzahlFeldgruppenBOBString">
				<xsl:for-each-group select="//xdf3:datenfeldgruppe[fn:substring(xdf3:identifikation/xdf3:id/text(),2,2) = '60']" group-by="concat(xdf3:identifikation/xdf3:id,xdf3:identifikation/xdf3:version)">
					<xsl:if test="fn:position() = 1">
						<xsl:value-of select="fn:last()"/>
					</xsl:if>
				</xsl:for-each-group>
			</xsl:variable>
			<xsl:variable name="AnzahlFeldgruppenBOB">
				<xsl:choose>
					<xsl:when test="empty($AnzahlFeldgruppenBOBString/text())">0</xsl:when>
					<xsl:otherwise>
						<xsl:value-of select="$AnzahlFeldgruppenBOBString"/>
					</xsl:otherwise>
				</xsl:choose>
			</xsl:variable>
			<xsl:variable name="AnzahlFeldgruppenHeimString">
				<xsl:for-each-group select="//xdf3:datenfeldgruppe[fn:substring(xdf3:identifikation/xdf3:id/text(),2,2) = $HeimNummernkreis]" group-by="concat(xdf3:identifikation/xdf3:id,xdf3:identifikation/xdf3:version)">
					<xsl:if test="fn:position() = 1">
						<xsl:value-of select="fn:last()"/>
					</xsl:if>
				</xsl:for-each-group>
			</xsl:variable>
			<xsl:variable name="AnzahlFeldgruppenHeim">
				<xsl:choose>
					<xsl:when test="empty($AnzahlFeldgruppenHeimString/text())">0</xsl:when>
					<xsl:otherwise>
						<xsl:value-of select="$AnzahlFeldgruppenHeimString"/>
					</xsl:otherwise>
				</xsl:choose>
			</xsl:variable>
			<xsl:variable name="AnzahlFeldgruppenFremdString">
				<xsl:for-each-group select="//xdf3:datenfeldgruppe[fn:substring(xdf3:identifikation/xdf3:id/text(),2,2) != $HeimNummernkreis and fn:substring(xdf3:identifikation/xdf3:id/text(),2,2) != '60']" group-by="concat(xdf3:identifikation/xdf3:id,xdf3:identifikation/xdf3:version)">
					<xsl:if test="fn:position() = 1">
						<xsl:value-of select="fn:last()"/>
					</xsl:if>
				</xsl:for-each-group>
			</xsl:variable>
			<xsl:variable name="AnzahlFeldgruppenFremd">
				<xsl:choose>
					<xsl:when test="empty($AnzahlFeldgruppenFremdString/text())">0</xsl:when>
					<xsl:otherwise>
						<xsl:value-of select="$AnzahlFeldgruppenFremdString"/>
					</xsl:otherwise>
				</xsl:choose>
			</xsl:variable>
			<xsl:variable name="AnzahlFeldgruppenStatus2String">
				<xsl:for-each-group select="//xdf3:datenfeldgruppe[xdf3:freigabestatus/code/text() = '2']" group-by="concat(xdf3:identifikation/xdf3:id,xdf3:identifikation/xdf3:version)">
					<xsl:if test="fn:position() = 1">
						<xsl:value-of select="fn:last()"/>
					</xsl:if>
				</xsl:for-each-group>
			</xsl:variable>
			<xsl:variable name="AnzahlFeldgruppenStatus2">
				<xsl:choose>
					<xsl:when test="empty($AnzahlFeldgruppenStatus2String/text())">0</xsl:when>
					<xsl:otherwise>
						<xsl:value-of select="$AnzahlFeldgruppenStatus2String"/>
					</xsl:otherwise>
				</xsl:choose>
			</xsl:variable>
			<xsl:variable name="AnzahlFeldgruppenStatus3String">
				<xsl:for-each-group select="//xdf3:datenfeldgruppe[xdf3:freigabestatus/code/text() = '3']" group-by="concat(xdf3:identifikation/xdf3:id,xdf3:identifikation/xdf3:version)">
					<xsl:if test="fn:position() = 1">
						<xsl:value-of select="fn:last()"/>
					</xsl:if>
				</xsl:for-each-group>
			</xsl:variable>
			<xsl:variable name="AnzahlFeldgruppenStatus3">
				<xsl:choose>
					<xsl:when test="empty($AnzahlFeldgruppenStatus3String/text())">0</xsl:when>
					<xsl:otherwise>
						<xsl:value-of select="$AnzahlFeldgruppenStatus3String"/>
					</xsl:otherwise>
				</xsl:choose>
			</xsl:variable>
			<xsl:variable name="AnzahlFeldgruppenStatus4String">
				<xsl:for-each-group select="//xdf3:datenfeldgruppe[xdf3:freigabestatus/code/text() = '3']" group-by="concat(xdf3:identifikation/xdf3:id,xdf3:identifikation/xdf3:version)">
					<xsl:if test="fn:position() = 1">
						<xsl:value-of select="fn:last()"/>
					</xsl:if>
				</xsl:for-each-group>
			</xsl:variable>
			<xsl:variable name="AnzahlFeldgruppenStatus4">
				<xsl:choose>
					<xsl:when test="empty($AnzahlFeldgruppenStatus4String/text())">0</xsl:when>
					<xsl:otherwise>
						<xsl:value-of select="$AnzahlFeldgruppenStatus4String"/>
					</xsl:otherwise>
				</xsl:choose>
			</xsl:variable>
			<xsl:variable name="AnzahlFeldgruppenStatus5String">
				<xsl:for-each-group select="//xdf3:datenfeldgruppe[xdf3:freigabestatus/code/text() = '5']" group-by="concat(xdf3:identifikation/xdf3:id,xdf3:identifikation/xdf3:version)">
					<xsl:if test="fn:position() = 1">
						<xsl:value-of select="fn:last()"/>
					</xsl:if>
				</xsl:for-each-group>
			</xsl:variable>
			<xsl:variable name="AnzahlFeldgruppenStatus5">
				<xsl:choose>
					<xsl:when test="empty($AnzahlFeldgruppenStatus5String/text())">0</xsl:when>
					<xsl:otherwise>
						<xsl:value-of select="$AnzahlFeldgruppenStatus5String"/>
					</xsl:otherwise>
				</xsl:choose>
			</xsl:variable>
			<xsl:variable name="AnzahlFeldgruppenStatus6String">
				<xsl:for-each-group select="//xdf3:datenfeldgruppe[xdf3:freigabestatus/code/text() = '6']" group-by="concat(xdf3:identifikation/xdf3:id,xdf3:identifikation/xdf3:version)">
					<xsl:if test="fn:position() = 1">
						<xsl:value-of select="fn:last()"/>
					</xsl:if>
				</xsl:for-each-group>
			</xsl:variable>
			<xsl:variable name="AnzahlFeldgruppenStatus6">
				<xsl:choose>
					<xsl:when test="empty($AnzahlFeldgruppenStatus6String/text())">0</xsl:when>
					<xsl:otherwise>
						<xsl:value-of select="$AnzahlFeldgruppenStatus6String"/>
					</xsl:otherwise>
				</xsl:choose>
			</xsl:variable>
			<xsl:variable name="AnzahlFeldgruppenStatus7String">
				<xsl:for-each-group select="//xdf3:datenfeldgruppe[xdf3:freigabestatus/code/text() = '7']" group-by="concat(xdf3:identifikation/xdf3:id,xdf3:identifikation/xdf3:version)">
					<xsl:if test="fn:position() = 1">
						<xsl:value-of select="fn:last()"/>
					</xsl:if>
				</xsl:for-each-group>
			</xsl:variable>
			<xsl:variable name="AnzahlFeldgruppenStatus7">
				<xsl:choose>
					<xsl:when test="empty($AnzahlFeldgruppenStatus7String/text())">0</xsl:when>
					<xsl:otherwise>
						<xsl:value-of select="$AnzahlFeldgruppenStatus7String"/>
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
			<xsl:variable name="AnzahlFelderBOBString">
				<xsl:for-each-group select="//xdf3:datenfeld[fn:substring(xdf3:identifikation/xdf3:id/text(),2,2) = '60']" group-by="concat(xdf3:identifikation/xdf3:id,xdf3:identifikation/xdf3:version)">
					<xsl:if test="fn:position() = 1">
						<xsl:value-of select="fn:last()"/>
					</xsl:if>
				</xsl:for-each-group>
			</xsl:variable>
			<xsl:variable name="AnzahlFelderBOB">
				<xsl:choose>
					<xsl:when test="empty($AnzahlFelderBOBString/text())">0</xsl:when>
					<xsl:otherwise>
						<xsl:value-of select="$AnzahlFelderBOBString"/>
					</xsl:otherwise>
				</xsl:choose>
			</xsl:variable>
			<xsl:variable name="AnzahlFelderHeimString">
				<xsl:for-each-group select="//xdf3:datenfeld[fn:substring(xdf3:identifikation/xdf3:id/text(),2,2) = $HeimNummernkreis]" group-by="concat(xdf3:identifikation/xdf3:id,xdf3:identifikation/xdf3:version)">
					<xsl:if test="fn:position() = 1">
						<xsl:value-of select="fn:last()"/>
					</xsl:if>
				</xsl:for-each-group>
			</xsl:variable>
			<xsl:variable name="AnzahlFelderHeim">
				<xsl:choose>
					<xsl:when test="empty($AnzahlFelderHeimString/text())">0</xsl:when>
					<xsl:otherwise>
						<xsl:value-of select="$AnzahlFelderHeimString"/>
					</xsl:otherwise>
				</xsl:choose>
			</xsl:variable>
			<xsl:variable name="AnzahlFelderFremdString">
				<xsl:for-each-group select="//xdf3:datenfeld[fn:substring(xdf3:identifikation/xdf3:id/text(),2,2) != $HeimNummernkreis and fn:substring(xdf3:identifikation/xdf3:id/text(),2,2) != '60']" group-by="concat(xdf3:identifikation/xdf3:id,xdf3:identifikation/xdf3:version)">
					<xsl:if test="fn:position() = 1">
						<xsl:value-of select="fn:last()"/>
					</xsl:if>
				</xsl:for-each-group>
			</xsl:variable>
			<xsl:variable name="AnzahlFelderFremd">
				<xsl:choose>
					<xsl:when test="empty($AnzahlFelderFremdString/text())">0</xsl:when>
					<xsl:otherwise>
						<xsl:value-of select="$AnzahlFelderFremdString"/>
					</xsl:otherwise>
				</xsl:choose>
			</xsl:variable>
			<xsl:variable name="AnzahlFelderStatus2String">
				<xsl:for-each-group select="//xdf3:datenfeld[xdf3:freigabestatus/code/text() = '2']" group-by="concat(xdf3:identifikation/xdf3:id,xdf3:identifikation/xdf3:version)">
					<xsl:if test="fn:position() = 1">
						<xsl:value-of select="fn:last()"/>
					</xsl:if>
				</xsl:for-each-group>
			</xsl:variable>
			<xsl:variable name="AnzahlFelderStatus2">
				<xsl:choose>
					<xsl:when test="empty($AnzahlFelderStatus2String/text())">0</xsl:when>
					<xsl:otherwise>
						<xsl:value-of select="$AnzahlFelderStatus2String"/>
					</xsl:otherwise>
				</xsl:choose>
			</xsl:variable>
			<xsl:variable name="AnzahlFelderStatus3String">
				<xsl:for-each-group select="//xdf3:datenfeld[xdf3:freigabestatus/code/text() = '3']" group-by="concat(xdf3:identifikation/xdf3:id,xdf3:identifikation/xdf3:version)">
					<xsl:if test="fn:position() = 1">
						<xsl:value-of select="fn:last()"/>
					</xsl:if>
				</xsl:for-each-group>
			</xsl:variable>
			<xsl:variable name="AnzahlFelderStatus3">
				<xsl:choose>
					<xsl:when test="empty($AnzahlFelderStatus3String/text())">0</xsl:when>
					<xsl:otherwise>
						<xsl:value-of select="$AnzahlFelderStatus3String"/>
					</xsl:otherwise>
				</xsl:choose>
			</xsl:variable>
			<xsl:variable name="AnzahlFelderStatus4String">
				<xsl:for-each-group select="//xdf3:datenfeld[xdf3:freigabestatus/code/text() = '4']" group-by="concat(xdf3:identifikation/xdf3:id,xdf3:identifikation/xdf3:version)">
					<xsl:if test="fn:position() = 1">
						<xsl:value-of select="fn:last()"/>
					</xsl:if>
				</xsl:for-each-group>
			</xsl:variable>
			<xsl:variable name="AnzahlFelderStatus4">
				<xsl:choose>
					<xsl:when test="empty($AnzahlFelderStatus4String/text())">0</xsl:when>
					<xsl:otherwise>
						<xsl:value-of select="$AnzahlFelderStatus4String"/>
					</xsl:otherwise>
				</xsl:choose>
			</xsl:variable>
			<xsl:variable name="AnzahlFelderStatus5String">
				<xsl:for-each-group select="//xdf3:datenfeld[xdf3:freigabestatus/code/text() = '5']" group-by="concat(xdf3:identifikation/xdf3:id,xdf3:identifikation/xdf3:version)">
					<xsl:if test="fn:position() = 1">
						<xsl:value-of select="fn:last()"/>
					</xsl:if>
				</xsl:for-each-group>
			</xsl:variable>
			<xsl:variable name="AnzahlFelderStatus5">
				<xsl:choose>
					<xsl:when test="empty($AnzahlFelderStatus5String/text())">0</xsl:when>
					<xsl:otherwise>
						<xsl:value-of select="$AnzahlFelderStatus5String"/>
					</xsl:otherwise>
				</xsl:choose>
			</xsl:variable>
			<xsl:variable name="AnzahlFelderStatus6String">
				<xsl:for-each-group select="//xdf3:datenfeld[xdf3:freigabestatus/code/text() = '6']" group-by="concat(xdf3:identifikation/xdf3:id,xdf3:identifikation/xdf3:version)">
					<xsl:if test="fn:position() = 1">
						<xsl:value-of select="fn:last()"/>
					</xsl:if>
				</xsl:for-each-group>
			</xsl:variable>
			<xsl:variable name="AnzahlFelderStatus6">
				<xsl:choose>
					<xsl:when test="empty($AnzahlFelderStatus6String/text())">0</xsl:when>
					<xsl:otherwise>
						<xsl:value-of select="$AnzahlFelderStatus6String"/>
					</xsl:otherwise>
				</xsl:choose>
			</xsl:variable>
			<xsl:variable name="AnzahlFelderStatus7String">
				<xsl:for-each-group select="//xdf3:datenfeld[xdf3:freigabestatus/code/text() = '7']" group-by="concat(xdf3:identifikation/xdf3:id,xdf3:identifikation/xdf3:version)">
					<xsl:if test="fn:position() = 1">
						<xsl:value-of select="fn:last()"/>
					</xsl:if>
				</xsl:for-each-group>
			</xsl:variable>
			<xsl:variable name="AnzahlFelderStatus7">
				<xsl:choose>
					<xsl:when test="empty($AnzahlFelderStatus7String/text())">0</xsl:when>
					<xsl:otherwise>
						<xsl:value-of select="$AnzahlFelderStatus7String"/>
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
			<xsl:variable name="AnzahlWertelistenString">
				<xsl:for-each-group select="//xdf3:datenfeld[xdf3:werte]" group-by="concat(xdf3:identifikation/xdf3:id,xdf3:identifikation/xdf3:version)">
					<xsl:if test="fn:position() = 1">
						<xsl:value-of select="fn:last()"/>
					</xsl:if>
				</xsl:for-each-group>
			</xsl:variable>
			<xsl:variable name="AnzahlWertelisten">
				<xsl:choose>
					<xsl:when test="empty($AnzahlWertelistenString/text())">0</xsl:when>
					<xsl:otherwise>
						<xsl:value-of select="$AnzahlWertelistenString"/>
					</xsl:otherwise>
				</xsl:choose>
			</xsl:variable>
			<h4><br/>Baukastenelemente</h4>
			<table style="page-break-after:always">
				<thead>
					<tr>
						<th></th>
						<th>Datenfelder</th>
						<th>Datenfeldgruppe</th>
						<th><b>Baukastenelemente gesamt</b></th>
					</tr>
				</thead>
				<tbody>
					<tr>
						<td><b>alle</b></td>
						<td><b><xsl:value-of select="$AnzahlFelder"/></b></td>
						<td><b><xsl:value-of select="$AnzahlFeldgruppen"/></b></td>
						<td><b><xsl:value-of select="$AnzahlFelder + $AnzahlFeldgruppen"/></b></td>
					</tr>
					<tr>
						<td colspan="4">&#160;</td>
					</tr>
					<tr>
						<td>&#160;&#160;abstrakt</td>
						<td><xsl:value-of select="$AnzahlFelderAbstrakt"/></td>
						<td><xsl:value-of select="$AnzahlFeldgruppenAbstrakt"/></td>
						<td><xsl:value-of select="$AnzahlFelderAbstrakt + $AnzahlFeldgruppenAbstrakt"/></td>
					</tr>
					<tr>
						<td>&#160;&#160;harmonisiert</td>
						<td><xsl:value-of select="$AnzahlFelderHarmonisiert"/></td>
						<td><xsl:value-of select="$AnzahlFeldgruppenHarmonisiert"/></td>
						<td><xsl:value-of select="$AnzahlFelderHarmonisiert + $AnzahlFeldgruppenHarmonisiert"/></td>
					</tr>
					<tr>
						<td>&#160;&#160;rechtsnormgebunden</td>
						<td><xsl:value-of select="$AnzahlFelderRechtsnormgebunden"/></td>
						<td><xsl:value-of select="$AnzahlFeldgruppenRechtsnormgebunden"/></td>
						<td><xsl:value-of select="$AnzahlFelderRechtsnormgebunden + $AnzahlFeldgruppenRechtsnormgebunden"/></td>
					</tr>
					<tr>
						<td colspan="4">&#160;</td>
					</tr>
					<tr>
						<td>&#160;&#160;in Bearbeitung</td>
						<td><xsl:value-of select="$AnzahlFelderStatus2"/></td>
						<td><xsl:value-of select="$AnzahlFeldgruppenStatus2"/></td>
						<td><xsl:value-of select="$AnzahlFelderStatus2 + $AnzahlFeldgruppenStatus2"/></td>
					</tr>
					<tr>
						<td>&#160;&#160;Entwurf</td>
						<td><xsl:value-of select="$AnzahlFelderStatus3"/></td>
						<td><xsl:value-of select="$AnzahlFeldgruppenStatus3"/></td>
						<td><xsl:value-of select="$AnzahlFelderStatus3 + $AnzahlFeldgruppenStatus3"/></td>
					</tr>
					<tr>
						<td>&#160;&#160;methodisch freigegeben</td>
						<td><xsl:value-of select="$AnzahlFelderStatus4"/></td>
						<td><xsl:value-of select="$AnzahlFeldgruppenStatus4"/></td>
						<td><xsl:value-of select="$AnzahlFelderStatus4 + $AnzahlFeldgruppenStatus4"/></td>
					</tr>
					<tr>
						<td>&#160;&#160;fachlich freigegeben (silber)</td>
						<td><xsl:value-of select="$AnzahlFelderStatus5"/></td>
						<td><xsl:value-of select="$AnzahlFeldgruppenStatus5"/></td>
						<td><xsl:value-of select="$AnzahlFelderStatus5 + $AnzahlFeldgruppenStatus5"/></td>
					</tr>
					<tr>
						<td>&#160;&#160;fachlich freigegeben (gold)</td>
						<td><xsl:value-of select="$AnzahlFelderStatus6"/></td>
						<td><xsl:value-of select="$AnzahlFeldgruppenStatus6"/></td>
						<td><xsl:value-of select="$AnzahlFelderStatus6 + $AnzahlFeldgruppenStatus6"/></td>
					</tr>
					<tr>
						<td>&#160;&#160;inaktiv</td>
						<td><xsl:value-of select="$AnzahlFelderStatus7"/></td>
						<td><xsl:value-of select="$AnzahlFeldgruppenStatus7"/></td>
						<td><xsl:value-of select="$AnzahlFelderStatus7 + $AnzahlFeldgruppenStatus7"/></td>
					</tr>
					<tr>
						<td colspan="4">&#160;</td>
					</tr>
					<tr>
						<td>&#160;&#160;aus eigenem Nummernkreis</td>
						<td><xsl:value-of select="$AnzahlFelderHeim"/></td>
						<td><xsl:value-of select="$AnzahlFeldgruppenHeim"/></td>
						<td><xsl:value-of select="$AnzahlFelderHeim + $AnzahlFeldgruppenHeim"/></td>
					</tr>
					<tr>
						<td>&#160;&#160;aus BOB</td>
						<td><xsl:value-of select="$AnzahlFelderBOB"/></td>
						<td><xsl:value-of select="$AnzahlFeldgruppenBOB"/></td>
						<td><xsl:value-of select="$AnzahlFelderBOB + $AnzahlFeldgruppenBOB"/></td>
					</tr>
					<tr>
						<td>&#160;&#160;aus weiteren Nummernkreisen</td>
						<td><xsl:value-of select="$AnzahlFelderFremd"/></td>
						<td><xsl:value-of select="$AnzahlFeldgruppenFremd"/></td>
						<td><xsl:value-of select="$AnzahlFelderFremd + $AnzahlFeldgruppenFremd"/></td>
					</tr>
					<tr>
						<td colspan="4">&#160;</td>
					</tr>
					<tr>
						<td>Anteil harmonisierter Baukastenelemente</td>
						<td colspan="3">
							<xsl:value-of select="format-number((fn:number($AnzahlFelderHarmonisiert) + fn:number($AnzahlFeldgruppenHarmonisiert)) div (fn:number($AnzahlFeldgruppen) + fn:number($AnzahlFelder)),'#.## %')"/>
						</td>
					</tr>
					<tr>
						<td>Anteil BOB-Baukastenelemente</td>
						<td colspan="3">
							<xsl:value-of select="format-number((fn:number($AnzahlFelderBOB) + fn:number($AnzahlFeldgruppenBOB)) div (fn:number($AnzahlFeldgruppen) + fn:number($AnzahlFelder)),'#.## %')"/>
						</td>
					</tr>
				</tbody>
			</table>
			<h4><br/>Regeln</h4>
			<table style="page-break-after:always">
				<tbody>
					<tr>
						<td>Anzahl Regeln</td>
						<td>
							<xsl:value-of select="$AnzahlRegeln"/>
						</td>
					</tr>
				</tbody>
			</table>
			<h4><br/>Werte- und Codelisten</h4>
			<table style="page-break-after:always">
				<tbody>
					<tr>
						<td>Anzahl unterschiedlicher Codelisten</td>
						<td>
							<xsl:value-of select="$AnzahlCodelisten"/>
						</td>
					</tr>
					<tr>
						<td>Anzahl Wertelisten</td>
						<td>
							<xsl:value-of select="$AnzahlWertelisten"/>
						</td>
					</tr>
				</tbody>
			</table>
			<table style="page-break-after:always" width="100%">
				<tbody>
					<tr style="page-break-after:always">
						<td class="Navigation" style="background: #FFFFFF;">
							<xsl:call-template name="navigationszeile"/>
						</td>
					</tr>
				</tbody>
			</table>
		</xsl:if>
		<xsl:if test="$StatistikVerwendung = '1'">
			<xsl:if test="$DebugMode = '2' or $DebugMode = '3' or $DebugMode = '4'">
				<xsl:message>
					++++++++ StatistikVerwendung ++++++++
				</xsl:message>
			</xsl:if>
			<xsl:choose>
				<xsl:when test="$Navigation = '2'">
					<h3>
						<a name="StatistikVerwendung"/>Verwendung von Baukastenelementen&#160;<a href="#Statistik" title="nach oben">&#8593;</a>
						<br/>
					</h3>
				</xsl:when>
				<xsl:otherwise>
					<h3>
						<a name="StatistikVerwendung"/>Verwendung von Baukastenelementen<br/>
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
				</tbody>
			</table>
			<table style="page-break-after:always" width="100%">
				<tbody>
					<tr style="page-break-after:always">
						<td class="Navigation" style="background: #FFFFFF;">
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
				<xsl:when test="$Navigation = '2'">
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
						<xsl:sort select="./xdf3:name" lang="de"/>
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
			<table style="page-break-after:always" width="100%">
				<tbody>
					<tr style="page-break-after:always">
						<td class="Navigation" style="background: #FFFFFF;">
							<xsl:call-template name="navigationszeile"/>
						</td>
					</tr>
				</tbody>
			</table>
			<xsl:choose>
				<xsl:when test="$Navigation = '2'">
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
						<xsl:sort select="./xdf3:name" lang="de"/>
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
			<table style="page-break-after:always" width="100%">
				<tbody>
					<tr style="page-break-after:always">
						<td class="Navigation" style="background: #FFFFFF;">
							<xsl:call-template name="navigationszeile"/>
						</td>
					</tr>
				</tbody>
			</table>
			<xsl:choose>
				<xsl:when test="$Navigation = '2'">
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
						<xsl:sort select="./xdf3:name" lang="de"/>
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
			<table style="page-break-after:always" width="100%">
				<tbody>
					<tr style="page-break-after:always">
						<td class="Navigation" style="background: #FFFFFF;">
							<xsl:call-template name="navigationszeile"/>
						</td>
					</tr>
				</tbody>
			</table>
		</xsl:if>
		<xsl:if test="$StatistikStatus = '1'">
			<xsl:if test="$DebugMode = '2' or $DebugMode = '3' or $DebugMode = '4'">
				<xsl:message>
					++++++++ StatistikStatus ++++++++
				</xsl:message>
			</xsl:if>
			<h3>
				<a name="StatistikStatus"/>Baukastenelemente nach Status<br/>
			</h3>
			<xsl:choose>
				<xsl:when test="$Navigation = '2'">
					<h4>
						<br/>
						<a name="StatistikStatus2"/>Status <i>in Bearbeitung</i>&#160;<a href="#Statistik" title="nach oben">&#8593;</a>
						<br/>
					</h4>
				</xsl:when>
				<xsl:otherwise>
					<h4>
						<br/>
						<a name="StatistikStatus2"/>Status <i>in Bearbeitung</i><br/>
					</h4>
				</xsl:otherwise>
			</xsl:choose>
			<table style="page-break-after:always">
				<thead>
					<tr>
						<th>ID</th>
						<th>Version</th>
						<th>Name</th>
						<th>Status</th>
					</tr>
				</thead>
				<tbody>
					<xsl:for-each-group select="//xdf3:datenfeldgruppe[xdf3:freigabestatus/code/text() = '2'] | //xdf3:datenfeld[xdf3:freigabestatus/code/text() = '2']" group-by="xdf3:identifikation/xdf3:id">
						<xsl:sort select="./xdf3:name" lang="de"/>
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
									in Bearbeitung
								</td>
							</tr>
						</xsl:for-each-group>
					</xsl:for-each-group>
				</tbody>
			</table>
			<table style="page-break-after:always" width="100%">
				<tbody>
					<tr style="page-break-after:always">
						<td class="Navigation" style="background: #FFFFFF;">
							<xsl:call-template name="navigationszeile"/>
						</td>
					</tr>
				</tbody>
			</table>
			<xsl:choose>
				<xsl:when test="$Navigation = '2'">
					<h4>
						<br/>
						<a name="StatistikStatus3"/>Status <i>Entwurf</i>&#160;<a href="#Statistik" title="nach oben">&#8593;</a>
						<br/>
					</h4>
				</xsl:when>
				<xsl:otherwise>
					<h4>
						<br/>
						<a name="StatistikStatus3"/>Status <i>Entwurf</i><br/>
					</h4>
				</xsl:otherwise>
			</xsl:choose>
			<table style="page-break-after:always">
				<thead>
					<tr>
						<th>ID</th>
						<th>Version</th>
						<th>Name</th>
						<th>Status</th>
					</tr>
				</thead>
				<tbody>
					<xsl:for-each-group select="//xdf3:datenfeldgruppe[xdf3:freigabestatus/code/text() = '3'] | //xdf3:datenfeld[xdf3:freigabestatus/code/text() = '3']" group-by="xdf3:identifikation/xdf3:id">
						<xsl:sort select="./xdf3:name" lang="de"/>
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
									Entwurf
								</td>
							</tr>
						</xsl:for-each-group>
					</xsl:for-each-group>
				</tbody>
			</table>
			<table style="page-break-after:always" width="100%">
				<tbody>
					<tr style="page-break-after:always">
						<td class="Navigation" style="background: #FFFFFF;">
							<xsl:call-template name="navigationszeile"/>
						</td>
					</tr>
				</tbody>
			</table>
			<xsl:choose>
				<xsl:when test="$Navigation = '2'">
					<h4>
						<br/>
						<a name="StatistikStatus4"/>Status <i>methodisch freigegeben</i>&#160;<a href="#Statistik" title="nach oben">&#8593;</a>
						<br/>
					</h4>
				</xsl:when>
				<xsl:otherwise>
					<h4>
						<br/>
						<a name="StatistikStatus4"/>Status <i>methodisch freigegeben</i><br/>
					</h4>
				</xsl:otherwise>
			</xsl:choose>
			<table style="page-break-after:always">
				<thead>
					<tr>
						<th>ID</th>
						<th>Version</th>
						<th>Name</th>
						<th>Status</th>
					</tr>
				</thead>
				<tbody>
					<xsl:for-each-group select="//xdf3:datenfeldgruppe[xdf3:freigabestatus/code/text() = '4'] | //xdf3:datenfeld[xdf3:freigabestatus/code/text() = '4']" group-by="xdf3:identifikation/xdf3:id">
						<xsl:sort select="./xdf3:name" lang="de"/>
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
									methodisch freigegeben
								</td>
							</tr>
						</xsl:for-each-group>
					</xsl:for-each-group>
				</tbody>
			</table>
			<table style="page-break-after:always" width="100%">
				<tbody>
					<tr style="page-break-after:always">
						<td class="Navigation" style="background: #FFFFFF;">
							<xsl:call-template name="navigationszeile"/>
						</td>
					</tr>
				</tbody>
			</table>
			<xsl:choose>
				<xsl:when test="$Navigation = '2'">
					<h4>
						<br/>
						<a name="StatistikStatus5"/>Status <i>fachlich freigegeben (silber)</i>&#160;<a href="#Statistik" title="nach oben">&#8593;</a>
						<br/>
					</h4>
				</xsl:when>
				<xsl:otherwise>
					<h4>
						<br/>
						<a name="StatistikStatus5"/>Status <i>fachlich freigegeben (silber)</i><br/>
					</h4>
				</xsl:otherwise>
			</xsl:choose>
			<table style="page-break-after:always">
				<thead>
					<tr>
						<th>ID</th>
						<th>Version</th>
						<th>Name</th>
						<th>Status</th>
					</tr>
				</thead>
				<tbody>
					<xsl:for-each-group select="//xdf3:datenfeldgruppe[xdf3:freigabestatus/code/text() = '5'] | //xdf3:datenfeld[xdf3:freigabestatus/code/text() = '5']" group-by="xdf3:identifikation/xdf3:id">
						<xsl:sort select="./xdf3:name" lang="de"/>
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
									fachlich freigegeben (silber)
								</td>
							</tr>
						</xsl:for-each-group>
					</xsl:for-each-group>
				</tbody>
			</table>
			<table style="page-break-after:always" width="100%">
				<tbody>
					<tr style="page-break-after:always">
						<td class="Navigation" style="background: #FFFFFF;">
							<xsl:call-template name="navigationszeile"/>
						</td>
					</tr>
				</tbody>
			</table>
			<xsl:choose>
				<xsl:when test="$Navigation = '2'">
					<h4>
						<br/>
						<a name="StatistikStatus6"/>Status <i>fachlich freigegeben (gold)</i>&#160;<a href="#Statistik" title="nach oben">&#8593;</a>
						<br/>
					</h4>
				</xsl:when>
				<xsl:otherwise>
					<h4>
						<br/>
						<a name="StatistikStatus6"/>Status <i>fachlich freigegeben (gold)</i><br/>
					</h4>
				</xsl:otherwise>
			</xsl:choose>
			<table style="page-break-after:always">
				<thead>
					<tr>
						<th>ID</th>
						<th>Version</th>
						<th>Name</th>
						<th>Status</th>
					</tr>
				</thead>
				<tbody>
					<xsl:for-each-group select="//xdf3:datenfeldgruppe[xdf3:freigabestatus/code/text() = '6'] | //xdf3:datenfeld[xdf3:freigabestatus/code/text() = '6']" group-by="xdf3:identifikation/xdf3:id">
						<xsl:sort select="./xdf3:name" lang="de"/>
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
									fachlich freigegeben (gold)
								</td>
							</tr>
						</xsl:for-each-group>
					</xsl:for-each-group>
				</tbody>
			</table>
			<table style="page-break-after:always" width="100%">
				<tbody>
					<tr style="page-break-after:always">
						<td class="Navigation" style="background: #FFFFFF;">
							<xsl:call-template name="navigationszeile"/>
						</td>
					</tr>
				</tbody>
			</table>
			<xsl:choose>
				<xsl:when test="$Navigation = '2'">
					<h4>
						<br/>
						<a name="StatistikStatus7"/>Status <i>inaktiv</i>&#160;<a href="#Statistik" title="nach oben">&#8593;</a>
						<br/>
					</h4>
				</xsl:when>
				<xsl:otherwise>
					<h4>
						<br/>
						<a name="StatistikStatus7"/>Status <i>inaktiv</i><br/>
					</h4>
				</xsl:otherwise>
			</xsl:choose>
			<table style="page-break-after:always">
				<thead>
					<tr>
						<th>ID</th>
						<th>Version</th>
						<th>Name</th>
						<th>Status</th>
					</tr>
				</thead>
				<tbody>
					<xsl:for-each-group select="//xdf3:datenfeldgruppe[xdf3:freigabestatus/code/text() = '7'] | //xdf3:datenfeld[xdf3:freigabestatus/code/text() = '7']" group-by="xdf3:identifikation/xdf3:id">
						<xsl:sort select="./xdf3:name" lang="de"/>
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
									inaktiv
								</td>
							</tr>
						</xsl:for-each-group>
					</xsl:for-each-group>
				</tbody>
			</table>
			<table style="page-break-after:always" width="100%">
				<tbody>
					<tr style="page-break-after:always">
						<td class="Navigation" style="background: #FFFFFF;">
							<xsl:call-template name="navigationszeile"/>
						</td>
					</tr>
				</tbody>
			</table>
		</xsl:if>
		<xsl:if test="$StatistikHandlungsgrundlage = '1'">
			<xsl:if test="$DebugMode = '2' or $DebugMode = '3' or $DebugMode = '4'">
				<xsl:message>
					++++++++ StatistikHandlungsgrundlage ++++++++
				</xsl:message>
			</xsl:if>
			<xsl:choose>
				<xsl:when test="$Navigation = '2'">
					<h3>
						<a name="StatistikHandlungsgrundlage"/>Baukastenelemente nach Nummernkreis und Handlungsgrundlage<a href="#Statistik" title="nach oben">&#8593;</a>
						<br/>
					</h3>
				</xsl:when>
				<xsl:otherwise>
					<h3>
						<a name="StatistikHandlungsgrundlage"/>Baukastenelemente nach Nummernkreis und Handlungsgrundlage<br/>
					</h3>
				</xsl:otherwise>
			</xsl:choose>

			<xsl:variable name="BezugsListe">
				<BezugsListe>
					<xsl:for-each select="//xdf3:bezug">
						<xsl:sort select="."/>
	
						<zeile>
							<xsl:choose>
								<xsl:when test="../xdf3:identifikation/xdf3:id">
									<id><xsl:value-of select="../xdf3:identifikation/xdf3:id"/></id>
									<version><xsl:value-of select="../xdf3:identifikation/xdf3:version"/></version>
									<name><xsl:value-of select="../xdf3:name"/></name>
								</xsl:when>
								<xsl:otherwise>
									<id><xsl:value-of select="../xdf3:enthaelt/*/xdf3:identifikation/xdf3:id"/></id>
									<version><xsl:value-of select="../xdf3:enthaelt/*/xdf3:identifikation/xdf3:version"/></version>
									<name><xsl:value-of select="../xdf3:enthaelt/*/xdf3:name"/></name>
								</xsl:otherwise>
							</xsl:choose>
							<bezug><xsl:value-of select="./text()"/></bezug>
							<link><xsl:value-of select="./@link"/></link>
							<xsl:choose>
								<xsl:when test="../xdf3:identifikation/xdf3:id">
									<typ>element</typ>
								</xsl:when>
								<xsl:otherwise>
									<typ>verwendung</typ>
								</xsl:otherwise>
							</xsl:choose>
						</zeile>
					</xsl:for-each>
				</BezugsListe>
			</xsl:variable>

			<xsl:for-each-group select="$BezugsListe//*/*:zeile" group-by="fn:substring(./*:id,2,2)">
				<xsl:sort select="fn:substring(./*:id,2,2)"/>
				<h4>
					<br/>
										Nummernkreis <i>
						<xsl:value-of select="fn:substring(./*:id,2,2)"/>
					</i>
					<br/>
				</h4>
				<table style="page-break-after:always">
					<thead>
						<tr>
							<th>ID</th>
							<th>Version</th>
							<th>Name</th>
							<th>Handlungsgrundlage</th>
						</tr>
					</thead>
					<tbody>
						<xsl:for-each-group select="fn:current-group()" group-by="./*:bezug">
							<xsl:sort select="./*:bezug"/>

							<xsl:for-each-group select="fn:current-group()" group-by="./*:id">
								<xsl:sort select="./*:id"/>

								<xsl:for-each-group select="fn:current-group()" group-by="string(./*:version)">
									<xsl:sort select="./*:version"/>
									<xsl:if test="$DebugMode = '3' or $DebugMode = '4'">
										<xsl:message>
																-------- <xsl:value-of select="./*:id"/>
											<xsl:if test="./*:version">V<xsl:value-of select="./*:version"/>
											</xsl:if> --------
															</xsl:message>
									</xsl:if>
									<tr>
										<td>
											<xsl:choose>
												<xsl:when test="$Statistik = '2' or empty(./*:id)">
													<xsl:value-of select="./*:id"/>
													<xsl:if test="$ToolAufruf = '1'">
																			&#160;&#160;
																			<xsl:element name="a">
															<xsl:attribute name="href"><xsl:value-of select="$ToolPfadPrefix"/><xsl:value-of select="./*:id"/><xsl:if test="./*:version">V<xsl:value-of select="./*:version"/></xsl:if><xsl:value-of select="$ToolPfadPostfix"/></xsl:attribute>
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
																<xsl:attribute name="href">#<xsl:value-of select="./*:id"/><xsl:if test="./*:version">V<xsl:value-of select="./*:version"/></xsl:if></xsl:attribute>
																<xsl:value-of select="./*:id"/>
															</xsl:element>
														</xsl:when>
														<xsl:otherwise>
															<xsl:value-of select="./*:id"/>
														</xsl:otherwise>
													</xsl:choose>
												</xsl:otherwise>
											</xsl:choose>
										</td>
										<td>
											<xsl:value-of select="./*:version"/>
										</td>
										<td>
											<xsl:value-of select="./*:name"/>
										</td>
										<td>
											<xsl:choose>
												<xsl:when test="./*:bezug = 'Bitte Handlungsgrundlage erg�nzen'"><b><xsl:value-of select="./*:bezug"/></b></xsl:when>
												<xsl:otherwise><xsl:value-of select="./*:bezug"/></xsl:otherwise>
											</xsl:choose>
											
										</td>
									</tr>
								</xsl:for-each-group>
							</xsl:for-each-group>
						</xsl:for-each-group>
					</tbody>
				</table>
			</xsl:for-each-group>
			<table style="page-break-after:always" width="100%">
				<tbody>
					<tr style="page-break-after:always">
						<td class="Navigation" style="background: #FFFFFF;">
							<xsl:call-template name="navigationszeile"/>
						</td>
					</tr>
				</tbody>
			</table>
		</xsl:if>
		<xsl:if test="$StatistikIDVersion = '1'">
			<xsl:if test="$DebugMode = '2' or $DebugMode = '3' or $DebugMode = '4'">
				<xsl:message>
					++++++++ StatistikIDVersion ++++++++
				</xsl:message>
			</xsl:if>
			<xsl:choose>
				<xsl:when test="$Navigation = '2'">
					<h3>
						<a name="StatistikIDVersion"/>Baukastenelemente nach Nummernkreis, ID und Version&#160;<a href="#Statistik" title="nach oben">&#8593;</a>
						<br/>
					</h3>
				</xsl:when>
				<xsl:otherwise>
					<h3>
						<a name="StatistikIDVersion"/>Baukastenelemente nach Nummernkreis, ID und Version<br/>
					</h3>
				</xsl:otherwise>
			</xsl:choose>
					<xsl:for-each-group select="//xdf3:datenfeldgruppe | //xdf3:datenfeld" group-by="fn:substring(./xdf3:identifikation/xdf3:id,2,2)">
						<xsl:sort select="fn:substring(./xdf3:identifikation/xdf3:id,2,2)"/>
						<h4>
							<br/>
							Nummernkreis <i><xsl:value-of select="fn:substring(./xdf3:identifikation/xdf3:id,2,2)"/></i><br/>
						</h4>
						<table style="page-break-after:always">
							<thead>
								<tr>
									<th>ID</th>
									<th>Version</th>
									<th>Name</th>
								</tr>
							</thead>
							<tbody>
								<xsl:for-each-group select="fn:current-group()" group-by="xdf3:identifikation/xdf3:id">
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
												<xsl:variable name="EID" select="./xdf3:identifikation/xdf3:id"/>
												<xsl:variable name="EV" select="./xdf3:identifikation/xdf3:version"/>
												<xsl:choose>
													<xsl:when test="//*/xdf3:identifikation[./xdf3:id = $EID and ./xdf3:version != $EV]"><b><xsl:value-of select="./xdf3:identifikation/xdf3:version"/></b></xsl:when>
													<xsl:otherwise><xsl:value-of select="./xdf3:identifikation/xdf3:version"/></xsl:otherwise>
												</xsl:choose>
											</td>
											<td>
												<xsl:value-of select="./xdf3:name"/>
											</td>
										</tr>
									</xsl:for-each-group>
								</xsl:for-each-group>
							</tbody>
						</table>
					</xsl:for-each-group>
			<table style="page-break-after:always" width="100%">
				<tbody>
					<tr style="page-break-after:always">
						<td class="Navigation" style="background: #FFFFFF;">
							<xsl:call-template name="navigationszeile"/>
						</td>
					</tr>
				</tbody>
			</table>
		</xsl:if>
		<xsl:if test="$StatistikAktualitaet = '1'">
			<xsl:if test="$DebugMode = '2' or $DebugMode = '3' or $DebugMode = '4'">
				<xsl:message>
					++++++++ StatistikAktualitaet ++++++++
				</xsl:message>
			</xsl:if>
			<xsl:choose>
				<xsl:when test="$Navigation = '2'">
					<h3>
						<a name="StatistikAktualitaet"/>Baukastenelemente nach Nummernkreis, ID, Version und Aktualit�t&#160;<a href="#Statistik" title="nach oben">&#8593;</a>
						<br/>
					</h3>
				</xsl:when>
				<xsl:otherwise>
					<h3>
						<a name="StatistikAktualitaet"/>Baukastenelemente nach Nummernkreis, ID,Version mit Aktualit�t<br/>
					</h3>
				</xsl:otherwise>
			</xsl:choose>
					<xsl:for-each-group select="//xdf3:datenfeldgruppe | //xdf3:datenfeld" group-by="fn:substring(./xdf3:identifikation/xdf3:id,2,2)">
						<xsl:sort select="fn:substring(./xdf3:identifikation/xdf3:id,2,2)"/>
						<h4>
							<br/>
							Nummernkreis <i><xsl:value-of select="fn:substring(./xdf3:identifikation/xdf3:id,2,2)"/></i><br/>
						</h4>
						<table style="page-break-after:always">
							<thead>
								<tr>
									<th></th>
									<th></th>
									<th colspan="2">Hier verwendet</th>
									<th colspan="2">Aktuelle Version im Sammelrepository</th>
								</tr>
								<tr>
									<th><br/>ID</th>
									<th><br/>Name</th>
									<th>Version</th>
									<th>Status</th>
									<th>Version</th>
									<th>Status</th>
								</tr>
							</thead>
							<tbody>
								<xsl:for-each-group select="fn:current-group()" group-by="xdf3:identifikation/xdf3:id">
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

										<xsl:variable name="URLBE" select="fn:concat($URLFeList,./xdf3:identifikation/xdf3:id,'/latest')"/>
										
										<xsl:if test="$DebugMode = '4'">
											<xsl:message>                                  URLBE:<xsl:value-of select="$URLBE"/></xsl:message>
										</xsl:if>
			
										<xsl:variable name="BEJSON" as="xs:string">
											<xsl:choose>
												<xsl:when test="$SammelrepositoryCheck = '1'">
													<xsl:try>
														<xsl:value-of select="unparsed-text($URLBE)"/>
													
														<xsl:catch>
															<xsl:value-of  select="'not found'"/>
														</xsl:catch>
													</xsl:try>
												</xsl:when>
												<xsl:otherwise>
													<xsl:value-of  select="'not found'"/>
												</xsl:otherwise>
											</xsl:choose>
										</xsl:variable>

										<xsl:variable name="BEXML">
											<xsl:if test="$BEJSON != 'not found'">
												<xsl:copy-of select="json-to-xml($BEJSON)"/>
											</xsl:if>
										</xsl:variable>
		
										<xsl:variable name="BELatestVersion" select="$BEXML/fn:map/*[./@key='fim_version']"/>
										<xsl:variable name="BELatestStatus" select="$BEXML/fn:map/*[./@key='freigabe_status_label']"/>
										
										<xsl:choose>
											<xsl:when test="$BEJSON = 'not found'">
												<xsl:if test="$DebugMode = '4'">
													<xsl:message>                                  Element in Sammelrepository nicht gefunden</xsl:message>
												</xsl:if>
											</xsl:when>
											<xsl:otherwise>
												
											</xsl:otherwise>
										</xsl:choose>

										<xsl:variable name="istAktueller">
											<xsl:call-template name="aktuellereversion">
												<xsl:with-param name="ElementVersion" select="./xdf3:identifikation/xdf3:version"/>
												<xsl:with-param name="VergleichsVersion" select="$BELatestVersion"/>
											</xsl:call-template>
										</xsl:variable>
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
												<xsl:value-of select="./xdf3:name"/>
											</td>
											<td>
												<xsl:choose>
													<xsl:when test="$istAktueller = 'true'"><b><xsl:value-of select="./xdf3:identifikation/xdf3:version"/></b></xsl:when>
													<xsl:otherwise><xsl:value-of select="./xdf3:identifikation/xdf3:version"/></xsl:otherwise>
												</xsl:choose>
											</td>
											<td>
												<xsl:apply-templates select="./xdf3:freigabestatus"/>
											</td>
											<td>
												<xsl:choose>
													<xsl:when test="$istAktueller = 'true'"><b><xsl:value-of select="$BELatestVersion"/></b></xsl:when>
													<xsl:otherwise><xsl:value-of select="$BELatestVersion"/></xsl:otherwise>
												</xsl:choose>
											</td>
											<td>
												<xsl:apply-templates select="$BELatestStatus"/>
											</td>
										</tr>
									</xsl:for-each-group>
								</xsl:for-each-group>
							</tbody>
						</table>
					</xsl:for-each-group>
			<table style="page-break-after:always" width="100%">
				<tbody>
					<tr style="page-break-after:always">
						<td class="Navigation" style="background: #FFFFFF;">
							<xsl:call-template name="navigationszeile"/>
						</td>
					</tr>
				</tbody>
			</table>
		</xsl:if>
		<xsl:if test="$StatistikFachlicherErsteller = '1'">
			<xsl:if test="$DebugMode = '2' or $DebugMode = '3' or $DebugMode = '4'">
				<xsl:message>
					++++++++ StatistikFachlicherErsteller ++++++++
				</xsl:message>
			</xsl:if>
			<xsl:choose>
				<xsl:when test="$Navigation = '2'">
					<h3>
						<a name="StatistikFachlicherErsteller"/>Baukastenelemente nach Fachlichem Ersteller&#160;<a href="#Statistik" title="nach oben">&#8593;</a>
						<br/>
					</h3>
				</xsl:when>
				<xsl:otherwise>
					<h3>
						<a name="StatistikFachlicherErsteller"/>Baukastenelemente nach Fachlichem Ersteller<br/>
					</h3>
				</xsl:otherwise>
			</xsl:choose>
			<table style="page-break-after:always">
				<thead>
					<tr>
						<th>ID</th>
						<th>Version</th>
						<th>Name</th>
						<th>Fachlicher Ersteller</th>
					</tr>
				</thead>
				<tbody>
					<xsl:for-each-group select="//xdf3:datenfeldgruppe | //xdf3:datenfeld" group-by="xdf3:identifikation/xdf3:id">
						<xsl:sort select="./xdf3:statusGesetztDurch" lang="de"/>
						<xsl:sort select="./xdf3:name" lang="de"/>
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
								<td>
									<xsl:value-of select="./xdf3:statusGesetztDurch"/>
								</td>
							</tr>
						</xsl:for-each-group>
					</xsl:for-each-group>
				</tbody>
			</table>
			<table style="page-break-after:always" width="100%">
				<tbody>
					<tr style="page-break-after:always">
						<td class="Navigation" style="background: #FFFFFF;">
							<xsl:call-template name="navigationszeile"/>
						</td>
					</tr>
				</tbody>
			</table>
		</xsl:if>
	</xsl:template>
	<!-- ############################################################################################################# -->
	<xsl:template name="datenschemaeinzeln">
		<xsl:if test="$DebugMode = '1' or $DebugMode = '2' or $DebugMode = '3' or $DebugMode = '4'">
			<xsl:message>
				++++ datenschemaeinzeln ++++
			</xsl:message>
		</xsl:if>
		<h2>
			<a name="SchemaDetails"/>Details zum Datenschema <xsl:value-of select="/*/xdf3:stammdatenschema/xdf3:identifikation/xdf3:id"/>
			<xsl:if test="/*/xdf3:stammdatenschema/xdf3:identifikation/xdf3:version">&#160;Version&#160;<xsl:value-of select="/*/xdf3:stammdatenschema/xdf3:identifikation/xdf3:version"/><xsl:if test="$Navigation = '2'">&#160;<a href="#Bericht" title="nach oben">&#8593;</a></xsl:if>
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
				<xsl:call-template name="datenschemadetails">
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
			<xsl:if test="/*/xdf3:datenfeldgruppe/xdf3:identifikation/xdf3:version">&#160;Version&#160;<xsl:value-of select="/*/xdf3:datenfeldgruppe/xdf3:identifikation/xdf3:version"/><xsl:if test="$Navigation = '2'">&#160;<a href="#Bericht" title="nach oben">&#8593;</a></xsl:if>
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
	<xsl:template name="datenschemadetails">
		<xsl:param name="Element"/>
		<xsl:if test="$DebugMode = '2' or $DebugMode = '3' or $DebugMode = '4'">
			<xsl:message>
				++++++++ datenschemadetails ++++++++
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
					<xsl:attribute name="id"><xsl:value-of select="$Element/xdf3:identifikation/xdf3:id"/><xsl:if test="$Element/xdf3:identifikation/xdf3:version">V<xsl:value-of select="$Element/xdf3:identifikation/xdf3:version"/></xsl:if></xsl:attribute>
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
							<xsl:call-template name="meldung">
								<xsl:with-param name="nummer">1002</xsl:with-param>
							</xsl:call-template>
						</xsl:if>
					</td>
				</xsl:when>
				<xsl:otherwise>
					<td class="ElementName">
						<xsl:value-of select="$Element/xdf3:name"/>
						<xsl:call-template name="PruefeStringLatin">
							<xsl:with-param name="PruefString" select="$Element/xdf3:name"/>
						</xsl:call-template>
					</td>
				</xsl:otherwise>
			</xsl:choose>
		</tr>
		<tr>
			<td>Stichw�rter</td>
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
							<xsl:call-template name="meldung">
								<xsl:with-param name="nummer">1050</xsl:with-param>
							</xsl:call-template>
						</xsl:if>
					</td>
				</xsl:when>
				<xsl:otherwise>
					<td>
						<xsl:value-of select="$Element/xdf3:bezeichnung"/>
						<xsl:call-template name="PruefeStringLatin">
							<xsl:with-param name="PruefString" select="$Element/xdf3:bezeichnung"/>
						</xsl:call-template>
					</td>
				</xsl:otherwise>
			</xsl:choose>
		</tr>
		<tr>
			<td>Hilfetext</td>
			<td>
				<xsl:value-of select="fn:replace($Element/xdf3:hilfetext,'\n','&lt;br/&gt;')" disable-output-escaping="yes"/>
				<xsl:if test="$Meldungen = '1' and not(empty($Element/xdf3:hilfetext/text())) and $Element/xdf3:bezeichnung/text() = $Element/xdf3:hilfetext">
					<xsl:call-template name="meldung">
						<xsl:with-param name="nummer">1098</xsl:with-param>
					</xsl:call-template>
				</xsl:if>
				<xsl:call-template name="PruefeStringLatin">
					<xsl:with-param name="PruefString" select="$Element/xdf3:hilfetext"/>
				</xsl:call-template>
			</td>
		</tr>
		<tr>
			<td>Handlungsgrundlagen</td>
			<td>
				<xsl:choose>
					<xsl:when test="fn:count($Element/xdf3:bezug) = 0">
						<xsl:if test="$Meldungen = '1'">
							<xsl:call-template name="meldung">
								<xsl:with-param name="nummer">1051</xsl:with-param>
							</xsl:call-template>
						</xsl:if>
					</xsl:when>
					<xsl:otherwise>
						<xsl:call-template name="handlungsgrundlagen">
							<xsl:with-param name="Element" select="$Element"/>
						</xsl:call-template>
					</xsl:otherwise>
				</xsl:choose>
			</td>
		</tr>
		<tr>
			<td>Beschreibung</td>
			<td>
				<xsl:value-of select="fn:replace($Element/xdf3:beschreibung,'\n','&lt;br/&gt;')" disable-output-escaping="yes"/>
				<xsl:call-template name="PruefeStringLatin">
					<xsl:with-param name="PruefString" select="$Element/xdf3:beschreibung"/>
				</xsl:call-template>
			</td>
		</tr>
		<tr>
			<td>Definition</td>
			<td>
				<xsl:value-of select="fn:replace($Element/xdf3:definition,'\n','&lt;br/&gt;')" disable-output-escaping="yes"/>
				<xsl:call-template name="PruefeStringLatin">
					<xsl:with-param name="PruefString" select="$Element/xdf3:definition"/>
				</xsl:call-template>
			</td>
		</tr>
		<tr>
			<td>�nderbarkeit Struktur</td>
			<td>
				<xsl:choose>
					<xsl:when test="empty($Element/xdf3:ableitungsmodifikationenStruktur/code/text())">
						<xsl:if test="$Meldungen = '1'">
							<xsl:call-template name="meldung">
								<xsl:with-param name="nummer">1033</xsl:with-param>
							</xsl:call-template>
						</xsl:if>
					</xsl:when>
					<xsl:otherwise>
						<xsl:apply-templates select="$Element/xdf3:ableitungsmodifikationenStruktur"/>
					</xsl:otherwise>
				</xsl:choose>
			</td>
		</tr>
		<tr>
			<td>�nderbarkeit Repr�sentation</td>
			<td>
				<xsl:choose>
					<xsl:when test="empty($Element/xdf3:ableitungsmodifikationenRepraesentation/code/text())">
						<xsl:if test="$Meldungen = '1'">
							<xsl:call-template name="meldung">
								<xsl:with-param name="nummer">1034</xsl:with-param>
							</xsl:call-template>
						</xsl:if>
					</xsl:when>
					<xsl:otherwise>
						<xsl:apply-templates select="$Element/xdf3:ableitungsmodifikationenRepraesentation"/>
					</xsl:otherwise>
				</xsl:choose>
			</td>
		</tr>
		<tr>
			<td>G�ltig ab</td>
			<td>
				<xsl:value-of select="fn:format-date($Element/xdf3:gueltigAb,'[D01].[M01].[Y0001]')"/>
			</td>
		</tr>
		<tr>
			<td>G�ltig bis</td>
			<td>
				<xsl:value-of select="fn:format-date($Element/xdf3:gueltigBis,'[D01].[M01].[Y0001]')"/>
			</td>
		</tr>
		<tr>
			<td>Fachlicher Ersteller</td>
			<xsl:choose>
				<xsl:when test="empty($Element/xdf3:statusGesetztDurch/text()) and $VersionsHinweise ='1'">
					<td>
						<xsl:value-of select="$Element/xdf3:statusGesetztDurch"/>
						<xsl:if test="$Meldungen = '1'">
							<xsl:call-template name="meldung">
								<xsl:with-param name="nummer">1117</xsl:with-param>
							</xsl:call-template>
						</xsl:if>
					</td>
				</xsl:when>
				<xsl:otherwise>
					<td>
						<xsl:value-of select="$Element/xdf3:statusGesetztDurch"/>
						<xsl:call-template name="PruefeStringLatin">
							<xsl:with-param name="PruefString" select="$Element/xdf3:statusGesetztDurch"/>
						</xsl:call-template>
					</td>
				</xsl:otherwise>
			</xsl:choose>
		</tr>
		<tr>
			<td>Status</td>
			<td>
				<xsl:choose>
					<xsl:when test="empty($Element/xdf3:freigabestatus/code/text())">
						<xsl:if test="$Meldungen = '1'">
							<xsl:call-template name="meldung">
								<xsl:with-param name="nummer">1032</xsl:with-param>
							</xsl:call-template>
						</xsl:if>
					</xsl:when>
					<xsl:otherwise>
						<xsl:apply-templates select="$Element/xdf3:freigabestatus"/>
					</xsl:otherwise>
				</xsl:choose>
			</td>
		</tr>
		<tr>
			<td>Status gesetzt am</td>
			<td>
				<xsl:value-of select="fn:format-date($Element/xdf3:statusGesetztAm,'[D01].[M01].[Y0001]')"/>
			</td>
		</tr>
		<tr>
			<td>Ver�ffentlichungsdatum</td>
			<td>
				<xsl:value-of select="fn:format-date($Element/xdf3:veroeffentlichungsdatum,'[D01].[M01].[Y0001]')"/>
			</td>
		</tr>
		<tr>
			<td>Letzte �nderung</td>
			<td>
				<xsl:value-of select="fn:format-dateTime(fn:adjust-dateTime-to-timezone($Element/xdf3:letzteAenderung,xs:dayTimeDuration($Zeitzone)),'[D01].[M01].[Y0001] um [H01]:[m01] Uhr')"/>
			</td>
		</tr>
		<tr>
			<td>Letzte �nderung der enthaltenen Baukastenelemente</td>
			<td>
				<xsl:for-each select="//xdf3:enthaelt/*/xdf3:letzteAenderung">
					<xsl:sort select="." order="descending"/>
					<xsl:if test="fn:position() = 1">
						<xsl:value-of select="fn:format-dateTime(fn:adjust-dateTime-to-timezone(.,xs:dayTimeDuration($Zeitzone)),'[D01].[M01].[Y0001] um [H01]:[m01] Uhr')"/>
					</xsl:if>
				</xsl:for-each>
				
			</td>
		</tr>
		<tr>
			<td>Letzte Status�nderung der enthaltenen Baukastenelemente</td>
			<td>
				<xsl:for-each select="//xdf3:enthaelt/*/xdf3:statusGesetztAm">
					<xsl:sort select="." order="descending"/>
					<xsl:if test="fn:position() = 1">
						<xsl:value-of select="fn:format-date(.,'[D01].[M01].[Y0001]')"/>
					</xsl:if>
				</xsl:for-each>
				
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
								<xsl:choose>
									<xsl:when test="$SammelrepositoryCheck = '1'">
										<xsl:variable name="URLDSB" select="fn:concat($URLDSBList,$Element/xdf3:dokumentsteckbrief/xdf3:id,'/latest')"/>
										
										<xsl:if test="$DebugMode = '4'">
											<xsl:message>                                  URLDSB:<xsl:value-of select="$URLDSB"/></xsl:message>
										</xsl:if>
	
										<xsl:variable name="DSBJSON" as="xs:string">
											<xsl:try>
												<xsl:value-of select="unparsed-text($URLDSB)"/>
											
												<xsl:catch>
													<xsl:value-of  select="'not found'"/>
												</xsl:catch>
											</xsl:try>
										</xsl:variable>
	
										<xsl:choose>
											<xsl:when test="$DSBJSON = 'not found'">
												<xsl:if test="$ToolAufruf = '1'">
																				&#160;&#160;
																				<xsl:element name="a">
														<xsl:attribute name="href"><xsl:value-of select="$ToolPfadPrefix"/><xsl:value-of select="$Element/xdf3:dokumentsteckbrief/xdf3:id"/><xsl:value-of select="$ToolPfadPostfix"/></xsl:attribute>
														<xsl:attribute name="target">FIMTool</xsl:attribute>
														<xsl:attribute name="title">Springe in den Datenfeldeditor (man muss vorher angemeldet sein).</xsl:attribute>
																					&#8658;
																				</xsl:element>&#160;&#160;
												</xsl:if>

												<xsl:if test="$Meldungen = '1'">
													<xsl:call-template name="meldung">
														<xsl:with-param name="nummer">1125</xsl:with-param>
													</xsl:call-template>
												</xsl:if>
											</xsl:when>
											<xsl:otherwise>
												<xsl:variable name="DSBXML" select="json-to-xml($DSBJSON)"/>
				
												(<xsl:value-of select="$DSBXML/fn:map/fn:string[./@key='name']"/>)
												
												<xsl:if test="$ToolAufruf = '1'">
																				&#160;&#160;
																				<xsl:element name="a">
														<xsl:attribute name="href"><xsl:value-of select="$ToolPfadPrefix"/><xsl:value-of select="$Element/xdf3:dokumentsteckbrief/xdf3:id"/><xsl:value-of select="$ToolPfadPostfix"/></xsl:attribute>
														<xsl:attribute name="target">FIMTool</xsl:attribute>
														<xsl:attribute name="title">Springe in den Datenfeldeditor (man muss vorher angemeldet sein).</xsl:attribute>
																					&#8658;
																				</xsl:element>&#160;&#160;
												</xsl:if>
											</xsl:otherwise>
										</xsl:choose>
										
									</xsl:when>
									<xsl:otherwise>
										<xsl:if test="$ToolAufruf = '1'">
																		&#160;&#160;
																		<xsl:element name="a">
												<xsl:attribute name="href"><xsl:value-of select="$ToolPfadPrefix"/><xsl:value-of select="$Element/xdf3:dokumentsteckbrief/xdf3:id"/><xsl:value-of select="$ToolPfadPostfix"/></xsl:attribute>
												<xsl:attribute name="target">FIMTool</xsl:attribute>
												<xsl:attribute name="title">Springe in den Datenfeldeditor (man muss vorher angemeldet sein).</xsl:attribute>
																			&#8658;
																		</xsl:element>&#160;&#160;
										</xsl:if>
									</xsl:otherwise>
								</xsl:choose>

								<xsl:if test="$Meldungen = '1'">
									<xsl:if test="$Element/xdf3:dokumentsteckbrief/xdf3:id/text() ='D99000000001'">
										<xsl:choose>
											<xsl:when test="$Element/xdf3:freigabestatus/code/text() = '4' or $Element/xdf3:freigabestatus/code/text() = '5' or $Element/xdf3:freigabestatus/code/text() = '6'">
												<xsl:call-template name="meldung">
													<xsl:with-param name="nummer">1097</xsl:with-param>
												</xsl:call-template>
											</xsl:when>
											<xsl:otherwise>
												<xsl:call-template name="meldung">
													<xsl:with-param name="nummer">1096</xsl:with-param>
												</xsl:call-template>
											</xsl:otherwise>
										</xsl:choose>
									</xsl:if>
									<xsl:if test="fn:substring($Element/xdf3:dokumentsteckbrief/xdf3:id/text(),1,3)  != 'D99'">
										<xsl:call-template name="meldung">
											<xsl:with-param name="nummer">1124</xsl:with-param>
										</xsl:call-template>
									</xsl:if>
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
					</xsl:when>
					<xsl:otherwise>
						<xsl:if test="$Meldungen = '1'">
							<xsl:call-template name="meldung">
								<xsl:with-param name="nummer">1007</xsl:with-param>
							</xsl:call-template>
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
										<xsl:choose>
											<xsl:when test="empty(./xdf3:objekt/xdf3:id/text())">
												<xsl:if test="$Meldungen = '1'">
													<xsl:call-template name="meldung">
														<xsl:with-param name="nummer">1091</xsl:with-param>
													</xsl:call-template>
												</xsl:if>
											</xsl:when>
											<xsl:otherwise>
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
											</xsl:otherwise>
										</xsl:choose>
									</td>
									<td>
										<xsl:value-of select="./xdf3:objekt/xdf3:version"/>
									</td>
									<td>
										<xsl:choose>
											<xsl:when test="empty(./xdf3:praedikat/code/text())">
												<xsl:if test="$Meldungen = '1'">
													<xsl:call-template name="meldung">
														<xsl:with-param name="nummer">1029</xsl:with-param>
													</xsl:call-template>
												</xsl:if>
											</xsl:when>
											<xsl:otherwise>
												<xsl:apply-templates select="./xdf3:praedikat"/>
												<xsl:if test="$Meldungen = '1' and ./xdf3:praedikat/code = 'VKN'">
													<xsl:call-template name="meldung">
														<xsl:with-param name="nummer">1088</xsl:with-param>
													</xsl:call-template>
												</xsl:if>
											</xsl:otherwise>
										</xsl:choose>
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
				<xsl:if test="$Element/xdf3:art/code = 'X'">
					<br/>
					<b>Auswahlgruppe</b>
				</xsl:if>
				<xsl:if test="$Meldungen = '1' and (count($Element/xdf3:struktur) &lt; 1)">
					<xsl:call-template name="meldung">
						<xsl:with-param name="nummer">1078</xsl:with-param>
					</xsl:call-template>
				</xsl:if>
				<xsl:if test="$Meldungen = '1' and $Element/xdf3:struktur/xdf3:enthaelt/xdf3:datenfeld/xdf3:identifikation[./xdf3:id/text() ='F60000000001']">
					<xsl:choose>
						<xsl:when test="count($Element/xdf3:struktur) &gt; 1">
							<xsl:call-template name="meldung">
								<xsl:with-param name="nummer">1094</xsl:with-param>
							</xsl:call-template>
						</xsl:when>
						<xsl:otherwise>
							<xsl:call-template name="meldung">
								<xsl:with-param name="nummer">1095</xsl:with-param>
							</xsl:call-template>
						</xsl:otherwise>
					</xsl:choose>
				</xsl:if>
			</td>
			<td>
				<xsl:if test="count($Element/xdf3:struktur) + count($Element/xdf3:regel)">
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
				-------- <xsl:value-of select="$Element/xdf3:identifikation/xdf3:id"/>
				<xsl:if test="$Element/xdf3:identifikation/xdf3:version">V<xsl:value-of select="$Element/xdf3:identifikation/xdf3:version"/>
				</xsl:if> --------
			</xsl:message>
		</xsl:if>
		<tr>
			<td>
				<xsl:element name="a">
					<xsl:attribute name="id"><xsl:value-of select="$Element/xdf3:identifikation/xdf3:id"/><xsl:if test="$Element/xdf3:identifikation/xdf3:version">V<xsl:value-of select="$Element/xdf3:identifikation/xdf3:version"/></xsl:if></xsl:attribute>
				</xsl:element>
											ID
										</td>
			<xsl:choose>
				<xsl:when test="empty($Element/xdf3:identifikation/xdf3:id/text())">
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
							<xsl:call-template name="meldung">
								<xsl:with-param name="nummer">1002</xsl:with-param>
							</xsl:call-template>
						</xsl:if>
					</td>
				</xsl:when>
				<xsl:otherwise>
					<td class="ElementName">
						<xsl:value-of select="$Element/xdf3:name"/>
						<xsl:call-template name="PruefeStringLatin">
							<xsl:with-param name="PruefString" select="$Element/xdf3:name"/>
						</xsl:call-template>
					</td>
				</xsl:otherwise>
			</xsl:choose>
		</tr>
		<tr>
			<td>Stichw�rter</td>
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
			<xsl:call-template name="PruefeStringLatin">
				<xsl:with-param name="PruefString" select="$Element/xdf3:definition"/>
			</xsl:call-template>
		</tr>
		<tr>
			<td>Strukturelementart</td>
			<td>
				<xsl:choose>
					<xsl:when test="empty($Element/xdf3:schemaelementart/code/text())">
						<xsl:if test="$Meldungen = '1'">
							<xsl:call-template name="meldung">
								<xsl:with-param name="nummer">1031</xsl:with-param>
							</xsl:call-template>
						</xsl:if>
					</xsl:when>
					<xsl:otherwise>
						<xsl:apply-templates select="$Element/xdf3:schemaelementart"/>
					</xsl:otherwise>
				</xsl:choose>
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
									<xsl:call-template name="meldung">
										<xsl:with-param name="nummer">1006</xsl:with-param>
									</xsl:call-template>
								</xsl:if>
							</xsl:when>
							<xsl:when test="$Element/xdf3:schemaelementart/code/text() = 'HAR'">
								<xsl:if test="$Meldungen = '1'">
									<xsl:call-template name="meldung">
										<xsl:with-param name="nummer">1101</xsl:with-param>
									</xsl:call-template>
								</xsl:if>
							</xsl:when>
							<xsl:otherwise>
							</xsl:otherwise>
						</xsl:choose>
					</xsl:when>
					<xsl:otherwise>
						<xsl:call-template name="handlungsgrundlagen">
							<xsl:with-param name="Element" select="$Element"/>
						</xsl:call-template>
					</xsl:otherwise>
				</xsl:choose>
			</td>
		</tr>
		<tr>
			<td>Beschreibung</td>
			<td>
				<xsl:value-of select="fn:replace($Element/xdf3:beschreibung,'\n','&lt;br/&gt;')" disable-output-escaping="yes"/>
				<xsl:call-template name="PruefeStringLatin">
					<xsl:with-param name="PruefString" select="$Element/xdf3:beschreibung"/>
				</xsl:call-template>
			</td>
		</tr>
		<tr>
			<td>Bezeichnung Eingabe</td>
			<xsl:choose>
				<xsl:when test="empty($Element/xdf3:bezeichnungEingabe/text())">
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
						<xsl:value-of select="$Element/xdf3:bezeichnungEingabe"/>
						<xsl:call-template name="PruefeStringLatin">
							<xsl:with-param name="PruefString" select="$Element/xdf3:bezeichnungEingabe"/>
						</xsl:call-template>
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
							<xsl:call-template name="meldung">
								<xsl:with-param name="nummer">1010</xsl:with-param>
							</xsl:call-template>
						</xsl:if>
					</td>
				</xsl:when>
				<xsl:otherwise>
					<td>
						<xsl:value-of select="$Element/xdf3:bezeichnungAusgabe"/>
						<xsl:call-template name="PruefeStringLatin">
							<xsl:with-param name="PruefString" select="$Element/xdf3:bezeichnungAusgabe"/>
						</xsl:call-template>
					</td>
				</xsl:otherwise>
			</xsl:choose>
		</tr>
		<tr>
			<td>Hilfetext Eingabe</td>
			<td>
				<xsl:value-of select="fn:replace($Element/xdf3:hilfetextEingabe,'\n','&lt;br/&gt;')" disable-output-escaping="yes"/>
				<xsl:if test="$Meldungen = '1' and not(empty($Element/xdf3:hilfetextEingabe/text())) and $Element/xdf3:bezeichnungEingabe/text() = $Element/xdf3:hilfetextEingabe/text()">
					<xsl:call-template name="meldung">
						<xsl:with-param name="nummer">1098</xsl:with-param>
					</xsl:call-template>
				</xsl:if>
				<xsl:call-template name="PruefeStringLatin">
					<xsl:with-param name="PruefString" select="$Element/xdf3:hilfetextEingabe"/>
				</xsl:call-template>
			</td>
		</tr>
		<tr>
			<td>Hilfetext Ausgabe</td>
			<td>
				<xsl:value-of select="fn:replace($Element/xdf3:hilfetextAusgabe,'\n','&lt;br/&gt;')" disable-output-escaping="yes"/>
				<xsl:if test="$Meldungen = '1' and not(empty($Element/xdf3:hilfetextAusgabe/text())) and $Element/xdf3:bezeichnungAusgabe/text() = $Element/xdf3:hilfetextAusgabe/text()">
					<xsl:call-template name="meldung">
						<xsl:with-param name="nummer">1098</xsl:with-param>
					</xsl:call-template>
				</xsl:if>
				<xsl:call-template name="PruefeStringLatin">
					<xsl:with-param name="PruefString" select="$Element/xdf3:hilfetextAusgabe"/>
				</xsl:call-template>
			</td>
		</tr>
		<tr>
			<td>G�ltig ab</td>
			<td>
				<xsl:value-of select="fn:format-date($Element/xdf3:gueltigAb,'[D01].[M01].[Y0001]')"/>
			</td>
		</tr>
		<tr>
			<td>G�ltig bis</td>
			<td>
				<xsl:value-of select="fn:format-date($Element/xdf3:gueltigBis,'[D01].[M01].[Y0001]')"/>
			</td>
		</tr>
		<tr>
			<td>Fachlicher Ersteller</td>
			<xsl:choose>
				<xsl:when test="empty($Element/xdf3:statusGesetztDurch/text()) and $VersionsHinweise ='1'">
					<td>
						<xsl:value-of select="$Element/xdf3:statusGesetztDurch"/>
						<xsl:if test="$Meldungen = '1'">
							<xsl:call-template name="meldung">
								<xsl:with-param name="nummer">1117</xsl:with-param>
							</xsl:call-template>
						</xsl:if>
					</td>
				</xsl:when>
				<xsl:otherwise>
					<td>
						<xsl:value-of select="$Element/xdf3:statusGesetztDurch"/>
						<xsl:call-template name="PruefeStringLatin">
							<xsl:with-param name="PruefString" select="$Element/xdf3:statusGesetztDurch"/>
						</xsl:call-template>
					</td>
				</xsl:otherwise>
			</xsl:choose>
		</tr>
		<tr>
			<td>Status</td>
			<td>
				<xsl:choose>
					<xsl:when test="empty($Element/xdf3:freigabestatus/code/text())">
						<xsl:if test="$Meldungen = '1'">
							<xsl:call-template name="meldung">
								<xsl:with-param name="nummer">1032</xsl:with-param>
							</xsl:call-template>
						</xsl:if>
					</xsl:when>
					<xsl:otherwise>
						<xsl:apply-templates select="$Element/xdf3:freigabestatus"/>
					</xsl:otherwise>
				</xsl:choose>
			</td>
		</tr>
		<tr>
			<td>Status gesetzt am</td>
			<td>
				<xsl:value-of select="fn:format-date($Element/xdf3:statusGesetztAm,'[D01].[M01].[Y0001]')"/>
			</td>
		</tr>
		<tr>
			<td>Ver�ffentlichungsdatum</td>
			<td>
				<xsl:value-of select="fn:format-date($Element/xdf3:veroeffentlichungsdatum,'[D01].[M01].[Y0001]')"/>
			</td>
		</tr>
		<tr>
			<td>Letzte �nderung</td>
			<td>
				<xsl:value-of select="fn:format-dateTime(fn:adjust-dateTime-to-timezone($Element/xdf3:letzteAenderung,xs:dayTimeDuration($Zeitzone)),'[D01].[M01].[Y0001] um [H01]:[m01] Uhr')"/>
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
										<xsl:choose>
											<xsl:when test="empty(./xdf3:objekt/xdf3:id/text())">
												<xsl:if test="$Meldungen = '1'">
													<xsl:call-template name="meldung">
														<xsl:with-param name="nummer">1091</xsl:with-param>
													</xsl:call-template>
												</xsl:if>
											</xsl:when>
											<xsl:otherwise>
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
											</xsl:otherwise>
										</xsl:choose>
									</td>
									<td>
										<xsl:value-of select="./xdf3:objekt/xdf3:version"/>
									</td>
									<td>
										<xsl:choose>
											<xsl:when test="empty(./xdf3:praedikat/code/text())">
												<xsl:if test="$Meldungen = '1'">
													<xsl:call-template name="meldung">
														<xsl:with-param name="nummer">1029</xsl:with-param>
													</xsl:call-template>
												</xsl:if>
											</xsl:when>
											<xsl:otherwise>
												<xsl:apply-templates select="./xdf3:praedikat"/>
												<xsl:if test="$Meldungen = '1' and ./xdf3:praedikat/code = 'VKN'">
													<xsl:call-template name="meldung">
														<xsl:with-param name="nummer">1088</xsl:with-param>
													</xsl:call-template>
												</xsl:if>
											</xsl:otherwise>
										</xsl:choose>
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
				<xsl:choose>
					<xsl:when test="$Element/xdf3:art/code = 'X'">
						<br/>
						<b>Auswahlgruppe</b>
						<xsl:if test="$Meldungen = '1'">
							<xsl:choose>
								<xsl:when test="count($Element/xdf3:struktur) &lt; 1">
									<xsl:call-template name="meldung">
										<xsl:with-param name="nummer">1023</xsl:with-param>
									</xsl:call-template>
								</xsl:when>
								<xsl:when test="count($Element/xdf3:struktur) = 1">
									<xsl:call-template name="meldung">
										<xsl:with-param name="nummer">1043</xsl:with-param>
									</xsl:call-template>
								</xsl:when>
							</xsl:choose>
						</xsl:if>
					</xsl:when>
					<xsl:otherwise>
						<xsl:if test="$Meldungen = '1'">
							<xsl:choose>
								<xsl:when test="count($Element/xdf3:struktur) &lt; 1">
									<xsl:call-template name="meldung">
										<xsl:with-param name="nummer">1023</xsl:with-param>
									</xsl:call-template>
								</xsl:when>
								<xsl:when test="count($Element/xdf3:struktur) = 1">
									<xsl:call-template name="meldung">
										<xsl:with-param name="nummer">1106</xsl:with-param>
									</xsl:call-template>
								</xsl:when>
							</xsl:choose>
						</xsl:if>
					</xsl:otherwise>
				</xsl:choose>
				<xsl:if test="$Meldungen = '1' and $Element/xdf3:struktur/xdf3:enthaelt/xdf3:datenfeld/xdf3:identifikation[./xdf3:id/text() ='F60000000001']">
					<xsl:choose>
						<xsl:when test="count($Element/xdf3:struktur) &gt; 1">
							<xsl:call-template name="meldung">
								<xsl:with-param name="nummer">1094</xsl:with-param>
							</xsl:call-template>
						</xsl:when>
						<xsl:otherwise>
							<xsl:call-template name="meldung">
								<xsl:with-param name="nummer">1095</xsl:with-param>
							</xsl:call-template>
						</xsl:otherwise>
					</xsl:choose>
				</xsl:if>
			</td>
			<td>
				<xsl:if test="count($Element/xdf3:struktur) + count($Element/xdf3:regel)">
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
								<xsl:with-param name="Strukturelementart" select="$Element/xdf3:schemaelementart/code"/>
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
				-------- <xsl:value-of select="$Element/xdf3:identifikation/xdf3:id"/>
				<xsl:if test="$Element/xdf3:identifikation/xdf3:version">V<xsl:value-of select="$Element/xdf3:identifikation/xdf3:version"/>
				</xsl:if> --------
			</xsl:message>
		</xsl:if>
		<tr>
			<td>
				<xsl:element name="a">
					<xsl:attribute name="id"><xsl:value-of select="$Element/xdf3:identifikation/xdf3:id"/><xsl:if test="$Element/xdf3:identifikation/xdf3:version">V<xsl:value-of select="$Element/xdf3:identifikation/xdf3:version"/></xsl:if></xsl:attribute>
				</xsl:element>
											ID
										</td>
			<xsl:choose>
				<xsl:when test="empty($Element/xdf3:identifikation/xdf3:id/text())">
					<td class="ElementID">
						<xsl:if test="$Meldungen = '1'">
							<xsl:call-template name="meldung">
								<xsl:with-param name="nummer">1038</xsl:with-param>
							</xsl:call-template>
						</xsl:if>
					</td>
				</xsl:when>
				<xsl:otherwise>
					<td class="SteckbriefID">
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
							<xsl:call-template name="meldung">
								<xsl:with-param name="nummer">1002</xsl:with-param>
							</xsl:call-template>
						</xsl:if>
					</td>
				</xsl:when>
				<xsl:otherwise>
					<td class="ElementName">
						<xsl:value-of select="$Element/xdf3:name"/>
						<xsl:call-template name="PruefeStringLatin">
							<xsl:with-param name="PruefString" select="$Element/xdf3:name"/>
						</xsl:call-template>
					</td>
				</xsl:otherwise>
			</xsl:choose>
		</tr>
		<tr>
			<td>Stichw�rter</td>
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
							<xsl:call-template name="meldung">
								<xsl:with-param name="nummer">1049</xsl:with-param>
							</xsl:call-template>
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
						<xsl:if test="$Meldungen = '1' and $Element/xdf3:istAbstrakt = 'false'">
							<xsl:call-template name="meldung">
								<xsl:with-param name="nummer">1052</xsl:with-param>
							</xsl:call-template>
						</xsl:if>
					</xsl:when>
					<xsl:otherwise>
						<xsl:call-template name="handlungsgrundlagen">
							<xsl:with-param name="Element" select="$Element"/>
						</xsl:call-template>
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
			<td colspan="3"><p/></td>
		</tr>

		<tr>
			<td>Art</td>
			<td>
				<xsl:choose>
					<xsl:when test="empty($Element/xdf3:istAbstrakt/text()) or not($Element/xdf3:istAbstrakt/text() castable as xs:boolean)">
						<xsl:value-of select="$Element/xdf3:istAbstrakt"/>
						<xsl:if test="$Meldungen = '1'">
							<xsl:call-template name="meldung">
								<xsl:with-param name="nummer">1092</xsl:with-param>
							</xsl:call-template>
						</xsl:if>
					</xsl:when>
					<xsl:otherwise>
						<xsl:choose>
							<xsl:when test="$Element/xdf3:istAbstrakt = 'true'">
								abstrakter Dokumentsteckbrief
							</xsl:when>
							<xsl:otherwise>
								konkreter Dokumentsteckbrief
							</xsl:otherwise>
						</xsl:choose>
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
										<xsl:choose>
											<xsl:when test="empty(./xdf3:objekt/xdf3:id/text())">
												<xsl:if test="$Meldungen = '1'">
													<xsl:call-template name="meldung">
														<xsl:with-param name="nummer">1091</xsl:with-param>
													</xsl:call-template>
												</xsl:if>
											</xsl:when>
											<xsl:otherwise>
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
											</xsl:otherwise>
										</xsl:choose>
									</td>
								</tr>
							</xsl:for-each>
							<xsl:if test="$Meldungen = '1'">
								<xsl:choose>
									<xsl:when test="$Element/xdf3:istAbstrakt = 'false'">
										<tr>
											<td>
												<xsl:call-template name="meldung">
													<xsl:with-param name="nummer">1053</xsl:with-param>
												</xsl:call-template>
											</td>
										</tr>
									</xsl:when>
									<xsl:when test="$Element/xdf3:istAbstrakt = 'true' and count($Element/xdf3:relation[xdf3:praedikat/code = 'VKN']) &lt; 2">
										<tr>
											<td>
												<xsl:call-template name="meldung">
													<xsl:with-param name="nummer">1054</xsl:with-param>
												</xsl:call-template>
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
				<xsl:choose>
					<xsl:when test="empty($Element/xdf3:dokumentart/code/text())">
						<xsl:if test="$Meldungen = '1'">
							<xsl:call-template name="meldung">
								<xsl:with-param name="nummer">1055</xsl:with-param>
							</xsl:call-template>
						</xsl:if>
					</xsl:when>
					<xsl:otherwise>
						<xsl:apply-templates select="$Element/xdf3:dokumentart"/>
					</xsl:otherwise>
				</xsl:choose>
			</td>
		</tr>
		<tr>
			<td colspan="3"><p/></td>
		</tr>

		<tr>
			<td>Bezeichnung</td>
			<xsl:choose>
				<xsl:when test="empty($Element/xdf3:bezeichnung/text())">
					<td>
						<xsl:if test="$Meldungen = '1'">
							<xsl:call-template name="meldung">
								<xsl:with-param name="nummer">1050</xsl:with-param>
							</xsl:call-template>
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
							<xsl:call-template name="meldung">
								<xsl:with-param name="nummer">1107</xsl:with-param>
							</xsl:call-template>
						</xsl:if>
					</td>
				</xsl:when>
				<xsl:otherwise>
					<td>
						<xsl:value-of select="fn:replace($Element/xdf3:hilfetext,'\n','&lt;br/&gt;')" disable-output-escaping="yes"/>
						<xsl:if test="$Meldungen = '1' and $Element/xdf3:bezeichnung/text() = $Element/xdf3:hilfetext/text()">
							<xsl:call-template name="meldung">
								<xsl:with-param name="nummer">1098</xsl:with-param>
							</xsl:call-template>
						</xsl:if>
					</td>
				</xsl:otherwise>
			</xsl:choose>
		</tr>
		<tr>
			<td colspan="3"><p/></td>
		</tr>

		<tr>
			<td>G�ltig ab</td>
			<td>
				<xsl:value-of select="fn:format-date($Element/xdf3:gueltigAb,'[D01].[M01].[Y0001]')"/>
			</td>
		</tr>
		<tr>
			<td>G�ltig bis</td>
			<td>
				<xsl:value-of select="fn:format-date($Element/xdf3:gueltigBis,'[D01].[M01].[Y0001]')"/>
			</td>
		</tr>
		<tr>
			<td>Fachlicher Ersteller</td>
			<xsl:choose>
				<xsl:when test="empty($Element/xdf3:statusGesetztDurch/text()) and $VersionsHinweise ='1'">
					<td>
						<xsl:value-of select="$Element/xdf3:statusGesetztDurch"/>
						<xsl:if test="$Meldungen = '1'">
							<xsl:call-template name="meldung">
								<xsl:with-param name="nummer">1117</xsl:with-param>
							</xsl:call-template>
						</xsl:if>
					</td>
				</xsl:when>
				<xsl:otherwise>
					<td>
						<xsl:value-of select="$Element/xdf3:statusGesetztDurch"/>
						<xsl:call-template name="PruefeStringLatin">
							<xsl:with-param name="PruefString" select="$Element/xdf3:statusGesetztDurch"/>
						</xsl:call-template>
					</td>
				</xsl:otherwise>
			</xsl:choose>
		</tr>
		<tr>
			<td>Status</td>
			<td>
				<xsl:choose>
					<xsl:when test="empty($Element/xdf3:freigabestatus/code/text())">
						<xsl:if test="$Meldungen = '1'">
							<xsl:call-template name="meldung">
								<xsl:with-param name="nummer">1032</xsl:with-param>
							</xsl:call-template>
						</xsl:if>
					</xsl:when>
					<xsl:otherwise>
						<xsl:apply-templates select="$Element/xdf3:freigabestatus"/>
					</xsl:otherwise>
				</xsl:choose>
			</td>
		</tr>
		<tr>
			<td>Status gesetzt am</td>
			<td>
				<xsl:value-of select="fn:format-date($Element/xdf3:statusGesetztAm,'[D01].[M01].[Y0001]')"/>
			</td>
		</tr>
		<tr>
			<td>Ver�ffentlichungsdatum</td>
			<td>
				<xsl:value-of select="fn:format-date($Element/xdf3:veroeffentlichungsdatum,'[D01].[M01].[Y0001]')"/>
			</td>
		</tr>
		<tr>
			<td>Letzte �nderung</td>
			<td>
				<xsl:value-of select="fn:format-dateTime(fn:adjust-dateTime-to-timezone($Element/xdf3:letzteAenderung,xs:dayTimeDuration($Zeitzone)),'[D01].[M01].[Y0001] um [H01]:[m01] Uhr')"/>
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
										<xsl:choose>
											<xsl:when test="empty(./xdf3:objekt/xdf3:id/text())">
												<xsl:if test="$Meldungen = '1'">
													<xsl:call-template name="meldung">
														<xsl:with-param name="nummer">1091</xsl:with-param>
													</xsl:call-template>
												</xsl:if>
											</xsl:when>
											<xsl:otherwise>
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
											</xsl:otherwise>
										</xsl:choose>
									</td>
									<td>
										<xsl:value-of select="./xdf3:objekt/xdf3:version"/>
									</td>
									<td>
										<xsl:choose>
											<xsl:when test="empty(./xdf3:praedikat/code/text())">
												<xsl:if test="$Meldungen = '1'">
													<xsl:call-template name="meldung">
														<xsl:with-param name="nummer">1029</xsl:with-param>
													</xsl:call-template>
												</xsl:if>
											</xsl:when>
											<xsl:otherwise>
												<xsl:apply-templates select="./xdf3:praedikat"/>
											</xsl:otherwise>
										</xsl:choose>
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
					<xsl:if test="/*/xdf3:stammdatenschema/xdf3:identifikation/xdf3:version"> Version <xsl:value-of select="/*/xdf3:stammdatenschema/xdf3:identifikation/xdf3:version"/><xsl:if test="$Navigation = '2'">&#160;<a href="#Bericht" title="nach oben">&#8593;</a></xsl:if>
					</xsl:if>
				</xsl:when>
				<xsl:when test="name(/*) ='xdf3:xdatenfelder.datenfeldgruppe.0103'">
					<a name="ElementDetails"/>Details zu den Baukastenelementen der Datenfeldgruppe <xsl:value-of select="/*/xdf3:datenfeldgruppe/xdf3:identifikation/xdf3:id"/>
					<xsl:if test="/*/xdf3:datenfeldgruppe/xdf3:identifikation/xdf3:version"> Version <xsl:value-of select="/*/xdf3:datenfeldgruppe/xdf3:identifikation/xdf3:version"/><xsl:if test="$Navigation = '2'">&#160;<a href="#Bericht" title="nach oben">&#8593;</a></xsl:if>
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
							<xsl:attribute name="id"><xsl:value-of select="$Element/xdf3:identifikation/xdf3:id"/><xsl:if test="$Element/xdf3:identifikation/xdf3:version">V<xsl:value-of select="$Element/xdf3:identifikation/xdf3:version"/></xsl:if></xsl:attribute>
						</xsl:element>
													ID
												</td>
					<xsl:choose>
						<xsl:when test="empty($Element/xdf3:identifikation/xdf3:id/text())">
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
						<xsl:value-of select="$Element/xdf3:identifikation/xdf3:version"/>
						<xsl:if test="$Meldungen = '1'">
							<xsl:if test="$SammelrepositoryCheck = '1'">
								<xsl:variable name="URLBE" select="fn:concat($URLFeList,$Element/xdf3:identifikation/xdf3:id,'/latest')"/>
								
								<xsl:if test="$DebugMode = '4'">
									<xsl:message>                                  URLBE:<xsl:value-of select="$URLBE"/></xsl:message>
								</xsl:if>
	
								<xsl:variable name="BEJSON" as="xs:string">
									<xsl:try>
										<xsl:value-of select="unparsed-text($URLBE)"/>
									
										<xsl:catch>
											<xsl:value-of  select="'not found'"/>
										</xsl:catch>
									</xsl:try>
								</xsl:variable>

								<xsl:choose>
									<xsl:when test="$BEJSON = 'not found'">
										<xsl:if test="$DebugMode = '4'">
											<xsl:message>                                  Element in Sammelrepository nicht gefunden</xsl:message>
										</xsl:if>
									</xsl:when>
									<xsl:otherwise>
										<xsl:variable name="BEXML" select="json-to-xml($BEJSON)"/>
		
										<xsl:variable name="BELatestVersion" select="$BEXML/fn:map/*[./@key='fim_version']"/>
										<xsl:variable name="BELatestStatus" select="$BEXML/fn:map/*[./@key='freigabe_status_label']"/>
										
										<xsl:variable name="BEVersionMaj" select="number(tokenize($Element/xdf3:identifikation/xdf3:version, '\.')[1])"/>
										<xsl:variable name="BEVersionMin" select="number(tokenize($Element/xdf3:identifikation/xdf3:version, '\.')[2])"/>
										<xsl:variable name="BEVersionMic" select="number(tokenize($Element/xdf3:identifikation/xdf3:version, '\.')[3])"/>

										<xsl:variable name="BELatestMaj" select="number(tokenize($BELatestVersion, '\.')[1])"/>
										<xsl:variable name="BELatestMin" select="number(tokenize($BELatestVersion, '\.')[2])"/>
										<xsl:variable name="BELatestMic" select="number(tokenize($BELatestVersion, '\.')[3])"/>
										
										<xsl:choose>
											<xsl:when test="$BELatestMaj &gt; $BEVersionMaj">
												[Aktuelle im Sammelrepository ver�ffentlichte Version: <xsl:value-of select="$BELatestVersion"/> im Status <xsl:value-of select="$BELatestStatus"/>]
												<xsl:call-template name="meldung">
													<xsl:with-param name="nummer">1126</xsl:with-param>
												</xsl:call-template>
											</xsl:when>
											<xsl:when test="$BELatestMaj = $BEVersionMaj">
												<xsl:choose>
													<xsl:when test="$BELatestMin &gt; $BEVersionMin">
														[Aktuelle im Sammelrepository ver�ffentlichte Version: <xsl:value-of select="$BELatestVersion"/> im Status <xsl:value-of select="$BELatestStatus"/>]
														<xsl:call-template name="meldung">
															<xsl:with-param name="nummer">1126</xsl:with-param>
														</xsl:call-template>
													</xsl:when>
													<xsl:when test="$BELatestMin = $BEVersionMin">
														<xsl:choose>
															<xsl:when test="$BELatestMin &gt; $BEVersionMin">
																[Aktuelle im Sammelrepository ver�ffentlichte Version: <xsl:value-of select="$BELatestVersion"/> im Status <xsl:value-of select="$BELatestStatus"/>]
																<xsl:call-template name="meldung">
																	<xsl:with-param name="nummer">1126</xsl:with-param>
																</xsl:call-template>
															</xsl:when>
															<xsl:otherwise></xsl:otherwise>
														</xsl:choose>
													</xsl:when>
													<xsl:otherwise></xsl:otherwise>
												</xsl:choose>
											</xsl:when>
											<xsl:otherwise></xsl:otherwise>
										</xsl:choose>
										
									</xsl:otherwise>
								</xsl:choose>
							</xsl:if>
							<xsl:if test="$VersionsAnzahl &gt; 1">
								<xsl:call-template name="meldung">
									<xsl:with-param name="nummer">1003</xsl:with-param>
								</xsl:call-template>
							</xsl:if>
							<xsl:if test="fn:string(/*/*/xdf3:identifikation/xdf3:version) and not(fn:string($Element/xdf3:identifikation/xdf3:version))">
								<xsl:call-template name="meldung">
									<xsl:with-param name="nummer">1135</xsl:with-param>
								</xsl:call-template>
							</xsl:if>
							<xsl:if test="$VersionsHinweise = '1'">
								<xsl:if test="not(fn:string(/*/*/xdf3:identifikation/xdf3:version)) and fn:string($Element/xdf3:identifikation/xdf3:version) and (fn:substring(./xdf3:identifikation/xdf3:id,2,2) = fn:substring(/*/*/xdf3:identifikation/xdf3:id,2,2))">
									<xsl:call-template name="meldung">
										<xsl:with-param name="nummer">1134</xsl:with-param>
									</xsl:call-template>
								</xsl:if>
							</xsl:if>
						</xsl:if>
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
									<xsl:call-template name="meldung">
										<xsl:with-param name="nummer">1002</xsl:with-param>
									</xsl:call-template>
								</xsl:if>
							</td>
						</xsl:when>
						<xsl:otherwise>
							<td class="ElementName">
								<xsl:value-of select="$Element/xdf3:name"/>
								<xsl:call-template name="PruefeStringLatin">
									<xsl:with-param name="PruefString" select="$Element/xdf3:name"/>
								</xsl:call-template>
							</td>
						</xsl:otherwise>
					</xsl:choose>
				</tr>
				<tr>
					<td>Stichw�rter</td>
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
						<xsl:call-template name="PruefeStringLatin">
							<xsl:with-param name="PruefString" select="$Element/xdf3:definition"/>
						</xsl:call-template>
					</td>
				</tr>
				<tr>
					<td>Strukturelementart</td>
					<td>
						<xsl:choose>
							<xsl:when test="empty($Element/xdf3:schemaelementart/code/text())">
								<xsl:if test="$Meldungen = '1'">
									<xsl:call-template name="meldung">
										<xsl:with-param name="nummer">1031</xsl:with-param>
									</xsl:call-template>
								</xsl:if>
							</xsl:when>
							<xsl:otherwise>
								<xsl:apply-templates select="$Element/xdf3:schemaelementart"/>
								<xsl:if test="$Meldungen = '1' and $Element/xdf3:schemaelementart/code/text() = 'ABS'">
									<xsl:call-template name="meldung">
										<xsl:with-param name="nummer">1014</xsl:with-param>
									</xsl:call-template>
								</xsl:if>
							</xsl:otherwise>
						</xsl:choose>
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
											<xsl:call-template name="meldung">
												<xsl:with-param name="nummer">1006</xsl:with-param>
											</xsl:call-template>
										</xsl:if>
									</xsl:when>
									<xsl:when test="$Element/xdf3:schemaelementart/code/text() = 'HAR'">
										<xsl:if test="$Meldungen = '1'">
											<xsl:call-template name="meldung">
												<xsl:with-param name="nummer">1101</xsl:with-param>
											</xsl:call-template>
										</xsl:if>
									</xsl:when>
									<xsl:otherwise>
									</xsl:otherwise>
								</xsl:choose>
							</xsl:when>
							<xsl:otherwise>
								<xsl:call-template name="handlungsgrundlagen">
									<xsl:with-param name="Element" select="$Element"/>
								</xsl:call-template>
							</xsl:otherwise>
						</xsl:choose>
					</td>
				</tr>
				<tr>
					<td>Feldart</td>
					<td>
						<xsl:choose>
							<xsl:when test="empty($Element/xdf3:feldart/code/text())">
								<xsl:if test="$Meldungen = '1'">
									<xsl:call-template name="meldung">
										<xsl:with-param name="nummer">1027</xsl:with-param>
									</xsl:call-template>
								</xsl:if>
							</xsl:when>
							<xsl:otherwise>
								<xsl:apply-templates select="$Element/xdf3:feldart"/>
							</xsl:otherwise>
						</xsl:choose>
					</td>
				</tr>
				<tr>
					<td>Datentyp</td>
					<xsl:choose>
						<xsl:when test="empty($Element/xdf3:datentyp/code/text())">
							<td>
								<xsl:if test="$Meldungen = '1'">
									<xsl:call-template name="meldung">
										<xsl:with-param name="nummer">1028</xsl:with-param>
									</xsl:call-template>
								</xsl:if>
							</td>
						</xsl:when>
						<xsl:otherwise>
							<td>
								<xsl:apply-templates select="$Element/xdf3:datentyp"/>
								<xsl:if test="$Meldungen = '1'">
									<xsl:choose>
										<xsl:when test="$Element/xdf3:feldart/code/text() = 'input'">
											<xsl:if test="$Element/xdf3:datentyp/code/text() = 'obj'">
												<xsl:call-template name="meldung">
													<xsl:with-param name="nummer">1089</xsl:with-param>
												</xsl:call-template>
											</xsl:if>
										</xsl:when>
										<xsl:when test="$Element/xdf3:feldart/code/text() = 'select'">
											<xsl:if test="$Element/xdf3:datentyp/code/text() != 'text'">
												<xsl:call-template name="meldung">
													<xsl:with-param name="nummer">1011</xsl:with-param>
												</xsl:call-template>
											</xsl:if>
										</xsl:when>
										<xsl:when test="$Element/xdf3:feldart/code/text() = 'label'">
											<xsl:if test="not($Element/xdf3:datentyp/code/text() = 'obj' or $Element/xdf3:datentyp/code/text() = 'text' or $Element/xdf3:datentyp/code/text() = 'text_latin')">
												<xsl:call-template name="meldung">
													<xsl:with-param name="nummer">1090</xsl:with-param>
												</xsl:call-template>
											</xsl:if>
										</xsl:when>
										<xsl:when test="$Element/xdf3:feldart/code/text() = 'hidden'">
										</xsl:when>
										<xsl:when test="$Element/xdf3:feldart/code/text() = 'locked'">
										</xsl:when>
									</xsl:choose>
								</xsl:if>
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
								<xsl:when test="($Element/xdf3:datentyp/code/text() = 'text' or $Element/xdf3:datentyp/code/text() = 'text_latin') and $Element/xdf3:feldart/code/text() = 'input'">
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
								<xsl:when test="$Element/xdf3:datentyp/code/text() = 'num_int'">
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
								<xsl:when test="$Element/xdf3:datentyp/code/text() = 'date'">
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
								<xsl:when test="$Element/xdf3:datentyp/code/text() = 'datetime'">
									<td>
										<xsl:if test="$minValue != ''">
											von <xsl:value-of select="$minValue"/>
										</xsl:if>
										<xsl:if test="$maxValue != ''">
											bis <xsl:value-of select="$maxValue"/>
										</xsl:if>
										<xsl:if test="$Meldungen = '1' and $minValue != '' and not($minValue castable as xs:dateTime)">
											<xsl:call-template name="meldung">
												<xsl:with-param name="nummer">1079</xsl:with-param>
											</xsl:call-template>
										</xsl:if>
										<xsl:if test="$Meldungen = '1' and $maxValue != '' and not($maxValue castable as xs:dateTime)">
											<xsl:call-template name="meldung">
												<xsl:with-param name="nummer">1080</xsl:with-param>
											</xsl:call-template>
										</xsl:if>
										<xsl:if test="$Meldungen = '1' and $minValue != '' and $maxValue != '' and ($minValue castable as xs:dateTime) and ($maxValue castable as xs:dateTime) and ($minValue cast as xs:dateTime &gt; $maxValue cast as xs:dateTime)">
											<xsl:call-template name="meldung">
												<xsl:with-param name="nummer">1064</xsl:with-param>
											</xsl:call-template>
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
											<xsl:call-template name="meldung">
												<xsl:with-param name="nummer">1081</xsl:with-param>
											</xsl:call-template>
										</xsl:if>
										<xsl:if test="$Meldungen = '1' and $maxValue != '' and not($maxValue castable as xs:time)">
											<xsl:call-template name="meldung">
												<xsl:with-param name="nummer">1082</xsl:with-param>
											</xsl:call-template>
										</xsl:if>
										<xsl:if test="$Meldungen = '1' and $minValue != '' and $maxValue != '' and ($minValue castable as xs:time) and ($maxValue castable as xs:time) and ($minValue cast as xs:time &gt; $maxValue cast as xs:time)">
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
								<xsl:when test="$Element/xdf3:datentyp/code/text() = 'num' or $Element/xdf3:datentyp/code/text() = 'num_int' or $Element/xdf3:datentyp/code/text() = 'num_currency'">
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
						<xsl:value-of select="$Element/xdf3:praezisierung/@pattern"/>
						<xsl:if test="$Meldungen = '1' and $Element/xdf3:praezisierung/@pattern and $Element/xdf3:praezisierung/@pattern != '' and ($Element/xdf3:datentyp/code/text() = 'file' or $Element/xdf3:datentyp/code/text() = 'obj')">
							<xsl:call-template name="meldung">
								<xsl:with-param name="nummer">1120</xsl:with-param>
							</xsl:call-template>
						</xsl:if>
					</td>
				</tr>
				<xsl:if test="$Element/xdf3:werte">
					<tr>
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
												<xsl:if test="$Meldungen = '1' and not(empty(./xdf3:hilfe/text())) and ./xdf3:name/text() = ./xdf3:hilfe/text()">
													<xsl:call-template name="meldung">
														<xsl:with-param name="nummer">1099</xsl:with-param>
													</xsl:call-template>
												</xsl:if>
											</td>
										</tr>
									</xsl:for-each>
								</tbody>
							</table>
							<xsl:if test="$Meldungen = '1'">
								<xsl:if test="$Element/xdf3:feldart/code/text() != 'select'">
									<xsl:call-template name="meldung">
										<xsl:with-param name="nummer">1017</xsl:with-param>
									</xsl:call-template>
								</xsl:if>
								<xsl:if test="$Meldungen = '1'and $Element/xdf3:feldart/code/text() = 'select' and $Element/xdf3:codelisteReferenz">
									<xsl:call-template name="meldung">
										<xsl:with-param name="nummer">1018</xsl:with-param>
									</xsl:call-template>
								</xsl:if>
								<xsl:if test="count($Element/xdf3:werte/xdf3:wert) &lt; 2">
									<xsl:call-template name="meldung">
										<xsl:with-param name="nummer">1044</xsl:with-param>
									</xsl:call-template>
								</xsl:if>
								<xsl:if test="count(distinct-values($Element/xdf3:werte/xdf3:wert/xdf3:code)) &lt; count($Element/xdf3:werte/xdf3:wert/xdf3:code)">
									<xsl:call-template name="meldung">
										<xsl:with-param name="nummer">1045</xsl:with-param>
									</xsl:call-template>
								</xsl:if>
								<xsl:if test="count(distinct-values($Element/xdf3:werte/xdf3:wert/xdf3:name)) &lt; count($Element/xdf3:werte/xdf3:wert/xdf3:name)">
									<xsl:call-template name="meldung">
										<xsl:with-param name="nummer">1093</xsl:with-param>
									</xsl:call-template>
								</xsl:if>
							</xsl:if>
						</td>
					</tr>
				</xsl:if>
				<xsl:if test="$Element/xdf3:codelisteReferenz">
					<tr>
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
								<xsl:call-template name="meldung">
									<xsl:with-param name="nummer">1017</xsl:with-param>
								</xsl:call-template>
							</xsl:if>
							<xsl:if test="$Meldungen = '1'and $Element/xdf3:feldart/code/text() = 'select' and $Element/xdf3:werte">
								<xsl:call-template name="meldung">
									<xsl:with-param name="nummer">1018</xsl:with-param>
								</xsl:call-template>
							</xsl:if>
						</td>
					</tr>
				</xsl:if>
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
									<xsl:choose>
										<xsl:when test="$Meldungen = '1'">
											<xsl:variable name="RichtigeVersion">
												<xsl:choose>
													<xsl:when test="empty($Element/xdf3:codelisteReferenz/xdf3:version/text())">
														<xsl:variable name="CodelisteAbfrageURL" select="fn:concat($XMLXRepoOhneVersionPfadPrefix,$Element/xdf3:codelisteReferenz/xdf3:canonicalIdentification,$XMLXRepoOhneVersionPfadPostfix)"/>
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

											<xsl:variable name="NormalisierteURN" select="fn:replace($Element/xdf3:codelisteReferenz/xdf3:canonicalIdentification,':','.')"/>
											<xsl:variable name="CodelisteDatei" select="fn:concat($InputPfad,$NormalisierteURN,'_',$RichtigeVersion,'.xml')"/>
											<xsl:variable name="CodelisteURL" select="fn:concat($XMLXRepoMitVersionPfadPrefix,$Element/xdf3:codelisteReferenz/xdf3:canonicalIdentification,'_',$RichtigeVersion,$XMLXRepoMitVersionPfadPostfix)"/>
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
													<tr>
														<td colspan="2">
															<xsl:call-template name="meldung">
																<xsl:with-param name="nummer">1115</xsl:with-param>
															</xsl:call-template>
														</td>
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
												</xsl:when>
												<xsl:otherwise>
													<tr>
														<td>
															Code
														</td>
														<td>
															<xsl:value-of select="$Element/xdf3:codeKey"/>
															<xsl:if test="not($CodelisteInhalt/*/ColumnSet/Column[./@Id = $Element/xdf3:codeKey]) and not($CodelisteInhalt/*/gc:ColumnSet/gc:Column[./@Id = $Element/xdf3:codeKey])">
																<xsl:choose>
																	<xsl:when test="empty($Element/xdf3:codelisteReferenz/xdf3:version/text())">
																		<xsl:call-template name="meldung">
																			<xsl:with-param name="nummer">1123</xsl:with-param>
																		</xsl:call-template>
																	</xsl:when>
																	<xsl:otherwise>
																		<xsl:call-template name="meldung">
																			<xsl:with-param name="nummer">1122</xsl:with-param>
																		</xsl:call-template>
																	</xsl:otherwise>
																</xsl:choose>
															</xsl:if>
														</td>
													</tr>
													<tr>
														<td>
															Name
														</td>
														<td>
															<xsl:value-of select="$Element/xdf3:nameKey"/>
															<xsl:if test="not($CodelisteInhalt/*/ColumnSet/Column[./@Id = $Element/xdf3:nameKey]) and not($CodelisteInhalt/*/gc:ColumnSet/gc:Column[./@Id = $Element/xdf3:nameKey])">
																<xsl:choose>
																	<xsl:when test="empty($Element/xdf3:codelisteReferenz/xdf3:version/text())">
																		<xsl:call-template name="meldung">
																			<xsl:with-param name="nummer">1123</xsl:with-param>
																		</xsl:call-template>
																	</xsl:when>
																	<xsl:otherwise>
																		<xsl:call-template name="meldung">
																			<xsl:with-param name="nummer">1122</xsl:with-param>
																		</xsl:call-template>
																	</xsl:otherwise>
																</xsl:choose>
															</xsl:if>
														</td>
													</tr>
													<tr>
														<td>
															Hilfetext
														</td>
														<td>
															<xsl:value-of select="$Element/xdf3:helpKey"/>
															<xsl:if test="not($CodelisteInhalt/*/ColumnSet/Column[./@Id = $Element/xdf3:helpKey]) and not($CodelisteInhalt/*/gc:ColumnSet/gc:Column[./@Id = $Element/xdf3:helpKey])">
																<xsl:choose>
																	<xsl:when test="empty($Element/xdf3:codelisteReferenz/xdf3:version/text())">
																		<xsl:call-template name="meldung">
																			<xsl:with-param name="nummer">1123</xsl:with-param>
																		</xsl:call-template>
																	</xsl:when>
																	<xsl:otherwise>
																		<xsl:call-template name="meldung">
																			<xsl:with-param name="nummer">1122</xsl:with-param>
																		</xsl:call-template>
																	</xsl:otherwise>
																</xsl:choose>
															</xsl:if>
														</td>
													</tr>
												</xsl:otherwise>
											</xsl:choose>
										</xsl:when>
										<xsl:otherwise>
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
										</xsl:otherwise>
									</xsl:choose>
								</tbody>
							</table>
							<xsl:if test="$Meldungen = '1' and not($Element/xdf3:codelisteReferenz)">
								<xsl:call-template name="meldung">
									<xsl:with-param name="nummer">1058</xsl:with-param>
								</xsl:call-template>
							</xsl:if>
						</xsl:if>
					</td>
				</tr>
				<xsl:if test="$Element/xdf3:feldart/code/text() = 'select' and not($Element/xdf3:codelisteReferenz or $Element/xdf3:werte)">
					<tr>
						<td>Werteliste /<br/>Referenzierte Codeliste</td>
						<td>
							<xsl:if test="$Meldungen = '1'">
								<xsl:call-template name="meldung">
									<xsl:with-param name="nummer">1018</xsl:with-param>
								</xsl:call-template>
							</xsl:if>
						</td>
					</tr>
				</xsl:if>
				<tr>
					<td>Inhalt</td>
					<xsl:choose>
						<xsl:when test="$Element/xdf3:feldart/code/text() = 'label' and empty($Element/xdf3:inhalt/text())">
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
										<xsl:when test="$Element/xdf3:datentyp/code/text() = 'num_int'">
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
										<xsl:when test="$Element/xdf3:datentyp/code/text() = 'date'">
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
										<xsl:when test="$Element/xdf3:datentyp/code/text() = 'datetime'">
											<xsl:if test="$Inhalt != '' and not($Inhalt castable as xs:dateTime)">
												<xsl:call-template name="meldung">
													<xsl:with-param name="nummer">1083</xsl:with-param>
												</xsl:call-template>
											</xsl:if>
											<xsl:if test="$Inhalt != '' and $minValue != '' and ($Inhalt castable as xs:dateTime) and ($minValue castable as xs:dateTime) and ($minValue cast as xs:dateTime &gt; $Inhalt cast as xs:dateTime)">
												<xsl:call-template name="meldung">
													<xsl:with-param name="nummer">1072</xsl:with-param>
												</xsl:call-template>
											</xsl:if>
											<xsl:if test="$Inhalt != '' and $maxValue != '' and ($Inhalt castable as xs:dateTime) and ($maxValue castable as xs:dateTime) and ($maxValue cast as xs:dateTime &lt; $Inhalt cast as xs:dateTime)">
												<xsl:call-template name="meldung">
													<xsl:with-param name="nummer">1073</xsl:with-param>
												</xsl:call-template>
											</xsl:if>
										</xsl:when>
										<xsl:when test="$Element/xdf3:datentyp/code/text() = 'time'">
											<xsl:if test="$Inhalt != '' and not($Inhalt castable as xs:time)">
												<xsl:call-template name="meldung">
													<xsl:with-param name="nummer">1084</xsl:with-param>
												</xsl:call-template>
											</xsl:if>
											<xsl:if test="$Inhalt != '' and $minValue != '' and ($Inhalt castable as xs:time) and ($minValue castable as xs:time) and ($minValue cast as xs:time &gt; $Inhalt cast as xs:time)">
												<xsl:call-template name="meldung">
													<xsl:with-param name="nummer">1072</xsl:with-param>
												</xsl:call-template>
											</xsl:if>
											<xsl:if test="$Inhalt != '' and $maxValue != '' and ($Inhalt castable as xs:time) and ($maxValue castable as xs:time) and ($maxValue cast as xs:time &lt; $Inhalt cast as xs:time)">
												<xsl:call-template name="meldung">
													<xsl:with-param name="nummer">1073</xsl:with-param>
												</xsl:call-template>
											</xsl:if>
										</xsl:when>
										<xsl:when test="$Element/xdf3:datentyp/code/text() = 'text' or $Element/xdf3:datentyp/code/text() = 'text_latin'">
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
										<xsl:when test="$Element/xdf3:datentyp/code/text() = 'bool'">
											<xsl:if test="$Inhalt != '' and not($Inhalt castable as xs:boolean)">
												<xsl:call-template name="meldung">
													<xsl:with-param name="nummer">1077</xsl:with-param>
												</xsl:call-template>
											</xsl:if>
										</xsl:when>
										<xsl:when test="$Element/xdf3:datentyp/code/text() = 'file' or $Element/xdf3:datentyp/code/text() = 'obj'">
											<xsl:if test="$Inhalt != ''">
												<xsl:call-template name="meldung">
													<xsl:with-param name="nummer">1100</xsl:with-param>
												</xsl:call-template>
											</xsl:if>
										</xsl:when>
									</xsl:choose>
									<xsl:choose>
										<xsl:when test="$Element/xdf3:feldart/code/text() = 'select' and $Element/xdf3:werte and fn:not($Element/xdf3:werte/xdf3:wert[xdf3:code/text() = $Inhalt])">
											<xsl:call-template name="meldung">
												<xsl:with-param name="nummer">1085</xsl:with-param>
											</xsl:call-template>
										</xsl:when>
										<xsl:when test="$Element/xdf3:feldart/code/text() = 'select' and $Element/xdf3:codelisteReferenz">
										
											<xsl:variable name="RichtigeVersion">
												<xsl:choose>
													<xsl:when test="empty($Element/xdf3:codelisteReferenz/xdf3:version/text())">
														<xsl:variable name="CodelisteAbfrageURL" select="fn:concat($XMLXRepoOhneVersionPfadPrefix,$Element/xdf3:codelisteReferenz/xdf3:canonicalIdentification,$XMLXRepoOhneVersionPfadPostfix)"/>
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

											<xsl:variable name="NormalisierteURN" select="fn:replace($Element/xdf3:codelisteReferenz/xdf3:canonicalIdentification,':','.')"/>
											<xsl:variable name="CodelisteDatei" select="fn:concat($InputPfad,$NormalisierteURN,'_',$RichtigeVersion,'.xml')"/>
											<xsl:variable name="CodelisteURL" select="fn:concat($XMLXRepoMitVersionPfadPrefix,$Element/xdf3:codelisteReferenz/xdf3:canonicalIdentification,'_',$RichtigeVersion,$XMLXRepoMitVersionPfadPostfix)"/>
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
													<xsl:call-template name="meldung">
														<xsl:with-param name="nummer">1115</xsl:with-param>
													</xsl:call-template>
												</xsl:when>
												<xsl:otherwise>
													<xsl:variable name="NameCodeKey"><xsl:value-of select="$CodelisteInhalt/*/gc:ColumnSet/gc:Key[1]/gc:ColumnRef/@Ref"/><xsl:value-of select="$CodelisteInhalt/*/ColumnSet/Key[1]/ColumnRef/@Ref"/></xsl:variable>
		
													<xsl:if test="count($CodelisteInhalt/*/gc:SimpleCodeList/gc:Row/gc:Value[./@ColumnRef = $NameCodeKey]/gc:SimpleValue[./text() = $Inhalt]) = 0 and count($CodelisteInhalt/*/SimpleCodeList/Row/Value[./@ColumnRef = $NameCodeKey]/SimpleValue[./text() = $Inhalt]) = 0">
														<xsl:choose>
															<xsl:when test="empty($Element/xdf3:codelisteReferenz/xdf3:version/text())">
																<xsl:call-template name="meldung">
																	<xsl:with-param name="nummer">1121</xsl:with-param>
																</xsl:call-template>
															</xsl:when>
															<xsl:otherwise>
																<xsl:call-template name="meldung">
																	<xsl:with-param name="nummer">1076</xsl:with-param>
																</xsl:call-template>
															</xsl:otherwise>
														</xsl:choose>
													</xsl:if>
			
												</xsl:otherwise>
											</xsl:choose>
										
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
								<xsl:value-of select="fn:format-number(number($Element/xdf3:maxSize) div 1000000,'###.###,00', 'european')"/> MB
								<xsl:if test="$Meldungen = '1' and $Element/xdf3:datentyp/code/text() != 'file'">
									<xsl:call-template name="meldung">
										<xsl:with-param name="nummer">1056</xsl:with-param>
									</xsl:call-template>
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
									<xsl:call-template name="meldung">
										<xsl:with-param name="nummer">1057</xsl:with-param>
									</xsl:call-template>
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
						<xsl:choose>
							<xsl:when test="empty($Element/xdf3:vorbefuellung/code/text())">
								<xsl:if test="$Meldungen = '1'">
									<xsl:call-template name="meldung">
										<xsl:with-param name="nummer">1030</xsl:with-param>
									</xsl:call-template>
								</xsl:if>
							</xsl:when>
							<xsl:otherwise>
								<xsl:apply-templates select="$Element/xdf3:vorbefuellung"/>
							</xsl:otherwise>
						</xsl:choose>
					</td>
				</tr>
				<tr>
					<td>Beschreibung</td>
					<td>
						<xsl:value-of select="fn:replace($Element/xdf3:beschreibung,'\n','&lt;br/&gt;')" disable-output-escaping="yes"/>
						<xsl:call-template name="PruefeStringLatin">
							<xsl:with-param name="PruefString" select="$Element/xdf3:beschreibung"/>
						</xsl:call-template>
					</td>
				</tr>
				<tr>
					<td>Bezeichnung Eingabe</td>
					<xsl:choose>
						<xsl:when test="empty($Element/xdf3:bezeichnungEingabe/text())">
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
								<xsl:value-of select="$Element/xdf3:bezeichnungEingabe"/>
								<xsl:call-template name="PruefeStringLatin">
									<xsl:with-param name="PruefString" select="$Element/xdf3:bezeichnungEingabe"/>
								</xsl:call-template>
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
									<xsl:call-template name="meldung">
										<xsl:with-param name="nummer">1010</xsl:with-param>
									</xsl:call-template>
								</xsl:if>
							</td>
						</xsl:when>
						<xsl:otherwise>
							<td>
								<xsl:value-of select="$Element/xdf3:bezeichnungAusgabe"/>
								<xsl:call-template name="PruefeStringLatin">
									<xsl:with-param name="PruefString" select="$Element/xdf3:bezeichnungAusgabe"/>
								</xsl:call-template>
							</td>
						</xsl:otherwise>
					</xsl:choose>
				</tr>
				<tr>
					<td>Hilfetext Eingabe</td>
					<td>
						<xsl:value-of select="fn:replace($Element/xdf3:hilfetextEingabe,'\n','&lt;br/&gt;')" disable-output-escaping="yes"/>
						<xsl:if test="$Meldungen = '1' and not(empty($Element/xdf3:hilfetextEingabe/text())) and $Element/xdf3:bezeichnungEingabe/text() = $Element/xdf3:hilfetextEingabe/text()">
							<xsl:call-template name="meldung">
								<xsl:with-param name="nummer">1098</xsl:with-param>
							</xsl:call-template>
						</xsl:if>
						<xsl:call-template name="PruefeStringLatin">
							<xsl:with-param name="PruefString" select="$Element/xdf3:hilfetextEingabe"/>
						</xsl:call-template>
					</td>
				</tr>
				<tr>
					<td>Hilfetext Ausgabe</td>
					<td>
						<xsl:value-of select="fn:replace($Element/xdf3:hilfetextAusgabe,'\n','&lt;br/&gt;')" disable-output-escaping="yes"/>
						<xsl:if test="$Meldungen = '1' and not(empty($Element/xdf3:hilfetextAusgabe/text())) and $Element/xdf3:bezeichnungAusgabe/text() = $Element/xdf3:hilfetextAusgabe/text()">
							<xsl:call-template name="meldung">
								<xsl:with-param name="nummer">1098</xsl:with-param>
							</xsl:call-template>
						</xsl:if>
						<xsl:call-template name="PruefeStringLatin">
							<xsl:with-param name="PruefString" select="$Element/xdf3:hilfetextAusgabe"/>
						</xsl:call-template>
					</td>
				</tr>
				<tr>
					<td>G�ltig ab</td>
					<td>
						<xsl:value-of select="fn:format-date($Element/xdf3:gueltigAb,'[D01].[M01].[Y0001]')"/>
					</td>
				</tr>
				<tr>
					<td>G�ltig bis</td>
					<td>
						<xsl:value-of select="fn:format-date($Element/xdf3:gueltigBis,'[D01].[M01].[Y0001]')"/>
					</td>
				</tr>
				<tr>
					<td>Fachlicher Ersteller</td>
					<xsl:choose>
						<xsl:when test="empty($Element/xdf3:statusGesetztDurch/text()) and $VersionsHinweise ='1'">
							<td>
								<xsl:value-of select="$Element/xdf3:statusGesetztDurch"/>
								<xsl:if test="$Meldungen = '1'">
									<xsl:call-template name="meldung">
										<xsl:with-param name="nummer">1117</xsl:with-param>
									</xsl:call-template>
								</xsl:if>
							</td>
						</xsl:when>
						<xsl:otherwise>
							<td>
								<xsl:value-of select="$Element/xdf3:statusGesetztDurch"/>
								<xsl:call-template name="PruefeStringLatin">
									<xsl:with-param name="PruefString" select="$Element/xdf3:statusGesetztDurch"/>
								</xsl:call-template>
							</td>
						</xsl:otherwise>
					</xsl:choose>
				</tr>
				<tr>
					<td>Status</td>
					<td>
						<xsl:choose>
							<xsl:when test="empty($Element/xdf3:freigabestatus/code/text())">
								<xsl:if test="$Meldungen = '1'">
									<xsl:call-template name="meldung">
										<xsl:with-param name="nummer">1032</xsl:with-param>
									</xsl:call-template>
									<xsl:choose>
										<xsl:when test="$VoeDS !=''">
											<xsl:call-template name="meldung">
												<xsl:with-param name="nummer">1129</xsl:with-param>
											</xsl:call-template>
										</xsl:when>
										<xsl:when test="$VoeFG != ''">
											<xsl:call-template name="meldung">
												<xsl:with-param name="nummer">1130</xsl:with-param>
											</xsl:call-template>
										</xsl:when>
										<xsl:otherwise></xsl:otherwise>
									</xsl:choose>
								</xsl:if>
							</xsl:when>
							<xsl:otherwise>
								<xsl:apply-templates select="$Element/xdf3:freigabestatus"/>
								<xsl:if test="$Meldungen = '1' and fn:number($Element/xdf3:freigabestatus/code) &lt; 3" >
									<xsl:choose>
										<xsl:when test="$VoeDS !=''">
											<xsl:call-template name="meldung">
												<xsl:with-param name="nummer">1129</xsl:with-param>
											</xsl:call-template>
										</xsl:when>
										<xsl:when test="$VoeFG != ''">
											<xsl:call-template name="meldung">
												<xsl:with-param name="nummer">1130</xsl:with-param>
											</xsl:call-template>
										</xsl:when>
										<xsl:otherwise></xsl:otherwise>
									</xsl:choose>
								</xsl:if>
							</xsl:otherwise>
						</xsl:choose>
					</td>
				</tr>
				<tr>
					<td>Status gesetzt am</td>
					<td>
						<xsl:value-of select="fn:format-date($Element/xdf3:statusGesetztAm,'[D01].[M01].[Y0001]')"/>
					</td>
				</tr>
				<tr>
					<td>Ver�ffentlichungsdatum</td>
					<td>
						<xsl:value-of select="fn:format-date($Element/xdf3:veroeffentlichungsdatum,'[D01].[M01].[Y0001]')"/>
						<xsl:if test="$Meldungen = '1' and empty($Element/xdf3:veroeffentlichungsdatum/text())" >
							<xsl:choose>
								<xsl:when test="$VoeDS !=''">
									<xsl:call-template name="meldung">
										<xsl:with-param name="nummer">1127</xsl:with-param>
									</xsl:call-template>
								</xsl:when>
								<xsl:when test="$VoeFG != ''">
									<xsl:call-template name="meldung">
										<xsl:with-param name="nummer">1128</xsl:with-param>
									</xsl:call-template>
								</xsl:when>
								<xsl:otherwise></xsl:otherwise>
							</xsl:choose>
						</xsl:if>
					</td>
				</tr>
				<tr>
					<td>Letzte �nderung</td>
					<td>
						<xsl:value-of select="fn:format-dateTime(fn:adjust-dateTime-to-timezone($Element/xdf3:letzteAenderung,xs:dayTimeDuration($Zeitzone)),'[D01].[M01].[Y0001] um [H01]:[m01] Uhr')"/>
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
												<xsl:choose>
													<xsl:when test="empty(./xdf3:objekt/xdf3:id/text())">
														<xsl:if test="$Meldungen = '1'">
															<xsl:call-template name="meldung">
																<xsl:with-param name="nummer">1091</xsl:with-param>
															</xsl:call-template>
														</xsl:if>
													</xsl:when>
													<xsl:otherwise>
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
													</xsl:otherwise>
												</xsl:choose>
											</td>
											<td>
												<xsl:value-of select="./xdf3:objekt/xdf3:version"/>
											</td>
											<td>
												<xsl:choose>
													<xsl:when test="empty(./xdf3:praedikat/code/text())">
														<xsl:if test="$Meldungen = '1'">
															<xsl:call-template name="meldung">
																<xsl:with-param name="nummer">1029</xsl:with-param>
															</xsl:call-template>
														</xsl:if>
													</xsl:when>
													<xsl:otherwise>
														<xsl:apply-templates select="./xdf3:praedikat"/>
														<xsl:if test="$Meldungen = '1' and ./xdf3:praedikat/code = 'VKN'">
															<xsl:call-template name="meldung">
																<xsl:with-param name="nummer">1088</xsl:with-param>
															</xsl:call-template>
														</xsl:if>
													</xsl:otherwise>
												</xsl:choose>
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
															<xsl:for-each select="$MeldungenInhalt/gc:CodeList/*:SimpleCodeList/*:Row[*:Value/@ColumnRef ='Code' and *:Value/*:SimpleValue = '1001']">
																<xsl:choose>
																	<xsl:when test="./*:Value[@ColumnRef ='Typ']/*:SimpleValue = 'FehlerKritisch'">
																		<div class="FehlerKritisch M1001">
																			FehlerKritisch!! 1001: <xsl:value-of select="./*:Value[@ColumnRef ='Meldungstext']/*:SimpleValue"/> Nicht-erreichbares Element: <xsl:value-of select="$TestElement"/>
																			<xsl:if test="$QSHilfeAufruf = '1'">
																				&#160;&#160;
																				<xsl:element name="a">
																					<xsl:attribute name="href"><xsl:value-of  select="$QSHilfePfadPrefix"/>M1001<xsl:value-of select="$QSHilfePfadPostfix"/></xsl:attribute>
																					<xsl:attribute name="target">MeldungsHilfe</xsl:attribute>
																					<xsl:attribute name="title">Springe zu den Erl�uterungen der Meldungscodes in die Qualit�tskriterien.</xsl:attribute>
																					&#8658;
																				</xsl:element>&#160;&#160;&#160;&#160;
																			</xsl:if>
																		</div>
																	</xsl:when>
																	<xsl:when test="./*:Value[@ColumnRef ='Typ']/*:SimpleValue = 'FehlerMethodisch'">
																		<div class="FehlerMethodisch M1001">
																			FehlerMethodisch!! 1001: <xsl:value-of select="./*:Value[@ColumnRef ='Meldungstext']/*:SimpleValue"/> Nicht-erreichbares Element: <xsl:value-of select="$TestElement"/>
																			<xsl:if test="$QSHilfeAufruf = '1'">
																				&#160;&#160;
																				<xsl:element name="a">
																					<xsl:attribute name="href"><xsl:value-of  select="$QSHilfePfadPrefix"/>M1001<xsl:value-of select="$QSHilfePfadPostfix"/></xsl:attribute>
																					<xsl:attribute name="target">MeldungsHilfe</xsl:attribute>
																					<xsl:attribute name="title">Springe zu den Erl�uterungen der Meldungscodes in die Qualit�tskriterien.</xsl:attribute>
																					&#8658;
																				</xsl:element>&#160;&#160;&#160;&#160;
																			</xsl:if>
																		</div>
																	</xsl:when>
																	<xsl:when test="./*:Value[@ColumnRef ='Typ']/*:SimpleValue = 'Warnung'">
																		<div class="Warnung M1001">
																			Warnung!! 1001: <xsl:value-of select="./*:Value[@ColumnRef ='Meldungstext']/*:SimpleValue"/> Nicht-erreichbares Element: <xsl:value-of select="$TestElement"/>
																			<xsl:if test="$QSHilfeAufruf = '1'">
																				&#160;&#160;
																				<xsl:element name="a">
																					<xsl:attribute name="href"><xsl:value-of  select="$QSHilfePfadPrefix"/>M1001<xsl:value-of select="$QSHilfePfadPostfix"/></xsl:attribute>
																					<xsl:attribute name="target">MeldungsHilfe</xsl:attribute>
																					<xsl:attribute name="title">Springe zu den Erl�uterungen der Meldungscodes in die Qualit�tskriterien.</xsl:attribute>
																					&#8658;
																				</xsl:element>&#160;&#160;&#160;&#160;
																			</xsl:if>
																		</div>
																	</xsl:when>
																	<xsl:when test="./*:Value[@ColumnRef ='Typ']/*:SimpleValue = 'Hinweis'">
																		<div class="Hinweis M1001">
																			Hinweis!! 1001: <xsl:value-of select="./*:Value[@ColumnRef ='Meldungstext']/*:SimpleValue"/> Nicht-erreichbares Element: <xsl:value-of select="$TestElement"/>
																			<xsl:if test="$QSHilfeAufruf = '1'">
																				&#160;&#160;
																				<xsl:element name="a">
																					<xsl:attribute name="href"><xsl:value-of  select="$QSHilfePfadPrefix"/>M1001<xsl:value-of select="$QSHilfePfadPostfix"/></xsl:attribute>
																					<xsl:attribute name="target">MeldungsHilfe</xsl:attribute>
																					<xsl:attribute name="title">Springe zu den Erl�uterungen der Meldungscodes in die Qualit�tskriterien.</xsl:attribute>
																					&#8658;
																				</xsl:element>&#160;&#160;&#160;&#160;
																			</xsl:if>
																		</div>
																	</xsl:when>
																	<xsl:when test="./*:Value[@ColumnRef ='Typ']/*:SimpleValue = 'Deaktiviert'">
																	</xsl:when>
																	<xsl:otherwise>
																		<div class="Hinweis M1001">Hinweis!! 1001: Unbekannte Meldung!</div>
																	</xsl:otherwise>
																</xsl:choose>
															</xsl:for-each>
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
														<xsl:variable name="BaukastenElement" select="."/>
														<xsl:for-each select="$MeldungenInhalt/gc:CodeList/*:SimpleCodeList/*:Row[*:Value/@ColumnRef ='Code' and *:Value/*:SimpleValue = '1019']">
															<xsl:choose>
																<xsl:when test="./*:Value[@ColumnRef ='Typ']/*:SimpleValue = 'FehlerKritisch'">
																	<div class="FehlerKritisch M1019">
																		FehlerKritisch!! 1019: <xsl:value-of select="./*:Value[@ColumnRef ='Meldungstext']/*:SimpleValue"/> Betroffenes Element: <xsl:value-of select="$BaukastenElement"/>
																		<xsl:if test="$QSHilfeAufruf = '1'">
																			&#160;&#160;
																			<xsl:element name="a">
																				<xsl:attribute name="href"><xsl:value-of  select="$QSHilfePfadPrefix"/>M1019<xsl:value-of select="$QSHilfePfadPostfix"/></xsl:attribute>
																				<xsl:attribute name="target">MeldungsHilfe</xsl:attribute>
																				<xsl:attribute name="title">Springe zu den Erl�uterungen der Meldungscodes in die Qualit�tskriterien.</xsl:attribute>
																				&#8658;
																			</xsl:element>&#160;&#160;&#160;&#160;
																		</xsl:if>
																	</div>
																</xsl:when>
																<xsl:when test="./*:Value[@ColumnRef ='Typ']/*:SimpleValue = 'FehlerMethodisch'">
																	<div class="FehlerMethodisch M1019">
																		FehlerMethodisch!! 1019: <xsl:value-of select="./*:Value[@ColumnRef ='Meldungstext']/*:SimpleValue"/> Betroffenes Element: <xsl:value-of select="$BaukastenElement"/>
																		<xsl:if test="$QSHilfeAufruf = '1'">
																			&#160;&#160;
																			<xsl:element name="a">
																				<xsl:attribute name="href"><xsl:value-of  select="$QSHilfePfadPrefix"/>M1019<xsl:value-of select="$QSHilfePfadPostfix"/></xsl:attribute>
																				<xsl:attribute name="target">MeldungsHilfe</xsl:attribute>
																				<xsl:attribute name="title">Springe zu den Erl�uterungen der Meldungscodes in die Qualit�tskriterien.</xsl:attribute>
																				&#8658;
																			</xsl:element>&#160;&#160;&#160;&#160;
																		</xsl:if>
																	</div>
																</xsl:when>
																<xsl:when test="./*:Value[@ColumnRef ='Typ']/*:SimpleValue = 'Warnung'">
																	<div class="Warnung M1019">
																		Warnung!! 1019: <xsl:value-of select="./*:Value[@ColumnRef ='Meldungstext']/*:SimpleValue"/> Betroffenes Element: <xsl:value-of select="$BaukastenElement"/>
																		<xsl:if test="$QSHilfeAufruf = '1'">
																			&#160;&#160;
																			<xsl:element name="a">
																				<xsl:attribute name="href"><xsl:value-of  select="$QSHilfePfadPrefix"/>M1019<xsl:value-of select="$QSHilfePfadPostfix"/></xsl:attribute>
																				<xsl:attribute name="target">MeldungsHilfe</xsl:attribute>
																				<xsl:attribute name="title">Springe zu den Erl�uterungen der Meldungscodes in die Qualit�tskriterien.</xsl:attribute>
																				&#8658;
																			</xsl:element>&#160;&#160;&#160;&#160;
																		</xsl:if>
																	</div>
																</xsl:when>
																<xsl:when test="./*:Value[@ColumnRef ='Typ']/*:SimpleValue = 'Hinweis'">
																	<div class="Hinweis M1019">
																		Hinweis!! 1019: <xsl:value-of select="./*:Value[@ColumnRef ='Meldungstext']/*:SimpleValue"/> Betroffenes Element: <xsl:value-of select="$BaukastenElement"/>
																		<xsl:if test="$QSHilfeAufruf = '1'">
																			&#160;&#160;
																			<xsl:element name="a">
																				<xsl:attribute name="href"><xsl:value-of  select="$QSHilfePfadPrefix"/>M1019<xsl:value-of select="$QSHilfePfadPostfix"/></xsl:attribute>
																				<xsl:attribute name="target">MeldungsHilfe</xsl:attribute>
																				<xsl:attribute name="title">Springe zu den Erl�uterungen der Meldungscodes in die Qualit�tskriterien.</xsl:attribute>
																				&#8658;
																			</xsl:element>&#160;&#160;&#160;&#160;
																		</xsl:if>
																	</div>
																</xsl:when>
																<xsl:otherwise>
																	<div class="Hinweis M1019">Hinweis!! 1019: Unbekannte Meldung!</div>
																</xsl:otherwise>
															</xsl:choose>
														</xsl:for-each>
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
														<xsl:variable name="BaukastenElement" select="."/>
														<xsl:for-each select="$MeldungenInhalt/gc:CodeList/*:SimpleCodeList/*:Row[*:Value/@ColumnRef ='Code' and *:Value/*:SimpleValue = '1041']">
															<xsl:choose>
																<xsl:when test="./*:Value[@ColumnRef ='Typ']/*:SimpleValue = 'FehlerKritisch'">
																	<div class="FehlerKritisch M1041">
																		FehlerKritisch!! 1041: <xsl:value-of select="./*:Value[@ColumnRef ='Meldungstext']/*:SimpleValue"/> Betroffenes Element: <xsl:value-of select="fn:substring($BaukastenElement,1,9)"/>
																		<xsl:if test="$QSHilfeAufruf = '1'">
																			&#160;&#160;
																			<xsl:element name="a">
																				<xsl:attribute name="href"><xsl:value-of  select="$QSHilfePfadPrefix"/>M1041<xsl:value-of select="$QSHilfePfadPostfix"/></xsl:attribute>
																				<xsl:attribute name="target">MeldungsHilfe</xsl:attribute>
																				<xsl:attribute name="title">Springe zu den Erl�uterungen der Meldungscodes in die Qualit�tskriterien.</xsl:attribute>
																				&#8658;
																			</xsl:element>&#160;&#160;&#160;&#160;
																		</xsl:if>
																	</div>
																</xsl:when>
																<xsl:when test="./*:Value[@ColumnRef ='Typ']/*:SimpleValue = 'FehlerMethodisch'">
																	<div class="FehlerMethodisch M1041">
																		FehlerMethodisch!! 1041: <xsl:value-of select="./*:Value[@ColumnRef ='Meldungstext']/*:SimpleValue"/> Betroffenes Element: <xsl:value-of select="fn:substring($BaukastenElement,1,9)"/>
																		<xsl:if test="$QSHilfeAufruf = '1'">
																			&#160;&#160;
																			<xsl:element name="a">
																				<xsl:attribute name="href"><xsl:value-of  select="$QSHilfePfadPrefix"/>M1041<xsl:value-of select="$QSHilfePfadPostfix"/></xsl:attribute>
																				<xsl:attribute name="target">MeldungsHilfe</xsl:attribute>
																				<xsl:attribute name="title">Springe zu den Erl�uterungen der Meldungscodes in die Qualit�tskriterien.</xsl:attribute>
																				&#8658;
																			</xsl:element>&#160;&#160;&#160;&#160;
																		</xsl:if>
																	</div>
																</xsl:when>
																<xsl:when test="./*:Value[@ColumnRef ='Typ']/*:SimpleValue = 'Warnung'">
																	<div class="Warnung M1041">
																		Warnung!! 1041: <xsl:value-of select="./*:Value[@ColumnRef ='Meldungstext']/*:SimpleValue"/> Betroffenes Element: <xsl:value-of select="fn:substring($BaukastenElement,1,9)"/>
																		<xsl:if test="$QSHilfeAufruf = '1'">
																			&#160;&#160;
																			<xsl:element name="a">
																				<xsl:attribute name="href"><xsl:value-of  select="$QSHilfePfadPrefix"/>M1041<xsl:value-of select="$QSHilfePfadPostfix"/></xsl:attribute>
																				<xsl:attribute name="target">MeldungsHilfe</xsl:attribute>
																				<xsl:attribute name="title">Springe zu den Erl�uterungen der Meldungscodes in die Qualit�tskriterien.</xsl:attribute>
																				&#8658;
																			</xsl:element>&#160;&#160;&#160;&#160;
																		</xsl:if>
																	</div>
																</xsl:when>
																<xsl:when test="./*:Value[@ColumnRef ='Typ']/*:SimpleValue = 'Hinweis'">
																	<div class="Hinweis M1041">
																		Hinweis!! 1041: <xsl:value-of select="./*:Value[@ColumnRef ='Meldungstext']/*:SimpleValue"/> Betroffenes Element: <xsl:value-of select="fn:substring($BaukastenElement,1,9)"/>
																		<xsl:if test="$QSHilfeAufruf = '1'">
																			&#160;&#160;
																			<xsl:element name="a">
																				<xsl:attribute name="href"><xsl:value-of  select="$QSHilfePfadPrefix"/>M1041<xsl:value-of select="$QSHilfePfadPostfix"/></xsl:attribute>
																				<xsl:attribute name="target">MeldungsHilfe</xsl:attribute>
																				<xsl:attribute name="title">Springe zu den Erl�uterungen der Meldungscodes in die Qualit�tskriterien.</xsl:attribute>
																				&#8658;
																			</xsl:element>&#160;&#160;&#160;&#160;
																		</xsl:if>
																	</div>
																</xsl:when>
																<xsl:otherwise>
																	<div class="Hinweis M1041">Hinweis!! 1041: Unbekannte Meldung!</div>
																</xsl:otherwise>
															</xsl:choose>
														</xsl:for-each>
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
									<xsl:when test="empty($Element/xdf3:identifikation/xdf3:version/text())">
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
							<xsl:attribute name="id"><xsl:value-of select="$Element/xdf3:identifikation/xdf3:id"/><xsl:if test="$Element/xdf3:identifikation/xdf3:version">V<xsl:value-of select="$Element/xdf3:identifikation/xdf3:version"/></xsl:if></xsl:attribute>
						</xsl:element>
													ID
												</td>
					<xsl:choose>
						<xsl:when test="empty($Element/xdf3:identifikation/xdf3:id/text())">
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
						<xsl:value-of select="$Element/xdf3:identifikation/xdf3:version"/>
						<xsl:if test="$Meldungen = '1'">
							<xsl:if test="$SammelrepositoryCheck = '1'">
								<xsl:variable name="URLBE" select="fn:concat($URLFGList,$Element/xdf3:identifikation/xdf3:id,'/latest')"/>
								
								<xsl:if test="$DebugMode = '4'">
									<xsl:message>                                  URLBE:<xsl:value-of select="$URLBE"/></xsl:message>
								</xsl:if>
	
								<xsl:variable name="BEJSON" as="xs:string">
									<xsl:try>
										<xsl:value-of select="unparsed-text($URLBE)"/>
									
										<xsl:catch>
											<xsl:value-of  select="'not found'"/>
										</xsl:catch>
									</xsl:try>
								</xsl:variable>
	
								<xsl:choose>
									<xsl:when test="$BEJSON = 'not found'">
										<xsl:if test="$DebugMode = '4'">
											<xsl:message>                                  Element in Sammelrepository nicht gefunden</xsl:message>
										</xsl:if>
									</xsl:when>
									<xsl:otherwise>
										<xsl:variable name="BEXML" select="json-to-xml($BEJSON)"/>
		
										<xsl:variable name="BELatestVersion" select="$BEXML/fn:map/*[./@key='fim_version']"/>
										<xsl:variable name="BELatestStatus" select="$BEXML/fn:map/*[./@key='freigabe_status_label']"/>
										
										<xsl:variable name="BEVersionMaj" select="number(tokenize($Element/xdf3:identifikation/xdf3:version, '\.')[1])"/>
										<xsl:variable name="BEVersionMin" select="number(tokenize($Element/xdf3:identifikation/xdf3:version, '\.')[2])"/>
										<xsl:variable name="BEVersionMic" select="number(tokenize($Element/xdf3:identifikation/xdf3:version, '\.')[3])"/>

										<xsl:variable name="BELatestMaj" select="number(tokenize($BELatestVersion, '\.')[1])"/>
										<xsl:variable name="BELatestMin" select="number(tokenize($BELatestVersion, '\.')[2])"/>
										<xsl:variable name="BELatestMic" select="number(tokenize($BELatestVersion, '\.')[3])"/>
										
										<xsl:choose>
											<xsl:when test="$BELatestMaj &gt; $BEVersionMaj">
												[Aktuelle im Sammelrepository ver�ffentlichte Version: <xsl:value-of select="$BELatestVersion"/> im Status <xsl:value-of select="$BELatestStatus"/>]
												<xsl:call-template name="meldung">
													<xsl:with-param name="nummer">1126</xsl:with-param>
												</xsl:call-template>
											</xsl:when>
											<xsl:when test="$BELatestMaj = $BEVersionMaj">
												<xsl:choose>
													<xsl:when test="$BELatestMin &gt; $BEVersionMin">
														[Aktuelle im Sammelrepository ver�ffentlichte Version: <xsl:value-of select="$BELatestVersion"/> im Status <xsl:value-of select="$BELatestStatus"/>]
														<xsl:call-template name="meldung">
															<xsl:with-param name="nummer">1126</xsl:with-param>
														</xsl:call-template>
													</xsl:when>
													<xsl:when test="$BELatestMin = $BEVersionMin">
														<xsl:choose>
															<xsl:when test="$BELatestMin &gt; $BEVersionMin">
																[Aktuelle im Sammelrepository ver�ffentlichte Version: <xsl:value-of select="$BELatestVersion"/> im Status <xsl:value-of select="$BELatestStatus"/>]
																<xsl:call-template name="meldung">
																	<xsl:with-param name="nummer">1126</xsl:with-param>
																</xsl:call-template>
															</xsl:when>
															<xsl:otherwise></xsl:otherwise>
														</xsl:choose>
													</xsl:when>
													<xsl:otherwise></xsl:otherwise>
												</xsl:choose>
											</xsl:when>
											<xsl:otherwise></xsl:otherwise>
										</xsl:choose>
										
									</xsl:otherwise>
								</xsl:choose>
							</xsl:if>
							<xsl:if test="$VersionsAnzahl &gt; 1">
								<xsl:call-template name="meldung">
									<xsl:with-param name="nummer">1003</xsl:with-param>
								</xsl:call-template>
							</xsl:if>
							<xsl:if test="$VersionsHinweise = '1'">
								<xsl:if test="not(fn:string(/*/*/xdf3:identifikation/xdf3:version)) and fn:string($Element/xdf3:identifikation/xdf3:version) and (fn:substring(./xdf3:identifikation/xdf3:id,2,2) = fn:substring(/*/*/xdf3:identifikation/xdf3:id,2,2))">
									<xsl:call-template name="meldung">
										<xsl:with-param name="nummer">1134</xsl:with-param>
									</xsl:call-template>
								</xsl:if>
							</xsl:if>
						</xsl:if>
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
									<xsl:call-template name="meldung">
										<xsl:with-param name="nummer">1002</xsl:with-param>
									</xsl:call-template>
								</xsl:if>
							</td>
						</xsl:when>
						<xsl:otherwise>
							<td class="ElementName">
								<xsl:value-of select="$Element/xdf3:name"/>
								<xsl:call-template name="PruefeStringLatin">
									<xsl:with-param name="PruefString" select="$Element/xdf3:name"/>
								</xsl:call-template>
							</td>
						</xsl:otherwise>
					</xsl:choose>
				</tr>
				<tr>
					<td>Stichw�rter</td>
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
						<xsl:call-template name="PruefeStringLatin">
							<xsl:with-param name="PruefString" select="$Element/xdf3:definition"/>
						</xsl:call-template>
					</td>
				</tr>
				<tr>
					<td>Strukturelementart</td>
					<td>
						<xsl:choose>
							<xsl:when test="empty($Element/xdf3:schemaelementart/code/text())">
								<xsl:if test="$Meldungen = '1'">
									<xsl:call-template name="meldung">
										<xsl:with-param name="nummer">1031</xsl:with-param>
									</xsl:call-template>
								</xsl:if>
							</xsl:when>
							<xsl:otherwise>
								<xsl:apply-templates select="$Element/xdf3:schemaelementart"/>
							</xsl:otherwise>
						</xsl:choose>
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
											<xsl:call-template name="meldung">
												<xsl:with-param name="nummer">1006</xsl:with-param>
											</xsl:call-template>
										</xsl:if>
									</xsl:when>
									<xsl:when test="$Element/xdf3:schemaelementart/code/text() = 'HAR'">
										<xsl:if test="$Meldungen = '1'">
											<xsl:call-template name="meldung">
												<xsl:with-param name="nummer">1101</xsl:with-param>
											</xsl:call-template>
										</xsl:if>
									</xsl:when>
									<xsl:otherwise>
									</xsl:otherwise>
								</xsl:choose>
							</xsl:when>
							<xsl:otherwise>
								<xsl:call-template name="handlungsgrundlagen">
									<xsl:with-param name="Element" select="$Element"/>
								</xsl:call-template>
							</xsl:otherwise>
						</xsl:choose>
					</td>
				</tr>
				<tr>
					<td>Beschreibung</td>
					<td>
						<xsl:value-of select="fn:replace($Element/xdf3:beschreibung,'\n','&lt;br/&gt;')" disable-output-escaping="yes"/>
						<xsl:call-template name="PruefeStringLatin">
							<xsl:with-param name="PruefString" select="$Element/xdf3:beschreibung"/>
						</xsl:call-template>
					</td>
				</tr>
				<tr>
					<td>Bezeichnung Eingabe</td>
					<xsl:choose>
						<xsl:when test="empty($Element/xdf3:bezeichnungEingabe/text())">
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
								<xsl:value-of select="$Element/xdf3:bezeichnungEingabe"/>
								<xsl:call-template name="PruefeStringLatin">
									<xsl:with-param name="PruefString" select="$Element/xdf3:bezeichnungEingabe"/>
								</xsl:call-template>
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
									<xsl:call-template name="meldung">
										<xsl:with-param name="nummer">1010</xsl:with-param>
									</xsl:call-template>
								</xsl:if>
							</td>
						</xsl:when>
						<xsl:otherwise>
							<td>
								<xsl:value-of select="$Element/xdf3:bezeichnungAusgabe"/>
								<xsl:call-template name="PruefeStringLatin">
									<xsl:with-param name="PruefString" select="$Element/xdf3:bezeichnungAusgabe"/>
								</xsl:call-template>
							</td>
						</xsl:otherwise>
					</xsl:choose>
				</tr>
				<tr>
					<td>Hilfetext Eingabe</td>
					<td>
						<xsl:value-of select="fn:replace($Element/xdf3:hilfetextEingabe,'\n','&lt;br/&gt;')" disable-output-escaping="yes"/>
						<xsl:if test="$Meldungen = '1' and not(empty($Element/xdf3:hilfetextEingabe/text())) and $Element/xdf3:bezeichnungEingabe/text() = $Element/xdf3:hilfetextEingabe/text()">
							<xsl:call-template name="meldung">
								<xsl:with-param name="nummer">1098</xsl:with-param>
							</xsl:call-template>
						</xsl:if>
						<xsl:call-template name="PruefeStringLatin">
							<xsl:with-param name="PruefString" select="$Element/xdf3:hilfetextEingabe"/>
						</xsl:call-template>
					</td>
				</tr>
				<tr>
					<td>Hilfetext Ausgabe</td>
					<td>
						<xsl:value-of select="fn:replace($Element/xdf3:hilfetextAusgabe,'\n','&lt;br/&gt;')" disable-output-escaping="yes"/>
						<xsl:if test="$Meldungen = '1' and not(empty($Element/xdf3:hilfetextAusgabe/text())) and $Element/xdf3:bezeichnungAusgabe/text() = $Element/xdf3:hilfetextAusgabe/text()">
							<xsl:call-template name="meldung">
								<xsl:with-param name="nummer">1098</xsl:with-param>
							</xsl:call-template>
						</xsl:if>
						<xsl:call-template name="PruefeStringLatin">
							<xsl:with-param name="PruefString" select="$Element/xdf3:hilfetextAusgabe"/>
						</xsl:call-template>
					</td>
				</tr>
				<tr>
					<td>G�ltig ab</td>
					<td>
						<xsl:value-of select="fn:format-date($Element/xdf3:gueltigAb,'[D01].[M01].[Y0001]')"/>
					</td>
				</tr>
				<tr>
					<td>G�ltig bis</td>
					<td>
						<xsl:value-of select="fn:format-date($Element/xdf3:gueltigBis,'[D01].[M01].[Y0001]')"/>
					</td>
				</tr>
				<tr>
					<td>Fachlicher Ersteller</td>
					<xsl:choose>
						<xsl:when test="empty($Element/xdf3:statusGesetztDurch/text()) and $VersionsHinweise ='1'">
							<td>
								<xsl:value-of select="$Element/xdf3:statusGesetztDurch"/>
								<xsl:if test="$Meldungen = '1'">
									<xsl:call-template name="meldung">
										<xsl:with-param name="nummer">1117</xsl:with-param>
									</xsl:call-template>
								</xsl:if>
							</td>
						</xsl:when>
						<xsl:otherwise>
							<td>
								<xsl:value-of select="$Element/xdf3:statusGesetztDurch"/>
								<xsl:call-template name="PruefeStringLatin">
									<xsl:with-param name="PruefString" select="$Element/xdf3:statusGesetztDurch"/>
								</xsl:call-template>
							</td>
						</xsl:otherwise>
					</xsl:choose>
				</tr>
				<tr>
					<td>Status</td>
					<td>
						<xsl:choose>
							<xsl:when test="empty($Element/xdf3:freigabestatus/code/text())">
								<xsl:if test="$Meldungen = '1'">
									<xsl:call-template name="meldung">
										<xsl:with-param name="nummer">1032</xsl:with-param>
									</xsl:call-template>
									<xsl:choose>
										<xsl:when test="$VoeDS !=''">
											<xsl:call-template name="meldung">
												<xsl:with-param name="nummer">1129</xsl:with-param>
											</xsl:call-template>
										</xsl:when>
										<xsl:when test="$VoeFG != ''">
											<xsl:call-template name="meldung">
												<xsl:with-param name="nummer">1130</xsl:with-param>
											</xsl:call-template>
										</xsl:when>
										<xsl:otherwise></xsl:otherwise>
									</xsl:choose>
								</xsl:if>
							</xsl:when>
							<xsl:otherwise>
								<xsl:apply-templates select="$Element/xdf3:freigabestatus"/>
								<xsl:if test="$Meldungen = '1' and fn:number($Element/xdf3:freigabestatus/code) &lt; 3" >
									<xsl:choose>
										<xsl:when test="$VoeDS !=''">
											<xsl:call-template name="meldung">
												<xsl:with-param name="nummer">1129</xsl:with-param>
											</xsl:call-template>
										</xsl:when>
										<xsl:when test="$VoeFG != ''">
											<xsl:call-template name="meldung">
												<xsl:with-param name="nummer">1130</xsl:with-param>
											</xsl:call-template>
										</xsl:when>
										<xsl:otherwise></xsl:otherwise>
									</xsl:choose>
								</xsl:if>
							</xsl:otherwise>
						</xsl:choose>
					</td>
				</tr>
				<tr>
					<td>Status gesetzt am</td>
					<td>
						<xsl:value-of select="fn:format-date($Element/xdf3:statusGesetztAm,'[D01].[M01].[Y0001]')"/>
					</td>
				</tr>
				<tr>
					<td>Ver�ffentlichungsdatum</td>
					<td>
						<xsl:value-of select="fn:format-date($Element/xdf3:veroeffentlichungsdatum,'[D01].[M01].[Y0001]')"/>
						<xsl:if test="$Meldungen = '1' and empty($Element/xdf3:veroeffentlichungsdatum/text())" >
							<xsl:choose>
								<xsl:when test="$VoeDS !=''">
									<xsl:call-template name="meldung">
										<xsl:with-param name="nummer">1127</xsl:with-param>
									</xsl:call-template>
								</xsl:when>
								<xsl:when test="$VoeFG != ''">
									<xsl:call-template name="meldung">
										<xsl:with-param name="nummer">1128</xsl:with-param>
									</xsl:call-template>
								</xsl:when>
								<xsl:otherwise></xsl:otherwise>
							</xsl:choose>
						</xsl:if>
					</td>
				</tr>
				<tr>
					<td>Letzte �nderung</td>
					<td>
						<xsl:value-of select="fn:format-dateTime(fn:adjust-dateTime-to-timezone($Element/xdf3:letzteAenderung,xs:dayTimeDuration($Zeitzone)),'[D01].[M01].[Y0001] um [H01]:[m01] Uhr')"/>
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
												<xsl:choose>
													<xsl:when test="empty(./xdf3:objekt/xdf3:id/text())">
														<xsl:if test="$Meldungen = '1'">
															<xsl:call-template name="meldung">
																<xsl:with-param name="nummer">1091</xsl:with-param>
															</xsl:call-template>
														</xsl:if>
													</xsl:when>
													<xsl:otherwise>
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
													</xsl:otherwise>
												</xsl:choose>
											</td>
											<td>
												<xsl:value-of select="./xdf3:objekt/xdf3:version"/>
											</td>
											<td>
												<xsl:choose>
													<xsl:when test="empty(./xdf3:praedikat/code/text())">
														<xsl:if test="$Meldungen = '1'">
															<xsl:call-template name="meldung">
																<xsl:with-param name="nummer">1029</xsl:with-param>
															</xsl:call-template>
														</xsl:if>
													</xsl:when>
													<xsl:otherwise>
														<xsl:apply-templates select="./xdf3:praedikat"/>
														<xsl:if test="$Meldungen = '1' and ./xdf3:praedikat/code = 'VKN'">
															<xsl:call-template name="meldung">
																<xsl:with-param name="nummer">1088</xsl:with-param>
															</xsl:call-template>
														</xsl:if>
													</xsl:otherwise>
												</xsl:choose>
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
					<xsl:variable name="AuswahlGruppe" select="$Element/xdf3:art/code"/>
					<td>
						<b>Unterelemente</b>
						<xsl:choose>
							<xsl:when test="$Element/xdf3:art/code = 'X'">
								<br/>
								<b>Auswahlgruppe</b>
								<xsl:if test="$Meldungen = '1'">
									<xsl:choose>
										<xsl:when test="count($Element/xdf3:struktur) &lt; 1">
											<xsl:call-template name="meldung">
												<xsl:with-param name="nummer">1023</xsl:with-param>
											</xsl:call-template>
										</xsl:when>
										<xsl:when test="count($Element/xdf3:struktur) = 1">
											<xsl:call-template name="meldung">
												<xsl:with-param name="nummer">1043</xsl:with-param>
											</xsl:call-template>
										</xsl:when>
									</xsl:choose>
								</xsl:if>
							</xsl:when>
							<xsl:otherwise>
								<xsl:if test="$Meldungen = '1'">
									<xsl:choose>
										<xsl:when test="count($Element/xdf3:struktur) &lt; 1">
											<xsl:call-template name="meldung">
												<xsl:with-param name="nummer">1023</xsl:with-param>
											</xsl:call-template>
										</xsl:when>
										<xsl:when test="count($Element/xdf3:struktur) = 1">
											<xsl:call-template name="meldung">
												<xsl:with-param name="nummer">1106</xsl:with-param>
											</xsl:call-template>
										</xsl:when>
									</xsl:choose>
								</xsl:if>
							</xsl:otherwise>
						</xsl:choose>
						<xsl:if test="$Meldungen = '1' and $Element/xdf3:struktur/xdf3:enthaelt/xdf3:datenfeld/xdf3:identifikation[./xdf3:id/text() ='F60000000001']">
							<xsl:choose>
								<xsl:when test="count($Element/xdf3:struktur) &gt; 1">
									<xsl:call-template name="meldung">
										<xsl:with-param name="nummer">1094</xsl:with-param>
									</xsl:call-template>
								</xsl:when>
								<xsl:otherwise>
									<xsl:call-template name="meldung">
										<xsl:with-param name="nummer">1095</xsl:with-param>
									</xsl:call-template>
								</xsl:otherwise>
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
																<xsl:call-template name="meldung">
																	<xsl:with-param name="nummer">1038</xsl:with-param>
																</xsl:call-template>
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
																	<xsl:call-template name="meldung">
																		<xsl:with-param name="nummer">1004</xsl:with-param>
																	</xsl:call-template>
																</xsl:if>
															</xsl:if>
														</xsl:when>
														<xsl:otherwise>
															<xsl:if test="count($Element/xdf3:struktur/./xdf3:enthaelt/*/xdf3:identifikation[xdf3:id=$VergleichsElement and xdf3:version=$VergleichsVersion]) &gt; 1">
																<xsl:if test="$Meldungen = '1'">
																	<xsl:call-template name="meldung">
																		<xsl:with-param name="nummer">1004</xsl:with-param>
																	</xsl:call-template>
																</xsl:if>
															</xsl:if>
														</xsl:otherwise>
													</xsl:choose>
													<xsl:if test="$Meldungen = '1' and ./xdf3:enthaelt/*/name() = 'xdf3:datenfeldgruppe'">
														<!-- Zirkelbezug E1026 -->
														<xsl:if test="count(.//xdf3:enthaelt/xdf3:datenfeldgruppe[xdf3:identifikation/xdf3:id = $Element/xdf3:identifikation/xdf3:id and xdf3:identifikation/xdf3:version = $Element/xdf3:identifikation/xdf3:version]) &gt; 0">
															<xsl:if test="$Meldungen = '1'">
																<xsl:call-template name="meldung">
																	<xsl:with-param name="nummer">1026</xsl:with-param>
																</xsl:call-template>
															</xsl:if>
														</xsl:if>
													</xsl:if>
												</td>
												<td>
													<xsl:choose>
														<xsl:when test="fn:string($Element/xdf3:identifikation/xdf3:version) and not(fn:string(./xdf3:enthaelt/*/xdf3:identifikation/xdf3:version))">
															<xsl:value-of select="./xdf3:enthaelt/*/xdf3:identifikation/xdf3:version"/>
															<xsl:if test="$Meldungen = '1'">
																<xsl:call-template name="meldung">
																	<xsl:with-param name="nummer">1135</xsl:with-param>
																</xsl:call-template>
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
														<xsl:when test="./xdf3:enthaelt/*/xdf3:schemaelementart/code/text() = 'ABS'">
															<xsl:apply-templates select="./xdf3:enthaelt/*/xdf3:schemaelementart"/>
															<xsl:if test="$Meldungen = '1'">
																<xsl:call-template name="meldung">
																	<xsl:with-param name="nummer">1013</xsl:with-param>
																</xsl:call-template>
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
																<xsl:call-template name="meldung">
																	<xsl:with-param name="nummer">1116</xsl:with-param>
																</xsl:call-template>
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
															<xsl:analyze-string regex="^\d+:(\d+|\*)$" select="./xdf3:anzahl">
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
																	<xsl:if test="$AuswahlGruppe = 'X' and ($minCount != '0' or $maxCount != '1')">
																		<xsl:call-template name="meldung">
																			<xsl:with-param name="nummer">1118</xsl:with-param>
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
																		<xsl:call-template name="meldung">
																			<xsl:with-param name="nummer">1022</xsl:with-param>
																		</xsl:call-template>
																	</xsl:if>
																</xsl:when>
																<xsl:otherwise>
																</xsl:otherwise>
															</xsl:choose>
														</xsl:when>
														<xsl:otherwise>
															<xsl:for-each select="./xdf3:bezug">
																<xsl:choose>
																	<xsl:when test="fn:string(./@link)">
																		<xsl:choose>
																			<xsl:when test="$HandlungsgrundlagenLinks = '1'">
																				<xsl:value-of select="."/> (<xsl:element name="a">
																					<xsl:attribute name="href"><xsl:value-of select="./@link"/></xsl:attribute>
																					<xsl:attribute name="target">Handlungsgrundlage</xsl:attribute>
																					<xsl:attribute name="title">Springe zum Text der Handlungsgrundlage.</xsl:attribute>
																					<xsl:value-of select="./@link"/>
																				</xsl:element>)
																				<xsl:call-template name="PruefeHandlungsgrundlage">
																					<xsl:with-param name="PruefBezug" select="."/>
																				</xsl:call-template>
																			</xsl:when>
																			<xsl:otherwise>
																				<xsl:value-of select="."/> (<xsl:value-of select="./@link"/>)
																				<xsl:call-template name="PruefeHandlungsgrundlage">
																					<xsl:with-param name="PruefBezug" select="."/>
																				</xsl:call-template>
																			</xsl:otherwise>
																		</xsl:choose>
																	</xsl:when>
																	<xsl:otherwise>
																		<xsl:value-of select="."/>
																		<xsl:call-template name="PruefeHandlungsgrundlage">
																			<xsl:with-param name="PruefBezug" select="."/>
																		</xsl:call-template>
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
									<xsl:call-template name="meldung">
										<xsl:with-param name="nummer">1023</xsl:with-param>
									</xsl:call-template>
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
															<xsl:for-each select="$MeldungenInhalt/gc:CodeList/*:SimpleCodeList/*:Row[*:Value/@ColumnRef ='Code' and *:Value/*:SimpleValue = '1001']">
																<xsl:choose>
																	<xsl:when test="./*:Value[@ColumnRef ='Typ']/*:SimpleValue = 'FehlerKritisch'">
																		<div class="FehlerKritisch M1001">
																			FehlerKritisch!! 1001: <xsl:value-of select="./*:Value[@ColumnRef ='Meldungstext']/*:SimpleValue"/> Nicht-erreichbares Element: <xsl:value-of select="$TestElement"/>
																			<xsl:if test="$QSHilfeAufruf = '1'">
																				&#160;&#160;
																				<xsl:element name="a">
																					<xsl:attribute name="href"><xsl:value-of  select="$QSHilfePfadPrefix"/>M1001<xsl:value-of select="$QSHilfePfadPostfix"/></xsl:attribute>
																					<xsl:attribute name="target">MeldungsHilfe</xsl:attribute>
																					<xsl:attribute name="title">Springe zu den Erl�uterungen der Meldungscodes in die Qualit�tskriterien.</xsl:attribute>
																					&#8658;
																				</xsl:element>&#160;&#160;&#160;&#160;
																			</xsl:if>
																		</div>
																	</xsl:when>
																	<xsl:when test="./*:Value[@ColumnRef ='Typ']/*:SimpleValue = 'FehlerMethodisch'">
																		<div class="FehlerMethodisch M1001">
																			FehlerMethodisch!! 1001: <xsl:value-of select="./*:Value[@ColumnRef ='Meldungstext']/*:SimpleValue"/> Nicht-erreichbares Element: <xsl:value-of select="$TestElement"/>
																			<xsl:if test="$QSHilfeAufruf = '1'">
																				&#160;&#160;
																				<xsl:element name="a">
																					<xsl:attribute name="href"><xsl:value-of  select="$QSHilfePfadPrefix"/>M1001<xsl:value-of select="$QSHilfePfadPostfix"/></xsl:attribute>
																					<xsl:attribute name="target">MeldungsHilfe</xsl:attribute>
																					<xsl:attribute name="title">Springe zu den Erl�uterungen der Meldungscodes in die Qualit�tskriterien.</xsl:attribute>
																					&#8658;
																				</xsl:element>&#160;&#160;&#160;&#160;
																			</xsl:if>
																		</div>
																	</xsl:when>
																	<xsl:when test="./*:Value[@ColumnRef ='Typ']/*:SimpleValue = 'Warnung'">
																		<div class="Warnung 1001">
																			Warnung!! M1001: <xsl:value-of select="./*:Value[@ColumnRef ='Meldungstext']/*:SimpleValue"/> Nicht-erreichbares Element: <xsl:value-of select="$TestElement"/>
																			<xsl:if test="$QSHilfeAufruf = '1'">
																				&#160;&#160;
																				<xsl:element name="a">
																					<xsl:attribute name="href"><xsl:value-of  select="$QSHilfePfadPrefix"/>M1001<xsl:value-of select="$QSHilfePfadPostfix"/></xsl:attribute>
																					<xsl:attribute name="target">MeldungsHilfe</xsl:attribute>
																					<xsl:attribute name="title">Springe zu den Erl�uterungen der Meldungscodes in die Qualit�tskriterien.</xsl:attribute>
																					&#8658;
																				</xsl:element>&#160;&#160;&#160;&#160;
																			</xsl:if>
																		</div>
																	</xsl:when>
																	<xsl:when test="./*:Value[@ColumnRef ='Typ']/*:SimpleValue = 'Hinweis'">
																		<div class="Hinweis M1001">
																			Hinweis!! 1001: <xsl:value-of select="./*:Value[@ColumnRef ='Meldungstext']/*:SimpleValue"/> Nicht-erreichbares Element: <xsl:value-of select="$TestElement"/>
																			<xsl:if test="$QSHilfeAufruf = '1'">
																				&#160;&#160;
																				<xsl:element name="a">
																					<xsl:attribute name="href"><xsl:value-of  select="$QSHilfePfadPrefix"/>M1001<xsl:value-of select="$QSHilfePfadPostfix"/></xsl:attribute>
																					<xsl:attribute name="target">MeldungsHilfe</xsl:attribute>
																					<xsl:attribute name="title">Springe zu den Erl�uterungen der Meldungscodes in die Qualit�tskriterien.</xsl:attribute>
																					&#8658;
																				</xsl:element>&#160;&#160;&#160;&#160;
																			</xsl:if>
																		</div>
																	</xsl:when>
																	<xsl:when test="./*:Value[@ColumnRef ='Typ']/*:SimpleValue = 'Deaktiviert'">
																	</xsl:when>
																	<xsl:otherwise>
																		<div class="Hinweis M1001">Hinweis!! 1001: Unbekannte Meldung!</div>
																	</xsl:otherwise>
																</xsl:choose>
															</xsl:for-each>
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
														<xsl:variable name="BaukastenElement" select="."/>
														<xsl:for-each select="$MeldungenInhalt/gc:CodeList/*:SimpleCodeList/*:Row[*:Value/@ColumnRef ='Code' and *:Value/*:SimpleValue = '1019']">
															<xsl:choose>
																<xsl:when test="./*:Value[@ColumnRef ='Typ']/*:SimpleValue = 'FehlerKritisch'">
																	<div class="FehlerKritisch M1019">
																		FehlerKritisch!! 1019: <xsl:value-of select="./*:Value[@ColumnRef ='Meldungstext']/*:SimpleValue"/> Betroffenes Element: <xsl:value-of select="$BaukastenElement"/>
																		<xsl:if test="$QSHilfeAufruf = '1'">
																			&#160;&#160;
																			<xsl:element name="a">
																				<xsl:attribute name="href"><xsl:value-of  select="$QSHilfePfadPrefix"/>M1019<xsl:value-of select="$QSHilfePfadPostfix"/></xsl:attribute>
																				<xsl:attribute name="target">MeldungsHilfe</xsl:attribute>
																				<xsl:attribute name="title">Springe zu den Erl�uterungen der Meldungscodes in die Qualit�tskriterien.</xsl:attribute>
																				&#8658;
																			</xsl:element>&#160;&#160;&#160;&#160;
																		</xsl:if>
																	</div>
																</xsl:when>
																<xsl:when test="./*:Value[@ColumnRef ='Typ']/*:SimpleValue = 'FehlerMethodisch'">
																	<div class="FehlerMethodisch M1019">
																		FehlerMethodisch!! 1019: <xsl:value-of select="./*:Value[@ColumnRef ='Meldungstext']/*:SimpleValue"/> Betroffenes Element: <xsl:value-of select="$BaukastenElement"/>
																		<xsl:if test="$QSHilfeAufruf = '1'">
																			&#160;&#160;
																			<xsl:element name="a">
																				<xsl:attribute name="href"><xsl:value-of  select="$QSHilfePfadPrefix"/>M1019<xsl:value-of select="$QSHilfePfadPostfix"/></xsl:attribute>
																				<xsl:attribute name="target">MeldungsHilfe</xsl:attribute>
																				<xsl:attribute name="title">Springe zu den Erl�uterungen der Meldungscodes in die Qualit�tskriterien.</xsl:attribute>
																				&#8658;
																			</xsl:element>&#160;&#160;&#160;&#160;
																		</xsl:if>
																	</div>
																</xsl:when>
																<xsl:when test="./*:Value[@ColumnRef ='Typ']/*:SimpleValue = 'Warnung'">
																	<div class="Warnung M1019">
																		Warnung!! 1019: <xsl:value-of select="./*:Value[@ColumnRef ='Meldungstext']/*:SimpleValue"/> Betroffenes Element: <xsl:value-of select="$BaukastenElement"/>
																		<xsl:if test="$QSHilfeAufruf = '1'">
																			&#160;&#160;
																			<xsl:element name="a">
																				<xsl:attribute name="href"><xsl:value-of  select="$QSHilfePfadPrefix"/>M1019<xsl:value-of select="$QSHilfePfadPostfix"/></xsl:attribute>
																				<xsl:attribute name="target">MeldungsHilfe</xsl:attribute>
																				<xsl:attribute name="title">Springe zu den Erl�uterungen der Meldungscodes in die Qualit�tskriterien.</xsl:attribute>
																				&#8658;
																			</xsl:element>&#160;&#160;&#160;&#160;
																		</xsl:if>
																	</div>
																</xsl:when>
																<xsl:when test="./*:Value[@ColumnRef ='Typ']/*:SimpleValue = 'Hinweis'">
																	<div class="Hinweis M1019">
																		Hinweis!! 1019: <xsl:value-of select="./*:Value[@ColumnRef ='Meldungstext']/*:SimpleValue"/> Betroffenes Element: <xsl:value-of select="$BaukastenElement"/>
																		<xsl:if test="$QSHilfeAufruf = '1'">
																			&#160;&#160;
																			<xsl:element name="a">
																				<xsl:attribute name="href"><xsl:value-of  select="$QSHilfePfadPrefix"/>M1019<xsl:value-of select="$QSHilfePfadPostfix"/></xsl:attribute>
																				<xsl:attribute name="target">MeldungsHilfe</xsl:attribute>
																				<xsl:attribute name="title">Springe zu den Erl�uterungen der Meldungscodes in die Qualit�tskriterien.</xsl:attribute>
																				&#8658;
																			</xsl:element>&#160;&#160;&#160;&#160;
																		</xsl:if>
																	</div>
																</xsl:when>
																<xsl:otherwise>
																	<div class="Hinweis M1019">Hinweis!! 1019: Unbekannte Meldung!</div>
																</xsl:otherwise>
															</xsl:choose>
														</xsl:for-each>
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
														<xsl:variable name="BaukastenElement" select="."/>
														<xsl:for-each select="$MeldungenInhalt/gc:CodeList/*:SimpleCodeList/*:Row[*:Value/@ColumnRef ='Code' and *:Value/*:SimpleValue = '1041']">
															<xsl:choose>
																<xsl:when test="./*:Value[@ColumnRef ='Typ']/*:SimpleValue = 'FehlerKritisch'">
																	<div class="FehlerKritisch M1041">
																		FehlerKritisch!! 1041: <xsl:value-of select="./*:Value[@ColumnRef ='Meldungstext']/*:SimpleValue"/> Betroffenes Element: <xsl:value-of select="fn:substring($BaukastenElement,1,9)"/>
																		<xsl:if test="$QSHilfeAufruf = '1'">
																			&#160;&#160;
																			<xsl:element name="a">
																				<xsl:attribute name="href"><xsl:value-of  select="$QSHilfePfadPrefix"/>M1041<xsl:value-of select="$QSHilfePfadPostfix"/></xsl:attribute>
																				<xsl:attribute name="target">MeldungsHilfe</xsl:attribute>
																				<xsl:attribute name="title">Springe zu den Erl�uterungen der Meldungscodes in die Qualit�tskriterien.</xsl:attribute>
																				&#8658;
																			</xsl:element>&#160;&#160;&#160;&#160;
																		</xsl:if>
																	</div>
																</xsl:when>
																<xsl:when test="./*:Value[@ColumnRef ='Typ']/*:SimpleValue = 'FehlerMethodisch'">
																	<div class="FehlerMethodisch M1041">
																		FehlerMethodisch!! 1041: <xsl:value-of select="./*:Value[@ColumnRef ='Meldungstext']/*:SimpleValue"/> Betroffenes Element: <xsl:value-of select="fn:substring($BaukastenElement,1,9)"/>
																		<xsl:if test="$QSHilfeAufruf = '1'">
																			&#160;&#160;
																			<xsl:element name="a">
																				<xsl:attribute name="href"><xsl:value-of  select="$QSHilfePfadPrefix"/>M1041<xsl:value-of select="$QSHilfePfadPostfix"/></xsl:attribute>
																				<xsl:attribute name="target">MeldungsHilfe</xsl:attribute>
																				<xsl:attribute name="title">Springe zu den Erl�uterungen der Meldungscodes in die Qualit�tskriterien.</xsl:attribute>
																				&#8658;
																			</xsl:element>&#160;&#160;&#160;&#160;
																		</xsl:if>
																	</div>
																</xsl:when>
																<xsl:when test="./*:Value[@ColumnRef ='Typ']/*:SimpleValue = 'Warnung'">
																	<div class="Warnung M1041">
																		Warnung!! 1041: <xsl:value-of select="./*:Value[@ColumnRef ='Meldungstext']/*:SimpleValue"/> Betroffenes Element: <xsl:value-of select="fn:substring($BaukastenElement,1,9)"/>
																		<xsl:if test="$QSHilfeAufruf = '1'">
																			&#160;&#160;
																			<xsl:element name="a">
																				<xsl:attribute name="href"><xsl:value-of  select="$QSHilfePfadPrefix"/>M1041<xsl:value-of select="$QSHilfePfadPostfix"/></xsl:attribute>
																				<xsl:attribute name="target">MeldungsHilfe</xsl:attribute>
																				<xsl:attribute name="title">Springe zu den Erl�uterungen der Meldungscodes in die Qualit�tskriterien.</xsl:attribute>
																				&#8658;
																			</xsl:element>&#160;&#160;&#160;&#160;
																		</xsl:if>
																	</div>
																</xsl:when>
																<xsl:when test="./*:Value[@ColumnRef ='Typ']/*:SimpleValue = 'Hinweis'">
																	<div class="Hinweis M1041">
																		Hinweis!! 1041: <xsl:value-of select="./*:Value[@ColumnRef ='Meldungstext']/*:SimpleValue"/> Betroffenes Element: <xsl:value-of select="fn:substring($BaukastenElement,1,9)"/>
																		<xsl:if test="$QSHilfeAufruf = '1'">
																			&#160;&#160;
																			<xsl:element name="a">
																				<xsl:attribute name="href"><xsl:value-of  select="$QSHilfePfadPrefix"/>M1041<xsl:value-of select="$QSHilfePfadPostfix"/></xsl:attribute>
																				<xsl:attribute name="target">MeldungsHilfe</xsl:attribute>
																				<xsl:attribute name="title">Springe zu den Erl�uterungen der Meldungscodes in die Qualit�tskriterien.</xsl:attribute>
																				&#8658;
																			</xsl:element>&#160;&#160;&#160;&#160;
																		</xsl:if>
																	</div>
																</xsl:when>
																<xsl:otherwise>
																	<div class="Hinweis M1041">Hinweis!! 1041: Unbekannte Meldung!</div>
																</xsl:otherwise>
															</xsl:choose>
														</xsl:for-each>
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
			<xsl:choose>
				<xsl:when test="name(/*) ='xdf3:xdatenfelder.stammdatenschema.0102'">
					<a name="RegelDetails"/>Details zu den Regeln des Datenschemas <xsl:value-of select="/*/xdf3:stammdatenschema/xdf3:identifikation/xdf3:id"/>
					<xsl:if test="/*/xdf3:stammdatenschema/xdf3:identifikation/xdf3:version">&#160;Version&#160;<xsl:value-of select="/*/xdf3:stammdatenschema/xdf3:identifikation/xdf3:version"/></xsl:if><xsl:if test="$Navigation = '2' and $Statistik != '2'">&#160;<a href="#Bericht" title="nach oben">&#8593;</a></xsl:if>
				</xsl:when>
				<xsl:when test="name(/*) ='xdf3:xdatenfelder.datenfeldgruppe.0103'">
					<a name="RegelDetails"/>Details zu den Regeln der Datenfeldgruppe <xsl:value-of select="/*/xdf3:datenfeldgruppe/xdf3:identifikation/xdf3:id"/>
					<xsl:if test="/*/xdf3:datenfeldgruppe/xdf3:identifikation/xdf3:version">&#160;Version&#160;<xsl:value-of select="/*/xdf3:datenfeldgruppe/xdf3:identifikation/xdf3:version"/></xsl:if><xsl:if test="$Navigation = '2' and $Statistik != '2'">&#160;<a href="#Bericht" title="nach oben">&#8593;</a></xsl:if>
				</xsl:when>
			</xsl:choose>
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
					<xsl:attribute name="id"><xsl:value-of select="$Element/xdf3:identifikation/xdf3:id"/><xsl:if test="$Element/xdf3:identifikation/xdf3:version">V<xsl:value-of select="$Element/xdf3:identifikation/xdf3:version"/></xsl:if></xsl:attribute>
				</xsl:element>
										ID
									</td>
			<xsl:choose>
				<xsl:when test="empty($Element/xdf3:identifikation/xdf3:id/text())">
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
							<xsl:call-template name="meldung">
								<xsl:with-param name="nummer">1002</xsl:with-param>
							</xsl:call-template>
						</xsl:if>
					</td>
				</xsl:when>
				<xsl:otherwise>
					<td class="RegelName">
						<xsl:value-of select="$Element/xdf3:name"/>
						<xsl:call-template name="PruefeStringLatin">
							<xsl:with-param name="PruefString" select="$Element/xdf3:name"/>
						</xsl:call-template>
					</td>
				</xsl:otherwise>
			</xsl:choose>
		</tr>
		<tr>
			<td>Stichw�rter</td>
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
							<xsl:call-template name="meldung">
								<xsl:with-param name="nummer">1024</xsl:with-param>
							</xsl:call-template>
						</xsl:if>
					</td>
				</xsl:when>
				<xsl:otherwise>
					<td>
						<xsl:value-of select="fn:replace($Element/xdf3:freitextRegel,'\n','&lt;br/&gt;')" disable-output-escaping="yes"/>
						<xsl:call-template name="PruefeStringLatin">
							<xsl:with-param name="PruefString" select="$Element/xdf3:freitextRegel"/>
						</xsl:call-template>
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
						<!-- 
							<xsl:if test="$Meldungen = '1'">
								<xsl:call-template name="meldung">
									<xsl:with-param name="nummer">1104</xsl:with-param>
								</xsl:call-template>
							</xsl:if> 
						-->
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
				<xsl:call-template name="PruefeStringLatin">
					<xsl:with-param name="PruefString" select="$Element/xdf3:beschreibung"/>
				</xsl:call-template>
			</td>
		</tr>
		<tr>
			<td>Handlungsgrundlagen</td>
			<td>
				<xsl:choose>
					<xsl:when test="fn:count($Element/xdf3:bezug) = 0">
					</xsl:when>
					<xsl:otherwise>
						<xsl:call-template name="handlungsgrundlagen">
							<xsl:with-param name="Element" select="$Element"/>
						</xsl:call-template>
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
							<xsl:call-template name="meldung">
								<xsl:with-param name="nummer">1117</xsl:with-param>
							</xsl:call-template>
						</xsl:if>
					</td>
				</xsl:when>
				<xsl:otherwise>
					<td>
						<xsl:value-of select="$Element/xdf3:fachlicherErsteller"/>
						<xsl:call-template name="PruefeStringLatin">
							<xsl:with-param name="PruefString" select="$Element/xdf3:statusGesetztDurch"/>
						</xsl:call-template>
					</td>
				</xsl:otherwise>
			</xsl:choose>
		</tr>
		<tr>
			<td>Letzte �nderung</td>
			<td>
				<xsl:value-of select="fn:format-dateTime(fn:adjust-dateTime-to-timezone($Element/xdf3:letzteAenderung,xs:dayTimeDuration($Zeitzone)),'[D01].[M01].[Y0001] um [H01]:[m01] Uhr')"/>
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
			<xsl:choose>
				<xsl:when test="name(/*) ='xdf3:xdatenfelder.stammdatenschema.0102'">
					<a name="CodelisteDetails"/>Details zu den Codelisten des Datenschemas <xsl:value-of select="/*/xdf3:stammdatenschema/xdf3:identifikation/xdf3:id"/>
					<xsl:if test="/*/xdf3:stammdatenschema/xdf3:identifikation/xdf3:version">&#160;Version&#160;<xsl:value-of select="/*/xdf3:stammdatenschema/xdf3:identifikation/xdf3:version"/></xsl:if><xsl:if test="$Navigation = '2' and $Statistik != '2'">&#160;<a href="#Bericht" title="nach oben">&#8593;</a></xsl:if>
				</xsl:when>
				<xsl:when test="name(/*) ='xdf3:xdatenfelder.datenfeldgruppe.0103'">
					<a name="CodelisteDetails"/>Details zu den Codelisten der Datenfeldgruppe <xsl:value-of select="/*/xdf3:datenfeldgruppe/xdf3:identifikation/xdf3:id"/>
					<xsl:if test="/*/xdf3:datenfeldgruppe/xdf3:identifikation/xdf3:version">&#160;Version&#160;<xsl:value-of select="/*/xdf3:datenfeldgruppe/xdf3:identifikation/xdf3:version"/></xsl:if><xsl:if test="$Navigation = '2' and $Statistik != '2'">&#160;<a href="#Bericht" title="nach oben">&#8593;</a></xsl:if>
				</xsl:when>
			</xsl:choose>
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
				-------- <xsl:value-of select="$Element/xdf3:canonicalIdentification"/><xsl:if test="$Element/xdf3:version">_<xsl:value-of select="$Element/xdf3:version"/></xsl:if> --------
			</xsl:message>
		</xsl:if>
		<tr>
			<xsl:variable name="CodelisteURN">
				<xsl:value-of select="$Element/xdf3:canonicalIdentification"/>
				<xsl:if test="$Element/xdf3:version">_<xsl:value-of select="$Element/xdf3:version"/></xsl:if>
			</xsl:variable>

			<xsl:variable name="XMLCodelisteURL">
				<xsl:choose>
					<xsl:when test="not(fn:string($Element/xdf3:version))">
						<xsl:value-of select="fn:concat($XMLXRepoOhneVersionPfadPrefix,$CodelisteURN,$XMLXRepoOhneVersionPfadPostfix)"/>
					</xsl:when>
					<xsl:otherwise>
						<xsl:value-of select="fn:concat($XMLXRepoMitVersionPfadPrefix,$CodelisteURN,$XMLXRepoMitVersionPfadPostfix)"/>
					</xsl:otherwise>
				</xsl:choose>
			</xsl:variable>

			<xsl:variable name="DocCodelisteURL">
				<xsl:choose>
					<xsl:when test="not(fn:string($Element/xdf3:version))">
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
					<xsl:attribute name="id"><xsl:value-of select="$CodelisteURN"/></xsl:attribute>
				</xsl:element>
				Kennung
			</td>
			<td>
				<xsl:value-of select="$Element/xdf3:canonicalIdentification"/>
				<xsl:if test="$Meldungen = '1'">
					<xsl:choose>
						<xsl:when test="empty($Element/xdf3:canonicalIdentification/text())">
							<xsl:call-template name="meldung">
								<xsl:with-param name="nummer">1040</xsl:with-param>
							</xsl:call-template>
						</xsl:when>
						<xsl:otherwise>
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
									<xsl:if test="$Meldungen = '1' and fn:string-length($CodelisteInhalt) &lt; 10">
										<xsl:call-template name="meldung">
											<xsl:with-param name="nummer">1115</xsl:with-param>
										</xsl:call-template>
									</xsl:if>
								</xsl:matching-substring>
								<xsl:non-matching-substring>
									<xsl:if test="$Meldungen = '1'">
										<xsl:choose>
											<xsl:when test="substring($Element/xdf3:canonicalIdentification/text(),1,4) != 'urn:'">
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

		<xsl:variable name="RichtigeVersion">
			<xsl:choose>
				<xsl:when test="empty($Element//xdf3:version/text())">
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
				<xsl:otherwise><xsl:value-of select="$Element/xdf3:version"/></xsl:otherwise>
			</xsl:choose>
		</xsl:variable>

		<tr>
			<td>Version</td>
			<td>
				<xsl:choose>
					<xsl:when test="fn:string($Element/xdf3:version)">
						<xsl:value-of select="$Element/xdf3:version"/>
					</xsl:when>
					<xsl:otherwise>
						Da die Version der Codeliste nicht vorgegeben ist, sollte in der Regel immer die aktuellste Version 
						<xsl:if test="$RichtigeVersion != 'unbestimmt'">
							(derzeit <xsl:value-of select="$RichtigeVersion"/>
							<xsl:if test="$XRepoAufruf = '1'">
								<xsl:element name="a"><xsl:attribute name="href"><xsl:value-of select="fn:concat($DocXRepoMitVersionPfadPrefix,$Element/xdf3:canonicalIdentification,'_',$RichtigeVersion,$DocXRepoMitVersionPfadPostfix)"/></xsl:attribute><xsl:attribute name="target">XRepo</xsl:attribute><xsl:attribute name="title">Springe in das XRepository.</xsl:attribute>&#8658;</xsl:element>
							</xsl:if>) 
						</xsl:if>
						der Codeliste verwendet werden.
					</xsl:otherwise>
				</xsl:choose>
				<xsl:if test="$Meldungen = '1' and (count(//xdf3:codelisteReferenz[xdf3:canonicalIdentification = $Element/xdf3:canonicalIdentification and xdf3:version != $Element/xdf3:version]) &gt; 0)">
					<xsl:call-template name="meldung">
						<xsl:with-param name="nummer">1037</xsl:with-param>
					</xsl:call-template>
				</xsl:if>
			</td>
		</tr>
		<tr>
			<td>Versionskennung</td>
			<td>
				<xsl:value-of select="$Element/xdf3:canonicalVersionUri"/>
			</td>
		</tr>

		<xsl:if test="$CodelistenInhalt = '1' and substring($Element/xdf3:canonicalIdentification/text(),1,4) = 'urn:'">

			<xsl:variable name="NormalisierteURN" select="fn:replace($Element/xdf3:canonicalIdentification,':','.')"/>
			<xsl:variable name="CodelisteDatei" select="fn:concat($InputPfad,$NormalisierteURN,'_',$RichtigeVersion,'.xml')"/>
			<xsl:variable name="CodelisteURL" select="fn:concat($XMLXRepoMitVersionPfadPrefix,$Element/xdf3:canonicalIdentification,'_',$RichtigeVersion,$XMLXRepoMitVersionPfadPostfix)"/>

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
					<xsl:choose>
						<xsl:when test="not(fn:string($Element/xdf3:version)) and $AktuelleCodelisteLaden ='0'">
							<tr>
								<td>Inhalt</td>
								<td>
									Der Inhalt der Codeliste kann ohne Version nicht geladen werden.
								</td>
							</tr>
						</xsl:when>
						<xsl:otherwise>
							<tr>
								<td>Inhalt</td>
								<td>
									Der Inhalt der Codeliste konnte nicht geladen werden.
								</td>
							</tr>
						</xsl:otherwise>
					</xsl:choose>
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
							<xsl:value-of select="$CodelisteInhalt/*/*:Identification/LongName"/>
						</td>
					</tr>
					<tr>
						<td>Herausgeber</td>
						<td>
							<xsl:value-of select="$CodelisteInhalt/*/gc:Identification/gc:Agency/gc:LongName"/>
							<xsl:value-of select="$CodelisteInhalt/*/*:Identification/Agency/LongName"/>
						</td>
					</tr>
					<tr>
						<td colspan="2">
							<h2/>
						</td>
					</tr>
					<tr>
						<td>Inhalt<xsl:if test="$RichtigeVersion != 'unbestimmt'"> der Version <xsl:value-of select="$RichtigeVersion"/></xsl:if></td>
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
								<xsl:call-template name="meldung">
									<xsl:with-param name="nummer">1038</xsl:with-param>
								</xsl:call-template>
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
									<xsl:for-each select="$MeldungenInhalt/gc:CodeList/*:SimpleCodeList/*:Row[Value/@ColumnRef ='Code' and *:Value/*:SimpleValue = '1001']">
										<xsl:choose>
											<xsl:when test="./*:Value[@ColumnRef ='Typ']/*:SimpleValue = 'FehlerKritisch'">
												<div class="FehlerKritisch M1001">
													FehlerKritisch!! 1001: <xsl:value-of select="./*:Value[@ColumnRef ='Meldungstext']/*:SimpleValue"/> Nicht-erreichbares Element: <xsl:value-of select="$TestElement"/>
													<xsl:if test="$QSHilfeAufruf = '1'">
														&#160;&#160;
														<xsl:element name="a">
															<xsl:attribute name="href"><xsl:value-of  select="$QSHilfePfadPrefix"/>M1001<xsl:value-of select="$QSHilfePfadPostfix"/></xsl:attribute>
															<xsl:attribute name="target">MeldungsHilfe</xsl:attribute>
															<xsl:attribute name="title">Springe zu den Erl�uterungen der Meldungscodes in die Qualit�tskriterien.</xsl:attribute>
															&#8658;
														</xsl:element>&#160;&#160;&#160;&#160;
													</xsl:if>
												</div>
											</xsl:when>
											<xsl:when test="./*:Value[@ColumnRef ='Typ']/*:SimpleValue = 'FehlerMethodisch'">
												<div class="FehlerMethodisch M1001">
													FehlerMethodisch!! 1001: <xsl:value-of select="./*:Value[@ColumnRef ='Meldungstext']/*:SimpleValue"/> Nicht-erreichbares Element: <xsl:value-of select="$TestElement"/>
													<xsl:if test="$QSHilfeAufruf = '1'">
														&#160;&#160;
														<xsl:element name="a">
															<xsl:attribute name="href"><xsl:value-of  select="$QSHilfePfadPrefix"/>M1001<xsl:value-of select="$QSHilfePfadPostfix"/></xsl:attribute>
															<xsl:attribute name="target">MeldungsHilfe</xsl:attribute>
															<xsl:attribute name="title">Springe zu den Erl�uterungen der Meldungscodes in die Qualit�tskriterien.</xsl:attribute>
															&#8658;
														</xsl:element>&#160;&#160;&#160;&#160;
													</xsl:if>
												</div>
											</xsl:when>
											<xsl:when test="./*:Value[@ColumnRef ='Typ']/*:SimpleValue = 'Warnung'">
												<div class="Warnung M1001">
													Warnung!! 1001: <xsl:value-of select="./*:Value[@ColumnRef ='Meldungstext']/*:SimpleValue"/> Nicht-erreichbares Element: <xsl:value-of select="$TestElement"/>
													<xsl:if test="$QSHilfeAufruf = '1'">
														&#160;&#160;
														<xsl:element name="a">
															<xsl:attribute name="href"><xsl:value-of  select="$QSHilfePfadPrefix"/>M1001<xsl:value-of select="$QSHilfePfadPostfix"/></xsl:attribute>
															<xsl:attribute name="target">MeldungsHilfe</xsl:attribute>
															<xsl:attribute name="title">Springe zu den Erl�uterungen der Meldungscodes in die Qualit�tskriterien.</xsl:attribute>
															&#8658;
														</xsl:element>&#160;&#160;&#160;&#160;
													</xsl:if>
												</div>
											</xsl:when>
											<xsl:when test="./*:Value[@ColumnRef ='Typ']/*:SimpleValue = 'Hinweis'">
												<div class="Hinweis M1001">
													Hinweis!! 1001: <xsl:value-of select="./*:Value[@ColumnRef ='Meldungstext']/*:SimpleValue"/> Nicht-erreichbares Element: <xsl:value-of select="$TestElement"/>
													<xsl:if test="$QSHilfeAufruf = '1'">
														&#160;&#160;
														<xsl:element name="a">
															<xsl:attribute name="href"><xsl:value-of  select="$QSHilfePfadPrefix"/>M1001<xsl:value-of select="$QSHilfePfadPostfix"/></xsl:attribute>
															<xsl:attribute name="target">MeldungsHilfe</xsl:attribute>
															<xsl:attribute name="title">Springe zu den Erl�uterungen der Meldungscodes in die Qualit�tskriterien.</xsl:attribute>
															&#8658;
														</xsl:element>&#160;&#160;&#160;&#160;
													</xsl:if>
												</div>
											</xsl:when>
											<xsl:when test="./*:Value[@ColumnRef ='Typ']/*:SimpleValue = 'Deaktiviert'">
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
							<xsl:variable name="BaukastenElement" select="."/>
							<xsl:for-each select="$MeldungenInhalt/gc:CodeList/*:SimpleCodeList/*:Row[*:Value/@ColumnRef ='Code' and *:Value/*:SimpleValue = '1019']">
								<xsl:choose>
									<xsl:when test="./*:Value[@ColumnRef ='Typ']/*:SimpleValue = 'FehlerKritisch'">
										<div class="FehlerKritisch M1019">
											FehlerKritisch!! 1019: <xsl:value-of select="./*:Value[@ColumnRef ='Meldungstext']/*:SimpleValue"/> Betroffenes Element: <xsl:value-of select="$BaukastenElement"/>
											<xsl:if test="$QSHilfeAufruf = '1'">
												&#160;&#160;
												<xsl:element name="a">
													<xsl:attribute name="href"><xsl:value-of  select="$QSHilfePfadPrefix"/>M1019<xsl:value-of select="$QSHilfePfadPostfix"/></xsl:attribute>
													<xsl:attribute name="target">MeldungsHilfe</xsl:attribute>
													<xsl:attribute name="title">Springe zu den Erl�uterungen der Meldungscodes in die Qualit�tskriterien.</xsl:attribute>
													&#8658;
												</xsl:element>&#160;&#160;&#160;&#160;
											</xsl:if>
										</div>
									</xsl:when>
									<xsl:when test="./*:Value[@ColumnRef ='Typ']/*:SimpleValue = 'FehlerMethodisch'">
										<div class="FehlerMethodisch M1019">
											FehlerMethodisch!! 1019: <xsl:value-of select="./*:Value[@ColumnRef ='Meldungstext']/*:SimpleValue"/> Betroffenes Element: <xsl:value-of select="$BaukastenElement"/>
											<xsl:if test="$QSHilfeAufruf = '1'">
												&#160;&#160;
												<xsl:element name="a">
													<xsl:attribute name="href"><xsl:value-of  select="$QSHilfePfadPrefix"/>M1019<xsl:value-of select="$QSHilfePfadPostfix"/></xsl:attribute>
													<xsl:attribute name="target">MeldungsHilfe</xsl:attribute>
													<xsl:attribute name="title">Springe zu den Erl�uterungen der Meldungscodes in die Qualit�tskriterien.</xsl:attribute>
													&#8658;
												</xsl:element>&#160;&#160;&#160;&#160;
											</xsl:if>
										</div>
									</xsl:when>
									<xsl:when test="./*:Value[@ColumnRef ='Typ']/*:SimpleValue = 'Warnung'">
										<div class="Warnung M1019">
											Warnung!! 1019: <xsl:value-of select="./*:Value[@ColumnRef ='Meldungstext']/*:SimpleValue"/> Betroffenes Element: <xsl:value-of select="$BaukastenElement"/>
											<xsl:if test="$QSHilfeAufruf = '1'">
												&#160;&#160;
												<xsl:element name="a">
													<xsl:attribute name="href"><xsl:value-of  select="$QSHilfePfadPrefix"/>M1019<xsl:value-of select="$QSHilfePfadPostfix"/></xsl:attribute>
													<xsl:attribute name="target">MeldungsHilfe</xsl:attribute>
													<xsl:attribute name="title">Springe zu den Erl�uterungen der Meldungscodes in die Qualit�tskriterien.</xsl:attribute>
													&#8658;
												</xsl:element>&#160;&#160;&#160;&#160;
											</xsl:if>
										</div>
									</xsl:when>
									<xsl:when test="./*:Value[@ColumnRef ='Typ']/*:SimpleValue = 'Hinweis'">
										<div class="Hinweis M1019">
											Hinweis!! 1019: <xsl:value-of select="./*:Value[@ColumnRef ='Meldungstext']/*:SimpleValue"/> Betroffenes Element: <xsl:value-of select="$BaukastenElement"/>
											<xsl:if test="$QSHilfeAufruf = '1'">
												&#160;&#160;
												<xsl:element name="a">
													<xsl:attribute name="href"><xsl:value-of  select="$QSHilfePfadPrefix"/>M1019<xsl:value-of select="$QSHilfePfadPostfix"/></xsl:attribute>
													<xsl:attribute name="target">MeldungsHilfe</xsl:attribute>
													<xsl:attribute name="title">Springe zu den Erl�uterungen der Meldungscodes in die Qualit�tskriterien.</xsl:attribute>
													&#8658;
												</xsl:element>&#160;&#160;&#160;&#160;
											</xsl:if>
										</div>
									</xsl:when>
									<xsl:otherwise>
										<div class="Hinweis M1019">Hinweis!! 1019: Unbekannte Meldung!</div>
									</xsl:otherwise>
								</xsl:choose>
							</xsl:for-each>
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
							<xsl:variable name="BaukastenElement" select="."/>
							<xsl:for-each select="$MeldungenInhalt/gc:CodeList/*:SimpleCodeList/*:Row[*:Value/@ColumnRef ='Code' and *:Value/*:SimpleValue = '1041']">
								<xsl:choose>
									<xsl:when test="./*:Value[@ColumnRef ='Typ']/*:SimpleValue = 'FehlerKritisch'">
										<div class="FehlerKritisch M1041">
											FehlerKritisch!! 1041: <xsl:value-of select="./*:Value[@ColumnRef ='Meldungstext']/*:SimpleValue"/> Betroffenes Element: <xsl:value-of select="fn:substring($BaukastenElement,1,9)"/>
											<xsl:if test="$QSHilfeAufruf = '1'">
												&#160;&#160;
												<xsl:element name="a">
													<xsl:attribute name="href"><xsl:value-of  select="$QSHilfePfadPrefix"/>M1041<xsl:value-of select="$QSHilfePfadPostfix"/></xsl:attribute>
													<xsl:attribute name="target">MeldungsHilfe</xsl:attribute>
													<xsl:attribute name="title">Springe zu den Erl�uterungen der Meldungscodes in die Qualit�tskriterien.</xsl:attribute>
													&#8658;
												</xsl:element>&#160;&#160;&#160;&#160;
											</xsl:if>
										</div>
									</xsl:when>
									<xsl:when test="./*:Value[@ColumnRef ='Typ']/*:SimpleValue = 'FehlerMethodisch'">
										<div class="FehlerMethodisch M1041">
											FehlerMethodisch!! 1041: <xsl:value-of select="./*:Value[@ColumnRef ='Meldungstext']/*:SimpleValue"/> Betroffenes Element: <xsl:value-of select="fn:substring($BaukastenElement,1,9)"/>
											<xsl:if test="$QSHilfeAufruf = '1'">
												&#160;&#160;
												<xsl:element name="a">
													<xsl:attribute name="href"><xsl:value-of  select="$QSHilfePfadPrefix"/>M1041<xsl:value-of select="$QSHilfePfadPostfix"/></xsl:attribute>
													<xsl:attribute name="target">MeldungsHilfe</xsl:attribute>
													<xsl:attribute name="title">Springe zu den Erl�uterungen der Meldungscodes in die Qualit�tskriterien.</xsl:attribute>
													&#8658;
												</xsl:element>&#160;&#160;&#160;&#160;
											</xsl:if>
										</div>
									</xsl:when>
									<xsl:when test="./*:Value[@ColumnRef ='Typ']/*:SimpleValue = 'Warnung'">
										<div class="Warnung M1041">
											Warnung!! 1041: <xsl:value-of select="./*:Value[@ColumnRef ='Meldungstext']/*:SimpleValue"/> Betroffenes Element: <xsl:value-of select="fn:substring($BaukastenElement,1,9)"/>
											<xsl:if test="$QSHilfeAufruf = '1'">
												&#160;&#160;
												<xsl:element name="a">
													<xsl:attribute name="href"><xsl:value-of  select="$QSHilfePfadPrefix"/>M1041<xsl:value-of select="$QSHilfePfadPostfix"/></xsl:attribute>
													<xsl:attribute name="target">MeldungsHilfe</xsl:attribute>
													<xsl:attribute name="title">Springe zu den Erl�uterungen der Meldungscodes in die Qualit�tskriterien.</xsl:attribute>
													&#8658;
												</xsl:element>&#160;&#160;&#160;&#160;
											</xsl:if>
										</div>
									</xsl:when>
									<xsl:when test="./*:Value[@ColumnRef ='Typ']/*:SimpleValue = 'Hinweis'">
										<div class="Hinweis M1041">
											Hinweis!! 1041: <xsl:value-of select="./*:Value[@ColumnRef ='Meldungstext']/*:SimpleValue"/> Betroffenes Element: <xsl:value-of select="fn:substring($BaukastenElement,1,9)"/>
											<xsl:if test="$QSHilfeAufruf = '1'">
												&#160;&#160;
												<xsl:element name="a">
													<xsl:attribute name="href"><xsl:value-of  select="$QSHilfePfadPrefix"/>M1041<xsl:value-of select="$QSHilfePfadPostfix"/></xsl:attribute>
													<xsl:attribute name="target">MeldungsHilfe</xsl:attribute>
													<xsl:attribute name="title">Springe zu den Erl�uterungen der Meldungscodes in die Qualit�tskriterien.</xsl:attribute>
													&#8658;
												</xsl:element>&#160;&#160;&#160;&#160;
											</xsl:if>
										</div>
									</xsl:when>
									<xsl:otherwise>
										<div class="Hinweis M1041">Hinweis!! 1041: Unbekannte Meldung!</div>
									</xsl:otherwise>
								</xsl:choose>
							</xsl:for-each>
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
								<xsl:call-template name="meldung">
									<xsl:with-param name="nummer">1038</xsl:with-param>
								</xsl:call-template>
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
							<xsl:call-template name="meldung">
								<xsl:with-param name="nummer">1026</xsl:with-param>
							</xsl:call-template>
						</xsl:if>
					</xsl:if>
					<xsl:choose>
						<xsl:when test="$VergleichsVersion = ''">
							<xsl:if test="$Tiefe = 1 and count($Element/xdf3:struktur/./xdf3:enthaelt/*/xdf3:identifikation[xdf3:id=$VergleichsElement and not(xdf3:version)]) &gt; 1">
								<xsl:if test="$Meldungen = '1'">
									<xsl:call-template name="meldung">
										<xsl:with-param name="nummer">1025</xsl:with-param>
									</xsl:call-template>
								</xsl:if>
							</xsl:if>
						</xsl:when>
						<xsl:otherwise>
							<xsl:if test="$Tiefe = 1 and count($Element/xdf3:struktur/./xdf3:enthaelt/*/xdf3:identifikation[xdf3:id=$VergleichsElement and xdf3:version=$VergleichsVersion]) &gt; 1">
								<xsl:if test="$Meldungen = '1'">
									<xsl:call-template name="meldung">
										<xsl:with-param name="nummer">1025</xsl:with-param>
									</xsl:call-template>
								</xsl:if>
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
					<xsl:value-of select="./xdf3:enthaelt/*/xdf3:bezeichnungEingabe"/>
				</td>
				<td>
					<xsl:choose>
						<xsl:when test="./xdf3:enthaelt/*/xdf3:schemaelementart/code/text() = 'ABS' and $Tiefe = 1">
							<xsl:apply-templates select="./xdf3:enthaelt/*/xdf3:schemaelementart"/>
							<xsl:if test="$Meldungen = '1'">
								<xsl:call-template name="meldung">
									<xsl:with-param name="nummer">1013</xsl:with-param>
								</xsl:call-template>
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
								<xsl:call-template name="meldung">
									<xsl:with-param name="nummer">1116</xsl:with-param>
								</xsl:call-template>
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
							<xsl:analyze-string regex="^\d+:(\d+|\*)$" select="./xdf3:anzahl">
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
								<xsl:call-template name="meldung">
									<xsl:with-param name="nummer">1022</xsl:with-param>
								</xsl:call-template>
							</xsl:if>
						</xsl:when>
						<xsl:when test="$Strukturelementart ='SDS' and (./xdf3:enthaelt/*/xdf3:schemaelementart/code/text() = 'ABS' or ./xdf3:enthaelt/*/xdf3:schemaelementart/code/text() = 'HAR') and empty(./xdf3:bezug/text())and $Tiefe = 1">
							<xsl:if test="$Meldungen = '1'">
								<xsl:call-template name="meldung">
									<xsl:with-param name="nummer">1022</xsl:with-param>
								</xsl:call-template>
							</xsl:if>
						</xsl:when>
						<xsl:otherwise>
							<xsl:for-each select="./xdf3:bezug">
								<xsl:choose>
									<xsl:when test="fn:string(./@link)">
										<xsl:choose>
											<xsl:when test="$HandlungsgrundlagenLinks = '1'">
												<xsl:value-of select="."/> (<xsl:element name="a">
													<xsl:attribute name="href"><xsl:value-of select="./@link"/></xsl:attribute>
													<xsl:attribute name="target">Handlungsgrundlage</xsl:attribute>
													<xsl:attribute name="title">Springe zum Text der Handlungsgrundlage.</xsl:attribute>
													<xsl:value-of select="./@link"/>
												</xsl:element>)
												<xsl:if test="$Tiefe = 1">
													<xsl:call-template name="PruefeHandlungsgrundlage">
														<xsl:with-param name="PruefBezug" select="."/>
													</xsl:call-template>
												</xsl:if>
											</xsl:when>
											<xsl:otherwise>
												<xsl:value-of select="."/> (<xsl:value-of select="./@link"/>)
												<xsl:if test="$Tiefe = 1">
													<xsl:call-template name="PruefeHandlungsgrundlage">
														<xsl:with-param name="PruefBezug" select="."/>
													</xsl:call-template>
												</xsl:if>
											</xsl:otherwise>
										</xsl:choose>
									</xsl:when>
									<xsl:otherwise>
										<xsl:value-of select="."/>
										<xsl:if test="$Tiefe = 1">
											<xsl:call-template name="PruefeHandlungsgrundlage">
												<xsl:with-param name="PruefBezug" select="."/>
											</xsl:call-template>
										</xsl:if>
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
			<xsl:if test="count(.//xdf3:enthaelt/xdf3:datenfeldgruppe[xdf3:identifikation/xdf3:id = $Element/xdf3:identifikation/xdf3:id and xdf3:identifikation/xdf3:version = $Element/xdf3:identifikation/xdf3:version]) = 0 and $WurzelAlleUnterelemente = '1'">
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
	<xsl:template name="handlungsgrundlagen">
		<xsl:param name="Element"/>
					<xsl:choose>
						<xsl:when test="fn:count($Element/xdf3:bezug) = 1">
							<xsl:choose>
								<xsl:when test="fn:string($Element/xdf3:bezug/@link)">
									<xsl:choose>
										<xsl:when test="$HandlungsgrundlagenLinks = '1'">
											<xsl:value-of select="$Element/xdf3:bezug"/> (<xsl:element name="a">
												<xsl:attribute name="href"><xsl:value-of select="$Element/xdf3:bezug/@link"/></xsl:attribute>
												<xsl:attribute name="target">Handlungsgrundlage</xsl:attribute>
												<xsl:attribute name="title">Springe zum Text der Handlungsgrundlage.</xsl:attribute>
												<xsl:value-of select="$Element/xdf3:bezug/@link"/>
											</xsl:element>)
											<xsl:call-template name="PruefeHandlungsgrundlage">
												<xsl:with-param name="PruefBezug" select="$Element/xdf3:bezug"/>
											</xsl:call-template>
										</xsl:when>
										<xsl:otherwise>
											<xsl:value-of select="$Element/xdf3:bezug"/> (<xsl:value-of select="$Element/xdf3:bezug/@link"/>)
											<xsl:call-template name="PruefeHandlungsgrundlage">
												<xsl:with-param name="PruefBezug" select="$Element/xdf3:bezug"/>
											</xsl:call-template>
										</xsl:otherwise>
									</xsl:choose>
								</xsl:when>
								<xsl:otherwise>
									<xsl:value-of select="$Element/xdf3:bezug"/>
									<xsl:call-template name="PruefeHandlungsgrundlage">
										<xsl:with-param name="PruefBezug" select="$Element/xdf3:bezug"/>
									</xsl:call-template>
								</xsl:otherwise>
							</xsl:choose>
						</xsl:when>
						<xsl:otherwise>
							<ul>
								<xsl:for-each select="$Element/xdf3:bezug">
									<li>
										<xsl:choose>
											<xsl:when test="fn:string(./@link)">
												<xsl:choose>
													<xsl:when test="$HandlungsgrundlagenLinks = '1'">
														<xsl:value-of select="."/> (<xsl:element name="a">
															<xsl:attribute name="href"><xsl:value-of select="./@link"/></xsl:attribute>
															<xsl:attribute name="target">Handlungsgrundlage</xsl:attribute>
															<xsl:attribute name="title">Springe zum Text der Handlungsgrundlage.</xsl:attribute>
															<xsl:value-of select="./@link"/>
														</xsl:element>)
														<xsl:call-template name="PruefeHandlungsgrundlage">
															<xsl:with-param name="PruefBezug" select="."/>
														</xsl:call-template>
													</xsl:when>
													<xsl:otherwise>
														<xsl:value-of select="."/> (<xsl:value-of select="./@link"/>)
														<xsl:call-template name="PruefeHandlungsgrundlage">
															<xsl:with-param name="PruefBezug" select="."/>
														</xsl:call-template>
													</xsl:otherwise>
												</xsl:choose>
											</xsl:when>
											<xsl:otherwise>
												<xsl:value-of select="."/>
												<xsl:call-template name="PruefeHandlungsgrundlage">
													<xsl:with-param name="PruefBezug" select="."/>
												</xsl:call-template>
											</xsl:otherwise>
										</xsl:choose>
									</li>
								</xsl:for-each>
							</ul>
						</xsl:otherwise>
					</xsl:choose>

	</xsl:template>
	<!-- ############################################################################################################# -->
	<xsl:template name="PruefeHandlungsgrundlage">
		<xsl:param name="PruefBezug"/>

		<xsl:if test="fn:string($PruefBezug)">
			<xsl:if test="$Meldungen = '1'">

				<xsl:call-template name="PruefeStringLatin">
					<xsl:with-param name="PruefString" select="$PruefBezug/text()"/>
				</xsl:call-template>
				<xsl:if test="(count(tokenize($PruefBezug/text(),'�')) - 1) &gt; 1">
					<xsl:call-template name="meldung">
						<xsl:with-param name="nummer">1132</xsl:with-param>
					</xsl:call-template>
				</xsl:if>

				<xsl:if test="fn:string($PruefBezug/@link)">
					<xsl:variable name="url_pattern" select="'^https?://[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}(/.*)?$'"/>
					
					<xsl:if test="not(fn:matches($PruefBezug/@link, $url_pattern))">
						<xsl:call-template name="meldung">
							<xsl:with-param name="nummer">1133</xsl:with-param>
						</xsl:call-template>
					</xsl:if>
				</xsl:if>
				

			</xsl:if>
			
		</xsl:if>
	</xsl:template>
	<!-- ############################################################################################################# -->
	<xsl:template name="PruefeStringLatin">
		<xsl:param name="PruefString"/>

		<xsl:if test="fn:string($PruefString)">

			<xsl:if test="$Meldungen = '1'">

				<xsl:variable name="hasError">
					<xsl:analyze-string select="$PruefString" regex="(([&#x9;-&#xa;&#xd;&#x20;-&#x7e;&#xa1;-&#xac;&#xae;-&#x107;&#x10a;-&#x11b;&#x11e;-&#x123;&#x126;-&#x131;&#x134;-&#x15b;&#x15e;-&#x16b;&#x16e;-&#x17e;&#x18f;&#x1a0;-&#x1a1;&#x1af;-&#x1b0;&#x1b7;&#x1cd;-&#x1d4;&#x1de;-&#x1df;&#x1e4;-&#x1f0;&#x1f4;-&#x1f5;&#x1fa;-&#x1ff;&#x218;-&#x21b;&#x21e;-&#x21f;&#x22a;-&#x22b;&#x22e;-&#x233;&#x259;&#x292;&#x1e02;-&#x1e03;&#x1e0a;-&#x1e0b;&#x1e10;-&#x1e11;&#x1e1e;-&#x1e21;&#x1e24;-&#x1e27;&#x1e30;-&#x1e31;&#x1e40;-&#x1e41;&#x1e44;-&#x1e45;&#x1e56;-&#x1e57;&#x1e60;-&#x1e63;&#x1e6a;-&#x1e6b;&#x1e80;-&#x1e85;&#x1e8c;-&#x1e93;&#x1e9e;&#x1ea0;-&#x1ea7;&#x1eaa;-&#x1eac;&#x1eae;-&#x1ec1;&#x1ec4;-&#x1ed3;&#x1ed6;-&#x1edd;&#x1ee4;-&#x1ef9;&#x20ac;])|(&#x4d;&#x302;|&#x4e;&#x302;|&#x6d;&#x302;|&#x6e;&#x302;|&#x44;&#x302;|&#x64;&#x302;|&#x4a;&#x30c;|&#x4c;&#x302;|&#x6c;&#x302;))*">
						<xsl:non-matching-substring>
							<xsl:text>1</xsl:text>
						</xsl:non-matching-substring>
						<!-- matching-substring ignorieren -->
					</xsl:analyze-string>
				</xsl:variable>
	
				<xsl:if test="string-length($hasError) &gt; 0">
					<xsl:variable name="MeldungsKlasse">
						<xsl:for-each select="$MeldungenInhalt/gc:CodeList/*:SimpleCodeList/*:Row[*:Value/@ColumnRef ='Code' and *:Value/*:SimpleValue = '1131']">
							<xsl:choose>
								<xsl:when test="./*:Value[@ColumnRef ='Typ']/*:SimpleValue = 'FehlerKritisch'">FehlerKritischText</xsl:when>
								<xsl:when test="./*:Value[@ColumnRef ='Typ']/*:SimpleValue = 'FehlerMethodisch'">FehlerMethodischText</xsl:when>
								<xsl:when test="./*:Value[@ColumnRef ='Typ']/*:SimpleValue = 'Warnung'">WarnungText</xsl:when>
								<xsl:when test="./*:Value[@ColumnRef ='Typ']/*:SimpleValue = 'Hinweis'">HinweisText</xsl:when>
								<xsl:when test="./*:Value[@ColumnRef ='Typ']/*:SimpleValue = 'Deaktiviert'">Deaktiviert</xsl:when>
								<xsl:otherwise>HinweisText</xsl:otherwise>
							</xsl:choose>
						</xsl:for-each>
					</xsl:variable>
	
					<xsl:call-template name="meldung">
						<xsl:with-param name="nummer">1131</xsl:with-param>
					</xsl:call-template>
					<xsl:choose>
						<xsl:when test="$MeldungsKlasse != 'Deaktiviert'">
							<span class="{$MeldungsKlasse}">Zeichen, die nicht StringLatin entsprechen sind farblich hervorgehoben und in ' eingeschlossen:</span><br/>
							<xsl:analyze-string regex="(([&#x9;-&#xa;&#xd;&#x20;-&#x7e;&#xa1;-&#xac;&#xae;-&#x107;&#x10a;-&#x11b;&#x11e;-&#x123;&#x126;-&#x131;&#x134;-&#x15b;&#x15e;-&#x16b;&#x16e;-&#x17e;&#x18f;&#x1a0;-&#x1a1;&#x1af;-&#x1b0;&#x1b7;&#x1cd;-&#x1d4;&#x1de;-&#x1df;&#x1e4;-&#x1f0;&#x1f4;-&#x1f5;&#x1fa;-&#x1ff;&#x218;-&#x21b;&#x21e;-&#x21f;&#x22a;-&#x22b;&#x22e;-&#x233;&#x259;&#x292;&#x1e02;-&#x1e03;&#x1e0a;-&#x1e0b;&#x1e10;-&#x1e11;&#x1e1e;-&#x1e21;&#x1e24;-&#x1e27;&#x1e30;-&#x1e31;&#x1e40;-&#x1e41;&#x1e44;-&#x1e45;&#x1e56;-&#x1e57;&#x1e60;-&#x1e63;&#x1e6a;-&#x1e6b;&#x1e80;-&#x1e85;&#x1e8c;-&#x1e93;&#x1e9e;&#x1ea0;-&#x1ea7;&#x1eaa;-&#x1eac;&#x1eae;-&#x1ec1;&#x1ec4;-&#x1ed3;&#x1ed6;-&#x1edd;&#x1ee4;-&#x1ef9;&#x20ac;])|(&#x4d;&#x302;|&#x4e;&#x302;|&#x6d;&#x302;|&#x6e;&#x302;|&#x44;&#x302;|&#x64;&#x302;|&#x4a;&#x30c;|&#x4c;&#x302;|&#x6c;&#x302;))*" select="$PruefString">
								<xsl:matching-substring>
									<xsl:value-of select="."/>
								</xsl:matching-substring>
								<xsl:non-matching-substring>
									<span class="{$MeldungsKlasse}">'<xsl:value-of select="."/>'</span>
								</xsl:non-matching-substring>
							</xsl:analyze-string>
						</xsl:when>
						<xsl:otherwise>
						</xsl:otherwise>
					</xsl:choose>
				</xsl:if>

			</xsl:if>

		</xsl:if>
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
				<xsl:if test="$Meldungen = '1'">
					<xsl:call-template name="meldung">
						<xsl:with-param name="nummer">1027</xsl:with-param>
					</xsl:call-template>
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
				<xsl:value-of select="./code/text()"/> 
				<xsl:if test="$Meldungen = '1'">
					<xsl:call-template name="meldung">
						<xsl:with-param name="nummer">1028</xsl:with-param>
					</xsl:call-template>
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
				<xsl:value-of select="./code/text()"/> 
				<xsl:if test="$Meldungen = '1'">
					<xsl:call-template name="meldung">
						<xsl:with-param name="nummer">1029</xsl:with-param>
					</xsl:call-template>
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
				<xsl:value-of select="./code/text()"/> 
				<xsl:if test="$Meldungen = '1'">
					<xsl:call-template name="meldung">
						<xsl:with-param name="nummer">1030</xsl:with-param>
					</xsl:call-template>
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
				<xsl:value-of select="./code/text()"/> 
				<xsl:if test="$Meldungen = '1'">
					<xsl:call-template name="meldung">
						<xsl:with-param name="nummer">1031</xsl:with-param>
					</xsl:call-template>
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
				<xsl:value-of select="./code/text()"/> 
				<xsl:if test="$Meldungen = '1'">
					<xsl:call-template name="meldung">
						<xsl:with-param name="nummer">1032</xsl:with-param>
					</xsl:call-template>
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
				<xsl:value-of select="./code/text()"/> 
				<xsl:if test="$Meldungen = '1'">
					<xsl:call-template name="meldung">
						<xsl:with-param name="nummer">1033</xsl:with-param>
					</xsl:call-template>
				</xsl:if>
			</xsl:otherwise>
		</xsl:choose>
	</xsl:template>
	<xsl:template match="xdf3:ableitungsmodifikationenRepraesentation">
		<xsl:choose>
			<xsl:when test="./code/text() = '0'">nicht modifizierbar</xsl:when>
			<xsl:when test="./code/text() = '1'">modifizierbar</xsl:when>
			<xsl:otherwise>
				<xsl:value-of select="./code/text()"/> 
				<xsl:if test="$Meldungen = '1'">
					<xsl:call-template name="meldung">
						<xsl:with-param name="nummer">1034</xsl:with-param>
					</xsl:call-template>
				</xsl:if>
			</xsl:otherwise>
		</xsl:choose>
	</xsl:template>
	<xsl:template match="xdf3:art">
		<xsl:choose>
			<xsl:when test="./code/text() = 'X'">Auswahlgruppe</xsl:when>
			<xsl:otherwise>
				<xsl:value-of select="./code/text()"/> 
				<xsl:if test="$Meldungen = '1'">
					<xsl:call-template name="meldung">
						<xsl:with-param name="nummer">1042</xsl:with-param>
					</xsl:call-template>
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
				<xsl:value-of select="./code/text()"/> 
				<xsl:if test="$Meldungen = '1'">
					<xsl:call-template name="meldung">
						<xsl:with-param name="nummer">1055</xsl:with-param>
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
	<xsl:template name="aktuellereversion">
		<xsl:param name="ElementVersion"/>
		<xsl:param name="VergleichsVersion"/>

		<xsl:variable name="EVersionMaj" select="xs:integer(tokenize($ElementVersion, '\.')[1])"/>
		<xsl:variable name="EVersionMin" select="xs:integer(tokenize($ElementVersion, '\.')[2])"/>
		<xsl:variable name="EVersionMic" select="xs:integer(tokenize($ElementVersion, '\.')[3])"/>

		<xsl:variable name="VLatestMaj" select="xs:integer(tokenize($VergleichsVersion, '\.')[1])"/>
		<xsl:variable name="VLatestMin" select="xs:integer(tokenize($VergleichsVersion, '\.')[2])"/>
		<xsl:variable name="VLatestMic" select="xs:integer(tokenize($VergleichsVersion, '\.')[3])"/>
		
		<xsl:choose>
			<xsl:when test="fn:string($ElementVersion) = fn:string($VergleichsVersion)"><xsl:value-of select="'false'"/></xsl:when>
			<xsl:when test="not(fn:string($ElementVersion)) or not(fn:string($VergleichsVersion))"><xsl:value-of select="'false'"/></xsl:when>
			<xsl:otherwise>
				<xsl:choose>
					<xsl:when test="$EVersionMaj &lt; $VLatestMaj"><xsl:value-of select="'true'"/></xsl:when>
					<xsl:when test="$EVersionMaj &gt; $VLatestMaj"><xsl:value-of select="'false'"/></xsl:when>
					<xsl:otherwise>
						<xsl:choose>
							<xsl:when test="$EVersionMin &lt; $VLatestMin"><xsl:value-of select="'true'"/></xsl:when>
							<xsl:when test="$EVersionMin &gt; $VLatestMin"><xsl:value-of select="'false'"/></xsl:when>
							<xsl:otherwise>
								<xsl:choose>
									<xsl:when test="$EVersionMic &lt; $VLatestMic"><xsl:value-of select="'true'"/></xsl:when>
									<xsl:otherwise><xsl:value-of select="'false'"/></xsl:otherwise>
								</xsl:choose>
							</xsl:otherwise>
						</xsl:choose>
					</xsl:otherwise>
				</xsl:choose>
			</xsl:otherwise>
		</xsl:choose>

	</xsl:template>
	<!-- ############################################################################################################# -->
	<xsl:template name="meldung">
		<xsl:param name="nummer"/>
		
		<xsl:for-each select="$MeldungenInhalt/gc:CodeList/*:SimpleCodeList/*:Row[*:Value/@ColumnRef ='Code' and *:Value/*:SimpleValue = $nummer]">
			<xsl:choose>
				<xsl:when test="./*:Value[@ColumnRef ='Typ']/*:SimpleValue = 'FehlerKritisch'">
					<div class="FehlerKritisch M{$nummer}">
						FehlerKritisch!! <xsl:value-of select="$nummer"/>: <xsl:value-of select="./*:Value[@ColumnRef ='Meldungstext']/*:SimpleValue"/>
						<xsl:if test="$QSHilfeAufruf = '1'">
							&#160;&#160;
							<xsl:element name="a">
								<xsl:attribute name="href"><xsl:value-of select="$QSHilfePfadPrefix"/>M<xsl:value-of select="$nummer"/><xsl:value-of select="$QSHilfePfadPostfix"/></xsl:attribute>
								<xsl:attribute name="target">MeldungsHilfe</xsl:attribute>
								<xsl:attribute name="title">Springe zu den Erl�uterungen der Meldungscodes in die Qualit�tskriterien.</xsl:attribute>
								&#8658;
							</xsl:element>&#160;&#160;&#160;&#160;
						</xsl:if>
					</div>
				</xsl:when>
				<xsl:when test="./*:Value[@ColumnRef ='Typ']/*:SimpleValue = 'FehlerMethodisch'">
					<div class="FehlerMethodisch M{$nummer}">
						FehlerMethodisch!! <xsl:value-of select="$nummer"/>: <xsl:value-of select="./*:Value[@ColumnRef ='Meldungstext']/*:SimpleValue"/>
						<xsl:if test="$QSHilfeAufruf = '1'">
							&#160;&#160;
							<xsl:element name="a">
								<xsl:attribute name="href"><xsl:value-of select="$QSHilfePfadPrefix"/>M<xsl:value-of select="$nummer"/><xsl:value-of select="$QSHilfePfadPostfix"/></xsl:attribute>
								<xsl:attribute name="target">MeldungsHilfe</xsl:attribute>
								<xsl:attribute name="title">Springe zu den Erl�uterungen der Meldungscodes in die Qualit�tskriterien.</xsl:attribute>
								&#8658;
							</xsl:element>&#160;&#160;&#160;&#160;
						</xsl:if>
					</div>
				</xsl:when>
				<xsl:when test="./*:Value[@ColumnRef ='Typ']/*:SimpleValue = 'Warnung'">
					<div class="Warnung M{$nummer}">
						Warnung!! <xsl:value-of select="$nummer"/>: <xsl:value-of select="./*:Value[@ColumnRef ='Meldungstext']/*:SimpleValue"/>
						<xsl:if test="$QSHilfeAufruf = '1'">
							&#160;&#160;
							<xsl:element name="a">
								<xsl:attribute name="href"><xsl:value-of select="$QSHilfePfadPrefix"/>M<xsl:value-of select="$nummer"/><xsl:value-of select="$QSHilfePfadPostfix"/></xsl:attribute>
								<xsl:attribute name="target">MeldungsHilfe</xsl:attribute>
								<xsl:attribute name="title">Springe zu den Erl�uterungen der Meldungscodes in die Qualit�tskriterien.</xsl:attribute>
								&#8658;
							</xsl:element>&#160;&#160;&#160;&#160;
						</xsl:if>
					</div>
				</xsl:when>
				<xsl:when test="./*:Value[@ColumnRef ='Typ']/*:SimpleValue = 'Hinweis'">
					<div class="Hinweis M{$nummer}">
						Hinweis!! <xsl:value-of select="$nummer"/>: <xsl:value-of select="./*:Value[@ColumnRef ='Meldungstext']/*:SimpleValue"/>
						<xsl:if test="$QSHilfeAufruf = '1'">
							&#160;&#160;
							<xsl:element name="a">
								<xsl:attribute name="href"><xsl:value-of select="$QSHilfePfadPrefix"/>M<xsl:value-of select="$nummer"/><xsl:value-of select="$QSHilfePfadPostfix"/></xsl:attribute>
								<xsl:attribute name="target">MeldungsHilfe</xsl:attribute>
								<xsl:attribute name="title">Springe zu den Erl�uterungen der Meldungscodes in die Qualit�tskriterien.</xsl:attribute>
								&#8658;
							</xsl:element>&#160;&#160;&#160;&#160;
						</xsl:if>
					</div>
				</xsl:when>
				<xsl:when test="./*:Value[@ColumnRef ='Typ']/*:SimpleValue = 'Deaktiviert'">
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
										<a href="#ElementListe">�bersicht der Elemente</a> - <a href="#ElementDetails">Details zu den Baukastenelementen</a> - <a href="#RegelListe">�bersicht der Regeln</a> - <a href="#RegelDetails">Details zu den Regeln</a> - <a href="#FormularListe">�bersicht der Formularsteckbriefe</a> - <a href="#FormularDetails">Details zu den Formularsteckbriefen</a>- <a href="#StammListe">�bersicht der Stammformulare</a> - <a  style="page-break-after:always" href="#StammDetails">Details zu den Stammformularen</a>
	-->
		<xsl:choose>
			<xsl:when test="$Navigation = '1'">
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
			<xsl:if test="$Navigation = '0' or $Navigation = '2' or name(/*) ='xdf3:xdatenfelder.dokumentsteckbrief.0101'">
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
				<xsl:when test="$Navigation = '0' or $Navigation = '2' or name(/*) ='xdf3:xdatenfelder.dokumentsteckbrief.0101'">
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
				<xsl:when test="$Navigation = '0' or $Navigation = '2' or name(/*) ='xdf3:xdatenfelder.dokumentsteckbrief.0101'">
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

			.HinweisText
			{
				color:green;
			}
			
			.WarnungText
			{
				color:blue;
			}
			
			.FehlerMethodischText
			{
				color:orange;
			}

			.FehlerKritischText
			{
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
				<xsl:if test="$Meldungen = '1'">

			function VersteckeMeldungen() {
				const hinweisClass = document.getElementsByClassName('Hinweis');
				const warningClass = document.getElementsByClassName('Warnung');
				const fehlerKritischClass = document.getElementsByClassName('FehlerKritisch');
				const fehlerMethodischClass = document.getElementsByClassName('FehlerMethodisch');
				
				for (i = 0; i <xsl:text disable-output-escaping="yes">&lt;</xsl:text> hinweisClass.length; i++) {
				  hinweisClass[i].style.display='none';
				}
				for (i = 0; i <xsl:text disable-output-escaping="yes">&lt;</xsl:text> warningClass.length; i++) {
				  warningClass[i].style.display='none';
				}
				for (i = 0; i <xsl:text disable-output-escaping="yes">&lt;</xsl:text> fehlerKritischClass.length; i++) {
				  fehlerKritischClass[i].style.display='none';
				}
				for (i = 0; i <xsl:text disable-output-escaping="yes">&lt;</xsl:text> fehlerMethodischClass.length; i++) {
				  fehlerMethodischClass[i].style.display='none';
				}
				document.getElementById('versteckeLink').style.display='none';
				document.getElementById('zeigeLink').style.display='inherit';
				document.getElementById('Zusammenfassungsbereich').style.display='none';
				document.getElementById('ZusammenfassungLink').style.display='none';
			}
			
			function ZeigeMeldungen() {
				const hinweisClass = document.getElementsByClassName('Hinweis');
				const warningClass = document.getElementsByClassName('Warnung');
				const fehlerKritischClass = document.getElementsByClassName('FehlerKritisch');
				const fehlerMethodischClass = document.getElementsByClassName('FehlerMethodisch');
				
				for (i = 0; i <xsl:text disable-output-escaping="yes">&lt;</xsl:text> hinweisClass.length; i++) {
				  hinweisClass[i].style.display='inherit';
				}
				for (i = 0; i <xsl:text disable-output-escaping="yes">&lt;</xsl:text> warningClass.length; i++) {
				  warningClass[i].style.display='inherit';
				}
				for (i = 0; i <xsl:text disable-output-escaping="yes">&lt;</xsl:text> fehlerKritischClass.length; i++) {
				  fehlerKritischClass[i].style.display='inherit';
				}
				for (i = 0; i <xsl:text disable-output-escaping="yes">&lt;</xsl:text> fehlerMethodischClass.length; i++) {
				  fehlerMethodischClass[i].style.display='inherit';
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
					document.getElementById("AnzahlFehlerKritisch").innerHTML = "Anzahl kritischer Fehler: " + AnzahlFehlerKritisch + "<xsl:text disable-output-escaping="yes">&lt;</xsl:text>br/<xsl:text disable-output-escaping="yes">&gt;</xsl:text><xsl:text disable-output-escaping="yes">&lt;</xsl:text>span class='ZusammenfassungHilfe'<xsl:text disable-output-escaping="yes">&gt;</xsl:text>(verhindern den Austausch zwischen Editoren und mit dem Sammelrepository)<xsl:text disable-output-escaping="yes">&lt;</xsl:text>/span<xsl:text disable-output-escaping="yes">&gt;</xsl:text>";
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


				<xsl:for-each select="$MeldungenInhalt/*:CodeList/*:SimpleCodeList/*:Row">
					<xsl:choose>
						<xsl:when test="./*:Value[@ColumnRef ='Typ']/*:SimpleValue = 'FehlerKritisch'">

							if (document.querySelectorAll('.M<xsl:value-of select="./*:Value[@ColumnRef ='Code']/*:SimpleValue"/>').length != 0)
							{
								document.getElementById("ListeFehlerKritisch").insertAdjacentHTML('beforeend', document.querySelectorAll('.M<xsl:value-of select="./*:Value[@ColumnRef ='Code']/*:SimpleValue"/>').length + " mal <xsl:value-of select="./*:Value[@ColumnRef ='Code']/*:SimpleValue"/>: <xsl:value-of select="./*:Value[@ColumnRef ='Meldungstext']/*:SimpleValue"/>" + <xsl:if test="$QSHilfeAufruf = '1'">"&#160;&#160;<xsl:text disable-output-escaping="yes">&lt;</xsl:text>a href='<xsl:value-of select="$QSHilfePfadPrefix"/>M<xsl:value-of select="./*:Value[@ColumnRef ='Code']/*:SimpleValue"/><xsl:value-of select="$QSHilfePfadPostfix"/>' target='MeldungsHilfe' title='Springe zu den Erl�uterungen der Meldungscodes in die Qualit�tskriterien.'<xsl:text disable-output-escaping="yes">&gt;</xsl:text>&#8658;<xsl:text disable-output-escaping="yes">&lt;</xsl:text>/a<xsl:text disable-output-escaping="yes">&gt;</xsl:text>"</xsl:if> + "<xsl:text disable-output-escaping="yes">&lt;</xsl:text>br/<xsl:text disable-output-escaping="yes">&gt;</xsl:text>" );
							}

						</xsl:when>

						<xsl:when test="./*:Value[@ColumnRef ='Typ']/*:SimpleValue = 'FehlerMethodisch'">

							if (document.querySelectorAll('.M<xsl:value-of select="./*:Value[@ColumnRef ='Code']/*:SimpleValue"/>').length != 0)
							{
								document.getElementById("ListeFehlerMethodisch").insertAdjacentHTML('beforeend', document.querySelectorAll('.M<xsl:value-of select="./*:Value[@ColumnRef ='Code']/*:SimpleValue"/>').length + " mal <xsl:value-of select="./*:Value[@ColumnRef ='Code']/*:SimpleValue"/>: <xsl:value-of select="./*:Value[@ColumnRef ='Meldungstext']/*:SimpleValue"/>" + <xsl:if test="$QSHilfeAufruf = '1'">"&#160;&#160;<xsl:text disable-output-escaping="yes">&lt;</xsl:text>a href='<xsl:value-of select="$QSHilfePfadPrefix"/>M<xsl:value-of select="./*:Value[@ColumnRef ='Code']/*:SimpleValue"/><xsl:value-of select="$QSHilfePfadPostfix"/>' target='MeldungsHilfe' title='Springe zu den Erl�uterungen der Meldungscodes in die Qualit�tskriterien.'<xsl:text disable-output-escaping="yes">&gt;</xsl:text>&#8658;<xsl:text disable-output-escaping="yes">&lt;</xsl:text>/a<xsl:text disable-output-escaping="yes">&gt;</xsl:text>"</xsl:if> + "<xsl:text disable-output-escaping="yes">&lt;</xsl:text>br/<xsl:text disable-output-escaping="yes">&gt;</xsl:text>");
							}

						</xsl:when>

						<xsl:when test="./*:Value[@ColumnRef ='Typ']/*:SimpleValue = 'Warnung'">

							if (document.querySelectorAll('.M<xsl:value-of select="./*:Value[@ColumnRef ='Code']/*:SimpleValue"/>').length != 0)
							{
								document.getElementById("ListeWarnungen").insertAdjacentHTML('beforeend', document.querySelectorAll('.M<xsl:value-of select="./*:Value[@ColumnRef ='Code']/*:SimpleValue"/>').length + " mal <xsl:value-of select="./*:Value[@ColumnRef ='Code']/*:SimpleValue"/>: <xsl:value-of select="./*:Value[@ColumnRef ='Meldungstext']/*:SimpleValue"/>" + <xsl:if test="$QSHilfeAufruf = '1'">"&#160;&#160;<xsl:text disable-output-escaping="yes">&lt;</xsl:text>a href='<xsl:value-of select="$QSHilfePfadPrefix"/>M<xsl:value-of select="./*:Value[@ColumnRef ='Code']/*:SimpleValue"/><xsl:value-of select="$QSHilfePfadPostfix"/>' target='MeldungsHilfe' title='Springe zu den Erl�uterungen der Meldungscodes in die Qualit�tskriterien.'<xsl:text disable-output-escaping="yes">&gt;</xsl:text>&#8658;<xsl:text disable-output-escaping="yes">&lt;</xsl:text>/a<xsl:text disable-output-escaping="yes">&gt;</xsl:text>"</xsl:if> + "<xsl:text disable-output-escaping="yes">&lt;</xsl:text>br/<xsl:text disable-output-escaping="yes">&gt;</xsl:text>");
							}

						</xsl:when>

						<xsl:when test="./*:Value[@ColumnRef ='Typ']/*:SimpleValue = 'Hinweis'">

							if (document.querySelectorAll('.M<xsl:value-of select="./*:Value[@ColumnRef ='Code']/*:SimpleValue"/>').length != 0)
							{
								document.getElementById("ListeHinweise").insertAdjacentHTML('beforeend', document.querySelectorAll('.M<xsl:value-of select="./*:Value[@ColumnRef ='Code']/*:SimpleValue"/>').length + " mal <xsl:value-of select="./*:Value[@ColumnRef ='Code']/*:SimpleValue"/>: <xsl:value-of select="./*:Value[@ColumnRef ='Meldungstext']/*:SimpleValue"/>" + <xsl:if test="$QSHilfeAufruf = '1'">"&#160;&#160;<xsl:text disable-output-escaping="yes">&lt;</xsl:text>a href='<xsl:value-of select="$QSHilfePfadPrefix"/>M<xsl:value-of select="./*:Value[@ColumnRef ='Code']/*:SimpleValue"/><xsl:value-of select="$QSHilfePfadPostfix"/>' target='MeldungsHilfe' title='Springe zu den Erl�uterungen der Meldungscodes in die Qualit�tskriterien.'<xsl:text disable-output-escaping="yes">&gt;</xsl:text>&#8658;<xsl:text disable-output-escaping="yes">&lt;</xsl:text>/a<xsl:text disable-output-escaping="yes">&gt;</xsl:text>"</xsl:if> + "<xsl:text disable-output-escaping="yes">&lt;</xsl:text>br/<xsl:text disable-output-escaping="yes">&gt;</xsl:text>");
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
