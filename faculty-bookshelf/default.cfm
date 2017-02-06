<cfset template.attribute.subtitle = "The Weatherhead Bookshelf">
<cfset template.attribute.subsec = "subsec15">
<cfset template.attribute.usenavigation = false>

<link rel="stylesheet" href="css/main.css">
<!--[if lt IE 7]>
    <p class="chromeframe">You are using an <strong>outdated</strong> browser. Please <a href="http://browsehappy.com/">upgrade your browser</a> or <a href="http://www.google.com/chromeframe/?redirect=true">activate Google Chrome Frame</a> to improve your experience.</p>
<![endif]-->

<cfset template.meta.social_image = "//weatherhead.case.edu/faculty/books/images/social-preview.jpg"/>
<cfset template.meta.description = "Weatherhead faculty members have published dozens of books that have changed the way management schools teach future business leaders and have shaped the way people around the world lead and manage their companies. Browse the featured titles by our distinguished faculty at Weatherhead below, and click the covers to read more about the titles and their authors."/>

<cfcache timespan="#CreateTimeSpan(7,0,0,0)#">

<p><cfoutput>#template.meta.description#</cfoutput></p>

<cfobject type="component" component="components/DigitalMeasuresCache" name="dm" />

<cfset data = dm.GetFacultyXmlData() />
<cfset booksJSON = DeserializeJSON(XmlTransform(data, ExpandPath("facultyBooksAsJson.xslt"))) />

<!--- Now filter out books for which we don't have cover images --->
<cfscript>
currentDirectory = GetDirectoryFromPath(ExpandPath("*.*"));
booksToDisplay = ArrayNew(1);
for (book in booksJSON) {
	if (FileExists("#currentDirectory#images\#book.id#.jpg")) {
		ArrayAppend(booksToDisplay, book);
	}
}
</cfscript>

<style>
input:checked + .btn {
	background: #d0d0d0;
}
/* visibly hide radio buttons while still keeping them accessible */
input[type="radio"] {
	border: 0;
	clip: rect(0 0 0 0);
	height: 1px; margin:-1px;
	overflow: hidden;
	padding: 0;
	position: absolute;
	width: 1px;	
}
</style>

<div class="text-right">
    <strong>Sort by:</strong>
    <label><input type="radio" name="sortBy" id="sortByYear" data-sort-method="year" checked="checked" aria-hidden="false" /><a class="btn btn-default">Year</a></label>
    <label><input type="radio" name="sortBy" id="sortByAuthor" data-sort-method="author" aria-hidden="false" /><a class="btn btn-default">Author</a></label>
    <label><input type="radio" name="sortBy" id="sortByTitle" data-sort-method="title" aria-hidden="false" /><a class="btn btn-default">Title</a></label>
</div>

<script>
// some helper functions
function getBookYear(from) {
	return parseInt($(from).find(".bookYear").text());
}
function getBookAuthor(from) {
	return $(from).find(".bookAuthor").text().split(",")[0].split(" ")[1];
}
function getBookTitle(from) {
	return $(from).find(".bookTitle").text().replace(/^(the|a) /i, "");
}
// the sorting functions. 
var sortingFuncs = {
	"year": function(a, b){
		var a_year = getBookYear(a),
			b_year = getBookYear(b);
		// sort in descending order by year
		if (a_year === b_year){
			return sortingFuncs["author"](a, b);
		}
		else {
			return b_year - a_year;
		}
	},
	"author": function(a, b){
		// select the first author's last name
		var a_author = getBookAuthor(a),
			b_author = getBookAuthor(b);
		if (a_author < b_author){
			return -1;
		}
		else if (a_author > b_author){
			return 1;
		}
		else {
			return 0;
		}
	},
	"title": function(a, b){
		// select title, but trim off "a" or "the"
		var a_title = getBookTitle(a),
			b_title = getBookTitle(b);
		if (a_title < b_title){
			return -1;
		}
		else if (a_title > b_title){
			return 1;
		}
		else {
			return 0;
		}
	}
};
$(function(){
	// sort the books appropriately when the button is clicked
	$("[name='sortBy']").click(function(e) {
		// remove the books from the DOM so we can work with them freely
		var sortedBooks = $(".book").detach();
		sortedBooks.sort(sortingFuncs[$(this).data("sort-method")]);
		// construct the shelves
		var shelfCount = Math.ceil(sortedBooks.length/6),
			preShelves = new Array(shelfCount);
		for (var i=0; i < shelfCount; i++){
			preShelves[i] = sortedBooks.slice(i*6, i*6 + 6);
		}
		// put the shelves on the DOM
		$(".shelf").each(function(index, elem){
			$(this).find(".books").append(preShelves[index]);
		});
	});
});
</script>

<cfset i = 1>
<cfset shelfTagsClosed = true>
<cfloop array="#booksToDisplay#" index="book">
	<cfif i mod 6 eq 1><!--- Start a new shelf --->
		<cfset shelfTagsClosed = false>
        <cfoutput>
        <div class="shelf row-fluid">
            <ul class="books clearfix">
        </cfoutput>
    </cfif>
    <!--- Book images will be at most 340px tall and 200px wide. Adjust the top margin so that the bottom of the book appears on the shelf  --->
    <cfset coverImage = ImageRead("#currentDirectory#images\#book.id#.jpg")>
    <cfset coverImageInfo = ImageInfo(coverImage)>
    <cfset marginTop = 340 - coverImageInfo.height/coverImageInfo.width * 200>
	<cfoutput>
    <li class="book" style="margin-top:#marginTop#px">
    	<a href="#book.link#">
        <img class="front" src="images/#book.id#.jpg" alt="#book.title#" aria-hidden="true" />
        <div class="back">
            <div class="p10">
                <div class="bookTitle">#book.title#</div>
                <br/>
                <div class="bookAuthor">#ArrayToList(book.authors, ", ")#</div>
                <br />
                <div class="bookYear">#book.year#</div>
            </div>
        </div>
        </a>
    </li>
    </cfoutput>
    <cfif i mod 6 eq 0><!--- end the shelf --->
		<cfset shelfTagsClosed = true>
        <cfoutput>
            </ul>
        </div>
		</cfoutput>
    </cfif>
    <!--- increment i --->
    <cfset i += 1>
</cfloop>
<!--- ensure that the last shelf has closing tags --->
<cfif not shelfTagsClosed>
	<cfoutput>
        </ul>
    </div>
    </cfoutput>
</cfif>

</cfcache>