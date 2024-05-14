if ((gi .).ToString() -eq $Global:secondPath) {
    Set-Location $Global:origPath
    . ./reset.ps1
    return
}

function WInput {
    param( $msg )
    Write-Host $msg -ForegroundColor Red -NoNewLine
    Read-Host
}
function WInfo {
    param( $msg )
    Write-Host $msg -ForegroundColor Red -NoNewLine
    $e = Read-Host
}
function WAsk {
    param( $msg, [Switch] $NoDefault )
    Write-Host $msg -ForegroundColor Red -NoNewLine
    Write-Host " (" -NoNewLine
    if ($NoDefault) {
        Write-Host "j/N" -ForeGroundColor Yellow -NoNewLine
    }
    else {
        Write-Host "J/n" -ForeGroundColor Yellow -NoNewLine
    }
    Write-Host ") :" -NoNewLine
    $e = Read-Host
    if ($NoDefault) {
        return !($e -ne "J")
    }
    else {
        return ($e -ne "N")
    }
}

Remove-Item * -Exclude reset.ps1 -Recurse -Force
Remove-Item .git -Recurse -Force

Set-Content file1.js "console.log(`"Teil 1 des Projektes`");

for(let i = 0; i < 10; i++){
    console.log(i);
}"

Set-Content file2.js "console.log(`"Teil 2 des Projektes`");

for(let i = 10; i < 20; i++){
    console.log(i);
}"

git init
git add .
git commit -m "Initial-A"
git config pull.rebase false

while($true) {
    $url = WInput "Inital Commit erstellt - GitHub Repo erstellen und URL eingeben.`nURL: "
    if ($url -eq "https://github.com/bugfrei/pullrebase.git") {
        Write-Host "Ungültige URL - Bitte ein neues Repository auf Github erstellen und dessen URL hier eingeben!" -ForegroundColor Red
    }
    else {
        break
    }
}


$kon = WAsk "Änderungen mit Konflikt erstellen? "

$origPath = (Get-Item .)
$name = $origPath.Name
$secondPath = (Join-Path $origPath.Parent "$($name)_2")

if (Test-Path $secondPath) {
    Remove-Item $secondPath -Recurse -Force
}

New-Item -ItemType Directory -Path $secondPath | Out-Null
Set-Location $secondPath
git clone $url .

if ($kon) {
    "// Konflikt-Änderung von geklontem Repo" >> file1.js
}
else {
    "// Änderung" >> file2.js
}
git add .
git commit -m "Second change"
git push $url

Set-Location $origPath
"// Änderung von Original Repo" >> file1.js

git add .
git commit -m "First change"

Write-Host "================================================================================"
Write-Host "Git Log des geklonten Repos (z.B. Kollege John)"
Set-Location $secondPath
git log --graph --abbrev-commit --decorate --format=format:'%C(bold blue)%h%C(reset) - %C(bold green)(%ar)%C(reset) %C(white)%s%C(reset) %C(dim white)- %an%C(reset)%C(auto)%d%C(reset)'
Write-Host "Diese änderungen wurden auf Github gepushed!" -ForegroundColor Red
Write-Host "--------------------------------------------------------------------------------"
Set-Location $origPath
Write-Host "Git Log des original Repos (Du)"
git log --graph --abbrev-commit --decorate --format=format:'%C(bold blue)%h%C(reset) - %C(bold green)(%ar)%C(reset) %C(white)%s%C(reset) %C(dim white)- %an%C(reset)%C(auto)%d%C(reset)'

Write-Host "--------------------------------------------------------------------------------"

Write-Host "Änderungen sind erstellt - push führt zu Fehler! pull --rebase bzw. pull ausführen"

$Global:secondPath = $secondPath.ToString()
$Global:origPath = $origPath.ToString()
Write-Host "repo2 eingeben um in den Ordners der geklonten Repos zu wechseln"
Write-Host "repo1 eingeben um wieder in den Ordner des Original repos zu wechseln"

function repo1 { Set-Location $Global:origPath }
function repo2 { Set-Location $Global:secondPath }

