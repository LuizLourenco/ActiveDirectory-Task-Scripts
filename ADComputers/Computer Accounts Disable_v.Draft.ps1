#Run PowerShell as Administrator Right

# Remember
#First Set an Execution Policy as Unrestricted = Set-ExecutionPolicy Unrestricted

# Preparing the execution environment
Set-ExecutionPolicy Unrestricted CurrentUser
Clear-Host

# Importing the Active Directory module
Import-Module ActiveDirectory

# Start counting as 0
$count = 0

# Path to the text file containing the list of computers
$computersFile = "..\HostnameList.txt"

# Reading the text file
$computers = Get-Content $computersFile

# Loop through the computers in the list
foreach ($computer in $computers) {
    # Getting the computer object from Active Directory
    $adComputer = Get-ADComputer -Filter "Name -eq '$($computer)'"
    $adComputerDescription = Get-ADComputer -Filter "Name -eq '$computer'" -Properties Description

    # Increment the count
    $count++

    Try {

        # Checking if the computer has been found
        if ($adComputer) {
            # Disabling the computer object
            Disable-ADAccount -Identity $adComputer.SamAccountName
            Write-Output "$count - The computer $($adComputer.Name) was disabled."

            # Updating the computer object's “Description” field
            $newDescription = "Disabled on TechRefresh at 2024 by LLourenc | " + $adComputerDescription.Description

            Set-ADComputer -Identity $adComputer -Description $newDescription
            Write-Output "The 'Description' field of the $($adComputer.Name) computer has been updated to '$newDescription'."

        } else {
            Write-Output "  "
            Write-Output "$count - The computer $($computer) was not found in Active Directory."
        }        

    }
    Catch {
        # This block will be executed if an error occurs in the Try block
        Write-Output "  "
        Write-Host "$count - Erro found with $adComputer : $($_.Exception.Message)"
    }
}
