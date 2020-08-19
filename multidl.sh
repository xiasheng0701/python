#!/bin/bash
# @文件    :multidl.sh
# @时间    :2020/08/14 09:56:42
# @作者    :xs71
# @说明    :本脚本主要用于测试多线程下载，请勿用作非法用途
tmp_fifofile="/tmp/$$.fifo"
mkfifo $tmp_fifofile   # 新建一个FIFO类型的文件
exec 6<>$tmp_fifofile  # 将FD6指向FIFO类型
rm $tmp_fifofile  #删也可以，
thread_num=5  # 定义最大线程数
url=""
for ((i=0;i<${thread_num};i++));do
    echo
done >&6
while :
do
    read -u6
    {
        curl -o /dev/null $url \
        # -H 'User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10_14_3) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/73.0.3683.75 Safari/537.36' \
        # -H 'Referer: '\
        # -H 'Host: '
        echo >&6 # 当进程结束以后，再向FD6中加上一个回车符，即补上了read -u6减去的那个
    } &
done
wait # 要有wait，等待所有线程结束