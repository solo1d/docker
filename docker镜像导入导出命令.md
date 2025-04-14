```bash
# 导出
$ docker save -o debian.tar debian:latest
$ tar -czvf  debian.tar.gz     debian.tar

#导入
$ tar -xzvf  debian.tar.gz 
$ docker load  --input debian.tar
```