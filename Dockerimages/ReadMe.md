The Docker images for all components of the MOSIM Framework are available at: hub.docker.com

You can ues PullImages.bat to download the images to your local machine.

We recommend to pull the images before you try to start them using StartImages.bat because (depending on the download speed) the pause times in the start script might be too short which could make some images fail to connect to the launcher image.

Please make sure that you set the environment variable MOSIM_IPA to the IP address of the machine on which you want to run the framework.
Therefore, please use Windows command line window for this rather than PowerShell.
We recommend to use the Windows Terminal App beccause it allows to easily switch between these two.

Please make sure that you also set the IP address in Unity in Scene and Avatar in the MMI plugins to the IP address of the machine where you have the framework running.
Remote access to the framework should work out of the box. However, using localhost (127.0.0.1) when Unity and the Framework run on the same machine is not supported.

By default we do not support a distrubuted setting for the MOSIM framework (i.e. the provided scripts asssume that all components of the Framewok run on the same machine), however, it is strainght modify what is there to get to a distributed setting.

Provided bat scripts:

PullImages.bat:
	Pulls all images of the Framework from Docker Hub.
	Images which include Unity dlls are provided in a private repository.
	Please contact Klaus.Fischer@dfki.de to ask for access if you want to have it.

StartImages.bat:
	Starts all images for the Framework.
	Please use Windows command line window and make sure that evnrionment variable MOSIM_IPA is set to IP address of the machine.

StopContainers.bat:
	Stops all running containers.
	Please note: This stops all containers on the machine not just the MOSIM containers!

RemoveContainers.bat:
	Removes all containers.
	Please note: Containers must be stoped before they can be deleted.
	Please note: This removes all containers on the machine not just the MOSIm containers!

RemoveImages.bat:
	Removes all images.
	Please note: This removes all images on the machine not just the MOSIm images!
