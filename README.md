# 8lab Federated Learning deployment using Docker Compose
This guid describes the process of deploying 8lab Federated Learning platform using Docker Compose

## Prerequisites
The nodes (target nodes) to install 8lab fl must meet the following requirements:
- Linux Host (Ubuntu 18.x above)
- Docker 20.10+
- Docker-compose v2.9.0+
- Network connection to internet to pull container images from 8lab private docker hub (`telnet 101.251.207.188 5000`). If network connecto to internet is not available, considering to set up Harbor as a local registry or use offline images.
## Modify Config
### For platform
- ${BASEDIR}/plat_template/.env
```properties
IP=[Your Server IP4]
```
### For Node
- ${BASEDIR}/node_template/.env
```properties
IP=[Your Server IP4]
```
- ${BASEDIR}/node_template/fl-scheduler/config/constant_settings.yaml
```yaml
LOCAL_IP: [Your Server IP4]
FEDERATION:
    rabbitmq:
        host: [Your Server IP4]
```
- ${BASEDIR}/node_template/fl-scheduler/.node_info
```json
{
    "user_id": "[UDF Series NO.]"
}
```

## Deploying 8lab fl platform
Note: Before running the below commands, all target hosts must

- enable 8lab fl repository
- has correct permission to run docker
- meet the requirements specified in Prerequisites.


To deploy all system to one host use the below command:

```
bash ./docker_deploy.sh all
```

if only node or platform need to be install use the below:

```
bash ./docker_deploy.sh node|platform
```

## Verifying the deployment

open broswer access url below:
```
# for platform
http://[you_host]
# for node
http://[you_host]:50000
```
