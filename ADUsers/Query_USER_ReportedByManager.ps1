#Clear Screen
Clear-Host

# Import the Active Directory module
Import-Module ActiveDirectory

# Define the UID or Email of the user
$userIdentifier = "Matheus.Souzaf@dhl.com" # This can be either the UID or the Email

# Use a filter to find the user by UID or Email
$manager = Get-ADUser -Filter { (sAMAccountName -eq $userIdentifier) -or (mail -eq $userIdentifier) } -Properties DistinguishedName

# Check if the user was found
if ($manager) {
    # Get the list of subordinates
    $subordinates = Get-ADUser -Filter "manager -eq '$($manager.DistinguishedName)'" -Properties DisplayName

    # Create a custom object array with numbering
    $subordinateList = $subordinates | Select-Object @{Name="No."; Expression={[array]::IndexOf($subordinates, $_) + 1}}, DisplayName

    # Display the list of subordinates in a tabular format
    $subordinateList | Format-Table -AutoSize
} else {
    # If the user was not found, display a message
    Write-Host "User not found with UID or Email: $userIdentifier"
}