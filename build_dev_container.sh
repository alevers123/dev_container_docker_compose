#!/bin/bash

create_image() {
  service=$1
  cont_name=${2:-${1,,}_cont}
  image_name=${3:-${1,,}_image}
  echo "$cont_name, $image_name"
  uid=$uid gid=$gid uname=$uname cont_name=$cont_name image_name=$image_name docker compose build $service
}


create_container() {
  service=$1
  cont_name=${2:-${1,,}_cont}
  image_name=${3:-${1,,}_image}
  uid=$uid gid=$gid uname=$uname cont_name=$cont_name image_name=$image_name docker compose create $service
}

recreate_image() {
  delete_image ${1}
  create_image $1 $2
}

delete_image() {
  image_name=${1}
  attached_container=$(docker ps -a -q --filter "ancestor=$image_name")
  if [ -n "$attached_container" ]; then
    docker rm $(docker ps -a -q --filter "ancestor=$image_name")
  fi
  docker image rm $image_name
}

delete_container() {
 service=$1
 cont_name=${2:-${1,,}_cont}
 image_name=${3:-${1,,}_image}
 uid=$uid gid=$gid uname=$uname cont_name=$cont_name image_name=$image_name docker compose rm $service 
}

service_start() {
  service=$1
  cont_name=${2:-${1,,}_cont}
  image_name=${3:-${1,,}_image}
  #uid=$uid gid=$gid uname=$uname cont_name=$cont_name image_name=$image_name docker compose start $service
  docker container start -i $cont_name
  #docker container exec -it $cont_name /bin/zsh
}

list_services() {
  docker compose config --services 2>/dev/null
}

list_images() {
  docker images
}

usage() {
  echo '
USAGE
-i | --create-image: Creates a new docker image for a service defined in compose file
-c | --create-container: Creates a container for the service in compose file
-s | --start-service: Starts up a container
-r | --recreate-image: Recreates the docker image
-d | --delete: Delete the docker image and attached containers
-m | --del-container: Delete the docker container attached to service
-l | --list: List all services
-L | --list-images: List all images
-N | --container_name
-I | --image_name
-h | --help: Show this help file
'
}

TEMP=$(getopt -o "i,c,s,r:,d:,m,l,L,N:,I:,h" --long "create-image,create-container,start-service,recreate_image:,delete-image:,del-container,list,list-images,container_name:,image_name:,help:" -n "$0" -- "$@")

[ $? -eq 0 ] || {
  echo "Incorrect options provided"
  exit 1
}

opts=0
docker_file=./
tools_directory=/usr/local/share/dockerfiles/devcontainer/InitScripts
uid=$(id -u)
gid=$(id -g)
uname=$(whoami)
privileged=false

eval set -- $TEMP

while true; do
  case $1 in
  '-i' | '--create-image')
    opts=$((opts + 1))
    shift
    continue
    ;;
  '-c' | '--create-container')
    opts=$((opts + 2))
    shift
    continue
    ;;
  '-s' | '--start-service')
    opts=$((opts + 4))
    shift
    continue
    ;;
  '-r' | '--recreate-image')
    opts=$((opts + 8))
    shift
    continue
    ;;
  '-m' | '--delete-container')
    opts=$((opts + 16))
    shift
    continue
    ;;
  '-d' | '--delete')
    image_name=$2
    opts=$((opts + 32))
    shift 2
    continue
    ;;
 '-l' | '--list')
    opts=$((opts + 64))
    shift
    continue
    ;; 
  '-L' | '--list-images')
    opts=$((opts + 128))
    shift
    continue
    ;; 
  '-N' | '--container_name')
    cont_name=$2
    shift 2
    continue
    ;;
  '-I' | '--image_name')
    image_name=$2
    shift 2
    continue
    ;;
  '-h' | '--help')
    usage
    exit 1
    ;;
  '--')
    shift
    break
    ;;
  esac
done

if [ -z "$1" ] && ! [ "$opts" -ge 32 ]; then
  usage
  exit -1
fi

service_name=$1
shift

if [ -n "$1" ]; then
  usage
  exit -1
fi

for x in {0..8}; do
  case $(($opts & 1 << $x)) in
  1)
    echo "Creating docker image for service"
    create_image $service_name $cont_name $image_name
    continue
    ;;
  2)
    echo "Creating container for service"
    create_container $service_name $cont_name $image_name
    continue
    ;;
  4)
    echo "Starting service from compose file" 
    service_start $service_name $cont_name $image_name 
    continue
    ;;
  8)
    echo "Recreating service image"
    recreate_image $service_name $cont_name $image_name 
    continue
    ;;
  16)
    echo "Delete container attached to service"
    delete_container $service_name $cont_name $image_name 
    continue
    ;;
  32)
    echo "Docker image will be removed"
    delete_image $image_name
    continue
    ;;
  64)
    echo "Services listed in docker file:"
    list_services 
    continue
    ;;
  128)
    echo "List all images"
    list_images
  esac
done

exit 1
