$Base = "\\go.johnsoncontrols.com\Nasuni$\1159\SA-FS02\Projects"
function moveFiles {
    param (
        $UnitNumberInput,
        $JobNumberInput
    )

    $UnitNumber = [int]$UnitNumberInput.text
    $JobNumber = $JobNumberInput.text
    $Prefix =  $JobNumber.ToString().substring(0, 2) + "00"

    $DestURL = "$Base\$Prefix"

    try {
        $JobNumberFolder = Get-ChildItem -Path $DestURL -Filter "*$JobNumber*"
        if ($JobNumberFolder.Count -eq 0) {
            throw "No job folders found matching the pattern *$JobNumber*"
        }elseif($JobNumberFolder.Count -gt 1){
            #multiple selections found. get user input
            $i = 0
            Write-Host "=== SELECTION ===" -ForegroundColor Cyan
            for ($i; $i -le $JobNumberFolder.Count - 1; $i++) {
                $var = $JobNumberFolder[$i]
                Write-Host "$i. $var"   
            }
            Write-Host "e. Exit"
    
            $choice = Read-Host "Please select an option"
            $temp = ""
            switch ($choice) {
            "$_" {
                $temp = $JobNumberFolder[$_]
                $DestURL = "$DestUrl\$temp"
            }
            "e"{
                Write-Host "Exiting..."
                break;
            }
            Default { 
                Write-Host "Invalid option, try again." -ForegroundColor Red; Start-Sleep -Seconds 1 }
            }
        }else{
            $DestURL = Join-Path $DestURL $JobNumberFolder
        }
    } catch {
        Write-Host "Error: $_"
        return
    }
    $QualityURL = Get-ChildItem -Path $DestURL -Filter "*Quality*"
    $DestURL = "$DestURL\$QualityURL"

    switch ($UnitNumber) {
        {$_ -le 32} {
            $Colo = Get-ChildItem $QualityRootFolder -Filter "*32"
            break
        }
        {$_ -ge 33 -and $_ -le 64} {
            $Colo = Get-ChildItem $DestURL -Filter "*64"
            break
        }
        {$_ -ge 65 -and $_ -le 96} {
            $Colo = Get-ChildItem $DestURL -Filter "*96"
            break
        }
        {$_ -ge 97 -and $_ -le 128} {
            $Colo = Get-ChildItem $DestURL -Filter "*128"
            break
        }
        {$_ -ge 129 -and $_ -le 160} {
            $Colo = Get-ChildItem $DestURL -Filter "*160"
            break
        }
        {$_ -ge 161 -and $_ -le 192} {
            $Colo = Get-ChildItem $DestURL -Filter "*192"
            break
        }
        default {
            Write-Host "Unit number out of expected range."
            return
        }
    }

    $DestURL = Join-Path $DestURL $Colo
    Write-Host $DestURL
    try {
        $UnitFolder = Get-ChildItem -Path $DestURL -Filter "*$UnitNumber*" | Where-Object { $_.Name -match "\-$UnitNumber[L|R]$" }
        if ($null -eq $UnitFolder) {
            throw "No unit folder found matching the pattern *-$UnitNumber*"
        }

        $FunctionalityRootFolder = "$DestURL\$UnitFolder"
        Write-Host "Functionality Root Folder: $FunctionalityRootFolder"

        $FunctionalityFolder = Get-ChildItem -Path $FunctionalityRootFolder -Filter "*functionality*"
        if ($null -eq $FunctionalityFolder) {
            throw "No functionality folder found in $FunctionalityRootFolder"
        }

        $UnitRootFolder = "$FunctionalityRootFolder\$FunctionalityFolder"
        Write-Host "Unit Root Folder: $UnitRootFolder"
    } catch {
        Write-Host "Error: $_"
        return
    }

    $Destination = $UnitRootFolder

    if(Test-Path -Path "$env:USERPROFILE\OneDrive - Johnson Controls\Downloads"){
        $RootSource = "$env:USERPROFILE\OneDrive - Johnson Controls\Downloads"
    } else {
        $RootSource = "$env:USERPROFILE\Downloads"
    }

    try {
        $SourceFile = Get-ChildItem -Path $RootSource -Filter "*$JobNumber-$UnitNumber*"
        if ($null -eq $SourceFile) {
            throw "No files found matching the pattern *$JobNumber-$UnitNumber*"
        }
    } catch {
        Write-Host "Error: $_"
        return
    }

    foreach ($file in $SourceFile) {
        $FileFT = Get-ChildItem -Path $RootSource  "*$JobNumber-$UnitNumber*"
    }

    $FT = "$RootSource\$FileFT"


    Write-Host "Destination: $Destination"
    Write-Host "FT File: $FT"

    try {
        if($FileFT){
            Move-Item -Path $FT -Destination $Destination
        }
    } catch {
        Write-Host "Error moving files: $_"
    }

    Get-ChildItem -Path $UnitRootFolder
    Invoke-Item $UnitRootFolder
}

function search{
    param($ColoNumber, $JobNumber)


    $ColoNumber = [int]$UnitNumberInput.text
    $JobNumber = $JobNumberInput.text
    $Prefix =  $JobNumber.ToString().substring(0, 2) + "00"

    $DestURL = "$Base/$Prefix"

    try {
        $JobNumberFolder = Get-ChildItem -Path $DestURL -Filter "*$JobNumber*"
        if ($JobNumberFolder.Count -eq 0) {
            throw "No job folders found matching the pattern *$JobNumber*"
        }elseif($JobNumberFolder.Count -gt 1){
            #multiple selections found. get user input
            $i = 0
            Write-Host "=== SELECTION ===" -ForegroundColor Cyan
            for ($i; $i -le $JobNumberFolder.Count - 1; $i++) {
                $var = $JobNumberFolder[$i]
                Write-Host "$i. $var"   
            }
            Write-Host "e. Exit"
    
            $choice = Read-Host "Please select an option"
            $temp = ""
            switch ($choice) {
            "$_" {
                $temp = $JobNumberFolder[$_]
                $DestURL = "$DestUrl\$temp"
            }
            "e"{
                Write-Host "Exiting..."
                break;
            }
            Default { 
                Write-Host "Invalid option, try again." -ForegroundColor Red; Start-Sleep -Seconds 1 }
            }
        }
    } catch {
        Write-Host "Error: $_"
        return
    }

    $temp = Get-ChildItem -Path $DestURL -Filter "*Quality*"
    $DestURL = "$DestURl\$temp"
    $Colo = Get-ChildItem $DestURL -Filter "*Colo $ColoNumber*"

    $ColoRootFolder = "$DestUrl\$Colo"
    Write-Host $ColoRootFolder
    $UnitList = Get-ChildItem $ColoRootFolder
    $count = 0
    $missing = 0
    foreach($child in $UnitList){
        $TestPath = "$ColoRootFolder\$child\Functionality & calibration sheets\*.pdf"
        if(Test-Path $TestPath){
            $count = $count + 1
            $Unit = Get-ChildItem -Path "$ColoRootFolder\$child\Functionality & calibration sheets" -Name
            Write-Host $Unit
        }else {
            $missing = $missing + 1
            Write-Host "Missing: $TestPath"
        }
        } Write-Host "Units in Colo: $count"
        Write-Host "Missing $missing files"
        return 
}


# ls "https://apps.jci.com/sites/JCI-EdmontonElectricalTesters/Shared Documents/General/Plant 4/In Progress functionality reports/Ballard ALC/Ballard"

Add-Type -AssemblyName System.Windows.Forms
Add-Type -AssemblyName System.Drawing

$JobNumberLabel = New-Object System.Windows.Forms.label
$JobNumberLabel.text = "Job Number:"
$JobNumberLabel.Size = New-Object System.Drawing.Size(80,30)
$JobNumberLabel.Location = new-object System.Drawing.Size(20,10)

$JobNumberInput = New-Object System.Windows.Forms.textbox
$JobNumberInput.text = ""
$JobNumberInput.Multiline = $False
$JobNumberInput.Size = New-Object System.Drawing.Size(40,40)
$JobNumberInput.Location = new-object System.Drawing.Size(40,40)

$UnitNumberLabel = New-Object System.Windows.Forms.label
$UnitNumberLabel.text = "Unit or Colo Number:"
$UnitNumberLabel.Location = new-object System.Drawing.Size(100,10) # 20,20
$UnitNumberLabel.Size = New-Object System.Drawing.Size(120,30) #100,20

$UnitNumberInput = New-Object System.Windows.Forms.textbox
$UnitNumberInput.text = ""
$UnitNumberInput.Multiline = $False
$UnitNumberInput.Location = new-object System.Drawing.Size(130,40) #40,40
$UnitNumberInput.Size = New-Object System.Drawing.Size(40,40)

$MoveFilesButton = New-Object System.Windows.Forms.button
$MoveFilesButton.text = "Move Files"
$MoveFilesButton.Location = new-object System.Drawing.Size(20,75)
$MoveFilesButton.Add_Click({
    moveFiles -UnitNumberInput $UnitNumberInput -JobNumberInput $JobNumberInput
})

$SearchFilesButton = New-Object System.Windows.Forms.button
$SearchFilesButton.text = "Search Files"
$SearchFilesButton.Location = new-object System.Drawing.Size(120,75)
$SearchFilesButton.Add_Click({
    search -ColoNumber $ColoNumber -JobNumberInput $JobNumberInput
})

$Form = New-Object Windows.Forms.Form
$Form.Text = "Ballard SwiftTransfer"
$Form.Width = 300
$Form.Height = 150

$Form.Controls.add($JobNumberLabel)
$Form.Controls.add($JobNumberInput)
$Form.Controls.add($UnitNumberLabel)
$Form.Controls.add($UnitNumberInput)
$Form.Controls.add($MoveFilesButton)
$Form.Controls.add($SearchFilesButton)

$Form.Add_Shown({$Form.Activate()})
$Form.ShowDialog()
