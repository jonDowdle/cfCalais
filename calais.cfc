<cfcomponent output="false">
<cffunction name="init">
	<cfargument name="license" required="true">
	<cfargument name="directives" type="struct" 
				hint="Structure of params to pass to webservice see getCalaisParams()">
	
	<cfscript>
	var local = {};
	local.directives = {};
	/*
	if(structKeyExists(arguments, directives)){
		local.directives = arguments.directives;
	}
	*/
	variables.liscenseKey = arguments.license;
	variables.content = "";
	variables.myParams = getCalaisParams( argumentCollection = arguments.directives );
	variables.semanticContent = '';
	
	variables.enlightenWS = createObject('webservice', 'http://api.opencalais.com/enlighten/?wsdl');
	return this;
	</cfscript>
</cffunction>
	
<cffunction name="parseContent" output="false">
	<cfscript>
	var wsReturnVal = '';

	wsReturnVal = enlightenWS.enlighten(variables.liscenseKey, arguments.content, myParams);
	
	if(isJson(wsReturnVal)){
		variables.semanticContent = DeserializeJSON(wsReturnVal);
	}else if(isXml(wsReturnVal)){
		variables.semanticContent = xmlParse(wsReturnVal); 
	}else{
		variables.semanticContent = variables.content;
	}
	return variables.semanticContent;
	</cfscript>
</cffunction>

<cffunction name="extractXmlEntities" 
	hint='I return a struct that enables easy extraction of entities from XML by searching for the rdf:type. Only Persons and Cities work right now'>
	<cfargument name="content"/>
	<cfscript>
	var data = {};
	var keyToRdfType = {
		Persons = "http://s.opencalais.com/1/type/em/e/Person",
		Cities = "http://s.opencalais.com/1/type/er/Geo/City",
		Countries = "http://s.opencalais.com/1/type/er/Geo/Country"
	};
	</cfscript>
	<cfloop collection="#keyToRdfType#" item="key">
		<cfset data[key] = extractTypeData( type = key, rawData = XmlSearch(content, '//rdf:Description/rdf:type[@rdf:resource="#keyToRdfType[key]#"]/..') ) />
	</cfloop>
	<cfreturn data />
</cffunction>

<cffunction name="extractEntities" hint='I return a struct that enables easy extraction of entities' output="false">
	<cfargument name="content"/>
	<cfreturn extractJSONEntities(arguments.content) />
</cffunction>

<cffunction name="extractJSONEntities" output="false">
	<cfargument name="content">
	<cfset var typeStrct = {}>
	<cfset var entStruct = {} >
	<cfset var tuple = {} >
	<cfset var key = ''>
	
	<cfloop collection="#arguments.content#" item="key">
		<cfset tuple = arguments.content[key]>
		
		<cfif structKeyExists(tuple, '_type')>
			<cfif !structKeyExists(typeStrct, tuple._type)>
				<cfset typeStrct[tuple._type] = {}>
			</cfif>

			<cfif structKeyExists(tuple, 'name')>
				<cfif ! structKeyExists( typeStrct[tuple._type], tuple.name) >
					<cfset typeStrct[tuple._type][tuple.name] = {}>
					<cfset entStruct = {name = tuple.name, instances = tuple.instances} />
					<cfset structAppend( typeStrct[tuple._type][tuple.name], entStruct ) />
				</cfif>
			<cfelse>
				<!---
					TODO: Parse other entities here
					CompanyTechnology, GenericRelations, Quotation, PersonCareer
				--->
			</cfif>
		<cfelseif structKeyExists(tuple,'_typeGroup') && tuple._typeGroup eq "socialTag">
			<!---
			When _type isn't defined there seems to be a _typeGroup defined. 
			The exception to this is the document information, in which the key is 'doc' 
			 --->
			<cfif !structKeyExists(typeStrct, tuple._typeGroup)>
				<cfset typeStrct[tuple._typeGroup] = {}>
			</cfif>	
			<cfif !structKeyExists( typeStrct[tuple._typeGroup], tuple.name)>
				<cfset typeStrct[tuple._typeGroup][tuple.name] = {
					importance = tuple.importance,
					socialTag = tuple.socialTag
				}>
			</cfif>	 
		</cfif>
	</cfloop>
	<cfreturn removeEmptyKeys(typeStrct) />
</cffunction>

<cffunction name="getCalaisParams" output="false" returntype="xml"
			hint="I return an xml variabe that defines the input/output from OpenCalais">
	<cfargument name="contentType" default="text/raw" 
				hint='MIME type of content. Possible types are "TEXT/XML" "TEXT/HTML" "TEXT/HTMLRAW" "TEXT/RAW"'/>
	<cfargument name="enableMetadataType" default="" hint="Possible types: GenericRelations, SocialTags (can be combined in a comma separated list)"/>
	<cfargument name="outputFormat" default="Application/JSON" 
				hint='MIME type for web service to return. Possible types are "XML/RDF", "Text/Simple" or "Text/Microformats" or "Application/JSON"'>
	<cfargument name="docRDFaccesible" default="true" />
	<cfargument name="allowDistribution" default="true" />
	<cfargument name="allowSearch" default="true" />
	<cfargument name="externalID" default="" />
	<cfargument name="submitter" default="" />
		
	<cfset var params = "" />
	<cfxml variable="params">
	<c:params xmlns:c="http://s.opencalais.com/1/pred/" xmlns:rdf="http://www.w3.org/1999/02/22-rdf-syntax-ns#">
		<c:processingDirectives 
			c:contentType="<cfoutput>#arguments.contentType#</cfoutput>" 
			c:enableMetadataType="<cfoutput>#arguments.enableMetadataType#</cfoutput>" 
			c:outputFormat="<cfoutput>#arguments.outputFormat#</cfoutput>"
			c:docRDFaccesible="<cfoutput>#arguments.docRDFaccesible#</cfoutput>">
		</c:processingDirectives>
		
		<c:userDirectives 
			c:allowDistribution="<cfoutput>#arguments.allowDistribution#</cfoutput>" 
			c:allowSearch="<cfoutput>#arguments.allowSearch#</cfoutput>" 
			c:externalID="<cfoutput>#arguments.externalID#</cfoutput>" 
			c:submitter="<cfoutput>#arguments.submitter#</cfoutput>">
		</c:userDirectives>
		
		<c:externalMetadata></c:externalMetadata>
	</c:params>
	</cfxml>
	<cfreturn params>
</cffunction>

<cffunction name="removeEmptyKeys" access="private">
	<cfargument name="strctIn" type="Struct" >
	<cfset var key="">
	
	<cfloop collection="#strctIn#" item="key">
		<cfif ArrayLen(structKeyArray(strctIn[key])) eq 0>
			<cfset structDelete(strctIn,key)>
		</cfif>
	</cfloop>
	
	<cfreturn strctIn />
</cffunction>

</cfcomponent>