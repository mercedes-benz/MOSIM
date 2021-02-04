@echo off

REM SPDX-License-Identifier: MIT
REM The content of this file has been developed in the context of the MOSIM research project.
REM Original author(s): Janis Sprenger, Bhuvaneshwaran Ilanthirayan
REM This is a deploy script to auto-generate the framework, including launcher, mmus, services and adapters. 

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

if not defined UNITY2018_4_1 (
  ECHO [31mUNITY2018_4_1 Environment variable pointing to the Unity.exe for Unity version 2018.4.1f1 is missing.[0m
  ECHO    e.g. SET "UNITY2018_4_1=C:\Program Files\Unity Environments\2018.4.1f1\Editor\Unity.exe\"
  pause
  exit /b 1
) else (
  ECHO UNITY2018_4_1 defined as: "%UNITY2018_4_1%"
)

if not defined UNITY2019_18_1 (
  ECHO [31mUNITY2019_18_1 Environment variable pointing to the Unity.exe for Unity version 2019.18.1f1 is missing.[0m
  ECHO    e.g. SET "UNITY2019_18_1=C:\Program Files\Unity Environments\2018.4.1f1\Editor\Unity.exe\"
  ECHO UNITY2019_18_1 defined as: "%UNITY2019_18_1%"
  pause
  exit /b 1
) else (
  ECHO UNITY2019_18_1 defined as: "%UNITY2019_18_1%"
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
  cd .\Core
  call .\distribute_unity.bat
  cd %WORKDIR%
  
  REM Build Adapters
  cd Core\Framework\LanguageSupport\cs
  call .\deploy.bat

  cd %WORKDIR%
  md build\Environment\Adapters\CSharpAdapter
  cmd /c xcopy /S/Y/Q .\Core\Framework\LanguageSupport\cs\MMIAdapterCSharp\build\* build\Environment\Adapters\CSharpAdapter

  REM Build Unity Engine Support:
  cd Core\Framework\EngineSupport\Unity
  call .\deploy.bat
  
  cd %WORKDIR%
  REM Todo: extend deploy to compile and pack unity adapter and copy it to the framework
  md build\Environment\Adapters\UnityAdapter
  cmd /c xcopy /S/Y/Q .\Core\Framework\EngineSupport\Unity\MMIAdapterUnity\UnityProject\build\* build\Environment\Adapters\UnityAdapter

  REM Build Launcher
  cd Core\Launcher\
  call .\deploy.bat

  cd %WORKDIR%
  cmd /c xcopy /S/Y/Q .\Core\Launcher\build\* build\Environment\Launcher
  
  REM Additional requirement for CoSimulator compilation? 
  

REM Build MMUs
  cd Core\BasicMMus\CS-MMUs\CS
  call .\deploy.bat

  cd %WORKDIR%
  cmd /c xcopy /S/Y/Q .\Core\BasicMMus\CS-MMUs\CS\build\* build\Environment\MMUs\


REM Copy core artifacts to services:
RD /S/Q Services\MMICSharp
MD Services\MMICSharp
cmd /c xcopy /S/Y/Q .\Core\Framework\LanguageSupport\cs\MMICSharp\build\* Services\MMICSharp

REM Copy MMIUnity artifacts to UnityPathPlanning
cmd /c xcopy /S/Y/Q .\Core\Framework\EngineSupport\Unity\MMIUnity\build .\Services\UnityPathPlanning\UnityPathPlanningService\Assets\Plugins

REM Copy MMIUnityTarget engine to UnityDemo
cmd /c xcopy /S/Y/Q .\Core\Framework\EngineSupport\Unity\MMIUnity.TargetEngine\MMIUnity.TargetEngine\build .\Demos\Assets\MMI\Plugins

REM Build Services

  REM Deploy Blender IK Service
  cd .\Services\BlenderIK
  call .\deploy.bat
  
  cd %WORKDIR%
  md .\build\Environment\Services\BlenderIK
  cmd /c xcopy /S/Y/Q .\Services\BlenderIK\build\* .\build\Environment\Services\BlenderIK
  
  REM deploy CoordinateSystemMapper
  cd .\Services\CoordinateSystemMapper
  call .\deploy.bat
  
  cd %WORKDIR%
  md .\build\Environment\Services\CoordinateSystemMapper
  cmd /c xcopy /S/Y/Q .\Services\CoordinateSystemMapper\build\* .\build\Environment\Services\CoordinateSystemMapper
  
  REM deploy PostureBlendingService
  cd .\Services\PostureBlendingService
  call .\deploy.bat
  
  cd %WORKDIR%
  md .\build\Environment\Services\PostureBlendingService
  cmd /c xcopy /S/Y/Q .\Services\PostureBlendingService\build\* .\build\Environment\Services\PostureBlendingService
  
  REM deploy RetargetingService
  cd .\Services\RetargetingService
  call .\deploy.bat
  
  cd %WORKDIR%
  md .\build\Environment\Services\RetargetingService
  cmd /c xcopy /S/Y/Q .\Services\RetargetingService\build\* .\build\Environment\Services\RetargetingService
  
  REM Todo: write deployment script for unityPathPlanning
  cd .\Services\UnityPathPlanning
  call .\deploy.bat
  
  cd %WORKDIR%
  md .\build\Environment\Services\UnityPathPlanning
  cmd /c xcopy /S/Y/Q .\Services\UnityPathPlanning\UnityPathPlanningService\build\* .\build\Environment\Services\UnityPathPlanning

COPY Scripts\enableFirewall.exe .\build\
COPY Scripts\defaultSettings.json .\build\Environment\Launcher\settings.json

REM the link currently does not yet work. 
REM RD build\
REM 
REM call ..\Scripts\link.vbs StartFramework.lnk Environment\Launcher\MMILauncher.exe
REM CD ..\

ECHO [92mSuccessfully deployed the Framework to the build folder. After copying to the target, consider running the "enableFirewall" script to setup firewall access rights for all executables in the framework. [0m

pause