@echo off

REM SPDX-License-Identifier: MIT
REM The content of this file has been developed in the context of the MOSIM research project.
REM Original author(s): Janis Sprenger, Bhuvaneshwaran Ilanthirayan, Klaus Fischer
REM This is a deploy script to auto-generate the framework, including launcher, mmus, services and adapters. 

REM set filepath="Core\Framework\EngineSupport\Unity\MMIUnity.sln"
REM for /F "delims=" %%i in (%filepath%) do set dirname="%%~dpi" 
REM for /F "delims=" %%i in (%filepath%) do set filename="%%~nxi"
REM for /F "delims=" %%i in (%filepath%) do set basename="%%~ni"

SET MOSIM_HOME=%~dp0
SET BUILDENV=%MOSIM_HOME%\build\Environment
SET LIBRARYPATH=%MOSIM_HOME%\build\Libraries

call :argparse %*

call :safeCall deploy_variables.bat "There has been an error when setting the deploy vaiables!"

call :DeployMethod randomService

if not exist %BUILDENV% (
  md %BUILDENV%
)

if "%DPL_CORE%"=="T" call :DeployCore
if "%DPL_MMU%"=="T" call :DeployMMUs
if "%DPL_UNITY%"=="T" call :DeployUnity
if "%DPL_SERVICE%"=="T" call :DeployServices


COPY Scripts\enableFirewall.exe .\build\
COPY Scripts\defaultSettings.json .\build\Environment\Launcher\settings.json

echo copying scripts done

echo Removing doublicated MMUs
pause
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

goto :eof

REM Method Section

:: argparse
:argparse
if [%1]==[] (
	SET DPL_CORE=T
	SET DPL_MMU=T
	SET DPL_UNITY=T
	SET DPL_SERVICE=T
) else (
	SET DPL_CORE=F
	SET DPL_MMU=F
	SET DPL_UNITY=F
	SET DPL_SERVICE=F
	:argparse_loop
	if not [%1]==[] (
		if "%1"=="-c" (
			SET DPL_CORE=T
		) else (
			if "%1"=="-m" (
				SET DPL_MMU=T
			) else (
				if "%1"=="-u" (
					SET DPL_UNITY=T
				) else (
					if "%1"=="-s" (
						SET DPL_SERVICE=T
					) else (
						ECHO Unkown parameter "%1"
					) 
				) 
			) 
		)
		SHIFT
		goto :argparse_loop
	)
)
exit /b 0


::DeployCore
:DeployCore
	call :MSBUILD "Core\Framework\LanguageSupport\cs\MMICSharp.sln" MMIAdapterCSharp\bin Adapters\CSharpAdapter
	call :MSBUILD "Core\Launcher\MMILauncher.sln" MMILauncher\bin Launcher
	call :MSBUILD "Core\CoSimulation\MMICoSimulation.sln" CoSimulationStandalone\bin Services\CoSimulationStandalone 
	
	if not exist %LIBRARYPATH% (
		md %LIBRARYPATH%
	)
	>>deploy.log (
		cmd /c xcopy /S/Y/Q .\Core\Framework\LanguageSupport\cs\MMICSharp\bin\Debug\MMICSharp.dll %LIBRARYPATH%
		cmd /c xcopy /S/Y/Q .\Core\Framework\LanguageSupport\cs\MMICSharp\bin\Debug\MMIStandard.dll %LIBRARYPATH%
		cmd /c xcopy /S/Y/Q .\Core\Framework\LanguageSupport\cs\MMICSharp\bin\Debug\MMICSharp.dll %LIBRARYPATH%
		cmd /c xcopy /S/Y/Q .\Core\CoSimulation\MMICoSimulation\bin\Debug\MMICoSimulation.dll %LIBRARYPATH%
	)
exit /b

:DeployMMUs
	call :DeployMethod Core\BasicMMus\CS-MMUs\CS MMUs build
exit /b

:DeployUnity
    cd .\Core
    call .\distribute_unity.bat
    cd %MOSIM_HOME%
    if %ERRORLEVEL% NEQ 0 call :halt %ERRORLEVEL%

	call :DeployMethod Core\Framework\EngineSupport\Unity Adapters\UnityAdapter MMIAdapterUnity\UnityProject\build
	
	REM Copy core artifacts to services:
    REM Copy MMIUnity artifacts to UnityPathPlanning
    cmd /c xcopy /S/Y/Q .\Core\Framework\EngineSupport\Unity\MMIUnity\build\* .\Services\UnityPathPlanning\UnityPathPlanningService\Assets\Plugins
    if %ERRORLEVEL% NEQ 0 call :halt %ERRORLEVEL%

    REM Copy MMIUnityTarget engine to UnityDemo
    cmd /c xcopy /S/Y/Q .\Core\Framework\EngineSupport\Unity\MMIUnity.TargetEngine\MMIUnity.TargetEngine\build\* .\Demos\Unity\Assets\MMI\Plugins
    if %ERRORLEVEL% NEQ 0 call :halt %ERRORLEVEL%

	REM Copy core artifacts to Tools
	REM Copy MMIUnity to SkeletonTesting
	cmd /c xcopy /S/Y/Q .\Core\Framework\EngineSupport\Unity\MMIUnity\build .\Tools\SkeletonTesting\Assets\Plugins
    if %ERRORLEVEL% NEQ 0 call :halt %ERRORLEVEL%

exit /b

:DeployServices
    RD /S/Q Services\MMICSharp
    MD Services\MMICSharp
    cmd /c xcopy /S/Y/Q .\Core\Framework\LanguageSupport\cs\MMICSharp\build\* Services\MMICSharp
    if %ERRORLEVEL% NEQ 0 call :halt %ERRORLEVEL%
	
	call :DeployMethod Services\BlenderIK Services\BlenderIK build
	call :DeployMethod Services\CoordinateSystemMapper Services\CoordinateSystemMapper build
	call :DeployMethod Services\PostureBlendingService Services\PostureBlendingService build
	call :DeployMethod Services\RetargetingService Services\RetargetingService build
	call :DeployMethod Services\UnityPathPlanning Services\UnityPathPlanning UnityPathPlanningService\build
	call :DeployMethod Services\SkeletonAccessService Services\SkeletonAccessService build
exit /b


::DeployMethod 
::  %1 path to component
::  %2 target path
::  %3 build path in component
:DeployMethod 
  REM Build Adapters
  if exist %1 (
	  cd %1
	  call :safeCall .\deploy.bat "There has been an error when deploying %1"
	  cd %MOSIM_HOME%
	  if not [%2]==[] (
		  md ".\%BUILDENV%\%2"
		  cmd /c xcopy /S/Y/Q ".\%1\%3\*" ".\%BUILDENV%\%2"
		  if %ERRORLEVEL% NEQ 0 cd %MOSIM_HOME% && call :halt %ERRORLEVEL%
	  )
  ) else (
    ECHO -----------
	ECHO [31m Path %1 does not exist and thus will not be deployed.[0m
	ECHO -----------
  )
exit /b

::MSBUILD
:MSBUILD
  for /F "delims=" %%i in (%1) do set dirname="%%~dpi"
  for /F "delims=" %%i in (%1) do set filename="%%~nxi"
  
  set mode=Debug
  SETLOCAL EnableDelayedExpansion 
 
  if exist %dirname% (
	cd %dirname%
		
	>deploy.log (
		"%MSBUILD%" %filename% -t:Build -p:Configuration=%mode% -flp:logfile=build.log
	)
	REM If the build was sucessfull, copy all files to the respective build folders. 

	if !ERRORLEVEL! EQU 0 (
			:msbuild_loop
			if not [%2]==[] (
				>>deploy.log (
					cmd /c xcopy /S/Y/Q ".\%2\%mode%\*" "%BUILDENV%\%3"
				)
			)
			if not [%4]==[] (
				>>deploy.log (
					cmd /c xcopy /S/Y/Q ".\%4\%mode%\*" "%BUILDENV%\%5"
				)
			)
			if not [%6]==[] (
				>>deploy.log (
					cmd /c xcopy /S/Y/Q ".\%6\%mode%\*" "%BUILDENV%\%7"
				)
			)
			
		ECHO [92mSuccessfully deployed %filename%. [0m
	) else (
		type deploy.log 
		ECHO [31mDeployment of %filename% failed. Please consider the build.log for more information.[0m 
		cd %MOSIM_HOME%
		call :halt %ERRORLEVEL%
	)
  ) else (
    ECHO -----------
	ECHO [31m Path %1 does not exist and thus will not be deployed.[0m
	ECHO -----------
  )
cd %MOSIM_HOME%
exit /b

:: Calls a method %1 and checks the error level. If %1 failed, text %2 will be reported. 
:safeCall
call %1
if %ERRORLEVEL% NEQ 0 (
  ECHO [31m %~2 [0m
  cd %MOSIM_HOME%
  call :halt %ERRORLEVEL%
) else (
	exit /b
)

:: Sets the errorlevel and stops the batch immediately
:halt
call :__SetErrorLevel %1
call :__ErrorExit 2> nul
goto :eof

:__ErrorExit
rem Creates a syntax error, stops immediately
() 
goto :eof

:__SetErrorLevel
exit /b %time:~-2%
goto :eof

REM ErrorExit should not be called, just goto'ed. It assumes, that the ERRORLEVEL variable was set before to the appropriate value. 
REM exit /b %ERRORLEVEL%
REM Nothing should folow after this. 