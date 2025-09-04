#Abrir o PowerShell com Admin
#1. Set-ExecutionPolicy Unrestricted

Clear-Host

# Inicializa o contador
$contador = 0

$users=Get-Content 'C:\Users\LLourenc\OneDrive - DPDHL\ScriptCode\PowerShell\UsersAccounts\UserList.txt'

ForEach ($user in $users)
{
    # Incrementa o contador a cada iteração
    $contador++

    Try {
        # Insira o código que pode causar um erro aqui
        Enable-ADAccount -Identity $user
        $currentUser = Get-ADUser -Identity $user -Properties Description
        $newDescription = "#Account is MFA compliant since June-2024"
        
        Set-ADUser -Identity $user -Description $newDescription
        
        write-host "$contador - The user $($user) has enabled and the description has been updated"
    }
    Catch {
        # Este bloco será executado se ocorrer um erro no bloco Try
        Write-Host "$contador - Erro with user $user : $($_.Exception.Message)"
    }
}
