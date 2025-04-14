```bash
# 将布置好的开发环境容器提交为镜像, 需要保持容器在运行状态
$ docker ps   # 得到运行镜像的名字
CONTAINER ID   IMAGE                 COMMAND   CREATED       STATUS         PORTS     NAMES
dd6345c37e64   amd64/debian:latest   "bash"    2 weeks ago   Up 3 seconds             debian_os
33a61234f564   mysql:latest          "bash"    2 weeks ago   Up 3 seconds             homeControlMysql

#将 debian_os , homeControlMysql 容器名字提交为新的镜像, 必须是全小写名字
$ docker commit -p debian_os  debian_os:v1  
$ docker commit -p homeControlMysql   home_control_mysql:v1 

# 导出镜像
$ docker save -o debian_os.tar debian_os:v1
$ docker save -o homeControlMysql.tar home_control_mysql:v1 

# 压缩镜像文件，节约空间
$ tar -czvf  debian_os.tar.gz debian_os.tar
$ tar -czvf  homeControlMysql.tar.gz homeControlMysql.tar
## 导出完成 

# 导入镜像
# 需要先解压
$ tar -xzvf debian_os.tar
$ tar -xzvf homeControlMysql.tar.gz
$ docker load --input  debian_os.tar
$ docker load --input  homeControlMysql.tar

# 导入完成

# 将这个镜像正常运行起来即可
$ docker run --name debian_os -itd --mount type=bind,source=/Users/ns/os,target=/root/os  debian_os:v1

$ docker run --name  homeControlMysql  -itd -p 3306:3306 \
 --mount type=bind,source=/Users/ns/dockerRun/homeControlMysql/mysql,target=/root/mysql \
 --privileged=true -e MYSQL_ROOT_PASSWORD=12345678 \
  -v /Users/ns/dockerRun/homeControlMysql/var:/var \
  -v  /Users/ns/dockerRun/homeControlMysql/conf.d:/etc/mysql/conf.d \
    home_control_mysql:v1  --lower_case_table_names=1
```



docker 配置备份

{
  "builder": {
    "gc": {
      "defaultKeepStorage": "20GB",
      "enabled": true
    }
  },
  "experimental": true,
  "registry-mirrors": [
    "https://docker.xuanyuan.me"
  ]
}