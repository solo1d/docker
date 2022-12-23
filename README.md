```shell
$sudo docker  pull debian     #从服务器下载 安装某个镜像或应用

$sudo docker  run  debian     #运行下载好的镜像
    $sudo docker  run  -d  debian     #-d 后台 运行该镜像或应用
    $sudo docker  run  -p 80:81  debian     #运行该镜像或应用, -p 端口映射, 外部80:内部81 ,访问81会到容器的80



$sudo docker ps      #查看目前正在运行的容器
   # CONTAINER ID 是重要属性, 用以区分各个容器内的进程

$sudo docker exec -it  923  bash   #923是某个容器的 CONTAINER ID 属性. 进入bash 模式来控制这个容器镜像

```

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

