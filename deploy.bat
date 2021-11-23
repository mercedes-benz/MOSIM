@echo off

REM SPDX-License-Identifier: MIT
REM The content of this file has been developed in the context of the MOSIM research project.
REM Original author(s): Janis Sprenger, Bhuvaneshwaran Ilanthirayan
REM This is a deploy script to auto-generate the framework, including launcher, mmus, services and adapters. 

call deploy_variables.bat
if %ERRORLEVEL% NEQ 0 (
  ECHO [31mThere has been an error when setting the deploy vaiables! [0m
  exit /b %ERRORLEVEL%
)

call Scripts/deploy/init.bat

echo %ERRORLEVEL%

if %ERRORLEVEL% NEQ 0 (
  ECHO [31mThere has been an error during initialization! [0m
  exit /b %ERRORLEVEL%
)

echo deploying core started ...

call Scripts\deploy\deploy_core.bat

echo deploying core done

if %ERRORLEVEL% NEQ 0 (
  ECHO "[31mThere has been an error during deployment of Framework Core. [0m"
  exit /b %ERRORLEVEL%
)

echo deploying mmus started ...

call Scripts\deploy\deploy_mmus.bat

echo deploying mmus done

if %ERRORLEVEL% NEQ 0 (
  ECHO "[31mThere has been an error during deployment (mmus). [0m"
  exit /b %ERRORLEVEL%
)

echo deploying unity started ...

call Scripts\deploy\deploy_unity.bat

echo deploying unity done
echo deploying services started ...

call Scripts\deploy\deploy_services.bat

echo deploying services done
echo copying scripts started ...

COPY Scripts\enableFirewall.exe .\build\
COPY Scripts\defaultSettings.json .\build\Environment\Launcher\settings.json

echo copying scripts done

echo Removing doublicated MMUs

call .\remove_double_mmus.bat

echo Removing doublicated MMUs done.

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