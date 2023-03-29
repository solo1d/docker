## 镜像操作（用于创建容器）

```bash
# 获取镜像
$ docker pull [选项] [Docker Registry 地址[:端口号]/]仓库名[:标签]
$ docker  pull debian     #从服务器下载 安装某个镜像或应用

# 列出镜像(ID、镜像名)
$ docker image ls

# 删除镜像
$ docker image rm [选项] <镜像1> [<镜像2> ...]
			$ docker image rm $(docker image ls -q redis)	 #删除所有仓库名为 redis 的镜像：

# 镜像体积
$ docker system df

# 虚悬镜像搜索（一般删除即可）
$ docker image ls -f dangling=true 


# 搜索镜像
$ docker search  ubuntu
```

## 容器操作

```bash
# 守护进程启动，并分配bas控制
$ docker run -it -d  ubuntu:18.04

 #运行下载好的镜像
$sudo docker  run  debian    
    $sudo docker  run  -d  debian     #-d 后台 运行该镜像或应用
    $sudo docker  run  -p 80:81  debian     #运行该镜像或应用, -p 端口映射, 外部80:内部81 ,访问81会到容器的80
    
    
# 将本地的   /home/ns/os 目录挂载到容器的 /root/os 目录（读写）。
#  并启动 ubuntu 最新的容器
$ docker run --name ubuntu_os -it -d --mount type=bind,source=/home/ns/os,target=/root/os ubuntu

#923是某个容器的 CONTAINER ID 属性. 进入bash 模式来控制这个容器镜像
$sudo docker exec -it  923  bash  


#查看目前正在运行的容器
$sudo docker ps      
   # CONTAINER ID 是重要属性, 用以区分各个容器内的进程


# 启动已终止容器
# 可以利用 docker container start 命令，直接将一个已经终止（exited）的容器启动运行。
$  docker container start   容器id

# 查看本地的容器。 可以查询未启动的容器列表
$ docker container ls -a


#进入容器
$ docker exec -it 69d1 bash



# 停止容器
# 	终止状态的容器可以用 docker container ls -a 命令看到。
$ docker container stop   容器id

# 重新启动容器
$ docker container start  容器id


#删除容器
$ docker container rm trusting_newton



# 清理所有处于终止状态的容器
#   用 docker container ls -a 命令可以查看所有已经创建的包括终止状态的容器
$ docker container prune
```





## docker配置文件备份

```json
{
  "builder": {
    "gc": {
      "defaultKeepStorage": "20GB",
      "enabled": true
    }
  },
  "debug": true,
  "experimental": true,
  "features": {
    "buildkit": true
  }
  // 加速地址
  ,
  "registry-mirrors": [
    "http://hub-mirror.c.163.com"
  ]
}
```

