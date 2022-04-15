# Docker Images

The well of knowlege concerning Docker images is indeed deep.  Docker is a technology that allows you to install sofware within porable containers. Since it only requires the OS kernal to run they can be relatively small. If you are not familiar with Docker that's OK. We'll show you what you need to know to get going. The images we will be discussing here are based upon Ubuntu Server 20.4.04. We will update to a later distro whenever approprieate. We will show you how to deploy a running Virdadia server on a Docker container and provide you some knowlege of it works. To save time we will discuss how to run the deployment we have provided.  Then we will explain how to build an image on your own.

## Deploy a Vircadia Container

NOTE: Run this on Ubuntu Server 20.4.04 with Docker installed and Internet access

-1. Clone the Git Repository:
```
git clone https://github.com/Colorfingers/VircadiaDeploy.git
```

-2. Navigate to the Dockerfile directory
```
cd VircadiaDeploy/Docker/Image
```

-3. Execute the batch script
```
./bootstrap.sh
```

Once the script is finished you will have a running docker container running the Vircadia domain server. You will see the following message.

```
##############################################################################################################
#                                                                                                            #
#  The domain server is running and you can reach the configuration GUI at http://XXX.XXX.XXX.XXX:40100      #
#                                                                                                            #
#  All the configuration data is stored on the host at ~/d_vircadia/config/.local                            #
#                                                                                                            #
#  If LOGGING is turned on you will find the log file at ~/d_vircadia/logs/domain-server.log                 #
#                                                                                                            #
##############################################################################################################
```
You should setup configuration at the console GUI running at the given address... Ensure to use a very strong password. The running container is sharing a volume with the configuration data on your host. The container is set to reboot unless manually shutdown.  So if your host reboots so will the container.  Logging is intentionally turned off and must be set in the script prior to running it if you want to examine the logs.  You will have to manually kill the container and remove it before running the script a second time to enable logging.  Your configuration data is still on your host so when you rebuild the container it will be restored to the condition before you shut it down.

To shutdown the container you must first find it's ID, kill it and remove it.

```
# Find the ID
docker ps -a

CONTAINER ID   IMAGE      COMMAND       CREATED          STATUS          PORTS     NAMES
c795be0de853   vircadia   "/bin/bash"   25 minutes ago   Up 25 minutes             domainserver

docker kill c795be0de853
docker rm c795be0de853
docker ps -a

CONTAINER ID   IMAGE      COMMAND       CREATED          STATUS          PORTS     NAMES
```

Directions in the script provide the details for turning on logging.  Just change LOGGING="${LOGOFF}" to LOGGING="${LOGON}"

```
# To enable logging change LOGGING to ${LOGOFF} or ${LOGON}
LOGOFF="/dev/null"
LOGON="${LOGDIR}/domain-server.log"
LOGGING="${LOGON}"
```
Once you have removed the image you need to run the bootstrap script again.  Logging will continue to run until you shut down the container.  Be careful of the log size.

```
./bootstrap.sh
```

# How to build an image (Coming Soon)
