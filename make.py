#!/usr/bin/env python3
# -*- coding: utf-8 -*-

import os
import shutil
import getpass


path = os.getcwd() # 获取当前路径
print(path)
user_name = getpass.getuser() # 获取当前用户名
dirs = os.listdir(path) # 获取当前路径下的所有文件夹
abspath = ''

podname = input("请输入组件名称：")
filename =  podname + '.podspec'
print('当前pod 文件名为:', filename)
for dirpath in dirs:
    print(dirpath)
    if podname in dirpath:
    	abspath = path + '/' + dirpath + '/'

isExists = os.path.exists(abspath)
if isExists:
    print("当前组件绝对路径为: %s" % abspath)
	
if isExists:
   	os.chdir(abspath)
else:
    print('输入的组件名路径不存在')	

f = open(filename)
iter_f = iter(f)
for line in iter_f:
    if 's.version' in line and len(line) < 50:
        stirngs = line.split('=')
        tag = stirngs[1]
        tag = tag.replace('\"', '')
        tag = eval(tag)

        shellpull = 'git pull'
        shelladd = 'git add .'
        
        shellcommit = "git commit -m \"" + "update " + tag + ' ' + podname + " \""
        shellpush = "git push origin develop:develop"

        shellTag = 'git tag ' + tag
        print('当前tag号' + tag)
        os.system(shellTag)
        shellpushtag = 'git push --tags'
        os.system('git push --tags')
        print('push tags success')

        file_base = '/Users/' + user_name + '/.cocoapods/repos/cocopodsSpec/'
        file_dir = file_base + podname
        file_name = file_dir + '/' + tag
        os.makedirs(file_name)
        shutil.copy(filename, file_name)
        os.chdir(file_base)
        os.system(shellpull)
        os.system(shelladd)
        os.system(shellcommit)
        os.system(shellpush)
        os.system('pod repo update')
        print("pod 版本更新完成🚀🚀🚀")
