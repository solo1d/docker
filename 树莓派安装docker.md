## 树莓派环境(无桌面)

```bash
#安装日期为 20230706  ，磁盘镜像为 2023-05-03-raspios-bullseye-arm64-lite.img (64位)
Linux raspberrypi 6.1.21-v8+ #1642 SMP PREEMPT Mon Apr  3 17:24:16 BST 2023 aarch64 GNU/Linux

PRETTY_NAME="Debian GNU/Linux 11 (bullseye)"
NAME="Debian GNU/Linux"
VERSION_ID="11"
VERSION="11 (bullseye)"
VERSION_CODENAME=bullseye
ID=debian
HOME_URL="https://www.debian.org/"
SUPPORT_URL="https://www.debian.org/support"
BUG_REPORT_URL="https://bugs.debian.org/"
```



### 官方安装说明网址:https://docs.docker.com/engine/install/debian/#set-up-the-repository

## 在 Debian 上安装 Docker 引擎

```bash
# 1、 更新apt
$ sudo apt update 

# 2、运行以下命令以卸载所有冲突的软件包：
$ for pkg in docker.io docker-doc docker-compose podman-docker containerd runc; do sudo apt-get remove $pkg; done

# 3、设置存储库
# 3.1、更新apt包索引和安装包以允许apt要通过 HTTPS 使用存储库，请执行以下操作：
$ sudo apt-get install ca-certificates curl gnupg 

# 3.2、添加 Docker 的官方 GPG 密钥：
$ sudo install -m 0755 -d /etc/apt/keyrings
$ curl -fsSL https://download.docker.com/linux/debian/gpg | sudo gpg --dearmor -o /etc/apt/keyrings/docker.gpg
$ sudo chmod a+r /etc/apt/keyrings/docker.gpg

# 3.3、使用以下命令设置存储库：
$ echo \
  "deb [arch="$(dpkg --print-architecture)" signed-by=/etc/apt/keyrings/docker.gpg] https://download.docker.com/linux/debian \
  "$(. /etc/os-release && echo "$VERSION_CODENAME")" stable" | \
  sudo tee /etc/apt/sources.list.d/docker.list > /dev/null
		#注意, 如果您使用衍生发行版，例如 Kali Linux，则可能需要替换此命令中预期打印版本代号的部分：
							$ (. /etc/os-release && echo "$VERSION_CODENAME")
							
# 4、安装 Docker 引擎
# 4.1、更新apt包索引：
$ sudo apt-get update

# 4.2、安装 Docker Engine、containerd 和 Docker Compose。(下面两个选项 二选一)
	# 安装最新版
$ sudo apt-get install -y docker-ce docker-ce-cli containerd.io docker-buildx-plugin docker-compose-plugin qemu-user-static binfmt-support
	# 安装某个特定版本
		# 一、要安装特定版本的 Docker 引擎，请首先列出存储库中的可用版本：
			# List the available versions:
				$ apt-cache madison docker-ce | awk '{ print $3 }'
					5:24.0.0-1~debian.11~bullseye
					5:23.0.6-1~debian.11~bullseye
					<...>
	  # 二、选择所需的版本并安装：
	  	$ VERSION_STRING='5:24.0.0-1~debian.11~bullseye'
			$ sudo apt-get -y install docker-ce=$VERSION_STRING docker-ce-cli=$VERSION_STRING containerd.io docker-buildx-plugin docker-compose-plugin qemu-user-static binfmt-support
			
# 5、通过运行hello-world图像： （已经安装完成）
$ sudo docker run hello-world
```



## 开启docker实验特性-Linux

需要进入 root 权限。

```bash
#我们需要安装一个可以模拟arm平台的系统环境。
$ apt update 
$ apt install -y  qemu-user-static binfmt-support

```



编辑 `/etc/docker/daemon.json`，新增如下条目

```bash
$ vim /etc/docker/daemon.json
# registry-mirrors : 添加阿里云加速源，也可以直接 [ ];
{
 "registry-mirrors": ["https://r9xxm8z8.mirror.aliyuncs.com","https://registry.docker-cn.com"],
	"experimental": true
}
```

**开启 Docker CLI 的实验特性**

编辑 `~/.docker/config.json` 文件，新增如下条目

```bash
$ vim ~/.docker/config.json		# 如果没有该目录的话，可以手动创建 mkdir ~/.docker/

{
	"auth": {},
  "experimental": "enabled"
}
```

**再执行通过设置环境变量的方式**

```bash
$ echo 'export DOCKER_CLI_EXPERIMENTAL=enabled' >> ~/.bashrc
$ source ~/.bashrc
```

**重启docker 服务**

```bash
$ systemctl daemon-reload
$ systemctl restart docker.service
```

**启用 binfmt_misc**

```bash
# 如果你使用的是 Linux，需要手动启用 binfmt_misc。大多数 Linux 发行版都很容易启用，不过还有一个更容易的办法，直接运行一个特权容器，容器里面写好了设置脚本：
$ docker run --rm --privileged docker/binfmt:66f9012c56a8316f9244ffd7622d7c21c1f6f28d
```





## 开启docker实验特性-Mac

**编辑 docker Desktop 中的设置,并进入 Dosker Engine设置**

```bash
{
  "builder": {
    "gc": {
      "defaultKeepStorage": "20GB",
      "enabled": true
    }
  },
  # 添加下面的字段
  "experimental": true,	
  "features": {
    "buildkit": true
  },
  # 下面是镜像加速
  "registry-mirrors": [
    "http://hub-mirror.c.163.com"
  ]
}
```



**开启 Docker CLI 的实验特性**

编辑 `~/.docker/config.json` 文件，新增如下条目

```bash
$ vim ~/.docker/config.json		# 如果没有该目录的话，可以手动创建 mkdir ~/.docker/

{
  "experimental": "enabled"
}
```

**再执行通过设置环境变量的方式**

```bash
$ echo 'export DOCKER_CLI_EXPERIMENTAL=enabled' >> ~/.bashrc
$ sorce ~/.bashrc
```

如果你使用的是 Docker 桌面版（MacOS 和 Windows），默认已经启用了 `binfmt_misc`，可以跳过这一步

再重启 docker Desktop 即可。
