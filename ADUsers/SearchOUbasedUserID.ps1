# Importar o módulo do Active Directory
Import-Module ActiveDirectory

# Importar os nomes de usuários de um arquivo txt
$usernames = Get-Content C:\Users\LLourenc\OneDrive - DPDHL\ScriptCode\PowerShell\UsersAccounts\UsersDSCOU.txt

$results = foreach ($username in $usernames) {
    # Obter o caminho completo do AD do usuário
    $user = Get-ADUser -Identity $username -Properties distinguishedName

    if ($user) {
        # Extraia a OU do caminho completo do AD
        $ou = ($user.distinguishedName -split ',',2)[1]

        # Crie um objeto de resultado personalizado
        New-Object PSObject -Property @{
            Username = $username
            OU = $ou
        }
    }
}

# Exportar os resultados para um arquivo CSV
$results | Export-Csv -Path C:\Users\LLourenc\OneDrive - DPDHL\ScriptCode\PowerShell\UsersAccounts\ADReport\UsersDSCOU.csv -NoTypeInformation
