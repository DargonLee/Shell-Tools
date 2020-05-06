

# 计时
SECONDS=0

# 指定项目名称
workspace_name="MOS_SDK_Workspace"

# 指定项目名称
project_name="MosSSOSDK"

# 指定项目的scheme名称
scheme_name="MosSSOSDK"

# 指定要打包编译的方式 : Release,Debug
build_configuration="Release"




# 指定项目名称
workspace_name1="SSOWrokspace"

# 指定项目名称
project_name1="SSOSDK"

# 指定项目的scheme名称
scheme_name1="SSOSDK"

# 指定要打包编译的方式 : Release,Debug
build_configuration1="Release"


# =======================脚本的一些固定参数定义(无特殊情况不用修改)====================== #

# 获取当前脚本所在目录
script_dir="$( cd "$( dirname "$0"  )" && pwd  )"
# 工程根目录
project_dir=$script_dir

export_path="/Users/apple/Desktop/Projects/platform/MOS_SDK_Demo/build/"

# 时间
DATE=`date '+%Y-%m-%d-%H-%m-%S'`


# =======================自动打包部分(无特殊情况不用修改)====================== #
# 进入项目工程目录
# cd ${project_dir}
# 编译前清理工程
path1=`pwd`
cd "${path1}/MOS_SDK_Demo"
echo "--------------------打包Mos ipa文件--------------------"
xcodebuild clean -workspace ${workspace_name}.xcworkspace \
                 -scheme ${scheme_name} \
                 -configuration ${build_configuration}

xcodebuild archive -workspace ${workspace_name}.xcworkspace \
                   -scheme ${scheme_name} \
                   -configuration ${build_configuration} \
                   -archivePath ${export_path}


# 检查framework文件是否存在
if [ -e "$export_path$scheme_name.framework" ] ; then
    echo "项目构建成功 🚀 🚀 🚀 "
else
    echo "项目构建失败 😢 😢 😢  "
    exit 1
fi


echo "--------------------打包SSO ipa文件--------------------"
path1=`pwd`
cd ../
cd "${path1}/Third_SDK_Demo"
xcodebuild clean -workspace ${workspace_name1}.xcworkspace \
                 -scheme ${scheme_name1} \
                 -configuration ${build_configuration1}

xcodebuild archive -workspace ${workspace_name1}.xcworkspace \
                   -scheme ${scheme_name1} \
                   -configuration ${build_configuration1} \
                   -archivePath ${export_path}


# 检查framework文件是否存在
if [ -e "$export_path$scheme_name1.framework" ] ; then
    echo "项目构建成功 🚀 🚀 🚀 "
else
    echo "项目构建失败 😢 😢 😢  "
    exit 1
fi

# 输出打包总用时
echo "项目构建打包总用时: ${SECONDS}s "

exit 0                   
