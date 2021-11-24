@echo off

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

if not defined MSBUILD (
  ECHO [31mMSBUILD Environment variable pointing to the Visual Studio 2017 MSBuild.exe is missing.[0m
  ECHO    e.g. "C:\Program Files (x86)\Microsoft Visual Studio\2019\Professional\MSBuild\Current\Bin\MSBuild.exe"
  pause
  exit /b 1
) else (
  if not exist "%MSBUILD%" (
    ECHO    MSBUILD: [31mMISSING[0m at "%MSBUILD%"
    ECHO [31mPlease update the deploy_variables.bat script with a valid path![0m
	exit /b 2
    )
  )
)

if not defined MOSIM_HOME (
  ECHO [31mMOSIM_HOME Environment variable is not set.[0m
  ECHO [31mPlease check deploy_variables.bat script, modify it accordingly and run it.[0m
  pause
  exit /b 1
) else (
  if not exist "%MOSIM_HOME%" (
    ECHO "%MOSIM_HOME%" not correctly set. Folder does not exist.
    exit /b 2
  )
)

REM Distribute Unity dlls if the environment variable is set for mixed artefacts (e.g. MMUs). 
set unity=F

if defined UNITY2018_4_1 if exist "%UNITY2018_4_1%" set unity=T
if defined UNITY2019_18_1 if exist "%UNITY2019_18_1%" set unity=T

if "%unity%"=="T" (
  cd %MOSIM_HOME%\Core
  call .\distribute_unity.bat
  cd %MOSIM_HOME%
  if %ERRORLEVEL% NEQ 0 (
    ECHO [31mThere has been an error during deployment! [0m
    exit /b %ERRORLEVEL%
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

exit /b 0
