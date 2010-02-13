#cfCalais
## A Coldfusion tag to easily utilize OpenCalais ##
* * *
### Introduction to OpenCalais
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

1. Obtain a license key at [http://www.opencalais.com/](http://www.opencalais.com/ "Open Calais Website")
2. Place in a directory where your CFML engine can find it
3. Wrap your content like this:
		<cf_calais name="myLittlePony" license='#myLicenseKey#'>Some content here</cf_calais>
4. Use the returned data

### Return Variable

A structure is returned which contains various keys depending on the content that was parsed. A full list of returned metadata returned can be found here: <http://www.opencalais.com/documentation/calais-web-service-api/api-metadata/entity-index-and-definitions>

For the example content (taken from tagTest.cfm):
		
>Amazon's Kindle e-book reader is going on sale in more than 100 countries around the world, including the UK. The reader has been confined to the US since its launch in November 2007; Amazon expects to have sold a million of the devices by the end of the year. The global version will run on the 3G network, although Amazon has not specified the networks that will provide connectivity for the devices. The Kindle store will offer over 200,000 English-language titles. Hundreds of publishers are signed up including Penguin, Faber and Faber, and HarperCollins. It will also carry more than 85 US and international newspapers and magazines. "We have millions of customers in countries all over the world who read English-language books. Kindle enables these customers to think of a book and download it in less than 60 seconds," said Amazon founder Jeff Bezos. Penguin chief executive John Makinson hopes it will kickstart digital book sales in Europe. "The publishing industry is experiencing explosive growth in digital book sales in the US," he said. KINDLE IN EUROPE Amazon Kindle 0.36 inches thick with 6in e-ink display 2GB of internal memory QWERTY keyboard to add notes to text Battery life "weeks on a single charge" USB synching for people out of coverage area The look and feel of the device will be the same as the US version with the exception of network access. Following difficulties making the Kindle's Whispernet wireless download system work in the Europe, Amazon has decided to make downloads available via the 3G network. This means that people wishing to download a book outside of a 3G coverage area will have to transfer content over USB. In May of this year, Amazon unveiled a new version of its e-reader aimed at reading magazines, newspapers and documents. The Kindle DX is currently available only in the US. The European version of the Kindle will begin shipping on October 19 with a $279 (£175) price tag. 

Returns a structure that would have the following keys and values:
		
* Technology : 3G
* socialTag : Technology_Internet,Printing,Ur,Mass media,E-book,Amazon Kindle,Amazon.com,Media technology,Publishing,Linux based devices,Electronic publishing,E Ink,3G
* Country : United Kingdom,United States
* Person : John Makinson,Jeff Bezos
* Position : chief executive
* Company : Amazon,Penguin
* Facility : Kindle store
* Currency : GBP,USD
* Product : Kindle
* Continent : Europe
* IndustryTerm : e-reader,e-ink,e-book,wireless download system work,3G network