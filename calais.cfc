<cfcomponent>
<cffunction name="init">
	<cfscript>
	if(arguments.license eq ''){ /* Extract this logic out to function */
		throw("Big Error");
	}
	variables.liscenseKey = arguments.license;
	variables.content = "";
	variables.myParams = getParams();
	variables.semanticContent = '';
	
	variables.enlightenWS = createObject('webservice', 'http://api.opencalais.com/enlighten/?wsdl');
	return this;
	</cfscript>
</cffunction>
	
<cffunction name="parseContent">
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

<cffunction name="getParams">
<cfset var params = "" />
<cfxml variable="params">
<c:params xmlns:c="http://s.opencalais.com/1/pred/" xmlns:rdf="http://www.w3.org/1999/02/22-rdf-syntax-ns#">
	<c:processingDirectives 
		c:contentType="text/raw" 
		c:enableMetadataType="GenericRelations,SocialTags" 
		c:outputFormat="Application/JSON"
		<!--- 
		"XML/RDF", "Text/Simple" or "Text/Microformats" or "Application/JSON"
		--->
		c:docRDFaccesible="true" >
	</c:processingDirectives>
	
	<c:userDirectives 
		c:allowDistribution="true" 
		c:allowSearch="true" 
		c:externalID="17cabs901" 
		c:submitter="ABC">
	</c:userDirectives>
	
	<c:externalMetadata></c:externalMetadata>
</c:params>
</cfxml>
<cfreturn params>
</cffunction>

</cfcomponent>