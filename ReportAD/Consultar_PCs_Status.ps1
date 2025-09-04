# Autor: Luiz Lourenco
# Data: 2021-09-29
# Descrição: Script para consultar o status de computadores no Active Directory e gerar um relatório em CSV.

# Limpa a tela
Clear-Host

# Caminho do arquivo TXT contendo a lista de computadores
$computersListPath = "C:\DevProjects\DHL\PowerShell\ReportAD\computers_list.txt"

# Verifica se o módulo ActiveDirectory está instalado e o importa
if (-not (Get-Module -ListAvailable -Name ActiveDirectory)) {
    Install-Module -Name ActiveDirectory -Force -Confirm:$false
}
Import-Module ActiveDirectory

# Lê a lista de computadores do arquivo TXT
$computers = Get-Content -Path $computersListPath

# Cria uma lista para armazenar os resultados
$results = @()

foreach ($computer in $computers) {
    try {
        # Obtém o status do computador no Active Directory
        $computerStatus = Get-ADComputer -Identity $computer -Properties Name, Enabled, LastLogonDate, CanonicalName

        # Adiciona o resultado à lista
        $result = [PSCustomObject]@{
            ComputerName  = $computerStatus.Name
            Enabled       = $computerStatus.Enabled
            LastLogonDate = $computerStatus.LastLogonDate
            CanonicalName = $computerStatus.CanonicalName
        }

        # Adiciona o resultado à lista de resultados
        $results += $result

        # Imprime o resultado na tela
        Write-Output $result

    } catch {
        # Em caso de erro, adiciona uma entrada com o erro
        $results += [PSCustomObject]@{
            ComputerName  = $computer
            Enabled       = "N/A"
            LastLogonDate = "N/A"
            Error         = $_.Exception.Message
            
        }
    }
}

# Exporta os resultados para um arquivo CSV
$results | Export-Csv -Path "C:\DevProjects\DHL\PowerShell\ReportAD\computers_status_report.csv" -NoTypeInformation

Write-Output "Relatório de status dos computadores gerado com sucesso."