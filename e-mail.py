import smtplib
from email.mime.text import MIMEText
from email.header import Header
import time
# 账号
my_username = '********@163.com'
# 密码  
my_passwd = '*******' 
# smtp服务器              
smtp_sever = 'smtp.163.com'    
# smtp端口     
smtp_port = 465  
# 发件地址                  
from_addr = '********@163.com'
# 收件地址列表
to_addr = ["********@163.com"]                       


try:
    # 创建消息
    msg = "This is a test message"
    message = MIMEText(msg, 'plain', 'utf-8')
    message['FROM'] = Header("test1")
    message['TO'] = Header("test2")
    message['Subject'] = Header("test", 'utf-8')
    # 发送消息
    server=smtplib.SMTP_SSL(smtp_sever, smtp_port) 
    server.login(my_username, my_passwd)
    server.sendmail(from_addr, to_addr, message.as_string())
    time.sleep(5) # 避免断开太快
    server.quit()
    print('发送成功')
except:
    print('发送失败')