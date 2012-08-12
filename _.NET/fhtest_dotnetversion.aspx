<%@ Page Language="C#" ContentType="text/html" validateRequest="false" ResponseEncoding="UTF-8" %>

<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<SCRIPT runat="server">
protected void Page_Load(Object Src, EventArgs E)
{
Label4.Text = System.Environment.Version.ToString();
}
</script>
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
<title>what version of the framework</title>
</head>
<body>
ASP.NET VERSION: <asp:Label ID="Label4" runat="server"></asp:Label>
</body>
</html>
