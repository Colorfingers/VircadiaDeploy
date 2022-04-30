echo "Create local data folder..."
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

echo "Executing docker-compose..."
# Create containers and map port to host
docker-compose up &> ${LOGGING} &

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