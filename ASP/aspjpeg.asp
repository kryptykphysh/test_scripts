<% 
' Create instance of AspJpeg
Set Jpeg = Server.CreateObject("Persits.Jpeg")
' Open source image
Jpeg.Open "\\IIS681\domains\s\swankclothing.co.uk\user\htdocs\sunset.jpg"

' New width
L = 100

' Resize, preserve aspect ratio
Jpeg.Width = L
Jpeg.Height = Jpeg.OriginalHeight * L / Jpeg.OriginalWidth

' create thumbnail and save it to disk
Jpeg.Save "\\IIS681\domains\s\swankclothing.co.uk\user\htdocs\thumbnailsunset.jpg"

%> 
