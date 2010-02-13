cfCalais
========
## A Coldfusion tag to easily utilize OpenCalais ##

If you are unfamiliar with ThompsonReuters OpenCalais&copy; service, here is a 
short description taken from [http://www.opencalais.com/](http://www.opencalais.com/ "Open Calais Website")

>We want to make all the world's content more accessible, interoperable and valuable. 
Some call it Web 2.0, Web 3.0, the Semantic Web or the Giant Global Graph - we call our piece 
of it Calais.
>
>Calais is a rapidly growing toolkit of capabilities that allow you to readily incorporate 
state-of-the-art semantic functionality within your blog, content management system, website 
or application.

### Tag Use

1. Place in a directory where your CFML engine can find it
2. Wrap your content like this:
		<cf_calais name="myLittlePony" license='#myLicenseKey#'>Some content here</cf_calais>
3. Use the returned data

### Return Variable

A structure is returned which contains various keys depending on the content that was parsed.
For the example content:
		
		<put content here>

the structure that was returned would have the following keys:
		
		<put resulting keys here>
