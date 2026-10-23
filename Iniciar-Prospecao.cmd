@echo off
cd /d "%~dp0"
docker info >nul 2>&1
if errorlevel 1 (
  start "" "C:\Program Files\Docker\Docker\Docker Desktop.exe"
  echo Aguardando o Docker Desktop iniciar...
  powershell.exe -NoProfile -Command "$ready=$false; for($i=0;$i -lt 90;$i++){ docker info *> $null; if($LASTEXITCODE -eq 0){$ready=$true;break}; Start-Sleep -Seconds 2 }; if(-not $ready){exit 1}"
  if errorlevel 1 (
    echo Nao foi possivel iniciar o Docker. Confira o Docker Desktop.
    pause
    exit /b 1
  )
)
docker compose up -d
if errorlevel 1 (
  pause
  exit /b 1
)
curl.exe --max-time 3 -fsS http://127.0.0.1:8090/api/inicio >nul 2>&1
if errorlevel 1 (
  set PYTHONIOENCODING=utf-8
  python painel\server.py
) else (
  start "" http://localhost:8090
)
