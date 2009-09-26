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
	if(attributes.license eq ''){ /* Extract this logic out to function */
		throw("Big Error");
	}
	
	variables.liscenseKey = attributes.license;
	variables.content = thisTag.generatedContent;
	thisTag.generatedContent = "";
	
	myParams = getParams();
	
	enlightenWS = createObject('webservice', 'http://api.opencalais.com/enlighten/?wsdl');
	rdf = enlightenWS.enlighten(variables.liscenseKey, variables.content, myParams);
	
	if(isJson(rdf)){
		variables.semanticContent = DeserializeJSON(rdf);
	}else if(isXml(rdf)){
		variables.semanticContent = xmlParse(rdf); 
	}else{
		variables.semanticContent = variables.content;
	}
	caller[attributes.name] = variables.semanticContent;
	</cfscript>
	<cfdump var="#extractEntities(variables.semanticContent)#">
</cfif>

<cffunction name="extractEntities" hint='I return a struct that enables easy extraction of entities. This only works with XML as of now.'>
	<cfargument name="content"/>
	<cfreturn extractXmlEntities(arguments.content) />
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
	
	<cfloop array="#arguments.cityArray#" index="cityNode">
		
		<cfset data = ArrayAppend(data, XmlSearch(cityNode, '//c:shortname/text()')) >
	</cfloop>
	<cfreturn data>
</cffunction>


<cffunction name="getParams">
<cfset var params = "" />
<cfxml variable="params">
<c:params xmlns:c="http://s.opencalais.com/1/pred/" xmlns:rdf="http://www.w3.org/1999/02/22-rdf-syntax-ns#">
	<c:processingDirectives 
		c:contentType="text/raw" 
		c:enableMetadataType="GenericRelations,SocialTags" 
		c:outputFormat="xml/rdf"
		<!---c:outputFormat="Application/JSON"--->
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
