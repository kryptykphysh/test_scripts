<%@ Page Language="vb" AutoEventWireup="false" CodeBehind="mssql.aspx.vb" Inherits="mssqltest._Default" %>

<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">

<html xmlns="http://www.w3.org/1999/xhtml" >
<head runat="server">
    <title>Untitled Page</title>
    <style type="text/css">
      .style1
      {
        width: 25%;
        height: 119px;
      }
      .style2
      {
        width: 100px;
      }
      .style3
      {
        font-size: x-large;
      }
    </style>
</head>
<body>
    <form id="form1" runat="server">
    <div>
    
      <span class="style3" lang="en-gb">Microsoft SQL Server Database Connection Test<br />
      </span><span lang="en-gb">
      <br />
      <a href="/">Back</a></span></div>
    <p>
      <span lang="en-gb">
      <asp:Label ID="lblInfo" runat="server" Text="Enter database information:"></asp:Label>
      </span>
    </p>
    <table class="style1">
      <tr>
        <td class="style2">
          <span lang="en-gb">Server IP:</span></td>
        <td>
          <asp:TextBox ID="txtServer" runat="server" Height="18px" Width="214px"></asp:TextBox>
        </td>
      </tr>
      <tr>
        <td class="style2">
          <span lang="en-gb">Database:</span></td>
        <td>
          <span lang="en-gb">
          <asp:TextBox ID="txtDatabase" runat="server" Height="18px" Width="214px"></asp:TextBox>
          </span>
        </td>
      </tr>
      <tr>
        <td class="style2">
          <span lang="en-gb">Username:</span></td>
        <td>
          <span lang="en-gb">
          <asp:TextBox ID="txtUsername" runat="server" Height="18px" Width="214px"></asp:TextBox>
          </span>
        </td>
      </tr>
      <tr>
        <td class="style2">
          <span lang="en-gb">Password:</span></td>
        <td>
          <span lang="en-gb">
          <asp:TextBox ID="txtPassword" runat="server" Height="18px" Width="214px"></asp:TextBox>
          </span>
        </td>
      </tr>
    </table>
    <span lang="en-gb">
    <br />
    <asp:Button ID="btnConnect" runat="server" Text="Connect" Width="84px" />
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
    <asp:Button ID="btnClear" runat="server" Text="Clear" Width="84px" />
    </span>
    <p>
      <span lang="en-gb">
      <asp:Button ID="btnListTables" runat="server" Text="List Tables" Width="84px" />
&nbsp;&nbsp;&nbsp;
      <asp:Label ID="lblTableCount" runat="server"></asp:Label>
      </span>
    </p>
    <asp:GridView ID="GridView1" runat="server" AllowPaging="True" 
      AllowSorting="True" AutoGenerateSelectButton="True" 
      EnableSortingAndPagingCallbacks="True">
    </asp:GridView>
    </form>
</body>
</html>
