#!/usr/bin/env python3
# -*- coding: utf-8 -*-

import os
import shutil
import getpass


os.chdir(os.getcwd())
user_name = getpass.getuser() # 获取当前用户名
#print(user_name)
podname = input("请输入组件名称：")
filename =  podname + '.podspec'
print('当前pod 文件名为:', filename)
f = open(filename)
iter_f = iter(f)
for line in iter_f:
    if 's.version' in line and len(line) < 50:
        stirngs = line.split('=')
        tag = stirngs[1]
        tag = tag.replace('\"', '')
        tag = eval(tag)
        shellpull = 'git pull'
        # print(shellpull)
        # os.system(shellpull)
        # print('当前tag版本号为', tag)
        shelladd = 'git add .'
        # os.system(shelladd)
        shellcommit = "git commit -m \"" + "update " + tag + ' ' +podname + " \""
        # print(shellcommit)
        # os.system(shellcommit)
        shellpush = "git push origin develop:develop"
        # print(shellpush)
        # os.system(shellpush)
        # print('push success')
        shellTag = 'git tag ' + tag
        print(shellTag)
        os.system(shellTag)
        shellpushtag = 'git push --tags'
        os.system('git push --tags')
        print(shellpushtag)
        print('push tags success')
        file_base = '/Users/' + user_name + '/.cocoapods/repos/cocopodsSpec/'
        file_dir = file_base + podname
        file_name = file_dir + '/' + tag
        print(file_name)
        os.makedirs(file_name)
        shutil.copy(filename, file_name)
        os.chdir(file_base)
        print(os.getcwd())
        os.system(shellpull)
        os.system(shelladd)
        os.system(shellcommit)
        os.system(shellpush)
        #print(shelladd)
        print(shellcommit)
        print(shellpush)
        os.system('pod repo update')
        print("pod 版本更新完成🚀🚀🚀")
