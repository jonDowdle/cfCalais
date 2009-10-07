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
	caller[attributes.name] = thisTag.calais.extractEntities(variables.semanticContent);
	</cfscript>
</cfif>

