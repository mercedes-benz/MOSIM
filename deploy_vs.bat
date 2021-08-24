@echo off

REM SPDX-License-Identifier: MIT
REM The content of this file has been developed in the context of the MOSIM research project.
REM Original author(s): Janis Sprenger, Bhuvaneshwaran Ilanthirayan
REM This is a deploy script to auto-generate the framework, including launcher, mmus, services and adapters. 

REM Checking environment variables
ECHO.
ECHO _______________________________________________________
ECHO [33mdeploy_vs.bat[0m at %cd%\deploy_vs.bat Deploying all Visual Studio dependencies. 
ECHO _______________________________________________________
ECHO.

if not defined DEVENV (
  ECHO [31mDEVENV Environment variable pointing to the Visual Studio 2017 devenv.exe is missing.[0m
  ECHO    e.g. "C:\Program Files (x86)\Microsoft Visual Studio\2017\Professional\Common7\IDE\devenv.com"
  pause
  exit /b 1
) else (
  if not exist "%DEVENV%" (
    ECHO Visual Studio does not seem to be installed at "%DEVENV%" or path name in deploy_variables.bat is wrong.
    exit /b 2
  )

)

IF EXIST build (
  RD /S/Q build
)

REM Build folder structure
md build\Environment
md build\Environment\Adapters
md build\Environment\Services
md build\Environment\MMUs
md build\Environment\Launcher

SET WORKDIR=%~dp0

REM Core

  REM Build Adapters
  cd Core\Framework\LanguageSupport\cs
  call .\deploy_vs.bat
  
  if %ERRORLEVEL% NEQ 0 cd %WORKDIR% && exit /b %ERRORLEVEL%
  cd %WORKDIR%
  
  md build\Environment\Adapters\CSharpAdapter
  cmd /c xcopy /S/Y/Q .\Core\Framework\LanguageSupport\cs\MMIAdapterCSharp\build\* build\Environment\Adapters\CSharpAdapter
  if %ERRORLEVEL% NEQ 0 cd %WORKDIR% && exit /b %ERRORLEVEL%
  
  REM Build Launcher
  cd Core\Launcher\
  call .\deploy_vs.bat

  if %ERRORLEVEL% NEQ 0 cd %WORKDIR% && exit /b %ERRORLEVEL%
  cd %WORKDIR%  



  cmd /c xcopy /S/Y/Q .\Core\Launcher\build\* build\Environment\Launcher
  if %ERRORLEVEL% NEQ 0 exit /b %ERRORLEVEL%

  REM Additional requirement for CoSimulator compilation? 

REM Build MMUs
  cd Core\BasicMMus\CS-MMUs\CS
  call .\deploy_vs.bat
  if %ERRORLEVEL% NEQ 0 cd %WORKDIR% && exit /b %ERRORLEVEL%
  cd %WORKDIR%


  cmd /c xcopy /S/Y/Q .\Core\BasicMMus\CS-MMUs\CS\build\* build\Environment\MMUs\
  if %ERRORLEVEL% NEQ 0 exit /b %ERRORLEVEL%


REM Copy core artifacts to services:
    RD /S/Q Services\MMICSharp
    MD Services\MMICSharp
    cmd /c xcopy /S/Y/Q .\Core\Framework\LanguageSupport\cs\MMICSharp\build\* Services\MMICSharp
    if %ERRORLEVEL% NEQ 0 exit /b %ERRORLEVEL%

REM Build Services

    REM Deploy Blender IK Service
    cd .\Services\BlenderIK
    call .\deploy.bat
  if %ERRORLEVEL% NEQ 0 cd %WORKDIR% && exit /b %ERRORLEVEL%
  cd %WORKDIR%

    md .\build\Environment\Services\BlenderIK
    cmd /c xcopy /S/Y/Q .\Services\BlenderIK\build\* .\build\Environment\Services\BlenderIK
    if %ERRORLEVEL% NEQ 0 exit /b %ERRORLEVEL%
	
    REM deploy CoordinateSystemMapper
    cd .\Services\CoordinateSystemMapper
    call .\deploy_vs.bat
  if %ERRORLEVEL% NEQ 0 cd %WORKDIR% && exit /b %ERRORLEVEL%
  cd %WORKDIR%

    md .\build\Environment\Services\CoordinateSystemMapper
    cmd /c xcopy /S/Y/Q .\Services\CoordinateSystemMapper\build\* .\build\Environment\Services\CoordinateSystemMapper
    if %ERRORLEVEL% NEQ 0 exit /b %ERRORLEVEL%

    
    REM deploy PostureBlendingService
    cd .\Services\PostureBlendingService
    call .\deploy_vs.bat
  if %ERRORLEVEL% NEQ 0 cd %WORKDIR% && exit /b %ERRORLEVEL%
  cd %WORKDIR%
	
    md .\build\Environment\Services\PostureBlendingService
    cmd /c xcopy /S/Y/Q .\Services\PostureBlendingService\build\* .\build\Environment\Services\PostureBlendingService
    if %ERRORLEVEL% NEQ 0 exit /b %ERRORLEVEL%
    
    REM deploy RetargetingService
    cd .\Services\RetargetingService
    call .\deploy_vs.bat
  if %ERRORLEVEL% NEQ 0 cd %WORKDIR% && exit /b %ERRORLEVEL%
  cd %WORKDIR%
    
    md .\build\Environment\Services\RetargetingService
    cmd /c xcopy /S/Y/Q .\Services\RetargetingService\build\* .\build\Environment\Services\RetargetingService
    if %ERRORLEVEL% NEQ 0 exit /b %ERRORLEVEL%

COPY Scripts\enableFirewall.exe .\build\
COPY Scripts\defaultSettings.json .\build\Environment\Launcher\settings.json

ECHO [92mSuccessfully deployed Visual studio dependencies of the Framework. [0m
exit /b 0
REM pause