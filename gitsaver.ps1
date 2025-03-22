# Caminho do reposit�rio Git (opcional, se o script for para ser rodado dentro de um reposit�rio Git j� inicializado)
#$repoPath = "C:\caminho\para\seu\repositorio"

# Mudar para o diret�rio do reposit�rio (caso o script esteja sendo rodado fora)
#Set-Location -Path $repoPath

# Adicionar todos os arquivos modificados
git add .

# Fazer o commit com uma mensagem padr�o
$commitMessage = "Commit autom�tico com PowerShell"
git commit -m $commitMessage

# Enviar as altera��es para o reposit�rio remoto
git push

Write-Host "Altera��es enviadas com sucesso!"