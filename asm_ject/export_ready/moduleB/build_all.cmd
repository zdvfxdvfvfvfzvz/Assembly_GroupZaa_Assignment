@echo off
@rem builds the whole DES shell: modules A + B + C + D
setlocal
set "DIR=%~dp0"

set "VSWHERE=%ProgramFiles(x86)%\Microsoft Visual Studio\Installer\vswhere.exe"
for /f "usebackq tokens=*" %%i in (`"%VSWHERE%" -latest -products * -requires Microsoft.VisualStudio.Component.VC.Tools.x86.x64 -property installationPath`) do set "VSDIR=%%i"
if not defined VSDIR (
  echo [build] Cannot find Visual Studio C++ tools.
  exit /b 1
)
call "%VSDIR%\VC\Auxiliary\Build\vcvars32.bat" >nul

pushd "%DIR%"

ml /nologo /c /coff /Zi /I C:\Irvine /I . Test_ModuleA.asm
if errorlevel 1 goto :err
ml /nologo /c /coff /Zi /I C:\Irvine /I . moduleB5.asm
if errorlevel 1 goto :err
ml /nologo /c /coff /Zi /I C:\Irvine /I . ModuleC.asm
if errorlevel 1 goto :err
ml /nologo /c /coff /Zi /I C:\Irvine /I . moduleD.asm
if errorlevel 1 goto :err

link /nologo /SUBSYSTEM:CONSOLE /DEBUG Test_ModuleA.obj moduleB5.obj ModuleC.obj moduleD.obj C:\Irvine\Irvine32.lib C:\Irvine\Kernel32.lib C:\Irvine\User32.lib /LIBPATH:C:\Irvine
if errorlevel 1 goto :err
ren Test_ModuleA.exe DES_Shell.exe
echo [build] OK -^> DES_Shell.exe
popd
exit /b 0

:err
echo [build] FAILED
popd
exit /b 1
