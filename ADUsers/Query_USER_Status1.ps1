Clear-Host

#Variavel do Usuário
$usuarioPesquisado='graziedo'

Get-ADUser $usuarioPesquisado -Server phx-dc.dhl.com -Properties * | findstr extensionAttribute

Get-ADUser $usuarioPesquisado -Server phx-dc.dhl.com -Properties * | findstr UserPrincipalName

