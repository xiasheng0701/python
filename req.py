import requests
import threading
url = ""
headers={}
N = 5

def req(url):
    re = requests.get(url,headers=headers)
    if re.status_code != 200:
        print(url)

if __name__ == "__main__":
    for i in range (N):
        t = threading.Thread(target=req,args=url)
        t.start()
        t.join()