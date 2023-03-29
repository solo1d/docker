环境 `Mac M1 Mro(arm架构)` 笔记本



## 1、下载容器

```bash
$ docker pull ubuntu    # 最新版的 ubuntu 即可
```

## 2、启动容器并映射开发目录

```bash
# 将本地的   /home/ns/os 目录挂载到容器的 /root/os 目录（读写）。
#  并启动 ubuntu 最新的容器 到后台
$ docker run --name ubuntu_os -it -d --mount type=bind,source=/home/ns/os,target=/root/os ubuntu
```

## 3、进入ubuntu容器

```bash
$ docker exec  -it fa06210d5add  /bin/bash     # 通过 docker ps 来获取容器id
```

## 4、设置显示中文

```bash
#先查看是否有支持的编码
$locale -a

#输出如下：
locale: Cannot set LC_CTYPE to default locale: No such file or directory
locale: Cannot set LC_MESSAGES to default locale: No such file or directory
locale: Cannot set LC_COLLATE to default locale: No such file or directory
C
C.utf8
POSIX
#输出结束

# 设置为  C.utf8 这个所支持的编码即可
echo "export LANG=C.utf8"  >> ~/.bashrc

#重新载入环境变量
source ~/.bashrc
```

## 5、配置apt为国内源

配置脚本 [get-docker.sh](sh_source/get-docker.sh)

将 `/etc/apt/sources.list` 这个文件的内容全部注释，并添加下面的内容。

```ini
# 默认注释了源码镜像以提高 apt update 速度，如有需要可自行取消注释
deb https://mirrors.bfsu.edu.cn/ubuntu-ports/ jammy main restricted universe multiverse
# deb-src https://mirrors.bfsu.edu.cn/ubuntu-ports/ jammy main restricted universe multiverse
deb https://mirrors.bfsu.edu.cn/ubuntu-ports/ jammy-updates main restricted universe multiverse
# deb-src https://mirrors.bfsu.edu.cn/ubuntu-ports/ jammy-updates main restricted universe multiverse
deb https://mirrors.bfsu.edu.cn/ubuntu-ports/ jammy-backports main restricted universe multiverse
# deb-src https://mirrors.bfsu.edu.cn/ubuntu-ports/ jammy-backports main restricted universe multiverse

# deb https://mirrors.bfsu.edu.cn/ubuntu-ports/ jammy-security main restricted universe multiverse
# # deb-src https://mirrors.bfsu.edu.cn/ubuntu-ports/ jammy-security main restricted universe multiverse

deb http://ports.ubuntu.com/ubuntu-ports/ jammy-security main restricted universe multiverse
# deb-src http://ports.ubuntu.com/ubuntu-ports/ jammy-security main restricted universe multiverse

# 预发布软件源，不建议启用
# deb https://mirrors.bfsu.edu.cn/ubuntu-ports/ jammy-proposed main restricted universe multiverse
# # deb-src https://mirrors.bfsu.edu.cn/ubuntu-ports/ jammy-proposed main restricted universe multiverse
```

```bash
# 再执行清空和更新
$ apt clean
$ apt update
```



## 6、配置开发环境

```bash
# 取消系统最小化配置
$ unminimize

$ apt install man   #安装man

$ apt install -y  gcc make nasm  gcc-arm-linux-gnueabihf 
```



```bash
$ arm-linux-gnueabihf-gcc -mbe32   #编译32位程序
$ arm-linux-gnueabihf-ld --verbose   #查看支持的仿真类型
elf32-bigarm
```

