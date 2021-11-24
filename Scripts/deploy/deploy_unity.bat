@echo off

  if not defined MOSIM_HOME (
	ECHO [31mMOSIM_HOME Environment variable is not set.[0m
	ECHO [31mPlease check deploy_variables.bat script, modify it accordingly and run it.[0m
	pause
	exit /b 1
  )

REM SPDX-License-Identifier: MIT
REM The content of this file has been developed in the context of the MOSIM research project.
REM Original author(s): Janis Sprenger, Bhuvaneshwaran Ilanthirayan
REM This is a deploy script to auto-generate the framework, including launcher, mmus, services and adapters. 

REM Checking environment variables

ECHO.
ECHO _______________________________________________________
ECHO [33mdeploy_unity.bat[0m at %cd%\deploy_unity.bat Deploying all Unity dependencies. 
ECHO _______________________________________________________
ECHO.


if not defined UNITY2018_4_1 (
  ECHO [31mUNITY2018_4_1 Environment variable pointing to the Unity.exe for Unity version 2018.4.1f1 is missing.[0m
  ECHO    e.g. SET "UNITY2018_4_1=C:\Program Files\Unity Environments\2018.4.1f1\Editor\Unity.exe\"
  pause
  exit /b 1
) else (
  if not exist "%UNITY2018_4_1%" (
    ECHO Unity does not seem to be installed at "%UNITY2018_4_1%" or path name in deploy_variables.bat is wrong.
    exit /b 2
  )

)

if not defined UNITY2019_18_1 (
  ECHO [31mUNITY2019_18_1 Environment variable pointing to the Unity.exe for Unity version 2019.18.1f1 is missing.[0m
  ECHO    e.g. SET "UNITY2019_18_1=C:\Program Files\Unity Environments\2018.4.1f1\Editor\Unity.exe\"
  pause
  exit /b 1
) else (
  if not exist "%UNITY2019_18_1%" (
    ECHO Unity does not seem to be installed at "%UNITY2019_18_1%" or path name in deploy_variables.bat is wrong.
    exit /b 2
  )

)

REM Core
    cd .\Core
    call .\distribute_unity.bat
    cd %MOSIM_HOME%
    if %ERRORLEVEL% NEQ 0 exit /b %ERRORLEVEL%


    REM Build Unity Engine Support:
    cd Core\Framework\EngineSupport\Unity
    call .\deploy_unity.bat
    cd %MOSIM_HOME%
    if %ERRORLEVEL% NEQ 0 exit /b %ERRORLEVEL%
	
    REM Todo: extend deploy to compile and pack unity adapter and copy it to the framework
    md build\Environment\Adapters\UnityAdapter
    cmd /c xcopy /S/Y/Q .\Core\Framework\EngineSupport\Unity\MMIAdapterUnity\UnityProject\build\* build\Environment\Adapters\UnityAdapter
    if %ERRORLEVEL% NEQ 0 exit /b %ERRORLEVEL%

REM Copy core artifacts to services:

    REM Copy MMIUnity artifacts to UnityPathPlanning
    cmd /c xcopy /S/Y/Q .\Core\Framework\EngineSupport\Unity\MMIUnity\build\* .\Services\UnityPathPlanning\UnityPathPlanningService\Assets\Plugins
    if %ERRORLEVEL% NEQ 0 exit /b %ERRORLEVEL%

    REM Copy MMIUnityTarget engine to UnityDemo
    cmd /c xcopy /S/Y/Q .\Core\Framework\EngineSupport\Unity\MMIUnity.TargetEngine\MMIUnity.TargetEngine\build\* .\Demos\Unity\Assets\MMI\Plugins
    if %ERRORLEVEL% NEQ 0 exit /b %ERRORLEVEL%

REM Copy core artifacts to Tools
	
	REM Copy MMIUnity to SkeletonTesting
	cmd /c xcopy /S/Y/Q .\Core\Framework\EngineSupport\Unity\MMIUnity\build .\Tools\SkeletonTesting\Assets\Plugins
    if %ERRORLEVEL% NEQ 0 exit /b %ERRORLEVEL%

ECHO [92mSuccessfully deployed Unity Dependencies of the Framework to the build folder. [0m

REM pause

exit /b 0