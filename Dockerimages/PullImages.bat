if if not defined MOSIM_IPA (
	echo [31mIP address of host not set![0m
	echo [31mPlease set environment variable MOSIM_IPA to the IP address of the host on which you want to run the images.[0m
	echo [31mPlease note: Using localhost (127.0.0.1) is not supported so far![0m
	exit /b 1
)

docker pull mosim01/launcher:latest

docker pull mosim01/csharpadapter:latest 

docker pull mosim01/unity:unityadapter

docker pull mosim01/postureblending:latest

docker pull mosim01/coordinatesystemmapper:latest

docker pull mosim01/unity:pathplanning

docker pull mosim01/blenderservice:latest

