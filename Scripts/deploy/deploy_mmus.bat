@echo off

  if not defined MOSIM_HOME (
	ECHO [31mMOSIM_HOME Environment variable is not set.[0m
	ECHO [31mPlease run deploy_variables.bat in MOSIMS root folder.[0m
	pause
	exit /b 1
  )

REM Build MMUs

  cd Core\BasicMMus\CS-MMUs\CS
  call .\deploy_vs.bat
  if %ERRORLEVEL% NEQ 0 cd %MOSIM_HOME% && exit /b %ERRORLEVEL%
  cd %MOSIM_HOME%


  cmd /c xcopy /S/Y/Q .\Core\BasicMMus\CS-MMUs\CS\build\* build\Environment\MMUs\
  if %ERRORLEVEL% NEQ 0 exit /b %ERRORLEVEL%
