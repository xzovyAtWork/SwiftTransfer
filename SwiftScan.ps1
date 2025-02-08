Add-Type -AssemblyName System.Windows.Forms
Add-Type -AssemblyName System.Drawing

$JobNumberLabel = New-Object System.Windows.Forms.Label
$JobNumberLabel.Text = "Job Number:"
$JobNumberLabel.Location = New-Object System.Drawing.Size(20,20) 
$JobNumberInput = New-Object System.Windows.Forms.TextBox
$JobNumberInput.Text = ""
$JobNumberInput.Size = New-Object System.Drawing.Size(400,100)
$JobNumberInput.Location = New-Object System.Drawing.Size(40,60)

$UserRootFolder = New-Object System.Windows.Forms.textbox
$UserRootFolder.text = $env:USERPROFILE + '\Desktop\'
$UserRootFolder.Multiline = $False
$UserRootFolder.Size = New-Object System.Drawing.Size(400,100)
$UserRootFolder.Location = new-object System.Drawing.Size(40,180)

$SearchFilesButton = New-Object System.Windows.Forms.button
$SearchFilesButton.text = "Search Files"
$SearchFilesButton.Location = new-object System.Drawing.Size(200,100)

function ScanAndSaveOutput {
    param (
        $JobNumberInput
    )

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

    
    Get-ChildItem -Path $QualityRootFolder -Recurse -Name -Filter "*T.pdf" |
    Select-String -Pattern "tasklist", "inspection", '-calibration' -NotMatch |
    Out-File -FilePath "$env:USERPROFILE\Desktop\$JobNumber-log.csv"
}

$SearchFilesButton.Add_Click({
    ScanAndSaveOutput -JobNumber $JobNumberInput
    $Form.Close();
})

$Form = New-Object Windows.Forms.Form
$Form.Text = "SwiftScan"
$Form.Width = 500
$Form.Height = 200


$Form.Controls.add($JobNumberLabel)
$Form.Controls.add($JobNumberInput)
# $Form.Controls.add($EndPointLabel)
$Form.Controls.add($SearchFilesButton)

$Form.Add_Shown({$Form.Activate()})
$Form.ShowDialog()