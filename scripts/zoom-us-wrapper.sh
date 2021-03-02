#!/bin/bash

PATH=/usr/sbin:/usr/bin:/sbin:/bin
ZOOM_US_USER=zoom

# do we need to use sudo to start docker containers?
( id -Gn | grep -q docker ) || SUDO=sudo

USER_UID=$(id -u)
USER_GID=$(id -g)

XSOCK=/tmp/.X11-unix
XAUTH=/tmp/.docker.xauth

DOWNLOAD_DIR=$(xdg-user-dir DOWNLOAD)
if [ -z "${DOWNLOAD_DIR}" ]; then
    DOWNLOAD_DIR="${HOME}/Downloads"
fi;
DOCUMENTS_DIR=$(xdg-user-dir DOCUMENTS)
if [ -z "${DOCUMENTS_DIR}" ]; then
    DOCUMENTS_DIR="${HOME}/Documents"
fi;

#list_commands() {
#  echo ""
#  echo "Launch zoom-us using:"
#  echo "  zoom                        OR "
#  echo "  zoom-us-wrapper zoom"
#  echo ""
#  exit 1
#}

cleanup_stopped_zoom_us_instances(){
  echo "Cleaning up stopped zoom-us instances..."
  for c in $(${SUDO} docker ps -a -q)
  do
    image="$(${SUDO} docker inspect -f {{.Config.Image}} ${c})"
    if [ "${image}" == "mdouchement/zoom-us:latest" ]; then
      running=$(${SUDO} docker inspect -f {{.State.Running}} ${c})
      if [ "${running}" != "true" ]; then
        ${SUDO} docker rm "${c}" >/dev/null
      fi
    fi
  done
}

prepare_docker_env_parameters() {
  ENV_VARS+=" --env=USER_UID=${USER_UID}"
  ENV_VARS+=" --env=USER_GID=${USER_GID}"
  ENV_VARS+=" --env=DISPLAY=unix$DISPLAY"
  ENV_VARS+=" --env=XAUTHORITY=${XAUTH}"
  ENV_VARS+=" --env=TZ=$(date +%Z)"
}

prepare_docker_volume_parameters() {
  touch ${XAUTH}
  xauth nlist :0 | sed -e 's/^..../ffff/' | xauth -f ${XAUTH} nmerge -

  if [[ -z "${ZOOM_HOME}" ]]; then
    ZOOM_HOME=${HOME} # Default directory
  else
    DOWNLOAD_DIR=${DOWNLOAD_DIR/$HOME/$ZOOM_HOME}
    DOCUMENTS_DIR=${DOCUMENTS_DIR/$HOME/$ZOOM_HOME}
    mkdir -p {$DOWNLOAD_DIR,$DOCUMENTS_DIR}

    mkdir -p ${ZOOM_HOME}/{.config,.cache,.zoom}
  fi

  echo "Using ZOOM_HOME: ${ZOOM_HOME}"

  touch ${ZOOM_HOME}/.config/zoomus.conf # create if not exists

  VOLUMES+=" --volume=${ZOOM_HOME}/.config/zoomus.conf:/home/${ZOOM_US_USER}/.config/zoomus.conf"
  VOLUMES+=" --volume=${ZOOM_HOME}/.cache/zoom:/home/${ZOOM_US_USER}/.cache/zoom"
  VOLUMES+=" --volume=${ZOOM_HOME}/.zoom:/home/${ZOOM_US_USER}/.zoom"
  VOLUMES+=" --volume=${DOWNLOAD_DIR}:/home/${ZOOM_US_USER}/Downloads"
  VOLUMES+=" --volume=${DOCUMENTS_DIR}:/home/${ZOOM_US_USER}/Documents"
  VOLUMES+=" --volume=${XSOCK}:${XSOCK}"
  VOLUMES+=" --volume=${XAUTH}:${XAUTH}"
  VOLUMES+=" --volume=/run/user/${USER_UID}/pulse:/run/pulse"
}

prepare_docker_device_parameters() {
  # enumerate video devices for webcam support
  VIDEO_DEVICES=
  for device in /dev/video*
  do
    if [ -c $device ]; then
      VIDEO_DEVICES="${VIDEO_DEVICES} --device $device:$device"
    fi
  done
}

#prog=$(basename $0)
#exec=$(which $prog)

#if [[ ${prog} == "zoom-us-wrapper" ]]; then
#  case ${1} in
#    zoom)
#      prog=${1}
#      shift
#      ;;
#    *|help)
#      list_commands
#      exit 1
#      ;;
#  esac
#elif [[ -n ${exec} ]]; then
#  # launch host binary if it exists
#  exec ${exec} $@
#fi
prog="zoom"

cleanup_stopped_zoom_us_instances
prepare_docker_env_parameters
prepare_docker_volume_parameters
prepare_docker_device_parameters

echo "Starting ${prog}..."
${SUDO} docker run -d \
  ${ENV_VARS} \
  ${VIDEO_DEVICES} \
  --device /dev/dri \
  ${VOLUMES} \
  ${ZOOM_EXTRA_DOCKER_ARGUMENTS} \
  --name zoomus \
  mdouchement/zoom-us:latest ${prog} $@ >/dev/null

prog="firefox"
echo "Starting ${prog}..."
${SUDO} docker exec -u $USER_UID -ti zoomus ${prog}

