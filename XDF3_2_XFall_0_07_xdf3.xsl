<?xml version="1.0" encoding="iso-8859-1"?>
<xsl:stylesheet version="2.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:xdf3="urn:xoev-de:fim:standard:xdatenfelder_3.0.0" xmlns:xs="http://www.w3.org/2001/XMLSchema" xmlns:html="http://www.w3.org/1999/xhtml" xmlns:fn="http://www.w3.org/2005/xpath-functions" xmlns:xdf="urn:xoev-de:fim:standard:xdatenfelder_2" xmlns:gc="http://docs.oasis-open.org/codelist/ns/genericode/1.0/" xmlns:ext="http://www.xoev.de/de/xrepository/framework/1/extrakte" xmlns:bdt="http://www.xoev.de/de/xrepository/framework/1/basisdatentypen" xmlns:dat="http://www.xoev.de/de/xrepository/framework/1/datenbereitstellung" xmlns:svrl="http://purl.oclc.org/dsdl/svrl" exclude-result-prefixes="html xsl fn xdf3 gc xdf">

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

	<xsl:variable name="StyleSheetName" select="'XDF3_2_XFall_0_07_xdf3.xsl'"/> <!-- BackUp, falls fn:static-base-uri() leer -->

	<xsl:output method="xml" omit-xml-declaration="no"/>
	<xsl:strip-space elements="*"/>

	<xsl:param name="Annotationen" select="'1'"/>
	<xsl:param name="Praezisierungen" select="'1'"/>
	<xsl:param name="AktuelleCodelisteLaden" select="'1'"/>
	<xsl:param name="DateiOutput" select="'0'"/>
	<xsl:param name="DebugMode" select="'3'"/>
	<xsl:variable name="XMLXRepoMitVersionPfadPrefix" select="'https://www.xrepository.de/api/version_codeliste/'"/>
	<xsl:variable name="XMLXRepoMitVersionPfadPostfix" select="'/genericode'"/>
	<xsl:variable name="XMLXRepoOhneVersionPfadPrefix" select="'https://www.xrepository.de/api/codeliste/'"/>
	<xsl:variable name="XMLXRepoOhneVersionPfadPostfix" select="'/gueltigeVersion'"/>

	<xsl:variable name="InputDateiname" select="tokenize($DocumentURI,'/')[last()]"/>
	<xsl:variable name="InputPfad" select="fn:substring-before($DocumentURI, $InputDateiname)"/>

	<xsl:variable name="OutputDateiname"><xsl:value-of select="fn:substring-before($InputDateiname,'.xml')"/>_xfall.xsd</xsl:variable>


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
				Annotationen: <xsl:value-of select="$Annotationen"/>
				DateiOutput: <xsl:value-of select="$DateiOutput"/>
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
			<xsl:when test="name(/*) ='xdf3:xdatenfelder.stammdatenschema.0102'">

				<xs:schema xmlns:xs="http://www.w3.org/2001/XMLSchema" 	xmlns="urn:fim-de:xfall:datenschema:xdf3" targetNamespace="urn:fim-de:xfall:datenschema:xdf3" xmlns:vc="http://www.w3.org/2007/XMLSchema-versioning" elementFormDefault="qualified" attributeFormDefault="unqualified">

					<xsl:comment><xsl:text>           </xsl:text>Erstellt am: <xsl:value-of select="format-date(fn:current-date(),'[D01].[M01].[Y0001]')"/> um <xsl:value-of select="format-time(fn:current-time(),'[H01]:[m01]')"/> Uhr<xsl:text>           </xsl:text>XSLT: <xsl:choose><xsl:when test="empty($StyleSheetURI)"><xsl:value-of select="$StyleSheetName"/></xsl:when><xsl:otherwise><xsl:call-template name="fileName"><xsl:with-param name="path" select="$StyleSheetURI"/></xsl:call-template></xsl:otherwise></xsl:choose><xsl:if test="not(empty($DocumentURI))"><xsl:text>           </xsl:text>XML: <xsl:call-template name="fileName"><xsl:with-param name="path" select="$DocumentURI"/></xsl:call-template></xsl:if><xsl:text>           </xsl:text></xsl:comment>

					<xsl:apply-templates select="./*/xdf3:stammdatenschema"/>

					<xsl:for-each-group select="//xdf3:datenfeldgruppe" group-by="concat(xdf3:identifikation/xdf3:id,xdf3:identifikation/xdf3:version)">
						<xsl:apply-templates select="."/>
					</xsl:for-each-group>

					<xsl:for-each-group select="//xdf3:datenfeld" group-by="concat(xdf3:identifikation/xdf3:id,xdf3:identifikation/xdf3:version)">
						<xsl:apply-templates select="."/>
					</xsl:for-each-group>
					
				</xs:schema>
	
			</xsl:when>
			<xsl:otherwise>
			</xsl:otherwise>
		</xsl:choose>
	
	</xsl:template>

	<!-- ############################################################################################################# -->
	
	<xsl:template match="xdf3:stammdatenschema | xdf3:datenfeldgruppe">
		
		<xsl:if test="$DebugMode = '2' or $DebugMode = '3' or $DebugMode = '4'">
			<xsl:message>
				++++ stammdatenschema / datenfeldgruppe++++
				Element: <xsl:value-of select="./xdf3:identifikation/xdf3:id"/>
			</xsl:message>
		</xsl:if>
		
			<xsl:variable name="ElementName">
				<xsl:call-template name="elementname">
					<xsl:with-param name="identifikation" select="./xdf3:identifikation"/>
				</xsl:call-template>
			</xsl:variable>
			
			<xs:element name="{$ElementName}">
				<xsl:if test="$Annotationen = '1'">
					<xs:annotation>
						<xsl:choose>
							<xsl:when test="./name() = 'xdf3:datenfeldgruppe'">
								<xs:documentation>Feldgruppe: <xsl:value-of select="./xdf3:name"/></xs:documentation>
							</xsl:when>
							<xsl:otherwise>
								<xs:documentation>Datenschema: <xsl:value-of select="./xdf3:name"/></xs:documentation>
							</xsl:otherwise>
						</xsl:choose>
					</xs:annotation>
				</xsl:if>
				<xs:complexType>
					<xsl:choose>
						<xsl:when test="./xdf3:art/code/text()='X'">
							<xs:choice>
								<xsl:call-template name="struktur">
									<xsl:with-param name="Element" select="."/>
								</xsl:call-template>
							</xs:choice>
						</xsl:when>
						<xsl:otherwise>
							<xs:sequence>
								<xsl:call-template name="struktur">
									<xsl:with-param name="Element" select="."/>
								</xsl:call-template>
							</xs:sequence>
						</xsl:otherwise>
					</xsl:choose>
				</xs:complexType>


			</xs:element>

	</xsl:template>
	
	<!-- ############################################################################################################# -->
	
	<xsl:template match="xdf3:datenfeld">

		<xsl:if test="$DebugMode = '2' or $DebugMode = '3' or $DebugMode = '4'">
			<xsl:message>
				++++ datenfeld++++
				Element: <xsl:value-of select="./xdf3:identifikation/xdf3:id"/>
			</xsl:message>
		</xsl:if>
		
			<xsl:variable name="ElementName">
				<xsl:call-template name="elementname">
					<xsl:with-param name="identifikation" select="./xdf3:identifikation"/>
				</xsl:call-template>
			</xsl:variable>

			<xs:element name="{$ElementName}">
				<xsl:choose>
					<xsl:when test="./xdf3:feldart/code/text() = 'label'">
						<xsl:attribute name="type">xs:string</xsl:attribute>
						<xsl:if test="$Annotationen = '1'">
							<xs:annotation>
								<xs:documentation>Feld: <xsl:value-of select="./xdf3:name"/> - Typ: Hinweistext</xs:documentation>
							</xs:annotation>
						</xsl:if>
					</xsl:when>
					<xsl:when test="./xdf3:feldart/code/text() = 'select'">
						<xsl:choose>
							<xsl:when test="$Praezisierungen = '1'">
								<xsl:choose>
									<xsl:when test="./xdf3:werte">
										<xsl:if test="$Annotationen = '1'">
											<xs:annotation>
												<xs:documentation>Feld: <xsl:value-of select="./xdf3:name"/> - Typ: Auswahlliste (Werteliste)</xs:documentation>
											</xs:annotation>
										</xsl:if>
										<xs:simpleType>
											<xs:restriction base="xs:token">
												<xsl:for-each select="./xdf3:werte/xdf3:wert">
													<xs:enumeration value="{./xdf3:code}">
														<xsl:if test="$Annotationen = '1'">
															<xs:annotation>
																<xs:documentation>Auswahlwert: <xsl:value-of select="./xdf3:name"/></xs:documentation>
															</xs:annotation>
														</xsl:if>
													</xs:enumeration>
												</xsl:for-each>
											</xs:restriction>
										</xs:simpleType>
									</xsl:when>
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
														<xsl:when test="(fn:string-length($CodelisteAbfrageInhalt) &lt; 10) or ($AktuelleCodelisteLaden = '0')">unbestimmt</xsl:when>
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
												<xsl:attribute name="type">xs:string</xsl:attribute>
												<xsl:if test="$Annotationen = '1'">
													<xsl:choose>
														<xsl:when test="not(empty(./xdf3:codelisteReferenz/xdf3:version/text()))">
															<xs:annotation>
																<xs:documentation>Feld: <xsl:value-of select="./xdf3:name"/> - Typ: Auswahlliste (Externe Codeliste: <xsl:value-of select="./xdf3:codelisteReferenz/xdf3:canonicalIdentification"/>_<xsl:value-of select="./xdf3:codelisteReferenz/xdf3:version"/> konnte nicht geladen werden)</xs:documentation>
															</xs:annotation>
														</xsl:when>
														<xsl:when test="$RichtigeVersion/text() != 'unbestimmt'">
															<xs:annotation>
																<xs:documentation>Feld: <xsl:value-of select="./xdf3:name"/> - Typ: Auswahlliste (Externe Codeliste: <xsl:value-of select="./xdf3:codelisteReferenz/xdf3:canonicalIdentification"/> in der aktuellen Version <xsl:value-of select="$RichtigeVersion"/> konnte nicht geladen werden)</xs:documentation>
															</xs:annotation>
														</xsl:when>
														<xsl:otherwise>
															<xs:annotation>
																<xs:documentation>Feld: <xsl:value-of select="./xdf3:name"/> - Typ: Auswahlliste (Externe Codeliste: <xsl:value-of select="./xdf3:codelisteReferenz/xdf3:canonicalIdentification"/> konnte nicht geladen werden)</xs:documentation>
															</xs:annotation>
														</xsl:otherwise>
													</xsl:choose>
												</xsl:if>
											</xsl:when>
											<xsl:otherwise>
												<xsl:if test="$Annotationen = '1'">
													<xsl:choose>
														<xsl:when test="not(empty(./xdf3:codelisteReferenz/xdf3:version/text()))">
															<xs:annotation>
																<xs:documentation>Feld: <xsl:value-of select="./xdf3:name"/> - Typ: Auswahlliste (Externe Codeliste: <xsl:value-of select="./xdf3:codelisteReferenz/xdf3:canonicalIdentification"/>_<xsl:value-of select="./xdf3:codelisteReferenz/xdf3:version"/>)</xs:documentation>
															</xs:annotation>
														</xsl:when>
														<xsl:otherwise>
															<xs:annotation>
																<xs:documentation>Feld: <xsl:value-of select="./xdf3:name"/> - Typ: Auswahlliste (Externe Codeliste: <xsl:value-of select="./xdf3:codelisteReferenz/xdf3:canonicalIdentification"/> in der aktuellen Version <xsl:value-of select="$RichtigeVersion"/>)</xs:documentation>
															</xs:annotation>
														</xsl:otherwise>
													</xsl:choose>
												</xsl:if>
												<xsl:variable name="NameCodeKey"><xsl:value-of select="$CodelisteInhalt/*/gc:ColumnSet/gc:Key[1]/gc:ColumnRef/@Ref"/><xsl:value-of select="$CodelisteInhalt/*/ColumnSet/Key[1]/ColumnRef/@Ref"/></xsl:variable>
												<xsl:variable name="NameCodenameKey"><xsl:value-of select="$CodelisteInhalt/*/gc:ColumnSet/(gc:Column[@Id != $NameCodeKey])[1]/@Id"/><xsl:value-of select="$CodelisteInhalt/*/ColumnSet/(Column[@Id != $NameCodeKey])[1]/@Id"/></xsl:variable>
												
												<xs:simpleType>
													<xs:restriction base="xs:token">


														<xsl:for-each-group select="$CodelisteInhalt/*/gc:SimpleCodeList/gc:Row" group-by="gc:Value[@ColumnRef=$NameCodenameKey]">
															<xs:enumeration value="{./gc:Value[@ColumnRef=$NameCodeKey]}">
																<xsl:if test="$Annotationen = '1'">
																	<xs:annotation>
																		<xs:documentation>Auswahlwert: <xsl:value-of select="./gc:Value[@ColumnRef=$NameCodenameKey]"/></xs:documentation>
																	</xs:annotation>
																</xsl:if>
															</xs:enumeration>
														</xsl:for-each-group>
														<xsl:for-each-group select="$CodelisteInhalt/*/SimpleCodeList/Row" group-by="Value[@ColumnRef=$NameCodenameKey]">
															<xs:enumeration value="{./Value[@ColumnRef=$NameCodeKey]}">
																<xsl:if test="$Annotationen = '1'">
																	<xs:annotation>
																		<xs:documentation>Auswahlwert: <xsl:value-of select="./Value[@ColumnRef=$NameCodenameKey]"/></xs:documentation>
																	</xs:annotation>
																</xsl:if>
															</xs:enumeration>
														</xsl:for-each-group>

													</xs:restriction>
												</xs:simpleType>

											
											</xsl:otherwise>
										</xsl:choose>
									</xsl:when>
									<xsl:otherwise>
										<xsl:attribute name="type">xs:string</xsl:attribute>
										<xsl:if test="$Annotationen = '1'">
											<xs:annotation>
												<xs:documentation>Feld: <xsl:value-of select="./xdf3:name"/> - Typ: Auswahlliste (Keine Angabe einer Werte- oder Codeliste)</xs:documentation>
											</xs:annotation>
										</xsl:if>
									</xsl:otherwise>
								</xsl:choose>
							</xsl:when>
							<xsl:otherwise>
								<xsl:attribute name="type">xs:string</xsl:attribute>
								<xsl:choose>
									<xsl:when test="./xdf3:werte">
										<xsl:if test="$Annotationen = '1'">
											<xs:annotation>
												<xs:documentation>Feld: <xsl:value-of select="./xdf3:name"/> - Typ: Auswahlliste (Werteliste)</xs:documentation>
											</xs:annotation>
										</xsl:if>
									</xsl:when>
									<xsl:when test="./xdf3:codelisteReferenz">
										<xsl:choose>
											<xsl:when test="./xdf3:codelisteReferenz/xdf3:version">
												<xsl:if test="$Annotationen = '1'">
													<xs:annotation>
														<xs:documentation>Feld: <xsl:value-of select="./xdf3:name"/> - Typ: Auswahlliste (Externe Codeliste: <xsl:value-of select="./xdf3:codelisteReferenz/xdf3:canonicalIdentification"/>_<xsl:value-of select="./xdf3:codelisteReferenz/xdf3:version"/>)</xs:documentation>
													</xs:annotation>
												</xsl:if>
											</xsl:when>
											<xsl:otherwise>
												<xsl:if test="$Annotationen = '1'">
													<xs:annotation>
														<xs:documentation>Feld: <xsl:value-of select="./xdf3:name"/> - Typ: Auswahlliste (Externe Codeliste: <xsl:value-of select="./xdf3:codelisteReferenz/xdf3:canonicalIdentification"/> ohne Versionsangabe)</xs:documentation>
													</xs:annotation>
												</xsl:if>
											</xsl:otherwise>
										</xsl:choose>
									</xsl:when>
									<xsl:otherwise>
										<xsl:if test="$Annotationen = '1'">
											<xs:annotation>
												<xs:documentation>Feld: <xsl:value-of select="./xdf3:name"/> - Typ: Auswahlliste (Keine Angabe einer Werte- oder Codeliste)</xs:documentation>
											</xs:annotation>
										</xsl:if>
									</xsl:otherwise>
								</xsl:choose>
							</xsl:otherwise>
						</xsl:choose>
					</xsl:when>
					<xsl:when test="./xdf3:datentyp/code/text() = 'text' or ./xdf3:datentyp/code/text() = 'text_latin'">
						<xsl:choose>
							<xsl:when test="$Praezisierungen = '1' and ./xdf3:praezisierung">
								<xsl:if test="$Annotationen = '1'">
									<xs:annotation>
										<xs:documentation>Feld: <xsl:value-of select="./xdf3:name"/> - Wertebereich: Text</xs:documentation>
									</xs:annotation>
								</xsl:if>
								<xs:simpleType>
									<xs:restriction base="xs:string">
										<xsl:if test="./xdf3:praezisierung/@minLength and ./xdf3:praezisierung/@minLength != ''">
											<xs:minLength value="{./xdf3:praezisierung/@minLength}"/>
										</xsl:if>
										<xsl:if test="./xdf3:praezisierung/@maxLength and ./xdf3:praezisierung/@maxLength != ''">
											<xs:maxLength value="{./xdf3:praezisierung/@maxLength}"/>
										</xsl:if>
										<xsl:if test="./xdf3:praezisierung/@pattern and ./xdf3:praezisierung/@pattern != ''">
											<xs:pattern value="{./xdf3:praezisierung/@pattern}"/>
										</xsl:if>
									</xs:restriction>
								</xs:simpleType>
							</xsl:when>
							<xsl:otherwise>
								<xsl:attribute name="type">xs:string</xsl:attribute>
								<xsl:if test="$Annotationen = '1'">
									<xs:annotation>
										<xs:documentation>Feld: <xsl:value-of select="./xdf3:name"/> - Wertebereich: Text</xs:documentation>
									</xs:annotation>
								</xsl:if>
							</xsl:otherwise>
						</xsl:choose>
					</xsl:when>
					<xsl:when test="./xdf3:datentyp/code/text() = 'date'">
						<xsl:choose>
							<xsl:when test="$Praezisierungen = '1' and ./xdf3:praezisierung">
								<xsl:if test="$Annotationen = '1'">
									<xs:annotation>
										<xs:documentation>Feld: <xsl:value-of select="./xdf3:name"/> - Wertebereich: Datum</xs:documentation>
									</xs:annotation>
								</xsl:if>
								<xs:simpleType>
									<xs:restriction base="xs:date">
										<xsl:if test="./xdf3:praezisierung/@minValue and ./xdf3:praezisierung/@minValue != ''">
											<xs:minInclusive value="{./xdf3:praezisierung/@minValue}"/>
										</xsl:if>
										<xsl:if test="./xdf3:praezisierung/@maxValue and ./xdf3:praezisierung/@maxValue != ''">
											<xs:maxInclusive value="{./xdf3:praezisierung/@maxValue}"/>
										</xsl:if>
										<xsl:if test="./xdf3:praezisierung/@pattern and ./xdf3:praezisierung/@pattern != ''">
											<xs:pattern value="{./xdf3:praezisierung/@pattern}"/>
										</xsl:if>
									</xs:restriction>
								</xs:simpleType>
							</xsl:when>
							<xsl:otherwise>
								<xsl:attribute name="type">xs:date</xsl:attribute>
								<xsl:if test="$Annotationen = '1'">
									<xs:annotation>
										<xs:documentation>Feld: <xsl:value-of select="./xdf3:name"/> - Wertebereich: Datum</xs:documentation>
									</xs:annotation>
								</xsl:if>
							</xsl:otherwise>
						</xsl:choose>
					</xsl:when>
					<xsl:when test="./xdf3:datentyp/code/text() = 'time'">
						<xsl:choose>
							<xsl:when test="$Praezisierungen = '1' and ./xdf3:praezisierung">
								<xsl:if test="$Annotationen = '1'">
									<xs:annotation>
										<xs:documentation>Feld: <xsl:value-of select="./xdf3:name"/> - Wertebereich: Zeit</xs:documentation>
									</xs:annotation>
								</xsl:if>
								<xs:simpleType>
									<xs:restriction base="xs:time">
										<xsl:if test="./xdf3:praezisierung/@minValue and ./xdf3:praezisierung/@minValue != ''">
											<xs:minInclusive value="{./xdf3:praezisierung/@minValue}"/>
										</xsl:if>
										<xsl:if test="./xdf3:praezisierung/@maxValue and ./xdf3:praezisierung/@maxValue != ''">
											<xs:maxInclusive value="{./xdf3:praezisierung/@maxValue}"/>
										</xsl:if>
										<xsl:if test="./xdf3:praezisierung/@pattern and ./xdf3:praezisierung/@pattern != ''">
											<xs:pattern value="{./xdf3:praezisierung/@pattern}"/>
										</xsl:if>
									</xs:restriction>
								</xs:simpleType>
							</xsl:when>
							<xsl:otherwise>
								<xsl:attribute name="type">xs:time</xsl:attribute>
								<xsl:if test="$Annotationen = '1'">
									<xs:annotation>
										<xs:documentation>Feld: <xsl:value-of select="./xdf3:name"/> - Wertebereich: Zeit</xs:documentation>
									</xs:annotation>
								</xsl:if>
							</xsl:otherwise>
						</xsl:choose>
					</xsl:when>
					<xsl:when test="./xdf3:datentyp/code/text() = 'datetime'">
						<xsl:choose>
							<xsl:when test="$Praezisierungen = '1' and ./xdf3:praezisierung">
								<xsl:if test="$Annotationen = '1'">
									<xs:annotation>
										<xs:documentation>Feld: <xsl:value-of select="./xdf3:name"/> - Wertebereich: Zeitpunkt</xs:documentation>
									</xs:annotation>
								</xsl:if>
								<xs:simpleType>
									<xs:restriction base="xs:dateTime">
										<xsl:if test="./xdf3:praezisierung/@minValue and ./xdf3:praezisierung/@minValue != ''">
											<xs:minInclusive value="{./xdf3:praezisierung/@minValue}"/>
										</xsl:if>
										<xsl:if test="./xdf3:praezisierung/@maxValue and ./xdf3:praezisierung/@maxValue != ''">
											<xs:maxInclusive value="{./xdf3:praezisierung/@maxValue}"/>
										</xsl:if>
										<xsl:if test="./xdf3:praezisierung/@pattern and ./xdf3:praezisierung/@pattern != ''">
											<xs:pattern value="{./xdf3:praezisierung/@pattern}"/>
										</xsl:if>
									</xs:restriction>
								</xs:simpleType>
							</xsl:when>
							<xsl:otherwise>
								<xsl:attribute name="type">xs:dateTime</xsl:attribute>
								<xsl:if test="$Annotationen = '1'">
									<xs:annotation>
										<xs:documentation>Feld: <xsl:value-of select="./xdf3:name"/> - Wertebereich: Zeitpunkt</xs:documentation>
									</xs:annotation>
								</xsl:if>
							</xsl:otherwise>
						</xsl:choose>
					</xsl:when>
					<xsl:when test="./xdf3:datentyp/code/text() = 'bool'">
						<xsl:attribute name="type">xs:boolean</xsl:attribute>
						<xsl:if test="$Annotationen = '1'">
							<xs:annotation>
								<xs:documentation>Feld: <xsl:value-of select="./xdf3:name"/> - Wertebereich: Wahrheitswert</xs:documentation>
							</xs:annotation>
						</xsl:if>
					</xsl:when>
					<xsl:when test="./xdf3:datentyp/code/text() = 'num'">
						<xsl:choose>
							<xsl:when test="$Praezisierungen = '1' and ./xdf3:praezisierung">
								<xsl:if test="$Annotationen = '1'">
									<xs:annotation>
										<xs:documentation>Feld: <xsl:value-of select="./xdf3:name"/> - Wertebereich: Fließkommazahl</xs:documentation>
									</xs:annotation>
								</xsl:if>
								<xs:simpleType>
									<xs:restriction base="xs:float">
										<xsl:if test="./xdf3:praezisierung/@minValue and ./xdf3:praezisierung/@minValue != ''">
											<xs:minInclusive value="{./xdf3:praezisierung/@minValue}"/>
										</xsl:if>
										<xsl:if test="./xdf3:praezisierung/@maxValue and ./xdf3:praezisierung/@maxValue != ''">
											<xs:maxInclusive value="{./xdf3:praezisierung/@maxValue}"/>
										</xsl:if>
										<xsl:if test="./xdf3:praezisierung/@pattern and ./xdf3:praezisierung/@pattern != ''">
											<xs:pattern value="{./xdf3:praezisierung/@pattern}"/>
										</xsl:if>
									</xs:restriction>
								</xs:simpleType>
							</xsl:when>
							<xsl:otherwise>
								<xsl:attribute name="type">xs:float</xsl:attribute>
								<xsl:if test="$Annotationen = '1'">
									<xs:annotation>
										<xs:documentation>Feld: <xsl:value-of select="./xdf3:name"/> - Wertebereich: Fließkommazahl</xs:documentation>
									</xs:annotation>
								</xsl:if>
							</xsl:otherwise>
						</xsl:choose>
					</xsl:when>
					<xsl:when test="./xdf3:datentyp/code/text() = 'num_int'">
						<xsl:choose>
							<xsl:when test="$Praezisierungen = '1' and ./xdf3:praezisierung">
								<xsl:if test="$Annotationen = '1'">
									<xs:annotation>
										<xs:documentation>Feld: <xsl:value-of select="./xdf3:name"/> - Wertebereich: Ganzzahl</xs:documentation>
									</xs:annotation>
								</xsl:if>
								<xs:simpleType>
									<xs:restriction base="xs:integer">
										<xsl:if test="./xdf3:praezisierung/@minValue and ./xdf3:praezisierung/@minValue != ''">
											<xs:minInclusive value="{./xdf3:praezisierung/@minValue}"/>
										</xsl:if>
										<xsl:if test="./xdf3:praezisierung/@maxValue and ./xdf3:praezisierung/@maxValue != ''">
											<xs:maxInclusive value="{./xdf3:praezisierung/@maxValue}"/>
										</xsl:if>
										<xsl:if test="./xdf3:praezisierung/@pattern and ./xdf3:praezisierung/@pattern != ''">
											<xs:pattern value="{./xdf3:praezisierung/@pattern}"/>
										</xsl:if>
									</xs:restriction>
								</xs:simpleType>
							</xsl:when>
							<xsl:otherwise>
								<xsl:attribute name="type">xs:integer</xsl:attribute>
								<xsl:if test="$Annotationen = '1'">
									<xs:annotation>
										<xs:documentation>Feld: <xsl:value-of select="./xdf3:name"/> - Wertebereich: Ganzzahl</xs:documentation>
									</xs:annotation>
								</xsl:if>
							</xsl:otherwise>
						</xsl:choose>
					</xsl:when>
					<xsl:when test="./xdf3:datentyp/code/text() = 'num_currency'">
						<xsl:choose>
							<xsl:when test="$Praezisierungen = '1' and ./xdf3:praezisierung">
								<xsl:if test="$Annotationen = '1'">
									<xs:annotation>
										<xs:documentation>Feld: <xsl:value-of select="./xdf3:name"/> - Wertebereich: Währungswert</xs:documentation>
									</xs:annotation>
								</xsl:if>
								<xs:simpleType>
									<xs:restriction base="xs:decimal">
										<xsl:if test="./xdf3:praezisierung/@minValue and ./xdf3:praezisierung/@minValue != ''">
											<xs:minInclusive value="{./xdf3:praezisierung/@minValue}"/>
										</xsl:if>
										<xsl:if test="./xdf3:praezisierung/@maxValue and ./xdf3:praezisierung/@maxValue != ''">
											<xs:maxInclusive value="{./xdf3:praezisierung/@maxValue}"/>
										</xsl:if>
										<xsl:if test="./xdf3:praezisierung/@pattern and ./xdf3:praezisierung/@pattern != ''">
											<xs:pattern value="{./xdf3:praezisierung/@pattern}"/>
										</xsl:if>
									</xs:restriction>
								</xs:simpleType>
							</xsl:when>
							<xsl:otherwise>
								<xsl:attribute name="type">xs:decimal</xsl:attribute>
								<xsl:if test="$Annotationen = '1'">
									<xs:annotation>
										<xs:documentation>Feld: <xsl:value-of select="./xdf3:name"/> - Wertebereich: Währungswert</xs:documentation>
									</xs:annotation>
								</xsl:if>
							</xsl:otherwise>
						</xsl:choose>
					</xsl:when>
					<xsl:when test="./xdf3:datentyp/code/text() = 'file'">
						<xsl:attribute name="type">xs:anyType</xsl:attribute>
						<xsl:if test="$Annotationen = '1'">
							<xs:annotation>
								<xs:documentation>Feld: <xsl:value-of select="./xdf3:name"/> - Wertebereich: Anlage</xs:documentation>
							</xs:annotation>
						</xsl:if>
					</xsl:when>
					<xsl:when test="./xdf3:datentyp/code/text() = 'obj'">
						<xsl:attribute name="type">xs:anyType</xsl:attribute>
						<xsl:if test="$Annotationen = '1'">
							<xs:annotation>
								<xs:documentation>Feld: <xsl:value-of select="./xdf3:name"/> - Wertebereich: Statisches Objekt</xs:documentation>
							</xs:annotation>
						</xsl:if>
					</xsl:when>
					<xsl:otherwise>
						<xsl:attribute name="type">xs:anyType</xsl:attribute>
						<xsl:if test="$Annotationen = '1'">
							<xs:annotation>
								<xs:documentation>Feld: <xsl:value-of select="./xdf3:name"/> - Wertebereich: Unbekannt</xs:documentation>
							</xs:annotation>
						</xsl:if>
					</xsl:otherwise>
				</xsl:choose>
			</xs:element>

		
	</xsl:template>

	<!-- ############################################################################################################# -->
	
	<xsl:template name="struktur">
		<xsl:param name="Element"/>

		<xsl:if test="$DebugMode = '3' or $DebugMode = '4'">
			<xsl:message>
				++++ struktur ++++
			</xsl:message>
		</xsl:if>

		<xsl:for-each select="$Element/xdf3:struktur">
			<xsl:variable name="UnterelementName">
				<xsl:call-template name="elementname">
					<xsl:with-param name="identifikation" select="./xdf3:enthaelt/*/xdf3:identifikation"/>
				</xsl:call-template>
			</xsl:variable>
			<xsl:variable name="Min">
				<xsl:choose>
					<xsl:when test="./xdf3:enthaelt/*/xdf3:feldart/code/text() = 'label'">0</xsl:when>
					<xsl:otherwise><xsl:value-of select="tokenize(./xdf3:anzahl/text(),':')[1]"/></xsl:otherwise>
				</xsl:choose>
			</xsl:variable>
			<xsl:variable name="Max">
				<xsl:choose>
					<xsl:when test="./xdf3:enthaelt/*/xdf3:feldart/code/text() = 'label'">0</xsl:when>
					<xsl:otherwise><xsl:value-of select="tokenize(./xdf3:anzahl/text(),':')[2]"/></xsl:otherwise>
				</xsl:choose>
			</xsl:variable>
			<xsl:element name="xs:element">
				<xsl:attribute name="ref"><xsl:value-of select="$UnterelementName"/></xsl:attribute>
				<xsl:if test="$Min != '1'">
					<xsl:attribute name="minOccurs"><xsl:value-of select="$Min"/></xsl:attribute>
				</xsl:if>
				<xsl:choose>
					<xsl:when test="$Max = '*'">
						<xsl:attribute name="maxOccurs">unbounded</xsl:attribute>
					</xsl:when>
					<xsl:when test="$Max = '1'">
					</xsl:when>
					<xsl:otherwise>
						<xsl:attribute name="maxOccurs"><xsl:value-of select="$Max"/></xsl:attribute>
					</xsl:otherwise>
				</xsl:choose>
			</xsl:element>
		</xsl:for-each>


	</xsl:template>

	<!-- ############################################################################################################# -->
	
	<xsl:template name="elementname">
		<xsl:param name="identifikation"/>

		<xsl:if test="$DebugMode = '4'">
			<xsl:message>
				++++ elementname ++++
			</xsl:message>
		</xsl:if>
		
		<xsl:choose>
			<xsl:when test="$identifikation/xdf3:version"><xsl:value-of select="$identifikation/xdf3:id"/>V<xsl:value-of select="$identifikation/xdf3:version"/></xsl:when>
			<xsl:otherwise><xsl:value-of select="$identifikation/xdf3:id"/></xsl:otherwise>
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

</xsl:stylesheet>
