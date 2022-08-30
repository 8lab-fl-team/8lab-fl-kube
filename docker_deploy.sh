set -e
BASEDIR=$(dirname "$0")
cd $BASEDIR
WORKINGDIR=$(pwd)

cd ${WORKINGDIR}

ShowUsage() {
	echo "Usage: "
	echo "Deploy all parties or specified partie(s): bash docker_deploy.sh [--down] node | platform | all"
}

Deploy_platform() {
    # RegistryURI=${RegistryURI} TAG=${TAG} PPCP_RESTFUL_API=${PPCP_RESTFUL_API} docker-compose -f ${WORKINGDIR}/plat_template/docker-compose-plat.yml up -d
    docker-compose -f ${WORKINGDIR}/plat_template/docker-compose-plat.yml up -d
}

Deploy_node() {
    # RegistryURI=${RegistryURI} TAG=${TAG} NODE_RESTFUL_API=${NODE_RESTFUL_API} IP=${IP} docker-compose -f ${WORKINGDIR}/node_template/docker-compose-node.yml up -d
    docker-compose -f ${WORKINGDIR}/node_template/docker-compose-node.yml up -d
}

Delete_platform() {
    docker-compose -f ${WORKINGDIR}/plat_template/docker-compose-plat.yml down
}

Delete_node() {
    docker-compose -f ${WORKINGDIR}/node_template/docker-compose-node.yml down
}

Delete() {
    if [ "$1" = "" ]; then
		echo "No system was provided, please check your arguments "
		exit 1
	fi

    if [ "$1" != "" ]; then
        case $1 in
        all)
            Delete_platform
	    Delete_node
            ;;
        platform)
            Delete_platform
            ;;
        node)
	    Delete_node
            ;;
        *)
            echo 'no matched'
            exit 1
            ;;
        esac
    fi
}

Deploy() {
    if [ "$1" = "" ]; then
		echo "No system was provided, please check your arguments "
		exit 1
	fi

    if [ "$1" != "" ]; then
        case $1 in
        all)
            Deploy_platform
	    Deploy_node
            ;;
        platform)
            Deploy_platform
            ;;
        node)
	    Deploy_node
            ;;
        *)
            echo "unsupported system"
            exit 1
        esac
    fi
}

main() {
	if [ "$1" = "" ] || [ "$" = "--help" ]; then
		ShowUsage
		exit 1
	elif [ "$1" = "--down" ]; then
		shift
		Delete $@
	else
		Deploy "$@"
	fi
	exit 0
}

main $@
