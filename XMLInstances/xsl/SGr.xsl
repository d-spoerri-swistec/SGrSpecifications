<?xml version="1.0" encoding="UTF-8"?>

<xsl:stylesheet version="1.1" xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:sgr="http://www.smartgridready.com/ns/V0/">

	<xsl:output method="html" version="4.0" encoding="UTF-8" indent="yes" />

	<xsl:include href="SGrDeviceProfile.xsl" />
	<xsl:include href="SGrFunctionProfile.xsl" />
	<xsl:include href="SGrDataPoint.xsl" />

	<xsl:include href="SGrDeviceTypeContact.xsl" />
	<xsl:include href="SGrDeviceTypeModbus.xsl" />
	<xsl:include href="SGrDeviceTypeRestAPI.xsl" />
	<xsl:include href="SGrDeviceTypeFunctionalProfile.xsl"/>

	<xsl:include href="SGrGenericAttributes.xsl" />
	<xsl:include href="SGrGenericDataPointDefinitions.xsl" />
	<xsl:include href="SgrGenericHelpers.xsl" />
	<xsl:include href="SGrGenericNamelistType.xsl" />
	<xsl:include href="SGrGenericLegibDocumentationType.xsl" />


	<xsl:template match="/">
		<html lang="any">
			<head>
				<title>
					SGr EI
					<xsl:value-of select="/*/@manufacturerName" />
					-
					<xsl:value-of select="/*/@deviceName" />
				</title>
				<meta name="viewport" content="width=device-width, initial-scale=1" />
				<link rel="stylesheet" type="text/css" href="/xsl/SGr.css" />
			</head>
			<body class="any">
				<script type="text/javascript">
			function toggleClass(className) {
				const collection = document.getElementsByClassName(className);
				for (let i = 0; i &lt; collection.length; i++) {
				  collection[i].style.display == "none" ? collection[i].style.display = "block" : collection[i].style.display = "none";
				}
			}
			function toggleClassRow(className) {
				const collection = document.getElementsByClassName(className);
				for (let i = 0; i &lt; collection.length; i++) {
				  collection[i].style.display == "none" ? collection[i].style.display = "table-row" : collection[i].style.display = "none";
				}
			}
		</script>
				<div class="navigation">
					<h2>Details</h2>
					<div>
						<input type="checkbox" onclick="toggleClassRow('dataPointDetails')" name="showDPDetails" value="1" checked="checked" />
						Data Points
					</div>
					<div>
						<input type="checkbox" onclick="toggleClassRow('genericDetails')" name="showDPDetails" value="1" checked="checked" />
						Generic Info
					</div>
					<div>
						<input type="checkbox" onclick="toggleClassRow('ontologyDetails')" name="showDPDetails" value="1" checked="checked" />
						Ontology
					</div>
					<div>
						<input type="checkbox" onclick="toggleClassRow('transportDetails')" name="showDPDetails" value="1" checked="checked" />
						Transport Layer
					</div>
					<div>
						<select name="language" id="language" title="Language" onchange="document.body.className = this.value">
							<option value="any">All Languages</option>
							<option value="en">English</option>
							<option value="de">Deutsch</option>
							<option value="fr">Francais</option>
							<option value="it">Italiano</option>
							<option value="none">(none)</option>
						</select>
					</div>
				</div>
				<div class="document">
					<div class="profileheader" style="height: 134px; margin-bottom:2em">
						<div style="float:left; width:50%">
							<img src="https://smartgridready.ch/media/images/Logos/SGR_LOGO_REDESIGN_RGB.svg" alt="SGr" width="240px" height="134px" />
						</div>
						<div style="float:left; width:50%; text-align:right; height: 134px">
							<xsl:choose>
								<xsl:when test="/sgr:SGrFunctionalProfileDescriptionType">Definition Functional Profile</xsl:when>
								<xsl:otherwise>Device Profile</xsl:otherwise>
							</xsl:choose>
						</div>
					</div>
					<p></p>

					<!-- Device Types -->
					<xsl:apply-templates select="sgr:SGrModbusDeviceDescriptionType" />
					<xsl:apply-templates select="sgr:SGrRESTAPIDeviceDescriptionType" />
					<xsl:apply-templates select="sgr:SGrContactAPIDeviceDescriptionType" />

					<!-- generic functional Profiles -->
					<xsl:apply-templates select="sgr:SGrFunctionalProfileDescriptionType" />
				</div>
			</body>
		</html>
	</xsl:template>

	<!-- Device Profiles -->
	<xsl:template match="sgr:SGrModbusDeviceDescriptionType">
		<xsl:call-template name="SGrDeviceType" />
	</xsl:template>
	<xsl:template match="sgr:SGrRESTAPIDeviceDescriptionType">
		<xsl:call-template name="SGrDeviceType" />
	</xsl:template>
	<xsl:template match="sgr:SGrContactAPIDeviceDescriptionType">
		<xsl:call-template name="SGrDeviceType" />
	</xsl:template>
	<xsl:template name="SGrDeviceType">
		<div class="externalInterface">
			<h1>
				<xsl:value-of select="@manufacturerName" />
				-
				<xsl:value-of select="@deviceName" />
			</h1>

			<table>
				<colgroup>
					<col style="width:30%" />
				</colgroup>
				<tr>
					<td>Name</td>
					<td>
						<xsl:value-of select="@deviceName" />
					</td>
				</tr>
				<tr>
					<td>Manufacturer</td>
					<td>
						<xsl:value-of select="@manufacturerName" />
					</td>
				</tr>
				<tr>
					<td>Manufacturer ID</td>
					<td>
						<xsl:value-of select="@manufacturerID" />
					</td>
				</tr>
				<tr>
					<td>Type</td>
					<td>
						<xsl:choose>
							<xsl:when test="@isLocalControl = 'true'">
								<img src="/xsl/lan.png" alt="" width="16pt" height="16pt" />
								Local area
							</xsl:when>
							<xsl:otherwise>
								<img src="/xsl/cloud.png" alt="" width="16pt" height="16pt" />
								Cloud device
							</xsl:otherwise>
						</xsl:choose>
					</td>
				</tr>

				<tr>
					<td class="noborder">&#160;</td>
				</tr>

				<!-- Device Profile (nameList, legibDesc-->
				<xsl:apply-templates select="sgr:deviceProfile" />

				<!-- Generic Attributes -->
				<xsl:apply-templates select="sgr:genAttribute" />

				<!-- Modbus Device -->
				<xsl:if test="sgr:modbusInterfaceDesc">
					<tr class="transportDetails">
						<td colspan="2" class="noborder">
							<h3>
								<img src="/xsl/modbus.png" alt="Modbus" width="100px" />
							</h3>
						</td>
					</tr>
					<xsl:apply-templates select="sgr:modbusInterfaceDesc" />
					<xsl:apply-templates select="sgr:modbusAttr" />
				</xsl:if>

				<!-- Rest Device -->
				<xsl:if test="sgr:restAPIInterfaceDesc">
					<tr class="transportDetails">
						<td colspan="2" class="noborder">
							<h3>
								<img src="/xsl/rest.png" alt="Rest" width="100px" />
							</h3>
						</td>
					</tr>
					<xsl:apply-templates select="sgr:restAPIInterfaceDesc" />
					<xsl:apply-templates select="sgr:restAPIAttr" />
				</xsl:if>

				<!-- Contact Device -->
				<xsl:if test="sgr:contactApiInterfaceDesc">
					<tr class="transportDetails">
						<td colspan="2" class="noborder">
							<h3>
								<img src="/xsl/contacts.png" alt="Contacts" width="40px" />
							</h3>
						</td>
					</tr>
					<xsl:apply-templates select="sgr:contactApiInterfaceDesc" />
				</xsl:if>

			</table>

			<xsl:apply-templates select="sgr:networkConnectionState" />

			<!-- Functiol Profiles -->
			<xsl:apply-templates select="sgr:fpListElement" />
		</div>
	</xsl:template>
	
	<xsl:template match="sgr:networkConnectionState">
		<h3>Network Connection State</h3>
		<table>
			<colgroup>
				<col style="width:30%" />
			</colgroup>
			<tr class="transportDetails">
				<td>Connected</td>
				<td>
					<xsl:value-of select="sgr:isConnected" />
				</td>
			</tr>
			<tr class="transportDetails">
				<td>Next Attempt</td>
				<td>
					<xsl:value-of select="sgr:nextAttempt" />
				</td>
			</tr>
		</table>
	</xsl:template>

</xsl:stylesheet>