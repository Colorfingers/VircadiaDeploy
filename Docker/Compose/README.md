# Docker Compose

When we ran the container using the dockerfile there were limitations that made it difficult running the servers without the help of Bash. The one problem with running services with Bash is that when the container reboots the services do not restart. One remedy would be to place our commmands in a bash file and push it to the container. You can then run the bash file from the dockerfile. This method was abandoned because it was taking too much time troubleshooting the errors and our ultimate goal is load balancing. Secondly, we can reuse our dockerfile with Docker Compose. If the services are not started with the dockerfile they will not restart with the container. It is generally a frowned upon practice to run multiple services within one container. While it is certainly fine when testing, in production containers should idealy only run one service. This allows us to have more granualar control over them and load balancing is only performed on services that need it. We are reusing the dockerfile in the Image folder to create our containers. When we use Docker Compose we are able to launch multiple containers and if the system reboots the containers will reboot with them. 

If you make changes to the docker-compose.yml file or the domain-vars.env file you must run down and up for the changes to take effect. 

Docker Compose will run the following services within the containers:

* domain-server
* assignment_client_audio_mixer
* assignment_client_avatar_mixer
* assignment_client_agent
* assignment_client_asset_server
* assignment_client_message_mixer
* assignment_client_entity_script_server
* assignment_client_entities_server


## Deploy the Vircadia Container with Docker Compose

-1. Clone the Git Repository:
```
git clone https://github.com/Colorfingers/VircadiaDeploy.git
```

-2. Navigate to the Docker Compose directory
```
cd VircadiaDeploy/Docker/Image/Compose
```

-3. Execute the bootstrap batch script
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
You should setup configuration at the console GUI running at the given address... Ensure to use a very strong password. The running container is sharing a volume with the configuration data on your host. If your host reboots the containers will reboot with it until you stop or bring them down. Logging is intentionally turned off and must be set in the bootstrap script prior to running it if you want to examine the logs. Your configuration data is still on your host so when you bring the containers back up your configuration will be restored.

## Useful Commands

Commands must run from the same folder as the docker-compose.yml.  You can use some of these commands directly against a container using the service names we provided above.  We are providing html links to the commands for more information.

For example to restart the audio server:
```
docker-compose restart assignment_client_audio_mixer

```

Create and start containers:
https://docs.docker.com/compose/reference/up/
```
docker-compose up [options] [--scale SERVICE=NUM...] [SERVICE...]

```

Stop and remove containers, networks, images, and volumes:
https://docs.docker.com/compose/reference/down/
```
docker-compose down [options]

```   

Stop services:
https://docs.docker.com/compose/reference/stop/
```
docker-compose stop [options] [SERVICE...]  

```

Start services:
https://docs.docker.com/compose/reference/start/
```
docker-compose start [SERVICE...]

```

Restart services:
https://docs.docker.com/compose/reference/stop/
```
docker-compose restart [options] [SERVICE...] 

```

Pause services:
https://docs.docker.com/compose/reference/pause/
```
docker-compose pause 

```

Unpause services:
https://docs.docker.com/compose/reference/unpause/
```
docker-compose unpause

```