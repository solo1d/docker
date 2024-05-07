

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
# 创建所需要的映射目录
$ mkdir -p /Users/myName/dockerRun/mysql/var/lib/mysql
$ mkdir -p /Users/myName/dockerRun/mysql/conf.d

$ docker run --name JavaTestData  -itd -p 3306:3306  \
	--mount type=bind,source=/Users/myName/dockerRun/,target=/root/mysql \
  --privileged=true -e MYSQL_ROOT_PASSWORD=12345678 \
  -v /Users/myName/dockerRun/mysql/var/lib/mysql:/var/lib/mysql  \
  -v /Users/myName/dockerRun/mysql/conf.d:/etc/mysql/conf.d   \
  mysql  --lower_case_table_names=1 

# 参数说明：
-p 3306:3306 ：映射容器服务的 3306 端口到宿主机的 3306 端口，外部主机可以直接通过 宿主机ip:3306 访问到 MySQL 的服务。
MYSQL_ROOT_PASSWORD=12345678：设置 MySQL 服务 root 用户的密码。
lower_case_table_names=1  ：设置数据的表名忽略大小写，必须在 mysql 后面，表示是传递给他的参数
```



### 5、配置远程连接

```bash
$ docker exec -it  容器编码  bash
docker>$ mysql -u root -p12345678
mysql> ALTER USER 'root'@'%' IDENTIFIED BY '12345678' PASSWORD EXPIRE NEVER;
mysql> ALTER USER 'root'@'%' IDENTIFIED WITH mysql_native_password BY '12345678';
mysql> GRANT ALL PRIVILEGES ON *.* TO 'root'@'%'WITH GRANT OPTION;
mysql> flush privileges;
```









### 6、安装成功

通过 **docker ps** 命令查看是否安装成功

```bash
$ docker ps 
```

