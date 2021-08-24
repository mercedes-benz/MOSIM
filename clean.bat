@echo off

REM SPDX-License-Identifier: MIT
REM The content of this file has been developed in the context of the MOSIM research project.
REM Original author(s): Janis Sprenger, Bhuvaneshwaran Ilanthirayan

call deploy_variables.bat

REM Checking environment variables
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

@REM Clean folder structure
IF EXIST build (
  RD /S/Q build
)

SET WORKDIR=%~dp0
@REM Core

  @REM Clean Unity Engine Support
  cd Core\Framework\EngineSupport\Unity
  call .\clean.bat
  if %ERRORLEVEL% NEQ 0 (
    ECHO [31mThere has been an error during cleanup! [0m
    cd %WORKDIR%
    exit /b %ERRORLEVEL%
  )

  cd %WORKDIR%
  
  @REM Clean Adapters
  cd Core\Framework\LanguageSupport\cs
  call .\clean.bat
  if %ERRORLEVEL% NEQ 0 (
    ECHO [31mThere has been an error during cleanup! [0m
    cd %WORKDIR%
    exit /b %ERRORLEVEL%
  )
  
  cd %WORKDIR%
  
  @REM Clean Launcher
  cd Core\Launcher
  call .\clean.bat
  if %ERRORLEVEL% NEQ 0 (
    ECHO [31mThere has been an error during cleanup! [0m
    cd %WORKDIR%
    exit /b %ERRORLEVEL%
  )
  
  cd %WORKDIR%
  
  @REM Clean MMUs
  cd Core\BasicMMus\CS-MMUs\CS
  call  .\clean.bat
  if %ERRORLEVEL% NEQ 0 (
    ECHO [31mThere has been an error during cleanup! [0m
    cd %WORKDIR%
    exit /b %ERRORLEVEL%
  )

  cd %WORKDIR%

@REM Remove core artifacts from services
if EXIST Services\MMICSharp (
  RD /S/Q Services\MMICSharp
)

@REM Clean Services
  @REM Clean BlenderIK Service
  cd .\Services\BlenderIK
  call clean.bat
  if %ERRORLEVEL% NEQ 0 (
    ECHO [31mThere has been an error during cleanup! [0m
    cd %WORKDIR%
    exit /b %ERRORLEVEL%
  )
  
  cd %WORKDIR%

  @REM Clean CoordinateSystemMapper
  cd .\Services\CoordinateSystemMapper
  call .\clean.bat
  if %ERRORLEVEL% NEQ 0 (
    ECHO [31mThere has been an error during cleanup! [0m
    cd %WORKDIR%
    exit /b %ERRORLEVEL%
  )
  
  cd %WORKDIR%

  @REM Clean PostureBlendingService
  cd .\Services\PostureBlendingService
  call .\clean.bat
  if %ERRORLEVEL% NEQ 0 (
    ECHO [31mThere has been an error during cleanup! [0m
    cd %WORKDIR%
    exit /b %ERRORLEVEL%
  )
  
  cd %WORKDIR%

  @REM Clean RetargetingService
  cd .\Services\RetargetingService
  call .\clean.bat
  if %ERRORLEVEL% NEQ 0 (
    ECHO [31mThere has been an error during cleanup! [0m
    cd %WORKDIR%
    exit /b %ERRORLEVEL%
  )
  
  cd %WORKDIR%

  @REM Clean unityPathPlanning
  cd .\Services\UnityPathPlanning
  call .\clean.bat
  if %ERRORLEVEL% NEQ 0 (
    ECHO [31mThere has been an error during cleanup! [0m
    cd %WORKDIR%
    exit /b %ERRORLEVEL%
  )
  
  cd %WORKDIR%
  cd .\Core
  call .\remove_unity.bat
  if %ERRORLEVEL% NEQ 0 (
    ECHO [31mThere has been an error during cleanup! [0m
    cd %WORKDIR%
    exit /b %ERRORLEVEL%
  )
  
  cd %WORKDIR%


ECHO [92mSuccessfully cleaned the Framework to the initiate the deployment process. Run deploy.bat script to start deployment process [0m

pause
