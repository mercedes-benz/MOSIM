This Folder contains experimental scripts to create and start a C# Adapter with Docker.

1. Copy the adapter in the "adapter" folder (name of the runnable adapter file must be the same as in the ENTRYPOINT entry in the file called Dockerfile)
2. run createContainer.cmd
3. modify runContainer.cmd
4. run runContainer.cmd




Parameters in runContainer.cmd:

docker run --rm -it -p 9102:9102 csharpadapter -a "127.0.0.1:9102"  -r  "172.25.160.1:9009" -m .

--rm ------------->  causes Docker to automatically remove the container when it exits
-it ------------->  is short for --interactive + --tty when you docker run with this command.. it would take you straight inside of the container


-p 9102:9102 --------------> maps host port 9102 to container port 9102; because of this the Adapter is reachable over the host IP and the specified port

-a "127.0.0.1:9102"  -r  "172.25.160.1:9009" -m . --------------> "normal" start parameters for the adapter 
								  -a IP address of the Adapter; port must be the same as the before mapped port 
								  -r the IP address of the Launcher; here the IP address of the  virtual Ethernet adapter with NAT is needed (In Windows it is called vEthernet(DocketNAT) and in Linux docker0)
								  -m path where the adapter loads the MMUs


