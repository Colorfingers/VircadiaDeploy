#! /bin/bash

# BUILD CONTAINER WITH DESIRED EXPOSED PORTS FROM DOCKERFILE
# NAME CONTAINER VIRCADIA
echo ""
echo "Build Working Image 'vircadia'..."
docker build -t vircadia .

echo ""
echo "Stage Variables..."
# Borrowed from MisterBlueGuy
METAVERSE_URL=${METAVERSE_URL:-https://metaverse.vircadia.com/live}

# Create local directories that are mounted from the Docker container
# Permission is set to 777 since the container runs its own UID:GID
# If container is destroyed it will use the config from this saved data
CONFIGDIR=~/d_vircadia/config
LOGDIR=~/d_vircadia/logs
mkdir -p "${CONFIGDIR}"
chmod 1777 "${CONFIGDIR}"
chmod o+s "${CONFIGDIR}"
mkdir -p "${LOGDIR}"
chmod 777 "${LOGDIR}"

echo "You can ignore 'Operation not permitted' errors. This only happens if you already have the local directories."

# To enable logging change LOGGING to ${LOGOFF} or ${LOGON}
LOGOFF="/dev/null"
LOGON="${LOGDIR}/domain-server.log"
LOGGING="${LOGOFF}"

echo ""
echo "Launch the 'vircadia' Image..."
# LAUNCH NEW CONTAINER WITH OPEN PORTS
# RUN CONTAINER WITH NAME DOMAIN_SERVER
docker run -dit --name domainserver -e METAVERSE_URL=${METAVERSE_URL} --network=host -v ${CONFIGDIR}:/var/lib/vircadia:z vircadia

echo ""
echo "Run the Domain Server... "
# LAUNCH THE DOMAIN SERVER IN BACKGROUND
docker exec -u vircadia domainserver ./opt/vircadia/domain-server &> ${LOGGING} &

echo ""
echo "Run the Assignment Clients..."
# LAUNCH THE ASSIGNMENT CLIENTS IN BACKGROUND
# -h = help
# -v = version
# -t = type
	# 0 = audio-mixer
	# 1 = avatar-mixer
	# 2 = agent
	# 3 = asset-server
	# 4 = message-mixer
	# 5 = entity-script-server
	# 6 = entity-server
# -n = number of child assignment clients to fork
# -p = port number
# -a = Domain server host name
# --pool = Identifies a pool of assignment clients... can be of different hosts
# --min = minimum number of assignment clients
# --max = maximum number of assignment clients
# --server-port = assignment (domain server) server port (default is 40102)
# --monitor-port <port>

	# AUDIO_MIXER
docker exec -u vircadia domainserver ./opt/vircadia/assignment-client -n 1 -t 0 -p 48000 &> ${LOGGING}  &
	# AVATAR_MIXER_PORT
docker exec -u vircadia domainserver ./opt/vircadia/assignment-client -n 1 -t 1 -p 48001 &> ${LOGGING} &
	# AGENT_PORT
docker exec -u vircadia domainserver ./opt/vircadia/assignment-client -n 1 -t 2 -p 48002 &> ${LOGGING} &
	# ASSET_SERVER_PORT
docker exec -u vircadia domainserver ./opt/vircadia/assignment-client -n 1 -t 3 -p 48003 &> ${LOGGING} &
	# MESSAGES_MIXER_PORT
docker exec -u vircadia domainserver ./opt/vircadia/assignment-client -n 1 -t 4 -p 48004 &> ${LOGGING} &
	# SCRIPT_SERVER_PORT
docker exec -u vircadia domainserver ./opt/vircadia/assignment-client -n 1 -t 5 -p 48005 &> ${LOGGING} &
	# ENTITIES_SERVER_PORT
docker exec -u vircadia domainserver ./opt/vircadia/assignment-client -n 1 -t 6 -p 48006 &> ${LOGGING} &

# Print out exit instructions
function getIp() {
	ip -o route get to 8.8.8.8 | sed -n 's/.*src \([0-9.]\+\).*/\1/p'
}
IP=$(getIp)
function expIp() {
	echo 00${IP//./.00} | sed -r 's/0*([0-9]{3})/\1/g'
}
LIP=$(expIp)
echo "##############################################################################################################"
echo "#                                                                                                            #"
echo "#  The domain server is running and you can reach the configuration GUI at http://${LIP}:40100      #"
echo "#                                                                                                            #"
echo "#  All the configuration data is stored on the host at ~/d_vircadia/config/.local                            #"
echo "#                                                                                                            #"
echo "#  If LOGGING is turned on you will find the log file at ~/d_vircadia/logs/domain-server.log                 #"
echo "#                                                                                                            #"
echo "##############################################################################################################"
echo ""
exit 0
