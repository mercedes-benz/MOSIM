@echo off

REM SPDX-License-Identifier: MIT
REM The content of this file has been developed in the context of the MOSIM research project.
REM Original author(s): Janis Sprenger

call deploy_variables.bat

REM Checking environment variables
if not defined DEVENV (
  ECHO [31mDEVENV Environment variable pointing to the Visual Studio 2017 devenv.exe is missing.[0m
  ECHO    e.g. "C:\Program Files (x86)\Microsoft Visual Studio\2017\Professional\Common7\IDE\devenv.com"
  pause
  exit /b 1
) else (
  ECHO DEVENV defined as: "%DEVENV%"
)


SET WORKDIR=%~dp0

REM Core 

  REM Build Adapters
  cd Core\Framework\LanguageSupport\cs
  call .\deploy.bat
  cd %WORKDIR%

  REM Build Unity Engine Support:
  cd Core\Framework\EngineSupport\Unity
  call .\deploy.bat
  cd %WORKDIR%

cmd /c xcopy /S/Y/Q .\Core\Framework\LanguageSupport\cs\MMICSharp\build\* Services\MMICSharp

REM Copy MMIUnity artifacts to UnityPathPlanning
cmd /c xcopy /S/Y/Q .\Core\Framework\EngineSupport\Unity\MMIUnity\build .\Services\UnityPathPlanning\UnityPathPlanningService\Assets\Plugins

REM Copy MMIUnityTarget engine to UnityDemo
cmd /c xcopy /S/Y/Q .\Core\Framework\EngineSupport\Unity\MMIUnity.TargetEngine\MMIUnity.TargetEngine\build .\Demos\Assets\MMI\Plugins


