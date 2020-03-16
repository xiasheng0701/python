import os
import sys
import copy
import json
import requests
url = "http://loaclhost:6800/jsonrpc"
key = ""
dic={'jsonrpc': '2.0', 
'id': 'qwer',
'method': 'aria2.addUri'}
params=["token:"+key]
def posturl(magnets):
    tmp_d = dic.copy()
    tmp_p = params.copy()
    tmp_p.append(magnets)
    tmp_d["params"]=tmp_p
    datas = json.dumps(tmp_d)
    print(datas)
    datas=json.dumps(tmp_d).encode()
    r = requests.post(url,data=datas)
    print(r.text)
def isurl(u):
    posturl([u])
def isfile(f):
    fp = open(f,encoding="UTF-8").read()
    l=fp.split("\n")
    for i in l:
        isurl(i)
if __name__ == "__main__":
    for i in sys.argv[1:]:
        if os.path.isfile(i):
            isfile(i)
        else:
            isurl(i)