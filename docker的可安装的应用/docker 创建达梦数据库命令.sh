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
 -e  INSTANCE_NAME=STIJDB  \
 -e  DB_NAME=STIDB          \
 -e  SYSDBA_PWD=JLbank123  \
 -e  CHG_PASSWD=JLbank123  \
 -v /Users/ns/dockerRun/dmServer:/opt/dmdbms/data  dm8_single:dm8_20230808_rev197096_x86_rh6_64
 
# 如果需要开机启动就添加一个参数  --restart=always  到端口后面

# 所有的参数都在 DM8_dminit使用手册 文件中
# UNICODE_FLAG=1  编码为 UTF-8   , 0 是GB18030
# 上面进行登录的用户名密码是:
SYSDBA     JLbank123


# 添加新用户
# 先进行登陆
/opt/dmdbms/bin/disql / as sysdba
username: SYSDBA
password: JLbank123

# 创建用户
CREATE USER "STIDB" IDENTIFIED BY "JLbank123" ;
GRANT create table,select table,update table,insert table TO "STIDB";
GRANT resource，public TO "STIDB";
GRANT dba TO "STIDB";