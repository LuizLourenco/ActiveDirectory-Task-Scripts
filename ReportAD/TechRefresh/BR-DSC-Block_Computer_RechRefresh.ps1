#Clear Screen
Clear-Host

# Define the path to the TXT file containing the list of computers
$computerListPath = "C:\DevProjects\DHL\PowerShell\ReportAD\TechRefresh\ComputerList.txt"

# Define the target OU where the computers will be moved
$targetOU = "OU=TechRefresh,OU=Disabled,OU=DSC,OU=BR,OU=Prod,OU=Computers,OU=NGWS,DC=phx-dc,DC=dhl,DC=com"

# Import the Active Directory module
Import-Module ActiveDirectory

# Menssagem para Adicionar ao objeto no AD
$msg2ObjDsc = "Blocked because of Tech Refresh at 2024"

# Start Count
$count = 0

# Read the list of computers from the TXT file
$computers = Get-Content -Path $computerListPath

# Loop through each computer in the list
foreach ($computer in $computers) {
    $count=$count+1
    try {
        # Search for the computer in Active Directory
        $adComputer = Get-ADComputer -Identity $computer -ErrorAction Stop

        # Block the computer account
        Set-ADComputer -Identity $adComputer -Enabled $false -ErrorAction Stop

        # Add a comment to the description of the computer object
        Set-ADComputer -Identity $adComputer -Description $msg2ObjDsc -ErrorAction Stop

        # Move the computer to the target OU
        Move-ADObject -Identity $adComputer.DistinguishedName -TargetPath $targetOU -ErrorAction Stop

        # Log the action to the console
        Write-Host "$count | $computer Computer has been blocked, moved to $targetOU, and updated with a description." -ForegroundColor Green
    } catch {
        # Log any errors to the console
        Write-Host "$count | $computer Failed to process computer : $_" -ForegroundColor Red
    }
}

# End of script