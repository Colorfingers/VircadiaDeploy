# Docker Images

The well of knowlege concerning Docker images is indeed deep.  Docker is a technology that allows you to install software within portable containers. Since it only requires the OS kernal to run they can be relatively small. If you are not familiar with Docker that's OK. We'll show you what you need to know to get going. The images we will be discussing here are based upon Ubuntu Server 20.4.04. We will update to a later distro whenever approprieate. We will show you how to deploy a running Vircadia server on a Docker container and provide you some knowledge of it works. To save time we will discuss how to run the deployment we have provided.  Then we will explain how to build an image on your own. We recommend you run this on Ubuntu Server 20.4.04 with Docker installed and Internet access. The container should run on other flavors of Linux but have not been tested.

The bootscript will run the domain-server and assignment clients in one container. You can experiment with different ports and options for the assignment clients if you choose. In this situation there really is not necessary.  

## Deploy the Vircadia Container

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
chmod +x bootstrap.sh
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
You should setup configuration at the console GUI running at the given address... Ensure to use a very strong password. The running container is sharing a volume with the configuration data on your host. If your host reboots or you shutdown your image you will need to remove the existing image and run the bootstrap script again.  Logging is intentionally turned off and must be set in the bootstrap script prior to running it if you want to examine the logs.  You will have to manually kill the container and remove it before re-running the bootstrap script to enable logging.  Your configuration data is still on your host so when you rebuild the container it will be restored to the condition before you shut it down.

Show images:
```
docker images

```

Show containers:
```
docker ps -a
```

To shutdown the container: 
```
docker stop domainserver

```

To start a stopped container:
```
docker start domainserver

```

To restart the container:
```
docker restart domainserver

```

To remove a container:
```
docker kill domainserver
docker rm domainserer

```

To remove all containers:
```
docker stop $(docker ps -a -q)
docker rm $(docker ps -a -q)

```

To remove all images:
```
docker rmi -f $(docker images -a -q)

```

Cleanup all dangling images, containers:
```
docker system prune -a

```

To turn on logging open the bootstrap.sh file and change the following:
```
# To enable logging change LOGGING to ${LOGOFF} or ${LOGON}
LOGOFF="/dev/null"
LOGON="${LOGDIR}/domain-server.log"
LOGGING="${LOGON}"
```
Logging will continue to run until you remove the container, change the bootstrap file and run it again.  Be careful of the log size.

Remove the container, and run the bootstrap:
```
docker kill domainserver
docker rm domainserer
./bootstrap.sh
```

# How to Build an Image

We recognize that you may want to build your own image to run the Vircadia server. It may be for security or educational reasons. Whatever your reasons we will show you how we built the image we provided. There are a couple of caveats before we begin.  Our image is a whopping 325 megabytes.  We are using the Ubuntu 20.4.04 container to ensure compatibility with the deb package we have already created. If you are after a smaller or more performant image you can try to create it completely from scratch following MisterBlueGuy's build instructions: https://github.com/vircadia/vircadia-domain-server-docker. You can also try to use the dated package script found in the Vircadia build repository: https://github.com/vircadia/vircadia/tree/master/pkg-scripts.  We suspect the later will not work without some editing of the source.  Lastly, if you deviate much from the instructions we provide your container may grow larger in size or worst... not run at all.

NOTE: Technically you can run the container on any Linux distribution.  We recommend you run this on Ubuntu Server 20.4.04 with Docker installed and Internet access.  You can find the installation image on the Ubuntu website.

https://releases.ubuntu.com/20.04.4/ubuntu-20.04.4-live-server-amd64.iso

-1. Run the following command from the terminal to pull the Ubuntu 20.4 image from Github.com (You can pull it from another repository if you know one). You will be working inside the container from this moment on.  The command puts you in the terminal of the container.
```
docker run -it --entrypoint "/bin/bash" -e METAVERSE_URL=${METAVERSE_URL} --network=host ubuntu:20.04
```
-2. Update the container
```
apt update -y
apt upgrade -y
```
-3. Run the following commands to install the Vircadia server
```
apt-get install wget -y
wget https://hapticmonkey.s3-us-west-1.amazonaws.com/vircadia-server_2022.1.1-selene-20220303-beb7bd4-0ubuntu1-1_amd64.deb
dpkg --install vircadia-server_2022.1.1-selene-20220303-beb7bd4-0ubuntu1-1_amd64.deb
# At first you will see errors and the installation will not be successfull. Run the following 
apt install -f -y --no-install-recommends
```
-4. Perform a little cleanup
```
# Delete the deb package
rm vircadia*
# Cleanup apt packages cache
rm -rf /var/lib/apt/lists/*

```
-5. Set environmental variables... NOTE: Environmental variables will not remain when you shutdown the container. The Dockerfile helps us to set these up during deployment when running the bootstrap script. 
```
export LD_LIBRARY_PATH=$LD_LIBRARY_PATH:/usr/local/lib/:/usr/lib/:/usr/lib64/:/opt/vircadia/lib
export PATH=$PATH:/opt/vircadia
export HIFI_DOMAIN_SERVER_HTTP_PORT=40100 
export HIFI_DOMAIN_SERVER_HTTPS_PORT=40101 
export HIFI_DOMAIN_SERVER_PORT=40102 
export HIFI_DOMAIN_SERVER_DTLS_PORT=40103 
export HIFI_ASSIGNMENT_CLIENT_AUDIO_MIXER_PORT=48000 
export HIFI_ASSIGNMENT_CLIENT_AVATAR_MIXER_PORT=48001 
export HIFI_ASSIGNMENT_CLIENT_ASSET_SERVER_PORT=48003 
export HIFI_ASSIGNMENT_CLIENT_MESSAGES_MIXER_PORT=48004 
export HIFI_ASSIGNMENT_CLIENT_ENTITY_SCRIPT_SERVER_PORT=48005 
export HIFI_ASSIGNMENT_CLIENT_ENTITIES_SERVER_PORT=48006 

```
-6. Start the domain-server and assignment clients
```
./opt/vircadia/domain-server & 
./opt/vircadia/assignment-client -n 6 &

```
-7. Commit and push you docker container to your repository.  You do not need to stop the container to commit it. Docker will pause it while it's being committed. 
```
# Get the CONTAINER ID
docker ps -a

# FROM the output
CONTAINER ID   IMAGE          COMMAND       CREATED          STATUS          PORTS     NAMES
<CONTAINER ID> ubuntu:20.04   "/bin/bash"   16 minutes ago   Up 16 minutes             priceless_mendeleev

# You can name it what you wish: <USER ID>/name:tag
docker commit <CONTAINER ID> <USER ID>/vircadia-server-u20.04:2022.1.1_selene

# Logon to your docker or other repository.  Obtain a personal access token so you do not have to use your password.
https://hub.docker.com/settings/security

docker login -u <USER ID>
# When you get prompted for your password enter the personal access token.
password: <TOKEN>

docker push <USER ID>/vircadia-server-u20.04:2022.1.1_selene

```
