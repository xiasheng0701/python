import random
import threading
import time
import os
from concurrent import futures
from lxml import etree
import requests
# txt文件用于存储代理
PATH = './IP_LIST.txt'
# 检测代理ip有效性的网站
CHECK_URL = 'https://www.baidu.com'
# 获取数目
NUM = 200
# 调用抓取地址
FETCH_URL = 'https://www.kuaidaili.com/free/inha/1/'
ROOT_URL='https://www.kuaidaili.com'
# 有效代理ip列表
proxies = []
# 代理类型（http/https）
PROXY_TYPE = 'http'
# 线程池，用于同时验证多个代理ip
POOL = futures.ThreadPoolExecutor(max_workers=50)
headers = {
    'User-Agent': 'Mozilla/5.0 (Windows NT 6.1; WOW64) AppleWebKit/537.36 (KHTML, like Gecko) \
                  Chrome/53.0.2785.104 Safari/537.36 Core/1.53.2306.400 QQBrowser/9.5.10530.400',
    'referer':FETCH_URL}
data = {"msg": "", "code": -1, "data": {"username": "",  "has_unread": 'false'}}

def add_proxy(proxy: str):
    """
    添加代理
    :param proxy: 代理ip+端口号
    :return:
    """
    try:
        r = requests.get(CHECK_URL, proxies={PROXY_TYPE: proxy}, headers=headers,timeout=10)
        if r.status_code == 200:
            print('有效代理：', proxy)
            # 将有效代理写入文件
            with open(PATH, 'a', encoding='utf-8') as f:
                f.write(proxy+"\n")
    except Exception as e:
        print('无效代理：', proxy)
        proxies.remove(proxy)
        print(e)

def fetch_proxy(url,proxies):
    """
    抓取代理ip
    :return:
    """
    if len(proxies) < NUM:
        res = requests.get(url, headers=headers)
        res = etree.HTML(res.text)
        ip_table = res.xpath('''//table[@class='table table-bordered table-striped']/tbody/tr''')
        for row in ip_table:
            ip = str(row.xpath('''./td[1]/text()''')[0])+':'+str(row.xpath('''./td[2]/text()''')[0])
            proxies.append(ip)
            POOL.submit(add_proxy, ip)
        active= res.xpath('''//*[@id='listnav']/ul/li/a[@class='active']''')[0]
        next_page = ROOT_URL+str(active.xpath('''../following-sibling::li[1]/a/@href''')[0])
        time.sleep(1)
        fetch_proxy(next_page, proxies)


def run():
    try:
        if os.path.exists(PATH):
            os.remove(PATH)
        fetch_proxy(FETCH_URL,proxies)
    except Exception as e:
        print(e)


# 启动抓取线程
threading.Thread(target=run).start()