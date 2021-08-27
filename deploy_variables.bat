@echo off

REM SPDX-License-Identifier: MIT
REM The content of this file has been developed in the context of the MOSIM research project.
REM Original author(s): Janis Sprenger, Bhuvaneshwaran Ilanthirayan

SET "DEVENV=C:\Program Files (x86)\Microsoft Visual Studio\2019\Professional\Common7\IDE\devenv.com"
SET "MSBUILD=C:\Program Files (x86)\Microsoft Visual Studio\2019\Professional\MSBuild\Current\Bin\MSBuild.exe"
REM SET "UNITY2018_4_1=C:\Program Files\Unity\Hub\Editor\2018.4.1f1\Editor\Unity.exe"
REM SET "UNITY2019_18_1=C:\Program Files\Unity\Hub\Editor\2019.4.18f1\Editor\Unity.exe"
SET "UNITY2018_4_1=C:\Program Files\Unity\Hub\Editor\2020.3.15f2\Editor\Unity.exe"
SET "UNITY2019_18_1=C:\Program Files\Unity\Hub\Editor\2020.3.15f2\Editor\Unity.exe"

ECHO The following environment variables are utilized:
if exist "%DEVENV%" (
 ECHO    DEVENV: [92mFound[0m at "%DEVENV%"
) else (
 ECHO    DEVENV: [31mMISSING[0m at "%DEVENV%"
 ECHO [31mPlease update the deploy_variables.bat script with a valid path![0m
 exit /b 2
)

if exist "%MSBUILD%" (
 ECHO    MSBUILD: [92mFound[0m at "%MSBUILD%"
) else (
 ECHO    MSBUILD: [31mMISSING[0m at "%MSBUILD%"
 ECHO [31mPlease update the deploy_variables.bat script with a valid path![0m
 exit /b 2
) 

if exist "%UNITY2018_4_1%" (
 ECHO    UNITY2018_4_1: [92mFound[0m at "%UNITY2018_4_1%"
) else (
 ECHO    UNITY2018_4_1: [31mMISSING[0m at "%UNITY2018_4_1%"
 ECHO [31mPlease update the deploy_variables.bat script with a valid path![0m
 exit /b 2
) 

if exist "%UNITY2019_18_1%" (
 ECHO    UNITY2019_18_1: [92mFound[0m at "%UNITY2019_18_1%"
) else (
 ECHO    UNITY2019_18_1: [31mMISSING[0m at "%UNITY2019_18_1%"
 ECHO [31mPlease update the deploy_variables.bat script with a valid path![0m
 exit /b 2
) 

exit /b 0