<%@ Page 
    Title=""
    Language="C#" 
    AutoEventWireup="true" 
    CodeFileBaseClass="edu.cwru.weatherhead.templates.BasePage"
    CodeFile="book-list.aspx.cs" 
    Inherits="faculty_books_book_list" %>
<asp:Content ContentPlaceHolderID="mainColumn" Runat="Server">

    <h2>Books needing cover images:</h2>
    <asp:Repeater runat="server" ID="rptBooksWithoutCoverImages">
        <HeaderTemplate>
            <ol>
        </HeaderTemplate>
        <ItemTemplate>
           <li><%# Eval("AuthorsFormatted") %> et al.  <%# Eval("Year") %>. <i><%# Eval("Title") %></i>.  <%# Eval("Publisher") %></li>
            <small>Save image as: <pre><%# Eval("Id") %>.jpg</pre></small>
        </ItemTemplate>
         <FooterTemplate>
         </ol>
         </FooterTemplate>
    </asp:Repeater>

    <h2>Books with cover images:</h2>
    <asp:Repeater runat="server" ID="rptBooksWithCoverImages">
        <HeaderTemplate>
            <ol>
        </HeaderTemplate>
        <ItemTemplate>
           <li><img src="images/<%# Eval("Id") %>.jpg" style="max-width:150px;max-height:150px;padding:5px;"/><%# Eval("Title") %></li>
        </ItemTemplate>
         <FooterTemplate>
         </ol>
         </FooterTemplate>
    </asp:Repeater>
</asp:Content>