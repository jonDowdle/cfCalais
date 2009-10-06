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
	<cfset var typeStrct = {}>
	<cfset var entStruct = {} />
	<cfloop collection="#variables.semanticContent#" item="key">
		<cfset tuple = variables.semanticContent[key]>
		<cfif structKeyExists(tuple, '_type')>
			<cfoutput>#tuple._type# : #arrayLen(tuple.instances)#</cfoutput>
			
			<cfif !structKeyExists(typeStrct, tuple._type)>
				<cfset typeStrct[tuple._type] = {}>
			</cfif>
			<!---
			TODO: Fix
			Overwrites existing structs
			--->
			<cfif structKeyExists(tuple, 'name')> 
				<cfset entStruct = { name = tuple.name, instances = tuple.instances} />
				<cfset structAppend( typeStrct[tuple._type], entStruct ) />
				<cfdump var="#typeStrct#">  
			</cfif>
			<br />
		<cfelse>
			<!---
			When _type isn't defined there seems to be a _typeGroup defined. 
			The exception to this is the document information, in which the key is 'doc' 
			 --->
			<cfdump var="#tuple#">
		</cfif>
	</cfloop>

	<cfdump var="#variables.semanticContent#">
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
