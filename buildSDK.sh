
# 计时
SECONDS=0

doc_name="documents"

# 指定项目名称
workspace_name="MOS_SDK_Workspace"

# 指定项目名称
project_name="MosSSOSDK"

# 指定项目的scheme名称
scheme_name="MosSSOSDK"

# 指定要打包编译的方式 : Release,Debug
build_configuration="Release"

# build 好的SDK路径MOS_SDK_Workspace-hgqajwjsmerrmwfbquoxzezxyenh
sdk_path="Build/Products/Release-iphoneos/${scheme_name}.framework"



# 指定项目名称
workspace_name1="SSOWrokspace"

# 指定项目名称
project_name1="SSOSDK"

# 指定项目的scheme名称
scheme_name1="SSOSDK"

# 指定要打包编译的方式 : Release,Debug
build_configuration1="Release"

# build 好的SDK路径MOS_SDK_Workspace-hgqajwjsmerrmwfbquoxzezxyenh
sdk_path1="Build/Products/Release-iphoneos/${scheme_name1}.framework"

# cmd = 'cd %s && xcodebuild build %s -%s %s -configuration %s %s CONFIGURATION_BUILD_DIR=%s ONLY_ACTIVE_ARCH=NO' % (
# projectPath, project, module['build'], moduleName, g_mode, xcconfig, buildPath

cd build
rm -rf "${scheme_name}.zip" "${scheme_name1}.zip" "${doc_path}.zip"
cd ../

# =======================脚本的一些固定参数定义(无特殊情况不用修改)====================== #

# 获取当前脚本所在目录
script_dir="$( cd "$( dirname "$0"  )" && pwd  )"
# 工程根目录
project_dir=$script_dir

path1=`pwd`
cd "${path1}/MOS_SDK_Demo"

export_path="${path1}/build/"

# 时间
DATE=`date '+%Y-%m-%d-%H-%m-%S'`


# =======================自动打包部分(无特殊情况不用修改)====================== #
# 进入项目工程目录
# cd ${project_dir}
# 编译前清理工程

echo "-----------开始构建MosSDK-----------"

# SSOSDK
xcodebuild clean -workspace ${workspace_name}.xcworkspace \
                 -scheme ${scheme_name} \
                 -configuration ${build_configuration}

xcodebuild build  -workspace ${workspace_name}.xcworkspace \
                  -scheme ${scheme_name} \
                  -configuration ${build_configuration} \
                  -sdk iphoneos \
                  -derivedDataPath ${export_path}

cd ../
target_path="./build/${sdk_path}"
cp -R ${target_path} ${export_path}
cd build
rm -rf Build info.plist Logs ModuleCache.noindex

# 检查framework文件是否存在
if [ -e "$export_path$scheme_name.framework" ] ; then
echo "MosSDK - 项目构建成功 🚀 🚀 🚀 "
else
echo "MosSDK - 项目构建失败 😢 😢 😢  "
exit 0
fi


cd ../
cd "Third_SDK_Demo"

echo "-----------开始构建SSOSDK-----------"

# MosSDK
xcodebuild clean -workspace ${workspace_name1}.xcworkspace \
-scheme ${scheme_name1} \
-configuration ${build_configuration1}

xcodebuild build  -workspace ${workspace_name1}.xcworkspace \
-scheme ${scheme_name1} \
-configuration ${build_configuration1} \
-sdk iphoneos \
-derivedDataPath ${export_path}

cd ../
target_path="./build/${sdk_path1}"
cp -R ${target_path} ${export_path}
cd build
rm -rf Build info.plist Logs ModuleCache.noindex ModuleCache
cd ../

# 检查framework文件是否存在
if [ -e "$export_path$scheme_name1.framework" ] ; then
    echo "SSOSDK项目构建成功 🚀 🚀 🚀 "
else
    echo "SSOSDK项目构建失败 😢 😢 😢  "
    exit 0
fi

cd build

zip -r -q -m ./$scheme_name1.zip $scheme_name1.framework
zip -r -q -m ./$scheme_name.zip $scheme_name.framework
zip -r -q ./$doc_name.zip $doc_name

# 检查framework文件是否存在
if [ -e "$export_path$scheme_name1.zip" ] ; then
echo "构建zip成功 🚀 🚀 🚀 "
else
echo "构建zip 😢 😢 😢  "
exit 1
fi
# 输出打包总用时
echo "项目构建打包总用时: ${SECONDS}s "

exit 0                   
