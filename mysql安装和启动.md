

### 1、查看可用mysql版本

```bash
$ docker search mysql
```



### 2、拉取 MySQL 镜像

```bash
# 这里我们拉取官方的最新版本的镜像：
$ docker pull mysql:latest
```



### 3、查看本地镜像

使用以下命令来查看是否已安装了 mysql：

```bash
$ docker images
```



### 4、运行容器

安装完成后，我们可以使用以下命令来运行 mysql 容器：

```bash
$ docker run -itd --name mysql-test -p 3306:3306 -e MYSQL_ROOT_PASSWORD=123456             mysql

# 参数说明：
-p 3306:3306 ：映射容器服务的 3306 端口到宿主机的 3306 端口，外部主机可以直接通过 宿主机ip:3306 访问到 MySQL 的服务。
MYSQL_ROOT_PASSWORD=123456：设置 MySQL 服务 root 用户的密码。
```



### 5、安装成功

通过 **docker ps** 命令查看是否安装成功

```bash
$ docker ps 
```

