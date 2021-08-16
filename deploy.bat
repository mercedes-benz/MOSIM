@echo off

REM SPDX-License-Identifier: MIT
REM The content of this file has been developed in the context of the MOSIM research project.
REM Original author(s): Janis Sprenger, Bhuvaneshwaran Ilanthirayan
REM This is a deploy script to auto-generate the framework, including launcher, mmus, services and adapters. 

call deploy_variables.bat

REM Distribute Unity dlls if the environment variable is set for mixed artefacts (e.g. MMUs). 
if defined UNITY2018_4_1 (
  if exist "%UNITY2018_4_1%" (
    cd Core
	call .\distribute_unity.bat
	cd ..
  )
)
if defined UNITY2019_18_1 (
  if exist "%UNITY2019_18_1%" (
    cd Core
	call .\distribute_unity.bat
	cd ..
  )
)


call .\deploy_vs.bat

call .\deploy_unity.bat

call .\remove_double_mmus.bat

REM the link currently does not yet work. 
REM RD build\
REM 
REM call ..\Scripts\link.vbs StartFramework.lnk Environment\Launcher\MMILauncher.exe
REM CD ..\

ECHO [92mSuccessfully deployed the Framework to the build folder. After copying to the target, consider running the "enableFirewall" script to setup firewall access rights for all executables in the framework. [0m

pause
