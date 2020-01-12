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
IFS=$'\n'
if [ ! -f "$dlogs" ]; then
    touch "$ulogs"
fi
for i in `ls $L_Path`
do
    echo "$i" >> $ulogs
    rclone move "$i" $Name:$Folder >> $ulogs
done