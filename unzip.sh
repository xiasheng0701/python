#!/bin/sh
floder=$1
if [ -d $floder ]; then
    cd $floder
    floder=`pwd`
    for i in `ls $floder/*.zip`
    do
        unzip $i -d ${i%%.zip}
        if [ $? -eq 0 ]; then
            rm -rf $i
        else
            echo $i '失败' >> err.log
        fi
    done
fi