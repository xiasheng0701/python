#!/bin/bash
###############################################
# ytb-dl下载目录
DL_PATH='/usr/Download'
# Rclone网盘名
Name='gd'
# 网盘目录
Folder='YouTube'
# 下载链接
urls=$@
# 等待时间
retry=10
##############################################
if [ ! -d "$DL_PATH" ]; then
  mkdir "$DL_PATH"
fi


#下载
Download(){
    for url in $urls
    do
    {
        cd $DL_PATH
        youtube-dl -f best  -ciw -v --restrict-filenames -o "$DL_PATH/%(title)s.%(ext)s" $url >>d.log
    } 
    done
}


#上传
Upload(){
    while [ $retry -gt 0 ]
    do
    {
        files=$(ls $DL_Path/*.mp4 2> /dev/null | wc -l)
        if [ "$files" != "0" ] ; then
            ((retry--))
            sleep 1m
            continue
        fi
        retry=10
        for i in `ls $DL_PATH/*.mp4`
        do
        {
            cd $DL_PATH
            echo $i >> u.log
            rclone move $i $Name:$Folder
        }
        done
    }
    done 
}

Download &
Upload &
wait
