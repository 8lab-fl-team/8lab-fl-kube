# 使用Docker Compose安装八分量隐私计算平台
该手册用于使用项目中的脚本安装隐私计算平台以及节点。

## 前提条件
安装隐私计算平台的计算机节点需要满足以下条件：
- Linux Host (Ubuntu 18.x 以上)
- Docker 20.10+
- Docker-compose v2.9.0+
- 节点需要能够访问互联网，可以通过命令检查与八分量docker hub仓库的连通性 (`telnet 101.251.207.188 5000`). 

## 开始部署
注意，部署前请再次检查是否满足以及如下事项：

- 指定 `--insecure-repository=101.251.207.188:5000`
  或者更改配置文件 /etc/docker/daemon.json
  {
    "insecure-registries": ["${registry_host}:50000"]
  }
  修改后需要重启docker服务
- 当前用户拥有执行docker命令的权限
- 满足上述前提条件


可以使用如下命令将隐私激素啊平台和一个隐私计算节点都部署在同一台机器上:

```
bash ./docker_deploy.sh all
```

如果需要单独将隐私计算节点或者隐私计算平台部署到一台机器上，则需要执行如下命令:

```
bash ./docker_deploy.sh node|platform
```

## 验证安装结果

隐私计算平台和隐私计算节点均提供了前端页面，安装完成后可以直接打开相应页面执行注册节点等操作。如果操作可以正常进行则说明安装成功。
```
# for platform
http://[you_host]
# for node
http://[you_host]:50000
```