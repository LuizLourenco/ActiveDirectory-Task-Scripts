#Abrir o PowerShell com Admin
#1. Set-ExecutionPolicy Unrestricted


# Limpa a saída
Clear-Host

# Declaração de Variáveis
$users=Get-Content 'C:\Users\LLourenc\OneDrive - DPDHL\ScriptCode\PowerShell\UsersAccounts\1.UserStatusList.txt'

# Inicializa o contador
$contador = 0

Write-Host "Count;UserID;EmailAddress;UserDN;Status"
ForEach ($user in $users)
{
    Try{

        # Incrementa o contador a cada iteração
        $contador++

        # Busca o usuário no AD e extrai o DistinguishedName
        $userX = Get-ADUser -Identity $user -Properties DistinguishedName, Enabled, EmailAddress

        #Capitura o login do usuário
        $userID = $userX.Name   

        # Modifica o DistinguishedName para o formato desejado
        $userDN = $userX.DistinguishedName.Replace("CN=", "").Replace($userID+",OU=", "").Replace(",DC=phx-dc,DC=dhl,DC=com","").Replace("Users,OU=","").Replace(",OU=","-")

        Write-Host "$contador;$userID;$($userX.EmailAddress);$userDN;$($userX.Enabled)"
    
    }
    Catch{
        # Este bloco será executado se ocorrer um erro no bloco Try
        Write-Host "$contador - Erro with user $user : $($_.Exception.Message)"

    }
   
}




