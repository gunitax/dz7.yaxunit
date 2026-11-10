
#requires -Version 3
param(
    [Parameter(Mandatory = $true)][string]$Extension,
    [ValidateRange(1, 3)][int]$Step = 1,
    [string]$Base = 'D:\infobase\vebinar7.yaxunit',
    [string]$Src = 'D:\AI.V7\1c\extensions',
    [string]$V8Path = 'C:\Program Files\1cv8\8.5.1.1529\bin\1cv8.exe',
    [string]$User = 'Администратор',
    [string]$Password = ''
)

# Загрузка/обновление расширения из файловой выгрузки в тестовую копию базы.
# Кириллица передаётся массивом аргументов через Start-Process, не через cmd.
$extDir = Join-Path $Src $Extension
$log = Join-Path $env:TEMP ("load-ext-" + $Extension + ".log")
if (Test-Path -LiteralPath $log) { Remove-Item -LiteralPath $log -Force }

$arg = @('DESIGNER', '/F', $Base, "/N$User")
if ($Password) { $arg += "/P$Password" }

switch ($Step) {
    1 { $arg += @('/LoadConfigFromFiles', $extDir, '-Extension', $Extension) }
    2 { $arg += @('/UpdateDBCfg', '-Extension', $Extension) }
    3 { $arg += @('/DumpCfg', (Join-Path $env:TEMP ($Extension + '.probe.cfe')), '-Extension', $Extension) }
}
$arg += @('/Out', $log, '/DisableStartupDialogs')

$p = Start-Process -FilePath $V8Path -ArgumentList $arg -Wait -PassThru
Write-Output ("EXIT=" + $p.ExitCode)
if (Test-Path -LiteralPath $log) {
    $lines = Get-Content -LiteralPath $log -Encoding UTF8
    if ($lines) { $lines } else { Write-Output '(log empty)' }
} else {
    Write-Output '(log missing)'
}
