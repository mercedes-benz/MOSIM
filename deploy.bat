REM @echo off

REM SPDX-License-Identifier: MIT
REM The content of this file has been developed in the context of the MOSIM research project.
REM Original author(s): Janis Sprenger, Bhuvaneshwaran Ilanthirayan
REM This is a deploy script to auto-generate the framework, including launcher, mmus, services and adapters. 

call deploy_variables.bat
if %ERRORLEVEL% NEQ 0 (
  ECHO [31mThere has been an error during deployment! [0m
  exit /b %ERRORLEVEL%
)

REM Distribute Unity dlls if the environment variable is set for mixed artefacts (e.g. MMUs). 
set unity=F

if defined UNITY2018_4_1 if exist "%UNITY2018_4_1%" set unity=T
if defined UNITY2019_18_1 if exist "%UNITY2019_18_1%" set unity=T

if "%unity%"=="T" (
  cd Core
  call .\distribute_unity.bat
  cd ..
  if %ERRORLEVEL% NEQ 0 (
    ECHO [31mThere has been an error during deployment! [0m
    exit /b %ERRORLEVEL%
  )
)

call .\deploy_vs.bat
if %ERRORLEVEL% NEQ 0 (
  ECHO [31mThere has been an error during deployment! [0m
  exit /b %ERRORLEVEL%
)

call .\deploy_unity.bat
if %ERRORLEVEL% NEQ 0 (
  ECHO [31mThere has been an error during deployment! [0m
  exit /b %ERRORLEVEL%
)

call .\remove_double_mmus.bat
if %ERRORLEVEL% NEQ 0 (
  ECHO [31mThere has been an error during deployment! [0m
  exit /b %ERRORLEVEL%
)

REM the link currently does not yet work. 
REM RD build\
REM 
REM call ..\Scripts\link.vbs StartFramework.lnk Environment\Launcher\MMILauncher.exe
REM CD ..\

ECHO  __  __  ___  ____ ___ __  __ 
ECHO ^|  \/  ^|/ _ \/ ___^|_ _^|  \/  ^|
ECHO ^| ^|\/^| ^| ^| ^| \___ \^| ^|^| ^|\/^| ^|
ECHO ^| ^|  ^| ^| ^|_^| ^|___) ^| ^|^| ^|  ^| ^|
ECHO ^|_^|  ^|_^|\___/^|____/___^|_^|  ^|_^|
ECHO.   

ECHO [92mSuccessfully deployed the Framework to %cd%/build/Environment.   [0m
ECHO If this is the first time, the framework was deployed, consider utilizing the script %cd%\build\enableFirewall.exe to setup all firewall exceptions. 
ECHO [92mTo start the framework[0m, start the launcher at %cd%\build\Environment\Launcher\MMILauncher.exe To use the framework, please open the Unity Demo-Scene at %cd%\Demos\Unity or any other MOSIM-enabled Project.

explorer.exe %cd%\build

pause