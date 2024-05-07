下载网址：

https://eco.dameng.com/document/dm/zh-cn/start/dm-install-docker.html



```bash
# 配置为正常
docker run -d -p 5236:5236  --name dm8Server --privileged=true  \
 -e  PAGE_SIZE=16               \
 -e  LD_LIBRARY_PATH=/opt/dmdbms/bin \
 -e  EXTENT_SIZE=32       \
 -e  BLANK_PAD_MODE=1       \
 -e  LOG_SIZE=1024       \
 -e  UNICODE_FLAG=1       \
 -e  CHARSET=1       \
 -e  LENGTH_IN_CHAR=1       \
 -e  INSTANCE_NAME=MYUSER  \
 -e  DB_NAME=MYDB          \
 -e  SYSDBA_PWD=Password  \
 -e  CHG_PASSWD=Password  \
 -v /Users/ns/dockerRun/dmServer:/opt/dmdbms/data  dm8_single:dm8_20230808_rev197096_x86_rh6_64
 
# 如果需要开机启动就添加一个参数  --restart=always  到端口后面

# 所有的参数都在 DM8_dminit使用手册 文件中
#部分参数解释：
CASE_SENSITIVE=0 设置大小写不敏感
LENGTH_IN_CHAR=1 VARCHAR 类型对象的长度以字符为单位
UNICODE_FLAG 字符集 (0)，可选值： 0[GB18030]， 1[UTF-8]， 2[EUC-KR]
SYSDBA_PWD=Password  配置密码
INSTANCE_NAME=MYUSER  配置实例

# 上面进行登录的用户名密码是:
SYSDBA     Password
```

启动完成后，可通过日志检查启动情况，命令如下：

```shell
docker logs -f  dm8Server/容器名称或id
或
docker logs -f 58deb28d1209
```

**注意**

1.如果使用 docker 容器里面的 disql，进入容器后，先执行 `source /etc/profile` 防止中文乱码。
2.新版本 Docker 镜像中数据库默认用户名/密码为 `SYSDBA / SYSDBA001`。



新增用户

```sql
# 添加新用户
# 先进行登陆
/opt/dmdbms/bin/disql / as sysdba
username: SYSDBA
password: Password

# 创建用户
CREATE USER "MYDB" IDENTIFIED BY "Password" ;
GRANT create table,select table,update table,insert table TO "MYDB";
GRANT resource，public TO "MYDB";
GRANT dba TO "MYDB";
```

