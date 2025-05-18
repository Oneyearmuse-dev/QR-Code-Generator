This is using PowerShell GUI code to create QR Codes from text using then open source QRCode.dll, you are welcome to use the code free of charge please however leave my credits in place.

Make sure the files are placed in to the folder C:\QR Code Generator

If you want to place the files in a different folder you will have to edit code QR Code Generator.ps1 just edit with notepad or a text editor of your choice.

And change this line below to point at the folder you want.

$QRCoderDLLPath = "C:\QR Code Generator\QRCoder.dll"
The shortcut file can be copied to your Desktop and just double click to run the GUI.