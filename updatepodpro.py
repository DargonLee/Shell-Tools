#!/usr/bin/python

import os
import getpass

# 使用 依赖python环境  在脚本当前目录执行 python3 make.py 即刻
# 原理 会遍历当前目录的所有文件夹 并遍历cd到每一个文件夹内 读取 xxx.podspec文件
# 执行上传pod操作

path = os.getcwd()
files = os.listdir(path)
user_name = getpass.getuser()  # 获取当前用户名
subpath = os.getcwd()
abspaths = []

for file in files:
    if os.path.isdir(file):
        filepath = subpath + '/' + file + '/'
        abspaths.append(filepath)

for filedir in abspaths:
    os.chdir(filedir)
    originTag = os.system('git describe --tags')
    dirs = filedir.split('/')
    dirname = dirs[len(dirs) - 2]
    filename = dirname + '.podspec'
    version = '' # 版本号
    tag = '' # tag号 为了区分是否带v
    if 'XLog' in dirs:
        continue
    if 'UIAlertControllerBlocks' in dirs:
        filename = 'UIAlertController+Blocks.podspec'
    if 'BaiduMap' in dirs:
        filename = 'BaiduMapKit.podspec'
    if 'thirdWCDBOptimizedSQLCipher' in dirs:
        filename = 'WCDBOptimizedSQLCipher.podspec'
    if 'thirdWCDB' in dirs:
        filename = 'WCDB.podspec'
    if 'AFNetwork' in dirs:
        filename = 'AFNetworking.podspec'
    podspecFilePath = filedir + filename
    isExists = os.path.exists(filename)
    if isExists:
        print(isExists)
        podspec = open(filename)
        iter_f = iter(podspec)
        for line in iter_f:
            if 's.version' in line and len(line) < 50:
                vstirngs = line.split('=')
                version = vstirngs[1]
                version = version.replace('\"','') # 去除多余字符
                version = version.replace(" ", "") # 去除空格
                print(version)
            if ':git' in line:
                tstirngs = line.split('=> ')
                tag = tstirngs[len(tstirngs) - 1]
                tag = tag.replace('\"','')
                tag = tag.replace(' }','')
                if 'v' in tag:
                    print('有v')
                    version = 'v' + version
                    print(version)
        
        if str(originTag) in version:
            print(filename + "版本无更新完成😊😊😊")
            continue
        os.system('git add .')
        shell0 = "git commit -m \"" + "update " + dirname + "\""

        os.system(shell0)
        shell1 = 'git tag ' + version

        os.system(shell1)
        os.system('git push --tags')

        shell2 = ' pod repo push cocopodsSpec ' + filename +' --use-libraries --allow-warnings'

        file_base = '/Users/' + user_name + '/.cocoapods/repos/cocopodsSpec/'
        os.chdir(file_base)
        os.system('git pull')
        os.system('git add .')
        os.system("git commit -m \"" + "add " + filename + "\"")
        os.system("git push origin develop:develop")
        os.system('pod repo update')
        print(filename + "版本更新完成🚀🚀🚀")
    else:
        print('podspec文件不存在')
        continue

"""
for file in files:
    if os.path.isdir(file):
        filepath = subpath + '/' + file + '/'
        # print(filepath)
        filename = filepath + file + '.podspec'
        print('begin')
        os.chdir(filepath)
        os.system('pwd')
        originTag = os.system('git describe --tags')
        version = '' # 版本号
        tag = '' # tag号 为了区分是否带v
        # print(filename)
        if file == 'XLog':
            continue
        if file == 'UIAlertControllerBlocks':
            filename = filepath + 'UIAlertController+Blocks.podspec'
        if file == 'BaiduMap':
            filename = filepath + 'BaiduMapKit.podspec'
        if file == 'thirdWCDBOptimizedSQLCipher':
            filename = filepath + 'WCDBOptimizedSQLCipher.podspec'
        if file == 'thirdWCDB':
            filename = filepath + 'WCDB.podspec'
        if file == 'AFNetwork':
            filename = filepath + 'AFNetworking.podspec'
        print(filename)
        isExists = os.path.exists(filename)
        if isExists:
            print(isExists)
            podspec = open(filename)
            iter_f = iter(podspec)
            for line in iter_f:
                if 's.version' in line and len(line) < 50:
                    vstirngs = line.split('=')
                    version = vstirngs[1]
                    version = version.replace('\"','') # 去除多余字符
                    version = version.replace(" ", "") # 去除空格
                    # print(version)
                if ':git' in line:
                    tstirngs = line.split('=> ')
                    tag = tstirngs[len(tstirngs) - 1]
                    tag = tag.replace('\"','')
                    tag = tag.replace(' }','')
                    if 'v' in tag:
                        print('有v')
                        print(version)
                    print(tag)
                    # print(tstirngs)
        else:
            print('podspec文件不存在')
            continue
"""