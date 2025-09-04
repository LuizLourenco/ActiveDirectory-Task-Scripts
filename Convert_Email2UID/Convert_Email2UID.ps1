# Caminho do arquivo de entrada
$inputFile = "C:\DevProjects\DHL\PowerShell\Convert_Email2UID\1.ListaDeEMail.txt"

# Verifica se o arquivo existe
if (-Not (Test-Path $inputFile)) {
    Write-Host "Arquivo não encontrado: $inputFile"
    exit
}

# Lê os e-mails do arquivo
$emailList = Get-Content -Path $inputFile

# Cria uma lista para armazenar os resultados
$resultados = @()

# Loop através de cada e-mail
foreach ($email in $emailList) {
    # Consulta o Active Directory para o e-mail
    $user = Get-ADUser -Filter {EmailAddress -eq $email} -Properties SamAccountName

    if ($user) {
        # Adiciona o resultado à lista
        $resultados += [PSCustomObject]@{
            Email = $email
            UID   = $user.SamAccountName
        }
    } else {
        # Se não encontrar o usuário, adiciona um aviso
        $resultados += [PSCustomObject]@{
            Email = $email
            UID   = "Usuário não encontrado"
        }
    }
}

# Exibe os resultados
$resultados | Format-Table -AutoSize

# Opcional: Salva os resultados em um arquivo
$outputFile = "C:\DevProjects\DHL\PowerShell\Convert_Email2UID\2.Resultado.txt"
$resultados | Out-File -FilePath $outputFile -Encoding utf8

Write-Host "Resultados salvos em: $outputFile"