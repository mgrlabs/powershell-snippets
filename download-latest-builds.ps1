# Force PowerShell to utilise TLS 1.2 as it defaults to 1.0
[Net.ServicePointManager]::SecurityProtocol = [Net.SecurityProtocolType]::Tls12

# Install latest release of Git for Windows - https://gitforwindows.org/
Write-Host "Downloading Git for Windows..."
$gfwRepo = "git-for-windows/git"
$gfwLatest = (Invoke-WebRequest "https://api.github.com/repos/$gfwRepo/releases/latest" | ConvertFrom-Json)
$gfwExe = $gfwLatest.assets.name | Select-String -Pattern "(?=.*Git)(?=.*64-bit.exe)^(?!.*busybox)"
Invoke-WebRequest "https://github.com/$gfwRepo/releases/download/$($gfwLatest.tag_name)/$gfwExe" -OutFile Git-64-bit.exe
Write-Host "Installing Git for Windows..."
.\Git-64-bit /verysilent
Start-Sleep -s 30
Remove-Item 'Git-64-bit.exe' -Force

#Install latest build of Buildkite agent - https://github.com/buildkite/agent/releases
Write-Host "Downloading Buildkite agent..."
$bkRepo = "buildkite/agent"
$bkInstdir = 'C:\Program Files\Buildkite'
$bkLatest = (Invoke-WebRequest "https://api.github.com/repos/$bkRepo/releases/latest" | ConvertFrom-Json)
$bkExe = $bkLatest.assets.name | Select-String -Pattern "windows-amd64"
Invoke-WebRequest "https://github.com/$bkRepo/releases/download/$($bkLatest.tag_name)/$bkExe" -OutFile buildkite-agent.zip
Write-Host "Installing Buildkite agent..."
Expand-Archive -Force -Path buildkite-agent.zip -DestinationPath $bkInstdir
$env:PATH = "${bkInstdir};" + $env:PATH
[Environment]::SetEnvironmentVariable('PATH', $env:PATH, [EnvironmentVariableTarget]::Machine)
Remove-Item 'buildkite-agent.zip' -Force

#Install AWS CLI
Write-Host "Downloading AWS CLI..."
Invoke-WebRequest "https://s3.amazonaws.com/aws-cli/AWSCLI64.msi" -OutFile AWSCLI64.msi
Write-Host "Installing AWS CLI..."
.\AWSCLI64.msi /q
Start-Sleep -s 30
Remove-Item '.\AWSCLI64.msi' -Force

#Install Python
Write-Host "Downloading Python..."
Invoke-WebRequest "https://www.python.org/ftp/python/$pyVersion/python-$pyVersion-amd64.exe" -OutFile python-amd64.exe
Write-Host "Installing Python..."
.\python-amd64.exe /q InstallAllUsers=1 PrependPath=1
Start-Sleep -s 30
Remove-Item '.\python-amd64.exe' -Force
