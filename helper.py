# -*- coding: UTF-8 -*-
import json
import sys
import getopt
import socket

local_ip = None

def update_insecure_registries(host):
    """添加 insecure-registries 到 docker 配置文件中
    """
    with open("/etc/docker/daemon.json","r",encoding='utf-8') as f:
        content = f.read()
        data = json.loads(content.strip() or "{}")
        original = data.get("insecure-registries",[])
        if host  in original:
            return
        original.append(host)
        data["insecure-registries"] = original
        with open("/etc/docker/daemon.json","w",encoding='utf-8') as f:
            f.write(json.dumps(data,indent=4,sort_keys=True))

def get_ip():
    """获取本机ip"""
    global local_ip
    if local_ip:
        return local_ip
    ip = [(s.connect(('8.8.8.8', 53)), s.getsockname()[0], s.close()) for s in [socket.socket(socket.AF_INET, socket.SOCK_DGRAM)]]
    return ip[0][1]


def generate_env():
    with open("node_template/.env","w",encoding="utf-8") as f:
        f.write("\nIP={}\n".format(get_ip()))
    with open("plat_template/.env","w",encoding="utf-8") as f:
        f.write("\nIP={}\n".format(get_ip()))


def generate_node_info():
    suffix = get_ip().split(".")[-1]
    data = {"user_id": f"{suffix:0<32}"}
    with open("node_template/fl-scheduler/.node_info","w",encoding="utf-8") as f:
        f.write(json.dumps(data,indent=4,sort_keys=True))

def generate_fl_config():
    with open("node_template/fl-scheduler/config/constant_settings.yaml.example","r",encoding="utf-8") as f:
        data=f.read()
        data = data.replace("${IP}",get_ip())
    with open("node_template/fl-scheduler/config/constant_settings.yaml","w",encoding="utf-8") as f:
        f.write(data)

def generate_docker_compose(host, tag):
    registry_host = host.split("//")[-1]
    with open("node_template/docker-compose-node.yml.example","r",encoding="utf-8") as f:
        data=f.read()
        data = data.replace("${IP}",get_ip()).replace("${RegistryURI}",registry_host).replace("${TAG}",tag)
    with open("node_template/docker-compose-node.yml","w",encoding="utf-8") as f:
        f.write(data)

    with open("plat_template/docker-compose-plat.yml.example","r",encoding="utf-8") as f:
        data=f.read()
        data = data.replace("${IP}",get_ip()).replace("${RegistryURI}",registry_host).replace("${TAG}",tag)
    with open("plat_template/docker-compose-plat.yml","w",encoding="utf-8") as f:
        f.write(data)

def main(argv):
    global local_ip
    registry, tag = "http://101.251.207.188:5000", "latest"
    try:
        opts, _ = getopt.getopt(argv, "-h-r:-t:-i:", ["help", "registry=", "tag=", "ip="])
    except getopt.GetoptError:
        print('helper.py -h')
        sys.exit(2)
    for opt, arg in opts:
        if opt in ("-h", "--help"):
            print('helper.py --registry="<protocol>://<host>:<port>" --<tag> --ip=<local ip>')
            print('or: helper.py -r "<protocol>://<host>:<port>" -t <tag> -i <local ip>')
            sys.exit()
        elif opt in ("-r", "--registry"):
            registry = arg
        elif opt in ("-i", "--ip"):
            local_ip = arg
        elif opt in ("-t", "--tag"):
            tag = arg
    print(f"check args: registry: {registry}, tag: {tag}, ip: {local_ip}")
    # update_insecure_registries(host=registry)
    generate_docker_compose(host=registry, tag=tag)
    generate_env()
    generate_node_info()
    generate_fl_config()

if __name__ == "__main__":
    main(sys.argv[1:])