function moveFiles {
    param (
        $UnitNumberInput,
        $JobNumberInput
    )

    $UnitNumber = [int]$UnitNumberInput.text
    $JobNumber = $JobNumberInput.text
    $Prefix =  $JobNumber.ToString().substring(0, 2) + "00"

    $RootFolder = "N:\$Prefix"

    try {
        $JobFolders = Get-ChildItem -Path $RootFolder -Filter "*$JobNumber*"
        if ($JobFolders.Count -eq 0) {
            throw "No job folders found matching the pattern *$JobNumber*"
        }
    } catch {
        Write-Host "Error: $_"
        return
    }

    foreach ($job in $JobFolders) {
        try {
            $qualityPath = "$RootFolder\$job\2 Quality"
            $unitsPath = "$qualityPath\*Units*"

            Write-Host "Checking path: $qualityPath"

            if (Test-Path $qualityPath) {
                if (Get-ChildItem -Path $qualityPath -Filter "*Units*") {
                    $QualityRootFolder = $qualityPath
                    Write-Host "Quality Root Folder found: $QualityRootFolder"
                } else {
                    Write-Host "No Units folder found in: $qualityPath"
                }
            } else {
                Write-Host "Path does not exist: $qualityPath"
            }
        } catch {
            Write-Host "Error accessing path: $_"
        }
    }

    switch ($UnitNumber) {
        {$_ -le 32} {
            $Colo = Get-ChildItem $QualityRootFolder -Filter "*32"
            break
        }
        {$_ -ge 33 -and $_ -le 64} {
            $Colo = Get-ChildItem $QualityRootFolder -Filter "*64"
            break
        }
        {$_ -ge 65 -and $_ -le 96} {
            $Colo = Get-ChildItem $QualityRootFolder -Filter "*96"
            break
        }
        {$_ -ge 97 -and $_ -le 128} {
            $Colo = Get-ChildItem $QualityRootFolder -Filter "*128"
            break
        }
        {$_ -ge 129 -and $_ -le 160} {
            $Colo = Get-ChildItem $QualityRootFolder -Filter "*160"
            break
        }
        {$_ -ge 161 -and $_ -le 192} {
            $Colo = Get-ChildItem $QualityRootFolder -Filter "*192"
            break
        }
        default {
            Write-Host "Unit number out of expected range."
            return
        }
    }

    $ColoRootFolder = "$QualityRootFolder\$Colo"

    try {
        $UnitFolder = Get-ChildItem -Path $ColoRootFolder -Filter "*-$UnitNumber*" | Where-Object { $_.Name -match "\-$UnitNumber[L|R]$" }
        if ($null -eq $UnitFolder) {
            throw "No unit folder found matching the pattern *-$UnitNumber*"
        }

        $FunctionalityRootFolder = "$ColoRootFolder\$UnitFolder"
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

    if(Test-Path -Path "$env:USERPROFILE\OneDrive - Johnson Controls\Documents"){
        $RootSource = "$env:USERPROFILE\OneDrive - Johnson Controls\Documents"
    } else {
        $RootSource = "$env:USERPROFILE\Documents"
    }

    try {
        $SourceFile = Get-ChildItem -Path $RootSource -Filter "*$JobNumber-$UnitNumber*"
        if ($SourceFile -eq $null) {
            throw "No files found matching the pattern *$JobNumber-$UnitNumber*"
        }
    } catch {
        Write-Host "Error: $_"
        return
    }

    foreach ($file in $SourceFile) {
        $FileFT = Get-ChildItem -Path $RootSource  "*$JobNumber-$UnitNumber*FT.pdf"
        $FileWT = Get-ChildItem -Path $RootSource  "*$JobNumber-$UnitNumber*WT.pdf"

    }

    $FT = "$RootSource\$FileFT"
    if ($FileWT) {
        $WT = "$RootSource\$FileWT"
    }

    Write-Host "Destination: $Destination"
    Write-Host "FT File: $FT"
    Write-Host "WT File: $WT"

    try {
        if($FileFT){
            Move-Item -Path $FT -Destination $Destination
        }
        if ($FileWT) {
            Move-Item -Path $WT -Destination $Destination
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

    $RootFolder = "N:\$Prefix"

    try {
        $JobFolders = Get-ChildItem -Path $RootFolder -Filter "*$JobNumber*"
        if ($JobFolders.Count -eq 0) {
            throw "No job folders found matching the pattern *$JobNumber*"
        }
    } catch {
        Write-Host "Error: $_"
        return
    }

    foreach ($job in $JobFolders) {
        try {
            $qualityPath = "$RootFolder\$job\2 Quality"

            Write-Host "Checking path: $qualityPath"

            if (Test-Path $qualityPath) {
                if (Get-ChildItem -Path $qualityPath -Filter "*Units*") {
                    $QualityRootFolder = $qualityPath
                    Write-Host "Quality Root Folder found: $QualityRootFolder"
                } else {
                    Write-Host "No Units folder found in: $qualityPath"
                }
            } else {
                Write-Host "Path does not exist: $qualityPath"
            }
        } catch {
            Write-Host "Error accessing path: $_"
        }
    }

    switch ($ColoNumber) {
        {$_ -eq 1} {
            $Colo = Get-ChildItem $QualityRootFolder -Filter "*32"
            break
        }
        {$_ -eq 2} {
            $Colo = Get-ChildItem $QualityRootFolder -Filter "*64"
            break
        }
        {$_ -eq 3} {
            $Colo = Get-ChildItem $QualityRootFolder -Filter "*96"
            break
        }
        {$_ -eq 4} {
            $Colo = Get-ChildItem $QualityRootFolder -Filter "*128"
            break
        }
        {$_ -eq 5} {
            $Colo = Get-ChildItem $QualityRootFolder -Filter "*160"
            break
        }
        {$_ -eq 6} {
            $Colo = Get-ChildItem $QualityRootFolder -Filter "*192"
            break
        }
        default {
            Write-Host "Unit number out of expected range."
            return
        }
    }

    $ColoRootFolder = "$QualityRootFolder\$Colo"
    $UnitList = Get-ChildItem $ColoRootFolder
    $count = 0
    $missing = 0
    foreach($child in $UnitList){
        if(Test-Path "$ColoRootFolder\$child\Functionality & calibration sheets\*.pdf"){
            $count = $count + 1
            $Unit = Get-ChildItem -Path "$ColoRootFolder\$child\Functionality & calibration sheets" -Name
            Write-Host $Unit
        }else {$missing = $missing + 1}
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
$Form.Text = "SwiftTransfer"
$Form.Width = 250
$Form.Height = 150

$Form.Controls.add($JobNumberLabel)
$Form.Controls.add($JobNumberInput)
$Form.Controls.add($UnitNumberLabel)
$Form.Controls.add($UnitNumberInput)
$Form.Controls.add($MoveFilesButton)
$Form.Controls.add($SearchFilesButton)

$Form.Add_Shown({$Form.Activate()})
$Form.ShowDialog()
