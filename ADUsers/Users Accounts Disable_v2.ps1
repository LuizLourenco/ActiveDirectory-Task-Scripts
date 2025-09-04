#Abrir o PowerShell com Admin
#1. Set-ExecutionPolicy Unrestricted

Clear-Host

# Inicializa o contador
$contador = 0


$users=Get-Content 'C:\Users\LLourenc\OneDrive - DPDHL\ScriptCode\PowerShell\UsersAccounts\2.UserList2Block.txt'


ForEach ($user in $users)
{ 
    # Incrementa o contador a cada iteração
    $contador++

    Try {
        # Insira o código que pode causar um erro aqui
        Disable-ADAccount -Identity $user
        $currentUser = Get-ADUser -Identity $user -Properties Description
        $newDescription = "#Account disabled because of MFA at 27-Aug-2024 by phx-dc\LLourenc |"+$currentUser.Description
        #$newDescription = "#Account disabled because of MFA at 06-Aug-2024"

        Set-ADUser -Identity $user -Description $newDescription

        write-host "$contador - The user $($user) has been disabled and the description has been updated"

    }
    Catch {
        # Este bloco será executado se ocorrer um erro no bloco Try
        Write-Host "$contador - Erro with user $user : $($_.Exception.Message)"
    }
}
