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
# 记录已下载ID
Archive=$DL_PATH/youtube-dl-archive.txt
##############################################
if [ ! -d "$DL_PATH" ]; then
  mkdir "$DL_PATH"
fi
if [ ! -f "$Archive" ]; then
  touch "$Archive"
fi


#下载
Download(){
    for url in $urls
    do
    {
        cd $DL_PATH
        # youtube-dl -f best  -ciw -v -o "$DL_PATH/%(title)s.%(ext)s" $url >>d.log
        youtube-dl -f best  -ciw -v -o "$DL_PATH/%(title)s.%(ext)s" --download-archive $Archive $url
    } 
    done
}


#上传
Upload(){
    while [ $retry -gt 0 ]
    do
    {
        files=$(ls $DL_PATH/*.mp4 2> /dev/null | wc -l)
        if [ "$files" = "0" ] ; then
            ((retry--))
            sleep 1m
            continue
        fi
        retry=10
        OLD_IFS=$IFS
        IFS=$(echo -en "\n\b")
        for i in `ls $DL_PATH/*.mp4`
        do
        {                                                   
            cd $DL_PATH
            # echo $i >> u.log
            echo $i
            rclone move $i $Name:$Folder
        }
        done
        IFS=$OLD_IFS
    }
    done 
}

Download &
Upload &
wait
