@echo off

REM Core

  if not defined MOSIM_HOME (
	ECHO [31mMOSIM_HOME Environment variable is not set.[0m
	ECHO [31mPlease run deploy_variables.bat in MOSIMS root folder.[0m
	pause
	exit /b 1
  )

  REM Build Adapters
  cd Core\Framework\LanguageSupport\cs
  call .\deploy_vs.bat
  
  if %ERRORLEVEL% NEQ 0 cd %MOSIM_HOME% && exit /b %ERRORLEVEL%
  cd %MOSIM_HOME%
  
  md build\Environment\Adapters\CSharpAdapter
  cmd /c xcopy /S/Y/Q .\Core\Framework\LanguageSupport\cs\MMIAdapterCSharp\build\* build\Environment\Adapters\CSharpAdapter
  if %ERRORLEVEL% NEQ 0 cd %MOSIM_HOME% && exit /b %ERRORLEVEL%
  
  REM Build Launcher
  cd Core\Launcher\
  call .\deploy_vs.bat

  if %ERRORLEVEL% NEQ 0 cd %MOSIM_HOME% && exit /b %ERRORLEVEL%
  cd %MOSIM_HOME%

  cmd /c xcopy /S/Y/Q .\Core\Launcher\build\* build\Environment\Launcher
  if %ERRORLEVEL% NEQ 0 exit /b %ERRORLEVEL%

  REM Additional requirement for CoSimulator compilation?
  
  cd .\Core\CoSimulation\
  call .\deploy.bat
  if %ERRORLEVEL% NEQ 0 cd %MOSIM_HOME% && exit /b %ERRORLEVEL%
  cd %MOSIM_HOME%
  md .\build\Environment\Services\CoSimulationStandalone
  cmd /c xcopy /S/Y/Q .\Core\CoSimulation\CoSimulationStandalone\build\* .\build\Environment\Services\CoSimulationStandalone
  if %ERRORLEVEL% NEQ 0 exit /b %ERRORLEVEL%
  
  exit /b 0
