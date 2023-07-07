- [docker网络](#docker网络)
  - [查看docker网络](#查看docker网络)
  - [映射端口](#映射端口)
  - [映射到指定地址的指定端口](#映射到指定地址的指定端口)
  - [映射到指定地址的任意端口](#映射到指定地址的任意端口)
  - [查看映射端口配置](#查看映射端口配置)
- [容器互联](#容器互联)
  - [新建网络](#新建网络)
  - [连接容器](#连接容器)
- [高级网络配置](#高级网络配置)
  - [访问所有端口](#访问所有端口)
  - [访问指定端口](#访问指定端口)
  - [永久绑定到某个固定的IP地址](#永久绑定到某个固定的IP地址)
  - [编辑网络配置文件](#编辑网络配置文件)





# docker网络

## 查看docker网络

```bash
# 命令：
$ docker container ls

# 输出
CONTAINER ID   IMAGE                                                      COMMAND                  CREATED         STATUS         PORTS                               NAMES
b19b54209a1d   mysql                                                      "docker-entrypoint.s…"   6 minutes ago   Up 6 minutes   0.0.0.0:3306->3306/tcp, 33060/tcp   ubuntu_mysql
97704184d8a0   ccr.ccs.tencentyun.com/dockerpracticesig/docker_practice   "/docker-entrypoint.…"   7 minutes ago   Up 7 minutes   0.0.0.0:4000->80/tcp                bold_galois

```

## 映射端口

```bash
# -p 则可以指定要映射的端口，并且，在一个指定端口上只可以绑定一个容器。支持的格式有
ip:hostPort:containerPort | ip::containerPort | hostPort:containerPort

# 标记可以多次使用来绑定多个端口
$ docker run -d \
    -p 80:80 \
    -p 443:443 \
    nginx:alpine
```

## 映射到指定地址的指定端口

```bash
# 可以使用 ip:hostPort:containerPort 格式指定映射使用一个特定地址，比如 localhost 地址 127.0.0.1
$ docker run -d -p 127.0.0.1:80:80 	nginx:alpine

# 或者
$ docker run -d -p 80:80 --ip 127.0.0.1	nginx:alpine


```

## 映射到指定地址的任意端口

```bash
# 使用 ip::containerPort 绑定 localhost 的任意端口到容器的 80 端口，本地主机会自动分配一个端口。
$ docker run -d -p 127.0.0.1::80 nginx:alpine

#还可以使用 udp 标记来指定 udp 端口
$ docker run -d -p 127.0.0.1:80:80/udp nginx:alpine
```

## 查看映射端口配置

```bash
#使用 docker port 来查看当前映射的端口配置，也可以查看到绑定的地址

$ docker port fa198237  80

0.0.0.0:80
```

## 配置 DNS

```bash
# 如何自定义配置容器的主机名和 DNS 呢？秘诀就是 Docker 利用虚拟文件来挂载容器的 3 个相关配置文件。
# 在容器中使用 mount 命令可以看到挂载信息：

$ mount
/dev/disk/by-uuid/1fec...ebdf on /etc/hostname type ext4 ...
/dev/disk/by-uuid/1fec...ebdf on /etc/hosts type ext4 ...
tmpfs on /etc/resolv.conf type tmpfs ...

#这种机制可以让宿主主机 DNS 信息发生更新后，所有 Docker 容器的 DNS 配置通过 /etc/resolv.conf 文件立刻得到更新。

#配置全部容器的 DNS ，也可以在 /etc/docker/daemon.json 文件中增加以下内容来设置。

{
  "dns" : [
    "114.114.114.114",
    "8.8.8.8"
  ]
}
#这样每次启动的容器 DNS 自动配置为 114.114.114.114 和 8.8.8.8。使用以下命令来证明其已经生效。

$ docker run -it --rm ubuntu:18.04  cat etc/resolv.conf

nameserver 114.114.114.114
nameserver 8.8.8.8

#如果用户想要手动指定容器的配置，可以在使用 docker run 命令启动容器时加入如下参数：
-h HOSTNAME 或者 --hostname=HOSTNAME 设定容器的主机名，它会被写到容器内的 /etc/hostname 和 /etc/hosts。但它在容器外部看不到，既不会在 docker container ls 中显示，也不会在其他的容器的 /etc/hosts 看到。

--dns=IP_ADDRESS 添加 DNS 服务器到容器的 /etc/resolv.conf 中，让容器用这个服务器来解析所有不在 /etc/hosts 中的主机名。

--dns-search=DOMAIN 设定容器的搜索域，当设定搜索域为 .example.com 时，在搜索一个名为 host 的主机时，DNS 不仅搜索 host，还会搜索 host.example.com。

注意：如果在容器启动时没有指定最后两个参数，Docker 会默认用主机上的 /etc/resolv.conf 来配置容器。
```







# 容器互联

## 新建网络

```bash
# 先创建一个新的 Docker 网络。  名字为 my-net  , 会输出一个ID, 网段也进行了配置
$ docker network create -d bridge   --subnet=192.168.65.0/24  my-net

# -d 参数指定 Docker 网络类型，有 bridge overlay。其中 overlay 网络类型用于 Swarm mode
# --subnet  参数指定网络的子网信息
```

## 连接容器

```bash
# 运行一个容器并连接到新建的 my-net 网络， 行完命令后，容器会自动退出并被删除。
$ docker run -it --rm --name busybox1 --network my-net busybox  --ip 192.168.65.6 -p 80:80 bash

# -it：这个参数结合了 -i 和 -t 两个参数，表示让 Docker 在容器内启动一个交互式的终端。
# --rm：这个参数表示在容器退出后自动删除容器。这样可以确保容器退出时自动清理不必要的资源。
# --name busybox1：这个参数用于指定容器的名称，这里指定为 busybox1。
# --network my-net：这个参数用于指定容器启动时所连接的网络，这里的网络名称为 my-net。
# busybox：这个参数表示使用 Docker Hub 上的 busybox 镜像来启动容器。如果本地没有该镜像，Docker 会自动从 Docker Hub 下载该镜像。
# bash：这个参数表示启动一个 Bash shell，在容器内可以执行一些基本的命令和操作。


# 打开新的终端，再运行一个容器并加入到 my-net 网络
$ docker run -it --rm --name busybox2 --network my-net busybox sh


# 再打开一个新的终端查看容器信息
$ docker container ls

CONTAINER ID        IMAGE               COMMAND             CREATED             STATUS              PORTS               NAMES
b47060aca56b        busybox             "sh"                11 minutes ago      Up 11 minutes                           busybox2
8720575823ec        busybox             "sh"                16 minutes ago      Up 16 minutes                           busybox1

```



## 删除网络

```bash
# 删除名为 my-net  的网络
$ docker network  rm  my-net 
```





# 高级网络配置

当 Docker 启动时，会自动在主机上创建一个 `docker0` 虚拟网桥，实际上是 Linux 的一个 bridge，可以理解为一个软件交换机。它会在挂载到它的网口之间进行转发。

同时，Docker 随机分配一个本地未占用的私有网段（在 [RFC1918](https://datatracker.ietf.org/doc/html/rfc1918) 中定义）中的一个地址给 `docker0` 接口。比如典型的 `172.17.42.1`，掩码为 `255.255.0.0`。此后启动的容器内的网口也会自动分配一个同一网段（`172.17.0.0/16`）的地址。

当创建一个 Docker 容器的时候，同时会创建了一对 `veth pair` 接口（当数据包发送到一个接口时，另外一个接口也可以收到相同的数据包）。这对接口一端在容器内，即 `eth0`；另一端在本地并被挂载到 `docker0` 网桥，名称以 `veth` 开头（例如 `vethAQI2QT`）。通过这种方式，主机可以跟容器通信，容器之间也可以相互通信。Docker 就创建了在主机和所有容器之间一个虚拟共享网络。

![Docker 网络](assets/network-20230626145416962.png)

接下来的部分将介绍在一些场景中，Docker 所有的网络定制配置。以及通过 Linux 命令来调整、补充、甚至替换 Docker 默认的网络配置。

## 访问所有端口

当启动 Docker 服务（即 dockerd）的时候，默认会添加一条转发策略到本地主机 iptables 的 FORWARD 链上。策略为通过（`ACCEPT`）还是禁止（`DROP`）取决于配置`--icc=true`（缺省值）还是 `--icc=false`。当然，如果手动指定 `--iptables=false` 则不会添加 `iptables` 规则。

可见，默认情况下，不同容器之间是允许网络互通的。如果为了安全考虑，可以在 `/etc/docker/daemon.json` 文件中配置 `{"icc": false}` 来禁止它。

## 访问指定端口

在通过 `-icc=false` 关闭网络访问后，还可以通过 `--link=CONTAINER_NAME:ALIAS` 选项来访问容器的开放端口。

例如，在启动 Docker 服务时，可以同时使用 `icc=false --iptables=true` 参数来关闭允许相互的网络访问，并让 Docker 可以修改系统中的 `iptables` 规则。

此时，系统中的 `iptables` 规则可能是类似

```bash
$ sudo iptables -nL
...
Chain FORWARD (policy ACCEPT)
target     prot opt source               destination
DROP       all  --  0.0.0.0/0            0.0.0.0/0
...
```

之后，启动容器（`docker run`）时使用 `--link=CONTAINER_NAME:ALIAS` 选项。Docker 会在 `iptable` 中为 两个容器分别添加一条 `ACCEPT` 规则，允许相互访问开放的端口（取决于 `Dockerfile`中的 `EXPOSE` 指令）。

当添加了 `--link=CONTAINER_NAME:ALIAS` 选项后，添加了 `iptables` 规则。

```bash
$ sudo iptables -nL
...
Chain FORWARD (policy ACCEPT)
target     prot opt source               destination
ACCEPT     tcp  --  172.17.0.2           172.17.0.3           tcp spt:80
ACCEPT     tcp  --  172.17.0.3           172.17.0.2           tcp dpt:80
DROP       all  --  0.0.0.0/0            0.0.0.0/0
```

注意：`--link=CONTAINER_NAME:ALIAS` 中的 `CONTAINER_NAME` 目前必须是 Docker 分配的名字，或使用 `--name` 参数指定的名字。主机名则不会被识别。

## 永久绑定到某个固定的IP地址

```bash
# 永久绑定到某个固定的 IP 地址，可以在 Docker 配置文件 /etc/docker/daemon.json 中添加如下内容。

$ vim  /etc/docker/daemon.json

{
  "ip": "0.0.0.0"
}
```

## 编辑网络配置文件

Docker 1.2.0 开始支持在运行中的容器里编辑 `/etc/hosts`, `/etc/hostname` 和 `/etc/resolv.conf`文件。

但是这些修改是临时的，只在运行的容器中保留，容器终止或重启后并不会被保存下来，也不会被 `docker commit` 提交。
