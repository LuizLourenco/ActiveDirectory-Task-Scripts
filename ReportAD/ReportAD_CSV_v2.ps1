<#
ScriptName..: ReportAD_CSV.ps1
Description.: Report computers from DHL Active Directory (PHX-DC)
Written.....: Leandro Prado (Leandro.Prado2@dhl.com)
When........: 04/Abr/2024
Updated.....: Leandro Prado
When........: 29/Abr/2024
Requirements: RSAT - Active Directory
#>

cls
Write-host "============================================================================================================"
Write-host "= Active Directory Computers Report - PHX-DC                                        Written: Leandro Prado ="
Write-host "= List from PHX-DC to BU: DSC/EXP/GBS/ITS                                           Updated: Leandro Prado ="
Write-host "= List from PHX-DC to Country AR, BR, CL, CR, CO and MX                                                    ="
Write-host "= Requirements: RSAT - Active Directory,                                                                   ="
Write-host "= At the end, the file named ADReport will be avaliable in C:\Temp\ADReport\                               ="
Write-host "============================================================================================================"

$reportPath = "C:\Users\rpa01EUSLD\OneDrive - DPDHL\RobotEUS\Scripts\ReportAD_CSV.ps1"
$finalCsv = "C:\Users\rpa01EUSLD\OneDrive - DPDHL\RobotEUS\ADReport\ReportAD.csv"

Write-Host "Checking Path..."

If(!(test-path $reportPath))
{
    New-Item -ItemType Directory -Force -Path $reportPath
}

Write-Host "Creating Report.."

$ous = @(
# NGWS AR DSC
    "OU=DSC,OU=AR,OU=Prod,OU=Computers,OU=NGWS,DC=phx-dc,DC=dhl,DC=com", 
# NGWS AR ITS
    "OU=ITS,OU=AR,OU=Prod,OU=Computers,OU=NGWS,DC=phx-dc,DC=dhl,DC=com", 
# NGWS BR DSC
    "OU=DSC,OU=BR,OU=Prod,OU=Computers,OU=NGWS,DC=phx-dc,DC=dhl,DC=com"
# NGWS BR EXP
    "OU=EXP,OU=BR,OU=Prod,OU=Computers,OU=NGWS,DC=phx-dc,DC=dhl,DC=com", 
# NGWS BR GBS
    "OU=GBS,OU=BR,OU=Prod,OU=Computers,OU=NGWS,DC=phx-dc,DC=dhl,DC=com", 
# NGWS BR ITS
    "OU=ITS,OU=BR,OU=Prod,OU=Computers,OU=NGWS,DC=phx-dc,DC=dhl,DC=com", 
# NGWS CL DSC
    "OU=DSC,OU=CL,OU=Prod,OU=Computers,OU=NGWS,DC=phx-dc,DC=dhl,DC=com", 
# NGWS CL ITS
    "OU=ITS,OU=CL,OU=Prod,OU=Computers,OU=NGWS,DC=phx-dc,DC=dhl,DC=com", 
# NGWS CL ITS
    "OU=ITS,OU=CR,OU=Prod,OU=Computers,OU=NGWS,DC=phx-dc,DC=dhl,DC=com", 
# NGWS CO DGF
    "OU=DGF,OU=CO,OU=Prod,OU=Computers,OU=NGWS,DC=phx-dc,DC=dhl,DC=com", 
# NGWS CO DSC
    "OU=DSC,OU=CO,OU=Prod,OU=Computers,OU=NGWS,DC=phx-dc,DC=dhl,DC=com", 
# NGWS MX DGF
    "OU=DGF,OU=MX,OU=Prod,OU=Computers,OU=NGWS,DC=phx-dc,DC=dhl,DC=com", 
# NGWS MX DSC
    "OU=DSC,OU=MX,OU=Prod,OU=Computers,OU=NGWS,DC=phx-dc,DC=dhl,DC=com" 

)
$data = @()

$dateTimeFormat = "dd/MM/yyyy HH:mm:ss"

foreach ($ou in $ous) {
    $splitOu = $ou -split ","
    $loc_cod = $splitOu[4].Split('=')[1] + "-" + $splitOu[1].Split('=')[1] + "-" + $splitOu[0].Split('=')[1]
    Write-host "Getting $loc_cod"
    
    $ouData = get-adcomputer -SearchBase $ou -filter *  -properties CanonicalName, name, description, enabled, OPeratingSystem, whenCreated, lastlogondate, distinguishedname | 
    select  @{Name='Loc_Cod'; Expression={$loc_cod}},
    @{Name='CanonicalName'; Expression={$_.CanonicalName}},
    @{Name='ComputerName'; Expression={$_.name}}, 
    @{Name='Description'; Expression={$_.description}},
    @{Name='Enabled'; Expression={$_.enabled}},
    @{Name='OperatingSystem'; Expression={$_.OperatingSystem}},
    @{Name='WhenCreated'; Expression={$_.whenCreated.ToString($dateTimeFormat)}},
    @{Name='LastLogonDate'; Expression={$_.lastlogondate.ToString($dateTimeFormat)}},
    @{Name='DaysSinceLastLogon'; Expression={if ($_.lastlogondate -ne $null) {(New-TimeSpan -Start $_.lastlogondate -End (Get-Date)).Days} else {"N/A"}}}
    
    $data += $ouData
}

$data | Export-Csv $finalCsv -NoTypeInformation
Write-Host "The Report is now Completed, the file is available in $finalCsv"
