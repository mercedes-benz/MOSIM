@echo off

if not defined MOSIM_IPA (
	echo [31mIP address of host not set![0m
	echo [31mPlease set environment variable MOSIM_IPA to the IP address of the host on which you want to run the images.[0m
	echo "[31mPlease note: Using localhost (127.0.0.1) is not supported so far![0m"
	exit /b 1
)

start cmd.exe /c "docker run -p 9009:9009 -it -v C:\Repositories\AIToC-MOSIM\MOSIM\Dockerfiles\data:/data mosim01/launcher:latest"
timeout /t 10

start cmd.exe /c "docker run -p 8900:8900 -t mosim01/csharpadapter:latest -a %MOSIM_IPA%:8900 -r %MOSIM_IPA%:9009" 
timeout /t 5

start cmd.exe /c "docker run -p 8950:8950 -t mosim01/unity:unityadapter -a %MOSIM_IPA%:8950 -r %MOSIM_IPA%:9009 -m MMUs"
timeout /t 5

start cmd.exe /c "docker run -p 9503:9503 -t mosim01/postureblending:latest -a %MOSIM_IPA%:9503 -r %MOSIM_IPA%:9009"
timeout /t 5 

start cmd.exe /c "docker run -p 9505:9505 -t mosim01/coordinatesystemmapper:latest -a %MOSIM_IPA%:9505 -r %MOSIM_IPA%:9009"
timeout /t 5

start cmd.exe /c "docker run -p 9507:9507 -t mosim01/unity:pathplanning -a %MOSIM_IPA%:9507 -r %MOSIM_IPA%:9009"
timeout /t 5

start cmd.exe /c "docker run -p 9091:9091 -l -t mosim01/blenderservice:latest -a %MOSIM_IPA%:9091 -r %MOSIM_IPA%:9009 -l"
timeout /t 5

REM start cmd.exe /c "docker run -p 9091:9091 -l -t unityik -a %MOSIM_IPA%:9091 -r %MOSIM_IPA%:9009 -l"
REM timeout /t 5


