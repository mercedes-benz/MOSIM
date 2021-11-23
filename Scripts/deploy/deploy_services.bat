@echo off

  if not defined MOSIM_HOME (
	ECHO [31mMOSIM_HOME Environment variable is not set.[0m
	ECHO [31mPlease check deploy_variables.bat script, modify it accordingly and run it.[0m
	pause
	exit /b 1
  )

REM Copy core artifacts to services:

    RD /S/Q Services\MMICSharp
    MD Services\MMICSharp
    cmd /c xcopy /S/Y/Q .\Core\Framework\LanguageSupport\cs\MMICSharp\build\* Services\MMICSharp
    if %ERRORLEVEL% NEQ 0 exit /b %ERRORLEVEL%

REM Build Services

REM Deploy Blender IK Service
    cd .\Services\BlenderIK
    call .\deploy.bat
    if %ERRORLEVEL% NEQ 0 cd %MOSIM_HOME% && exit /b %ERRORLEVEL%
    cd %MOSIM_HOME%

    md .\build\Environment\Services\BlenderIK
    cmd /c xcopy /S/Y/Q .\Services\BlenderIK\build\* .\build\Environment\Services\BlenderIK
    if %ERRORLEVEL% NEQ 0 exit /b %ERRORLEVEL%

REM deploy CoordinateSystemMapper

    cd .\Services\CoordinateSystemMapper
    call .\deploy_vs.bat
    if %ERRORLEVEL% NEQ 0 cd %MOSIM_HOME% && exit /b %ERRORLEVEL%
    cd %MOSIM_HOME%

    md .\build\Environment\Services\CoordinateSystemMapper
    cmd /c xcopy /S/Y/Q .\Services\CoordinateSystemMapper\build\* .\build\Environment\Services\CoordinateSystemMapper
    if %ERRORLEVEL% NEQ 0 exit /b %ERRORLEVEL%

    
REM deploy PostureBlendingService
    cd .\Services\PostureBlendingService
    call .\deploy_vs.bat
    if %ERRORLEVEL% NEQ 0 cd %MOSIM_HOME% && exit /b %ERRORLEVEL%
    cd %MOSIM_HOME%
	
    md .\build\Environment\Services\PostureBlendingService
    cmd /c xcopy /S/Y/Q .\Services\PostureBlendingService\build\* .\build\Environment\Services\PostureBlendingService
    if %ERRORLEVEL% NEQ 0 exit /b %ERRORLEVEL%
    
REM deploy RetargetingService
    cd .\Services\RetargetingService
    call .\deploy_vs.bat
    if %ERRORLEVEL% NEQ 0 cd %MOSIM_HOME% && exit /b %ERRORLEVEL%
    cd %MOSIM_HOME%
    
    md .\build\Environment\Services\RetargetingService
    cmd /c xcopy /S/Y/Q .\Services\RetargetingService\build\* .\build\Environment\Services\RetargetingService
    if %ERRORLEVEL% NEQ 0 exit /b %ERRORLEVEL%

REM deploy UnitPathPlanning
	
  cd .\Services\UnityPathPlanning
  call .\deploy_unity.bat  
  if %ERRORLEVEL% NEQ 0 exit /b %ERRORLEVEL%
  cd %MOSIM_HOME%

  md .\build\Environment\Services\UnityPathPlanning
  cmd /c xcopy /S/Y/Q .\Services\UnityPathPlanning\UnityPathPlanningService\build\* .\build\Environment\Services\UnityPathPlanning
  if %ERRORLEVEL% NEQ 0 exit /b %ERRORLEVEL%

REM deploy SkeletonAccessService

  cd .\Services\SkeletonAccessService\
  call .\deploy.bat 
  if %ERRORLEVEL% NEQ 0 cd %MOSIM_HOME% && exit /b %ERRORLEVEL%
  cd %MOSIM_HOME%

  md .\build\Environment\Services\SkeletonAccessService
  cmd /c xcopy /S/Y/Q .\Services\SkeletonAccessService\build\* .\build\Environment\Services\SkeletonAccessService
  if %ERRORLEVEL% NEQ 0 exit /b %ERRORLEVEL%
