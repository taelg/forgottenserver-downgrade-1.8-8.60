@echo off
setlocal enabledelayedexpansion
REM ============================================================
REM  build_windows.cmd - Configure + build TFS (main) no Windows
REM  vcpkg toolchain + Ninja + MSVC 2022 BuildTools
REM ============================================================

set "ROOT=%~dp0"
set "CMAKE=C:\Program Files\CMake\bin\cmake.exe"
if not defined VCPKG_ROOT set "VCPKG_ROOT=C:\vcpkg"
set "VCPKG=!VCPKG_ROOT!\scripts\buildsystems\vcpkg.cmake"

REM Garante que o CMake roda dentro da pasta do projeto
cd /d "%ROOT%"

echo [INFO] ROOT:   %ROOT%
echo [INFO] CMake:  %CMAKE%
echo [INFO] vcpkg:  !VCPKG!
if not exist "!VCPKG!" goto :novcpkg

REM Carrega o ambiente MSVC 2022
call "C:\Program Files (x86)\Microsoft Visual Studio\2022\BuildTools\VC\Auxiliary\Build\vcvars64.bat" >nul 2>&1
if errorlevel 1 goto :nomsvc

echo.
echo [PASSO 1/2] Configurando com vcpkg toolchain (Ninja)...
"%CMAKE%" --preset vcpkg -DCMAKE_BUILD_TYPE=Release
if errorlevel 1 goto :erro

echo.
echo [PASSO 2/2] Compilando (vcpkg instala dependencias automaticamente)...
"%CMAKE%" --build --preset vcpkg
if errorlevel 1 goto :erro

echo.
echo [DONE] Build concluida.
echo Binario esperado: "%ROOT%build\Debug\tfs.exe"
if exist "%ROOT%build\Debug\tfs.exe" echo [OK] Arquivo encontrado.
goto :fim

:novcpkg
echo [ERRO] vcpkg toolchain nao encontrado: !VCPKG!
goto :fim

:nomsvc
echo [ERRO] Nao foi possivel carregar vcvars64.bat
goto :fim

:erro
echo [ERRO] A build falhou. Veja as mensagens acima.
goto :fim

:fim
endlocal
