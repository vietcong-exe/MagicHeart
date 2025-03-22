# Caminho do repositório Git (opcional, se o script for para ser rodado dentro de um repositório Git já inicializado)
$repoPath = "C:\caminho\para\seu\repositorio"

# Mudar para o diretório do repositório (caso o script esteja sendo rodado fora)
Set-Location -Path $repoPath

# Adicionar todos os arquivos modificados
git add .

# Fazer o commit com uma mensagem padrão
$commitMessage = "Commit automático com PowerShell"
git commit -m $commitMessage

# Enviar as alterações para o repositório remoto
git push

Write-Host "Alterações enviadas com sucesso!"