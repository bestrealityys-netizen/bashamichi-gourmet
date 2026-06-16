@echo off
REM ==========================================================
REM  馬車道グルメ - Netlify CLI 直接デプロイ（方式A / 手動トリガー）
REM  使い方: このファイルをダブルクリック、または
REM          コマンドプロンプトで  deploy.bat  を実行
REM  前提: PC に Node.js がインストール済み（https://nodejs.org）
REM ==========================================================
setlocal
cd /d "%~dp0"

set "SITE_ID=b12d2794-2e7b-4114-9ace-bf6b16b2719e"

if not exist ".netlify-token" (
  echo [ERROR] .netlify-token が見つかりません。Netlify個人トークンを保存してください。
  pause
  exit /b 1
)
set /p TOKEN=<.netlify-token

REM 公開用フォルダを用意（サイト本体 index.html のみ。data\ や *.py や token は除外）
if exist "_publish" rmdir /s /q "_publish"
mkdir "_publish"
copy /Y "index.html" "_publish\" >nul

echo === Netlify へデプロイ中 ===
call npx -y netlify-cli@latest deploy --prod --dir="_publish" --site="%SITE_ID%" --auth="%TOKEN%" --message "manual deploy"

echo.
echo Done: https://dulcet-florentine-92abf1.netlify.app
pause
endlocal
