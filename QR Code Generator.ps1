# This script creates a simple GUI application to generate QR codes from URLs using QRCoder library.
# Rearched/Written by: [Oneyearmuse] using ChatGPT & Visual Studio Coder
# Date: 02-05-25 - Modified: 16-05-25
# Code Ref Link:https://peramhe.github.io/posts/How-to-generate-SEPA-Credit-Transfer-(SCT)-QR-codes-using-PowerShell/

Set-ExecutionPolicy -ExecutionPolicy Bypass -Scope CurrentUser

Add-Type -AssemblyName System.Windows.Forms
Add-Type -AssemblyName System.Drawing

# Load QRCoder.dll assembly
$QRCoderDLLPath = "C:\QR Code Generator\QRCoder.dll"
$DllBytes = [System.IO.File]::ReadAllBytes($QRCoderDLLPath)
[System.Reflection.Assembly]::Load($DllBytes) | Out-Null

# Create the form
$form = New-Object System.Windows.Forms.Form
$form.Text = "QR Code Generator (Oneyearmuse)"
$form.Size = New-Object System.Drawing.Size(400,500)

#Create Tooltip Object
$toolTip = New-Object System.Windows.Forms.ToolTip

#Always Button on/off at the top of the form
$AlwaysButton = New-Object System.Windows.Forms.Button
$AlwaysButton.Size = New-Object System.Drawing.Size(100, 20)
$AlwaysButton.Location = New-Object System.Drawing.Point(150, 4)
$AlwaysButton.AutoSize = $false
$AlwaysButton.Font = New-Object System.Drawing.Font("Arial", 7, [System.Drawing.FontStyle]::Bold)
$AlwaysButton.Text = "Always Off"

# Always on Top/Off Button
$form.Controls.Add($AlwaysButton)
$toolTip.SetToolTip($AlwaysButton, "Window Always on top or not.")
$form.TopMost = $false

# Define the button click event
$AlwaysButton.Add_Click({
    if ($form.TopMost) {
        $form.TopMost = $false
        $AlwaysButton.Text = "Always Off"
    } else {
        $form.TopMost = $true
        $AlwaysButton.Text = "Always on Top"
    }
})

# Create the label for URL input
$urlLabel = New-Object System.Windows.Forms.Label
$urlLabel.Text = "Please enter the URL to create a QR code"
$urlLabel.Font = New-Object System.Drawing.Font("Arial", 10, [System.Drawing.FontStyle]::Bold)
$urlLabel.Location = New-Object System.Drawing.Point(65, 30)
$urlLabel.AutoSize = $true
$form.Controls.Add($urlLabel)

# Create the textbox for URL input
$textbox = New-Object System.Windows.Forms.TextBox
$textbox.Location = New-Object System.Drawing.Point(50,50)
$textbox.Size = New-Object System.Drawing.Size(300,20)

# Create the button to generate QR code
$buttonGenerate = New-Object System.Windows.Forms.Button
$buttonGenerate.Text = "Generate QR Code"
$buttonGenerate.Location = New-Object System.Drawing.Point(150,100)
$buttonGenerate.Size = New-Object System.Drawing.Size(100,30)
$buttonGenerate.AutoSize = $true

# Create the button to save QR code
$buttonSave = New-Object System.Windows.Forms.Button
$buttonSave.Text = "Save QR Code"
$buttonSave.Location = New-Object System.Drawing.Point(158,150)
$buttonSave.AutoSize = $true
$buttonSave.Enabled = $false

# Create the picture box to display the QR code
$pictureBox = New-Object System.Windows.Forms.PictureBox
$pictureBox.Location = New-Object System.Drawing.Point(100,200)
$pictureBox.Size = New-Object System.Drawing.Size(200,200)
$pictureBox.BorderStyle = [System.Windows.Forms.BorderStyle]::FixedSingle

# Create a XKCD button
$xkcdbutton = New-Object System.Windows.Forms.Button
$xkcdbutton.Text = "Do Not Click Me!"
$xkcdbutton.Size = New-Object System.Drawing.Size(30, 5)
$xkcdbutton.Location = New-Object System.Drawing.Point(176, 420)
$xkcdButton.AutoSize = $true
$xkcdButton.Font = New-Object System.Drawing.Font("Arial", 10, [System.Drawing.FontStyle]::Bold)
$xkcdbutton.Add_Click({
    # Open a random XKCD comic in Microsoft Edge
    $url = "https://c.xkcd.com/random/comic/"
    
    # Open Microsoft Edge with the random XKCD URL
    Start-Process "msedge.exe" -ArgumentList $url
})
$form.Controls.Add($xkcdbutton)

# Create a XKCD button
$linktreebutton = New-Object System.Windows.Forms.Button
$linktreebutton.Text = "OYM"
$linktreebutton.Size = New-Object System.Drawing.Size(30, 5)
$linktreebutton.Location = New-Object System.Drawing.Point(100, 420)
$linktreeButton.AutoSize = $true
$linktreeButton.Font = New-Object System.Drawing.Font("Arial", 10, [System.Drawing.FontStyle]::Bold)
$linktreebutton.Add_Click({
    # Opens my linktr.ee page in Microsoft Edge
    $url = "https://linktr.ee/seadevil4"
    
    # Open Microsoft Edge with the random Linktree URL
    Start-Process "msedge.exe" -ArgumentList $url
})
$form.Controls.Add($linktreebutton)

# Add controls to the form
$form.Controls.Add($textbox)
$form.Controls.Add($buttonGenerate)
$form.Controls.Add($buttonSave)
$form.Controls.Add($pictureBox)

# Define the function to generate QR code
$buttonGenerate.Add_Click({
    $url = $textbox.Text
    if ($url) {
        $QRCodeGenerator = [QRCoder.QRCodeGenerator]::new()
        $QRCodeData = $QRCodeGenerator.CreateQrCode($url, [QRCoder.QRCodeGenerator+ECCLevel]::M)
        $PngByteQRCode = [QRCoder.PngByteQRCode]::new($QRCodeData)
        $PngByteArray = $PngByteQRCode.GetGraphic(3)  # Reduced module size
        
        # Convert byte array to image
        $stream = [System.IO.MemoryStream]::new($PngByteArray)
        $global:bitmap = [System.Drawing.Image]::FromStream($stream)
        if ($global:bitmap) {
            # Center the image in the PictureBox
            $pictureBox.SizeMode = [System.Windows.Forms.PictureBoxSizeMode]::CenterImage
            $pictureBox.Image = $global:bitmap
            # Enable the save button
            $buttonSave.Enabled = $true
        } else {
            [System.Windows.Forms.MessageBox]::Show("Failed to generate QR code image.")
        }
    } else {
        [System.Windows.Forms.MessageBox]::Show("Please enter a URL.")
    }
})

# Define the function to save QR code
$buttonSave.Add_Click({
    $saveFileDialog = New-Object System.Windows.Forms.SaveFileDialog
    $saveFileDialog.Filter = "PNG Files|*.png"
    $saveFileDialog.Title = "Save QR Code"
    $saveFileDialog.ShowDialog()

    if ($saveFileDialog.FileName -ne "") {
        if ($global:bitmap) {
            # Resize the image before saving
            $resizedBitmap = New-Object System.Drawing.Bitmap(150, 150)
            $graphics = [System.Drawing.Graphics]::FromImage($resizedBitmap)
            $graphics.DrawImage($global:bitmap, 0, 0, 150, 150)
            $graphics.Dispose()
            $resizedBitmap.Save($saveFileDialog.FileName, [System.Drawing.Imaging.ImageFormat]::Png)
            [System.Windows.Forms.MessageBox]::Show("QR Code saved successfully.")
        } else {
            [System.Windows.Forms.MessageBox]::Show("No QR code image to save.")
        }
    }
})

# Show the form
$form.ShowDialog()
