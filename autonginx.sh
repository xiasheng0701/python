#!/bin/sh
# Created on 4月-25-20 09:43
# autonginx.sh
# @author: xs0701
getrely(){
    echo "-------------------安装依赖-----------------------------"
    yum -y update
    yum -y install wget gcc pcre pcre-devel zlib zlib-devel openssl openssl-devel
    echo "-------------------依赖完成-----------------------------"
}
downcode(){
    echo "-------------------下载源码-----------------------------"
    # 下载
    wget http://nginx.org/download/nginx-1.18.0.tar.gz
    # 解压
    tar -xzf nginx-1.18.0.tar.gz
    cd nginx-1.18.0
    echo "-------------------下载完成-----------------------------"
}
compile(){
    echo "-------------------编译安装-----------------------------"
    # 添加用户和用户组
    groupadd www
    useradd -g www www
    # 配置
    ./configure \
    --user=www \
    --group=www \
    --prefix=/usr/local/nginx \
    --with-http_ssl_module \
    --with-http_stub_status_module \
    --with-http_realip_module \
    --with-threads \
    --with-http_sub_module
    # 编译安装
    make && make install
    echo "-------------------安装完成-----------------------------"
}
addconfig(){
    echo "-------------------配置文件-----------------------------"
    echo '
[Unit]
Description=nginx
After=network.target
  
[Service]
Type=forking
ExecStart=/usr/local/nginx/sbin/nginx
ExecReload=/usr/local/nginx/sbin/nginx -s reload
ExecStop=/usr/local/nginx/sbin/nginx -s quit
PrivateTmp=true
  
[Install]
WantedBy=multi-user.target
' > /usr/lib/systemd/system/nginx.service
    systemctl start nginx
    systemctl enable nginx
    firewall-cmd --permanent --add-service=http
    firewall-cmd --permanent --add-service=https
    if [[ `curl localhost` =~ 'Welcome to nginx' ]]
    then
        echo echo -e "\033[32m 安装成功 \033[0m"
    else
        echo echo -e "\033[32m 安装失败请检查输出 \033[0m"
    fi
echo "-------------------配置完成-----------------------------" 
}
cleanfile(){
    cd ../
    rm -rf nginx*
}
source /etc/os-release
if [ "$ID" = 'centos' ]; then 
    getrely
    downcode
    compile
    addconfig
    cleanfile
else
    echo $ID
    echo "本脚本只适用于centos,其他发行版可能会出错"
fi
