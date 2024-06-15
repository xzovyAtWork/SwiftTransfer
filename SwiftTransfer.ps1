Add-Type -AssemblyName System.Windows.Forms
Add-Type -AssemblyName System.Drawing

$JobPrefixLabel = New-Object System.Windows.Forms.label
$JobPrefixLabel.text = "Date Code:"
$JobPrefixLabel.Size = New-Object System.Drawing.Size(40,20)
$JobPrefixLabel.Location = new-object System.Drawing.Size(20,10)

$JobPrefix = New-Object System.Windows.Forms.textbox
$JobPrefix.text = "0793"
$JobPrefix.Multiline = $False
$JobPrefix.Size = New-Object System.Drawing.Size(40,40)
$JobPrefix.Location = new-object System.Drawing.Size(40,40)

$JobNumberLabel = New-Object System.Windows.Forms.label
$JobNumberLabel.text = "Job Number:"
$JobNumberLabel.Location = new-object System.Drawing.Size(100,10) # 20,20
$JobNumberLabel.Size = New-Object System.Drawing.Size(80,20) #100,20

$JobNumber = New-Object System.Windows.Forms.textbox
$JobNumber.text = "3906"
$JobNumber.Multiline = $False
$JobNumber.Size = New-Object System.Drawing.Size(40,40)
$JobNumber.Location = new-object System.Drawing.Size(130,40) #40,40

$UnitNumbersLabel = New-Object System.Windows.Forms.label
$UnitNumbersLabel.text = "Unit Numbers:"
$UnitNumbersLabel.Location = new-object System.Drawing.Size(20,80)

$UnitNumbers = New-Object System.Windows.Forms.textbox
$UnitNumbers.text = "1L,3L,5L"
$UnitNumbers.Multiline = $False
$UnitNumbers.Size = New-Object System.Drawing.Size(130,100)
$UnitNumbers.Location = new-object System.Drawing.Size(40,110)

$DestinationFolderLabel = New-Object System.Windows.Forms.label
$DestinationFolderLabel.text = "Destination Address:"
$DestinationFolderLabel.Location = new-object System.Drawing.Size(20,230)

$DestinationFolder = New-Object System.Windows.Forms.textbox
$DestinationFolder.text = "n:\3900\3906 - MSFT - CYS14 Ballard Direct Evap\2 Quality\Colo 1 Units 1 - 32"
$DestinationFolder.Multiline = $False
$DestinationFolder.Size = New-Object System.Drawing.Size(300,100)
$DestinationFolder.Location = new-object System.Drawing.Size(40,260)

$EndPointLabel = New-Object System.Windows.Forms.label
$EndPointLabel.text = "End Folder:"
$EndPointLabel.Location = new-object System.Drawing.Size(20,300)
$EndPoint = New-Object System.Windows.Forms.textbox
$EndPoint.text = "Functionality & calibration sheets"
$EndPoint.Multiline = $False
$EndPoint.Size = New-Object System.Drawing.Size(300,100)
$EndPoint.Location = new-object System.Drawing.Size(40,330)

$UserRootLabel = New-Object System.Windows.Forms.label
$UserRootLabel.text = "Source Folder:"
$UserRootLabel.Location = new-object System.Drawing.Size(20,150)

$UserRootFolder = New-Object System.Windows.Forms.textbox
$UserRootFolder.text = "c:\Users\Caleb.Steinwandt\Desktop\"
$UserRootFolder.Multiline = $False
$UserRootFolder.Size = New-Object System.Drawing.Size(300,100)
$UserRootFolder.Location = new-object System.Drawing.Size(40,180)

$MoveFilesButton = New-Object System.Windows.Forms.button
$MoveFilesButton.text = "Move Files"
$MoveFilesButton.Location = new-object System.Drawing.Size(380,400)

$SearchFilesButton = New-Object System.Windows.Forms.button
$SearchFilesButton.text = "Search Files"
$SearchFilesButton.Location = new-object System.Drawing.Size(280,400)


function MoveFiles {
    # $prefix -match '\d{4}' 
    $prefix = $JobPrefix.Text
    $jobNumber = $JobNumber.Text
     $unitNumbers = $UnitNumbers.Text.Split(',')
    # $unitNumbers = $UnitNumbers.Text -split ',\s*'
    $baseFolder = $DestinationFolder.Text
    $folder = $EndPoint.Text
    $source = $UserRootFolder.Text


    foreach ($unit in $unitNumbers) {
        $source1 = "$source$jobNumber-$unit FT.pdf"
        $source2 = "$source$jobNumber-$unit WT.pdf"
        $destination = Join-Path $baseFolder "$prefix-$jobNumber-$unit\$folder"
        Move-Item -Path $source1 -Destination $destination
        if (Test-Path -Path $source2 -PathType Leaf) {
            Move-Item -Path $source2 -Destination $destination
        } else {
            Write-Host "Source2 does not exist or is not a file: $source2"
        }
    }
}

function ScanAndSaveOutput {
    $jobNumber = $JobNumber.Text
    $unitNumbers = $UnitNumbers.Text.Split(',')
    $baseFolder = $DestinationFolder.Text
    $source = $UserRootFolder.Text
     
    Get-ChildItem -Path $baseFolder -Recurse -Filter -Name "*T.pdf" |
    Select-String -Pattern "tasklist" -NotMatch |
    Out-File -FilePath "$source\$jobNumber-list.txt"
}


$MoveFilesButton.Add_Click({ 
    MoveFiles
})

$SearchFilesButton.Add_Click({
    ScanAndSaveOutput
})

$Form = New-Object Windows.Forms.Form
$Form.Text = "SwiftTransfer"
$Form.Width = 500
$Form.Height = 500

$Form.Controls.add($JobPrefixLabel)
$Form.Controls.add($JobPrefix)
$Form.Controls.add($JobNumberLabel)
$Form.Controls.add($JobNumber)
$Form.Controls.add($UnitNumbersLabel)
$Form.Controls.add($UnitNumbers)
$Form.Controls.add($DestinationFolderLabel)
$Form.Controls.add($DestinationFolder)
$Form.Controls.add($EndPointLabel)
$Form.Controls.add($EndPoint)
$Form.Controls.add($UserRootLabel)
$Form.Controls.add($UserRootFolder)
$Form.Controls.add($MoveFilesButton)
$Form.Controls.add($SearchFilesButton)

$Form.Add_Shown({$Form.Activate()})
$Form.ShowDialog()

