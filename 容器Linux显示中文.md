docker容器不能显示中文原因：

系统使用的是en_US.UTF-8字符集，en_US.UTF-8字符集是不支持中文的，而C.utf8是支持中文的 只要把系统中的环境 LANG 改为”C.utf8”格式即可解决问题（注意要和上面支持的字符集写法保持一致，是C.utf8而不是C.UTF-8，有些同学看别的文档上写的是C.UTF-8然而试了之后并没有起作用）。


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

