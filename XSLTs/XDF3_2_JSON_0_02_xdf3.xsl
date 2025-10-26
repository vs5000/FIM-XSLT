<?xml version="1.0" encoding="iso-8859-1"?>
<xsl:stylesheet version="2.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:xdf3="urn:xoev-de:fim:standard:xdatenfelder_3.0.0" xmlns:xs="http://www.w3.org/2001/XMLSchema" xmlns:fn="http://www.w3.org/2005/xpath-functions" xmlns:gc="http://docs.oasis-open.org/codelist/ns/genericode/1.0/" xmlns:dat="http://www.xoev.de/de/xrepository/framework/1/datenbereitstellung" exclude-result-prefixes="xsl fn xdf3 gc dat">
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
	<xsl:variable name="StyleSheetName" select="'XDF3_2_JSON_0_02_xdf3.xsl'"/>
	<!-- BackUp, falls fn:static-base-uri() leer -->
	<xsl:output method="text" encoding="UTF-8" indent="no"/>
	<xsl:strip-space elements="*"/>

	<xsl:param name="MitVersionen" select="'1'"/>
	<xsl:param name="KeineErweiterungen" select="'1'"/>
	<xsl:param name="KommentareBeiEnums" select="'1'"/>

	<xsl:param name="Annotationen" select="'1'"/>

	<xsl:param name="Praezisierungen" select="'1'"/>

	<xsl:param name="CodelistenInhalt" select="'0'"/>
	<xsl:param name="AktuelleCodelisteLaden" select="'1'"/>

	<xsl:param name="DateiOutput" select="'0'"/>
	<xsl:param name="DebugMode" select="'3'"/>

	<xsl:variable name="XMLXRepoMitVersionPfadPrefix" select="'https://www.xrepository.de/api/version_codeliste/'"/>
	<xsl:variable name="XMLXRepoMitVersionPfadPostfix" select="'/genericode'"/>
	<xsl:variable name="XMLXRepoOhneVersionPfadPrefix" select="'https://www.xrepository.de/api/codeliste/'"/>
	<xsl:variable name="XMLXRepoOhneVersionPfadPostfix" select="'/gueltigeVersion'"/>

	<xsl:variable name="InputDateiname" select="(tokenize($DocumentURI,'/'))[last()]"/>
	<xsl:variable name="InputPfad" select="fn:substring-before($DocumentURI, $InputDateiname)"/>
	<xsl:variable name="OutputDateiname">
		<xsl:value-of select="fn:substring-before($InputDateiname,'.xml')"/>.schema.json</xsl:variable>
	<xsl:variable name="OutputDateinameUndPfad" select="concat($InputPfad,$OutputDateiname)"/>
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
				<xsl:result-document href="{$OutputDateinameUndPfad}">
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
			<xsl:when test="name(/*) ='xdf3:xdatenfelder.stammdatenschema.0102'"><xsl:text>{</xsl:text><xsl:apply-templates select="./*/xdf3:stammdatenschema"/><xsl:text>}</xsl:text></xsl:when>
			<xsl:otherwise></xsl:otherwise>
		</xsl:choose>
	</xsl:template>
	<!-- ############################################################################################################# -->
	<xsl:template match="xdf3:stammdatenschema">
		<xsl:if test="$DebugMode = '2' or $DebugMode = '3' or $DebugMode = '4'">
			<xsl:message>
				++++ stammdatenschema ++++
				Element: <xsl:value-of select="./xdf3:identifikation/xdf3:id"/>
			</xsl:message>
		</xsl:if>
		<xsl:variable name="ElementName">
			<xsl:value-of select="./xdf3:identifikation/xdf3:id"/>
			<xsl:if test="./xdf3:identifikation/xdf3:version">V<xsl:value-of select="./xdf3:identifikation/xdf3:version"/></xsl:if>
		</xsl:variable>

		<xsl:text>"$schema": "https://json-schema.org/draft/2020-12/schema",</xsl:text>
		<xsl:text>"$id": "</xsl:text><xsl:value-of select="./xdf3:identifikation/xdf3:id"/><xsl:if test="./xdf3:identifikation/xdf3:version">V<xsl:value-of select="./xdf3:identifikation/xdf3:version"/></xsl:if><xsl:text>.schema.json",</xsl:text>
		<xsl:text>"title": "</xsl:text><xsl:value-of select="./xdf3:name"/><xsl:text>",</xsl:text>

		<xsl:text>"description": "</xsl:text>Erstellt am: <xsl:value-of select="format-date(fn:current-date(),'[D01].[M01].[Y0001]')"/> um <xsl:value-of select="format-time(fn:current-time(),'[H01]:[m01]')"/> Uhr<xsl:text>  -  </xsl:text>XSLT: <xsl:choose><xsl:when test="$StyleSheetURI=''"><xsl:value-of select="$StyleSheetName"/></xsl:when><xsl:otherwise><xsl:call-template name="fileName"><xsl:with-param name="path" select="$StyleSheetURI"/></xsl:call-template></xsl:otherwise></xsl:choose><xsl:if test="not(empty($DocumentURI))"><xsl:text>  -  </xsl:text>XML: <xsl:call-template name="fileName"><xsl:with-param name="path" select="$DocumentURI"/></xsl:call-template></xsl:if><xsl:text>",</xsl:text>

		<xsl:text>"type": "object",</xsl:text>

		<xsl:if test="$MitVersionen = '1'">
			<xsl:text>"$defs": {</xsl:text>
				<xsl:for-each-group select="//xdf3:datenfeld" group-by="concat(xdf3:identifikation/xdf3:id,xdf3:identifikation/xdf3:version)">
					<xsl:sort select="concat(xdf3:identifikation/xdf3:id,xdf3:identifikation/xdf3:version)"/>
					<xsl:apply-templates select="."/>
					<xsl:if test="fn:position() != fn:last()">
						<xsl:text>,</xsl:text>
					</xsl:if>
				</xsl:for-each-group>
				<xsl:if test="//xdf3:datenfeldgruppe">
					<xsl:text>,</xsl:text>
				</xsl:if>
				<xsl:for-each-group select="//xdf3:datenfeldgruppe" group-by="concat(xdf3:identifikation/xdf3:id,xdf3:identifikation/xdf3:version)">
					<xsl:sort select="concat(xdf3:identifikation/xdf3:id,xdf3:identifikation/xdf3:version)"/>
					<xsl:apply-templates select="."/>
					<xsl:if test="fn:position() != fn:last()">
						<xsl:text>,</xsl:text>
					</xsl:if>
				</xsl:for-each-group>
			<xsl:text>}</xsl:text>
			<xsl:text>,</xsl:text>
		</xsl:if>

		<xsl:call-template name="struktur">
			<xsl:with-param name="Element" select="."/>
		</xsl:call-template>

	</xsl:template>
	<!-- ############################################################################################################# -->
	<xsl:template match="xdf3:datenfeldgruppe">
		<xsl:if test="$DebugMode = '2' or $DebugMode = '3' or $DebugMode = '4'">
			<xsl:message>
				++++ datenfeldgruppe++++
				Element: <xsl:value-of select="./xdf3:identifikation/xdf3:id"/>
			</xsl:message>
		</xsl:if>
		<xsl:variable name="ElementName">
			<xsl:call-template name="elementname">
				<xsl:with-param name="identifikation" select="./xdf3:identifikation"/>
			</xsl:call-template>
		</xsl:variable>
		<xsl:variable name="Min">
			<xsl:value-of select="tokenize(../../xdf3:anzahl/text(),':')[1]"/>
		</xsl:variable>
		<xsl:variable name="Max">
			<xsl:value-of select="tokenize(../../xdf3:anzahl/text(),':')[2]"/>
		</xsl:variable>

		<xsl:text>"</xsl:text><xsl:value-of select="$ElementName"/><xsl:text>": {</xsl:text>
			<xsl:text>"title": "</xsl:text><xsl:value-of select="./xdf3:name"/><xsl:text>",</xsl:text>
			<xsl:if test="$Annotationen = '1'">
				<xsl:text>"description": "</xsl:text>Datenfeldgruppe: <xsl:call-template name="escape-json"><xsl:with-param name="text" select="./xdf3:name"/></xsl:call-template><xsl:if test="$MitVersionen = '0' and fn:string(./xdf3:identifikation/xdf3:version)"> - Version: <xsl:value-of select="./xdf3:identifikation/xdf3:version"/></xsl:if><xsl:text>",</xsl:text>
			</xsl:if>
			<xsl:choose>
				<xsl:when test="(($Min = '0' or $Min = '1') and $Max = '1') or $MitVersionen = '1'">
					<xsl:text>"type": "object",</xsl:text>
					<xsl:call-template name="struktur">
						<xsl:with-param name="Element" select="."/>
					</xsl:call-template>
				</xsl:when>
				<xsl:otherwise>
					<xsl:text>"type": "array",</xsl:text>
					<xsl:text>"items": {</xsl:text>
						<xsl:call-template name="struktur">
							<xsl:with-param name="Element" select="."/>
						</xsl:call-template>
					<xsl:text>}</xsl:text>
					<xsl:if test="not($Min = '0' or $Min = '1') or $Max != '1'">
						<xsl:text>,</xsl:text>
						<xsl:text>"minItems": </xsl:text><xsl:value-of select="$Min"/>
					</xsl:if>
					<xsl:if test="$Max != '*' and $Max != '1'">
						<xsl:text>,</xsl:text>
						<xsl:text>"maxItems": </xsl:text><xsl:value-of select="$Max"/>
					</xsl:if>
				</xsl:otherwise>
			</xsl:choose>
		<xsl:text>}</xsl:text>

	</xsl:template>
	<!-- ############################################################################################################# -->
	<xsl:template match="xdf3:datenfeld">
		<xsl:if test="$DebugMode = '2' or $DebugMode = '3' or $DebugMode = '4'">
			<xsl:message>
				++++ datenfeld++++
				Element: <xsl:value-of select="./xdf3:identifikation/xdf3:id"/>
			</xsl:message>
		</xsl:if>
		<xsl:if test="./xdf3:feldart/code/text() != 'label'">
		</xsl:if>
			<xsl:variable name="ElementName">
				<xsl:call-template name="elementname">
					<xsl:with-param name="identifikation" select="./xdf3:identifikation"/>
				</xsl:call-template>
			</xsl:variable>
			<xsl:variable name="Min">
				<xsl:value-of select="tokenize(../../xdf3:anzahl/text(),':')[1]"/>
			</xsl:variable>
			<xsl:variable name="Max">
				<xsl:value-of select="tokenize(../../xdf3:anzahl/text(),':')[2]"/>
			</xsl:variable>

			<xsl:text>"</xsl:text><xsl:value-of select="$ElementName"/><xsl:text>": {</xsl:text>
				<xsl:text>"title": "</xsl:text><xsl:value-of select="./xdf3:name"/><xsl:text>",</xsl:text>
				<xsl:choose>
					<xsl:when test="(($Min = '0' or $Min = '1') and $Max = '1') or $MitVersionen = '1'">
						<xsl:call-template name="typ">
							<xsl:with-param name="Element" select="."/>
						</xsl:call-template>
					</xsl:when>
					<xsl:otherwise>
						<xsl:text>"type": "array",</xsl:text>
						<xsl:text>"items": {</xsl:text>
							<xsl:call-template name="typ">
								<xsl:with-param name="Element" select="."/>
							</xsl:call-template>
						<xsl:text>}</xsl:text>
						<xsl:if test="not($Min = '0' or $Min = '1') or $Max != '1'">
							<xsl:text>,</xsl:text>
							<xsl:text>"minItems": </xsl:text><xsl:value-of select="$Min"/>
						</xsl:if>
						<xsl:if test="$Max != '*' and $Max != '1'">
							<xsl:text>,</xsl:text>
							<xsl:text>"maxItems": </xsl:text><xsl:value-of select="$Max"/>
						</xsl:if>
					</xsl:otherwise>
				</xsl:choose>
			<xsl:text>}</xsl:text>

	</xsl:template>
	<!-- ############################################################################################################# -->
	<xsl:template name="typ">
		<xsl:param name="Element"/>
		<xsl:if test="$DebugMode = '3' or $DebugMode = '4'">
			<xsl:message>
				++++ typ ++++
			</xsl:message>
		</xsl:if>

		<xsl:choose>
			<xsl:when test="$Element/xdf3:feldart/code/text() = 'label'">
			</xsl:when>
			<xsl:when test="$Element/xdf3:feldart/code/text() = 'select'">
				<xsl:choose>
					<xsl:when test="$Element/xdf3:werte">
						<xsl:if test="$Annotationen = '1'">
							<xsl:text>"description": "</xsl:text>Datenfeld: <xsl:call-template name="escape-json"><xsl:with-param name="text" select="./xdf3:name"/></xsl:call-template> - <xsl:if test="$MitVersionen = '0' and fn:string(./xdf3:identifikation/xdf3:version)">Version: <xsl:value-of select="./xdf3:identifikation/xdf3:version"/> - </xsl:if>Typ: Auswahlliste (Werteliste)<xsl:text>",</xsl:text>
						</xsl:if>
						<xsl:text>"type": "string"</xsl:text>
						<xsl:choose>
							<xsl:when test="$Praezisierungen = '1'">
								<xsl:text>,</xsl:text>
								<xsl:choose>
									<xsl:when test="$KommentareBeiEnums ='1' and $Annotationen = '1'">
										<xsl:text>"oneOf": [</xsl:text>
												<xsl:for-each select="$Element/xdf3:werte/xdf3:wert">
													<xsl:text>{</xsl:text>
														<xsl:text>"const": "</xsl:text><xsl:value-of select="./xdf3:code"/><xsl:text>",</xsl:text>
														<xsl:text>"description": "</xsl:text><xsl:call-template name="escape-json"><xsl:with-param name="text" select="./xdf3:name"/></xsl:call-template><xsl:text>"</xsl:text>
													<xsl:text>}</xsl:text>
													<xsl:if test="fn:position() != fn:last()">
														<xsl:text>,</xsl:text>
													</xsl:if>
												</xsl:for-each>
										<xsl:text>]</xsl:text>
									</xsl:when>
									<xsl:otherwise>
										<xsl:text>"enum": [</xsl:text>
												<xsl:for-each select="$Element/xdf3:werte/xdf3:wert">
													<xsl:text>"</xsl:text><xsl:value-of select="./xdf3:code"/><xsl:text>"</xsl:text>
													<xsl:if test="fn:position() != fn:last()">
														<xsl:text>,</xsl:text>
													</xsl:if>
												</xsl:for-each>
										<xsl:text>]</xsl:text>
									</xsl:otherwise>
								</xsl:choose>
							</xsl:when>
							<xsl:otherwise></xsl:otherwise>
						</xsl:choose>
					</xsl:when>
					<xsl:when test="$Element/xdf3:codelisteReferenz">
						<xsl:choose>
							<xsl:when test="$Praezisierungen = '1' and $CodelistenInhalt ='1'">
								<xsl:variable name="RichtigeVersion">
									<xsl:choose>
										<xsl:when test="not(fn:string($Element/xdf3:codelisteReferenz/xdf3:version))">
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
												<xsl:otherwise>
													<xsl:value-of select="$CodelisteAbfrageInhalt/dat:VersionCodeliste/dat:version"/>
												</xsl:otherwise>
											</xsl:choose>
										</xsl:when>
										<xsl:otherwise>
											<xsl:value-of select="$Element/xdf3:codelisteReferenz/xdf3:version"/>
										</xsl:otherwise>
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
										<xsl:if test="$Annotationen = '1'">
											<xsl:choose>
												<xsl:when test="not(fn:string(./xdf3:codelisteReferenz/xdf3:version)) and $AktuelleCodelisteLaden ='0'">
													<xsl:text>"description": "</xsl:text>Datenfeld: <xsl:call-template name="escape-json"><xsl:with-param name="text" select="./xdf3:name"/></xsl:call-template> - <xsl:if test="$MitVersionen = '0' and fn:string(./xdf3:identifikation/xdf3:version)">Version: <xsl:value-of select="./xdf3:identifikation/xdf3:version"/> - </xsl:if>Typ: Auswahlliste (Externe Codeliste: <xsl:value-of select="./xdf3:codelisteReferenz/xdf3:canonicalIdentification"/> ohne Versionsangabe)<xsl:text>",</xsl:text>
												</xsl:when>
												<xsl:when test="not(fn:string(./xdf3:codelisteReferenz/xdf3:version)) and $RichtigeVersion/text() != 'unbestimmt'">
													<xsl:text>"description": "</xsl:text>Datenfeld: <xsl:call-template name="escape-json"><xsl:with-param name="text" select="./xdf3:name"/></xsl:call-template> - <xsl:if test="$MitVersionen = '0' and fn:string(./xdf3:identifikation/xdf3:version)">Version: <xsl:value-of select="./xdf3:identifikation/xdf3:version"/> - </xsl:if>Typ: Auswahlliste (Externe Codeliste: <xsl:value-of select="./xdf3:codelisteReferenz/xdf3:canonicalIdentification"/> in der aktuellen Version <xsl:value-of select="$RichtigeVersion"/> konnte nicht geladen werden)<xsl:text>",</xsl:text>
												</xsl:when>
												<xsl:when test="$RichtigeVersion/text() = 'unbestimmt'">
													<xsl:text>"description": "</xsl:text>Datenfeld: <xsl:call-template name="escape-json"><xsl:with-param name="text" select="./xdf3:name"/></xsl:call-template> - <xsl:if test="$MitVersionen = '0' and fn:string(./xdf3:identifikation/xdf3:version)">Version: <xsl:value-of select="./xdf3:identifikation/xdf3:version"/> - </xsl:if>Typ: Auswahlliste (Externe Codeliste: <xsl:value-of select="./xdf3:codelisteReferenz/xdf3:canonicalIdentification"/> konnte nicht geladen werden)<xsl:text>",</xsl:text>
												</xsl:when>
												<xsl:otherwise>
													<xsl:text>"description": "</xsl:text>Datenfeld: <xsl:call-template name="escape-json"><xsl:with-param name="text" select="./xdf3:name"/></xsl:call-template> - <xsl:if test="$MitVersionen = '0' and fn:string(./xdf3:identifikation/xdf3:version)">Version: <xsl:value-of select="./xdf3:identifikation/xdf3:version"/> - </xsl:if>Typ: Auswahlliste (Externe Codeliste: <xsl:value-of select="./xdf3:codelisteReferenz/xdf3:canonicalIdentification"/> konnte nicht geladen werden)<xsl:text>",</xsl:text>
												</xsl:otherwise>
											</xsl:choose>
										</xsl:if>
										<xsl:text>"type": "string"</xsl:text>
									</xsl:when>
									<xsl:otherwise>
										<xsl:if test="$Annotationen = '1'">
											<xsl:choose>
												<xsl:when test="fn:string(./xdf3:codelisteReferenz/xdf3:version)">
													<xsl:text>"description": "</xsl:text>Datenfeld: <xsl:call-template name="escape-json"><xsl:with-param name="text" select="./xdf3:name"/></xsl:call-template> - <xsl:if test="$MitVersionen = '0' and fn:string(./xdf3:identifikation/xdf3:version)">Version: <xsl:value-of select="./xdf3:identifikation/xdf3:version"/> - </xsl:if>Typ: Auswahlliste (Externe Codeliste: <xsl:value-of select="./xdf3:codelisteReferenz/xdf3:canonicalIdentification"/>_<xsl:value-of select="./xdf3:codelisteReferenz/xdf3:version"/>)<xsl:text>",</xsl:text>												
												</xsl:when>
												<xsl:otherwise>
													<xsl:text>"description": "</xsl:text>Datenfeld: <xsl:call-template name="escape-json"><xsl:with-param name="text" select="./xdf3:name"/></xsl:call-template> - <xsl:if test="$MitVersionen = '0' and fn:string(./xdf3:identifikation/xdf3:version)">Version: <xsl:value-of select="./xdf3:identifikation/xdf3:version"/> - </xsl:if>Typ: Auswahlliste (Externe Codeliste: <xsl:value-of select="./xdf3:codelisteReferenz/xdf3:canonicalIdentification"/> in der aktuellen Version <xsl:value-of select="$RichtigeVersion"/>)<xsl:text>",</xsl:text>												
												</xsl:otherwise>
											</xsl:choose>
										</xsl:if>
										<xsl:text>"type": "string"</xsl:text>
										<xsl:text>,</xsl:text>
										<xsl:variable name="NameCodeKey">
											<xsl:choose>
												<xsl:when test="fn:string($Element/xdf3:codeKey)">
													<xsl:value-of select="$Element/xdf3:codeKey"/>
												</xsl:when>
												<xsl:otherwise>
													<xsl:value-of select="$CodelisteInhalt/*/*:ColumnSet/*:Key[1]/*:ColumnRef/@Ref"/>
												</xsl:otherwise>
											</xsl:choose>
										</xsl:variable>
										<xsl:variable name="NameCodenameKey">
											<xsl:choose>
												<xsl:when test="fn:string($Element/xdf3:nameKey)">
													<xsl:value-of select="$Element/xdf3:nameKey"/>
												</xsl:when>
												<xsl:otherwise>
													<xsl:value-of select="$CodelisteInhalt/*/*:ColumnSet/(*:Column[@Id != $NameCodeKey])[1]/@Id"/>
												</xsl:otherwise>
											</xsl:choose>
										</xsl:variable>
										<xsl:choose>
											<xsl:when test="$KommentareBeiEnums ='1' and $Annotationen = '1'">
												<xsl:text>"oneOf": [</xsl:text>
													<xsl:for-each-group select="$CodelisteInhalt/*/*:SimpleCodeList/*:Row" group-by="*:Value[@ColumnRef=$NameCodenameKey]">
														<xsl:text>{</xsl:text>
															<xsl:text>"const": "</xsl:text><xsl:value-of select="./*:Value[@ColumnRef=$NameCodeKey]"/><xsl:text>",</xsl:text>
															<xsl:text>"description": "</xsl:text><xsl:call-template name="escape-json"><xsl:with-param name="text" select="./*:Value[@ColumnRef=$NameCodenameKey]"/></xsl:call-template><xsl:text>"</xsl:text>
														<xsl:text>}</xsl:text>
														<xsl:if test="fn:position() != fn:last()">
															<xsl:text>,</xsl:text>
														</xsl:if>
													</xsl:for-each-group>
												<xsl:text>]</xsl:text>
											</xsl:when>
											<xsl:otherwise>
												<xsl:text>"enum": [</xsl:text>
													<xsl:for-each-group select="$CodelisteInhalt/*/*:SimpleCodeList/*:Row" group-by="*:Value[@ColumnRef=$NameCodenameKey]">
														<xsl:text>"</xsl:text><xsl:value-of select="./*:Value[@ColumnRef=$NameCodeKey]"/><xsl:text>"</xsl:text>
														<xsl:if test="fn:position() != fn:last()">
															<xsl:text>,</xsl:text>
														</xsl:if>
													</xsl:for-each-group>
												<xsl:text>]</xsl:text>
											</xsl:otherwise>
										</xsl:choose>
									</xsl:otherwise>
								</xsl:choose>
							</xsl:when>
							<xsl:otherwise>
								<xsl:if test="$Annotationen = '1'">
									<xsl:choose>
										<xsl:when test="./xdf3:codelisteReferenz/xdf3:version">
											<xsl:text>"description": "</xsl:text>Datenfeld: <xsl:call-template name="escape-json"><xsl:with-param name="text" select="./xdf3:name"/></xsl:call-template> - <xsl:if test="$MitVersionen = '0' and fn:string(./xdf3:identifikation/xdf3:version)">Version: <xsl:value-of select="./xdf3:identifikation/xdf3:version"/> - </xsl:if>Typ: Auswahlliste (Externe Codeliste: <xsl:value-of select="./xdf3:codelisteReferenz/xdf3:canonicalIdentification"/>_<xsl:value-of select="./xdf3:codelisteReferenz/xdf3:version"/>)<xsl:text>",</xsl:text>
										</xsl:when>
										<xsl:otherwise>
											<xsl:text>"description": "</xsl:text>Datenfeld: <xsl:call-template name="escape-json"><xsl:with-param name="text" select="./xdf3:name"/></xsl:call-template> - <xsl:if test="$MitVersionen = '0' and fn:string(./xdf3:identifikation/xdf3:version)">Version: <xsl:value-of select="./xdf3:identifikation/xdf3:version"/> - </xsl:if>Typ: Auswahlliste (Externe Codeliste: <xsl:value-of select="./xdf3:codelisteReferenz/xdf3:canonicalIdentification"/> ohne Versionsangabe)<xsl:text>",</xsl:text>												
										</xsl:otherwise>
									</xsl:choose>
								</xsl:if>
								<xsl:text>"type": "string"</xsl:text>
							</xsl:otherwise>
						</xsl:choose>
					</xsl:when>
					<xsl:otherwise>
						<xsl:if test="$Annotationen = '1'">
							<xsl:text>"description": "</xsl:text>Datenfeld: <xsl:call-template name="escape-json"><xsl:with-param name="text" select="./xdf3:name"/></xsl:call-template> - <xsl:if test="$MitVersionen = '0' and fn:string(./xdf3:identifikation/xdf3:version)">Version: <xsl:value-of select="./xdf3:identifikation/xdf3:version"/> - </xsl:if>Typ: Auswahlliste (Keine Angabe einer Werte- oder Codeliste)<xsl:text>",</xsl:text>												
						</xsl:if>
						<xsl:text>"type": "string"</xsl:text>
					</xsl:otherwise>
				</xsl:choose>
			</xsl:when>
			<xsl:when test="$Element/xdf3:datentyp/code/text() = 'text' or $Element/xdf3:datentyp/code/text() = 'text_latin'">
				<xsl:if test="$Annotationen = '1'">
					<xsl:text>"description": "</xsl:text>Datenfeld: <xsl:call-template name="escape-json"><xsl:with-param name="text" select="./xdf3:name"/></xsl:call-template> - <xsl:if test="$MitVersionen = '0' and fn:string(./xdf3:identifikation/xdf3:version)">Version: <xsl:value-of select="./xdf3:identifikation/xdf3:version"/> - </xsl:if>Wertebereich: Text<xsl:text>",</xsl:text>												
				</xsl:if>
				<xsl:text>"type": "string"</xsl:text>
				<xsl:choose>
					<xsl:when test="$Praezisierungen = '1' and $Element/xdf3:praezisierung">
						<xsl:if test="fn:string($Element/xdf3:praezisierung/@minLength)">
							<xsl:text>,</xsl:text>
							<xsl:text>"minLength": </xsl:text><xsl:value-of select="$Element/xdf3:praezisierung/@minLength"/>
						</xsl:if>
						<xsl:if test="fn:string($Element/xdf3:praezisierung/@maxLength)">
							<xsl:text>,</xsl:text>
							<xsl:text>"maxLength": </xsl:text><xsl:value-of select="$Element/xdf3:praezisierung/@maxLength"/>
						</xsl:if>
						<xsl:if test="fn:string($Element/xdf3:praezisierung/@pattern)">
							<xsl:text>,</xsl:text>
							<xsl:text>"pattern": "</xsl:text><xsl:call-template name="escape-json"><xsl:with-param name="text" select="$Element/xdf3:praezisierung/@pattern"/></xsl:call-template><xsl:text>"</xsl:text>
						</xsl:if>
					</xsl:when>
					<xsl:otherwise>
					</xsl:otherwise>
				</xsl:choose>
			</xsl:when>
			<xsl:when test="$Element/xdf3:datentyp/code/text() = 'date'">
				<xsl:if test="$Annotationen = '1'">
					<xsl:text>"description": "</xsl:text>Datenfeld: <xsl:call-template name="escape-json"><xsl:with-param name="text" select="./xdf3:name"/></xsl:call-template> - <xsl:if test="$MitVersionen = '0' and fn:string(./xdf3:identifikation/xdf3:version)">Version: <xsl:value-of select="./xdf3:identifikation/xdf3:version"/> - </xsl:if>Wertebereich: Datum<xsl:text>",</xsl:text>												
				</xsl:if>
				<xsl:text>"type": "string"</xsl:text>
				<xsl:choose>
					<xsl:when test="$Praezisierungen = '1' and $Element/xdf3:praezisierung">
						<xsl:text>,</xsl:text>
						<xsl:text>"format": "date"</xsl:text>
						<xsl:if test="fn:string($Element/xdf3:praezisierung/@minValue)">
							<xsl:text>,</xsl:text>
							<xsl:text>"minimum": </xsl:text><xsl:value-of select="$Element/xdf3:praezisierung/@minValue"/>
						</xsl:if>
						<xsl:if test="fn:string($Element/xdf3:praezisierung/@maxValue)">
							<xsl:text>,</xsl:text>
							<xsl:text>"maximum": </xsl:text><xsl:value-of select="$Element/xdf3:praezisierung/@maxValue"/>
						</xsl:if>
						<xsl:if test="fn:string($Element/xdf3:praezisierung/@pattern)">
							<xsl:text>,</xsl:text>
							<xsl:text>"pattern": "</xsl:text><xsl:call-template name="escape-json"><xsl:with-param name="text" select="$Element/xdf3:praezisierung/@pattern"/></xsl:call-template><xsl:text>"</xsl:text>
						</xsl:if>
					</xsl:when>
					<xsl:otherwise>
					</xsl:otherwise>
				</xsl:choose>
			</xsl:when>
			<xsl:when test="$Element/xdf3:datentyp/code/text() = 'time'">
				<xsl:if test="$Annotationen = '1'">
					<xsl:text>"description": "</xsl:text>Datenfeld: <xsl:call-template name="escape-json"><xsl:with-param name="text" select="./xdf3:name"/></xsl:call-template> - <xsl:if test="$MitVersionen = '0' and fn:string(./xdf3:identifikation/xdf3:version)">Version: <xsl:value-of select="./xdf3:identifikation/xdf3:version"/> - </xsl:if>Wertebereich: Zeit<xsl:text>",</xsl:text>												
				</xsl:if>
				<xsl:text>"type": "string"</xsl:text>
				<xsl:choose>
					<xsl:when test="$Praezisierungen = '1' and $Element/xdf3:praezisierung">
						<xsl:text>,</xsl:text>
						<xsl:text>"format": "time"</xsl:text>
						<xsl:if test="fn:string($Element/xdf3:praezisierung/@minValue)">
							<xsl:text>,</xsl:text>
							<xsl:text>"minimum": </xsl:text><xsl:value-of select="$Element/xdf3:praezisierung/@minValue"/>
						</xsl:if>
						<xsl:if test="fn:string($Element/xdf3:praezisierung/@maxValue)">
							<xsl:text>,</xsl:text>
							<xsl:text>"maximum": </xsl:text><xsl:value-of select="$Element/xdf3:praezisierung/@maxValue"/>
						</xsl:if>
						<xsl:if test="fn:string($Element/xdf3:praezisierung/@pattern)">
							<xsl:text>,</xsl:text>
							<xsl:text>"pattern": "</xsl:text><xsl:call-template name="escape-json"><xsl:with-param name="text" select="$Element/xdf3:praezisierung/@pattern"/></xsl:call-template><xsl:text>"</xsl:text>
						</xsl:if>
					</xsl:when>
					<xsl:otherwise>
					</xsl:otherwise>
				</xsl:choose>
			</xsl:when>
			<xsl:when test="$Element/xdf3:datentyp/code/text() = 'datetime'">
				<xsl:if test="$Annotationen = '1'">
					<xsl:text>"description": "</xsl:text>Datenfeld: <xsl:call-template name="escape-json"><xsl:with-param name="text" select="./xdf3:name"/></xsl:call-template> - <xsl:if test="$MitVersionen = '0' and fn:string(./xdf3:identifikation/xdf3:version)">Version: <xsl:value-of select="./xdf3:identifikation/xdf3:version"/> - </xsl:if>Wertebereich: Zeitpunkt<xsl:text>",</xsl:text>												
				</xsl:if>
				<xsl:text>"type": "string"</xsl:text>
				<xsl:choose>
					<xsl:when test="$Praezisierungen = '1' and $Element/xdf3:praezisierung">
						<xsl:text>,</xsl:text>
						<xsl:text>"format": "datetime"</xsl:text>
						<xsl:if test="fn:string($Element/xdf3:praezisierung/@minValue)">
							<xsl:text>,</xsl:text>
							<xsl:text>"minimum": </xsl:text><xsl:value-of select="$Element/xdf3:praezisierung/@minValue"/>
						</xsl:if>
						<xsl:if test="fn:string($Element/xdf3:praezisierung/@maxValue)">
							<xsl:text>,</xsl:text>
							<xsl:text>"maximum": </xsl:text><xsl:value-of select="$Element/xdf3:praezisierung/@maxValue"/>
						</xsl:if>
						<xsl:if test="fn:string($Element/xdf3:praezisierung/@pattern)">
							<xsl:text>,</xsl:text>
							<xsl:text>"pattern": "</xsl:text><xsl:call-template name="escape-json"><xsl:with-param name="text" select="$Element/xdf3:praezisierung/@pattern"/></xsl:call-template><xsl:text>"</xsl:text>
						</xsl:if>
					</xsl:when>
					<xsl:otherwise>
					</xsl:otherwise>
				</xsl:choose>
			</xsl:when>
			<xsl:when test="$Element/xdf3:datentyp/code/text() = 'bool'">
				<xsl:if test="$Annotationen = '1'">
					<xsl:text>"description": "</xsl:text>Datenfeld: <xsl:call-template name="escape-json"><xsl:with-param name="text" select="./xdf3:name"/></xsl:call-template> - <xsl:if test="$MitVersionen = '0' and fn:string(./xdf3:identifikation/xdf3:version)">Version: <xsl:value-of select="./xdf3:identifikation/xdf3:version"/> - </xsl:if>Wertebereich: Wahrheitswert<xsl:text>",</xsl:text>												
				</xsl:if>
				<xsl:text>"type": "boolean"</xsl:text>
			</xsl:when>
			<xsl:when test="$Element/xdf3:datentyp/code/text() = 'num'">
				<xsl:if test="$Annotationen = '1'">
					<xsl:text>"description": "</xsl:text>Datenfeld: <xsl:call-template name="escape-json"><xsl:with-param name="text" select="./xdf3:name"/></xsl:call-template> - <xsl:if test="$MitVersionen = '0' and fn:string(./xdf3:identifikation/xdf3:version)">Version: <xsl:value-of select="./xdf3:identifikation/xdf3:version"/> - </xsl:if>Wertebereich: Fließkommazahl<xsl:text>",</xsl:text>												
				</xsl:if>
				<xsl:text>"type": "number"</xsl:text>
				<xsl:choose>
					<xsl:when test="$Praezisierungen = '1' and $Element/xdf3:praezisierung">
						<xsl:if test="fn:string($Element/xdf3:praezisierung/@minValue)">
							<xsl:text>,</xsl:text>
							<xsl:text>"minimum": </xsl:text><xsl:value-of select="$Element/xdf3:praezisierung/@minValue"/>
						</xsl:if>
						<xsl:if test="fn:string($Element/xdf3:praezisierung/@maxValue)">
							<xsl:text>,</xsl:text>
							<xsl:text>"maximum": </xsl:text><xsl:value-of select="$Element/xdf3:praezisierung/@maxValue"/>
						</xsl:if>
						<xsl:if test="fn:string($Element/xdf3:praezisierung/@pattern)">
							<xsl:text>,</xsl:text>
							<xsl:text>"pattern": "</xsl:text><xsl:call-template name="escape-json"><xsl:with-param name="text" select="$Element/xdf3:praezisierung/@pattern"/></xsl:call-template><xsl:text>"</xsl:text>
						</xsl:if>
					</xsl:when>
					<xsl:otherwise>
					</xsl:otherwise>
				</xsl:choose>
			</xsl:when>
			<xsl:when test="$Element/xdf3:datentyp/code/text() = 'num_int'">
				<xsl:if test="$Annotationen = '1'">
					<xsl:text>"description": "</xsl:text>Datenfeld: <xsl:call-template name="escape-json"><xsl:with-param name="text" select="./xdf3:name"/></xsl:call-template> - <xsl:if test="$MitVersionen = '0' and fn:string(./xdf3:identifikation/xdf3:version)">Version: <xsl:value-of select="./xdf3:identifikation/xdf3:version"/> - </xsl:if>Wertebereich: Ganzzahl<xsl:text>",</xsl:text>												
				</xsl:if>
				<xsl:text>"type": "integer"</xsl:text>
				<xsl:choose>
					<xsl:when test="$Praezisierungen = '1' and $Element/xdf3:praezisierung">
						<xsl:if test="fn:string($Element/xdf3:praezisierung/@minValue)">
							<xsl:text>,</xsl:text>
							<xsl:text>"minimum": </xsl:text><xsl:value-of select="$Element/xdf3:praezisierung/@minValue"/>
						</xsl:if>
						<xsl:if test="fn:string($Element/xdf3:praezisierung/@maxValue)">
							<xsl:text>,</xsl:text>
							<xsl:text>"maximum": </xsl:text><xsl:value-of select="$Element/xdf3:praezisierung/@maxValue"/>
						</xsl:if>
						<xsl:if test="fn:string($Element/xdf3:praezisierung/@pattern)">
							<xsl:text>,</xsl:text>
							<xsl:text>"pattern": "</xsl:text><xsl:call-template name="escape-json"><xsl:with-param name="text" select="$Element/xdf3:praezisierung/@pattern"/></xsl:call-template><xsl:text>"</xsl:text>
						</xsl:if>
					</xsl:when>
					<xsl:otherwise>
					</xsl:otherwise>
				</xsl:choose>
			</xsl:when>
			<xsl:when test="$Element/xdf3:datentyp/code/text() = 'num_currency'">
				<xsl:if test="$Annotationen = '1'">
					<xsl:text>"description": "</xsl:text>Datenfeld: <xsl:call-template name="escape-json"><xsl:with-param name="text" select="./xdf3:name"/></xsl:call-template> - <xsl:if test="$MitVersionen = '0' and fn:string(./xdf3:identifikation/xdf3:version)">Version: <xsl:value-of select="./xdf3:identifikation/xdf3:version"/> - </xsl:if>Wertebereich: Währungswert<xsl:text>",</xsl:text>												
				</xsl:if>
				<xsl:text>"type": "number"</xsl:text>
				<xsl:choose>
					<xsl:when test="$Praezisierungen = '1' and $Element/xdf3:praezisierung">
						<xsl:if test="fn:string($Element/xdf3:praezisierung/@minValue)">
							<xsl:text>,</xsl:text>
							<xsl:text>"minimum": </xsl:text><xsl:value-of select="$Element/xdf3:praezisierung/@minValue"/>
						</xsl:if>
						<xsl:if test="fn:string($Element/xdf3:praezisierung/@maxValue)">
							<xsl:text>,</xsl:text>
							<xsl:text>"maximum": </xsl:text><xsl:value-of select="$Element/xdf3:praezisierung/@maxValue"/>
						</xsl:if>
						<xsl:if test="fn:string($Element/xdf3:praezisierung/@pattern)">
							<xsl:text>,</xsl:text>
							<xsl:text>"pattern": "</xsl:text><xsl:call-template name="escape-json"><xsl:with-param name="text" select="$Element/xdf3:praezisierung/@pattern"/></xsl:call-template><xsl:text>"</xsl:text>
						</xsl:if>
					</xsl:when>
					<xsl:otherwise>
					</xsl:otherwise>
				</xsl:choose>
			</xsl:when>
			<xsl:when test="$Element/xdf3:datentyp/code/text() = 'file'">
				<xsl:if test="$Annotationen = '1'">
					<xsl:text>"description": "</xsl:text>Datenfeld: <xsl:call-template name="escape-json"><xsl:with-param name="text" select="./xdf3:name"/></xsl:call-template> - <xsl:if test="$MitVersionen = '0' and fn:string(./xdf3:identifikation/xdf3:version)">Version: <xsl:value-of select="./xdf3:identifikation/xdf3:version"/> - </xsl:if>Wertebereich: Anlage<xsl:text>",</xsl:text>												
				</xsl:if>
				<xsl:text>"type": "string"</xsl:text>
			</xsl:when>
			<xsl:when test="$Element/xdf3:datentyp/code/text() = 'obj'">
				<xsl:if test="$Annotationen = '1'">
					<xsl:text>"description": "</xsl:text>Datenfeld: <xsl:call-template name="escape-json"><xsl:with-param name="text" select="./xdf3:name"/></xsl:call-template> - <xsl:if test="$MitVersionen = '0' and fn:string(./xdf3:identifikation/xdf3:version)">Version: <xsl:value-of select="./xdf3:identifikation/xdf3:version"/> - </xsl:if>Wertebereich: Statisches Objekt<xsl:text>",</xsl:text>												
				</xsl:if>
				<xsl:text>"type": "string"</xsl:text>
			</xsl:when>
			<xsl:otherwise>
				<xsl:if test="$Annotationen = '1'">
					<xsl:text>"description": "</xsl:text>Datenfeld: <xsl:call-template name="escape-json"><xsl:with-param name="text" select="./xdf3:name"/></xsl:call-template> - <xsl:if test="$MitVersionen = '0' and fn:string(./xdf3:identifikation/xdf3:version)">Version: <xsl:value-of select="./xdf3:identifikation/xdf3:version"/> - </xsl:if>Wertebereich: Unbekannt<xsl:text>",</xsl:text>												
				</xsl:if>
				<xsl:text>"type": "string"</xsl:text>
			</xsl:otherwise>
		</xsl:choose>

	</xsl:template>
	<!-- ############################################################################################################# -->
	<xsl:template name="struktur">
		<xsl:param name="Element"/>
		<xsl:if test="$DebugMode = '3' or $DebugMode = '4'">
			<xsl:message>
				++++ struktur ++++
			</xsl:message>
		</xsl:if>
		<xsl:text>"properties": {</xsl:text>
			<xsl:for-each select="$Element/xdf3:struktur">
				<xsl:if test="./xdf3:enthaelt/xdf3:datenfeldgruppe or ./xdf3:enthaelt/*/xdf3:feldart/code/text() != 'label'">
					<xsl:variable name="UnterelementName">
						<xsl:call-template name="elementname">
							<xsl:with-param name="identifikation" select="./xdf3:enthaelt/*/xdf3:identifikation"/>
						</xsl:call-template>
					</xsl:variable>
					<xsl:variable name="Min">
						<xsl:value-of select="tokenize(./xdf3:anzahl/text(),':')[1]"/>
					</xsl:variable>
					<xsl:variable name="Max">
						<xsl:value-of select="tokenize(./xdf3:anzahl/text(),':')[2]"/>
					</xsl:variable>
	
					<xsl:choose>
						<xsl:when test="$MitVersionen = '1'">
							<xsl:text>"</xsl:text><xsl:value-of select="$UnterelementName"/><xsl:text>": {</xsl:text>
								<xsl:choose>
									<xsl:when test="($Min = '0' or $Min = '1') and $Max = '1'">
										<xsl:text>"$ref": "#/$defs/</xsl:text><xsl:value-of select="$UnterelementName"/><xsl:text>"</xsl:text>
									</xsl:when>
									<xsl:otherwise>
										<xsl:text>"type": "array",</xsl:text>
										<xsl:text>"items": {</xsl:text>
											<xsl:text>"$ref": "#/$defs/</xsl:text><xsl:value-of select="$UnterelementName"/><xsl:text>"</xsl:text>
										<xsl:text>}</xsl:text>
										<xsl:if test="not($Min = '0' or $Min = '1') or $Max != '1'">
											<xsl:text>,</xsl:text>
											<xsl:text>"minItems": </xsl:text><xsl:value-of select="$Min"/>
										</xsl:if>
										<xsl:if test="$Max != '*' and $Max != '1'">
											<xsl:text>,</xsl:text>
											<xsl:text>"maxItems": </xsl:text><xsl:value-of select="$Max"/>
										</xsl:if>
									</xsl:otherwise>
								</xsl:choose>
							<xsl:text>}</xsl:text>
						</xsl:when>
						<xsl:otherwise>
							<xsl:apply-templates select="./xdf3:enthaelt/*"/>
						</xsl:otherwise>
					</xsl:choose>
					<xsl:if test="fn:position() != fn:last()">
						<xsl:text>,</xsl:text>
					</xsl:if>
				</xsl:if>
			</xsl:for-each>
		<xsl:text>}</xsl:text>
		<xsl:if test="$KeineErweiterungen = '1'">
			<xsl:text>, "additionalProperties": false</xsl:text>
		</xsl:if>
		<xsl:choose>
			<xsl:when test="$Element/xdf3:art/code ='X'">
				<xsl:text>,</xsl:text>
				<xsl:text>"oneOf": [</xsl:text>
					<xsl:for-each select="$Element/xdf3:struktur">
						<xsl:variable name="UnterelementName">
							<xsl:call-template name="elementname">
								<xsl:with-param name="identifikation" select="./xdf3:enthaelt/*/xdf3:identifikation"/>
							</xsl:call-template>
						</xsl:variable>
						<xsl:text>{</xsl:text>
							<xsl:text>"required": [</xsl:text>
								<xsl:text>"</xsl:text><xsl:value-of select="$UnterelementName"/><xsl:text>"</xsl:text>
							<xsl:text>]</xsl:text>
						<xsl:text>}</xsl:text>
						<xsl:if test="fn:position() != fn:last()">
							<xsl:text>,</xsl:text>
						</xsl:if>
					</xsl:for-each>
				<xsl:text>]</xsl:text>
			</xsl:when>
			<xsl:otherwise>
				<xsl:variable name="required">
					<xsl:for-each select="$Element/xdf3:struktur">
						<xsl:variable name="UnterelementName">
							<xsl:call-template name="elementname">
								<xsl:with-param name="identifikation" select="./xdf3:enthaelt/*/xdf3:identifikation"/>
							</xsl:call-template>
						</xsl:variable>
						<xsl:variable name="Min">
							<xsl:choose>
								<xsl:when test="./xdf3:enthaelt/*/xdf3:feldart/code/text() = 'label'">0</xsl:when>
								<xsl:otherwise>
									<xsl:value-of select="tokenize(./xdf3:anzahl/text(),':')[1]"/>
								</xsl:otherwise>
							</xsl:choose>
						</xsl:variable>
						<xsl:choose>
							<xsl:when test="$Min != '0'">
								<xsl:text>"</xsl:text><xsl:value-of select="$UnterelementName"/><xsl:text>"</xsl:text>
								<xsl:if test="fn:position() != fn:last()">
									<xsl:text>,</xsl:text>
								</xsl:if>
							</xsl:when>
							<xsl:otherwise>
							</xsl:otherwise>
						</xsl:choose>
					</xsl:for-each>
				</xsl:variable>
				<xsl:if test="fn:string($required)">
				<xsl:text>,</xsl:text>
					<xsl:text>"required": [</xsl:text>
						<xsl:value-of select="$required"/>
					<xsl:text>]</xsl:text>
				</xsl:if>
			</xsl:otherwise>
		</xsl:choose>
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
			<xsl:when test="$identifikation/xdf3:version and $MitVersionen ='1'">
				<xsl:value-of select="$identifikation/xdf3:id"/>V<xsl:value-of select="$identifikation/xdf3:version"/>
			</xsl:when>
			<xsl:otherwise>
				<xsl:value-of select="$identifikation/xdf3:id"/>
			</xsl:otherwise>
		</xsl:choose>
	</xsl:template>
	<!-- ############################################################################################################# -->
	 <xsl:template name="escape-json">
			<xsl:param name="text"/>
			<xsl:value-of select="replace(
				replace(
					replace(
						replace(
							replace($text, '\\', '\\\\'),
							'&quot;', '\\&quot;'),
						'&#x0A;', '\\n'),
					'&#x0D;', '\\r'),
				'&#x09;', '\\t')"/>
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
</xsl:stylesheet>
