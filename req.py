import requests
from random import choice
IP_LIST=[]
for line in open('''./IP_LIST.txt'''):
    IP_LIST.append(line.strip())

while(1):
    url = ''
    proxy = {'http':choice(IP_LIST)}
    print(proxy)
    r = requests.get(url,proxies=proxy)
    print(r.text)
    input()