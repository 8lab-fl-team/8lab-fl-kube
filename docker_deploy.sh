set -e
BASEDIR=$(dirname "$0")
cd $BASEDIR
WORKINGDIR=$(pwd)

source ${WORKINGDIR}/.env

cd ${WORKINGDIR}

ShowUsage() {
	echo "Usage: "
	echo "Deploy all parties or specified partie(s): bash docker_deploy.sh [--down] node | platform | all"
}

Delete() {
    if [ "$1" = "" ]; then
		echo "No system was provided, please check your arguments "
		exit 1
	fi 

    if [ "$1" != "" ]; then
        case $1 in
        all)
            docker-compose -f ${WORKINGDIR}/plat_template/docker-compose-plat.yml down 
            docker-compose -f ${WORKINGDIR}/node_template/docker-compose-node.yml down 
            ;;
        platform)
            docker-compose -f ${WORKINGDIR}/plat_template/docker-compose-plat.yml down 
            ;;
        node)
            docker-compose -f ${WORKINGDIR}/node_template/docker-compose-node.yml down 
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
            docker-compose -f ${WORKINGDIR}/plat_template/docker-compose-plat.yml up
            docker-compose -f ${WORKINGDIR}/node_template/docker-compose-node.yml up
            ;;
        platform)
            docker-compose -f ${WORKINGDIR}/plat_template/docker-compose-plat.yml up 
            ;;
        node)
            docker-compose -f ${WORKINGDIR}/node_template/docker-compose-node1.yml up 
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