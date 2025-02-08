function moveFiles{

    $UnitNumber = $UnitNumberInput
    $JobNumber = $JobNumberInput
    $Prefix =  $JobNumber.ToString().substring(0,2) + "00"

    $RootFolder = "N:\$Prefix"              #N:\<[0-9]x4>
    $JobFolders = Get-ChildItem  $RootFolder "*$JobNumber*"

    foreach($job in $JobFolders){
        Write-Host Get-ChildItem $RootFolder\$job "2 Quality\*$Location*"
        # Get-ChildItem $JobRootFolder\$job "2 Quality"
        if(Get-ChildItem $RootFolder\$job "2 Quality\"){
            if(Get-ChildItem "$RootFolder\$job\2 Quality" "*Units*"){
                $QualityRootFolder = "$RootFolder\$job\2 Quality"  #  $QualityRootFolder: N:\<Prefix>\<JobNumber> - ...\2 Quality
            } 
        }
    }

    if($UnitNumber -lt 33){
        $Colo = Get-ChildItem $QualityRootFolder "*32"
    } elseif (($UnitNumber -ge 33) -and ($UnitNumber -le 64)){
        $Colo = Get-ChildItem $QualityRootFolder "*64"
    } elseif(($UnitNumber -ge 65) -and ($UnitNumber -le 96)){
        $Colo = Get-ChildItem $QualityRootFolder "*96"
    } elseif(($UnitNumber -ge 97) -and ($UnitNumber -le 128)){
        $Colo = Get-ChildItem $QualityRootFolder "*128"
    } elseif(($UnitNumber -ge 129) -and ($UnitNumber -le 160)){
        $Colo = Get-ChildItem $QualityRootFolder "*128"
    } 
        
    $ColoRootFolder = "$QualityRootFolder\$Colo"

    $UnitFolder = Get-ChildItem  $ColoRootFolder "*-$UnitNumber*" | Where-Object { $_.Name -match "\-$UnitNumber[L|R]$" }

    $FunctionalityRootFolder = "$ColoRootFolder\$UnitFolder"
    $FunctionalityFolder = Get-ChildItem  $FunctionalityRootFolder "*functionality*"
    $FileName = $FunctionalityRootFolder.ToString()

    $UnitRootFolder = "$FunctionalityRootFolder\$FunctionalityFolder"

    $Destination = $UnitRootFolder
    $RootSource = $env:USERPROFILE + "\Documents" 
    $SourceFile = Get-ChildItem $RootSource "*$JobNumber-$UnitNumber*"
    foreach($file in $RootSource){
        $FileFT = Get-ChildItem $file "*FT.pdf"
        $FileWT = Get-ChildItem $file "*WT.pdf"
    }
    $FT = "$RootSource\$FileFT"
    if($FileWT){
        $WT = "$RootSource\$FileWT"
    }
    # Set-Location $UnitRootFolder
    # Invoke-Item $UnitRootFolder
    Move-Item $FT $Destination
    if($FileWT){
        Move-Item $WT $Destination
    }
    Get-ChildItem $UnitRootFolder
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
$UnitNumberLabel.text = "Unit Number:"
$UnitNumberLabel.Location = new-object System.Drawing.Size(100,10) # 20,20
$UnitNumberLabel.Size = New-Object System.Drawing.Size(80,20) #100,20

$UnitNumberInput = New-Object System.Windows.Forms.textbox
$UnitNumberInput.text = ""
$UnitNumberInput.Multiline = $False
$UnitNumberInput.Location = new-object System.Drawing.Size(130,40) #40,40
$UnitNumberInput.Size = New-Object System.Drawing.Size(40,40)

$MoveFilesButton = New-Object System.Windows.Forms.button
$MoveFilesButton.text = "Move Files"
$MoveFilesButton.Location = new-object System.Drawing.Size(100,70)


$MoveFilesButton.Add_Click({ 
    MoveFiles
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

$Form.Add_Shown({$Form.Activate()})
$Form.ShowDialog()
