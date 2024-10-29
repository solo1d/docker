## 配置ubuntu_X86版本的apt国内源

```bash
# 更换为 阿里云(x86) 源
$ sed -i s@/archive.ubuntu.com/@/mirrors.aliyun.com/@g /etc/apt/sources.list
# 再执行清空和更新
$ apt clean
$ apt update
```



## 配置ubuntu_Arm版本的apt国内源

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

