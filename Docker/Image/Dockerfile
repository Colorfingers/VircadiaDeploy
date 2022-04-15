# FROM DOCKER REPOSITORY/CONTAINER:TAG
# Latest: 2022.1.1_selene
FROM colorfingers/vircadia-server-u20.04:2022.1.1_selene

RUN echo UTC >/etc/timezone

# Tell the libraries not to use the interactive dialogs
ARG DEBIAN_FRONTEND=noninteractive
ARG TERM=linux

# Port assigments are realy for future Swarm and Kubernetes builds
# For one offs we are running networking as host
# DOMAIN SERVER PORTS
EXPOSE 40100/tcp
EXPOSE 40101/tcp
EXPOSE 40102/udp
EXPOSE 40103/udp
# ASSIGNMENT CLIENT PORTS
	# AUDIO_MIXER_PORT
EXPOSE 48000/udp
	# AVATAR_MIXER_PORT
EXPOSE 48001/udp
	# ASSIGNMENT_AGENT_PORT
EXPOSE 48002/udp
	# ASSET_SERVER_PORT
EXPOSE 48003/udp
	# MESSAGES_MIXER_PORT
EXPOSE 48004/udp
	# SCRIPT_SERVER_PORT
EXPOSE 48005/udp
	# ENTITIES_SERVER_PORT
EXPOSE 48006/udp

# ENVIRONMENTAL VARIABLES
ENV \
HIFI_DOMAIN_SERVER_HTTP_PORT=40100 \
HIFI_DOMAIN_SERVER_HTTPS_PORT=40101 \
HIFI_DOMAIN_SERVER_PORT=40102 \
HIFI_DOMAIN_SERVER_DTLS_PORT=40103 \
\
HIFI_ASSIGNMENT_CLIENT_AUDIO_MIXER_PORT=48000 \
HIFI_ASSIGNMENT_CLIENT_AVATAR_MIXER_PORT=48001 \
HIFI_ASSIGNMENT_CLIENT_ASSET_SERVER_PORT=48003 \
HIFI_ASSIGNMENT_CLIENT_MESSAGES_MIXER_PORT=48004 \
HIFI_ASSIGNMENT_CLIENT_ENTITY_SCRIPT_SERVER_PORT=48005 \
HIFI_ASSIGNMENT_CLIENT_ENTITIES_SERVER_PORT=48006 \
\
LD_LIBRARY_PATH=$LD_LIBRARY_PATH:/usr/local/lib/:/usr/lib/:/usr/lib64/:/opt/vircadia/lib

# Attempt to make the config files readable on host...
RUN chmod 1777 /var/lib/vircadia
RUN chmod u=rwx,g=rwx,o=rwx /var/lib/vircadia

# Set volume to vircadia config directory
VOLUME /var/lib/vircadia

# Must run as user vircadia
# Unsecure practice to run containers as root
USER vircadia