#!/bin/bash
###############################################
# 本地文件
L_Path=$1
# Rclone
Name=$2
# 网盘目录
Folder=$3
ulogs='./u.log'
###############################################
if [ ! -f "$dlogs" ]; then
    touch "$ulogs"
fi
for i in `ls $L_Path`
do
    echo $i >> $ulogs
    rclone copy $i $Name:$Folder >> $ulogs
done