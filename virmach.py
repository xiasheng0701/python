import requests
import json
import re
import winsound
import time 
url = 'https://billing.virmach.com/modules/addons/blackfriday/new_plan.json'
will_price = 10
last = 0
def my_get(url):
    try:
        return requests.get(url)
    except:
        return my_get(url)
while(1):
    res = my_get(url)
    dic = json.loads(res.text)
    price = dic['price']
    price_int = float(re.findall(r"\d+\.?\d*",price)[0])
    if price_int != last:       
        print(time.strftime("%H:%M:%S", time.localtime()),':',price_int)
        last = price_int
        if price_int < will_price:
            duration = 1000  # millisecond
            freq = 440  # Hz
            winsound.Beep(freq, duration)
    time.sleep(1)# 每秒检测一次