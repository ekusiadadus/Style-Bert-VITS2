chcp 65001 > NUL
@echo off

pushd %~dp0
set PS_CMD=PowerShell -Version 5.1 -ExecutionPolicy Bypass

set CURL_CMD=C:\Windows\System32\curl.exe
if not exist %CURL_CMD% (
	echo [ERROR] %CURL_CMD% が見つかりません。
	pause & popd & exit /b 1
)

@REM Style-Bert-VITS2.zip をGitHubのmasterの最新のものをダウンロード
%CURL_CMD% -Lo Style-Bert-VITS2.zip^
	https://github.com/litagin02/Style-Bert-VITS2/archive/refs/heads/master.zip
if %errorlevel% neq 0 ( pause & popd & exit /b %errorlevel% )

@REM Style-Bert-VITS2.zip を解凍（フォルダ名前がBert-VITS2-masterになる）
%PS_CMD% Expand-Archive -Path Style-Bert-VITS2.zip -DestinationPath . -Force
if %errorlevel% neq 0 ( pause & popd & exit /b %errorlevel% )

@REM 元のzipを削除
del Style-Bert-VITS2.zip
if %errorlevel% neq 0 ( pause & popd & exit /b %errorlevel% )

@REM Bert-VITS2-masterの中身をStyle-Bert-VITS2に上書き移動
xcopy /QSY .\Style-Bert-VITS2-master\ .\Style-Bert-VITS2\
rmdir /s /q Style-Bert-VITS2-master
if %errorlevel% neq 0 ( pause & popd & exit /b %errorlevel% )

@REM 仮想環境のpip requirements.txtを更新

echo call .\Style-Bert-VITS2\scripts\activate.bat
call .\Style-Bert-VITS2\venv\Scripts\activate.bat
if %errorlevel% neq 0 ( pause & popd & exit /b %errorlevel% )

pip install -U -r Style-Bert-VITS2\requirements.txt
if %errorlevel% neq 0 ( pause & popd & exit /b %errorlevel% )

pushd Style-Bert-VITS2

@REM 初期化（必要なモデルのダウンロード）
python initialize.py

echo Style-Bert-VITS2の2.0.1へのアップデートが完了しました。

pause

popd

popd