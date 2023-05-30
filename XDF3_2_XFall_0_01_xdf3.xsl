<?xml version="1.0" encoding="iso-8859-1"?>

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

<xsl:stylesheet version="2.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:xdf3="urn:xoev-de:fim:standard:xdatenfelder_3.0.0" xmlns:xs="http://www.w3.org/2001/XMLSchema" xmlns:html="http://www.w3.org/1999/xhtml" xmlns:fn="http://www.w3.org/2005/xpath-functions" xmlns:xdf="urn:xoev-de:fim:standard:xdatenfelder_2" xmlns:gc="http://docs.oasis-open.org/codelist/ns/genericode/1.0/" exclude-result-prefixes="html xsl fn xdf3 gc xdf">

	<!-- #####                                     Autor: Volker Schmitz                                     ######### -->
	
	<xsl:variable name="StyleSheetURI" select="fn:static-base-uri()"/>
	<xsl:variable name="DocumentURI" select="fn:document-uri(.)"/>
	<xsl:output method="xml" omit-xml-declaration="no"/>
	<xsl:strip-space elements="*"/>

	<xsl:param name="Annotationen" select="'1'"/>
	<xsl:param name="Praezisierungen" select="'1'"/>
	<xsl:param name="DateiOutput" select="'0'"/>
	<xsl:param name="DebugMode" select="'3'"/>

	<xsl:variable name="InputDateiname" select="tokenize($DocumentURI,'/')[last()]"/>
	<xsl:variable name="TempElementName">
		<xsl:call-template name="elementname">
			<xsl:with-param name="identifikation" select="//xdf3:stammdatenschema/xdf3:identifikation"/>
		</xsl:call-template>
	</xsl:variable>
	<xsl:variable name="OutputDateiname">
		<xsl:value-of select="fn:concat($TempElementName,'_xfall.xsd')"/>
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

				<xs:schema xmlns:xs="http://www.w3.org/2001/XMLSchema" 	xmlns="urn:fim-de:xfall:datenschema:xdf3" targetNamespace="urn:fim-de:xfall:datenschema:xdf3" xmlns:vc="http://www.w3.org/2007/XMLSchema-versioning" elementFormDefault="qualified" attributeFormDefault="unqualified" vc:minVersion="1.1">

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
						<xs:documentation><xsl:value-of select="./xdf3:name"/></xs:documentation>
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
								<xs:documentation><xsl:value-of select="./xdf3:name"/> - Hinweistext</xs:documentation>
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
												<xs:documentation><xsl:value-of select="./xdf3:name"/> - Werteliste</xs:documentation>
											</xs:annotation>
										</xsl:if>
										<xs:simpleType>
											<xs:restriction base="xs:token">
												<xsl:for-each select="./xdf3:werte/xdf3:wert">
													<xs:enumeration value="{./xdf3:code}">
														<xsl:if test="$Annotationen = '1'">
															<xs:annotation>
																<xs:documentation><xsl:value-of select="./xdf3:name"/> - Auswahlwert</xs:documentation>
															</xs:annotation>
														</xsl:if>
													</xs:enumeration>
												</xsl:for-each>
											</xs:restriction>
										</xs:simpleType>
									</xsl:when>
									<xsl:otherwise>
										<xsl:attribute name="type">xs:string</xsl:attribute>
										<xsl:if test="$Annotationen = '1'">
											<xs:annotation>
												<xs:documentation><xsl:value-of select="./xdf3:name"/> - Externe Codeliste: <xsl:value-of select="./xdf3:codelisteReferenz/xdf3:canonicalIdentification"/><xsl:if test="./xdf3:codelisteReferenz/xdf3:version">_<xsl:value-of select="./xdf3:codelisteReferenz/xdf3:version"/></xsl:if>  !!!TODO</xs:documentation>
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
												<xs:documentation><xsl:value-of select="./xdf3:name"/> - Werteliste</xs:documentation>
											</xs:annotation>
										</xsl:if>
									</xsl:when>
									<xsl:otherwise>
										<xsl:if test="$Annotationen = '1'">
											<xs:annotation>
												<xs:documentation><xsl:value-of select="./xdf3:name"/> - Externe Codeliste: <xsl:value-of select="./xdf3:codelisteReferenz/xdf3:canonicalIdentification"/><xsl:if test="./xdf3:codelisteReferenz/xdf3:version">_<xsl:value-of select="./xdf3:codelisteReferenz/xdf3:version"/></xsl:if></xs:documentation>
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
										<xs:documentation><xsl:value-of select="./xdf3:name"/> - Text</xs:documentation>
									</xs:annotation>
								</xsl:if>
								<xs:simpleType>
									<xs:restriction base="xs:string">
										<xsl:if test="./xdf3:praezisierung/@minLength">
											<xs:minLength value="{./xdf3:praezisierung/@minLength}"/>
										</xsl:if>
										<xsl:if test="./xdf3:praezisierung/@maxLength">
											<xs:maxLength value="{./xdf3:praezisierung/@maxLength}"/>
										</xsl:if>
										<xsl:if test="./xdf3:praezisierung/@pattern">
											<xs:pattern value="{./xdf3:praezisierung/@pattern}"/>
										</xsl:if>
									</xs:restriction>
								</xs:simpleType>
							</xsl:when>
							<xsl:otherwise>
								<xsl:attribute name="type">xs:string</xsl:attribute>
								<xsl:if test="$Annotationen = '1'">
									<xs:annotation>
										<xs:documentation><xsl:value-of select="./xdf3:name"/> - Text</xs:documentation>
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
										<xs:documentation><xsl:value-of select="./xdf3:name"/> - Datum</xs:documentation>
									</xs:annotation>
								</xsl:if>
								<xs:simpleType>
									<xs:restriction base="xs:date">
										<xsl:if test="./xdf3:praezisierung/@minValue">
											<xs:minInclusive value="{./xdf3:praezisierung/@minValue}"/>
										</xsl:if>
										<xsl:if test="./xdf3:praezisierung/@maxValue">
											<xs:maxInclusive value="{./xdf3:praezisierung/@maxValue}"/>
										</xsl:if>
										<xsl:if test="./xdf3:praezisierung/@pattern">
											<xs:pattern value="{./xdf3:praezisierung/@pattern}"/>
										</xsl:if>
									</xs:restriction>
								</xs:simpleType>
							</xsl:when>
							<xsl:otherwise>
								<xsl:attribute name="type">xs:date</xsl:attribute>
								<xsl:if test="$Annotationen = '1'">
									<xs:annotation>
										<xs:documentation><xsl:value-of select="./xdf3:name"/> - Datum</xs:documentation>
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
										<xs:documentation><xsl:value-of select="./xdf3:name"/> - Zeit</xs:documentation>
									</xs:annotation>
								</xsl:if>
								<xs:simpleType>
									<xs:restriction base="xs:time">
										<xsl:if test="./xdf3:praezisierung/@minValue">
											<xs:minInclusive value="{./xdf3:praezisierung/@minValue}"/>
										</xsl:if>
										<xsl:if test="./xdf3:praezisierung/@maxValue">
											<xs:maxInclusive value="{./xdf3:praezisierung/@maxValue}"/>
										</xsl:if>
										<xsl:if test="./xdf3:praezisierung/@pattern">
											<xs:pattern value="{./xdf3:praezisierung/@pattern}"/>
										</xsl:if>
									</xs:restriction>
								</xs:simpleType>
							</xsl:when>
							<xsl:otherwise>
								<xsl:attribute name="type">xs:time</xsl:attribute>
								<xsl:if test="$Annotationen = '1'">
									<xs:annotation>
										<xs:documentation><xsl:value-of select="./xdf3:name"/> - Zeit</xs:documentation>
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
										<xs:documentation><xsl:value-of select="./xdf3:name"/> - Zeitpunkt</xs:documentation>
									</xs:annotation>
								</xsl:if>
								<xs:simpleType>
									<xs:restriction base="xs:dateTime">
										<xsl:if test="./xdf3:praezisierung/@minValue">
											<xs:minInclusive value="{./xdf3:praezisierung/@minValue}"/>
										</xsl:if>
										<xsl:if test="./xdf3:praezisierung/@maxValue">
											<xs:maxInclusive value="{./xdf3:praezisierung/@maxValue}"/>
										</xsl:if>
										<xsl:if test="./xdf3:praezisierung/@pattern">
											<xs:pattern value="{./xdf3:praezisierung/@pattern}"/>
										</xsl:if>
									</xs:restriction>
								</xs:simpleType>
							</xsl:when>
							<xsl:otherwise>
								<xsl:attribute name="type">xs:dateTime</xsl:attribute>
								<xsl:if test="$Annotationen = '1'">
									<xs:annotation>
										<xs:documentation><xsl:value-of select="./xdf3:name"/> - Zeitpunkt</xs:documentation>
									</xs:annotation>
								</xsl:if>
							</xsl:otherwise>
						</xsl:choose>
					</xsl:when>
					<xsl:when test="./xdf3:datentyp/code/text() = 'bool'">
						<xsl:attribute name="type">xs:boolean</xsl:attribute>
						<xsl:if test="$Annotationen = '1'">
							<xs:annotation>
								<xs:documentation><xsl:value-of select="./xdf3:name"/> - Wahrheitswert</xs:documentation>
							</xs:annotation>
						</xsl:if>
					</xsl:when>
					<xsl:when test="./xdf3:datentyp/code/text() = 'num'">
						<xsl:choose>
							<xsl:when test="$Praezisierungen = '1' and ./xdf3:praezisierung">
								<xsl:if test="$Annotationen = '1'">
									<xs:annotation>
										<xs:documentation><xsl:value-of select="./xdf3:name"/> - Flie�kommazahl</xs:documentation>
									</xs:annotation>
								</xsl:if>
								<xs:simpleType>
									<xs:restriction base="xs:float">
										<xsl:if test="./xdf3:praezisierung/@minValue">
											<xs:minInclusive value="{./xdf3:praezisierung/@minValue}"/>
										</xsl:if>
										<xsl:if test="./xdf3:praezisierung/@maxValue">
											<xs:maxInclusive value="{./xdf3:praezisierung/@maxValue}"/>
										</xsl:if>
										<xsl:if test="./xdf3:praezisierung/@pattern">
											<xs:pattern value="{./xdf3:praezisierung/@pattern}"/>
										</xsl:if>
									</xs:restriction>
								</xs:simpleType>
							</xsl:when>
							<xsl:otherwise>
								<xsl:attribute name="type">xs:float</xsl:attribute>
								<xsl:if test="$Annotationen = '1'">
									<xs:annotation>
										<xs:documentation><xsl:value-of select="./xdf3:name"/> - Flie�kommazahl</xs:documentation>
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
										<xs:documentation><xsl:value-of select="./xdf3:name"/> - Ganzzahl</xs:documentation>
									</xs:annotation>
								</xsl:if>
								<xs:simpleType>
									<xs:restriction base="xs:integer">
										<xsl:if test="./xdf3:praezisierung/@minValue">
											<xs:minInclusive value="{./xdf3:praezisierung/@minValue}"/>
										</xsl:if>
										<xsl:if test="./xdf3:praezisierung/@maxValue">
											<xs:maxInclusive value="{./xdf3:praezisierung/@maxValue}"/>
										</xsl:if>
										<xsl:if test="./xdf3:praezisierung/@pattern">
											<xs:pattern value="{./xdf3:praezisierung/@pattern}"/>
										</xsl:if>
									</xs:restriction>
								</xs:simpleType>
							</xsl:when>
							<xsl:otherwise>
								<xsl:attribute name="type">xs:integer</xsl:attribute>
								<xsl:if test="$Annotationen = '1'">
									<xs:annotation>
										<xs:documentation><xsl:value-of select="./xdf3:name"/> - Ganzzahl</xs:documentation>
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
										<xs:documentation><xsl:value-of select="./xdf3:name"/> - W�hrungswert</xs:documentation>
									</xs:annotation>
								</xsl:if>
								<xs:simpleType>
									<xs:restriction base="xs:decimal">
										<xsl:if test="./xdf3:praezisierung/@minValue">
											<xs:minInclusive value="{./xdf3:praezisierung/@minValue}"/>
										</xsl:if>
										<xsl:if test="./xdf3:praezisierung/@maxValue">
											<xs:maxInclusive value="{./xdf3:praezisierung/@maxValue}"/>
										</xsl:if>
										<xsl:if test="./xdf3:praezisierung/@pattern">
											<xs:pattern value="{./xdf3:praezisierung/@pattern}"/>
										</xsl:if>
									</xs:restriction>
								</xs:simpleType>
							</xsl:when>
							<xsl:otherwise>
								<xsl:attribute name="type">xs:decimal</xsl:attribute>
								<xsl:if test="$Annotationen = '1'">
									<xs:annotation>
										<xs:documentation><xsl:value-of select="./xdf3:name"/> - W�hrungswert</xs:documentation>
									</xs:annotation>
								</xsl:if>
							</xsl:otherwise>
						</xsl:choose>
					</xsl:when>
					<xsl:when test="./xdf3:datentyp/code/text() = 'file'">
						<xsl:attribute name="type">xs:anyType</xsl:attribute>
						<xsl:if test="$Annotationen = '1'">
							<xs:annotation>
								<xs:documentation><xsl:value-of select="./xdf3:name"/> - Anlage</xs:documentation>
							</xs:annotation>
						</xsl:if>
					</xsl:when>
					<xsl:when test="./xdf3:datentyp/code/text() = 'obj'">
						<xsl:attribute name="type">xs:anyType</xsl:attribute>
						<xsl:if test="$Annotationen = '1'">
							<xs:annotation>
								<xs:documentation><xsl:value-of select="./xdf3:name"/> - Statisches Objekt</xs:documentation>
							</xs:annotation>
						</xsl:if>
					</xsl:when>
					<xsl:otherwise>
						<xsl:attribute name="type">xs:anyType</xsl:attribute>
						<xsl:if test="$Annotationen = '1'">
							<xs:annotation>
								<xs:documentation><xsl:value-of select="./xdf3:name"/> - Unbekannt</xs:documentation>
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
	
	<xsl:template match="xdf3:codelisteReferenz">

		<xsl:if test="$DebugMode = '3' or $DebugMode = '4'">
			<xsl:message>
				++++ codelisteReferenz ++++
				Codeliste: <xsl:value-of select="./xdf3:canonicalVersionUri"/>
			</xsl:message>
		</xsl:if>

		<xsl:variable name="InternalID">C<xsl:value-of select="fn:generate-id(.)"/></xsl:variable>
		
		<xdf:codelisteReferenz>
			<xdf:identifikation>
				<xdf:id><xsl:value-of select="$InternalID"/></xdf:id>
			</xdf:identifikation>
			<xdf:genericodeIdentification>
				<xdf:canonicalIdentification><xsl:value-of select="./xdf3:canonicalIdentification"/></xdf:canonicalIdentification>
				<xdf:version><xsl:value-of select="./xdf3:version"/></xdf:version>
				<xdf:canonicalVersionUri><xsl:value-of select="./xdf3:canonicalVersionUri"/></xdf:canonicalVersionUri>
			</xdf:genericodeIdentification>
		</xdf:codelisteReferenz>

	</xsl:template>

	<!-- ############################################################################################################# -->
	
	<xsl:template match="xdf3:werte">

<!--
		<xsl:variable name="TempcanonicalIdentification"><xsl:value-of select="fn:replace(../xdf3:name, '\s', '_')"/></xsl:variable>
		
		<xsl:variable name="Tempversion"><xsl:value-of select="fn:substring(../xdf3:letzteAenderung, 1, 10)"/></xsl:variable>
		
		<xsl:variable name="InternalID">C<xsl:value-of select="fn:generate-id(.)"/></xsl:variable>
		
		<xsl:variable name="FileName"><xsl:value-of select="$InternalID"/>_genericode.xml</xsl:variable>
		
		
		

		<xsl:if test="$DebugMode = '3' or $DebugMode = '4'">
			<xsl:message>
				++++ werte ++++
				Werteliste: <xsl:value-of select="$CodelistenInternIdentifier"/><xsl:value-of select="$TempcanonicalIdentification"/>_<xsl:value-of select="$Tempversion"/>
			</xsl:message>
		</xsl:if>
		
		<xdf:codelisteReferenz>
			<xdf:identifikation>
				<xdf:id><xsl:value-of select="$InternalID"/></xdf:id>
			</xdf:identifikation>
			<xdf:genericodeIdentification>
				<xdf:canonicalIdentification><xsl:value-of select="$CodelistenInternIdentifier"/><xsl:value-of select="$TempcanonicalIdentification"/></xdf:canonicalIdentification>
				<xdf:version><xsl:value-of select="$Tempversion"/></xdf:version>
				<xdf:canonicalVersionUri><xsl:value-of select="$CodelistenInternIdentifier"/><xsl:value-of select="$TempcanonicalIdentification"/>_<xsl:value-of select="$Tempversion"/></xdf:canonicalVersionUri>
			</xdf:genericodeIdentification>
		</xdf:codelisteReferenz>

		<xsl:if test="$CodelistendateienErzeugen = '1'">
			<xsl:result-document href="{$FileName}" encoding="UTF-8" method="xml">
				
				<CodeList xmlns="http://docs.oasis-open.org/codelist/ns/genericode/1.0/">
					<Identification>
						<ShortName><xsl:value-of select="../xdf3:name"/></ShortName>
						<LongName/>
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
						<xsl:for-each select="./xdf3:wert">
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
		</xsl:if>
-->
		
	</xsl:template>


</xsl:stylesheet>
