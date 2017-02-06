using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;
using edu.cwru.weatherhead.data;
using edu.cwru.weatherhead.helpers;
using edu.cwru.weatherhead.templates;
using Newtonsoft.Json;
using System.IO;


public partial class faculty_books_book_list : BasePage
{
    public class Book
    {
        public string Title { get; set; }
        public string[] Authors { get; set; }
        public string Publisher { get; set; }
        public int Year { get; set; }
        public string Link { get; set; }
        public long Id { get; set; }
        public string AuthorsFormatted
        {
            get
            {
                return String.Join(", ", Authors);
            }
        }
    }

    protected void Page_Load(object sender, EventArgs e)
    {
        string json = XsltHelper.TransformToString(
            DigitalMeasures.FacultyDataFile,
            Server.MapPath("/faculty/books/facultyBooksAsJson.xslt"));

        json = json.Substring(45, json.Length - 51);
        List<Book> books = JsonConvert.DeserializeObject<List<Book>>(json);
        //Response.WriteFormat("<pre>{0}</pre>", JsonConvert.SerializeObject(books));

        string webRootDirectory = HttpRuntime.AppDomainAppPath;
        List<Book> booksToDisplay = new List<Book>();
        List<Book> bookCoversNeeded = new List<Book>();

        foreach (Book book in books)
        {
            if(File.Exists(webRootDirectory + "faculty\\books\\images\\" + book.Id + ".jpg"))
            {
                booksToDisplay.Add(book);
            }

            else
            {
                bookCoversNeeded.Add(book);
            }
        }

        rptBooksWithoutCoverImages.DataSource = bookCoversNeeded;
        rptBooksWithoutCoverImages.DataBind();

        rptBooksWithCoverImages.DataSource = booksToDisplay;
        rptBooksWithCoverImages.DataBind();
    }
}