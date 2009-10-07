<cf_calais name="kindle" license='#url.license#'>
Amazon's Kindle e-book reader is going on sale in more than 100 countries around the world, including the UK.

The reader has been confined to the US since its launch in November 2007; Amazon expects to have sold a million of the devices by the end of the year.

The global version will run on the 3G network, although Amazon has not specified the networks that will provide connectivity for the devices.

The Kindle store will offer over 200,000 English-language titles.

Hundreds of publishers are signed up including Penguin, Faber and Faber, and HarperCollins.

It will also carry more than 85 US and international newspapers and magazines.

"We have millions of customers in countries all over the world who read English-language books. Kindle enables these customers to think of a book and download it in less than 60 seconds," said Amazon founder Jeff Bezos.

Penguin chief executive John Makinson hopes it will kickstart digital book sales in Europe.

"The publishing industry is experiencing explosive growth in digital book sales in the US," he said.

	
KINDLE IN EUROPE
Amazon Kindle
0.36 inches thick with 6in e-ink display
2GB of internal memory
QWERTY keyboard to add notes to text
Battery life "weeks on a single charge"
USB synching for people out of coverage area

The look and feel of the device will be the same as the US version with the exception of network access.

Following difficulties making the Kindle's Whispernet wireless download system work in the Europe, Amazon has decided to make downloads available via the 3G network.

This means that people wishing to download a book outside of a 3G coverage area will have to transfer content over USB.

In May of this year, Amazon unveiled a new version of its e-reader aimed at reading magazines, newspapers and documents. The Kindle DX is currently available only in the US.

The European version of the Kindle will begin shipping on October 19 with a $279 (£175) price tag. 
</cf_calais>

<ul>
<cfloop collection="#kindle#" item="key">
	<li><cfoutput>#key# : #StructKeyList(kindle[key])#</cfoutput></li>
</cfloop>
</ul>
<hr />

<cffeed action="read" query="tweetStream" source="http://twitter.com/statuses/user_timeline/1523901.rss"  />
<cfloop query="tweetStream" endrow="5">
	<cf_calais name="tweet" license='#url.license#'>
	<cfoutput>#content#</cfoutput>
	</cf_calais>
	<ul>
	<cfloop collection="#tweet#" item="key">
		<li><cfoutput>#key# : #StructKeyList(tweet[key])#</cfoutput></li>
	</cfloop>
	</ul>
</cfloop>