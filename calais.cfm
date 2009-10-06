<cfparam name="variables.liscenseKey" default="yourLicenseKeyHere" />

<cfparam name="variables.content" default="" />
<cfparam name="variables.semanticContent" default="" />

<cfparam name="attributes.name" default="cfcalais" />
<cfparam name="attributes.license" default="" />

<cfif not thisTag.hasEndTag>
	<cfthrow message="Must have end tag" />
</cfif>

<cfif thisTag.ExecutionMode eq 'end'>
	<cfscript>
	variables.liscenseKey = attributes.license;
	thisTag.calais = createObject('component', 'calais').init( license = variables.liscenseKey);
	variables.semanticContent = thisTag.calais.parseContent( content = thisTag.generatedContent );
	caller[attributes.name] = variables.semanticContent;
	</cfscript>

	<cfset test() >	<cfabort>
	
	<cfdump var="#extractEntities(variables.semanticContent)#">
</cfif>

<cffunction name="test" >
	<cfargument name="xmlin">
	<cfset var strct = {}>
	
	<cfset resources = xmlSearch(variables.semanticContent, '//rdf:Description/c:subject/@rdf:resource')>
	<cfloop array="#resources#" index="i">
		<cfset strct['#i.XmlValue#'] = xmlSearch(variables.semanticContent, '//rdf:Description/c:subject[@rdf:resource="#i.XmlValue#"]/..')>
	</cfloop>
	
	<cfdump var="#semanticContent#">
	<cfdump var="#strct#">
</cffunction>

<cffunction name="extractEntities" hint='I return a struct that enables easy extraction of entities. This only works with XML as of now.'>
	<cfargument name="content"/>
	<cfreturn extractXmlEntities(arguments.content) />
</cffunction>


<cffunction name="extractTypeData">
	<cfargument name="type">
	<cfargument name="rawData">
	
	<cfif structKeyExists(variables, "parse#arguments.type#")>
		<cfreturn Evaluate("parse#arguments.type#(rawData)")>
	<cfelse>
		<cfreturn rawData />
	</cfif>
	
</cffunction>

<cffunction name="parseCities">
	<cfargument name="cityArray">
	<cfset var data= [] >
	
	<cfset data = XmlSearch(cityArray[1], '//c:shortname/text()') >
	
	<cfreturn data>
</cffunction>
<cffunction name="parseCountries">
	<cfargument name="cityArray">
	<cfset var data= [] >
	
	<cfset data = XmlSearch(cityArray[1], '//c:name/text()') >
	
	<cfreturn data>
</cffunction>
