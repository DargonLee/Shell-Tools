#!/bin/sh

# 取得build的target名（get project name）
TARGET_NAME="uusandboxCore"
# 指定项目名称
WORKSPACE_NAME="CoreWorkspace"
DOCUMENT="document"
SCRIPT_DIR="$( cd "$( dirname "$0"  )" && pwd  )"
DOCUMENT_DIR="${SCRIPT_DIR}/build/${DOCUMENT}"
# 写build版本号
CORECONFIGPLIST_DIR="${SCRIPT_DIR}/CoreSDK/CoreSDK/Info"
echo "$1"
/usr/libexec/PlistBuddy -c "print" "${CORECONFIGPLIST_DIR}.plist"
/usr/libexec/PlistBuddy  -c 'Set :buildVersion "'$1'"' "${CORECONFIGPLIST_DIR}.plist"
echo "🚀写入构建版本号"

IPHONESIMULATOR_DIR="Release-iphonesimulator"
IPHONEOS_DIR="Release-iphoneos"
IPHONESIMULATOR_DIR_TEMP="Release-temp"
UNIVERSAL_OUTPUT_FOLDER_IPHONESIMULATOR="${SCRIPT_DIR}/build/${IPHONESIMULATOR_DIR}"
UNIVERSAL_OUTPUT_FOLDER_IPHONEOS="${SCRIPT_DIR}/build/${IPHONEOS_DIR}"
UNIVERSAL_OUTPUT_FOLDER_TEMP="${SCRIPT_DIR}/build/${IPHONESIMULATOR_DIR_TEMP}"
CONFIGURATION="Release"
#删除模拟器文件夹
if [ -d "${UNIVERSAL_OUTPUT_FOLDER_IPHONESIMULATOR}" ]
then
rm -rf "${UNIVERSAL_OUTPUT_FOLDER_IPHONESIMULATOR}"
rm -rf "${UNIVERSAL_OUTPUT_FOLDER_IPHONESIMULATOR}.zip"
fi
#删除真机文件夹
if [ -d "${UNIVERSAL_OUTPUT_FOLDER_IPHONEOS}" ]
then
rm -rf "${UNIVERSAL_OUTPUT_FOLDER_IPHONEOS}"
rm -rf "${UNIVERSAL_OUTPUT_FOLDER_IPHONEOS}.zip"
fi
#删除temp文件夹
if [ -d "${UNIVERSAL_OUTPUT_FOLDER_TEMP}" ]
then
rm -rf "${UNIVERSAL_OUTPUT_FOLDER_TEMP}"
rm -rf "${UNIVERSAL_OUTPUT_FOLDER_TEMP}.zip"
fi

#删除document文件夹
if [ -d "${DOCUMENT_DIR}" ]
then
rm -rf "${DOCUMENT_DIR}"
rm -rf "${DOCUMENT_DIR}.zip"
fi

#创建输出目录，并删除之前的framework文件
mkdir -p "${UNIVERSAL_OUTPUT_FOLDER_IPHONESIMULATOR}"
mkdir -p "${UNIVERSAL_OUTPUT_FOLDER_IPHONEOS}"
mkdir -p "${UNIVERSAL_OUTPUT_FOLDER_TEMP}"
mkdir -p "${DOCUMENT_DIR}"

#拷贝文档到document文档中
cp -R "${SCRIPT_DIR}/MBS远程单品SDK集成文档.pdf" "${DOCUMENT_DIR}"

#rm -rf "${UNIVERSAL_OUTPUT_FOLDER}/${TARGET_NAME}.framework"
# 设置真机和模拟器生成的静态库路径 （set devcie framework and simulator framework path）
DEVICE_DIR=${UNIVERSAL_OUTPUT_FOLDER_IPHONEOS}/${TARGET_NAME}.framework
#SIMULATOR_DIR=${WRK_DIR}/Products/Release-iphonesimulator/${TARGET_NAME}.framework
#分别编译模拟器和真机的Framework
#xcodebuild -workspace ${WORKSPACE_NAME}.xcworkspace -scheme ${TARGET_NAME} ONLY_ACTIVE_ARCH=NO -configuration ${CONFIGURATION} -sdk iphoneos CONFIGURATION_BUILD_DIR=${SCRIPT_DIR} clean build
xcodebuild -workspace ${WORKSPACE_NAME}.xcworkspace -scheme ${TARGET_NAME} clean
xcodebuild -workspace ${WORKSPACE_NAME}.xcworkspace -scheme ${TARGET_NAME} ONLY_ACTIVE_ARCH=NO -configuration ${CONFIGURATION} CONFIGURATION_BUILD_DIR="${UNIVERSAL_OUTPUT_FOLDER_IPHONEOS}/" -sdk iphoneos build
xcodebuild -workspace ${WORKSPACE_NAME}.xcworkspace -scheme ${TARGET_NAME} ONLY_ACTIVE_ARCH=NO -configuration ${CONFIGURATION} CONFIGURATION_BUILD_DIR="${UNIVERSAL_OUTPUT_FOLDER_TEMP}/" -sdk iphonesimulator build
#拷贝framework到模拟器目录
cp -R "${DEVICE_DIR}" "${UNIVERSAL_OUTPUT_FOLDER_IPHONESIMULATOR}"

#拷贝framework到模拟器目录
#cp -R "${DEVICE_DIR}" "${UNIVERSAL_OUTPUT_FOLDER_IPHONEOS}"

#合并framework，输出最终的framework到build目录
lipo -create -output "${UNIVERSAL_OUTPUT_FOLDER_IPHONESIMULATOR}/${TARGET_NAME}.framework/${TARGET_NAME}" "${UNIVERSAL_OUTPUT_FOLDER_TEMP}/${TARGET_NAME}.framework/${TARGET_NAME}" "${UNIVERSAL_OUTPUT_FOLDER_IPHONESIMULATOR}/${TARGET_NAME}.framework/${TARGET_NAME}"

#打包文档
cd build
zip -r -q $DOCUMENT.zip ./$DOCUMENT
zip -r -q $IPHONESIMULATOR_DIR.zip ./$IPHONESIMULATOR_DIR
zip -r -q $IPHONEOS_DIR.zip ./$IPHONEOS_DIR

# 检查zip文件是否存在
if [ -e "${DOCUMENT}.zip" ] ; then
echo "🚀 构建文档.zip成功 🚀 "
else
echo "😢 构建文档.zip失败😢 "
exit 1
fi

if [ -e "${IPHONESIMULATOR_DIR}.zip" ] ; then
echo "🚀 构建Release-iphonesimulator.zip成功 🚀"
else
echo "😢 构建Release-iphonesimulator.zip失败 😢"
exit 1
fi

if [ -e "${IPHONEOS_DIR}.zip" ] ; then
echo "🚀 构建Release-iphoneos.zip成功 🚀"
else
echo "😢 构建Release-iphoneos.zip失败 😢"
exit 1
fi

echo "🚀 🚀 🚀 All Done 🚀 🚀 🚀"
