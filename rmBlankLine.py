# -*- coding: utf-8 -*-
'''
Created on Mar-21-20 10:42
rmBlankLine.py
@author: xs0701
@e-mail: liuxs0701@gmail.com
'''
import os
path =''
fileEx=['.txt']

def rmBlankLine(path):
    for file in os.listdir(path):
        filename = os.path.join(path,file)
        # 递归遍历子文件夹
        if os.path.isdir(filename):
            rmBlankLine(filename)
        # 判断后缀名是否符合
        elif os.path.splitext(filename)[1] in fileEx:
            with open(filename+'.b','a',encoding="utf-8") as f:
                for line in open(filename,'r',encoding="utf-8"):
                    print(line.lstrip(),end='',file=f)
            # 备份原文件
            os.rename(filename, filename+'.bak')
            os.rename(filename+'.b', filename)

if __name__ == "__main__":
    rmBlankLine(path)
    